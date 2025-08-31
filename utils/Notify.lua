local sg=game:GetService("StarterGui")
local pg=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

return function(txt)
    local ok=pcall(function()
        sg:SetCore("SendNotification",{Title="ESP Hub",Text=txt,Duration=3})
    end)
    if not ok then
        local s=Instance.new("ScreenGui",pg)s.Name="ESP_Notify"
        local l=Instance.new("TextLabel",s)l.Size=UDim2.new(0.3,0,0.05,0)l.Position=UDim2.new(0.35,0,0,5)
        l.BackgroundTransparency=0.3 l.BackgroundColor3=Color3.new(0,0,0)
        l.TextColor3=Color3.new(1,1,1)l.Font=Enum.Font.SourceSansBold l.TextScaled=true
        l.Text=txt
        task.delay(3,function()s:Destroy()end)
    end
end