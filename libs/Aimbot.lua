local uis=game:GetService("UserInputService")
local rs=game:GetService("RunService")
local plrs=game:GetService("Players")
local lp=plrs.LocalPlayer
local cam=workspace.CurrentCamera

return function(cfg)
    local enabled=false
    local mode="NearestToCrosshair"
    local toggleKey=cfg.AimbotToggleKey or Enum.KeyCode.Z
    local switchKey=cfg.AimbotSwitchKey or Enum.KeyCode.X

    uis.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode==toggleKey then enabled=not enabled end
        if i.KeyCode==switchKey then
            mode=mode=="NearestToCrosshair" and "NearestPlayer" or "NearestToCrosshair"
        end
    end)

    local function validTarget(p)
        if p==lp or not p.Character then return false end
        if cfg.TeamMode=="AllEnemies" and p.Team==lp.Team then return false end
        return p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid")
    end

    local function getBone(c)
        local h=c:FindFirstChild("Head")if h and cam:WorldToViewportPoint(h.Position) then return h end
        local t=c:FindFirstChild("UpperTorso")or c:FindFirstChild("Torso")if t then return t end
        return c:FindFirstChild("HumanoidRootPart")
    end

    local function nearest()
        local best,dist=nil,1e9
        for _,p in pairs(plrs:GetPlayers())do
            if validTarget(p)then
                local b=getBone(p.Character)if not b then continue end
                local pos,vis=cam:WorldToViewportPoint(b.Position)
                if vis then
                    if mode=="NearestToCrosshair" then
                        local d=(Vector2.new(pos.X,pos.Y)-uis:GetMouseLocation()).Magnitude
                        if d<dist then dist=d best=b end
                    else
                        local d=(lp.Character.HumanoidRootPart.Position-b.Position).Magnitude
                        if d<dist then dist=d best=b end
                    end
                end
            end
        end
        return best
    end

    rs.RenderStepped:Connect(function()
        if not enabled then return end
        local b=nearest()
        if b then
            cam.CFrame=CFrame.new(cam.CFrame.Position,b.Position)
        end
    end)
end