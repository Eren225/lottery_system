/*
Made by Eren -> https://steamcommunity.com/id/ErenRbac/
*/
include("lotto_config.lua")

util.AddNetworkString("lotto_start")
util.AddNetworkString("lotto_startToCli")
util.AddNetworkString("joinLotto")
util.AddNetworkString("lottoWinner")
util.AddNetworkString("lottoParticipant")
local participants = participants or {}
local lottoLeader
local tempsChoixGagnant = ErenConfig.tempsChoixGagnant + ErenConfig.closeTime // temps avant tirage au sort
net.Receive("lotto_start",function(_,ply)  
    lottoLeader = ply
    net.Start("lotto_startToCli")
    net.Broadcast()

    timer.Simple(tempsChoixGagnant, function()

        if table.IsEmpty( participants ) then 
            net.Start("lottoWinner")
            net.WriteString("")
            net.WriteBool(false)
            net.Broadcast()
            return
        end

        local nbParticipants = #participants
        local winner = participants[ math.random( nbParticipants )]
        local winnerName = winner:Name()
        local winnerValue = ErenConfig.winAmount*nbParticipants
        winner:addMoney(winnerValue)
        participants = {}
        lottoLeader:addMoney(ErenConfig.leaderWin*nbParticipants)
        net.Start("lottoWinner")
        net.WriteString(winnerName)
        net.WriteBool(true)
        net.WriteInt(winnerValue,21)
        net.Broadcast()

    end)
end)

net.Receive("joinLotto",function(_,ply)
    if ply:getDarkRPVar("money")-ErenConfig.joinCost<0 then
        return
    end
    ply:addMoney(-ErenConfig.joinCost)
    table.insert(participants, ply)
    net.Start("lottoParticipant")
    net.WriteString(ply:Name())
    net.Send(lottoLeader)
end)
