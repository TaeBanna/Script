local air = Instance.new("ScreenGui")
local ScreenGuiHIDESHOW = Instance.new("ScreenGui")
local miniHIDESHOW = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local ScreenGui555 = Instance.new("ScreenGui")
local Creator = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Creator_2 = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local Main = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")

-- Properties:

air.Name = "air"
air.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
air.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGuiHIDESHOW.Name = "ScreenGuiHIDESHOW"
ScreenGuiHIDESHOW.Parent = air
ScreenGuiHIDESHOW.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

miniHIDESHOW.Name = "miniHIDESHOW"
miniHIDESHOW.Parent = ScreenGuiHIDESHOW
miniHIDESHOW.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
miniHIDESHOW.BorderColor3 = Color3.fromRGB(0, 0, 0)
miniHIDESHOW.BorderSizePixel = 0
miniHIDESHOW.Position = UDim2.new(0.476092309, 0, 0.0718582869, 0)
miniHIDESHOW.Size = UDim2.new(0, 43, 0, 40)
miniHIDESHOW.Image = "rbxassetid://74722061366512"

UICorner.CornerRadius = UDim.new(0, 50)
UICorner.Parent = miniHIDESHOW

ScreenGui555.Name = "ScreenGui555"
ScreenGui555.Parent = air
ScreenGui555.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Creator.Name = "Creator"
Creator.Parent = ScreenGui555
Creator.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
Creator.BorderColor3 = Color3.fromRGB(0, 0, 0)
Creator.BorderSizePixel = 0
Creator.Position = UDim2.new(0.431780696, 0, 0.157085553, 0)
Creator.Size = UDim2.new(0.135037139, 0, 0.0782754049, 0)

UICorner_2.CornerRadius = UDim.new(0, 20)
UICorner_2.Parent = Creator

Creator_2.Name = "Creator"
Creator_2.Parent = Creator
Creator_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Creator_2.BackgroundTransparency = 1.000
Creator_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Creator_2.BorderSizePixel = 0
Creator_2.Position = UDim2.new(0.0730769485, 0, 0.0426985435, 0)
Creator_2.Size = UDim2.new(0.848896265, 0, 0.896669447, 0)
Creator_2.Font = Enum.Font.SourceSans
Creator_2.Text = "By.TaeBanna"
Creator_2.TextColor3 = Color3.fromRGB(220, 97, 187)
Creator_2.TextSize = 24.000

UICorner_3.CornerRadius = UDim.new(0, 20)
UICorner_3.Parent = Creator_2

Main.Name = "Main"
Main.Parent = ScreenGui555
Main.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.249381661, 0, 0.24899736, 0)
Main.Size = UDim2.new(0.5, 0, 0.5, 0)

UICorner_4.CornerRadius = UDim.new(0, 20)
UICorner_4.Parent = Main

-- สร้างปุ่มใหม่ใน Main
local NewButton = Instance.new("TextButton")
local UICorner_NewButton = Instance.new("UICorner")

-- ตั้งค่าปุ่มใหม่ใน Main
NewButton.Name = "NewButton"
NewButton.Parent = Main
NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
NewButton.BorderSizePixel = 0
NewButton.Position = UDim2.new(0.25, 0, 0.25, 0)
NewButton.Size = UDim2.new(0.5, 0, 0.1, 0)
NewButton.Font = Enum.Font.SourceSans
NewButton.Text = "เก็บของ"
NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
NewButton.TextSize = 20

UICorner_NewButton.CornerRadius = UDim.new(0, 10)
UICorner_NewButton.Parent = NewButton

-- เพิ่มฟังก์ชันการเก็บของ
local pickupEnabled = false
local pickupDistance = 20
local scanning = false
local heartbeatConnection
local runtimeItems = workspace:WaitForChild("RuntimeItems")
local player = game.Players.LocalPlayer
local playerCharacter = player.Character or player.CharacterAdded:Wait()
local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local function scanAndPickUpItems()
    if not pickupEnabled or scanning then return end
    scanning = true

    local itemsToPickUp = {}
    for _, item in ipairs(runtimeItems:GetChildren()) do
        if item:IsA("Model") and item.PrimaryPart then
            local distance = (item.PrimaryPart.Position - playerHumanoidRootPart.Position).magnitude
            if distance <= pickupDistance then
                table.insert(itemsToPickUp, item)
            end
        end
    end

    if #itemsToPickUp > 0 then
        local args = {}
        for i = 1, math.min(5, #itemsToPickUp) do
            table.insert(args, itemsToPickUp[i])
        end
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(unpack(args))
        task.wait(0.1)
    end
    task.wait(0.1)
    scanning = false
end

-- ฟังก์ชันเปิด/ปิดการเก็บของ
local function togglePickupEnabled()
    pickupEnabled = not pickupEnabled
    if pickupEnabled then
        heartbeatConnection = RunService.Heartbeat:Connect(scanAndPickUpItems)
    else
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
    end
end

-- เมื่อคลิกปุ่มใหม่
NewButton.MouseButton1Click:Connect(function()
    togglePickupEnabled()
    if pickupEnabled then
        NewButton.Text = "หยุดเก็บของ"
    else
        NewButton.Text = "เก็บของ"
    end
end)

-- Scripts for miniHIDESHOW (Existing part)
local function MVNCYPE_fake_script() -- miniHIDESHOW.ToggleScreenGuiVisibility 
    local script = Instance.new('LocalScript', miniHIDESHOW)

    local button = script.Parent
    local screenGui555 = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("air"):WaitForChild("ScreenGui555")
    
    button.MouseButton1Click:Connect(function()
        screenGui555.Enabled = not screenGui555.Enabled
    end)
end
coroutine.wrap(MVNCYPE_fake_script)()
