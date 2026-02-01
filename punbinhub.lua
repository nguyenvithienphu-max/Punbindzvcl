-- PunBinHub Fly Script MOBILE (Universal - 2026 Working)
-- Touch buttons để di chuyển! Tương thích Arceus X, Delta, Codex Mobile, v.v.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local flying = false
local speed = 50
local connection = nil
local bv = nil
local bg = nil
local humanoid = nil
local rootpart = nil

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PunBinHubFlyMobile"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim2.new(0, 12, 0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✈️ PunBinHub Fly Mobile"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Toggle Fly Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 60)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.Text = "BẬT FLY"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim2.new(0, 8, 0, 8)
ToggleCorner.Parent = ToggleBtn

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 40)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 150)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = MainFrame

-- Speed Buttons
local SpeedUpBtn = Instance.new("TextButton")
SpeedUpBtn.Size = UDim2.new(0.42, 0, 0, 50)
SpeedUpBtn.Position = UDim2.new(0.05, 0, 0, 200)
SpeedUpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SpeedUpBtn.Text = "+"
SpeedUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUpBtn.TextScaled = true
SpeedUpBtn.Font = Enum.Font.GothamBold
SpeedUpBtn.Parent = MainFrame

local SpeedDownBtn = Instance.new("TextButton")
SpeedDownBtn.Size = UDim2.new(0.42, 0, 0, 50)
SpeedDownBtn.Position = UDim2.new(0.52, 0, 0, 200)
SpeedDownBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
SpeedDownBtn.Text = "-"
SpeedDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDownBtn.TextScaled = true
SpeedDownBtn.Font = Enum.Font.GothamBold
SpeedDownBtn.Parent = MainFrame

-- Movement Buttons Frame
local MoveFrame = Instance.new("Frame")
MoveFrame.Size = UDim2.new(0.9, 0, 0, 120)
MoveFrame.Position = UDim2.new(0.05, 0, 0, 270)
MoveFrame.BackgroundTransparency = 1
MoveFrame.Parent = MainFrame

-- Buttons: Forward, Back, Left, Right, Up, Down
local buttons = {
    {name="Forward", pos=UDim2.new(0.25, 0, 0, 0), color=Color3.fromRGB(0, 162, 255), text="↑"},
    {name="Left", pos=UDim2.new(0, 0, 0.5, 0), color=Color3.fromRGB(100, 100, 255), text="←"},
    {name="Right", pos=UDim2.new(0.5, 0, 0.5, 0), color=Color3.fromRGB(100, 100, 255), text="→"},
    {name="Back", pos=UDim2.new(0.75, 0, 0, 0), color=Color3.fromRGB(0, 162, 255), text="↓"},
    {name="Up", pos=UDim2.new(0.85, 0, 0, 0), color=Color3.fromRGB(0, 255, 0), text="▲"},
    {name="Down", pos=UDim2.new(0.85, 0, 0.6, 0), color=Color3.fromRGB(255, 0, 0), text="▼"}
}

local pressed = {}

for i, btnData in pairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Name = btnData.name
    btn.Size = UDim2.new(0.25, -5, 0.45, -5)
    btn.Position = btnData.pos
    btn.BackgroundColor3 = btnData.color
    btn.Text = btnData.text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MoveFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim2.new(0, 6, 0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Down:Connect(function()
        pressed[btnData.name] = true
    end)
    
    btn.MouseButton1Up:Connect(function()
        pressed[btnData.name] = false
    end)
    
    btn.TouchTap:Connect(function() -- Mobile touch
        pressed[btnData.name] = not pressed[btnData.name] -- Toggle cho mobile nhanh
    end)
end

-- Draggable Frame
local dragging = false
local dragStart = nil
local startPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Functions
local function getCharacter()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") then
        humanoid = Player.Character.Humanoid
        rootpart = Player.Character.HumanoidRootPart
        return true
    end
    return false
end

local function startFly()
    if not getCharacter() then return end
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 9e4
    bg.Parent = rootpart
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0, 0.1, 0)
    bv.Parent = rootpart
    
    humanoid.PlatformStand = true
    
    connection = RunService.Heartbeat:Connect(function()
        if not flying or not rootpart.Parent then
            connection:Disconnect()
            return
        end
        
        local cam = workspace.CurrentCamera
        local vel = Vector3.new(0, 0, 0)
        
        if pressed.Forward then vel = vel + cam.CFrame.LookVector * speed end
        if pressed.Back then vel = vel - cam.CFrame.LookVector * speed end
        if pressed.Left then vel = vel - cam.CFrame.RightVector * speed end
        if pressed.Right then vel = vel + cam.CFrame.RightVector * speed end
        if pressed.Up then vel = vel + Vector3.new(0, speed, 0) end
        if pressed.Down then vel = vel - Vector3.new(0, speed, 0) end
        
        bv.Velocity = vel
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if connection then connection:Disconnect() end
    if humanoid then humanoid.PlatformStand = false end
end

-- Events
ToggleBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        ToggleBtn.Text = "TẮT FLY"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        startFly()
    else
        ToggleBtn.Text = "BẬT FLY"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        stopFly()
    end
end)

SpeedUpBtn.MouseButton1Click:Connect(function()
    speed = math.min(speed + 10, 200)
    SpeedLabel.Text = "Tốc độ: " .. speed
end)

SpeedDownBtn.MouseButton1Click:Connect(function()
    speed = math.max(speed - 10, 10)
    SpeedLabel.Text = "Tốc độ: " .. speed
end)

-- Handle respawn
Player.CharacterAdded:Connect(function()
    if flying then
        wait(1)
        startFly()
    end
end)

-- Auto corners for buttons
for _, btn in pairs({SpeedUpBtn, SpeedDownBtn}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim2.new(0, 8, 0, 8)
    corner.Parent = btn
end

print("PunBinHub Fly Mobile đã load! Touch BẬT FLY để bắt đầu ✈️")
