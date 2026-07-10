--[[
    Legenly LK v9.0
    Только ККРП (Краснодар РП) + Музыка
    Минималистичный дизайн, всё работает
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

if _G.LegenlyLK_Loaded then return end
_G.LegenlyLK_Loaded = true

-- GUI (маленькое, простое)
local gui = Instance.new("ScreenGui")
gui.Name = "LegenlyLK"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Основное окно (маленькое, 300x400)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Заголовок (с кнопками закрытия и сворачивания)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.04, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Legenly LK"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

-- Кнопка сворачивания
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -52, 0, 3)
minBtn.BackgroundTransparency = 1
minBtn.Text = "_"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = header
minBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    miniBar.Visible = true
end)

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Мини-полоска (при сворачивании)
local miniBar = Instance.new("Frame")
miniBar.Size = UDim2.new(0, 120, 0, 30)
miniBar.Position = UDim2.new(0.5, -60, 0, 0)
miniBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
miniBar.BackgroundTransparency = 0.05
miniBar.BorderSizePixel = 0
miniBar.Visible = false
miniBar.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 8)
miniCorner.Parent = miniBar

local miniTitle = Instance.new("TextLabel")
miniTitle.Size = UDim2.new(1, 0, 1, 0)
miniTitle.BackgroundTransparency = 1
miniTitle.Text = "⚡ LK"
miniTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
miniTitle.TextScaled = true
miniTitle.Font = Enum.Font.GothamBold
miniTitle.Parent = miniBar

miniBar.MouseButton1Click:Connect(function()
    miniBar.Visible = false
    frame.Visible = true
end)

-- ScrollingFrame для контента
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 0, 600)
content.ScrollBarThickness = 4
content.Parent = frame

-- ===== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =====
local function createButton(parent, text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 55)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    return btn
end

local function createTextBox(parent, placeholder, y)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 30)
    box.Position = UDim2.new(0.05, 0, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    box.BorderSizePixel = 0
    box.Text = placeholder
    box.TextColor3 = Color3.fromRGB(200, 200, 200)
    box.TextScaled = true
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = box
    return box
end

-- ===== РАЗДЕЛ МУЗЫКИ =====
local musicLabel = Instance.new("TextLabel")
musicLabel.Size = UDim2.new(0.9, 0, 0, 25)
musicLabel.Position = UDim2.new(0.05, 0, 0, 10)
musicLabel.BackgroundTransparency = 1
musicLabel.Text = "🎵 МУЗЫКА (глобальная/локальная)"
musicLabel.TextColor3 = Color3.fromRGB(70, 150, 255)
musicLabel.TextScaled = true
musicLabel.Font = Enum.Font.GothamBold
musicLabel.Parent = content

local idBox = createTextBox(content, "Вставь ID звука...", 45)
local playBtn = createButton(content, "▶ Играть", 85, Color3.fromRGB(60, 120, 200))
playBtn.MouseButton1Click:Connect(function()
    local id = idBox.Text
    if id == "" or id == "Вставь ID звука..." then return end
    
    -- Поиск RemoteEvent для звука
    local remote = nil
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") and (child.Name:find("Sound") or child.Name:find("Audio") or child.Name:find("Play") or child.Name:find("Banana") or child.Name:match("^%d+$")) then
            remote = child
            break
        end
    end
    
    if remote then
        pcall(function()
            remote:FireServer("PlaySound", id)
            wait(0.05)
            remote:FireServer("PlayAudio", id)
            wait(0.05)
            remote:FireServer("Sound", id)
            wait(0.05)
            remote:FireServer("Play", id)
            wait(0.05)
            remote:FireServer(id)
        end)
        playBtn.Text = "✅ Отправлено"
        wait(1)
        playBtn.Text = "▶ Играть"
    else
        -- Локальный звук
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = 10
        sound.Parent = Workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 10)
        playBtn.Text = "⚠️ Локально"
        wait(1)
        playBtn.Text = "▶ Играть"
    end
end)

-- Готовые звуки
local sounds = {
    {"🔊 Взрыв", "165969964"},
    {"🚨 Сирена", "433848566"},
    {"😱 Скример", "7236490488"},
    {"💀 Страшный", "7854285068"},
    {"🎵 Мем", "9120399989"},
}
for i, data in pairs(sounds) do
    local btn = createButton(content, data[1], 130 + (i-1) * 38, Color3.fromRGB(45, 45, 60))
    btn.MouseButton1Click:Connect(function()
        -- Поиск RemoteEvent
        local remote = nil
        for _, child in pairs(ReplicatedStorage:GetDescendants()) do
            if child:IsA("RemoteEvent") and (child.Name:find("Sound") or child.Name:find("Audio") or child.Name:find("Play") or child.Name:find("Banana") or child.Name:match("^%d+$")) then
                remote = child
                break
            end
        end
        if remote then
            pcall(function()
                remote:FireServer("PlaySound", data[2])
                remote:FireServer("PlayAudio", data[2])
                remote:FireServer("Sound", data[2])
                remote:FireServer("Play", data[2])
                remote:FireServer(data[2])
            end)
            btn.Text = "✅"
            wait(1)
            btn.Text = data[1]
        else
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. data[2]
            sound.Volume = 10
            sound.Parent = Workspace
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 10)
            btn.Text = "⚠️"
            wait(1)
            btn.Text = data[1]
        end
    end)
end

-- ===== РАЗДЕЛ АДМИН-КОМАНД =====
local adminLabel = Instance.new("TextLabel")
adminLabel.Size = UDim2.new(0.9, 0, 0, 25)
adminLabel.Position = UDim2.new(0.05, 0, 0, 340)
adminLabel.BackgroundTransparency = 1
adminLabel.Text = "⚡ АДМИН-КОМАНДЫ (проверь в игре)"
adminLabel.TextColor3 = Color3.fromRGB(220, 70, 70)
adminLabel.TextScaled = true
adminLabel.Font = Enum.Font.GothamBold
adminLabel.Parent = content

local commands = {
    {"🛫 Fly", "fly"},
    {"🛡️ God", "god"},
    {"👻 Invis", "invis"},
    {"🌀 NoClip", "noclip"},
    {"🔫 Btools", "btools"},
    {"👢 Kick", "kick"},
    {"⛔ Ban", "ban"},
    {"📦 Bring", "bring"},
    {"💀 Kill", "kill"},
}
for i, data in pairs(commands) do
    local btn = createButton(content, data[1], 375 + (i-1) * 38, Color3.fromRGB(55, 40, 40))
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            -- Пробуем через чат
            local chat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chat then
                local say = chat:FindFirstChild("SayMessageRequest")
                if say then
                    say:FireServer("/" .. data[2], "All")
                    wait(0.1)
                    say:FireServer("!" .. data[2], "All")
                    wait(0.1)
                    say:FireServer(data[2], "All")
                end
            end
        end)
        btn.Text = "✅"
        wait(1)
        btn.Text = data[1]
    end)
end

-- ===== ПЕРЕТАСКИВАНИЕ =====
local drag = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ===== ЗАКРЫТИЕ ПО ESC =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        gui:Destroy()
    end
end)

print("⚡ Legenly LK v9.0 загружен (только ККРП)")
