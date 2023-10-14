local function convertNatureDrop()
    local total = 0
    for k, v in pairs(linvChar.Config.Natures) do
        total = total + v.drop
    end

    if total == 1 then return end

    for k, v in pairs(linvChar.Config.Natures) do
        v.drop = v.drop / total
    end
end

local function pickNature()
    local random = math.random()
    local naturePicked = nil

    convertNatureDrop()

    for k, v in pairs(linvChar.Config.Natures) do
        if random <= v.drop then
            return k
        end
        random = random - v.drop
    end
end

local function showStat(try)
    print(" ")
    print("---- Nature Stat ----")

    for k, v in pairs(linvChar.Config.Natures) do
        print(k, v.drop * 100 .. "%")
    end

    print(" ")
    print("---- Test for " .. try .. " tries ----")

    local test = {}
    for i = 1, try do
        local naturePicked = pickNature()
        if test[naturePicked] then
            test[naturePicked] = test[naturePicked] + 1
        else
            test[naturePicked] = 1
        end
    end

    // print the result
    for k, v in pairs(test) do
        print(k, v / try * 100 .. "%")
    end
end

concommand.Add("linv_char", function(ply, cmd, args)
    if (ply != NULL) then return end
    local try = tonumber(args[1]) || 1000
    showStat(try)
end)

hook.Add("linv_plyDataSaver_loadPlyData", "linvChar.loadPlyData", function(ply, data)
    if (!data.linv_char) then return end

    data.linv_char = util.JSONToTable(data.linv_char) || {}

    if (!data.linv_char.nature || !linvChar.Config.Natures[data.linv_char.nature]) then
        ply:RerollLinvNature()
    else
        ply:SetNWString("linv_nature", data.linv_char.nature)
    end

    ply:SetNWInt("linv_mana", data.linv_char.mana || linvChar.Config.DefaultMana)
    ply:SetNWInt("linv_mana_max", data.linv_char.mana_max || linvChar.Config.DefaultMana)
end)

local meta = FindMetaTable("Player")

function meta:GetLinvCharID()
    return self.linv_char_id || 1
end

function meta:GetLinvNature()
    local nature = self:GetNWString("linv_nature")
    if (!nature || !linvChar.Config.Natures[nature]) then
        self:RerollLinvNature()
        return self:GetLinvNature()
    else
        return nature
    end
end

function meta:GetLinvMana()
    return self:GetNWInt("linv_mana")
end

function meta:GetLinvManaMax()
    return self:GetNWInt("linv_mana_max")
end

function meta:TryRerollLinvNature()
    LinvLib.SQL.Query("SELECT * FROM linvChar WHERE steamID64 = '" .. self:SteamID64() .. "'", function(data)
        if (!data || !data[1] || !(data[1].reroll > 0)) then
            self:ChatPrint("Vous n'avez plus de reroll disponible, vous pouvez en acheter sur notre boutique https://fogo-rp.fr")
            return
        end
        self:RerollLinvNature()
        LinvLib.SQL.Query("UPDATE linvChar SET reroll = reroll - 1 WHERE steamID64 = '" .. self:SteamID64() .. "'")
        self:SetNWInt("linv_reroll", self:GetNWInt("linv_reroll") - 1)
    end)
end

function meta:RerollLinvNature()
    local newNature = pickNature()
    self:SetNWString("linv_nature", newNature)
    self:ChatPrint("Vous avez reroll votre nature, vous êtes maintenant " .. newNature .. " !")

    linvChar.savePlayerData(self)
end

linvChar.net = linvChar.net || {}

function linvChar.net.reroll(ply)
    ply:TryRerollLinvNature()
end

function linvChar.net.clientReady(ply)
    LinvLib.SQL.Query("SELECT * FROM linvChar WHERE steamID64 = '" .. ply:SteamID64() .. "'", function(data)
        if (!data || !data[1]) then
            LinvLib.SQL.Query("INSERT INTO linvChar (steamID64, reroll) VALUES ('" .. ply:SteamID64() .. "', " .. linvChar.Config.DefaultReroll .. ")")

            ply:SetNWInt("linv_reroll", linvChar.Config.DefaultReroll)
        else
            ply:SetNWInt("linv_reroll", data[1].reroll || 0)
        end
    end)
end