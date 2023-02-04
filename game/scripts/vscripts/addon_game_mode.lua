-- Generated from template
MAX_LEVEL = 25
STRATEGY_TIME =0
--RESPAWN_TIME = 2001
PRE_GAME_TIME = 30.0
HERO_SELECTION_TIME = 15.0  
UNIVERSAL_SHOP_MODE = true 
GOLD_PER_TICK = 10
STARTING_GOLD = 6000
local globalMeepo = nil;
local globalMonkey = nil;
local monkeyCount = 0;



LinkLuaModifier("modifier_core_courier", LUA_MODIFIER_MOTION_NONE)

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()

end

function CAddonTemplateGameMode:InitGameMode()
	

	--Convars:RegisterCommand( "asd", Dynamic_Wrap(CAddonTemplateGameMode, 'ExampleConsoleCommand'), "A console command example", 0 )

	-- if GetMapName() == "10vs10" then
	-- 	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 10)
	-- 	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 10)
	-- end
	self.couriers = {}

	--GameRules:GetGameModeEntity():SetFixedRespawnTime(20)
	GameRules:SetStrategyTime( STRATEGY_TIME )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetStartingGold(STARTING_GOLD)
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	--GameRules:SetCustomGameSetupTimeout(60)
	GameRules:SetGoldPerTick(GOLD_PER_TICK)

	-- GameRules:SetSameHeroSelectionEnabled(true)

	-- ListenToGameEvent("player_chat", Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerChat'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(CAddonTemplateGameMode, 'OnConnectFull'), self)
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CAddonTemplateGameMode, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( CAddonTemplateGameMode, "OnPickedHero" ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CAddonTemplateGameMode, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CAddonTemplateGameMode, "OnNPCKilled" ), self )
	

	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

end
function CAddonTemplateGameMode:OnConnectFull(keys)
	CAddonTemplateGameMode:CaptureGameMode()


end
function CAddonTemplateGameMode:CaptureGameMode()
	if mode == nil then
		mode = GameRules:GetGameModeEntity()

		mode:SetTowerBackdoorProtectionEnabled( true )

	end
end

--[[
function CAddonTemplateGameMode:ExampleConsoleCommand()
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			-- Do something here for the player who called this command
			--PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
			CreateItem('item_courier', playerID, playerID)
		end
	end
	print( '*********************************************' )
end
]]

function CAddonTemplateGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
 	--print ("stat changed")
 	--print (nNewState)
	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameRules:SetCustomGameSetupAutoLaunchDelay( 10 )
	end

	if nNewState == 6 then

	end
	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then


	end
end

               

function CAddonTemplateGameMode:buffTowers()
	
    local buffTowers = 1.2


    local towers = Entities:FindAllByClassname('npc_dota_tower')
    -- Loop over all ents
    for k,tower in pairs(towers) do
        tower:SetBaseDamageMax(tower:GetBaseDamageMax() * buffTowers)
        tower:SetBaseDamageMin(tower:GetBaseDamageMin() * buffTowers)

        tower:SetMaxHealth(tower:GetBaseMaxHealth() * buffTowers)
        tower:SetBaseMaxHealth(tower:GetBaseMaxHealth() * buffTowers) 
        tower:SetHealth(tower:GetBaseMaxHealth() * buffTowers)
		
		tower:SetPhysicalArmorBaseValue(tower:GetPhysicalArmorBaseValue() * buffTowers)
        -- print("tower ",tower:GetName() )
    end

    local buildings = Entities:FindAllByClassname('npc_dota_building')
    -- Loop over all ents
    for k,building in pairs(buildings) do

        building:SetMaxHealth(building:GetBaseMaxHealth() * buffTowers)
		building:SetBaseMaxHealth(building:GetBaseMaxHealth() * buffTowers) 
        building:SetHealth(building:GetBaseMaxHealth() * buffTowers)
        building:SetPhysicalArmorBaseValue(building:GetPhysicalArmorBaseValue() * buffTowers)
    end

    local racks = Entities:FindAllByClassname('npc_dota_barracks')
    -- Loop over all ents
    for k,rack in pairs(racks) do
        rack:SetMaxHealth(rack:GetBaseMaxHealth() * buffTowers)
		rack:SetBaseMaxHealth(rack:GetBaseMaxHealth() * buffTowers) 
        rack:SetHealth(rack:GetBaseMaxHealth() * buffTowers)
             rack:SetPhysicalArmorBaseValue(rack:GetPhysicalArmorBaseValue() * buffTowers)
  
    end

    local forts = Entities:FindAllByClassname('npc_dota_fort')
    -- Loop over all ents
    for k,fort in pairs(forts) do
    	fort:SetMaxHealth(fort:GetBaseMaxHealth() * buffTowers)
		fort:SetBaseMaxHealth(fort:GetBaseMaxHealth() * buffTowers) 

        fort:SetHealth(fort:GetBaseMaxHealth() * buffTowers)
         fort:SetPhysicalArmorBaseValue(fort:GetPhysicalArmorBaseValue() * buffTowers)
  
    end

end
-- function CAddonTemplateGameMode:test()
-- 	   --  local towers = Entities:FindAllByClassname('npc_dota_tower')
--     -- -- Loop over all ents
--     -- for k,tower in pairs(towers) do
--     --     tower:SetPhysicalArmorBaseValue(123)


--     --     -- print("tower ",tower:GetName() )
--     -- end
-- end

-- function CAddonTemplateGameMode:OnPlayerChat(keys)
--     -- local text = keys.text
--     -- if string.match(text, "-gold") or string.match(text, "-lvlup") then

--     --   GameState:CheatCommandUsed()
--     -- end
--     --local userID = keys.userid
	
--     -- CAddonTemplateGameMode:test()
  
-- end
function CAddonTemplateGameMode:OnNPCKilled( event )
	local hero = EntIndexToHScript( event.entindex_killed )
	local attacker = nil
	                         
	local addTime = 0
	if event.entindex_attacker ~= nil then
		attacker = EntIndexToHScript( event.entindex_attacker )
	end

    if IsValidEntity(hero) then


	    if hero:IsRealHero() and not hero:IsReincarnating() then


		    -- respawn time is the number of deaths * 5

	            if event.entindex_inflictor ~= nil then
	                local inflictor_index = event.entindex_inflictor
	                if inflictor_index ~= nil then
	                    local ability = EntIndexToHScript( event.entindex_inflictor )
	                    if ability ~= nil then
	                        if ability:GetAbilityName() ~= nil then
	                            if ability:GetAbilityName() == "necrolyte_reapers_scythe" then
	                              
	                           	addTime = 20
	                            end
	                        end
	                    end
	                end
	            end

		    if hero:GetUnitName() ~= "npc_dota_hero_meepo" then 
		    	-- print ("fixing ".. hero:GetUnitName())
				hero:SetTimeUntilRespawn((hero:GetDeaths() * 5) + addTime)
		
			else
				--print ("global meepo=",globalMeepo)
				if not globalMeepo:IsReincarnating() then
					globalMeepo:SetTimeUntilRespawn((hero:GetDeaths() * 5) + addTime)
				end
			end
		end
		
	end
end
--[[	
	local givenFreeCouriers = {}
	function CAddonTemplateGameMode:giveCour( hero )
		local team = hero:GetTeam()

        if not givenFreeCouriers[team] then
	        	--print("doing the thing")
	        givenFreeCouriers[team] = true
	       
	        --print("team = ",team)
	        --print("givenFreeCouriers = ",givenFreeCouriers[team])
			--print("giving cour to",hero)
			local item = CreateItem("item_courier", hero, hero)
			hero:AddItem(item)

			local playerID = hero:GetPlayerOwnerID()    
	        hero:CastAbilityImmediately(item, playerID)
			local flyingItem = CreateItem('item_flying_courier', hero, hero)
	        if flyingItem then
	        	hero:AddItem(flyingItem)
	        end
         end
	end
]]
local rosh = nil
function CAddonTemplateGameMode:OnNPCSpawned( event )
local hero = EntIndexToHScript( event.entindex )
	-- print (hero:GetUnitName(), " spawned")

	if hero:GetUnitName() == "npc_dota_roshan" then
		-- print("Roshan spawned")
		rosh = hero
		CAddonTemplateGameMode:buffRosh()

	end
end
function CAddonTemplateGameMode:buffRosh()

		-- print ("Buffing rosh")
		local buffSize = 1.5
		rosh:SetBaseDamageMax(rosh:GetBaseDamageMax() * buffSize)
        rosh:SetBaseDamageMin(rosh:GetBaseDamageMin() * buffSize)
        
        rosh:SetPhysicalArmorBaseValue(rosh:GetPhysicalArmorBaseValue() * buffSize)
        -- local base = rosh:GetBaseMaxHealth()
        -- print ("base =", base)
        -- rosh:SetMaxHealth(base * buffSize)
        -- rosh:SetBaseMaxHealth(base * buffSize) 
        -- rosh:SetHealth(base * buffSize)
        -- print ("base now = ",rosh:GetBaseMaxHealth())

end
function CAddonTemplateGameMode:OnPickedHero( event )
	local hero = EntIndexToHScript( event.heroindex )

	
	if hero:IsRealHero()  then
		
		--CAddonTemplateGameMode:giveCour(hero)

		local team = hero:GetTeam()

		-- print("Hero is spawned!!!", hero:GetUnitName())
		--print ("IsClone  ", hero:IsClone())
		--hero:SetGold(6000, false)
		
		--for i=1,MAX_LEVEL do
			--hero:HeroLevelUp(true)
			--[[
			Returns:void
		Levels up the hero, true or false to play effects.
		]]
		--end
		--hero:AddItemByName("item_courier")
		--hero:AddItemByName("item_flying_courier")
		hero:AddItemByName("item_boots")
		--hero:AddItemByName("item_ultimate_scepter")
		-- hero:AddItemByName("item_blink")
		-- hero:AddItemByName("item_bottle")
		--hero:AddItemByName("item_tpscroll")
    	local level = hero:GetLevel()

    	
			
		while level < MAX_LEVEL do
			hero:AddExperience (2000,false,false)
			level = hero:GetLevel()
		end

	


		local ability = nil

		if hero:GetUnitName() == "npc_dota_hero_meepo" and globalMeepo == nil then
			
			globalMeepo = hero

		end
		if hero:GetUnitName() == "npc_dota_hero_monkey_king" and globalMonkey == nil then
			
			globalMonkey = hero

		end

    --local courier_spawn = pointToSpawn + RandomVector(RandomFloat(100, 100))

	--local team = owner:GetTeamNumber()

	TURBO_COURIER_POSITION = {}

	TURBO_COURIER_POSITION[2] = Vector(-7450, -6550+ RandomFloat(100, 100), 256)
	TURBO_COURIER_POSITION[3] = Vector(7400, 6500+ RandomFloat(100, 100), 256)

	local cr = CreateUnitByName("npc_dota_courier",TURBO_COURIER_POSITION[hero:GetTeamNumber()] , true, nil, nil, team)

	cr:SetControllableByPlayer(hero:GetPlayerID(), true)
	cr:SetOwner(hero)
	cr:AddNewModifier(cr, nil, "modifier_core_courier", {})
	for i = 0, 24 do
		local ability = cr:GetAbilityByIndex(i)

		if ability and ability:GetLevel() == 0 then
			ability:SetLevel(20)
		end
	end
	--cr:UpgradeToFlyingCourier()
		--print("hero name:",hero:GetUnitName() )
		if hero:GetUnitName() ~= "npc_dota_hero_tiny" then
		if hero:GetUnitName() ~= "npc_dota_hero_invoker" then 
		if hero:GetUnitName() ~= "npc_dota_hero_meepo" then 
					
    		for i=0,15 do
        		local ability = hero:GetAbilityByIndex(i)
        		if ability then
        			if not string.find(ability:GetAbilityName(), "special") then
					  	
            			ability:SetLevel(ability:GetMaxLevel())
            			
					end
        		end
    		end
    		hero:SetAbilityPoints(4)
    	

    	end
    	end
    	end
		
			  
--[[			local courier_spawn = {}
			courier_spawn[2] = Entities:FindByClassname(nil, "info_courier_spawn_radiant")
			courier_spawn[3] = Entities:FindByClassname(nil, "info_courier_spawn_dire")

			for team = 2, 3 do
				self.couriers[team] = CreateUnitByName("npc_dota_courier", courier_spawn[team]:GetAbsOrigin(), true, nil, nil, team)
				if _G.mainTeamCouriers[team] == nil then
					_G.mainTeamCouriers[team] = self.couriers[team]
				end
				self.couriers[team]:AddNewModifier(self.couriers[team], nil, "modifier_core_courier", {})
			end--]]
			  
	end

	

end