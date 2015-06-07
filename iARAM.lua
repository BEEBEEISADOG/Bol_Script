--[[
────────────────────────────────────────────────────────────────────────────────────
─██████████─██████████████─████████████████───██████████████─██████──────────██████─
─██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░██████████████░░██─
─████░░████─██░░██████░░██─██░░████████░░██───██░░██████░░██─██░░░░░░░░░░░░░░░░░░██─
───██░░██───██░░██──██░░██─██░░██────██░░██───██░░██──██░░██─██░░██████░░██████░░██─
───██░░██───██░░██████░░██─██░░████████░░██───██░░██████░░██─██░░██──██░░██──██░░██─
───██░░██───██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░██──██░░██──██░░██─
───██░░██───██░░██████░░██─██░░██████░░████───██░░██████░░██─██░░██──██████──██░░██─
───██░░██───██░░██──██░░██─██░░██──██░░██─────██░░██──██░░██─██░░██──────────██░░██─
─████░░████─██░░██──██░░██─██░░██──██░░██████─██░░██──██░░██─██░░██──────────██░░██─
─██░░░░░░██─██░░██──██░░██─██░░██──██░░░░░░██─██░░██──██░░██─██░░██──────────██░░██─
─██████████─██████──██████─██████──██████████─██████──██████─██████──────────██████─
────────────────────────────────────────────────────────────────────────────────────
]]--


--[[
		Credits & Mentions:
			-Barasia
			-One
			-Husky
			-Dekland
]]--

--[[

		──|> Error with stance: low health
		──|> Auto ignite, Auto heal doesn´t test it.
		──|> Auto potion Casts Multiple potions
]]--

--[[ SETTINGS ]]--
local HotKey = 115 --F4 = 115, F6 = 117 default
local AutomaticChat = true --If is in true mode, then it will say "gl and hf" when the game starts.
local AUTOUPDATE = true --change to false to disable auto update


--[[ GLOBALS [Do Not Change] ]]--
local version = "3.0"

--Attack and farm globals
local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
local range = myHero.range
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, range, DAMAGE_PHYSICAL, false)
require 'VPrediction'


--Chat
local switcher = true

--Buyer
local lastSay = 0
local lastCast = 0
local lastCast1 = 0
local lastCast2 = 0
local lastCast3 = 0
local lastCast4 = 0
local lastCast5 = 0
local lastCast6 = 0
local lastCast7 = 0
local lastCast8 = 0
local lastCast9 = 0
local lastCast10 = 0
local lastCast11 = 0
local lastCast12 = 0
local lastCast13 = 0
local lastCast14 = 0
local lastCast15 = 0

--Main Script
local abilitySequence
local qOff, wOff, eOff, rOff = 0,0,0,0
local buyIndex = 1
local shoplist = {}
local buffs = {{pos = { x = 8922, y = 10, z = 7868 },current=0},{pos = { x = 7473, y = 10, z = 6617 },current=0},{pos = { x = 5929, y = 10, z = 5190 },current=0},{pos = { x = 4751, y = 10, z = 3901 },current=0}}
local lastsixpos = {0,0,0,0,0,0,0,0,0,0}

--Autopotions



local _b = false
local ab = true
local db = {br0l4nds = true, corearmies = true}


--Auto ward

local drawWardSpots      = false
local wardSlot           = nil


--!> Ignite
local iReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
local iDmg = (ignite and getDmg("IGNITE", enemy, myHero)) or 0



--[[ Auto Update Globals]]--

local UPDATE_CHANGE_LOG = "Temporal fix for Autobuy and for AutoPotions"
local UPDATE_HOST = "raw.githubusercontent.com"
local UPDATE_PATH = "/Husmeador12/Bol_Script/master/iARAM.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH


function _AutoupdaterMsg(msg) print("<font color=\"#9bbcfe\"><b>i<font color=\"#6699ff\">ARAM:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/Husmeador12/Bol_Script/master/version/iARAM.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				_AutoupdaterMsg("New version available "..ServerVersion)
				_AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () _AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				_AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
				_AutoupdaterMsg("<font color=\"#81BEF7\">Update Notes: </font>".. UPDATE_CHANGE_LOG .."")
			end
		end
	else
		_AutoupdaterMsg("Error downloading version info")
	end
end


--[[ Build and defining Champion Class ]]--
do
	myHero = GetMyHero()
	Target = nil
	spawnpos  = { x = myHero.x, z = myHero.z}
	ranged = 0
	assassins = {"Akali","Diana","Evelynn","Fizz","Katarina","Nidalee"}
	adtanks = {"Braum","DrMundo","Garen","Gnar","Hecarim","Jarvan IV","Nasus","Skarner","Volibear","Yorick"}
	adcs = {"Ashe","Caitlyn","Corki","Draven","Ezreal","Gangplank","Graves","Jinx","Kalista","KogMaw","Lucian","MissFortune","Quinn","Sivir","Thresh","Tristana","Tryndamere","Twitch","Urgot","Varus","Vayne"}
	aptanks = {"Alistar","Amumu","Blitzcrank","Chogath","Leona","Malphite","Maokai","Nautilus","Rammus","Sejuani","Shen","Singed","Zac"}
	mages = {"Ahri","Anivia","Annie","Azir","Bard","Brand","Cassiopeia","Ekko","Galio","Gragas","Heimerdinger","Janna","Karma","Karthus","LeBlanc","Lissandra","Lulu","Lux","Malzahar","Morgana","Nami","Nunu","Orianna","Ryze","Sona","Soraka","Swain","Syndra","Taric","TwistedFate","Veigar","Velkoz","Viktor","Xerath","Ziggs","Zilean","Zyra"}
	hybrids = {"Kayle","Teemo"}
	bruisers = {"Darius","Irelia","Khazix","LeeSin","Olaf","Pantheon","RekSai","Renekton","Rengar","Riven","Shyvana","Talon","Trundle","Vi","MonkeyKing","Zed","Yasuo"}
	fighters = {"Aatrox","Fiora","Jax","Jayce","MasterYi","Nocturne","Poppy","Sion","Udyr","Warwick","XinZhao"}
	apcs = {"Elise","FiddleSticks","Kennen","Mordekaiser","Rumble","Vladimir"}
	
	
	heroType = nil
	
	for i,nam in pairs(adcs) do 
		if nam == myHero.charName then
			heroType = 1
		end
	end
	
	for i,nam in pairs(adtanks) do 
		if nam == myHero.charName then
			heroType = 2
		end
	end
	for i,nam in pairs(aptanks) do 
		if nam == myHero.charName then
			heroType = 3
		end
	end
	for i,nam in pairs(hybrids) do 
		if nam == myHero.charName then
			heroType = 4
		end
	end
	for i,nam in pairs(bruisers) do 
		if nam == myHero.charName then
			heroType = 5
		end
	end
	for i,nam in pairs(assassins) do 
		if nam == myHero.charName then
			heroType = 6
		end
	end
	for i,nam in pairs(mages) do 
		if nam == myHero.charName then
			heroType = 7
		end
	end
	for i,nam in pairs(apcs) do 
		if nam == myHero.charName then
			heroType = 8
		end
	end
	for i,nam in pairs(fighters) do 
		if nam == myHero.charName then
			heroType = 9
		end
	end
	
	if heroType == nil then
		heroType = 10
	end
	if heroType ~= 10 then
	--	_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Items Loaded</font>")
	end
	if heroType == 1 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#00FF00\">ADC</font>" )
	elseif heroType == 2 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF8000\">ADTANK</font>" )
	elseif heroType == 3 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF00FF\">APTANK</font>" )
	elseif heroType == 4 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#A9F5F2\">Hybrid</font>" )	
	elseif heroType == 5 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#8A084B\">BRUISER</font>" )	
	elseif heroType == 6 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FF0000\">ASSASINS</font>" )	
	elseif heroType == 7 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#0040FF\">MAGE</font>" )	
	elseif heroType == 8 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#80FF00\">APC</font>" )	
	elseif heroType == 9 then
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#FFFF00\">FIGHTER</font>")	
	else
		_AutoupdaterMsg("<font color=\"#81BEF7\">Hero Type:</font> <font color=\"#BDBDBD\">UNKOWN</font>" )
	end
	
	if myHero.range > 400 then
		ranged = 1
	end
	
	
	--[[ ItemsList ]]--
	
	if heroType == 1 then --ADC
		shopList = {1038,3072,1038,3031,1038,3139,1038,3508}
	end
	if heroType == 2 then --ADTANK
		shopList = {3083,3155,3156,3068,3211,3102,3075}
	end
	if heroType == 3 then --APTANK
		shopList = {3083,1058,3089,1058,3157,1058,3285,3001}
	end
	if heroType == 4 then --HYBRID
		shopList = {3101,3115,3136,3151,1058,3089,3100}
	end
	if heroType == 5 then --BRUISER
		shopList = {3211,3102,3075,1038,3072,3044,3071}
	end
	if heroType == 6 then --ASSASSIN
		shopList = {3211,3065,3190,3075,3068}
	end
	if heroType == 7 then --MAGE
		shopList = {3165,1058,3089,1058,3157,1058,3285}
	end
	if heroType == 8 then  --APC
		shopList = {3165,1058,3089,1058,3157,1058,3285}
	end
	if heroType == 9 or heroType == 10 then --FIGHTER and OTHERS
		shopList = {3211,3065,3190,3075,3068}
	end
	startTime = GetTickCount()
	--[[
	if heroType == 1 then
		shopList = {3006,1042,3086,3087,3144,3153,1038,3181,1037,3035,3026,0}
	end
	if heroType == 2 then
		shopList = {3047,1011,3134,3068,3024,3025,3071,3082,3143,3005,0}
	end
	if heroType == 3 then
		shopList = {3111,1031,3068,1057,3116,1026,3001,3082,3110,3102,0}
	end
	if heroType == 4 then
		shopList = {1001,3108,3115,3020,1026,3136,3089,1043,3091,3151,3116}
	end
	if heroType == 5 then
		shopList = {3111,3134,1038,3181,3155,3071,1053,3077,3074,3156,3190}
	end
	if heroType == 6 then
		shopList = {3020,3057,3100,1026,3089,3136,3151,1058,3157,3135,0}
	end
	if heroType == 7 then 
		shopList = {3028,1001,3020,3136,1058,3089,3174,3151,1026,3001,3135,0}
	end
	if heroType == 8 then 
		shopList = {3145,3020,3152,1026,3116,1058,3089,1026,3001,3157}
	end
	if heroType == 9 or heroType == 10 then 
		shopList = {3111,3044,3086,3078,3144,3153,3067,3065,3134,3071,3156,0}
	end
	--yellow ward 3340
	--item ids can be found at many websites, ie: http://www.lolking.net/items/1004
	]]--
end

--[[ Checks Function ]]--
function Checks()

--|> Ignite Slot
	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then
                    Ignite.slot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then
                    Ignite.slot = SUMMONER_2
    end
     
    Ignite.ready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
	
	--|> Healh Slot
	if SUMMONER_1 == 4 then
		HL_slot = SUMMONER_1
	elseif SUMMONER_2 == 4 then
		HL_slot = SUMMONER_2
	end
	
	--|> Barrier Slot
	if SUMMONER_1 == 5 then
		BR_slot = SUMMONER_1	
	elseif SUMMONER_2 == 5 then
		BR_slot = SUMMONER_2
	end
	
end

--[[ On Draw Function ]]--
function OnDraw()
	AirText()
	RangeCircles()
	--Autoward
	AutoWarderDraw()
	DebugCursorPos()
	

end

--[[ On Load Function ]]--
 function OnLoad()
		
		OnProcessSpell()
		timeToShoot()
		heroCanMove()
		Menu()
		LevelSequence()
		OnWndMsg()
		if AutomaticChat then
			AutoChat()
		end
	
		AutoWard()
	
		
		--Autopotions
		LoadTables()
		LoadVariables()

		
end

--[[ On Unload Function ]]--
function OnUnload()
	print ("<font color=\"#9bbcfe\"><b>i<font color=\"#6699ff\">ARAM:</b></font> <font color=\"#FFFFFF\">disabled.</font>")
end

--[[ OnTick Function ]]--
function OnTick()

	AutoIgnite()
	AutotatackChamp()
	AutoFarm()
	Follow()	
	LFC()
	Checks()
	
	--|> Poro Shouter
	
		PoroCheck()
	
	
	--|> Zhonya
	Zhonya()
	getHealthPercent(unit)
	

	
	--|> AutoPotions
	if not myHero.dead then

		Consumables()
		
	end
	

end

--[[ Follow Function ]]--
function Follow()
	if iARAM.follow and not myHero.dead then
		stance = 0
		if Allies() >=  2 then
			stance = 1
			--if lastCast > os.clock() - 0.5 then return end
			--_AutoupdaterMsg("TF mode")
			--lastCast = os.clock()
			--_FloatTextMsg("TF mode")
			--DrawText("TF mode", 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
			
		else
			stance = 0
			--if lastCast > os.clock() - 10 then return end
			--_AutoupdaterMsg("Alone mode")
			--lastCast = os.clock()
			
			--_FloatTextMsg("Alone mode")
			--local Note = "Alone mode"
			--DrawText("Alone mode", 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
			
			
		end
		--val = myHero.maxHealth/myHero.health
		--if  val > 3 and GetDistance(findClosestEnemy()) > 300 then
			--stance = 3
			--if lastCast > os.clock() - 10 then return end
			--_AutoupdaterMsg("Low Health mode")
			--lastCast = os.clock()
			
			--_FloatTextMsg("Lox Health mode")
			--DrawText("Low Health mode", 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
			--PrintFloatText(myHero, 0, "Low Health mode")
		--end
		if findLowHp() ~= 0 then
			Target = findLowHp()
			else
			Target = findClosestEnemy()
		end
		
		Allie = followHero()
		--Attacks Champs
		if Target ~= nil then
		  myHero:Attack(Target)
			if stance == 1  then
				attacksuccess = 0
				if myHero:GetSpellData(_W).range > GetDistance(Target) then
					CastSpell(_W, Target)
					attacksuccess =1
										
				end
				if myHero:GetSpellData(_Q).range > GetDistance(Target) then
					CastSpell(_Q, Target)
					attacksuccess =1 
					
					--PrintFloatText(Target,0,"Casting spell to".. Target.charName)
				end
				if myHero:GetSpellData(_E).range > GetDistance(Target) then
					CastSpell(_E, Target)
					attacksuccess = 1
				
					--PrintFloatText(Target,0,"Casting spell to".. Target.charName)
				end
				if myHero:GetSpellData(_R).range > GetDistance(Target) then
					CastSpell(_R, Target)
					attacksuccess =1
					--DrawText("Casting spell to".. Target.charName, 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))
				
				
				end
				if GetDistance(Target) < getTrueRange() then
					myHero:Attack(Target)
					if ranged == 1 then
						attacksuccess = 1
						missilesent = 0
						while not missilesent do
							if myHero.dead then missilesent = 1 end
							for _, v in pairs(getChampTable()[myHero.charName].aaParticles) do
								if obj.name:lower():find(v:lower()) then
									missilesent =1 
								end
							end
						end
					end
				end
				if attacksuccess == 0 then
					--Attack Minions
				end
			elseif stance == 0 then
				--alone
			--elseif stance == 3 then
				--low health
				--[[
				if HL_slot ~= nil and player:CanUseSpell(HL_slot) == READY then
					CastSpell(HL_slot)
				end
				if BR_slot ~= nil and player:CanUseSpell(BR_slot) == READY then
					CastSpell(BR_slot)
				end
				
				
				for i,buff in pairs(buffs) do 
					if buff.current ==1 then
						if GetDistance(spawnpos,findClosestEnemy()) > GetDistance(spawnpos,buff.pos) then 
							myHero:MoveTo(buff.pos.x,buff.pos.z) 
							break 
						end
					end
				end
				]]--
				--/low health
			end
			allytofollow = followHero()
			if allytofollow ~= nil and GetDistance(allytofollow,myHero) > 350  then
				--PrintFloatText(allytofollow, 0, "Following")
				distance1 = math.random(250,300)
				distance2 = math.random(250,300)
				neg1 = 1 
				neg2 = 1 
				if myHero.team == TEAM_BLUE then
					myHero:MoveTo(allytofollow.x-distance1*neg1,allytofollow.z-distance2*neg2)
				else
					myHero:MoveTo(allytofollow.x+distance1*neg1,allytofollow.z+distance2*neg2)
				end
			end
			if frontally() == myHero then
				myHero:MoveTo(spawnpos.x,spawnpos.z)
			end
		end	
		
	else
		--dead
		buyItems()
	end
	buyItems()
	--[[
	for i =1, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.name == "HA_AP_HealthRelic4.1.1" then 
			buffs[4].current =1
		else 
			buffs[4].current=0 
		end
		if object ~= nil and object.name == "HA_AP_HealthRelic3.1.1" then 
			buffs[3].current =1 
		else 
			buffs[3].current=0 
		end
		if object ~= nil and object.name == "HA_AP_HealthRelic2.1.1" then 
			buffs[2].current =1 
		else 
			buffs[2].current=0 
		end
		if object ~= nil and object.name == "HA_AP_HealthRelic1.1.1" then 
			buffs[1].current =1 
		else 
			buffs[1].current=0 
		end
	end
	]]--
	--LEVELUP
	local qL, wL, eL, rL = player:GetSpellData(_Q).level + qOff, player:GetSpellData(_W).level + wOff, player:GetSpellData(_E).level + eOff, player:GetSpellData(_R).level + rOff
	if qL + wL + eL + rL < player.level then
		local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4, }
		local level = { 0, 0, 0, 0 }
		for i = 1, player.level, 1 do
			level[abilitySequence[i]] = level[abilitySequence[i]] + 1
		end
		for i, v in ipairs({ qL, wL, eL, rL }) do
			if v < level[i] then LevelSpell(spellSlot[i]) end
		end
	end
	--/LEVELUP
	
end

function findClosestEnemy()
    local closestEnemy = nil
    local currentEnemy = nil
    for i=1, heroManager.iCount do
        currentEnemy = heroManager:GetHero(i)
        if currentEnemy.team ~= myHero.team and not currentEnemy.dead and currentEnemy.visible then
            if closestEnemy == nil then
                closestEnemy = currentEnemy
                elseif GetDistance(currentEnemy) < GetDistance(closestEnemy) then
                    closestEnemy = currentEnemy
            end
        end
    end
	--PrintFloatText(closestEnemy, 0, "Enemy!")
	return closestEnemy
end

function findLowHp() 
	local lowEnemy = nil
    local currentEnemy = nil
    for i=1, heroManager.iCount do
        currentEnemy = heroManager:GetHero(i)
        if currentEnemy.team ~= myHero.team and not currentEnemy.dead and currentEnemy.visible then
		
            if lowEnemy == nil then
				lowEnemy = currentEnemy
			end
			
		    if currentEnemy.health < lowEnemy.health then
				lowEnemy = currentEnemy
			end
        end
    end
	if lowEnemy ~= nil  then
		if lowEnemy.health < 200 then
			PrintFloatText(lowEnemy, 0, "Kill Me")
			return lowEnemy
		else
			return 0
		end
	else
		return 0
	end
end

function Allies()
    local allycount = 0
    for i=1, heroManager.iCount do
        hero = heroManager:GetHero(i)
        if hero.team == myHero.team and not hero.dead and GetDistance(hero) < 350 then
					allycount = allycount + 1
				end
    end
	return allycount
end

function frontally()
	local target = nil
	local dist = 0
	for d=1, heroManager.iCount, 1 do
		TargetAlly = heroManager:getHero(d)
		if TargetAlly.afk == nil and TargetAlly.dead == false and TargetAlly.team == myHero.team and GetDistance(TargetAlly,spawnpos) > dist then
			target = TargetAlly
			dist = GetDistance(target,spawnpos)
		end
	end
	return target
end

function followHero()
	local target =nil
	for d=1, heroManager.iCount, 1 do
		TargetAlly = heroManager:getHero(d)
		if TargetAlly.afk == nil and TargetAlly.dead == false and GetDistance(TargetAlly,spawnpos) > 3000 then
			if TargetAlly.team == myHero.team and TargetAlly.name ~= myHero.name then
				target = TargetAlly
			end
		end
	end
	return target
end

--[[ AutoBuyItems ]]--
function buyItems()
	if iARAM.autobuy then
		if InFountain() or player.dead then	
	
			--[[ Basic Items ]]--	
			if GetInGameTimer() < 10 then
				DelayAction(function()
						BuyItem(3340)
						BuyItem(2003)
						BuyItem(2003)
						BuyItem(1001)
					if lastCast1 > os.clock() - 10 then return end
						_AutoupdaterMsg("Buying Bots, Trinket and Potions")
					lastCast1 = os.clock()
				end, 10-GetInGameTimer()) --0:12
			
			
			
			--[[ ADC Items ]]--
			--shopList = {1038,3072,1038,3031,1038,3139,1038,3508}
			elseif GetInGameTimer() < 490 and heroType == 1 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying Berserker's Greaves (ADC)")
					BuyItem(3006) --Berserker's Greaves
					lastCast4 = os.clock()
				end, 490-GetInGameTimer()) --8:09
				
			elseif GetInGameTimer() < 590 and heroType == 1 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item(ADC)")
					BuyItem(3144) 
					lastCast5 = os.clock()
				end, 590-GetInGameTimer()) --9:83
				
			
			elseif GetInGameTimer() < 1000 and heroType == 1 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (ADC)")
					BuyItem(3031)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 1 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (ADC)")
					BuyItem(3139)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 1 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (ADC)")
					BuyItem(3508)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00	
				
				
				
			--[[ ADTank  Items ]]--
			--shopList = {3083,3155,3156,3068,3211,3102,3075}
			
			elseif GetInGameTimer() < 15 and heroType == 2 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (ADTank)")
					BuyItem(3083)
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 2 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (ADTank)")
					BuyItem(3155)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 2 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item ()")
					BuyItem(3156)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 2 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item ()")
					BuyItem(3068)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 2 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item ()")
					BuyItem(3075)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00

			
			--[[ APTank Items ]]--
			--shopList = {3083,1058,3089,1058,3157,1058,3285,3001}
			
			elseif GetInGameTimer() < 330 and heroType == 3 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying Tank bots (APTank)")
					BuyItem(3083) --bots tank
					lastCast3 = os.clock()
				end, 330-GetInGameTimer()) --5:17
			
			elseif GetInGameTimer() < 15 and heroType == 3 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APTank)")
					BuyItem(1058)
					--BuyItem(1052) --Amplifying Tome
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 3 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APTank)")
					BuyItem(3089)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 3 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APTank)")
					BuyItem(3157)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 3 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APTank)")
					BuyItem(3285)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 3 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APTank)")
					BuyItem(3001)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00
			
			
			--[[ HYBRID Items ]]--
			--shopList = {3101,3115,3136,3151,1058,3089,3100}
			
			elseif GetInGameTimer() < 15 and heroType == 4 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (HYBRID)")
					BuyItem(3101)
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 4 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (HYBRID)")
					BuyItem(3115)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 4 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (HYBRID)")
					BuyItem(3136)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 4 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (HYBRID)")
					BuyItem(3151)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 4 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (HYBRID)")
					BuyItem(3100)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00
			
			
			--[[ BRUISER Items ]]--
			--shopList = {3211,3102,3075,1038,3072,3044,3071}
			
			elseif GetInGameTimer() < 15 and heroType == 5 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (BRUISER)")
					BuyItem(3211)
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 5 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (BRUISER)")
					BuyItem(3102)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 5 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (BRUISER)")
					BuyItem(3075)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 5 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (BRUISER)")
					BuyItem(3072)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 5 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (BRUISER)")
					BuyItem(3044)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00
			
			
			
			
			--[[ Assasin Items ]]--
			--shopList = {3211,3065,3190,3075,3068}
			
			elseif GetInGameTimer() < 15 and heroType == 6 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Assasin)")
					BuyItem(3211)
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 6 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Assasin)")
					BuyItem(3065)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 6 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Assasin)")
					BuyItem(3190)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 6 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Assasin)")
					BuyItem(3075)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 6 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Assasin)")
					BuyItem(3068)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00
			
	
			--[[ Mage Items ]]--
			--shopList = {3165,1058,3089,1058,3157,1058,3285}
			
			elseif GetInGameTimer() < 15 and heroType == 7 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying Fiendish Codex (Mage)")
					BuyItem(3108)
					--BuyItem(1052) --Amplifying Tome
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 7 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Mage)")
					BuyItem(1058)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 7 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Mage)")
					BuyItem(3089)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 7 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Mage)")
					BuyItem(3157)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 7 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Mage)")
					BuyItem(3285)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00
				
				
			--[[ APC Items ]]--
			--shopList = {3165,1058,3089,1058,3157,1058,3285}
			
			elseif GetInGameTimer() < 15 and heroType == 8 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APC)")
					BuyItem(3165)
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 8 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APC)")
					BuyItem(3089)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 8 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APC)")
					BuyItem(3157)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 8 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APC)")
					BuyItem(1058)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 8 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (APC)")
					BuyItem(3285)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00
			
			--[[ Fighter Items ]]--
			--shopList = {3211,3065,3190,3075,3068}
			
			elseif GetInGameTimer() < 15 and heroType == 9 or heroType == 10 then
				DelayAction(function()
				if lastCast2 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Fighter)")
					BuyItem(3211)
					lastCast2 = os.clock()
			end, 15-GetInGameTimer()) --0:25
			
			elseif GetInGameTimer() < 600 and heroType == 9 or heroType == 10 then
				DelayAction(function()
				if lastCast3 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Fighter)")
					BuyItem(3065)
					lastCast3 = os.clock()
			end, 600-GetInGameTimer()) --
			
			elseif GetInGameTimer() < 1000 and heroType == 9 or heroType == 10 then
				DelayAction(function()
				if lastCast4 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Fighter)")
					BuyItem(3190)
					lastCast4 = os.clock()
			end, 1000-GetInGameTimer()) -- 13.00
			
			elseif GetInGameTimer() < 1500 and heroType == 9 or heroType == 10 then
				DelayAction(function()
				if lastCast5 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Fighter)")
					BuyItem(3075)
					lastCast5 = os.clock()
			end, 1500-GetInGameTimer()) -- 25.00
			
			elseif GetInGameTimer() < 2000 and heroType == 9 or heroType == 10 then
				DelayAction(function()
				if lastCast6 > os.clock() - 10 then return end
					_AutoupdaterMsg("Buying item (Fighter)")
					BuyItem(3068)
					lastCast6 = os.clock()
			end, 2000-GetInGameTimer()) -- 33.00
			
			
			end
		end
	end
end
--[[ 
Outdate	
function buyItems()
 if iARAM.autobuy then
		if InFountain() or player.dead or shopList[buyIndex] ~= 0 then
			local itemval = shopList[buyIndex]
			BuyItem(itemval)
				if GetInventorySlotItem(shopList[buyIndex]) ~= nil then
					--Last Buy successful
					buyIndex = buyIndex + 1
					buyItems()
				end
			
		end
	end
end
]]--

function getTrueRange()
    return myHero.range + GetDistance(myHero.minBBox)+100
end

--[[ Level Sequence ]]--
function LevelSequence()
    local champ = player.charName
    if champ == "Aatrox" then           abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Ahri" then         abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 2, 2, }
    elseif champ == "Akali" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Alistar" then      abilitySequence = { 1, 3, 2, 1, 3, 4, 1, 3, 1, 3, 4, 1, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Amumu" then        abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Anivia" then       abilitySequence = { 1, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 1, 1, 1, 2, 4, 2, 2, }
    elseif champ == "Annie" then        abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Ashe" then         abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Azir" then         abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Blitzcrank" then   abilitySequence = { 1, 3, 2, 3, 2, 4, 3, 2, 3, 2, 4, 3, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Brand" then        abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Bard" then         abilitySequence = { 2, 1, 3, 2, 2, 4, 1, 2, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
	elseif champ == "Braum" then        abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Caitlyn" then      abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Cassiopeia" then   abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Chogath" then      abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Corki" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif champ == "Darius" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Diana" then        abilitySequence = { 2, 1, 2, 3, 1, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "DrMundo" then      abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Draven" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
	elseif champ == "Ekko" then      	abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Elise" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, } rOff = -1
    elseif champ == "Evelynn" then      abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Ezreal" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "FiddleSticks" then abilitySequence = { 3, 2, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Fiora" then        abilitySequence = { 2, 1, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Fizz" then         abilitySequence = { 3, 1, 2, 1, 2, 4, 1, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Galio" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, }
    elseif champ == "Gangplank" then    abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Garen" then        abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Gragas" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Graves" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
	elseif champ == "Gnar" then         abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 3, 2, 2, 4, 3, 3, }
    elseif champ == "Hecarim" then      abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Heimerdinger" then abilitySequence = { 1, 2, 2, 1, 1, 4, 3, 2, 2, 2, 4, 1, 1, 3, 3, 4, 1, 1, }
    elseif champ == "Irelia" then       abilitySequence = { 3, 1, 2, 2, 2, 4, 2, 3, 2, 3, 4, 1, 1, 3, 1, 4, 3, 1, }
    elseif champ == "Janna" then        abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, }
    elseif champ == "JarvanIV" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 2, 1, 4, 3, 3, 3, 2, 4, 2, 2, }
    elseif champ == "Jax" then          abilitySequence = { 3, 2, 1, 2, 2, 4, 2, 3, 2, 3, 4, 1, 3, 1, 1, 4, 3, 1, }
    elseif champ == "Jayce" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, } rOff = -1
	elseif champ == "Jinx" then         abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 2, 3, 2, 1, 2, 2, 1, 1, 1, 4, 4, }
	elseif champ == "Kalista" then      abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 1, 3, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Karma" then        abilitySequence = { 1, 3, 1, 2, 3, 1, 3, 1, 3, 1, 3, 1, 3, 2, 2, 2, 2, 2, }
    elseif champ == "Karthus" then      abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 1, 3, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Kassadin" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Katarina" then     abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
    elseif champ == "Kayle" then        abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Kennen" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Khazix" then       abilitySequence = { 1, 3, 1, 2 ,1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "KogMaw" then       abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Leblanc" then      abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "LeeSin" then       abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Leona" then        abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Lissandra" then    abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Lucian" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Lulu" then         abilitySequence = { 3, 2, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Lux" then          abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Malphite" then     abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif champ == "Malzahar" then     abilitySequence = { 1, 3, 3, 2, 3, 4, 1, 3, 1, 3, 4, 2, 1, 2, 1, 4, 2, 2, }
    elseif champ == "Maokai" then       abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "MasterYi" then     abilitySequence = { 3, 1, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 2, 2, 4, 2, 2, }
    elseif champ == "MissFortune" then  abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "MonkeyKing" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 3, 1, 3, 1, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Mordekaiser" then  abilitySequence = { 3, 1, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Morgana" then      abilitySequence = { 1, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Nami" then         abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 2, 3, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Nasus" then        abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Nautilus" then     abilitySequence = { 2, 3, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Nidalee" then      abilitySequence = { 2, 3, 1, 3, 1, 4, 3, 2, 3, 1, 4, 3, 1, 1, 2, 4, 2, 2, }
    elseif champ == "Nocturne" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Nunu" then         abilitySequence = { 3, 1, 3, 2, 1, 4, 3, 1, 3, 1, 4, 1, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Olaf" then         abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Orianna" then      abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Pantheon" then     abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 2, 3, 2, 4, 2, 2, }
    elseif champ == "Poppy" then        abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 2, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, }
    elseif champ == "Quinn" then        abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Rammus" then       abilitySequence = { 1, 2, 3, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
	elseif champ == "RekSai" then       abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Renekton" then     abilitySequence = { 2, 1, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Rengar" then       abilitySequence = { 1, 3, 2, 1, 1, 4, 2, 1, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Riven" then        abilitySequence = { 1, 2, 3, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Rumble" then       abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Ryze" then         abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Sejuani" then      abilitySequence = { 2, 1, 3, 3, 2, 4, 3, 2, 3, 3, 4, 2, 1, 2, 1, 4, 1, 1, }
    elseif champ == "Shaco" then        abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 2, 4, 2, 2, 1, 1, 4, 1, 1, }
    elseif champ == "Shen" then         abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Shyvana" then      abilitySequence = { 2, 1, 2, 3, 2, 4, 2, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, }
    elseif champ == "Singed" then       abilitySequence = { 1, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 3, 2, 3, 2, 4, 2, 3, }
    elseif champ == "Sion" then         abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Sivir" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3, }
    elseif champ == "Skarner" then      abilitySequence = { 1, 2, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 3, 3, 4, 3, 3, }
    elseif champ == "Sona" then         abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Soraka" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif champ == "Swain" then        abilitySequence = { 2, 3, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Syndra" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Talon" then        abilitySequence = { 2, 3, 1, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Taric" then        abilitySequence = { 3, 2, 1, 2, 2, 4, 1, 2, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3, }
    elseif champ == "Teemo" then        abilitySequence = { 1, 3, 2, 3, 1, 4, 3, 3, 3, 1, 4, 2, 2, 1, 2, 4, 2, 1, }
    elseif champ == "Thresh" then       abilitySequence = { 1, 3, 2, 2, 2, 4, 2, 3, 2, 3, 4, 3, 3, 1, 1, 4, 1, 1, }
    elseif champ == "Tristana" then     abilitySequence = { 3, 2, 2, 3, 2, 4, 2, 1, 2, 1, 4, 1, 1, 1, 3, 4, 3, 3, }
    elseif champ == "Trundle" then      abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif champ == "Tryndamere" then   abilitySequence = { 3, 1, 2, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "TwistedFate" then  abilitySequence = { 2, 1, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Twitch" then       abilitySequence = { 1, 3, 3, 2, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 1, 2, 2, }
    elseif champ == "Udyr" then         abilitySequence = { 4, 2, 3, 4, 4, 2, 4, 2, 4, 2, 2, 1, 3, 3, 3, 3, 1, 1, }
    elseif champ == "Urgot" then        abilitySequence = { 3, 1, 1, 2, 1, 4, 1, 2, 1, 3, 4, 2, 3, 2, 3, 4, 2, 3, }
    elseif champ == "Varus" then        abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Vayne" then        abilitySequence = { 1, 3, 2, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Veigar" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, }
	elseif champ == "Velkoz" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 2, 2, 2, 2, 4, 3, 1, 1, 3, 4, 3, 3, }
    elseif champ == "Vi" then           abilitySequence = { 3, 1, 2, 3, 3, 4, 3, 1, 3, 1, 4, 1, 1, 2, 2, 4, 2, 2, }
    elseif champ == "Viktor" then       abilitySequence = { 3, 2, 3, 1, 3, 4, 3, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, }
    elseif champ == "Vladimir" then     abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Volibear" then     abilitySequence = { 2, 3, 2, 1, 2, 4, 3, 2, 1, 2, 4, 3, 1, 3, 1, 4, 3, 1, }
    elseif champ == "Warwick" then      abilitySequence = { 2, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 3, 2, 4, 2, 2, }
    elseif champ == "Xerath" then       abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "XinZhao" then      abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Yorick" then       abilitySequence = { 2, 3, 1, 3, 3, 4, 3, 2, 3, 1, 4, 2, 1, 2, 1, 4, 2, 1, }
	elseif champ == "Yasuo" then        abilitySequence = { 1, 3, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Zac" then          abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Zed" then          abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Ziggs" then        abilitySequence = { 1, 2, 3, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    elseif champ == "Zilean" then       abilitySequence = { 1, 2, 1, 3, 1, 4, 1, 2, 1, 2, 4, 2, 2, 3, 3, 4, 3, 3, }
    elseif champ == "Zyra" then         abilitySequence = { 3, 2, 1, 1, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2, 2, }
    else _AutoupdaterMsg(string.format(" >> AutoLevelSpell  disabled for %s", champ))
    end
    if abilitySequence and #abilitySequence == 18 then
		--_AutoupdaterMsg("<font color=\"#81BEF7\">AutoLevelSpell loaded!</font>")
    else
        _AutoupdaterMsg(" >> AutoLevel Error")
        OnTick = function() end
        return
    end
end

--[[ Attack Distance ]]-- 
function getChampTable() 
    return {                                                   
        Ahri         = { projSpeed = 1.6, aaParticles = {"Ahri_BasicAttack_mis", "Ahri_BasicAttack_tar"}, aaSpellName = "ahribasicattack", startAttackSpeed = "0.668",  },
        Anivia       = { projSpeed = 1.05, aaParticles = {"cryo_BasicAttack_mis", "cryo_BasicAttack_tar"}, aaSpellName = "aniviabasicattack", startAttackSpeed = "0.625",  },
        Annie        = { projSpeed = 1.0, aaParticles = {"AnnieBasicAttack_tar", "AnnieBasicAttack_tar_frost", "AnnieBasicAttack2_mis", "AnnieBasicAttack3_mis"}, aaSpellName = "anniebasicattack", startAttackSpeed = "0.579",  },
        Ashe         = { projSpeed = 2.0, aaParticles = {"bowmaster_frostShot_mis", "bowmasterbasicattack_mis"}, aaSpellName = "ashebasicattack", startAttackSpeed = "0.658" },
		Azir         = { projSpeed = 1.6, aaParticles = {"Azir_BasicAttack_mis", "Azir_BasicAttack_tar"}, aaSpellName = "Azirbasicattack", startAttackSpeed = "0.668",  },
        Brand        = { projSpeed = 1.975, aaParticles = {"BrandBasicAttack_cas", "BrandBasicAttack_Frost_tar", "BrandBasicAttack_mis", "BrandBasicAttack_tar", "BrandCritAttack_mis", "BrandCritAttack_tar", "BrandCritAttack_tar"}, aaSpellName = "brandbasicattack", startAttackSpeed = "0.625" },
		Bard         = { projSpeed = 1.0, aaParticles = {"BardBasicAttack_tar", "BardBasicAttack_tar_frost", "BardBasicAttack2_mis", "BardBasicAttack3_mis"}, aaSpellName = "Bardbasicattack", startAttackSpeed = "0.579",  },        
		Caitlyn      = { projSpeed = 2.5, aaParticles = {"caitlyn_basicAttack_cas", "caitlyn_headshot_tar", "caitlyn_mis_04"}, aaSpellName = "caitlynbasicattack", startAttackSpeed = "0.668" },
        Cassiopeia   = { projSpeed = 1.22, aaParticles = {"CassBasicAttack_mis"}, aaSpellName = "cassiopeiabasicattack", startAttackSpeed = "0.644" },
        Corki        = { projSpeed = 2.0, aaParticles = {"corki_basicAttack_mis", "Corki_crit_mis"}, aaSpellName = "CorkiBasicAttack", startAttackSpeed = "0.658" },
        Draven       = { projSpeed = 1.4, aaParticles = {"Draven_BasicAttack_mis", "Draven_crit_mis", "Draven_Q_mis", "Draven_Qcrit_mis"}, aaSpellName = "dravenbasicattack", startAttackSpeed = "0.679",  },
        Ezreal       = { projSpeed = 2.0, aaParticles = {"Ezreal_basicattack_mis", "Ezreal_critattack_mis"}, aaSpellName = "ezrealbasicattack", startAttackSpeed = "0.625" },
        FiddleSticks = { projSpeed = 1.75, aaParticles = {"FiddleSticks_cas", "FiddleSticks_mis", "FiddleSticksBasicAttack_tar"}, aaSpellName = "fiddlesticksbasicattack", startAttackSpeed = "0.625" },
        Graves       = { projSpeed = 3.0, aaParticles = {"Graves_BasicAttack_mis",}, aaSpellName = "gravesbasicattack", startAttackSpeed = "0.625" },
        Gnar         = { projSpeed = 1.6, aaParticles = {"Gnar_BasicAttack_mis", "Gnar_BasicAttack_tar"}, aaSpellName = "gnarbasicattack", startAttackSpeed = "0.668",  },
		Heimerdinger = { projSpeed = 1.4, aaParticles = {"heimerdinger_basicAttack_mis", "heimerdinger_basicAttack_tar"}, aaSpellName = "heimerdingerbasicAttack", startAttackSpeed = "0.625" },
        Janna        = { projSpeed = 1.2, aaParticles = {"JannaBasicAttack_mis", "JannaBasicAttack_tar", "JannaBasicAttackFrost_tar"}, aaSpellName = "jannabasicattack", startAttackSpeed = "0.625" },
        Jayce        = { projSpeed = 2.2, aaParticles = {"Jayce_Range_Basic_mis", "Jayce_Range_Basic_Crit"}, aaSpellName = "jaycebasicattack", startAttackSpeed = "0.658",  },
        Kalista      = { projSpeed = 1.6, aaParticles = {"Kalista_BasicAttack_mis", "Kalista_BasicAttack_tar"}, aaSpellName = "Kalistabasicattack", startAttackSpeed = "0.668",  },
		Karma        = { projSpeed = nil, aaParticles = {"karma_basicAttack_cas", "karma_basicAttack_mis", "karma_crit_mis"}, aaSpellName = "karmabasicattack", startAttackSpeed = "0.658",  },
        Karthus      = { projSpeed = 1.25, aaParticles = {"LichBasicAttack_cas", "LichBasicAttack_glow", "LichBasicAttack_mis", "LichBasicAttack_tar"}, aaSpellName = "karthusbasicattack", startAttackSpeed = "0.625" },
        Kayle        = { projSpeed = 1.8, aaParticles = {"RighteousFury_nova"}, aaSpellName = "KayleBasicAttack", startAttackSpeed = "0.638",  }, -- Kayle doesn't have a particle when auto attacking without E buff..
        Kennen       = { projSpeed = 1.35, aaParticles = {"KennenBasicAttack_mis"}, aaSpellName = "kennenbasicattack", startAttackSpeed = "0.690" },
        KogMaw       = { projSpeed = 1.8, aaParticles = {"KogMawBasicAttack_mis", "KogMawBioArcaneBarrage_mis"}, aaSpellName = "kogmawbasicattack", startAttackSpeed = "0.665", },
        Leblanc      = { projSpeed = 1.7, aaParticles = {"leBlanc_basicAttack_cas", "leBlancBasicAttack_mis"}, aaSpellName = "leblancbasicattack", startAttackSpeed = "0.625" },
        Lulu         = { projSpeed = 2.5, aaParticles = {"lulu_attack_cas", "LuluBasicAttack", "LuluBasicAttack_tar"}, aaSpellName = "LuluBasicAttack", startAttackSpeed = "0.625" },
        Lux          = { projSpeed = 1.55, aaParticles = {"LuxBasicAttack_mis", "LuxBasicAttack_tar", "LuxBasicAttack01"}, aaSpellName = "luxbasicattack", startAttackSpeed = "0.625" },
        Malzahar     = { projSpeed = 1.5, aaParticles = {"AlzaharBasicAttack_cas", "AlZaharBasicAttack_mis"}, aaSpellName = "malzaharbasicattack", startAttackSpeed = "0.625" },
        MissFortune  = { projSpeed = 2.0, aaParticles = {"missFortune_basicAttack_mis", "missFortune_crit_mis"}, aaSpellName = "missfortunebasicattack", startAttackSpeed = "0.656" },
        Morgana      = { projSpeed = 1.6, aaParticles = {"FallenAngelBasicAttack_mis", "FallenAngelBasicAttack_tar", "FallenAngelBasicAttack2_mis"}, aaSpellName = "Morganabasicattack", startAttackSpeed = "0.579" },
        Nidalee      = { projSpeed = 1.7, aaParticles = {"nidalee_javelin_mis"}, aaSpellName = "nidaleebasicattack", startAttackSpeed = "0.670" },
        Orianna      = { projSpeed = 1.4, aaParticles = {"OrianaBasicAttack_mis", "OrianaBasicAttack_tar"}, aaSpellName = "oriannabasicattack", startAttackSpeed = "0.658" },
        Quinn        = { projSpeed = 1.85, aaParticles = {"Quinn_basicattack_mis", "QuinnValor_BasicAttack_01", "QuinnValor_BasicAttack_02", "QuinnValor_BasicAttack_03", "Quinn_W_mis"}, aaSpellName = "QuinnBasicAttack", startAttackSpeed = "0.668" },  --Quinn's critical attack has the same particle name as his basic attack.
        Ryze         = { projSpeed = 2.4, aaParticles = {"ManaLeach_mis"}, aaSpellName = {"RyzeBasicAttack"}, startAttackSpeed = "0.625" },
        Sivir        = { projSpeed = 1.4, aaParticles = {"sivirbasicattack_mis", "sivirbasicattack2_mis", "SivirRicochetAttack_mis"}, aaSpellName = "sivirbasicattack", startAttackSpeed = "0.658" },
        Sona         = { projSpeed = 1.6, aaParticles = {"SonaBasicAttack_mis", "SonaBasicAttack_tar", "SonaCritAttack_mis", "SonaPowerChord_AriaofPerseverance_mis", "SonaPowerChord_AriaofPerseverance_tar", "SonaPowerChord_HymnofValor_mis", "SonaPowerChord_HymnofValor_tar", "SonaPowerChord_SongOfSelerity_mis", "SonaPowerChord_SongOfSelerity_tar", "SonaPowerChord_mis", "SonaPowerChord_tar"}, aaSpellName = "sonabasicattack", startAttackSpeed = "0.644" },
        Soraka       = { projSpeed = 1.0, aaParticles = {"SorakaBasicAttack_mis", "SorakaBasicAttack_tar"}, aaSpellName = "sorakabasicattack", startAttackSpeed = "0.625" },
        Swain        = { projSpeed = 1.6, aaParticles = {"swain_basicAttack_bird_cas", "swain_basicAttack_cas", "swainBasicAttack_mis"}, aaSpellName = "swainbasicattack", startAttackSpeed = "0.625" },
        Syndra       = { projSpeed = 1.2, aaParticles = {"Syndra_attack_hit", "Syndra_attack_mis"}, aaSpellName = "sorakabasicattack", startAttackSpeed = "0.625",  },
        Teemo        = { projSpeed = 1.3, aaParticles = {"TeemoBasicAttack_mis", "Toxicshot_mis"}, aaSpellName = "teemobasicattack", startAttackSpeed = "0.690" },
        Tristana     = { projSpeed = 2.25, aaParticles = {"TristannaBasicAttack_mis"}, aaSpellName = "tristanabasicattack", startAttackSpeed = "0.656",  },
        TwistedFate  = { projSpeed = 1.5, aaParticles = {"TwistedFateBasicAttack_mis", "TwistedFateStackAttack_mis"}, aaSpellName = "twistedfatebasicattack", startAttackSpeed = "0.651",  },
        Twitch       = { projSpeed = 2.5, aaParticles = {"twitch_basicAttack_mis",--[[ "twitch_punk_sprayandPray_tar", "twitch_sprayandPray_tar",]] "twitch_sprayandPray_mis"}, aaSpellName = "twitchbasicattack", startAttackSpeed = "0.679" },
        Urgot        = { projSpeed = 1.3, aaParticles = {"UrgotBasicAttack_mis"}, aaSpellName = "urgotbasicattack", startAttackSpeed = "0.644" },
        Vayne        = { projSpeed = 2.0, aaParticles = {"vayne_basicAttack_mis", "vayne_critAttack_mis", "vayne_ult_mis" }, aaSpellName = "vaynebasicattack", startAttackSpeed = "0.658",  },
        Varus        = { projSpeed = 2.0, aaParticles = {"varus_basicAttack_mis", "varus_critAttack_mis" }, aaSpellName = "varusbasicattack", startAttackSpeed = "0.658",  },
        Veigar       = { projSpeed = 1.05, aaParticles = {"ahri_basicattack_mis"}, aaSpellName = "veigarbasicattack", startAttackSpeed = "0.625" },
        Velkoz       = { projSpeed = 1.05, aaParticles = {"velkoz_basicattack_mis"}, aaSpellName = "velkozbasicattack", startAttackSpeed = "0.625" },
		Viktor       = { projSpeed = 2.25, aaParticles = {"ViktorBasicAttack_cas", "ViktorBasicAttack_mis", "ViktorBasicAttack_tar"}, aaSpellName = "viktorbasicattack", startAttackSpeed = "0.625" },
        Vladimir     = { projSpeed = 1.4, aaParticles = {"VladBasicAttack_mis", "VladBasicAttack_mis_bloodless", "VladBasicAttack_tar", "VladBasicAttack_tar_bloodless"}, aaSpellName = "vladimirbasicattack", startAttackSpeed = "0.658" },
        Xerath       = { projSpeed = 1.2, aaParticles = {"XerathBasicAttack_mis", "XerathBasicAttack_tar"}, aaSpellName = "xerathbasicattack", startAttackSpeed = "0.625" },
        Ziggs        = { projSpeed = 1.5, aaParticles = {"ZiggsBasicAttack_mis", "ZiggsPassive_mis"}, aaSpellName = "ziggsbasicattack", startAttackSpeed = "0.656" },
        Zilean       = { projSpeed = 1.25, aaParticles = {"ChronoBasicAttack_mis"}, aaSpellName = "zileanbasicattack" },
        Zyra         = { projSpeed = 1.7, aaParticles = {"Zyra_basicAttack_cas", "Zyra_basicAttack_cas_02", "Zyra_basicAttack_mis", "Zyra_basicAttack_tar", "Zyra_basicAttack_tar_hellvine"}, aaSpellName = "zileanbasicattack", startAttackSpeed = "0.625",  },
 
    }
end

--[[ Menu Function ]]-- 
function Menu()
       iARAM = scriptConfig("iARAM: "..myHero.charName.." Bot", "iARAM BOT")
	   
	   
	   --[[ AutoWard Menu ]]--
	   
			iARAM:addSubMenu("Config Autoguard", "AutoWard")
			iARAM.AutoWard:addParam("AutoWardEnable", "Autoward Enabled", SCRIPT_PARAM_ONOFF, true)
			iARAM.AutoWard:addParam("AutoWardDraw", "Autoward Draw Circles", SCRIPT_PARAM_ONOFF, false)
			iARAM.AutoWard:addParam("debug", "Debug Mode", SCRIPT_PARAM_ONOFF, false)
		
		--[[ Drawing menu ]]--
		iARAM:addSubMenu("Drawing Settings", "drawing")
		iARAM.drawing:addParam("drawcircles", "Draw Circles", SCRIPT_PARAM_ONOFF, true)
		iARAM.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)
		
		--[[ PoroShoter menu ]]--
		
		ARAM = ARAMSlot()
		vPred = VPrediction()
		TargetSelector = TargetSelector(TARGET_CLOSEST, 2500, DAMAGE_PHYSICAL)
		iARAM:addSubMenu("PoroShotter Settings", "PoroShot")
		iARAM.PoroShot:addParam("comboKey", "Auto Poro Shoot", SCRIPT_PARAM_ONOFF, true) 
		iARAM.PoroShot:addParam("range", "Poro Cast Range", SCRIPT_PARAM_SLICE, 1400, 800, 2500, 0) 
		iARAM.PoroShot:addTS(TargetSelector)
		
		
		--Zhonya
		iARAM:addParam("zhonya", "Use Zhonyas", SCRIPT_PARAM_ONOFF, true)
		iARAM:addParam("zhonyaHP", "Max HP when using Zhonya", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)

		--Attack
		iARAM:addParam("farm", "last hit farm", SCRIPT_PARAM_ONOFF, true)	
		iARAM:addParam("key", "AutoAtack champs", SCRIPT_PARAM_ONOFF, true)

		--Main Script
		iARAM:addParam("autobuy", "Auto Buy Items", SCRIPT_PARAM_ONOFF, true)
		iARAM:addParam("follow", "Enable bot", SCRIPT_PARAM_ONKEYTOGGLE, true, HotKey)

		-----------------------------------------------------------------------------------------------------
		iARAM:addParam("info", " >> edited by ", SCRIPT_PARAM_INFO, "Husmeador12") 
		iARAM:addParam("info2", "iARAM Version : ", SCRIPT_PARAM_INFO, version)
		
		
		
		
end

--[[ Lagfree Circles by barasia, vadash and viseversa ]]---
function RangeCircles()
	if iARAM.drawing.drawcircles and not myHero.dead then
		DrawCircle(myHero.x,myHero.y,myHero.z,getTrueRange(),RGB(0,255,0))
		DrawCircle(myHero.x,myHero.y,myHero.z,400,RGB(55,64,60))	
	end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
		quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
		quality = 2 * math.pi / quality
		radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function round(num) 
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 75)	
    end
end

---------[[ Lagfree Circles ]]---------
function LFC()
	if iARAM.drawing.LfcDraw then
		_G.DrawCircle = DrawCircle2
	end
end	

---------[[ AirText ]]---------
function AirText()
SetupDrawY = 0.15
SetupDrawX = 0.1
tempSetupDrawY = SetupDrawY
MenuTextSize = 18

	DrawText(""..myHero.charName.." Bot", MenuTextSize , (WINDOW_W - WINDOW_X) * SetupDrawX, (WINDOW_H - WINDOW_Y) * tempSetupDrawY , 0xffffff00) 
	tempSetupDrawY = tempSetupDrawY + 0.03
	
	--DrawText(" ".. GetUser() .." ", MenuTextSize , (WINDOW_W - WINDOW_X) * SetupDrawX, (WINDOW_H - WINDOW_Y) * tempSetupDrawY , 0xffffff00) 
	tempSetupDrawY = tempSetupDrawY + 0.07

end

---------[[ Activated/disabled Script ]]---------
function OnWndMsg(msg, keycode)

	--|> AutoWard
		if summonersRiftMap then
			AutoWard()
		end
		
	if keycode == HotKey and msg == KEY_DOWN then
        if switcher == true then
            switcher = false
			_AutoupdaterMsg("<font color='#FF0000'>Script disabled </font>")
        else
            switcher = true
			_AutoupdaterMsg("<font color='#00FF00'>Script enabled </font>")
        end
    end
	
end



--[[
	Perfect Ward, originally by Husky
]]--     

local wardSpots = {
    -- Perfect Wards
	{x=3261.93, y=60, z=7773.65}, -- BLUE GOLEM
	{x=7831.46, y=60, z=3501.13}, -- BLUE LIZARD
	{x=10586.62, y=60, z=3067.93}, -- BLUE TRI BUSH
	{x=6483.73, y=60, z=4606.57}, -- BLUE PASS BUSH
	{x=7610.46, y=60, z=5000}, -- BLUE RIVER ENTRANCE
	{x=4717.09, y=50.83, z=7142.35}, -- BLUE ROUND BUSH
	{x=4882.86, y=27.83, z=8393.77}, -- BLUE RIVER ROUND BUSH
	{x=6951.01, y=52.26, z=3040.55}, -- BLUE SPLIT PUSH BUSH
	{x=5583.74, y=51.43, z=3573.83}, --BlUE RIVER CENTER CLOSE

	{x=11600.35, y=51.73, z=7090.37}, -- RED GOLEM
	{x=11573.9, y=51.71, z=6457.76}, -- RED GOLEM 2
	{x=12629.72, y=48.62, z=4908.16}, -- RED TRIBRUSH 2
	{x=7018.75, y=54.76, z=11362.12}, -- RED LIZARD
	{x=4232.69, y=47.56, z=11869.25}, -- RED TRI BUSH
	{x=8198.22, y=49.38, z=10267.89}, -- RED PASS BUSH
	{x=7202.43, y=53.18, z=9881.83}, -- RED RIVER ENTRANCE
	{x=10074.63, y=51.74, z=7761.62}, -- RED ROUND BUSH
	{x=9795.85, y=-12.21, z=6355.15}, -- RED RIVER ROUND BUSH
	{x=7836.85, y=56.48, z=11906.34}, -- RED SPLIT PUSH BUSH

	{x=10546.35, y=-60, z=5019.06}, -- DRAGON
	{x=9344.95, y=-64.07, z=5703.43}, -- DRAGON BUSH
	{x=4334.98, y=-60.42, z=9714.54}, -- BARON
	{x=5363.31, y=-62.70, z=9157.05}, -- BARON BUSH

	--{x=12731.25, y=50.32, z=9132.66}, -- RED BOT T2
	--{x=8036.52, y=45.19, z=12882.94}, -- RED TOP T2
	{x=9757.9, y=50.73, z=8768.25}, -- RED MID T1

	{x=4749.79, y=53.59, z=5890.76}, -- BLUE MID T1
	{x=5983.58, y=52.99, z=1547.98}, -- BLUE BOT T2
	{x=1213.70, y=58.77, z=5324.73}, -- BLUE TOP T2

	{x=6523.58, y=60, z=6743.31}, -- BLUE MIDLANE
	{x=8223.67, y=60, z=8110.15}, -- RED MIDLANE
	{x=9736.8, y=51.98, z=6916.26}, -- RED MID PATH
	{x=2222.31, y=53.2, z=9964.1}, -- BLUE TRI TOP
	{x=8523.9, y=51.24, z=4707.76}, -- DRAGON PASS BUSH
	{x=6323.9, y=53.62, z=10157.76} -- NASHOR PASS BUSH

}

local safeWardSpots = {

	{    -- RED MID -> SOLO BUSH
		magneticSpot = {x=9223, y=52.95, z=7525.34},
		clickPosition = {x=9603.52, y=54.71, z=7872.23},
		wardPosition = {x=9873.90, y=51.52, z=7957.76},
		movePosition = {x=9223, y=52.95, z=7525.34}
	},
	{    -- RED MID FROM TOWER -> SOLO BUSH
		magneticSpot =  {x=9127.66, y=53.76, z=8337.72},
		clickPosition = {x=9624.05, y=72.46, z=8122.68},
		wardPosition =  {x=9873.90, y=51.52, z=7957.76},
		movePosition  = {x=9127.66, y=53.76, z=8337.72}
	},
	{    -- BLUE MID -> SOLO BUSH
		magneticSpot =  {x=5667.73, y=51.65, z=7360.45},
		clickPosition = {x=5148.87, y=50.41, z=7205.80},
		wardPosition =  {x=4923.90, y=50.64, z=7107.76},
		movePosition  = {x=5667.73, y=51.65, z=7360.45}
	},
	{    -- BLUE MID FROM TOWER -> SOLO BUSH
		magneticSpot =  {x=5621.65, y=52.81, z=6452.61},
		clickPosition = {x=5255.46, y=50.44, z=6866.24},
		wardPosition =  {x=4923.90, y=50.64, z=7107.76},
		movePosition  = {x=5621.65, y=52.81, z=6452.61}
	},
	{    -- NASHOR -> TRI BUSH
		magneticSpot =  {x=4724, y=-71.24, z=10856},
		clickPosition = {x=4627.26, y=-71.24, z=11311.69},
		wardPosition =  {x=4473.9, y=51.4, z=11457.76},
		movePosition  = {x=4724, y=-71.24, z=10856}
	},
	{    -- BLUE TOP -> SOLO BUSH
		magneticSpot  = {x=2824, y=54.33, z=10356},
		clickPosition = {x=3078.62, y=54.33, z=10868.39},
		wardPosition  = {x=3078.62, y=-67.95, z=10868.39},
		movePosition  = {x=2824, y=54.33, z=10356}
	},
	{ -- BLUE MID -> ROUND BUSH
		magneticSpot  = {x=5474, y=51.67, z=7906},
		clickPosition = {x=5132.65, y=51.67, z=8373.2},
		wardPosition  = {x=5123.9, y=-21.23, z=8457.76},
		movePosition  = {x=5474, y=51.67, z=7906}
	},
	{ -- BLUE MID -> RIVER LANE BUSH
		magneticSpot  = {x=5874, y=51.65, z=7656},
		clickPosition = {x=6202.24, y=51.65, z=8132.12},
		wardPosition  = {x=6202.24, y=-67.39, z=8132.12},
		movePosition  = {x=5874, y=51.65, z=7656}
	},
	{ -- BLUE LIZARD -> DRAGON PASS BUSH
		magneticSpot  = {x=8022, y=53.72, z=4258},
		clickPosition = {x=8400.68, y=53.72, z=4657.41},
		wardPosition  = {x=8523.9, y=51.24, z=4707.76},
		movePosition  = {x=8022, y=53.72, z=4258}
	},
	{ -- RED MID -> ROUND BUSH
		magneticSpot  = {x=9372, y=52.63, z=7008},
		clickPosition = {x=9703.5, y=52.63, z=6589.9},
		wardPosition  = {x=9823.9, y=23.47, z=6507.76},
		movePosition  = {x=9372, y=52.63, z=7008}
	},
	{ -- RED MID -> RIVER ROUND BUSH // Inconsistent Placement
		magneticSpot  = {x=9072, y=53.04, z=7158},
		clickPosition = {x=8705.95, y=53.04, z=6819.1},
		wardPosition  = {x=8718.88, y=95.75, z=6764.86},
		movePosition  = {x=9072, y=53.04, z=7158}
	},
	{ -- RED BOTTOM -> SOLO BUSH
		magneticSpot  = {x=12422, y=51.73, z=4508},
		clickPosition = {x=12353.94, y=51.73, z=4031.58},
		wardPosition  = {x=12023.9, y=-66.25, z=3757.76},
		movePosition  = {x=12422, y=51.73, z=4508}
	},
	{ -- RED LIZARD -> NASHOR PASS BUSH -- FIXED FOR MORE VISIBLE AREA
		magneticSpot  = {x=6824, y=56, z=10656},
		clickPosition = {x=6484.47, y=53.5, z=10309.94},
		wardPosition  = {x=6323.9, y=53.62, z=10157.76},
		movePosition  = {x=6824, y=56, z=10656}
	},
	{ -- BLUE GOLEM -> BLUE LIZARD
		magneticSpot  = {x=8272,    y=51.13, z=2908},
		clickPosition = {x=8163.7056, y=51.13, z=3436.0476},
		wardPosition  = {x=8163.71, y=51.6628, z=3436.05},
		movePosition  = {x=8272,    y=51.13, z=2908}
	},
	{ -- RED GOLEM -> RED LIZARD
		magneticSpot  = {x=6574, y=56.48, z=12006},
		clickPosition = {x=6678.08, y=56.48, z=11477.83},
		wardPosition  = {x=6678.08, y=53.85, z=11477.83},
		movePosition  = {x=6574, y=56.48, z=12006}
	},
	{ -- BLUE TOP SIDE BRUSH
		magneticSpot  = {x=1774, y=52.84, z=10756},
		clickPosition = {x=2302.36, y=52.84, z=10874.22},
		wardPosition  = {x=2773.9, y=-71.24, z=11307.76},
		movePosition  = {x=1774, y=52.84, z=10756}
	},
	{ -- MID LANE DEATH BRUSH
		magneticSpot  = {x=5874, y=-70.12, z=8306},
		clickPosition = {x=5332.9, y=-70.12, z=8275.21},
		wardPosition  = {x=5123.9, y=-21.23, z=8457.76},
		movePosition  = {x=5874, y=-70.12, z=8306}
	},
	{ -- MID LANE DEATH BRUSH RIGHT SIDE
		magneticSpot  = {x=9022, y=-71.24, z=6558},
		clickPosition = {x=9540.43, y=-71.24, z=6657.68},
		wardPosition  = {x=9773.9, y=9.56, z=6457.76},
		movePosition  = {x=9022, y=-71.24, z=6558}
	},
	{ -- BLUE INNER TURRET JUNGLE
		magneticSpot  = {x=6874, y=50.52, z=1708},
		clickPosition = {x=6849.11, y=50.52, z=2252.01},
		wardPosition  = {x=6723.9, y=52.17, z=2507.76},
		movePosition  = {x=6874, y=50.52, z=1708}
	},
	{ -- RED INNER TURRET JUNGLE
		magneticSpot  = {x=8122, y=52.84, z=13206},
		clickPosition = {x=8128.53, y=52.84, z=12658.41},
		wardPosition  = {x=8323.9, y=56.48, z=12457.76},
		movePosition  = {x=8122, y=52.84, z=13206}
	}
}

local wardItems = {
    { id = 2043, spellName = "VisionWard",     		range = 1450, duration = 180000},
    { id = 2044, spellName = "SightWard",      		range = 1450, duration = 180000},
	{ id = 2045, spellName = "RubySightstone",  		range = 1450, duration = 180000},
    { id = 2049, spellName = "Sightstone",  		range = 1450, duration = 180000},
    { id = 2050, spellName = "ItemMiniWard",   		range = 1450, duration = 60000},
    { id = 3154, spellName = "WriggleLantern", 		range = 1450, duration = 180000},
    { id = 3160, spellName = "FeralFlare",	   		range = 1450, duration = 180000},
	{ id = 3340, spellName = "WardingTotem(Trinket)",   range = 1450, duration = 180000},
    { id = 3350, spellName = "YellowTrinketUpgrade", range = 1450, duration = 180000}, 
	{ id = 3361, spellName = "TrinketTotemLvl3", 	range = 1450, duration = 180000},--added
	{ id = 3362, spellName = "TrinketTotemLvl3B", 	range = 1450, duration = 180000},--added

}



-- Code ------------------------------------------------------------------------

function AutoWard()

   if iARAM.AutoWard.AutoWardEnable then
	wardSlot = ITEM_7
 
        local item = myHero:getInventorySlot(wardSlot)
         for i,wardItems in pairs(wardItems) do
                    if item == wardItems.id and myHero:CanUseSpell(wardSlot) == READY then
                        drawWardSpots = true
                        return
                    end
                end
           
        for i,wardSpot in pairs(wardSpots) do
            if GetDistance(wardSpot, myHeroPos) <= 250  then
                CastSpell(wardSlot, wardSpot.x, wardSpot.z)
                return
            end
        end
    end
end

function AutoWarderDraw()

    if iARAM.AutoWard.AutoWardDraw and summonersRiftMap then
        for i, wardSpot in pairs(wardSpots) do
            local wardColor = (GetDistance(wardSpot, myHeroPos) <= 250) and ARGB(255,0,255,0) or ARGB(255,0,255,0)

            local x, y, onScreen = get2DFrom3D(wardSpot.x, wardSpot.y, wardSpot.z)
            if onScreen then
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 31, wardColor)
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 32, wardColor)
                DrawCircle(wardSpot.x, wardSpot.y, wardSpot.z, 250, wardColor)
            end
        end

        for i,wardSpot in pairs(safeWardSpots) do
            local wardColor  = (GetDistance(wardSpot.magneticSpot, myHeroPos) <= 100) and ARGB(255,0,255,0) or ARGB(255,0,255,0)
            local arrowColor = (GetDistance(wardSpot.magneticSpot, myHeroPos) <= 100) and ARGB(255,0,255,0) or ARGB(255,0,255,0)

            local x, y, onScreen = get2DFrom3D(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z)
            if onScreen then
                DrawCircle(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z, 31, wardColor)
                DrawCircle(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z, 32, wardColor)

                DrawCircle(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z, 99, wardColor)
                DrawCircle(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z, 100, wardColor)

                local magneticWardSpotVector = Vector(wardSpot.magneticSpot.x, wardSpot.magneticSpot.y, wardSpot.magneticSpot.z)
                local wardPositionVector = Vector(wardSpot.wardPosition.x, wardSpot.wardPosition.y, wardSpot.wardPosition.z)
                local directionVector = (wardPositionVector-magneticWardSpotVector):normalized()
                local line1Start = magneticWardSpotVector + directionVector:perpendicular() * 98
                local line1End = wardPositionVector + directionVector:perpendicular() * 31
                local line2Start = magneticWardSpotVector + directionVector:perpendicular2() * 98
                local line2End = wardPositionVector + directionVector:perpendicular2() * 31

                DrawLine3D(line1Start.x,line1Start.y,line1Start.z, line1End.x,line1End.y,line1End.z,1,arrowColor)
                DrawLine3D(line2Start.x,line2Start.y,line2Start.z, line2End.x,line2End.y,line2End.z,1,arrowColor)

                
            end
        end
    end

    
end

function get2DFrom3D(x, y, z)
    local pos = WorldToScreen(D3DXVECTOR3(x, y, z))
    return pos.x, pos.y, OnScreen(pos.x, pos.y)
end

function DebugCursorPos()
	if iARAM.AutoWard.debug then
		DrawText("Cursor Pos: X = ".. string.format("%.2f", mousePos.x) .." Y = ".. string.format("%.2f", mousePos.y) .." Z = ".. string.format("%.2f", mousePos.z), 21, 5, 140, 0xFFFFFFFF)
		local target = GetTarget()
		for i,wardItem in pairs(wardItems) do
			if target ~= nil and target.name == wardItem.spellName then
				DrawText("Target Pos: X = ".. string.format("%.2f", target.x) .." Y = ".. string.format("%.2f", target.y) .." Z = ".. string.format("%.2f", target.z), 21, 5, 160, 0xFFFFFFFF)
			end
		end
	end
end



---------[[ Auto Ignite ]]---------
function AutoIgnite()
	Ignite = { name = "summonerdot", range = 600, slot = nil }
	if ValidTarget(unit, Ignite.range) and unit.health <= getDmg("IGNITE", unit, myHero) then
               if Ignite.ready then
                   CastSpell(Ignite.slot, unit)
               end
    end
			
--[[	if myTarget ~=	nil then		
		if Target.health <= iDmg and GetDistance(Target) <= 600 then
			if iReady then
				CastSpell(ignite, Target)			
			end

		end
	
	end]]--
end


---------[[ Auto Good luck and have fun ]]---------
function AutoChat()
Text1 = {"Good luck and have fun", "gl hf", "gl hf", "Good luck have fun", "Good luck and have fun guys", "gl hf guys", "gl and have fun", "good luck and hf" } 
Phrases2 = {"c´mon guys", "we can do it", "This is my winner team", "It doesnt matter", "let´s go", "team work is OP" }

	if GetInGameTimer() < 15 then
		DelayAction(function()
			SendChat(Text1[math.random(#Text1)])
		end, 15-GetInGameTimer()) --0:17
	end
	
	if GetInGameTimer() < 333 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 333-GetInGameTimer()) --5:35
	end
	
	--[[ if GetInGameTimer() < 360 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 360-GetInGameTimer()) --6:02
	end ]]--
	
	if GetInGameTimer() < 460 then
		DelayAction(function()
			SendChat(Phrases2[math.random(#Phrases2)])
		end, 460-GetInGameTimer()) --7:40
	end
	
	if GetGame().isOver then 
        SendChat("gg wp")
		QuitGame(10)
    end
	
end


---------[[ Poro shouter function ]]---------

function PoroCheck()
	Target = getTarget()
	if ARAM and (myHero:CanUseSpell(ARAM) == READY) then 
		ARAMRdy = true
	else
		ARAMRdy = false
	end
	if iARAM.PoroShot.comboKey then
		shootARAM(Target)
	end

end

function getTarget()
	TargetSelector:update()	
	if TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type == myHero.type then
		return TargetSelector.target
	else
		return nil
	end
end

function ARAMSlot()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonersnowball") then
		return SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonersnowball") then
		return SUMMONER_2
	else
		return nil
	end
end

function hit()
	if myHero:GetSpellData(SUMMONER_1).name:find("snowballfollowupcast") then
		return true
	elseif myHero:GetSpellData(SUMMONER_2).name:find("snowballfollowupcast") then
		return true
	else
		return false
	end
end

function shootARAM(unit)
	if lastCast > os.clock() - 10 then return end
	
	if  ValidTarget(unit, iARAM.PoroShot.range + 50) and ARAMRdy then
		local CastPosition, Hitchance, Position = vPred:GetLineCastPosition(Target, .25, 75, iARAM.range, 1200, myHero, true)
		if CastPosition and Hitchance >= 2 then
			d = CastPosition
			CastSpell(ARAM, CastPosition.x, CastPosition.z)
			lastCast = os.clock()
		end
	end
end



-----[[ AutoFarm and harras ]]------

function AutotatackChamp()
	
	range = myHero.range + myHero.boundingRadius - 3
	ts.range = range
	ts:update()
	if iARAM.follow then
		if not iARAM.key then return end
		local myTarget = ts.target
		if myTarget ~=	nil then		
			if timeToShoot() then
				myHero:Attack(myTarget)
				AttackChampion = true
				elseif heroCanMove() then
				AttackChampion = false
				
			end

		end
	end
end

function AutoFarm()
	if iARAM.follow then
		enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
		enemyMinions:update()
		local player = GetMyHero()
		local tick = 0
		local delay = 400
		local myTarget = ts.target
	  
		
		  if iARAM.farm then
			for index, minion in pairs(enemyMinions.objects) do
			  if GetDistance(minion, myHero) <= (myHero.range + 75) and GetTickCount() > tick + delay then
				local dmg = getDmg("AD", minion, myHero)
				if dmg > minion.health then
				  myHero:Attack(minion)
				  tick = GetTickCount()
				  AttackMinion = true
				  else
				  AttackMinion = false
				end
			  end
			end
		  end
	end
end

function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end 

function OnProcessSpell(object, spell)
	if object == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
		end 
	end
end


-----[[ Zhonya ]]------

function Zhonya()
	if iARAM.zhonya and getHealthPercent(myHero) < iARAM.zhonyaHP then 
		for slot = ITEM_1, ITEM_7 do
			if myHero:GetSpellData(slot).name == "ZhonyasHourglass" then
				CastSpell(slot)
			end
		end
	end
end

function getHealthPercent(unit)
    local obj = unit or myHero
    return (obj.health / obj.maxHealth) * 100
end

function ChampionFloatText()
ChampionCount = 0
    ChampionTable = {}
 
    for i = 1, heroManager.iCount do
        local champ = heroManager:GetHero(i)
               
        if champ.team ~= player.team then
            ChampionCount = ChampionCount + 1
            ChampionTable[ChampionCount] = { player = champ, indicatorText = "", damageGettingText = "", ultAlert = false, ready = true}
        end
    end
end

function _FloatTextMsg(msg) 

	local barPos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
	DrawText(" "..msg.." ", 15, barPos.x - 35, barPos.y + 20, ARGB(255, 0, 255, 0))

end

function LoadMapVariables()
	gameState = GetGame()
	if gameState.map.shortName then
		if gameState.map.shortName == "summonerRift" then
			summonersRiftMap = true
			--print("summonerRift")
		else
			summonersRiftMap = false
		end
		
		if gameState.map.shortName == "crystalScar" then
			crystalScarMap = true
			
		else
			crystalScarMap = false
		end
		
		if gameState.map.shortName == "howlingAbyss" then
			howlingAbyssMap = true
		else
			howlingAbyssMap = false
		end
		
		if gameState.map.shortName == "twistedTreeline" then
			twistedTreeLineMap = true
		else
			twistedTreeLineMap = false
		end
	else
		summonersRiftMap = true
	end
end



-----[[ AutoPotions ]]------

function LoadTables()
	Slots = 
	{
		6,
		7,
		8,
		9,
		10,
		11
	}
	
	Items = 
	{
		Pots = 
		{
			regenerationpotion = 
			{
				Name = "regenerationpotion",
				CastType = "Self"
			},

			flaskofcrystalwater = 
			{
				Name = "flaskofcrystalwater",
				CastType = "Self"
			},

			itemcrystalflask = 
			{
				Name = "itemcrystalflask",
				CastType = "Self"
			}
		},
	}
end

function PotReady(_c)
	for ac, bc in pairs(Slots) do
		if Items.Pots[myHero:GetSpellData(bc).name:lower()] and Items.Pots[myHero:GetSpellData(bc).name:lower()].Name == _c then
			if myHero:CanUseSpell(bc) == 0 then
				return true
			else
				return false
			end
		end
	end
end

function CastPots(_c)
	for ac, bc in pairs(Slots) do
		if Items.Pots[myHero:GetSpellData(bc).name:lower()] and Items.Pots[myHero:GetSpellData(bc).name:lower()].Name == _c and myHero:CanUseSpell(bc) == 0 then
			CastSpell(bc)
		end
	end
end

function LoadVariables()
	LoadMapVariables()
	LoadAutoPotsMenu()
end


function LoadAutoPotsMenu()
	iARAM:addSubMenu("Auto Pot Settings", "autoPots")
	iARAM.autoPots:addParam("useAutoPots", "Use Auto Pots", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useHealthPots", "Use Health Pots", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useManaPots", "Use Mana Pots", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useFlask", "Use Flask", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("useBiscuit", "Use Biscuit", SCRIPT_PARAM_ONOFF, true)
	iARAM.autoPots:addParam("minHealthPercent", "Min Health Percent", SCRIPT_PARAM_SLICE, 30, 1, 99, 0)
	iARAM.autoPots:addParam("HealhLost", "Health Lost Percent", SCRIPT_PARAM_SLICE, 40, 1, 99, 0)
	iARAM.autoPots:addParam("minManaPercent", "Min Mana Percent", SCRIPT_PARAM_SLICE, 30, 1, 99, 0)
	iARAM.autoPots:addParam("minHealthFlaskPercent", "Min Flask Health Percent", SCRIPT_PARAM_SLICE, 40, 1, 99, 0)
	iARAM.autoPots:addParam("minManaFlaskPercent", "Min Flask Mana Percent", SCRIPT_PARAM_SLICE, 40, 1, 99, 0)
end

function Consumables()
	if not iARAM.autoPots.useAutoPots then
		return
	end
	
	if not recalling and not InFountain() and not usingMixedPot then
		local _c = myHero.health / myHero.maxHealth * 100
		local ac = myHero.mana / myHero.maxMana * 100
		if _c <= iARAM.autoPots.minHealthPercent and not usingHealthPot and PotReady("regenerationpotion") then
			if PotReady("regenerationpotion") then
				CastPots("regenerationpotion")
			end
		elseif _c <= iARAM.autoPots.minHealthFlaskPercent and iARAM.autoPots.useFlask and PotReady("itemcrystalflask") and not usingHealthPot then
			CastPots("itemcrystalflask")
		elseif ac <= iARAM.autoPots.minManaPercent and iARAM.autoPots.useManaPots and PotReady("flaskofcrystalwater") and not usingManaPot then
			CastPots("flaskofcrystalwater")
		elseif ac <= iARAM.autoPots.minManaFlaskPercent and iARAM.autoPots.useFlask and PotReady("itemcrystalflask") and not usingManaPot then
			CastPots("itemcrystalflask")
		end
	end
end


