return function(Library)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- กันซ้ำ: ถ้ามีอยู่แล้วให้ลบทิ้งก่อน
    local old = PlayerGui:FindFirstChild("ToggleGui")
    if old then old:Destroy() end

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

    -- หา GUI หลัก (fallback ใช้ตรวจจับและซ่อน/แสดงเองได้)
    local function findMainWindow()
        for _, gui in pairs(CoreGui:GetChildren()) do
            -- library ของคุณสุ่มชื่อเป็นตัวเลขไว้ (tonumber(gui.Name))
            if gui:IsA("ScreenGui") and tonumber(gui.Name) then
                local main = gui:FindFirstChild("Main") -- CanvasGroup
                local header = main and main:FindFirstChild("MainHeader")
                local title = header and header:FindFirstChild("title")
                if title and title.Text == "BannaHub" then
                    return gui, main
                end
            end
        end
        return nil, nil
    end

    local isOpen = true -- สถานะปัจจุบัน (สำหรับสลับข้อความปุ่ม)

    local function setButtonText()
        ToggleBtn.Text = isOpen and "Close Gui" or "Open Gui"
    end

    local function toggleUI()
        -- ถ้า Library มีเมธอด Toggle/Show/Hide ใช้อันนี้ก่อน
        if typeof(Library) == "table" and Library.ToggleUI then
            Library:ToggleUI()
            isOpen = not isOpen
            setButtonText()
            return
        end

        -- Fallback: ถ้า Library ยังไม่มี ToggleUI ให้ซ่อน/แสดงด้วยตัวเอง
        local gui, main = findMainWindow()
        if main and main:IsA("CanvasGroup") then
            if main.Visible then
                -- ปิด
                main.Visible = false
                isOpen = false
            else
                -- เปิด
                main.Visible = true
                main.GroupTransparency = 0
                isOpen = true
            end
            setButtonText()
        end
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        if wasDragged then return end
        toggleUI()
    end)

    -- เพิ่มคีย์ลัด (เช่น LeftAlt) สำหรับเปิด/ปิด
    local Keybind = Enum.KeyCode.LeftAlt
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Keybind then
            toggleUI()
        end
    end)

    -- ลบปุ่มถ้า UI หลักหายไป
    local renderConn
    renderConn = RunService.RenderStepped:Connect(function()
        if not ToggleGui or not ToggleGui.Parent then
            if renderConn then renderConn:Disconnect() end
            return
        end
        local gui = findMainWindow()
        if not gui then
            ToggleGui:Destroy()
            if renderConn then renderConn:Disconnect() end
        end
    end)

    CoreGui.ChildRemoved:Connect(function(child)
        local main = child:FindFirstChild("Main")
        local header = main and main:FindFirstChild("MainHeader")
        local title = header and header:FindFirstChild("title")
        if title and title.Text == "BannaHub" and ToggleGui and ToggleGui.Parent then
            ToggleGui:Destroy()
            if renderConn then renderConn:Disconnect() end
        end
    end)
end
