/*
Made by Eren -> https://steamcommunity.com/id/ErenRbac/
*/
local scrW = ScrW()
local scrH = ScrH()

local function RespW(size) return size/(scrW/1920) end
local function RespH(size) return size/(scrH/1080) end
local function PosWBasedOnSize(size) return scrW-size end
local tempsFermetureInscription = 3*60 // temps avant fermeture des inscriptions
surface.CreateFont("Font_med", {
    font = "Arial",
   weight = 30000,
    extended = true,
    size = 30,
 
})
local function minimap(status)
    if status then
        DermaPanel = vgui.Create("DFrame") -- The name DermaPanel to store the value DFrame.
        DermaPanel:SetSize(RespW(450), RespH(200)) -- Sets the size to 500x by 300y.
        DermaPanel:SetPos(RespW(PosWBasedOnSize(450)),0)
        DermaPanel:SetTitle("") -- Set the title to nothing.
        DermaPanel:SetDraggable(false) -- Makes it so you can't drag it.
        DermaPanel:ShowCloseButton( false )
        DermaPanel.Paint = function(self, w, h)
            draw.RoundedBox(30, 0, 0, w, h, Color(0,119,255,52))
            surface.SetDrawColor(0,119,255)
            surface.DrawRect(0,0,w,h/4)
            draw.SimpleText("LOTERIE", "Font_big",w/2, h/8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Une lotterie est en cours !", "Font_small",w/20, h/2.6, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText("Le prix de participation est de 5000€", "Font_small",w/20, h/1.9, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        end

        local removebutt = vgui.Create("DButton",DermaPanel)
        removebutt:SetText( "" )
        
        removebutt:SetPos( RespW(418) , RespH(8) )
        removebutt:SetSize(RespW(20), RespH(7) )
        removebutt.DoClick = function()
            DermaPanel:Remove()
            LocalPlayer():EmitSound("garrysmod/ui_return.wav")
        end
        removebutt.Paint = function(self, w, h)
            draw.RoundedBox(30, 0, 0, w, h, Color(255,255,255))
        end

        local button = vgui.Create("DButton",DermaPanel)
        button:SetText( "" )
        
        button:SetPos( 0 , RespH(140) )
        button:SetSize(RespW(450/2), RespH(40) )
        button:CenterHorizontal()
        button.DoClick = function()
            LocalPlayer():EmitSound( Sound( "garrysmod/save_load4.wav" ))
            DermaPanel:Remove()
            net.Start("joinLotto")
            net.SendToServer()
        end
        button.Paint = function(self, w, h)
            draw.RoundedBox(30, 0, 0, w, h, Color(0,119,255))
            draw.SimpleText("PARTICIPER", "Font_med",w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    else
        DermaPanel:Remove()

    end




end


net.Receive("lotto_startToCli",function(_,_)
    minimap(true)

    timer.Simple( tempsFermetureInscription, function()
        minimap(false)
    end)
end)

net.Receive("lottoWinner",function(_,_)
    local winnerName = net.ReadString()
    if winnerName == "02Kl_ lz12" then
        LocalPlayer():EmitSound("garrysmod/content_downloaded.wav")
        chat.AddText(Color(255,255,0),"[Loterie] ",Color(255,255,255),"Personne n'a gagné à la loterie (manque de participant)")
    return 
    end
    local montant = net.ReadInt(21)
    LocalPlayer():EmitSound("garrysmod/content_downloaded.wav")
    chat.AddText(Color(255,255,0),"[Loterie] ",Color(255,255,255),winnerName.." a gagné à la loterie, il a gagné "..montant.."€")
    
end)