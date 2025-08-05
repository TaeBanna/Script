local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local ATTACK_RADIUS = 30
local autoAttackEnabled = false
local showRangeEnabled = false
local attackRangePart
local attackDelay = 1 -- default = slow
local lastAttackTime = 0

-- ตารางแปลงความเร็วแบบคำเป็นตัวเลข
local speedMap = {
	Fast = 0.1,
	Medium = 0.5,
	Slow = 1
}

-- UI Setup
local Window = OrionLib:MakeWindow({
	Name = "Auto Attack UI", 
	HidePremium = true, 
	SaveConfig = false
})

local Tab = Window:MakeTab({
	Name = "Main", 
	Icon = "rbxassetid://4483345998", 
	PremiumOnly = false
})

Tab:AddToggle({
	Name = "โจมตีอัตโนมัติ รอบๆตัว",
	Default = false,
	Callback = function(v) 
		autoAttackEnabled = v 
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
	Default = "Slow",
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
		for _, model in ipairs(workspace:GetChildren()) do
			local targetRoot = model:FindFirstChild("HumanoidRootPart")
			if targetRoot and (targetRoot.Position - root.Position).Magnitude <= ATTACK_RADIUS then
				attack(CFrame.new(targetRoot.Position))
				lastAttackTime = tick()
				-- ถ้าต้องการโจมตีทุกตัวในรอบเดียวให้ลบ break ออก
				-- แต่ถ้าต้องการโจมตีทีละตัวให้มี break
				break
			end
		end
	end
	
	if showRangeEnabled and attackRangePart then
		attackRangePart.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, math.rad(90))
	end
end)
