_G.AutoFarmLV = true -- เปิดใช้งาน AutoFarm

local player = game.Players.LocalPlayer
local monsterFolders = {workspace.Monster.Mon, workspace.Monster.Boss}
local monsters = {} -- เก็บข้อมูลมอนสเตอร์ที่ล็อคไว้

-- ฟังก์ชันหามอนสเตอร์
local function findMonster(name)
    for _, folder in pairs(monsterFolders) do
        for _, v in pairs(folder:GetChildren()) do
            if v.Name == name and v:FindFirstChild("HumanoidRootPart") then
                return v
            end
        end
    end
end

-- ฟังก์ชันล็อคมอนสเตอร์
local function lockMonster(monster)
    local humanoid = monster:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true -- ปิดการเคลื่อนไหว
        monster:MoveTo(monster.Position) -- ป้องกันมอนสเตอร์เคลื่อนที่
        monster:SetPrimaryPartCFrame(monster.HumanoidRootPart.CFrame)
        monster.Anchored = true -- ตั้งค่า Anchored
        table.insert(monsters, monster) -- เก็บข้อมูลมอนสเตอร์
    end
end

-- ฟังก์ชันปลดล็อคมอนสเตอร์
local function unlockMonster(monster)
    local humanoid = monster:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false -- เปิดการเคลื่อนไหว
        monster.Anchored = false -- ปลดล็อค Anchored
    end
end

-- ฟังก์ชันเช็ค Level และเลือกมอนสเตอร์
local function checkPlayerLevel()
    local level = player.PlayerStats.lvl.Value
    local targetMonster = (level <= 10 and "Soldier [Lv. 1]") or
                          (level <= 20 and "Clown Pirate [Lv. 10]") or
                          (level <= 30 and "Smoky [Lv. 20]")

    if targetMonster then
        local monster = findMonster(targetMonster)
        if monster then
            player.Character:SetPrimaryPartCFrame(monster.HumanoidRootPart.CFrame * CFrame.new(0, 0, 6))
            lockMonster(monster) -- ล็อคมอนสเตอร์เมื่อเจอ
        else
            warn(targetMonster .. " not found!")
        end
    else
        warn("Level not valid!")
    end
end

-- ตัวอย่างการใช้งาน
while task.wait() do
    if _G.AutoFarmLV then
        pcall(checkPlayerLevel)
    else
        -- ปลดล็อคมอนสเตอร์ทั้งหมดเมื่อปิด AutoFarm
        for _, monster in pairs(monsters) do
            unlockMonster(monster)
        end
        monsters = {} -- เคลียร์ข้อมูลมอนสเตอร์ที่ล็อค
    end
end
