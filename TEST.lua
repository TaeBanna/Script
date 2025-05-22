---Ghost Gui UI Library
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/UI-Library/refs/heads/main/Ghost%20Gui'))()
game.CoreGui.GhostGui.MainFrame.Title.Text = "test game"

AddContent("Switch", "ESP Killer", [[
local f = workspace.Players:WaitForChild("Killers")

local highlightEnabled = false
local addedConn, removedConn

-- ค่าเริ่มต้น GHighlight() ไม่ทำอะไรเลย
local function GHighlight()
	-- ว่างไว้ ไม่มีการทำงาน
end

local function up(o, add)
	local hl = o:FindFirstChildOfClass("Highlight")
	if add and not hl and (o:IsA("Model") or o:IsA("BasePart")) then
		Instance.new("Highlight", o).FillColor = Color3.fromRGB(255,0,0)
	elseif not add and hl then
		hl:Destroy()
	end
end

local function clearHighlights()
	for _, o in ipairs(f:GetChildren()) do
		local hl = o:FindFirstChildOfClass("Highlight")
		if hl then hl:Destroy() end
	end
end

function enableHighlight()
	if highlightEnabled then return end
	highlightEnabled = true
	for _, o in ipairs(f:GetChildren()) do up(o, true) end
	addedConn = f.ChildAdded:Connect(function(o) up(o, true) end)
	removedConn = f.ChildRemoved:Connect(function(o) up(o, false) end)
end

function disableHighlight()
	if not highlightEnabled then return end
	highlightEnabled = false
	if addedConn then addedConn:Disconnect() end
	if removedConn then removedConn:Disconnect() end
	clearHighlights()
end

-- กำหนดให้เริ่มต้นเป็นฟังก์ชัน GHighlight ที่ไม่ทำอะไรเลย
highlightEnabled = false
addedConn = nil
removedConn = nil
local HighlightFunction = GHighlight

enableHighlight()

enableHighlight()  -- เริ่มต้นเปิดไฮไลต์
]],[[
disableHighlight()
]])
