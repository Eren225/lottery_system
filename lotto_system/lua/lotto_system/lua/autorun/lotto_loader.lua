/*
Made by Eren -> https://steamcommunity.com/id/ErenRbac/
*/

local function includeFile(fileName)
    local path = "lotto/" .. fileName
    local loadType = string.Left(string.lower(fileName),3)

    if (loadType == "sh_") then
        AddCSLuaFile(path)
        include(path)
    elseif (loadType == "cl_") then
        AddCSLuaFile(path)
        if (CLIENT) then
            include(path)
        end
    elseif (loadType == "sv_") then
        if (SERVER) then
            include(path)
        end
    end
end
includeFile("sv_lottonetwork.lua")
includeFile("cl_lottomenu.lua")
includeFile("cl_lottominimap.lua")
