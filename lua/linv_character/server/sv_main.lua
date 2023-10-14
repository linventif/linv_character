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

hook.Add("linv_plyDataSaver_loadPlyData", "linvChar.loadPlyData", function(ply, data)
    LinvLib.SQL.Query("SELECT * FROM linvChar WHERE steamID64 = '" .. ply:SteamID64() .. "'", function(data)
        data = data[1] || {}
        if (!data) then
            LinvLib.SQL.Query("INSERT INTO linvChar (steamID64, reroll) VALUES ('" .. ply:SteamID64() .. "', " .. linvChar.Config.DefaultReroll .. ")")
            data = {
                reroll = linvChar.Config.DefaultReroll
            }
        end

        ply:SetNWInt("linv_reroll", data.reroll || 0)
    end)

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
    return self:GetNWString("linv_nature")
end

function meta:GetLinvMana()
    return self:GetNWInt("linv_mana")
end

function meta:GetLinvManaMax()
    return self:GetNWInt("linv_mana_max")
end

function meta:RerollLinvNature()
    LinvLib.SQL.Query("SELECT * FROM linvChar WHERE steamID64 = '" .. self:SteamID64() .. "'", function(data)
        if (!data || !data[1] || !(data.reroll > 0)) then
            self:ChatPrint("Vous n'avez plus de reroll disponible, vous pouvez en acheter sur notre boutique https://fogo-rp.fr")
            return
        end

        data = data[1]

        local newNature = pickNature()
        self:SetNWString("linv_nature", newNature)
        self:ChatPrint("Vous avez reroll votre nature, vous êtes maintenant " .. newNature .. " !")

        LinvLib.SQL.Query("UPDATE linvChar SET reroll = reroll - 1 WHERE steamID64 = '" .. self:SteamID64() .. "'")
        linvChar.savePlayerData(ply)
    end)
end

linvChar.net = linvChar.net || {}
function linvChar.net.reroll(ply)
    ply:RerollLinvNature()
end