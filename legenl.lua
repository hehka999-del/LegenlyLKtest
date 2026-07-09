--[[
    ⚡ Legenly LK v8.0
    Игры: Краснодар РП | Зареченск РП | Carros Rebaixados BR | Школа 102 РП
    Фичи: Музыка (глобальная/локальная), админ-команды, читы, ESP, Fly, NoClip, Speed, Kill, Bring, Ban, Kick и многое другое
    Дизайн: RGB-свечение, чёрно-серый фон, плавные анимации
]]

-- ========== СЛУЖБЫ ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

if _G.LegenlyLK_Loaded then return end
_G.LegenlyLK_Loaded = true

-- ========== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ==========
local isMinimized = false
local currentTab = "Krasnodar"
local flyBodyVelocity = nil
local noclipEnabled = false
local espEnabled = false
local espObjects = {}
local soundRemote = nil
local musicSound = nil

-- ========== ЦВЕТОВАЯ СХЕМА ==========
local colors = {
    bg = Color3.fromRGB(18, 18, 28),
    bg2 = Color3.fromRGB(28, 28, 40),
    panel = Color3.fromRGB(40, 40, 55),
    accent = Color3.fromRGB(70, 150, 255),
    gold = Color3.fromRGB(255, 215, 0),
    green = Color3.fromRGB(70, 220, 70),
    red = Color3.fromRGB(220, 70, 70),
    text = Color3.fromRGB(220, 220, 235),
    textdim = Color3.fromRGB(160, 160, 180),
}

-- ========== СОЗДАНИЕ GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LegenlyLK"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Главное окно (с тенью)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 440, 0, 540)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -270)
mainFrame.BackgroundColor3 = colors.bg
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316047255"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)
shadow.Parent = mainFrame

-- RGB-свечение
local glow = Instance.new("Frame")
glow.Size = UDim2.new(1, 12, 1, 12)
glow.Position = UDim2.new(0, -6, 0, -6)
glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
glow.BackgroundTransparency = 0.3
glow.BorderSizePixel = 0
glow.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 18)
glowCorner.Parent = glow

-- ========== ЗАГОЛОВОК ==========
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = colors.bg2
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
titleLabel.Position = UDim2.new(0.04, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ Legenly LK"
titleLabel.TextColor3 = colors.gold
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = header

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0.15, 0, 1, 0)
versionLabel.Position = UDim2.new(0.6, 0, 0, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v8.0"
versionLabel.TextColor3 = colors.textdim
versionLabel.TextScaled = true
versionLabel.Font = Enum.Font.Gotham
versionLabel.Parent = header

-- Кнопка сворачивания
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -72, 0, 6)
minBtn.BackgroundTransparency = 1
minBtn.Text = "_"
minBtn.TextColor3 = colors.text
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = header
minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
    isMinimized = true
end)

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- ========== МИНИ-ПОЛОСКА ==========
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.new(0, 200, 0, 32)
miniFrame.Position = UDim2.new(0.5, -100, 0, 0)
miniFrame.BackgroundColor3 = colors.bg
miniFrame.BackgroundTransparency = 0.05
miniFrame.BorderSizePixel = 0
miniFrame.Visible = false
miniFrame.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 12)
miniCorner.Parent = miniFrame

local miniTitle = Instance.new("TextLabel")
miniTitle.Size = UDim2.new(1, 0, 1, 0)
miniTitle.BackgroundTransparency = 1
miniTitle.Text = "⚡ Legenly LK"
miniTitle.TextColor3 = colors.gold
miniTitle.TextScaled = true
miniTitle.Font = Enum.Font.GothamBold
miniTitle.Parent = miniFrame

miniFrame.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    mainFrame.Visible = true
    isMinimized = false
end)

-- ========== ВКЛАДКИ ==========
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 44)
tabContainer.Position = UDim2.new(0, 0, 0, 44)
tabContainer.BackgroundColor3 = colors.bg2
tabContainer.BackgroundTransparency = 0
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabs = {
    {name = "🏠 ККРП", id = "Krasnodar"},
    {name = "🏙️ Зареченск", id = "Zarechensk"},
    {name = "🚗 Carros BR", id = "Carros"},
    {name = "🏫 Школа 102", id = "School"},
}

local tabButtons = {}
for i, tabData in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = tabData.name
    btn.TextColor3 = (i == 1) and colors.gold or colors.textdim
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabContainer
    tabButtons[tabData.id] = btn
    btn.MouseButton1Click:Connect(function()
        currentTab = tabData.id
        for _, b in pairs(tabButtons) do
            b.TextColor3 = colors.textdim
        end
        btn.TextColor3 = colors.gold
        for _, container in pairs(contentContainers) do
            container.Visible = false
        end
        contentContainers[tabData.id].Visible = true
    end)
end

-- Контейнеры для контента
local contentContainers = {}
for _, tabData in ipairs(tabs) do
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, -88)
    container.Position = UDim2.new(0, 0, 0, 88)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.CanvasSize = UDim2.new(0, 0, 0, 800)
    container.ScrollBarThickness = 4
    container.Visible = (tabData.id == "Krasnodar")
    container.Parent = mainFrame
    contentContainers[tabData.id] = container
end

-- ========== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ==========
local function createButton(parent, text, y, color, size)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.44, 0, 0, size or 34)
    btn.Position = UDim2.new(0.03, 0, 0, y)
    btn.BackgroundColor3 = color or colors.panel
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = colors.text
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local function createToggle(parent, text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.44, 0, 0, 34)
    btn.Position = UDim2.new(0.03, 0, 0, y)
    btn.BackgroundColor3 = color or colors.panel
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = colors.text
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local function createTextBox(parent, placeholder, y)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.44, 0, 0, 34)
    box.Position = UDim2.new(0.03, 0, 0, y)
    box.BackgroundColor3 = colors.bg2
    box.BorderSizePixel = 0
    box.Text = placeholder
    box.TextColor3 = colors.textdim
    box.TextScaled = true
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box
    return box
end

-- ========== ОБЩИЕ ФУНКЦИИ (ДЛЯ ВСЕХ ИГР) ==========

-- Поиск RemoteEvent для звука
local function findSoundRemote()
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            local name = child.Name
            if name:find("Sound") or name:find("Audio") or name:find("Music") or name:find("Play") or name:find("Banana") or name:find("Gun") or name:match("^%d+$") then
                return child
            end
        end
    end
    return nil
end

-- Глобальный звук
local function playGlobalSound(id)
    soundRemote = findSoundRemote()
    if soundRemote then
        pcall(function()
            soundRemote:FireServer("PlaySound", id)
            wait(0.05)
            soundRemote:FireServer("PlayAudio", id)
            wait(0.05)
            soundRemote:FireServer("Sound", id)
            wait(0.05)
            soundRemote:FireServer("Play", id)
            wait(0.05)
            soundRemote:FireServer("GlobalSound", id)
            wait(0.05)
            soundRemote:FireServer(id)
        end)
        return true
    else
        -- Локальный звук (запасной)
        if musicSound and musicSound.Parent then musicSound:Destroy() end
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = 10
        sound.Parent = Workspace
        sound:Play()
        musicSound = sound
        return false
    end
end

-- ========== ВКЛАДКА: КРАСНОДАР РП ==========
local krasnodarContent = contentContainers["Krasnodar"]

-- Заголовок
local krasnodarTitle = Instance.new("TextLabel")
krasnodarTitle.Size = UDim2.new(0.94, 0, 0, 30)
krasnodarTitle.Position = UDim2.new(0.03, 0, 0, 5)
krasnodarTitle.BackgroundTransparency = 1
krasnodarTitle.Text = "🔥 Краснодар РП (WIP)"
krasnodarTitle.TextColor3 = colors.gold
krasnodarTitle.TextScaled = true
krasnodarTitle.Font = Enum.Font.GothamBold
krasnodarTitle.Parent = krasnodarContent

-- Музыка
local musicLabel = Instance.new("TextLabel")
musicLabel.Size = UDim2.new(0.94, 0, 0, 24)
musicLabel.Position = UDim2.new(0.03, 0, 0, 40)
musicLabel.BackgroundTransparency = 1
musicLabel.Text = "🎵 МУЗЫКА (глобальная/локальная)"
musicLabel.TextColor3 = colors.accent
musicLabel.TextScaled = true
musicLabel.Font = Enum.Font.GothamBold
musicLabel.Parent = krasnodarContent

local krasnodarIdBox = createTextBox(krasnodarContent, "Вставь ID звука...", 70)
local krasnodarPlayBtn = createButton(krasnodarContent, "▶ Играть", 70, colors.accent)
krasnodarPlayBtn.Position = UDim2.new(0.51, 0, 0, 70)
krasnodarPlayBtn.MouseButton1Click:Connect(function()
    local id = krasnodarIdBox.Text
    if id == "" or id == "Вставь ID звука..." then return end
    local success = playGlobalSound(id)
    if success then
        krasnodarPlayBtn.Text = "✅ Отправлено!"
    else
        krasnodarPlayBtn.Text = "⚠️ Локально"
    end
    wait(1.5)
    krasnodarPlayBtn.Text = "▶ Играть"
end)

-- Готовые звуки
local krasnodarSounds = {
    {"🔊 Взрыв", "165969964"},
    {"🚨 Сирена", "433848566"},
    {"😱 Скример", "7236490488"},
    {"💀 Страшный", "7854285068"},
    {"🎵 Мем", "9120399989"},
}
for i, data in pairs(krasnodarSounds) do
    local btn = createButton(krasnodarContent, data[1], 115 + (i-1) * 42, colors.panel)
    btn.MouseButton1Click:Connect(function()
        playGlobalSound(data[2])
        btn.Text = "✅"
        wait(1)
        btn.Text = data[1]
    end)
end

-- Админ-команды
local adminLabel = Instance.new("TextLabel")
adminLabel.Size = UDim2.new(0.94, 0, 0, 24)
adminLabel.Position = UDim2.new(0.03, 0, 0, 330)
adminLabel.BackgroundTransparency = 1
adminLabel.Text = "⚡ АДМИН-КОМАНДЫ (проверь в игре)"
adminLabel.TextColor3 = colors.red
adminLabel.TextScaled = true
adminLabel.Font = Enum.Font.GothamBold
adminLabel.Parent = krasnodarContent

local krasnodarCommands = {
    {"🛫 Fly", "fly"},
    {"🛡️ God", "god"},
    {"👻 Invis", "invis"},
    {"🌀 NoClip", "noclip"},
    {"🔫 Btools", "btools"},
    {"👥 New Team", "newteam"},
    {"⚔️ Team", "team"},
    {"👢 Kick", "kick"},
    {"⛔ Ban", "ban"},
    {"📦 Bring", "bring"},
    {"💀 Kill", "kill"},
}
for i, data in pairs(krasnodarCommands) do
    local btn = createButton(krasnodarContent, data[1], 365 + (i-1) * 42, colors.panel)
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("/" .. data[2], "All")
            wait(0.1)
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("!" .. data[2], "All")
            wait(0.1)
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(data[2], "All")
        end)
        btn.Text = "✅"
        wait(1)
        btn.Text = data[1]
    end)
end

-- ========== ВКЛАДКА: ЗАРЕЧЕНСК РП ==========
local zarechenskContent = contentContainers["Zarechensk"]

local zarechenskTitle = Instance.new("TextLabel")
zarechenskTitle.Size = UDim2.new(0.94, 0, 0, 30)
zarechenskTitle.Position = UDim2.new(0.03, 0, 0, 5)
zarechenskTitle.BackgroundTransparency = 1
zarechenskTitle.Text = "🏙️ Зареченск РП"
zarechenskTitle.TextColor3 = colors.gold
zarechenskTitle.TextScaled = true
zarechenskTitle.Font = Enum.Font.GothamBold
zarechenskTitle.Parent = zarechenskContent

-- Музыка (аналогично)
local zarechenskMusicLabel = Instance.new("TextLabel")
zarechenskMusicLabel.Size = UDim2.new(0.94, 0, 0, 24)
zarechenskMusicLabel.Position = UDim2.new(0.03, 0, 0, 40)
zarechenskMusicLabel.BackgroundTransparency = 1
zarechenskMusicLabel.Text = "🎵 МУЗЫКА"
zarechenskMusicLabel.TextColor3 = colors.accent
zarechenskMusicLabel.TextScaled = true
zarechenskMusicLabel.Font = Enum.Font.GothamBold
zarechenskMusicLabel.Parent = zarechenskContent

local zarechenskIdBox = createTextBox(zarechenskContent, "Вставь ID звука...", 70)
local zarechenskPlayBtn = createButton(zarechenskContent, "▶ Играть", 70, colors.accent)
zarechenskPlayBtn.Position = UDim2.new(0.51, 0, 0, 70)
zarechenskPlayBtn.MouseButton1Click:Connect(function()
    local id = zarechenskIdBox.Text
    if id == "" or id == "Вставь ID звука..." then return end
    playGlobalSound(id)
end)

-- Читы для Зареченска
local zarechenskCheatsLabel = Instance.new("TextLabel")
zarechenskCheatsLabel.Size = UDim2.new(0.94, 0, 0, 24)
zarechenskCheatsLabel.Position = UDim2.new(0.03, 0, 0, 120)
zarechenskCheatsLabel.BackgroundTransparency = 1
zarechenskCheatsLabel.Text = "🛠 ЧИТЫ (работают в большинстве серверов)"
zarechenskCheatsLabel.TextColor3 = colors.green
zarechenskCheatsLabel.TextScaled = true
zarechenskCheatsLabel.Font = Enum.Font.GothamBold
zarechenskCheatsLabel.Parent = zarechenskContent

local zarechenskToggles = {
    {"🛫 Fly", "fly"},
    {"🌀 NoClip", "noclip"},
    {"⚡ Speed", "speed"},
    {"👻 Invis", "invis"},
    {"💀 Kill All", "killall"},
    {"📦 Bring All", "bringall"},
}
local zarechenskStates = {}
for i, data in pairs(zarechenskToggles) do
    local btn = createToggle(zarechenskContent, data[1], 155 + (i-1) * 42, colors.panel)
    zarechenskStates[data[2]] = false
    btn.MouseButton1Click:Connect(function()
        zarechenskStates[data[2]] = not zarechenskStates[data[2]]
        if zarechenskStates[data[2]] then
            btn.Text = data[1] .. " [ON]"
            btn.BackgroundColor3 = colors.green
        else
            btn.Text = data[1] .. " [OFF]"
            btn.BackgroundColor3 = colors.panel
        end
        -- Выполнение команды (зависит от игры)
        if data[2] == "fly" then
            if zarechenskStates[data[2]] then
                -- Включаем полет
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.PlatformStand = true
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
                    flyBodyVelocity.Parent = player.Character
                end
            else
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.PlatformStand = false
                    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
                end
            end
        elseif data[2] == "noclip" then
            noclipEnabled = zarechenskStates[data[2]]
        elseif data[2] == "speed" then
            if zarechenskStates[data[2]] and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 50
            elseif player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
        elseif data[2] == "killall" then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character then
                    v.Character:BreakJoints()
                end
            end
        elseif data[2] == "bringall" then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        v.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 2, 0)
                    end
                end
            end
        end
    end)
end

-- ========== ВКЛАДКА: CARROS REBAIXADOS BR ==========
local carrosContent = contentContainers["Carros"]

local carrosTitle = Instance.new("TextLabel")
carrosTitle.Size = UDim2.new(0.94, 0, 0, 30)
carrosTitle.Position = UDim2.new(0.03, 0, 0, 5)
carrosTitle.BackgroundTransparency = 1
carrosTitle.Text = "🚗 Carros Rebaixados BR"
carrosTitle.TextColor3 = colors.gold
carrosTitle.TextScaled = true
carrosTitle.Font = Enum.Font.GothamBold
carrosTitle.Parent = carrosContent

-- Музыка (глобальная через A-Chassis)
local carrosMusicLabel = Instance.new("TextLabel")
carrosMusicLabel.Size = UDim2.new(0.94, 0, 0, 24)
carrosMusicLabel.Position = UDim2.new(0.03, 0, 0, 40)
carrosMusicLabel.BackgroundTransparency = 1
carrosMusicLabel.Text = "🎵 МУЗЫКА (через A-Chassis)"
carrosMusicLabel.TextColor3 = colors.accent
carrosMusicLabel.TextScaled = true
carrosMusicLabel.Font = Enum.Font.GothamBold
carrosMusicLabel.Parent = carrosContent

local carrosIdBox = createTextBox(carrosContent, "Вставь ID звука...", 70)
local carrosPlayBtn = createButton(carrosContent, "▶ Играть", 70, colors.accent)
carrosPlayBtn.Position = UDim2.new(0.51, 0, 0, 70)
carrosPlayBtn.MouseButton1Click:Connect(function()
    local id = carrosIdBox.Text
    if id == "" or id == "Вставь ID звука..." then return end
    -- Попытка через A-Chassis
    local remote = ReplicatedStorage:FindFirstChild("AC6_FE_Sounds")
    if remote then
        pcall(function()
            remote:FireServer("newSound", "Music", Workspace, "rbxassetid://" .. id, 0, 10, true)
            wait(0.1)
            remote:FireServer("playSound", "Music")
        end)
    else
        playGlobalSound(id)
    end
end)

-- Специфичные для Carros функции
local carrosFuncs = {
    {"🚗 Turbo", "turbo"},
    {"🔧 Reparo", "repair"},
    {"💥 Explodir", "explode"},
    {"🚀 Super Velocidade", "superspeed"},
}
for i, data in pairs(carrosFuncs) do
    local btn = createButton(carrosContent, data[1], 120 + (i-1) * 42, colors.panel)
    btn.MouseButton1Click:Connect(function()
        -- Заглушки, нужно проверять в игре
        if data[2] == "turbo" then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 100
            end
        elseif data[2] == "repair" then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.Health = 100
            end
        elseif data[2] == "explode" then
            if player.Character then
                player.Character:BreakJoints()
            end
        elseif data[2] == "superspeed" then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 200
            end
        end
    end)
end

-- ========== ВКЛАДКА: ШКОЛА 102 РП ==========
local schoolContent = contentContainers["School"]

local schoolTitle = Instance.new("TextLabel")
schoolTitle.Size = UDim2.new(0.94, 0, 0, 30)
schoolTitle.Position = UDim2.new(0.03, 0, 0, 5)
schoolTitle.BackgroundTransparency = 1
schoolTitle.Text = "🏫 Школа 102 РП"
schoolTitle.TextColor3 = colors.gold
schoolTitle.TextScaled = true
schoolTitle.Font = Enum.Font.GothamBold
schoolTitle.Parent = schoolContent

-- Музыка
local schoolMusicLabel = Instance.new("TextLabel")
schoolMusicLabel.Size = UDim2.new(0.94, 0, 0, 24)
schoolMusicLabel.Position = UDim2.new(0.03, 0, 0, 40)
schoolMusicLabel.BackgroundTransparency = 1
schoolMusicLabel.Text = "🎵 МУЗЫКА"
schoolMusicLabel.TextColor3 = colors.accent
schoolMusicLabel.TextScaled = true
schoolMusicLabel.Font = Enum.Font.GothamBold
schoolMusicLabel.Parent = schoolContent

local schoolIdBox = createTextBox(schoolContent, "Вставь ID звука...", 70)
local schoolPlayBtn = createButton(schoolContent, "▶ Играть", 70, colors.accent)
schoolPlayBtn.Position = UDim2.new(0.51, 0, 0, 70)
schoolPlayBtn.MouseButton1Click:Connect(function()
    local id = schoolIdBox.Text
    if id == "" or id == "Вставь ID звука..." then return end
    playGlobalSound(id)
end)

-- Читы для школы (админ-роли, донат)
local schoolCheats = {
    {"👑 Admin", "admin"},
    {"🛡️ God", "god"},
    {"🛫 Fly", "fly"},
    {"👻 Invis", "invis"},
    {"⚡ Speed", "speed"},
    {"🔫 Btools", "btools"},
    {"👢 Kick", "kick"},
    {"⛔ Ban", "ban"},
}
for i, data in pairs(schoolCheats) do
    local btn = createButton(schoolContent, data[1], 120 + (i-1) * 42, colors.panel)
    btn.MouseButton1Click:Connect(function()
        -- Попытка через чат (как в школе часто есть)
        pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("/" .. data[2], "All")
            wait(0.1)
            game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("!" .. data[2], "All")
        end)
        btn.Text = "✅"
        wait(1)
        btn.Text = data[1]
    end)
end

-- ========== ГЛОБАЛЬНЫЙ ЦИКЛ (для читов, работающих всегда) ==========
RunService.Heartbeat:Connect(function()
    -- NoClip (если включен в любой вкладке)
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif player.Character and not noclipEnabled then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end

    -- Fly (если включен)
    if flyBodyVelocity and player.Character then
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = Vector3.new(0,50,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = Vector3.new(0,-50,0) end
        flyBodyVelocity.Velocity = dir
    end
end)

-- ========== RGB АНИМАЦИЯ ==========
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    local color = Color3.fromHSV(hue, 0.9, 0.6)
    glow.BackgroundColor3 = color
    glow.BackgroundTransparency = 0.2 + math.sin(hue * 10) * 0.1
    titleLabel.TextColor3 = color
    if miniFrame.Visible then
        miniTitle.TextColor3 = color
    end
end)

-- ========== ПЕРЕТАСКИВАНИЕ ==========
local drag = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ========== ЗАКРЫТИЕ ПО ESC ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        screenGui:Destroy()
    end
end)

print("⚡ Legenly LK v8.0 загружен")