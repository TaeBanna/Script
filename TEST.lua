-- ฟังก์ชันการเปิด/ปิดไฮไลต์
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local highlights = {} -- เก็บรายการ Highlight ที่ถูกสร้าง
local screenGui
local highlightEnabled = false -- ตัวแปรเปิด/ปิดไฮไลต์

-- ฟังก์ชันเพิ่ม Highlight ให้ Model
local function addHighlight(target)
    if not target:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = target
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.1
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Enabled = highlightEnabled -- ใช้ค่าเดียวกับปุ่ม
        highlight.Parent = target
        table.insert(highlights, highlight)
    end
end

-- ฟังก์ชันสแกน RuntimeItems
local function scanRuntimeItems()
    local runtimeItems = workspace:FindFirstChild("RuntimeItems") -- ค้นหาใหม่เสมอ
    if runtimeItems then
        for _, item in ipairs(runtimeItems:GetChildren()) do
            if item:IsA("Model") then
                addHighlight(item)
            end
        end
    end
end

-- ฟังก์ชันอัปเดต Highlight ตามสถานะปุ่ม
local function updateHighlights()
    for _, highlight in ipairs(highlights) do
        highlight.Enabled = highlightEnabled
    end
end

-- ฟังก์ชันเปิด/ปิดไฮไลต์
local function toggleHighlights()
    highlightEnabled = not highlightEnabled
    updateHighlights()
end

-- ฟังก์ชันสร้าง GUI
local function createGui()
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Parent = playerGui
        screenGui.Name = "ScreenGui"
    end

    -- สร้างปุ่มเปิด/ปิดไฮไลต์
    local highlightButton = Instance.new("TextButton")
    highlightButton.Size = UDim2.new(0, 100, 0, 50)
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

    -- สร้างปุ่มเก็บของ
    local pickupButton = Instance.new("TextButton")
    pickupButton.Size = UDim2.new(0, 50, 0, 50)
    pickupButton.Position = UDim2.new(0, 10, 0.5, -25)
    pickupButton.Text = "เปิด/ปิด การเก็บของ"
    pickupButton.TextSize = 12
    pickupButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pickupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    pickupButton.Parent = screenGui

    -- ทำให้ปุ่มเป็นวงกลม
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0, 25)
    corner3.Parent = pickupButton

    pickupButton.MouseButton1Click:Connect(function()
        togglePickupEnabled()
        if pickupEnabled then
            pickupButton.Text = "ปิด การเก็บของ"
        else
            pickupButton.Text = "เปิด การเก็บของ"
        end
    end)
end

-- ฟังก์ชันเก็บของที่อยู่ใกล้
local pickupEnabled = false
local pickupDistance = 20  -- ระยะห่างที่สามารถเก็บของได้
local scanning = false
local heartbeatConnection
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local function scanAndPickUpItems()
    if not pickupEnabled or scanning then return end  -- ถ้าไม่ได้เปิดหรือกำลังทำงานอยู่ ให้ข้าม
    scanning = true  

    -- ฟิลเตอร์รายการที่อยู่ใกล้กับผู้เล่นมากที่สุดก่อน
    local itemsToPickUp = {}
    for _, item in ipairs(runtimeItems:GetChildren()) do
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
        for i = 1, math.min(5, #itemsToPickUp) do  -- จำกัดจำนวนที่ส่งเป็น 5 รายการต่อรอบ
            table.insert(args, itemsToPickUp[i])
        end

        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(unpack(args))

        -- หน่วงเวลาเล็กน้อยระหว่างการส่งคำสั่ง (ลดอาการแลค)
        task.wait(0.1)
    end

    -- รอ 0.1 วินาที ก่อนสแกนรอบถัดไป
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

-- สร้าง GUI และสแกนครั้งแรก
createGui()
scanRuntimeItems()
