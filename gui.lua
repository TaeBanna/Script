local success, message = pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/UI-Library/refs/heads/main/Ghost%20Gui'))()
end)

if not success then
    warn("Failed to load GUI: " .. message)
end


game.CoreGui.GhostGui.MainFrame.Title.Text = "Menu"

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local runtimeItems = workspace:WaitForChild("RuntimeItems")
local dropItemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DropItem")

local highlightEnabled = false
local pickupEnabled = false
local pickupDistance = 20  -- ระยะที่สามารถเก็บของได้
local highlights = {}
local scanning = false
local heartbeatConnection

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
                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(item)
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

-- ฟังก์ชัน Drop All 10 ครั้ง
shared.dropAll = function()
  local function dropItems()
    for i = 1, 10 do
        dropItemRemote:FireServer()
    end
end


----------------------------



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

-- เพิ่มปุ่ม DropAllItem ที่เชื่อมกับฟังก์ชันที่ถูกต้อง
AddContent("TextButton", "DropAllItem", [[
shared.dropAll()  -- เรียกฟังก์ชันด้วยวงเล็บ
]])


