local ToggleGui = Instance.new("ScreenGui")
local Toggle = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

local IsOpen = true

ToggleGui.Name = "Toggle Gui"
ToggleGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.ResetOnSpawn = false

UICorner.Parent = Toggle
Toggle.Name = "Toggle"
Toggle.Parent = ToggleGui
Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
Toggle.Position = UDim2.new(0, 0, 0.4547, 0)
Toggle.Size = UDim2.new(0, 80, 0, 38)
Toggle.Font = Enum.Font.SourceSans
Toggle.Text = "Close Gui"
Toggle.TextColor3 = Color3.fromRGB(203, 122, 49)
Toggle.TextSize = 19.000
Toggle.Draggable = true

Toggle.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen -- สลับสถานะ

    if IsOpen then
        Toggle.Text = "Close Gui"
    else
        Toggle.Text = "Open Gui"
    end

    Library:ToggleUI()  -- เรียกฟังก์ชัน toggle UI ของ Library
end)
