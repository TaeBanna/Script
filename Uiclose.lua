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

    local UserInputService = game:GetService("UserInputService")
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
                task.wait(0.1)
                wasDragged = false
            end
        end
    end)

    Toggle.MouseButton1Click:Connect(function()
        if wasDragged then return end
        Library:ToggleUI()
        Toggle.Text = (Toggle.Text == "Close Gui") and "Open Gui" or "Close Gui"
    end)

    -- ปุ่มใหม่
    local NewButton = Instance.new("TextButton")
    NewButton.Name = "NewButton"
    NewButton.Parent = ToggleGui
    NewButton.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
    NewButton.Position = UDim2.new(0, 0, 0.55, 0)
    NewButton.Size = UDim2.new(0, 80, 0, 38)
    NewButton.Font = Enum.Font.SourceSans
    NewButton.Text = "Sell"
    NewButton.TextColor3 = Color3.fromRGB(85, 255, 85)
    NewButton.TextSize = 18
    NewButton.AutoButtonColor = false

    local UICorner2 = Instance.new("UICorner")
    UICorner2.Parent = NewButton

    NewButton.MouseButton1Click:Connect(function()
        local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local old = hrp.CFrame
        hrp.CFrame = CFrame.new(1019, 245, -65)
        task.wait(0.5)
        game:GetService("ReplicatedStorage"):WaitForChild("Ml"):WaitForChild("SellInventory"):FireServer()
        task.wait(0.5)
        hrp.CFrame = old
    end)
end
