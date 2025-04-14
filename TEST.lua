-- สคริปต์ Auto Farm วาปไปค้างบนหัว Monster ชื่อ Solder [Lv.1]

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local farming = true

-- ฟังก์ชัน teleport ตัวละครไปยังตำแหน่งที่ต้องการ
local function teleportToMonster(monster)
    player.Character.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0)
end

-- ฟังก์ชัน auto farm loop
local function autoFarm()
    while farming do
        for _, monster in pairs(game.Workspace.Monster.Mon:GetChildren()) do
            if monster.Name == "Solder [Lv.1]" and monster:FindFirstChild("HumanoidRootPart") then
                teleportToMonster(monster)
                wait(0.5) -- รอค้างไว้บนหัวมอนสเตอร์
            end
        end

        wait(1) -- พักการทำงานเล็กน้อยก่อนวนรอบใหม่
    end
end

-- เริ่มทำงาน auto farm
runService.Stepped:Connect(autoFarm)
