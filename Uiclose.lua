return function(Library)
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false

    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Parent = ToggleGui
    Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    Toggle.Position = UDim2.new(0, 0, 0.45, 0)
    Toggle.Size = UDim2.new(0, 80, 0, 38)
    Toggle.Font = Enum.Font.SourceSans
    Toggle.Text = "Close Gui"
    Toggle.TextColor3 = Color3.fromRGB(203, 122, 49)
    Toggle.TextSize = 19
    Toggle.AutoButtonColor = false

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Toggle

    -- Dragging system
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos, wasDragged = false, nil, nil, nil, false

    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Toggle.Position
            wasDragged = false

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Toggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 2 then
                wasDragged = true
            end
            Toggle.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    Toggle.MouseButton1Click:Connect(function()
        if wasDragged then
            wasDragged = false
            return -- อย่าทำอะไรถ้าเพิ่งลาก
        end

        Library:ToggleUI()
        Toggle.Text = (Toggle.Text == "Close Gui") and "Open Gui" or "Close Gui"
    end)
end
