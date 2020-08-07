ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('repairkit', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent("acrp_repairkit:StartRepairing", source, display)

end)

RegisterNetEvent("acrp_repairkit:TirarRepairKit")
AddEventHandler("acrp_repairkit:TirarRepairKit", function()
    
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('repairkit', 1)

end)