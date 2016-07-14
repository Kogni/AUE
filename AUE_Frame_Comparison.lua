--TESTING
--_G.AUE_Static = {}
--ItemRefTooltip = {}
--function ItemRefTooltip:HookScript()
--end
--GameTooltip = {}
--function GameTooltip:HookScript()
--end

--function GetItemInfo()
--  return "ItemName", "ItemLink", "itemRarity", "ilevel", "itemMinLevel", "itemType", "itemSubType", "itemStackCount", "itemEquipLoc", "itemTexture"
--end

--function GetInventorySlotInfo()
--  return 1
--end

--function GetInventoryItemLink()
--  return "testlink"
--end

--function UnitName()
--  return "testname"
--end
-----------------

--Klassen regner ikke ut noe, forandrer ikke noe, sender ikke noe, bare henter og lagrer data.
--Cleanes for hver comparison. Sammenligner 2 scenarioer
local AUE_Static = _G.AUE_Static
local Comparison = {};
_G.AUE_Static.Comparison = Comparison

local InternalSlotName_1, InternalSlotName_2
local Upgradenmbr_1, Upgradenmbr_2
local Print_1, Print_2
local Addition_1, Addition_2
local EquippedItem_1, EquippedItem_2
local SlotID_1, SlotID_2
local Compare

local CurrentComparison, LastComparison = {}
local currentScenario
local comparedScenario


function AUE_Static.Comparison.Parsing(tooltip) --triggers comparison

  --print("AUE_Static.Comparison.Parsing started", tooltip)
  CurrentComparison = {}
  CurrentComparison.Tooltip =tooltip
  Compare = true
  local ComparedItem_String = ""
  local PreviousItem = ""
  local ItemName, link = tooltip:GetItem();
  if ( link ~= nil ) then
    local found, _, Item_String = string.find(link, "^|c%x+|H(.+)|h%[.*%]")
    Item_String = string.sub(Item_String, 6, 10)
    tooltip:AddLine("Item ID:"..Item_String)
    ComparedItem_String = Item_String
  else
    --print("AUE_Static.Comparison.Parsing link is nil, returning")
    return
  end
  CurrentComparison.ItemLink = link
  if ( _G.CurrentStats_Combat == nil ) then
    --print("AUE_Static.Comparison.Parsing _G.CurrentStats_Combat is nil" )
    AUE_Static.Locals.GetStats()
    return
  end

  if ( IsEquippableItem( link ) ~= nil ) then
    CurrentComparison = AUE_Static.Comparison:ComparedIsEquippable_comparison(CurrentComparison)
    --print("AUE_Static.Comparison.Parsing skal oppdatere tooltip")
    AUE_Static.GUI_Tooltips.UpdateTooltip(CurrentComparison)
  end
  _G.CheckingItem = false
end

function AUE_Static.Comparison:ComparedIsEquippable_comparison(comparison)
  --print("AUE_Static.Comparison:ComparesIsEquippable()", comparison.ItemLink, comparison.Tooltip, _G.PreviousItem)
  if ( _G.PreviousItem == comparison.ItemLink ) then
    print("AUE_Static.Comparison:ComparesIsEquippable() link is previous item, skip calculation")
    return comparison
  else
    --AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)
    --print("AUE_Static.Comparison.ComparedIsEquippable_comparison 2 ", comparison.ItemLink, comparison.Tooltip, _G.PreviousItem, _G.CheckingItem)
    if ( _G.CheckingItem == false ) then
      comparison = AUE_Static.Comparison.ComparedToCalculate_comparison(comparison)
      --AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)
    else
    --print("AUE_Static.Comparison.ComparedIsEquippable_comparison CheckingItem=", _G.CheckingItem)
    end

    if (comparison.ComparedScenario == nil)then
      print("AUE_Static.Comparison.ComparedIsEquippable_comparison comparedScenario=nil, aborting ", comparison.ItemLink)
      _G.CheckingItem = false
      return comparison
    end
    if (comparison.ComparedScenario.DPS == nil)then
      print("AUE_Static.Comparison.ComparedIsEquippable_comparison comparedScenario.DPS=nil, aborting ", comparison.ItemLink)
      _G.CheckingItem = false
      return comparison
    end
    if (comparison.CurrentScenario == nil)then
      print("AUE_Static.Comparison.ComparedIsEquippable_comparison currentScenario=nil, aborting ", comparison.EquippedItem_1)
      _G.CheckingItem = false
      return comparison
    end
    if (comparison.CurrentScenario.DPS == nil)then
      print("AUE_Static.Comparison.ComparedIsEquippable_comparison currentScenario.DPS=nil, aborting ", comparison.EquippedItem_1)
      _G.CheckingItem = false
      return comparison
    end
    --AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)

    --local DPSDiff = comparedScenario.DPS - currentScenario.DPS
    CurrentComparison = comparison
    LastComparison = CurrentComparison
  end
  print( _G.PreviousItem, link )
  --tooltip:AddDoubleLine( "A" , "A", 0, 1, 1)
  --AUE_Static.GUI_Tooltips.UpdateTooltip(LastComparison)
  --print("AUE_Static.Comparison.ComparedIsEquippable_comparison comparison=", comparison)
  return comparison
end

function AUE_Static.Comparison.ComparedToCalculate_comparison(comparison)
  --print("AUE_Static.Comparison.ComparedToCalculate_comparison", comparison.ItemLink)
  if (comparison.ItemLink == nil)then
    print("AUE_Static.Comparison.ComparedToCalculate_comparison link=nil, aborting ")
    return comparison
  end
  if (comparison.Tooltip == nil)then
    print("AUE_Static.Comparison.ComparedToCalculate_comparison tooltip=nil, aborting ")
    return comparison
  end
  --print("AUE_Static.Comparison.ComparedToCalculate_comparison continues ")
  _G.CheckingItem = true;
  if ( comparison.ComparedItem == nil ) then
    comparison.ComparedItem = {}
  end
  --AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)

  --Finn slot for compared item
  comparison = AUE_Static.Comparison.GetSlotName_comparison(comparison)

  return comparison
end

function AUE_Static.Comparison.GetSlotName_comparison(comparison)
  print("AUE_Static.Comparison.GetSlotName_comparison comparison.ItemLink=", comparison.ItemLink )

  --print("AUE_Static.Comparison.GetSlotName_comparison comparison.ComparedItem=", comparison.ComparedItem )
  if ( comparison.ComparedItem.ItemName == nil ) then
    comparison.ComparedItem.ItemName, comparison.ComparedItem.ItemLink, comparison.ComparedItem.ItemRarity, comparison.ComparedItem.Ilevel, comparison.ComparedItem.ItemMinLevel, comparison.ComparedItem.ItemType, comparison.ComparedItem.ItemSubType, comparison.ComparedItem.ItemStackCount, comparison.ComparedItem.ItemEquipLoc, comparison.ComparedItem.ItemTextur = GetItemInfo(comparison.ItemLink);
  end
  --print("AUE_Static.Comparison.GetSlotName_comparison ItemEquipLoc=", comparison.ComparedItem.ItemEquipLoc )
  if ( comparison.ComparedItem.SlotName == nil ) then
    comparison.ComparedItem.SlotName = _G[comparison.ComparedItem.ItemEquipLoc]
  end
  --print("AUE_Static.Comparison.GetSlotName_comparison SlotName=", comparison.ComparedItem.SlotName )
  if ( comparison.ComparedItem.Slot == nil ) then
  --ComparedItemslot = comparison.ComparedItem.SlotName
  --Compared_SlotName = comparison.ComparedItem.SlotName
  end
  --print("AUE_Static.Comparison.GetSlotName_comparison itemEquipLoc=", itemEquipLoc, "SlotName=", SlotName, "Compared_SlotName=", Compared_SlotName)
  if ( comparison.ComparedItem.SlotName == nil) then
    print("AUE_Static.Comparison.GetSlotName_comparison SlotName is nil, aborting" )
    return comparison
  end
  if ( comparison.ComparedItem.SlotName == "") then
    print("AUE_Static.Comparison.GetSlotName_comparison SlotName is '', aborting" )
    return comparison
  end
  if ( comparison.ComparedItem.SlotName=="Trinket" ) then
    comparison.ComparedItem.InternalSlotName_1 = comparison.ComparedItem.SlotName.."0Slot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
    comparison.ComparedItem.InternalSlotName_2 = comparison.ComparedItem.SlotName.."1Slot"
    comparison.ComparedItem.Upgradenmbr_2 = 1
    comparison.ComparedItem.Print_2 = true
    comparison.ComparedItem.Addition_2 = false
  elseif ( comparison.ComparedItem.SlotName=="Two-Hand" ) then
    comparison.ComparedItem.InternalSlotName_1 = "MainHandSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = false
    comparison.ComparedItem.Addition_1 = false
    comparison.ComparedItem.InternalSlotName_2 = "SecondaryHandSlot"
    comparison.ComparedItem.Upgradenmbr_2 = 1
    comparison.ComparedItem.Print_2 = true
    comparison.ComparedItem.Addition_2 = true
  elseif ( comparison.ComparedItem.SlotName=="One-Hand" ) then
    comparison.ComparedItem.InternalSlotName_1 = "MainHandSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = false
    comparison.ComparedItem.Addition_1 = false
    comparison.ComparedItem.InternalSlotName_2 = "SecondaryHandSlot"
    comparison.ComparedItem.Upgradenmbr_2 = 1
    comparison.ComparedItem.Print_2 = true
    comparison.ComparedItem.Addition_2 = false
  elseif ( comparison.ComparedItem.SlotName=="Main Hand" ) then
    comparison.ComparedItem.InternalSlotName_1 = "MainHandSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = false
    comparison.ComparedItem.Addition_1 = false
    comparison.ComparedItem.InternalSlotName_2 = "SecondaryHandSlot"
    comparison.ComparedItem.Upgradenmbr_2 = 1
    comparison.ComparedItem.Print_2 = true
    comparison.ComparedItem.Addition_2 = true
  elseif ( comparison.ComparedItem.SlotName=="Held In Off-hand" ) then
    comparison.ComparedItem.InternalSlotName_1 = "MainHandSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = false
    comparison.ComparedItem.Addition_1 = false
    comparison.ComparedItem.InternalSlotName_2 = "SecondaryHandSlot"
    comparison.ComparedItem.Upgradenmbr_2 = 1
    comparison.ComparedItem.Print_2 = true
    comparison.ComparedItem.Addition_2 = true
  elseif ( comparison.ComparedItem.SlotName=="Off Hand" ) then
    comparison.ComparedItem.InternalSlotName_1 = "MainHandSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = false
    comparison.ComparedItem.Addition_1 = false
    comparison.ComparedItem.InternalSlotName_2 = "SecondaryHandSlot"
    comparison.ComparedItem.Upgradenmbr_2 = 1
    comparison.ComparedItem.Print_2 = true
    comparison.ComparedItem.Addition_2 = true
  elseif ( comparison.ComparedItem.SlotName=="Finger" ) then
    comparison.ComparedItem.InternalSlotName_1 = comparison.ComparedItem.SlotName.."0Slot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
    comparison.ComparedItem.InternalSlotName_2 = comparison.ComparedItem.SlotName.."1Slot"
    comparison.ComparedItem.Upgradenmbr_2 = 1
    comparison.ComparedItem.Print_2 = true
    comparison.ComparedItem.Addition_2 = false
  elseif ( comparison.ComparedItem.SlotName=="Bag" ) then
    comparison.ComparedItem.InternalSlotName_1 = comparison.ComparedItem.SlotName.."1Slot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  elseif ( comparison.ComparedItem.SlotName=="Thrown" ) then
    comparison.ComparedItem.InternalSlotName_1 = "RangedSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  elseif ( comparison.ComparedItem.SlotName=="Libram" ) then
    comparison.ComparedItem.InternalSlotName_1 = "RangedSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  elseif ( comparison.ComparedItem.SlotName=="Idol" ) then
    comparison.ComparedItem.InternalSlotName_1 = "RangedSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  elseif ( comparison.ComparedItem.SlotName=="Sigil" ) then
    comparison.ComparedItem.InternalSlotName_1 = "RangedSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  elseif ( comparison.ComparedItem.SlotName=="Totem" ) then
    comparison.ComparedItem.InternalSlotName_1 = "RangedSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  elseif ( comparison.ComparedItem.SlotName=="Relic" ) then
    comparison.ComparedItem.InternalSlotName_1 = "RangedSlot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  elseif ( comparison.ComparedItem.SlotName=="Bag" ) then
    comparison.ComparedItem.Compare = false
  elseif ( comparison.ComparedItem.SlotName=="Ammo" ) then
    comparison.ComparedItem.Compare = false
  else
    comparison.ComparedItem.InternalSlotName_1 = comparison.ComparedItem.SlotName.."Slot"
    comparison.ComparedItem.Upgradenmbr_1 = 0
    comparison.ComparedItem.Print_1 = true
    comparison.ComparedItem.Addition_1 = false
  end

  --print("AUE_Static.Comparison.GetSlotName_comparison comparison=", comparison)

  if Compare == false then
    _G.CheckingItem = false
    return comparison
  end
  --print("AUE_Static.Comparison.GetSlotName_comparison InternalSlotName_1=", comparison.ComparedItem.InternalSlotName_1)
  comparison = AUE_Static.Comparison.GetSlots_comparison(comparison)

  return comparison
end


function AUE_Static.Comparison.GetSlots_comparison(comparison)
  print("AUE_Static.Comparison.GetSlots_comparison InternalSlotName_1=", comparison.ComparedItem.InternalSlotName_1)
  if ( comparison.ComparedItem.InternalSlotName_1 == nil ) then
    print("AUE_Static.Comparison.GetSlots_comparison InternalSlotName_1=nil, aborting")
    return comparison
  end
  --print("AUE_Static.Comparison.GetSlots_comparison InternalSlotName_1", comparison.ComparedItem.InternalSlotName_1)
  --slot#1
  if ( comparison.ComparedItem.InternalSlotName_1 ~= nil ) then
    comparison.SlotID_1 = GetInventorySlotInfo(comparison.ComparedItem.InternalSlotName_1)
  end
  --slot#20
  if ( comparison.ComparedItem.InternalSlotName_2 ~= nil ) then
    comparison.SlotID_2 = GetInventorySlotInfo(comparison.ComparedItem.InternalSlotName_2)
  end
  --print("AUE_Static.Comparison.GetSlots_comparison comparison=", comparison)

  comparison = AUE_Static.Comparison.ComparedToCalculate2_comparison(comparison)

  return comparison
end

function AUE_Static.Comparison.ComparedToCalculate2_comparison(comparison)
  print("AUE_Static.ComparedToCalculate2_comparison comparison=", comparison)
  --Finn link til item equipped i samme slot
  if ( comparison.ComparedItem.InternalSlotName_1 ~= nil ) then
    comparison.ComparedItem.SlotID_1 = GetInventorySlotInfo(comparison.ComparedItem.InternalSlotName_1)
    comparison.EquippedItem_1 = GetInventoryItemLink("player", comparison.ComparedItem.SlotID_1) -- hvis 2h mot 2h så kan denne være offhand
  else
  end
  --AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)
  --print("AUE_Static.ComparedToCalculate2_comparison EquippedItem_1=", comparison.EquippedItem_1)
  --AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)

  if ( AUE_LR.HealEnabled[UnitName("player")] == 1 ) then
    --AUE_Static.Healing:PrintPrevious(tooltip)
    print("AUE_Static.Comparison.ComparedToCalculate2_comparison skal trigge heal calc")
  end
  if ( comparison.EquippedItem_1 == nil ) then
    print("AUE_Static.Comparison:ComparedToCalculate2_comparison EquippedItem_1=nil, aborting")
    return comparison
  end
  if ( AUE_LR.DPSEnabled[UnitName("player")] == 1 ) then
    comparison = AUE_Static.Comparison.CalculateDPSScenario_comparison(comparison)
  end

  return comparison
end

function AUE_Static.Comparison.CalculateDPSScenario_comparison(comparison) --calculates stats as well as DPS
  print("AUE_Static.Comparison.CalculateDPSScenario_comparison comparison=", comparison)
  --print("AUE_Static.Comparison.CalculateDPS", comparison.ItemLink)
  if ( comparison.EquippedItem_1 == nil ) then
    print("AUE_Static.Comparison:CalculateDPSScenario_comparison EquippedItem_1=nil, aborting")
    return comparison
  end
  --print("AUE_Static.Comparison.CalculateDPS continues", comparison.ItemLink, comparison.EquippedItem_1)
  --AUE_Static.DPS:PrintPrevious(tooltip)
  comparison.CurrentScenario = AUE_Static.Scenario:NewScenario_scenario(comparison.EquippedItem_1, comparison) --includes DPS results
  comparison.ComparedScenario = AUE_Static.Scenario:NewScenario_scenario(comparison.ItemLink, comparison) --includes DPS results

  if ( comparison.CurrentScenario == nil ) then
    print("AUE_Static.Comparison.CalculateDPSScenario_comparison currentScenario=nil, aborting")
    return comparison
  end
  if ( comparison.ComparedScenario == nil ) then
    print("AUE_Static.Comparison.CalculateDPSScenario_comparison comparedScenario=nil, aborting")
    return comparison
  end

  --Hvis 2 mulige slots, sjekk og lagre begge
  --print("AUE_Static.Comparison.CalculateDPSScenario_comparison comparison=", comparison)

  _G.PreviousItem = link
  --AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)
  if (comparison.ComparedScenario == nil)then
    print("AUE_Static.Comparison.ComparedToCalculate_comparison comparedScenario=nil, aborting ", link)
    return comparison
  end
  if (comparison.CurrentScenario == nil)then
    print("AUE_Static.Comparison.ComparedToCalculate_comparison currentScenario=nil, aborting ", link)
    return comparison
  end
  --print("AUE_Static.Comparison:ComparedToCalculate_comparison comparedScenario=", comparison.ComparedScenario)
  --print("AUE_Static.Comparison:ComparedToCalculate_comparison currentScenario=", comparison.CurrentScenario)
  print("AUE_Static.Comparison:ComparedToCalculate_comparison comparison=", comparison)
  return comparison
end


ItemRefTooltip:HookScript("OnTooltipSetItem", AUE_Static.Comparison.Parsing);
GameTooltip:HookScript("OnTooltipSetItem", AUE_Static.Comparison.Parsing);
--GameTooltip:HookScript("OnTooltipSetUnit", AUE_Static.Comparison.ParsingUnit);

print("AUE_Comaprison loaded")
