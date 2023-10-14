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
    if (!data.linv_char) then return end
    data.linv_char = util.JSONToTable(data.linv_char) || {}

    local newNature = false
    if (!data.linv_char.nature || !linvChar.Config.Natures[data.linv_char.nature]) then
        data.linv_char.nature = pickNature()
        newNature = true
    end

    ply:SetNWString("linv_nature", data.linv_char.nature)
    ply:SetNWInt("linv_mana", data.linv_char.mana || linvChar.Config.DefaultMana)
    ply:SetNWInt("linv_mana_max", data.linv_char.mana_max || linvChar.Config.DefaultMana)

    if (newNature) then
        linvChar.savePlayerData(ply)
    end
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