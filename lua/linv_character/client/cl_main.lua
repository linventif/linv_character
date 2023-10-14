hook.Add("InitPostEntity", "linvChar:InitPostEntity", function()
    plyDataSaver.sendNet("clientReady")
end)

function menuReroll()
    local frame = vgui.Create("DFrame")
    frame:SetPos(ScrW() / 2 - 187.5, ScrH() / 2 - 110)
    frame:SetSize(375, 220)
    frame:SetDraggable(false)
    frame:ShowCloseButton(true)
    frame:SetTitle("Reroll - Menu Temporaire")
    frame:MakePopup()

    local DLabel = vgui.Create("DLabel", frame )
    DLabel:SetPos(30, 10)
    DLabel:SetSize(300, 100)
    DLabel:SetText("Menu Temporaire | Ui c'est moche")

    local DLabelNature = vgui.Create("DLabel", frame )
    DLabelNature:SetPos(30, 40)
    DLabelNature:SetSize(300, 100)
    DLabelNature:SetText("Nature Actuelle: " .. LocalPlayer():GetNWString("linv_nature"))

    local DLabelReroll = vgui.Create("DLabel", frame )
    DLabelReroll:SetPos(30, 70)
    DLabelReroll:SetSize(300, 100)
    DLabelReroll:SetText("Reroll Restant: " .. LocalPlayer():GetNWInt("linv_reroll"))

    local buy_reroll = vgui.Create("DButton", frame)
    buy_reroll:SetText("Acheter des Reroll")
    buy_reroll:SetPos(25, 150)
    buy_reroll:SetSize(150, 40)
    buy_reroll.DoClick = function()
        gui.OpenURL("https://fogo-rp.fr/store/packages/1")
    end

    local reroll = vgui.Create("DButton", frame)
    reroll:SetText("Reroll sa Nature")
    reroll:SetPos(200, 150)
    reroll:SetSize(150, 40)
    reroll.DoClick = function()
        linvChar.sendNet("reroll")
        frame:Close()
    end
end

// when /roll in chat open menu
hook.Add("OnPlayerChat", "plyDataSaver:OnPlayerChat", function(ply, text)
    if ply == LocalPlayer() then
        text = string.lower(text)
        if (text == "/roll") || (text == "/reroll") then
            ply:ChatPrint("Utilisez /reroll pour reroll votre nature, /roll ne fonctionne plus pour les natures")
            menuReroll()
        end
    end
end)