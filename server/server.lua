
local vehicleDamage = {}

Citizen.CreateThread(function()
	while (true) do
		Citizen.Wait(2000)

		for i, vehicle in ipairs(GetAllVehicles()) do
			if (not vehicleDamage[vehicle] and IsVehicleEligible(vehicle)) then
				StartVehicleEngineDamage(vehicle)
			end
		end
	end
end)

function IsVehicleEligible(vehicle)
	return 
		DoesEntityExist(vehicle) 
		and GetVehicleEngineHealth(vehicle) > -4000.0 
		and IsInRotationLimits(vehicle) 
		and GetEntitySpeed(vehicle) < 2.0
end

function StartVehicleEngineDamage(vehicle)
	vehicleDamage[vehicle] = GetVehicleEngineHealth(vehicle)

	Citizen.CreateThread(function()
		while (IsVehicleEligible(vehicle)) do
			vehicleDamage[vehicle] = vehicleDamage[vehicle] - Config.damagePerTick

			-- explosion
			if (Config.explosion and vehicleDamage[vehicle] <= -4000.0) then
				TriggerClientEvent("VB:dmg", NetworkGetEntityOwner(vehicle), NetworkGetNetworkIdFromEntity(vehicle), -4000.0)
				break
			end

			TriggerClientEvent("VB:dmg", NetworkGetEntityOwner(vehicle), NetworkGetNetworkIdFromEntity(vehicle), vehicleDamage[vehicle])

			Citizen.Wait(1000 / Config.ticksPerSecond)
		end

		vehicleDamage[vehicle] = nil
	end)
end

function IsInRotationLimits(vehicle)
	local rotation = GetEntityRotation(vehicle)
	return rotation.x > 75.0 or rotation.x < -75.0 or rotation.y > 75.0 or rotation.y < -75.0
end
