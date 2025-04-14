_G.AutoFarmLV = true

local p = game.Players.LocalPlayer
local monsterFolders = {workspace.Monster.Mon, workspace.Monster.Boss}
local monsterLock = nil
local monsterData = {
    {maxLv = 9, name = "Soldier [Lv. 1]", quest = "Kill 4 Soldiers", pos = CFrame.new(-1975,49,-4560)},
    {maxLv = 19, name = "Clown Pirate [Lv. 10]", quest = "Kill 5 Clown Pirates", pos = CFrame.new(-1792,50,-4442)},
    {maxLv = 29, name = "Smoky [Lv. 20]", quest = "Kill 1 Smokys", pos = CFrame.new(-2101,49,-4715)},
    {maxLv = 49, name = "Tashi [Lv. 30]", quest = "Kill 1 Tashi", pos = CFrame.new(-2321,50,-4514)},
    {maxLv = 100, name = "Pusst [Lv. 50]", quest = "Kill 1 Pusst", pos = CFrame.new(-693,65,-3470)}
}

-- ล็อกผู้เล่นให้อยู่บนหัวมอน
coroutine.wrap(function()
    while task.wait(0.1) do
        if _G.AutoFarmLV and monsterLock and monsterLock:IsDescendantOf(workspace) then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = monsterLock.Position + Vector3.new(0, 5, 0)
                char:SetPrimaryPartCFrame(CFrame.new(pos, monsterLock.Position))
            end
        else
            monsterLock = nil
        end
    end
end)()

-- หามอนสเตอร์ที่ยังไม่ตาย
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

-- รับเควสและเลือกเป้าหมายตามเลเวล
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

-- ปลดล็อกมอนสเตอร์ทั้งหมด
local function releaseMonsters()
    for _, folder in pairs(monsterFolders) do
        for _, v in pairs(folder:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") then
                v.HumanoidRootPart.Anchored = false
            end
        end
    end
end

-- ลูปหลัก
while task.wait(1) do
    pcall(function()
        if _G.AutoFarmLV then
            autoQuest()
        else
            releaseMonsters()
        end
    end)
end
