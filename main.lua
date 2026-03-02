local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- === НАСТРОЙКИ ===
local CORRECT_KEY = "CLOUDVN.HUB-364832" -- ТВОЙ КЛЮЧ
local SITE_URL = "https://cloudvn10.github.io/checkkeyy/"
local isVerified = false

-- === ПЕРЕМЕННЫЕ ФУНКЦИЙ ===
local distractEnabled = false
local airWalkEnabled = false
local followEnabled = false
local espEnabled = false
local espObjects = {}
local airHeight = 5
local distractHeight = 14
local distractIndex = 1
local followTarget = nil
local airPlatform = nil

local monsterList = {"AstroMonster", "BlottMonster", "BobetteMonster", "BoxtenMonster", "BrightneyMonster", "BrushaMonster", "CoalMonster", "ConnieMonster", "CosmoMonster", "DandyMonster", "DyleMonster", "EclipseMonster", "FinnMonster", "FlutterMonster", "GigiMonster", "GingerMonster", "GlistenMonster", "GoobMonster", "GourdyMonster", "LooeyMonster", "PebbleMonster", "PoppyMonster", "RazzleDazzleMonster", "RibeccaMonster", "RodgerMonster", "RudieMonster", "ScrapsMonster", "ShellyMonster", "ShrimpoMonster", "SoulvesterMonster", "SproutMonster", "SquirmMonster", "TeaganMonster", "TishaMonster", "ToodlesMonster", "VeeMonster", "YattaMonster"}
local isMonster = {}
for _, name in pairs(monsterList) do isMonster[name] = true end

-- === ЗАЩИТА И УТИЛИТЫ ===
local function getSafeParent()
    local success, target = pcall(function() return CoreGui end)
    if success and target then return target end
    return player:WaitForChild("PlayerGui")
end

local function safeSetClipboard(text)
    if setclipboard then setclipboard(text) end
end

-- === ИНТЕРФЕЙС ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Xeno_Ultra_Hub_Final"
ScreenGui.Parent = getSafeParent()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function createPrettyBtn(name, parent, pos, size, color)
    local b = Instance.new("TextButton")
    b.Name = name .. "_Btn"
    b.Parent = parent
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Position = pos
    b.Size = size
    b.Font = Enum.Font.GothamBold
    b.Text = name
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 16
    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 8)
    
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    return b
end

-- === ОКНО КЛЮЧА ===
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeyFrame.Size = UDim2.new(0, 350, 0, 250)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 15)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Thickness = 3
KeyStroke.Color = Color3.fromRGB(85, 0, 255)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "XENO SYSTEM | ACCESS"
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.TextSize = 20

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 45)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
KeyInput.PlaceholderText = "ENTER KEY..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KeyInput)

local CheckBtn = createPrettyBtn("ACTIVATE", KeyFrame, UDim2.new(0.1, 0, 0.6, 0), UDim2.new(0.8, 0, 0, 40), Color3.fromRGB(85, 0, 255))
local GetBtn = createPrettyBtn("GET KEY (COPY LINK)", KeyFrame, UDim2.new(0.1, 0, 0.8, 0), UDim2.new(0.8, 0, 0, 40), Color3.fromRGB(40, 40, 45))

-- === ГЛАВНОЕ МЕНЮ ===
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(85, 0, 255)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "XENO HUB ULTRA v2"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20

local DistractBtn = createPrettyBtn("ALL DISTRACT: OFF", MainFrame, UDim2.new(0.05, 0, 0, 50), UDim2.new(0.9, 0, 0, 45), Color3.fromRGB(85, 0, 255))
local AirWalkBtn = createPrettyBtn("AIR WALK: OFF", MainFrame, UDim2.new(0.05, 0, 0, 105), UDim2.new(0.9, 0, 0, 45), Color3.fromRGB(231, 76, 60))

local UpBtn = createPrettyBtn("+ HEIGHT", MainFrame, UDim2.new(0.05, 0, 0, 160), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(52, 152, 219))
local DownBtn = createPrettyBtn("- HEIGHT", MainFrame, UDim2.new(0.52, 0, 0, 160), UDim2.new(0.43, 0, 0, 35), Color3.fromRGB(149, 165, 166))

local NickBox = Instance.new("TextBox", MainFrame)
NickBox.Position = UDim2.new(0.05, 0, 0, 210)
NickBox.Size = UDim2.new(0.9, 0, 0, 40)
NickBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
NickBox.PlaceholderText = "Player Nickname..."
NickBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", NickBox)

local FollowBtn = createPrettyBtn("FOLLOW: OFF", MainFrame, UDim2.new(0.05, 0, 0, 260), UDim2.new(0.9, 0, 0, 45), Color3.fromRGB(150, 50, 50))
local EspBtn = createPrettyBtn("ESP MONSTERS: OFF", MainFrame, UDim2.new(0.05, 0, 0, 315), UDim2.new(0.9, 0, 0, 45), Color3.fromRGB(0, 150, 200))
local CloseBtn = createPrettyBtn("CLOSE UI", MainFrame, UDim2.new(0.05, 0, 0, 380), UDim2.new(0.9, 0, 0, 45), Color3.fromRGB(40, 40, 40))

-- === ЛОГИКА ФУНКЦИЙ ===

local function getActiveMonsters()
    local found = {}
    local cr = workspace:FindFirstChild("CurrentRoom")
    local folder = cr and cr:FindFirstChild("Monsters", true)
    if folder then
        for _, m in pairs(folder:GetChildren()) do
            if isMonster[m.Name] and m:FindFirstChild("HumanoidRootPart") then
                table.insert(found, m.HumanoidRootPart)
            end
        end
    end
    return found
end

local function createESP(part, name)
    if part:FindFirstChild("XenoESP") then return end
    local bgui = Instance.new("BillboardGui", part)
    bgui.Name = "XenoESP"; bgui.AlwaysOnTop = true; bgui.Size = UDim2.new(0, 100, 0, 50); bgui.ExtentsOffset = Vector3.new(0, 3, 0)
    local tl = Instance.new("TextLabel", bgui)
    tl.BackgroundTransparency = 1; tl.Size = UDim2.new(1, 0, 1, 0); tl.Text = "[ " .. name:upper() .. " ]"
    tl.Font = Enum.Font.GothamBold; tl.TextColor3 = Color3.new(1, 0.2, 0.2); tl.TextSize = 14
    table.insert(espObjects, bgui)
end

-- Основной цикл
RunService.Heartbeat:Connect(function()
    if not isVerified then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Исправленный AirWalk
    if airWalkEnabled and airPlatform then
        airPlatform.Position = Vector3.new(root.Position.X, airPlatform.Position.Y, root.Position.Z)
        if root.Position.Y < (airPlatform.Position.Y + 1) then
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
            root.CFrame = CFrame.new(root.Position.X, airPlatform.Position.Y + 3.5, root.Position.Z)
        end
    end

    -- Distract
    if distractEnabled then
        local targets = getActiveMonsters()
        if #targets > 0 then
            if distractIndex > #targets then distractIndex = 1 end
            local tRoot = targets[distractIndex]
            if tRoot and tRoot.Parent then
                root.CFrame = tRoot.CFrame * CFrame.new(0, distractHeight, 0)
                root.Velocity = Vector3.zero
                distractIndex = distractIndex + 1
            end
        end
    end

    -- Follow
    if followEnabled and followTarget and followTarget.Character then
        local tRoot = followTarget.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            root.CFrame = root.CFrame:Lerp(tRoot.CFrame * CFrame.new(0, 0, 3), 0.3)
            root.Velocity = Vector3.zero
        end
    end

    -- ESP
    if espEnabled then
        for _, mRoot in pairs(getActiveMonsters()) do createESP(mRoot, mRoot.Parent.Name) end
    end
end)

-- === ОБРАБОТКА КНОПОК ===
CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        isVerified = true
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        KeyInput.Text = "INVALID KEY!"
        task.wait(1)
        KeyInput.Text = ""
    end
end)

GetBtn.MouseButton1Click:Connect(function()
    safeSetClipboard(SITE_URL)
    GetBtn.Text = "LINK COPIED!"
    task.wait(1)
    GetBtn.Text = "GET KEY (COPY LINK)"
end)

AirWalkBtn.MouseButton1Click:Connect(function()
    airWalkEnabled = not airWalkEnabled
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if airWalkEnabled and root then
        AirWalkBtn.Text = "AIR WALK: ON"
        AirWalkBtn.BackgroundColor3 = Color3.new(0, 0.7, 0)
        airPlatform = Instance.new("Part", workspace)
        airPlatform.Size = Vector3.new(20, 1, 20)
        airPlatform.Transparency = 0.7
        airPlatform.Anchored = true
        airPlatform.CanCollide = true -- ТВЕРДАЯ ПЛАТФОРМА
        airPlatform.Position = root.Position + Vector3.new(0, -3.5, 0)
    else
        AirWalkBtn.Text = "AIR WALK: OFF"
        AirWalkBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        if airPlatform then airPlatform:Destroy() airPlatform = nil end
    end
end)

DistractBtn.MouseButton1Click:Connect(function()
    distractEnabled = not distractEnabled
    DistractBtn.Text = distractEnabled and "DISTRACTING..." or "ALL DISTRACT: OFF"
    DistractBtn.BackgroundColor3 = distractEnabled and Color3.new(0, 0.7, 0) or Color3.fromRGB(85, 0, 255)
end)

UpBtn.MouseButton1Click:Connect(function()
    if airPlatform then airPlatform.Position = airPlatform.Position + Vector3.new(0, 2, 0) end
end)

DownBtn.MouseButton1Click:Connect(function()
    if airPlatform then airPlatform.Position = airPlatform.Position - Vector3.new(0, 2, 0) end
end)

EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ON" or "ESP MONSTERS: OFF"
    if not espEnabled then
        for _, o in pairs(espObjects) do if o then o:Destroy() end end
        espObjects = {}
    end
end)

FollowBtn.MouseButton1Click:Connect(function()
    followEnabled = not followEnabled
    if followEnabled then
        local n = NickBox.Text:lower()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and (p.Name:lower():find(n) or p.DisplayName:lower():find(n)) then
                followTarget = p; break
            end
        end
        if followTarget then FollowBtn.Text = "FOLLOWING: "..followTarget.DisplayName 
        else followEnabled = false end
    else
        FollowBtn.Text = "FOLLOW: OFF"; followTarget = nil
    end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightControl and isVerified then 
        MainFrame.Visible = not MainFrame.Visible 
    end
end)

print("XENO HUB v2 LOADED | KEY: "..CORRECT_KEY)
