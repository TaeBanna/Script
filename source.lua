-- source.lua
-- KavoPlus UI Core Library (Fixed Version)
-- Minimal UI Framework รองรับมือถือ+PC ปรับขนาด ลากได้ ใช้งานง่าย
-- ใช้: local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUser/KavoPlusUILib/main/source.lua"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local UILib = {}

-- Internal Helper
local function Create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Parent" then
			inst[k] = v
		end
	end
	if props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

-- Safe Math Functions
local function SafeClamp(value, min, max)
	return math.max(min, math.min(max, value))
end

-- Theme (override ได้)
local Theme = {
	SchemeColor = Color3.fromRGB(0, 170, 255),
	Background = Color3.fromRGB(25, 25, 25),
	Header = Color3.fromRGB(35, 35, 35),
	TextColor = Color3.fromRGB(255, 255, 255),
	ElementColor = Color3.fromRGB(45, 45, 45),
	BorderColor = Color3.fromRGB(60, 60, 60),
	HoverColor = Color3.fromRGB(55, 55, 55)
}

-- Load External Theme
function UILib:SetTheme(tbl)
	if typeof(tbl) ~= "table" then return end
	for k, v in pairs(tbl) do
		if Theme[k] and typeof(v) == typeof(Theme[k]) then 
			Theme[k] = v 
		end
	end
end

-- CreateWindow
function UILib:CreateWindow(title, theme)
	title = title or "KavoPlus GUI"
	
	if typeof(theme) == "table" then
		UILib:SetTheme(theme)
	end

	-- Remove existing GUI if exists
	local existingGui = player.PlayerGui:FindFirstChild("KavoPlusGUI")
	if existingGui then
		existingGui:Destroy()
		wait(0.1)
	end

	local gui = Create("ScreenGui", {
		Name = "KavoPlusGUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = player:WaitForChild("PlayerGui")
	})

	local main = Create("Frame", {
		Name = "MainFrame",
		Size = UDim2.new(0, 450, 0, 350),
		Position = UDim2.new(0.5, -225, 0.5, -175),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ClipsDescendants = true,
		Parent = gui
	})

	Create("UICorner", { 
		CornerRadius = UDim.new(0, 8), 
		Parent = main 
	})

	-- Add shadow effect
	local shadow = Create("Frame", {
		Name = "Shadow",
		Size = UDim2.new(1, 6, 1, 6),
		Position = UDim2.new(0, -3, 0, -3),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		ZIndex = main.ZIndex - 1,
		Parent = main
	})
	
	Create("UICorner", { 
		CornerRadius = UDim.new(0, 8), 
		Parent = shadow 
	})

	-- Title Bar
	local titlebar = Create("Frame", {
		Name = "TitleBar",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Theme.Header,
		BorderSizePixel = 0,
		Parent = main
	})

	Create("UICorner", { 
		CornerRadius = UDim.new(0, 8), 
		Parent = titlebar 
	})

	-- Fix corner for bottom of titlebar
	Create("Frame", {
		Size = UDim2.new(1, 0, 0, 8),
		Position = UDim2.new(0, 0, 1, -8),
		BackgroundColor3 = Theme.Header,
		BorderSizePixel = 0,
		Parent = titlebar
	})

	local titleLabel = Create("TextLabel", {
		Name = "Title",
		Text = title,
		Size = UDim2.new(1, -80, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		TextColor3 = Theme.TextColor,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = titlebar
	})

	-- Close Button
	local closeBtn = Create("TextButton", {
		Name = "CloseButton",
		Text = "×",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -35, 0, 2.5),
		BackgroundColor3 = Color3.fromRGB(255, 85, 85),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		BorderSizePixel = 0,
		Parent = titlebar
	})

	Create("UICorner", { 
		CornerRadius = UDim.new(0, 6), 
		Parent = closeBtn 
	})

	closeBtn.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	-- Minimize Button
	local minimizeBtn = Create("TextButton", {
		Name = "MinimizeButton",
		Text = "−",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -70, 0, 2.5),
		BackgroundColor3 = Color3.fromRGB(255, 165, 0),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		BorderSizePixel = 0,
		Parent = titlebar
	})

	Create("UICorner", { 
		CornerRadius = UDim.new(0, 6), 
		Parent = minimizeBtn 
	})

	local isMinimized = false
	local originalSize = main.Size
	
	minimizeBtn.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		local targetSize = isMinimized and UDim2.new(0, 450, 0, 35) or originalSize
		
		local tween = TweenService:Create(main, 
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = targetSize}
		)
		tween:Play()
	end)

	-- Dragging functionality
	local dragging = false
	local dragStart = nil
	local startPos = nil

	titlebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Tab Container
	local tabContainer = Create("Frame", {
		Name = "TabContainer",
		Size = UDim2.new(1, -20, 0, 30),
		Position = UDim2.new(0, 10, 0, 45),
		BackgroundTransparency = 1,
		Parent = main
	})

	local tabLayout = Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = tabContainer
	})

	-- Content Container
	local contentContainer = Create("Frame", {
		Name = "ContentContainer",
		Size = UDim2.new(1, -20, 1, -85),
		Position = UDim2.new(0, 10, 0, 80),
		BackgroundTransparency = 1,
		Parent = main
	})

	-- Tab System
	local tabs = {}
	local tabButtons = {}
	local activeTab = nil

	function tabs:NewTab(tabName)
		tabName = tabName or "New Tab"
		
		local tabBtn = Create("TextButton", {
			Name = "TabButton_" .. tabName,
			Text = tabName,
			Size = UDim2.new(0, 100, 1, 0),
			BackgroundColor3 = Theme.ElementColor,
			TextColor3 = Theme.TextColor,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			Parent = tabContainer
		})

		Create("UICorner", { 
			CornerRadius = UDim.new(0, 6), 
			Parent = tabBtn 
		})

		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 15),
			Parent = tabBtn
		})

		local tabFrame = Create("ScrollingFrame", {
			Name = "TabFrame_" .. tabName,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 4,
			ScrollBarImageColor3 = Theme.SchemeColor,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			Visible = false,
			Parent = contentContainer
		})

		local layout = Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			Parent = tabFrame
		})

		-- Auto-resize canvas
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
		end)

		-- Tab switching
		tabBtn.MouseButton1Click:Connect(function()
			-- Hide all tabs
			for _, frame in pairs(contentContainer:GetChildren()) do
				if frame:IsA("ScrollingFrame") then
					frame.Visible = false
				end
			end
			
			-- Reset all button colors
			for _, btn in pairs(tabContainer:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.BackgroundColor3 = Theme.ElementColor
				end
			end
			
			-- Show selected tab and highlight button
			tabFrame.Visible = true
			tabBtn.BackgroundColor3 = Theme.SchemeColor
			activeTab = tabFrame
		end)

		-- Hover effects
		tabBtn.MouseEnter:Connect(function()
			if tabBtn.BackgroundColor3 ~= Theme.SchemeColor then
				tabBtn.BackgroundColor3 = Theme.HoverColor
			end
		end)

		tabBtn.MouseLeave:Connect(function()
			if tabBtn.BackgroundColor3 ~= Theme.SchemeColor then
				tabBtn.BackgroundColor3 = Theme.ElementColor
			end
		end)

		-- Auto-select first tab
		if not activeTab then
			tabBtn.BackgroundColor3 = Theme.SchemeColor
			tabFrame.Visible = true
			activeTab = tabFrame
		end

		table.insert(tabButtons, tabBtn)

		-- Tab Functions
		function tabFrame:NewSection(sectionTitle)
			sectionTitle = sectionTitle or "Section"
			local section = {}

			local sectionLabel = Create("TextLabel", {
				Name = "Section_" .. sectionTitle,
				Text = sectionTitle,
				TextColor3 = Theme.TextColor,
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextSize = 14,
				Size = UDim2.new(1, 0, 0, 25),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Parent = tabFrame
			})

			function section:NewButton(text, desc, callback)
				text = text or "Button"
				callback = callback or function() end
				
				local btn = Create("TextButton", {
					Name = "Button_" .. text,
					Text = text,
					Size = UDim2.new(1, 0, 0, 35),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					Font = Enum.Font.Gotham,
					TextSize = 13,
					BorderSizePixel = 0,
					Parent = tabFrame
				})
				
				Create("UICorner", { 
					CornerRadius = UDim.new(0, 6), 
					Parent = btn 
				})

				-- Hover effects
				btn.MouseEnter:Connect(function()
					btn.BackgroundColor3 = Theme.HoverColor
				end)

				btn.MouseLeave:Connect(function()
					btn.BackgroundColor3 = Theme.ElementColor
				end)

				btn.MouseButton1Click:Connect(function()
					pcall(callback)
				end)

				if desc then
					Create("TextLabel", {
						Name = "Description",
						Text = desc,
						Size = UDim2.new(1, -10, 1, 0),
						Position = UDim2.new(0, 5, 0, 0),
						BackgroundTransparency = 1,
						TextColor3 = Color3.fromRGB(200, 200, 200),
						Font = Enum.Font.Gotham,
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Center,
						Parent = btn
					})
				end

				return btn
			end

			function section:NewToggle(text, desc, callback)
				text = text or "Toggle"
				callback = callback or function() end
				
				local state = false
				local btn = Create("TextButton", {
					Name = "Toggle_" .. text,
					Text = "✗ " .. text,
					Size = UDim2.new(1, 0, 0, 35),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					Font = Enum.Font.Gotham,
					TextSize = 13,
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = tabFrame
				})
				
				Create("UICorner", { 
					CornerRadius = UDim.new(0, 6), 
					Parent = btn 
				})

				Create("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					Parent = btn
				})

				-- Hover effects
				btn.MouseEnter:Connect(function()
					btn.BackgroundColor3 = Theme.HoverColor
				end)

				btn.MouseLeave:Connect(function()
					btn.BackgroundColor3 = Theme.ElementColor
				end)

				btn.MouseButton1Click:Connect(function()
					state = not state
					btn.Text = (state and "✓ " or "✗ ") .. text
					btn.TextColor3 = state and Theme.SchemeColor or Theme.TextColor
					pcall(callback, state)
				end)

				if desc then
					Create("TextLabel", {
						Name = "Description",
						Text = desc,
						Size = UDim2.new(1, -10, 1, 0),
						Position = UDim2.new(0, 5, 0, 0),
						BackgroundTransparency = 1,
						TextColor3 = Color3.fromRGB(200, 200, 200),
						Font = Enum.Font.Gotham,
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Center,
						Parent = btn
					})
				end

				return {
					SetValue = function(value)
						state = value
						btn.Text = (state and "✓ " or "✗ ") .. text
						btn.TextColor3 = state and Theme.SchemeColor or Theme.TextColor
					end
				}
			end

			function section:NewSlider(text, desc, max, min, callback)
				text = text or "Slider"
				max = max or 100
				min = min or 0
				callback = callback or function() end
				
				local val = min
				
				local container = Create("Frame", {
					Name = "Slider_" .. text,
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundTransparency = 1,
					Parent = tabFrame
				})

				local label = Create("TextLabel", {
					Name = "Label",
					Text = text .. ": " .. val,
					TextColor3 = Theme.TextColor,
					BackgroundTransparency = 1,
					Font = Enum.Font.Gotham,
					TextSize = 13,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = container
				})

				local sliderBack = Create("Frame", {
					Name = "SliderBackground",
					Size = UDim2.new(1, 0, 0, 8),
					Position = UDim2.new(0, 0, 0, 25),
					BackgroundColor3 = Color3.fromRGB(50, 50, 50),
					BorderSizePixel = 0,
					Parent = container
				})

				Create("UICorner", { 
					CornerRadius = UDim.new(0, 4), 
					Parent = sliderBack 
				})

				local fill = Create("Frame", {
					Name = "SliderFill",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Theme.SchemeColor,
					BorderSizePixel = 0,
					Parent = sliderBack
				})

				Create("UICorner", { 
					CornerRadius = UDim.new(0, 4), 
					Parent = fill 
				})

				local function updateSlider(inputPos)
					if not sliderBack.Parent then return end
					
					local scale = SafeClamp((inputPos - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
					fill.Size = UDim2.new(scale, 0, 1, 0)
					val = math.floor(min + (max - min) * scale)
					label.Text = text .. ": " .. val
					pcall(callback, val)
				end

				local dragging = false

				sliderBack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						updateSlider(input.Position.X)
					end
				end)

				sliderBack.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateSlider(input.Position.X)
					end
				end)

				UIS.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				if desc then
					Create("TextLabel", {
						Name = "Description",
						Text = desc,
						Size = UDim2.new(1, 0, 0, 15),
						Position = UDim2.new(0, 0, 1, -15),
						BackgroundTransparency = 1,
						TextColor3 = Color3.fromRGB(200, 200, 200),
						Font = Enum.Font.Gotham,
						TextSize = 11,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = container
					})
					container.Size = UDim2.new(1, 0, 0, 65)
				end

				return {
					SetValue = function(value)
						val = SafeClamp(value, min, max)
						local scale = (val - min) / (max - min)
						fill.Size = UDim2.new(scale, 0, 1, 0)
						label.Text = text .. ": " .. val
					end
				}
			end

			function section:NewTextbox(title, placeholder, callback)
				title = title or "Textbox"
				placeholder = placeholder or "Enter text..."
				callback = callback or function() end
				
				local container = Create("Frame", {
					Name = "Textbox_" .. title,
					Size = UDim2.new(1, 0, 0, 50),
					BackgroundTransparency = 1,
					Parent = tabFrame
				})

				Create("TextLabel", {
					Name = "Label",
					Text = title,
					TextColor3 = Theme.TextColor,
					BackgroundTransparency = 1,
					Font = Enum.Font.Gotham,
					TextSize = 13,
					Size = UDim2.new(1, 0, 0, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = container
				})

				local box = Create("TextBox", {
					Name = "TextBox",
					PlaceholderText = placeholder,
					Text = "",
					Size = UDim2.new(1, 0, 0, 30),
					Position = UDim2.new(0, 0, 0, 20),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
					Font = Enum.Font.Gotham,
					TextSize = 12,
					ClearTextOnFocus = false,
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = container
				})

				Create("UICorner", { 
					CornerRadius = UDim.new(0, 6), 
					Parent = box 
				})

				Create("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
					Parent = box
				})

				box.FocusLost:Connect(function(enterPressed)
					pcall(callback, box.Text)
				end)

				-- Focus effects
				box.Focused:Connect(function()
					box.BackgroundColor3 = Theme.HoverColor
				end)

				box.FocusLost:Connect(function()
					box.BackgroundColor3 = Theme.ElementColor
				end)

				return {
					SetText = function(text)
						box.Text = text or ""
					end,
					GetText = function()
						return box.Text
					end
				}
			end

			function section:NewDropdown(text, desc, list, callback)
				text = text or "Dropdown"
				list = list or {"Option 1", "Option 2"}
				callback = callback or function() end
				
				local selectedValue = list[1] or "None"
				local isOpen = false

				local container = Create("Frame", {
					Name = "Dropdown_" .. text,
					Size = UDim2.new(1, 0, 0, 35),
					BackgroundTransparency = 1,
					Parent = tabFrame
				})

				local dropdown = Create("TextButton", {
					Name = "DropdownButton",
					Text = text .. ": " .. selectedValue .. " ▼",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Theme.ElementColor,
					TextColor3 = Theme.TextColor,
					Font = Enum.Font.Gotham,
					TextSize = 13,
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = container
				})

				Create("UICorner", { 
					CornerRadius = UDim.new(0, 6), 
					Parent = dropdown 
				})

				Create("UIPadding", {
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10),
					Parent = dropdown
				})

				local optionsFrame = Create("Frame", {
					Name = "OptionsFrame",
					Size = UDim2.new(1, 0, 0, #list * 30),
					Position = UDim2.new(0, 0, 1, 2),
					BackgroundColor3 = Theme.ElementColor,
					BorderSizePixel = 0,
					Visible = false,
					ZIndex = 10,
					Parent = container
				})

				Create("UICorner", { 
					CornerRadius = UDim.new(0, 6), 
					Parent = optionsFrame 
				})

				local optionsLayout = Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Parent = optionsFrame
				})

				-- Create option buttons
				for i, option in ipairs(list) do
					local optionBtn = Create("TextButton", {
						Name = "Option_" .. option,
						Text = option,
						Size = UDim2.new(1, 0, 0, 30),
						BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0),
						TextColor3 = Theme.TextColor,
						Font = Enum.Font.Gotham,
						TextSize = 12,
						BorderSizePixel = 0,
						TextXAlignment = Enum.TextXAlignment.Left,
						Parent = optionsFrame
					})

					Create("UIPadding", {
						PaddingLeft = UDim.new(0, 10),
						Parent = optionBtn
					})

					optionBtn.MouseEnter:Connect(function()
						optionBtn.BackgroundColor3 = Theme.HoverColor
					end)

					optionBtn.MouseLeave:Connect(function()
						optionBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
					end)

					optionBtn.MouseButton1Click:Connect(function()
						selectedValue = option
						dropdown.Text = text .. ": " .. selectedValue .. " ▼"
						optionsFrame.Visible = false
						isOpen = false
						container.Size = UDim2.new(1, 0, 0, 35)
						pcall(callback, selectedValue)
					end)
				end

				dropdown.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					optionsFrame.Visible = isOpen
					dropdown.Text = text .. ": " .. selectedValue .. (isOpen and " ▲" or " ▼")
					container.Size = isOpen and UDim2.new(1, 0, 0, 35 + #list * 30 + 2) or UDim2.new(1, 0, 0, 35)
				end)

				-- Hover effects
				dropdown.MouseEnter:Connect(function()
					dropdown.BackgroundColor3 = Theme.HoverColor
				end)

				dropdown.MouseLeave:Connect(function()
					dropdown.BackgroundColor3 = Theme.ElementColor
				end)

				return {
					SetValue = function(value)
						if table.find(list, value) then
							selectedValue = value
							dropdown.Text = text .. ": " .. selectedValue .. " ▼"
						end
					end,
					GetValue = function()
						return selectedValue
					end
				}
			end

			return section
		end

		return tabFrame
	end

	return tabs
end

return UILib
