local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local pickupEnabled = false
local pickupDistance = 20  
local scanning = false  
local heartbeatConnection

local function scanAndPickUpItems()
    if not pickupEnabled or scanning then return end  
    scanning = true  

    local itemsToPickUp = {}
    for _, item in ipairs(runtimeItems:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local distance = (item.PrimaryPart.Position - playerHumanoidRootPart.Position).magnitude
            if distance <= pickupDistance then
                table.insert(itemsToPickUp, item)
            end
        end
    end
    
    if #itemsToPickUp > 0 then
        local args = {}
        for i = 1, math.min(5, #itemsToPickUp) do
            table.insert(args, itemsToPickUp[i])
        end
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(unpack(args))
        task.wait(0.1)
    end

    task.wait(0.1)
    scanning = false
end

local function togglePickupEnabled()
    pickupEnabled = not pickupEnabled

    if pickupEnabled then
        heartbeatConnection = RunService.Heartbeat:Connect(scanAndPickUpItems)
    else
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 250)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Main.Parent = screenGui

local function createButton(name, text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Position = position
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.TextSize = 14

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = button

    return button
end

local highlightButton = createButton("Highlight", "Highlight", UDim2.new(0.15, 0, 0.1, 0), Main)
local pickupButton = createButton("Pickup", "Pickup", UDim2.new(0.15, 0, 0.35, 0), Main)
local dropButton = createButton("Drop", "Drop", UDim2.new(0.15, 0, 0.6, 0), Main)

pickupButton.MouseButton1Click:Connect(function()
    togglePickupEnabled()
    pickupButton.Text = pickupEnabled and "ปิด การเก็บของ" or "Pickup"
end)
