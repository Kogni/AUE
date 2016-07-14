local AUE_Static = _G.AUE_Static
_G.AUE_Static.Started = false

function AUE_Static.OnEvent()
  print("AUE_Static.OnEvent event=", event)

  if (event == "ADDON_LOADED") then
    if ( _G.AUE_Static.Started == nil ) or ( _G.AUE_Static.Started == false ) then
      _G.AUE_Static.Started = true

      --Finn ut universale/statiske data (AUE_Universals)
      --Finn ut globale/session data (AUE_Globals)
      --Finn ut lokale/moment data (AUE_Locals)
      --Finn ut karakterinfo--
      --singlesource - get class: UnitClass("player")
      --multisource - get Specc
      --multisource - get Level
      --multisource - get Stats
      AUE_Static.Locals.GetStats()
      --multisource - get Gear equipped
      AUE_Static.Locals.GetEquipment()
      --multisource - get Buffs applied
      AUE_Static.Locals.GetBuffs()
      --multisource - calculate CombatRating ratingPerPercent

      --multisource - load Combat rotation DPS/heal
      AUE_Static.Locals.LoadRotation()
      --multisource - calculate dps/heal
      AUE_Static.Locals.GetCombatResults()
      --multisource - calculate stat values
      AUE_Static.Locals.GetRatings()
      --multisource - update char gui
      AUE_Static.GUI_CharScreen:UpdateDoll()
      --multisource - update ability gui

      --multisource - update aue gui

      --multisource - update tooltips'

    else
      return
    end
  else
    print("AUE_Static.OnEvent event=", event)
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
    end
  end
end

local function main()
  AUE_Static.OnEvent()
end
main()

print("AUE_Load loaded")
