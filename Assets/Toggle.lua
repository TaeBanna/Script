return function(Library)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- หา UI หลักจาก CoreGui (Library ของคุณใช้ชื่อ "Main")
    local function findMainUI()
        for _, gui in pairs(CoreGui:GetChildren()) do
            local main = gui:FindFirstChild("Main")
            if main and main:IsA("CanvasGroup") then
                return main
            end
        end
        return nil
    end

    local MainUI = findMainUI()

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
    local dragging = false
    local dragStartPos, dragStartInput, wasDragged = nil, nil, false

    local function updatePosition(input)
        if not dragging then return end
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
        end
    end)

    ToggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragStartInput and dragging then
            updatePosition(input)
        end
    end)

    -- ปุ่มกดเปิด/ปิด UI
    ToggleBtn.MouseButton1Click:Connect(function()
        if wasDragged then return end
        MainUI = MainUI or findMainUI()
        if MainUI then
            local isVisible = MainUI.Visible
            MainUI.Visible = not isVisible
            ToggleBtn.Text = isVisible and "Open Gui" or "Close Gui"
        end
    end)

    -- ถ้า UI หลักหายไป ปุ่มก็หายตาม
    RunService.RenderStepped:Connect(function()
        if not findMainUI() then
            ToggleGui:Destroy()
        end
    end)
end
