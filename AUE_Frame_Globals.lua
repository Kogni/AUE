-- Klassen regner ikke ut noe, forandrer ikke noe, sender ikke noe, bare henter og lagrer data.
---Globale/sessionvariabler
local AUE_Static = _G.AUE_Static
local Globals = {};
_G.AUE_Static.Globals = Globals

if ( not AUE_LR.Upgradelist ) then
  AUE_LR.Upgradelist = {}
end

if ( not AUE_LR.DPSEnabled ) then
  AUE_LR.DPSEnabled = {}
  AUE_LR.DPSEnabled[UnitName("player")] = 1
end
if ( not AUE_LR.HealEnabled ) then
  AUE_LR.HealEnabled = {}
  AUE_LR.HealEnabled[UnitName("player")] = 0
end
if ( not AUE_LR.Statlocation ) then
  AUE_LR.Statlocation = {}
  AUE_LR.Statlocation[UnitName("player")] = 2
end
if ( not AUE_LR.CharTheory ) then
  AUE_LR.CharTheory = {}
  AUE_LR.CharTheory[UnitName("player")] = 1
end
if ( not AUE_LR.AbilityTheory ) then
  AUE_LR.AbilityTheory = {}
  AUE_LR.AbilityTheory[UnitName("player")] = 1
end
if ( not AUE_LR.HitCalculations ) then
  AUE_LR.HitCalculations = {}
  AUE_LR.HitCalculations[UnitName("player")] = 1
end
if ( not AUE_LR.HitCap ) then
  AUE_LR.HitCap = {}
  AUE_LR.HitCap[UnitName("player")] = 1
end
if ( not AUE_LR.StatSorting ) then
  AUE_LR.StatSorting = {}
  AUE_LR.StatSorting[UnitName("player")] = 1
end
if ( not AUE_LR.GemQuality ) then
  AUE_LR.GemQuality = {}
  AUE_LR.GemQuality[UnitName("player")] = 1
end
if ( not AUE_LR.RaidBuffs ) then
  AUE_LR.RaidBuffs = {}
  AUE_LR.RaidBuffs[UnitName("player")] = 1
end

function AUE_Static.Globals:SetupDPS()

  print("AUE_Static.Globals:SetupDPS started")

  _G.ClassStatValuesDPS = AUE
  if ( UnitClass("player") == "Death Knight" ) then
    Class = DK
    _G.ClassStatValuesDPS.DK = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.DK
    _G.Classfile = _G.AUE_Static.DK
  elseif ( UnitClass("player") == "Druid" ) then
    Class = Druid
    _G.ClassStatValuesDPS.Druid = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Druid
    _G.Classfile = _G.AUE_Static.Druid
  elseif ( UnitClass("player") == "Hunter" ) then
    Class = Hunter
    _G.ClassStatValuesDPS.Hunter = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Hunter
    _G.Classfile = _G.AUE_Static.Hunter
  elseif ( UnitClass("player") == "Mage" ) then
    Class = Mage
    _G.ClassStatValuesDPS.Mage = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Mage
    _G.Classfile = _G.AUE_Static.Mage
  elseif ( UnitClass("player") == "Paladin" ) then
    Class = Paladin
    _G.ClassStatValuesDPS.Paladin = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Paladin
    _G.Classfile = _G.AUE_Static.Paladin
  elseif ( UnitClass("player") == "Priest" ) then
    Class = Priest
    _G.ClassStatValuesDPS.Priest = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Priest
    _G.Classfile = _G.AUE_Static.Priest
  elseif ( UnitClass("player") == "Rogue" ) then
    Class = Rogue
    _G.ClassStatValuesDPS.Rogue = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Rogue
    _G.Classfile = _G.AUE_Static.Rogue
  elseif ( UnitClass("player") == "Shaman" ) then
    Class = Shaman
    _G.ClassStatValuesDPS.Shaman= {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Shaman
    _G.Classfile = _G.AUE_Static.Shaman
  elseif ( UnitClass("player") == "Warlock" ) then
    Class = Warlock
    _G.ClassStatValuesDPS.Warlock = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Warlock
    _G.Classfile = _G.AUE_Static.Warlock
  elseif ( UnitClass("player") == "Warrior" ) then
    Class = Warrior
    _G.ClassStatValuesDPS.Warrior = {}
    _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.Warrior
    _G.Classfile = _G.AUE_Static.Warrior
  else
    print("- AGC error DPS.95. Most likely cause: Addon only supports english clients.")
  end
  _G.ClassStatValuesDPS.StatValues = {}
  _G.ClassStatValuesDPS = _G.ClassStatValuesDPS.StatValues

  _G.ClassStatValuesDPS.Agility = 0
  _G.ClassStatValuesDPS.Armor = 0
  _G.ClassStatValuesDPS.ARP = 0
  _G.ClassStatValuesDPS.AP = 0
  _G.ClassStatValuesDPS.Crit = 0
  _G.ClassStatValuesDPS.Exprate = 0
  _G.ClassStatValuesDPS.Haste = 0
  _G.ClassStatValuesDPS.Hit = 0
  _G.ClassStatValuesDPS.Intellect = 0
  _G.ClassStatValuesDPS.Mana = 0
  _G.ClassStatValuesDPS.MP5 = 0
  _G.ClassStatValuesDPS.Socket = 0
  _G.ClassStatValuesDPS.SP = 0
  _G.ClassStatValuesDPS.Spirit = 0
  _G.ClassStatValuesDPS.Stamina = 0
  _G.ClassStatValuesDPS.Strength = 0
  _G.ClassStatValuesDPS.Wpn_Main = 0
  _G.ClassStatValuesDPS.Wpn_Off = 0
  _G.ClassStatValuesDPS.Wpn_Ranged = 0
  _G.ClassStatValuesDPS.Bonusdps = 0

end

function AUE_Static.Globals:SetupHealing()

  print("AUE_Static.Globals:SetupHealing started")

  if ( AUE_LR.Healspells == nil ) then
    AUE_LR.Healspells = {}
  end

  --if ( ClassStatValues == nil ) then
  --AUE_LR.Warlock = nil
  _G.ClassStatValuesHealed = AUE
  if ( UnitClass("player") == "Death Knight" ) then
    Class = DK
    _G.ClassStatValuesHealed.DK = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.DK
    _G.Classfile = AUE_Static.DK
  elseif ( UnitClass("player") == "Druid" ) then
    Class = Druid
    _G.ClassStatValuesHealed.Druid = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Druid
    _G.Classfile = AUE_Static.Druid
  elseif ( UnitClass("player") == "Hunter" ) then
    Class = Hunter
    _G.ClassStatValuesHealed.Hunter = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Hunter
    _G.Classfile = AUE_Static.Hunter
  elseif ( UnitClass("player") == "Mage" ) then
    Class = Mage
    _G.ClassStatValuesHealed.Mage = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Mage
    _G.Classfile = AUE_Static.Mage
  elseif ( UnitClass("player") == "Paladin" ) then
    Class = Paladin
    _G.ClassStatValuesHealed.Paladin = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Paladin
    _G.Classfile = AUE_Static.Paladin
  elseif ( UnitClass("player") == "Priest" ) then
    Class = Priest
    _G.ClassStatValuesHealed.Priest = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Priest
    _G.Classfile = AUE_Static.Priest
  elseif ( UnitClass("player") == "Rogue" ) then
    Class = Rogue
    _G.ClassStatValuesHealed.Rogue = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Rogue
    _G.Classfile = AUE_Static.Rogue
  elseif ( UnitClass("player") == "Shaman" ) then
    Class = Shaman
    _G.ClassStatValuesHealed.Shaman= {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Shaman
    _G.Classfile = AUE_Static.Shaman
  elseif ( UnitClass("player") == "Warlock" ) then
    Class = Warlock
    _G.ClassStatValuesHealed.Warlock = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Warlock
    _G.Classfile = AUE_Static.Warlock
  elseif ( UnitClass("player") == "Warrior" ) then
    Class = Warrior
    _G.ClassStatValuesHealed.Warrior = {}
    _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.Warrior
    _G.Classfile = AUE_Static.Warrior
  else
    print("- AGC error heal.85")
  end

  _G.ClassStatValuesHealed.StatValues = {}
  _G.ClassStatValuesHealed = _G.ClassStatValuesHealed.StatValues

  --end

  _G.ClassStatValuesHealed.Agility = 0
  _G.ClassStatValuesHealed.Armor = 0
  _G.ClassStatValuesHealed.ARP = 0
  _G.ClassStatValuesHealed.AP = 0
  _G.ClassStatValuesHealed.Crit = 0
  _G.ClassStatValuesHealed.Exprate = 0
  _G.ClassStatValuesHealed.Haste = 0
  _G.ClassStatValuesHealed.Hit = 0
  _G.ClassStatValuesHealed.Intellect = 0
  _G.ClassStatValuesHealed.Mana = 0
  _G.ClassStatValuesHealed.MP5 = 0
  _G.ClassStatValuesHealed.Socket = 0
  _G.ClassStatValuesHealed.SP = 0
  _G.ClassStatValuesHealed.Spirit = 0
  _G.ClassStatValuesHealed.Stamina = 0
  _G.ClassStatValuesHealed.Strength = 0
  _G.ClassStatValuesHealed.Wpn_Main = 0
  _G.ClassStatValuesHealed.Wpn_Off = 0
  _G.ClassStatValuesHealed.Bonusdps = 0

end

AUE_Static.frame = CreateFrame("Frame", "AthenesUpgradeEstimatorFrame");
AUE_Static.frame:SetScript("OnEvent", AUE_Static.OnEvent);
AUE_Static.frame:RegisterEvent("ADDON_LOADED");

--SlashCmdList["AthenesUpgradeEstimator"] = AUE_Static.GUI.SlashHandler;
SLASH_AthenesUpgradeEstimator1 = "/AthenesUpgradeEstimator";
SLASH_AthenesUpgradeEstimator2 = "/AUE";

local frame = CreateFrame("FRAME", "FooAddonFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("COMBAT_LOG_EVENT");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame:RegisterEvent("COMBAT_TEXT_SHOW_RESISTANCES");
frame:RegisterEvent("COMBAT_TEXT_UPDATE");
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
frame:RegisterEvent("UNIT_COMBAT");
local function eventHandler(self, event, arg1, arg2, arg3, arg4, arg5)
  print("eventHandler event=", event, arg1, arg2, arg3, arg4, arg5);
  if ( event == "COMBAT_TEXT_UPDATE") then
    if ( arg1 == "DAMAGE") then
      AUE_Static.Functions_Abilities:COMBAT_TEXT_UPDATE(event, arg1, arg2, arg3)
    end
  elseif ( event == "UNIT_COMBAT") then
    if ( arg2 == "DAMAGE") then
      AUE_Static.Functions_Abilities:UNIT_COMBAT(event, arg1, arg2, arg3, arg4, arg5)
    end
  elseif ( event == "COMBAT_LOG_EVENT ") then
    if ( arg2 == "DAMAGE") then
      AUE_Static.Functions_Abilities:UNIT_COMBAT(event, arg1, arg2, arg3, arg4, arg5)
    end
  elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED ") then
    if ( arg2 == "DAMAGE") then
      AUE_Static.Functions_Abilities:COMBAT_LOG_EVENT_UNFILTERED(event, arg1, arg2, arg3, arg4, arg5)
    end
  else
    
  end
end
frame:SetScript("OnEvent", eventHandler);

local frame, events = CreateFrame("Frame"), {};
function events:PLAYER_ENTERING_WORLD(...)
  print("PLAYER_ENTERING_WORLD arg1=", arg1);
end
function events:PLAYER_LEAVING_WORLD(...)
  print("PLAYER_LEAVING_WORLD arg1=", arg1);
end
function events:MAIL_INBOX_UPDATE(...)
  print("MAIL_INBOX_UPDATE arg1=", arg1);
end
frame:SetScript("OnEvent", function(self, event, ...)
  events[event](self, ...); -- call one of the functions above
end);
for k, v in pairs(events) do
  frame:RegisterEvent(k); -- Register all events for which handlers have been defined
end

print("AUE_Globals loaded")
