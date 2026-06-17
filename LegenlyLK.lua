--[[
    Версия: 1.2
    Название: Legenly LK
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = Workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "LegenlyLK"
gui.Parent = player:WaitForChild("PlayerGui")

local isKeyValid = false
local isMinimized = false
local generatedKey = ""
local toggles = {AimBot=false, ESP=false, Speed=false, Fly=false, InfiniteJump=false, NoClip=false, SilentAim=false}

-- Окно входа
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 400, 0, 300)
loginFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
loginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
loginFrame.BackgroundTransparency = 0.1
loginFrame.BorderSizePixel = 0
loginFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Legenly LK  v1.2"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = loginFrame

local subTitle = Instance.new("TextLabel")
subTitle.Size = UDim2.new(1, 0, 0, 30)
subTitle.Position = UDim2.new(0, 0, 0, 50)
subTitle.BackgroundTransparency = 1
subTitle.Text = "⚡ Welcome to Legenly LK ⚡"
subTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
subTitle.TextScaled = true
subTitle.Font = Enum.Font.Gotham
subTitle.Parent = loginFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0, 100)
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
keyBox.BorderSizePixel = 0
keyBox.Text = "Paste your key here..."
keyBox.TextColor3 = Color3.fromRGB(200, 200, 200)
keyBox.TextScaled = true
keyBox.Font = Enum.Font.Gotham
keyBox.ClearTextOnFocus = false
keyBox.Parent = loginFrame

local copyKeyBtn = Instance.new("TextButton")
copyKeyBtn.Size = UDim2.new(0.35, 0, 0, 40)
copyKeyBtn.Position = UDim2.new(0.08, 0, 0, 160)
copyKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
copyKeyBtn.BorderSizePixel = 0
copyKeyBtn.Text = "Copy KEY"
copyKeyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
copyKeyBtn.TextScaled = true
copyKeyBtn.Font = Enum.Font.GothamBold
copyKeyBtn.Parent = loginFrame

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(0.45, 0, 0, 40)
verifyBtn.Position = UDim2.new(0.47, 0, 0, 160)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
verifyBtn.BorderSizePixel = 0
verifyBtn.Text = "Verify Key"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextScaled = true
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.Parent = loginFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 215)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = loginFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = loginFrame

-- Главная панель
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, 500, 0, 600)
mainPanel.Position = UDim2.new(0.5, -250, 0.5, -300)
mainPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
mainPanel.BackgroundTransparency = 0.05
mainPanel.BorderSizePixel = 0
mainPanel.Visible = false
mainPanel.Parent = gui

local panelTitle = Instance.new("TextLabel")
panelTitle.Size = UDim2.new(1, 0, 0, 45)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "⚡ Legenly LK Panel ⚡"
panelTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
panelTitle.TextScaled = true
panelTitle.Font = Enum.Font.GothamBold
panelTitle.Parent = mainPanel

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -45, 0, 5)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = mainPanel

local closePanelBtn = Instance.new("TextButton")
closePanelBtn.Size = UDim2.new(0, 35, 0, 35)
closePanelBtn.Position = UDim2.new(1, -85, 0, 5)
closePanelBtn.BackgroundTransparency = 1
closePanelBtn.Text = "✕"
closePanelBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closePanelBtn.TextScaled = true
closePanelBtn.Font = Enum.Font.GothamBold
closePanelBtn.Parent = mainPanel

local miniBar = Instance.new("Frame")
miniBar.Size = UDim2.new(0.3, 0, 0, 30)
miniBar.Position = UDim2.new(0.35, 0, -1, 0)
miniBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
miniBar.BackgroundTransparency = 0.1
miniBar.BorderSizePixel = 0
miniBar.Visible = false
miniBar.Parent = gui

local miniText = Instance.new("TextLabel")
miniText.Size = UDim2.new(1, 0, 1, 0)
miniText.BackgroundTransparency = 1
miniText.Text = "⚡ LK ⚡"
miniText.TextColor3 = Color3.fromRGB(255, 215, 0)
miniText.TextScaled = true
miniText.Font = Enum.Font.GothamBold
miniText.Parent = miniBar

-- Создание кнопок
local function createToggle(parent, name, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
    btn.BorderSizePixel = 0
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    return btn
end

local aimBtn = createToggle(mainPanel, "AimBot", 60, Color3.fromRGB(200, 50, 50))
local espBtn = createToggle(mainPanel, "ESP", 115, Color3.fromRGB(50, 200, 50))
local speedBtn = createToggle(mainPanel, "Speed", 170, Color3.fromRGB(50, 150, 255))
local flyBtn = createToggle(mainPanel, "Fly", 225, Color3.fromRGB(255, 150, 50))
local jumpBtn = createToggle(mainPanel, "Infinite Jump", 280, Color3.fromRGB(200, 50, 200))
local noclipBtn = createToggle(mainPanel, "NoClip", 335, Color3.fromRGB(50, 200, 200))
local silentBtn = createToggle(mainPanel, "Silent Aim", 390, Color3.fromRGB(255, 50, 150))

-- Функции
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
end

local function minimizePanel()
    isMinimized = true
    mainPanel.Visible = false
    miniBar.Visible = true
    miniBar.Position = UDim2.new(0.35, 0, 0, 5)
end

local function restorePanel()
    isMinimized = false
    miniBar.Visible = false
    mainPanel.Visible = true
end

-- Кнопки
copyKeyBtn.MouseButton1Click:Connect(function()
    generatedKey = generateKey()
    setclipboard(generatedKey)
    keyBox.Text = generatedKey
    statusLabel.Text = "✅ Key copied!"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    wait(2)
    statusLabel.Text = ""
end)

verifyBtn.MouseButton1Click:Connect(function()
    local input = keyBox.Text
    if input == "" or input == "Paste your key here..." then
        statusLabel.Text = "❌ Please paste a key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    if verifyKey(input) then
        statusLabel.Text = "✅ Welcome!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        isKeyValid = true
        wait(0.5)
        openPanel()
    else
        statusLabel.Text = "❌ Invalid key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
    wait(2)
    statusLabel.Text = ""
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
closePanelBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
minimizeBtn.MouseButton1Click:Connect(function()
    minimizePanel()
end)
miniBar.MouseButton1Click:Connect(function()
    restorePanel()
end)

-- Перетаскивание
local function makeDraggable(frame)
    local dragging = false
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(loginFrame)
makeDraggable(mainPanel)
makeDraggable(miniBar)

-- Функционал читов
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
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
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
        player.Character.Humanoid.WalkSpeed = 16
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
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 50
    end
    
    -- NoClip
    if toggles.NoClip and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    elseif player.Character and not toggles.NoClip then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end)

-- Тогглы
local function toggleFunc(btn, name, colorOn)
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        if toggles[name] then
            btn.BackgroundColor3 = colorOn
            btn.Text = string.gsub(btn.Text, "%[OFF%]", "[ON]")
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            btn.Text = string.gsub(btn.Text, "%[ON%]", "[OFF]")
        end
    end)
end

toggleFunc(aimBtn, "AimBot", Color3.fromRGB(200, 50, 50))
toggleFunc(espBtn, "ESP", Color3.fromRGB(50, 200, 50))
toggleFunc(speedBtn, "Speed", Color3.fromRGB(50, 150, 255))
toggleFunc(flyBtn, "Fly", Color3.fromRGB(255, 150, 50))
toggleFunc(jumpBtn, "InfiniteJump", Color3.fromRGB(200, 50, 200))
toggleFunc(noclipBtn, "NoClip", Color3.fromRGB(50, 200, 200))
toggleFunc(silentBtn, "SilentAim", Color3.fromRGB(255, 50, 150))

print("Legenly LK v1.2 loaded!")
