local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BannaHub = {}
BannaHub.__index = BannaHub

-- Themes
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

-- ทำให้ลากได้
local function MakeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            -- ป้องกันบัคกดแล้วเดิน
            if input.UserInputType == Enum.UserInputType.Touch then
                input.UserInputState = Enum.UserInputState.Begin
            end
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Gradient ให้ปุ่ม
local function ApplyGradient(button, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1, color2)
    gradient.Rotation = 90
    gradient.Parent = button
end

-- Hover Effect
local function AddHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
end

-- Notification
function BannaHub:Notify(text, time)
    local notif = Instance.new("TextLabel")
    notif.Text = text
    notif.Size = UDim2.new(0, 220, 0, 40)
    notif.BackgroundColor3 = Theme.Accent
    notif.TextColor3 = Theme.Text
    notif.Font = Enum.Font.Gotham
    notif.TextSize = 14
    notif.Parent = self.ScreenGui
    notif.Position = UDim2.new(1, 220, 1, -60)

    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -240, 1, -60)
    }):Play()

    task.delay(time or 2, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 220, 1, -60)
        }):Play()
        task.delay(0.3, function() notif:Destroy() end)
    end)
end

-- เปลี่ยนธีม
function BannaHub:SetTheme(themeName)
    if Themes[themeName] then
        Theme = Themes[themeName]
    end
end

-- สร้างปุ่ม Open/Close GUI
local function CreateToggleButton(library)
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Parent = ToggleGui
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    ToggleBtn.Position = UDim2.new(0.5, -40, 0, 10)
    ToggleBtn.Size = UDim2.new(0, 80, 0, 38)
    ToggleBtn.Font = Enum.Font.SourceSans
    ToggleBtn.Text = "Close Gui"
    ToggleBtn.TextColor3 = Color3.fromRGB(203, 122, 49)
    ToggleBtn.TextSize = 19
    ToggleBtn.AutoButtonColor = false

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = ToggleBtn

    MakeDraggable(ToggleBtn, ToggleBtn)

    ToggleBtn.MouseButton1Click:Connect(function()
        library.ScreenGui.Enabled = not library.ScreenGui.Enabled
        ToggleBtn.Text = library.ScreenGui.Enabled and "Close Gui" or "Open Gui"
    end)
end

-- สร้าง Window
function BannaHub:CreateWindow(config)
    config = config or {}
    local title = config.Name or "BannaHub"
    Theme = Themes[config.Theme] or Theme

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    self.ScreenGui = ScreenGui

    CreateToggleButton(self)

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local Header = Instance.new("TextLabel")
    Header.Parent = MainFrame
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.Text = title
    Header.TextColor3 = Theme.Text
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 16

    MakeDraggable(MainFrame, Header)

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
            if TabContent.Visible then return end
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
            AddHoverEffect(btn)
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
            AddHoverEffect(btn)
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = cfg.Name .. ": " .. tostring(state)
                if cfg.Callback then cfg.Callback(state) end
            end)
        end

        return TabAPI
    end

    return self
end

return BannaHub
