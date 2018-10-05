 --[[
 Commands

 Move Along: 	/ma  	: You can press E to wave the wand!
 Paparazzo: 	/pap 	: You can press E to take photos!
 Panhandle: 	/beg 	: Hold a sign asking for money!
 Salute: 		/o7 	: Salute your commrads!
 Bird 1: 		/bird 	: One hand middle Finger
 Bird 2: 		/bird2 	: 2 hands middle finger
 Surrender: 	/k 		: Kneeldown hands behind head surrender
 Facepalm: 		/palm	: Facepalm
 BongRip:		/bong	: Press E to take a fat rip!
 Cell Record:	/phoneR : Press E to take a picture! 
 Notepad:		/ticket : Press E to check your watch
 Crowd Control:	/cc		: Press E to control the crowd!
 Slow Clap:		/sc		: Slow Clap
 Umbrella:		/umb	: Pull out an umbrella on those rainy days!
 
]]--


-------Props-------
local holdingcam = false
local cammodel = "prop_pap_camera_01"
local cam_net = nil

local holdingsign = false
local signmodel = "prop_beggers_sign_01"
local sign_net = nil

local holdingwand = false
local wandmodel = "prop_parking_wand_01"
local wand_net = nil

local holdingbong = false
local bongmodel = "hei_heist_sh_bong_01"
local bong_net = nil

local holdingphoneR = false
local phoneRmodel = "prop_amb_phone"
local phoneR_net = nil

local holdingpad = false
local padmodel = "prop_notepad_02"
local pad_net = nil

local holdingumb = false
local umbmodel = "p_amb_brolly_01"
local umb_net = nil


-------------

------------- umbrella

RegisterCommand("umb",function(source, args)
	local ad1 = "amb@code_human_wander_drinking@beer@male@base"
	local ad1a = "static"
	local player = GetPlayerPed(-1)
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	local umbspawned = CreateObject(GetHashKey(umbmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(umbspawned)


	if (DoesEntityExist(player) and not IsEntityDead(player)) then 
		loadAnimDict(ad1)
		RequestModel(GetHashKey(umbmodel))
		if holdingumb then
			Wait(100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(NetToObj(umb_net), 1, 1)
			DeleteEntity(NetToObj(umb_net))
			umb_net = nil
			holdingumb = false
		else
			TaskPlayAnim(player, ad1, ad1a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
			Wait(500)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			AttachEntityToEntity(umbspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),0.0,0.0,0.0,0.0,0.0,0.0,1,1,0,1,0,1)
			Wait(120)
			umb_net = netid
			holdingumb = true
		end
	end
end, false)


------------- slowclap


RegisterCommand("sc",function(source, args)
	local clapping = false
	local ad = "anim@mp_player_intupperslow_clap"
	local ad2 = "amb@world_human_drinking@beer@male@exit"
	local ad2a = "exit"
	local player = GetPlayerPed( -1 )
	
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
		loadAnimDict( ad )
		if clapping then 
			Wait (0)
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, 5000, 49, 0, 0, 0, 0 )
			clapping = true
			Wait (5000)
			clapping = false
		end     
	end

	
end, false)



------------- ticket

RegisterCommand("ticket",function(source, args)

	local player = GetPlayerPed(-1)
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	local padspawned = CreateObject(GetHashKey(padmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(padspawned)
	local ad = "amb@medic@standing@timeofdeath@enter"
	local ad2 = "amb@medic@standing@timeofdeath@base"
	local ad3 = "amb@medic@standing@timeofdeath@exit"
	local ad4 = "amb@medic@standing@timeofdeath@idle_a" -- use idle_b for anim(check watch)

	if (DoesEntityExist(player) and not IsEntityDead(player)) then ---------------------If playing then cancel
		loadAnimDict(ad)
		loadAnimDict(ad2)
		loadAnimDict(ad3)
		loadAnimDict(ad4)
		if holdingpad then
			TaskPlayAnim(player, ad3, "exit", 8.0, 1.0, -1, 50, 0, 0, 0, 0)
			Wait(5330)
			DetachEntity(NetToObj(pad_net), 1, 1)
			DeleteEntity(NetToObj(pad_net))
			Wait(2500)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			pad_net = nil
			holdingpad = false
		else
			Wait(500) ---------------------if not playing, then play
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			TaskPlayAnim( player, ad, "enter", 8.0, 1.0, -1, 50, 0, 0, 0, 0 )
			Wait (3000)																							--28422
			AttachEntityToEntity(padspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),0.0,0.0,0.0,0.0,360.0,0.0,1,1,0,1,0,1)
			Wait(1310)
			DetachEntity(NetToObj(pad_net), 1, 1)
			DeleteEntity(NetToObj(pad_net))
 			AttachEntityToEntity(padspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 18905),0.1,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
			-- Wait(120)
			Notification("Press ~r~[E]~w~ check the time.")
			pad_net = netid
			holdingpad = true
		end
	end

	while holdingpad do
		Wait(0)
		if IsControlJustPressed(0, 38) then
			Notification("Your watch is broken...")
			Wait(500)
			TaskPlayAnim( player, ad4, "idle_b", 8.0, 1.0, -1, 50, 0, 0, 0, 0 )
		end
	end
end, false)


------------- mobile phone record

RegisterCommand("phoneR",function(source, args)

	local player = GetPlayerPed(-1)
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	local phoneRspawned = CreateObject(GetHashKey(phoneRmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(phoneRspawned)
	local ad = "amb@world_human_mobile_film_shocking@male@enter"
	local ad2 = "amb@world_human_mobile_film_shocking@male@base"
	local ad3 = "amb@world_human_mobile_film_shocking@male@exit"
	local pd = "core" 
	local pn = "ent_anim_paparazzi_flash"

	if (DoesEntityExist(player) and not IsEntityDead(player)) then ---------------------If playing then cancel
		loadAnimDict(ad)
		loadAnimDict(ad2)
		loadAnimDict(ad3)
		RequestPtfxAsset(pd)
		RequestModel(GetHashKey(phoneRmodel))
		if holdingphoneR then
			TaskPlayAnim(player, ad3, "exit", 8.0, 1.0, -1, 50, 0, 0, 0, 0)
			Wait(1840)
			DetachEntity(NetToObj(phoneR_net), 1, 1)
			DeleteEntity(NetToObj(phoneR_net))
			Wait(750)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			phoneR_net = nil
			holdingphoneR = false
		else
			Wait(500) ---------------------if not playing, then play
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			TaskPlayAnim( player, ad, "enter", 8.0, 1.0, -1, 50, 0, 0, 0, 0 )
			Wait (1260)
			AttachEntityToEntity(phoneRspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
			-- Wait(1310)
 			-- TaskPlayAnim( player, ad2, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			-- Wait(120)
			Notification("Press ~r~[E]~w~ to take a picture!")
			phoneR_net = netid
			holdingphoneR = true
		end
	end

	while holdingphoneR do
		Wait(0)
		if IsControlJustPressed(0, 38) then
			Notification("Click Click")
			Wait(500)
			UseParticleFxAssetNextCall(pd)
			StartParticleFxNonLoopedOnEntity(pn, phoneRspawned, 0.0	, 0.1, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0)
		end
	end
end, false)

-----------  BongRips

RegisterCommand("bong",function(source, args)
	local ad1 = "anim@safehouse@bong"
	local ad1a = "bong_stage1"
	local player = GetPlayerPed(-1)
	local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	local bongspawned = CreateObject(GetHashKey(bongmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	local netid = ObjToNet(bongspawned)


	if (DoesEntityExist(player) and not IsEntityDead(player)) then 
		loadAnimDict(ad1)
		RequestModel(GetHashKey(bongmodel))
		if holdingbong then
			Wait(100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(NetToObj(bong_net), 1, 1)
			DeleteEntity(NetToObj(bong_net))
			bong_net = nil
			holdingbong = false
		else
			Wait(500)
			SetNetworkIdExistsOnAllMachines(netid, true)
			NetworkSetNetworkIdDynamic(netid, true)
			SetNetworkIdCanMigrate(netid, false)
			AttachEntityToEntity(bongspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 18905),0.10,-0.25,0.0,95.0,190.0,180.0,1,1,0,1,0,1)
			Wait(120)
			Notification("Press ~r~[E]~w~ to take a toke!")
			bong_net = netid
			holdingbong = true
		end
	end

	while holdingbong do
		Wait(0)
		local plyCoords2 = GetEntityCoords(player, true)
		local head = GetEntityHeading(player)
		if IsControlJustPressed(0, 38) then
			TaskPlayAnimAdvanced(player, ad1, ad1a, plyCoords2.x, plyCoords2.y, plyCoords2.z, 0.0, 0.0, head, 8.0, 1.0, 4000, 49, 0.25, 0, 0)
			Wait(100)
			Notification("You take a huge rip!")
			Wait(7250)
			TaskPlayAnim(player, ad2, ad2a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
		end
	end
end, false)



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

	local camnoti = {
		"~g~Smile~w~!",
		"Say ~y~cheese~w~!",
		"~y~Cheeeeeeeeese~w~!!!",
		"You look ~g~great~w~!",
		"~g~F~b~u~r~n~y~n~g~y ~g~f~b~a~r~c~g~e~w~!!!"
	}
	local camnotiRnd = math.random(1, 5)

	while holdingcam do
		Wait(0)
		if IsControlJustPressed(0, 38) then
			Wait(100)
			Notification(camnoti[camnotiRnd])
			Wait(100)
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
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
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
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
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
		else
			TaskPlayAnim( player, ad, "idle_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
		end     
	end
end, false)


--------------------Crowd Control
local control = false
local control2 = false
RegisterCommand("cc",function(source, args)


	local ad1 = "amb@code_human_police_crowd_control@base" -- only anim in ad -> "base"

	local ad2 = "amb@code_human_police_crowd_control@idle_a"
	local ad2a = "idle_a"
	local ad2b = "idle_b"
	local ad2c = "idle_c"

	local ad3 = "amb@code_human_police_crowd_control@idle_b"
	local ad3d = "idle_d"
	local ad3e = "idle_e"
	local ad3f = "idle_f"

	local adex = "anim@mp_player_intselfiethe_bird" --what im using to exit the anim

	local player = GetPlayerPed(-1)

	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
		loadAnimDict( ad1 )
		loadAnimDict( ad2 )
		loadAnimDict( ad3 )
		loadAnimDict( adex )
		if ( IsEntityPlayingAnim( player, ad1, "base", 3 ) ) then 
			--TaskPlayAnim( player, adex, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (100)
			ClearPedSecondaryTask(GetPlayerPed(-1))
			control = false
		else
			TaskPlayAnim( player, ad1, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			Wait (500)
			Notification("Press ~r~[E]~w~ to control the crowd!")
			control = true
		end     
	end


	local conAnimRnd = math.random(1, 3)
	local conAnim2Rnd = math.random(1, 3)
	local connotiRnd = math.random(1, 6)

	local conAnim = {
		ad2a,
		ad2b,
		ad2c
	}

	local conAnim2 = {
		ad3d,
		ad3e,
		ad3f
	}

	local connoti = {
		"Calm down people!",
		"Whoa, just take it easy, man!",
		"Hey. HEY! Back up!",
		"Everyone just remain calm.",
		"Hey, cut the shit!",
		"Everyone just take it down a notch!"
	}

	local fin = false
	while control do
		Wait(0)
		if IsControlJustPressed(0, 38) then
			Wait(100)
			Notification(connoti[connotiRnd])
			Wait(100)

			if connotiRnd <= 3 then
				TaskPlayAnim(player, ad2, conAnim[conAnimRnd], 8.0, -8.0, -1, 50, 0, 0, 0, 0)
			elseif connotiRnd >= 4 then
				TaskPlayAnim(player, ad3, conAnim2[conAnim2Rnd], 8.0, -8.0, -1, 50, 0, 0, 0, 0)
				if IsEntityPlayingAnim(player, ad2, ad2a, 3) then
					Wait(11000)
					fin = true
				elseif IsEntityPlayingAnim(player, ad2, ad2b, 3) then
					Wait(13000)
					fin = true
				elseif IsEntityPlayingAnim(player, ad2, ad2c, 3) then
					Wait(5050)
					fin = true
				elseif IsEntityPlayingAnim(player, ad3, ad3d, 3) then
					Wait(10900)
					fin = true
				elseif	IsEntityPlayingAnim(player, ad3, ad3e, 3) then
					Wait(9750)
					fin = true
				elseif IsEntityPlayingAnim(player, ad3, ad3f, 3) then
					Wait(8000)
					fin = true
				end
				if fin then
					TaskPlayAnim(player, ad1, "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
					Wait(1000)
					fin = false
				end
			end
		end
	end
end, false)


----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------ functions -----------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
function Notification(message)  --- default gta notification
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

function DrawMissionText2(m_text, showtime) --subtitles
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end
