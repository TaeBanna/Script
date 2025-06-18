return function(Library)
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    
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

    -- ✅ ปรับปรุงระบบการลาก
    local Dragging = false
    local DragStart = nil
    local StartPos = nil
    local Connection = nil

    -- ฟังก์ชันการลาก
    local function UpdateDrag(input)
        local Delta = input.Position - DragStart
        local NewPosition = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
        Toggle.Position = NewPosition
    end

    -- เริ่มการลาก
    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            Dragging = true
            DragStart = input.Position
            StartPos = Toggle.Position
            
            -- เชื่อมต่อการอัพเดทตำแหน่ง
            Connection = UserInputService.InputChanged:Connect(function(inputChanged)
                if Dragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or 
                   inputChanged.UserInputType == Enum.UserInputType.Touch) then
                    UpdateDrag(inputChanged)
                end
            end)
        end
    end)

    -- หยุดการลาก
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            if Dragging then
                Dragging = false
                if Connection then
                    Connection:Disconnect()
                    Connection = nil
                end
            end
        end
    end)

    -- ✅ คลิกเพื่อ Toggle (ป้องกันการคลิกขณะลาก)
    local LastClickTime = 0
    Toggle.MouseButton1Click:Connect(function()
        local CurrentTime = tick()
        
        -- ตรวจสอบว่าไม่ได้กำลังลากและไม่คลิกเร็วเกินไป
        if not Dragging and (CurrentTime - LastClickTime) > 0.1 then
            LastClickTime = CurrentTime
            Library:ToggleUI()
            Toggle.Text = (Toggle.Text == "Close Gui") and "Open Gui" or "Close Gui"
        end
    end)

    -- ✅ เพิ่ม Hover Effect (เสริม)
    Toggle.MouseEnter:Connect(function()
        Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    Toggle.MouseLeave:Connect(function()
        Toggle.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    end)
end
