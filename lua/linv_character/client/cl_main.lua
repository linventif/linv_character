hook.Add("InitPostEntity", "plyDataSaver:InitPostEntity", function()
    local function selectChar(id)
        print("Selected char " .. id)
    end

    local frame = vgui.Create("DFrame")
    frame:SetPos(ScrW() / 2 - 250, ScrH() / 2 - 150)
    frame:SetSize(500, 300)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetTitle("Selection du Personnage")
    frame:MakePopup()

    local char_1 = vgui.Create("DButton", frame)
    char_1:SetText("Select Char 1")
    char_1:SetPos(25, 50)
    char_1:SetSize(250, 30)
    char_1.DoClick = function()
        // close frame
        frame:Close()
        plyDataSaver.sendNet("clientReady")
    end
end)