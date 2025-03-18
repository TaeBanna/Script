-- สร้างปุ่มใหม่ใน Main
local NewButton = Instance.new("TextButton")
local UICorner_NewButton = Instance.new("UICorner")

-- ตั้งค่าปุ่มใหม่ใน Main
NewButton.Name = "NewButton"
NewButton.Parent = Main
NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
NewButton.BorderSizePixel = 0
NewButton.Position = UDim2.new(0.25, 0, 0.25, 0)
NewButton.Size = UDim2.new(0.5, 0, 0.1, 0)
NewButton.Font = Enum.Font.SourceSans
NewButton.Text = "เก็บของ"
NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
NewButton.TextSize = 20

UICorner_NewButton.CornerRadius = UDim.new(0, 10)
UICorner_NewButton.Parent = NewButton

-- เพิ่มฟังก์ชันการเก็บของ
local pickupEnabled = false
local pickupDistance = 20
local scanning = false
local heartbeatConnection
local runtimeItems = workspace:WaitForChild("RuntimeItems")
local player = game.Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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

-- ฟังก์ชันเปิด/ปิดการเก็บของ
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

-- เมื่อคลิกปุ่มใหม่
NewButton.MouseButton1Click:Connect(function()
    togglePickupEnabled()
    if pickupEnabled then
        NewButton.Text = "หยุดเก็บของ"
    else
        NewButton.Text = "เก็บของ"
    end
end)
