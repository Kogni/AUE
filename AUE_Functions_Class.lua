local AUE_Static = _G.AUE_Static
local Functions_Class = {};
_G.AUE_Static.Functions_Class = Functions_Class

function AUE_Static.Functions_Class:CanUse1(scenario)
  --print("AUE_Static.Functions_Class:CanUse1 started ", ItemLink)
  if scenario.ItemLink == nil then
    print("AUE_Static.Functions_Class:CanUse1 scenario.ItemLink is nil")
    return
  end
  --print("AUE_Static.Functions_Class:CanUse1 continues ", ItemLink)
  if IsEquippableItem(scenario.ItemLink) ~= nil then

    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(scenario.ItemLink)
    scenario.SlotName = _G[itemEquipLoc]

    --"Miscellaneous" - includes Spellstones and Firestones
    --"Cloth"
    --"Leather"
    --"Mail"
    --"Plate"
    --"Shields"
    --"Librams"
    --"Idols"
    --"Totems"

    --"Bows"
    --"Crossbows"
    --"Daggers"
    --"Guns"
    --"Fishing Poles" (used to be "Fishing Pole" before 2.3)
    --"Fist Weapons"
    --"Miscellaneous"
    --"One-Handed Axes"
    --"One-Handed Maces"
    --"One-Handed Swords"
    --"Polearms"
    --"Staves"
    --"Thrown"
    --"Two-Handed Axes"
    --"Two-Handed Maces"
    --"Two-Handed Swords"
    --"Wands"

    if ( UnitClass("player") == "Druid" ) then
      if ( scenario.ItemSubType == "Mail" ) or ( scenario.ItemSubType == "Plate" ) or ( scenario.ItemSubType == "Shields" ) or ( scenario.ItemSubType == "Librams" ) or ( scenario.ItemSubType == "Totems" ) or ( scenario.ItemSubType == "Sigils" ) then
        return false
      end
      if ( scenario.ItemSubType == "Axe") or ( scenario.ItemSubType == "Sword") or ( scenario.ItemSubType == "Bows") or ( scenario.ItemSubType == "Polearms" ) or ( scenario.ItemSubType == "Two-Handed Axes")  or ( scenario.ItemSubType == "Two-Handed Swords" ) or ( scenario.ItemSubType == "Crossbows" ) or ( scenario.ItemSubType == "Guns" ) or ( scenario.ItemSubType == "Thrown" ) or ( scenario.ItemSubType == "Wands" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Rogue" ) then
      if ( scenario.ItemSubType == "Mail" ) or ( scenario.ItemSubType == "Plate" ) or ( scenario.ItemSubType == "Shields" ) or ( scenario.ItemSubType == "Librams" ) or ( scenario.ItemSubType == "Totems" ) or ( scenario.ItemSubType == "Sigils" ) then
        return false
      end
      if ( scenario.ItemSubType == "Two-Handed Maces") or ( scenario.ItemSubType == "Sigils") or ( scenario.ItemSubType == "Idols") or ( scenario.ItemSubType == "Staves") or ( scenario.ItemSubType == "Bows") or ( scenario.ItemSubType == "Polearms" ) or ( scenario.ItemSubType == "Two-Handed Axes")  or ( scenario.ItemSubType == "Two-Handed Swords" ) or ( scenario.ItemSubType == "Crossbows" ) or ( scenario.ItemSubType == "Guns" ) or ( scenario.ItemSubType == "Wands" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Paladin" ) then
      if ( scenario.ItemSubType == "Idols" ) or ( scenario.ItemSubType == "Totems" ) or ( scenario.ItemSubType == "Sigils" ) then
        return false
      end
      if ( scenario.ItemSubType == "Daggers" ) or ( scenario.ItemSubType == "Bows" ) or ( scenario.ItemSubType == "Crossbows" ) or ( scenario.ItemSubType == "Staves" ) or ( scenario.ItemSubType == "Fist Weapons" ) or ( scenario.ItemSubType == "Guns" ) or ( scenario.ItemSubType == "Thrown" ) or ( scenario.ItemSubType == "Wands" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Shaman" ) then
      if ( scenario.ItemSubType == "Idols" ) or ( scenario.ItemSubType == "Librams" ) or ( scenario.ItemSubType == "Plate" ) or ( scenario.ItemSubType == "Sigils" ) then
        return false
      end
      if ( scenario.ItemSubType == "Two-Handed Swords" ) or ( scenario.ItemSubType == "Polearms" ) or ( scenario.ItemSubType == "Bows" ) or ( scenario.ItemSubType == "One-Handed Swords" )or ( scenario.ItemSubType == "Crossbows" ) or ( scenario.ItemSubType == "Staves" ) or ( scenario.ItemSubType == "Guns" ) or ( scenario.ItemSubType == "Thrown" ) or ( scenario.ItemSubType == "Wands" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Mage" ) then
      if ( scenario.ItemSubType == "Idols" ) or ( scenario.ItemSubType == "Librams" ) or ( scenario.ItemSubType == "Totems" ) or ( scenario.ItemSubType == "Plate" ) or ( scenario.ItemSubType == "Sigils" ) or ( scenario.ItemSubType == "Shields" ) or ( scenario.ItemSubType == "Mail" ) or ( scenario.ItemSubType == "Leather" ) then
        return false
      end
      if ( scenario.ItemSubType == "Two-Handed Axes" ) or ( scenario.ItemSubType == "Two-Handed Swords" ) or ( scenario.ItemSubType == "Polearms" ) or ( scenario.ItemSubType == "Bows" ) or ( scenario.ItemSubType == "Crossbows" ) or ( scenario.ItemSubType == "Guns" ) or ( scenario.ItemSubType == "Thrown" ) or ( scenario.ItemSubType == "One-Handed Maces" ) or ( scenario.ItemSubType == "One-Handed Axes" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Priest" ) then
      if ( scenario.ItemSubType == "Idols" ) or ( scenario.ItemSubType == "Librams" ) or ( scenario.ItemSubType == "Totems" ) or ( scenario.ItemSubType == "Plate" ) or ( scenario.ItemSubType == "Sigils" ) or ( scenario.ItemSubType == "Shields" ) or ( scenario.ItemSubType == "Mail" ) or ( scenario.ItemSubType == "Leather" ) then
        return false
      end
      if ( scenario.ItemSubType == "Fist Weapons" ) or ( scenario.ItemSubType == "Two-Handed Swords" ) or ( scenario.ItemSubType == "Polearms" ) or ( scenario.ItemSubType == "Bows" ) or ( scenario.ItemSubType == "One-Handed Swords" )or ( scenario.ItemSubType == "Crossbows" ) or ( scenario.ItemSubType == "Guns" ) or ( scenario.ItemSubType == "Thrown" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Death Knight" ) then
      if ( scenario.ItemSubType == "Idols" ) or ( scenario.ItemSubType == "Librams" ) or ( scenario.ItemSubType == "Shields" ) or ( scenario.ItemSubType == "Totems" ) then
        return false
      end
      if ( scenario.ItemSubType == "Daggers" ) or ( scenario.ItemSubType == "Bows" ) or ( scenario.ItemSubType == "Crossbows" ) or ( scenario.ItemSubType == "Guns" ) or ( scenario.ItemSubType == "Thrown" ) or ( scenario.ItemSubType == "Fist Weapons" ) or ( scenario.ItemSubType == "Wands" ) then
        return false
      end
    end
    return true
  else
    return false
  end

end

function AUE_Static.Functions_Class:CanUse2( ItemLink )
  --print("AUE_Static.Functions_Class:CanUse2 ", ItemLink)
  if ItemLink == nil then
    print("AUE_Static.Functions_Class:CanUse2 ItemLink is nil")
    return
  end
  --print("AUE_Static.Functions_Class:CanUse2 continues", ItemLink)
  if ( IsEquippableItem(ItemLink) ~= nil ) then

    local SlotName = _G[AUE_Static.Functions_Item:GetEquipLoc( ItemLink )]

    --"Miscellaneous" - includes Spellstones and Firestones
    --"Cloth"
    --"Leather"
    --"Mail"
    --"Plate"
    --"Shields"
    --"Librams"
    --"Idols"
    --"Totems"

    --"Bows"
    --"Crossbows"
    --"Daggers"
    --"Guns"
    --"Fishing Poles" (used to be "Fishing Pole" before 2.3)
    --"Fist Weapons"
    --"Miscellaneous"
    --"One-Handed Axes"
    --"One-Handed Maces"
    --"One-Handed Swords"
    --"Polearms"
    --"Staves"
    --"Thrown"
    --"Two-Handed Axes"
    --"Two-Handed Maces"
    --"Two-Handed Swords"
    --"Wands"

    if ( AUE_Static.Functions_Item:GetNameFromLink( ItemLink ) == nil ) or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == nil ) then
      local Successful = AUE_Static.Functions_Item:SaveItemInfo( ItemLink , "AUE_Static.Functions_Class:CanUse 1654" )
      if ( Successful == true ) then
        return AUE_Static.Functions_Item:CanUse( ItemLink )
      else
        return nil
      end
    end
    if strfind( AUE_Static.Functions_Item:GetNameFromLink( ItemLink ), "QA Combat" ) then
      return false
    elseif strfind( AUE_Static.Functions_Item:GetNameFromLink( ItemLink ), "QA PVP" ) then
      return false
    elseif strfind( AUE_Static.Functions_Item:GetNameFromLink( ItemLink ), "QA Test" ) then
      return false
    elseif strfind( AUE_Static.Functions_Item:GetNameFromLink( ItemLink ), "Rough Approximation" ) then
      return false
    end

    if ( UnitClass("player") == "Hunter" ) then
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Plate" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Shields" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Librams" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Totems" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Idols")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Maces")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Maces" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Wands" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" ) then
        return false
      end
      if ( SlotName == "INVTYPE_CLOAK" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Cloth" ) then
        return false
      end
    end
    --Cloth
    --Leather
    --Mail
    --Plate

    --Shields
    --Relic
    --Miscellaneous (trinkets)

    --One-Handed Axes
    --Two-Handed Axes
    --One-Handed Maces
    --Two-Handed Maces
    --One-Handed Swords
    --Two-Handed Swords
    --Daggers
    --Wands
    --Polearms
    --Staves
    if ( UnitClass("player") == "Druid" ) then
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Mail" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Plate" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Shields" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Librams" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Totems" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Axe")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Swords")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Polearms" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Axes")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Swords" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Wands" ) then
        return false
      end

      if ( SlotName == "INVTYPE_CLOAK" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Cloth" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Rogue" ) then
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Mail" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Plate" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Shields" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Librams" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Totems" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Maces")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Idols")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Staves")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Polearms" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Axes")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Swords" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Wands" ) then
        return false
      end

      if ( SlotName == "INVTYPE_CLOAK" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Cloth" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Paladin" ) then

      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Idols" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Totems" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Mail" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Leather" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Daggers" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Staves" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Fist Weapons" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Wands" ) then
        return false
      end
      if ( SlotName == "INVTYPE_CLOAK" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Cloth" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Shaman" ) then
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Idols" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Librams" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Plate" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Swords" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Polearms" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Swords" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Staves" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Wands" ) then
        return false
      end
      if ( SlotName == "INVTYPE_CLOAK" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Cloth" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Mage" ) then
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Idols" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Librams" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Totems" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Plate" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Shields" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Mail" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Leather" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Axes" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Swords" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Polearms" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Maces" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Axes" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Priest" ) then

      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Cloth" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Leather" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Mail" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Plate" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Shields" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Relic" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Miscellaneous" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Axes" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Axes" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Maces" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Maces" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Swords" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Swords" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Daggers" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Wands" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Polearms" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Staves" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" ) then
        return false
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Fist Weapons" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" ) then
      end

    end
    if ( UnitClass("player") == "Warlock" ) then
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Idols" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Librams" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Totems" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Plate" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Sigils" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Shields" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Mail" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Leather" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Maces")
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Axes" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Fist Weapons" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Two-Handed Swords" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Polearms" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "One-Handed Maces" ) then
        return false
      end
    end
    if ( UnitClass("player") == "Death Knight" ) then
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Idols" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Librams" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Shields" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Totems" ) then
        return false
      end
      if ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Daggers" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Bows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Crossbows" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Guns" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Thrown" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Fist Weapons" )
        or ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Wands" ) then
        return false
      end
      if ( SlotName == "INVTYPE_CLOAK" ) then
      elseif ( AUE_Static.Functions_Item:GetSubtype( ItemLink ) == "Cloth" ) then
        return false
      end
    end
    return true
  else

    return false
  end

end

function AUE_Static.Functions_Class:ConvertToCombatStats(StatsSet)
  --print("AUE_Static.Functions_Class.ConvertToCombatStats started")

  if ( StatsSet == nil) then
    print("AUE_Static.Functions_Class.ConvertToCombatStats StatsSet=nil")
    return StatsSet
  end

  if class == "Paladin" then
    StatsSet.Wpn_Main = StatsSet.Wpn_Main * 1.3
    StatsSet.Mastery = StatsSet.Mastery * 1.05
  end
  if class == "Warlock" then
    StatsSet.Crit = StatsSet.Crit + (StatsSet.Intellect / IntPerCrit * RatingPerSpellCrit)
    StatsSet.Mana = StatsSet.Mana + (StatsSet.Intellect * 15)

    nameTalent, icon, tier, column, currRank, maxRank= GetTalentInfo(2,20);
    StatsSet.SP = StatsSet.SP + (currRank * 0.04 * ( ( StatsSet.Stamina * (1/3) ) + ( StatsSet.Intellect * (1/3) ) ) )

  end

  StatsSet.Strength = 0 --for å unngå dobbelt opp
  StatsSet.Agility = 0 --for å unngå dobbelt opp
  StatsSet.Intellect = 0 --for å unngå dobbelt opp
  StatsSet.Spirit = 0 --for å unngå dobbelt opp
  StatsSet.Stamina = 0 --for å unngå dobbelt opp

  return StatsSet
end

function AUE_Static.Functions_Class:ApplyStatTalents(scenario)
  --print("AUE_Static.Functions_Class:ApplyStatTalents started")
  CritBonus = 0.5
  if ( scenario.StatsSet == nil) then
    print("AUE_Static.Functions_Class:ApplyStatTalents StatsSet==nil")
    return scenario
  end
  if class == "Paladin" then
    scenario.StatsSet.Versatility = scenario.StatsSet.Versatility + (_G.RatingPerVersatility * 3)
  end
  if class == "Warlock" then

  --nameTalent, icon, tier, column, currRank, maxRank= GetTalentInfo(1,2);
  --StatsSet.Hit = StatsSet.Hit + (currRank*RatingPerSpellHit)

  end
  return scenario

end

print("AUE_Functions_Class loaded")
