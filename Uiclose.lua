return function(Library)
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false
    
    -- ตรวจสอบเมื่อ Kavo GUI ถูกทำลาย
    local function checkKavoDestroyed()
        local kavoGui = CoreGui:FindFirstChild("67177")
        if not kavoGui then
            -- ถ้า Kavo GUI ถูกทำลาย ให้ทำลาย Toggle GUI ด้วย
            if ToggleGui and ToggleGui.Parent then
                ToggleGui:Destroy()
            end
        end
    end
    
    -- เช็คทุก 1 วินาที
    spawn(function()
        while ToggleGui and ToggleGui.Parent do
            checkKavoDestroyed()
            wait(1)
        end
    end)
    
    -- เช็คเมื่อมี Child ถูกลบใน CoreGui
    CoreGui.ChildRemoved:Connect(function(child)
        if child.Name == "67177" then
            if ToggleGui and ToggleGui.Parent then
                ToggleGui:Destroy()
            end
        end
    end)
    
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
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local wasDragged = false
    
    local function updateInput(input)
        if dragging then
            local delta = input.Position - dragStart
            -- ถ้าเลื่อนเกิน 5 pixels ถือว่าเป็นการลาก
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Toggle.Position
            wasDragged = false
        end
    end)
    
    Toggle.InputChanged:Connect(function(input)
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
                -- รอสักครู่แล้วค่อยรีเซ็ต wasDragged เพื่อป้องกันการกดปุ่มทันที
                task.wait(0.1)
                wasDragged = false
            end
        end
    end)
    
    Toggle.MouseButton1Click:Connect(function()
        if wasDragged then
            return -- อย่าทำอะไรถ้าเพิ่งลาก
        end
        Library:ToggleUI()
        Toggle.Text = (Toggle.Text == "Close Gui") and "Open Gui" or "Close Gui"
    end)
end
