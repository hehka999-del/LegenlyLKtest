--[[
    Включает музыку для всех в Школе 102 РП
    Использует HDAdmin (админ-система игры)
    ID: 137962895289195
]]

local RS = game:GetService("ReplicatedStorage")

-- Ищем HDAdmin (может называться по-разному)
local adminSystem = RS:FindFirstChild("HDAdminHDClient") 
    or RS:FindFirstChild("Admin") 
    or RS:FindFirstChild("Admins")
    or RS:FindFirstChild("AdminSystem")

if not adminSystem then
    -- Пробуем найти через RemoteEvent
    for _, child in pairs(RS:GetDescendants()) do
        if child:IsA("RemoteEvent") and (child.Name:find("Admin") or child.Name:find("Command")) then
            adminSystem = child.Parent
            break
        end
    end
end

if adminSystem then
    local signals = adminSystem:FindFirstChild("Signals") or adminSystem
    local req = signals:FindFirstChild("RequestCommand") 
        or signals:FindFirstChild("Command") 
        or signals:FindFirstChild("Execute")
    
    if req then
        -- Включаем музыку для всех
        local success, err = pcall(function()
            req:InvokeServer(";music 137962895289195 ;volume inf")
            wait(0.5)
            req:InvokeServer(";music 137962895289195 ;volume 10")
            wait(0.5)
            req:InvokeServer(";volume 10")
        end)
        
        if success then
            print("🎵 Музыка играет для всех!")
        else
            print("❌ Ошибка: " .. tostring(err))
        end
    else
        print("❌ RemoteCommand не найден")
    end
else
    print("❌ Админ-система не найдена")
end
