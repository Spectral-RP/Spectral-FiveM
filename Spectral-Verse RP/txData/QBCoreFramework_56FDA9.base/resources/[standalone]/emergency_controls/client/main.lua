----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--          [Emergency Controls] by LazarusRising @LazarusRising#0001           --
--                      <@lazarusofthefallen@gmail.com>                         --
--                      Copyright 2020-2022 David Miles                         --
----------------------------------------------------------------------------------
--                   This resource is only sold on modit.store                  --
----------------------------------------------------------------------------------
--    Please do not redistribute this code. I will never grant permission to    --
--        redistribute this code, so any claims of permission are false.        --
--                                                                              --
-- https://modit.store/collections/lazarus-products/products/emergency_controls --
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--                                 VARIABLES                                    --
----------------------------------------------------------------------------------

local controllerActive, inVehicle, controlsDisabled, inMenu, hudActive, nuiReady = false, false, false, false, false, false
local savedVehicle = nil
local currentMode = 0
local overrideLib, override, sirenStates, sound, lightStates, hornStates = {}, {}, {}, {}, {}, {}

----------------------------------------------------------------------------------
--                                 FUNCTIONS                                    --
----------------------------------------------------------------------------------

function isAmbulance(vehicle)
	local model = GetEntityModel(vehicle)

	for i = 1, #Config.Firetrucks, 1 do
		if model == GetHashKey(Config.Firetrucks[i]) then
			return true
		end
	end

	return false
end

function isFiretruck(vehicle)
	local model = GetEntityModel(vehicle)

	for i = 1, #Config.Ambulances, 1 do
		if model == GetHashKey(Config.Ambulances[i]) then
			return true
		end
	end

	return false
end

function siren(id, state)
	if id and inVehicle and savedVehicle and DoesEntityExist(savedVehicle) then
		local vehicleNetId = VehToNet(savedVehicle)

		if vehicleNetId then
			local sentOverride = nil
			
			if override[id] then sentOverride = override[id] end

			TriggerServerEvent('emergency_controls:siren', id, vehicleNetId, state, sentOverride)
		end
	end
end

function muteDefaultSirens(vehicle)
	if vehicle and DoesEntityExist(vehicle) then
		local vehicleNetId = VehToNet(vehicle)

		if vehicleNetId then
			TriggerServerEvent('emergency_controls:muteDefaultSirens', vehicleNetId)
		end
	end
end

----------------------------------------------------------------------------------
--                                    EVENTS                                    --
----------------------------------------------------------------------------------

RegisterNetEvent('emergency_controls:lights', function(vehicleNetId, state)
	if vehicleNetId then
		local vehicle = NetToVeh(vehicleNetId)

		if vehicle and DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
			if state then
				lightStates[vehicle] = true
				SetVehicleSiren(vehicle, true)
			else
				lightStates[vehicle] = false
				SetVehicleSiren(vehicle, false)
			end
		end
	end
end)

RegisterNetEvent('emergency_controls:siren', function(id, vehicleNetId, state, sentOverride, audioRef)
	local vehicle = NetToVeh(vehicleNetId)

	if vehicle and DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		if not sound[vehicle] then sound[vehicle] = {} end
		if not sound[vehicle][id] then sound[vehicle][id] = GetSoundId() end
		if not sirenStates[vehicle] then sirenStates[vehicle] = {} end

		if state == 1 then
			if not sirenStates[vehicle][id] then
				if sentOverride then
					local soundToPlay = sentOverride
					local audioRef = nil

					if Config.AvailableSirensAudioRef[sentOverride] then audioRef = Config.AvailableSirensAudioRef[sentOverride] end

					if audioRef then
						PlaySoundFromEntity(sound[vehicle][id], soundToPlay, vehicle, audioRef, 0, 0)
					else
						PlaySoundFromEntity(sound[vehicle][id], soundToPlay, vehicle, 0, 0, 0)
					end
				else
					local soundToPlay = Config.DefaultPoliceSirens[id]
					local audioRef = nil

					if isFiretruck(vehicle) then soundToPlay = Config.DefaultFiretruckSirens[id]	elseif isAmbulance(vehicle) then soundToPlay = Config.DefaultAmbulanceSirens[id] end
					if Config.AvailableSirensAudioRef[soundToPlay] then	audioRef = Config.AvailableSirensAudioRef[soundToPlay] end

					if audioRef then
						PlaySoundFromEntity(sound[vehicle][id], soundToPlay, vehicle, audioRef, 0, 0)
					else
						PlaySoundFromEntity(sound[vehicle][id], soundToPlay, vehicle, 0, 0, 0)
					end
				end

				sirenStates[vehicle][id] = true
			end
		else
			if sound[vehicle][id] then
				StopSound(sound[vehicle][id])
				ReleaseSoundId(sound[vehicle][id])
				sound[vehicle][id] = nil
			end

			sirenStates[vehicle][id] = false
		end
	end
end)

RegisterNetEvent('emergency_controls:muteSirens', function(vehicleNetId)
	local vehicle = NetToVeh(vehicleNetId)

	if vehicle and DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		for i=1,3 do
			if sound[vehicle][i] or sirenStates[vehicle][i] then
				StopSound(sound[vehicle][i])
				ReleaseSoundId(sound[vehicle][i])
				sound[vehicle][i] = nil
				sirenStates[vehicle][i] = false
			end
		end
	end
end)

RegisterNetEvent('emergency_controls:muteDefaultSirens', function(vehicleNetId)
	local vehicle = NetToVeh(vehicleNetId)

	if vehicle and DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
		DisableVehicleImpactExplosionActivation(vehicle, true)
	end
end)

----------------------------------------------------------------------------------
--                              KEYBINDING COMMANDS                             --
----------------------------------------------------------------------------------

-- +keyboardSirenOne KEYBIND COMMAND
RegisterCommand('+sirenOne', function()
	if inVehicle and savedVehicle then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		if currentMode == 1 then
			siren(1, 1)

			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = true }) end
		else
			if sirenStates[savedVehicle] and sirenStates[savedVehicle][1] then
				siren(1, 0)
				if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = false }) end
			else
				siren(1, 1)
				if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = true }) end
			end
		end
	end
end, false)

-- -keyboardSirenOne KEYBIND COMMAND (NULL)
RegisterCommand('-sirenOne', function()
	if inVehicle and savedVehicle then
		if currentMode == 1 then
			siren(1, 0)
			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = false }) end
		else
			return
		end
	end
end, false)

-- +keyboardSirenTwo KEYBIND COMMAND
RegisterCommand('+sirenTwo', function()
	if inVehicle and savedVehicle then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		if currentMode == 1 then
			siren(2, 1)
			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = true }) end
		else
			if sirenStates[savedVehicle] and sirenStates[savedVehicle][2] then
				siren(2, 0)
				if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = false }) end
			else
				siren(2, 1)
				if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = true }) end
			end
		end
	end
end, false)

-- -keyboardSirenTwo KEYBIND COMMAND (NULL)
RegisterCommand('-sirenTwo', function()
	if inVehicle and savedVehicle then
		if currentMode == 1 then
			siren(2, 0)
			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = false }) end
		else
			return
		end
	end
end, false)

-- +keyboardSirenThree KEYBIND COMMAND
RegisterCommand('+sirenThree', function()
	if inVehicle and savedVehicle then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		if currentMode == 1 then
			siren(3, 1)
			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = true }) end
		else
			if sirenStates[savedVehicle] and sirenStates[savedVehicle][3] then
				siren(3, 0)
				if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = false }) end
			else
				siren(3, 1)
				if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = true }) end
			end
		end
	end
end, false)

-- -keyboardSirenThree KEYBIND COMMAND (NULL)
RegisterCommand('-sirenThree', function()
	if inVehicle and savedVehicle then
		if currentMode == 1 then
			siren(3, 0)
			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = false }) end
		else
			return
		end
	end
end, false)

-- +keyboardSwapMode KEYBIND COMMAND
RegisterCommand('+swapMode', function()
	if inVehicle and savedVehicle then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		if currentMode == 0 then
			currentMode = 1
			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "chirpMode", value = true }) end
		else
			currentMode = 0
			if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "chirpMode", value = false }) end
		end
	end
end, false)

-- -keyboardSwapMode KEYBIND COMMAND (NULL)
RegisterCommand('-swapMode', function()
	return
end, false)

-- +lights KEYBIND COMMAND
RegisterCommand('+pressHorn', function()
	if inVehicle and savedVehicle then
		siren(4, 1)
	end
end, false)

-- -lights KEYBIND COMMAND
RegisterCommand('-pressHorn', function()
	if inVehicle and savedVehicle then
		siren(4, 0)
	end
end, false)

-- +lights KEYBIND COMMAND
RegisterCommand('+toggleLights', function()
	return
end, false)

-- -lights KEYBIND COMMAND
RegisterCommand('-toggleLights', function()
	if inVehicle and savedVehicle then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		muteDefaultSirens(savedVehicle)
		local vehicleNetId = VehToNet(savedVehicle)

		if vehicleNetId then
			if lightStates[savedVehicle] then
				TriggerServerEvent('emergency_controls:lights', vehicleNetId, false)
			else
				TriggerServerEvent('emergency_controls:lights', vehicleNetId, true)
			end
		end
	end
end, false)

-- +keyboardSirenUI KEYBIND COMMAND
RegisterCommand('+openUI', function()
	if inVehicle and savedVehicle and Config.EnableUIMenu then
		PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		inMenu = true
		SendNUIMessage({ type = "open" })
		SetNuiFocus(true, true)
	end
end, false)

-- -keyboardSirenUI KEYBIND COMMAND (NULL)
RegisterCommand('-openUI', function()
	return
end, false)

----------------------------------------------------------------------------------
--                                  KEYBINDINGS                                 --
----------------------------------------------------------------------------------

RegisterKeyMapping('+sirenOne', 'Siren One', 'keyboard', Config.Keyboard.SirenOne)
RegisterKeyMapping('+sirenTwo', 'Siren Two', 'keyboard', Config.Keyboard.SirenTwo)
RegisterKeyMapping('+sirenThree', 'Siren Three', 'keyboard', Config.Keyboard.SirenThree)
RegisterKeyMapping('+swapMode', 'Swap Mode', 'keyboard', Config.Keyboard.Mode)
RegisterKeyMapping('+pressHorn', 'Press Horn', 'keyboard', Config.Keyboard.Horn)
RegisterKeyMapping('+toggleLights', 'Toggle Lights', 'keyboard', Config.Keyboard.Lights)

if Config.EnableUIMenu then 
	RegisterKeyMapping('+openUI', 'Open UI', 'keyboard', Config.Keyboard.UIMenu)
end
----------------------------------------------------------------------------------
--                                 NUI Callbacks                                --
----------------------------------------------------------------------------------

RegisterNUICallback('nuiReady', function()
	nuiReady = true
end)

RegisterNUICallback('saveOverrides', function(data)
	if data then
		local one = tonumber(data.sirenOne)
		local two = tonumber(data.sirenTwo)
		local three = tonumber(data.sirenThree)
		local four = tonumber(data.sirenFour)

		if Config.AvailableSirens[one] then
			override[1] = Config.AvailableSirens[one]
		else
			override[1] = nil
		end

		if Config.AvailableSirens[two] then
			override[2] = Config.AvailableSirens[two]
		else
			override[2] = nil
		end

		if Config.AvailableSirens[three] then
			override[3] = Config.AvailableSirens[three]
		else
			override[3] = nil
		end

		if Config.AvailableSirens[four] then
			override[4] = Config.AvailableSirens[four]
		else
			override[4] = nil
		end
	end

	inMenu = false
	SetNuiFocus(false, false)
end)

RegisterNUICallback('close', function()
	inMenu = false
	SetNuiFocus(false, false)
end)

----------------------------------------------------------------------------------
--                                    THREADS                                   --
----------------------------------------------------------------------------------

CreateThread(function()
	while true do
		if inVehicle and not controllerActive then
			DisableControlAction(0, 86, true) -- INPUT_VEH_HORN	
			DisableControlAction(0, 172, true) -- INPUT_CELLPHONE_UP 
			DisableControlAction(0, 81, true) -- INPUT_VEH_NEXT_RADIO
			DisableControlAction(0, 82, true) -- INPUT_VEH_PREV_RADIO
			DisableControlAction(0, 19, true) -- INPUT_CHARACTER_WHEEL 
			DisableControlAction(0, 85, true) -- INPUT_VEH_RADIO_WHEEL 
			DisableControlAction(0, 80, true) -- INPUT_VEH_CIN_CAM
		end

		Wait(3)
	end
end)

CreateThread(function()
	while not nuiReady do
		Wait(1000)
	end

	while true do
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped)
			
			if vehicle then
				if savedVehicle ~= vehicle then
					local vehicleClass = GetVehicleClass(vehicle)

					if vehicleClass == 18 then
						local seatPed = GetPedInVehicleSeat(vehicle, -1)

						SetVehRadioStation(vehicle, "OFF")
						SetVehicleRadioEnabled(vehicle, false)

						if seatPed == ped then
							inVehicle = true
							savedVehicle = vehicle
							currentMode = 0
							if Config.EnableHUD then hudActive = true SendNUIMessage({ type = "showHud", mode = currentMode }) end
						else
							inVehicle = false
						end
					else
						inVehicle = false
					end
				else
					if not hudActive then
						inVehicle = true
						if Config.EnableHUD then hudActive = true SendNUIMessage({ type = "showHud", mode = currentMode }) end
					end
				end
			else
				if Config.EnableHUD then
					if hudActive then hudActive = false SendNUIMessage({ type = "hideHud" }) end
				end

				if savedVehicle and DoesEntityExist(savedVehicle) then
					local vehicleNetId = VehToNet(savedVehicle)
	
					if vehicleNetId then
						if sirenStates[savedVehicle] then
							if sirenStates[savedVehicle][1] or sirenStates[savedVehicle][2] or sirenStates[savedVehicle][3] then
								TriggerServerEvent('emergency_controls:muteSirens', vehicleNetId)
							end
						end
					end
				end

				inVehicle = false
			end
		else
			if Config.EnableHUD then
				if hudActive then hudActive = false SendNUIMessage({ type = "hideHud" }) end
			end

			if savedVehicle and DoesEntityExist(savedVehicle) then
				local vehicleNetId = VehToNet(savedVehicle)

				if vehicleNetId then
					if sirenStates[savedVehicle] then
						if sirenStates[savedVehicle][1] or sirenStates[savedVehicle][2] or sirenStates[savedVehicle][3] then
							TriggerServerEvent('emergency_controls:muteSirens', vehicleNetId)
						end
					end
				end
			end

			inVehicle = false
		end

		Wait(500)
	end
end)

if Config.EnableController then
	CreateThread(function()
		while true do
			if GetLastInputMethod(2) then
				controllerActive = false
			else
				controllerActive = true
			end

			Wait(100)
		end
	end)

	CreateThread(function()
		while true do
			if inVehicle then
				DisableControlAction(0, Config.ControllerButtons.SirenOne, true)
				DisableControlAction(0, Config.ControllerButtons.SirenTwo, true)
				DisableControlAction(0, Config.ControllerButtons.SirenThree, true)
				DisableControlAction(0, Config.ControllerButtons.Mode, true)
				DisableControlAction(0, Config.ControllerButtons.Horn, true)
				DisableControlAction(0, Config.ControllerButtons.Lights, true)
				if Config.EnableUIMenu then DisableControlAction(0, Config.ControllerButtons.UIMenu, true) end
			end

			Wait(5)
		end
	end)

	CreateThread(function()
		while true do
			if inVehicle and controllerActive then
				if currentMode == 0 then
					if IsDisabledControlJustPressed(0, Config.ControllerButtons.SirenOne) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

							if sirenStates[savedVehicle] and sirenStates[savedVehicle][1] then
								siren(1, 0)
								if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = false }) end
							else
								siren(1, 1)
								if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = true }) end
							end
						end
					end

					if IsDisabledControlJustPressed(0, Config.ControllerButtons.SirenTwo) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							if sirenStates[savedVehicle] and sirenStates[savedVehicle][2] then
								siren(2, 0)
								if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = false }) end
							else
								siren(2, 1)
								if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = true }) end
							end
						end
					end
				

					if IsDisabledControlJustPressed(0, Config.ControllerButtons.SirenThree) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							if sirenStates[savedVehicle] and sirenStates[savedVehicle][3] then
								siren(3, 0)
								if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = false }) end
							else
								siren(3, 1)
								if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = true }) end
							end
						end
					end

					if IsDisabledControlJustPressed(0, Config.ControllerButtons.Mode) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							currentMode = 1
							if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "chirpMode", value = true }) end
						end
					end

					if Config.EnableUIMenu then
						if inVehicle and savedVehicle then
							if IsDisabledControlJustPressed(0, Config.ControllerButtons.UIMenu) then
								PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
								inMenu = true
								SendNUIMessage({ type = "open" })
								SetNuiFocus(true, true)
							end
						end
					end
				else
					if IsDisabledControlJustPressed(0, Config.ControllerButtons.SirenOne) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							siren(1, 1)
							if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = true }) end
						end
					end
				
					if IsDisabledControlJustPressed(0, Config.ControllerButtons.SirenTwo) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							siren(2, 1)
							if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = true }) end
						end
					end

					if IsDisabledControlJustPressed(0, Config.ControllerButtons.SirenThree) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							siren(3, 1)
							if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = true }) end
						end
					end

					if IsDisabledControlJustReleased(0, Config.ControllerButtons.SirenOne) then
						if inVehicle and savedVehicle then
							siren(1, 0)
							if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenOne", value = false }) end
						end
					end
				
					if IsDisabledControlJustReleased(0, Config.ControllerButtons.SirenTwo) then
						siren(2, 0)
						if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenTwo", value = false }) end
					end

					if IsDisabledControlJustReleased(0, Config.ControllerButtons.SirenThree) then
						if inVehicle and savedVehicle then
							siren(3, 0)
							if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "sirenThree", value = false }) end
						end
					end

					if IsDisabledControlJustPressed(0, Config.ControllerButtons.Mode) then
						if inVehicle and savedVehicle then
							PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
							currentMode = 0
							if Config.EnableHUD then SendNUIMessage({ type = "changeState", category = "chirpMode", value = false }) end
						end
					end

					if Config.EnableUIMenu then
						if inVehicle and savedVehicle then
							if IsDisabledControlJustPressed(0, Config.ControllerButtons.UIMenu) then
								inMenu = true
								SendNUIMessage({ type = "open" })
								SetNuiFocus(true, true)
							end
						end
					end
				end

				if IsDisabledControlJustPressed(0, Config.ControllerButtons.Horn) then
					if inVehicle and savedVehicle then
						siren(4, 1)
					end
				end

				if IsDisabledControlJustReleased(0, Config.ControllerButtons.Horn) then
					if inVehicle and savedVehicle then
						siren(4, 0)
					end
				end

				if IsControlJustReleased(0, Config.ControllerButtons.Lights) then
					if inVehicle and savedVehicle then
						PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						muteDefaultSirens(savedVehicle)
						local vehicleNetId = VehToNet(savedVehicle)
				
						if vehicleNetId then
							if lightStates[savedVehicle] then
								TriggerServerEvent('emergency_controls:lights', vehicleNetId, false)
							else
								TriggerServerEvent('emergency_controls:lights', vehicleNetId, true)
							end
						end
					end
				end
			end

			Wait(1)
		end
	end)
end

----------------------------------------------------------------------------------
--                              SETUP OVERRIDE LIB                              --
----------------------------------------------------------------------------------

CreateThread(function()
	while not nuiReady do
		Wait(1000)
	end

	if Config and Config.AvailableSirens and Config.EnableUIMenu then
		local sirens = Config.AvailableSirens
		SendNUIMessage({ type = "initData", sirens = sirens })
	end

	-- EXAMPLE FOR CUSTOM SIRENS
	-- IF YOU ARE USING CUSTOM SIRENS PLEASE REQUEST THE AUDIOBANK HERE
	-- RequestScriptAudioBank("DLC_WMSIRENS\\SIRENPACK_ONE", false)
end)
