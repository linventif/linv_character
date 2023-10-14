//
// Network
//

// Variables
local netName = "linvChar"
local netTable = {
    [0] = "reroll",
    [1] = "clientReady"
}

// Add Network Strings
util.AddNetworkString(netName)

// Receive
net.Receive(netName, function(len, ply)
    local id = net.ReadUInt(8)
    local data = util.JSONToTable(net.ReadString())
    if (linvChar["net"][netTable[id]]) then linvChar["net"][netTable[id]](ply, data) end
end)