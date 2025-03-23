-- Gui to Lua
-- Version: 3.2

-- Instances:

local air = Instance.new("ScreenGui")
local ScreenHideShow = Instance.new("ScreenGui")
local miniHIDESHOW = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local ScreenGui555 = Instance.new("ScreenGui")
local Creator = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Creator_2 = Instance.new("TextLabel")
local UICorner_3 = Instance.new("UICorner")
local ScreenFn = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")
local ScreenMain = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local GameButton = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")
local DropButton = Instance.new("ImageButton")
local UICorner_7 = Instance.new("UICorner")
local crcl = Instance.new("Frame")
local UICorner_8 = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local UIGradient_2 = Instance.new("UIGradient")
local TextLabel = Instance.new("TextLabel")
local testButton = Instance.new("TextButton")
local UICorner_9 = Instance.new("UICorner")
local GraButton = Instance.new("TextButton")
local UICorner_10 = Instance.new("UICorner")
local TextLabel_2 = Instance.new("TextLabel")

--Properties:

air.Name = "air"
air.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
air.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenHideShow.Name = "ScreenHideShow"
ScreenHideShow.Parent = air
ScreenHideShow.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

miniHIDESHOW.Name = "miniHIDESHOW"
miniHIDESHOW.Parent = ScreenHideShow
miniHIDESHOW.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
miniHIDESHOW.BorderColor3 = Color3.fromRGB(0, 0, 0)
miniHIDESHOW.BorderSizePixel = 0
miniHIDESHOW.Position = UDim2.new(0, 0, 0.10026738, 0)
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
Creator.Position = UDim2.new(0.461665273, 0, 0.173532933, 0)
Creator.Size = UDim2.new(0.135037139, 0, 0.0782754049, 0)

UICorner_2.CornerRadius = UDim.new(0, 20)
UICorner_2.Parent = Creator

Creator_2.Name = "Creator"
Creator_2.Parent = Creator
Creator_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Creator_2.BackgroundTransparency = 1.000
Creator_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Creator_2.BorderSizePixel = 0
Creator_2.Position = UDim2.new(0.0730772838, 0, 0.100004278, 0)
Creator_2.Size = UDim2.new(0.848896265, 0, 0.896669447, 0)
Creator_2.Font = Enum.Font.SourceSans
Creator_2.Text = "By.TaeBanna"
Creator_2.TextColor3 = Color3.fromRGB(220, 97, 187)
Creator_2.TextSize = 24.000

UICorner_3.CornerRadius = UDim.new(0, 20)
UICorner_3.Parent = Creator_2

ScreenFn.Name = "ScreenFn"
ScreenFn.Parent = ScreenGui555
ScreenFn.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
ScreenFn.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScreenFn.BorderSizePixel = 0
ScreenFn.Position = UDim2.new(0.279266238, 0, 0.251987785, 0)
ScreenFn.Size = UDim2.new(0.5, 0, 0.5, 0)

UICorner_4.CornerRadius = UDim.new(0, 20)
UICorner_4.Parent = ScreenFn

ScreenMain.Name = "ScreenMain"
ScreenMain.Parent = ScreenGui555
ScreenMain.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
ScreenMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScreenMain.BorderSizePixel = 0
ScreenMain.Position = UDim2.new(0.220527589, 0, 0.251987785, 0)
ScreenMain.Size = UDim2.new(0.0517312326, 0, 0.50000006, 0)

UICorner_5.CornerRadius = UDim.new(0, 20)
UICorner_5.Parent = ScreenMain

GameButton.Name = "GameButton"
GameButton.Parent = ScreenMain
GameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GameButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GameButton.BorderSizePixel = 0
GameButton.Position = UDim2.new(0.159362882, 0, 0.0448564552, 0)
GameButton.Size = UDim2.new(0, 33, 0, 30)
GameButton.Font = Enum.Font.SourceSans
GameButton.Text = "Game"
GameButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GameButton.TextSize = 14.000

UICorner_6.CornerRadius = UDim.new(0, 20)
UICorner_6.Parent = GameButton

DropButton.Name = "DropButton"
DropButton.Parent = GameButton
DropButton.Active = false
DropButton.BackgroundColor3 = Color3.fromRGB(113, 113, 113)
DropButton.BorderColor3 = Color3.fromRGB(27, 42, 53)
DropButton.Position = UDim2.new(8.7036705, -79, 2.09466505, -33)
DropButton.Selectable = false
DropButton.Size = UDim2.new(0, 60, 0, 25)
DropButton.AutoButtonColor = false

UICorner_7.CornerRadius = UDim.new(1, 0)
UICorner_7.Parent = DropButton

crcl.Name = "crcl"
crcl.Parent = DropButton
crcl.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
crcl.BorderColor3 = Color3.fromRGB(27, 42, 53)
crcl.Position = UDim2.new(0.0440002456, 0, 0.0833333358, 0)
crcl.Size = UDim2.new(0, 20, 0, 20)

UICorner_8.CornerRadius = UDim.new(0, 100)
UICorner_8.Parent = crcl

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
UIGradient.Rotation = 90
UIGradient.Parent = crcl

UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(83, 83, 83))}
UIGradient_2.Rotation = 90
UIGradient_2.Parent = DropButton

TextLabel.Parent = DropButton
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(-2.88333344, 0, -0.540000618, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "DropAllItem"
TextLabel.TextColor3 = Color3.fromRGB(220, 97, 187)
TextLabel.TextSize = 29.000

testButton.Name = "testButton"
testButton.Parent = ScreenMain
testButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
testButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
testButton.BorderSizePixel = 0
testButton.Position = UDim2.new(0.159362882, 0, 0.205284283, 0)
testButton.Size = UDim2.new(0, 33, 0, 30)
testButton.Font = Enum.Font.SourceSans
testButton.Text = "Test"
testButton.TextColor3 = Color3.fromRGB(0, 0, 0)
testButton.TextSize = 14.000

UICorner_9.CornerRadius = UDim.new(0, 20)
UICorner_9.Parent = testButton

GraButton.Name = "GraButton"
GraButton.Parent = testButton
GraButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GraButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
GraButton.BorderSizePixel = 0
GraButton.Position = UDim2.new(5.78787899, 0, -0.666666687, 0)
GraButton.Size = UDim2.new(0, 200, 0, 50)
GraButton.Visible = false
GraButton.Font = Enum.Font.SourceSans
GraButton.Text = "Click"
GraButton.TextColor3 = Color3.fromRGB(0, 0, 0)
GraButton.TextSize = 14.000

UICorner_10.CornerRadius = UDim.new(0, 20)
UICorner_10.Parent = GraButton

TextLabel_2.Parent = GraButton
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0, 0, -0.86000061, 0)
TextLabel_2.Size = UDim2.new(0, 200, 0, 50)
TextLabel_2.Font = Enum.Font.SourceSans
TextLabel_2.Text = "GGez"
TextLabel_2.TextColor3 = Color3.fromRGB(220, 97, 187)
TextLabel_2.TextSize = 29.000

-- Scripts:

local function ZUYZ_fake_script() -- miniHIDESHOW.ToggleScreenGuiVisibility 
	local script = Instance.new('LocalScript', miniHIDESHOW)

	local button = script.Parent
	local screenGui555 = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("air"):WaitForChild("ScreenGui555")
	
	button.MouseButton1Click:Connect(function()
		screenGui555.Enabled = not screenGui555.Enabled
	end)
	
	
end
coroutine.wrap(ZUYZ_fake_script)()
local function AFNSA_fake_script() -- GameButton.Script 
	local script = Instance.new('Script', GameButton)

	local function toggleButtonVisibility()
		local button = script.Parent.DropButton
		local All = script.Parent.Parent.testButton.GraButton
		button.Visible = true
		All.Visible = false
	
		
	end
	
	local button = script.Parent
	button.MouseButton1Click:Connect(function()
		toggleButtonVisibility()
	end)
end
coroutine.wrap(AFNSA_fake_script)()
local function YVYVQIK_fake_script() -- DropButton.Main 
	local script = Instance.new('LocalScript', DropButton)

	local Status = script.Parent:WaitForChild("Status")
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	
	local player = Players.LocalPlayer
	local playerCharacter = player.Character or player.CharacterAdded:Wait()
	local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")
	local runtimeItems = workspace:WaitForChild("RuntimeItems")
	local dropItemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DropItem")
	
	
	local pickupEnabled = false
	local pickupDistance = 20  -- ระยะที่สามารถเก็บของได้
	local scanning = false
	local heartbeatConnection
	
	local configs = {
		DisabledPos = UDim2.new(0.044, 0, 0.06, 0),
		EnabledPos = UDim2.new(0.585, 0, 0.104, 0),
	
		EnabledBGCol = Color3.fromRGB(0, 115, 255),
		DisabledBGCol = Color3.fromRGB(113, 113, 113)
	}
	
	local function enabled()
		game:GetService("TweenService"):Create(Status.Parent.crcl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = configs.EnabledPos}):Play()
		game:GetService("TweenService"):Create(Status.Parent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = configs.EnabledBGCol}):Play()    
	end
	
	local function disable()
		game:GetService("TweenService"):Create(Status.Parent.crcl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = configs.DisabledPos}):Play()
		game:GetService("TweenService"):Create(Status.Parent, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = configs.DisabledBGCol}):Play()    
	end
	
	-- ฟังก์ชันเปิด/ปิดระบบเก็บของอัตโนมัติ
	local function togglePickup(state)
		pickupEnabled = state
		if pickupEnabled then
			heartbeatConnection = RunService.Heartbeat:Connect(scanAndPickUpItems)
		else
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end
	end
	
	script.Parent.MouseButton1Click:Connect(function()
		print("old:", Status.Value)
		if Status.Value then 
			Status.Value = false
			togglePickup(false)  -- ปิดระบบเก็บของ
			return
		end
		Status.Value = true
		togglePickup(true)  -- เปิดระบบเก็บของ
	end)
	
	
	Status:GetPropertyChangedSignal("Value"):Connect(function()
		if Status.Value then enabled() return end
		disable()
	end)
	
end
coroutine.wrap(YVYVQIK_fake_script)()
local function JYBH_fake_script() -- testButton.Script 
	local script = Instance.new('Script', testButton)

	local function toggleButtonVisibility()
		local button = script.Parent.GraButton
		local All = script.Parent.Parent.GameButton.DropButton
		button.Visible = true
		All.Visible = false
	
	
	end
	
	local button = script.Parent
	button.MouseButton1Click:Connect(function()
		toggleButtonVisibility()
	end)
end
coroutine.wrap(JYBH_fake_script)()
local function ULYG_fake_script() -- GraButton.Script 
	local script = Instance.new('Script', GraButton)

	local screenGui = game.StarterGui:FindFirstChild("air"):FindFirstChild("ScreenGui555")
	local graButton = screenGui:FindFirstChild("ScreenMain"):FindFirstChild("testButton"):FindFirstChild("GraButton")
	
	if graButton then
		local isOn = false
		graButton.MouseButton1Click:Connect(function()
			isOn = not isOn
			graButton.TextLabel.Text = isOn and "On" or "Off"
		end)
	else
		warn("GraButton not found")
	end
	
end
coroutine.wrap(ULYG_fake_script)()
