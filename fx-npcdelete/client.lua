local plateCache = {}
local Framework = {}

CreateThread(function()
    if Config.Framework == "qbcore" then
        Framework.Core = exports["qb-core"]:GetCoreObject()
    elseif Config.Framework == "esx" then
        while Framework.Core == nil do
            TriggerEvent('esx:getSharedObject', function(obj) Framework.Core = obj end)
            Wait(200)
        end
    elseif Config.Framework == "ox" then
        Framework.Core = exports.ox_core
    end
end)

local function IsPointInPolygon(point, polygon)
    local inside = false
    local j = #polygon
    for i = 1, #polygon do
        local xi, yi = polygon[i].x, polygon[i].y
        local xj, yj = polygon[j].x, polygon[j].y
        if ((yi > point.y) ~= (yj > point.y)) and (point.x < (xj - xi) * (point.y - yi) / ((yj - yi) + 0.00001) + xi) then
            inside = not inside
        end
        j = i
    end
    return inside
end

local function updatePlateCache()
    if Config.Framework == "ox" then
        lib.callback('fx-npcdelete:getPlates', false, function(result)
            plateCache = result
        end)
    else
        Framework.Core.Functions.TriggerCallback('fx-npcdelete:getPlates', function(result)
            plateCache = result
        end)
    end
end

CreateThread(function()
    updatePlateCache()
    while true do
        Wait(60000)
        updatePlateCache()
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if Config.ShowZoneLines then
            for _, zone in pairs(Config.DeleteZones) do
                for i = 1, #zone.points do
                    local p1 = zone.points[i]
                    local p2 = zone.points[(i % #zone.points) + 1]
                    DrawLine(p1.x, p1.y, 30.0, p2.x, p2.y, 30.0, 255, 0, 0, 150)
                end
            end
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        if not Config.EnableDeleteZone then goto continue end
        for _, veh in ipairs(GetGamePool("CVehicle")) do
            if DoesEntityExist(veh) and not IsPedAPlayer(GetPedInVehicleSeat(veh, -1)) then
                local coords = GetEntityCoords(veh)
                local plate = string.gsub(GetVehicleNumberPlateText(veh), "%s+", ""):upper()
                local vehPoint = vector2(coords.x, coords.y)
                for _, zone in pairs(Config.DeleteZones) do
                    if IsPointInPolygon(vehPoint, zone.points) then
                        if not plateCache[plate] then
                            local controlled = false
                            for i = 1, 20 do
                                NetworkRequestControlOfEntity(veh)
                                if NetworkHasControlOfEntity(veh) then
                                    controlled = true
                                    break
                                end
                                Wait(100)
                            end
                            if controlled then
                                local driver = GetPedInVehicleSeat(veh, -1)
                                if driver and DoesEntityExist(driver) then
                                    TaskLeaveVehicle(driver, veh, 0)
                                    Wait(500)
                                    DeleteEntity(driver)
                                end
                                if DoesEntityExist(veh) then
                                    SetEntityAsMissionEntity(veh, true, true)
                                    DeleteEntity(veh)
                                    Wait(100)
                                    if DoesEntityExist(veh) then
                                        DeleteVehicle(veh)
                                    end
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
        ::continue::
    end
end)
