return function(Config)
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local LocalPlayer=Players.LocalPlayer
local Camera=workspace.CurrentCamera
local Mouse=LocalPlayer:GetMouse()
local AimbotEnabled=false
local PriorityMode=Config.AimbotPriority or "Crosshair"
UserInputService.InputBegan:Connect(function(input,gp)
if gp then return end
if input.KeyCode==Config.AimbotKey then
AimbotEnabled=not AimbotEnabled
print("[Aimbot] "..(AimbotEnabled and "Ativado" or "Desativado"))
elseif input.KeyCode==Config.PrioritySwitchKey then
PriorityMode=(PriorityMode=="Crosshair") and "Distance" or "Crosshair"
print("[Aimbot] Prioridade trocada para "..PriorityMode)
end
end)
local function isVisible(part)
local origin=Camera.CFrame.Position
local direction=(part.Position-origin).Unit*1000
local params=RaycastParams.new()
params.FilterDescendantsInstances={LocalPlayer.Character}
params.FilterType=Enum.RaycastFilterType.Blacklist
local result=workspace:Raycast(origin,direction,params)
return (not result) or (result.Instance:IsDescendantOf(part.Parent))
end
local function getBestPart(character)
local parts={"Head","UpperTorso","HumanoidRootPart"}
for _,name in ipairs(parts) do
local part=character:FindFirstChild(name)
if part and isVisible(part) then
return part
end
end
return nil
end
local function getTarget()
local closest,dist=nil,math.huge
for _,p in ipairs(Players:GetPlayers()) do
if p~=LocalPlayer and p.Character then
local part=getBestPart(p.Character)
if part then
local screenPos,vis=Camera:WorldToViewportPoint(part.Position)
if vis then
if PriorityMode=="Crosshair" then
local mag=(Vector2.new(screenPos.X,screenPos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
if mag<dist and mag<Config.AimbotFOV then closest,dist=part,mag end
elseif PriorityMode=="Distance" then
local mag=(part.Position-LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
if mag<dist then closest,dist=part,mag end
end
end
end
end
end
return closest
end
RunService.RenderStepped:Connect(function()
if not Config.EnableAimbot or not AimbotEnabled then return end
local target=getTarget()
if target then
local pos=Camera:WorldToViewportPoint(target.Position)
mousemoverel((pos.X-Mouse.X)*Config.AimbotSmoothness,(pos.Y-Mouse.Y)*Config.AimbotSmoothness)
end
end)
end