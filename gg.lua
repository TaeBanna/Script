-- BannaHub UI Library (BHub) - Version 1.0
-- Inspired by Rayfield, built from scratch with unique layout
-- Developer: TaeBanna

local BannaHub = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Theme
local Theme = {
	Background = Color3.fromRGB(20, 20, 30),
	Header = Color3.fromRGB(30, 30, 45),
	Primary = Color3.fromRGB(88, 101, 242),
	Text = Color3.fromRGB(255, 255, 255),
	Section = Color3.fromRGB(40, 40, 60),
	Button = Color3.fromRGB(60, 60, 90),
	ToggleOn = Color3.fromRGB(67, 181, 129),
	ToggleOff = Color3.fromRGB(100, 100, 120),
}

-- Utility Functions
local function create(instanceType, properties)
	local obj = Instance.new(instanceType)
	for k, v in pairs(properties) do
		obj[k] = v
	end
	return obj
end

-- Main UI Constructor
function BannaHub:CreateWindow(title, theme)
	theme = Theme -- (future: custom themes)

	local screenGui = create("ScreenGui", {
		Name = "BannaHubGUI",
		Parent = PlayerGui,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
	})

	local mainFrame = create("Frame", {
		Name = "Main",
		Parent = screenGui,
		BackgroundColor3 = theme.Background,
		Size = UDim2.new(0, 500, 0, 350),
		Position = UDim2.new(0.5, -250, 0.5, -175),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
	})
	create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = mainFrame})

	local header = create("TextLabel", {
		Parent = mainFrame,
		BackgroundColor3 = theme.Header,
		Size = UDim2.new(1, 0, 0, 40),
		Text = title or "BannaHub",
		TextColor3 = theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		BorderSizePixel = 0,
	})
	create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = header})

	local tabHolder = create("Frame", {
		Parent = mainFrame,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 1, -60),
		Position = UDim2.new(0, 10, 0, 50),
	})

	local layout = create("UIListLayout", {
		Parent = tabHolder,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
	})

	-- Tab System
	local tabFunctions = {}

	function tabFunctions:NewTab(name)
		local tabFrame = create("Frame", {
			Name = name,
			Parent = tabHolder,
			BackgroundColor3 = theme.Section,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
		})
		create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabFrame})

		local tabLayout = create("UIListLayout", {
			Parent = tabFrame,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5),
		})

		local sectionFunctions = {}

		function sectionFunctions:NewSection(title)
			local section = create("Frame", {
				Parent = tabFrame,
				BackgroundColor3 = theme.Background,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
			})
			create("UICorner", {Parent = section})

			create("TextLabel", {
				Parent = section,
				Text = title,
				TextColor3 = theme.Text,
				Font = Enum.Font.GothamSemibold,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 0, 25),
				Position = UDim2.new(0, 5, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
			})

			local contentLayout = create("UIListLayout", {
				Parent = section,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			})

			-- Button
			function section:NewButton(text, callback)
				local button = create("TextButton", {
					Parent = section,
					Text = text,
					BackgroundColor3 = theme.Button,
					TextColor3 = theme.Text,
					Font = Enum.Font.Gotham,
					Size = UDim2.new(1, -10, 0, 30),
					Position = UDim2.new(0, 5, 0, 0),
					BorderSizePixel = 0,
				})
				create("UICorner", {Parent = button})
				button.MouseButton1Click:Connect(function()
					pcall(callback)
				end)
			end

			-- Toggle
			function section:NewToggle(text, default, callback)
				local state = default
				local toggle = create("TextButton", {
					Parent = section,
					Text = text,
					BackgroundColor3 = state and theme.ToggleOn or theme.ToggleOff,
					TextColor3 = theme.Text,
					Font = Enum.Font.Gotham,
					Size = UDim2.new(1, -10, 0, 30),
					Position = UDim2.new(0, 5, 0, 0),
					BorderSizePixel = 0,
				})
				create("UICorner", {Parent = toggle})
				toggle.MouseButton1Click:Connect(function()
					state = not state
					toggle.BackgroundColor3 = state and theme.ToggleOn or theme.ToggleOff
					pcall(callback, state)
				end)
			end

			return section
		end

		return sectionFunctions
	end

	return tabFunctions
end

return BannaHub
