--[[
    Legenly LK Ultimate v2.0
    Собрано из: D.F.E 2 F3X, OBI MUSIC, BackDoor Sound, Infinite Yield
    Категории: Музыка (глобальная/локальная) | Админ-команды | Билд-инструменты | Троллинг
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local player = Players.LocalPlayer

if _G.LegenlyLK_Loaded then return end
_G.LegenlyLK_Loaded = true

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "LegenlyLK_Ultimate"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 550)
main.Position = UDim2.new(0.5, -200, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2
stroke.Transparency = 0.5

-- Заголовок
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.04, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Legenly LK Ultimate"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 4)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ===== ВКЛАДКИ =====
local tabs = {"🎵 Музыка", "⚡ Админ", "🛠 Билд", "🔥 Тролль"}
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
    btn.Parent = header
    tabBtns[i] = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, -36)
    content.Position = UDim2.new(0, 0, 0, 36)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 600)
    content.ScrollBarThickness = 4
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
    btn.Size = UDim2.new(0.9, 0, 0, 32)
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
    box.Size = UDim2.new(0.6, 0, 0, 32)
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

-- ===== ВКЛАДКА 1: МУЗЫКА =====
local musicContent = contents[1]
local y = 10

createBtn(musicContent, "🎵 OBI MUSIC PLAYER (все песни)", y, Color3.fromRGB(60, 120, 200))
local obiBtn = createBtn(musicContent, "▶ ЗАПУСТИТЬ OBI", y + 38, Color3.fromRGB(40, 40, 55))
obiBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hehka999-del/LegenlyLKtest/refs/heads/main/legenl.lua"))()
end)

y = y + 80
createBtn(musicContent, "🔊 BackDoor Sound Panel (глобальные звуки)", y, Color3.fromRGB(200, 100, 50))
local soundBtn = createBtn(musicContent, "▶ ЗАПУСТИТЬ SOUND PANEL", y + 38, Color3.fromRGB(40, 40, 55))
soundBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-BackDoor-Sound-Panel-By-Axom666-48759"))()
end)

y = y + 80
createBtn(musicContent, "🎶 Infinite Yield (музыка + команды)", y, Color3.fromRGB(50, 200, 100))
local iyBtn = createBtn(musicContent, "▶ ЗАПУСТИТЬ INFINITE YIELD", y + 38, Color3.fromRGB(40, 40, 55))
iyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Xane123/InfiniteFun_IY/master/source'))()
end)

-- ===== ВКЛАДКА 2: АДМИН =====
local adminContent = contents[2]
y = 10

local adminCmds = {
    "🛫 Fly",
    "🛡️ God",
    "👻 Invis",
    "🌀 NoClip",
    "⚡ Speed 50",
    "🔫 Btools",
    "👢 Kick",
    "⛔ Ban",
    "📦 Bring",
    "💀 Kill",
    "💥 Kill All",
    "📦 Bring All",
}
for i, cmd in ipairs(adminCmds) do
    local btn = createBtn(adminContent, cmd, y, Color3.fromRGB(55, 40, 40))
    btn.MouseButton1Click:Connect(function()
        local chat = RS:FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local say = chat:FindFirstChild("SayMessageRequest")
            if say then
                local cmdName = cmd:match("%s(.+)$") or cmd:match("^[^%s]+")
                if cmdName == "Fly" then say:FireServer("/fly", "All") end
                if cmdName == "God" then say:FireServer("/god", "All") end
                if cmdName == "Invis" then say:FireServer("/invis", "All") end
                if cmdName == "NoClip" then say:FireServer("/noclip", "All") end
                if cmdName == "Speed 50" then say:FireServer("/speed 50", "All") end
                if cmdName == "Btools" then say:FireServer("/btools", "All") end
                if cmdName == "Kick" then say:FireServer("/kick " .. player.Name, "All") end
                if cmdName == "Ban" then say:FireServer("/ban " .. player.Name, "All") end
                if cmdName == "Bring" then say:FireServer("/bring " .. player.Name, "All") end
                if cmdName == "Kill" then say:FireServer("/kill", "All") end
                if cmdName == "Kill All" then say:FireServer("/kill all", "All") end
                if cmdName == "Bring All" then say:FireServer("/bring all", "All") end
            end
        end
        btn.Text = "✅"
        wait(1)
        btn.Text = cmd
    end)
    y = y + 38
end

-- ===== ВКЛАДКА 3: БИЛД =====
local buildContent = contents[3]
y = 10

local buildCmds = {
    "🧱 Создать Skybox",
    "🏗️ Baseplate под ногами",
    "📐 Unanchor всё",
    "🔄 Спавн деколы",
}
for i, cmd in ipairs(buildCmds) do
    local btn = createBtn(buildContent, cmd, y, Color3.fromRGB(40, 55, 40))
    btn.MouseButton1Click:Connect(function()
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
                        if v:IsA("BasePart") and v.CFrame.X == x and v.CFrame.Z == z and v.Name == "" then
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
            elseif cmd:find("деколы") then
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
        end
        btn.Text = "✅"
        wait(1)
        btn.Text = cmd
    end)
    y = y + 38
end

-- ===== ВКЛАДКА 4: ТРОЛЛИНГ =====
local trollContent = contents[4]
y = 10

local trollCmds = {
    "🔥 Огонь на всех",
    "💀 Чар all",
    "🌀 Дискотека",
    "🌑 Blackout",
    "📢 Спам сообщений",
}
for i, cmd in ipairs(trollCmds) do
    local btn = createBtn(trollContent, cmd, y, Color3.fromRGB(55, 40, 55))
    btn.MouseButton1Click:Connect(function()
        local chat = RS:FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            local say = chat:FindFirstChild("SayMessageRequest")
            if say then
                if cmd:find("Огонь") then say:FireServer("/fire all", "All") end
                if cmd:find("Чар all") then say:FireServer("/char all mlg_leafy123", "All") end
                if cmd:find("Дискотека") then say:FireServer("/disco", "All") end
                if cmd:find("Blackout") then
                    say:FireServer("/time 2", "All")
                    say:FireServer("/fogcolor black", "All")
                    say:FireServer("/fog 1000", "All")
                    say:FireServer("/title all Git haxxed by Legenly LK", "All")
                    say:FireServer("/loopwarp all", "All")
                end
                if cmd:find("Спам") then
                    for i = 1, 5 do
                        say:FireServer("/h Git haxxed by Legenly LK", "All")
                        say:FireServer("/m Git haxxed by Legenly LK", "All")
                        wait(0.2)
                    end
                end
            end
        end
        btn.Text = "✅"
        wait(1)
        btn.Text = cmd
    end)
    y = y + 38
end

-- ===== RGB-анимация =====
local hue = 0
game:GetService("RunService").RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    stroke.Color = Color3.fromHSV(hue, 1, 1)
    stroke.Transparency = 0.3 + math.sin(hue * 10) * 0.1
end)

-- ===== ПЕРЕТАСКИВАНИЕ =====
local drag, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = input.Position
        startPos = main.Position
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

print("⚡ Legenly LK Ultimate v2.0 загружен!")
