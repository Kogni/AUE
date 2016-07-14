--TESTING
--_G.AUE_Static = {}
--PaperDollFrame = {}
--function PaperDollFrame:HookScript()
--end
----

-- Klassen regner ikke ut noe, forandrer ikke noe, sender ikke noe, bare henter og lagrer data.
--Variabler for 1 scenario
--Inkluderer item stats, char stats, equipped gear, buffs, rotation
--hvert scenario lever kun så lenge det finnes en link til det - linker lagres ikke i _G.

local AUE_Static = _G.AUE_Static
local Scenario = {};
_G.AUE_Static.Scenario = Scenario

local ComparedStats_Combat
local DPS

function AUE_Static.Scenario:CharVinduAapnet()
  print("AUE_Static.Scenario:CharVinduAapnet started")
  AUE_Static.GUI_CharScreen:UpdateDoll()
end

function AUE_Static.Scenario:NewScenario_scenario(itemlink, comparison)
  print("AUE_Static.Scenario:NewScenario start", itemlink, comparison.Tooltip, comparison.EquippedItem_1)
  if (itemlink ==nil)then
    print("AUE_Static.Scenario:NewScenario itemlink=nil, aborting")
    return nil
  end
  if ( comparison.Tooltip == nil )then
    print("AUE_Static.Scenario:NewScenario tooltip=nil, aborting")
    return nil
  end
  if ( comparison.EquippedItem_1 == nil )then
    print("AUE_Static.Scenario:NewScenario EquippedItem_1=nil, aborting")
    return nil
  end
  if ( _G.CurrentStats_Combat == nil ) then
    print("AUE_Static.Scenario:NewScenario _G.CurrentStats_Combat is nil, aborting" )
    return nil
  end
  --AUE_Static.GUI_Tooltips.UpdateTooltip(CurrentComparison)
  --print("AUE_Static.Scenario:NewScenario EquippedItem_1=", comparison.EquippedItem_1)
  comparison[itemlink] = {}
  local scenario = {}
  scenario.ComparedItem = {}
  scenario.Equippeditem_1 = {}

  --print("AUE_Static.Scenario:NewScenario ber om GetNoncombatStats")
  scenario.ComparedItem.ItemLink = itemlink
  scenario.Tooltip = comparison.Tooltip
  scenario.Equippeditem_1.ItemLink = comparison.EquippedItem_1
  --print("AUE_Static.Scenario:NewScenario ItemLink=", scenario.Equippeditem_1.ItemLink)
  scenario.Slot=0
  scenario = AUE_Static.Scenario:GetNoncombatStats_scenario(scenario)

  return scenario
end

function AUE_Static.Scenario:GetNoncombatStats_scenario(scenario)
  print("AUE_Static.Scenario:GetNoncombatStats Equippeditem_1=", scenario.Equippeditem_1)
  if ( scenario.ComparedItem.ItemLink == nil )then
    print("AUE_Static.Scenario:GetNoncombatStats scenario.ItemLink=nil, aborting")
    return scenario
  end
  if ( scenario.Tooltip == nil )then
    print("AUE_Static.Scenario:GetNoncombatStats scenario.Tooltip=nil, aborting")
    return scenario
  end
  scenario.Equippeditem_1.Tooltip = scenario.Tooltip
  scenario.ComparedItem.Tooltip = scenario.Tooltip
  if ( scenario.Equippeditem_1.ItemLink == nil )then
    print("AUE_Static.Scenario:GetNoncombatStats scenario.Equippeditem_1=nil, aborting")
    return scenario
  end
  --print("AUE_Static.Scenario:GetNoncombatStats continues", scenario.ItemLink)
  local StatsSet = AUE_Static.Locals.StatsSet

  --non-combat stats
  --print("AUE_Static.Scenario:GetNoncombatStats ber om GetItemStats equippeditem")
  scenario = AUE_Static.Scenario.GetEquippedItemStats_scenario(scenario)

  return scenario
end

function AUE_Static.Scenario.GetEquippedItemStats_scenario(scenario)
  scenario.Equippeditem_1 = AUE_Static.Functions:GetItemStats_scenarioItem(scenario.Equippeditem_1)
  --print("AUE_Static.Scenario:GetNoncombatStats EquippedItemStats=", EquippedItemStats)

  --print("AUE_Static.Scenario:GetNoncombatStats ber om GetItemStats comparedlink")
  scenario = AUE_Static.Scenario.GetComparedItemStats_scenario(scenario)

  return scenario
end

function AUE_Static.Scenario.GetComparedItemStats_scenario(scenario)
  scenario.ComparedItem = AUE_Static.Functions:GetItemStats_scenarioItem(scenario.ComparedItem)
  --print("AUE_Static.Scenario:GetNoncombatStats ComparedItemStats=", ComparedItemStats)

  if ( scenario.ComparedItem == nil ) then
    print("AUE_Static.Scenario:GetNoncombatStats scenario.ComparedItem is nil, aborting" )
    return scenario
  end
  --print("AUE_Static.Scenario:GetNoncombatStats scenario.EquippedItemStats", scenario.Equippeditem_1_Stats)
  scenario.ItemDiff = AUE_Static.Functions:AMinusBIsC(scenario.ComparedItem.ItemStats, scenario.Equippeditem_1.ItemStats, scenario.ItemDiff) --upgrades are positive numbers
  if ( scenario.ItemDiff == nil ) then
    print("AUE_Static.Scenario:GetNoncombatStats scenario.ItemDiff is nil, aborting" )
    return scenario
  end
  scenario.NoncombatStats = AUE_Static.Functions:APlusBIsC(scenario.Equippeditem_1.ItemStats, scenario.ItemDiff, scenario.NoncombatStats) --upgrades are positive numbers

  if ( _G.CurrentStats_Combat == nil ) then
    print("AUE_Static.Scenario:GetNoncombatStats _G.CurrentStats_Combat is nil, aborting" )
    return scenario
  end
  scenario = AUE_Static.Scenario:GetCombatStats_scenario(scenario)


  return scenario
end

function AUE_Static.Scenario:GetCombatStats_scenario(scenario)
  --print("AUE_Static.Scenario:GetCombatStats ",ItemDiff )
  if ( scenario.ItemDiff == nil ) then
    print("AUE_Static.Scenario:GetCombatStats scenario.ItemDiff is nil, aborting" )
    return scenario
  end
  if ( _G.CurrentStats_Combat == nil ) then
    print("AUE_Static.Scenario:GetCombatStats _G.CurrentStats_Combat is nil, aborting" )
    return scenario
  end
  --print("AUE_Static.Scenario:GetCombatStats continues" )
  scenario = AUE_Static.Functions_Class:ConvertToCombatStats(scenario)

  return scenario
end

function AUE_Static.Scenario:GetItemDiffCombatStats_scenario(scenario)

  scenario.ItemDiff_Combat = AUE_Static.Functions_Class:ConvertToCombatStats(scenario.ItemDiff)

  --print("AUE_Static.Scenario:GetCombatStats ber om APlusBIsC")
  scenario.Stats_Combat = AUE_Static.Functions:MakeNewStatSet()
  --print("AUE_Static.Scenario:GetTotalStats A ComparedStats_Combat",ComparedStats_Combat )

  --print("AUE_Static.Scenario:GetCombatStats _G.CurrentStats_Combat=",_G.CurrentStats_Combat )
  scenario.Stats_Combat = AUE_Static.Functions:APlusBIsC(_G.CurrentStats_Combat, scenario.ItemDiff_Combat, scenario.Stats_Combat) --upgrades are positive numbers
  --print("AUE_Static.Scenario:GetTotalStats B ComparedStats_Combat",ComparedStats_Combat.Versatility )

  --GEMS
  --ComparedStats = AUE_Static.Scenario:ApplyGemStats(ComparedStats)
  --ComparedStats = AUE_Static.Functions_Class:ConvertToCombatStats(ComparedStats)
  --ComparedStats_Combat = AUE_Static.Functions:APlusBIsC(ComparedStats, ComparedStats_Combat, ComparedStats_Combat)

  --talents addes til sist
  scenario  = AUE_Static.Scenario:ApplyStatTalents_Scenario(scenario)

  print("AUE_Static.Scenario:GetCombatStats scenario=", scenario)

  return scenario
end

function AUE_Static.Scenario:ApplyStatTalents_Scenario(scenario)
  scenario = AUE_Static.Functions_Class:ApplyStatTalents(scenario)

  if ( scenario.Stats_Combat == nil)then
    print("AUE_Static.Scenario:GetCombatStats scenario.Stats_Combat=nil, aborting",scenario.Stats_Combat )
    return scenario
  end

  --print("AUE_Static.Scenario:NewScenario scenario=", scenario)
  comparison[itemlink] = scenario
  if ( scenario.NoncombatStats == nil )then
    print("AUE_Static.Scenario:NewScenario scenario.NoncombatStats=nil, aborting")
    return scenario
  end
  scenario = AUE_Static.Scenario:TriggerDPSCalc_scenario(scenario)
  print("AUE_Static.Scenario:GetNoncombatStats scenario=", scenario )

  return scenario
end


function AUE_Static.Scenario:TriggerDPSCalc_scenario(scenario)
  scenario.DPS = AUE_Static.Functions_DPS:TriggerDPSCalc_scenario(scenario)
  if ( scenario.DPS == nil ) then
    print("AUE_Static.Scenario:NewScenario DPS=nil, aborting", itemlink)
    return scenario
  end
  --print("AUE_Static.Scenario:NewScenario DPS=", scenario.DPS)
  comparison[itemlink] = scenario
  --AUE_Static.GUI_Tooltips.UpdateTooltip(CurrentComparison)
  --AUE_Static.GUI_Tooltips.UpdateTooltip(CurrentComparison)

  return scenario
end

function AUE_Static.Scenario:ApplyGemStats_scenario(scenario)
  print("AUE_Static.Scenario:ApplyGemStats")

  return scenario
end

--multisource - calculate dps/heal

PaperDollFrame:HookScript("OnShow", AUE_Static.Scenario.CharVinduAapnet)

print("AUE_Scenario loaded")



--TESTING
--comparison = {}
--comparison.EquippedItem_1 = "setg"
--comparison.Tooltip = {}
--_G.CurrentStats_Combat = {}
--AUE_Static.Locals = {}
--AUE_Static.Locals.StatsSet = {}
--comparison.CurrentScenario = AUE_Static.Scenario:NewScenario_scenario(comparison.EquippedItem_1, comparison)
print("")
