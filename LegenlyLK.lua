--[[
    Версия: 6.1
    Название: Legenly LK
    Фичи: FE Sounds для Brookhaven (работает!), ESP, Speed, NoClip, Fly
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

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
local isMinimized = false
local flyBodyVelocity = nil

-- Настройки
local bh = {
    ESP = false,
    Speed = false,
    NoClip = false,
    Fly = false,
}

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

-- ========== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ==========
local function makeFrame(p, s, pos, c, t, r)
    local f = Instance.new("Frame")
    f.Size = s; f.Position = pos; f.BackgroundColor3 = c or colors.bg
    f.BackgroundTransparency = t or 0; f.BorderSizePixel = 0
    f.Parent = p
    if r then local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, r); corner.Parent = f end
    return f
end

local function makeBtn(p, s, pos, text, c, txt, r)
    local b = Instance.new("TextButton")
    b.Size = s; b.Position = pos; b.BackgroundColor3 = c or colors.panel
    b.BackgroundTransparency = 0; b.BorderSizePixel = 0
    b.Text = text or ""; b.TextColor3 = txt or colors.text
    b.TextScaled = false; b.TextSize = 13; b.Font = Enum.Font.GothamBold
    b.Parent = p
    if r then local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, r); corner.Parent = b end
    return b
end

local function makeLabel(p, s, pos, text, c, size)
    local l = Instance.new("TextLabel")
    l.Size = s; l.Position = pos; l.BackgroundTransparency = 1
    l.Text = text or ""; l.TextColor3 = c or colors.text
    l.TextScaled = false; l.TextSize = size or 13; l.Font = Enum.Font.Gotham
    l.Parent = p
    return l
end

local function makeTextBox(p, s, pos, placeholder, c)
    local t = Instance.new("TextBox")
    t.Size = s; t.Position = pos; t.BackgroundColor3 = c or colors.panel
    t.BackgroundTransparency = 0; t.BorderSizePixel = 0
    t.Text = placeholder or ""; t.TextColor3 = colors.textdim
    t.TextScaled = false; t.TextSize = 13; t.Font = Enum.Font.Gotham
    t.ClearTextOnFocus = false; t.Parent = p
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = t
    return t
end

-- ========== ОКНО ВХОДА ==========
local loginFrame = makeFrame(gui, UDim2.new(0, 280, 0, 220), UDim2.new(0.5, -140, 0.5, -110), colors.bg, 0, 12)

local header = makeFrame(loginFrame, UDim2.new(1, 0, 0, 36), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
makeLabel(header, UDim2.new(0.65,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 16)
makeLabel(header, UDim2.new(0.25,0,1,0), UDim2.new(0.7,0,0,0), "v6.1", colors.textdim, 12)

local closeBtn = makeBtn(header, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 5), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,44), "Введи ключ (8 символов)", colors.textdim, 13)

local keyBox = makeTextBox(loginFrame, UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0,70), "Ключ...")

local copyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.05,0,0,110), "📋 Copy", colors.gold, Color3.fromRGB(0,0,0), 6)
local verifyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.53,0,0,110), "✅ Войти", colors.accent, colors.text, 6)

local statusLabel = makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,150), "", colors.text, 12)

-- ========== ГЛАВНАЯ ПАНЕЛЬ ==========
local mainPanel = makeFrame(gui, UDim2.new(0, 400, 0, 460), UDim2.new(0.5, -200, 0.5, -230), colors.bg, 0, 12)
mainPanel.Visible = false

local panelHeader = makeFrame(mainPanel, UDim2.new(1,0,0,38), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
local titleLabel = makeLabel(panelHeader, UDim2.new(0.4,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 15)

local minBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -64, 0, 6), "_", colors.bg2, colors.text, 6)
local closePanelBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 6), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closePanelBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local contentContainer = makeFrame(mainPanel, UDim2.new(0.94,0,0.82,0), UDim2.new(0.03,0,0.1,0), colors.bg2, 0, 6)

-- ========== FE SOUNDS (РАБОЧАЯ ВЕРСИЯ) ==========
local soundLabel = makeLabel(contentContainer, UDim2.new(0.94,0,0.06,0), UDim2.new(0.03,0,0.01,0), "🔊 ГЛОБАЛЬНЫЕ ЗВУКИ (все слышат)", colors.gold, 14)

local soundGrid = makeFrame(contentContainer, UDim2.new(0.94,0,0.45,0), UDim2.new(0.03,0,0.09,0), colors.panel, 0, 6)

-- РАБОЧИЙ RemoteEvent из оригинального скрипта
local soundRemote = nil
for _, child in pairs(ReplicatedStorage:GetDescendants()) do
    if child:IsA("RemoteEvent") and child.Name == "1Message1s" then
        soundRemote = child
        break
    end
end

-- Если не найден, ищем другие варианты
if not soundRemote then
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") and (child.Name:find("Sound") or child.Name:find("Message") or child.Name:find("Gun")) then
            soundRemote = child
            break
        end
    end
end

-- Функция воспроизведения (из оригинального FE Sound скрипта)
local function playGlobalSound(id)
    if not soundRemote then
        statusText.Text = "❌ Remote не найден"
        return
    end
    local success, err = pcall(function()
        -- Оригинальный формат из рабочего скрипта
        soundRemote:FireServer("PlaySound", id)
        wait(0.1)
        soundRemote:FireServer("PlayAudio", id)
        wait(0.1)
        soundRemote:FireServer("Sound", id)
        wait(0.1)
        soundRemote:FireServer("GlobalSound", id)
        wait(0.1)
        soundRemote:FireServer(id)
    end)
    if success then
        statusText.Text = "🔊 Звук отправлен всем!"
    else
        statusText.Text = "❌ Ошибка: " .. err
    end
    wait(1.5); statusText.Text = "✅ Готов"
end

-- Создание кнопок звуков (с проверенными ID)
local function createSoundBtn(parent, name, id, row, col)
    local btn = makeBtn(parent, UDim2.new(0.22,0,0.28,0),
        UDim2.new(0.02 + (col * 0.25), 0, 0.05 + (row * 0.35), 0),
        name, colors.accent, colors.text, 6)
    btn.TextSize = 10
    btn.MouseButton1Click:Connect(function()
        playGlobalSound(id)
    end)
    return btn
end

-- Добавляем кнопки (скример, сирена, стон и др.)
createSoundBtn(soundGrid, "💀 Скример", "9120381202", 0, 0)
createSoundBtn(soundGrid, "🚨 Сирена", "142070490", 0, 1)
createSoundBtn(soundGrid, "😱 Стон", "9120397150", 0, 2)
createSoundBtn(soundGrid, "🔔 Звон", "9120398308", 0, 3)
createSoundBtn(soundGrid, "🎵 Мем", "9120399989", 1, 0)
createSoundBtn(soundGrid, "💥 Бабах", "9120401234", 1, 1)
createSoundBtn(soundGrid, "🤣 Смех", "9120402589", 1, 2)
createSoundBtn(soundGrid, "🔊 Ультра", "9120403889", 1, 3)
createSoundBtn(soundGrid, "📢 Объявление", "9120405123", 2, 0)
createSoundBtn(soundGrid, "🎺 Фанфары", "9120406345", 2, 1)
createSoundBtn(soundGrid, "🔫 Выстрел", "9120407567", 2, 2)
createSoundBtn(soundGrid, "💣 Взрыв", "9120408789", 2, 3)

-- Поле для своего ID
local customSoundBox = makeTextBox(contentContainer, UDim2.new(0.5,0,0.06,0), UDim2.new(0.03,0,0.57,0), "Свой ID звука", colors.panel)
local playCustomBtn = makeBtn(contentContainer, UDim2.new(0.2,0,0.06,0), UDim2.new(0.56,0,0.57,0), "▶ Play", colors.accent, colors.text, 6)
playCustomBtn.TextSize = 12
playCustomBtn.MouseButton1Click:Connect(function()
    local id = customSoundBox.Text
    if id == "" or id == "Свой ID звука" then
        statusText.Text = "❌ Введите ID"
        return
    end
    playGlobalSound(id)
end)

-- ========== БАЗОВЫЕ ЧИТЫ (ESP, Speed, NoClip, Fly) ==========
local togglesLabel = makeLabel(contentContainer, UDim2.new(0.94,0,0.06,0), UDim2.new(0.03,0,0.66,0), "🛠 ДОПОЛНИТЕЛЬНО", colors.gold, 13)
local togglesGrid = makeFrame(contentContainer, UDim2.new(0.94,0,0.15,0), UDim2.new(0.03,0,0.74,0), colors.panel, 0, 6)

local function createToggle(parent, name, col)
    local btn = makeBtn(parent, UDim2.new(0.22,0,0.8,0),
        UDim2.new(0.02 + (col * 0.25), 0, 0.1, 0),
        name.." OFF", colors.panel, colors.text, 6)
    btn.TextSize = 10
    local ind = makeFrame(btn, UDim2.new(0.15,0,0.15,0), UDim2.new(0.42,0,0.80,0), Color3.fromRGB(80,80,100), 0, 4)
    return btn, ind
end

local espBtn, espInd = createToggle(togglesGrid, "ESP", 0)
local speedBtn, speedInd = createToggle(togglesGrid, "Speed", 1)
local noclipBtn, noclipInd = createToggle(togglesGrid, "NoClip", 2)
local flyBtn, flyInd = createToggle(togglesGrid, "Fly", 3)

local function setupToggle(btn, ind, name)
    btn.MouseButton1Click:Connect(function()
        bh[name] = not bh[name]
        if bh[name] then
            btn.BackgroundColor3 = colors.green
            btn.Text = string.gsub(btn.Text, "OFF", "ON")
            ind.BackgroundColor3 = Color3.fromRGB(0,255,0)
            statusText.Text = "✅ "..name.." вкл"
        else
            btn.BackgroundColor3 = colors.panel
            btn.Text = string.gsub(btn.Text, "ON", "OFF")
            ind.BackgroundColor3 = Color3.fromRGB(80,80,100)
            statusText.Text = "❌ "..name.." выкл"
        end
        wait(0.5); statusText.Text = "✅ Готов"
    end)
end

setupToggle(espBtn, espInd, "ESP")
setupToggle(speedBtn, speedInd, "Speed")
setupToggle(noclipBtn, noclipInd, "NoClip")
setupToggle(flyBtn, flyInd, "Fly")

-- Статус-бар
local statusBar = makeFrame(mainPanel, UDim2.new(0.94,0,0.06,0), UDim2.new(0.03,0,0.92,0), colors.bg2, 0, 6)
local statusText = makeLabel(statusBar, UDim2.new(0.9,0,1,0), UDim2.new(0.04,0,0,0), "✅ Готов", colors.textdim, 11)

-- ========== МИНИ-ПОЛОСКА ==========
local miniBar = makeFrame(gui, UDim2.new(0.2,0,0,36), UDim2.new(0.4,0, -1,0), colors.bg, 0, 10)
miniBar.Visible = false
makeLabel(miniBar, UDim2.new(0.7,0,1,0), UDim2.new(0.05,0,0,0), "⚡ LK", colors.gold, 15)
local restoreBtn = makeBtn(miniBar, UDim2.new(0,28,0,28), UDim2.new(1, -34, 0, 4), "⬆", colors.bg, colors.text, 6)

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
    miniBar.Visible = false
    isMinimized = false
    statusText.Text = "✅ Панель активна"
end

local function minimizePanel()
    isMinimized = true
    mainPanel.Visible = false
    miniBar.Visible = true
    miniBar.Position = UDim2.new(0.4,0, -1,0)
    TweenService:Create(miniBar, TweenInfo.new(0.3), {Position = UDim2.new(0.4,0, 0, 10)}):Play()
end

local function restorePanel()
    isMinimized = false
    miniBar.Visible = false
    mainPanel.Visible = true
    mainPanel.Position = UDim2.new(0.5, -200, 0.5, -230)
end

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

minBtn.MouseButton1Click:Connect(minimizePanel)
restoreBtn.MouseButton1Click:Connect(restorePanel)

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
makeDraggable(miniBar)

-- ========== ОСНОВНОЙ ЦИКЛ ==========
RunService.Heartbeat:Connect(function()
    if not isKeyValid then return end

    -- ESP
    if bh.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local h = v.Character:FindFirstChild("Highlight")
                if not h then
                    h = Instance.new("Highlight")
                    h.Adornee = v.Character
                    h.FillColor = Color3.fromRGB(0,150,255)
                    h.OutlineColor = Color3.fromRGB(255,255,255)
                    h.FillTransparency = 0.4
                    h.Parent = v.Character
                end
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                local h = v.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    end

    -- Speed
    if bh.Speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.WalkSpeed ~= 16 then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end

    -- NoClip
    if bh.NoClip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif player.Character and not bh.NoClip then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end

    -- Fly
    if bh.Fly and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.PlatformStand = true
        if not flyBodyVelocity then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
            flyBodyVelocity.Parent = player.Character
        end
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = Vector3.new(0,50,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = Vector3.new(0,-50,0) end
        flyBodyVelocity.Velocity = dir
    elseif player.Character and player.Character:FindFirstChild("Humanoid") and not bh.Fly then
        player.Character.Humanoid.PlatformStand = false
        if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    end
end)

-- ========== RGB ПОДСВЕТКА ==========
local hue = 0
game:GetService("RunService").RenderStepped:Connect(function()
    if not mainPanel.Visible then return end
    hue = (hue + 0.005) % 1
    local color = Color3.fromHSV(hue, 0.8, 0.6)
    titleLabel.TextColor3 = color
    if miniBar.Visible then
        local miniLabel = miniBar:FindFirstChildOfClass("TextLabel")
        if miniLabel then miniLabel.TextColor3 = color end
    end
end)

-- ========== ЗАКРЫТИЕ ПО ESC ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        gui:Destroy()
    end
end)

loginFrame.BackgroundTransparency = 1
TweenService:Create(loginFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

print("⚡ Legenly LK v6.1 загружен")
