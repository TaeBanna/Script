--// Services
local UserInputService = game:GetService("UserInputService");

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TaeBanna/Script/main/Assets/Main.lua"))()
local Window = Library:CreateWindow({
    Title = "BannaHub1",
    Theme = "Light",
    Size = UDim2.fromOffset(570, 260),
    Transparency = 0.2,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.LeftAlt
})

local createChatSideToggle = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/TaeBanna/Script/main/Assets/ToggleChatSide1.lua"
))()

local toggleApi = createChatSideToggle({
    Window = Window,
    position = UDim2.new(0, 55, 0.449999988, -132)
})


local Themes = {
    Light = {
        Primary = Color3.fromRGB(232, 232, 232),
        Secondary = Color3.fromRGB(255, 255, 255),
        Component = Color3.fromRGB(245, 245, 245),
        Interactables = Color3.fromRGB(235, 235, 235),
        Tab = Color3.fromRGB(50, 50, 50),
        Title = Color3.fromRGB(0, 0, 0),
        Description = Color3.fromRGB(100, 100, 100),
        Shadow = Color3.fromRGB(255, 255, 255),
        Outline = Color3.fromRGB(210, 210, 210),
        Icon = Color3.fromRGB(100, 100, 100),
    },
    Dark = {
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40),
        Interactables = Color3.fromRGB(45, 45, 45),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240,240,240),
        Description = Color3.fromRGB(200,200,200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220),
    },
    Void = {
        Primary = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(20, 20, 20),
        Component = Color3.fromRGB(25, 25, 25),
        Interactables = Color3.fromRGB(30, 30, 30),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240,240,240),
        Description = Color3.fromRGB(200,200,200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220),
    },
}

-- ตั้งธีมเริ่มต้น
Window:SetTheme(Themes.Dark)

-- Sections
Window:AddTabSection({ Name = "Main", Order = 1 })
Window:AddTabSection({ Name = "Settings", Order = 2 })

-- Tab Main
local Main = Window:AddTab({
    Title = "Components",
    Section = "Main",
    Icon = "rbxassetid://11963373994"
})

Window:AddSection({ Name = "ขอให้สนุก", Tab = Main })

Window:AddParagraph({
    Title = "Paragraph",
    Description = "Insert any important text here.",
    Tab = Main
})

-- ตัวแปรเก็บเกาะที่เลือก
local SelectedIsland = nil

-- เก็บตำแหน่งเดิม
local SavedPosition = nil

Window:AddButton({
    Title = "claim compass",
    Tab = Main,
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- เซฟตำแหน่งปัจจุบัน
        SavedPosition = hrp.CFrame

        -- วาปไปจุดเคลม
        hrp.CFrame = CFrame.new(1547, 264, 2132)

        -- ยิง event claim (อันนี้สำคัญ)
        local args = { "Claim1" }
        game.ReplicatedStorage:WaitForChild("Connections"):WaitForChild("Claim_Sam"):FireServer(unpack(args))

        -- ดีเลย์นิดหน่อยแล้วกลับจุดเดิม
        task.delay(1, function()
            if hrp and SavedPosition then
                hrp.CFrame = SavedPosition
                Window:Notify({
                    Title = "Claim Compass",
                    Description = "Compass claimed and returned to original position!",
                    Duration = 5
                })
            end
        end)
    end,
})


-- Dropdown เลือกเกาะ
Window:AddDropdown({
    Title = "Select Island",
    Description = "Choose where to teleport",
    Tab = Main,
    Options = {
        ["Island1"] = "A",
        ["Island2"] = "B",
        ["sam10k"] = "C",
        ["spawn1"] = "D",
        ["spawn2"] = "E",
        ["spawn3"] = "F",
        ["bubble"] = "G",
        ["Moon"] = "H",
        ["Purple"] = "I",
        ["treeTall"] = "J",
        ["MoutanRock"] = "K",
        ["smallIslandrock"] = "L",
        ["sandisland"] = "M",
        ["snowsmall"] = "N",
        ["snowbig"] = "O",
        ["treeangryisland"] = "P",

    },
    Callback = function(Value)
        SelectedIsland = Value
        warn("Selected Island: " .. Value)
    end,
})

-- ปุ่ม TP island
Window:AddButton({
    Title = "TP island",
    Tab = Main,
    Callback = function()
        if not SelectedIsland then
            Window:Notify({
                Title = "Error",
                Description = "Please select an island first!",
                Duration = 5
            })
            return
        end

        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- พิกัดของแต่ละเกาะ
        local IslandPositions = {
            A = CFrame.new(786, 216, -1349),
            B = CFrame.new(-1260, 216, 597),
            C = CFrame.new(1453, 263, 2092),
            D = CFrame.new(-127, 216, -779),
            E = CFrame.new(-237, 226, -1108),
            F = CFrame.new(720, 241, 1192),
            G = CFrame.new(4483, 217, 5459),
            H = CFrame.new(3202, 357, 1655),
            I = CFrame.new(-5192, 518, -7778),
            J = CFrame.new(-5852, 216, -220),
            K = CFrame.new(2028, 300, -480),
            L = CFrame.new(-28, 229, 2151),
            M = CFrame.new(1028, 224, -3344),
            N = CFrame.new(-1881, 230, 3339),
            O = CFrame.new(6232, 539, -1232),
            P = CFrame.new(1033, 217, 3386),
        }

        -- ถ้ามีพิกัดตรงกับที่เลือก
        if IslandPositions[SelectedIsland] then
            hrp.CFrame = IslandPositions[SelectedIsland]
            Window:Notify({
                Title = "Teleport",
                Description = "Teleported to island: " .. SelectedIsland,
                Duration = 5
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "No position set for island: " .. SelectedIsland,
                Duration = 5
            })
        end
    end,
})


-- Tab Settings
local Keybind = nil
local Settings = Window:AddTab({
    Title = "Settings",
    Section = "Settings",
    Icon = "rbxassetid://11293977610",
})

Window:AddKeybind({
    Title = "Minimize Keybind",
    Description = "Set the keybind for Minimizing",
    Tab = Settings,
    Callback = function(Key)
        Window:SetSetting("Keybind", Key)
    end,
})

Window:AddDropdown({
    Title = "Set Theme",
    Description = "Set the theme of the library!",
    Tab = Settings,
    Options = {
        ["Light Mode"] = "Light",
        ["Dark Mode"] = "Dark",
        ["Extra Dark"] = "Void",
    },
    Callback = function(Theme)
        Window:SetTheme(Themes[Theme])
    end,
})

Window:AddToggle({
    Title = "UI Blur",
    Description = "If enabled, must have your Roblox graphics set to 8+ for it to work",
    Default = true,
    Tab = Settings,
    Callback = function(Boolean)
        Window:SetSetting("Blur", Boolean)
    end,
})

Window:AddSlider({
    Title = "UI Transparency",
    Description = "Set the transparency of the UI",
    Tab = Settings,
    AllowDecimals = true,
    MaxValue = 1,
    Callback = function(Amount)
        Window:SetSetting("Transparency", Amount)
    end,
})

Window:Notify({
    Title = "Hello World!",
    Description = "Press Left Alt to Minimize and Open the tab!",
    Duration = 10
})

