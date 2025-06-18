return function(Library)
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false

    -- ✅ ซ่อน ToggleGui ทันทีหลังสร้าง
    ToggleGui.Enabled = false

    local function findKavoGui()
        for _, child in pairs(CoreGui:GetChildren()) do
            if child:IsA("ScreenGui") and tonumber(child.Name) then
                local main = child:FindFirstChild("Main")
                if main then
                    local mainHeader = main:FindFirstChild("MainHeader")
                    if mainHeader then
                        local title = mainHeader:FindFirstChild("title")
                        if title and title.Text == "BannaHub" then
                            return child
                        end
                    end
                end
            end
        end
        return nil
    end

    local function checkKavoDestroyed()
        local kavoGui = findKavoGui()
        if not kavoGui then
            if ToggleGui and ToggleGui.Parent then
                ToggleGui:Destroy()
            end
        end
    end

    spawn(function()
        while ToggleGui and ToggleGui.Parent do
            checkKavoDestroyed()
            wait(1)
        end
    end)

    CoreGui.ChildRemoved:Connect(function(child)
        if child:IsA("ScreenGui") and tonumber(child.Name) then
            local main = child:FindFirstChild("Main")
            if main then
                local mainHeader = main:FindFirstChild("MainHeader")
                if mainHeader then
                    local title = mainHeader:FindFirstChild("title")
                    if title and title.Text == "BannaHub" then
                        if ToggleGui and ToggleGui.Parent then
                            ToggleGui:Destroy()
                        end
                    end
                end
            end
        end
    end)

    -- สร้าง Frame สำหรับรวมปุ่มทั้งหมด
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "ButtonFrame"
    ButtonFrame.Parent = ToggleGui
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Position = UDim2.new(0, 0, 0.45, 0)
    ButtonFrame.Size = UDim2.new(0, 85, 0, 85)

    -- ปุ่ม Toggle GUI หลัก
    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Parent = ButtonFrame
    Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    Toggle.Position = UDim2.new(0, 0, 0, 0)
    Toggle.Size = UDim2.new(0, 80, 0, 38)
    Toggle.Font = Enum.Font.SourceSans
    Toggle.Text = "Close Gui"
    Toggle.TextColor3 = Color3.fromRGB(203, 122, 49)
    Toggle.TextSize = 19
    Toggle.AutoButtonColor = false

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Toggle

    -- ปุ่ม BringCoal ใหม่
    local BringCoalToggle = Instance.new("TextButton")
    BringCoalToggle.Name = "BringCoalToggle"
    BringCoalToggle.Parent = ButtonFrame
    BringCoalToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    BringCoalToggle.Position = UDim2.new(0, 0, 0, 47)
    BringCoalToggle.Size = UDim2.new(0, 80, 0, 38)
    BringCoalToggle.Font = Enum.Font.SourceSans
    BringCoalToggle.Text = "Coal: OFF"
    BringCoalToggle.TextColor3 = Color3.fromRGB(255, 85, 85)
    BringCoalToggle.TextSize = 16
    BringCoalToggle.AutoButtonColor = false

    local UICorner2 = Instance.new("UICorner")
    UICorner2.Parent = BringCoalToggle

    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local wasDragged = false

    -- ฟังก์ชันการลากสำหรับ Frame ทั้งหมด
    local function updateInput(input)
        if dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                wasDragged = true
            end
            ButtonFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end

    -- การลากสำหรับปุ่ม Toggle
    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ButtonFrame.Position
            wasDragged = false
        end
    end)

    Toggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateInput(input)
        end
    end)

    -- การลากสำหรับปุ่ม BringCoal
    BringCoalToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ButtonFrame.Position
            wasDragged = false
        end
    end)

    BringCoalToggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                task.wait(0.1)
                wasDragged = false
            end
        end
    end)

    -- คลิกปุ่ม Toggle GUI
    Toggle.MouseButton1Click:Connect(function()
        if wasDragged then return end
        Library:ToggleUI()
        Toggle.Text = (Toggle.Text == "Close Gui") and "Open Gui" or "Close Gui"
    end)

    -- คลิกปุ่ม BringCoal
    BringCoalToggle.MouseButton1Click:Connect(function()
        if wasDragged then return end
        
        -- สลับสถานะ BringCoal
        _G.BringCoal = not _G.BringCoal
        
        -- อัพเดทข้อความและสีของปุ่ม
        if _G.BringCoal then
            BringCoalToggle.Text = "Coal: ON"
            BringCoalToggle.TextColor3 = Color3.fromRGB(85, 255, 85) -- เขียว
            BringCoalToggle.BackgroundColor3 = Color3.fromRGB(25, 60, 25)
        else
            BringCoalToggle.Text = "Coal: OFF"
            BringCoalToggle.TextColor3 = Color3.fromRGB(255, 85, 85) -- แดง
            BringCoalToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)

    -- เพิ่ม Hover Effects
    Toggle.MouseEnter:Connect(function()
        Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    Toggle.MouseLeave:Connect(function()
        Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    end)

    BringCoalToggle.MouseEnter:Connect(function()
        if _G.BringCoal then
            BringCoalToggle.BackgroundColor3 = Color3.fromRGB(30, 70, 30)
        else
            BringCoalToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        end
    end)

    BringCoalToggle.MouseLeave:Connect(function()
        if _G.BringCoal then
            BringCoalToggle.BackgroundColor3 = Color3.fromRGB(25, 60, 25)
        else
            BringCoalToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)
end
