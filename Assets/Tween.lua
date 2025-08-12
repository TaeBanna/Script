-- TweenTP.lua
-- ฟังก์ชันสำหรับ Tween ไปหาตำแหน่งหรือวัตถุใน Roblox
-- รองรับ Part, Model, Vector3, CFrame

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function TweenTP(target, speed)
    -- speed: studs ต่อวินาที (ค่าเริ่มต้น 300)
    speed = speed or 300
    if not target then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- หาตำแหน่งของเป้าหมาย
    local targetPos
    if typeof(target) == "Instance" then
        if target:IsA("Model") and target.PrimaryPart then
            targetPos = target.PrimaryPart.Position
        elseif target:IsA("BasePart") then
            targetPos = target.Position
        end
    elseif typeof(target) == "Vector3" then
        targetPos = target
    elseif typeof(target) == "CFrame" then
        targetPos = target.Position
    end
    if not targetPos then return end

    -- สร้าง Marker ไว้ให้ Tween ตาม
    local marker = Instance.new("Part")
    marker.Size = Vector3.new(0.5, 0.5, 0.5)
    marker.Anchored = true
    marker.CanCollide = false
    marker.Transparency = 1
    marker.CFrame = hrp.CFrame
    marker.Parent = workspace

    -- คำนวณระยะและเวลา
    local distance = (hrp.Position - targetPos).Magnitude
    local duration = distance / speed

    -- Tween Marker ไปยังเป้าหมาย
    local tween = TweenService:Create(marker, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(targetPos)
    })
    tween:Play()

    -- ให้ตัวเราตาม Marker
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if marker and hrp then
            hrp.CFrame = marker.CFrame
        end
    end)

    -- เมื่อ Tween เสร็จให้หยุด
    tween.Completed:Connect(function()
        if connection then connection:Disconnect() end
        hrp.CFrame = marker.CFrame
        marker:Destroy()
    end)
end

return TweenTP
