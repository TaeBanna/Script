loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/UI-Library/refs/heads/main/Ghost%20Gui'))()

game.CoreGui.GhostGui.MainFrame.Title.Text = "Menu"

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local runtimeItems = workspace:WaitForChild("RuntimeItems")

local highlightEnabled = false
local pickupEnabled = false
local pickupDistance = 10  -- ระยะที่สามารถเก็บของได้
local highlights = {}
local scanning = false
local heartbeatConnection

-- ดึงข้อมูลที่จำเป็นจาก ReplicatedStorage ไว้ข้างนอก
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local dropItemEvent = remotes:WaitForChild("DropItem")

-- ฟังก์ชันทำความสะอาดไฮไลต์เก่าทั้งหมด
local function cleanupHighlights()
    for _, highlight in ipairs(highlights) do
        highlight:Destroy()
    end
    highlights = {}
end

-- ฟังก์ชันเพิ่มไฮไลต์ให้ไอเทมที่พบ
local function addHighlight(target)
    if not target:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight", target)
        highlight.Adornee = target
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- สีแดง
        table.insert(highlights, highlight)
    end
end

-- ฟังก์ชันสแกน RuntimeItems และเพิ่มไฮไลต์
local function scanRuntimeItems()
    cleanupHighlights() -- ล้างของเก่าออกก่อน
    local items = runtimeItems:GetChildren()
    for _, item in ipairs(items) do
        if item:IsA("Model") then
            local hasHumanoid = item:FindFirstChildOfClass("Humanoid")
            if hasHumanoid then
                addHighlight(item)
            else
                for _, part in ipairs(item:GetChildren()) do
                    if part:IsA("BasePart") then
                        addHighlight(part)
                    end
                end
            end
        end
    end
end

-- อัปเดตการสแกนเมื่อมีของใหม่เข้า-ออก
runtimeItems.ChildAdded:Connect(function() 
    if highlightEnabled then scanRuntimeItems() end 
end)

runtimeItems.ChildRemoved:Connect(function() 
    if highlightEnabled then scanRuntimeItems() end 
end)

-- ฟังก์ชันเปิด/ปิดไฮไลต์ และแชร์ให้ `AddContent` ใช้งาน
shared.toggleHighlight = function(state)
    highlightEnabled = state
    if highlightEnabled then
        scanRuntimeItems()
    else
        cleanupHighlights()
    end
end

-- ฟังก์ชันเก็บของที่อยู่ใกล้
local function scanAndPickUpItems()
    if not pickupEnabled or scanning then return end  -- ถ้าไม่ได้เปิดหรือกำลังทำงานอยู่ ให้ข้าม
    scanning = true  

    for _, item in ipairs(runtimeItems:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local distance = (item.PrimaryPart.Position - playerHumanoidRootPart.Position).magnitude
            if distance <= pickupDistance then
                dropItemEvent:FireServer(item)
            end
        end
    end

    task.wait(0.5)  -- ลดโหลดของเซิร์ฟเวอร์
    scanning = false
end

-- ฟังก์ชันเปิด/ปิดระบบเก็บของอัตโนมัติ และแชร์ให้ `AddContent` ใช้งาน
shared.togglePickup = function(state)
    pickupEnabled = state
    if pickupEnabled then
        heartbeatConnection = RunService.Heartbeat:Connect(scanAndPickUpItems)
    else
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
    end
end

----------------------------

-- ฟังก์ชัน Drop All
local function dropAllItems()
    -- ทิ้งทุกไอเทมที่อยู่ใน Backpack ของผู้เล่น
    local player = game.Players.LocalPlayer
    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            dropItemEvent:FireServer(item)  -- ส่งคำสั่งทิ้งไปยังเซิร์ฟเวอร์
        end
    end
end

-- เพิ่มปุ่มควบคุมใน Ghost GUI --

-- ระบบ Highlights
AddContent("Switch", "Highlights", [[
shared.toggleHighlight(true) -- เปิดใช้งาน
]], [[
shared.toggleHighlight(false) -- ปิดใช้งาน
]])

-- ระบบ Pickup
AddContent("Switch", "Auto Pickup", [[
shared.togglePickup(true) -- เปิดใช้งาน
]], [[
shared.togglePickup(false) -- ปิดใช้งาน
]])

-- ระบบ Drop All
AddContent("Switch", "Drop All Items", [[
dropAllItems() -- ทิ้งไอเทมทั้งหมด
]], [[
-- ไม่มีการปิดหรือหยุด
]])

-- LocalScript (เช่น ใน StarterPlayerScripts)

-- สร้าง ScreenGui และปุ่มบนหน้าจอ
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- สร้างปุ่ม TextButton
local dropButton = Instance.new("TextButton")
dropButton.Size = UDim2.new(0, 200, 0, 50)  -- ขนาดของปุ่ม
dropButton.Position = UDim2.new(0.5, -100, 0.8, -25)  -- ตำแหน่งของปุ่ม (ตรงกลางด้านล่าง)
dropButton.Text = "ทิ้งของทั้งหมด"  -- ข้อความบนปุ่ม
dropButton.Parent = screenGui

-- เมื่อกดปุ่มจะทิ้งไอเทม 10 ครั้ง โดยใช้ delay หรือ task.spawn เพื่อให้ทิ้งเร็วขึ้น
dropButton.MouseButton1Click:Connect(function()
    for i = 1, 10 do
        task.spawn(dropAllItems)  -- ใช้ task.spawn เพื่อให้ทิ้งไอเทมในเธรดใหม่
    end
end)
