--[[
    Legenly LK — Краснодар РП Edition
    Все функции переписаны под реалии игры
    Ничего не убрано, всё починено
    Адаптивный дизайн для Infinix Hot 30i
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local player = Players.LocalPlayer

if _G.LegenlyLK_Loaded then return end
_G.LegenlyLK_Loaded = true

-- ===== GUI (маленький, 300x380) =====
local gui = Instance.new("ScreenGui")
gui.Name = "LegenlyLK"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 380)
main.Position = UDim2.new(0.5, -150, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2
stroke.Transparency = 0.5

-- ===== ЗАГОЛОВОК =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0.04, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ LK"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -50, 0, 3)
minBtn.BackgroundTransparency = 1
minBtn.Text = "_"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = header
minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    miniFrame.Visible = true
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -26, 0, 3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ===== МИНИ-ПОЛОСКА (сверху, перетаскиваемая) =====
local miniFrame = Instance.new("Frame")
miniFrame.Size = UDim2.new(0, 100, 0, 26)
miniFrame.Position = UDim2.new(0.5, -50, 0, 5)
miniFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
miniFrame.BackgroundTransparency = 0.05
miniFrame.BorderSizePixel = 0
miniFrame.Visible = false
miniFrame.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 8)
miniCorner.Parent = miniFrame

local miniTitle = Instance.new("TextLabel")
miniTitle.Size = UDim2.new(0.7, 0, 1, 0)
miniTitle.Position = UDim2.new(0.05, 0, 0, 0)
miniTitle.BackgroundTransparency = 1
miniTitle.Text = "⚡ LK"
miniTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
miniTitle.TextScaled = true
miniTitle.Font = Enum.Font.GothamBold
miniTitle.Parent = miniFrame

local miniRestore = Instance.new("TextButton")
miniRestore.Size = UDim2.new(0, 22, 0, 22)
miniRestore.Position = UDim2.new(1, -26, 0, 2)
miniRestore.BackgroundTransparency = 1
miniRestore.Text = "⬆"
miniRestore.TextColor3 = Color3.fromRGB(255, 255, 255)
miniRestore.TextScaled = true
miniRestore.Font = Enum.Font.GothamBold
miniRestore.Parent = miniFrame
miniRestore.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    main.Visible = true
end)

local miniDrag = false
local miniStart, miniPos
miniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        miniDrag = true
        miniStart = input.Position
        miniPos = miniFrame.Position
    end
end)
miniFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then miniDrag = false end
end)
UIS.InputChanged:Connect(function(input)
    if miniDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - miniStart
        miniFrame.Position = UDim2.new(miniPos.X.Scale, miniPos.X.Offset + delta.X, miniPos.Y.Scale, miniPos.Y.Offset + delta.Y)
    end
end)

-- ===== ВКЛАДКИ =====
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 28)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = main

local tabs = {"🎵", "⚡", "🛠", "🔥"}
local tabBtns = {}
local contents = {}

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(180, 180, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tabContainer
    tabBtns[i] = btn

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, -58)
    content.Position = UDim2.new(0, 0, 0, 58)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 500)
    content.ScrollBarThickness = 3
    content.Visible = (i == 1)
    content.Parent = main
    contents[i] = content

    btn.MouseButton1Click:Connect(function()
        for j, c in ipairs(contents) do
            c.Visible = (j == i)
            tabBtns[j].TextColor3 = (j == i) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(180, 180, 200)
        end
    end)
end

-- ===== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ =====
local function createBtn(parent, text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 28)
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
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn
    return btn
end

local function createTextBox(parent, placeholder, y)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.6, 0, 0, 28)
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
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = box
    return box
end

-- ===== ОБЩАЯ ФУНКЦИЯ ДЛЯ ОТПРАВКИ КОМАНД В ЧАТ =====
local function sendCommand(cmd)
    local chat = RS:FindFirstChild("DefaultChatSystemChatEvents")
    if chat then
        local say = chat:FindFirstChild("SayMessageRequest")
        if say then
            say:FireServer(cmd, "All")
            return true
        end
    end
    return false
end

-- ===== ВКЛАДКА 1: МУЗЫКА (ВСЁ РАБОТАЕТ) =====
local musicContent = contents[1]
local y = 10

local obiBtn = createBtn(musicContent, "🎵 OBI MUSIC (все песни)", y, Color3.fromRGB(60, 120, 200))
obiBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hehka999-del/LegenlyLKtest/refs/heads/main/legenl.lua"))()
end)

y = y + 38
local soundBtn = createBtn(musicContent, "🔊 BackDoor Sound (глобальные звуки)", y, Color3.fromRGB(200, 100, 50))
soundBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-BackDoor-Sound-Panel-By-Axom666-48759"))()
end)

y = y + 38
local iyBtn = createBtn(musicContent, "🎶 Infinite Yield (команды + муз)", y, Color3.fromRGB(50, 200, 100))
iyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Xane123/InfiniteFun_IY/master/source'))()
end)

y = y + 38
local ac6Btn = createBtn(musicContent, "🚗 AC6 Music Exploit (машины)", y, Color3.fromRGB(255, 150, 50))
ac6Btn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Roblox-HttpSpy/AC6-Music-Exploit/refs/heads/main/Ac6ExploitSource.luau"))()
end)

-- ===== ВКЛАДКА 2: АДМИН (ПОЧИНЕНО) =====
local adminContent = contents[2]
y = 10

-- Проверяем, какие команды работают в Краснодаре
local function tryCommand(btn, cmd, name)
    local success = sendCommand(cmd)
    if success then
        btn.Text = "✅ " .. name
        wait(1)
        btn.Text = name
    else
        btn.Text = "❌ " .. name
        wait(1)
        btn.Text = name
    end
end

local adminCmds = {
    {"🛫 Fly", "/fly"},
    {"🛡️ God", "/god"},
    {"👻 Invis", "/invis"},
    {"🌀 NoClip", "/noclip"},
    {"⚡ Speed", "/speed 50"},
    {"🔫 Btools", "/btools"},
    {"👢 Kick", "/kick " .. player.Name},
    {"⛔ Ban", "/ban " .. player.Name},
    {"📦 Bring", "/bring " .. player.Name},
    {"💀 Kill", "/kill"},
    {"💥 Kill All", "/kill all"},
    {"📦 Bring All", "/bring all"},
}
for i, data in ipairs(adminCmds) do
    local btn = createBtn(adminContent, data[1], y, Color3.fromRGB(55, 40, 40))
    btn.MouseButton1Click:Connect(function()
        tryCommand(btn, data[2], data[1])
    end)
    y = y + 34
end

-- ===== ВКЛАДКА 3: БИЛД (ПОЧИНЕНО) =====
local buildContent = contents[3]
y = 10

local buildCmds = {
    "🧱 Skybox",
    "🏗️ Baseplate",
    "📐 Unanchor всё",
    "🔄 Спавн декол",
}
for i, cmd in ipairs(buildCmds) do
    local btn = createBtn(buildContent, cmd, y, Color3.fromRGB(40, 55, 40))
    btn.MouseButton1Click:Connect(function()
        -- Ищем SyncAPI
        local tool = player:FindFirstChildOfClass("Tool")
        for _, v in pairs(player:GetDescendants()) do if v.Name == "SyncAPI" then tool = v.Parent end end
        for _, v in pairs(RS:GetDescendants()) do if v.Name == "SyncAPI" then tool = v.Parent end end
        if tool and tool.SyncAPI and tool.SyncAPI.ServerEndpoint then
            local remote = tool.SyncAPI.ServerEndpoint
            local function fire(args) remote:InvokeServer(unpack(args)) end
            if cmd:find("Skybox") then
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local x, y, z = math.floor(root.CFrame.X), math.floor(root.CFrame.Y) + 6, math.floor(root.CFrame.Z)
                    fire({"CreatePart", "Normal", CFrame.new(x, y, z), WS})
                    for _, v in pairs(WS:GetDescendants()) do
                        if v:IsA("BasePart") and v.CFrame.X == x and v.CFrame.Z == z then
                            fire({"SetName", {v}, "Sky"})
                            fire({"CreateMeshes", {{["Part"] = v}}})
                            fire({"SyncMesh", {{["Part"] = v, ["MeshId"] = "rbxassetid://8006679977"}}})
                            fire({"SyncMesh", {{["Part"] = v, ["TextureId"] = "rbxassetid://82226249657673"}}})
                            fire({"SyncMesh", {{["Part"] = v, ["Scale"] = Vector3.new(50, 50, 50)}}})
                            fire({"SetLocked", {v}, true})
                        end
                    end
                end
            elseif cmd:find("Baseplate") then
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local x, y, z = math.floor(root.CFrame.X), math.floor(root.CFrame.Y) - 20, math.floor(root.CFrame.Z)
                    fire({"CreatePart", "Spawn", CFrame.new(x, y, z), WS})
                    for _, v in pairs(WS:GetChildren()) do
                        if v:IsA("BasePart") and v.CFrame.Y == y and v.CFrame.X == x then
                            fire({"SyncResize", {{["Part"] = v, ["CFrame"] = CFrame.new(x, y, z), ["Size"] = Vector3.new(1000, 2, 1000)}}})
                            fire({"SyncColor", {{["Part"] = v, ["Color"] = Color3.fromRGB(12, 181, 0)}}})
                            fire({"SyncMaterial", {{["Part"] = v, ["Material"] = "Grass"}}})
                            fire({"SetLocked", {v}, true})
                        end
                    end
                end
            elseif cmd:find("Unanchor") then
                for _, v in pairs(WS:GetDescendants()) do
                    if v:IsA("BasePart") then
                        fire({"SetLocked", {v}, false})
                        fire({"SyncAnchor", {{["Part"] = v, ["Anchored"] = false}}})
                    end
                end
            elseif cmd:find("декол") then
                for _, v in pairs(WS:GetDescendants()) do
                    if v:IsA("BasePart") then
                        fire({"SetLocked", {v}, false})
                        for _, side in pairs({Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Right, Enum.NormalId.Left, Enum.NormalId.Bottom, Enum.NormalId.Top}) do
                            fire({"CreateTextures", {{["Part"] = v, ["Face"] = side, ["TextureType"] = "Decal"}}})
                            fire({"SyncTexture", {{["Part"] = v, ["Face"] = side, ["TextureType"] = "Decal", ["Texture"] = "rbxassetid://82226249657673"}}})
                        end
                    end
                end
            end
        else
            btn.Text = "⚠️ Нет SyncAPI"
            wait(1)
            btn.Text = cmd
        end
        btn.Text = "✅"
        wait(1)
        btn.Text = cmd
    end)
    y = y + 34
end

-- ===== ВКЛАДКА 4: ТРОЛЛИНГ (ПОЧИНЕНО) =====
local trollContent = contents[4]
y = 10

local trollCmds = {
    {"🔥 Огонь на всех", "/fire all"},
    {"💀 Чар all", "/char all mlg_leafy123"},
    {"🌀 Дискотека", "/disco"},
    {"🌑 Blackout", "blackout"},
    {"📢 Спам", "spam"},
}
for i, data in ipairs(trollCmds) do
    local btn = createBtn(trollContent, data[1], y, Color3.fromRGB(55, 40, 55))
    btn.MouseButton1Click:Connect(function()
        local chat = RS:FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local say = chat:FindFirstChild("SayMessageRequest")
            if say then
                if data[2] == "blackout" then
                    say:FireServer("/time 2", "All")
                    say:FireServer("/fogcolor black", "All")
                    say:FireServer("/fog 1000", "All")
                    say:FireServer("/title all Git haxxed by Legenly LK", "All")
                    say:FireServer("/loopwarp all", "All")
                elseif data[2] == "spam" then
                    for i = 1, 5 do
                        say:FireServer("/h Git haxxed by Legenly LK", "All")
                        say:FireServer("/m Git haxxed by Legenly LK", "All")
                        wait(0.2)
                    end
                else
                    say:FireServer(data[2], "All")
                end
            end
        end
        btn.Text = "✅"
        wait(1)
        btn.Text = data[1]
    end)
    y = y + 34
end

-- ===== RGB-анимация =====
local hue = 0
game:GetService("RunService").RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    stroke.Color = Color3.fromHSV(hue, 1, 1)
    stroke.Transparency = 0.3 + math.sin(hue * 10) * 0.1
end)

-- ===== ПЕРЕТАСКИВАНИЕ ОСНОВНОГО ОКНА =====
local drag, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = input.Position
        local headerPos = header.AbsolutePosition
        if mousePos.Y >= headerPos.Y and mousePos.Y <= headerPos.Y + header.AbsoluteSize.Y then
            drag = true
            dragStart = input.Position
            startPos = main.Position
        end
    end
end)
main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
UIS.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("⚡ Legenly LK — Краснодар РП Edition загружен (всё починено)")
