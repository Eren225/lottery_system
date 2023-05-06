/*
Made by Eren -> https://steamcommunity.com/id/ErenRbac/
*/
local scrW = ScrW()
local scrH = ScrH()
local cooldown = CurTime()
local participants = ""
local cooldownLotto = 8*60 // cooldown + temps choix gagnant
local tempsChoixGagnant = 3*60 // temps avant tirage au sort
local function RespW(size) return size/(scrW/1920) end
local function RespH(size) return size/(scrH/1080) end
local function PosWBasedOnSize(size) return scrW-size end
local gameLaunched = false
surface.CreateFont("Font_big", {
    font = "Arial",
   weight = 30000,
    extended = true,
    size = 40,
 
})
surface.CreateFont("Font_small", {
    font = "Arial",
    extended = true,
    size = 26,
    weight = 3000

})

local function lottoPanel(open)
    if open then
        PanelConfig = vgui.Create("DFrame") -- The name DermaPanel to store the value DFrame.
        PanelConfig:SetSize(RespW(1000), RespH(700)) -- Sets the size to 500x by 300y.
        PanelConfig:Center()
        PanelConfig:SetTitle("") -- Set the title to nothing.
        PanelConfig:SetDraggable(false) -- Makes it so you can't drag it.
        PanelConfig:ShowCloseButton( false )
        PanelConfig.Paint = function(self, w, h)
            draw.RoundedBox(30, 0, 0, w, h, Color(45,143,255,94))
            surface.SetDrawColor(0,119,255)
            surface.DrawRect(w/12,h/5,w/1.2,h/6)
            surface.DrawRect(0,0,w,h/9)
            draw.SimpleText("LOTERIE", "Font_big",w/2, h/17, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if (!gameLaunched && #participants==0) then
                draw.SimpleText("Bonjour, vous etes sur le point de lancer une loterie, une fois la loterie lancée", "Font_small",w/2, h/4, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("tous les civils receveront une notification de début de loterie", "Font_small",w/2, h/3.3, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("La loterie est déjà lancée, voici les participants ci-dessous", "Font_small",w/2, h/4, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                surface.DrawRect(w/12,h/2.5,w/1.2,h/3)
            end
           
        end
        local panelParticipants= vgui.Create("DPanel",PanelConfig)
        panelParticipants:SetSize(RespW(700), RespH(200)) 
        panelParticipants:SetText( participants )
        panelParticipants:SetPos( 0, RespH(295) )
        panelParticipants:CenterHorizontal()
        panelParticipants:SetWrap(true)
        panelParticipants.Paint = function(self,w,h)
        end

        local panParticipants = vgui.Create("DLabel",panelParticipants)
        panParticipants:SetSize(RespW(700), RespH(200)) 
        panParticipants:SetText( participants )
        panParticipants:SetPos( 0, 0 )
        panParticipants:CenterHorizontal()
        panParticipants:SetFont("Font_small")
        panParticipants:SetWrap( true )
        panParticipants:SetAutoStretchVertical(true)
        if (!gameLaunched && #participants==0) then
        local button = vgui.Create("DButton",PanelConfig)
        button:SetText( "" )
        
        button:SetPos( RespW(250-RespW(150)) , RespH(550) )
        button:SetSize(RespW(300), RespH(60) )
        button.DoClick = function()
            if (!IsValid(DermaPanel)&& cooldown+cooldownLotto<CurTime()) then
                LocalPlayer():EmitSound(Sound("garrysmod/ui_click.wav"))
                net.Start("lotto_start")
                net.SendToServer()
                cooldown = CurTime()
                gameLaunched = true
                if PanelConfig!=nil then
                    PanelConfig:Remove()
                end
                timer.Simple(tempsChoixGagnant,function()
                    participants = ""
                    if PanelConfig!=nil then
                        PanelConfig:Remove()
                    end
                    gameLaunched = false
                end)
            else
                local time = string.ToMinutesSeconds( cooldown+cooldownLotto-CurTime() )
                LocalPlayer():EmitSound("garrysmod/ui_return.wav")
                notification.AddLegacy("Vous devez encore attendre "..time, NOTIFY_ERROR, 3)
            end
        end
        button.Paint = function(self, w, h)
            draw.RoundedBox(30, 0, 0, w, h, Color(0,119,255))
            draw.SimpleText("LANCER", "Font_big",w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        end
    
        local buttonR = vgui.Create("DButton",PanelConfig)
        buttonR:SetText( "" )
        
        buttonR:SetPos( RespW(750-RespW(150)) , RespH(550) )
        buttonR:SetSize(RespW(300), RespH(60) )
        if (gameLaunched || #participants!=0) then
            buttonR:CenterHorizontal()
        end
        buttonR.DoClick = function()
            PanelConfig:Remove()
            LocalPlayer():EmitSound("garrysmod/ui_return.wav")
        end
        buttonR.Paint = function(self, w, h)
            draw.RoundedBox(30, 0, 0, w, h, Color(0,119,255))
            draw.SimpleText("FERMER", "Font_big",w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

    else
        PanelConfig:Remove()

    end 
end

net.Receive("lottoParticipant",function(_,_)
    if (#participants==0) then
        participants = net.ReadString()
    else
        participants = participants..", "..net.ReadString()
    end
end)

hook.Add( "OnPlayerChat", "HelloCommand", function( ply, strText, bTeam, bDead ) 
    if ( ply != LocalPlayer()|| (string.Trim(string.lower(strText))!="!loterie" && string.Trim(string.lower(strText))!="!lotto") || ply:Team()!=TEAM_CITIZEN) then return end 
    lottoPanel(true)
end )