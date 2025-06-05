local Framework = {}

if Config.Framework == "qbcore" then
    Framework.Core = exports['qb-core']:GetCoreObject()
    Framework.RegisterCallback = Framework.Core.Functions.CreateCallback
elseif Config.Framework == "esx" then
    TriggerEvent('esx:getSharedObject', function(obj) Framework.Core = obj end)
    Framework.RegisterCallback = ESX.RegisterServerCallback
elseif Config.Framework == "ox" then
    Framework.RegisterCallback = lib.callback.register
end

Framework.RegisterCallback('fx-npcdelete:getPlates', function(source, cb)
    local plates = {}
    local query = string.format("SELECT plate FROM %s", Config.SQLVehicleTable)
    local result = MySQL.query.await(query, {})
    for _, v in ipairs(result) do
        plates[v.plate:upper()] = true
    end
    cb(plates)
end)
