-- BannaHub UI Library (From Scratch)
-- Designed for PC + Mobile
-- Single file usage: loadstring(game:HttpGet("..."))()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BannaHub = {}
BannaHub.__index = BannaHub

-- Theme colors
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(25, 25, 35),
    Primary = Color3.fromRGB(88, 101, 242),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    Accent = Color3.fromRGB(255, 170, 0)
}

-- Create draggable functionality
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
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Create window
function BannaHub:CreateWindow(config)
    config = config or {}
    local title = config.Name or "BannaHub"
    local theme = config.Theme or "Dark"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Header
    local Header = Instance.new("TextLabel")
    Header.Parent = MainFrame
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.Text = title
    Header.TextColor3 = Theme.Text
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 16

    -- Make draggable
    MakeDraggable(MainFrame, Header)

    -- Sidebar
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

    function BannaHub:CreateTab(name)
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
            btn.AutoButtonColor = true

            btn.MouseButton1Click:Connect(function()
                if cfg.Callback then
                    cfg.Callback()
                end
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

            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = cfg.Name .. ": " .. tostring(state)
                if cfg.Callback then
                    cfg.Callback(state)
                end
            end)
        end

        return TabAPI
    end

    return self
end

return BannaHub
