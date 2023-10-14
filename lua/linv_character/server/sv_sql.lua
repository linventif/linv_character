hook.Add("linv_plyDataSaver_SQL_Init", "linv_char_add_sql", function()
    LinvLib.SQL.Query("SELECT * FROM plyDataSaver LIMIT 1", function(data)
        if (!data || !data[1]) then
            LinvLib.SQL.Query("ALTER TABLE plyDataSaver ADD linv_char TEXT DEFAULT '{}'")
            LinvLib.SQL.Query("UPDATE plyDataSaver SET linv_char = '{}'")
        end
    end)
end)

function linvChar.savePlayerData(ply)
    // Char ID
    local charID = ply:GetLinvCharID() || 1

    local data = util.TableToJSON({
        nature = ply:GetLinvNature();
        mana = ply:GetLinvMana(),
        mana_max = ply:GetLinvManaMax()
    })

    LinvLib.SQL.Query("UPDATE plyDataSaver SET linv_char = '" .. data .. "' WHERE steamID64 = '" .. ply:SteamID64() .. "'")
end

// Create DB Stucture
hook.Add("LinvLib.SQL.Init", "linvChar:SQL:Init", function()
    LinvLib.SQL.Query("CREATE TABLE IF NOT EXISTS linvChar (steamID64 CHAR(255), reroll INT, PRIMARY KEY (steamID64))")
end)

hook.Add("linv_plyDataSaver_savePlyData", "linv_char_savePlyData", function(ply)
    linvChar.savePlayerData(ply)
end)

function linvChar.addReroll(steam, reroll)
    LinvLib.SQL.Query("SELECT * FROM linvChar WHERE steamID64 = '" .. steam .. "'", function(data)
        if (!data || !data[1]) then
            data.reroll = linvChar.Config.DefaultReroll + reroll
            LinvLib.SQL.Query("INSERT INTO linvChar (steamID64, reroll) VALUES ('" .. steam .. "', " .. data.reroll .. ")")

            local ply = player.GetBySteamID64(steam)
            if (ply) then
                ply:SetNWInt("linv_reroll", data.reroll || 0)
                ply:ChatPrint("Vous avez reçu " .. data.reroll .. " reroll")
            end
        else
            data = data[1]
            data.reroll = tonumber(data.reroll) + reroll
            LinvLib.SQL.Query("UPDATE linvChar SET reroll = " .. data.reroll .. " WHERE steamID64 = '" .. steam .. "'")

            local ply = player.GetBySteamID64(steam)
            if (ply) then
                ply:SetNWInt("linv_reroll", data.reroll || 0)
                ply:ChatPrint("Vous avez reçu " .. data.reroll .. " reroll")
            end
        end
    end)
end