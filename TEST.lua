_G.AutoFarmLV = true
local player = game.Players.LocalPlayer
local monsterFolders = {workspace.Monster.Mon, workspace.Monster.Boss}

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
                    return v
                end
            end
        end
    end
end

-- เช็ค Level และกำหนดข้อมูลตามเลเวล
local function getTargetInfo()
    local level = player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("lvl") and player.PlayerStats.lvl.Value
    if not level or level <= 0 then return end

    if level <= 9 then 
        return "Soldier [Lv. 1]", "Kill 4 Soldiers", CFrame.new(-1975, 49, -4560)
    elseif level <= 19 then 
        return "Clown Pirate [Lv. 10]", "Kill 5 Clown Pirates", CFrame.new(-1792, 50, -4442)
    elseif level <= 29 then 
        return "Smoky [Lv. 20]", "Kill 1 Smokys", CFrame.new(-2101, 49, -4715)
    elseif level <= 49 then
        return "Tashi [Lv. 30]", "Kill 1 Tashi", CFrame.new(-2321, 50, -4514)
    elseif level <= 100 then
        return "Pusst [Lv. 50]", "Kill 1 Pusst", CFrame.new(-693, 65, -3470)
    else
        return nil
    end
end

-- รับเควส
local function takeQuest(questName)
    local args = {
        [1] = "take",
        [2] = questName
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest"):InvokeServer(unpack(args))
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

-- วาร์ปบนหัวมอนและหันหน้า
local function teleportAboveMonster(monster)
    local root = monster:FindFirstChild("HumanoidRootPart")
    if root and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local above = root.Position + Vector3.new(0, 5, 0)
        local cf = CFrame.new(above, root.Position)
        player.Character:SetPrimaryPartCFrame(cf)
    end
end

-- ลูปหลัก
while task.wait() do
    pcall(function()
        if not _G.AutoFarmLV then
            unlockMonsters()
            return
        end

        local targetMonster, questName, targetPosition = getTargetInfo()
        if not targetMonster then return end

        -- รับเควส
        takeQuest(questName)

        -- พยายามหามอน
        local monster = findMonster(targetMonster)

        if monster then
            teleportAboveMonster(monster)
            -- ตรงนี้คุณสามารถเพิ่มคำสั่งโจมตีหรือใช้สกิลได้ในอนาคต
        else
            -- ถ้าไม่เจอมอน วาร์ปไปจุดรอ
            player.Character:SetPrimaryPartCFrame(targetPosition)
        end
    end)
end
