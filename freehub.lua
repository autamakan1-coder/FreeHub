--// FREEHUB STYLE - MOBILE
--// Original implementation, no premium bypass

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- CLEAN OLD UI
--==================================================

pcall(function()
    game.CoreGui:FindFirstChild("FreeHubStyle"):Destroy()
end)

--==================================================
-- VARIABLES
--==================================================

local SpeedEnabled = false
local JumpEnabled = false
local InfiniteJump = false
local Noclip = false
local ESPEnabled = false
local NameESP = false
local DistanceESP = false
local Fullbright = false
local AntiAFK = false

local SpeedValue = 16
local JumpValue = 50

local Connections = {}
local ESPObjects = {}

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "FreeHubStyle"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 530, 0, 360)
Main.Position = UDim2.new(0.5, -265, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,10)
Corner.Parent = Main

--==================================================
-- DRAG
--==================================================

local dragging = false
local dragStart
local startPos

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and
    (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,50)
Header.BackgroundColor3 = Color3.fromRGB(25,25,30)
Header.BorderSizePixel = 0
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-70,1,0)
Title.Position = UDim2.new(0,18,0,0)
Title.BackgroundTransparency = 1
Title.Text = "FREEHUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0,100,1,0)
Version.Position = UDim2.new(0,120,0,0)
Version.BackgroundTransparency = 1
Version.Text = "v1.0"
Version.TextColor3 = Color3.fromRGB(120,120,130)
Version.Font = Enum.Font.Gotham
Version.TextSize = 12
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,40,0,40)
Close.Position = UDim2.new(1,-45,0,5)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255,90,90)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 28
Close.Parent = Header

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,125,1,-50)
Sidebar.Position = UDim2.new(0,0,0,50)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,27)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0,5)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0,10)
SidePadding.Parent = Sidebar

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-125,1,-50)
Content.Position = UDim2.new(0,125,0,50)
Content.BackgroundColor3 = Color3.fromRGB(18,18,22)
Content.BorderSizePixel = 0
Content.Parent = Main

local Pages = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1,-20,1,-20)
    Page.Position = UDim2.new(0,10,0,10)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0,0,0,0)
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,7)
    Layout.Parent = Page

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(
            0,0,
            0,
            Layout.AbsoluteContentSize.Y + 15
        )
    end)

    Pages[name] = Page
    return Page
end

local HomePage = CreatePage("Home")
local PlayerPage = CreatePage("Player")
local VisualPage = CreatePage("Visual")
local UtilityPage = CreatePage("Utility")
local SettingsPage = CreatePage("Settings")

--==================================================
-- ELEMENT FUNCTIONS
--==================================================

local function Section(parent,text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-5,0,30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(130,130,140)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent
    return Label
end

local function Button(parent,text,callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,-5,0,38)
    B.BackgroundColor3 = Color3.fromRGB(29,29,35)
    B.BorderSizePixel = 0
    B.Text = text
    B.TextColor3 = Color3.fromRGB(235,235,240)
    B.Font = Enum.Font.Gotham
    B.TextSize = 13
    B.Parent = parent

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,6)
    C.Parent = B

    B.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    return B
end

local function Toggle(parent,text,default,callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,-5,0,42)
    B.BackgroundColor3 = Color3.fromRGB(29,29,35)
    B.BorderSizePixel = 0
    B.Text = ""
    B.Parent = parent

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,6)
    C.Parent = B

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1,-70,1,0)
    L.Position = UDim2.new(0,12,0,0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(235,235,240)
    L.Font = Enum.Font.Gotham
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = B

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0,42,0,22)
    Switch.Position = UDim2.new(1,-52,0.5,-11)
    Switch.BackgroundColor3 = Color3.fromRGB(55,55,62)
    Switch.Parent = B

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(1,0)
    SC.Parent = Switch

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0,18,0,18)
    Circle.Position = UDim2.new(0,2,0.5,-9)
    Circle.BackgroundColor3 = Color3.fromRGB(220,220,225)
    Circle.Parent = Switch

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(1,0)
    CC.Parent = Circle

    local state = default or false

    local function Update()
        if state then
            Switch.BackgroundColor3 = Color3.fromRGB(80,130,255)
            Circle.Position = UDim2.new(1,-20,0.5,-9)
        else
            Switch.BackgroundColor3 = Color3.fromRGB(55,55,62)
            Circle.Position = UDim2.new(0,2,0.5,-9)
        end
    end

    B.MouseButton1Click:Connect(function()
        state = not state
        Update()
        pcall(callback,state)
    end)

    Update()

    return B
end

--==================================================
-- HOME
--==================================================

Section(HomePage,"HOME")

Button(HomePage,"⚡  Welcome to FreeHub",function()
end)

Button(HomePage,"🔄  Rejoin Server",function()
    TeleportService:TeleportToPlaceInstance(
        game.PlaceId,
        game.JobId,
        LP
    )
end)

Button(HomePage,"🔁  Re-execute UI",function()
    Gui.Enabled = false
    task.wait(.2)
    Gui.Enabled = true
end)

Section(HomePage,"STATUS")

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1,-5,0,90)
Info.BackgroundColor3 = Color3.fromRGB(29,29,35)
Info.TextColor3 = Color3.fromRGB(190,190,200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 12
Info.TextWrapped = true
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Text = "  Player: "..LP.Name..
    "\n  Place ID: "..game.PlaceId..
    "\n  Players: "..#Players:GetPlayers()..
    "\n  FreeHub Mobile"
Info.Parent = HomePage

local IC = Instance.new("UICorner")
IC.CornerRadius = UDim.new(0,6)
IC.Parent = Info

--==================================================
-- PLAYER
--==================================================

Section(PlayerPage,"PLAYER")

Toggle(PlayerPage,"⚡ Speed",false,function(v)
    SpeedEnabled = v

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.WalkSpeed = v and SpeedValue or 16
    end
end)

Button(PlayerPage,"🏃 Speed +5",function()
    SpeedValue = math.clamp(SpeedValue + 5,16,100)

    if SpeedEnabled and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = SpeedValue
        end
    end
end)

Button(PlayerPage,"🏃 Speed Reset",function()
    SpeedValue = 16

    if LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
        end
    end
end)

Toggle(PlayerPage,"🦘 Jump Power",false,function(v)
    JumpEnabled = v

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = v and JumpValue or 50
    end
end)

Button(PlayerPage,"🦘 Jump +10",function()
    JumpValue = math.clamp(JumpValue + 10,50,150)

    if JumpEnabled and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = JumpValue
        end
    end
end)

Toggle(PlayerPage,"♾️ Infinite Jump",false,function(v)
    InfiniteJump = v
end)

UIS.JumpRequest:Connect(function()
    if InfiniteJump then
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Toggle(PlayerPage,"👻 Noclip",false,function(v)
    Noclip = v
end)

RunService.Stepped:Connect(function()
    if Noclip and LP.Character then
        for _,obj in ipairs(LP.Character:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CanCollide = false
            end
        end
    end
end)

Button(PlayerPage,"💀 Reset Character",function()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.Health = 0
    end
end)

--==================================================
-- ESP
--==================================================

Section(VisualPage,"PLAYER ESP")

local function RemoveESP(player)
    if ESPObjects[player] then
        pcall(function()
            ESPObjects[player]:Destroy()
        end)

        ESPObjects[player] = nil
    end
end

local function CreateESP(player)
    if player == LP then return end
    if not ESPEnabled then return end

    local char = player.Character
    if not char then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    RemoveESP(player)

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "FreeHubESP"
    Billboard.Size = UDim2.new(0,200,0,50)
    Billboard.StudsOffset = Vector3.new(0,3,0)
    Billboard.AlwaysOnTop = true
    Billboard.Adornee = head
    Billboard.Parent = head

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1,0,1,0)
    Text.BackgroundTransparency = 1
    Text.TextColor3 = Color3.fromRGB(255,255,255)
    Text.TextStrokeTransparency = 0
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 12
    Text.Parent = Billboard

    local function Update()
        if not player.Character then return end

        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local distance = math.floor(
            (Camera.CFrame.Position - root.Position).Magnitude
        )

        local text = ""

        if NameESP then
            text = player.DisplayName
        end

        if DistanceESP then
            if text ~= "" then
                text = text.." ["..distance.."m]"
            else
                text = "["..distance.."m]"
            end
        end

        Text.Text = text
    end

    ESPObjects[player] = Billboard

    local con
    con = RunService.RenderStepped:Connect(function()
        if not ESPEnabled or not Billboard.Parent then
            con:Disconnect()
            return
        end

        Update()
    end)
end

Toggle(VisualPage,"👁️ ESP",false,function(v)
    ESPEnabled = v

    if not v then
        for player in pairs(ESPObjects) do
            RemoveESP(player)
        end
    else
        for _,player in ipairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    end
end)

Toggle(VisualPage,"🏷️ Player Name",false,function(v)
    NameESP = v

    if ESPEnabled then
        for _,player in ipairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    end
end)

Toggle(VisualPage,"📏 Distance",false,function(v)
    DistanceESP = v

    if ESPEnabled then
        for _,player in ipairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)

        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

--==================================================
-- VISUAL
--==================================================

Section(UtilityPage,"UTILITY")

Toggle(UtilityPage,"☀️ Fullbright",false,function(v)
    Fullbright = v

    if v then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").GlobalShadows = true
    end
end)

Toggle(UtilityPage,"💤 Anti AFK",false,function(v)
    AntiAFK = v

    if v then
        local VirtualUser = game:GetService("VirtualUser")

        Connections.AFK = LP.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    elseif Connections.AFK then
        Connections.AFK:Disconnect()
        Connections.AFK = nil
    end
end)

Button(UtilityPage,"📋 Copy Job ID",function()
    if setclipboard then
        setclipboard(game.JobId)
    end
end)

Button(UtilityPage,"📋 Copy Place ID",function()
    if setclipboard then
        setclipboard(tostring(game.PlaceId))
    end
end)

--==================================================
-- SETTINGS
--==================================================

Section(SettingsPage,"SETTINGS")

Toggle(SettingsPage,"📱 Mobile UI",true,function(v)
    Main.Visible = v
end)

Button(SettingsPage,"🔄 Reset UI Position",function()
    Main.Position = UDim2.new(0.5,-265,0.5,-180)
end)

Button(SettingsPage,"❌ Close Hub",function()
    Gui:Destroy()
end)

--==================================================
-- SIDEBAR BUTTONS
--==================================================

local function AddTab(name,icon,page)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1,-15,0,40)
    B.BackgroundColor3 = Color3.fromRGB(22,22,27)
    B.BorderSizePixel = 0
    B.Text = icon.."  "..name
    B.TextColor3 = Color3.fromRGB(190,190,200)
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 12
    B.Parent = Sidebar

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,6)
    C.Parent = B

    B.MouseButton1Click:Connect(function()

        for _,p in pairs(Pages) do
            p.Visible = false
        end

        page.Visible = true

        for _,obj in ipairs(Sidebar:GetChildren()) do
            if obj:IsA("TextButton") then
                obj.BackgroundColor3 = Color3.fromRGB(22,22,27)
                obj.TextColor3 = Color3.fromRGB(190,190,200)
            end
        end

        B.BackgroundColor3 = Color3.fromRGB(65,95,180)
        B.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    return B
end

local HomeButton = AddTab("Home","⌂",HomePage)
AddTab("Player","●",PlayerPage)
AddTab("Visual","◉",VisualPage)
AddTab("Utility","⚙",UtilityPage)
AddTab("Settings","☰",SettingsPage)

HomePage.Visible = true
HomeButton.BackgroundColor3 = Color3.fromRGB(65,95,180)
HomeButton.TextColor3 = Color3.fromRGB(255,255,255)

--==================================================
-- FLOATING OPEN BUTTON
--==================================================

local Open = Instance.new("TextButton")
Open.Size = UDim2.new(0,55,0,55)
Open.Position = UDim2.new(0,15,0.5,-25)
Open.BackgroundColor3 = Color3.fromRGB(65,95,180)
Open.Text = "FH"
Open.TextColor3 = Color3.fromRGB(255,255,255)
Open.Font = Enum.Font.GothamBold
Open.TextSize = 16
Open.Visible = false
Open.Parent = Gui

local OC = Instance.new("UICorner")
OC.CornerRadius = UDim.new(1,0)
OC.Parent = Open

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Open.Visible = true
end)

Open.MouseButton1Click:Connect(function()
    Main.Visible = true
    Open.Visible = false
end)

print("[FreeHub] Loaded successfully")
