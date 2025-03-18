local air = Instance.new("ScreenGui")
local ScreenGuiHIDESHOW = Instance.new("ScreenGui")
local miniHIDESHOW = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local ScreenGui555 = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Highlight = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local UICorner_3 = Instance.new("UICorner")
local Pickup = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local Drop = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local Creator = Instance.new("Frame")
local UICorner_6 = Instance.new("UICorner")
local Creator_2 = Instance.new("TextLabel")
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
miniHIDESHOW.BorderColor3 = Color3.fromRGB(0, 0, 0)
miniHIDESHOW.BorderSizePixel = 0
miniHIDESHOW.Position = UDim2.new(0.477122813, 0, 0.0167112295, 0)
miniHIDESHOW.Size = UDim2.new(0, 43, 0, 40)
miniHIDESHOW.Image = "rbxassetid://74722061366512"

UICorner.CornerRadius = UDim.new(0, 50)
UICorner.Parent = miniHIDESHOW

ScreenGui555.Name = "ScreenGui555"
ScreenGui555.Parent = air
ScreenGui555.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = ScreenGui555
Main.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.249381661, 0, 0.24899736, 0)
Main.Size = UDim2.new(0.5, 0, 0.5, 0)

Highlight.Name = "Highlight"
Highlight.Parent = Main
Highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
Highlight.BorderSizePixel = 0
Highlight.Position = UDim2.new(0.294723809, 0, 0.0635026693, 0)
Highlight.Size = UDim2.new(0, 200, 0, 50)
Highlight.Font = Enum.Font.SourceSans
Highlight.TextColor3 = Color3.fromRGB(0, 0, 0)
Highlight.TextSize = 14.000

UICorner_2.CornerRadius = UDim.new(0, 20)
UICorner_2.Parent = Highlight

UICorner_3.CornerRadius = UDim.new(0, 20)
UICorner_3.Parent = Main

Pickup.Name = "Pickup"
Pickup.Parent = Main
Pickup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pickup.BorderColor3 = Color3.fromRGB(0, 0, 0)
Pickup.BorderSizePixel = 0
Pickup.Position = UDim2.new(0.294723809, 0, 0.277406394, 0)
Pickup.Size = UDim2.new(0, 200, 0, 50)
Pickup.Font = Enum.Font.SourceSans
Pickup.TextColor3 = Color3.fromRGB(0, 0, 0)
Pickup.TextSize = 14.000

UICorner_4.CornerRadius = UDim.new(0, 20)
UICorner_4.Parent = Pickup

Drop.Name = "Drop"
Drop.Parent = Main
Drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Drop.BorderColor3 = Color3.fromRGB(0, 0, 0)
Drop.BorderSizePixel = 0
Drop.Position = UDim2.new(0.294723809, 0, 0.487967908, 0)
Drop.Size = UDim2.new(0, 200, 0, 50)
Drop.Font = Enum.Font.SourceSans
Drop.TextColor3 = Color3.fromRGB(0, 0, 0)
Drop.TextSize = 14.000

UICorner_5.CornerRadius = UDim.new(0, 20)
UICorner_5.Parent = Drop

Creator.Name = "Creator"
Creator.Parent = ScreenGui555
Creator.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
Creator.BorderColor3 = Color3.fromRGB(0, 0, 0)
Creator.BorderSizePixel = 0
Creator.Position = UDim2.new(0.431780696, 0, 0.157085553, 0)
Creator.Size = UDim2.new(0.135037139, 0, 0.0782754049, 0)

UICorner_6.CornerRadius = UDim.new(0, 20)
UICorner_6.Parent = Creator

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

UICorner_7.CornerRadius = UDim.new(0, 20)
UICorner_7.Parent = Creator_2

-- Scripts:

local function DXXIS_fake_script() -- miniHIDESHOW.ToggleScreenGuiVisibility 
	local script = Instance.new('LocalScript', miniHIDESHOW)

	local button = script.Parent
	local screenGui555 = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("air"):WaitForChild("ScreenGui555")
	
	button.MouseButton1Click:Connect(function()
		screenGui555.Enabled = not screenGui555.Enabled
	end)
end
coroutine.wrap(DXXIS_fake_script)()

-- ปุ่มเลื่อนเปิด-ปิด
local function toggleHighlight()
	local script = Instance.new('LocalScript', Highlight)
	
	local button = script.Parent
	button.MouseButton1Click:Connect(function()
		Main.Visible = not Main.Visible
		Highlight.Text = Main.Visible and "Hide" or "Show"
	end)
end

coroutine.wrap(toggleHighlight)()
