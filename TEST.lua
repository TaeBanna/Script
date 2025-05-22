---Ghost Gui UI Library
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/UI-Library/refs/heads/main/Ghost%20Gui'))()
game.CoreGui.GhostGui.MainFrame.Title.Text = "test game"

local f = workspace.Players:WaitForChild("Killers")

local highlightEnabled = false
local conn

local function updateHighlight(o, add)
	if not (o:IsA("Model") or o:IsA("BasePart")) then return end
	local hl = o:FindFirstChildOfClass("Highlight")
	if add and not hl then
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
	-- เพิ่มไฮไลต์ทั้งหมดในโฟลเดอร์
	for _, o in ipairs(f:GetChildren()) do
		updateHighlight(o, true)
	end
	-- เชื่อมต่อแค่ event เดียว ตรวจทั้งเพิ่มและลบ
	conn = f.ChildAdded:Connect(function(o)
		updateHighlight(o, true)
		-- ตรวจสอบถ้าเปลี่ยนโฟลเดอร์ด้วย
		o.AncestryChanged:Connect(function(_, parent)
			if highlightEnabled then
				updateHighlight(o, parent == f)
			end
		end)
	end)
	-- ตรวจสอบไอเท็มที่ถูกลบ
	f.ChildRemoved:Connect(function(o)
		updateHighlight(o, false)
	end)
end

function disableHighlight()
	if not highlightEnabled then return end
	highlightEnabled = false
	if conn then
		conn:Disconnect()
		conn = nil
	end
	clearHighlights()
end


enableHighlight()

enableHighlight()  -- เริ่มต้นเปิดไฮไลต์
]],[[
disableHighlight()
]])
