return function(Window)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- อ่านค่าปุ่ม MinimizeKeybind จาก Window (ถ้าไม่เจอให้ใช้ LeftAlt)
    local minimizeKey = Window.MinimizeKeybind or Enum.KeyCode.LeftAlt

    -- GUI สำหรับปุ่ม Toggle
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
    ToggleBtn.Text = "Minimize"
    ToggleBtn.TextColor3 = Color3.fromRGB(203, 122, 49)
    ToggleBtn.TextSize = 19
    ToggleBtn.AutoButtonColor = false
    Instance.new("UICorner").Parent = ToggleBtn

    -- ตัวแปรลาก
    local dragging = false
    local dragStartPos, dragStartInput
    local wasDragged = false

    local function updatePosition(input)
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

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updatePosition(input)
        end
    end)

    -- ฟังก์ชันสำหรับสลับ UI
    local function toggleUI()
        if Window and typeof(Window.ToggleUI) == "function" then
            Window:ToggleUI()
        else
            Window.Visible = not Window.Visible
        end
    end

    -- คลิกปุ่ม = ทำเหมือนกดปุ่ม MinimizeKeybind
    ToggleBtn.MouseButton1Click:Connect(function()
        if wasDragged then
            wasDragged = false
            return
        end
        toggleUI()
    end)

    -- กดปุ่มคีย์บอร์ดตาม MinimizeKeybind
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == minimizeKey then
            toggleUI()
        end
    end)
end
