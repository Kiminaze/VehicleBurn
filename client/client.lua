
if (Config.preventRollover) then
	Citizen.CreateThread(function()
		local isInVehicle = false
		local isDriver = false
		local vehicle = nil

		while (true) do
			Citizen.Wait(0)

			if (not isInVehicle and IsPedInAnyVehicle(playerPed)) then
				isInVehicle = true
				vehicle = GetVehiclePedIsIn(playerPed)
			elseif (isInVehicle and not IsPedInAnyVehicle(playerPed)) then
				isInVehicle = false
				isDriver = false
				vehicle = nil
			end

			if (isInVehicle) then
				PreventRollingVehicle(vehicle)
			else
				Citizen.Wait(1000)
			end
		end
	end)

	function PreventRollingVehicle(vehicle)
		local rotation = GetEntityRotation(vehicle)

		if (rotation.x > 75.0 or rotation.x < -75.0 or rotation.y > 75.0 or rotation.y < -75.0) then
			DisableControlAction(0, 59)
			DisableControlAction(0, 60)
		end
	end
end

-- damage and explode vehicle
RegisterNetEvent("VB:dmg", function(networkId, newHealth)
	local vehicle = NetworkDoesNetworkIdExist(networkId) and NetworkGetEntityFromNetworkId(networkId)
	if (not vehicle) then return end

	SetVehicleEngineHealth(vehicle, newHealth)
	if (newHealth <= -4000.0) then
		NetworkExplodeVehicle(vehicle, true, false)
	end
end)
