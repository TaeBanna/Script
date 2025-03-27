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
                        humanoid.RootPart.Anchored = true 
                    end
                    return v.HumanoidRootPart
                end
            end
        end
    end
    return nil -- ถ้าไม่พบมอนสเตอร์
end

-- ฟังก์ชันเช็ค Level และเลือกมอนสเตอร์พร้อมรับเควส
local function checkPlayerLevel()
    local level = player.PlayerStats and player.PlayerStats.lvl and player.PlayerStats.lvl.Value
    if not level or level <= 0 then return end
    
    local targetMonster, questName, targetPosition
    
    -- กำหนดค่าตามระดับเลเวล
    if level == 1 or level <= 9 then 
        targetMonster, questName, targetPosition = "Soldier [Lv. 1]", "Kill 4 Soldiers", CFrame.new(-1975, 49, -4560)
    elseif level == 10 or level <= 19 then 
        targetMonster, questName, targetPosition = "Clown Pirate [Lv. 10]", "Kill 5 Clown Pirates", CFrame.new(-1792, 50, -4442)
    elseif level == 20 or level <= 29 then 
        targetMonster, questName, targetPosition = "Smoky [Lv. 20]", "Kill 1 Smokys", CFrame.new(-2101, 49, -4715)
    elseif level == 30 or level <= 100 then
        targetMonster, questName, targetPosition = "Tashi [Lv. 30]", "Kill 1 Tashi", CFrame.new(-2321, 50, -4514)
    elseif level == 101 or level <= 200 then
        targetMonster, questName, targetPosition = "Pusst [Lv. 50]", "Kill 1 Pusst", CFrame.new(-693, 65, -3470)
    end
    
    local args = {
        [1] = "take",
        [2] = questName
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest"):InvokeServer(unpack(args))
    
    -- วาร์ปไปหามอนสเตอร์หรือจุดเกิด
    if game:GetService("ReplicatedStorage"):FindFirstChild(targetMonster) then
        topos(game:GetService("ReplicatedStorage"):FindFirstChild(targetMonster).HumanoidRootPart.CFrame * CFrame.new(0, 0, 6))
    else    
        topos(targetPosition)
    end
end

-- ฟังก์ชันปลดล็อกมอนสเตอร์
local function unlockMonsters()
    if not _G.AutoFarmLV then
        for _, folder in pairs(monsterFolders) do
            for _, v in pairs(folder:GetChildren()) do
                local humanoid = v:FindFirstChildOfClass("Humanoid")
                if humanoid then 
                    humanoid.RootPart.Anchored = false 
                end
            end
        end
    end
end

-- ลูปทำงานฟาร์ม
while task.wait(1) do
    pcall(function ()
        if _G.AutoFarmLV then
            checkPlayerLevel()
        else
            unlockMonsters()
        end
    end)
end
