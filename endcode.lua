function TP(Pos)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = Pos
    end
end


function FastAttack()
    local ReplicatedStorage = game.ReplicatedStorage
    local player = game.Players.LocalPlayer 
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

		
	    
    -- เรียกใช้งาน RegisterAttack
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(unpack(args))
    end)
    if not success then return end    

    -- ตรวจสอบศัตรู
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return end
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Head") then
            local head = enemy:FindFirstChild("Head")

            local distance = (head.Position - rootPart.Position).Magnitude
            if distance <= 60 then -- ตรวจสอบว่าศัตรูอยู่ในระยะ 60 หน่วย
                if head then
                    pcall(function()
                        head:SetAttribute("Hidden", true)
                    end)
                end

                -- เรียกใช้งาน RegisterHit
                success, err = pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit"):FireServer(unpack(args))
                end)

                if not success then
                    print("Error in RegisterHit:", err)
                    return
                end
            end
        end
    end
end


while task.wait() do  -- เพิ่มการหน่วงเวลาเพื่อให้เกมไม่ทำงานหนักเกินไป
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Bandit" then
                TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
		FastAttack()
            end
        end
    end
end
