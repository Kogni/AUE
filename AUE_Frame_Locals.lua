-- Klassen regner ikke ut noe, forandrer ikke noe, sender ikke noe, bare skaffer og lagrer data.
---Lokale/momentvariabler
local AUE_Static = _G.AUE_Static
local Locals = {};
_G.AUE_Static.Locals = Locals

_G.MouseoveredItem = GameTooltip:GetItem();

_G.RatingPerCrit = 45.9
_G.RatingPerHaste = 32.8
_G.RatingPerMastery = 45.9
_G.RatingPerMultistrike = 45.9
_G.RatingPerVersatility = 45.9
_G.AgiPerCrit = 62.5
_G.IntPerCrit = 166
_G.RatingPerARP = 16
_G.RatingPerMeleeHit = 32.8
_G.RatingPerSpellHit = 26.2
_G.RatingPerExp = 32.8

_G.HastableDPS = 0
_G.CrittableDmg = 0
_G.AvgCritDmg = 0
_G.TotalDPS_Current = 0

local ColorRed, ColorGreen, ColorBlue
_G.AUE_Static.ColorRed = ColorRed
_G.AUE_Static.ColorGreen = ColorGreen
_G.AUE_Static.ColorBlue = ColorBlue

_G.PreviousItem = ""
_G.CheckingItem = false
--singlesource - get class: UnitClass("player")
--multisource - get Specc
--multisource - get Level
--multisource - get Stats
function AUE_Static.Locals.GetStats()

  --print("AUE_Static.Locals.GetStats started")

  local StatsSet = AUE_Static.Functions:MakeNewStatSet()
  _G.EnergyRegenPerSec_Current = 10
  StatsSet.EnergyRegenPerSec = 10

  StatsSet.Mana = 0
  StatsSet.Mana = UnitManaMax("player");
  local base, casting = GetManaRegen()
  StatsSet.MP5 = (casting*5)
  StatsSet.SP = GetSpellBonusDamage(4);
  StatsSet.Haste = GetCombatRating(18)
  StatsSet.Hit = 0
  StatsSet.Exprate = GetCombatRating(24) --exp RATING
  StatsSet.ARP = GetCombatRating(25)
  StatsSet.Mastery = GetCombatRating(26)
  StatsSet.Versatility = GetCombatRating(29)
  StatsSet.Multistrike = GetCombatRating(CR_MULTISTRIKE)
  StatsSet.Socket = 0

  local baseArmor , effectiveArmor, armor, posBuff, negBuff = UnitArmor("player");
  StatsSet.Armor = effectiveArmor

  local _, Strength, _, _ = UnitStat("player", 1);
  StatsSet.Strength = 0 --fordi all AP ink fra str addes lengre ned
  local _, Agility, _, _ = UnitStat("player", 2);
  StatsSet.Agility = 0 --fordi crit og avt ap addes lenre ned
  local _, Stamina, _, _ = UnitStat("player", 3);
  StatsSet.Stamina = 0 --fordi evt ap addes lengre ned
  local _, Intellect, _, _ = UnitStat("player", 4);
  StatsSet.Intellect = 0 --fordi mana, crit og mp5 addes lengre ned
  local _, Spirit, _, _ = UnitStat("player", 5);
  StatsSet.Spirit = 0 --fordi mp5 og sp addes lengre ned

  local base, posBuff, negBuff = UnitAttackPower("player");
  local effective = base + posBuff + negBuff;
  StatsSet.AP = effective

  StatsSet.Hit = GetCombatRating(6)

  if ( GetCombatRating(9) > GetCombatRating(11) ) then
    StatsSet.Crit = GetCombatRating(9)
  else
    StatsSet.Crit = GetCombatRating(11)
  end
  --Weapon speeds, requires haste knowledge
  lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("player");
  local mainSpeed, offSpeed = UnitAttackSpeed("player");

  local HasteBeforeTalents = StatsSet.Haste
  local EmptyStats = AUE_Static.Functions:MakeNewStatSet()
  local ResultStats = AUE_Static.Functions_Class:ApplyStatTalents(EmptyStats)
  local HasteAfterTalents = ResultStats.Haste
  local HasteToUse = HasteBeforeTalents
  if ( HasteAfterTalents > HasteBeforeTalents ) then
    HasteToUse = (HasteBeforeTalents+HasteAfterTalents)
  end
  mainSpeed = mainSpeed * ( (100+ (HasteToUse/ _G.RatingPerHaste) )/100)

  StatsSet.Wpn_Main_Speed = mainSpeed

  local WpnDmg = ((lowDmg+hiDmg)/2) --((StatsSet.AP/14)*mainSpeed)

  WpnDmg = WpnDmg - (StatsSet.AP/14*mainSpeed)
  StatsSet.Wpn_Main = WpnDmg
  StatsSet.Wpn_Main = (floor( StatsSet.Wpn_Main * 100 ))/100

  --offhand
  if ( offSpeed ~= nil ) then
    offSpeed = offSpeed * ( (100+ (HasteToUse/ _G.RatingPerHaste) ) /100)
    StatsSet.Wpn_Off_Speed = offSpeed
    local WpnDmg = ((offlowDmg+offhiDmg)/2) --((StatsSet.AP/14)*offSpeed)

    WpnDmg = WpnDmg-((StatsSet.AP/14*offSpeed)*0.5)

    StatsSet.Wpn_Off = WpnDmg
  else
    StatsSet.Wpn_Off = 0
    StatsSet.Wpn_Off_Speed = 0
  end
  -- done calc weapon speeds

  local MHlink = GetInventoryItemLink("player", 16)
  if ( OHlink ~= nil ) then
    local _, _, _, _, _, _, MH = GetItemInfo(MHlink)
    AUE_Static.MHtype = MH
  else
    AUE_Static.MHtype = nil
  end
  local OHlink = GetInventoryItemLink("player", 17)
  if ( OHlink ~= nil ) then
    local _, _, _, _, _, _, OH = GetItemInfo(OHlink)
    AUE_Static.OHtype = OH
  else
    AUE_Static.OHtype = nil
  end
  AUE_Static.MHtype_compared = AUE_Static.MHtype
  AUE_Static.OHtype_compared = AUE_Static.OHtype

  --Ranged not affected by haste??
  local speed, lowDmg, hiDmg, posBuff, negBuff, percent = UnitRangedDamage("player");
  local WpnDmg = ((lowDmg+hiDmg)/2)-((StatsSet.AP/14)*speed)
  StatsSet.Wpn_Ranged = WpnDmg

  AUE_Static.Locals.StatsSet = StatsSet
  _G.CurrentStats_Combat = StatsSet
  --print("AUE_Static.Locals.GetStats() _G.CurrentStats_Combat.Versatility=", _G.CurrentStats_Combat.Versatility)
  --print("AUE_Static.Locals.GetStats() StatsSet.Wpn_Main=", StatsSet.Wpn_Main, "StatsSet.Haste=", StatsSet.Haste)
end

--multisource - get Gear equipped
function AUE_Static.Locals.GetEquipment()
  for i = 1, 18 do
    if i == 4 then
    else
      GameTooltip:SetInventoryItem("player", i );
    end
  end
end

--multisource - get Buffs applied
function AUE_Static.Locals.GetBuffs()
end

--multisource - calculate CombatRating ratingPerPercent
function AUE_Static.Locals.GetRatings()
end

--multisource - load Combat rotation DPS/heal
function AUE_Static.Locals.LoadRotation()
  AUE_Static.Rotations:CreateDefault()
  AUE_Static.HealRotations:CreateDefault()
end

--multisource - calculate stat values
function AUE_Static.Locals.GetStatValues()
end



print("AUE_Locals loaded")
