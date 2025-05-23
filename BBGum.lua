---Ghost Gui UI Library
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/UI-Library/refs/heads/main/Ghost%20Gui'))()
game.CoreGui.GhostGui.MainFrame.Title.Text = "Title Here"
---


AddContent("TextButton", "Text Here", [[
--script here need clear--
]])


TextBox = AddContent("TextBox","Text")
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
print(TextBox.Text)
end)


AddContent("Toogle", "Text Here", [[
--script here need clear--
]])


AddContent("Switch", "Text Here", [[
--script1 here need clear เปิด --
]],[[
--script2 here need clear ปิด --
]])


TextLabel = AddContent("TextLabel")
TextLabel.Text = "Text Here"
