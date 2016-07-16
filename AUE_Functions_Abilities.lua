local AUE_Static = _G.AUE_Static
local Functions_Abilities = {};
_G.AUE_Static.Functions_Abilities = Functions_Abilities

function AUE_Static.Functions_Abilities:COMBAT_TEXT_UPDATE(event, arg1, arg2, arg3)
  print("AUE_Static.Functions_Abilities:COMBAT_TEXT_UPDATE event=", event, " ", arg1, " ", arg2, " ", arg3)
  --arg1
  --Combat message type. Known values include "DAMAGE", "SPELL_DAMAGE", "DAMAGE_CRIT", "HEAL", "PERIODIC_HEAL", "HEAL_CRIT", "MISS", "DODGE", "PARRY", "BLOCK", "RESIST", "SPELL_RESISTED", "ABSORB", "SPELL_ABSORBED", "MANA", "ENERGY", "RAGE", "FOCUS", "SPELL_ACTIVE", "COMBO_POINTS", "AURA_START", "AURA_END", "AURA_START_HARMFUL", "AURA_END_HARMFUL", "HONOR_GAINED", and "FACTION".
  --arg2
  --For damage, power gain and honor gains, this is the amount taken/gained.
  --For heals, this is the healer name. For auras, the aura name.
  --For block/resist/absorb messages where arg3 is not nil (indicating a partial block/resist/absorb) this is the amount taken.
  --For faction gain, this is the faction name.
  --For the SPELL_ACTIVE message, the name of the spell (abilities like Overpower and Riposte becoming active will trigger this message).
  --arg3
  --For heals, the amount healed.
  --For block/resist/absorb messages, this is the amount blocked/resisted/absorbed, or nil if all damage was avoided.
  --For faction gain, the amount of reputation gained.
  --arg3 does NOT return amount absorbed since at least patch 2.4
  print("AUE_Static.Functions_Abilities:COMBAT_TEXT_UPDATE Dmg=", arg2, "ability=", nil)

end

function AUE_Static.Functions_Abilities:UNIT_COMBAT(event, arg1, arg2, arg3, arg4, arg5)
  print("AUE_Static.Functions_Abilities.UNIT_COMBAT event=", event, " ", arg1, " ", arg2, " ", arg3, " ", arg4, " ", arg5)
  --Fired when an npc or player participates in combat and takes damage-
  --arg1-the UnitID of the entity
  --arg2-Action,Damage,etc (e.g. HEAL, DODGE, BLOCK, WOUND, MISS, PARRY, RESIST, ...)
  --arg3-Critical/Glancing indicator (e.g. CRITICAL, CRUSHING, GLANCING)
  --arg4-The numeric damage
  --arg5-Damage type in numeric value (1 - physical; 2 - holy; 4 - fire; 8 - nature; 16 - frost; 32 - shadow; 64 - arcane)
  print("AUE_Static.Functions_Abilities:UNIT_COMBAT Dmg=", arg4, "ability=", nil)
end

function AUE_Static.Functions_Abilities:COMBAT_LOG_EVENT (event, arg1, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2)
  print("AUE_Static.Functions_Abilities.COMBAT_LOG_EVENT event=", event, " ", arg1, " ", sourceGUID, " ", sourceName, " ", sourceFlags, " ", sourceFlags2, " ", destGUID, " ", destName, " ", destFlags, " ", destFlags2)
  --1st Param - unknown
  --print("AUE_Static.Functions_Abilities:COMBAT_LOG_EVENT Dmg=", nil, "ability=", nil)
end

function AUE_Static.Functions_Abilities:COMBAT_LOG_EVENT_UNFILTERED (event, timestamp, eventtype, sourceGUID, sourceName, caster, destGUID, destName, destFlags, spellID, spellName, spellSchool, arg12, arg13)
  --print("AUE_Static.Functions_Abilities.COMBAT_LOG_EVENT_UNFILTERED event=", event, timestamp, eventtype, sourceGUID, sourceName, caster, destGUID, destName, destFlags,spellID, spellName, spellSchool, arg12, arg13)
  --print("AUE_Static.Functions_Abilities.COMBAT_LOG_EVENT_UNFILTERED event2=", event2)
  -- arg12 - SuffixParam1
  -- arg13 - SuffixParam2
  -- arg14 - SuffixParam3
  -- arg15 - SuffixParam4
  -- arg16 - SuffixParam5
  -- arg17 - SuffixParam6
  -- arg18 - SuffixParam7
  -- arg19 - SuffixParam8
  -- arg20 - SuffixParam9
  if ( eventtype == "SWING_DAMAGE") then
    if ( caster == UnitName("player")) then
      print("AUE_Static.Functions_Abilities.COMBAT_LOG_EVENT_UNFILTERED Player does melee dmg")
      print("AUE_Static.Functions_Abilities.COMBAT_LOG_EVENT_UNFILTERED sourceGUID=",sourceGUID, "sourceName=",sourceName)
        print("AUE_Static.Functions_Abilities:COMBAT_LOG_EVENT_UNFILTERED Dmg=", nil, "ability=", spellID)
      AUE_Static.Functions_Abilities:SwingDamage(timestamp, eventtype, sourceGUID, sourceName, caster, destGUID, destName, destFlags, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand, multistrike)
    end
  end

end

function AUE_Static.Functions_Abilities:SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand, multistrike)
end

function AUE_Static.Functions_Abilities:NoteAbilityDmg(abilityID, nonCritDmg)
  print("AUE_Static.Functions_Abilities:NoteAbilityDmg(abilityID ", abilityID)
  if AthenesDB.Formulas[abilityID] == nil then
    AthenesDB.Formulas[abilityID] = {}
  end

  ------- BASIC DATAS
  AthenesDB.Formulas[abilityID].Hits = AthenesDB.Formulas[abilityID].Hits + 1
  AthenesDB.Formulas[abilityID].Dmg = AthenesDB.Formulas[abilityID].Dmg + nonCritDmg
  AthenesDB.Formulas[abilityID].SP = AthenesDB.Formulas[abilityID].SP + GetSpellBonusDamage(4);
  AthenesDB.Formulas[abilityID].VersatilityPrcnt = AthenesDB.Formulas[abilityID].VersatilityPrcnt + (GetCombatRating(29)/_G.RatingPerVersatility)

  local base, posBuff, negBuff = UnitAttackPower("player");
  local effective = base + posBuff + negBuff;
  AthenesDB.Formulas[abilityID].AP = AthenesDB.Formulas[abilityID].AP + effective
  local APplusSP = GetSpellBonusDamage(4) + effective

  -------- STATISTICS

  local unmodified = nonCritDmg / (1+(GetCombatRating(29)/_G.RatingPerVersatility))
  if ( unmodified < AthenesDB.Formulas[abilityID].LeastDmg) then
    AthenesDB.Formulas[abilityID].LeastDmg = nonCritDmg
  end
  if ( unmodified > AthenesDB.Formulas[abilityID].MostDmg) then
    AthenesDB.Formulas[abilityID].MostDmg = nonCritDmg
  end

  local dmgDiff = AthenesDB.Formulas[abilityID].MostDmg - AthenesDB.Formulas[abilityID].LeastDmg

  local dmgPerP = dmgDiff / (AthenesDB.Formulas[abilityID].SP+AthenesDB.Formulas[abilityID].AP)
  if ( dmgPerP > AthenesDB.Formulas[abilityID].DmgPerP) then
    AthenesDB.Formulas[abilityID].DmgPerP = dmgPerP
  end
  local LeastBase = unmodified - (AthenesDB.Formulas[abilityID].DmgPerP * APplusSP)
  if LeastBase <AthenesDB.Formulas[abilityID].LeastBase then
    AthenesDB.Formulas[abilityID].LeastBase = LeastBase
  end

  local dmgPerAP = dmgDiff / AthenesDB.Formulas[abilityID].AP
  if ( dmgPerAP < AthenesDB.Formulas[abilityID].DmgPerAP) then
    AthenesDB.Formulas[abilityID].DmgPerAP = dmgPerAP
  end
  local LeastAPScale = unmodified - (AthenesDB.Formulas[abilityID].DmgPerAP * dmgPerAP)
  if LeastAPScale < AthenesDB.Formulas[abilityID].LeastAPScale then
    AthenesDB.Formulas[abilityID].LeastAPScale = LeastAPScale
  end

  local dmgPerAP = dmgDiff / AthenesDB.Formulas[abilityID].AP
  if ( dmgPerAP < AthenesDB.Formulas[abilityID].DmgPerAP) then
    AthenesDB.Formulas[abilityID].DmgPerAP = dmgPerAP
  end
  local LeastSPScale = unmodified - (AthenesDB.Formulas[abilityID].DmgPerSP * dmgPerSP)
  if LeastSPScale < AthenesDB.Formulas[abilityID].LeastSPScale then
    AthenesDB.Formulas[abilityID].LeastSPScale = LeastSPScale
  end


  ------- ESTIMATES
  AthenesDB.Formulas[abilityID].Base = AthenesDB.Formulas[abilityID].LeastBase
  AthenesDB.Formulas[abilityID].APScale = AthenesDB.Formulas[abilityID].LeastAPScale
  AthenesDB.Formulas[abilityID].SPScale = AthenesDB.Formulas[abilityID].LeastSPScale
  print("AUE_Static.Functions_Abilities:NoteAbilityDmg(abilityID ", abilityID, " Base=", AthenesDB.Formulas[abilityID].Base )
  print("AUE_Static.Functions_Abilities:NoteAbilityDmg(abilityID ", abilityID, " AP Scale", AthenesDB.Formulas[abilityID].APScale )
  print("AUE_Static.Functions_Abilities:NoteAbilityDmg(abilityID ", abilityID, " SP Scale", AthenesDB.Formulas[abilityID].SPScale )

end
