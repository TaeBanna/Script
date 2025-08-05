local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local ATTACK_RADIUS = 30
local targetName = "Apple"
local autoAttackEnabled = false
local showRangeEnabled = false
local attackRangePart
local attackDelay = 1 -- default
local lastAttackTime = 0

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

Tab:AddDropdown({
	Name = "เลือกมอนสเตอร์",
	Default = "Apple",
	Options = {"Apple"},
	Callback = function(v) 
		targetName = v 
	end
})

Tab:AddToggle({
	Name = "Auto Attack",
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

-- ✅ ใช้ Dropdown แทน Slider
Tab:AddDropdown({
	Name = "เลือกระยะเวลาการโจมตี",
	Default = "1",
	Options = {"0.1", "0.5", "0.75", "1"},
	Callback = function(v)
		attackDelay = tonumber(v)
		print("เปลี่ยนความเร็วการตีเป็น: " .. v .. " วินาที")
	end
})

-- ฟังก์ชันโจมตี
local function attack(cframe)
	pcall(function()
		ReplicatedStorage.Packages.Knit.Services.MonsterService.RF.RequestAttack:InvokeServer(cframe)
	end)
end

-- Loop หลัก
RunService.RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	-- Auto Attack
	if autoAttackEnabled and tick() - lastAttackTime >= attackDelay then
		for _, model in ipairs(workspace:GetChildren()) do
			if model.Name == targetName then
				local targetRoot = model:FindFirstChild("HumanoidRootPart")
				if targetRoot and (targetRoot.Position - root.Position).Magnitude <= ATTACK_RADIUS then
					attack(CFrame.new(targetRoot.Position))
					lastAttackTime = tick()
					break
				end
			end
		end
	end
	
	-- อัปเดตวงแสดงระยะ
	if showRangeEnabled and attackRangePart then
		attackRangePart.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, math.rad(90))
	end
end)
