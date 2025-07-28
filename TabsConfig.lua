-- TabsConfig.lua
-- ตารางข้อมูล Tab + เนื้อหา (Button, Toggle)

return {
    {
        Name = "General",
        Content = {
            {
                Type = "Button",
                Text = "Click Me",
                OnClick = function()
                    print("Button Click Me clicked")
                end,
            },
            {
                Type = "Toggle",
                Text = "Enable Feature A",
                OnToggle = function(state)
                    print("Feature A toggled:", state)
                end,
            },
            {
                Type = "Toggle",
                Text = "Enable Feature B",
                OnToggle = function(state)
                    print("Feature B toggled:", state)
                end,
            },
        },
    },
    {
        Name = "Settings",
        Content = {
            {
                Type = "Button",
                Text = "Run Task",
                OnClick = function()
                    print("Run Task button clicked")
                end,
            },
            {
                Type = "Toggle",
                Text = "Activate Mode",
                OnToggle = function(state)
                    print("Activate Mode toggled:", state)
                end,
            },
        },
    },
}
