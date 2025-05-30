-- ตั้งค่า
_G.ENABLED = not _G.ENABLED
print("Bot Enabled:", _G.ENABLED)

_G.IGNORE_BOSSES = true
_G.WEAPON = "Combat"

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

local Chest = ReplicatedStorage:WaitForChild("Chest")
local Remotes = Chest:WaitForChild("Remotes")
local Modules = Chest:WaitForChild("Modules")
local Functions = Remotes:WaitForChild("Functions")

local QuestManager = require(Modules["QuestManager"])

-- ตัวช่วย
local function getRoot(char) return char:FindFirstChild("HumanoidRootPart") end
local function getHum(char) return char:FindFirstChild("Humanoid") end

local AttackCooldown = 0
local LastPos = {}

-- ข้อมูลเควสแยกเป็นตาราง
local QuestList = {
    {min = 0, max = 9, name = "Kill 4 Soldiers"},
    {min = 10, max = 19, name = "Kill 5 Clown Pirates"},
    {min = 20, max = 29, name = "Kill 1 Smoky"},
    {min = 30, max = 599, name = "SCRIPT BY ALPHES"} -- เปลี่ยนเป็นเควสจริง
}

-- ฟังก์ชันหลัก
local function getCurrentQuest()
    local lvl = LocalPlayer.PlayerStats.lvl.Value
    for _, q in ipairs(QuestList) do
        if lvl >= q.min and lvl <= q.max then
            local mob = QuestManager[q.name].Mob
            return {
                Quest = q.name,
                Monster = mob,
                IsBoss = QuestManager[q.name].Ammount == 1
            }
        end
    end
end

local function takeQuest(name)
    Functions["Quest"]:InvokeServer("take", name)
end

local function attack()
    if tick() >= AttackCooldown then
        AttackCooldown = tick() + 0.15
        Functions["SkillAction"]:InvokeServer("FS_None_M1")
    end
end

local function teleport(pos)
    local root = getRoot(LocalPlayer.Character)
    if root then root.CFrame = pos end
end

local function equipWeapon(name)
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == name then
            getHum(LocalPlayer.Character):EquipTool(tool)
            return
        end
    end
end

local function getEntities(monsterNames)
    local targets = {}
    for _, folder in pairs(workspace.Monster:GetChildren()) do
        for _, entity in pairs(folder:GetChildren()) do
            if entity:FindFirstChild("HumanoidRootPart") and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0 then
                if table.find(monsterNames, entity.Name) then
                    table.insert(targets, entity)
                    LastPos[entity.Name] = entity.HumanoidRootPart.CFrame
                end
            end
        end
    end
    return targets
end

-- ทำงานวนลูป
equipWeapon(_G.WEAPON)

while _G.ENABLED do
    task.wait()

    pcall(function()
        local currentQuest = getCurrentQuest()
        if not currentQuest then return end

        if LocalPlayer.CurrentQuest.Value == "" then
            takeQuest(currentQuest.Quest)
            return
        end

        local mobs = getEntities({currentQuest.Monster})
        if #mobs > 0 then
            teleport(mobs[1].HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(270), 0, 0))
            attack()
        elseif LastPos[currentQuest.Monster] then
            teleport(CFrame.new(LastPos[currentQuest.Monster].Position + Vector3.new(0, 60, 0)))
        end
    end)
end
