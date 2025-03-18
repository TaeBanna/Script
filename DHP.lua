local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local pickupEnabled = false
local highlightEnabled = false
local pickupDistance = 20
local scanning = false
local heartbeatConnection

-- ██████ ฟังก์ชันเปิด/ปิด Highlight ██████
local function toggleHighlight()
    highlightEnabled = not highlightEnabled
    for _, item in ipairs(runtimeItems:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local highlight = item:FindFirstChild("Highlight")
            if highlightEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = item
                end
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- ██████ ฟังก์ชันเก็บของ ██████
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

    scanning = false
end

-- ██████ ฟังก์ชันทิ้งของทั้งหมด ██████
local function dropAllItems()
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end

    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DropItem"):FireServer(item)
            task.wait(0.05) -- ลดอาการแลค
        end
    end
end

-- ██████ สร้าง GUI ██████
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = position
    button.Text = text
    button.TextSize = 18
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = screenGui
    button.MouseButton1Click:Connect(callback)
    return button
end

local pickupButton = createButton("เปิด การเก็บของ", UDim2.new(0, 10, 0.4, -25), function()
    pickupEnabled = not pickupEnabled
    if pickupEnabled then
        heartbeatConnection = RunService.Heartbeat:Connect(scanAndPickUpItems)
        pickupButton.Text = "ปิด การเก็บของ"
    else
        if heartbeatConnection then heartbeatConnection:Disconnect() end
        pickupButton.Text = "เปิด การเก็บของ"
    end
end)

local highlightButton = createButton("เปิด ไฮไลท์ไอเทม", UDim2.new(0, 10, 0.5, -25), function()
    toggleHighlight()
    if highlightEnabled then
        highlightButton.Text = "ปิด ไฮไลท์ไอเทม"
    else
        highlightButton.Text = "เปิด ไฮไลท์ไอเทม"
    end
end)

local dropAllButton = createButton("ทิ้งของทั้งหมด", UDim2.new(0, 10, 0.6, -25), dropAllItems)
