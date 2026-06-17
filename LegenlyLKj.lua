--[[
    Версия: 1.3
    Название: Legenly LK
    Дизайн: Premium Dark Theme
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

-- Защита от повторного запуска
if _G.LegenlyLK_Loaded then return end
_G.LegenlyLK_Loaded = true

-- Создаем GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LegenlyLK"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Переменные
local isKeyValid = false
local generatedKey = ""
local isMinimized = false
local isDragging = false
local dragStart = nil
local startPos = nil

local toggles = {
    AimBot = false,
    ESP = false,
    Speed = false,
    Fly = false,
    InfiniteJump = false,
    NoClip = false,
    SilentAim = false
}

-- ===== ДИЗАЙН: ЦВЕТА И СТИЛИ =====
local colors = {
    Background = Color3.fromRGB(18, 18, 28),
    BackgroundDark = Color3.fromRGB(12, 12, 20),
    Panel = Color3.fromRGB(25, 25, 40),
    PanelHover = Color3.fromRGB(35, 35, 55),
    Accent = Color3.fromRGB(100, 180, 255),
    AccentDark = Color3.fromRGB(60, 120, 200),
    Gold = Color3.fromRGB(255, 215, 0),
    Red = Color3.fromRGB(255, 70, 70),
    Green = Color3.fromRGB(70, 255, 70),
    Purple = Color3.fromRGB(180, 70, 255),
    Text = Color3.fromRGB(230, 230, 245),
    TextDim = Color3.fromRGB(150, 150, 175),
    Border = Color3.fromRGB(45, 45, 65),
}

-- Функция создания скругленного фрейма
local function createRoundFrame(parent, size, pos, color, transparency, radius)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = pos
    frame.BackgroundColor3 = color or colors.Background
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = frame
    
    return frame
end

-- Функция создания кнопки
local function createButton(parent, size, pos, text, color, textColor, radius)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = color or colors.Panel
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = text or ""
    btn.TextColor3 = textColor or colors.Text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = btn
    
    return btn
end

-- Функция создания текста
local function createLabel(parent, size, pos, text, color, scale, font)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or colors.Text
    label.TextScaled = scale or false
    label.TextSize = 14
    label.Font = font or Enum.Font.GothamBold
    label.Parent = parent
    return label
end

-- Функция создания поля ввода
local function createTextBox(parent, size, pos, placeholder, color)
    local box = Instance.new("TextBox")
    box.Size = size
    box.Position = pos
    box.BackgroundColor3 = color or colors.Panel
    box.BackgroundTransparency = 0
    box.BorderSizePixel = 0
    box.Text = placeholder or ""
    box.TextColor3 = colors.TextDim
    box.TextScaled = true
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    return box
end

-- ===== ОКНО ВХОДА =====
local loginFrame = createRoundFrame(gui, UDim2.new(0, 380, 0, 340), UDim2.new(0.5, -190, 0.5, -170), colors.Background, 0, 16)

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
shadow.Parent = loginFrame

-- Заголовок с иконкой
local header = createRoundFrame(loginFrame, UDim2.new(1, 0, 0, 60), UDim2.new(0, 0, 0, 0), colors.BackgroundDark, 0, 12)
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local titleLabel = createLabel(header, UDim2.new(0.7, 0, 1, 0), UDim2.new(0.05, 0, 0, 0), "⚡ Legenly LK", colors.Gold, true)
titleLabel.TextSize = 22

local verLabel = createLabel(header, UDim2.new(0.2, 0, 1, 0), UDim2.new(0.75, 0, 0, 0), "v1.3", colors.TextDim, true)
verLabel.TextSize = 14

-- Кнопка закрытия
local closeBtn = createButton(header, UDim2.new(0, 32, 0, 32), UDim2.new(1, -40, 0, 14), "✕", Color3.fromRGB(40, 40, 60), Color3.fromRGB(255, 100, 100), 8)
closeBtn.TextScaled = true
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Подзаголовок
local subLabel = createLabel(loginFrame, UDim2.new(0.9, 0, 0, 30), UDim2.new(0.05, 0, 0, 75), "🔥 Введи ключ для доступа к читам", colors.TextDim, false)
subLabel.TextSize = 16

-- Поле ввода ключа
local keyBox = createTextBox(loginFrame, UDim2.new(0.9, 0, 0, 45), UDim2.new(0.05, 0, 0, 115), "Вставь ключ сюда...", colors.Panel)
keyBox.TextColor3 = colors.Text

-- Кнопка "Copy KEY"
local copyBtn = createButton(loginFrame, UDim2.new(0.42, 0, 0, 45), UDim2.new(0.05, 0, 0, 175), "📋 Copy KEY", colors.Gold, Color3.fromRGB(0, 0, 0), 8)
copyBtn.TextScaled = true

-- Кнопка "Verify Key"
local verifyBtn = createButton(loginFrame, UDim2.new(0.42, 0, 0, 45), UDim2.new(0.53, 0, 0, 175), "✅ Verify KEY", colors.AccentDark, colors.Text, 8)
verifyBtn.TextScaled = true

-- Статус
local statusLabel = createLabel(loginFrame, UDim2.new(0.9, 0, 0, 30), UDim2.new(0.05, 0, 0, 235), "", colors.Text, false)
statusLabel.TextSize = 16

-- Строка "Tap"
local tapLabel = createLabel(loginFrame, UDim2.new(0.3, 0, 0, 30), UDim2.new(0.05, 0, 0, 285), "⚡ Tap", colors.TextDim, false)
tapLabel.TextSize = 14

local chatLabel = createLabel(loginFrame, UDim2.new(0.4, 0, 0, 30), UDim2.new(0.55, 0, 0, 285), "💬 Чат", colors.TextDim, false)
chatLabel.TextSize = 14

-- ===== ГЛАВНАЯ ПАНЕЛЬ =====
local mainPanel = createRoundFrame(gui, UDim2.new(0, 450, 0, 520), UDim2.new(0.5, -225, 0.5, -260), colors.Background, 0, 16)
mainPanel.Visible = false

-- Тень для панели
local shadow2 = Instance.new("ImageLabel")
shadow2.Size = UDim2.new(1, 20, 1, 20)
shadow2.Position = UDim2.new(0, -10, 0, -10)
shadow2.BackgroundTransparency = 1
shadow2.Image = "rbxassetid://1316047255"
shadow2.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow2.ImageTransparency = 0.6
shadow2.ScaleType = Enum.ScaleType.Slice
shadow2.SliceCenter = Rect.new(10, 10, 10, 10)
shadow2.Parent = mainPanel

-- Заголовок панели
local panelHeader = createRoundFrame(mainPanel, UDim2.new(1, 0, 0, 55), UDim2.new(0, 0, 0, 0), colors.BackgroundDark, 0, 12)
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panelHeader

local panelTitle = createLabel(panelHeader, UDim2.new(0.5, 0, 1, 0), UDim2.new(0.05, 0, 0, 0), "⚡ Legenly LK", colors.Gold, true)
panelTitle.TextSize = 20

-- Кнопка сворачивания в полоску (НЕ закрытия!)
local minimizeBtn = createButton(panelHeader, UDim2.new(0, 35, 0, 35), UDim2.new(1, -85, 0, 10), "─", Color3.fromRGB(40, 40, 60), colors.Text, 8)
minimizeBtn.TextScaled = true

-- Кнопка закрытия панели
local closePanelBtn = createButton(panelHeader, UDim2.new(0, 35, 0, 35), UDim2.new(1, -45, 0, 10), "✕", Color3.fromRGB(40, 40, 60), Color3.fromRGB(255, 100, 100), 8)
closePanelBtn.TextScaled = true

-- Контейнер для кнопок
local btnContainer = createRoundFrame(mainPanel, UDim2.new(0.9, 0, 0.7, 0), UDim2.new(0.05, 0, 0.13, 0), colors.BackgroundDark, 0, 12)

-- Создание кнопок-тогглов
local function createToggleBtn(parent, name, row, col, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0.28, 0)
    btn.Position = UDim2.new(0.05 + (col * 0.33), 0, 0.05 + (row * 0.35), 0)
    btn.BackgroundColor3 = colors.Panel
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Text = name .. "\n[OFF]"
    btn.TextColor3 = colors.Text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    -- Индикатор
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0.2, 0, 0.15, 0)
    indicator.Position = UDim2.new(0.4, 0, 0.8, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    indicator.BackgroundTransparency = 0
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator
    
    return btn, indicator
end

-- Создаем 7 кнопок в 2 ряда
local aimBtn, aimInd = createToggleBtn(btnContainer, "🎯 AimBot", 0, 0, colors.Red)
local espBtn, espInd = createToggleBtn(btnContainer, "👁 ESP", 0, 1, colors.Green)
local speedBtn, speedInd = createToggleBtn(btnContainer, "⚡ Speed", 0, 2, colors.Accent)
local flyBtn, flyInd = createToggleBtn(btnContainer, "🕊 Fly", 1, 0, colors.Gold)
local jumpBtn, jumpInd = createToggleBtn(btnContainer, "🦘 Jump", 1, 1, colors.Purple)
local noclipBtn, noclipInd = createToggleBtn(btnContainer, "🌀 NoClip", 1, 2, Color3.fromRGB(0, 200, 200))
local silentBtn, silentInd = createToggleBtn(btnContainer, "🔇 Silent", 2, 0, Color3.fromRGB(255, 100, 200))

-- Третья кнопка во втором ряду (пустое место)
local emptyPlace = Instance.new("Frame")
emptyPlace.Size = UDim2.new(0.28, 0, 0.28, 0)
emptyPlace.Position = UDim2.new(0.05 + (2 * 0.33), 0, 0.05 + (2 * 0.35), 0)
emptyPlace.BackgroundTransparency = 1
emptyPlace.Parent = btnContainer

-- Строка статуса внизу
local statusBar = createRoundFrame(mainPanel, UDim2.new(0.9, 0, 0, 35), UDim2.new(0.05, 0, 0.88, 0), colors.BackgroundDark, 0, 8)
local statusText = createLabel(statusBar, UDim2.new(0.9, 0, 1, 0), UDim2.new(0.05, 0, 0, 0), "✅ Готов к работе", colors.TextDim, false)
statusText.TextSize = 14

-- ===== МИНИ-ПОЛОСКА (сворачивание) =====
local miniBar = createRoundFrame(gui, UDim2.new(0.25, 0, 0, 40), UDim2.new(0.375, 0, -1, 0), colors.Background, 0, 12)
miniBar.Visible = false

local miniLabel = createLabel(miniBar, UDim2.new(0.8, 0, 1, 0), UDim2.new(0.05, 0, 0, 0), "⚡ Legenly LK", colors.Gold, true)
miniLabel.TextSize = 18

local miniRestore = createButton(miniBar, UDim2.new(0, 35, 0, 35), UDim2.new(1, -45, 0, 3), "⬆", Color3.fromRGB(40, 40, 60), colors.Text, 8)
miniRestore.TextScaled = true

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
    isMinimized = false
    miniBar.Visible = false
    statusText.Text = "✅ Панель активирована"
end

local function minimizePanel()
    isMinimized = true
    mainPanel.Visible = false
    miniBar.Visible = true
    miniBar.Position = UDim2.new(0.375, 0, -1, 0)
    TweenService:Create(miniBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0.375, 0, 0, 10)}):Play()
end

local function restorePanel()
    isMinimized = false
    miniBar.Visible = false
    mainPanel.Visible = true
    mainPanel.Position = UDim2.new(0.5, -225, 0.5, -260)
end

-- ===== ОБРАБОТЧИКИ КНОПОК =====
copyBtn.MouseButton1Click:Connect(function()
    generatedKey = generateKey()
    setclipboard(generatedKey)
    keyBox.Text = generatedKey
    keyBox.TextColor3 = colors.Text
    statusLabel.Text = "✅ Ключ скопирован!"
    statusLabel.TextColor3 = colors.Green
    wait(2)
    statusLabel.Text = ""
end)

verifyBtn.MouseButton1Click:Connect(function()
    local input = keyBox.Text
    if input == "" or input == "Вставь ключ сюда..." then
        statusLabel.Text = "❌ Вставь ключ!"
        statusLabel.TextColor3 = colors.Red
        return
    end
    if verifyKey(input) then
        statusLabel.Text = "✅ Добро пожаловать!"
        statusLabel.TextColor3 = colors.Green
        isKeyValid = true
        wait(0.5)
        openPanel()
    else
        statusLabel.Text = "❌ Неверный ключ!"
        statusLabel.TextColor3 = colors.Red
    end
    wait(2)
    statusLabel.Text = ""
end)

closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
closePanelBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

minimizeBtn.MouseButton1Click:Connect(function()
    minimizePanel()
end)

miniRestore.MouseButton1Click:Connect(function()
    restorePanel()
end)

-- ===== ПЕРЕТАСКИВАНИЕ =====
local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

makeDraggable(loginFrame)
makeDraggable(mainPanel)
makeDraggable(miniBar)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local frame = nil
        if loginFrame.Visible then frame = loginFrame
        elseif mainPanel.Visible then frame = mainPanel
        elseif miniBar.Visible then frame = miniBar end
        if frame then
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

-- ===== ТОГГЛЫ =====
local function setupToggle(btn, indicator, name, colorOn)
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        if toggles[name] then
            btn.BackgroundColor3 = colorOn
            btn.Text = string.gsub(btn.Text, "%[OFF%]", "[ON]")
            indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            statusText.Text = "✅ " .. name .. " включен"
        else
            btn.BackgroundColor3 = colors.Panel
            btn.Text = string.gsub(btn.Text, "%[ON%]", "[OFF]")
            indicator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            statusText.Text = "❌ " .. name .. " выключен"
        end
        wait(0.5)
        statusText.Text = "✅ Готов к работе"
    end)
end

setupToggle(aimBtn, aimInd, "AimBot", colors.Red)
setupToggle(espBtn, espInd, "ESP", colors.Green)
setupToggle(speedBtn, speedInd, "Speed", colors.Accent)
setupToggle(flyBtn, flyInd, "Fly", colors.Gold)
setupToggle(jumpBtn, jumpInd, "InfiniteJump", colors.Purple)
setupToggle(noclipBtn, noclipInd, "NoClip", Color3.fromRGB(0, 200, 200))
setupToggle(silentBtn, silentInd, "SilentAim", Color3.fromRGB(255, 100, 200))

-- ===== ФУНКЦИОНАЛ ЧИТОВ (РАБОЧИЙ) =====
RunService.Heartbeat:Connect(function()
    if not isKeyValid then return end
    
    -- AimBot
    if toggles.AimBot then
        local closest, closestDist
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, onScreen = camera:WorldToScreenPoint(v.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if not closestDist or dist < closestDist then
                        closest = v
                        closestDist = dist
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Character.Head.Position)
        end
    end
    
    -- ESP
    if toggles.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local highlight = v.Character:FindFirstChild("Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Adornee = v.Character
                    highlight.FillColor = Color3.fromRGB(255, 50, 50)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.4
                    highlight.Parent = v.Character
                end
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                local highlight = v.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
    
    -- Speed
    if toggles.Speed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.WalkSpeed ~= 16 then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
    
    -- Fly
    if toggles.Fly and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.PlatformStand = true
        local bv = player.Character:FindFirstChild("BodyVelocity")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(4000, 4000, 4000)
            bv.Parent = player.Character
        end
        local dir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector * 50 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = Vector3.new(0, 50, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = Vector3.new(0, -50, 0) end
        bv.Velocity = dir
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = false
        local bv = player.Character:FindFirstChild("BodyVelocity")
        if bv then bv:Destroy() end
    end
    
    -- Infinite Jump
    if toggles.InfiniteJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 100
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.JumpPower ~= 50 then
            player.Character.Humanoid.JumpPower = 50
        end
    end
    
    -- NoClip
    if toggles.NoClip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif player.Character and not toggles.NoClip then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end)

-- ===== АНИМАЦИЯ ПОЯВЛЕНИЯ =====
loginFrame.BackgroundTransparency = 1
TweenService:Create(loginFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
loginFrame.Position = UDim2.new(0.5, -190, 0.5, -170)

print("⚡ Legenly LK v1.3 загружен!")
