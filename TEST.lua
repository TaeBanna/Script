_G.AutoFarmLV = true

local p = game.Players.LocalPlayer
local monsterFolders = {workspace.Monster.Mon, workspace.Monster.Boss}
local monsterLock = nil

-- ข้อมูลเควสตามระดับ
local monsterData = {
    {maxLv = 9, name = "Soldier [Lv. 1]", quest = "Kill 4 Soldiers", pos = CFrame.new(-1975,49,-4560)},
    {maxLv = 19, name = "Clown Pirate [Lv. 10]", quest = "Kill 5 Clown Pirates", pos = CFrame.new(-1792,50,-4442)},
    {maxLv = 29, name = "Smoky [Lv. 20]", quest = "Kill 1 Smokys", pos = CFrame.new(-2101,49,-4715)},
    {maxLv = 49, name = "Tashi [Lv. 30]", quest = "Kill 1 Tashi", pos = CFrame.new(-2321,50,-4514)},
    {maxLv = 100, name = "Pusst [Lv. 50]", quest = "Kill 1 Pusst", pos = CFrame.new(-693,65,-3470)}
}

-- 🔁 ล็อกบนหัวมอน (แบบไม่ตก)
coroutine.wrap(function()
    while task.wait() do
        if _G.AutoFarmLV and monsterLock and monsterLock:IsDescendantOf(workspace) then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                local hrp = char.HumanoidRootPart
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                hum.PlatformStand = true
                hum:ChangeState(Enum.HumanoidStateType.Physics)
                
                local pos = monsterLock.Position + Vector3.new(0, 5, 0)
                hrp.CFrame = CFrame.new(pos, monsterLock.Position)
            end
        elseif p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            -- คืนค่าปกติถ้าปิดฟาร์ม
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            hum.PlatformStand = false
        end
    end
end)()

-- 📍 หามอนสเตอร์
local function getMonster(name)
    for _, folder in pairs(monsterFolders) do
        for _, v in pairs(folder:GetChildren()) do
            local h = v:FindFirstChildOfClass("Humanoid")
            if v.Name == name and h and h.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                if _G.AutoFarmLV then v.HumanoidRootPart.Anchored = true end
                return v.HumanoidRootPart
            end
        end
    end
end

-- 🎯 เลือกเควส + จัดการวาร์ป
local function autoQuest()
    local lvl = p:FindFirstChild("PlayerStats") and p.PlayerStats:FindFirstChild("lvl") and p.PlayerStats.lvl.Value
    if not lvl then return end
    for _, data in ipairs(monsterData) do
        if lvl <= data.maxLv then
            game.ReplicatedStorage.Chest.Remotes.Functions.Quest:InvokeServer("take", data.quest)
            local found = getMonster(data.name)
            if found then
                monsterLock = found
            else
                p.Character:SetPrimaryPartCFrame(data.pos)
            end
            return
        end
    end
end

-- 🔓 ปลด Anchor มอนสเตอร์ทั้งหมด
local function releaseMonsters()
    for _, folder in pairs(monsterFolders) do
        for _, v in pairs(folder:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") then
                v.HumanoidRootPart.Anchored = false
            end
        end
    end
end

-- 🔁 ลูปหลัก
while task.wait() do
    pcall(function()
        if _G.AutoFarmLV then
            autoQuest()
        else
            releaseMonsters()
        end
    end)
end
