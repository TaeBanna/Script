_G.ENABLED = not _G.ENABLED 
print("Enabled:", _G.ENABLED)
_G.IGNORE_BOSSES = true -- ไม่สนใจบอส
_G.WEAPON = "Combat" -- อาวุธที่ใช้

-- สร้างตารางชื่อ Collection สำหรับเก็บฟังก์ชันและตัวแปรต่างๆ
local Collection = {}

Collection.AttackCooldown = 0 -- เวลาคูลดาวน์ของการโจมตี
Collection.Entity_Position = {} -- เก็บตำแหน่งของมอนสเตอร์

-- เรียกใช้งานบริการที่จำเป็น
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Chest = ReplicatedStorage:WaitForChild("Chest")
local Remotes = Chest:WaitForChild("Remotes")
local Modules = Chest:WaitForChild("Modules")
local Functions = Remotes:WaitForChild("Functions")

local QuestManager = require(Modules["QuestManager"])
local LocalPlayer = Players.LocalPlayer -- ผู้เล่นคนปัจจุบัน

-- ฟังก์ชันเพื่อหาวัตถุ Humanoid ของตัวละคร
function Collection:GetHum(Character)
	return Character:FindFirstChild("Humanoid")
end

-- ฟังก์ชันเพื่อหาวัตถุ HumanoidRootPart
function Collection:GetRoot(Character)
	return Character:FindFirstChild("HumanoidRootPart")
end

-- ฟังก์ชันวาร์ปผู้เล่นไปยังตำแหน่งที่กำหนด (CFrame) แบบเสถียรสุดโหด
function Collection:Teleport(_CFrame_)
	local Char = LocalPlayer.Character
	if not Char then return end

	local RootPart = Collection:GetRoot(Char)
	if not RootPart then return end

	if typeof(_CFrame_) ~= "CFrame" then
		warn("ตำแหน่งวาร์ปไม่ถูกต้อง (ไม่ใช่ CFrame)")
		return
	end

	local distance = (RootPart.Position - _CFrame_.Position).Magnitude

	-- ถ้าไกลมาก วาร์ปทันที (ป้องกันค้าง)
	if distance > 300 then
		RootPart.CFrame = _CFrame_
		return
	end

	-- ถ้าใกล้ ให้วาร์ปแบบ Tween ลื่นๆ
	local Goal = { CFrame = _CFrame_ }
	local Info = TweenInfo.new(0.25, Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(RootPart, Info, Goal)
	Tween:Play()
	Tween.Completed:Wait()
end

-- ตรวจสอบว่าผู้เล่นรับเควสอยู่หรือไม่
function Collection:IsQuest()
	return LocalPlayer.CurrentQuest.Value ~= ""
end

-- ฟังก์ชันรับเควส
function Collection:TakeQuest(Quest)
	Functions["Quest"]:InvokeServer("take", Quest)
end

-- ฟังก์ชันสวมใส่อาวุธตามชื่อ ToolTip
function Collection:EquipTool(ToolTip)
	local Backpack = LocalPlayer.Backpack:GetChildren()
	if #Backpack <= 0 then return "ไม่มีอะไรในกระเป๋าเลย" end

	local Humanoid = Collection:GetHum(LocalPlayer.Character)

	for _, Tool in pairs(Backpack) do
		if Tool:IsA("Tool") and Tool.ToolTip == ToolTip then
			Humanoid:EquipTool(Tool)
			break
		end
	end
	return "ไม่มีอาวุธที่มี ToolTip นี้"
end

-- ฟังก์ชันโจมตี
function Collection:Attack()
	if tick() >= Collection.AttackCooldown then
		Collection.AttackCooldown = tick() + 0.15
		task.spawn(function()
			Functions["SkillAction"]:InvokeServer("FS_None_M1")
		end)
	end
end

-- ฟังก์ชันเลือกเควสตามเลเวลของผู้เล่น
function Collection:GetLatestQuest()
	local Result_Data = {}
	local CurrestQuest = ""
	local Level = LocalPlayer.PlayerStats.lvl.Value

	if Level >= 0 and Level < 10 then
		CurrestQuest = "Kill 4 Soldiers"
	elseif Level >= 10 and Level < 20 then
		CurrestQuest = "Kill 5 Clown Pirates"
	elseif Level >= 20 and Level < 30 then
		CurrestQuest = "Kill 1 Smoky"
	elseif Level >= 30 and Level < 600 then
		CurrestQuest = "SCRIPT BY ALPHES" -- ควรใส่ชื่อเควสจริงตรงนี้
	end

	Result_Data = {
		Quest = CurrestQuest,
		Monster = QuestManager[CurrestQuest].Mob,
		IsBosses = QuestManager[CurrestQuest].Ammount == 1
	}

	return Result_Data
end

-- ฟังก์ชันดึงรายชื่อมอนสเตอร์ที่มีชีวิตจากพื้นที่ Monster
function Collection:GetEntities(Entities)
	local Included_Entities = {}

	for _, EntityFolder in pairs(workspace.Monster:GetChildren()) do
		for __, Entity in pairs(EntityFolder:GetChildren()) do
			if not table.find(Collection.Entity_Position, Entity.Name) and Entity:FindFirstChild("HumanoidRootPart") then
				Collection.Entity_Position[Entity.Name] = Entity.HumanoidRootPart.CFrame
			end
			if table.find(Entities, Entity.Name) and Entity.Humanoid.Health > 0 then
				table.insert(Included_Entities, Entity)
			end
		end
	end

	return Included_Entities
end

-- ลูปหลักของระบบอัตโนมัติ
while _G.ENABLED do task.wait()
	pcall(function()
		local AvailableQuest = Collection:IsQuest()
		local LatestQuest = Collection:GetLatestQuest()

		if AvailableQuest then
			local Entities = Collection:GetEntities({ LatestQuest.Monster })
			if #Entities > 0 then
				-- วาร์ปไปด้านบนของมอนสเตอร์แล้วโจมตี
				Collection:Teleport(Entities[1].HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(270), 0, 0))
				Collection:Attack()
			else
				-- ถ้าไม่เจอมอนสเตอร์ ให้วาร์ปไปตำแหน่งที่เคยบันทึกไว้
				if Collection.Entity_Position[LatestQuest.Monster] ~= nil then
					Collection:Teleport(CFrame.new(Collection.Entity_Position[LatestQuest.Monster].Position + Vector3.new(0, 60, 0)))
				end
			end
		else
			-- ถ้ายังไม่ได้รับเควส ให้รับเควสล่าสุด
			Collection:TakeQuest(LatestQuest.Quest)
		end
	end)
end
