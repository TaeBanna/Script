-- ฟังก์ชัน TP (Teleports to a position)
function TP(Pos)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = Pos
    end
end

-- ฟังก์ชัน FastAttack (โจมตีอัตโนมัติ)
function FastAttack()
    local ReplicatedStorage = game.ReplicatedStorage
    local player = game.Players.LocalPlayer 
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- เรียกใช้งาน RegisterAttack
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer()
    end)
    if not success then
        print("Error in RegisterAttack:", err)
        return
    end    

    -- ตรวจสอบศัตรู
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return end
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Head") then
            local head = enemy.Head
            local distance = (head.Position - rootPart.Position).Magnitude
            if distance <= 60 then -- ตรวจสอบว่าศัตรูอยู่ในระยะ 60 หน่วย
                pcall(function()
                    head:SetAttribute("Hidden", true)
                end)

                -- เรียกใช้งาน RegisterHit
                success, err = pcall(function()
                    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit"):FireServer()
                end)

                if not success then
                    print("Error in RegisterHit:", err)
                    return
                end
            end
        end
    end
end

_G.AutoFarm = true  

while task.wait() do
    pcall(function() 
        if _G.AutoFarm then
            local enemiesFolder = workspace:FindFirstChild("Enemies")
            if enemiesFolder then
                for _, v in pairs(enemiesFolder:GetChildren()) do
                    if v.Name == "Bandit" then
                        local humanoid = v:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            repeat 
                                task.wait()
                                if v.Name == "Bandit" then
                                    TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0))  -- เทเลพอร์ตไปหาศัตรู
                                    FastAttack()  -- โจมตีศัตรู
                                end
                            until not _G.AutoFarm or v.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end
    end) 
end
