local BannaHub = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- สี Theme สำหรับ UI
local Theme = {
    Background = Color3.fromRGB(15, 15, 25),
    Sidebar = Color3.fromRGB(20, 20, 35),
    Primary = Color3.fromRGB(88, 101, 242),
    Secondary = Color3.fromRGB(30, 30, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    Success = Color3.fromRGB(67, 181, 129),
    Warning = Color3.fromRGB(250, 166, 26),
    Error = Color3.fromRGB(240, 71, 71),
    Border = Color3.fromRGB(40, 40, 60)
}

-- ฟังก์ชันสำหรับการ Drag
function BannaHub:MakeDraggable(frame, dragFrame)
    dragFrame = dragFrame or frame
    
    local dragging = false
    local dragInput, mousePos, framePos

    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- ฟังก์ชันสำหรับ Tween
function BannaHub:Tween(object, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(object, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

-- ฟังก์ชันสร้าง Library หลัก
function BannaHub:CreateWindow(title)
    title = title or "Banna Hub"
    
    -- สร้าง ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local TopBarCorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local Sidebar = Instance.new("Frame")
    local SidebarCorner = Instance.new("UICorner")
    local TabContainer = Instance.new("ScrollingFrame")
    local TabLayout = Instance.new("UIListLayout")
    local ContentFrame = Instance.new("Frame")
    local ContentCorner = Instance.new("UICorner")
    local PageContainer = Instance.new("Frame")
    
    -- การตั้งค่า ScreenGui
    ScreenGui.Name = "BannaHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- การตั้งค่า MainFrame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.ClipsDescendants = true
    
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- การตั้งค่า TopBar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Theme.Sidebar
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    -- ปิดมุมล่างของ TopBar
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Parent = TopBar
    TopBarFix.BackgroundColor3 = Theme.Sidebar
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Position = UDim2.new(0, 0, 0.5, 0)
    TopBarFix.Size = UDim2.new(1, 0, 0.5, 0)
    
    -- Title
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🍌 " .. title
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.Error
    CloseButton.TextSize = 20
    
    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.Warning
    MinimizeButton.TextSize = 18
    
    -- Sidebar
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 200, 1, -40)
    
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar
    
    -- ปิดมุมบนของ Sidebar
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Parent = Sidebar
    SidebarFix.BackgroundColor3 = Theme.Sidebar
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Size = UDim2.new(1, 0, 0, 12)
    
    -- Tab Container
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 10)
    TabContainer.Size = UDim2.new(1, -20, 1, -20)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Theme.Primary
    
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    
    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Theme.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 200, 0, 40)
    ContentFrame.Size = UDim2.new(1, -200, 1, -40)
    
    ContentCorner.CornerRadius = UDim.new(0, 12)
    ContentCorner.Parent = ContentFrame
    
    -- ปิดมุมซ้ายของ ContentFrame
    local ContentFix = Instance.new("Frame")
    ContentFix.Parent = ContentFrame
    ContentFix.BackgroundColor3 = Theme.Background
    ContentFix.BorderSizePixel = 0
    ContentFix.Size = UDim2.new(0, 12, 1, 0)
    
    -- Page Container
    PageContainer.Name = "PageContainer"
    PageContainer.Parent = ContentFrame
    PageContainer.BackgroundTransparency = 1
    PageContainer.Size = UDim2.new(1, 0, 1, 0)
    
    -- ทำให้ Draggable
    BannaHub:MakeDraggable(MainFrame, TopBar)
    
    -- ฟังก์ชัน Close
    local minimized = false
    CloseButton.MouseButton1Click:Connect(function()
        BannaHub:Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- ฟังก์ชัน Minimize
    MinimizeButton.MouseButton1Click:Connect(function()
        if not minimized then
            minimized = true
            BannaHub:Tween(MainFrame, {Size = UDim2.new(0, 200, 0, 40)}, 0.3)
            MinimizeButton.Text = "+"
        else
            minimized = false
            BannaHub:Tween(MainFrame, {Size = UDim2.new(0, 800, 0, 500)}, 0.3)
            MinimizeButton.Text = "−"
        end
    end)
    
    -- Hover Effects
    CloseButton.MouseEnter:Connect(function()
        BannaHub:Tween(CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
    end)
    CloseButton.MouseLeave:Connect(function()
        BannaHub:Tween(CloseButton, {TextColor3 = Theme.Error}, 0.2)
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        BannaHub:Tween(MinimizeButton, {TextColor3 = Color3.fromRGB(255, 200, 100)}, 0.2)
    end)
    MinimizeButton.MouseLeave:Connect(function()
        BannaHub:Tween(MinimizeButton, {TextColor3 = Theme.Warning}, 0.2)
    end)
    
    local Window = {}
    local tabs = {}
    local currentTab = nil
    
    function Window:CreateTab(name, icon)
        name = name or "Tab"
        icon = icon or "📄"
        
        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabIcon = Instance.new("TextLabel")
        local TabText = Instance.new("TextLabel")
        local Page = Instance.new("ScrollingFrame")
        local PageLayout = Instance.new("UIListLayout")
        
        -- Tab Button
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        -- Tab Icon
        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0, 0)
        TabIcon.Size = UDim2.new(0, 30, 1, 0)
        TabIcon.Font = Enum.Font.Gotham
        TabIcon.Text = icon
        TabIcon.TextColor3 = Theme.TextSecondary
        TabIcon.TextSize = 16
        TabIcon.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Tab Text
        TabText.Name = "Text"
        TabText.Parent = TabButton
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 40, 0, 0)
        TabText.Size = UDim2.new(1, -50, 1, 0)
        TabText.Font = Enum.Font.Gotham
        TabText.Text = name
        TabText.TextColor3 = Theme.TextSecondary
        TabText.TextSize = 14
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Page
        Page.Name = name .. "Page"
        Page.Parent = PageContainer
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Position = UDim2.new(0, 20, 0, 20)
        Page.Size = UDim2.new(1, -40, 1, -40)
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Theme.Primary
        Page.Visible = false
        
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 15)
        
        -- Tab Click
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all pages
            for _, tab in pairs(tabs) do
                tab.Page.Visible = false
                BannaHub:Tween(tab.Button, {BackgroundColor3 = Theme.Secondary}, 0.2)
                BannaHub:Tween(tab.Icon, {TextColor3 = Theme.TextSecondary}, 0.2)
                BannaHub:Tween(tab.Text, {TextColor3 = Theme.TextSecondary}, 0.2)
            end
            
            -- Show current page
            Page.Visible = true
            BannaHub:Tween(TabButton, {BackgroundColor3 = Theme.Primary}, 0.2)
            BannaHub:Tween(TabIcon, {TextColor3 = Theme.Text}, 0.2)
            BannaHub:Tween(TabText, {TextColor3 = Theme.Text}, 0.2)
            currentTab = name
        end)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if currentTab ~= name then
                BannaHub:Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if currentTab ~= name then
                BannaHub:Tween(TabButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
            end
        end)
        
        -- เพิ่มใน table
        local tabData = {
            Button = TabButton,
            Icon = TabIcon,
            Text = TabText,
            Page = Page,
            Layout = PageLayout
        }
        tabs[name] = tabData
        
        -- Auto select first tab
        if #tabs == 1 then
            TabButton.MouseButton1Click()
        end
        
        -- Update scroll
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        TabLayout.Changed:Connect(function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
        
        local Tab = {}
        
        function Tab:CreateSection(name)
            name = name or "Section"
            
            local Section = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionTitle = Instance.new("TextLabel")
            local SectionContainer = Instance.new("Frame")
            local SectionLayout = Instance.new("UIListLayout")
            
            Section.Name = name .. "Section"
            Section.Parent = Page
            Section.BackgroundColor3 = Theme.Secondary
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, 0, 0, 50)
            
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = Section
            
            SectionTitle.Name = "Title"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.Size = UDim2.new(1, -30, 0, 40)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionContainer.Name = "Container"
            SectionContainer.Parent = Section
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.Position = UDim2.new(0, 15, 0, 40)
            SectionContainer.Size = UDim2.new(1, -30, 1, -50)
            
            SectionLayout.Parent = SectionContainer
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 10)
            
            -- Auto resize section
            local function updateSize()
                local contentSize = SectionLayout.AbsoluteContentSize.Y
                Section.Size = UDim2.new(1, 0, 0, contentSize + 60)
                
                -- Update page canvas
                Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
            end
            
            SectionLayout.Changed:Connect(updateSize)
            updateSize()
            
            local Elements = {}
            
            function Elements:CreateButton(name, callback)
                name = name or "Button"
                callback = callback or function() end
                
                local Button = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")
                
                Button.Name = name .. "Button"
                Button.Parent = SectionContainer
                Button.BackgroundColor3 = Theme.Primary
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.Font = Enum.Font.GothamBold
                Button.Text = name
                Button.TextColor3 = Theme.Text
                Button.TextSize = 14
                Button.AutoButtonColor = false
                
                ButtonCorner.CornerRadius = UDim.new(0, 8)
                ButtonCorner.Parent = Button
                
                Button.MouseButton1Click:Connect(callback)
                
                -- Hover Effects
                Button.MouseEnter:Connect(function()
                    BannaHub:Tween(Button, {BackgroundColor3 = Color3.fromRGB(100, 115, 255)}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    BannaHub:Tween(Button, {BackgroundColor3 = Theme.Primary}, 0.2)
                end)
                
                updateSize()
                return Button
            end
            
            function Elements:CreateToggle(name, default, callback)
                name = name or "Toggle"
                default = default or false
                callback = callback or function() end
                
                local Toggle = Instance.new("Frame")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleButton = Instance.new("TextButton")
                local ToggleLabel = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local SwitchCorner = Instance.new("UICorner")
                local SwitchCircle = Instance.new("Frame")
                local CircleCorner = Instance.new("UICorner")
                
                local toggled = default
                
                Toggle.Name = name .. "Toggle"
                Toggle.Parent = SectionContainer
                Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = Toggle
                
                ToggleButton.Parent = Toggle
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Text = ""
                
                ToggleLabel.Parent = Toggle
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = Theme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                ToggleSwitch.Parent = Toggle
                ToggleSwitch.BackgroundColor3 = toggled and Theme.Success or Color3.fromRGB(60, 60, 80)
                ToggleSwitch.BorderSizePixel = 0
                ToggleSwitch.Position = UDim2.new(1, -55, 0.5, -10)
                ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
                
                SwitchCorner.CornerRadius = UDim.new(0, 10)
                SwitchCorner.Parent = ToggleSwitch
                
                SwitchCircle.Parent = ToggleSwitch
                SwitchCircle.BackgroundColor3 = Theme.Text
                SwitchCircle.BorderSizePixel = 0
                SwitchCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
                
                CircleCorner.CornerRadius = UDim.new(0, 8)
                CircleCorner.Parent = SwitchCircle
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    BannaHub:Tween(ToggleSwitch, {BackgroundColor3 = toggled and Theme.Success or Color3.fromRGB(60, 60, 80)}, 0.2)
                    BannaHub:Tween(SwitchCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    
                    callback(toggled)
                end)
                
                updateSize()
                return Toggle
            end
            
            function Elements:CreateSlider(name, min, max, default, callback)
                name = name or "Slider"
                min = min or 0
                max = max or 100
                default = default or 50
                callback = callback or function() end
                
                local Slider = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderLabel = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderButton = Instance.new("TextButton")
                
                local value = default
                local dragging = false
                
                Slider.Name = name .. "Slider"
                Slider.Parent = SectionContainer
                Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, 0, 0, 50)
                
                SliderCorner.CornerRadius = UDim.new(0, 8)
                SliderCorner.Parent = Slider
                
                SliderLabel.Parent = Slider
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 15, 0, 0)
                SliderLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = name
                SliderLabel.TextColor3 = Theme.Text
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                SliderValue.Parent = Slider
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0.7, 0, 0, 0)
                SliderValue.Size = UDim2.new(0.3, -15, 0.5, 0)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(value)
                SliderValue.TextColor3 = Theme.Primary
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 15, 0.6, 0)
                SliderBar.Size = UDim2.new(1, -30, 0, 6)
                
                BarCorner.CornerRadius = UDim.new(0, 3)
                BarCorner.Parent = SliderBar
                
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = Theme.Primary
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                
                FillCorner.CornerRadius = UDim.new(0, 3)
                FillCorner.Parent = SliderFill
                
                SliderButton.Parent = SliderBar
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Text = ""
                
                local function updateSlider(input)
                    local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * percentage)
                    
                    SliderValue.Text = tostring(value)
                    BannaHub:Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                    
                    callback(value)
                end
                
                SliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                SliderButton.MouseButton1Click:Connect(function()
                    updateSlider(UserInputService:GetMouseLocation())
                end)
                
                updateSize()
                return Slider
            end
            
            function Elements:CreateTextbox(name, placeholder, callback)
                name = name or "Textbox"
                placeholder = placeholder or "Enter text..."
                callback = callback or function() end
                
                local Textbox = Instance.new("Frame")
                local TextboxCorner = Instance.new("UICorner")
                local TextboxLabel = Instance.new("TextLabel")
                local TextboxInput = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")
                
                Textbox.Name = name .. "Textbox"
                Textbox.Parent = SectionContainer
                Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                Textbox.BorderSizePixel = 0
                Textbox.Size = UDim2.new(1, 0, 0, 50)
                
                TextboxCorner.CornerRadius = UDim.new(0, 8)
                TextboxCorner.Parent = Textbox
                
                TextboxLabel.Parent = Textbox
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Position = UDim2.new(0, 15, 0, 0)
                TextboxLabel.Size = UDim2.new(1, -30, 0.4, 0)
                TextboxLabel.Font = Enum.Font.Gotham
                TextboxLabel.Text = name
                TextboxLabel.TextColor3 = Theme.Text
                TextboxLabel.TextSize = 14
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                TextboxInput.Parent = Textbox
                TextboxInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                TextboxInput.BorderSizePixel = 0
                TextboxInput.Position = UDim2.new(0, 15, 0.5, 0)
                TextboxInput.Size = UDim2.new(1, -30, 0, 20)
                TextboxInput.Font = Enum.Font.Gotham
                TextboxInput.PlaceholderText = placeholder
                TextboxInput.PlaceholderColor3 = Theme.TextSecondary
                TextboxInput.Text = ""
                TextboxInput.TextColor3 = Theme.Text
                TextboxInput.TextSize = 12
                TextboxInput.TextXAlignment = Enum.TextXAlignment.Left
                
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = TextboxInput
                
                TextboxInput.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        callback(TextboxInput.Text)
                    end
                end)
                
                -- Hover Effects
                TextboxInput.Focused:Connect(function()
                    BannaHub:Tween(TextboxInput, {BackgroundColor3 = Theme.Primary}, 0.2)
                end)
                
                TextboxInput.FocusLost:Connect(function()
                    BannaHub:Tween(TextboxInput, {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}, 0.2)
                end)
                
                updateSize()
                return Textbox
            end
            
            function Elements:CreateDropdown(name, options, callback)
                name = name or "Dropdown"
                options = options or {}
                callback = callback or function() end
                
                local Dropdown = Instance.new("Frame")
                local DropdownCorner = Instance.new("UICorner")
                local DropdownLabel = Instance.new("TextLabel")
                local DropdownButton = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")
                local DropdownArrow = Instance.new("TextLabel")
                local DropdownList = Instance.new("Frame")
                local ListCorner = Instance.new("UICorner")
                local ListContainer = Instance.new("ScrollingFrame")
                local ListLayout = Instance.new("UIListLayout")
                
                local isOpen = false
                local selectedOption = "Select Option"
                
                Dropdown.Name = name .. "Dropdown"
                Dropdown.Parent = SectionContainer
                Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                Dropdown.BorderSizePixel = 0
                Dropdown.Size = UDim2.new(1, 0, 0, 50)
                Dropdown.ClipsDescendants = true
                
                DropdownCorner.CornerRadius = UDim.new(0, 8)
                DropdownCorner.Parent = Dropdown
                
                DropdownLabel.Parent = Dropdown
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
                DropdownLabel.Size = UDim2.new(1, -30, 0.4, 0)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = name
                DropdownLabel.TextColor3 = Theme.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                DropdownButton.Parent = Dropdown
                DropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Position = UDim2.new(0, 15, 0.5, 0)
                DropdownButton.Size = UDim2.new(1, -30, 0, 20)
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = selectedOption
                DropdownButton.TextColor3 = Theme.Text
                DropdownButton.TextSize = 12
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.AutoButtonColor = false
                
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = DropdownButton
                
                DropdownArrow.Parent = DropdownButton
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
                DropdownArrow.Size = UDim2.new(0, 25, 1, 0)
                DropdownArrow.Font = Enum.Font.GothamBold
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = Theme.TextSecondary
                DropdownArrow.TextSize = 10
                
                DropdownList.Parent = Dropdown
                DropdownList.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
                DropdownList.BorderSizePixel = 0
                DropdownList.Position = UDim2.new(0, 15, 0, 70)
                DropdownList.Size = UDim2.new(1, -30, 0, 0)
                DropdownList.Visible = false
                
                ListCorner.CornerRadius = UDim.new(0, 6)
                ListCorner.Parent = DropdownList
                
                ListContainer.Parent = DropdownList
                ListContainer.BackgroundTransparency = 1
                ListContainer.BorderSizePixel = 0
                ListContainer.Size = UDim2.new(1, 0, 1, 0)
                ListContainer.ScrollBarThickness = 2
                ListContainer.ScrollBarImageColor3 = Theme.Primary
                
                ListLayout.Parent = ListContainer
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 2)
                
                local function createOption(option)
                    local OptionButton = Instance.new("TextButton")
                    local OptionCorner = Instance.new("UICorner")
                    
                    OptionButton.Parent = ListContainer
                    OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Theme.Text
                    OptionButton.TextSize = 11
                    OptionButton.AutoButtonColor = false
                    
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        DropdownButton.Text = selectedOption
                        
                        -- Close dropdown
                        isOpen = false
                        DropdownList.Visible = false
                        BannaHub:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 50)}, 0.2)
                        BannaHub:Tween(DropdownArrow, {Rotation = 0}, 0.2)
                        
                        callback(option)
                        updateSize()
                    end)
                    
                    -- Hover Effects
                    OptionButton.MouseEnter:Connect(function()
                        BannaHub:Tween(OptionButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        BannaHub:Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}, 0.2)
                    end)
                end
                
                for _, option in pairs(options) do
                    createOption(option)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        local listHeight = math.min(#options * 27, 120)
                        DropdownList.Size = UDim2.new(1, -30, 0, listHeight)
                        DropdownList.Visible = true
                        BannaHub:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 50 + listHeight + 20)}, 0.2)
                        BannaHub:Tween(DropdownArrow, {Rotation = 180}, 0.2)
                        
                        ListContainer.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
                    else
                        DropdownList.Visible = false
                        BannaHub:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 50)}, 0.2)
                        BannaHub:Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    end
                    
                    updateSize()
                end)
                
                -- Hover Effects
                DropdownButton.MouseEnter:Connect(function()
                    BannaHub:Tween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}, 0.2)
                end)
                
                DropdownButton.MouseLeave:Connect(function()
                    BannaHub:Tween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}, 0.2)
                end)
                
                updateSize()
                return Dropdown
            end
            
            function Elements:CreateKeybind(name, defaultKey, callback)
                name = name or "Keybind"
                defaultKey = defaultKey or Enum.KeyCode.E
                callback = callback or function() end
                
                local Keybind = Instance.new("Frame")
                local KeybindCorner = Instance.new("UICorner")
                local KeybindLabel = Instance.new("TextLabel")
                local KeybindButton = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")
                
                local currentKey = defaultKey
                local isBinding = false
                
                Keybind.Name = name .. "Keybind"
                Keybind.Parent = SectionContainer
                Keybind.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                Keybind.BorderSizePixel = 0
                Keybind.Size = UDim2.new(1, 0, 0, 35)
                
                KeybindCorner.CornerRadius = UDim.new(0, 8)
                KeybindCorner.Parent = Keybind
                
                KeybindLabel.Parent = Keybind
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
                KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
                KeybindLabel.Font = Enum.Font.Gotham
                KeybindLabel.Text = name
                KeybindLabel.TextColor3 = Theme.Text
                KeybindLabel.TextSize = 14
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                KeybindButton.Parent = Keybind
                KeybindButton.BackgroundColor3 = Theme.Primary
                KeybindButton.BorderSizePixel = 0
                KeybindButton.Position = UDim2.new(1, -80, 0.5, -12)
                KeybindButton.Size = UDim2.new(0, 65, 0, 24)
                KeybindButton.Font = Enum.Font.GothamBold
                KeybindButton.Text = currentKey.Name
                KeybindButton.TextColor3 = Theme.Text
                KeybindButton.TextSize = 11
                KeybindButton.AutoButtonColor = false
                
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = KeybindButton
                
                KeybindButton.MouseButton1Click:Connect(function()
                    if not isBinding then
                        isBinding = true
                        KeybindButton.Text = "..."
                        BannaHub:Tween(KeybindButton, {BackgroundColor3 = Theme.Warning}, 0.2)
                        
                        local connection
                        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                            if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                                currentKey = input.KeyCode
                                KeybindButton.Text = currentKey.Name
                                BannaHub:Tween(KeybindButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                                isBinding = false
                                connection:Disconnect()
                            end
                        end)
                    end
                end)
                
                -- Key detection
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.KeyCode == currentKey and not isBinding then
                        callback()
                    end
                end)
                
                -- Hover Effects
                KeybindButton.MouseEnter:Connect(function()
                    if not isBinding then
                        BannaHub:Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(100, 115, 255)}, 0.2)
                    end
                end)
                
                KeybindButton.MouseLeave:Connect(function()
                    if not isBinding then
                        BannaHub:Tween(KeybindButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                    end
                end)
                
                updateSize()
                return Keybind
            end
            
            function Elements:CreateLabel(text)
                text = text or "Label"
                
                local Label = Instance.new("Frame")
                local LabelCorner = Instance.new("UICorner")
                local LabelText = Instance.new("TextLabel")
                
                Label.Name = "Label"
                Label.Parent = SectionContainer
                Label.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                Label.BorderSizePixel = 0
                Label.Size = UDim2.new(1, 0, 0, 30)
                
                LabelCorner.CornerRadius = UDim.new(0, 8)
                LabelCorner.Parent = Label
                
                LabelText.Parent = Label
                LabelText.BackgroundTransparency = 1
                LabelText.Position = UDim2.new(0, 15, 0, 0)
                LabelText.Size = UDim2.new(1, -30, 1, 0)
                LabelText.Font = Enum.Font.Gotham
                LabelText.Text = text
                LabelText.TextColor3 = Theme.TextSecondary
                LabelText.TextSize = 13
                LabelText.TextXAlignment = Enum.TextXAlignment.Left
                
                updateSize()
                
                local LabelFunctions = {}
                function LabelFunctions:UpdateText(newText)
                    LabelText.Text = newText
                end
                
                return LabelFunctions
            end
            
            return Elements
        end
        
        return Tab
    end
    
    function Window:Toggle()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    return Window
end

-- ตัวอย่างการใช้งาน:
--[[
local Window = BannaHub:CreateWindow("Banna Hub")

local MainTab = Window:CreateTab("Main", "🏠")
local PlayerSection = MainTab:CreateSection("Player")

PlayerSection:CreateButton("Test Button", function()
    print("Button clicked!")
end)

PlayerSection:CreateToggle("Fly Mode", false, function(state)
    print("Fly:", state)
end)

PlayerSection:CreateSlider("Speed", 1, 100, 16, function(value)
    print("Speed:", value)
end)

PlayerSection:CreateTextbox("Username", "Enter username...", function(text)
    print("Username:", text)
end)

PlayerSection:CreateDropdown("Weapons", {"Sword", "Gun", "Bow"}, function(option)
    print("Selected:", option)
end)

PlayerSection:CreateKeybind("Toggle GUI", Enum.KeyCode.RightShift, function()
    Window:Toggle()
end)

local InfoSection = MainTab:CreateSection("Information")
local statusLabel = InfoSection:CreateLabel("Status: Ready")

-- Update label text
statusLabel:UpdateText("Status: Active")
--]]

return BannaHub
