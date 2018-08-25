local holdingcam = false
local cammodel = "prop_pap_camera_01"
local cam_net = nil
local holdingsign = false
local signmodel = "prop_beggers_sign_01"
local sign_net = nil


RegisterCommand('pap', function(source, args)

	local ad1 = "amb@world_human_paparazzi@male@enter"
	local ad2 = "amb@world_human_paparazzi@male@idle_a"
	local ad3 = "amb@world_human_paparazzi@male@base"
	local ad4 = "amb@world_human_paparazzi@male@exit"
	local ad1a = "enter"
	local ad2a = "idle_a"
	local ad2b = "idle_b"
	local ad2c = "idle_c"
	local ad3a = "base"
	local ad4a = "exit"
	local player = GetPlayerPed( -1 )
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local camspawned = CreateObject(GetHashKey(cammodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(camspawned)
	
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 											---------------------If playing then cancel
		loadAnimDict( ad1 )
		loadAnimDict( ad2 )
		loadAnimDict( ad3 )
		loadAnimDict( ad4 )
		RequestModel(GetHashKey(cammodel))
			if ( IsEntityPlayingAnim( player, ad3, ad3a, 3 ) ) then
				TaskPlayAnim( player, ad4, ad4a, 8.0, 1.0, -1, 49, 0, 0, 0, 0  )
				Wait (100)
				ClearPedSecondaryTask(GetPlayerPed(-1))
				DetachEntity(NetToObj(cam_net), 1, 1)
				DeleteEntity(NetToObj(cam_net))
				cam_net = nil
				holdingcam = false
			else							
			TaskPlayAnim( player, ad1, ad1a, 8.0, 1.0, -1, 49, 0, 0, 0, 0  )
			Wait (500)													---------------------if not playing, then play
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)																	--- | x,y,z, x rotation, y rotation, z rotation, no idea
			AttachEntityToEntity(camspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.005, 0.0, 0.0, 360.0, 360.0, 0.0, 1, 1, 0, 1, 0, 1)
			Wait (960)
			TaskPlayAnim( player, ad3, ad3a, 8.0, 1.0, -1, 49, 0, 0, 0, 0  )
			Notification("Press ~r~[E]~w~ to take photos.")
			cam_net = netid
			holdingcam = true
		end     
	end
end, false )

RegisterCommand('beg', function(source, args)

	local ad1 = "amb@world_human_bum_freeway@male@base"
	local ad4 = "amb@world_human_drinking@beer@male@exit"
	local ad1base = "base"
	local player = GetPlayerPed( -1 )
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
    local signspawned = CreateObject(GetHashKey(signmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(signspawned)
	
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 											---------------------If playing then cancel
		loadAnimDict( "amb@world_human_bum_freeway@male@base" )
		loadAnimDict( "amb@world_human_bum_freeway@male@idle_a" )
		loadAnimDict( "amb@world_human_bum_freeway@male@idle_b" )
		RequestModel(GetHashKey(signmodel))
		    if ( IsEntityPlayingAnim( player, "amb@world_human_bum_freeway@male@base", "base", 3 ) ) then 
				TaskPlayAnim( player, ad4, "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Wait (100)
				ClearPedSecondaryTask(GetPlayerPed(-1))
				DetachEntity(NetToObj(sign_net), 1, 1)
				DeleteEntity(NetToObj(sign_net))
				sign_net = nil
				holdingsign = false
			else																				---------------------if not playing, then play
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)																	--- | x,y,z, x rotation, y rotation, z rotation, no idea
			AttachEntityToEntity(signspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.005, 0.0, 0.0, 360.0, 360.0, 0.0, 1, 1, 0, 1, 0, 1)
			sign_net = netid
			holdingsign = true
			TaskPlayAnim( player, ad1, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0  )
			DrawMissionText2("~r~Beggars~w~ can't be ~b~Choosers~w~.", 5000)
			Wait (1000)
		end     
    end
end, false )


----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ Question ---------------- -------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

--Do the extra animations and particles need to be in the same block as the /pap animation itself?


----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ cam animations and flash? -------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

-- local camani = {
-- 	"ad2a",
-- 	"ad2b",
-- 	"ad2c"
-- }
-- local camaniRnd = math.random( 1, 3)
-- local pd = "core"						--Future, add particle effects(flashes for camera)
-- local pn = "ent_anim_paparazzi_flash"
-- local TakingPics = false
----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ adding a flash? -----------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- Citizen.CreateThread( function()
-- 	while TakingPics do
-- 	Citizen.Wait(100)
-- 		if IsControlJustPressed(1, 38)  then
-- 			Wait (500)
-- 			UseParticleFxAssetNextCall( pd )
-- 			Wait (100)
-- 			StartParticleFxNonLoopedOnEntity( pn, cammodel, -0.715, 0.005, 0.0, 0.0, 25.0, 25.0, 0.75, 0.0, 0.0, 0.0) --startParticleFxNonLoopedOnEntity(effectName, entity, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, scale, axisX, axisY, axisZ)
-- 		elseif IsControlJustReleased(1, 38)  then
-- 			RemoveParticleFxFromEntity(cammodel)
-- 			Wait (100)
-- 		end
-- 	end
-- end


-- Citizen.CreateThread(function()
-- 	while holdingcam do
-- 		Citizen.Wait(0)
-- 		RequestAnimDict( ad2 )
-- 		RequestAnimDict( ad3 )
-- 		if ( IsEntityPlayingAnim( player, ad3, ad3a, 3 ) ) then
-- 			if IsControlPressed(1, 38) then
-- 				if DoesEntityExist(player) then
-- 					Citizen.CreateThread(function()
-- 						RequestAnimDict(ad2)
-- 						while not HasAnimDictLoaded(ad2) do
-- 							Citizen.Wait(100)
-- 						end

-- 						if not TakingPics then
-- 							TakingPics = true
-- 							TaskPlayAnim( player, ad2, camani[camaniRnd], 8.0, -8, -1, 49, 0, 0, 0, 0 )
-- 						end   
-- 					end)
-- 				end
-- 			end
-- 		end
-- 		if IsControlReleased(1, 38) then
-- 			if DoesEntityExist(player) then
-- 				Citizen.CreateThread(function()
-- 					RequestAnimDict(ad3)
-- 					while not HasAnimDictLoaded(ad3) do
-- 						Citizen.Wait(100)
-- 					end

-- 					if TakingPics then
-- 						TakingPics = false
-- 						TaskPlayAnim( player, ad3, ad3a, 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
-- 					end
-- 				end)
-- 			end
-- 		end
-- 	end
-- end)


----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ take pictures anim -----------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- local camani = {
-- 	"idle_a",
-- 	"idle_b",
-- 	"idle_c"
-- }
-- local camaniPos = math.random(1,3)

-- if holdingcam = true then
-- 	loadAnimDict( ad2 )
-- 	loadAnimDict( ad3 )
-- 	Notification("Press E to take photos.")
-- 	if IsControlJustPressed(1, 38) then
-- 		TaskPlayAnim( player, ad2, camani[camaniPos], 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
-- 	elseif IsControlJustReleased(1, 38) then
-- 		TaskPlayAnim( player, ad3, ad3a, 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
-- 	end
-- end
-- end
----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ another possibility -----------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ functions -----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
function Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0, 0)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function DrawMissionText2(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end
