local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TaeBanna/Script/main/Kivo.lua", true))()
local Window = Library.CreateLib("BannaHub", "DarkTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Anyware")
loadstring(game:HttpGet("https://raw.githubusercontent.com/TaeBanna/Script/main/Uiclose.lua", true))()(Library)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

Section:NewToggle("BringOres(Lag)", "เปิด/ปิดระบบดึง แร่", function(val)
    _G.BringCoal = val
end)

spawn(function()
    while task.wait() do
        if _G.BringCoal then
            pcall(function()
                for _, v in ipairs(workspace.Items:GetChildren()) do
                   if v.Name  then
                       v.CFrame = hrp.CFrame
                    --if string.find(v.Name, "Coal Ore") then ยังไม่ใช้ๆ
                   end 
                end
            end)
        end
    end
end)

Section:NewButton("SellOres", "ButtonInfo", function()
    local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local old = hrp.CFrame
    hrp.CFrame = CFrame.new(1019, 245, -65)
    task.wait(0.5)
    game:GetService("ReplicatedStorage"):WaitForChild("Ml"):WaitForChild("SellInventory"):FireServer()
    task.wait(0.5)
    hrp.CFrame = old
end)

local Tab = Window:NewTab("HotKey")
local Section = Tab:NewSection("Section Name")
Section:NewButton("Toggle ปุ่มลอย", "เปิด/ปิดปุ่มลอย (Close Gui)", function()
    local toggleGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("ToggleGui")
    if toggleGui then
        toggleGui.Enabled = not toggleGui.Enabled
    end
end)
