-- FREE HUB - Roblox game milik sendiri
-- Semua fitur di script ini dibuat dari nol.
-- LocalScript / loadstring-compatible source.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer

local Config = {
    SpeedEnabled = false,
    WalkSpeed = 16,
    InfiniteJump = false,
}

local function humanoid()
    local character = Player.Character or Player.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid")
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "FreeHub"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(430, 330)
Main.Position = UDim2.new(0.5, -215, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -55, 0, 45)
Title.Position = UDim2.fromOffset(15, 5)
Title.BackgroundTransparency = 1
Title.Text = "FREE HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35, 35)
Close.Position = UDim2.new(1, -42, 0, 8)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 28
Close.Font = Enum.Font.GothamBold
Close.Parent = Main

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Drag support
local dragging = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -30, 1, -60)
Content.Position = UDim2.fromOffset(15, 52)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.CanvasSize = UDim2.new()
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Content

local function button(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 42)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 15
    b.Font = Enum.Font.GothamMedium
    b.Parent = Content

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    b.MouseButton1Click:Connect(callback)
    return b
end

local speedButton = button("Speed: OFF", function()
    Config.SpeedEnabled = not Config.SpeedEnabled

    if Config.SpeedEnabled then
        humanoid().WalkSpeed = Config.WalkSpeed
        speedButton.Text = "Speed: ON"
    else
        humanoid().WalkSpeed = 16
        speedButton.Text = "Speed: OFF"
    end
end)

button("Set Jump Power: 50", function()
    humanoid().UseJumpPower = true
    humanoid().JumpPower = 50
end)

local jumpButton = button("Infinite Jump: OFF", function()
    Config.InfiniteJump = not Config.InfiniteJump
    jumpButton.Text = "Infinite Jump: " .. (Config.InfiniteJump and "ON" or "OFF")
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        humanoid():ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

button("Reset Character", function()
    humanoid().Health = 0
end)

button("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, Player)
end)

local fpsButton = button("FPS: ...", function() end)
local frames = 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
    frames += 1
    local now = os.clock()
    if now - last >= 1 then
        fpsButton.Text = "FPS: " .. frames
        frames = 0
        last = now
    end
end)

Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.SpeedEnabled then
        humanoid().WalkSpeed = Config.WalkSpeed
    end
end)

task.defer(function()
    task.wait()
    Content.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 10)
end)

local Open = Instance.new("TextButton")
Open.Size = UDim2.fromOffset(55, 55)
Open.Position = UDim2.new(0, 15, 0.5, -27)
Open.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Open.Text = "☰"
Open.TextColor3 = Color3.new(1, 1, 1)
Open.TextSize = 24
Open.Font = Enum.Font.GothamBold
Open.Parent = Gui

Instance.new("UICorner", Open).CornerRadius = UDim.new(1, 0)

Open.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
