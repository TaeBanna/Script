return function(Library)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
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

    -- ระบบลาก
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

    ToggleBtn.MouseButton1Click:Connect(function()
        if wasDragged then return end
        Library:ToggleUI()
        ToggleBtn.Text = (ToggleBtn.Text == "Close Gui") and "Open Gui" or "Close Gui"
    end)

    -- ฟังก์ชันตรวจสอบ UI Kavo ยังอยู่ไหม
    local function findKavoGui()
        for _, gui in pairs(CoreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and tonumber(gui.Name) then
                local main = gui:FindFirstChild("Main")
                local title = main and main:FindFirstChild("MainHeader") and main.MainHeader:FindFirstChild("title")
                if title and title.Text == "BannaHub" then
                    return gui
                end
            end
        end
        return nil
    end

    -- เช็คทุกเฟรม ถ้า UI Kavo หาย ให้ลบปุ่มทิ้งเลย
    local renderConn
    renderConn = RunService.RenderStepped:Connect(function()
        if not ToggleGui or not ToggleGui.Parent then
            if renderConn then renderConn:Disconnect() end
            return
        end
        if not findKavoGui() then
            ToggleGui:Destroy()
            if renderConn then renderConn:Disconnect() end
        end
    end)

    -- เช็คเวลามี UI หายจาก CoreGui
    CoreGui.ChildRemoved:Connect(function(child)
        local main = child:FindFirstChild("Main")
        local title = main and main:FindFirstChild("MainHeader") and main.MainHeader:FindFirstChild("title")
        if title and title.Text == "BannaHub" and ToggleGui and ToggleGui.Parent then
            ToggleGui:Destroy()
            if renderConn then renderConn:Disconnect() end
        end
    end)
end
