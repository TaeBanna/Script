-- Toggle11.lua (แก้ให้ลากได้)
return function(options)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    options = options or {}
    local keyToPress  = options.keyToPress or Enum.KeyCode.LeftAlt
    local position    = options.position or UDim2.new(0, 0, 0.45, 0)
    local size        = options.size or UDim2.new(0, 80, 0, 38)
    local cornerRadius = options.cornerRadius or UDim.new(0, 8)

    -- สร้าง GUI
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = options.name or "FloatingToggle"
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = PlayerGui

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleButton"
    ToggleBtn.Parent = ToggleGui
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    ToggleBtn.Position = position
    ToggleBtn.Size = size
    ToggleBtn.Font = Enum.Font.SourceSans
    ToggleBtn.TextColor3 = Color3.fromRGB(203, 122, 49)
    ToggleBtn.TextSize = 19
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = "Toggle"

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = cornerRadius
    UICorner.Parent = ToggleBtn

    -- ระบบลากปุ่ม
    local dragging = false
    local dragStartPos, dragStartInput
    local wasDragged = false

    local function updatePosition(input)
        if not dragging or not dragStartPos or not dragStartInput then return end
        local delta = input.Position - dragStartInput.Position
        if delta.Magnitude > 5 then wasDragged = true end
        ToggleBtn.Position = UDim2.new(
            dragStartPos.X.Scale,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale,
            dragStartPos.Y.Offset + delta.Y
        )
    end

    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStartPos = ToggleBtn.Position
            dragStartInput = input
            wasDragged = false

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    ToggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updatePosition(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragStartInput then
            updatePosition(input)
        end
    end)

    -- คลิก -> จำลองการกดคีย์บอร์ด
    ToggleBtn.MouseButton1Click:Connect(function()
        if wasDragged then return end
        VirtualInputManager:SendKeyEvent(true, keyToPress, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, keyToPress, false, game)
    end)

    return {
        Gui = ToggleGui,
        Button = ToggleBtn,
        Destroy = function()
            ToggleGui:Destroy()
        end
    }
end
