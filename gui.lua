local air = Instance.new("ScreenGui")
local ScreenGuiHIDESHOW = Instance.new("ScreenGui")
local miniHIDESHOW = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local ScreenGui555 = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Creator = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local Creator_2 = Instance.new("TextLabel")
local UICorner_4 = Instance.new("UICorner")

-- ปุ่มที่เพิ่มเข้ามา
local Highlight = Instance.new("TextButton")
local Pickup = Instance.new("TextButton")
local Drop = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local UICorner_6 = Instance.new("UICorner")
local UICorner_7 = Instance.new("UICorner")

--Properties:
air.Name = "air"
air.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
air.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGuiHIDESHOW.Name = "ScreenGuiHIDESHOW"
ScreenGuiHIDESHOW.Parent = air
ScreenGuiHIDESHOW.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

miniHIDESHOW.Name = "miniHIDESHOW"
miniHIDESHOW.Parent = ScreenGuiHIDESHOW
miniHIDESHOW.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
miniHIDESHOW.Size = UDim2.new(0, 43, 0, 40)
miniHIDESHOW.Position = UDim2.new(0.477, 0, -0.021, 0)
miniHIDESHOW.Image = "rbxassetid://74722061366512"

UICorner.CornerRadius = UDim.new(0, 50)
UICorner.Parent = miniHIDESHOW

ScreenGui555.Name = "ScreenGui555"
ScreenGui555.Parent = air
ScreenGui555.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = ScreenGui555
Main.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
Main.Position = UDim2.new(0.249, 0, 0.249, 0)
Main.Size = UDim2.new(0.5, 0, 0.5, 0)

UICorner_2.CornerRadius = UDim.new(0, 20)
UICorner_2.Parent = Main

-- ปุ่ม Highlight
Highlight.Name = "Highlight"
Highlight.Parent = Main
Highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Highlight.Position = UDim2.new(0.295, 0, 0.064, 0)
Highlight.Size = UDim2.new(0, 200, 0, 50)
Highlight.Text = "Highlight"
Highlight.TextColor3 = Color3.fromRGB(0, 0, 0)

UICorner_5.CornerRadius = UDim.new(0, 20)
UICorner_5.Parent = Highlight

-- ปุ่ม Pickup
Pickup.Name = "Pickup"
Pickup.Parent = Main
Pickup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pickup.Position = UDim2.new(0.295, 0, 0.277, 0)
Pickup.Size = UDim2.new(0, 200, 0, 50)
Pickup.Text = "Pickup"
Pickup.TextColor3 = Color3.fromRGB(0, 0, 0)

UICorner_6.CornerRadius = UDim.new(0, 20)
UICorner_6.Parent = Pickup

-- ปุ่ม Drop
Drop.Name = "Drop"
Drop.Parent = Main
Drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Drop.Position = UDim2.new(0.295, 0, 0.488, 0)
Drop.Size = UDim2.new(0, 200, 0, 50)
Drop.Text = "Drop"
Drop.TextColor3 = Color3.fromRGB(0, 0, 0)

UICorner_7.CornerRadius = UDim.new(0, 20)
UICorner_7.Parent = Drop

Creator.Name = "Creator"
Creator.Parent = ScreenGui555
Creator.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
Creator.Position = UDim2.new(0.431, 0, 0.157, 0)
Creator.Size = UDim2.new(0.135, 0, 0.078, 0)

UICorner_3.CornerRadius = UDim.new(0, 20)
UICorner_3.Parent = Creator

Creator_2.Name = "Creator"
Creator_2.Parent = Creator
Creator_2.BackgroundTransparency = 1.000
Creator_2.Position = UDim2.new(0.073, 0, 0.042, 0)
Creator_2.Size = UDim2.new(0.848, 0, 0.896, 0)
Creator_2.Text = "By.TaeBanna"
Creator_2.TextColor3 = Color3.fromRGB(220, 97, 187)
Creator_2.TextSize = 24.000

UICorner_4.CornerRadius = UDim.new(0, 20)
UICorner_4.Parent = Creator_2

-- Scripts:
local function ToggleScreenGui() 
    local script = Instance.new('LocalScript', miniHIDESHOW)
    local button = script.Parent
    local screenGui555 = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("air"):WaitForChild("ScreenGui555")
    
    button.MouseButton1Click:Connect(function()
        screenGui555.Enabled = not screenGui555.Enabled
    end)
end
coroutine.wrap(ToggleScreenGui)()

-- สคริปต์ของปุ่ม Highlight, Pickup และ Drop
Highlight.MouseButton1Click:Connect(function()
    print("Highlight button clicked!")
end)

Pickup.MouseButton1Click:Connect(function()
    print("Pickup button clicked!")
end)

Drop.MouseButton1Click:Connect(function()
    print("Drop button clicked!")
end)
