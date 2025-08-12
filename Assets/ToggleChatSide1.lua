return function(options)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    options = options or {}
    local position     = options.position or UDim2.new(0, 55, 0.45, -132)
    local size         = options.size or UDim2.new(0, 80, 0, 38)
    local cornerRadius = options.cornerRadius or UDim.new(0, 8)
    local closeFunc    = options.CloseFunction -- ฟังก์ชันที่ส่งมา
    local window       = options.Window       -- ส่ง Window มาแทน CloseFunction ก็ได้
    local draggable    = (options.draggable == nil) and false or not not options.draggable
    -- ^ ค่าเริ่มต้น "ล็อก" ไม่ให้ลาก (false). ถ้าอยากให้ลากได้ตั้งแต่เริ่ม ส่ง draggable = true

    -- สร้าง GUI
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = options.name or "FloatingToggle"
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Parent = PlayerGui

    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Parent = ToggleGui
    Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    Toggle.Position = position
    Toggle.Size = size
    Toggle.Font = Enum.Font.SourceSans
    Toggle.Text = options.startText or "Toggle"
    Toggle.TextColor3 = Color3.fromRGB(203, 122, 49)
    Toggle.TextSize = 19
    Toggle.AutoButtonColor = false

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = cornerRadius
    UICorner.Parent = Toggle

    -- ระบบลาก (รองรับเปิด/ปิด)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local wasDragged = false

    local function updateInput(input)
        if dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                wasDragged = true
            end
            Toggle.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end

    Toggle.InputBegan:Connect(function(input)
        if not draggable then return end -- ล็อก: ไม่ให้เริ่มลาก
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Toggle.Position
            wasDragged = false
        end
    end)

    Toggle.InputChanged:Connect(function(input)
        if not draggable then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            updateInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not draggable then return end
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not draggable then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                task.wait(0.1)
                wasDragged = false
            end
        end
    end)

    -- คลิกเพื่อรันฟังก์ชันปิด/เปิด
    Toggle.MouseButton1Click:Connect(function()
        if wasDragged then return end
        if typeof(closeFunc) == "function" then
            closeFunc()
        elseif window and typeof(window.ToggleUI) == "function" then
            window:ToggleUI()
        else
            warn("CloseFunction or Window.ToggleUI not found!")
        end
    end)

    -- API สำหรับเปิด/ปิดการลากภายหลัง
    local api = {
        Gui = ToggleGui,
        Button = Toggle,
        SetDraggable = function(state: boolean)
            draggable = not not state
            -- ถ้าปิดระหว่างกำลังลากอยู่ ให้หยุดลากทันที
            if not draggable and dragging then
                dragging = false
                wasDragged = false
            end
        end,
        IsDraggable = function()
            return draggable
        end,
        Destroy = function()
            ToggleGui:Destroy()
        end
    }

    return api
end
