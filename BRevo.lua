local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local ATTACK_RADIUS = 30
local autoAttackEnabled = false
local showRangeEnabled = false
local attackRangePart
local attackDelay = 0.01
local lastAttackTime = 0

local speedMap = {
	Fast = 0.01,
	Medium = 0.5,
	Slow = 1
}

local currentTarget = nil
local connection

-- UI Setup (OrionLib) - ขนาดเล็กลง
local Window = OrionLib:MakeWindow({
	Name = "Auto Attack V1",
	HidePremium = true,
	SaveConfig = false,
	IntroEnabled = false,
	IntroText = "",
	Size = UDim2.new(0, 350, 0, 280)
})

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local SettingsTab = Window:MakeTab({
	Name = "Settings",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Toggle Auto Attack
Tab:AddToggle({
	Name = "Auto Attack Near",
	Default = false,
	Callback = function(v)
		autoAttackEnabled = v
		if not v then
			currentTarget = nil
		end
	end
})

-- Toggle แสดงระยะโจมตี
Tab:AddToggle({
	Name = "Show Range",
	Default = false,
	Callback = function(v)
		showRangeEnabled = v
		if v then
			if not attackRangePart then
				attackRangePart = Instance.new("Part")
				attackRangePart.Name = "AttackRange"
				attackRangePart.Anchored = true
				attackRangePart.CanCollide = false
				attackRangePart.Transparency = 0.3
				attackRangePart.Size = Vector3.new(0.2, ATTACK_RADIUS * 2, ATTACK_RADIUS * 2)
				attackRangePart.Shape = Enum.PartType.Cylinder
				attackRangePart.Material = Enum.Material.Neon
				attackRangePart.Color = Color3.fromRGB(255, 0, 100)
				attackRangePart.Parent = workspace
			end
		else
			if attackRangePart then
				attackRangePart:Destroy()
				attackRangePart = nil
			end
		end
	end
})

-- Dropdown ความเร็ว
Tab:AddDropdown({
	Name = "Attack Speed",
	Default = "Fast",
	Options = {"Fast", "Medium", "Slow"},
	Callback = function(selection)
		attackDelay = speedMap[selection]
	end
})

-- Dropdown ความโปรงใสของระยะ
Tab:AddDropdown({
	Name = "Range Transparency",
	Default = "Medium",
	Options = {"Clear", "Medium", "Solid"},
	Callback = function(selection)
		if attackRangePart then
			if selection == "Clear" then
				attackRangePart.Transparency = 0.7
			elseif selection == "Medium" then
				attackRangePart.Transparency = 0.3
			elseif selection == "Solid" then
				attackRangePart.Transparency = 0.1
			end
		end
	end
})

-- ปุ่มปิดสคริปต์
SettingsTab:AddButton({
	Name = "Close Script",
	Callback = function()
		-- หยุดการทำงานทั้งหมด
		autoAttackEnabled = false
		showRangeEnabled = false
		currentTarget = nil
		
		-- ลบ connection
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		-- ลบ attack range part
		if attackRangePart then
			attackRangePart:Destroy()
			attackRangePart = nil
		end
		
		-- ปิด UI
		OrionLib:Destroy()
	end    
})

-- ฟังก์ชันโจมตี (ปรับปรุงความเสถียร)
local function attack(cframe)
	local success, err = pcall(function()
		local service = ReplicatedStorage:FindFirstChild("Packages")
		if service then
			service = service:FindFirstChild("Knit")
			if service then
				service = service:FindFirstChild("Services")
				if service then
					service = service:FindFirstChild("MonsterService")
					if service then
						service = service:FindFirstChild("RF")
						if service then
							service = service:FindFirstChild("RequestAttack")
							if service then
								service:InvokeServer(cframe)
							end
						end
					end
				end
			end
		end
	end)
	
	if not success and err then
		warn("Attack failed:", err)
	end
end

-- ฟังก์ชันตรวจสอบเป้าหมาย (ปรับปรุงประสิทธิภาพ)
local function isTargetValid(target)
	if not target or not target.Parent then
		return false
	end
	
	-- ตรวจสอบว่าไม่ใช่ player
	if Players:GetPlayerFromCharacter(target) then
		return false
	end
	
	local humanoid = target:FindFirstChildOfClass("Humanoid")
	local targetRoot = target:FindFirstChild("HumanoidRootPart")
	
	return humanoid and targetRoot and humanoid.Health > 0
end

-- ฟังก์ชันหาเป้าหมายใกล้ที่สุด (ปรับปรุงประสิทธิภาพ)
local function findNearestTarget(playerRoot)
	local nearestTarget = nil
	local shortestDistance = ATTACK_RADIUS
	
	for _, model in ipairs(workspace:GetChildren()) do
		if model ~= player.Character and isTargetValid(model) then
			local targetRoot = model:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local distance = (targetRoot.Position - playerRoot.Position).Magnitude
				if distance <= shortestDistance then
					nearestTarget = model
					shortestDistance = distance
				end
			end
		end
	end
	
	return nearestTarget
end

-- Main Loop (ปรับปรุงให้เสถียรและประหยัดทรัพยากร)
connection = RunService.Heartbeat:Connect(function()
	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	-- อัปเดตการแสดงระยะโจมตี
	if showRangeEnabled and attackRangePart then
		attackRangePart.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, math.rad(90))
	end

	-- Auto Attack Logic
	if autoAttackEnabled and tick() - lastAttackTime >= attackDelay then
		-- ตรวจสอบเป้าหมายปัจจุบัน
		if currentTarget and isTargetValid(currentTarget) then
			local targetRoot = currentTarget:FindFirstChild("HumanoidRootPart")
			if targetRoot and (targetRoot.Position - root.Position).Magnitude <= ATTACK_RADIUS then
				attack(CFrame.new(targetRoot.Position))
				lastAttackTime = tick()
			else
				currentTarget = nil
			end
		else
			-- หาเป้าหมายใหม่
			currentTarget = findNearestTarget(root)
			if currentTarget then
				local targetRoot = currentTarget:FindFirstChild("HumanoidRootPart")
				if targetRoot then
					attack(CFrame.new(targetRoot.Position))
					lastAttackTime = tick()
				end
			end
		end
	end
end)
