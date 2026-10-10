for i,u in ipairs(UpsList or {}) do
  if u.code=="cara" or (kTechId and u.techId==kTechId.Carapace) then
    table.remove(UpsList, i)
    table.insert(UpsList, i, BuildUpgrade("Alien", kCombatUpgrades.Carapace, "cara", "Carapace", kTechId.Carapace, nil, nil, 3, kCombatUpgradeTypes.Tech, false, 0, nil, false))
    if Server then Print(string.format("[UpsPatch] Carapace line reinserted w/ cost 3 (idx %d)", i)) end
    break
  end
end
