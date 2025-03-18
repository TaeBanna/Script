-- โหลด Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GLandCD", "Ocean") -- สร้างหน้าต่างหลัก
local Tab = Window:NewTab("Game") -- สร้างแท็บ
local Section = Tab:NewSection("Highlight Section") -- สร้างส่วนย่อยสำหรับไฮไลท์

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local runtimeItems = workspace:WaitForChild("RuntimeItems")

-- เพิ่มปุ่มสำหรับมือถือ
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local highlightButton = Instance.new("TextButton")
highlightButton.Size = UDim2.new(0, 200, 0, 50)
highlightButton.Position = UDim2.new(0.5, -100, 0.7, -25) -- ตำแหน่งตรงกลางหน้าจอ
highlightButton.Text = "ไฮไลท์"
highlightButton.TextSize = 20
highlightButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
highlightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
highlightButton.Parent = screenGui

-- การคลิกที่ปุ่มเพื่อทำไฮไลท์
highlightButton.MouseButton1Click:Connect(function()
    -- เปลี่ยนสีพื้นหลังของปุ่มให้เป็นสีเหลืองเพื่อทำไฮไลท์
    highlightButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- สีเหลือง

    -- ใช้เวลาในการแสดงไฮไลท์สักพักแล้วกลับไปสีเดิม
    wait(1) -- รอ 1 วินาที
    highlightButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- กลับไปเป็นสีดำ
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
