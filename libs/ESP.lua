local Players=game:GetService("Players")
local lp=Players.LocalPlayer
local function teamCheck(p,cfg)return cfg.TeamMode=="AllEnemies" and p.Team~=lp.Team or cfg.TeamMode=="All" end
local function color(p,cfg)if cfg.TeamMode=="ByTeam" then return p.TeamColor.Color elseif p.Team~=lp.Team then return Color3.new(1,0,0) else return Color3.new(0,1,0) end end
return function(cfg)
    local conns={}
    getgenv().ESP_Connections=conns
    local function addEsp(plr)
        if plr==lp then return end
        plr.CharacterAdded:Connect(function(char)
            local hrp=char:WaitForChild("HumanoidRootPart")
            if not teamCheck(plr,cfg) then return end
            local box=Instance.new("BoxHandleAdornment")
            box.Name="ESP_Box"box.Adornee=hrp box.Size=Vector3.new(4,6,4)box.AlwaysOnTop=true box.ZIndex=5 box.Transparency=0.45 box.Color3=color(plr,cfg)box.Parent=hrp
            if plr.Team~=lp.Team then
                local bb=Instance.new("BillboardGui")bb.Name="ESP_Billboard"bb.Adornee=hrp bb.Size=UDim2.new(4,0,1,0)bb.AlwaysOnTop=true bb.MaxDistance=100
                local txt=Instance.new("TextLabel",bb)txt.Size=UDim2.new(1,0,1,0)txt.BackgroundTransparency=1 txt.TextColor3=color(plr,cfg)txt.TextScaled=true txt.Font=Enum.Font.SourceSansBold
                local hum=char:WaitForChild("Humanoid")txt.Text=plr.Name.." - "..math.floor(hum.Health).." HP"
                hum:GetPropertyChangedSignal("Health"):Connect(function()txt.Text=plr.Name.." - "..math.floor(hum.Health).." HP"end)
                bb.Parent=hrp
            end
        end)
    end
    for _,p in pairs(Players:GetPlayers())do addEsp(p)end
    table.insert(conns,Players.PlayerAdded:Connect(addEsp))
end