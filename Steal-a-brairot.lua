--- ⚡ Safe Executor Check (Delta X)
local executor = identifyexecutor and identifyexecutor() or "Unknown"

-- Đưa về chữ thường để so dễ
local execLower = string.lower(executor)

if not string.find(execLower, "delta") then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Zynex Hub";
        Text = "You cannot use other clients!\nPlease use Delta X to play.";
        Duration = 8;
    })
    -- Xoá UI nếu có
    if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") then
        for _, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
            if v:IsA("ScreenGui") and v.Name == "ZynexHubUI" then
                v:Destroy()
            end
        end
    end
    return
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Zynex Hub";
        Text = "Support all games!";
        Duration = 8;
    })
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ZynexHubUI"
gui.Parent = lp:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Menu tròn (nút mở/ẩn UI)
local menuButton = Instance.new("ImageButton")
menuButton.Size = UDim2.new(0, 60, 0, 60) -- menu tròn 100x100
menuButton.Position = UDim2.new(0.05, 0, 0.2, 0) -- góc trái màn hình
menuButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menuButton.BackgroundTransparency = 0.2
menuButton.Image = "rbxassetid://118829242265386"
menuButton.Parent = gui
menuButton.Active = true
menuButton.Draggable = true

-- Bo góc tròn
local menuCorner = Instance.new("UICorner", menuButton)
menuCorner.CornerRadius = UDim.new(1, 0)

-- Viền xanh
local menuStroke = Instance.new("UIStroke", menuButton)
menuStroke.Thickness = 3
menuStroke.Color = Color3.fromRGB(0, 255, 0)

-- Khung chính (UI Upwall/Float)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0.5, -130, 0.6, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Toggle ẩn/hiện UI bằng menu tròn
menuButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(0, 255, 0)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Zynex Hub"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Parent = frame

-- Status chung một hàng
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 45)
status.BackgroundTransparency = 1
status.Text = "Upwall: OFF   |   Float: OFF"
status.Font = Enum.Font.SourceSans
status.TextSize = 16
status.TextColor3 = Color3.fromRGB(0, 200, 0)
status.Parent = frame

-- Button Upwall
local btnUpwall = Instance.new("TextButton")
btnUpwall.Size = UDim2.new(0.9, 0, 0, 40)
btnUpwall.Position = UDim2.new(0.05, 0, 0.45, 0)
btnUpwall.Text = "Upwall"
btnUpwall.Font = Enum.Font.SourceSansBold
btnUpwall.TextSize = 22
btnUpwall.TextColor3 = Color3.fromRGB(255, 255, 255) -- chữ trắng dễ đọc
btnUpwall.BackgroundTransparency = 0.2
btnUpwall.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- nền tối
btnUpwall.Parent = frame

local btnUpwallCorner = Instance.new("UICorner", btnUpwall)
btnUpwallCorner.CornerRadius = UDim.new(0, 8)

local btnUpwallStroke = Instance.new("UIStroke", btnUpwall)
btnUpwallStroke.Thickness = 2
btnUpwallStroke.Color = Color3.fromRGB(0, 255, 0) -- viền xanh lá

-- Button Float
local btnFloat = Instance.new("TextButton")
btnFloat.Size = UDim2.new(0.9, 0, 0, 40)
btnFloat.Position = UDim2.new(0.05, 0, 0.7, 0)
btnFloat.Text = "Float"
btnFloat.Font = Enum.Font.SourceSansBold
btnFloat.TextSize = 22
btnFloat.TextColor3 = Color3.fromRGB(255, 255, 255) -- chữ trắng dễ đọc
btnFloat.BackgroundTransparency = 0.2
btnFloat.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- nền tối
btnFloat.Parent = frame

local btnFloatCorner = Instance.new("UICorner", btnFloat)
btnFloatCorner.CornerRadius = UDim.new(0, 8)

local btnFloatStroke = Instance.new("UIStroke", btnFloat)
btnFloatStroke.Thickness = 2
btnFloatStroke.Color = Color3.fromRGB(0, 255, 0) -- viền xanh lá

-- STATE
local upwallActive = false
local floatActive = false
local carpetUpwall, carpetFloat
local connUpwall, connFloat

-- Cập nhật status chung
local function updateStatus()
    status.Text = "Upwall: " .. (upwallActive and "ON" or "OFF") ..
                  "   |   Float: " .. (floatActive and "ON" or "OFF")
end

-- Toggle Upwall (bay theo người)
local function toggleUpwall()
    if upwallActive then
        upwallActive = false
        if connUpwall then connUpwall:Disconnect() end
        if carpetUpwall then carpetUpwall:Destroy() end
    else
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        carpetUpwall = Instance.new("Part")
        carpetUpwall.Anchored = true
        carpetUpwall.CanCollide = true
        carpetUpwall.Size = Vector3.new(10,1,10)
        carpetUpwall.Material = Enum.Material.Neon
        carpetUpwall.Color = Color3.fromRGB(0,255,0)
        carpetUpwall.CFrame = hrp.CFrame * CFrame.new(0,-3,0)
        carpetUpwall.Parent = workspace

        upwallActive = true
        connUpwall = RunService.Heartbeat:Connect(function()
            if not upwallActive or not carpetUpwall then return end
            if not hrp or not hrp.Parent then return end
            carpetUpwall.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y-3, hrp.Position.Z)
        end)
    end
    updateStatus()
end
btnUpwall.MouseButton1Click:Connect(toggleUpwall)

-- Toggle Float (thảm xanh lá đi theo người, không nâng lên)
local function toggleFloat()
    if floatActive then
        floatActive = false
        if connFloat then connFloat:Disconnect() end
        if carpetFloat then carpetFloat:Destroy() end
    else
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        carpetFloat = Instance.new("Part")
        carpetFloat.Anchored = true
        carpetFloat.CanCollide = true
        carpetFloat.Size = Vector3.new(10,1,10) -- bằng Upwall
        carpetFloat.Material = Enum.Material.Neon -- giống Upwall
        carpetFloat.Color = Color3.fromRGB(0,255,0)
        carpetFloat.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 4, hrp.Position.Z)
        carpetFloat.Parent = workspace

        local fixedY = carpetFloat.Position.Y
        floatActive = true
        connFloat = RunService.Heartbeat:Connect(function()
            if not floatActive or not carpetFloat then return end
            if not hrp or not hrp.Parent then return end
            carpetFloat.CFrame = CFrame.new(hrp.Position.X, fixedY, hrp.Position.Z)
        end)
    end
    updateStatus()
end
btnFloat.MouseButton1Click:Connect(toggleFloat)

-- Khởi tạo status
updateStatus()
