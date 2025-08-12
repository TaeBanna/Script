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

local Opened = true -- สถานะเริ่มต้นเปิด

local function Close()
    if Opened then
        Window.Visible = false
        Opened = false
    else
        Window.Visible = true
        Opened = true
    end
end

-- โหลดปุ่มแล้วส่งฟังก์ชัน Close เข้าไป
local createChatSideToggle = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/TaeBanna/Script/main/Assets/ToggleChatSide1.lua"
))()

createChatSideToggle({
    CloseFunction = Close, -- ส่งฟังก์ชันเข้าไปตรงๆ
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

Window:AddSection({ Name = "Non Interactable", Tab = Main })
Window:AddParagraph({
    Title = "Paragraph",
    Description = "Insert any important text here.",
    Tab = Main
})


Window:AddButton({
    Title = "sellCrypto",
    Tab = Main,
    Callback = function()
        local args = {
            "All"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("SellCrypto"):FireServer(unpack(args))
        
        -- แจ้งเตือน
        Window:Notify({
            Title = "SellCrypto",
            Description = "Sold all crypto successfully!",
            Duration = 5
        })
    end,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local toggleRunning = false

Window:AddToggle({
    Title = "Toggle",
    Description = "Switching",
    Tab = Main,
    Callback = function(Boolean)
        warn("Toggle state:", Boolean)
        toggleRunning = Boolean

        if toggleRunning then
            task.spawn(function()
                while toggleRunning do
                    local placedFolder = Players.LocalPlayer.PlayerData:WaitForChild("Placed")

                    for _, child in ipairs(placedFolder:GetChildren()) do
                        local uuid = child.Name -- ชื่อคือ UUID
                        local args = { uuid }

                        -- ส่ง Event ClaimCrypto
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("ClaimCrypto"):FireServer(unpack(args))
                        task.wait(0.1) -- เว้นระยะ 0.1 วินาที กันเซิร์ฟเวอร์รับไม่ทัน
                    end
                end
            end)
        end
    end,
})

Window:AddDropdown({
    Title = "Dropdown",
    Description = "Selecting",
    Tab = Main,
    Options = {
        ["An Option"] = "hi",
        ["And another"] = "hi",
        ["Another"] = "hi",
    },
    Callback = function(Number)
        warn(Number)
    end,
})

Window:AddKeybind({
    Title = "Keybind",
    Description = "Binding",
    Tab = Main,
    Callback = function(Key)
        warn("Key Set")
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

-- Keybind Example
UserInputService.InputBegan:Connect(function(Key)
    if Key == Keybind then
        warn("You have pressed the minimize keybind!");
    end
end)
