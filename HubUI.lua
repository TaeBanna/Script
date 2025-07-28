-- HubUI.lua
-- โค้ดหลัก UI โหลด config Tab จาก GitHub แล้วสร้าง UI

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HubUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainColor = Color3.fromRGB(40, 40, 50)
local accentColor = Color3.fromRGB(0, 170, 255)
local textColor = Color3.fromRGB(240, 240, 240)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = mainColor
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Visible = false

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundColor3 = accentColor
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Hub"
titleLabel.TextColor3 = textColor
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.Parent = mainFrame

local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(0, 100, 1, -50)
tabFrame.Position = UDim2.new(0, 0, 0, 50)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = tabFrame

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 8)
tabPadding.PaddingLeft = UDim.new(0, 4)
tabPadding.PaddingRight = UDim.new(0, 4)
tabPadding.Parent = tabFrame

local pageFrame = Instance.new("Frame")
pageFrame.Name = "PageFrame"
pageFrame.Size = UDim2.new(1, -100, 1, -50)
pageFrame.Position = UDim2.new(0, 100, 0, 50)
pageFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
pageFrame.BorderSizePixel = 0
pageFrame.Parent = mainFrame

local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Name = "ContentScroll"
contentScroll.Size = UDim2.new(1, 0, 1, 0)
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.ScrollBarThickness = 8
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.Parent = pageFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 8)
contentLayout.Parent = contentScroll

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 8)
contentPadding.PaddingLeft = UDim.new(0, 8)
contentPadding.PaddingRight = UDim.new(0, 8)
contentPadding.Parent = contentScroll

contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 12)
end)

local toggleUIButton = Instance.new("TextButton")
toggleUIButton.Name = "ToggleUIButton"
toggleUIButton.Size = UDim2.new(0, 100, 0, 40)
toggleUIButton.Position = UDim2.new(0, 20, 0, 20)
toggleUIButton.BackgroundColor3 = accentColor
toggleUIButton.BorderSizePixel = 0
toggleUIButton.Text = "Toggle UI"
toggleUIButton.TextColor3 = textColor
toggleUIButton.Font = Enum.Font.GothamBold
toggleUIButton.TextSize = 18
toggleUIButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleUIButton

toggleUIButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local function createTab(name, contentItems)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = textColor
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 16
    tabButton.Parent = tabFrame

    local tabButtonCorner = Instance.new("UICorner")
    tabButtonCorner.CornerRadius = UDim.new(0, 6)
    tabButtonCorner.Parent = tabButton

    local pageContent = Instance.new("Frame")
    pageContent.Size = UDim2.new(1, 0, 0, 0)
    pageContent.BackgroundTransparency = 1
    pageContent.Parent = contentScroll
    pageContent.Visible = false

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = pageContent

    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 8)
    pagePadding.PaddingLeft = UDim.new(0, 8)
    pagePadding.PaddingRight = UDim.new(0, 8)
    pagePadding.Parent = pageContent

    for _, item in ipairs(contentItems) do
        if item.Type == "Button" then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = accentColor
            btn.BorderSizePixel = 0
            btn.Text = item.Text or "Button"
            btn.TextColor3 = textColor
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.Parent = pageContent

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn

            if item.OnClick then
                btn.MouseButton1Click:Connect(item.OnClick)
            end

        elseif item.Type == "Toggle" then
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 40)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = pageContent

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = item.Text or "Toggle"
            toggleLabel.TextColor3 = textColor
            toggleLabel.Font = Enum.Font.GothamBold
            toggleLabel.TextSize = 16
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0.3, -8, 0.6, 0)
            toggleBtn.Position = UDim2.new(0.7, 8, 0.2, 0)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Text = "Off"
            toggleBtn.TextColor3 = textColor
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.TextSize = 14
            toggleBtn.Parent = toggleFrame

            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 8)
            toggleCorner.Parent = toggleBtn

            local toggled = false
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    toggleBtn.BackgroundColor3 = accentColor
                    toggleBtn.Text = "On"
                else
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    toggleBtn.Text = "Off"
                end

                if item.OnToggle then
                    item.OnToggle(toggled)
                end
            end)
        end
    end

    tabButton.MouseButton1Click:Connect(function()
        for _, page in ipairs(contentScroll:GetChildren()) do
            if page:IsA("Frame") then
                page.Visible = false
            end
        end
        pageContent.Visible = true

        for _, btn in ipairs(tabFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            end
        end
        tabButton.BackgroundColor3 = accentColor
    end)

    return tabButton, pageContent
end

-- โหลด TabsConfig.lua จาก GitHub
local configUrl = "https://raw.githubusercontent.com/USERNAME/REPO_NAME/main/TabsConfig.lua" -- แก้เป็นของคุณ

local tabsData = nil
local success, result = pcall(function()
    return HttpService:GetAsync(configUrl)
end)

if success then
    local func, err = loadstring(result)
    if func then
        tabsData = func()
    else
        warn("Loadstring error: " .. err)
    end
else
    warn("Failed to load TabsConfig: " .. result)
end

if tabsData then
    for _, tab in ipairs(tabsData) do
        createTab(tab.Name, tab.Content)
    end

    -- แสดง Tab แรกอัตโนมัติ
    local firstTabButton = tabFrame:FindFirstChildOfClass("TextButton")
    if firstTabButton then
        firstTabButton.BackgroundColor3 = accentColor
        -- แสดงเนื้อหาของ Tab แรก
        for _, page in ipairs(contentScroll:GetChildren()) do
            if page:IsA("Frame") then
                page.Visible = true
                break
            end
        end
    end
end
