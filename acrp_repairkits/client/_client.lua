local display = false

RegisterNetEvent("acrp_repairkit:StartRepairing")
AddEventHandler("acrp_repairkit:StartRepairing", function()
    local pedCar = GetVehiclePedIsIn(PlayerPedId(), false)
    display = true
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        Citizen.CreateThread(function()
            local carHood = GetWorldPositionOfEntityBone(pedCar, GetEntityBoneIndexByName(pedCar, "bonnet"))
            while display do 
                Citizen.Wait(5)
                Draw3DText(carHood.x, carHood.y - 1.0, carHood.z, "~g~[E]~w~ Repair the car")
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), carHood.x, carHood.y, carHood.z, true) < 1.75 and not IsPedInAnyVehicle(PlayerPedId(), false) and IsControlJustPressed(0, 51) then
                    display = false
                    repair(getNearestVeh())
                end
            end
        end)
    else
        exports['mythic_notify']:SendAlert("inform", "You are not in a car")
    end
end)

function repair(carro)
    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    local animName = "machinic_loop_mechandplayer"
    LoadAnim(animDict)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 2.0, 2.0, 31400, 16, 0, false, false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    SetVehicleUndriveable(carro, true)
    exports['progressBars']:startUI(7500, "Repairing the engine")
    Citizen.Wait(7850)
    exports['progressBars']:startUI(7500, "Removing the glass")
    Citizen.Wait(7850)
    exports['progressBars']:startUI(7500, "Making some adjustments in the plate")
    Citizen.Wait(7850)
    exports['progressBars']:startUI(7500, "Puting new glasses")
    Citizen.Wait(7850)
    local health = 750
    SetVehicleFixed(carro)
    ClearPedTasksImmediately(PlayerPedId())
    SetVehicleUndriveable(carro, false)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent("acrp_repairkit:TirarRepairKit")
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

RegisterCommand('cancelrepair', function()
    if display == true then
        display = false
    end
end)

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    local scale = 0.35

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255,255,255,255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
  
    local factor = (string.len(text)) / 250
    DrawRect(_x, _y + 0.0125, 0.005 + factor, 0.03, 100, 100, 100, 155)
end


function getNearestVeh()
	local pos = GetEntityCoords(PlayerPedId())
	local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)

	return vehicleHandle
end

RegisterCommand("unfreeze", function()
    FreezeEntityPosition(PlayerPedId(), false)
end)