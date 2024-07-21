RegisterNetEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function (killerType, coords)
    if killerType and coords then
        TriggerServerEvent('One_Life:Death')
    end
end)