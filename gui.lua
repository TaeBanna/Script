-- โหลด Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GLandCD", "Ocean") -- สร้างหน้าต่างหลัก
local Tab = Window:NewTab("Game") -- สร้างแท็บ
local Section = Tab:NewSection("Dropdown") -- สร้างส่วนย่อยสำหรับ Dropdown

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local dropdownValue = "None" -- ค่าของ Dropdown เริ่มต้น

-- สร้าง Dropdown
Section:NewDropdown("Select an Item", "เลือกไอเทมจาก Dropdown", {"Item 1", "Item 2", "Item 3", "Item 4"}, function(selected)
    dropdownValue = selected -- เก็บค่าที่เลือกจาก Dropdown
    print("คุณเลือก: " .. dropdownValue) -- แสดงผลค่าที่เลือก
end)

-- เพิ่มปุ่มสำหรับมือถือ
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local dropdownButton = Instance.new("TextButton")
dropdownButton.Size = UDim2.new(0, 200, 0, 50)
dropdownButton.Position = UDim2.new(0.5, -100, 0.7, -25) -- ตำแหน่งตรงกลางหน้าจอ
dropdownButton.Text = "เปิด Dropdown"
dropdownButton.TextSize = 20
dropdownButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdownButton.Parent = screenGui

-- การคลิกที่ปุ่ม
dropdownButton.MouseButton1Click:Connect(function()
    -- แสดงหรือซ่อน Dropdown ตามสถานะ
    if Section:IsVisible() then
        Section:Hide() -- ซ่อน
    else
        Section:Show() -- แสดง
    end
end)

-- สร้างปุ่มปิด/แสดง GUI
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.8, -25) -- ตำแหน่งตรงกลางหน้าจอ
toggleButton.Text = "ปิด/เปิด GUI"
toggleButton.TextSize = 20
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

-- ฟังก์ชันสำหรับซ่อน/แสดง GUI
local isGuiVisible = true

toggleButton.MouseButton1Click:Connect(function()
    if isGuiVisible then
        screenGui.Enabled = false -- ซ่อน GUI
    else
        screenGui.Enabled = true -- แสดง GUI
    end
    isGuiVisible = not isGuiVisible -- เปลี่ยนสถานะของการแสดง/ซ่อน
end)
