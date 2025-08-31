return function(Config)
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local LocalPlayer=Players.LocalPlayer
local Camera=workspace.CurrentCamera
local Mouse=LocalPlayer:GetMouse()

local function getClosest()
local closest,d=nil,math.huge
for _,p in pairs(Players:GetPlayers()) do
if p~=LocalPlayer and p.Character and p.Character:FindFirstChild(Config.AimbotTargetPart) then
local pos,vis=Camera:WorldToViewportPoint(p.Character[Config.AimbotTargetPart].Position)
if vis then
local mag=(Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
if mag<d and mag<Config.AimbotFOV then closest,d=p.Character[Config.AimbotTargetPart],mag end
end
end
end
return closest
end

RunService.RenderStepped:Connect(function()
if not Config.EnableAimbot then return end
local t=getClosest()
if t then
local pos=Camera:WorldToViewportPoint(t.Position)
mousemoverel((pos.X-Mouse.X)*Config.AimbotSmoothness,(pos.Y-Mouse.Y)*Config.AimbotSmoothness)
end
end)
end
