--TESTING
--_G.AUE_Static = {}
--function GetItemInfo()
--  return "ItemName", "ItemLink", "itemRarity", "ilevel", "itemMinLevel", "itemType", "itemSubType", "itemStackCount", "itemEquipLoc", "itemTexture"
--end

--AUELR_ItemDB = {}
--AUELR_ItemDB.ItemInfo = {}
-----
--
local AUE_Static = _G.AUE_Static
local Functions_Item = {};
_G.AUE_Static.Functions_Item = Functions_Item

function AUE_Static.Functions_Item:ReadLines_scenario(scenario)
  print("AUE_Static.Functions_Item:ReadLines ", tooltip)
  if scenario.Tooltip == nil then
    print("AUE_Static.Functions_Item:ReadLines scenario.Tooltip is nil, aborting")
    return scenario
  end
  if scenario.Equippeditem_1 == nil then
    print("AUE_Static.Functions_Item:ReadLines scenario.Equippeditem_1 is nil, aborting")
    return scenario
  end
  if( scenario.ReadLines == true) then
    print("AUE_Static.Functions_Item:ReadLines already read lines, aborting")
    return scenario
  end
  --print("AUE_Static.Functions:ReadLines ", scenario.ItemLink)
  --print("AUE_Static.Functions_Item:ReadLines continues", tooltip)
  --local Equipped_ItemLink = GetInventoryItemLink("player", 16)
  --local ItemName, link = tooltip:GetItem();
  --print("AUE_Static.Functions_Item:ReadLines AUELR_ItemDB.ItemInfo=", AUELR_ItemDB.ItemInfo)
  if (scenario.ItemName == nil ) then
    scenario.ItemName, scenario.ItemLink, scenario.itemRarity, scenario.ilevel, scenario.itemMinLevel, scenario.itemType, scenario.itemSubType, scenario.itemStackCount, scenario.itemEquipLoc, scenario.itemTexture = GetItemInfo( scenario.Equippeditem_1 );
  end
  --print("AUE_Static.Functions_Item:ReadLines ItemInfo=", AUELR_ItemDB.ItemInfo[ AUE_Static.Functions_Item:GetItemString_scenario( Equipped_ItemLink  )..":"..scenario.ItemName ])
  if ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ]== nil)then
    AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ] = {}
  end
  if ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].Functions_Item== nil)then
    AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].Functions_Item = {}
  end
  scenario.ItemStatArray = AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].Functions_Item
  --print("AUE_Static.Functions_Item:ReadLines ItemStatArray=", ItemStatArray)

  for i=1,scenario.Tooltip:NumLines() do
    scenario = AUE_Static.Functions_Item:CheckLine_scenario(scenario, i)
  end
  scenario.ReadLines = true
  return scenario
end

function AUE_Static.Functions_Item:CheckLine_scenario(scenario, i)
  local Left = getglobal(scenario.Tooltip:GetName().."TextLeft" .. i)
  local Right = getglobal(scenario.Tooltip:GetName().."TextRight" .. i)
  local NotEnchant = Left:GetTextColor()
  NotEnchant = ceil(NotEnchant)
  local Color_Red_Left, Color_Blue_Left, Color_Green_Left = Left:GetTextColor()
  local TextLeft = Left:GetText()
  Color_Red_Left = (floor(Color_Red_Left*100))/100
  Color_Blue_Left = (floor(Color_Blue_Left*100))/100
  Color_Green_Left = (floor(Color_Green_Left*100))/100
  local Color_Red_Right, Color_Blue_Right, Color_Green_Right = Right:GetTextColor()
  local TextRight = Right:GetText()
  Color_Red_Right = (floor(Color_Red_Right*100))/100
  Color_Blue_Right = (floor(Color_Blue_Right*100))/100
  Color_Green_Right = (floor(Color_Green_Right*100))/100

  --ItemName is nil
  --local ItemName = AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].Name

  if ( scenario.ItemStatArray == nil ) then
    print("AUE_Static.Functions_Item:ReadLines scenario.ItemStatArray=nil, aborting")
    return scenario
  end
  scenario =AUE_Static.Functions_Item:GetItemStatArray2_scenario(scenario)
  return scenario
end

function AUE_Static.Functions_Item:GetItemStatArray2_scenario(scenario)
  local ItemStatArray2 = AUE_Static.Functions_Item:GetUsable_scenario(scenario)
  if ( ItemStatArray2 == nil ) then
    print("AUE_Static.Functions_Item:ReadLines ItemStatArray2=nil, aborting, aborting")
    return scenario
  else
    scenario.ItemStatArray = ItemStatArray2
  end
  scenario = AUE_Static.Functions_Item:GetItemStatArray3_scenario(scenario)
  return scenario
end

function AUE_Static.Functions_Item:GetItemStatArray3_scenario(scenario)
  local ItemStatArray3 = AUE_Static.Functions_Item:GetUnique_scenario(scenario)
  if ( ItemStatArray3 == nil ) then
    print("AUE_Static.Functions_Item:ReadLines ItemStatArray3=nil, aborting")
    return scenario
  else
    scenario.ItemStatArray = ItemStatArray3
  end

  if ( strfind(TextLeft, "Set: ") ) then
    if ( strsub( TextLeft, 0, (string.len("(2) Set: ")) ) == "(2) Set: " ) then
    elseif ( strsub( TextLeft, 0, (string.len("(4) Set: ")) ) == "(4) Set: " ) then
    elseif ( strsub( TextLeft, 0, (string.len("Set: ")) ) == "Set: " ) then
      local FoundBonus = false
      if ( _G.Classfile ) and ( _G.Classfile.Setbonuses ~= nil ) then
        for Bonusname, Bonusinfo in pairs( _G.Classfile.Setbonuses ) do
          if ( type(Bonusinfo) == "table" ) then
            if ( Bonusname ~= nil ) and ( Bonusinfo ~= nil ) and ( "Set: "..Bonusinfo.Text == TextLeft ) then
              Bonusinfo.Enabled = true
              FoundBonus = true
            end
          end
        end
      end
    end
  else
    local startPos, endPos, firstWord, restOfString = string.find( TextLeft, " Strength");
    if strmatch(TextLeft, "(%d+) Armor") then
      local value = strmatch(TextLeft, "(%d+) Armor");
      scenario.ItemStatArray = AUE_Static.Functions_Item:AddStat( scenario, "Armor", value, "Evaluate 757" );
    elseif strmatch(TextLeft, "Socket Bonus") then
    elseif strmatch(TextLeft, "Set: ") then
    elseif strmatch(TextLeft, "Equip: Restores") then
      local value, stat = strmatch(TextLeft, "Equip:%s%a+ (%d+) (mana per 5) sec.");
      if stat then
        scenario.ItemStatArray = AUE_Static.Functions_Item:AddStat( scenario, stat, value, "Evaluate 763" );
      end
    elseif strmatch(TextLeft, "Use") then
      scenario = AUE_Static.Functions_Item:Use_scenario(scenario, TextLeft)
      --EQUIP:
    elseif strmatch(TextLeft, "Equip") then
      -- inkluderer:
      -- Increases AP by x
      -- Increases exp rate by x
      -- increases spell power by x

      --stat, value = AUE_Static.Functions_Item:FinnEquipProcc( TextLeft, Itemname, ItemLink, Item_String );
      if ( value ~= nil ) and ( value > 0 ) then --adder stats fra proccs
        scenario = AUE_Static.Functions_Item:AddStat( scenario, stat, value, "Evaluate 1016");
      end
    elseif strmatch(TextLeft, "Chance on hit:") then
      local IndexStart, IndexEnd = string.find(TextLeft, "Chance on hit: ")
      if ( IndexEnd ) then
        local stat = string.sub(TextLeft, IndexEnd )
        local value = 0
        if ( stat == " Steals 2138 to 2362 life from target enemy." ) then
          stat = "bonusdps"
          value = ((2138+2362)/2)/10 --avg 10 sec mellom hver procc
        elseif ( stat == " Steals 2412 to 2664 life from target enemy." ) then
          stat = "bonusdps"
          value = ((2412+2664)/2)/13 --avg 10 sec mellom hver procc
        elseif ( stat == " Steals 100 to 180 life from target enemy." ) then
          stat = "bonusdps"
          value = ((100+180)/2)*0.15
        elseif ( stat == " Blasts up to 3 targets for 150 to 250 Nature damage. Each target after the first takes less damage." ) then
          stat = "bonusdps"
          value = (((250*3)+(50*3))/2)*0.1
        else
          stat, value = strmatch(TextLeft, "Chance on hit:%s%a+ (.*) by (%d+).");
          value = tonumber(value)
        end
        if ( value ~= nil ) and ( value > 0 ) then
          scenario = AUE_Static.Functions_Item:AddStat(scenario, stat, value, "Evaluate 1040");
        end
      end
    elseif strmatch(TextLeft, "Damage") then
      scenario = AUE_Static.Functions_Item:GetDmg_HitsDmgAvg(scenario, TextLeft)
      -- GRÅ TEKST:
    elseif (Color_Red_Left == 0.5) and (Color_Blue_Left == 0.5) and (Color_Green_Left == 0.5) then --grå tekst
      local Socket = strmatch( TextLeft, "Socket" );
      if ( Socket ~= nil ) then
        if ( TextLeft == "Meta Socket" ) then
          scenario = AUE_Static.Functions_Item:AddStat( scenario, "Socket", 1, "Evaluate 1113");
        elseif ( strlen(TextLeft) <= strlen("Prismatic Socket") ) then
          scenario = AUE_Static.Functions_Item:AddStat( scenario, "Socket", 1, "Evaluate 1115");

        else
          print( "AUE evaluate item 1249 - socket not recognized:", TextLeft )
        end
      end
    elseif (Color_Red_Left < 1) and ( string.sub(TextLeft, 0, 1 ) ~= "+" ) and ( string.find(TextLeft, "Increases attack power by 1 in Cat, Bear, Dire Bear, and Moonkin forms only.") ) then
      -- inkluderer:
      -- Increases AP by X in cat form
      -- item name
      local LengthWholeMIN = strlen("Increases attack power by 1 in Cat, Bear, Dire Bear, and Moonkin forms only.")
      if ( strlen(TextLeft) >= LengthWholeMIN ) then
        local text2 = string.sub(TextLeft, (strlen("Increases attack power by ")+1) )
        local IndexEnd = string.find(text2, " in Cat, Bear, Dire Bear, and Moonkin forms only.")
        local stat = "CatAP"
        local value = string.sub(text2, 0, IndexEnd )
        if ( stat ~= nil ) and ( value ~= nil ) then
          scenario = AUE_Static.Functions_Item:AddStat(scenario, stat, value, "Evaluate 1134");
        else
          print("AUEC ERROR: Evaluate 1232", stat, value)
        end
      end
      --GRØNN TEKST
      --elseif  (Color_Green_Left > 0.9) then
      --ItemStatArray = AUE_Static.Functions_Item:AddStat( ItemStatArray, stat, value, "Evaluate 1148" );
      --HVIT TEKST
    elseif NotEnchant == 1 then
    else --enchants
      local value, stat = strmatch(TextLeft, "([-+]%d+) (.*)");
      if stat then
      end
    end
    if ( TextRight ~= nil ) and strmatch(TextRight, "Speed") then
      local startPos, endPos, firstWord, restOfString = string.find( TextRight, "Speed ");
      local Speed = string.sub(TextRight, endPos, (endPos+4) )
      Speed = tonumber(Speed)
      local stat = "speed"
      if ( Speed ~= nil ) and ( type(Speed) == "number" ) then
        scenario = AUE_Static.Functions_Item:AddStat(scenario, stat, Speed, "Evaluate 1163");
      end
    elseif ( TextRight ~= nil ) then
    end
  end
  return scenario
end

function AUE_Static.Functions_Item:Use_scenario(scenario, TextLeft)
  print("AUE_Static.Functions_Item:Use ", scenario.ItemLink)

  local IndexStart, IndexEnd = string.find(TextLeft, "Use: ")
  if ( IndexEnd ) then
    local stat = string.sub(TextLeft, IndexEnd )
    local value = 0
    if ( stat == " Each time you cast a helpful spell, you gain 66 spell power.  Stacks up to 8 times.  Entire effect lasts 20 sec. (2 Min Cooldown)" ) then
      stat = "spellpower"
      value = (66*8*20)/120
    elseif ( stat == " Increases spell power by 599 for 20 sec. (2 Min Cooldown)" ) then
      stat = "spellpower"
      value = (599*20)/120
    elseif ( stat == " Increases attack power by 856 for 20 sec. (2 Min Cooldown)" ) then
      stat = "attackpower"
      value = (856*20)/120
    elseif ( stat == " Increases spell power by 346 for 20 sec. (2 Min Cooldown)" ) then
      stat = "spellpower"
      value = (346*20)/120
    elseif ( stat == " Increases spell power by 149 for 20 sec. (2 Min Cooldown)" ) then
      stat = "spellpower"
      value = (149*20)/120
    elseif ( stat == " Increases spell power by 84 for 15 sec. (1 Min 30 Sec Cooldown)" ) then
      stat = "spellpower"
      value = (84*15)/90
    elseif ( stat == " Each time you cast a harmful spell, you gain 57 haste rating.  Stacks up to 8 times.  Entire effect lasts 20 sec. (2 Min Cooldown)" ) then
      stat = "hasterating"
      value = (57*8*20)/120
    elseif ( stat == " Each time you strike an enemy, you gain 215 attack power.  Stacks up to 5 times.  Entire effect lasts 20 sec. (2 Min Cooldown)" ) then
      stat = "attackpower"
      value = (215*5*20)/120
    elseif ( stat == " Increases spell power by 408 for 20 sec. (2 Min Cooldown)" ) then
      stat = "spellpower"
      value = (408*20)/120
    elseif ( stat == " Each spell cast within 20 seconds will grant a stacking bonus of 60 mana regen per 5 sec. Expires after 20 seconds.  Abilities with no mana cost will not trigger this trinket. (2 Min Cooldown)" ) then
      stat = "manaper5"
      value = (60/120) *5
    elseif ( stat == " Increases attack power by 304 for 20 sec. (2 Min Cooldown)" ) then
      stat = "attackpower"
      value = 304*20/120
    elseif ( stat == " Absorbs 1500 damage for 6 sec.  When the shield is removed by any means, you regain 1500 mana. (5 Min Cooldown)" ) then
      stat = "manaper5"
      value = (1500/(5*60)) *5
    elseif ( stat == " Each time you cast a helpful spell, you gain 74 spell power.  Stacks up to 8 times.  Entire effect lasts 20 sec. (2 Min Cooldown)" ) then
      stat = "spellpower"
      value = (74*8*20)/2/120
    elseif ( stat == " Restores 2340 mana over 12 sec. (5 Min Cooldown)" ) then
      stat = "manaper5"
      value = (2340/(5*60)) *5
    elseif ( stat == " Increases your Spirit by 336 for 20 sec. (2 Min Cooldown)" ) then
      stat = "spirit"
      value = 336*20/120
    elseif ( stat == " Increases attack power by 670 for 20 sec. (2 Min Cooldown)" ) then
      stat = "attackpower"
      value = 670*20/120
    elseif ( stat == " Grants 464 haste rating for 20 sec. (2 Min Cooldown)" ) then
      stat = "hasterating"
      value = 464*20/120
    elseif ( stat == " Increases attack power by 280 for 20 sec. (1 Min 30 Sec Cooldown)" ) then
      stat = "attackpower"
      value = 280*20/90
    elseif ( stat == " Increases your haste rating by 140 for 20 sec. (2 Min Cooldown)" ) then
      stat = "hasterating"
      value = 140*20/120
    elseif ( TextLeft == "Use: Grants 6420 mana, but consumes all applications of Inner Eye and prevents Inner Eye from being triggered for 30 sec. (2 Min Cooldown)" ) then
      stat = "manaper5"
      value = ((6420/(2*60)) *5)
      scenario = AUE_Static.Functions_Item:AddStat( AUELR_ItemDB.ItemInfo[ AUE_Static.Functions_Item:GetItemString_scenario(scenario )..":"..scenario.ItemName ].Functions_Item, stat, value, "Evaluate 830");
      stat = "spirit"
      value = -(103*5*30)*(30/120)
    elseif ( TextLeft == "Use: Grants 7260 mana, but consumes all applications of Inner Eye and prevents Inner Eye from being triggered for 30 sec. (2 Min Cooldown)" ) then
      stat = "manaper5"
      value = ((7260/(2*60)) *5)
      scenario = AUE_Static.Functions_Item:AddStat( AUELR_ItemDB.ItemInfo[ AUE_Static.Functions_Item:GetItemString_scenario(scenario )..":"..scenario.ItemName ].Functions_Item, stat, value, "Evaluate 836");
      stat = "spirit"
      value = -(103*5*30)*(30/120)
    elseif ( TextLeft == "Use: Consume 5 stacks of Raw Fury to forge into the form of a Blackwing Dragonkin, granting 1926 Strength for 20 sec. (2 Min Cooldown)" ) then
      stat = "strength"
      value = 1926*20/120
    elseif ( TextLeft == "Use: Places Egg Shell on your current target, absorbing 4590 damage.  While Egg Shell persists, you will gain 475 mana every 5 sec.  When the effect is cancelled, you gain 5700 mana.  Lasts 30 sec. (2 Min Cooldown)" ) then
      stat = "manaper5"
      value = (475*(30/(2*60)))+(5700/(2*60))
    elseif ( TextLeft == "Use: Places Egg Shell on your current target, absorbing 4060 damage.  While Egg Shell persists, you will gain 420 mana every 5 sec.  When the effect is cancelled, you gain 5040 mana.  Lasts 30 sec. (2 Min Cooldown)" ) then
      stat = "manaper5"
      value = (420*(30/(2*60)))+(5040/(2*60))
    elseif ( TextLeft == "Use: Consumes all applications of Heart's Revelation, increasing your haste rating by 321 per application consumed.  Lasts 20 sec. (2 Min Cooldown)" ) then
      stat = "hasterating"
      value = (321*5*20)/(2*60)
    elseif ( TextLeft == "Use: Consumes all applications of Heart's Revelation, increasing your haste rating by 363 per application consumed.  Lasts 20 sec. (2 Min Cooldown)" ) then
      stat = "hasterating"
      value = (363*5*20)/(2*60)
    elseif ( TextLeft == "Use: Absorbs 6400 damage.  Lasts 10 sec. (2 Min Cooldown)" ) then
      return scenario
    elseif ( TextLeft == "Use: The next opponent you kill within 10 sec that yields experience or honor will restore 900 mana. (2 Min Cooldown)" ) then
      stat = "manaper5"
      value = ((900/(2*60)) *5)
    elseif ( TextLeft == "Use: Each time you are struck by an attack, you gain 1265 armor.  Stacks up to 5 times.  Entire effect lasts 20 sec. (2 Min Cooldown)" ) then
      stat = "armor"
      value = (1265*5*20)/120
    elseif ( TextLeft == "Use: Releases all mana stored within the doll, causing you to gain that much mana, and all enemies within 15 yards take 1 point of Arcane damage for each point of mana released. (1 Min Cooldown)" ) then
      stat = "manaper5"
      value = ((4200/60) *5)
    elseif ( TextLeft == "Use: Reduces the cost of your next spell cast within 10 sec by up to 215 mana. (3 Min Cooldown)" ) then
      stat = "manaper5"
      value = ((215/(60*3)) *5)
    elseif ( TextLeft == "Use: Your next 10 spells cast within 20 sec will reduce the cost of your holy and nature spells by 110, stacking up to 10 times. (2 Min Cooldown)" ) then
      return scenario
    elseif ( TextLeft == "Use: Absorbs 440 damage.  Lasts 20 sec. (2 Min Cooldown)" ) then
      return scenario
    elseif ( TextLeft == "Use: Absorbs 20% of incoming damage, up to 56980.  After the effect ends, you take 8% of the damage absorbed every 2 sec for 10 sec.  Lasts 30 sec. (2 Min Cooldown)" ) then
      return scenario
    elseif ( TextLeft == "Use: Your next 10 spells cast within 20 sec will reduce the cost of your holy and nature spells by 125, stacking up to 10 times. (2 Min Cooldown)" ) then
      stat = "manaper5"
      value = (((125*10)/(60*2)) *5)
    elseif ( strmatch(TextLeft, " Channels 75 health into mana every 1 sec for 10 sec. (5 Min Cooldown) ") ~= nil ) or ( strmatch(TextLeft, "chance") ~= nil ) then
      stat = "manaper5"
      value = (((75*10)/(60*5)) *5)
    elseif ( TextLeft == "Use: Grants 8,871 dodge for 10 sec. (1 Min Cooldown)" ) then
      return scenario
    elseif ( strmatch(TextLeft, "Chance") ~= nil ) or ( strmatch(TextLeft, "chance") ~= nil ) then
      print( "AUE evaluate item unknown item use:", TextLeft, ItemLink, Item_String )
    elseif ( strmatch(TextLeft, "Lasts") ~= nil ) or ( strmatch(TextLeft, "lasts") ~= nil ) then
      print( "AUE evaluate item unknown item use:", TextLeft, ItemLink, Item_String )
    elseif ( strmatch(TextLeft, "Grant") ~= nil ) or ( strmatch(TextLeft, "grant") ~= nil ) then
      print( "AUE evaluate item unknown item use:", TextLeft, ItemLink, Item_String )
    elseif ( strmatch(TextLeft, "Spells") ~= nil ) or ( strmatch(TextLeft, "spells") ~= nil ) then
      print( "AUE evaluate item unknown item use:", TextLeft, ItemLink, Item_String )
    elseif ( strmatch(TextLeft, "Mana") ~= nil ) or ( strmatch(TextLeft, "mana") ~= nil ) then
      print( "AUE evaluate item unknown item use:", TextLeft, ItemLink, Item_String )
    else
      local OnUse = stat
      --Increases your X rating by Y for Z sec. (Æ Min Cooldown)
      --Increases your X power by Y for Z sec. (Æ Min Cooldown)
      local Stat = ""
      local Value = 0
      local Duration = 0
      local CD = 0
      local IndexStart, IndexEnd = string.find(OnUse, "Increases your ")
      if ( IndexEnd ) then
        Stat = string.sub(OnUse, (IndexEnd+1) )
        local IndexStart, IndexEnd = string.find(Stat, " by ")
        if ( IndexEnd ) then
          Value = string.sub(Stat, (IndexEnd+1) )
          Stat = string.sub(Stat, 0, (IndexStart-1) )
        end
        local IndexStart, IndexEnd = string.find( Value, " for ")
        if ( IndexEnd ) then
          Duration = string.sub( Value, (IndexEnd+1) )
          Value = string.sub(Value, 0, (IndexStart-1) )
        end
        local IndexStart, IndexEnd = string.find( Duration, " sec. " )
        if ( IndexEnd ) then
          CD = string.sub(Duration, (IndexEnd+1) )
          Duration = string.sub(Duration, 0, (IndexStart-1) )
        end
      elseif ( string.find(OnUse, "Increases ") ) then
        local IndexStart, IndexEnd = string.find(OnUse, "Increases ")
        Stat = string.sub(OnUse, (IndexEnd+1) )
        local IndexStart, IndexEnd = string.find(Stat, " by ")
        if ( IndexEnd ) then
          Value = string.sub(Stat, (IndexEnd+1) )
          Stat = string.sub(Stat, 0, (IndexStart-1) )
        end
        local IndexStart, IndexEnd = string.find( Value, " for ")
        if ( IndexEnd ) then
          Duration = string.sub( Value, (IndexEnd+1) )
          Value = string.sub(Value, 0, (IndexStart-1) )
        end
        local IndexStart, IndexEnd = string.find( Duration, " sec. " )
        if ( IndexEnd ) then
          CD = string.sub(Duration, (IndexEnd+1) )
          Duration = string.sub(Duration, 0, (IndexStart-1) )
        end
      else
        local IndexStart, IndexEnd = string.find(OnUse, "Grants ")
        if ( IndexEnd ) then
          Value = string.sub(OnUse, (IndexEnd+1) )
        end
        local IndexStart, IndexEnd = string.find(Stat, " ")
        if ( IndexEnd ) then
          Stat = string.sub(Value, (IndexEnd+1) )
          Value = string.sub(Value, 0, (IndexStart-1) )
        end
        local IndexStart, IndexEnd = string.find(Stat, " for ")
        if ( IndexEnd ) then
          Duration = string.sub(Stat, (IndexEnd+1) )
          Stat = string.sub(Stat, 0, (IndexStart-1) )
        end
        local IndexStart, IndexEnd = string.find(Duration, "( ")
        if ( IndexEnd ) then
          CD = string.sub(Duration, (IndexEnd+1) )
          Duration = string.sub(Duration, 0, (IndexStart-1) )
        end
      end
      Stat = gsub( Stat, Value, "" )
      Value = gsub( Value, Duration, "" )
      Duration = gsub( Duration, CD, "" )
      Stat = gsub( Stat, " ", "" )
      CD = gsub( CD, "Cooldown", "" )
      CD = string.sub( CD, 2 )
      CD = string.sub( CD, 0, (string.len(CD)-1) )
      for i = 1, 5 do
        if ( CD == i.." Min" ) or ( string.find( CD, i.." Min" ) ) then
          CD = i*60
        elseif ( CD == i.." Min " ) then
          CD = i*60
        elseif ( CD == i.." Min 30 Sec" ) or ( string.find( CD, i.." Min 30 Sec" ) ) then
          CD = i*60
        elseif ( CD == i.." Min 30 Sec " ) then
          CD = i*60
        end
      end
      if ( CD == "hares cooldown with other Battlemaster's trinkets. (3 Min " ) then
        CD = 3*60
      elseif ( CD == "hares cooldown with other Battlemaster's trinkets. (3 Min" ) then
        CD = 3*60
      elseif ( CD == "hares cooldown with other Battlemaster's trinkets. (3 Min" ) then
        CD = 3*60
      elseif ( strmatch( CD, "(3 Min" ) ) or ( string.find( CD, "(3 Min" ) ) then
        CD = 3*60
      elseif ( strmatch( CD, "(2 Min" ) ) or ( string.find( CD, "(2 Min" ) ) then
        CD = 2*60
      elseif ( strmatch( CD, "180" ) ) or ( string.find( CD, "180" ) ) then
        CD = 180
      elseif ( strmatch( CD, "120" ) ) or ( string.find( CD, "120" ) ) then
        CD = 120
      elseif ( strmatch( CD, "60" ) ) or ( string.find( CD, "60" ) ) then
        CD = 60
      elseif ( CD == "very time one of your non-periodic spells deals a critical strike, the bonus is reduced by 184 critical strike rating. (3 Min " ) then
        CD = 999
      elseif ( CD == "" ) then
      else
      --print( "AUEC error evaluate 907: unreocgnized cd:"..CD..ItemLink )
      end

      Value = tonumber(Value)
      Duration = tonumber(Duration)
      CD = tonumber(CD)
      if Stat and Value and Duration and CD then
        stat = Stat
        value = Value*Duration/CD
      end
    end
    if ( value > 0 ) then
      scenario = AUE_Static.Functions_Item:AddStat( AUELR_ItemDB.ItemInfo[ AUE_Static.Functions_Item:GetItemString_scenario(scenario )..":"..scenario.ItemName ].Functions_Item, stat, value, "Evaluate 1005");
    end
  end
  return scenario
end

function AUE_Static.Functions_Item:GetUsable_scenario(scenario)
  print("AUE_Static.Functions_Item:GetUsable", scenario)
  if ( TextLeft == nil ) then

  elseif ( TextLeft == "Soulbound" ) then
    Unused = false
  elseif ( Color_Red_Left == 0.99 ) and ( Color_Green_Left == 0.12 ) then
    local startPos1, _, _, _ = string.find( TextLeft, "Classes:");
    if ( startPos1 ~= nil ) then --item cant be used
      scenario.ItemStatArray.Usable = false
    end
  elseif ( Color_Red_Left == 0.99 ) and ( Color_Green_Left == 0.12 ) then
    local startPos1, _, _, _ = string.find( TextLeft, "Races:");
    if ( startPos1 ~= nil ) then --item cant be used
      scenario.ItemStatArray.Usable = false
    end
  elseif ( Color_Red_Right == 0.99 ) and ( Color_Green_Right == 0.12 ) then
    if ( TextRight ~= nil ) then
      local startPos3, _, _, _ = string.find( TextRight, "Plate");
      if ( startPos3 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
      local startPos3, _, _, _ = string.find( TextRight, "Mail");
      if ( startPos3 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
      local startPos3, _, _, _ = string.find( TextRight, "Leather");
      if ( startPos3 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
      local startPos4, _, _, _ = string.find( TextRight, "Gun");
      if ( startPos4 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
      local startPos4, _, _, _ = string.find( TextRight, "Wand");
      if ( startPos4 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
      local startPos4, _, _, _ = string.find( TextRight, "Off Hand");
      if ( startPos4 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
      local startPos4, _, _, _ = string.find( TextRight, "Fist Weapon");
      if ( startPos4 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
      local startPos4, _, _, _ = string.find( TextRight, "Requires Engineering");
      if ( startPos4 ~= nil ) then --item cant be used
        scenario.ItemStatArray.Usable = false
      end
    end
  elseif ( TextLeft == "Relic" ) and ( Color_Red_Left == 0.99 ) and ( Color_Blue_Left == 0.99 ) and ( Color_Green_Left == 0.99 ) then
    if ( UnitClass("player") ~= "Shaman" ) and ( UnitClass("player") ~= "Paladin" ) and ( UnitClass("player") ~= "Death Knight" ) and ( UnitClass("player") ~= "Druid" ) then
      scenario.ItemStatArray.Usable = false
    end
    local Found = string.find(ItemName, "Totem of")
    if ( Found ) then
      if ( UnitClass("player") ~= "Shaman" ) then
        scenario.ItemStatArray.Usable = false
      end
    end
    local Found = string.find(ItemName, "Libram of")
    if ( Found ) then
      if ( UnitClass("player") ~= "Paladin" ) then
        scenario.ItemStatArray.Usable = false
      end
    end
    local Found = string.find(ItemName, "Sigil of")
    if ( Found ) then
      if ( UnitClass("player") ~= "Death Knight" ) then
        scenario.ItemStatArray.Usable = false
      end
    end
    local Found = string.find(ItemName, "Idol of")
    if ( Found ) then
      if ( UnitClass("player") ~= "Druid" ) then
        scenario.ItemStatArray.Usable = false
      end
    end
  elseif ( Color_Red_Left == 0.99 ) and ( Color_Blue_Left == 0.82 ) and ( string.sub( TextLeft, 0, string.len("Drops from ") ) == "Drops from " ) then
    local englishFaction, localizedFaction = UnitFactionGroup("player")
    if ( ( string.find(TextLeft, "Alliance") ) and ( englishFaction ~= "Alliance" ) ) then
      scenario.ItemStatArray.Usable = false
    end
    if ( ( string.find(TextLeft, "Horde") ) and ( englishFaction ~= "Horde") ) then
      scenario.ItemStatArray.Usable = false
    end
  elseif ( string.sub( TextLeft, 0, string.len("Source:") ) == "Source:" ) then
    scenario.ItemStatArray.Dropspots = ItemStatArray.Dropspots..Dropspot..", "
    local englishFaction, localizedFaction = UnitFactionGroup("player")
    if ( ( string.find(TextLeft, "Alliance") ) and ( englishFaction ~= "Alliance" ) ) then
      scenario.ItemStatArray.Usable = false
    end
    if ( ( string.find(TextLeft, "Horde") ) and ( englishFaction ~= "Horde") ) then
      scenario.ItemStatArray.Usable = false
    end
  end

  if ( scenario.ItemStatArray == nil ) then
    print("AUE_Static.Functions:GetUsable ItemStatArray=nil, aborting")
    return scenario
  end

  return scenario
end

function AUE_Static.Functions_Item:GetDmg_HitsDmgAvg(scenario, TextLeft)
  --print("AUE_Static.Functions:GetDmg ", scenario.ItemLink)
  -- inkluderer:
  -- wpn dmg

  while ( TextLeft ~= nil ) and ( strmatch(TextLeft, ",") ) do
    local startPos, endPos, firstWord, restOfString = string.find( TextLeft, ",");
    local Temp = string.sub( TextLeft, 0, (startPos-1) )..string.sub( TextLeft, (endPos+1), strlen(TextLeft) )
    TextLeft = Temp
  end
  if ( TextLeft == nil ) then
    print("AUE_Static.Functions:GetDmg No left text scenario.ItemStatArray, aborting", scenario.ItemStatArray)
    return scenario
  end

  if (strmatch(TextLeft, "Max Damage")) then
  elseif (strmatch(TextLeft, "Spell Damage")) then
  elseif (strmatch(TextLeft, "Critical Damage")) then
  elseif (strmatch(TextLeft, "Weapon Damage")) then
  elseif (strmatch(TextLeft, "Frost Damage")) then
  elseif (strmatch(TextLeft, "Shadow Damage")) then
  elseif (strmatch(TextLeft, "Fire Damage")) then
  elseif (strmatch(TextLeft, "Arcane Damage")) then
  elseif (strmatch(TextLeft, "Holy Damage")) then
  elseif (strmatch(TextLeft, "Nature Damage")) then
  elseif (strmatch(TextLeft, "Sharpened")) then
    scenario = AUE_Static.Functions_Item:AddStat(scenario, "Damage", 6, "Evaluate 1066");
  elseif (strmatch(TextLeft, "Scope (+")) then
    local startPos, endPos, firstWord, restOfString = string.find( TextLeft, "Scope (+");
    local startPos2, endPos2, firstWord2, restOfString2 = string.find( TextLeft, " Damage)");
    local Dmg = string.sub(TextLeft, endPos, startPos2)
    --print( "AUEC evalute 1191 scope dmg:", Dmg )
    Dmg = tonumber(Dmg)
    if ( Dmg ~= nil ) and ( type(Dmg) == "number" ) then
      local value = Dmg
      scenario = AUE_Static.Functions_Item:AddStat(scenario, "Damage", value, "Evaluate 1075");
    end
  elseif (strmatch(TextLeft, "Scope (+1 Damage)")) then
    scenario = AUE_Static.Functions_Item:AddStat(scenario, "Damage", 1, "Evaluate 1078");
  elseif (strmatch(TextLeft, "Scope (+2 Damage)")) then
    scenario = AUE_Static.Functions_Item:AddStat(scenario, "Damage", 2, "Evaluate 1080");
  elseif (strmatch(TextLeft, "Scope (+10 Damage)")) then
    scenario = AUE_Static.Functions_Item:AddStat(scenario, "Damage", 10, "Evaluate 1082");
  elseif (strmatch(TextLeft, "Scope (+15 Damage)")) then
    scenario = AUE_Static.Functions_Item:AddStat(scenario, "Damage", 15, "Evaluate 1084");
  else
    --print("AUE_Static.Functions:GetDmg Else ItemStatArray", ItemStatArray)
    local startPos, endPos, firstWord, restOfString = string.find( TextLeft, " - ");
    local MinDmg = string.sub(TextLeft, 0, startPos)
    MinDmg = tonumber(MinDmg)
    local MaxDmg = strmatch(TextLeft, "(%d+) Damage");
    MaxDmg = tonumber(MaxDmg)
    if ( MaxDmg ~= nil ) and ( type(MinDmg) == "number" ) then
      local value = (MinDmg+MaxDmg)/2
      scenario = AUE_Static.Functions_Item:AddStat( scenario, "Damage", value, "Evaluate 1093");
    else
      --print("AUE_Static.Functions:GetDmg Else-Else ItemStatArray", ItemStatArray)
      local Foundit = false
      for i = 1, 15 do
        if (strmatch(TextLeft, "Scope (+"..i.." Damage)")) then
          value = i
          scenario = AUE_Static.Functions_Item:AddStat(scenario, "Damage", i, "Evaluate 1099");
        end
      end
      if ( Foundit == false ) then
        print("AUEC error evaluate 2025: Dmg type not recognized:",TextLeft,"Please report this error")
      end
    end
  end
  return scenario
end

function AUE_Static.Functions_Item:GetUnique_scenario(scenario)
  print("AUE_Static.Functions_Item:GetUnique ", scenario)
  if ( TextLeft == "Unique-Equipped" ) then
    if ( _G.PreviousItem ~= nil ) then
      local found, _, Item_String = string.find(_G.PreviousItem, "^|c%x+|H(.+)|h%[.*%]")
      Item_String = string.sub(Item_String, 6, 10)
      if ( IsEquippedItem(Item_String) ) then
        scenario.ItemStatArray.Unique = true
      end
    end
  elseif ( TextLeft == "Unique" ) then
    if ( _G.PreviousItem ~= nil ) then
      local found, _, Item_String = string.find(_G.PreviousItem, "^|c%x+|H(.+)|h%[.*%]")
      Item_String = string.sub(Item_String, 6, 10)
      if ( IsEquippedItem(Item_String) ) then
        scenario.ItemStatArray.Unique = true
      end
    end
  end
  print("AUE_Static.Functions_Item:GetUnique scenario=", scenario)
  return scenario
end

function AUE_Static.Functions_Item:AddStat( scenario, stat, value, source )
  print("AUE_Static.Functions_Item:AddStat ", ItemStatArray)
  if ( stat == nil ) or ( value == nil ) then
    return scenario
  end
  --scenario.ItemStatArray
  if ( scenario.ItemStatArray == nil ) then
    print("AUE_Static.Functions_Item:AddStat scenario.ItemStatArray=nil, aborting")
    return scenario
  end
  --print("AUE_Static.Functions_Item:AddStat continues")
  --videre gjenkjenning av stats skjer i function AUE_Static.Functions_Item:StartLeting( Streng, value, Slot ) linje 371
  stat = strlower(stat) -- make lowercase
  stat = gsub(stat, "|r", ""); -- remove formatting
  stat = gsub(stat, " ", ""); -- remove spaces
  value = tonumber(value);
  --print("AUE_Static.Functions_Item:AddStat", scenario.ItemLink, "stat=", stat, " value=", value)

  if scenario.ItemStatArray[stat] == nil then
    scenario.ItemStatArray[stat] = value;
  else
    scenario.ItemStatArray[stat] = scenario.ItemStatArray[stat] + value;
  end
  return scenario;
end

function AUE_Static.Functions_Item:GetItemString_scenario( scenario  )
  print("AUE_Static.Functions_Item:GetItem_String ", scenario)
  if ( scenario.ItemLink == nil ) then
    print("AUE_Static.Functions_Item:GetItem_String scenario.ItemLink == nil, aborting")
    return scenario
  end

  scenario.color, scenario.Item_String, scenario.enchantId, scenario.jewelId1, scenario.jewelId2, scenario.jewelId3, scenario.jewelId4, scenario.suffixId, scenario.uniqueId, scenario.ItemLink, scenario.reforgeId = strsplit(":", scenario.ItemLink)

  if ( scenario.Item_String == nil ) then
    print("AUE_Static.Functions_Item:GetItem_String scenario.Item_String == nil , aborting")
    return scenario
  end

  return scenario
end

function AUE_Static.Functions_Item:GetSubtype( scenario  )
  print("AUE_Static.Functions_Item:GetSubtype ", scenario)
  if ( scenario.ItemLink  == nil ) then
    return scenario
  end
  --local ItemName, ItemLink, itemRarity, ilevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemLink);
  if ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ] == nil ) then
    return "ERROR @ AUE_Static.Functions_Item:GetSubtype 1681: no saved info for item"
  end
  return AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].Subtype
end

function AUE_Static.Functions_Item:GetEquipLoc( scenario  )
  print("AUE_Static.Functions_Item:GetEquipLoc ", scenario)
  if ( scenario.ItemLink  == nil ) then
    return scenario
  end

  if ( AUELR_ItemDB == nil ) then
    return scenario
  end
  if ( AUELR_ItemDB.ItemInfo == nil ) then
    return scenario
  end
  --local ItemName, ItemLink, itemRarity, ilevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(ItemLink);
  if ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ] == nil ) then
    return scenario
  end
  return AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].EquipLoc
end

function AUE_Static.Functions_Item:GetNameFromLink( scenario )

  if ( AUELR_ItemDB.Itemnames ) then
    return AUELR_ItemDB.Itemnames[ scenario.ItemLink ]
  else
    return scenario
  end
end

function AUE_Static.Functions_Item:StartLeting( Streng, value, scenario )
  print("AUE_Static.Functions_Item:StartLeting ", Streng, value, scenario)
  if ( scenario == nil ) then
    print("AUE_Static.Functions_Item:StartLeting scenario=nil, aborting")
    return scenario
  end
  if Streng ~= nil then

    AUE_Static.Functions_Item:LetEtterStat_scenario("damage", Streng, value, scenario)
    AUE_Static.Functions_Item:LetEtterStat_scenario("speed", Streng, value, scenario)
    AUE_Static.Functions_Item:LetEtterStat_scenario("armor", Streng, value, scenario)
    AUE_Static.Functions_Item:LetEtterStat_scenario("stamina", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("intellect", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("spirit", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("yourcriticalstrikerating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("criticalstrikerating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("criticalstrike", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("yourcriticalstrike", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("crit_rating", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("yourhasterating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("hasterating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("haste", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("yourhaste", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("yourhitrating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("hitrating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("hit", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("yourhit", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("yourexpertiserating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("expertiserating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("expertise", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("yourexpertise", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("strength", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("agility", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("attackpower", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("yourmasteryrating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("masteryrating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("yourmastery", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("mastery", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("parry", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("parryrating", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("dodge", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("dodgerating", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("block", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("blockrating", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("yourarmorpenetrationrating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("armorpenetrationrating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("armorpenetration", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("yourarmorpenetration", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("multistrikerating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("multistrike", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("multi-strike", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("allstats", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("spellpower", Streng, value, scenario )

    AUE_Static.Functions_Item:LetEtterStat_scenario("manaper5", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("manaevery5seconds", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("socket", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("catap", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("bonusdps", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("bonushealing", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("yourresiliencerating", Streng, value, scenario )
    AUE_Static.Functions_Item:LetEtterStat_scenario("resilience", Streng, value, scenario )
  end
  return scenario
end

function AUE_Static.Functions_Item:LetEtterStat_scenario( Soekestat, Streng, value, scenario )
  print("AUE_Static.Functions_Item:LetEtterStat ", Soekestat, Streng, value, scenario)
  if ( scenario == nil ) then
    print("AUE_Static.Functions_Item:LetEtterStat scenario=nil, aborting")
    return scenario
  end
  if ( scenario.StatSet_Base == nil ) then
    print("AUE_Static.Functions_Item:LetEtterStat scenario.StatSet_Base=nil, aborting")
    return scenario
  end

  if ( strmatch( Streng, Soekestat ) ~= nil ) then
    if ( strlen(Streng) > strlen(Soekestat) ) then
      if ( Soekestat ~= "armor" ) then
        local Streng2 = string.sub(Streng, (strlen(Soekestat)+4) )
        if ( strlen(Streng) <= 50 ) then
          local value2, stat2 = strmatch(Streng2, "([-+]%d+)(.*)"); --(.*)="rest of string"
          if ( value2 == nil ) then
          else
            value2 = string.sub(value2, 2 )
            AUE_Static.Functions_Item:StartLeting( stat2, value2, scenario )
          end
        else

        end
      end
    end

    while ( value ~= nil ) and ( strmatch(value, ",") ) do
      local startPos, endPos, firstWord, restOfString = string.find( value, ",");
      local Temp = string.sub( value, 0, (startPos-1) )..string.sub( value, (endPos+1), strlen(value) )
      value = Temp
    end

    if ( Soekestat == "intellect" ) then
      scenario.StatSet_Base.Intellect = scenario.StatSet_Base.Intellect + value
    elseif ( Soekestat == "spellpower" ) then
      scenario.StatSet_Base.SP = scenario.StatSet_Base.SP + value
    elseif ( Soekestat == "spellpower" ) then
      scenario.StatSet_Base.SP = scenario.StatSet_Base.SP + value
    elseif ( Soekestat == "manaper5" ) then
      scenario.StatSet_Base.MP5 = scenario.StatSet_Base.MP5 + value
    elseif ( Soekestat == "manaevery5seconds" ) then
      scenario.StatSet_Base.MP5 = scenario.StatSet_Base.MP5 + value
    elseif ( Soekestat == "spirit" ) then
      scenario.StatSet_Base.Spirit = scenario.StatSet_Base.Spirit + value

    elseif ( Soekestat == "yourhasterating" ) then
      scenario.StatSet_Base.Haste = scenario.StatSet_Base.Haste + value
    elseif ( Soekestat == "hasterating" ) then
      scenario.StatSet_Base.Haste = scenario.StatSet_Base.Haste + value
    elseif ( Soekestat == "haste" ) then
      scenario.StatSet_Base.Haste = scenario.StatSet_Base.Haste + value
    elseif ( Soekestat == "yourhaste" ) then
      scenario.StatSet_Base.Haste = scenario.StatSet_Base.Haste + value

    elseif ( Soekestat == "multistrikerating" ) then
      scenario.StatSet_Base.Multistrike = scenario.StatSet_Base.Multistrike + value
    elseif ( Soekestat == "multistrike" ) then
      scenario.StatSet_Base.Multistrike = scenario.StatSet_Base.Multistrike + value
    elseif ( Soekestat == "multi-strike" ) then
      scenario.StatSet_Base.Multistrike = scenario.StatSet_Base.Multistrike + value

    elseif ( Soekestat == "yourcriticalstrikerating" ) then
      scenario.StatSet_Base.Crit = scenario.StatSet_Base.Crit + value
    elseif ( Soekestat == "criticalstrikerating" ) then
      scenario.StatSet_Base.Crit = scenario.StatSet_Base.Crit + value
    elseif ( Soekestat == "criticalstrike" ) then
      scenario.StatSet_Base.Crit = scenario.StatSet_Base.Crit + value
    elseif ( Soekestat == "yourcriticalstrike" ) then
      scenario.StatSet_Base.Crit = scenario.StatSet_Base.Crit + value
    elseif ( Soekestat == "crit_rating" ) then
      scenario.StatSet_Base.Crit = scenario.StatSet_Base.Crit + value

    elseif ( Soekestat == "hitrating" ) then
      scenario.StatSet_Base.Hit = scenario.StatSet_Base.Hit + value
    elseif ( Soekestat == "yourhitrating" ) then
      scenario.StatSet_Base.Hit = scenario.StatSet_Base.Hit + value
    elseif ( Soekestat == "hit" ) then
      scenario.StatSet_Base.Hit = scenario.StatSet_Base.Hit + value
    elseif ( Soekestat == "yourhit" ) then
      scenario.StatSet_Base.Hit = scenario.StatSet_Base.Hit + value

    elseif ( Soekestat == "yourexpertiserating" ) then
      scenario.StatSet_Base.Exprate = scenario.StatSet_Base.Exprate + value
    elseif ( Soekestat == "expertiserating" ) then
      scenario.StatSet_Base.Exprate = scenario.StatSet_Base.Exprate + value
    elseif ( Soekestat == "expertise" ) then
      scenario.StatSet_Base.Exprate = scenario.StatSet_Base.Exprate + value
    elseif ( Soekestat == "yourexpertise" ) then
      scenario.StatSet_Base.Exprate = scenario.StatSet_Base.Exprate + value

    elseif ( Soekestat == "yourmasteryrating" ) then
      scenario.StatSet_Base.Masteryrating = scenario.StatSet_Base.Masteryrating + value
    elseif ( Soekestat == "masteryrating" ) then
      scenario.StatSet_Base.Masteryrating = scenario.StatSet_Base.Masteryrating + value
    elseif ( Soekestat == "yourmastery" ) then
      scenario.StatSet_Base.Masteryrating = scenario.StatSet_Base.Masteryrating + value
    elseif ( Soekestat == "mastery" ) then
      scenario.StatSet_Base.Masteryrating = scenario.StatSet_Base.Masteryrating + value

    elseif ( Soekestat == "dodge" ) then
      scenario.StatSet_Base.Dodgerating = scenario.StatSet_Base.Dodgerating + value
    elseif ( Soekestat == "dodgerating" ) then
      scenario.StatSet_Base.Dodgerating = scenario.StatSet_Base.Dodgerating + value

    elseif ( Soekestat == "parry" ) then
      scenario.StatSet_Base.Parryrating = scenario.StatSet_Base.Parryrating + value
    elseif ( Soekestat == "parryrating" ) then
      scenario.StatSet_Base.Parryrating = scenario.StatSet_Base.Parryrating + value

    elseif ( Soekestat == "block" ) then
      scenario.StatSet_Base.Blockrating = scenario.StatSet_Base.Blockrating + value
    elseif ( Soekestat == "blockrating" ) then
      scenario.StatSet_Base.Blockrating = scenario.StatSet_Base.Blockrating + value

    elseif ( Soekestat == "strength" ) then
      scenario.StatSet_Base.Strength = scenario.StatSet_Base.Strength + value
    elseif ( Soekestat == "agility" ) then
      scenario.StatSet_Base.Agility = scenario.StatSet_Base.Agility + value
    elseif ( Soekestat == "attackpower" ) then
      scenario.StatSet_Base.AP = scenario.StatSet_Base.AP + value
    elseif ( Soekestat == "stamina" ) then
      scenario.StatSet_Base.Stamina = scenario.StatSet_Base.Stamina + value
    elseif ( Soekestat == "damage" ) then
      if ( _G.LastComparedType == "INVTYPE_RANGEDRIGHT" ) or ( _G.LastComparedType == "INVTYPE_RANGED" ) or ( _G.LastComparedType == "INVTYPE_THROWN" ) then
        scenario.StatSet_Base.Wpn_Ranged = scenario.StatSet_Base.Wpn_Ranged + value
      else
        if ( Slot == 0 ) then
          scenario.StatSet_Base.Wpn_Main = scenario.StatSet_Base.Wpn_Main + value
        else
          scenario.StatSet_Base.Wpn_Off = scenario.StatSet_Base.Wpn_Off + value
        end
      end
    elseif ( Soekestat == "speed" ) then
      if ( _G.LastComparedType == "INVTYPE_RANGEDRIGHT" ) or ( _G.LastComparedType == "INVTYPE_RANGED" ) or ( _G.LastComparedType == "INVTYPE_THROWN" ) then
        scenario.StatSet_Base.Wpn_Ranged_Speed = scenario.StatSet_Base.Wpn_Ranged_Speed + value
      else
        if ( Slot == 0 ) then
          scenario.StatSet_Base.Wpn_Main_Speed = scenario.StatSet_Base.Wpn_Main_Speed + value
        else
          scenario.StatSet_Base.Wpn_Off_Speed = scenario.StatSet_Base.Wpn_Off_Speed + value
        end
      end
    elseif ( Soekestat == "yourarmorpenetrationrating" ) then
      scenario.StatSet_Base.ARP = scenario.StatSet_Base.ARP + value
    elseif ( Soekestat == "armorpenetrationrating" ) then
      scenario.StatSet_Base.ARP = scenario.StatSet_Base.ARP + value
    elseif ( Soekestat == "armorpenetration" ) then
      scenario.StatSet_Base.ARP = scenario.StatSet_Base.ARP + value

    elseif ( Soekestat == "armor" ) then
      scenario.StatSet_Base.Armor = scenario.StatSet_Base.Armor + value
    elseif ( Soekestat == "catap" ) then
      scenario.StatSet_Base.AP = scenario.StatSet_Base.AP + value
    elseif ( Soekestat == "allstats" ) then
      scenario.StatSet_Base.Intellect = scenario.StatSet_Base.Intellect + value
      scenario.StatSet_Base.Spirit = scenario.StatSet_Base.Spirit + value
      scenario.StatSet_Base.Strength = scenario.StatSet_Base.Strength + value
      scenario.StatSet_Base.Agility = scenario.StatSet_Base.Agility + value
      scenario.StatSet_Base.Stamina = scenario.StatSet_Base.Stamina + value
    elseif ( Soekestat == "socket" ) then
      scenario.StatSet_Base.Socket = scenario.StatSet_Base.Socket + value
    elseif ( Soekestat == "bonusdps" ) then
      scenario.StatSet_Base.Bonusdps = scenario.StatSet_Base.Bonusdps + value
    elseif ( Soekestat == "bonushealing" ) then
      scenario.StatSet_Base.Bonushealing = scenario.StatSet_Base.Bonushealing + value
    elseif ( Soekestat == "yourresiliencerating" ) then
      scenario.StatSet_Base.Resilience = scenario.StatSet_Base.Resilience + value
    elseif ( Soekestat == "yourresilience" ) then
      scenario.StatSet_Base.Resilience = scenario.StatSet_Base.Resilience + value

    else
    end
  end
  return scenario
end

function AUE_Static.Functions_Item:CalculateStatSet_scenario( scenario ) --slot bestemmer bl.a offhand\mainhand slot
  print("AUE_Static.Functions_Item:CalculateStatSet ", scenario.ItemLink)

  scenario.StatSet_Base = AUE_Static.Functions:MakeNewStatSet()
  if ( scenario.ItemLink == nil ) then
    print("AUE_Static.Functions_Item:CalculateStatSet scenario.ItemLink=nil, aborting")
    return scenario
  end
  scenario = AUE_Static.Functions_Item:CalculateStatSet2_scenario( scenario )
  return scenario

end

function AUE_Static.Functions_Item:CalculateStatSet2_scenario( scenario )
  scenario = AUE_Static.Functions_Item:GetItemString_scenario( scenario )
  if not ( scenario.Item_String ) then
    print("AUE_Static.Functions_Item:CalculateStatSet scenario.Item_String=nil, aborting")
    return scenario
  end
  if ( scenario.ItemName == nil ) then
    scenario.ItemName, scenario.ItemLink, scenario.itemRarity, scenario.ilevel, scenario.itemMinLevel, scenario.itemType, scenario.itemSubType, scenario.itemStackCount, scenario.itemEquipLoc, scenario.itemTexture = GetItemInfo( scenario.ItemLink )
  end
  if ( scenario.ItemLink == nil ) then
    print("AUE_Static.Functions_Item:CalculateStatSet scenario.ItemLink=nil, aborting")
    return scenario
  end
  --scenario = AUE_Static.Functions_Item:GetItemString_scenario( scenario )
  --print("AUE_Static.Functions_Item:CalculateStatSet AUELR_ItemDB.ItemInfo=", AUELR_ItemDB.ItemInfo)
  --print("AUE_Static.Functions_Item:CalculateStatSet lookup=", scenario.Item_String..":"..scenario.ItemName)
  --print("AUE_Static.Functions_Item:CalculateStatSet itemlookup=", AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ])
  if ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ] == nil ) then
    AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ] = {}
  end
  scenario.ItemStats = AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStats

  if ( scenario.ItemStats ) then
    if ( scenario.ItemStats ~= nil ) then
      for stat, value in pairs (scenario.ItemStats ) do
        if stat ~= nil then
          scenario.StatSet_Base = AUE_Static.Functions_Item:StartLeting( stat, value, scenario )
        end
      end
    end
  end

  if AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ] and ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper == nil ) then
    AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper = {}
  end
  if ( scenario.Slot == nil )then
    scenario.Slot = 1
  end

  if ( scenario.Slot == nil ) then
    print( "AUE_Static.Functions_Item:CalculateStatSet a1: ingen slot", ItemLink, Source, scenario.Slot )
  elseif not ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ] ) then
    print( "AUE_Static.Functions_Item:CalculateStatSet a", AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ], ItemLink, Source, scenario.Slot )
  elseif not ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper ) then
    print( "AUE_Static.Functions_Item:CalculateStatSet b", AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper, ItemLink, Source, scenario.Slot )
  elseif not ( AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper[scenario.Slot] ) then
    if ( scenario.Slot > -1 ) and ( scenario.Slot < 2 ) then
      AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper[scenario.Slot] = scenario.StatSet_Base.Stats
    else
      print( "AUE_Static.Functions_Item:CalculateStatSet c", AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper[scenario.Slot], ItemLink, Source, scenario.Slot )
    end
  else
    AUELR_ItemDB.ItemInfo[ scenario.Item_String..":"..scenario.ItemName ].ItemStatsProper[scenario.Slot] = scenario.StatSet_Base.Stats
  end
end

--TESTING
--scenario = {}
--scenario.Tooltip = {}
--function scenario.Tooltip:NumLines()
--  return 10
--end
--function scenario.Tooltip:GetName()
--  return "itemname"
--end
--scenario.Equippeditem_1 = {}
--scenario.StatSet_Base = {}
--scenario.Item_String = ""
--scenario.ItemStatArray = {}

--TextLeft = ""

--AUE_Static.Functions_Item:ReadLines_scenario(scenario)
--AUE_Static.Functions_Item:CalculateStatSet_scenario( scenario )
--AUE_Static.Functions_Item:GetUnique_scenario(scenario)
--AUE_Static.Functions_Item:GetUsable_scenario(scenario)
--AUE_Static.Functions_Item:Use_scenario(scenario, TextLeft)
--AUE_Static.Functions_Item:GetDmg_HitsDmgAvg(scenario, TextLeft)
--AUE_Static.Functions_Item:LetEtterStat_scenario( Soekestat, Streng, value, scenario )
print("")
