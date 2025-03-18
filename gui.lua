-- โหลด Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GLandCD", "Ocean") -- สร้างหน้าต่างหลัก
local Tab = Window:NewTab("Game") -- สร้างแท็บ
local Section = Tab:NewSection("Highlight") -- สร้างส่วนย่อยภายในแท็บ

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local highlightEnabled = false -- สถานะเริ่มต้นคือไม่เปิดไฮไลท์

-- ฟังก์ชันไฮไลท์
local function highlightItems()
    -- ลูปผ่านไอเทมใน RuntimeItems
    for _, item in ipairs(runtimeItems:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local highlight = item:FindFirstChild("Highlight")

            -- ถ้ากดเปิดไฮไลท์
            if highlightEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight") -- สร้าง Highlight ใหม่
                    highlight.FillColor = Color3.fromRGB(255, 255, 0) -- กำหนดสี
                    highlight.FillTransparency = 0.5 -- กำหนดความโปร่งใส
                    highlight.Parent = item -- เพิ่ม Highlight ลงในไอเทม
                end
            else
                if highlight then
                    highlight:Destroy() -- ลบ Highlight เมื่อปิด
                end
            end
        end
    end
end

-- สร้าง Toggle Switch
Section:NewToggle("Highlight", "เปิด/ปิดการไฮไลท์ของไอเทม", function(state)
    highlightEnabled = state -- ตั้งค่าการเปิด/ปิดตาม Toggle
    highlightItems() -- เรียกฟังก์ชัน highlightItems เมื่อสถานะเปลี่ยนแปลง
end)

-- เพิ่มปุ่มสำหรับมือถือ
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.8, -25) -- ตำแหน่งตรงกลางหน้าจอ
toggleButton.Text = "เปิด/ปิด การไฮไลท์"
toggleButton.TextSize = 20
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

toggleButton.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    highlightItems()
    if highlightEnabled then
        toggleButton.Text = "ปิด การไฮไลท์"
    else
        toggleButton.Text = "เปิด การไฮไลท์"
    end
end)

-- สร้างปุ่มวงกลมเพื่อปิดหน้าต่าง GUI
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(0.05, 0, 0.05, 0) -- ตำแหน่งทางซ้ายบนของหน้าจอ
closeButton.Text = "X"
closeButton.TextSize = 25
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- สีแดง
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = screenGui

-- ทำให้ปุ่มเป็นวงกลม
closeButton.ClipsDescendants = true
closeButton.TextButton.TextButton.Size = UDim2.new(1, 0, 1, 0)
closeButton.TextButton.BorderSizePixel = 0
closeButton.BackgroundTransparency = 1
closeButton.Text = ""

local circleShape = Instance.new("UICorner") -- สร้างมุมกลม
circleShape.CornerRadius = UDim.new(1, 0) -- ทำให้เป็นวงกลม
circleShape.Parent = closeButton

-- ฟังก์ชันการคลิกปิดหน้าต่าง
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- ลบหน้าจอ GUI ทั้งหมด
end)
