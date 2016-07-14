--TESTING
--_G.AUE_Static = {}
-----

local AUE_Static = _G.AUE_Static
local Functions_DPS = {};
_G.AUE_Static.Functions_DPS = Functions_DPS

function AUE_Static.Functions_DPS:TriggerDPSCalc_scenario(scenario)
  --print("AUE_Static.Functions_DPS:TriggerDPSCalc_scenario() ", _G.CurrentStats_Combat)
  if ( _G.CurrentStats_Combat == nil ) then
    print("AUE_Static.Functions_DPS:TriggerDPSCalc_scenario() CurrentStats_Combat=nil")
    AUE_Static.Locals.GetStats()
    return scenario
  end
  if ( scenario.Stats_Combat == nil ) then
    print("AUE_Static.Functions_DPS:TriggerDPSCalc_scenario() Stats_Combat=nil")
    return scenario
  end
  if ( _G.AUE_Static.Functions_Class.Abilities == nil ) then
    print("AUE_Static.Functions_DPS:TriggerDPSCalc_scenario() _G.AUE_Static.Functions_Class.Abilities=nil")
    return scenario
  end

  --burst vs bossfights vs mix - avgjøres av rotasjon brukt
  --multitarget vs singletarget vs mix - avgjøres av rotasjon brukt
  --forskjellen slår ut på ability uptime(hits/tid, procc uptime and stack, debuff uptime and stack), dmg per hit (main target vs others)

  --combat buff variations

  --auto-attack
  --spells
  --dots
  --aoe
  --proccs: statistisk sannsynlighet for procc * hits, targets hit, ability dmg, cast time
  --masteries: boost per ability, boost per dmg type

  --beregning per ability
  local Dmg
  DPS=0
  for ID, ability in pairs( _G.AUE_Static.Functions_Class.Abilities ) do
    --hits = opprinnelige_hits på hastable abilities/current haste*compared haste
    AUE_Static.Functions_DPS:GetHits_HitsHits(ability)
    --haste
    --AP/SP:
    AUE_Static.Functions_DPS:GetDmg_HitsDmgAvg(ability)
    --crit
    AUE_Static.Functions_DPS:GetCrits(ability)
    --versatility
    --multistrike
    --mastery

    --DPS
    --DPS = (total((hits*avgDmg) per ability)/time)
    --DPS = (total((ability.Hits.Hits*ability.Hits.DmgAvg) per ability)/time)
    DPS = DPS + (ability.Hits.Hits * ability.Hits.DmgAvg)
    DPS = DPS + AUE_Static.Functions_DPS:CalculateDPS_DPS()
  end

  print("AUE_Static.Functions_DPS:TriggerDPSCalc_scenario() DPS=", DPS)
  scenario.DPS = DPS
  return scenario
end

function AUE_Static.Functions_DPS:GetHits_HitsHits(ability)
  print("AUE_Static.Functions_DPS:GetHits_HitsHits()")
  --get char hit chance
  ability.Hits = {}
  ability.Hits.Hits = 0

  print("AUE_Static.Functions_DPS:GetHits_HitsHits()=", ability.Hits.Hits)
  return ability.Hits.Hits
end

function AUE_Static.Functions_DPS:GetDmg_HitsDmgAvg(ability)
  print("AUE_Static.Functions_DPS:GetDmg_HitsDmgAvg()")
  --get ability base dmg
  --ability.Hits.DmgAvg

  ability.Hits.DmgAvg = ability.Hits.DmgAvg + (TotalCombatStats.AP * ability.Scale_AP)
  ability.Hits.DmgAvg = ability.Hits.DmgAvg + (TotalCombatStats.SP * ability.Scale_SP)

  print("AUE_Static.Functions_DPS:GetDmg_HitsDmgAvg()=", ability.Hits.DmgAvg)
  return ability.Hits.DmgAvg
end

function AUE_Static.Functions_DPS:GetCrits(ability)
  print("AUE_Static.Functions_DPS:GetCrits()")
  --get char crit chance
  --TotalCombatStats.CritPrcnt

  ability.Crits = {}
  --get ability base crit chance
  ability.Crits.Criticals = 0
  --get ability crit dmg
  ability.Crits.CritPrcnt = 0
  --calculate total ability crit chance
  ability.Crits.CritPrcnt = 0

  print("AUE_Static.Functions_DPS:GetCrits() ability.Crits.Criticals=", ability.Crits.Criticals)
end

function AUE_Static.Functions_DPS:CalculateDPS_DPS()
  print("AUE_Static.Functions_DPS:CalculateDPS_DPS()")

  local DPS=0

  if true then
    return DPS
  end

  for i = 0, (getn(Classfile.ability)-1) do
    local Abilitycount = i
    local AktuellAbility = Classfile.ability[Abilitycount+1]
    if ( AktuellAbility ~= nil ) and ( AktuellAbility.Frame ~= nil ) then
      if ( AktuellAbility.Frame.Name ~= nil ) then
        DPS = DPS + (ability.Hits.Hits * ability.Hits.DmgAvg)
        DPS = DPS + (ability.Crits.Criticals * (ability.Crits.CritPrcnt/100)*ability.Hits.DmgAvg)
      end
    end
  end

  print("AUE_Static.Functions_DPS:GetDPS() DPS=", DPS)
  return DPS
end

--TESTING
--_G.CurrentStats_Combat = {}
--_G.AUE_Static.Functions_Class = {}
--_G.AUE_Static.Functions_Class.Abilities = {}
--scenario = {}
--scenario.Stats_Combat = {}
--AUE_Static.Functions_DPS:TriggerDPSCalc_scenario(scenario)
print("")