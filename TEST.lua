-- LocalScript (เช่น ใน StarterPlayerScripts)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- รองรับมือถือ
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local dropItemEvent = remotes:WaitForChild("DropItem")
local storeItemEvent = remotes:WaitForChild("StoreItem")

local runtimeItems = Workspace:WaitForChild("RuntimeItems")

-- ส่วนที่ 1: ฟังก์ชันการทิ้งไอเทมเมื่อผู้เล่นกดปุ่ม
local function dropItem()
    dropItemEvent:FireServer()
end

local function createDropButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui

    local dropButton = Instance.new("TextButton")
    dropButton.Size = UDim2.new(0, 200, 0, 50)
    dropButton.Position = UDim2.new(0.5, -100, 0.8, -25)
    dropButton.Text = "ทิ้งของทั้งหมด"
    dropButton.Parent = screenGui

    dropButton.MouseButton1Click:Connect(function()
        for i = 1, 10 do
            task.spawn(dropItem)
        end
    end)
end

-- ส่วนที่ 2: ฟังก์ชันการไฮไลต์ไอเทมที่ใกล้เคียง
local highlights = {}
local highlightEnabled = false

local function addHighlight(target)
    if not target:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = target
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.1
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Enabled = highlightEnabled
        highlight.Parent = target
        table.insert(highlights, highlight)
    end
end

local function scanRuntimeItems()
    local runtimeItems = Workspace:FindFirstChild("RuntimeItems")
    if runtimeItems then
        for _, item in ipairs(runtimeItems:GetChildren()) do
            if item:IsA("Model") then
                addHighlight(item)
            end
        end
    end
end

local function updateHighlights()
    for _, highlight in ipairs(highlights) do
        highlight.Enabled = highlightEnabled
    end
end

local function toggleHighlights()
    highlightEnabled = not highlightEnabled
    updateHighlights()
end

local function createHighlightButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 100)
    button.Position = UDim2.new(0.5, -50, 0.8, -55)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Text = "เปิด/ปิด ไฮไลต์"
    button.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 50)
    corner.Parent = button

    button.MouseButton1Click:Connect(function()
        toggleHighlights()
        button.Text = highlightEnabled and "ปิด ไฮไลต์" or "เปิด ไฮไลต์"
    end)

    UserInputService.TouchTap:Connect(function(input)
        if button:IsPointInRegion2D(input.Position) then
            button.MouseButton1Click:Fire()
        end
    end)
end

-- ส่วนที่ 3: ฟังก์ชันเก็บไอเทมใกล้เคียง
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
        storeItemEvent:FireServer(unpack(args))
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

local function createPickupButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 0.5, -25)
    toggleButton.Text = "เปิด/ปิด การเก็บของ"
    toggleButton.TextSize = 12
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 25)
    corner.Parent = toggleButton

    toggleButton.MouseButton1Click:Connect(function()
        togglePickupEnabled()
        if pickupEnabled then
            toggleButton.Text = "ปิด การเก็บของ"
        else
            toggleButton.Text = "เปิด การเก็บของ"
        end
    end)

    local dragging = false
    local dragStart = nil
    local startPos = nil

    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggleButton.Position
        end
    end)

    toggleButton.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    toggleButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- เรียกใช้งานฟังก์ชันทั้งหมด
createDropButton()
createHighlightButton()
createPickupButton()

-- เริ่มการสแกนไอเทม
scanRuntimeItems()

-- ติดตามการเปลี่ยนแปลงของ RuntimeItems
RunService.Heartbeat:Connect(function()
    local runtimeItems = Workspace:FindFirstChild("RuntimeItems")
    if runtimeItems then
        runtimeItems.ChildAdded:Connect(function(child)
            if child:IsA("Model") then
                addHighlight(child)
                if highlightEnabled then
                    local highlight = child:FindFirstChild("Highlight")
                    if highlight then
                        highlight.Enabled = true
                    end
                end
            end
        end)

        runtimeItems.ChildRemoved:Connect(function()
            scanRuntimeItems()
        end)
    end
end)
