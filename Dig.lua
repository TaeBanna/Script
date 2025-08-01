local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Settings
local settings = {
    running = false,
    autoSell = true,
    panDelay = 0.1,
    sellDelay = 5,
    showStats = true,
    minimized = false
}

-- Statistics
local stats = {
    sessionsStarted = 0,
    totalPansProcessed = 0,
    totalSells = 0,
    sessionStartTime = 0
}

-- Create ScreenGui with better properties
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PanAutoGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame with rounded corners and shadow effect
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 380)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0, 0.5)
frame.Parent = screenGui
frame.ClipsDescendants = true
frame.Active = true
frame.Draggable = true

-- Add UICorner for rounded corners
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Add UIStroke for border
local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(60, 60, 70)
frameStroke.Thickness = 2
frameStroke.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🍳 Pan Automation v2.0"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = titleBar

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
minimizeBtnCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- Toggle Button with gradient
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.1, 0, 0.05, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "🚀 START AUTOMATION"
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = contentFrame

local toggleBtnCorner = Instance.new("UICorner")
toggleBtnCorner.CornerRadius = UDim.new(0, 8)
toggleBtnCorner.Parent = toggleBtn

-- Status Frame
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0.9, 0, 0, 40)
statusFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
statusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = contentFrame

local statusFrameCorner = Instance.new("UICorner")
statusFrameCorner.CornerRadius = UDim.new(0, 6)
statusFrameCorner.Parent = statusFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Text = "🔴 Status: OFFLINE"
statusLabel.Parent = statusFrame

-- Settings Frame
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0.9, 0, 0, 120)
settingsFrame.Position = UDim2.new(0.05, 0, 0.42, 0)
settingsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
settingsFrame.BorderSizePixel = 0
settingsFrame.Parent = contentFrame

local settingsFrameCorner = Instance.new("UICorner")
settingsFrameCorner.CornerRadius = UDim.new(0, 8)
settingsFrameCorner.Parent = settingsFrame

-- Settings Title
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 25)
settingsTitle.Position = UDim2.new(0, 0, 0, 5)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙️ Settings"
settingsTitle.Font = Enum.Font.GothamSemibold
settingsTitle.TextSize = 14
settingsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
settingsTitle.Parent = settingsFrame

-- Auto Sell Toggle
local autoSellToggle = Instance.new("TextButton")
autoSellToggle.Size = UDim2.new(0.9, 0, 0, 25)
autoSellToggle.Position = UDim2.new(0.05, 0, 0, 30)
autoSellToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
autoSellToggle.Text = "✅ Auto Sell: ON"
autoSellToggle.Font = Enum.Font.Gotham
autoSellToggle.TextSize = 12
autoSellToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoSellToggle.Parent = settingsFrame

local autoSellCorner = Instance.new("UICorner")
autoSellCorner.CornerRadius = UDim.new(0, 4)
autoSellCorner.Parent = autoSellToggle

-- Delay Slider Label
local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(1, 0, 0, 20)
delayLabel.Position = UDim2.new(0, 0, 0, 60)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "⏱️ Pan Delay: 0.1s"
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 12
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.Parent = settingsFrame

-- Statistics Frame
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0.9, 0, 0, 100)
statsFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
statsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
statsFrame.BorderSizePixel = 0
statsFrame.Parent = contentFrame

local statsFrameCorner = Instance.new("UICorner")
statsFrameCorner.CornerRadius = UDim.new(0, 8)
statsFrameCorner.Parent = statsFrame

-- Statistics Title
local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, 0, 0, 20)
statsTitle.Position = UDim2.new(0, 0, 0, 5)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "📊 Session Statistics"
statsTitle.Font = Enum.Font.GothamSemibold
statsTitle.TextSize = 12
statsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
statsTitle.Parent = statsFrame

-- Statistics Labels
local pansProcessedLabel = Instance.new("TextLabel")
pansProcessedLabel.Size = UDim2.new(1, 0, 0, 15)
pansProcessedLabel.Position = UDim2.new(0, 0, 0, 25)
pansProcessedLabel.BackgroundTransparency = 1
pansProcessedLabel.Text = "🍳 Pans Processed: 0"
pansProcessedLabel.Font = Enum.Font.Gotham
pansProcessedLabel.TextSize = 10
pansProcessedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
pansProcessedLabel.TextXAlignment = Enum.TextXAlignment.Left
pansProcessedLabel.Parent = statsFrame

local sellsLabel = Instance.new("TextLabel")
sellsLabel.Size = UDim2.new(1, 0, 0, 15)
sellsLabel.Position = UDim2.new(0, 0, 0, 42)
sellsLabel.BackgroundTransparency = 1
sellsLabel.Text = "💰 Total Sells: 0"
sellsLabel.Font = Enum.Font.Gotham
sellsLabel.TextSize = 10
sellsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
sellsLabel.TextXAlignment = Enum.TextXAlignment.Left
sellsLabel.Parent = statsFrame

local uptimeLabel = Instance.new("TextLabel")
uptimeLabel.Size = UDim2.new(1, 0, 0, 15)
uptimeLabel.Position = UDim2.new(0, 0, 0, 59)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.Text = "⏰ Uptime: 00:00:00"
uptimeLabel.Font = Enum.Font.Gotham
uptimeLabel.TextSize = 10
uptimeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
uptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
uptimeLabel.Parent = statsFrame

local rateLabel = Instance.new("TextLabel")
rateLabel.Size = UDim2.new(1, 0, 0, 15)
rateLabel.Position = UDim2.new(0, 0, 0, 76)
rateLabel.BackgroundTransparency = 1
rateLabel.Text = "📈 Rate: 0 pans/min"
rateLabel.Font = Enum.Font.Gotham
rateLabel.TextSize = 10
rateLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
rateLabel.TextXAlignment = Enum.TextXAlignment.Left
rateLabel.Parent = statsFrame

-- Enhanced Pan Automation Function
local lastSellTime = 0
local function panAutomation()
    while settings.running do
        local success, err = pcall(function()
            local character = player.Character or player.CharacterAdded:Wait()
            local backpack = player:WaitForChild("Backpack")
            local pansFound = 0

            local function processPan(pan)
                local scripts = pan:FindFirstChild("Scripts")
                if scripts then
                    -- Toggle shovel active
                    local toggle = scripts:FindFirstChild("ToggleShovelActive")
                    if toggle and toggle:IsA("RemoteEvent") then
                        toggle:FireServer(true)
                    end

                    -- Collect
                    local collect = scripts:FindFirstChild("Collect")
                    if collect and collect:IsA("RemoteFunction") then
                        collect:InvokeServer(1)
                    end

                    -- Shake
                    local shake = scripts:FindFirstChild("Shake")
                    if shake and shake:IsA("RemoteEvent") then
                        shake:FireServer()
                    end

                    pansFound = pansFound + 1
                    stats.totalPansProcessed = stats.totalPansProcessed + 1
                end
            end

            -- Process pans in character
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Tool") and string.find(string.lower(item.Name), "pan") then
                    processPan(item)
                end
            end

            -- Process pans in backpack
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") and string.find(string.lower(item.Name), "pan") then
                    processPan(item)
                end
            end

            -- Auto sell functionality
            if settings.autoSell and (tick() - lastSellTime) >= settings.sellDelay then
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                if remotes then
                    local shop = remotes:FindFirstChild("Shop")
                    if shop then
                        local sell = shop:FindFirstChild("SellAll")
                        if sell and sell:IsA("RemoteFunction") then
                            sell:InvokeServer()
                            stats.totalSells = stats.totalSells + 1
                            lastSellTime = tick()
                        end
                    end
                end
            end

            -- Update statistics
            if settings.showStats then
                pansProcessedLabel.Text = "🍳 Pans Processed: " .. stats.totalPansProcessed
                sellsLabel.Text = "💰 Total Sells: " .. stats.totalSells
                
                local uptime = tick() - stats.sessionStartTime
                local hours = math.floor(uptime / 3600)
                local minutes = math.floor((uptime % 3600) / 60)
                local seconds = math.floor(uptime % 60)
                uptimeLabel.Text = string.format("⏰ Uptime: %02d:%02d:%02d", hours, minutes, seconds)
                
                local rate = uptime > 0 and (stats.totalPansProcessed / (uptime / 60)) or 0
                rateLabel.Text = string.format("📈 Rate: %.1f pans/min", rate)
            end
        end)

        if not success then
            warn("Pan automation error:", err)
        end

        task.wait(settings.panDelay)
    end
end

-- Button animations
local function animateButton(button, scale)
    local tween = TweenService:Create(button, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Size = button.Size * scale}
    )
    tween:Play()
    tween.Completed:Connect(function()
        TweenService:Create(button, 
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = button.Size / scale}
        ):Play()
    end)
end

-- Toggle Button Click
toggleBtn.MouseButton1Click:Connect(function()
    animateButton(toggleBtn, 0.95)
    settings.running = not settings.running
    
    if settings.running then
        toggleBtn.Text = "🛑 STOP AUTOMATION"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
        statusLabel.Text = "🟢 Status: ONLINE"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        stats.sessionStartTime = tick()
        stats.sessionsStarted = stats.sessionsStarted + 1
        spawn(panAutomation)
    else
        toggleBtn.Text = "🚀 START AUTOMATION"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        statusLabel.Text = "🔴 Status: OFFLINE"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Auto Sell Toggle
autoSellToggle.MouseButton1Click:Connect(function()
    animateButton(autoSellToggle, 0.95)
    settings.autoSell = not settings.autoSell
    
    if settings.autoSell then
        autoSellToggle.Text = "✅ Auto Sell: ON"
        autoSellToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
    else
        autoSellToggle.Text = "❌ Auto Sell: OFF"
        autoSellToggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
end)

-- Minimize functionality
minimizeBtn.MouseButton1Click:Connect(function()
    animateButton(minimizeBtn, 0.9)
    settings.minimized = not settings.minimized
    
    local targetSize = settings.minimized and UDim2.new(0, 280, 0, 40) or UDim2.new(0, 280, 0, 380)
    local tween = TweenService:Create(frame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Size = targetSize}
    )
    tween:Play()
    
    minimizeBtn.Text = settings.minimized and "□" or "−"
end)

-- Close functionality
closeBtn.MouseButton1Click:Connect(function()
    settings.running = false
    screenGui:Destroy()
end)

-- Keybind toggle (F2)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F2 then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Initialize
print("🍳 Pan Automation v2.0 loaded successfully!")
print("📋 Press F2 to toggle GUI visibility")
print("🎯 Features: Auto Pan Processing, Auto Sell, Statistics, Draggable GUI")
