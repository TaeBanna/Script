_G.AutoFarmLV = true -- เปิดใช้งาน AutoFarm
local player = game.Players.LocalPlayer
local monsterFolders = {workspace.Monster.Mon, workspace.Monster.Boss}

-- ฟังก์ชันหามอนสเตอร์
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

-- ฟังก์ชันเช็ค Level และเลือกมอนสเตอร์พร้อมรับเควส
local function checkPlayerLevel()
    local level = player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("lvl") and player.PlayerStats.lvl.Value
    if not level or level <= 0 then return end

    local targetMonster, questName, targetPosition

    if level <= 9 then 
        targetMonster = "Soldier [Lv. 1]"
        questName = "Kill 4 Soldiers"
        targetPosition = CFrame.new(-1975, 49, -4560)
    elseif level <= 19 then 
        targetMonster = "Clown Pirate [Lv. 10]"
        questName = "Kill 5 Clown Pirates"
        targetPosition = CFrame.new(-1792, 50, -4442)
    elseif level <= 29 then 
        targetMonster = "Smoky [Lv. 20]"
        questName = "Kill 1 Smokys"
        targetPosition = CFrame.new(-2101, 49, -4715)
    elseif level <= 49 then
        targetMonster = "Tashi [Lv. 30]"
        questName = "Kill 1 Tashi"
        targetPosition = CFrame.new(-2321, 50, -4514)
    elseif level <= 100 then
        targetMonster = "Pusst [Lv. 50]"
        questName = "Kill 1 Pusst"
        targetPosition = CFrame.new(-693, 65, -3470)
    else
        return -- ยังไม่มีเควสสำหรับระดับที่สูงกว่านี้
    end

    -- รับเควส
    local args = {
        [1] = "take",
        [2] = questName
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest"):InvokeServer(unpack(args))

    -- ไปยังตำแหน่งเป้าหมาย
    player.Character:SetPrimaryPartCFrame(targetPosition)
end

-- ฟังก์ชันปลดล็อกมอนสเตอร์
local function unlockMonsters()
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
            checkPlayerLevel()
        else
            unlockMonsters()
        end
    end)
end
