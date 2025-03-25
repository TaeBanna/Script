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

    -- กำหนด args ตามตัวอย่างที่คุณให้มา
    local args = {
        [1] = {},  -- ตัวอย่างค่า
        [2] = {},         -- ตัวอย่างค่า
        [3] = workspace:WaitForChild("Enemies"):WaitForChild("Bandit"),  -- ตัวอย่างค่าตำแหน่ง
        [4] = {},                 -- ข้อมูลเพิ่มเติม (อาจไม่ต้องใช้)
        [6] = {}"          -- ตัวอย่างค่า
    }

    -- เรียกใช้งาน RegisterAttack
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("37"):FireServer(unpack(args))
    end)
    if not success then
        print("Error in FastAttack:", err)
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
