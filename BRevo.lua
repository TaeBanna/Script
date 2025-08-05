local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local ATTACK_RADIUS = 30
local autoAttackEnabled = false
local showRangeEnabled = false
local attackRangePart
local attackDelay = 0.1 -- เริ่มต้น Fast
local lastAttackTime = 0

local speedMap = {
	Fast = 0.1,
	Medium = 0.5,
	Slow = 1
}

local currentTarget = nil -- เก็บเป้าหมายปัจจุบัน

-- UI Setup
local Window = OrionLib:MakeWindow({
	Name = "Auto Attack UI 0.1",
	HidePremium = true,
	SaveConfig = false
})

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddToggle({
	Name = "Auto Attack near",
	Default = false,
	Callback = function(v)
		autoAttackEnabled = v
		if not v then
			currentTarget = nil -- ปิด auto attack ล้างเป้าหมาย
		end
	end
})

Tab:AddToggle({
	Name = "แสดงระยะโจมตี",
	Default = false,
	Callback = function(v)
		showRangeEnabled = v
		if v then
			attackRangePart = Instance.new("Part")
			attackRangePart.Anchored = true
			attackRangePart.CanCollide = false
			attackRangePart.Transparency = 0.7
			attackRangePart.Size = Vector3.new(0.2, ATTACK_RADIUS * 2, ATTACK_RADIUS * 2)
			attackRangePart.Shape = Enum.PartType.Cylinder
			attackRangePart.Material = Enum.Material.Neon
			attackRangePart.Color = Color3.fromRGB(100, 150, 255)
			attackRangePart.Parent = workspace
		elseif attackRangePart then
			attackRangePart:Destroy()
			attackRangePart = nil
		end
	end
})

Tab:AddDropdown({
	Name = "เลือกระดับความเร็วการโจมตี",
	Default = "Fast",
	Options = {"Fast", "Medium", "Slow"},
	Callback = function(selection)
		attackDelay = speedMap[selection]
		print("เลือกความเร็วการตี:", selection, "(" .. tostring(attackDelay) .. " วินาที)")
	end
})

local function attack(cframe)
	pcall(function()
		ReplicatedStorage.Packages.Knit.Services.MonsterService.RF.RequestAttack:InvokeServer(cframe)
	end)
end

RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if autoAttackEnabled and tick() - lastAttackTime >= attackDelay then
		-- ตรวจสอบว่าเป้าหมายปัจจุบันยังอยู่ไหม
		if currentTarget and currentTarget.Parent and currentTarget:FindFirstChild("HumanoidRootPart") then
			local targetRoot = currentTarget.HumanoidRootPart
			-- เช็คระยะ ถ้าเกิน 30 stud ให้ลบเป้าหมาย เพื่อหาใหม่ในรอบหน้า
			if (targetRoot.Position - root.Position).Magnitude <= ATTACK_RADIUS then
				attack(CFrame.new(targetRoot.Position))
				lastAttackTime = tick()
			else
				currentTarget = nil -- เป้าหมายห่างเกิน ล้างเป้าหมาย
			end
		else
			-- หาเป้าหมายใหม่ในรัศมี 30 stud
			currentTarget = nil
			for _, model in ipairs(workspace:GetChildren()) do
				local targetRoot = model:FindFirstChild("HumanoidRootPart")
				if targetRoot and model ~= char and (targetRoot.Position - root.Position).Magnitude <= ATTACK_RADIUS then
					currentTarget = model
					break
				end
			end
		end
	end

	if showRangeEnabled and attackRangePart then
		attackRangePart.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, math.rad(90))
	end
end)
