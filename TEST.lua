local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent สำหรับการทิ้งไอเทม
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local dropItemEvent = remotes:WaitForChild("DropItem")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- ฟังก์ชันการทิ้งไอเทม
local function dropItem()
    dropItemEvent:FireServer()
end

-- สร้างปุ่ม TextButton เป็นวงกลม
local dropButton = Instance.new("TextButton")
dropButton.Size = UDim2.new(0, 50, 0, 50)  -- ขนาดปุ่ม
dropButton.Position = UDim2.new(0.5, -50, 0.8, -55)  -- ตำแหน่งปุ่ม
dropButton.Text = "ทิ้งของทั้งหมด"
dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dropButton.Font = Enum.Font.SourceSans
dropButton.TextSize = 18
dropButton.Parent = screenGui

-- ทำให้ปุ่มเป็นวงกลม
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 50)  -- ครึ่งหนึ่งของขนาดปุ่ม
corner.Parent = dropButton

-- ฟังก์ชันเมื่อคลิกปุ่ม
dropButton.MouseButton1Click:Connect(function()
    for i = 1, 10 do
        task.spawn(dropItem)
    end
end)

-- ทำให้ปุ่มสามารถลากได้
local dragging = false
local dragStart = nil
local startPos = nil

dropButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = dropButton.Position
    end
end)

dropButton.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        dropButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

dropButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ฟังก์ชันเพิ่ม Highlight
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

-- ฟังก์ชันเปิด/ปิดไฮไลต์
local function toggleHighlights()
    highlightEnabled = not highlightEnabled
    for _, highlight in ipairs(highlights) do
        highlight.Enabled = highlightEnabled
    end
end

-- สร้างปุ่มเปิด/ปิดไฮไลต์
local highlightButton = Instance.new("TextButton")
highlightButton.Size = UDim2.new(0, 50, 0, 50)
highlightButton.Position = UDim2.new(0.5, -50, 0.9, -25)
highlightButton.Text = "เปิด/ปิด ไฮไลต์"
highlightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
highlightButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
highlightButton.Font = Enum.Font.SourceSans
highlightButton.TextSize = 18
highlightButton.Parent = screenGui

-- ทำให้ปุ่มเป็นวงกลม
local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 25)
corner2.Parent = highlightButton

highlightButton.MouseButton1Click:Connect(function()
    toggleHighlights()
    highlightButton.Text = highlightEnabled and "ปิด ไฮไลต์" or "เปิด ไฮไลต์"
end)

-- ฟังก์ชันสแกน RuntimeItems และเพิ่ม Highlight
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

-- สแกน RuntimeItems เมื่อมีการเปลี่ยนแปลง
RunService.Heartbeat:Connect(function()
    local runtimeItems = Workspace:FindFirstChild("RuntimeItems")
    if runtimeItems then
        runtimeItems.ChildAdded:Connect(function(child)
            if child:IsA("Model") then
                addHighlight(child)
            end
        end)
    end
end)

-- สแกน RuntimeItems เมื่อเริ่มต้น
scanRuntimeItems()

-- ฟังก์ชันเก็บของที่อยู่ใกล้
local pickupEnabled = false
local pickupDistance = 20  -- ระยะห่างที่สามารถเก็บของได้
local scanning = false  -- ตัวแปรควบคุมการทำงาน
local heartbeatConnection

local function scanAndPickUpItems()
    if not pickupEnabled or scanning then return end  -- ถ้าไม่ได้เปิดหรือกำลังทำงานอยู่ ให้ข้าม
    scanning = true  

    -- ฟิลเตอร์รายการที่อยู่ใกล้กับผู้เล่นมากที่สุดก่อน
    local itemsToPickUp = {}
    for _, item in ipairs(Workspace:FindFirstChild("RuntimeItems"):GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local distance = (item.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance <= pickupDistance then
                table.insert(itemsToPickUp, item)
            end
        end
    end
    
    -- หากพบรายการที่ต้องการเก็บ, ส่งคำสั่งเก็บหลายๆ ตัวพร้อมกัน
    if #itemsToPickUp > 0 then
        local args = {}
        -- ส่งคำสั่งเก็บหลายๆ รายการในครั้งเดียว
        for i = 1, math.min(5, #itemsToPickUp) do  -- จำกัดจำนวนที่ส่งเป็น 5 รายการต่อรอบ
            table.insert(args, itemsToPickUp[i])
        end

        -- ส่งคำสั่งเก็บ
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(unpack(args))

        -- หน่วงเวลาเล็กน้อยระหว่างการส่งคำสั่ง (ลดอาการแลค)
        task.wait(0.1)
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
local pickupButton = Instance.new("TextButton")
pickupButton.Size = UDim2.new(0, 50, 0, 50)  -- ขนาดของปุ่มเล็กลงเป็น 50x50
pickupButton.Position = UDim2.new(0, 10, 0.5, -25)  -- ตำแหน่งซ้ายกลาง
pickupButton.Text = "เปิด/ปิด การเก็บของ"
pickupButton.TextSize = 12  -- ขนาดตัวอักษรลดลง
pickupButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
pickupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pickupButton.Parent = screenGui

-- ทำให้ปุ่มเป็นวงกลม
local corner3 = Instance.new("UICorner")
corner3.CornerRadius = UDim.new(0, 25)  -- กำหนดมุมให้เป็นวงกลม
corner3.Parent = pickupButton

-- ฟังก์ชันเมื่อคลิกปุ่ม
pickupButton.MouseButton1Click:Connect(function()
    togglePickupEnabled()
    if pickupEnabled then
        pickupButton.Text = "ปิด การเก็บของ"
    else
        pickupButton.Text = "เปิด การเก็บของ"
    end
end)
