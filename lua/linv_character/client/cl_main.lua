local function selectChar(id)
    print("Selected char " .. id)
end

local frame = vgui.Create("DFrame")
frame:SetPos(ScrW() / 2 - 300, ScrH() / 2 - 200)
frame:SetSize(600, 400)
frame:SetTitle("Selection du Personnage")
frame:MakePopup()

local char_1 = vgui.Create("DButton", frame)
char_1:SetText("Select Char 1")
char_1:SetPos(25, 50)
char_1:SetSize(250, 30)
char_1.DoClick = function()
    selectChar(1)
end

local char_2 = vgui.Create("DButton", frame)
char_2:SetText("Select Char 2")
char_2:SetPos(25, 100)
char_2:SetSize(250, 30)
char_2.DoClick = function()
    selectChar(2)
end

local char_admin = vgui.Create("DButton", frame)
char_admin:SetText("Select Char Admin")
char_admin:SetPos(25, 150)
char_admin:SetSize(250, 30)
char_admin.DoClick = function()
    selectChar("admin")
end