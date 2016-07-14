--TESTING
--_G.AUE_Static = {}

--AUE_LR = {}
--AUE_LR.HealEnabled = {}
--AUE_LR.DPSEnabled = {}

--function UnitName()
--  return "testname"
--end

--PaperDollFrame = {}
--function PaperDollFrame:HookScript()end
--function PaperDollFrame:CreateFontString()end
--StatValuesDPS = {}
--function StatValuesDPS:SetFont() end
--function StatValuesDPS:SetJustifyH() end
--function StatValuesDPS:SetPoint() end
--function StatValuesDPS:SetText() end
--function StatValuesDPS:Show() end
--Abilities = {}
--function Abilities:SetFont() end
--function Abilities:SetJustifyH() end
--function Abilities:SetPoint() end
--function Abilities:SetText() end
--function Abilities:Show() end
--DPSEstimates = {}
--function DPSEstimates:SetFont() end
--function DPSEstimates:SetJustifyH() end
--function DPSEstimates:SetPoint() end
--function DPSEstimates:SetText() end
--function DPSEstimates:Show() end
--StatValuesHeal = {}
--function StatValuesHeal:SetFont() end
--function StatValuesHeal:SetJustifyH() end
--function StatValuesHeal:SetPoint() end
--function StatValuesHeal:SetText() end
--function StatValuesHeal:Show() end
--HealEstimates = {}
--function HealEstimates:SetFont() end
--function HealEstimates:SetJustifyH() end
--function HealEstimates:SetPoint() end
--function HealEstimates:SetText() end
--function HealEstimates:Show() end
--StatsDiffFrame = {}
--function StatsDiffFrame:SetFont() end
--function StatsDiffFrame:SetJustifyH() end
--function StatsDiffFrame:SetPoint() end
--function StatsDiffFrame:SetText() end
--function StatsDiffFrame:Show() end
--StatDiff = {}
--function StatDiff:SetFont() end
--function StatDiff:SetJustifyH() end
--function StatDiff:SetPoint() end
--function StatDiff:SetText() end
--function StatDiff:Show() end
--function StatDiff:SetShadowColor() end

--function StatsDiffFrame:SetBackdropColor() end
--function StatsDiffFrame:SetFrameStrata() end
--function StatsDiffFrame:SetPoint() end
--function StatsDiffFrame:SetBackdrop() end
--function StatsDiffFrame:CreateFontString() end
--function CreateFrame(a,a)
--  return StatsDiffFrame
--end
-----

local AUE_Static = _G.AUE_Static
local GUI_CharScreen = {}
AUE_Static.GUI_CharScreen = GUI_CharScreen

function AUE_Static.GUI_CharScreen:UpdateDoll()
  print("AUE_Static.GUI_CharScreen:UpdateDoll")

  --regn ut current stats
  AUE_Static.Locals.GetStats()

  --hent current stats

  --combat estimates
  AUE_Static.GUI_CharScreen:CombatEstimates()

  --stat values
  AUE_Static.GUI_CharScreen:StatValues()

  --Rotation
  if ( ClassAbilityValues ~= nil ) then
    local Text = "Rotation: "..RotationDB.ActiveRotation[UnitName("player")].."\n"
  end

end

function AUE_Static.GUI_CharScreen:CombatEstimates()
  if ( AUE_LR.HealEnabled[UnitName("player")] == 1 ) then
    if ( _G.AUELocal.Heal ~= nil ) then
      if ( _G.AUE_Static.Heal.HPS ~= nil ) then
        local HealEstimate = "Heal estimates".."\n"
        HealEstimate = HealEstimate.."HPS : ".._G.AUELocal.H
      else
        print("AUE_Static.GUI_CharScreen:UpdateDoll Heal is enabled, but HPS is NIL")
      end
    else
      print("AUE_Static.GUI_CharScreen:UpdateDoll Heal is enabled, but heal data are NIL")
    end
  end
end

function AUE_Static.GUI_CharScreen:StatValues()
  if ( AUE_LR.HealEnabled[UnitName("player")] == 1 ) then
    if ( ClassValues ) then
      local Text = "Heal stat values:\n"
      Text = Text.."(Healed before oom)".."\n"
      Text = Text.."SP : "      ..ClassValues.SP.."\n"
      Text = Text.."Mana : "      ..ClassValues.Mana.."\n"
      Text = Text.."MP5 : "     ..ClassValues.MP5.."\n"
      Text = Text.."Haste rating : "  ..ClassValues.Haste.."\n"
      Text = Text.."Crit rating : " ..ClassValues.Crit.."\n"
      Text = Text.."Intellect : "   ..ClassValues.Intellect.."\n"
      if ( ClassValues.Spirit ~= nil ) then
        Text = Text.."Spirit : "    ..ClassValues.Spirit.."\n"
      end

      StatValuesHeal:SetText(  Text )
    end
  end

  if ( AUE_LR.DPSEnabled[UnitName("player")] == 1 ) then
    if ( _G.ClassStatValuesDPS ) then
      local Text = "Stat values:\n"
      Text = Text.."(DPS per 1 stat)".."\n"
      local Shortened

      local Temp = AUE_Static.Functions:GetSortedStats(_G.ClassStatValuesDPS)
      if ( Temp == nil)then
        print("AUE_Static.GUI_CharScreen:StatValues sorted stats are NIL")
        return
      end
      for Rank, Stat in pairs( Temp ) do
        if ( _G.ClassStatValuesDPS[Stat] > 0 ) then
          if ( Stat ~= "Bonusdps" ) then
            Shortened = (floor(_G.ClassStatValuesDPS[Stat]*1000))/1000
            local Name = Stat
            if ( Stat == "Wpn_Off_Speed" ) then
              Name = "OH wpn speed"
            elseif ( Stat == "Wpn_Main_Speed" ) then
              Name = "MH wpn speed"
            elseif ( Stat == "Wpn_Main" ) then
              Name = "MH wpn dmg"
            elseif ( Stat == "Wpn_Off" ) then
              Name = "OH wpn dmg"
            elseif ( Stat == "EnergyRegenPerSec" ) then
              Name = "Energy regen"
            end
            Text = Text..Name.." : "..Shortened.."\n"
          end
        end
      end

      Text = Text.."-Stats not showing have 0 value-".."\n"

      --local Temp = AUE_Static.ItemStats:GetSortedStats()

    else
      print("AUE_Static.GUI_CharScreen:StatValues  _G.ClassStatValuesDPS are NIL")
      return
    end
  end
end

PaperDollFrame:HookScript("OnShow", AUE_Static.GUI_CharScreen.CharVinduAapnet)

------
PaperDollFrame:CreateFontString("StatValuesDPS")
StatValuesDPS:SetFont("Fonts\\FRIZQT__.TTF", 12)
StatValuesDPS:SetJustifyH("LEFT")
StatValuesDPS:SetPoint("TOPLEFT",PaperDollFrame,"TOPRIGHT",20,-10)
StatValuesDPS:SetText(" ")
StatValuesDPS:Show()

PaperDollFrame:CreateFontString("Abilities")
Abilities:SetFont("Fonts\\FRIZQT__.TTF", 12)
Abilities:SetJustifyH("LEFT")
Abilities:SetPoint("TOPLEFT",PaperDollFrame,"TOPRIGHT",(180+160),-10)
Abilities:SetText("Abilities:")
Abilities:Show()

PaperDollFrame:CreateFontString("DPSEstimates")
DPSEstimates:SetFont("Fonts\\FRIZQT__.TTF", 12)
DPSEstimates:SetJustifyH("LEFT")
DPSEstimates:SetPoint("TOPLEFT",PaperDollFrame,"TOPRIGHT",180,-10)
DPSEstimates:SetText("Estimated DPS:")
DPSEstimates:Show()

--
PaperDollFrame:CreateFontString("StatValuesHeal")
StatValuesHeal:SetFont("Fonts\\FRIZQT__.TTF", 12)
StatValuesHeal:SetJustifyH("LEFT")
StatValuesHeal:SetPoint("TOPLEFT",PaperDollFrame,"TOPRIGHT",20,-300)
StatValuesHeal:SetText(" ")
StatValuesHeal:Show()

PaperDollFrame:CreateFontString("HealEstimates")
HealEstimates:SetFont("Fonts\\FRIZQT__.TTF", 12)
HealEstimates:SetJustifyH("LEFT")
HealEstimates:SetPoint("TOPLEFT",PaperDollFrame,"TOPRIGHT",180,-300)
HealEstimates:SetText(" ")
HealEstimates:Show()

-----
StatsDiffFrame = CreateFrame("Frame", "StatsDiffFrame");
StatsDiffFrame:SetBackdropColor(1,1,1,1);
StatsDiffFrame:SetFrameStrata("TOOLTIP")
StatsDiffFrame:SetPoint("TOPLEFT",GameTooltip,"TOPRIGHT",0,0)
StatsDiffFrame:SetBackdrop({
  bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  tile = true, tileSize = 32, edgeSize = 32,
  insets = { left = 9, right = 9, top = 9, bottom = 9}
})
StatsDiffFrame:SetBackdropColor(0,0,0,2)
StatsDiffFrame:Show()

StatsDiffFrame:CreateFontString("StatDiff")
StatDiff:SetJustifyH("LEFT")
StatDiff:SetFont("Fonts\\FRIZQT__.TTF", 12)
StatDiff:SetShadowColor(1, 1, 1, 1)
StatDiff:SetPoint("TOPLEFT",GameTooltip,"TOPRIGHT",10,0)
StatDiff:SetText(" ")
StatDiff:Show()

--TESTING
--AUE_Static.GUI_CharScreen:StatValues()
