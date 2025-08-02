local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local running = false
local automationThread = nil

-- UI Initialization
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PanAutoGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0.5, -130, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🥄 Pan Automation"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.6, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.2, 0, 0.55, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "Turn ON"
toggleBtn.AutoButtonColor = true
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Status: OFF"
statusLabel.Parent = frame

-- Core Automation
local function processPan(pan)
    local character = player.Character
    if not character then return end

    -- Equip pan if in backpack
    if pan.Parent == player:FindFirstChild("Backpack") then
        pan.Parent = character
        task.wait(0.2)
    end

    local scripts = pan:FindFirstChild("Scripts")
    if not scripts then return end

    local toggle = scripts:FindFirstChild("ToggleShovelActive")
    local shake = scripts:FindFirstChild("Shake")
    local collect = scripts:FindFirstChild("Collect")

    if toggle and toggle:IsA("RemoteEvent") then
        toggle:FireServer(true)
        task.wait(0.2)
    end

    if shake and shake:IsA("RemoteEvent") then
        shake:FireServer()
        task.wait(0.3)
    end

    if collect and collect:IsA("RemoteFunction") then
        collect:InvokeServer(1)
    end
end

local function panAutomation()
    while running do
        local success, err = pcall(function()
            local character = player.Character or player.CharacterAdded:Wait()
            local backpack = player:WaitForChild("Backpack")

            -- ใช้ Pan จากตัวละครก่อน
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Pan") then
                    processPan(item)
                end
            end

            -- แล้วค่อยเช็กในกระเป๋า
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Pan") then
                    processPan(item)
                end
            end

            -- ขายของ (ถ้ามี)
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local shop = remotes:FindFirstChild("Shop")
                if shop then
                    local sell = shop:FindFirstChild("SellAll")
                    if sell and sell:IsA("RemoteFunction") then
                        sell:InvokeServer()
                    end
                end
            end
        end)

        if not success then
            warn("Pan automation error:", err)
        end

        task.wait(0.8)
    end
end

-- Toggle Button Click
toggleBtn.MouseButton1Click:Connect(function()
    running = not running
    toggleBtn.Text = running and "Turn OFF" or "Turn ON"
    statusLabel.Text = running and "Status: ON" or "Status: OFF"

    if running then
        automationThread = coroutine.create(panAutomation)
        coroutine.resume(automationThread)
    end
end)
