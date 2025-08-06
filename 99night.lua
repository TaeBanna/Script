-- BannaHub Script for 99 Nights In The Forest
-- Version 2.0 - Complete Remake
-- Created by: BannaHub Team

local BannaHub = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Configuration
local Config = {
    HubName = "🍌 BannaHub",
    GameName = "99 Nights In The Forest",
    Version = "v2.0",
    Theme = "AmberGlow",
    Discord = "https://discord.gg/bannnahub"
}

-- Create Main Window
local Window = BannaHub:CreateWindow({
    Name = Config.HubName .. " | " .. Config.GameName,
    Icon = "🍌",
    LoadingTitle = "BannaHub Loading...",
    LoadingSubtitle = "The Ultimate Forest Survival Tool",
    Theme = Config.Theme,
    
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BannaHub_Forest",
        FileName = "config"
    },
    
    Discord = {
        Enabled = true,
        Invite = "bannnahub",
        RememberJoins = true
    },
    
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- State Management
local State = {
    -- Player Features
    Flying = false,
    FlySpeed = 1,
    WalkSpeed = 16,
    InfiniteJump = false,
    Noclip = false,
    
    -- Visual Features
    ESP = {
        Items = false,
        Enemies = false,
        Children = false,
        PeltTrader = false,
        Distance = false
    },
    
    -- Game Features
    KillAura = false,
    KillAuraDistance = 50,
    AutoChopTree = false,
    AutoChopDistance = 30,
    InstantPrompt = false,
    NoFog = false,
    
    -- Connections
    Connections = {}
}

-- Utility Functions
local Utils = {}

function Utils.Notify(title, content, duration)
    BannaHub:Notify({
        Title = "🍌 " .. title,
        Content = content,
        Duration = duration or 3,
        Image = "info"
    })
end

function Utils.GetDistance(part1, part2)
    if not part1 or not part2 then return math.huge end
    return (part1.Position - part2.Position).Magnitude
end

function Utils.GetPlayerRootPart()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

function Utils.DragItem(item)
    if not item then return end
    ReplicatedStorage.RemoteEvents.RequestStartDraggingItem:FireServer(item)
    wait(0.001)
    ReplicatedStorage.RemoteEvents.StopDraggingItem:FireServer(item)
end

function Utils.CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        Utils.Notify("Copied!", "Text copied to clipboard")
    end
end

-- ESP System
local ESP = {}

function ESP.Create(object, color, text, parent, offset)
    if not object or object:FindFirstChild("BannaHub_ESP") then return end
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "BannaHub_ESP_Highlight"
    highlight.Adornee = object
    highlight.FillColor = color
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = object
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BannaHub_ESP"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, offset or 2, 0)
    billboard.Adornee = parent or object
    billboard.Parent = parent or object
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    -- Distance updater
    if State.ESP.Distance then
        spawn(function()
            while billboard and billboard.Parent and State.ESP.Distance do
                local rootPart = Utils.GetPlayerRootPart()
                if rootPart and parent then
                    local distance = Utils.GetDistance(rootPart, parent)
                    label.Text = text .. " [" .. math.floor(distance) .. "m]"
                end
                wait(0.1)
            end
        end)
    end
end

function ESP.Remove(object)
    if not object then return end
    
    local highlight = object:FindFirstChild("BannaHub_ESP_Highlight")
    local billboard = object:FindFirstChild("BannaHub_ESP")
    
    if highlight then highlight:Destroy() end
    if billboard then billboard:Destroy() end
end

function ESP.UpdateAll()
    -- Items ESP
    if State.ESP.Items then
        for _, item in pairs(Workspace.Items:GetChildren()) do
            if item:IsA("Model") and item.PrimaryPart then
                ESP.Create(item, Color3.fromRGB(255, 255, 0), item.Name, item.PrimaryPart)
            end
        end
    else
        for _, item in pairs(Workspace.Items:GetChildren()) do
            ESP.Remove(item)
        end
    end
    
    -- Characters ESP
    for _, char in pairs(Workspace.Characters:GetChildren()) do
        if char:IsA("Model") and char.PrimaryPart then
            local isChild = char.Name:find("Lost Child")
            local isPeltTrader = char.Name == "Pelt Trader"
            local isEnemy = not isChild and not isPeltTrader
            
            if State.ESP.Children and isChild then
                ESP.Create(char, Color3.fromRGB(0, 255, 0), char.Name, char.PrimaryPart)
            elseif State.ESP.PeltTrader and isPeltTrader then
                ESP.Create(char, Color3.fromRGB(0, 255, 255), char.Name, char.PrimaryPart)
            elseif State.ESP.Enemies and isEnemy then
                ESP.Create(char, Color3.fromRGB(255, 0, 0), char.Name, char.PrimaryPart)
            else
                ESP.Remove(char)
            end
        end
    end
end

-- Movement System
local Movement = {}

function Movement.ToggleFly(enabled)
    State.Flying = enabled
    
    if enabled then
        if UserInputService.TouchEnabled then
            Movement.StartMobileFly()
        else
            Movement.StartPCFly()
        end
    else
        Movement.StopFly()
    end
end

function Movement.StartPCFly()
    local rootPart = Utils.GetPlayerRootPart()
    if not rootPart then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    local bodyGyro = Instance.new("BodyGyro")
    
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new()
    bodyVelocity.Parent = rootPart
    
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.P = 3000
    bodyGyro.D = 500
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    local function updateMovement()
        if not State.Flying then return end
        
        local camera = Workspace.CurrentCamera
        local moveVector = Vector3.new()
        
        -- Get input
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveVector.Unit * State.FlySpeed * 50
        bodyGyro.CFrame = camera.CFrame
    end
    
    State.Connections.FlyUpdate = RunService.Heartbeat:Connect(updateMovement)
    
    -- F key toggle
    State.Connections.FlyToggle = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F then
            State.Flying = not State.Flying
            if not State.Flying then
                Movement.StopFly()
            end
        end
    end)
end

function Movement.StopFly()
    local rootPart = Utils.GetPlayerRootPart()
    if rootPart then
        local bodyVelocity = rootPart:FindFirstChild("BodyVelocity")
        local bodyGyro = rootPart:FindFirstChild("BodyGyro")
        
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
    
    if State.Connections.FlyUpdate then
        State.Connections.FlyUpdate:Disconnect()
    end
    if State.Connections.FlyToggle then
        State.Connections.FlyToggle:Disconnect()
    end
end

-- Combat System
local Combat = {}

function Combat.KillAura()
    local rootPart = Utils.GetPlayerRootPart()
    if not rootPart then return end
    
    local weapon = LocalPlayer.Inventory:FindFirstChild("Old Axe") or 
                  LocalPlayer.Inventory:FindFirstChild("Good Axe") or
                  LocalPlayer.Inventory:FindFirstChild("Strong Axe") or
                  LocalPlayer.Inventory:FindFirstChild("Chainsaw")
    
    if not weapon then return end
    
    for _, enemy in pairs(Workspace.Characters:GetChildren()) do
        if enemy:IsA("Model") and enemy.PrimaryPart then
            local distance = Utils.GetDistance(rootPart, enemy.PrimaryPart)
            if distance <= State.KillAuraDistance then
                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(
                    enemy, weapon, 999, rootPart.CFrame
                )
            end
        end
    end
end

function Combat.AutoChopTree()
    local rootPart = Utils.GetPlayerRootPart()
    if not rootPart then return end
    
    local weapon = LocalPlayer.Inventory:FindFirstChild("Old Axe") or 
                  LocalPlayer.Inventory:FindFirstChild("Good Axe") or
                  LocalPlayer.Inventory:FindFirstChild("Strong Axe") or
                  LocalPlayer.Inventory:FindFirstChild("Chainsaw")
    
    if not weapon then return end
    
    local function chopTrees(parent)
        for _, tree in pairs(parent:GetChildren()) do
            if tree:IsA("Model") and tree.PrimaryPart then
                local isTree = tree.Name == "Small Tree" or 
                              tree.Name == "TreeBig1" or 
                              tree.Name == "TreeBig2"
                
                if isTree then
                    local distance = Utils.GetDistance(rootPart, tree.PrimaryPart)
                    if distance <= State.AutoChopDistance then
                        ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(
                            tree, weapon, 999, rootPart.CFrame
                        )
                    end
                end
            end
        end
    end
    
    chopTrees(Workspace.Map.Foliage)
    chopTrees(Workspace.Map.Landmarks)
end

-- Item Collection System
local ItemCollection = {}

function ItemCollection.BringItems(filter)
    local rootPart = Utils.GetPlayerRootPart()
    if not rootPart then return end
    
    local count = 0
    for _, item in pairs(Workspace.Items:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local shouldBring = false
            
            if filter == "all" then
                shouldBring = true
            elseif type(filter) == "table" then
                shouldBring = table.find(filter, item.Name) ~= nil
            elseif type(filter) == "string" then
                shouldBring = item.Name == filter
            end
            
            if shouldBring then
                item.PrimaryPart.CFrame = rootPart.CFrame
                Utils.DragItem(item)
                count = count + 1
            end
        end
    end
    
    Utils.Notify("Items Collected", "Brought " .. count .. " items to you!")
end

-- Create Tabs
local HomeTab = Window:CreateTab("🏠 Home")
local PlayerTab = Window:CreateTab("👤 Player")
local VisualTab = Window:CreateTab("👁️ Visuals")
local CombatTab = Window:CreateTab("⚔️ Combat")
local ItemsTab = Window:CreateTab("📦 Items")
local TeleportTab = Window:CreateTab("🌐 Teleport")
local SettingsTab = Window:CreateTab("⚙️ Settings")

-- Home Tab
HomeTab:CreateParagraph({
    Title = "Welcome to BannaHub! 🍌",
    Content = "The most advanced script for 99 Nights In The Forest. Enjoy all features responsibly!"
})

local ServerInfo = HomeTab:CreateParagraph({
    Title = "Server Information",
    Content = "Loading..."
})

HomeTab:CreateButton({
    Name = "Join Discord Server",
    Callback = function()
        Utils.CopyToClipboard(Config.Discord)
    end
})

-- Player Tab
PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        State.WalkSpeed = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = "Speed",
    CurrentValue = 1,
    Flag = "FlySpeed",
    Callback = function(value)
        State.FlySpeed = value
    end
})

PlayerTab:CreateToggle({
    Name = "Fly (Press F to toggle)",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(value)
        Movement.ToggleFly(value)
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        State.InfiniteJump = value
        
        if value then
            State.Connections.InfiniteJump = UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Space and State.InfiniteJump then
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:ChangeState("Jumping")
                    end
                end
            end)
        else
            if State.Connections.InfiniteJump then
                State.Connections.InfiniteJump:Disconnect()
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(value)
        State.Noclip = value
        
        if value then
            State.Connections.Noclip = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if State.Connections.Noclip then
                State.Connections.Noclip:Disconnect()
            end
            
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Instant Prompts",
    CurrentValue = false,
    Flag = "InstantPrompt",
    Callback = function(value)
        State.InstantPrompt = value
        
        for _, prompt in pairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                if value then
                    prompt:SetAttribute("OriginalHoldDuration", prompt.HoldDuration)
                    prompt.HoldDuration = 0
                else
                    local original = prompt:GetAttribute("OriginalHoldDuration")
                    if original then
                        prompt.HoldDuration = original
                    end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Flag = "NoFog",
    Callback = function(value)
        State.NoFog = value
        
        if value then
            State.Connections.NoFog = RunService.Heartbeat:Connect(function()
                for _, boundary in pairs(Workspace.Map.Boundaries:GetChildren()) do
                    if boundary:IsA("Part") then
                        boundary:Destroy()
                    end
                end
            end)
        else
            if State.Connections.NoFog then
                State.Connections.NoFog:Disconnect()
            end
        end
    end
})

-- Visual Tab
VisualTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Flag = "ESPDistance",
    Callback = function(value)
        State.ESP.Distance = value
        ESP.UpdateAll()
    end
})

VisualTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Flag = "ItemESP",
    Callback = function(value)
        State.ESP.Items = value
        ESP.UpdateAll()
    end
})

VisualTab:CreateToggle({
    Name = "Enemy ESP",
    CurrentValue = false,
    Flag = "EnemyESP",
    Callback = function(value)
        State.ESP.Enemies = value
        ESP.UpdateAll()
    end
})

VisualTab:CreateToggle({
    Name = "Children ESP",
    CurrentValue = false,
    Flag = "ChildrenESP",
    Callback = function(value)
        State.ESP.Children = value
        ESP.UpdateAll()
    end
})

VisualTab:CreateToggle({
    Name = "Pelt Trader ESP",
    CurrentValue = false,
    Flag = "PeltTraderESP",
    Callback = function(value)
        State.ESP.PeltTrader = value
        ESP.UpdateAll()
    end
})

-- Combat Tab
CombatTab:CreateParagraph({
    Title = "Combat Requirements",
    Content = "Equip any axe or chainsaw for Kill Aura and Auto Chop Tree to work!"
})

CombatTab:CreateSlider({
    Name = "Kill Aura Range",
    Range = {10, 200},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 50,
    Flag = "KillAuraRange",
    Callback = function(value)
        State.KillAuraDistance = value
    end
})

CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(value)
        State.KillAura = value
        
        if value then
            State.Connections.KillAura = RunService.Heartbeat:Connect(function()
                if State.KillAura then
                    Combat.KillAura()
                end
            end)
        else
            if State.Connections.KillAura then
                State.Connections.KillAura:Disconnect()
            end
        end
    end
})

CombatTab:CreateSlider({
    Name = "Auto Chop Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 30,
    Flag = "AutoChopRange",
    Callback = function(value)
        State.AutoChopDistance = value
    end
})

CombatTab:CreateToggle({
    Name = "Auto Chop Trees",
    CurrentValue = false,
    Flag = "AutoChop",
    Callback = function(value)
        State.AutoChopTree = value
        
        if value then
            State.Connections.AutoChop = RunService.Heartbeat:Connect(function()
                if State.AutoChopTree then
                    Combat.AutoChopTree()
                end
            end)
        else
            if State.Connections.AutoChop then
                State.Connections.AutoChop:Disconnect()
            end
        end
    end
})

-- Items Tab
ItemsTab:CreateButton({
    Name = "🎯 Bring All Items",
    Callback = function()
        ItemCollection.BringItems("all")
    end
})

local itemCategories = {
    ["🔥 Fuel Items"] = {"Log", "Coal", "Fuel Canister", "Oil Barrel"},
    ["🔧 Scrap Items"] = {"Tyre", "Sheet Metal", "Broken Fan", "Bolt", "Old Radio", "UFO Junk", "UFO Scrap", "Broken Microwave"},
    ["🔫 Weapons & Ammo"] = {"Rifle", "Revolver", "Rifle Ammo", "Revolver Ammo"},
    ["🥕 Food Items"] = {"Cake", "Carrot", "Morsel", "Meat? Sandwich"},
    ["🩹 Medical Items"] = {"Bandage", "MedKit"},
    ["🛡️ Armor Items"] = {"Leather Body", "Iron Body"},
    ["💰 Valuable Items"] = {"Coin Stack", "Seed Box"}
}

for categoryName, items in pairs(itemCategories) do
    ItemsTab:CreateButton({
        Name = categoryName,
        Callback = function()
            ItemCollection.BringItems(items)
        end
    })
end

ItemsTab:CreateButton({
    Name = "👶 Bring All Children",
    Callback = function()
        local rootPart = Utils.GetPlayerRootPart()
        if not rootPart then return end
        
        local count = 0
        for _, child in pairs(Workspace.Characters:GetChildren()) do
            if child.Name:find("Lost Child") and child.PrimaryPart then
                child.PrimaryPart.CFrame = rootPart.CFrame
                count = count + 1
            end
        end
        Utils.Notify("Children Rescued", "Brought " .. count .. " children to safety!")
    end
})

-- Teleport Tab
TeleportTab:CreateButton({
    Name = "🔥 Teleport to Campfire",
    Callback = function()
        local rootPart = Utils.GetPlayerRootPart()
        if rootPart then
            rootPart.CFrame = Workspace.Map.Campground.MainFire.PrimaryPart.CFrame
            Utils.Notify("Teleported", "Warped to campfire!")
        end
    end
})

-- Settings Tab
SettingsTab:CreateDropdown({
    Name = "Theme Selection",
    Options = {"Default", "AmberGlow", "Amethyst", "Bloom", "DarkBlue", "Green", "Light", "Ocean", "Serenity"},
    CurrentOption = {Config.Theme},
    Flag = "Theme",
    Callback = function(option)
        Window.ModifyTheme(option[1])
    end
})

SettingsTab:CreateButton({
    Name = "🔄 Reload Configuration",
    Callback = function()
        BannaHub:LoadConfiguration()
        Utils.Notify("Configuration", "Settings reloaded!")
    end
})

SettingsTab:CreateButton({
    Name = "❌ Unload BannaHub",
    Callback = function()
        -- Clean up connections
        for _, connection in pairs(State.Connections) do
            if connection then connection:Disconnect() end
        end
        
        -- Remove all ESP
        for _, item in pairs(Workspace.Items:GetChildren()) do
            ESP.Remove(item)
        end
        for _, char in pairs(Workspace.Characters:GetChildren()) do
            ESP.Remove(char)
        end
        
        BannaHub:Destroy()
        Utils.Notify("BannaHub", "Successfully unloaded!")
    end
})

-- Initialize
Utils.Notify("BannaHub Loaded!", Config.Version .. " - Ready to use! 🍌", 5)

-- Update server info periodically
spawn(function()
    while BannaHub do
        local playerCount = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers
        local ping = math.floor(Players.LocalPlayer:GetNetworkPing() * 1000)
        
        ServerInfo:Set({
            Title = "🌐 Server Information",
            Content = string.format(
                "👥 Players: %d/%d\n📡 Ping: %dms\n🆔 Place ID: %s\n🔑 Job ID: %s",
                playerCount, maxPlayers, ping, game.PlaceId, game.JobId
            )
        })
        
        wait(5)
    end
end)

-- ESP Update Loop
spawn(function()
    while BannaHub do
        ESP.UpdateAll()
        wait(1)
    end
end)

-- Load saved configuration
BannaHub:LoadConfiguration()
