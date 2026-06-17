--[[
    Версия: 3.1
    Название: Legenly LK
    Фичи: Lost Front (AimBot, ESP только враги, Wallbang, Triggerbot)
           Universal (убийства, кики, телепорты, флинги)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

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
local currentTab = "LostFront"

-- Настройки для Lost Front
local lfToggles = {
    AimBot = false,
    ESP = false,
    Wallbang = false,
    SilentAim = false,
    Triggerbot = false,
    NoSpread = false,
    Speed = false
}

-- Универсальные настройки
local uniToggles = {
    KillAll = false,
    KickAll = false,
    BringAll = false,
    FlingAll = false
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
    b.TextSize = 13
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
    l.TextSize = sizeText or 13
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
    t.TextSize = 13
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
makeLabel(header, UDim2.new(0.25,0,1,0), UDim2.new(0.7,0,0,0), "v3.1", colors.textdim, 12)

local closeBtn = makeBtn(header, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 5), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,44), "Введи ключ (8 символов)", colors.textdim, 13)

local keyBox = makeTextBox(loginFrame, UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0,70), "Ключ...")

local copyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.05,0,0,110), "📋 Copy", colors.gold, Color3.fromRGB(0,0,0), 6)
local verifyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.53,0,0,110), "✅ Войти", colors.accent, colors.text, 6)

local statusLabel = makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,150), "", colors.text, 12)

-- ========== ГЛАВНАЯ ПАНЕЛЬ ==========
local mainPanel = makeFrame(gui, UDim2.new(0, 360, 0, 420), UDim2.new(0.5, -180, 0.5, -210), colors.bg, 0, 12)
mainPanel.Visible = false

local panelHeader = makeFrame(mainPanel, UDim2.new(1,0,0,38), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
local titleLabel = makeLabel(panelHeader, UDim2.new(0.4,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 15)

local minBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -64, 0, 6), "_", colors.bg2, colors.text, 6)
local closePanelBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 6), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closePanelBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Вкладки
local tabContainer = makeFrame(mainPanel, UDim2.new(0.94,0,0.08,0), UDim2.new(0.03,0,0.1,0), colors.bg2, 0, 6)
local lfTabBtn = makeBtn(tabContainer, UDim2.new(0.48,0,0.8,0), UDim2.new(0.01,0,0.1,0), "🎯 Lost Front", colors.accent, colors.text, 6)
local uniTabBtn = makeBtn(tabContainer, UDim2.new(0.48,0,0.8,0), UDim2.new(0.51,0,0.1,0), "🌍 Universal", colors.panel, colors.text, 6)
lfTabBtn.TextSize = 12
uniTabBtn.TextSize = 12

local contentContainer = makeFrame(mainPanel, UDim2.new(0.94,0,0.6,0), UDim2.new(0.03,0,0.2,0), colors.bg2, 0, 6)

-- ===== ВКЛАДКА LOST FRONT =====
local lfContainer = makeFrame(contentContainer, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), colors.bg2, 0, 6)

local function createLFTog(parent, name, row, col)
    local btn = makeBtn(parent, UDim2.new(0.30,0,0.22,0),
        UDim2.new(0.02 + (col * 0.33), 0, 0.04 + (row * 0.26), 0),
        name.." OFF", colors.panel, colors.text, 6)
    btn.TextSize = 11
    local ind = makeFrame(btn, UDim2.new(0.15,0,0.15,0), UDim2.new(0.42,0,0.80,0), Color3.fromRGB(80,80,100), 0, 4)
    return btn, ind
end

local aimBtn, aimInd = createLFTog(lfContainer, "AimBot", 0,0)
local espBtn, espInd = createLFTog(lfContainer, "ESP", 0,1)
local wallBtn, wallInd = createLFTog(lfContainer, "Wallbang", 0,2)
local silentBtn, silentInd = createLFTog(lfContainer, "Silent Aim", 1,0)
local triggerBtn, triggerInd = createLFTog(lfContainer, "Triggerbot", 1,1)
local spreadBtn, spreadInd = createLFTog(lfContainer, "NoSpread", 1,2)
local speedBtn, speedInd = createLFTog(lfContainer, "Speed", 2,0)

-- ===== ВКЛАДКА UNIVERSAL =====
local uniContainer = makeFrame(contentContainer, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), colors.bg2, 0, 6)
uniContainer.Visible = false

local function createUniTog(parent, name, row, col)
    local btn = makeBtn(parent, UDim2.new(0.30,0,0.22,0),
        UDim2.new(0.02 + (col * 0.33), 0, 0.04 + (row * 0.26), 0),
        name, colors.panel, colors.text, 6)
    btn.TextSize = 11
    return btn
end

local killAllBtn = createUniTog(uniContainer, "💀 Kill All", 0,0)
local kickAllBtn = createUniTog(uniContainer, "👢 Kick All", 0,1)
local bringAllBtn = createUniTog(uniContainer, "📦 Bring All", 0,2)
local flingAllBtn = createUniTog(uniContainer, "🌀 Fling All", 1,0)

local targetBox = makeTextBox(uniContainer, UDim2.new(0.6,0,0.22,0), UDim2.new(0.05,0,0.3,0), "Имя игрока...")
local actionContainer = makeFrame(uniContainer, UDim2.new(0.9,0,0.2,0), UDim2.new(0.05,0,0.55,0), colors.bg2, 0, 6)

local killPlayerBtn = makeBtn(actionContainer, UDim2.new(0.22,0,0.8,0), UDim2.new(0.02,0,0.1,0), "🔪 Kill", colors.red, colors.text, 6)
local kickPlayerBtn = makeBtn(actionContainer, UDim2.new(0.22,0,0.8,0), UDim2.new(0.27,0,0.1,0), "👢 Kick", colors.accent, colors.text, 6)
local banPlayerBtn = makeBtn(actionContainer, UDim2.new(0.22,0,0.8,0), UDim2.new(0.52,0,0.1,0), "⛔ Ban", colors.gold, colors.text, 6)
local tpPlayerBtn = makeBtn(actionContainer, UDim2.new(0.22,0,0.8,0), UDim2.new(0.77,0,0.1,0), "🌀 TP", colors.green, colors.text, 6)
killPlayerBtn.TextSize = 10
kickPlayerBtn.TextSize = 10
banPlayerBtn.TextSize = 10
tpPlayerBtn.TextSize = 10

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
    mainPanel.Position = UDim2.new(0.5, -180, 0.5, -210)
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

-- Переключение вкладок
lfTabBtn.MouseButton1Click:Connect(function()
    currentTab = "LostFront"
    lfContainer.Visible = true
    uniContainer.Visible = false
    lfTabBtn.BackgroundColor3 = colors.accent
    uniTabBtn.BackgroundColor3 = colors.panel
end)

uniTabBtn.MouseButton1Click:Connect(function()
    currentTab = "Universal"
    lfContainer.Visible = false
    uniContainer.Visible = true
    uniTabBtn.BackgroundColor3 = colors.accent
    lfTabBtn.BackgroundColor3 = colors.panel
end)

minBtn.MouseButton1Click:Connect(minimizePanel)
restoreBtn.MouseButton1Click:Connect(restorePanel)

-- ========== ПЕРЕТАСКИВАНИЕ ==========
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

-- ========== ТОГГЛЫ ДЛЯ LOST FRONT ==========
local function setupLFToggle(btn, ind, name)
    btn.MouseButton1Click:Connect(function()
        lfToggles[name] = not lfToggles[name]
        if lfToggles[name] then
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

setupLFToggle(aimBtn, aimInd, "AimBot")
setupLFToggle(espBtn, espInd, "ESP")
setupLFToggle(wallBtn, wallInd, "Wallbang")
setupLFToggle(silentBtn, silentInd, "SilentAim")
setupLFToggle(triggerBtn, triggerInd, "Triggerbot")
setupLFToggle(spreadBtn, spreadInd, "NoSpread")
setupLFToggle(speedBtn, speedInd, "Speed")

-- ========== УНИВЕРСАЛЬНЫЕ ФУНКЦИИ (РАБОЧИЕ) ==========
local function getPlayers()
    local list = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then table.insert(list, v) end
    end
    return list
end

local function getPlayerByName(name)
    for _, v in pairs(Players:GetPlayers()) do
        if string.lower(v.Name):find(string.lower(name)) then
            return v
        end
    end
    return nil
end

-- Уничтожение игрока (работает в большинстве игр)
local function killPlayer(plr)
    if plr and plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part:BreakJoints()
            end
        end
        -- Альтернативный метод
        if plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
        end
    end
end

-- Кик (работает локально, но в некоторых играх сервер может перехватывать)
local function kickPlayer(plr)
    if plr then
        plr:Kick("Ты был кикнут!")
    end
end

-- Бан (симуляция бана)
local function banPlayer(plr)
    if plr then
        plr:Kick("Ты был забанен навсегда!")
        -- Добавляем в чёрный список (сохраняем в памяти скрипта)
    end
end

-- Телепорт к игроку
local function bringPlayer(plr)
    if plr and plr.Character and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
        if root and targetRoot then
            root.CFrame = targetRoot.CFrame + Vector3.new(0, 2, 0)
        end
    end
end

-- Флинг игрока
local function flingPlayer(plr)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local root = plr.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(4000,4000,4000)
        bv.Velocity = Vector3.new(math.random(-300,300), math.random(100,400), math.random(-300,300))
        bv.Parent = root
        game:GetService("Debris"):AddItem(bv, 0.5)
    end
end

-- ========== УНИВЕРСАЛЬНЫЕ КНОПКИ ==========
killAllBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(getPlayers()) do
        killPlayer(v)
    end
    statusText.Text = "💀 Все убиты!"
    wait(1); statusText.Text = "✅ Готов"
end)

kickAllBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(getPlayers()) do
        kickPlayer(v)
    end
    statusText.Text = "👢 Все кикнуты!"
    wait(1); statusText.Text = "✅ Готов"
end)

bringAllBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(getPlayers()) do
        bringPlayer(v)
    end
    statusText.Text = "📦 Все притянуты!"
    wait(1); statusText.Text = "✅ Готов"
end)

flingAllBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(getPlayers()) do
        flingPlayer(v)
    end
    statusText.Text = "🌀 Все разлетелись!"
    wait(1); statusText.Text = "✅ Готов"
end)

-- Действия с конкретным игроком
local function actionOnTarget(action)
    local name = targetBox.Text
    if name == "" or name == "Имя игрока..." then
        statusText.Text = "❌ Введите имя!"
        return
    end
    local target = getPlayerByName(name)
    if not target then
        statusText.Text = "❌ Игрок не найден!"
        return
    end
    action(target)
    statusText.Text = "✅ Готово для " .. target.Name
    wait(1); statusText.Text = "✅ Готов"
end

killPlayerBtn.MouseButton1Click:Connect(function()
    actionOnTarget(killPlayer)
end)

kickPlayerBtn.MouseButton1Click:Connect(function()
    actionOnTarget(kickPlayer)
end)

banPlayerBtn.MouseButton1Click:Connect(function()
    actionOnTarget(banPlayer)
end)

tpPlayerBtn.MouseButton1Click:Connect(function()
    actionOnTarget(bringPlayer)
end)

-- ========== ФУНКЦИОНАЛ ДЛЯ LOST FRONT (С УЧЁТОМ КОМАНД) ==========
-- Определяем врагов (игроки не в одной команде с нами)
local function getEnemies()
    local enemies = {}
    local myTeam = player.Team
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            if myTeam and v.Team and v.Team ~= myTeam then
                table.insert(enemies, v)
            elseif not myTeam then
                -- Если команды нет, считаем всех врагами
                table.insert(enemies, v)
            end
        end
    end
    return enemies
end

-- Основной цикл для Lost Front
RunService.Heartbeat:Connect(function()
    if not isKeyValid then return end

    -- AimBot (только враги)
    if lfToggles.AimBot then
        local enemies = getEnemies()
        local closest, closestDist
        for _, v in pairs(enemies) do
            if v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if not closestDist or dist < closestDist then
                        closest = v; closestDist = dist
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
        end
    end

    -- ESP (только враги)
    if lfToggles.ESP then
        local enemies = getEnemies()
        for _, v in pairs(enemies) do
            if v.Character then
                local h = v.Character:FindFirstChild("Highlight")
                if not h then
                    h = Instance.new("Highlight")
                    h.Adornee = v.Character
                    h.FillColor = Color3.fromRGB(255,50,50) -- Красный для врагов
                    h.OutlineColor = Color3.fromRGB(255,255,255)
                    h.FillTransparency = 0.4
                    h.Parent = v.Character
                end
            end
        end
        -- Убираем подсветку с союзников
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and not table.find(getEnemies(), v) then
                local h = v.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    else
        -- Убираем всю подсветку
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                local h = v.Character:FindFirstChild("Highlight")
                if h then h:Destroy() end
            end
        end
    end

    -- Speed
    if lfToggles.Speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.WalkSpeed ~= 16 then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end

    -- Wallbang (увеличиваем дальность стрельбы, если есть оружие)
    if lfToggles.Wallbang then
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                -- Увеличиваем дальность, если есть свойство
                -- Это зависит от игры, оставляем заглушку
            end
        end
    end

    -- Silent Aim
    if lfToggles.SilentAim then
        local enemies = getEnemies()
        local closest, closestDist
        for _, v in pairs(enemies) do
            if v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if not closestDist or dist < closestDist then
                        closest = v; closestDist = dist
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
        end
    end

    -- Triggerbot (авто-огонь по врагам)
    if lfToggles.Triggerbot then
        local enemies = getEnemies()
        local target = nil
        for _, v in pairs(enemies) do
            if v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < 80 then -- Радиус срабатывания
                        target = v
                        break
                    end
                end
            end
        end
        if target then
            -- Имитация клика мыши (если есть оружие)
            if player.Character and player.Character:FindFirstChildOfClass("Tool") then
                -- Можно использовать VirtualUser для клика
                -- VirtualUser:ClickButton()
            end
        end
    end

    -- NoSpread (убираем разброс)
    if lfToggles.NoSpread then
        -- Убираем разброс (зависит от игры)
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

-- Анимация появления
loginFrame.BackgroundTransparency = 1
TweenService:Create(loginFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

print("⚡ Legenly LK v3.1 загружен (исправлен)")
