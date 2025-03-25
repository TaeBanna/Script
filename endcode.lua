function FastAttack()
    local ReplicatedStorage = game.ReplicatedStorage
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- ค่าที่จำเป็นสำหรับ args
    local args = {0.5}  -- ค่าที่ใช้ใน RegisterAttack

    -- เรียกใช้งาน RegisterAttack
    local success, err = pcall(function()
        local RegisterAttack = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE"):WaitForChild("RegisterAttack")
        RegisterAttack:FireServer(unpack(args))
    end)

    if not success then
        print("Error in RegisterAttack:", err)
        return
    end

    -- ตรวจสอบศัตรู
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then 
        print("Enemies folder not found")
        return 
    end
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Head") then
            local head = enemy:FindFirstChild("Head")
            if head then
                local distance = (head.Position - rootPart.Position).Magnitude  -- คำนวณระยะห่าง
                
                if distance <= 60 then -- ตรวจสอบว่าศัตรูอยู่ในระยะ 60 หน่วย
                    -- ตั้งค่า Hidden ให้กับหัวศัตรู
                    pcall(function()
                        head:SetAttribute("Hidden", true)
                    end)

                    -- เรียกใช้งาน RegisterHit
                    success, err = pcall(function()
                        local RegisterHit = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE"):WaitForChild("RegisterHit")
                        RegisterHit:FireServer(unpack(args))
                    end)

                    if not success then
                        print("Error in RegisterHit:", err)
                        return
                    end
                end
            end
        end
    end
end

while task.wait() do  -- เพิ่มการหน่วงเวลาเพื่อให้เกมไม่ทำงานหนักเกินไป
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Bandit" then
                FastAttack()
            end
        end
    end
end
