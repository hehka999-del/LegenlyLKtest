--[[
    Версия: 2.0 (Brookhaven/MM2)
    Фичи: NoClip + Глобальная музыка (автопоиск Remote)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

if _G.LegenlyLK_Loaded then return end
_G.LegenlyLK_Loaded = true

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LegenlyLK"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Переменные
local isKeyValid = false
local generatedKey = ""
local noClipEnabled = false
local soundRemote = nil
local currentSound = nil

-- Цвета
local colors = {
    bg = Color3.fromRGB(18, 18, 28),
    bg2 = Color3.fromRGB(28, 28, 40),
    panel = Color3.fromRGB(40, 40, 55),
    accent = Color3.fromRGB(70, 150, 255),
    gold = Color3.fromRGB(230, 200, 100),
    green = Color3.fromRGB(70, 220, 70),
    red = Color3.fromRGB(220, 70, 70),
    text = Color3.fromRGB(220, 220, 235),
    textdim = Color3.fromRGB(160, 160, 180),
}

-- Вспомогательные функции
local function makeFrame(parent, size, pos, color, trans, radius)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = color or colors.bg
    f.BackgroundTransparency = trans or 0
    f.BorderSizePixel = 0
    f.Parent = parent
    if radius then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = f
    end
    return f
end

local function makeBtn(parent, size, pos, text, color, txtColor, radius)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color or colors.panel
    b.BackgroundTransparency = 0
    b.BorderSizePixel = 0
    b.Text = text or ""
    b.TextColor3 = txtColor or colors.text
    b.TextScaled = false
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    if radius then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = b
    end
    return b
end

local function makeLabel(parent, size, pos, text, color, sizeText)
    local l = Instance.new("TextLabel")
    l.Size = size
    l.Position = pos
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or colors.text
    l.TextScaled = false
    l.TextSize = sizeText or 14
    l.Font = Enum.Font.Gotham
    l.Parent = parent
    return l
end

local function makeTextBox(parent, size, pos, placeholder, color)
    local t = Instance.new("TextBox")
    t.Size = size
    t.Position = pos
    t.BackgroundColor3 = color or colors.panel
    t.BackgroundTransparency = 0
    t.BorderSizePixel = 0
    t.Text = placeholder or ""
    t.TextColor3 = colors.textdim
    t.TextScaled = false
    t.TextSize = 14
    t.Font = Enum.Font.Gotham
    t.ClearTextOnFocus = false
    t.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = t
    return t
end

-- ========== ОКНО ВХОДА ==========
local loginFrame = makeFrame(gui, UDim2.new(0, 280, 0, 220), UDim2.new(0.5, -140, 0.5, -110), colors.bg, 0, 12)

local header = makeFrame(loginFrame, UDim2.new(1, 0, 0, 36), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
makeLabel(header, UDim2.new(0.65,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 16)
makeLabel(header, UDim2.new(0.25,0,1,0), UDim2.new(0.7,0,0,0), "v2.0", colors.textdim, 12)

local closeBtn = makeBtn(header, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 5), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,44), "Введи ключ (8 символов)", colors.textdim, 13)

local keyBox = makeTextBox(loginFrame, UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0,70), "Ключ...")

local copyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.05,0,0,110), "📋 Copy", colors.gold, Color3.fromRGB(0,0,0), 6)
local verifyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.53,0,0,110), "✅ Войти", colors.accent, colors.text, 6)

local statusLabel = makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,150), "", colors.text, 12)

-- ========== ГЛАВНАЯ ПАНЕЛЬ ==========
local mainPanel = makeFrame(gui, UDim2.new(0, 320, 0, 260), UDim2.new(0.5, -160, 0.5, -130), colors.bg, 0, 12)
mainPanel.Visible = false

local panelHeader = makeFrame(mainPanel, UDim2.new(1,0,0,36), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
makeLabel(panelHeader, UDim2.new(0.6,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 15)

local closePanelBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 5), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closePanelBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- NoClip
local noclipFrame = makeFrame(mainPanel, UDim2.new(0.9,0,0.2,0), UDim2.new(0.05,0,0.1,0), colors.bg2, 0, 6)
makeLabel(noclipFrame, UDim2.new(0.4,0,1,0), UDim2.new(0.05,0,0,0), "🌀 NoClip", colors.text, 14)
local noclipBtn = makeBtn(noclipFrame, UDim2.new(0.35,0,0.7,0), UDim2.new(0.6,0,0.15,0), "Выкл", colors.panel, colors.text, 6)
noclipBtn.TextSize = 13

-- Музыка
local musicFrame = makeFrame(mainPanel, UDim2.new(0.9,0,0.45,0), UDim2.new(0.05,0,0.35,0), colors.bg2, 0, 6)
makeLabel(musicFrame, UDim2.new(1,0,0.25,0), UDim2.new(0.05,0,0,0), "🎵 Музыка (ID)", colors.text, 13)
local musicIdBox = makeTextBox(musicFrame, UDim2.new(0.6,0,0.6,0), UDim2.new(0.05,0,0.25,0), "ID трека")
local startMusicBtn = makeBtn(musicFrame, UDim2.new(0.25,0,0.6,0), UDim2.new(0.7,0,0.25,0), "▶ Старт", colors.accent, colors.text, 6)
startMusicBtn.TextSize = 13

-- Статус
local statusBar = makeFrame(mainPanel, UDim2.new(0.9,0,0.1,0), UDim2.new(0.05,0,0.85,0), colors.bg2, 0, 6)
local statusText = makeLabel(statusBar, UDim2.new(0.9,0,1,0), UDim2.new(0.05,0,0,0), "✅ Готов", colors.textdim, 12)

-- ========== ФУНКЦИИ ==========
local function generateKey()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local key = ""
    for i = 1, 8 do
        key = key .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
        if i % 4 == 0 and i < 8 then key = key .. "-" end
    end
    return key
end

local function verifyKey(input)
    return input == generatedKey
end

local function openPanel()
    mainPanel.Visible = true
    loginFrame.Visible = false
    statusText.Text = "✅ Готов"
end

-- Обработчики входа
copyBtn.MouseButton1Click:Connect(function()
    generatedKey = generateKey()
    setclipboard(generatedKey)
    keyBox.Text = generatedKey
    statusLabel.Text = "✅ Скопирован"
    statusLabel.TextColor3 = colors.green
    wait(1.5); statusLabel.Text = ""
end)

verifyBtn.MouseButton1Click:Connect(function()
    local input = keyBox.Text
    if input == "" or input == "Ключ..." then
        statusLabel.Text = "❌ Вставь ключ"
        statusLabel.TextColor3 = colors.red; return
    end
    if verifyKey(input) then
        statusLabel.Text = "✅ Добро пожаловать"
        statusLabel.TextColor3 = colors.green
        isKeyValid = true
        wait(0.5); openPanel()
    else
        statusLabel.Text = "❌ Неверный ключ"
        statusLabel.TextColor3 = colors.red
    end
    wait(1.5); statusLabel.Text = ""
end)

-- Перетаскивание
local function makeDraggable(frame)
    local drag, start, pos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; start = input.Position; pos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - start
            frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(loginFrame)
makeDraggable(mainPanel)

-- ========== NoClip ==========
noclipBtn.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    if noClipEnabled then
        noclipBtn.BackgroundColor3 = colors.green
        noclipBtn.Text = "Вкл"
        statusText.Text = "🌀 NoClip включён"
    else
        noclipBtn.BackgroundColor3 = colors.panel
        noclipBtn.Text = "Выкл"
        statusText.Text = "🌀 NoClip выключен"
    end
    wait(0.5); statusText.Text = "✅ Готов"
end)

RunService.Heartbeat:Connect(function()
    if not isKeyValid then return end
    if noClipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif player.Character and not noClipEnabled then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- ========== ГЛОБАЛЬНАЯ МУЗЫКА (АВТОПОИСК REMOTE) ==========
-- Ищем RemoteEvent с ключевыми словами
local function findSoundRemote()
    local candidates = {}
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") then
            local name = child.Name:lower()
            if name:find("sound") or name:find("music") or name:find("audio") or name:find("play") or name:find("global") or name:find("banana") then
                table.insert(candidates, child)
            end
        end
    end
    -- Если несколько, возьмём первый, но лучше проверить вручную
    return candidates[1]
end

-- Попытаемся найти Remote при загрузке
soundRemote = findSoundRemote()
if soundRemote then
    statusText.Text = "🔊 Найден Remote: " .. soundRemote.Name
else
    statusText.Text = "❌ Remote не найден, звук локально"
end

startMusicBtn.MouseButton1Click:Connect(function()
    local id = musicIdBox.Text
    if id == "" or id == "ID трека" then
        statusText.Text = "❌ Введите ID"
        return
    end

    -- Если Remote найден, отправляем
    if soundRemote then
        -- Пробуем разные форматы аргументов
        local success, err = pcall(function()
            -- Вариант 1: отправляем ID как строку
            soundRemote:FireServer("PlaySound", id)
            wait(0.2)
            soundRemote:FireServer("PlayMusic", id)
            wait(0.2)
            soundRemote:FireServer("Sound", id)
            wait(0.2)
            soundRemote:FireServer("GlobalSound", id)
        end)
        if success then
            statusText.Text = "🎵 Отправлено на сервер (глобально)"
        else
            statusText.Text = "❌ Ошибка: " .. err
        end
    else
        -- Запасной вариант: локальный звук (только для тебя)
        if currentSound and currentSound.Parent then currentSound:Destroy() end
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Looped = true
        sound.Volume = 10
        sound.Parent = workspace
        sound:Play()
        currentSound = sound
        statusText.Text = "🎵 Локально (только ты слышишь)"
    end
end)

-- Закрытие по ESC
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        gui:Destroy()
    end
end)

-- Анимация
loginFrame.BackgroundTransparency = 1
TweenService:Create(loginFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

print("⚡ Legenly LK v2.0 загружен")
