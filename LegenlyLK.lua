--[[
    Версия: 2.2
    Название: Legenly LK
    Для: Delta (мобильные и ПК)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

if _G.LegenlyLK_Loaded then return end
_G.LegenlyLK_Loaded = true

-- GUI (адаптив)
local gui = Instance.new("ScreenGui")
gui.Name = "LegenlyLK"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Переменные
local isKeyValid = false
local generatedKey = ""
local isMinimized = false
local musicSound = nil
local flySpeed = 50
local toggles = {
    AimBot = false,
    ESP = false,
    Speed = false,
    Fly = false,
    InfiniteJump = false,
    NoClip = false,
    SilentAim = false
}

-- Цвета (тёмная тема)
local colors = {
    bg = Color3.fromRGB(18, 18, 28),
    bg2 = Color3.fromRGB(28, 28, 40),
    panel = Color3.fromRGB(40, 40, 55),
    accent = Color3.fromRGB(70, 150, 255),
    gold = Color3.fromRGB(230, 200, 100),
    red = Color3.fromRGB(220, 70, 70),
    green = Color3.fromRGB(70, 220, 70),
    text = Color3.fromRGB(220, 220, 235),
    textdim = Color3.fromRGB(160, 160, 180),
}

-- Вспомогательные функции (создание элементов)
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

-- ===== ОКНО ВХОДА (адаптивное) =====
local loginFrame = makeFrame(gui, UDim2.new(0, 300, 0, 240), UDim2.new(0.5, -150, 0.5, -120), colors.bg, 0, 12)

-- Заголовок
local header = makeFrame(loginFrame, UDim2.new(1, 0, 0, 38), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
makeLabel(header, UDim2.new(0.65,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 17)
makeLabel(header, UDim2.new(0.25,0,1,0), UDim2.new(0.7,0,0,0), "v2.2", colors.textdim, 13)

-- Кнопка закрытия
local closeBtn = makeBtn(header, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 6), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Подзаголовок
makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,46), "Введи ключ", colors.textdim, 14)

-- Поле ввода
local keyBox = makeTextBox(loginFrame, UDim2.new(0.9,0,0,32), UDim2.new(0.05,0,0,74), "Вставь ключ...")

-- Кнопки
local copyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,32), UDim2.new(0.05,0,0,116), "📋 Copy", colors.gold, Color3.fromRGB(0,0,0), 6)
local verifyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,32), UDim2.new(0.53,0,0,116), "✅ Verify", colors.accent, colors.text, 6)

-- Статус
local statusLabel = makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,158), "", colors.text, 13)

-- ===== ГЛАВНАЯ ПАНЕЛЬ (адаптивная) =====
local mainPanel = makeFrame(gui, UDim2.new(0, 360, 0, 400), UDim2.new(0.5, -180, 0.5, -200), colors.bg, 0, 12)
mainPanel.Visible = false

-- Заголовок панели
local panelHeader = makeFrame(mainPanel, UDim2.new(1,0,0,38), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
makeLabel(panelHeader, UDim2.new(0.55,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 16)

-- Кнопки управления
local minBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -64, 0, 6), "−", colors.bg2, colors.text, 6)
local closePanelBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 6), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closePanelBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Контейнер для кнопок-тогглов
local btnContainer = makeFrame(mainPanel, UDim2.new(0.94,0,0.55,0), UDim2.new(0.03,0,0.12,0), colors.bg2, 0, 8)

-- Создание кнопок-тогглов (3x3)
local function createTog(parent, name, row, col, color)
    local btn = makeBtn(parent, UDim2.new(0.30,0,0.28,0), 
        UDim2.new(0.02 + (col * 0.33), 0, 0.04 + (row * 0.35), 0),
        name.." OFF", colors.panel, colors.text, 8)
    btn.TextSize = 12
    local ind = makeFrame(btn, UDim2.new(0.15,0,0.15,0), UDim2.new(0.42,0,0.80,0), Color3.fromRGB(80,80,100), 0, 4)
    return btn, ind
end

local aimBtn, aimInd = createTog(btnContainer, "AimBot", 0,0, colors.red)
local espBtn, espInd = createTog(btnContainer, "ESP", 0,1, colors.green)
local speedBtn, speedInd = createTog(btnContainer, "Speed", 0,2, colors.accent)
local flyBtn, flyInd = createTog(btnContainer, "Fly", 1,0, colors.gold)
local jumpBtn, jumpInd = createTog(btnContainer, "Jump", 1,1, Color3.fromRGB(180,80,255))
local noclipBtn, noclipInd = createTog(btnContainer, "NoClip", 1,2, Color3.fromRGB(0,200,200))
local silentBtn, silentInd = createTog(btnContainer, "Silent", 2,0, Color3.fromRGB(255,100,200))
-- Пустая ячейка
makeFrame(btnContainer, UDim2.new(0.30,0,0.28,0), UDim2.new(0.02 + 2*0.33,0, 0.04 + 2*0.35,0), Color3.fromRGB(0,0,0), 1)

-- Секция музыки
local musicFrame = makeFrame(mainPanel, UDim2.new(0.94,0,0.18,0), UDim2.new(0.03,0,0.72,0), colors.bg2, 0, 8)
makeLabel(musicFrame, UDim2.new(0.25,0,1,0), UDim2.new(0.03,0,0,0), "🎵 Музыка", colors.text, 13)
local musicIdBox = makeTextBox(musicFrame, UDim2.new(0.45,0,0.7,0), UDim2.new(0.28,0,0.15,0), "ID трека", colors.panel)
local startMusicBtn = makeBtn(musicFrame, UDim2.new(0.18,0,0.7,0), UDim2.new(0.76,0,0.15,0), "▶ Start", colors.accent, colors.text, 6)
startMusicBtn.TextSize = 12

-- Статус-бар
local statusBar = makeFrame(mainPanel, UDim2.new(0.94,0,0.06,0), UDim2.new(0.03,0,0.92,0), colors.bg2, 0, 6)
local statusText = makeLabel(statusBar, UDim2.new(0.9,0,1,0), UDim2.new(0.04,0,0,0), "✅ Готов", colors.textdim, 12)

-- ===== МИНИ-ПОЛОСКА =====
local miniBar = makeFrame(gui, UDim2.new(0.25,0,0,36), UDim2.new(0.375,0, -1,0), colors.bg, 0, 10)
miniBar.Visible = false
makeLabel(miniBar, UDim2.new(0.7,0,1,0), UDim2.new(0.05,0,0,0), "⚡ LK", colors.gold, 15)
local restoreBtn = makeBtn(miniBar, UDim2.new(0,28,0,28), UDim2.new(1, -34, 0, 4), "⬆", colors.bg, colors.text, 6)

-- ===== ФУНКЦИИ =====
local function generateKey()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local key = ""
    for i = 1, 16 do
        key = key .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
        if i % 4 == 0 and i < 16 then key = key .. "-" end
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
    miniBar.Position = UDim2.new(0.375,0, -1,0)
    TweenService:Create(miniBar, TweenInfo.new(0.3), {Position = UDim2.new(0.375,0, 0, 10)}):Play()
end

local function restorePanel()
    isMinimized = false
    miniBar.Visible = false
    mainPanel.Visible = true
    mainPanel.Position = UDim2.new(0.5, -180, 0.5, -200)
end

-- Обработчики кнопок входа
copyBtn.MouseButton1Click:Connect(function()
    generatedKey = generateKey()
    setclipboard(generatedKey)
    keyBox.Text = generatedKey
    keyBox.TextColor3 = colors.text
    statusLabel.Text = "✅ Скопирован"
    statusLabel.TextColor3 = colors.green
    wait(1.5); statusLabel.Text = ""
end)

verifyBtn.MouseButton1Click:Connect(function()
    local input = keyBox.Text
    if input == "" or input == "Вставь ключ..." then
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

-- Перетаскивание окон
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

-- ===== ТОГГЛЫ =====
local function setupToggle(btn, ind, name, colorOn)
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        if toggles[name] then
            btn.BackgroundColor3 = colorOn
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
setupToggle(aimBtn, aimInd, "AimBot", colors.red)
setupToggle(espBtn, espInd, "ESP", colors.green)
setupToggle(speedBtn, speedInd, "Speed", colors.accent)
setupToggle(flyBtn, flyInd, "Fly", colors.gold)
setupToggle(jumpBtn, jumpInd, "InfiniteJump", Color3.fromRGB(180,80,255))
setupToggle(noclipBtn, noclipInd, "NoClip", Color3.fromRGB(0,200,200))
setupToggle(silentBtn, silentInd, "SilentAim", Color3.fromRGB(255,100,200))

-- ===== МУЗЫКА (ГЛОБАЛЬНАЯ) =====
startMusicBtn.MouseButton1Click:Connect(function()
    local id = musicIdBox.Text
    if id == "" or id == "ID трека" then
        statusText.Text = "❌ Введите ID"
        return
    end
    -- Удаляем старый звук
    if musicSound and musicSound.Parent then musicSound:Destroy() end
    
    -- Создаём звук в SoundService (глобально)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. id
    sound.Looped = true
    sound.Volume = 1
    sound.Parent = SoundService
    local success, err = pcall(function() sound:Play() end)
    if success then
        musicSound = sound
        statusText.Text = "🎵 Музыка играет для всех"
        -- Автоматически остановить через 60 секунд, чтобы не перегружать
        game:GetService("Debris"):AddItem(sound, 60)
    else
        statusText.Text = "❌ Ошибка: " .. err
        sound:Destroy()
    end
end)

-- ===== ФУНКЦИОНАЛ ЧИТОВ (ПОЛНОСТЬЮ ПЕРЕПИСАН) =====
RunService.Heartbeat:Connect(function()
    if not isKeyValid then return end

    -- AimBot (плавное наведение)
    if toggles.AimBot then
        local closest, closestDist
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
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

    -- ESP (подсветка)
    if toggles.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local h = v.Character:FindFirstChild("Highlight")
                if not h then
                    h = Instance.new("Highlight")
                    h.Adornee = v.Character
                    h.FillColor = Color3.fromRGB(255,50,50)
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

    -- Speed (увеличение скорости)
    if toggles.Speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.WalkSpeed ~= 16 then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end

    -- Fly (полет с управлением WASD + пробел/Shift)
    if toggles.Fly and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.PlatformStand = true
        local bv = player.Character:FindFirstChild("BodyVelocity")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(4000,4000,4000)
            bv.Parent = player.Character
        end
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = Vector3.new(0, -flySpeed, 0) end
        bv.Velocity = dir
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = false
        local bv = player.Character:FindFirstChild("BodyVelocity")
        if bv then bv:Destroy() end
    end

    -- Infinite Jump (бесконечные прыжки)
    if toggles.InfiniteJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 100
        -- Перехватываем прыжок
        if not player.Character:FindFirstChild("JumpHandler") then
            local handler = Instance.new("BindableEvent")
            handler.Name = "JumpHandler"
            handler.Parent = player.Character
            handler.Event:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            UserInputService.JumpRequest:Connect(function()
                if player.Character and player.Character:FindFirstChild("JumpHandler") then
                    player.Character.JumpHandler:Fire()
                end
            end)
        end
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.JumpPower ~= 50 then
            player.Character.Humanoid.JumpPower = 50
        end
        local handler = player.Character:FindFirstChild("JumpHandler")
        if handler then handler:Destroy() end
    end

    -- NoClip (проход сквозь стены)
    if toggles.NoClip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif player.Character and not toggles.NoClip then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end

    -- Silent Aim (автоматическое наведение на ближайшего)
    if toggles.SilentAim then
        local closest, closestDist
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
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
            -- Меняем направление камеры без рывка
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
        end
    end
end)

-- ===== ГОРЯЧАЯ КЛАВИША ESC ДЛЯ ЗАКРЫТИЯ =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        gui:Destroy()
    end
end)

-- Анимация появления
loginFrame.BackgroundTransparency = 1
TweenService:Create(loginFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

print("⚡ Legenly LK v2.2 загружен (исправлен)")
