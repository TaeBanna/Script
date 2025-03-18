local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local pickupEnabled = false
local pickupDistance = 20  -- ระยะห่างที่สามารถเก็บของได้ (เพิ่มระยะห่าง)
local scanning = false  -- ตัวแปรควบคุมการทำงาน
local heartbeatConnection

-- ฟังก์ชันเก็บของที่อยู่ใกล้
local function scanAndPickUpItems()
    if not pickupEnabled or scanning then return end  -- ถ้าไม่ได้เปิดหรือกำลังทำงานอยู่ ให้ข้าม
    scanning = true  

    -- ฟิลเตอร์รายการที่อยู่ใกล้กับผู้เล่นมากที่สุดก่อน
    local itemsToPickUp = {}
    for _, item in ipairs(runtimeItems:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local distance = (item.PrimaryPart.Position - playerHumanoidRootPart.Position).magnitude
            if distance <= pickupDistance then
                table.insert(itemsToPickUp, item)
            end
        end
    end
    
    -- หากพบรายการที่ต้องการเก็บ, ส่งคำสั่งเก็บหลายๆ ตัวพร้อมกัน
    if #itemsToPickUp > 0 then
        -- ปรับระยะเวลาในการส่งคำสั่งเก็บเพื่อไม่ให้แลค
        local args = {}
        for _, item in ipairs(itemsToPickUp) do
            table.insert(args, item)
        end

        -- ส่งคำสั่งเก็บหลายๆ รายการในครั้งเดียว
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(unpack(args))

        -- หน่วงเวลาเล็กน้อยระหว่างการส่งคำสั่ง (ลดอาการแลค)
        task.wait(0.05)
    end

    -- รอ 0.1 วินาที ก่อนสแกนรอบถัดไป (ลดเวลาในการรอเพื่อเพิ่มความเร็ว)
    task.wait(0.1)
    scanning = false
end

-- ฟังก์ชันเปิด/ปิดการเก็บของอัตโนมัติ
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

-- สร้าง GUI ปุ่มที่อยู่ทางซ้ายกลาง
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, -25)  -- ตำแหน่งซ้ายกลาง
toggleButton.Text = "เปิด/ปิด การเก็บของ"
toggleButton.TextSize = 18
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

-- ฟังก์ชันเมื่อคลิกปุ่ม
toggleButton.MouseButton1Click:Connect(function()
    togglePickupEnabled()
    if pickupEnabled then
        toggleButton.Text = "ปิด การเก็บของ"
    else
        toggleButton.Text = "เปิด การเก็บของ"
    end
end)
