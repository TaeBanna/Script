---Ghost Gui UI Library
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/UI-Library/refs/heads/main/Ghost%20Gui'))()
game.CoreGui.GhostGui.MainFrame.Title.Text = "BBGum"
---


AddContent("TextButton", "Text Here", [[
--script here need clear--
]])



AddContent("Switch", "AutoBubble", [[
local rs = game:GetService("ReplicatedStorage")
local evt = rs.Shared.Framework.Network.Remote.RemoteEvent
local running = false

local function BBenable()
	if running then return end
	running = true
	task.spawn(function()
		while running do
			evt:FireServer("BlowBubble")
			task.wait(0.1)
		end
	end)
end

local function BBdisable()
	running = false
end


BBenable()
]],[[
BBdisable()
]])


TextLabel = AddContent("TextLabel")
TextLabel.Text = "Text Here"
