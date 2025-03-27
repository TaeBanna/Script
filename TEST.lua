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
    
    local targetMonster, questName
    local targetPosition -- ใช้สำหรับเก็บตำแหน่งของมอนสเตอร์หรือจุดที่ผู้เล่นจะวาร์ปไป

    -- กำหนดค่าตามระดับเลเวล
    if level <= 10 then 
        targetMonster, questName = "Soldier [Lv. 1]", "Kill 4 Soldiers"
        targetPosition = CFrame.new(-1975, 49, -4560) -- วาร์ปไปที่ตำแหน่ง Mon Lv. 1
    elseif level <= 20 then 
        targetMonster, questName = "Clown Pirate [Lv. 10]", "Kill 5 Clown Pirates"
        targetPosition = CFrame.new(-1792, 50, -4442) -- วาร์ปไปที่ตำแหน่ง
    elseif level <= 30 then 
        targetMonster, questName = "Smoky [Lv. 20]", "Kill 1 Smokys"
        targetPosition = CFrame.new(-2101, 49, -4715) -- วาร์ปไปที่ตำแหน่ง
    elseif level <= 40 then
        targetMonster, questName = "Tashi [Lv. 30]", "Kill 1 Tashi"
        targetPosition = CFrame.new(-2321, 50, -4514) -- วาร์ปไปที่ตำแหน่ง
    elseif level <= 50 then
        targetMonster, questName = "Pusst [Lv. 50]", "Kill 1 Pusst"
        targetPosition = CFrame.new(-693, 65, -3470) -- วาร์ปไปที่ตำแหน่ง
    end

    -- วาร์ปไปยังตำแหน่งมอนสเตอร์ก่อน
    if targetPosition then
        player.Character:SetPrimaryPartCFrame(targetPosition)
    end
    
    -- รับเควส
    local args = {
        [1] = "take",
        [2] = questName
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest"):InvokeServer(unpack(args))

    -- หามอนสเตอร์หลังจากรับเควส
    function farmMonsters()
        local monster = findMonster(targetMonster)
        if monster then
            -- ฟาร์มมอนสเตอร์ที่เจอ
            -- เพิ่มโค้ดการโจมตีหรือฟาร์มมอนสเตอร์ที่ต้องการที่นี่
        else
            -- ถ้าไม่เจอมอนสเตอร์ให้วาร์ปไปยังตำแหน่งที่กำหนด
            player.Character:SetPrimaryPartCFrame(targetPosition)
        end
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

-- ตัวอย่างการใช้งานในลูป
while task.wait(1) do
    pcall(function ()
        if _G.AutoFarmLV then
            checkPlayerLevel()  -- เช็คระดับของผู้เล่น และหามอนสเตอร์
            farmMonsters()      -- เรียกฟังก์ชันฟาร์มมอนสเตอร์
        else
            unlockMonsters()    -- ปลดล็อกมอนสเตอร์
        end
    end)
end
