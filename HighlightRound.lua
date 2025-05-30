-- LocalScript (เช่น ใน StarterPlayerScripts)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService") -- รองรับมือถือ

local player = Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui")

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
    local runtimeItems = Workspace:FindFirstChild("RuntimeItems") -- ค้นหาใหม่เสมอ
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

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 100)  -- ขนาดปุ่ม (100x100 ให้เป็นวงกลม)
    button.Position = UDim2.new(0.5, -50, 0.8, -55)  -- ตำแหน่งตรงกลางด้านล่าง
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18  -- ขนาดตัวอักษร
    button.Text = "เปิด/ปิด ไฮไลต์"
    button.Parent = screenGui

    -- เพิ่ม UICorner เพื่อทำให้ปุ่มเป็นวงกลม
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 50)  -- กำหนดมุมให้เป็นวงกลม (ครึ่งหนึ่งของขนาดปุ่ม)
    corner.Parent = button

    -- ฟังก์ชันเมื่อคลิกปุ่ม
    local function onButtonPress()
        toggleHighlights()
        button.Text = highlightEnabled and "ปิด ไฮไลต์" or "เปิด ไฮไลต์"
    end

    -- เมื่อกดปุ่มจะทำงาน
    button.MouseButton1Click:Connect(onButtonPress) -- สำหรับ PC
    UserInputService.TouchTap:Connect(function(input)
        -- เช็คว่ากดที่ปุ่มหรือไม่
        if button:IsPointInRegion2D(input.Position) then
            onButtonPress()
        end
    end) -- สำหรับมือถือ

end

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
            scanRuntimeItems() -- รีสแกนเมื่อมีการลบออก
        end)
    end
end)

-- สร้าง GUI และสแกนครั้งแรก
createGui()
scanRuntimeItems()
