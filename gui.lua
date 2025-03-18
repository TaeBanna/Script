local air = Instance.new("ScreenGui")
local ScreenGuiHIDESHOW = Instance.new("ScreenGui")
local miniHIDESHOW = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local ScreenGui555 = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Highlight = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local Pickup = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local Drop = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")

-- GUI Properties
air.Name = "air"
air.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
air.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGuiHIDESHOW.Name = "ScreenGuiHIDESHOW"
ScreenGuiHIDESHOW.Parent = air

miniHIDESHOW.Name = "miniHIDESHOW"
miniHIDESHOW.Parent = ScreenGuiHIDESHOW
miniHIDESHOW.Position = UDim2.new(0.477, 0, -0.021, 0)
miniHIDESHOW.Size = UDim2.new(0, 43, 0, 40)
miniHIDESHOW.Image = "rbxassetid://74722061366512"
UICorner.CornerRadius = UDim.new(0, 50)
UICorner.Parent = miniHIDESHOW

ScreenGui555.Name = "ScreenGui555"
ScreenGui555.Parent = air

Main.Name = "Main"
Main.Parent = ScreenGui555
Main.Position = UDim2.new(0.249, 0, 0.249, 0)
Main.Size = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(55, 40, 57)
UICorner_2.CornerRadius = UDim.new(0, 20)
UICorner_2.Parent = Main

-- Highlight Button
Highlight.Name = "Highlight"
Highlight.Parent = Main
Highlight.Position = UDim2.new(0.295, 0, 0.064, 0)
Highlight.Size = UDim2.new(0, 200, 0, 50)
Highlight.Text = "Highlight"
Highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UICorner_3.CornerRadius = UDim.new(0, 20)
UICorner_3.Parent = Highlight

-- Pickup Button
Pickup.Name = "Pickup"
Pickup.Parent = Main
Pickup.Position = UDim2.new(0.295, 0, 0.277, 0)
Pickup.Size = UDim2.new(0, 200, 0, 50)
Pickup.Text = "Pickup"
Pickup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UICorner_4.CornerRadius = UDim.new(0, 20)
UICorner_4.Parent = Pickup

-- Drop Button
Drop.Name = "Drop"
Drop.Parent = Main
Drop.Position = UDim2.new(0.295, 0, 0.488, 0)
Drop.Size = UDim2.new(0, 200, 0, 50)
Drop.Text = "Drop"
Drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UICorner_5.CornerRadius = UDim.new(0, 20)
UICorner_5.Parent = Drop

-- Button Functions
local function highlightObject()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Tool") then
                obj.Handle.Color = Color3.fromRGB(255, 255, 0) -- เปลี่ยนสีเป็นเหลือง
            end
        end
    end
end

local function pickupItem()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Tool") then
                obj.Parent = player.Backpack -- ย้ายไป Backpack
            end
        end
    end
end

local function dropItem()
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = workspace -- ทิ้งออกไปที่ workspace
            end
        end
    end
end

Highlight.MouseButton1Click:Connect(highlightObject)
Pickup.MouseButton1Click:Connect(pickupItem)
Drop.MouseButton1Click:Connect(dropItem)

-- Toggle GUI Visibility
miniHIDESHOW.MouseButton1Click:Connect(function()
    ScreenGui555.Enabled = not ScreenGui555.Enabled
end)
