hook.Add("linv_plyDataSaver_SQL_Init", "linv_char_add_sql", function(data)
    if (!data[1]) then return end

    // Add Linv Char
    if (!data[1].linv_char) then
        LinvLib.SQL.Query("ALTER TABLE plyDataSaver ADD linv_char TEXT")
        LinvLib.SQL.Query("UPDATE plyDataSaver SET linv_char = '[]'")
    end
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

hook.Add("linv_plyDataSaver_savePlyData", "linv_char_savePlyData", function(ply)
    linvChar.savePlayerData(ply)
end)