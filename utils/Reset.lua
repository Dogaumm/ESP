return function()
    for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "ESP_UI" or v.Name=="ESP_Box" or v.Name=="ESP_Billboard" or v.Name=="TraceLine" then
            v:Destroy()
        end
    end
    if getgenv().ESP_Connections then
        for _,c in pairs(getgenv().ESP_Connections) do
            pcall(function() c:Disconnect() end)
        end
    end
    getgenv().ESP_Connections={}
    print("[ESP] Reset concluído")
end