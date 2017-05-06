local ver = "0.02"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Blitzcrank" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Blitzcrank/master/Blitzcrank.lua', SCRIPT_PATH .. 'Blitzcrank.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Blitzcrank/master/Blitzcrank.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local BlitzcrankMenu = Menu("Blitzcrank", "Blitzcrank")

BlitzcrankMenu:SubMenu("Combo", "Combo")

BlitzcrankMenu.Combo:Boolean("Q", "Use Q in combo", true)
BlitzcrankMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
BlitzcrankMenu.Combo:Boolean("W", "Use W in combo", true)
BlitzcrankMenu.Combo:Boolean("E", "Use E in combo", true)
BlitzcrankMenu.Combo:Boolean("R", "Use R in combo", true)
BlitzcrankMenu.Combo:Slider("RX", "Enemies Around to Cast R",3,1,5,1)
BlitzcrankMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
BlitzcrankMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
BlitzcrankMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
BlitzcrankMenu.Combo:Boolean("RHydra", "Use RHydra", true)
BlitzcrankMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
BlitzcrankMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
BlitzcrankMenu.Combo:Boolean("Randuins", "Use Randuins", true)


BlitzcrankMenu:SubMenu("AutoMode", "AutoMode")
BlitzcrankMenu.AutoMode:Boolean("Level", "Auto level spells", false)
BlitzcrankMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
BlitzcrankMenu.AutoMode:Boolean("Q", "Auto Q", false)
BlitzcrankMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
BlitzcrankMenu.AutoMode:Boolean("W", "Auto W", false)
BlitzcrankMenu.AutoMode:Boolean("E", "Auto E", false)
BlitzcrankMenu.AutoMode:Boolean("R", "Auto R", false)

BlitzcrankMenu:SubMenu("LaneClear", "LaneClear")
BlitzcrankMenu.LaneClear:Boolean("Q", "Use Q", true)
BlitzcrankMenu.LaneClear:Boolean("W", "Use W", true)
BlitzcrankMenu.LaneClear:Boolean("E", "Use E", true)
BlitzcrankMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
BlitzcrankMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

BlitzcrankMenu:SubMenu("Harass", "Harass")
BlitzcrankMenu.Harass:Boolean("Q", "Use Q", true)
BlitzcrankMenu.Harass:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
BlitzcrankMenu.Harass:Boolean("W", "Use W", true)

BlitzcrankMenu:SubMenu("KillSteal", "KillSteal")
BlitzcrankMenu.KillSteal:Boolean("Q", "KS w Q", true)
BlitzcrankMenu.KillSteal:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
BlitzcrankMenu.KillSteal:Boolean("R", "KS w R", true)


BlitzcrankMenu:SubMenu("AutoIgnite", "AutoIgnite")
BlitzcrankMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

BlitzcrankMenu:SubMenu("Drawings", "Drawings")
BlitzcrankMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

BlitzcrankMenu:SubMenu("SkinChanger", "SkinChanger")
BlitzcrankMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
BlitzcrankMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
	local BlitzcrankQ = {delay = 0.22, range = 925, width = 70, speed = 1750}

	--AUTO LEVEL UP
	if BlitzcrankMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if BlitzcrankMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 925) then
				 local QPred = GetPrediction(target,BlitzcrankQ)
                       if QPred.hitChance > (BlitzcrankMenu.Harass.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end	

            if BlitzcrankMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if BlitzcrankMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if BlitzcrankMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if BlitzcrankMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if BlitzcrankMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

	    if BlitzcrankMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 925) then
                local QPred = GetPrediction(target,BlitzcrankQ)
                       if QPred.hitChance > (BlitzcrankMenu.Combo.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end		
			
            if BlitzcrankMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 900) then
			 CastSpell(_E)
	    end
            
            if BlitzcrankMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if BlitzcrankMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if BlitzcrankMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if BlitzcrankMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 900) then
			CastSpell(_W)
	    end
	    
	    
            if BlitzcrankMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 450) and (EnemiesAround(myHeroPos(), 450) >= BlitzcrankMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 925) and BlitzcrankMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         local QPred = GetPrediction(target,BlitzcrankQ)
                       if QPred.hitChance > (BlitzcrankMenu.KillSteal.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end	

                if IsReady(_E) and ValidTarget(enemy, 900) and BlitzcrankMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if BlitzcrankMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 925) then
	        	CastSkillShot(_Q, target)
                end

                if BlitzcrankMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 900) then
	        	CastSpell(_W)
	        end

                if BlitzcrankMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 900) then
	        	CastSpell(_E)
	        end

                if BlitzcrankMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if BlitzcrankMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if BlitzcrankMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 925) then
		      local QPred = GetPrediction(target,BlitzcrankQ)
                       if QPred.hitChance > (BlitzcrankMenu.AutoMode.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end	
          
        end 
        if BlitzcrankMenu.AutoMode.W:Value() then        
          if Ready(_W)  then
	  	      CastSpell(_W)
          end
        end
        if BlitzcrankMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 900) then
		      CastSpell(_E)
	  end
        end
        if BlitzcrankMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 450) then
		      CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if BlitzcrankMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if BlitzcrankMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 925, 0, 250, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        
        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if BlitzcrankMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Blitzcrank</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





