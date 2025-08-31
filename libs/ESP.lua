return function(Config)
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local LocalPlayer=Players.LocalPlayer

local function getColor(p)
if not p.Team or not LocalPlayer.Team then return Config.ESPNeutralColor end
return (p.Team==LocalPlayer.Team) and Config.ESPAllyColor or Config.ESPEnemyColor
end

local function setup(p,c)
if not c or p==LocalPlayer then return end
local hrp=c:WaitForChild("HumanoidRootPart",5)
if not hrp then return end

local box=Instance.new("BoxHandleAdornment")
box.Name="ESPBox"
box.Adornee=hrp
box.Size=Vector3.new(4,6,4)
box.AlwaysOnTop=true
box.ZIndex=5
box.Transparency=0.3
box.Color3=getColor(p)
box.Parent=hrp

local bb=Instance.new("BillboardGui")
bb.Name="ESPBillboard"
bb.Adornee=hrp
bb.Size=UDim2.new(4,0,1,0)
bb.AlwaysOnTop=true
bb.MaxDistance=Config.ESPMaxDistance
local lbl=Instance.new("TextLabel",bb)
lbl.Size=UDim2.new(1,0,1,0)
lbl.BackgroundTransparency=1
lbl.TextColor3=getColor(p)
lbl.TextScaled=true
lbl.Font=Enum.Font.SourceSansBold
lbl.Text=string.format("%s - %d HP",p.Name,100)
bb.Parent=hrp
local hum=c:WaitForChild("Humanoid",5)
if hum then hum:GetPropertyChangedSignal("Health"):Connect(function()
lbl.Text=string.format("%s - %d HP",p.Name,math.floor(hum.Health))
end) end
end

local function clear(c)
for _,o in ipairs(c:GetDescendants()) do
if o:IsA("BoxHandleAdornment") or o:IsA("BillboardGui") then o:Destroy() end
end
end

local function apply()
for _,p in pairs(Players:GetPlayers()) do
if p~=LocalPlayer then
if p.Character then clear(p.Character) setup(p,p.Character) end
p.CharacterAdded:Connect(function(c) clear(c) setup(p,c) end)
end
end
end

RunService.RenderStepped:Connect(function()
for _,p in pairs(Players:GetPlayers()) do
if p~=LocalPlayer and p.Character then
local hrp=p.Character:FindFirstChild("HumanoidRootPart")
if hrp then
local box=hrp:FindFirstChild("ESPBox")
local bb=hrp:FindFirstChild("ESPBillboard")
if box then box.Color3=getColor(p) end
if bb then local lbl=bb:FindFirstChildOfClass("TextLabel") if lbl then lbl.TextColor3=getColor(p) end end
end
end
end
end)

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() apply() end)
apply()
end
