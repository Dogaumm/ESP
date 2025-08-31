local Players=game:GetService("Players")
local lp=Players.LocalPlayer
return function(cfg)
    local run=game:GetService("RunService").RenderStepped
    local lines={}
    run:Connect(function()
        for _,line in pairs(lines)do line:Destroy()end
        lines={}
        local lpc=lp.Character if not lpc then return end
        local lphrp=lpc:FindFirstChild("HumanoidRootPart")if not lphrp then return end
        for _,p in pairs(Players:GetPlayers())do
            if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then
                if (cfg.TeamMode=="AllEnemies" and p.Team~=lp.Team) or (cfg.TeamMode=="All") then
                    local hrp=p.Character.HumanoidRootPart
                    local b=Instance.new("Beam")b.Name="TraceLine"b.FaceCamera=true b.Width0=0.1 b.Width1=0.1
                    local a0=Instance.new("Attachment",lphrp)local a1=Instance.new("Attachment",hrp)
                    b.Attachment0=a0 b.Attachment1=a1
                    b.Color=ColorSequence.new((cfg.TeamMode=="ByTeam")and p.TeamColor.Color or (p.Team~=lp.Team and Color3.new(1,0,0) or Color3.new(0,1,0)))
                    b.Parent=hrp table.insert(lines,b)
                end
            end
        end
    end)
end