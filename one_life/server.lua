-- Function to get the player's GTA license
function getPlayerLicense(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "license:") then
            return identifier
        end
    end
    return nil
end

function getDeathCount(playerLicense, callback)
    local query = "SELECT deaths FROM death_events WHERE player_license = @player_license"
    local parameters = {['@player_license'] = playerLicense}
    MySQL.Async.fetchScalar(query, parameters, function(deathCount)
        if deathCount then
            callback(deathCount)
        else
            callback(0) 
        end
    end)
end

function updateDeathCount(playerLicense, deathCount)
    local query = [[
        INSERT INTO death_events (player_license, deaths)
        VALUES (@player_license, @deaths)
        ON DUPLICATE KEY UPDATE deaths = @deaths
    ]]
    
    local parameters = {
        ['@player_license'] = playerLicense,
        ['@deaths'] = deathCount
    }

    MySQL.Async.execute(query, parameters, function(affectedRows)
        if affectedRows > 0 then
            print('Death count updated successfully.')
        else
            print('Failed to update death count.')
        end
    end)
end

function banPlayer(playerId)
    DropPlayer(playerId, "You have been banned for exceeding the death limit.")
    -- Optionally, log the ban in the database or a file.
end

RegisterNetEvent('One_Life:Death')
AddEventHandler('One_Life:Death', function()
    local playerId = source
    local playerLicense = getPlayerLicense(playerId)
    if playerLicense then
        getDeathCount(playerLicense, function(currentDeaths)
            local newDeathCount = currentDeaths + 1
            if newDeathCount >= config.settings.lives then
                banPlayer(playerId)
            else
                updateDeathCount(playerLicense, newDeathCount)
            end
        end)
    else
        print("Player license not found for player ID: " .. playerId)
    end
end)
