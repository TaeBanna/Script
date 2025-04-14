_G.AutoFarmLV = true
local player = game.Players.LocalPlayer
local monsterFolders = {workspace.Monster.Mon, workspace.Monster.Boss}
local currentTargetMonster = nil
local currentTargetPosition = nil
local lockOnMonster = nil -- ตัวแปรไว้ใช้ล็อกบนหัวมอน

-- หามอนสเตอร์
local function findMonster(name)
    for _, folder in pairs(monsterFolders) do
        for _, v in pairs(folder:GetChildren()) do
            if v.Name == name and v:FindFirstChild("HumanoidRootPart") then
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    if _G.AutoFarmLV then
                        v.HumanoidRootPart.Anchored = true
                    end
                    return v.HumanoidRootPart
                end
            end
        end
    end
end

-- รับเควส + เลือกเป้าหมาย
local function checkPlayerLevel()
    local level = player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("lvl") and player.PlayerStats.lvl.Value
    if not level or level <= 0 then return end

    if level <= 9 then 
        currentTargetMonster = "Soldier [Lv. 1]"
        questName = "Kill 4 Soldiers"
        currentTargetPosition = CFrame.new(-1975, 49, -4560)
    elseif level <= 19 then 
        currentTargetMonster = "Clown Pirate [Lv. 10]"
        questName = "Kill 5 Clown Pirates"
        currentTargetPosition = CFrame.new(-1792, 50, -4442)
    elseif level <= 29 then 
        currentTargetMonster = "Smoky [Lv. 20]"
        questName = "Kill 1 Smokys"
        currentTargetPosition = CFrame.new(-2101, 49, -4715)
    elseif level <= 49 then
        currentTargetMonster = "Tashi [Lv. 30]"
        questName = "Kill 1 Tashi"
        currentTargetPosition = CFrame.new(-2321, 50, -4514)
    elseif level <= 100 then
        currentTargetMonster = "Pusst [Lv. 50]"
        questName = "Kill 1 Pusst"
        currentTargetPosition = CFrame.new(-693, 65, -3470)
    else
        return
    end

    local args = {
        [1] = "take",
        [2] = questName
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest"):InvokeServer(unpack(args))
end

-- ปลด Anchor มอนสเตอร์
local function unlockMonsters()
    for _, folder in pairs(monsterFolders) do
        for _, v in pairs(folder:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") then
                v.HumanoidRootPart.Anchored = false
            end
        end
    end
end

-- วาร์ปไปยืนบนหัวมอน และล็อกไว้
local function lockOnTopOfMonster(monsterPart)
    lockOnMonster = monsterPart
end

-- อัปเดตตำแหน่งตัวละครไปยืนบนหัวมอนแบบล็อกค้าง
local function stayOnTopLoop()
    while task.wait(0.1) do
        if _G.AutoFarmLV and lockOnMonster and lockOnMonster:IsDescendantOf(workspace) then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local offset = Vector3.new(0, 5, 0)
                local headPos = lockOnMonster.Position + offset
                local cf = CFrame.new(headPos, lockOnMonster.Position)
                char:SetPrimaryPartCFrame(cf)
            end
        else
            lockOnMonster = nil -- ยกเลิกถ้าไม่ได้เปิดฟาร์ม
        end
    end
end

-- เริ่ม loop ล็อกบนหัว
task.spawn(stayOnTopLoop)

-- ลูปหลัก
while task.wait(1) do
    pcall(function()
        if _G.AutoFarmLV then
            checkPlayerLevel()
            local foundMonster = findMonster(currentTargetMonster)

            if foundMonster then
                lockOnTopOfMonster(foundMonster) -- ล็อกไว้บนหัว
            else
                player.Character:SetPrimaryPartCFrame(currentTargetPosition) -- วาร์ปไปจุดเกิดมอน
            end
        else
            unlockMonsters()
        end
    end)
end
