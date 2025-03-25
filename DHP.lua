-- Load the DrRay library from the GitHub repository Library
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

-- Create a new window and set its title and theme
local window = DrRayLibrary:Load("King Legacy Autofarm", "Default")

-- Create the Main tab
local mainTab = DrRayLibrary.newTab("Main", "ImageIdHere")

-- MOBS List
local mobs = {}
getgenv().mob = nil 
getgenv().autoAttack = false
getgenv().autofarmmobs = false

-- Fetch Mobs from the game
for _,v in pairs(game:GetService("Workspace").Monster.Mon:GetChildren()) do
    if not table.find(mobs, v.Name) then
        table.insert(mobs, v.Name)
    end
end

-- Dropdown to select the mob
mainTab.newDropdown("Choose Mob", "Select the mob to autofarm", mobs, function(v)
    getgenv().mob = v
end)

-- Function to check if player is alive
local function isPlayerAlive()
    local player = game.Players.LocalPlayer
    return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

-- Function to wait until player respawns
local function waitForRespawn()
    local player = game.Players.LocalPlayer
    while not isPlayerAlive() do wait(1) end
    wait(1) -- Give extra time for the character to load
end

-- Function to move the player behind the selected mob without delay
local function moveBehindMob(mob)
    if mob and mob:FindFirstChild("HumanoidRootPart") then
        -- Calculate the position behind the mob
        local mobPos = mob.HumanoidRootPart.Position
        local player = game.Players.LocalPlayer.Character
        if player and player:FindFirstChild("HumanoidRootPart") then
            -- Move the player instantly behind the mob (2 units behind)
            player.HumanoidRootPart.CFrame = CFrame.new(mobPos - mob.HumanoidRootPart.CFrame.LookVector * 2)
        end
    end
end

-- Toggle for Auto Farm
mainTab.newToggle("Start Mob Farm", "Automatically farm mobs", false, function(v)
    getgenv().autofarmmobs = v
    while getgenv().autofarmmobs do
        if not isPlayerAlive() then
            waitForRespawn()
        end
        if not getgenv().mob then 
            game.StarterGui:SetCore("SendNotification", {
                Title = "!! FAIL !!", 
                Text = "Please choose your MOBS",
                Duration = 2.5
            })
            getgenv().autofarmmobs = false
            return
        end
        local mob = game:GetService("Workspace").Monster.Mon:FindFirstChild(getgenv().mob)
        if not mob then
            game.StarterGui:SetCore("SendNotification", { 
                Title = "Info!",
                Text = "There are no spawned mobs of this type!\nWait for them to spawn", 
                Duration = 2.5
            })
            repeat wait() until game:GetService("Workspace").Monster.Mon:FindFirstChild(getgenv().mob) ~= nil
        else
            while getgenv().autofarmmobs do
                if not isPlayerAlive() then
                    waitForRespawn()
                end
                mob = game:GetService("Workspace").Monster.Mon:FindFirstChild(getgenv().mob)
                if not mob then break end
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health == 0 then
                    wait(0.1)
                    mob:Destroy()
                    break
                end
                -- Move the player instantly behind the mob
                moveBehindMob(mob)
                wait(0.5)
            end
        end
    end
end)

-- Toggle for Auto Attack
mainTab.newToggle("Auto Attack", "Toggles automatic attacking", false, function(v)
    getgenv().autoAttack = v
    while getgenv().autoAttack do
        if not isPlayerAlive() then
            waitForRespawn()
        end
        local args = {
            [1] = "FS_None_M1"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Chest"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SkillAction"):InvokeServer(unpack(args))
        wait(0.5)
    end
end)

-- Update Mobs List
local function updateMobs()
    table.clear(mobs)
    for _, v in pairs(game:GetService("Workspace").Monster.Mon:GetChildren()) do
        if not table.find(mobs, v.Name) then
            table.insert(mobs, v.Name)
        end
    end
end

game:GetService("Workspace").Monster.Mon.ChildAdded:Connect(updateMobs)
game:GetService("Workspace").Monster.Mon.ChildRemoved:Connect(updateMobs)
