/*
Made by Eren -> https://steamcommunity.com/id/ErenRbac/
*/
util.AddNetworkString("lotto_start")
util.AddNetworkString("lotto_startToCli")
util.AddNetworkString("joinLotto")
util.AddNetworkString("lottoWinner")
util.AddNetworkString("lottoParticipant")
local participants = participants or {}
local lottoLeader
local tempsChoixGagnant = 3*60 // temps avant tirage au sort
net.Receive("lotto_start",function(_,ply)  
    lottoLeader = ply
    net.Start("lotto_startToCli")
    net.Broadcast()

    timer.Simple(tempsChoixGagnant, function()

        if table.IsEmpty( participants ) then 
            net.Start("lottoWinner")
            net.WriteString("02Kl_ lz12")
            net.Broadcast()
            return
        end

        local nbParticipants = #participants
        local winner = participants[ math.random( nbParticipants )]
        local winnerName = winner:Name()
        local winnerValue = 5000*nbParticipants
        winner:addMoney(winnerValue)
        participants = {}
        lottoLeader:addMoney(1000*nbParticipants)
        net.Start("lottoWinner")
        net.WriteString(winnerName)
        net.WriteInt(winnerValue,21)
        net.Broadcast()

    end)
end)

net.Receive("joinLotto",function(_,ply)
    if ply:getDarkRPVar("money")-5000<0 then
        return
    end
    ply:addMoney(-5000)
    table.insert(participants, ply)
    net.Start("lottoParticipant")
    net.WriteString(ply:Name())
    net.Send(lottoLeader)
end)
