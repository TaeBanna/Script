return function(Library)
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false

    ToggleGui.Enabled = false

    -- ฟังก์ชันเช็ค GUI หลัก
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

    -- ปุ่มเปิด/ปิด GUI หลัก
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

    -- ปุ่มเปิด/ปิด BringCoal
    local BringToggle = Instance.new("TextButton")
    BringToggle.Name = "BringToggle"
    BringToggle.Parent = ToggleGui
    BringToggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    BringToggle.Position = UDim2.new(0, 0, 0.55, 0)
    BringToggle.Size = UDim2.new(0, 120, 0, 38)
    BringToggle.Font = Enum.Font.SourceSans
    BringToggle.Text = "BringOres Off"
    BringToggle.TextColor3 = Color3.fromRGB(122, 203, 49)
    BringToggle.TextSize = 17
    BringToggle.AutoButtonColor = false

    local UICorner2 = Instance.new("UICorner")
    UICorner2.Parent = BringToggle

    _G.BringCoal = false

    local UserInputService = game:GetService("UserInputService")

    -- ตัวแปรสำหรับลากปุ่มทั้งสอง
    local draggingToggle = false
    local dragStartToggle = nil
    local startPosToggle = nil
    local wasDraggedToggle = false

    local draggingBring = false
    local dragStartBring = nil
    local startPosBring = nil
    local wasDraggedBring = false

    -- ฟังก์ชันอัพเดตตำแหน่งสำหรับปุ่ม
    local function updateInput(input, button, dragStart, startPos)
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then
            if button == Toggle then
                wasDraggedToggle = true
            else
                wasDraggedBring = true
            end
        end
        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    -- ตั้งระบบลากปุ่ม Toggle (GUI หลัก)
    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingToggle = true
            dragStartToggle = input.Position
            startPosToggle = Toggle.Position
            wasDraggedToggle = false
        end
    end)

    Toggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingToggle then
                updateInput(input, Toggle, dragStartToggle, startPosToggle)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input, Toggle, dragStartToggle, startPosToggle)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if draggingToggle then
                draggingToggle = false
                task.wait(0.1)
                wasDraggedToggle = false
            end
        end
    end)

    Toggle.MouseButton1Click:Connect(function()
        if wasDraggedToggle then return end
        Library:ToggleUI()
        Toggle.Text = (Toggle.Text == "Close Gui") and "Open Gui" or "Close Gui"
    end)

    -- ตั้งระบบลากปุ่ม BringToggle (BringOres)
    BringToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingBring = true
            dragStartBring = input.Position
            startPosBring = BringToggle.Position
            wasDraggedBring = false
        end
    end)

    BringToggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingBring then
                updateInput(input, BringToggle, dragStartBring, startPosBring)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingBring and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input, BringToggle, dragStartBring, startPosBring)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if draggingBring then
                draggingBring = false
                task.wait(0.1)
                wasDraggedBring = false
            end
        end
    end)

    BringToggle.MouseButton1Click:Connect(function()
        if wasDraggedBring then return end
        _G.BringCoal = not _G.BringCoal
        BringToggle.Text = _G.BringCoal and "BringOres On" or "BringOres Off"
    end)
end
