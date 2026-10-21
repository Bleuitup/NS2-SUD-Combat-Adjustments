-- ARC routes
--
-- Combat sends every ARC down the shortest path to the alien hive, so they all walk the same
-- corridors. Here each ARC walks a randomly chosen series of rooms instead.
--
-- The route is chosen from the hive end. The rooms next to the hive's room are its approaches.
-- ARCs take them in turn, in a shuffled cycle: with approaches A, B and C, the first ARC comes
-- through one of them at random, the second through one of the other two, the third through the
-- last, and then a new shuffled cycle starts, never with the approach that ended the previous one.
-- The way from the spawn to that approach is random too, and not the same series of rooms as the
-- previous ARC's where there is a choice.
--
-- Where every route reaches the hive's room through the same room (co_legacy: Hive Access), the
-- approaches are counted one room further back instead: the rooms that lead into that one
-- (Central Room, Server Room, Down Access), so ARCs take turns entering it from each side. And
-- further back again if those are all the same too, until the routes split.
--
-- Once it enters the hive's room, Combat's own behavior takes over again:
-- head for the hive and deploy in range. Combat's "deploy as soon as a hive is in range" check
-- keeps working the whole way.
--
-- The rooms and the doorways between them come from the room map the game builds for its bots
-- (lua/bots/LocationGraph.lua). It is built on every server when the map loads.
--
-- A route never enters the same room twice. It may move away from the hive for a while, but it
-- never doubles back.
--
-- Each ARC logs its route to the server console, e.g.
--   [SCA] ARC route: Marine Start > Atrium > Cargo > Hive (from Cargo, one of 2 approaches; one of 3 routes that way)
--   [SCA] ARC route: Marine start > Pipe Corridor > Down Access > Hive Access > Alien Start (from Down Access > Hive Access, one of 3 approaches; ...)

if not Server then return end

local kMaxRoutes = 50             -- stop listing routes after this many
local kMaxSearchSteps = 20000     -- and never spend more than this many steps listing them
local kWaypointReachedDistance = 3
local kStuckTime = 20             -- seconds without getting closer to a doorway before skipping it
local kStuckProgress = 0.5        -- meters closer that count as progress
local kMaxSkips = 2               -- skipped doorways before the route is dropped
local kRoomCheckInterval = 0.5    -- seconds between checks of which room the ARC is in

local routesCache = {}            -- "<start room>|<hive room>" -> list of routes (lists of room names)
local previousRouteKey            -- route the previous ARC took
local approachCycles = {}         -- "<start room>|<hive room>" -> { remaining = { rooms }, last = room }

local function Log(message)
    Shared.Message("[SCA] " .. message)
end

local function GetRoomName(position)
    local location = GetLocationForPoint(position)
    local name = location and location:GetName()
    if name and name ~= "" then
        return name
    end
    return nil
end

-- Same target Combat uses: the first alien command structure that is still alive.
local function GetTargetHive(arc)
    for _, hive in ipairs(GetEntitiesForTeam("CommandStructure", GetEnemyTeamNumber(arc:GetTeamNumber()))) do
        if hive:GetIsAlive() then
            return hive
        end
    end
    return nil
end

-- Every series of rooms from startRoom to hiveRoom that never enters a room twice.
-- getNeighbors(roomName) returns the rooms directly connected to it.
function SCA_ListArcRoutes(startRoom, hiveRoom, getNeighbors)

    local routes = {}
    local steps = 0
    local route = { startRoom }
    local visited = { [startRoom] = true }

    local function Visit(room)

        if #routes >= kMaxRoutes or steps >= kMaxSearchSteps then
            return
        end
        steps = steps + 1

        if room == hiveRoom then
            local copy = {}
            for i = 1, #route do
                copy[i] = route[i]
            end
            table.insert(routes, copy)
            return
        end

        for _, nextRoom in ipairs(getNeighbors(room)) do
            if not visited[nextRoom] then
                visited[nextRoom] = true
                table.insert(route, nextRoom)
                Visit(nextRoom)
                table.remove(route)
                visited[nextRoom] = nil
            end
        end

    end

    Visit(startRoom)

    return routes

end

-- Random among the routes, never the one previousKey names, unless it is the only route.
function SCA_PickArcRoute(routes, previousKey, random)

    local candidates = {}
    for _, route in ipairs(routes) do
        if table.concat(route, " > ") ~= previousKey then
            table.insert(candidates, route)
        end
    end

    if #candidates == 0 then
        candidates = routes
    end

    if #candidates == 0 then
        return nil
    end

    return candidates[random(#candidates)]

end

-- The last rooms of a route before the hive's room: depth 1 is the room it enters the hive's room
-- from, depth 2 adds the room before that ("Down Access > Hive Access"), and so on.
local function GetApproach(route, depth)
    local first = math.max(1, #route - depth)
    return table.concat(route, " > ", first, #route - 1)
end

-- How far back from the hive's room the routes first split into more than one approach. 1 on most
-- maps; more where every route funnels through the same room(s) before the hive.
function SCA_GetArcApproachDepth(routes)

    local longest = 0
    for _, route in ipairs(routes) do
        longest = math.max(longest, #route - 1)
    end

    for depth = 1, longest do
        local seen, count = {}, 0
        for _, route in ipairs(routes) do
            local approach = GetApproach(route, depth)
            if not seen[approach] then
                seen[approach] = true
                count = count + 1
            end
        end
        if count > 1 then
            return depth
        end
    end

    return 1

end

-- Picks the approach for the next ARC from a shuffled cycle of the approaches that have routes.
-- cycle keeps the state between ARCs: { remaining = {...}, last = room }.
function SCA_PickArcApproach(approaches, cycle, random)

    if #approaches == 0 then
        return nil
    end

    local function IsAvailable(room)
        for _, approach in ipairs(approaches) do
            if approach == room then
                return true
            end
        end
        return false
    end

    -- Drop approaches that no longer have routes (the hive moved, a route went away).
    local remaining = {}
    for _, room in ipairs(cycle.remaining or {}) do
        if IsAvailable(room) then
            table.insert(remaining, room)
        end
    end

    if #remaining == 0 then

        -- New cycle: shuffle all approaches, never starting with the one that ended the last cycle.
        for _, room in ipairs(approaches) do
            table.insert(remaining, room)
        end
        for i = #remaining, 2, -1 do
            local j = random(i)
            remaining[i], remaining[j] = remaining[j], remaining[i]
        end
        if #remaining > 1 and remaining[1] == cycle.last then
            local j = random(#remaining - 1) + 1
            remaining[1], remaining[j] = remaining[j], remaining[1]
        end

    end

    local approach = table.remove(remaining, 1)
    cycle.remaining = remaining
    cycle.last = approach

    return approach

end

local function GetNeighborsFunction(graph)
    return function(roomName)
        local list = {}
        local connected = graph:GetDirectPathsForLocationName(roomName)
        if connected then
            for i = 1, #connected do
                table.insert(list, connected[i])
            end
        end
        return list
    end
end

-- The doorway between two connected rooms, or the middle of the next room if the room map has
-- no doorway for them.
local function GetDoorway(graph, fromRoom, toRoom)
    local gateways = graph.locationGateways[fromRoom]
    local doorway = gateways and gateways[toRoom]
    return doorway or graph:GetExplorePointForLocationName(toRoom)
end

local function PlanRoute(arc)

    local graph = GetLocationGraph and GetLocationGraph()
    local hive = GetTargetHive(arc)
    if not graph or not hive then
        return nil, "no room map or no hive"
    end

    local startRoom = GetRoomName(arc:GetOrigin())
    local hiveRoom = GetRoomName(hive:GetOrigin())
    if not startRoom or not hiveRoom then
        return nil, "spawn room or hive room has no name"
    end
    if startRoom == hiveRoom then
        return nil, "already in the hive room"
    end

    local cacheKey = startRoom .. "|" .. hiveRoom
    local routes = routesCache[cacheKey]
    if not routes then
        routes = SCA_ListArcRoutes(startRoom, hiveRoom, GetNeighborsFunction(graph))
        routesCache[cacheKey] = routes
    end

    -- Group the routes by the room they enter the hive's room from (or the rooms before it, where
    -- they all enter through the same one).
    local depth = SCA_GetArcApproachDepth(routes)
    local routesByApproach = {}
    local approaches = {}
    for _, route in ipairs(routes) do
        local approach = GetApproach(route, depth)
        if not routesByApproach[approach] then
            routesByApproach[approach] = {}
            table.insert(approaches, approach)
        end
        table.insert(routesByApproach[approach], route)
    end

    approachCycles[cacheKey] = approachCycles[cacheKey] or {}
    local approach = SCA_PickArcApproach(approaches, approachCycles[cacheKey], math.random)
    if not approach then
        return nil, "no route between " .. startRoom .. " and " .. hiveRoom
    end

    local approachRoutes = routesByApproach[approach]
    local rooms = SCA_PickArcRoute(approachRoutes, previousRouteKey, math.random)

    local routeKey = table.concat(rooms, " > ")
    previousRouteKey = routeKey

    local waypoints = {}
    for i = 2, #rooms do
        local doorway = GetDoorway(graph, rooms[i - 1], rooms[i])
        if not doorway then
            return nil, "no doorway into " .. rooms[i]
        end
        table.insert(waypoints, { room = rooms[i], position = doorway })
    end

    return { rooms = rooms, waypoints = waypoints, index = 1, skips = 0, key = routeKey,
             approach = approach, approaches = #approaches, approachRoutes = #approachRoutes }

end

local function AbandonRoute(arc, reason)
    Log("ARC route dropped (" .. reason .. "), heading straight for the hive")
    arc.scaRoute = false
end

-- Moves the route on to the next doorway once the ARC is at the current one, or already inside
-- the room it leads to (or one further along).
local function AdvanceRoute(arc, route)

    local now = Shared.GetTime()

    if not route.nextRoomCheck or now >= route.nextRoomCheck then

        route.nextRoomCheck = now + kRoomCheckInterval
        local currentRoom = GetRoomName(arc:GetOrigin())

        for i = #route.waypoints, route.index, -1 do
            if route.waypoints[i].room == currentRoom then
                route.index = i + 1
                route.bestDistance = nil
                return
            end
        end

    end

    local waypoint = route.waypoints[route.index]
    local distance = (waypoint.position - arc:GetOrigin()):GetLength()

    if distance < kWaypointReachedDistance then
        route.index = route.index + 1
        route.bestDistance = nil
        return
    end

    -- Stuck check
    if not route.bestDistance or distance < route.bestDistance - kStuckProgress then
        route.bestDistance = distance
        route.timeBest = now
    elseif now - route.timeBest > kStuckTime then
        route.skips = route.skips + 1
        route.index = route.index + 1
        route.bestDistance = nil
        if route.skips >= kMaxSkips then
            AbandonRoute(arc, "stuck")
        end
    end

end

local function UpdateRoute(arc)

    if arc.deployMode ~= ARC.kDeployMode.Undeployed then
        return
    end

    local currentOrder = arc:GetCurrentOrder()
    if currentOrder and currentOrder:GetType() ~= kTechId.Move then
        return -- deploying, or anything else that is not walking
    end

    if arc.scaRoute == nil then

        local route, reason = PlanRoute(arc)
        if route then
            arc.scaRoute = route
            local approachesText = route.approaches == 1 and "the only approach"
                or string.format("one of %d approaches", route.approaches)
            local routesText = route.approachRoutes == 1 and "the only route that way"
                or string.format("one of %d routes that way", route.approachRoutes)
            Log(string.format("ARC route: %s (from %s, %s; %s)", route.key, route.approach, approachesText, routesText))
        else
            arc.scaRoute = false
            Log("ARC route: none (" .. reason .. "), heading straight for the hive")
        end

    end

    local route = arc.scaRoute
    if not route then
        return
    end

    AdvanceRoute(arc, route)

    if not arc.scaRoute then
        return
    end

    if route.index > #route.waypoints then
        arc.scaRoute = false -- in the hive's room: Combat takes it from here
        return
    end

    local waypoint = route.waypoints[route.index].position
    local onWaypoint = currentOrder and (currentOrder:GetLocation() - waypoint):GetLength() < 0.1
    if not onWaypoint then
        arc:GiveOrder(kTechId.Move, Entity.invalidId, waypoint, nil, true, true)
    end

end

-- Runs before Combat's update, so Combat sees an ARC that is already walking and leaves its order
-- alone.
local oldOnUpdate = ARC.OnUpdate
function ARC:OnUpdate(deltaTime)

    UpdateRoute(self)

    oldOnUpdate(self, deltaTime)

end
