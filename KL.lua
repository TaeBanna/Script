-- สคริปต์นี้ถูกเขียนเพื่อใช้ในการสอน และแจกในไลฟ์ช่อง Deity Hub : https://www.youtube.com/watch?v=gMPACbuQC5M

_G.ENABLED = not _G.ENABLED print("Enabled:", _G.ENABLED)
_G.IGNORE_BOSSES = true
_G.WEAPON = "Combat"


local Collection = {}

Collection.AttackCooldown = 0
Collection.Entity_Position = {}

local Players = game:GetService("Players")
local ReplicatedStorage =game:GetService("ReplicatedStorage")

local Chest = ReplicatedStorage:WaitForChild("Chest")
local Remotes = Chest:WaitForChild("Remotes")
local Modules = Chest:WaitForChild("Modules")
local Functions = Remotes:WaitForChild("Functions")


local QuestManager = require(Modules["QuestManager"])

local LocalPlayer = Players.LocalPlayer


function Collection:GetHum(Character)
    return Character:FindFirstChild("Humanoid")
end
function Collection:GetRoot(Character)
    return Character:FindFirstChild("HumanoidRootPart")
end
function Collection:Teleport(_Position_) -- Params of "_Position_" is a CFrame data type
    local RootPart = Collection:GetRoot(LocalPlayer.Character)
    RootPart.CFrame = _Position_
end
function Collection:IsQuest()
    return LocalPlayer.CurrentQuest.Value ~= ""
end
function Collection:TakeQuest(Quest)
   Functions["Quest"]:InvokeServer("take", Quest)
end
function Collection:EquipTool(ToolTip)
    local Backpack = LocalPlayer.Backpack:GetChildren()
    if #Backpack <= 0 then return "NO ANYTHING IN YOUR BACKPACK" end

    local Humanoid = Collection:GetHum(LocalPlayer.Character)

    for _, Tool in pairs(Backpack) do
        if Tool:IsA("Tool") and Tool.ToolTip == ToolTip then
            Humanoid:EquipTool(Tool)
            break
        end
    end
    return "NO TOOL WITH THIS TOOLTIP"
end

function Collection:Attack()
    if tick() >= Collection.AttackCooldown then
        Collection.AttackCooldown  = tick() + 0.15
        task.spawn(function()
            Functions["SkillAction"]:InvokeServer("FS_None_M1")
        end)
    end
end

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
        CurrestQuest = "SCRIPT BY ALPHES" -- PLACE A QUEST REMOTE HERE
    end

     Result_Data = {
        Quest = CurrestQuest,
        Monster = QuestManager[CurrestQuest].Mob,
        IsBosses = QuestManager[CurrestQuest].Ammount == 1
    }

    return Result_Data
end



function Collection:GetEntities(Entities) -- Pramram of "Entities" is a table data type
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



while _G.ENABLED do task.wait()
    pcall(function()
        local AvailableQuest = Collection:IsQuest()
        local LatestQuest = Collection:GetLatestQuest()

        if AvailableQuest then
            local Entities = Collection:GetEntities({ LatestQuest.Monster })
            if #Entities > 0 then -- Found entity
                Collection:Teleport(Entities[1].HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(270), 0, 0))
                Collection:Attack()
            else
                if Collection.Entity_Position[LatestQuest.Monster] ~= nil then
                    Collection:Teleport(CFrame.new(Collection.Entity_Position[LatestQuest.Monster].Position + Vector3.new(0, 60, 0)))
                end
            end
        else
            Collection:TakeQuest(LatestQuest.Quest)
        end
    end)
end







