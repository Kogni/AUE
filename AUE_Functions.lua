--TESTING
--_G.AUE_Static = {}
-----

local AUE_Static = _G.AUE_Static
local Functions = {};
_G.AUE_Static.Functions = Functions

--Klassen skal ikke lagre noen globaler, kun regne ut og returnere ting

function AUE_Static.Functions:AMinusBIsC(A, B, C)

  --print("AUE_Static.Functions:AMinusBIsC started")
  if ( A == nil ) then
    print("AUE_Static.Functions:AMinusBIsC A=nil")
    return C
  end
  if ( B == nil ) then
    print("AUE_Static.Functions:AMinusBIsC B=nil")
    return C
  end

  C = {}
  for Stat, Value in pairs( A ) do
    if (stat ~= nil) and( A[Stat] ~= nil ) and ( B[Stat] ~= nil ) then
      --print("AUE_Static.Functions:AMinusBIsC stat=", stat,"C[Stat]=", C[Stat] )
      C[Stat] = A[Stat] - B[Stat]
    end
  end

  return C

end

function AUE_Static.Functions:APlusBIsC(A, B, C)

  --print("AUE_Static.Functions:APlusBIsC started")
  if (A==nil)then
    print("AUE_Static.Functions:APlusBIsC A=nil")
    return C
  end
  if ( B == nil ) then
    print("AUE_Static.Functions:APlusBIsC B=nil")
    return C
  end

  C = {}
  --print( A.SP, B.SP )
  if ( A.SP == nil ) or ( B.SP == nil ) then
    return C
  end
  for Stat, Value in pairs( A ) do
    if ( A[Stat] ~= nil ) and ( B[Stat] ~= nil ) then
      C[Stat] = A[Stat] + B[Stat]
    end
  end

  return C

end

function AUE_Static.Functions:AvalueisBvalue(A, B)

  --print("AUE_Static.Functions:AvalueisBvalue B=", B)

  C = AUE_Static.Functions:AMinusBIsC(A, B, C)

  C.SP = (floor(C.SP * 1000))/1000
  C.Haste = (floor(C.Haste * 1000))/1000
  C.Mastery = (floor(C.Mastery * 1000))/1000
  C.Crit = (floor(C.Crit * 1000))/1000
  C.Hit = (floor(C.Hit * 1000))/1000
  C.Exprate = (floor(C.Exprate * 1000))/1000
  C.Wpn_Main = (floor(C.Wpn_Main * 1000))/1000
  C.Wpn_Off = (floor(C.Wpn_Off * 1000))/1000
  C.Wpn_Main_Speed = (floor(C.Wpn_Main_Speed * 1000))/1000
  C.Wpn_Off_Speed = (floor(C.Wpn_Off_Speed * 1000))/1000
  C.Wpn_Ranged = (floor(C.Wpn_Ranged * 1000))/1000
  C.Strength = (floor(C.Strength * 1000))/1000
  C.Agility = (floor(C.Agility * 1000))/1000
  C.AP = (floor(C.AP * 1000))/1000
  C.Stamina = (floor(C.Stamina * 1000))/1000
  C.ARP = (floor(C.ARP * 1000))/1000
  C.Intellect = (floor(C.Intellect * 1000))/1000
  C.Spirit = (floor(C.Spirit * 1000))/1000
  C.Armor = (floor(C.Armor * 1000))/1000
  C.MP5 = (floor(C.MP5 * 1000))/1000
  C.Mana = (floor(C.Mana * 1000))/1000
  C.Socket = (floor(C.Socket * 1000))/1000
  C.Bonusdps = (floor(C.Bonusdps * 1000))/1000
  C.Versatility = (floor(C.Versatility * 1000))/1000
  C.Multistrike = (floor(C.Multistrike * 1000))/1000

  for Stat, Value in pairs( C ) do
    if ( Value ~= 0 ) and ( Value ~= 0.001 ) and ( Value ~= -0.001 ) then
      --print( Stat, Value )
      return false
    end
  end
  return true

end

function AUE_Static.Functions:UpgradeColor(CurrentValue, ComparedValue)
  --print("AUE_Static.Functions:UpgradeColor started")

  _G.AUE_Static.ColorRed = 1;
  _G.AUE_Static.ColorGreen = 1;
  local NormalizedUpper
  local NormalizedLower
  if ( CurrentValue ~= nil ) then
    NormalizedUpper = (CurrentValue*1.1)
    NormalizedLower = (CurrentValue*0.9);
  end

  if ( NormalizedUpper ~= nil ) then
    local Scale = NormalizedUpper-NormalizedLower;
    if ( CurrentValue ~= nil ) then
      _G.AUE_Static.ColorRed = (NormalizedUpper - ComparedValue)/Scale
    end
    if ( _G.AUE_Static.ColorRed < 0 ) then
      _G.AUE_Static.ColorRed = 0
    elseif ( _G.AUE_Static.ColorRed > 1 ) then
      _G.AUE_Static.ColorRed = 1
    end
    if ( CurrentValue ~= nil ) then
      _G.AUE_Static.ColorGreen = (ComparedValue - NormalizedLower)/Scale
    end
    if ( _G.AUE_Static.ColorGreen > 1 ) then
      _G.AUE_Static.ColorGreen = 1
    elseif ( _G.AUE_Static.ColorGreen < 0 ) then
      _G.AUE_Static.ColorGreen = 0
    end
  end

end

function AUE_Static.Functions:FigureUpgrade(StatDiff)
  --print("AUE_Static.Functions:FigureUpgrade started")

  local Upgrade = 0

  if ( _G.ClassStatValuesDPS ) then
    --ClassStatValuesDPS defineres i Globals
    Upgrade = Upgrade + (floor((StatDiff.Strength * _G.ClassStatValuesDPS.Strength) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Agility * _G.ClassStatValuesDPS.Agility) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.AP * _G.ClassStatValuesDPS.AP) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.SP * _G.ClassStatValuesDPS.SP) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Haste * _G.ClassStatValuesDPS.Haste) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Mastery * _G.ClassStatValuesDPS.Mastery) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Crit * _G.ClassStatValuesDPS.Crit) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Exprate * _G.ClassStatValuesDPS.Exprate) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.ARP * _G.ClassStatValuesDPS.ARP) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Intellect * _G.ClassStatValuesDPS.Intellect) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Spirit * _G.ClassStatValuesDPS.Spirit) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Socket * _G.ClassStatValuesDPS.Socket) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Wpn_Main * _G.ClassStatValuesDPS.Wpn_Main) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Wpn_Off * _G.ClassStatValuesDPS.Wpn_Off) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Wpn_Ranged * _G.ClassStatValuesDPS.Wpn_Ranged) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Hit * _G.ClassStatValuesDPS.Hit) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Multistrike * _G.ClassStatValuesDPS.Multistrike) * 1000))/1000
    Upgrade = Upgrade + (floor((StatDiff.Versatility * _G.ClassStatValuesDPS.Versatility) * 1000))/1000

  end

  return Upgrade
end

function AUE_Static.Functions:SearchAbility_AbilityInfo(SearchName)
  --print("AUE_Static.Functions:SearchAbility started")

  --Abilities2 defineres per class: AUE_Static.Paladin.Abilities2 = {}
  for Abilitynmbr, Abilityinfo in pairs( _G.Classfile.Abilities2 ) do
    local AbilitycountA = A
    if ( Abilityinfo ~= nil ) and ( Abilityinfo.Name ~= nil ) then
      if ( Abilityinfo.Name == SearchName ) then
        return Abilityinfo
      end
    end
  end
  return nil
end

function AUE_Static.Functions:MakeNewStatSet()
  --print("AUE_Static.Functions:MakeNewStatSet started")
  local CalculateStatSet_Base
  CalculateStatSet_Base = {};
  CalculateStatSet_Base.Mana = 0
  CalculateStatSet_Base.MP5 = 0
  CalculateStatSet_Base.SP = 0
  CalculateStatSet_Base.Haste = 0
  CalculateStatSet_Base.Mastery = 0
  CalculateStatSet_Base.Versatility = 0
  CalculateStatSet_Base.Multistrike = 0
  CalculateStatSet_Base.Crit = 0
  CalculateStatSet_Base.Hit = 0
  CalculateStatSet_Base.Exprate = 0
  CalculateStatSet_Base.Wpn_Main = 0
  CalculateStatSet_Base.Wpn_Off = 0
  CalculateStatSet_Base.Wpn_Ranged = 0
  CalculateStatSet_Base.Wpn_Main_Speed = 0
  CalculateStatSet_Base.Wpn_Off_Speed = 0
  CalculateStatSet_Base.Wpn_Ranged_Speed = 0
  CalculateStatSet_Base.Strength = 0
  CalculateStatSet_Base.Agility = 0
  CalculateStatSet_Base.AP = 0
  CalculateStatSet_Base.Stamina = 0
  CalculateStatSet_Base.Intellect = 0
  CalculateStatSet_Base.ARP = 0
  CalculateStatSet_Base.Armor = 0
  CalculateStatSet_Base.Spirit = 0
  CalculateStatSet_Base.Socket = 0
  CalculateStatSet_Base.CatAP = 0
  CalculateStatSet_Base.Bonusdps = 0
  CalculateStatSet_Base.EnergyRegenPerSec = 0

  return CalculateStatSet_Base
end

function AUE_Static.Functions:AddStat2_item(item, stat, value)
  --print("AUE_Static.Functions:AddStat started")

  stat = strlower(stat) -- make lowercase
  stat = gsub(stat, "|r", ""); -- remove formatting
  stat = gsub(stat, " ", ""); -- remove spaces
  value = tonumber(value);
  if item[stat] == nil then
    item[stat] = value;
  else
    item[stat] = item[stat] + value;
  end

  return item;

end

function AUE_Static.Functions:MakeDefaultAbility()

  --print("AUE_Static.Functions:MakeDefaultAbility started")

  local NewAbility = {}
  NewAbility.Frame = {}
  NewAbility.Frame.Name = ""
  NewAbility.Frame.DmgPrcnt = 0
  NewAbility.Frame.OfPotential = 0
  NewAbility.Frame.BaseDmg = 0
  NewAbility.Frame.CD = 0
  NewAbility.Frame.CritBonus = 1
  NewAbility.Frame.CritChance = 0
  NewAbility.Frame.Wpn_Main_Coeff = 0
  NewAbility.Frame.Wpn_Off_Coeff = 0
  NewAbility.Frame.Wpn_Ranged = 0
  NewAbility.Frame.HitCap = 0
  NewAbility.Frame.ExpCap = 0
  NewAbility.Frame.Targets = 1

  NewAbility.Frame.SP_Coeff = 0
  NewAbility.Frame.TalentSPCoeff = 0

  NewAbility.Frame.ScaleApToWeap = 0
  NewAbility.Frame.ScaleCastToWeap = false

  NewAbility.Frame.BaseApCoeff = 0
  NewAbility.Frame.BaseCast = 0

  NewAbility.Frame.DPSCD = 0

  NewAbility.Frame.TriggersWpnProccs = false

  return NewAbility
end

function AUE_Static.Functions:GetItemStats_scenarioItem(scenarioItem)
  print("AUE_Static.Functions:GetItemStats item=", scenarioItem.ItemLink)
  if (scenarioItem.ItemLink == nil )then
    print("AUE_Static.Functions:GetItemStats scenario.ItemLink=nil, aborting")
    return scenarioItem
  end
  if (scenarioItem.Tooltip == nil )then
    print("AUE_Static.Functions:GetItemStats scenario.Tooltip=nil, aborting ", scenarioItem.ItemLink)
    return scenarioItem
  end
  if (scenarioItem.GotItemStats == true )then
    print("AUE_Static.Functions:GetItemStats GotItemStats==true, aborting")
    return scenarioItem
  end
  --print("AUE_Static.Functions:GetItemStats continues ")
  scenarioItem.itemstats = AUE_Static.Functions:MakeNewStatSet()
  --print("AUE_Static.Functions:GetItemStats itemstats=", itemstats)

  local Usable1 = AUE_Static.Functions_Class:CanUse1(scenarioItem)
  --local Usable2 = AUE_Static.Functions_Class:CanUse2(ItemLink)
  --print("AUE_Static.Functions:GetItemStats Usable1=", Usable1, "Usable2=", Usable2)

  AUE_Static.Functions_Item:CalculateStatSet_scenario( scenarioItem )

  scenarioItem.ItemName, scenarioItem.ItemLink, scenarioItem.itemRarity, scenarioItem.ilevel, scenarioItem.itemMinLevel, scenarioItem.itemType, scenarioItem.itemSubType, scenarioItem.itemStackCount, scenarioItem.itemEquipLoc, scenarioItem.itemTexture = GetItemInfo( scenarioItem.ItemLink )
  scenarioItem.ItemStats = AUELR_ItemDB.ItemInfo[ scenarioItem.Item_String..":"..scenarioItem.ItemName ].itemstats

  if ( scenarioItem.ItemStats ) then
    if ( scenarioItem.ItemStats ~= nil ) then
      for stat, value in pairs (scenarioItem.ItemStats ) do
        if stat ~= nil then
          AUE_Static.Functions_Item:StartLeting( stat, value, scenarioItem )
          --print("AUE_Static.Functions:GetItemStats stat=", stat, "value=", value)
        end
      end
    end
  end

  if (scenarioItem.itemstats == nil) then
    print("AUE_Static.Functions:GetItemStats scenario.itemstats=nil")
  end
  AUE_Static.Functions_Item:ReadLines_scenario(scenarioItem)
  scenarioItem.GotItemStats = true
  return scenarioItem
end

function AUE_Static.Functions:GetSortedStats(StatsSet)
end

print("AUE_Functions loaded")

--TESTING
--scenario = {}
--scenario.ItemLink = "[Acid-Munched Greathelm]"
--tooltip = {}
--scenario.Tooltip = tooltip
--AUE_Static.Functions:GetItemStats_scenarioItem(scenario)
print("")