return function(options)
    local CoreGui = game:GetService("CoreGui")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    options = options or {}
    local keyToPress  = options.keyToPress or Enum.KeyCode.LeftAlt
    local offsetX     = options.offsetX or 100 -- ระยะห่างจากขอบซ้ายของช่องแชท
    local offsetY     = options.offsetY or -40 -- ระยะเลื่อนขึ้น/ลงจากขอบบนของช่องแชท
    local size        = options.size or UDim2.new(0, 80, 0, 38)
    local cornerRadius = options.cornerRadius or UDim.new(0, 8)

    -- ScreenGui
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = options.name or "FloatingToggle"
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.IgnoreGuiInset = true
    ToggleGui.Parent = CoreGui

    -- ปุ่ม
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleButton"
    ToggleBtn.Parent = ToggleGui
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    ToggleBtn.Size = size
    ToggleBtn.Font = Enum.Font.SourceSans
    ToggleBtn.TextColor3 = Color3.fromRGB(203, 122, 49)
    ToggleBtn.TextSize = 19
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = "Toggle"

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = cornerRadius
    UICorner.Parent = ToggleBtn

    -- จัดตำแหน่งข้างช่องแชท Roblox
    local function updatePosition()
        local chat = CoreGui:FindFirstChild("Chat")
        if chat and chat:FindFirstChild("Frame") then
            local chatFrame = chat.Frame
            ToggleBtn.Position = UDim2.new(0, chatFrame.AbsolutePosition.X + offsetX, 0, chatFrame.AbsolutePosition.Y + offsetY)
        else
            ToggleBtn.Position = UDim2.new(0, 200, 0, 400) -- fallback
        end
    end

    updatePosition()

    -- กดปุ่ม -> จำลองคีย์บอร์ด
    ToggleBtn.MouseButton1Click:Connect(function()
        VirtualInputManager:SendKeyEvent(true, keyToPress, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, keyToPress, false, game)
    end)

    return {
        Gui = ToggleGui,
        Button = ToggleBtn,
        UpdatePos = updatePosition,
        Destroy = function()
            ToggleGui:Destroy()
        end
    }
end
