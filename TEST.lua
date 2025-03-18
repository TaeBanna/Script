local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame") -- สร้าง Main ก่อน
local Highlight = Instance.new("TextButton")
local Pickup = Instance.new("TextButton")
local Drop = Instance.new("TextButton")
local UICorner_Highlight = Instance.new("UICorner")
local UICorner_Pickup = Instance.new("UICorner")
local UICorner_Drop = Instance.new("UICorner")

-- ตั้งค่า ScreenGui
ScreenGui.Name = "CustomGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ตั้งค่า Main (Frame)
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.Position = UDim2.new(0.5, -150, 0.5, -100)

-- Properties ของ Highlight
Highlight.Name = "Highlight"
Highlight.Parent = Main
Highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Highlight.Position = UDim2.new(0.1, 0, 0.1, 0)
Highlight.Size = UDim2.new(0, 200, 0, 50)
Highlight.Font = Enum.Font.SourceSans
Highlight.Text = "Highlight"
Highlight.TextColor3 = Color3.fromRGB(0, 0, 0)
Highlight.TextSize = 14

UICorner_Highlight.CornerRadius = UDim.new(0, 20)
UICorner_Highlight.Parent = Highlight

-- Properties ของ Pickup
Pickup.Name = "Pickup"
Pickup.Parent = Main
Pickup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pickup.Position = UDim2.new(0.1, 0, 0.4, 0)
Pickup.Size = UDim2.new(0, 200, 0, 50)
Pickup.Font = Enum.Font.SourceSans
Pickup.Text = "Pickup"
Pickup.TextColor3 = Color3.fromRGB(0, 0, 0)
Pickup.TextSize = 14

UICorner_Pickup.CornerRadius = UDim.new(0, 20)
UICorner_Pickup.Parent = Pickup

-- Properties ของ Drop
Drop.Name = "Drop"
Drop.Parent = Main
Drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Drop.Position = UDim2.new(0.1, 0, 0.7, 0)
Drop.Size = UDim2.new(0, 200, 0, 50)
Drop.Font = Enum.Font.SourceSans
Drop.Text = "Drop"
Drop.TextColor3 = Color3.fromRGB(0, 0, 0)
Drop.TextSize = 14

UICorner_Drop.CornerRadius = UDim.new(0, 20)
UICorner_Drop.Parent = Drop

-- Properties สำหรับการทำงานของ Pickup และ Drop
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local pickupEnabled = false
local pickupDistance = 20
local scanning = false
local heartbeatConnection

-- ฟังก์ชันเก็บของ
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

-- ฟังก์ชันกดปุ่ม Pickup
Pickup.MouseButton1Click:Connect(function()
    togglePickupEnabled()
    if pickupEnabled then
        Pickup.Text = "ปิด การเก็บของ"
    else
        Pickup.Text = "Pickup"
    end
end)

-- ฟังก์ชันกดปุ่ม Drop
Drop.MouseButton1Click:Connect(function()
    -- ฟังก์ชันที่ใช้ในการทำงานของปุ่ม Drop (สามารถเพิ่มฟังก์ชันได้ตามที่ต้องการ)
end)
