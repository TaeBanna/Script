_G.AutoFarmLV = true -- เปิดใช้งาน AutoFarm

local player = game.Players.LocalPlayer
local monsterFolders = {workspace.Monster.Mon, workspace.Monster.Boss} -- รวมทั้งสอง folder

-- ฟังก์ชันหามอนสเตอร์
local function findMonster(name)
    for _, folder in pairs(monsterFolders) do
        for _, v in pairs(folder:GetChildren()) do
            if v.Name == name and v:FindFirstChild("HumanoidRootPart") then
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then -- เช็คว่า Humanoid ยังมีชีวิตอยู่
                    -- ถ้าเปิด AutoFarm จะล็อกมอนสเตอร์
                    if _G.AutoFarmLV then
                        humanoid.RootPart.Anchored = true -- ตั้งค่าการล็อกที่ HumanoidRootPart
                    end
                    return v.HumanoidRootPart
                end
            end
        end
    end
    return nil
end

-- ฟังก์ชันเช็ค Level และเลือกมอนสเตอร์
local function checkPlayerLevel()
    -- ตรวจสอบว่า lvl มีค่าหรือไม่
    local level = LocalPlayer.PlayerStats.lvl.value
    if not level then 
        return
    end
    
    local targetMonster = level <= 10 and "Soldier [Lv. 1]" or 
                          (level <= 20 and "Clown Pirate [Lv. 10]" or 
                          (level <= 90 and "Smoky [Lv. 20]" ))

    if targetMonster then
        local monster = findMonster(targetMonster)
        if monster then
            player.Character:SetPrimaryPartCFrame(monster.CFrame * CFrame.new(0, 0, 5.5)) -- วาร์ปไปที่มอนสเตอร์
        else
            warn(targetMonster .. " not found or monster is dead!")
        end
    end
end

-- ฟังก์ชันที่จะคืนค่าการล็อกของมอนสเตอร์เมื่อปิด AutoFarm
local function unlockMonsters()
    if not _G.AutoFarmLV then
        for _, folder in pairs(monsterFolders) do
            for _, v in pairs(folder:GetChildren()) do
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.RootPart.Anchored = false -- รีเซ็ตการล็อกกลับ
                end
            end
        end
    end
end

-- ตัวอย่างการใช้งาน
while task.wait() do
    if _G.AutoFarmLV then
        pcall(checkPlayerLevel)
    else
        unlockMonsters() -- เมื่อปิด AutoFarm จะทำการปลดล็อกมอนสเตอร์
    end
end
