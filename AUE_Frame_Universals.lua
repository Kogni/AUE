-- Klassen regner ikke ut noe, forandrer ikke noe, sender ikke noe, bare henter og lagrer data.
---Universale/statiske variabler
_G.AUE_Static = {};
local AUE_Static = _G.AUE_Static

if ( AUE_Static.Enabled == nil ) then
  AUE_Static.Enabled = true
end

if ( AUELR_RotationDB == nil ) then
  AUELR_RotationDB = {};
end

if ( AthenesDB == nil ) then
  AthenesDB = {};
  AthenesDB.Enabled = true
end
if ( AthenesDB.Enabled == nil ) then
  AthenesDB.Enabled = true
end
if ( AthenesDB.Formulas == nil ) then
  AthenesDB.Formulas = {};
end


if ( AUELR_ItemDB == nil ) then
  AUELR_ItemDB = {}
end
if ( AUELR_ItemDB.Investigate == nil ) then
  AUELR_ItemDB.Investigate = {}
end
if ( AUELR_ItemDB.ItemInfo == nil ) then
  AUELR_ItemDB.ItemInfo = {}
end
if not  AUELR_ItemDB.Itemnames then
  AUELR_ItemDB.Itemnames = {}
end

if ( not AUE_LR ) then
  AUE_LR = {}
end

_G.HitCap_Universal_Melee_Boss = 7.5
_G.HitCap_Universal_Spell_Boss = 15
_G.ExpCap_Universal_Melee_Boss = 7.5

print("AUE_Universals loaded")
