//
// Network
//

// Variables
local netName = "linvChar"
local netTable = {
    ["reroll"] = 0,
    ["clientReady"] = 1
}

// Send
function linvChar.sendNet(id, args)
    net.Start(netName)
    net.WriteUInt(netTable[id], 8)
    net.WriteString(util.TableToJSON(args || {}))
    net.SendToServer()
end