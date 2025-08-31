return function(Config)
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local LocalPlayer=Players.LocalPlayer
local TeamMode=Config.TeamMode or "Default" -- Default | AllEnemies | TeamColors
UserInputService.InputBegan:Connect(function(input,gp)
if gp then return end
if input.KeyCode==Config.TeamModeSwitchKey then
if TeamMode=="Default" then TeamMode="AllEnemies"
elseif TeamMode=="AllEnemies" then TeamMode="TeamColors"
else TeamMode="Default" end
print("[ESP] TeamMode trocado para "..TeamMode)
end
end)
local function getColor(p)
if TeamMode=="AllEnemies" then
return Config.ESPEnemyColor
elseif TeamMode=="TeamColors" then
return p.Team and p.Team.TeamColor.Color or Config.ESPNeutralColor
else
if not p.Team or not LocalPlayer.Team then return Config.ESPNeutralColor end
return (p.Team==LocalPlayer.Team) and Config.ESPAllyColor or Config.ESPEnemyColor
end
end
local function setup(p,c)
if not c or p==LocalPlayer then return end
local hrp=c:WaitForChild("HumanoidRootPart",5)
local head=c:WaitForChild("Head",5)
if not hrp or not head then return end
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
bb.Adornee=head
bb.Size=UDim2.new(4,0,1,0)
bb.AlwaysOnTop=true
bb.MaxDistance=Config.ESPMaxDistance
local lbl=Instance.new("TextLabel",bb)
lbl.Size=UDim2.new(1,0,1,0)
lbl.BackgroundTransparency=1
lbl.TextColor3=getColor(p)
lbl.TextScaled=true
lbl.Font=Enum.Font.SourceSansBold
lbl.Text=string.format("%s - %d HP - %.0f studs",p.Name,100,(hrp.Position-LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
bb.Parent=head
local hum=c:WaitForChild("Humanoid",5)
if hum then hum:GetPropertyChangedSignal("Health"):Connect(function()
lbl.Text=string.format("%s - %d HP - %.0f studs",p.Name,math.floor(hum.Health),(hrp.Position-LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
end) end
local a0=Instance.new("Attachment",LocalPlayer.Character:WaitForChild("HumanoidRootPart"))
local a1=Instance.new("Attachment",hrp)
local beam=Instance.new("Beam")
beam.Name="ESPTracer"
beam.Attachment0=a0
beam.Attachment1=a1
beam.Width0=1 beam.Width1=1
beam.FaceCamera=true
beam.Color=ColorSequence.new(getColor(p))
beam.Parent=hrp
end
local function clear(c)
for _,o in ipairs(c:GetDescendants()) do
if o:IsA("BoxHandleAdornment") or o:IsA("BillboardGui") or o:IsA("Beam") then o:Destroy() end
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
local head=p.Character:FindFirstChild("Head")
if hrp and head then
local box=hrp:FindFirstChild("ESPBox")
local bb=head:FindFirstChild("ESPBillboard")
local tracer=hrp:FindFirstChild("ESPTracer")
if box then box.Color3=getColor(p) end
if bb then local lbl=bb:FindFirstChildOfClass("TextLabel") if lbl then lbl.TextColor3=getColor(p) end end
if tracer then tracer.Color=ColorSequence.new(getColor(p)) end
end
end
end
end)
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() apply() end)
apply()
end