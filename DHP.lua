local character = workspace:FindFirstChild("GlandCD") -- ตัวละครของคุณ
local enemiesFolder = workspace:FindFirstChild("NightEnemies") -- โฟลเดอร์เก็บมอน

if character and enemiesFolder then
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        -- ลบโหมดอมตะ (เอาออก)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.HealthChanged:Connect(function()
                humanoid.Health = humanoid.MaxHealth -- รีเซ็ตเลือดให้เต็มเสมอ
            end)
        end
        
        -- สร้างกำแพงใต้เท้าของตัวละครเพื่อป้องกันการโจมตี
        local function createBarrier()
            local barrier = Instance.new("Part")
            barrier.Size = Vector3.new(5, 1, 5) -- ขนาดกำแพงใต้เท้า
            barrier.Position = humanoidRootPart.Position - Vector3.new(0, 2.5, 0) -- ใต้เท้า
            barrier.Anchored = true
            barrier.CanCollide = true
            barrier.Transparency = 0.5 -- โปร่งใส (ดูผ่านได้)
            barrier.BrickColor = BrickColor.new("Bright red") -- สีแดง
            barrier.Parent = workspace
        end
        
        -- ทำให้ตัวละครลอยไปหามอน
        while true do
            -- ค้นหามอนทั้งหมดในโฟลเดอร์
            local enemies = enemiesFolder:GetChildren()

            for _, enemy in pairs(enemies) do
                local enemyHumanoid = enemy:FindFirstChildOfClass("Humanoid")
                local enemyRootPart = enemy:FindFirstChild("HumanoidRootPart")

                if enemyHumanoid and enemyRootPart then
                    -- คำนวณทิศทางที่ต้องการเคลื่อนที่ไปยังมอน
                    local direction = (enemyRootPart.Position - humanoidRootPart.Position).unit
                    local distance = (enemyRootPart.Position - humanoidRootPart.Position).magnitude

                    -- ลอยไปหามอน
                    while distance > 2 do
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(direction * 3) -- ปรับความเร็วที่นี่ (0.5 คือความเร็วในการเคลื่อนที่)
                        wait(0.1) -- หน่วงเวลาเล็กน้อย
                        distance = (enemyRootPart.Position - humanoidRootPart.Position).magnitude
                    end

                    -- ไปยืนบนหัวมอน
                    humanoidRootPart.CFrame = CFrame.new(enemyRootPart.Position + Vector3.new(0, 10, 0))

                    -- สร้างกำแพงใต้เท้าเพื่อป้องกันการโจมตีจากมอน
                    createBarrier()

                    -- รอ 2 วินาทีก่อนจะไปหามอนตัวถัดไป
                    wait(2)
                end
            end

            -- หน่วงเวลาเล็กน้อยก่อนวนใหม่
            wait(1)
        end
    end
end
