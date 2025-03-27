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
                    if _G.AutoFarmLV then humanoid.RootPart.Anchored = true end
                    return v.HumanoidRootPart
                end
            end
        end
    end
end

-- ฟังก์ชันเช็ค Level และเลือกมอนสเตอร์พร้อมรับเควส
local function checkPlayerLevel()
    local level = player.PlayerStats and player.PlayerStats.lvl and player.PlayerStats.lvl.Value
    if not level or level <= 0 then return end
    
    local targetMonster, questName
    if level <= 10 then 
        targetMonster, questName = "Soldier [Lv. 1]", "Kill 4 Soldiers"
    elseif level <= 20 then 
        targetMonster, questName = "Clown Pirate [Lv. 10]", "Kill 5 Clown Pirates"
    elseif level <= 30 then 
        targetMonster, questName = "Smoky [Lv. 20]", "Kill 1 Smokys"
    elseif level <= 40 then
        targetMonster, questName = "Pirate Captain [Lv. 30]", "Kill 7 Pirate Captains"
    end
    
    -- รับเควส
    local args = {
        [1] = "take",
        [2] = questName
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest"):InvokeServer(unpack(args))
    
    -- หาและวาร์ปไปที่มอนสเตอร์
    local monster = findMonster(targetMonster)
    if monster then
        player.Character:SetPrimaryPartCFrame(monster.CFrame * CFrame.new(0, 0, 6))
    end
end

-- ฟังก์ชันปลดล็อกมอนสเตอร์
local function unlockMonsters()
    if not _G.AutoFarmLV then
        for _, folder in pairs(monsterFolders) do
            for _, v in pairs(folder:GetChildren()) do
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.RootPart.Anchored = false end
            end
        end
    end
end

-- ตัวอย่างการใช้งาน
while task.wait() do
    if _G.AutoFarmLV then
        pcall(checkPlayerLevel)
    else
        unlockMonsters()
    end
end
