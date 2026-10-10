-- Post-hook to modify Focus cost
for i, u in ipairs(UpsList) do
    if u.code == "Focus" or (kTechId and u.techId == kTechId.Focus) then
        u.levels = 1  -- Change the cost to 1
        if Server then 
            Print(string.format("[UpsPatch] Focus cost changed to 1 (idx %d)", i)) 
        end
        break
    end
end