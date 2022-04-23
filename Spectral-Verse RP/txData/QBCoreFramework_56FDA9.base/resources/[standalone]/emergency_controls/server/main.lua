RegisterNetEvent('emergency_controls:siren', function(id, vehicleNetId, sirenState, sentOverride)
	TriggerClientEvent('emergency_controls:siren', -1, id, vehicleNetId, sirenState, sentOverride)
end)

RegisterNetEvent('emergency_controls:lights', function(vehicleNetId, state)
	TriggerClientEvent('emergency_controls:lights', -1, vehicleNetId, state)
end)

RegisterNetEvent('emergency_controls:horn', function(vehicleNetId, state)
	TriggerClientEvent('emergency_controls:horn', -1, vehicleNetId, state)
end)

RegisterNetEvent('emergency_controls:muteSirens', function(vehicleNetId)
	TriggerClientEvent('emergency_controls:muteSirens', -1, vehicleNetId)
end)

RegisterNetEvent('emergency_controls:muteDefaultSirens', function(vehicleNetId)
	TriggerClientEvent('emergency_controls:muteDefaultSirens', -1, vehicleNetId)
end)