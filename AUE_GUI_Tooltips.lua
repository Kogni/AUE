local AUE_Static = _G.AUE_Static
local GUI_Tooltips = {}
AUE_Static.GUI_Tooltips = GUI_Tooltips

function AUE_Static.GUI_Tooltips.UpdateTooltip(comparison)
  --print("function AUELocal.GUI_Tooltips.UpdateTooltip")
  if comparison == nil then
    print("AUE_Static.GUI_Tooltips.UpdateTooltip comparison=nil, aborting")
    return
  end
  if comparison.Printed == true then
    return
  end

  if ( AUE_LR.DPSEnabled[UnitName("player")] == 1 ) and ( AUE_LR.HealEnabled[UnitName("player")] == 1 ) then
    comparison.Tooltip:AddDoubleLine("Stat diff:", "DPS | Heal", 1, 1, 1);
  elseif ( AUE_LR.HealEnabled[UnitName("player")] == 1 ) then
    comparison.Tooltip:AddDoubleLine("Stat diff:", "Heal", 1, 1, 1);
  elseif ( AUE_LR.DPSEnabled[UnitName("player")] == 1 ) then
    --print("AUE_Static.GUI_Tooltips.UpdateTooltip DPS")
    comparison.Tooltip:AddDoubleLine("Stat diff:", "DPS", 1, 1, 1);
    --comparison.ComparedScenario
    printContents(comparison, comparison, 5, "comparison")
    comparison.Printed = true
  end
  --print( "AUE_Static.GUI_Tooltips.UpdateTooltip GameTooltip=", GameTooltip)
  GameTooltip:Show()
  --printContents(GameTooltip, comparison, 10, "comparison")
end

function printContents(A, comparison, count, parent)
  --print("printContents ", parent, A)
  count = count - 1
  if count < 0 then
    return
  end
  if ( A == comparison.Tooltip) then
    return
  end
  for Var, Content in pairs( A ) do
    --print("printContents ", parent.."."..Var, Content)
    --if ( Content ~= 0 ) and ( Content ~= 0.001 ) and ( Content ~= -0.001 ) then
    if (type(Content) == "table") then
      comparison.Tooltip:AddDoubleLine(parent.."."..Var, Content, 1, 1, 1);
      --print("printContents C",parent.."."..Var, Content)
      local found = string.find(Var, "ItemDiff")
      --print( "AUE_Static.GUI_Tooltips.UpdateTooltip found=", found)
      if( found == nil )then
        return
      end
      printContents(Content, comparison, count, parent.."."..Var)
    else
      comparison.Tooltip:AddDoubleLine(parent.."."..Var, Content, 1, 1, 1);
    end
    --end
  end
end
