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
	Fast = 0.01,
	Medium = 0.5,
	Slow = 1
}

local currentTarget = nil -- เก็บเป้าหมายปัจจุบัน

-- UI Setup
local Window = OrionLib:MakeWindow({
	Name = "Auto Attack UI V1",
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

-- ฟังก์ชันตรวจสอบว่ามอนสเตอร์ยังมีชีวิตอยู่ไหม
local function isTargetValid(target)
	if not target or not target.Parent then
		return false
	end
	
	local humanoid = target:FindFirstChild("Humanoid")
	local targetRoot = target:FindFirstChild("HumanoidRootPart")
	
	-- ตรวจสอบว่ามี Humanoid และ HumanoidRootPart และยังมีชีวิต
	if not humanoid or not targetRoot or humanoid.Health <= 0 then
		return false
	end
	
	return true
end

RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if autoAttackEnabled and tick() - lastAttackTime >= attackDelay then
		-- ตรวจสอบเป้าหมายปัจจุบันก่อน
		if currentTarget and isTargetValid(currentTarget) then
			local targetRoot = currentTarget.HumanoidRootPart
			-- เช็คระยะ ถ้าเกิน ATTACK_RADIUS ให้ลบเป้าหมาย
			if (targetRoot.Position - root.Position).Magnitude <= ATTACK_RADIUS then
				attack(CFrame.new(targetRoot.Position))
				lastAttackTime = tick()
			else
				currentTarget = nil -- เป้าหมายห่างเกิน ล้างเป้าหมาย
			end
		else
			-- เป้าหมายตายหรือไม่มี ให้หาใหม่ทันที
			currentTarget = nil
			for _, model in ipairs(workspace:GetChildren()) do
				if model ~= char and isTargetValid(model) then
					local targetRoot = model.HumanoidRootPart
					if (targetRoot.Position - root.Position).Magnitude <= ATTACK_RADIUS then
						currentTarget = model
						-- โจมตีทันทีที่เจอเป้าหมายใหม่
						attack(CFrame.new(targetRoot.Position))
						lastAttackTime = tick()
						break
					end
				end
			end
		end
	end

	if showRangeEnabled and attackRangePart then
		attackRangePart.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, math.rad(90))
	end
end)
