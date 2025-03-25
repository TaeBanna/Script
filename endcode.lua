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

    -- กำหนด args ก่อนใช้งาน (ต้องเปลี่ยนค่าตามที่ต้องการ)
    local args = {}

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
            local head = enemy.Head
            local distance = (head.Position - rootPart.Position).Magnitude
            if distance <= 100 then -- ตรวจสอบว่าศัตรูอยู่ในระยะ 60 หน่วย
                pcall(function()
                    head:SetAttribute("Hidden", true)
                end)

                -- เรียกใช้งาน RegisterHit
                success, err = pcall(function()
                    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit"):FireServer(unpack(args))
                end)

                if not success then
                    print("Error in RegisterHit:", err)
                    return
                end
            end
        end
    end
end

-- Loop ค้นหาศัตรู
while task.wait() do
    for _, v in pairs(workspace:FindFirstChild("Enemies"):GetChildren()) do
        if v.Name == "Bandit" then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            if hrp then
                TP(hrp.CFrame * CFrame.new(0, 10, 0))
                FastAttack()
            end
        end
    end
end
