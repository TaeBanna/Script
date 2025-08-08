local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BannaHub = {}
BannaHub.__index = BannaHub

-- 🎨 Theme Styles
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 25),
        Sidebar = Color3.fromRGB(25, 25, 35),
        Primary = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 190),
        Accent = Color3.fromRGB(255, 170, 0)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Sidebar = Color3.fromRGB(230, 230, 240),
        Primary = Color3.fromRGB(0, 120, 215),
        Text = Color3.fromRGB(20, 20, 25),
        TextSecondary = Color3.fromRGB(80, 80, 90),
        Accent = Color3.fromRGB(0, 170, 140)
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 35),
        Sidebar = Color3.fromRGB(20, 40, 60),
        Primary = Color3.fromRGB(0, 180, 255),
        Text = Color3.fromRGB(220, 240, 255),
        TextSecondary = Color3.fromRGB(160, 190, 210),
        Accent = Color3.fromRGB(0, 220, 180)
    }
}
local Theme = Themes.Dark

-- 🖱 MakeDraggable function
local function MakeDraggable(frame, options)
    options = options or {}
    local threshold = options.threshold or 5
    local dragging = false
    local dragStartPos, dragStartInput
    local wasDragged = false

    local function update(input)
        if not dragging then return end
        local delta = input.Position - dragStartInput.Position
        if delta.Magnitude > threshold then wasDragged = true end
        frame.Position = UDim2.new(
            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = frame.Position
            dragStartInput = input
            wasDragged = false

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragStartInput then
            update(input)
        end
    end)

    return function()
        return wasDragged
    end
end

-- 🌈 Gradient for buttons
local function ApplyGradient(button, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1, color2)
    gradient.Rotation = 90
    gradient.Parent = button
end

-- 🔔 Notification
function BannaHub:Notify(text, time)
    local notif = Instance.new("TextLabel")
    notif.Text = text
    notif.Size = UDim2.new(0, 220, 0, 40)
    notif.BackgroundColor3 = Theme.Accent
    notif.TextColor3 = Theme.Text
    notif.Font = Enum.Font.Gotham
    notif.TextSize = 14
    notif.Parent = self.ScreenGui
    notif.Position = UDim2.new(1, 220, 0, 20)

    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -240, 0, 20)
    }):Play()

    task.delay(time or 2, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 220, 0, 20)
        }):Play()
        task.delay(0.3, function() notif:Destroy() end)
    end)
end

-- 🎨 Change Theme
function BannaHub:SetTheme(themeName)
    if Themes[themeName] then
        Theme = Themes[themeName]
    end
end

-- 📂 Create Window
function BannaHub:CreateWindow(config)
    config = config or {}
    local title = config.Name or "BannaHub"
    Theme = Themes[config.Theme] or Theme

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    self.ScreenGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)

    local Header = Instance.new("TextLabel")
    Header.Parent = MainFrame
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.Text = title
    Header.TextColor3 = Theme.Text
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 16

    MakeDraggable(MainFrame)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.Size = UDim2.new(0, 120, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, -120, 1, -30)
    ContentFrame.Position = UDim2.new(0, 120, 0, 30)

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = Sidebar
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    local Tabs = {}

    function self:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = Sidebar
        TabButton.Text = name
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.BackgroundTransparency = 1
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14

        local TabContent = Instance.new("Frame")
        TabContent.Parent = ContentFrame
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Visible = false

        local ElementList = Instance.new("UIListLayout")
        ElementList.Parent = TabContent
        ElementList.Padding = UDim.new(0, 5)
        ElementList.SortOrder = Enum.SortOrder.LayoutOrder

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Content.Visible = false
                t.Button.TextColor3 = Theme.TextSecondary
            end
            TabContent.Visible = true
            TabButton.TextColor3 = Theme.Primary
        end)

        table.insert(Tabs, {Button = TabButton, Content = TabContent})

        local TabAPI = {}

        function TabAPI:CreateButton(cfg)
            local btn = Instance.new("TextButton")
            btn.Parent = TabContent
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Text = cfg.Name or "Button"
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Theme.Text
            btn.BackgroundColor3 = Theme.Primary
            ApplyGradient(btn, Theme.Primary, Theme.Accent)
            btn.MouseButton1Click:Connect(function()
                if cfg.Callback then cfg.Callback() end
            end)
        end

        function TabAPI:CreateToggle(cfg)
            local state = cfg.CurrentValue or false
            local btn = Instance.new("TextButton")
            btn.Parent = TabContent
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Text = cfg.Name .. ": " .. tostring(state)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Theme.Text
            btn.BackgroundColor3 = Theme.Accent
            ApplyGradient(btn, Theme.Accent, Theme.Primary)
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = cfg.Name .. ": " .. tostring(state)
                if cfg.Callback then cfg.Callback(state) end
            end)
        end

        -- 📂 DropDown
        function TabAPI:CreateDropdown(cfg)
            local current = cfg.CurrentOption or cfg.Options[1]
            local holder = Instance.new("Frame")
            holder.Parent = TabContent
            holder.Size = UDim2.new(1, -10, 0, 30)
            holder.BackgroundColor3 = Theme.Sidebar

            local label = Instance.new("TextButton")
            label.Parent = holder
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = cfg.Name .. ": " .. current
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Theme.Text

            local open = false
            label.MouseButton1Click:Connect(function()
                open = not open
                for _, child in ipairs(holder:GetChildren()) do
                    if child:IsA("TextButton") and child ~= label then
                        child.Visible = open
                    end
                end
            end)

            for _, option in ipairs(cfg.Options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = holder
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.Position = UDim2.new(0, 0, 1, (#holder:GetChildren()-2) * 30)
                optBtn.Text = option
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 14
                optBtn.TextColor3 = Theme.Text
                optBtn.Visible = false

                optBtn.MouseButton1Click:Connect(function()
                    current = option
                    label.Text = cfg.Name .. ": " .. current
                    open = false
                    for _, child in ipairs(holder:GetChildren()) do
                        if child:IsA("TextButton") and child ~= label then
                            child.Visible = false
                        end
                    end
                    if cfg.Callback then cfg.Callback(current) end
                end)
            end
        end

        return TabAPI
    end

    return self
end

return BannaHub
