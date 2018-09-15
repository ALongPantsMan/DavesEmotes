-- Commands
-- Move Along: 	/ma  	: You can press E to wave the wand!
-- Paparazzo: 	/pap 	: You can press E to take photos!(cosmetic)
-- Panhandle: 	/beg 	: Hold a sign asking for money!
-- Salute: 		/o7 	: Salute your commrads!
-- Bird 1: 		/bird 	: One hand middle Finger
-- Bird 2: 		/bird2 	: 2 hands middle finger
-- Surrender: 	/k 		: Kneeldown hands behind head surrender
-- Facepalm: 	/palm	: Facepalm


-- Sorry for the wonky formatting down there... I installed a lua formatter and VS code did that. I tried to clean it up as best i could.

local holdingcam = false
local cammodel = "prop_pap_camera_01"
local cam_net = nil
local holdingsign = false
local signmodel = "prop_beggers_sign_01"
local sign_net = nil
local holdingwand = false
local wandmodel = "prop_parking_wand_01"
local wand_net = nil

---------------------------------- Move Along(car park attendent)
--prop_parking_wand_01
RegisterCommand("ma",function(source, args)
	local ad1 = "amb@world_human_car_park_attendant@male@base"
	local ad1a = "base"
	local ad2 = "amb@world_human_drinking@beer@male@exit"
	local ad2a = "exit"
	local player = GetPlayerPed(-1)
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	local wandspawned = CreateObject(GetHashKey(wandmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(wandspawned)


	if (DoesEntityExist(player) and not IsEntityDead(player)) then ---------------------If playing then cancel
		loadAnimDict(ad1)
		loadAnimDict(ad2)
		RequestModel(GetHashKey(wandmodel))
		if holdingwand then
			Wait(100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(NetToObj(wand_net), 1, 1)
			DeleteEntity(NetToObj(wand_net))
			wand_net = nil
			holdingwand = false
		else
			Wait(500) ---------------------if not playing, then play
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false) --- | x,y,z, x rotation, y rotation, z rotation, no idea
			AttachEntityToEntity(wandspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
			Wait(120)
			Notification("Press ~r~[E]~w~ to wave the wand.")
			wand_net = netid
			holdingwand = true
		end
	end

	while holdingwand do
		Wait(0)

		local noti = {
			"Nothing to see here, lets move along.",
			"Keep it moving!",
			"Ugh, why did I pick traffic control..",
			"Lets go already!",
			"Will yinz hurry up!!"
		}
		local notiRnd = math.random(1, 5)


		if IsControlJustPressed(0, 38) then
			TaskPlayAnim(player, ad1, ad1a, 8.0, 1.0, 5000, 49, 0, 0, 0, 0)
			Wait(100)
			Notification(noti[notiRnd])
		end
	end
end, false)
--------------------------- camera anim
RegisterCommand("pap",function(source, args)
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
	local player = GetPlayerPed(-1)
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	local camspawned = CreateObject(GetHashKey(cammodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(camspawned)
	local camani = {
		ad2a,
		ad2b,
		ad2c
	}
	local camaniRnd = math.random(1, 3)
	local pd = "core" 
	local pn = "ent_anim_paparazzi_flash"
	local takingpics = false

	if (DoesEntityExist(player) and not IsEntityDead(player)) then ---------------------If playing then cancel
		loadAnimDict(ad1)
		loadAnimDict(ad2)
		loadAnimDict(ad3)
		loadAnimDict(ad4)
		RequestModel(GetHashKey(cammodel))
		if (IsEntityPlayingAnim(player, ad3, ad3a, 3)) then
			TaskPlayAnim(player, ad4, ad4a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
			Wait(100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(NetToObj(cam_net), 1, 1)
			DeleteEntity(NetToObj(cam_net))
			cam_net = nil
			holdingcam = false
		else
			TaskPlayAnim(player, ad1, ad1a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
			Wait(520) ---------------------if not playing, then play
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false) --- | x,y,z, x rotation, y rotation, z rotation, no idea
			AttachEntityToEntity(camspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
			Wait(120)
			TaskPlayAnim(player, ad3, ad3a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
			Notification("Press ~r~[E]~w~ to take photos.")
			cam_net = netid
			holdingcam = true
		end
	end

	while holdingcam do
		Wait(0)
		if IsControlJustPressed(0, 38) then
			TaskPlayAnim(player, ad2, camani[camaniRnd], 8.0, -8, -1, 49, 0, 0, 0, 0)
			Wait(100)
			if IsEntityPlayingAnim(player, ad2, ad2a, 49) then
				RequestPtfxAsset( pd )
				Wait(880)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(1300)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(2140)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(1580)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(2700)
			elseif IsEntityPlayingAnim(player, ad2, ad2b, 49) then
				RequestPtfxAsset( pd )
				Wait(2550)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(2410)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(200)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(100)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(3340)
			elseif IsEntityPlayingAnim(player, ad2, ad2c, 49) then
				RequestPtfxAsset( pd )
				Wait(500)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(4150)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(100)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(200)
				UseParticleFxAssetNextCall(pd)
				StartParticleFxNonLoopedOnEntity(pn, camspawned, 0.1, -0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
				Wait(1620)
			end
			TaskPlayAnim(player, ad3, ad3a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
		end
	end
end, false)
--startParticleFxNonLoopedOnEntity(effectName, entity, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, scale, axisX, axisY, axisZ)

RegisterCommand(
	"beg",
	function(source, args)
		local ad1 = "amb@world_human_bum_freeway@male@base"
		local ad4 = "amb@world_human_drinking@beer@male@exit"
		local ad1base = "base"
		local player = GetPlayerPed(-1)
		local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
		local signspawned = CreateObject(GetHashKey(signmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
		local netid = ObjToNet(signspawned)

		if (DoesEntityExist(player) and not IsEntityDead(player)) then ---------------------If playing then cancel
			loadAnimDict("amb@world_human_bum_freeway@male@base")
			loadAnimDict("amb@world_human_bum_freeway@male@idle_a")
			loadAnimDict("amb@world_human_bum_freeway@male@idle_b")
			RequestModel(GetHashKey(signmodel))
			if (IsEntityPlayingAnim(player, "amb@world_human_bum_freeway@male@base", "base", 3)) then
				TaskPlayAnim(player, ad4, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
				Wait(100)
				ClearPedSecondaryTask(GetPlayerPed(-1))
				DetachEntity(NetToObj(sign_net), 1, 1)
				DeleteEntity(NetToObj(sign_net))
				sign_net = nil
				holdingsign = false
			else ---------------------if not playing, then play
				SetNetworkIdExistsOnAllMachines(netid, true)
				NetworkSetNetworkIdDynamic(netid, true)
				SetNetworkIdCanMigrate(netid, false) --- | x,y,z, x rotation, y rotation, z rotation, no idea
				AttachEntityToEntity(
					signspawned, --first thing you want
					GetPlayerPed(PlayerId()), --second thing you want
					GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -- where to attach it to the player :: https://wiki.■■■■■■■■■■■/index.php?title=Bones
					-0.005, --offset x (left right)
					0.0, --offset y (forward back)
					0.0,--offset z (huh doi)
					360.0, --rotations x
					360.0, -- y 
					0.0, -- z
					1,
					1,
					0,
					1,
					0,
					1
				) --(Entity entity1, Entity entity2, int boneIndex, float xPos, float yPos, float zPos, float xRot, float yRot, float zRot, BOOL p9, BOOL useSoftPinning, BOOL collision, BOOL isPed, int vertexIndex, BOOL fixedRot)
				sign_net = netid
				holdingsign = true
				TaskPlayAnim(player, ad1, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
				DrawMissionText2("~r~Beggars~w~ can't be ~b~Choosers~w~.", 5000)
				Wait(1000)
			end
		end
	end,
	false)

	-- Hands Up, kneel down surrender. Originial was created by @Cosharek on the FiveM Forums. I just made it work as a standalone instead of just ESX
	local surrendered = false

	RegisterCommand("k",function(source, args)
		local player = GetPlayerPed( -1 )
		if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
			loadAnimDict( "random@arrests" )
			loadAnimDict( "random@arrests@busted" )
			if ( IsEntityPlayingAnim( player, "random@arrests@busted", "idle_a", 3 ) ) then 
				TaskPlayAnim( player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Wait (3000)
				TaskPlayAnim( player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
				surrendered = false
			else
				TaskPlayAnim( player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Wait (4000)
				TaskPlayAnim( player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Wait (500)
				TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
				Wait (1000)
				TaskPlayAnim( player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
				Wait(100)
				surrendered = true
			end     
		end
	end, false)
	
	Citizen.CreateThread(function() --disabling controls while surrendured
		while surrendered do
			Citizen.Wait(0)
			if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests@busted", "idle_a", 3) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(0,21,true)
			end
		end
	end)
---------------------------------------Salute Anim 



RegisterCommand("o7",function(source, args)

	local ad = "anim@mp_player_intuppersalute"
	local player = GetPlayerPed( -1 )
	
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, "idle_a", 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (600)
			ClearPedSecondaryTask(GetPlayerPed(-1))
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
		end     
	end
end, false)

--------------------------------2 Middle Fingers

RegisterCommand("bird2",function(source, args)

	local ad = "anim@mp_player_intupperfinger"
	local player = GetPlayerPed( -1 )
	
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, "idle_a", 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			salute = false
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
			salute = true
		end     
	end
end, false)

------------------------Facepalm

RegisterCommand("palm",function(source, args)

	local ad = "anim@mp_player_intupperface_palm"
	local player = GetPlayerPed( -1 )
	
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, "idle_a", 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			salute = false
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
			salute = true
		end     
	end
end, false)

----------------------- One middle Finger


RegisterCommand("bird",function(source, args)

	local ad = "anim@mp_player_intselfiethe_bird"
	local player = GetPlayerPed( -1 )
	
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, "idle_a", 3 ) ) then 
			TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			salute = false
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
			salute = true
		end     
	end
end, false)



----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ functions -----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
function Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0, 0)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function DrawMissionText2(m_text, showtime)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end
