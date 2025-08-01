local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local running = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PanAutoGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 120)
frame.Position = UDim2.new(0.8, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark gray
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Pan Automation"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.6, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- Steel blue
toggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "Turn ON"
toggleBtn.AutoButtonColor = true
toggleBtn.Parent = frame

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

-- Pan Automation Function
local function panAutomation()
    while running do
        local success, err = pcall(function()
            local character = player.Character or player.CharacterAdded:Wait()
            local backpack = player:WaitForChild("Backpack")

            local function processPan(pan)
                local scripts = pan:FindFirstChild("Scripts")
                if scripts then
                    local toggle = scripts:FindFirstChild("ToggleShovelActive")
                    if toggle and toggle:IsA("RemoteEvent") then
                        toggle:FireServer(true)
                    end

                    local collect = scripts:FindFirstChild("Collect")
                    if collect and collect:IsA("RemoteFunction") then
                        collect:InvokeServer(1)
                    end

                    local shake = scripts:FindFirstChild("Shake")
                    if shake and shake:IsA("RemoteEvent") then
                        shake:FireServer()
                    end
                end
            end

            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") and string.find(item.Name, "Pan") then
                    processPan(item)
                end
            end

            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") and string.find(item.Name, "Pan") then
                    processPan(item)
                end
            end

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

        task.wait(0)
    end
end

-- Toggle Button Click
toggleBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        toggleBtn.Text = "Turn OFF"
        statusLabel.Text = "Status: ON"
        spawn(panAutomation)
    else
        toggleBtn.Text = "Turn ON"
        statusLabel.Text = "Status: OFF"
    end
end)
