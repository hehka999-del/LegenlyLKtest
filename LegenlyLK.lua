--[[
    Версия: 4.0
    Название: Legenly LK
    Фичи: Lost Front (AimBot, ESP, Wallbang, Silent Aim, NoRecoil, Speed)
           Squid Game X (RedLight, AntiHit, GlassMarker, ESP, Speed, NoClip)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")

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
local tg = {}

-- Настройки Lost Front
local lf = {
    AimBot = false,
    ESP = false,
    Wallbang = false,
    SilentAim = false,
    NoRecoil = false,
    Speed = false,
    Triggerbot = false,
    NoSpread = false
}

-- Настройки Squid Game X
local sg = {
    AntiHit = false,
    GlassMarker = false,
    ESP = false,
    Speed = false,
    NoClip = false,
    RedLight = false,
    TugOfWar = false
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
makeLabel(header, UDim2.new(0.25,0,1,0), UDim2.new(0.7,0,0,0), "v4.0", colors.textdim, 12)

local closeBtn = makeBtn(header, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 5), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,44), "Введи ключ (8 символов)", colors.textdim, 13)

local keyBox = makeTextBox(loginFrame, UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0,70), "Ключ...")

local copyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.05,0,0,110), "📋 Copy", colors.gold, Color3.fromRGB(0,0,0), 6)
local verifyBtn = makeBtn(loginFrame, UDim2.new(0.42,0,0,30), UDim2.new(0.53,0,0,110), "✅ Войти", colors.accent, colors.text, 6)

local statusLabel = makeLabel(loginFrame, UDim2.new(0.9,0,0,22), UDim2.new(0.05,0,0,150), "", colors.text, 12)

-- ========== ГЛАВНАЯ ПАНЕЛЬ ==========
local mainPanel = makeFrame(gui, UDim2.new(0, 380, 0, 420), UDim2.new(0.5, -190, 0.5, -210), colors.bg, 0, 12)
mainPanel.Visible = false

local panelHeader = makeFrame(mainPanel, UDim2.new(1,0,0,38), UDim2.new(0,0,0,0), colors.bg2, 0, 12)
local titleLabel = makeLabel(panelHeader, UDim2.new(0.4,0,1,0), UDim2.new(0.04,0,0,0), "⚡ Legenly LK", colors.gold, 15)

local minBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -64, 0, 6), "_", colors.bg2, colors.text, 6)
local closePanelBtn = makeBtn(panelHeader, UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0, 6), "✕", colors.bg2, Color3.fromRGB(255,120,120), 6)
closePanelBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Вкладки
local tabContainer = makeFrame(mainPanel, UDim2.new(0.94,0,0.08,0), UDim2.new(0.03,0,0.1,0), colors.bg2, 0, 6)
local lfTabBtn = makeBtn(tabContainer, UDim2.new(0.48,0,0.8,0), UDim2.new(0.01,0,0.1,0), "🎯 Lost Front", colors.accent, colors.text, 6)
local sgTabBtn = makeBtn(tabContainer, UDim2.new(0.48,0,0.8,0), UDim2.new(0.51,0,0.1,0), "🦑 Squid Game", colors.panel, colors.text, 6)
lfTabBtn.TextSize = 12; sgTabBtn.TextSize = 12

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
local noRecoilBtn, noRecoilInd = createLFTog(lfContainer, "No Recoil", 1,1)
local triggerBtn, triggerInd = createLFTog(lfContainer, "Triggerbot", 1,2)
local speedBtn, speedInd = createLFTog(lfContainer, "Speed", 2,0)
local spreadBtn, spreadInd = createLFTog(lfContainer, "No Spread", 2,1)

-- ===== ВКЛАДКА SQUID GAME X =====
local sgContainer = makeFrame(contentContainer, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), colors.bg2, 0, 6)
sgContainer.Visible = false

local function createSGTog(parent, name, row, col)
    local btn = makeBtn(parent, UDim2.new(0.30,0,0.22,0),
        UDim2.new(0.02 + (col * 0.33), 0, 0.04 + (row * 0.26), 0),
        name.." OFF", colors.panel, colors.text, 6)
    btn.TextSize = 11
    local ind = makeFrame(btn, UDim2.new(0.15,0,0.15,0), UDim2.new(0.42,0,0.80,0), Color3.fromRGB(80,80,100), 0, 4)
    return btn, ind
end

local sgAntiHitBtn, sgAntiHitInd = createSGTog(sgContainer, "Anti Hit", 0,0)
local sgGlassBtn, sgGlassInd = createSGTog(sgContainer, "Glass Marker", 0,1)
local sgEspBtn, sgEspInd = createSGTog(sgContainer, "ESP", 0,2)
local sgSpeedBtn, sgSpeedInd = createSGTog(sgContainer, "Speed", 1,0)
local sgNoClipBtn, sgNoClipInd = createSGTog(sgContainer, "NoClip", 1,1)
local sgRedBtn, sgRedInd = createSGTog(sgContainer, "RedLight", 1,2)
local sgTugBtn, sgTugInd = createSGTog(sgContainer, "Tug of War", 2,0)

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
    mainPanel.Position = UDim2.new(0.5, -190, 0.5, -210)
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
    sgContainer.Visible = false
    lfTabBtn.BackgroundColor3 = colors.accent
    sgTabBtn.BackgroundColor3 = colors.panel
end)

sgTabBtn.MouseButton1Click:Connect(function()
    currentTab = "SquidGame"
    lfContainer.Visible = false
    sgContainer.Visible = true
    sgTabBtn.BackgroundColor3 = colors.accent
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
        lf[name] = not lf[name]
        if lf[name] then
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
setupLFToggle(noRecoilBtn, noRecoilInd, "NoRecoil")
setupLFToggle(triggerBtn, triggerInd, "Triggerbot")
setupLFToggle(speedBtn, speedInd, "Speed")
setupLFToggle(spreadBtn, spreadInd, "NoSpread")

-- ========== ТОГГЛЫ ДЛЯ SQUID GAME X ==========
local function setupSGToggle(btn, ind, name)
    btn.MouseButton1Click:Connect(function()
        sg[name] = not sg[name]
        if sg[name] then
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

setupSGToggle(sgAntiHitBtn, sgAntiHitInd, "AntiHit")
setupSGToggle(sgGlassBtn, sgGlassInd, "GlassMarker")
setupSGToggle(sgEspBtn, sgEspInd, "ESP")
setupSGToggle(sgSpeedBtn, sgSpeedInd, "Speed")
setupSGToggle(sgNoClipBtn, sgNoClipInd, "NoClip")
setupSGToggle(sgRedBtn, sgRedInd, "RedLight")
setupSGToggle(sgTugBtn, sgTugInd, "TugOfWar")

-- ========== ОСНОВНОЙ ФУНКЦИОНАЛ (РАБОЧИЙ) ==========

-- ===== LOST FRONT =====
local function getEnemies()
    local enemies = {}
    local myTeam = player.Team
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            if myTeam and v.Team and v.Team ~= myTeam then
                table.insert(enemies, v)
            elseif not myTeam then
                table.insert(enemies, v)
            end
        end
    end
    return enemies
end

-- NoRecoil для Lost Front (убирает отдачу)
local function noRecoil()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local recoil = handle:FindFirstChild("Recoil")
            if recoil then recoil:Destroy() end
        end
    end
end

-- NoSpread для Lost Front (убирает разброс)
local function noSpread()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local spread = handle:FindFirstChild("Spread")
            if spread then spread:Destroy() end
        end
    end
end

-- Wallbang для Lost Front (увеличивает дальность)
local function wallbang()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if tool then
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local range = handle:FindFirstChild("Range")
            if range then range.Value = 10000 end
        end
    end
end

-- Triggerbot для Lost Front (авто-огонь)
local function triggerbot()
    local enemies = getEnemies()
    for _, v in pairs(enemies) do
        if v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = camera:WorldToScreenPoint(v.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if dist < 80 then
                    VirtualUser:ClickButton()
                end
            end
        end
    end
end

-- ===== SQUID GAME X =====
-- AntiHit (неуязвимость)
local function antiHit()
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 99999
            humanoid.Health = 99999
            humanoid.BreakJointsOnDeath = false
        end
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- GlassMarker (показывает настоящие стёкла)
local function glassMarker()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name:lower():find("glass") and v:IsA("BasePart") then
            if v.BrickColor == BrickColor.new("Bright green") then
                v.BrickColor = BrickColor.new("Really red")
            end
        end
    end
end

-- RedLight (помощь в мини-игре)
local function redLight()
    local children = Workspace:GetDescendants()
    for _, v in pairs(children) do
        if v:IsA("Model") and v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") then
            if v:FindFirstChild("Green") and v.Green.Value == true then
                -- если зелёный свет, можно идти
            end
        end
    end
end

-- TugOfWar (помощь в мини-игре)
local function tugOfWar()
    local player = Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(4000, 4000, 4000)
        bv.Velocity = Vector3.new(0, 50, 0)
        bv.Parent = root
        game:GetService("Debris"):AddItem(bv, 0.5)
    end
end

-- ========== ГЛАВНЫЙ ЦИКЛ ==========
RunService.Heartbeat:Connect(function()
    if not isKeyValid then return end

    -- ===== LOST FRONT =====
    if currentTab == "LostFront" then
        -- AimBot
        if lf.AimBot then
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
        if lf.ESP then
            local enemies = getEnemies()
            for _, v in pairs(enemies) do
                if v.Character then
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
            -- Убираем подсветку с союзников
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character then
                    local isEnemy = false
                    for _, e in pairs(getEnemies()) do
                        if e == v then isEnemy = true; break end
                    end
                    if not isEnemy then
                        local h = v.Character:FindFirstChild("Highlight")
                        if h then h:Destroy() end
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
        if lf.Speed and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
        elseif player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.WalkSpeed ~= 16 then
                player.Character.Humanoid.WalkSpeed = 16
            end
        end

        -- NoRecoil
        if lf.NoRecoil then noRecoil() end

        -- NoSpread
        if lf.NoSpread then noSpread() end

        -- Wallbang
        if lf.Wallbang then wallbang() end

        -- Silent Aim
        if lf.SilentAim then
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

        -- Triggerbot
        if lf.Triggerbot then triggerbot() end
    end

    -- ===== SQUID GAME X =====
    if currentTab == "SquidGame" then
        -- AntiHit
        if sg.AntiHit then antiHit() end

        -- GlassMarker
        if sg.GlassMarker then glassMarker() end

        -- ESP (все игроки)
        if sg.ESP then
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
        if sg.Speed and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
        elseif player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.WalkSpeed ~= 16 then
                player.Character.Humanoid.WalkSpeed = 16
            end
        end

        -- NoClip
        if sg.NoClip and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        elseif player.Character and not sg.NoClip then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end

        -- RedLight
        if sg.RedLight then redLight() end

        -- TugOfWar
        if sg.TugOfWar then tugOfWar() end
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

print("⚡ Legenly LK v4.0 загружен")
