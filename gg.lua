--[[
BannaHub (BHub) - Single File UI Library
Version: 1.2.0
License: MIT (free to use/modify, attribution appreciated)

Features:
- Window with show/hide toggle (RightShift by default)
- Sidebar tabs, sections
- Controls: Button, Toggle, Slider, Dropdown, TextBox, Keybind
- Notifications (top-right)
- Mobile friendly (draggable header)
- Optional config save/load (uses executor filesystem if available)

API (quick):
local BannaHub = loadstring(game:HttpGet("<RAW URL>/BannaHub.lua"))()
local Win = BannaHub:CreateWindow({
    Title = "BannaHub", Subtitle = "BHub", Keybind = Enum.KeyCode.RightShift,
    Theme = "Dark" -- or "Light"
})
local Tab = Win:NewTab("Main")
local Sec = Tab:NewSection("Controls")
Sec:Button("Hello", function() print("hi") end)
Sec:Toggle("Auto", false, function(on) print("Auto:", on) end)
Sec:Slider("WalkSpeed", {min=8,max=40,default=16, step=1}, function(v) print(v) end)
Sec:Dropdown("Team", {"Red","Blue","Green"}, function(v) print(v) end)
Sec:TextBox("Say", "Type here", function(txt) print(txt) end)
Sec:Keybind("Panic", Enum.KeyCode.P, function() print("panic") end)
Win:Notify("Loaded", "BannaHub Ready")
-- Win:ToggleUI() -- show/hide
-- Win:Destroy()

Notes:
- Config helpers: Win:SaveConfig(name, table), Win:LoadConfig(name) -> table or nil
]]

-- ====== Library Start ======
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function create(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k]=v end
    return inst
end

local function round(n, step)
    step = step or 1
    return math.floor(n/step+0.5)*step
end

local themes = {
    Dark = {
        Bg = Color3.fromRGB(18,18,26),
        Panel = Color3.fromRGB(28,28,40),
        Header = Color3.fromRGB(34,34,52),
        Accent = Color3.fromRGB(88,101,242),
        Text = Color3.fromRGB(235,235,245),
        Sub = Color3.fromRGB(170,170,190),
        Muted = Color3.fromRGB(52,52,72),
        Good = Color3.fromRGB(67,181,129),
        Bad = Color3.fromRGB(240,71,71),
    },
    Light = {
        Bg = Color3.fromRGB(245,246,250),
        Panel = Color3.fromRGB(255,255,255),
        Header = Color3.fromRGB(240,242,247),
        Accent = Color3.fromRGB(88,101,242),
        Text = Color3.fromRGB(20,22,30),
        Sub = Color3.fromRGB(90,100,120),
        Muted = Color3.fromRGB(230,232,238),
        Good = Color3.fromRGB(30,170,115),
        Bad = Color3.fromRGB(220,60,60),
    }
}

local FS = {}
FS.write = (typeof(writefile)=="function") and writefile or function() end
FS.read  = (typeof(readfile)=="function") and readfile  or function() return nil end
FS.exists = (typeof(isfile)=="function") and isfile or function() return false end
FS.makefolder = (typeof(makefolder)=="function") and makefolder or function() end

local LIB = {}
LIB.__index = LIB

function LIB:CreateWindow(opts)
    opts = opts or {}
    local theme = themes[opts.Theme or "Dark"]

    local gui = create("ScreenGui", {
        Name = "BannaHubGUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })

    local main = create("Frame", {
        Name = "Main",
        Parent = gui,
        BackgroundColor3 = theme.Bg,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 680, 0, 410),
        Position = UDim2.new(0.5, -340, 0.5, -205)
    })
    create("UICorner", {Parent=main, CornerRadius=UDim.new(0,12)})
    create("UIStroke", {Parent=main, Color=theme.Muted, Thickness=1})

    local header = create("Frame", {
        Parent=main, BackgroundColor3=theme.Header, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,48)
    })
    create("UICorner", {Parent=header, CornerRadius=UDim.new(0,12)})

    local title = create("TextLabel", {
        Parent=header, BackgroundTransparency=1, Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,12,0,0),
        Font=Enum.Font.GothamBold, Text=((opts.Title or "BannaHub").."  •  "..(opts.Subtitle or "BHub")),
        TextSize=18, TextColor3=theme.Text, TextXAlignment=Enum.TextXAlignment.Left
    })

    local close = create("TextButton", {
        Parent=header, BackgroundTransparency=1, Text="×", Font=Enum.Font.GothamBold, TextSize=20,
        TextColor3=theme.Sub, Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-40,0,8)
    })

    local sidebar = create("Frame", {
        Parent=main, BackgroundColor3=theme.Panel, BorderSizePixel=0,
        Size=UDim2.new(0,160,1,-56), Position=UDim2.new(0,16,0,56)
    })
    create("UICorner", {Parent=sidebar, CornerRadius=UDim.new(0,10)})

    local sideList = create("UIListLayout", {Parent=sidebar, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)})
    sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideList.VerticalAlignment = Enum.VerticalAlignment.Begin
    create("UIPadding", {Parent=sidebar, PaddingTop=UDim.new(0,10)})

    local content = create("Frame", {
        Parent=main, BackgroundColor3=theme.Panel, BorderSizePixel=0,
        Size=UDim2.new(1,-200,1,-56), Position=UDim2.new(0,184,0,56), ClipsDescendants=true
    })
    create("UICorner", {Parent=content, CornerRadius=UDim.new(0,10)})

    local pageFolder = create("Folder", {Parent=content, Name="Pages"})

    local notifHolder = create("Frame", {
        Parent=gui, Name="Notifications", BackgroundTransparency=1, Size=UDim2.new(1,0,1,0)
    })

    -- Dragging
    do
        local dragging, dragStart, startPos
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = main.Position
            end
        end)
        header.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    close.MouseButton1Click:Connect(function() gui.Enabled=false end)

    local self = setmetatable({}, {
        __index = function(_, k)
            return rawget(LIB, k)
        end
    })

    self._gui = gui
    self._main = main
    self._theme = theme
    self._pages = pageFolder
    self._sidebar = sidebar
    self._tabs = {}
    self._keybind = opts.Keybind or Enum.KeyCode.RightShift

    -- Toggle key
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == self._keybind then gui.Enabled = not gui.Enabled end
    end)

    function self:ToggleUI() self._gui.Enabled = not self._gui.Enabled end
    function self:Destroy() self._gui:Destroy() end

    function self:Notify(titleText, message)
        local n = create("Frame", {Parent=notifHolder, BackgroundColor3=theme.Panel, Size=UDim2.new(0,280,0,60), Position=UDim2.new(1,10,0,10)})
        create("UICorner", {Parent=n, CornerRadius=UDim.new(0,8)})
        create("UIStroke", {Parent=n, Color=theme.Muted, Thickness=1})
        local t = create("TextLabel", {Parent=n, BackgroundTransparency=1, Text=titleText or "Notice", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=theme.Text, Size=UDim2.new(1,-10,0,24), Position=UDim2.new(0,10,0,6), TextXAlignment=Enum.TextXAlignment.Left})
        local m = create("TextLabel", {Parent=n, BackgroundTransparency=1, Text=message or "", Font=Enum.Font.Gotham, TextSize=13, TextColor3=theme.Sub, Size=UDim2.new(1,-10,0,24), Position=UDim2.new(0,10,0,30), TextXAlignment=Enum.TextXAlignment.Left})
        n.AnchorPoint = Vector2.new(1,0)
        TweenService:Create(n, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position=UDim2.new(1,-10,0,10)}):Play()
        task.delay(3, function()
            TweenService:Create(n, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position=UDim2.new(1,10,0,10)}):Play()
            task.wait(0.25); n:Destroy()
        end)
    end

    function self:NewTab(name)
        name = tostring(name or "Tab")
        local btn = create("TextButton", {Parent=self._sidebar, Text=name, Font=Enum.Font.Gotham, TextColor3=theme.Text, TextSize=14,
            BackgroundColor3=theme.Muted, BorderSizePixel=0, Size=UDim2.new(1,-20,0,32)})
        create("UICorner", {Parent=btn, CornerRadius=UDim.new(0,8)})

        local page = create("ScrollingFrame", {Parent=self._pages, Name=name, Active=true, ScrollBarThickness=4, BackgroundTransparency=1, Size=UDim2.new(1,0,1,0)})
        local pagelayout = create("UIListLayout", {Parent=page, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8)})
        create("UIPadding", {Parent=page, PaddingTop=UDim.new(0,10), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingBottom=UDim.new(0,10)})

        for _,p in ipairs(self._pages:GetChildren()) do if p~=page then p.Visible=false end end
        page.Visible=true

        btn.MouseButton1Click:Connect(function()
            for _,p in ipairs(self._pages:GetChildren()) do p.Visible=false end
            page.Visible=true
            for _,b in ipairs(self._sidebar:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3=theme.Muted end end
            btn.BackgroundColor3 = theme.Accent
        end)

        local TabObj = {}
        function TabObj:NewSection(title)
            local section = create("Frame", {Parent=page, BackgroundColor3=self and self._theme and self._theme.Panel or theme.Panel, BorderSizePixel=0, Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y})
            create("UICorner", {Parent=section, CornerRadius=UDim.new(0,8)})
            create("UIStroke", {Parent=section, Color=theme.Muted, Thickness=1})
            local head = create("TextLabel", {Parent=section, BackgroundTransparency=1, Text=tostring(title or "Section"), Font=Enum.Font.GothamSemibold, TextSize=14, TextColor3=theme.Sub, Size=UDim2.new(1,-16,0,28), Position=UDim2.new(0,8,0,6), TextXAlignment=Enum.TextXAlignment.Left})
            local list = create("UIListLayout", {Parent=section, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6)})
            create("UIPadding", {Parent=section, PaddingTop=UDim.new(0,34), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10), PaddingBottom=UDim.new(0,10)})

            local controlsTheme = theme
            local function ctrlBase(height)
                local fr = create("Frame", {Parent=section, BackgroundColor3=controlsTheme.Bg, BorderSizePixel=0, Size=UDim2.new(1,0,0,height or 36)})
                create("UICorner", {Parent=fr, CornerRadius=UDim.new(0,8)})
                create("UIStroke", {Parent=fr, Color=controlsTheme.Muted, Thickness=1})
                return fr
            end

            function section:Button(text, callback)
                local fr = ctrlBase(36)
                local lbl = create("TextButton", {Parent=fr, BackgroundTransparency=1, Text=tostring(text or "Button"), Font=Enum.Font.Gotham, TextSize=14, TextColor3=controlsTheme.Text, Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0)})
                lbl.MouseButton1Click:Connect(function() pcall(callback) end)
                return fr
            end

            function section:Toggle(text, default, callback)
                local state = not not default
                local fr = ctrlBase(36)
                local lbl = create("TextLabel", {Parent=fr, BackgroundTransparency=1, Text=tostring(text or "Toggle"), Font=Enum.Font.Gotham, TextSize=14, TextColor3=controlsTheme.Text, Size=UDim2.new(1,-60,1,0), Position=UDim2.new(0,8,0,0), TextXAlignment=Enum.TextXAlignment.Left})
                local knob = create("TextButton", {Parent=fr, Text="", BackgroundColor3=state and controlsTheme.Good or controlsTheme.Muted, Size=UDim2.new(0,40,0,20), Position=UDim2.new(1,-50,0.5,-10), BorderSizePixel=0})
                create("UICorner", {Parent=knob, CornerRadius=UDim.new(1,0)})
                knob.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = state and controlsTheme.Good or controlsTheme.Muted}):Play()
                    pcall(callback, state)
                end)
                function fr:Set(value)
                    state = not not value
                    knob.BackgroundColor3 = state and controlsTheme.Good or controlsTheme.Muted
                    pcall(callback, state)
                end
                return fr
            end

            function section:Slider(text, opts, callback)
                opts = opts or {}; local min=opts.min or 0; local max=opts.max or 100; local step=opts.step or 1; local value = opts.default or min
                local fr = ctrlBase(48)
                local lbl = create("TextLabel", {Parent=fr, BackgroundTransparency=1, Text=(tostring(text or "Slider").." : "..tostring(value)), Font=Enum.Font.Gotham, TextSize=14, TextColor3=controlsTheme.Text, Size=UDim2.new(1,-16,0,20), Position=UDim2.new(0,8,0,4), TextXAlignment=Enum.TextXAlignment.Left})
                local bar = create("Frame", {Parent=fr, BackgroundColor3=controlsTheme.Muted, BorderSizePixel=0, Size=UDim2.new(1,-16,0,6), Position=UDim2.new(0,8,0,28)})
                create("UICorner", {Parent=bar, CornerRadius=UDim.new(1,0)})
                local fill = create("Frame", {Parent=bar, BackgroundColor3=controlsTheme.Accent, BorderSizePixel=0, Size=UDim2.new((value-min)/(max-min),0,1,0)})
                create("UICorner", {Parent=fill, CornerRadius=UDim.new(1,0)})
                local dragging=false
                local function setFromX(x)
                    local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    value = round(min + rel * (max-min), step)
                    fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
                    lbl.Text = tostring(text).." : "..tostring(value)
                    pcall(callback, value)
                end
                bar.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; setFromX(i.Position.X) end
                end)
                bar.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setFromX(i.Position.X) end
                end)
                function fr:Set(v) setFromX(bar.AbsolutePosition.X + math.clamp((v-min)/(max-min),0,1)*bar.AbsoluteSize.X) end
                return fr
            end

            function section:Dropdown(text, list, callback)
                list = list or {}
                local current = list[1]
                local fr = ctrlBase(36)
                local lbl = create("TextLabel", {Parent=fr, BackgroundTransparency=1, Text=(tostring(text or "Dropdown")..": "..tostring(current or "-")), Font=Enum.Font.Gotham, TextSize=14, TextColor3=controlsTheme.Text, Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0), TextXAlignment=Enum.TextXAlignment.Left})
                local dd = create("Frame", {Parent=fr, BackgroundColor3=controlsTheme.Panel, BorderSizePixel=0, Size=UDim2.new(1,-16,0,0), Position=UDim2.new(0,8,1,4), Visible=false})
                create("UICorner", {Parent=dd, CornerRadius=UDim.new(0,8)})
                local listLay = create("UIListLayout", {Parent=dd, SortOrder=Enum.SortOrder.LayoutOrder})
                local btn = create("TextButton", {Parent=fr, BackgroundTransparency=1, Text="▼", Font=Enum.Font.GothamBold, TextSize=14, TextColor3=controlsTheme.Sub, Size=UDim2.new(0,24,0,24), Position=UDim2.new(1,-28,0,6)})

                local function populate()
                    dd:ClearAllChildren(); create("UIListLayout", {Parent=dd, SortOrder=Enum.SortOrder.LayoutOrder})
                    for _,name in ipairs(list) do
                        local it = create("TextButton", {Parent=dd, Text=tostring(name), BackgroundColor3=controlsTheme.Bg, TextColor3=controlsTheme.Text, Font=Enum.Font.Gotham, TextSize=14, BorderSizePixel=0, Size=UDim2.new(1,0,0,28)})
                        it.MouseButton1Click:Connect(function()
                            current = name; lbl.Text = tostring(text)..": "..tostring(current); dd.Visible=false; pcall(callback, current)
                        end)
                    end
                    dd.Size = UDim2.new(1,-16,0, #list*30)
                end
                populate()
                btn.MouseButton1Click:Connect(function() dd.Visible = not dd.Visible end)
                function fr:SetList(newList) list = newList or {}; populate() end
                function fr:Set(value) current=value; lbl.Text=tostring(text)..": "..tostring(current); pcall(callback,current) end
                return fr
            end

            function section:TextBox(label, placeholder, callback)
                local fr = ctrlBase(36)
                local lbl = create("TextLabel", {Parent=fr, BackgroundTransparency=1, Text=tostring(label or "Input"), Font=Enum.Font.Gotham, TextSize=14, TextColor3=controlsTheme.Text, Size=UDim2.new(0.4, -16,1,0), Position=UDim2.new(0,8,0,0), TextXAlignment=Enum.TextXAlignment.Left})
                local box = create("TextBox", {Parent=fr, PlaceholderText=tostring(placeholder or ""), Text="", Font=Enum.Font.Gotham, TextSize=14, TextColor3=controlsTheme.Text, BackgroundColor3=controlsTheme.Bg, BorderSizePixel=0, Size=UDim2.new(0.6,-16,0,28), Position=UDim2.new(0.4,8,0,4)})
                create("UICorner", {Parent=box, CornerRadius=UDim.new(0,6)})
                box.FocusLost:Connect(function(enter) if enter then pcall(callback, box.Text) end end)
                function fr:Set(text) box.Text = tostring(text or "") pcall(callback, box.Text) end
                return fr
            end

            function section:Keybind(text, defaultKey, callback)
                local current = defaultKey or Enum.KeyCode.RightControl
                local fr = ctrlBase(36)
                local lbl = create("TextLabel", {Parent=fr, BackgroundTransparency=1, Text=tostring(text or "Keybind"), Font=Enum.Font.Gotham, TextSize=14, TextColor3=controlsTheme.Text, Size=UDim2.new(0.6,-16,1,0), Position=UDim2.new(0,8,0,0), TextXAlignment=Enum.TextXAlignment.Left})
                local btn = create("TextButton", {Parent=fr, BackgroundColor3=controlsTheme.Bg, Text=current.Name, TextColor3=controlsTheme.Text, Font=Enum.Font.Gotham, TextSize=14, BorderSizePixel=0, Size=UDim2.new(0.4,-16,0,28), Position=UDim2.new(0.6,8,0,4)})
                create("UICorner", {Parent=btn, CornerRadius=UDim.new(0,6)})
                btn.MouseButton1Click:Connect(function()
                    btn.Text = "Press key..."
                    local conn; conn = UserInputService.InputBegan:Connect(function(input,gpe)
                        if gpe then return end
                        if input.KeyCode ~= Enum.KeyCode.Unknown then current = input.KeyCode; btn.Text=current.Name; conn:Disconnect() end
                    end)
                end)
                UserInputService.InputBegan:Connect(function(input,gpe)
                    if gpe then return end
                    if input.KeyCode==current then pcall(callback) end
                end)
                function fr:Set(keycode) current = keycode; btn.Text=current.Name end
                return fr
            end

            return section
        end

        table.insert(self._tabs, TabObj)
        -- Select first tab visual
        btn.BackgroundColor3 = (#self._tabs==1) and theme.Accent or theme.Muted
        return TabObj
    end

    function self:SaveConfig(name, data)
        local folder = "BannaHub_Configs"; if not FS.exists(folder) then FS.makefolder(folder) end
        local path = folder.."/"..tostring(name or "config")..".json"
        local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if ok then FS.write(path, encoded) end
        return path
    end

    function self:LoadConfig(name)
        local path = "BannaHub_Configs/"..tostring(name or "config")..".json"
        if FS.exists(path) then
            local ok, tbl = pcall(HttpService.JSONDecode, HttpService, FS.read(path))
            if ok then return tbl end
        end
        return nil
    end

    return self
end

return setmetatable({}, LIB)
