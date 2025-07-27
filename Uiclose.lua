return function(Library)
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Enabled = false
    ToggleGui.Parent = PlayerGui

    local function createButton(name, text, position, color, textColor)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Parent = ToggleGui
        btn.BackgroundColor3 = color
        btn.Position = position
        btn.Size = UDim2.new(0, 80, 0, 38)
        btn.Font = Enum.Font.SourceSans
        btn.Text = text
        btn.TextColor3 = textColor
        btn.TextSize = 18
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner")
        corner.Parent = btn
        return btn
    end

    local Toggle = createButton("Toggle", "Close Gui", UDim2.new(0, 0, 0.45, 0), Color3.fromRGB(29, 29, 29), Color3.fromRGB(203, 122, 49))

    local dragging, dragStart, startPos, wasDragged = false, nil, nil, false

    local function updateDrag(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then wasDragged = true end
            Toggle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

    UserInputService.InputChanged:Connect(updateDrag)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            task.wait(0.1)
            wasDragged = false
        end
    end)

    Toggle.MouseButton1Click:Connect(function()
        if wasDragged then return end
        Library:ToggleUI()
        Toggle.Text = (Toggle.Text == "Close Gui") and "Open Gui" or "Close Gui"
    end)

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

    RunService.RenderStepped:Connect(function()
        if not ToggleGui or not ToggleGui.Parent then return end
        if not findKavoGui() then
            ToggleGui:Destroy()
        end
    end)

    CoreGui.ChildRemoved:Connect(function(child)
        local main = child:FindFirstChild("Main")
        local title = main and main:FindFirstChild("MainHeader") and main.MainHeader:FindFirstChild("title")
        if title and title.Text == "BannaHub" and ToggleGui and ToggleGui.Parent then
            ToggleGui:Destroy()
        end
    end)
end
