return function(Window)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- สร้าง ScreenGui สำหรับปุ่ม
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.Parent = PlayerGui
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Toggle"
    ToggleBtn.Parent = ToggleGui
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    ToggleBtn.Position = UDim2.new(0, 0, 0.45, 0)
    ToggleBtn.Size = UDim2.new(0, 80, 0, 38)
    ToggleBtn.Font = Enum.Font.SourceSans
    ToggleBtn.Text = "Close Gui"
    ToggleBtn.TextColor3 = Color3.fromRGB(203, 122, 49)
    ToggleBtn.TextSize = 19
    ToggleBtn.AutoButtonColor = false

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = ToggleBtn

    -- ระบบลากปุ่ม
    local dragging, dragStartPos, dragStartInput, wasDragged = false, nil, nil, false

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

    -- ปุ่มเปิด/ปิด UI
    ToggleBtn.MouseButton1Click:Connect(function()
        if wasDragged then return end

        local mainUI = Window -- ตัวที่ได้จาก Library:CreateWindow()
        if mainUI then
            local isVisible = mainUI.Visible
            mainUI.Visible = not isVisible
            ToggleBtn.Text = isVisible and "Open Gui" or "Close Gui"
        end
    end)
end
