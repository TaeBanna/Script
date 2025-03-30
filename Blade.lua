-- Ghost Gui UI Library
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/UI-Library/refs/heads/main/Ghost%20Gui'))()

game.CoreGui.GhostGui.MainFrame.Title.Text = "Gupro"

-- สร้างฟังก์ชัน shared เพื่อเริ่มการท้าทาย
shared.StartChallenge = function()
    while true do
        local args = {
            [1] = 1
        }
        
        -- ส่งคำสั่ง Re_ChallengeStart
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Fight"):WaitForChild("Re_ChallengeStart"):FireServer(unpack(args))
        wait(1)
    end
end

-- สร้างฟังก์ชัน AutoFight ใน shared
shared.AutoFight = function(state)
    if state then  -- ถ้า state เป็น true, เปิดการทำงานของ Autofight
        while true do
            for i = 1, 7 do
                local npcName = "Npc" .. string.format("%03d", i) -- สร้างชื่อ NPC จาก Npc001, Npc002, ...
                local args = {
                    [1] = npcName,
                    [2] = 2
                }

                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Fight"):WaitForChild("Re_TakeDamage"):FireServer(unpack(args))
            end
            wait(0.1)  -- หน่วงเวลาเล็กน้อยเพื่อไม่ให้ฟังก์ชันทำงานเร็วเกินไป
        end
    end
end

-- สร้างฟังก์ชัน shared.ChallengeFinish เพื่อเปิด/ปิดการใช้งาน Rf_ChallengeFinish
local challengeFinishConnection
shared.ChallengeFinish = function(state)
    if state then
        -- เปิดการทำงานของ Rf_ChallengeFinish
        challengeFinishConnection = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Fight"):WaitForChild("Rf_ChallengeFinish").OnClientEvent:Connect(function()
            shared.StartChallenge()  -- เรียกฟังก์ชัน StartChallenge ใหม่เมื่อ Rf_ChallengeFinish ถูกเรียก
        end)
    else
        -- ปิดการทำงานของ Rf_ChallengeFinish โดยการยกเลิกการเชื่อมต่อ
        if challengeFinishConnection then
            challengeFinishConnection:Disconnect()
            challengeFinishConnection = nil  -- รีเซ็ตตัวแปร
        end
    end
end

-- สร้าง UI Switch สำหรับเปิด/ปิด AutoFight
AddContent("Switch", "Enable AutoFight", [[
    spawn(function()
        shared.StartChallenge()  -- เริ่มการท้าทาย
        shared.AutoFight(true)   -- เปิดการทำงานของ AutoFight
        shared.ChallengeFinish(true)  -- เปิดใช้งาน Rf_ChallengeFinish
    end)
]], [[
    -- สคริปต์ปิดการทำงานของ AutoFight
    shared.AutoFight(false)  -- ปิดการทำงานของ AutoFight
    shared.ChallengeFinish(false)  -- ปิดการใช้งาน Rf_ChallengeFinish
]])

-- สร้าง TextLabel สำหรับแสดงข้อความ
TextLabel = AddContent("Yo")
TextLabel.Text = "AutoFight & Challenge Control"
