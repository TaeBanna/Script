return function(Library)
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- สร้าง GUI สำหรับปุ่ม Toggle
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "ToggleGui"
    ToggleGui.Parent = PlayerGui
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleGui.ResetOnSpawn = false
    ToggleGui.Enabled = true -- เปิดไว้ให้เห็นเลย (ถ้าต้องการซ่อน ให้เปลี่ยนเป็น false)

    -- สร้างปุ่มเปิด-ปิด Kavo UI
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

    -- ระบบลากปุ่ม
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local wasDragged = false

    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then wasDragged = true end
            ToggleBtn.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end

    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleBtn.Position
            wasDragged = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            task.wait(0.1)
            wasDragged = false
        end
    end)

    -- ฟังก์ชันเปิด-ปิด Kavo UI
    ToggleBtn.MouseButton1Click:Connect(function()
        if wasDragged then return end
        Library:ToggleUI()
        if ToggleBtn.Text == "Close Gui" then
            ToggleBtn.Text = "Open Gui"
        else
            ToggleBtn.Text = "Close Gui"
        end
    end)

    -- ตรวจจับว่าถ้า Kavo UI ถูกลบหรือปิด ให้ลบปุ่มนี้ด้วย
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
