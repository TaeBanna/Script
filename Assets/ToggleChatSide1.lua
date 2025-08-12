return function(options)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    options = options or {}
    local position     = options.position or UDim2.new(0, 55, 0.45, -132)
    local size         = options.size or UDim2.new(0, 80, 0, 38)
    local cornerRadius = options.cornerRadius or UDim.new(0, 8)
    local closeFunc    = options.CloseFunction      -- ส่งฟังก์ชันเองก็ได้
    local window       = options.Window             -- หรือส่ง Window แล้วใช้ Window:ToggleUI()

    -- GUI
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

    -- ไม่มีระบบลาก (ล็อกตำแหน่งถาวร)
    Toggle.MouseButton1Click:Connect(function()
        if typeof(closeFunc) == "function" then
            closeFunc()
        elseif window and typeof(window.ToggleUI) == "function" then
            window:ToggleUI()
        else
            warn("CloseFunction or Window.ToggleUI not found!")
        end
    end)

    return {
        Gui = ToggleGui,
        Button = Toggle,
        Destroy = function()
            ToggleGui:Destroy()
        end
    }
end
