local lib = {}

local Script_Title = "Arceus X <font color=\"rgb(255, 0, 0)\">|</font> Enhanced UI"

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Device Detection
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function isTablet()
    return UserInputService.TouchEnabled and UserInputService.KeyboardEnabled
end

-- Responsive sizing based on device
local function getResponsiveSize()
    if isMobile() then
        return {
            main = UDim2.new(0.85, 0, 0.6, 0),
            collapsed = UDim2.new(0.15, 0, 0.25, 0),
            element_height = 60
        }
    elseif isTablet() then
        return {
            main = UDim2.new(0.5, 0, 0.45, 0),
            collapsed = UDim2.new(0.12, 0, 0.2, 0),
            element_height = 55
        }
    else -- Desktop
        return {
            main = UDim2.new(0.35, 0, 0.35, 0),
            collapsed = UDim2.new(0.1, 0, 0.175, 0),
            element_height = 50
        }
    end
end

local responsive = getResponsiveSize()

-- Instances:
local Arceus = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local DropShadow = Instance.new("Frame")
local DropShadowCorner = Instance.new("UICorner")
local Intro = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Logo = Instance.new("ImageButton")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local Title = Instance.new("TextLabel")
local TitleGradient = Instance.new("UIGradient")
local Menu = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")
local TopBar = Instance.new("Frame")
local TopBarCorner = Instance.new("UICorner")
local MinimizeBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local DragArea = Instance.new("Frame")

-- Element Templates
local Toggle = Instance.new("ImageButton")
local UICorner_3 = Instance.new("UICorner")
local ToggleGradient = Instance.new("UIGradient")
local Enabled = Instance.new("Frame")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
local UICorner_4 = Instance.new("UICorner")
local Check = Instance.new("Frame")
local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
local UICorner_5 = Instance.new("UICorner")
local CheckGradient = Instance.new("UIGradient")
local ToggleName = Instance.new("TextLabel")
local ToggleTextGradient = Instance.new("UIGradient")

local Button = Instance.new("ImageButton")
local UICorner_6 = Instance.new("UICorner")
local ButtonGradient = Instance.new("UIGradient")
local ButtonName = Instance.new("TextLabel")
local ButtonTextGradient = Instance.new("UIGradient")
local ButtonRipple = Instance.new("Frame")

local tab = Instance.new("Frame")
local ComboElem = Instance.new("ImageButton")
local UICorner_7 = Instance.new("UICorner")
local ComboElemGradient = Instance.new("UIGradient")
local ComboElemName = Instance.new("TextLabel")
local ComboElemTextGradient = Instance.new("UIGradient")
local ComboImg = Instance.new("TextLabel")
local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")

local ComboBox = Instance.new("ImageButton")
local UICorner_8 = Instance.new("UICorner")
local ComboBoxGradient = Instance.new("UIGradient")
local ComboBoxName = Instance.new("TextLabel")
local ComboBoxTextGradient = Instance.new("UIGradient")
local ComboImg_2 = Instance.new("TextLabel")
local UIAspectRatioConstraint_5 = Instance.new("UIAspectRatioConstraint")

-- Properties:
Arceus.Name = "ArceusEnhanced"
Arceus.Enabled = true
Arceus.ResetOnSpawn = false
Arceus.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Arceus.DisplayOrder = 999999999

-- Drop Shadow
DropShadow.Name = "DropShadow"
DropShadow.Parent = Arceus
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.BackgroundTransparency = 0.7
DropShadow.BorderSizePixel = 0
DropShadow.Position = UDim2.new(0.5, 2, 0.5, 2)
DropShadow.Size = responsive.main
DropShadow.ZIndex = 0

DropShadowCorner.CornerRadius = UDim.new(0.08, 0)
DropShadowCorner.Parent = DropShadow

-- Main Frame
Main.Name = "Main"
Main.Parent = Arceus
Main.Active = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, 0, -0.2, 0)
Main.Size = responsive.main
Main.ZIndex = 1

UICorner.CornerRadius = UDim.new(0.08, 0)
UICorner.Parent = Main

-- Top Bar for better UX
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0.15, 0)
TopBar.ZIndex = 2

TopBarCorner.CornerRadius = UDim.new(0.08, 0)
TopBarCorner.Parent = TopBar

-- Drag Area (invisible but functional)
DragArea.Name = "DragArea"
DragArea.Parent = TopBar
DragArea.BackgroundTransparency = 1
DragArea.Size = UDim2.new(0.7, 0, 1, 0)
DragArea.ZIndex = 3

-- Enhanced dragging system
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    DropShadow.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset + 2, Main.Position.Y.Scale, Main.Position.Y.Offset + 2)
end

DragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DragArea.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateInput(input)
        end
    end
end)

-- Control Buttons
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(0.85, 0, 0.5, 0)
MinimizeBtn.Size = UDim2.new(0.06, 0, 0.6, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextScaled = true
MinimizeBtn.ZIndex = 3

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0.5, 0)
MinimizeCorner.Parent = MinimizeBtn

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(0.95, 0, 0.5, 0)
CloseBtn.Size = UDim2.new(0.06, 0, 0.6, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.ZIndex = 3

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.5, 0)
CloseCorner.Parent = CloseBtn

-- Intro Frame
Intro.Name = "Intro"
Intro.Parent = Main
Intro.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Intro.ClipsDescendants = true
Intro.Size = UDim2.new(1, 0, 1, 0)
Intro.ZIndex = 4

UICorner_2.CornerRadius = UDim.new(0.08, 0)
UICorner_2.Parent = Intro

-- Enhanced Logo
Logo.Parent = Intro
Logo.AnchorPoint = Vector2.new(0.5, 0.5)
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 1
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
Logo.Size = UDim2.new(0.6, 0, 0.6, 0)
Logo.ZIndex = 5
Logo.Image = "http://www.roblox.com/asset/?id=9178187770"
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Active = false

UIAspectRatioConstraint.Parent = Logo

-- Enhanced Title
Title.Name = "Title"
Title.Parent = TopBar
Title.AnchorPoint = Vector2.new(0, 0.5)
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0.15, 0, 0.5, 0)
Title.Size = UDim2.new(0.5, 0, 0.8, 0)
Title.Font = Enum.Font.GothamBold
Title.RichText = true
Title.Text = Script_Title
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.ZIndex = 3

TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 255))
}
TitleGradient.Parent = Title

-- Enhanced Menu
Menu.Name = "Menu"
Menu.Parent = Main
Menu.Active = true
Menu.AnchorPoint = Vector2.new(0.5, 1)
Menu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Menu.BackgroundTransparency = 1
Menu.AutomaticCanvasSize = Enum.AutomaticSize.Y
Menu.BorderSizePixel = 0
Menu.Position = UDim2.new(0.5, 0, 0.98, 0)
Menu.Size = UDim2.new(0.95, 0, 0.8, 0)
Menu.CanvasSize = UDim2.new(0, 0, 0, 0)
Menu.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
Menu.ScrollBarThickness = isMobile() and 8 or 6
Menu.ZIndex = 2

UIListLayout.Parent = Menu
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

UIPadding.Parent = Menu
UIPadding.PaddingBottom = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.PaddingTop = UDim.new(0, 10)

-- Enhanced Toggle Template
Toggle.Name = "Toggle"
Toggle.Visible = false
Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Toggle.Size = UDim2.new(1, 0, 0, responsive.element_height)
Toggle.ZIndex = 2

UICorner_3.CornerRadius = UDim.new(0.2, 0)
UICorner_3.Parent = Toggle

ToggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(50, 50, 70)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 55))
}
ToggleGradient.Rotation = 45
ToggleGradient.Parent = Toggle

Enabled.Name = "Enabled"
Enabled.Parent = Toggle
Enabled.AnchorPoint = Vector2.new(1, 0.5)
Enabled.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
Enabled.Position = UDim2.new(0.95, 0, 0.5, 0)
Enabled.Size = UDim2.new(0, responsive.element_height * 0.6, 0, responsive.element_height * 0.6)

UIAspectRatioConstraint_2.Parent = Enabled

UICorner_4.CornerRadius = UDim.new(0.3, 0)
UICorner_4.Parent = Enabled

Check.Name = "Check"
Check.Parent = Enabled
Check.AnchorPoint = Vector2.new(0.5, 0.5)
Check.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Check.Position = UDim2.new(0.5, 0, 0.5, 0)
Check.Size = UDim2.new(0.65, 0, 0.65, 0)
Check.Visible = false

UIAspectRatioConstraint_3.Parent = Check

UICorner_5.CornerRadius = UDim.new(0.3, 0)
UICorner_5.Parent = Check

CheckGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 80, 80)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 50, 50))
}
CheckGradient.Parent = Check

ToggleName.Name = "Name"
ToggleName.Parent = Toggle
ToggleName.AnchorPoint = Vector2.new(0, 0.5)
ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleName.BackgroundTransparency = 1
ToggleName.BorderSizePixel = 0
ToggleName.Position = UDim2.new(0.05, 0, 0.5, 0)
ToggleName.Size = UDim2.new(0.7, 0, 0.6, 0)
ToggleName.Font = Enum.Font.Gotham
ToggleName.Text = "Toggle"
ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleName.TextScaled = true
ToggleName.TextXAlignment = Enum.TextXAlignment.Left
ToggleName.TextYAlignment = Enum.TextYAlignment.Center

ToggleTextGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 255))
}
ToggleTextGradient.Parent = ToggleName

-- Enhanced Button Template
Button.Name = "Button"
Button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Button.Size = UDim2.new(1, 0, 0, responsive.element_height)
Button.ZIndex = 2

UICorner_6.CornerRadius = UDim.new(0.2, 0)
UICorner_6.Parent = Button

ButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(60, 60, 85)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 55))
}
ButtonGradient.Rotation = 45
ButtonGradient.Parent = Button

ButtonName.Name = "Name"
ButtonName.Parent = Button
ButtonName.AnchorPoint = Vector2.new(0.5, 0.5)
ButtonName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ButtonName.BackgroundTransparency = 1
ButtonName.BorderSizePixel = 0
ButtonName.Position = UDim2.new(0.5, 0, 0.5, 0)
ButtonName.Size = UDim2.new(0.9, 0, 0.6, 0)
ButtonName.Font = Enum.Font.Gotham
ButtonName.Text = "Button"
ButtonName.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonName.TextScaled = true
ButtonName.TextXAlignment = Enum.TextXAlignment.Center
ButtonName.TextYAlignment = Enum.TextYAlignment.Center

ButtonTextGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 255))
}
ButtonTextGradient.Parent = ButtonName

-- Tab Spacer
tab.Name = "Tab"
tab.Visible = false
tab.BackgroundTransparency = 1
tab.Size = UDim2.new(1, 0, 0, 8)

-- Enhanced ComboBox Elements
ComboElem.Name = "ComboElem"
ComboElem.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
ComboElem.Size = UDim2.new(1, 0, 0, responsive.element_height)

UICorner_7.CornerRadius = UDim.new(0.2, 0)
UICorner_7.Parent = ComboElem

ComboElemGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 55, 75)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(45, 45, 60))
}
ComboElemGradient.Rotation = 180
ComboElemGradient.Parent = ComboElem

ComboElemName.Name = "Name"
ComboElemName.Parent = ComboElem
ComboElemName.AnchorPoint = Vector2.new(0, 0.5)
ComboElemName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ComboElemName.BackgroundTransparency = 1
ComboElemName.BorderSizePixel = 0
ComboElemName.Position = UDim2.new(0.05, 0, 0.5, 0)
ComboElemName.Size = UDim2.new(0.75, 0, 0.6, 0)
ComboElemName.Font = Enum.Font.Gotham
ComboElemName.Text = "Option"
ComboElemName.TextColor3 = Color3.fromRGB(255, 255, 255)
ComboElemName.TextScaled = true
ComboElemName.TextXAlignment = Enum.TextXAlignment.Left
ComboElemName.TextYAlignment = Enum.TextYAlignment.Center

ComboElemTextGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 255))
}
ComboElemTextGradient.Parent = ComboElemName

ComboImg.Name = "Img"
ComboImg.Parent = ComboElem
ComboImg.AnchorPoint = Vector2.new(1, 0.5)
ComboImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ComboImg.BackgroundTransparency = 1
ComboImg.BorderSizePixel = 0
ComboImg.Position = UDim2.new(0.95, 0, 0.5, 0)
ComboImg.Rotation = 90
ComboImg.Size = UDim2.new(0, responsive.element_height * 0.4, 0, responsive.element_height * 0.4)
ComboImg.Font = Enum.Font.GothamBold
ComboImg.Text = "▶"
ComboImg.TextColor3 = Color3.fromRGB(255, 255, 255)
ComboImg.TextScaled = true

UIAspectRatioConstraint_4.Parent = ComboImg

ComboBox.Name = "ComboBox"
ComboBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
ComboBox.Size = UDim2.new(1, 0, 0, responsive.element_height)

UICorner_8.CornerRadius = UDim.new(0.2, 0)
UICorner_8.Parent = ComboBox

ComboBoxGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(50, 50, 70)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 55))
}
ComboBoxGradient.Parent = ComboBox

ComboBoxName.Name = "Name"
ComboBoxName.Parent = ComboBox
ComboBoxName.AnchorPoint = Vector2.new(0, 0.5)
ComboBoxName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ComboBoxName.BackgroundTransparency = 1
ComboBoxName.BorderSizePixel = 0
ComboBoxName.Position = UDim2.new(0.05, 0, 0.5, 0)
ComboBoxName.Size = UDim2.new(0.75, 0, 0.6, 0)
ComboBoxName.Font = Enum.Font.Gotham
ComboBoxName.Text = "ComboBox"
ComboBoxName.TextColor3 = Color3.fromRGB(255, 255, 255)
ComboBoxName.TextScaled = true
ComboBoxName.TextXAlignment = Enum.TextXAlignment.Left
ComboBoxName.TextYAlignment = Enum.TextYAlignment.Center

ComboBoxTextGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200, 200, 255))
}
ComboBoxTextGradient.Parent = ComboBoxName

ComboImg_2.Name = "Img"
ComboImg_2.Parent = ComboBox
ComboImg_2.AnchorPoint = Vector2.new(1, 0.5)
ComboImg_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ComboImg_2.BackgroundTransparency = 1
ComboImg_2.BorderSizePixel = 0
ComboImg_2.Rotation = 180
ComboImg_2.Position = UDim2.new(0.95, 0, 0.5, 0)
ComboImg_2.Size = UDim2.new(0, responsive.element_height * 0.4, 0, responsive.element_height * 0.4)
ComboImg_2.Font = Enum.Font.GothamBold
ComboImg_2.Text = "▶"
ComboImg_2.TextColor3 = Color3.fromRGB(255, 50, 50)
ComboImg_2.TextScaled = true

UIAspectRatioConstraint_5.Parent = ComboImg_2

-- Enhanced Animation Functions
local function createRippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Parent = button
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = button.ZIndex + 1
    
    local rippleCorner = Instance.new("UICorner")
    rippleCorner.CornerRadius = UDim.new(1, 0)
    rippleCorner.Parent = ripple
    
    local expandTween = TweenService:Create(
        ripple,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}
    )
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function animateButton(button, scale)
    scale = scale or 0.95
    local originalSize = button.Size
    
    TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset, originalSize.Y.Scale * scale, originalSize.Y.Offset)}
    ):Play()
    
    wait(0.1)
    
    TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = originalSize}
    ):Play()
end

-- Enhanced Close Animation
local isMinimized = false

local function closeAnimation()
    Logo.Active = true
    
    -- Fade out content
    TweenService:Create(Intro, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
    
    wait(0.35)
    
    -- Animate logo
    Logo:TweenSizeAndPosition(
        UDim2.fromScale(0.6, 0.6),
        UDim2.fromScale(0.5, 0.5),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.3, true, nil
    )
    
    wait(0.35)
    
    -- Shrink main frame
    local shrinkTween = TweenService:Create(
        Main,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = responsive.collapsed}
    )
    
    local shadowShrinkTween = TweenService:Create(
        DropShadow,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = responsive.collapsed}
    )
    
    shrinkTween:Play()
    shadowShrinkTween:Play()
    
    wait(0.45)
    
    -- Hide UI elements
    for _, obj in pairs(Main:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= Intro and obj ~= TopBar then
            obj.Visible = false
        end
    end
    
    TopBar.Visible = false
    
    -- Final fade effects
    TweenService:Create(Logo, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 0.3}):Play()
    TweenService:Create(Intro, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0.8}):Play()
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 0.5}):Play()
    
    isMinimized = true
end

local function openAnimation()
    if not isMinimized then return end
    
    Logo.Active = false
    isMinimized = false
    
    -- Restore transparency
    TweenService:Create(Logo, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
    TweenService:Create(Intro, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    
    wait(0.35)
    
    -- Expand main frame
    local expandTween = TweenService:Create(
        Main,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = responsive.main}
    )
    
    local shadowExpandTween = TweenService:Create(
        DropShadow,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = responsive.main}
    )
    
    expandTween:Play()
    shadowExpandTween:Play()
    
    wait(0.45)
    
    -- Animate logo to corner
    Logo:TweenSizeAndPosition(
        UDim2.fromScale(0.12, 0.8),
        UDim2.fromScale(0.06, 0.5),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.3, true, nil
    )
    
    -- Show UI elements
    TopBar.Visible = true
    for _, obj in pairs(Main:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= Intro then
            obj.Visible = true
        end
    end
    
    wait(0.35)
    
    -- Fade out intro
    TweenService:Create(Intro, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
end

-- Connect Events
CloseBtn.MouseButton1Click:Connect(function()
    createRippleEffect(CloseBtn)
    animateButton(CloseBtn)
    closeAnimation()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    createRippleEffect(MinimizeBtn)
    animateButton(MinimizeBtn)
    closeAnimation()
end)

Logo.MouseButton1Click:Connect(function()
    createRippleEffect(Logo)
    openAnimation()
end)

-- Enhanced hover effects
local function addHoverEffect(button, hoverColor, normalColor)
    local isHovering = false
    
    button.MouseEnter:Connect(function()
        if not isHovering then
            isHovering = true
            TweenService:Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = hoverColor}
            ):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if isHovering then
            isHovering = false
            TweenService:Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = normalColor}
            ):Play()
        end
    end)
end

-- Add hover effects to control buttons
addHoverEffect(CloseBtn, Color3.fromRGB(255, 70, 90), Color3.fromRGB(220, 53, 69))
addHoverEffect(MinimizeBtn, Color3.fromRGB(255, 210, 30), Color3.fromRGB(255, 193, 7))

-- UI Parent Detection
local function getUIParent()
    local success, parent = pcall(function()
        return gethui and gethui() or game:GetService("CoreGui")
    end)
    
    if not success then
        return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    return parent
end

-- Initialize UI
local success, err = pcall(function()
    Arceus.Parent = getUIParent()
end)

if not success then
    Arceus.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Responsive UI Updates
local function updateResponsiveUI()
    local newResponsive = getResponsiveSize()
    responsive = newResponsive
    
    if not isMinimized then
        Main.Size = responsive.main
        DropShadow.Size = responsive.main
    else
        Main.Size = responsive.collapsed
        DropShadow.Size = responsive.collapsed
    end
    
    Menu.ScrollBarThickness = isMobile() and 8 or 6
end

-- Listen for device orientation changes
if UserInputService.TouchEnabled then
    local function onOrientationChanged()
        wait(0.1) -- Small delay to let the screen adjust
        updateResponsiveUI()
    end
    
    -- This is a simplified approach - in a real scenario you might want to detect actual orientation changes
    RunService.Heartbeat:Connect(function()
        -- You could add orientation detection logic here if needed
    end)
end

local elements = 0

local function AddSpace(parent)
    local space = tab:Clone()
    space.Parent = parent
    space.LayoutOrder = elements
    space.Visible = true
    elements += 1
end

-- Enhanced Library Functions
function lib:AddToggle(name, funct, enabled, ...)
    local newTog = Toggle:Clone()
    local args = {...}
    
    -- Enhanced click handling
    newTog.MouseButton1Click:Connect(function()
        enabled = not enabled
        local check = newTog:WaitForChild("Enabled"):WaitForChild("Check")
        
        -- Animate toggle
        animateButton(newTog, 0.98)
        createRippleEffect(newTog)
        
        -- Animate check with bounce effect
        if enabled then
            check.Visible = true
            check.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(
                check,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0.65, 0, 0.65, 0)}
            ):Play()
        else
            TweenService:Create(
                check,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Size = UDim2.new(0, 0, 0, 0)}
            ):Play()
            
            wait(0.2)
            check.Visible = false
        end
        
        funct(enabled, unpack(args))
    end)
    
    -- Add hover effect
    addHoverEffect(newTog, Color3.fromRGB(50, 50, 70), Color3.fromRGB(40, 40, 55))
    
    newTog:WaitForChild("Enabled"):WaitForChild("Check").Visible = enabled
    newTog:WaitForChild("Name").Text = name
    newTog.Size = UDim2.new(1, 0, 0, responsive.element_height)
    newTog.Name = name
    newTog.Parent = Menu
    newTog.LayoutOrder = elements
    newTog.Visible = true
    
    elements += 1
    AddSpace(Menu)
    
    return newTog
end

function lib:AddButton(name, funct, ...)
    local newBut = Button:Clone()
    local args = {...}
    
    newBut.MouseButton1Click:Connect(function()
        animateButton(newBut, 0.95)
        createRippleEffect(newBut)
        funct(unpack(args))
    end)
    
    -- Add hover effect
    addHoverEffect(newBut, Color3.fromRGB(60, 60, 85), Color3.fromRGB(40, 40, 55))
    
    newBut:WaitForChild("Name").Text = name
    newBut.Size = UDim2.new(1, 0, 0, responsive.element_height)
    newBut.Name = name
    newBut.Parent = Menu
    newBut.LayoutOrder = elements
    newBut.Visible = true
    
    elements += 1
    AddSpace(Menu)
    
    return newBut
end

function lib:AddComboBox(text, options, funct, ...)
    local newCombo = ComboBox:Clone()
    local enabled = false
    local elems = {}
    local args = {...}
    
    local function setBoxState()
        local img = newCombo:WaitForChild("Img")
        
        -- Animate arrow rotation
        TweenService:Create(
            img,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Rotation = enabled and 270 or 180}
        ):Play()
        
        -- Animate elements with stagger effect
        for i, elem in ipairs(elems) do
            if enabled then
                elem.Visible = true
                elem.Size = UDim2.new(1, 0, 0, 0)
                
                wait(0.05 * i) -- Stagger animation
                
                TweenService:Create(
                    elem,
                    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Size = UDim2.new(1, 0, 0, responsive.element_height)}
                ):Play()
            else
                TweenService:Create(
                    elem,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {Size = UDim2.new(1, 0, 0, 0)}
                ):Play()
                
                wait(0.05 * (i + 1))
                elem.Visible = false
            end
        end
    end
    
    newCombo.MouseButton1Click:Connect(function()
        enabled = not enabled
        animateButton(newCombo, 0.98)
        createRippleEffect(newCombo)
        setBoxState()
    end)
    
    -- Add hover effect
    addHoverEffect(newCombo, Color3.fromRGB(50, 50, 70), Color3.fromRGB(40, 40, 55))
    
    newCombo:WaitForChild("Name").Text = text .. ": " .. (#options > 0 and options[1] or "None")
    newCombo.Size = UDim2.new(1, 0, 0, responsive.element_height)
    newCombo.Name = #options > 0 and options[1] or "ComboBox"
    newCombo.Parent = Menu
    newCombo.LayoutOrder = elements
    newCombo.Visible = true
    
    elements += 1
    AddSpace(Menu)
    
    for i, optionName in ipairs(options) do
        local newElem = ComboElem:Clone()
        table.insert(elems, newElem)
        
        newElem.MouseButton1Click:Connect(function()
            newCombo:WaitForChild("Name").Text = text .. ": " .. optionName
            enabled = false
            
            animateButton(newElem, 0.95)
            createRippleEffect(newElem)
            
            setBoxState()
            funct(optionName, unpack(args))
        end)
        
        -- Add hover effect
        addHoverEffect(newElem, Color3.fromRGB(60, 60, 85), Color3.fromRGB(45, 45, 60))
        
        newElem:WaitForChild("Name").Text = optionName
        newElem.Size = UDim2.new(1, 0, 0, responsive.element_height)
        newElem.Name = optionName
        newElem.Parent = Menu
        newElem.LayoutOrder = elements
        newElem.Visible = false
        
        elements += 1
        AddSpace(Menu)
    end
    
    return newCombo
end

-- Enhanced customization functions
function lib:SetTitle(txt)
    Title.Text = txt
end

function lib:SetIcon(img)
    Logo.Image = img
end

function lib:SetBackgroundColor(r, g, b)
    local color = Color3.fromRGB(r, g, b)
    Main.BackgroundColor3 = color
    Intro.BackgroundColor3 = color
    DropShadow.BackgroundColor3 = Color3.fromRGB(math.max(0, r-20), math.max(0, g-20), math.max(0, b-20))
end

function lib:SetTitleColor(r, g, b)
    Title.TextColor3 = Color3.fromRGB(r, g, b)
end

function lib:SetAccentColor(r, g, b)
    local color = Color3.fromRGB(r, g, b)
    CloseBtn.BackgroundColor3 = color
    ComboImg_2.TextColor3 = color
    Check.BackgroundColor3 = color
    
    -- Update gradients
    CheckGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(math.min(255, r+30), math.min(255, g+30), math.min(255, b+30))), 
        ColorSequenceKeypoint.new(1.00, color)
    }
end

function lib:SetButtonsColor(r, g, b)
    local color = Color3.fromRGB(r, g, b)
    Toggle.BackgroundColor3 = color
    Button.BackgroundColor3 = color
    ComboElem.BackgroundColor3 = Color3.fromRGB(math.min(255, r+5), math.min(255, g+5), math.min(255, b+5))
    ComboBox.BackgroundColor3 = color
    TopBar.BackgroundColor3 = Color3.fromRGB(math.min(255, r+10), math.min(255, g+10), math.min(255, b+10))
end

-- Enhanced theme system
function lib:SetTheme(theme)
    if theme == "Default" then
        lib:SetBackgroundColor(25, 25, 35)
        lib:SetButtonsColor(40, 40, 55)
        lib:SetAccentColor(255, 50, 50)
        lib:SetTitleColor(255, 255, 255)
    elseif theme == "TomorrowNightBlue" then
        lib:SetBackgroundColor(5, 16, 58)
        lib:SetButtonsColor(74, 208, 238)
        lib:SetAccentColor(74, 208, 238)
        lib:SetTitleColor(255, 255, 255)
    elseif theme == "HighContrast" then
        lib:SetBackgroundColor(0, 0, 0)
        lib:SetButtonsColor(30, 30, 30)
        lib:SetAccentColor(255, 255, 0)
        lib:SetTitleColor(255, 255, 255)
    elseif theme == "Aqua" then
        lib:SetBackgroundColor(44, 62, 82)
        lib:SetButtonsColor(52, 74, 95)
        lib:SetAccentColor(26, 189, 158)
        lib:SetTitleColor(255, 255, 255)
    elseif theme == "Ocean" then
        lib:SetBackgroundColor(26, 32, 58)
        lib:SetButtonsColor(38, 45, 71)
        lib:SetAccentColor(86, 76, 251)
        lib:SetTitleColor(255, 255, 255)
    elseif theme == "Sunset" then
        lib:SetBackgroundColor(30, 20, 40)
        lib:SetButtonsColor(60, 40, 70)
        lib:SetAccentColor(255, 120, 60)
        lib:SetTitleColor(255, 200, 100)
    elseif theme == "Forest" then
        lib:SetBackgroundColor(20, 40, 30)
        lib:SetButtonsColor(40, 70, 50)
        lib:SetAccentColor(100, 200, 120)
        lib:SetTitleColor(200, 255, 200)
    elseif theme == "Cyberpunk" then
        lib:SetBackgroundColor(10, 10, 25)
        lib:SetButtonsColor(30, 0, 50)
        lib:SetAccentColor(255, 0, 150)
        lib:SetTitleColor(0, 255, 255)
    else
        warn("Theme '" .. theme .. "' not found. Available themes: Default, TomorrowNightBlue, HighContrast, Aqua, Ocean, Sunset, Forest, Cyberpunk")
    end
end

-- Advanced features
function lib:SetResponsiveMode(enabled)
    if enabled then
        updateResponsiveUI()
    end
end

function lib:SetMinimizeOnLostFocus(enabled)
    if enabled and UserInputService.TouchEnabled then
        UserInputService.TouchTapInWorld:Connect(function()
            if not isMinimized then
                closeAnimation()
            end
        end)
    end
end

-- Initialize with entrance animation
spawn(function()
    wait(0.5)
    
    -- Entrance animation
    Main:TweenPosition(
        UDim2.fromScale(0.5, 0.5),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.8, true, nil
    )
    
    DropShadow:TweenPosition(
        UDim2.fromScale(0.5, 0.502),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.8, true, nil
    )
    
    wait(1)
    
    -- Logo animation
    Logo:TweenSizeAndPosition(
        UDim2.fromScale(0.12, 0.8),
        UDim2.fromScale(0.06, 0.5),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.6, true, nil
    )
    
    wait(0.8)
    
    -- Fade out intro
    TweenService:Create(Intro, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
end)

return lib
