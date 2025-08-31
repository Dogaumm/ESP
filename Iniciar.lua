local function loadLib(name)
local s,r=pcall(function()
return loadstring(game:HttpGet("https://raw.githubusercontent.com/Dogaumm/ESP/main/libs/"..name..".lua"))()
end)
if not s then warn("Falha "..name..":"..tostring(r)) else print(name.." carregado") end
return r
end

local Config=loadLib("Config")
loadLib("Utils")
if Config.EnableESP then loadLib("ESP")(Config) end
if Config.EnableAimbot then loadLib("Aimbot")(Config) end