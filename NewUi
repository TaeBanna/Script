-- source.lua
-- KavoPlus UI Core Library
-- Minimal UI Framework รองรับมือถือ+PC ปรับขนาด ลากได้ ใช้งานง่าย
-- ใช้: local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUser/KavoPlusUILib/main/source.lua"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local UILib = {}

-- Internal Helper
local function Create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		inst[k] = v
	end
	return inst
end

-- Theme (override ได้)
local Theme = {
	SchemeColor = Color3.fromRGB(0,170,255),
	Background = Color3.fromRGB(25,25,25),
	Header = Color3.fromRGB(35,35,35),
	TextColor = Color3.fromRGB(255,255,255),
	ElementColor = Color3.fromRGB(45,45,45)
}

-- Load External Theme
function UILib:SetTheme(tbl)
	for k,v in pairs(tbl) do
		if Theme[k] then Theme[k] = v end
	end
end

-- CreateWindow
function UILib:CreateWindow(title, theme)
	if typeof(theme) == "table" then
		UILib:SetTheme(theme)
	end

	local gui = Create("ScreenGui", {
		Name = "KavoPlusGUI",
		ResetOnSpawn = false,
		Parent = player:WaitForChild("PlayerGui")
	})

	local main = Create("Frame", {
		Size = UDim2.new(0, 450, 0, 350),
		Position = UDim2.new(0.5, -225, 0.5, -175),
		BackgroundColor3 = Theme.Background,
		Draggable = true,
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = gui
	})

	Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })

	local titlebar = Create("TextLabel", {
		Text = title,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Theme.Header,
		TextColor3 = Theme.TextColor,
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		Parent = main
	})

	-- Tab Support
	local tabs = {}

	function tabs:NewTab(tabName)
		local tabBtn = Create("TextButton", {
			Text = tabName,
			Size = UDim2.new(0, 100, 0, 30),
			BackgroundColor3 = Theme.ElementColor,
			TextColor3 = Theme.TextColor,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			Parent = main
		})

		Create("UICorner", { Parent = tabBtn })

		local tabFrame = Create("Frame", {
			Size = UDim2.new(1, -20, 1, -60),
			Position = UDim2.new(0, 10, 0, 50),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = main
		})

		tabBtn.MouseButton1Click:Connect(function()
			for _, child in pairs(main:GetChildren()) do
				if child:IsA("Frame") and child ~= tabFrame and child.Name ~= "Main" then
					child.Visible = false
				end
			end
			tabFrame.Visible = true
		end)

		local layout = Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
			Parent = tabFrame
		})

		function tabFrame:NewSection(sectionTitle)
			local section = {}

			Create("TextLabel", {
				Text = sectionTitle,
				TextColor3 = Theme.TextColor,
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 16,
				Size = UDim2.new(1, 0, 0, 24),
				Parent = tabFrame
			})

			function section:NewButton(text, desc, callback)
				local btn = Create("TextButton", {
					Text = text,
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					Parent = tabFrame
				})
				Create("UICorner", { Parent = btn })
				btn.MouseButton1Click:Connect(callback)
			end

			function section:NewToggle(text, desc, callback)
				local state = false
				local btn = Create("TextButton", {
					Text = "[ OFF ] " .. text,
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					Parent = tabFrame
				})
				Create("UICorner", { Parent = btn })
				btn.MouseButton1Click:Connect(function()
					state = not state
					btn.Text = (state and "[ ON  ] " or "[ OFF ] ") .. text
					callback(state)
				end)
			end

			function section:NewSlider(text, desc, max, min, callback)
				min = min or 0
				local val = min
				local label = Create("TextLabel", {
					Text = text .. ": " .. val,
					TextColor3 = Theme.TextColor,
					BackgroundTransparency = 1,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					Size = UDim2.new(1, 0, 0, 20),
					Parent = tabFrame
				})

				local sliderBack = Create("Frame", {
					Size = UDim2.new(1, 0, 0, 8),
					BackgroundColor3 = Color3.fromRGB(50,50,50),
					Parent = tabFrame
				})
				local fill = Create("Frame", {
					Size = UDim2.new(0,0,1,0),
					BackgroundColor3 = Theme.SchemeColor,
					Parent = sliderBack
				})

				sliderBack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						local function update(x)
							local scale = math.clamp((x - sliderBack.AbsolutePosition.X)/sliderBack.AbsoluteSize.X, 0, 1)
							fill.Size = UDim2.new(scale,0,1,0)
							val = math.floor(min + (max - min) * scale)
							label.Text = text .. ": " .. val
							callback(val)
						end
						update(input.Position.X)
						local conn = UIS.InputChanged:Connect(function(input2)
							if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
								update(input2.Position.X)
							end
						end)
						UIS.InputEnded:Wait()
						conn:Disconnect()
					end
				end)
			end

			function section:NewTextbox(title, placeholder, callback)
				local box = Create("TextBox", {
					PlaceholderText = placeholder,
					Text = "",
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					ClearTextOnFocus = false,
					Parent = tabFrame
				})
				Create("UICorner", { Parent = box })
				box.FocusLost:Connect(function()
					callback(box.Text)
				end)
			end

			function section:NewDropdown(text, desc, list, callback)
				local dropdown = Create("TextButton", {
					Text = text .. " ▼",
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					Parent = tabFrame
				})
				Create("UICorner", { Parent = dropdown })
				dropdown.MouseButton1Click:Connect(function()
					for _, opt in pairs(list) do
						callback(opt)
						dropdown.Text = text .. ": " .. opt
						break
					end
				end)
			end

			return section
		end

		return tabFrame
	end

	return tabs
end

return UILib
