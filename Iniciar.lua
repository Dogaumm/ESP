local function loadUtil(name)
    local s,r=pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Dogaumm/ESP/main/utils/"..name..".lua"))()
    end)
    if not s then warn("Falha "..name..":"..tostring(r)) else print(name.." carregado") end
    return r
end

local function loadLib(name)
    local s,r=pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Dogaumm/ESP/main/libs/"..name..".lua"))()
    end)
    if not s then warn("Falha "..name..":"..tostring(r)) else print(name.." carregado") end
    return r
end

local Config=loadUtil("Config")
local Notify=loadUtil("Notify")
local Main=loadUtil("Main")

if Config.EnableESP then loadLib("ESP")(Config,Notify) end
if Config.EnableTracers then loadLib("TraceLines")(Config,Notify) end
if Config.EnableAimbot then loadLib("Aimbot")(Config,Notify) end