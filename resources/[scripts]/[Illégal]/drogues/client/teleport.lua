Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		TriggerServerEvent('esx_drugs:ChargementLicenses')
		Citizen.Wait(0)
	end
end)


local EntrerWeed = {coords = vector3(-287.638, 2535.75, 75.69)}
local SortieWeed = {coords = vector3(1066.300, -3183.11, -39.16)}


-- Zone 


Citizen.CreateThread(function()
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheckEntrer = GetDistanceBetweenCoords(pedCoords, EntrerWeed.coords, true)
		local dstCheckSortie = GetDistanceBetweenCoords(pedCoords, SortieWeed.coords, true)
		if dstCheckEntrer <= 4.2 then
			sleepThread = 5
			if dstCheckEntrer <= 4.2 then
				ESX.Game.Utils.DrawText3D(EntrerWeed.coords, "[E] Entrer dans le laboratoire de ~g~Weed\n~r~Activitée illégal", 1.0)
				if IsControlJustPressed(0, 38) then
					animationEntrer()
				end
			end
		end
		if dstCheckSortie <= 4.2 then
			sleepThread = 5
			if dstCheckSortie <= 4.2 then
				ESX.Game.Utils.DrawText3D(SortieWeed.coords, "[E] Sortir du laboratoire de ~g~Weed", 1.0)
				if IsControlJustPressed(0, 38) then
					animationSortie()
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)


-- Animation



-- Copyright © Vespura 2018
-- Edit it if you want, but don't re-release this without my permission, and never claim it to be yours!


------- Configurable options  -------

-- set the opacity of the clouds
local cloudOpacity = 0.20 -- (default: 0.01)

-- setting this to false will NOT mute the sound as soon as the game loads 
-- (you will hear background noises while on the loading screen, so not recommended)
local muteSound = true -- (default: true)



------- Code -------

-- Mutes or un-mutes the game's sound using a short fade in/out transition.
function ToggleSound(state)
	if state then
		StartAudioScene("MP_LEADERBOARD_SCENE");
	else
		StopAudioScene("MP_LEADERBOARD_SCENE");
	end
end

-- Runs the initial setup whenever the script is loaded.
function InitialSetup()
	-- Stopping the loading screen from automatically being dismissed.
	SetManualShutdownLoadingScreenNui(true)
	-- Disable sound (if configured)
	ToggleSound(muteSound)
	-- Switch out the player if it isn't already in a switch state.
	if not IsPlayerSwitchInProgress() then
		SwitchOutPlayer(PlayerPedId(), 0, 1)
	end
end


-- Hide radar & HUD, set cloud opacity, and use a hacky way of removing third party resource HUD elements.
function ClearScreen()
	SetCloudHatOpacity(cloudOpacity)
	HideHudAndRadarThisFrame()
	
	-- nice hack to 'hide' HUD elements from other resources/scripts. kinda buggy though.
	SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

-- Sometimes this gets called too early, but sometimes it's perfectly timed,
-- we need this to be as early as possible, without it being TOO early, it's a gamble!


function animationEntrer()
	local ped = PlayerPedId()
	InitialSetup()
	-- Wait for the switch cam to be in the sky in the 'waiting' state (5).
	while GetPlayerSwitchState() ~= 5 do
		Citizen.Wait(0)
		ClearScreen()
	end
	-- Shut down the game's loading screen (this is NOT the NUI loading screen).
	ShutdownLoadingScreen()
	ClearScreen()
	Citizen.Wait(0)
	DoScreenFadeOut(1000)
	ESX.Game.Teleport(ped, SortieWeed.coords)
	-- Shut down the NUI loading screen.
	ShutdownLoadingScreenNui()
	ClearScreen()
	Citizen.Wait(0)
	ClearScreen()
	local timer = GetGameTimer()
	-- Re-enable the sound in case it was muted.
	ToggleSound(false)
	while true do
		ClearScreen()
		Citizen.Wait(0)
		-- wait 5 seconds before starting the switch to the player
		if GetGameTimer() - timer > 50 then
			-- Switch to the player.
			SwitchInPlayer(PlayerPedId())
			ClearScreen()
			-- Wait for the player switch to be completed (state 12).
			while GetPlayerSwitchState() ~= 12 do
				Citizen.Wait(0)
				ClearScreen()

			end
			-- Stop the infinite loop.
			break
		end
	end
	-- Reset the draw origin, just in case (allowing HUD elements to re-appear correctly)
	DoScreenFadeIn(1000)
	ClearDrawOrigin()
end


function animationSortie()
	DoScreenFadeOut(500)
	Wait(500)
	local ped = PlayerPedId()
	InitialSetup()
	-- Wait for the switch cam to be in the sky in the 'waiting' state (5).
	while GetPlayerSwitchState() ~= 5 do
		Citizen.Wait(0)
		ClearScreen()
	end
	-- Shut down the game's loading screen (this is NOT the NUI loading screen).
	ShutdownLoadingScreen()
	ClearScreen()
	Citizen.Wait(0)
	
	ESX.Game.Teleport(ped, EntrerWeed.coords)
	-- Shut down the NUI loading screen.
	ShutdownLoadingScreenNui()
	ClearScreen()
	Citizen.Wait(0)
	ClearScreen()
	local timer = GetGameTimer()
	-- Re-enable the sound in case it was muted.
	ToggleSound(false)
	while true do
		ClearScreen()
		Citizen.Wait(0)
		-- wait 5 seconds before starting the switch to the player
		if GetGameTimer() - timer > 50 then
			-- Switch to the player.
			SwitchInPlayer(PlayerPedId())
			ClearScreen()
			-- Wait for the player switch to be completed (state 12).
			while GetPlayerSwitchState() ~= 12 do
				Citizen.Wait(0)
				ClearScreen()
				
			end
			
			-- Stop the infinite loop.
			break
			
		end
	end
	-- Reset the draw origin, just in case (allowing HUD elements to re-appear correctly)
	DoScreenFadeIn(1000)
	ClearDrawOrigin()
end