local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame") -- สร้าง Main ก่อน
local Highlight = Instance.new("TextButton")
local Pickup = Instance.new("TextButton")
local Drop = Instance.new("TextButton")
local UICorner_Highlight = Instance.new("UICorner")
local UICorner_Pickup = Instance.new("UICorner")
local UICorner_Drop = Instance.new("UICorner")

-- ตั้งค่า ScreenGui
ScreenGui.Name = "CustomGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ตั้งค่า Main (Frame)
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.Position = UDim2.new(0.5, -150, 0.5, -100)

-- Properties ของ Highlight
Highlight.Name = "Highlight"
Highlight.Parent = Main
Highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Highlight.Position = UDim2.new(0.1, 0, 0.1, 0)
Highlight.Size = UDim2.new(0, 200, 0, 50)
Highlight.Font = Enum.Font.SourceSans
Highlight.Text = "Highlight"
Highlight.TextColor3 = Color3.fromRGB(0, 0, 0)
Highlight.TextSize = 14

UICorner_Highlight.CornerRadius = UDim.new(0, 20)
UICorner_Highlight.Parent = Highlight

-- Properties ของ Pickup
Pickup.Name = "Pickup"
Pickup.Parent = Main
Pickup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pickup.Position = UDim2.new(0.1, 0, 0.4, 0)
Pickup.Size = UDim2.new(0, 200, 0, 50)
Pickup.Font = Enum.Font.SourceSans
Pickup.Text = "Pickup"
Pickup.TextColor3 = Color3.fromRGB(0, 0, 0)
Pickup.TextSize = 14

UICorner_Pickup.CornerRadius = UDim.new(0, 20)
UICorner_Pickup.Parent = Pickup

-- Properties ของ Drop
Drop.Name = "Drop"
Drop.Parent = Main
Drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Drop.Position = UDim2.new(0.1, 0, 0.7, 0)
Drop.Size = UDim2.new(0, 200, 0, 50)
Drop.Font = Enum.Font.SourceSans
Drop.Text = "Drop"
Drop.TextColor3 = Color3.fromRGB(0, 0, 0)
Drop.TextSize = 14

UICorner_Drop.CornerRadius = UDim.new(0, 20)
UICorner_Drop.Parent = Drop
