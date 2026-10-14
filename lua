local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "DOORS Ultimate Hub | Delta", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "DOORS Ultimate Hub"
})

-- ตัวแปรตั้งค่าระบบทั้งหมด
_G.FullBright = false
_G.NoFog = false
_G.SpeedBoost = false
_G.DoorESP = false
_G.KeyESP = false
_G.ItemESP = false
_G.EntityAlert = false
_G.BookESP = false
_G.FigureESP = false
_G.GlowEyes = false

-- ฟังก์ชันสร้าง Highlight (ESP)
local function createHighlight(instance, color)
    if not instance:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = instance
        highlight.FillColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = instance
        return highlight
    end
end

-- ฟังก์ชันลบ Highlight
local function removeHighlight(instance)
    if instance and instance:FindFirstChild("ESPHighlight") then
        instance.ESPHighlight:Destroy()
    end
end

-- ==================== TAB 1: MAIN & PLAYER ====================
local MainTab = Window:MakeTab({
	Name = "Main / ตัวละคร",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

MainTab:AddToggle({
	Name = "มองเห็นในที่มืด (FullBright)",
	Default = false,
	Callback = function(Value)
		_G.FullBright = Value
        if _G.FullBright then
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        else
            game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
        end
	end    
})

MainTab:AddToggle({
	Name = "ลบหมอกออก (Clear Fog)",
	Default = false,
	Callback = function(Value)
		_G.NoFog = Value
		if _G.NoFog then
			game:GetService("Lighting").FogEnd = 9e9
		else
			game:GetService("Lighting").FogEnd = 1000
		end
	end    
})

MainTab:AddToggle({
	Name = "เพิ่มความเร็วเดิน (WalkSpeed 21)",
	Default = false,
	Callback = function(Value)
		_G.SpeedBoost = Value
	end    
})

MainTab:AddToggle({
	Name = "Infinite Jump (กระโดดรัวๆ)",
	Default = false,
	Callback = function(Value)
		_G.InfJump = Value
	end    
})

-- ==================== TAB 2: ESP & ITEMS ====================
local ESPTab = Window:MakeTab({
	Name = "ESP (มองทะลุกำแพง)",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

ESPTab:AddToggle({
	Name = "ESP ประตูห้องที่ถูกต้อง (สีเขียว)",
	Default = false,
	Callback = function(Value)
		_G.DoorESP = Value
		if not _G.DoorESP then
			for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
				if v.Name == "Door" then removeHighlight(v) end
			end
		end
	end    
})

ESPTab:AddToggle({
	Name = "ESP กุญแจ (สีเหลือง)",
	Default = false,
	Callback = function(Value)
		_G.KeyESP = Value
		if not _G.KeyESP then
			for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
				if v.Name == "KeyObtain" then removeHighlight(v) end
			end
		end
	end    
})

ESPTab:AddToggle({
	Name = "ESP ไอเทม/เหรียญ/ตู้ (สีฟ้า)",
	Default = false,
	Callback = function(Value)
		_G.ItemESP = Value
		if not _G.ItemESP then
			for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
				if v.Name == "GoldPile" or v.Name == "Lighter" or v.Name == "Flashlight" or v.Name == "Lockpick" then
					removeHighlight(v)
				end
			end
		end
	end    
})

-- ==================== TAB 3: ROOM 50 & SPECIAL ====================
local Room50Tab = Window:MakeTab({
	Name = "ห้อง 50 / ห้องพิเศษ",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Room50Tab:AddToggle({
	Name = "ESP สมุดห้อง 50 (สีน้ำเงิน)",
	Default = false,
	Callback = function(Value)
		_G.BookESP = Value
		if not _G.BookESP then
			for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
				if v.Name == "LiveHintBook" then removeHighlight(v) end
			end
		end
	end    
})

Room50Tab:AddToggle({
	Name = "ESP ตัวผีฟิกเกอร์ / Figure (สีแดง)",
	Default = false,
	Callback = function(Value)
		_G.FigureESP = Value
		if not _G.FigureESP then
			for _, v in pairs(workspace:GetDescendants()) do
				if v.Name == "FigureRagdoll" or (v.Name == "Figure" and v:FindFirstChild("Humanoid")) then
					removeHighlight(v)
				end
			end
		end
	end    
})

-- ==================== TAB 4: ALERTS ====================
local AlertTab = Window:MakeTab({
	Name = "แจ้งเตือนภัย",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

AlertTab:AddToggle({
	Name = "แจ้งเตือนผีบุก (Rush, Ambush, Screech)",
	Default = false,
	Callback = function(Value)
		_G.EntityAlert = Value
	end    
})

-- ==================== LOOPS & LOGIC ====================

-- Loop ความเร็วและกระโดด
task.spawn(function()
	while task.wait(0.1) do
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			if _G.SpeedBoost then
				char.Humanoid.WalkSpeed = 21
			end
		end
	end
end)

-- ระบบ Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
	if _G.InfJump then
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChildOfClass('Humanoid') then
			char.Humanoid:ChangeState("Jumping")
		end
	end
end)

-- Loop ESP รวม
task.spawn(function()
	while task.wait(1) do
		-- ประตู
		if _G.DoorESP then
			local latestRoomNum, latestRoom = 0, nil
			for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
				local roomNum = tonumber(room.Name)
				if roomNum and roomNum > latestRoomNum then
					latestRoomNum = roomNum
					latestRoom = room
				end
			end
			if latestRoom then
				local door = latestRoom:FindFirstChild("Door")
				if door and door:FindFirstChild("Door") then
					createHighlight(door.Door, Color3.fromRGB(0, 255, 0))
				end
			end
		end

		-- กุญแจ
		if _G.KeyESP then
			for _, obj in pairs(workspace.CurrentRooms:GetDescendants()) do
				if obj.Name == "KeyObtain" then
					createHighlight(obj, Color3.fromRGB(255, 255, 0))
				end
			end
		end

		-- ไอเทม
		if _G.ItemESP then
			for _, obj in pairs(workspace.CurrentRooms:GetDescendants()) do
				if obj.Name == "GoldPile" or obj.Name == "Lighter" or obj.Name == "Flashlight" or obj.Name == "Lockpick" then
					createHighlight(obj, Color3.fromRGB(0, 150, 255))
				end
			end
		end

		-- สมุดห้อง 50
		if _G.BookESP then
			for _, obj in pairs(workspace.CurrentRooms:GetDescendants()) do
				if obj.Name == "LiveHintBook" then
					createHighlight(obj, Color3.fromRGB(0, 100, 255))
				end
			end
		end

		-- ฟิกเกอร์
		if _G.FigureESP then
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj.Name == "FigureRagdoll" or (obj.Name == "Figure" and obj:FindFirstChild("Humanoid")) then
					createHighlight(obj, Color3.fromRGB(255, 0, 0))
				end
			end
		end
	end
end)

-- ระบบแจ้งเตือนศัตรู
game:GetService("Workspace").ChildAdded:Connect(function(child)
    if _G.EntityAlert then
        if child.Name == "RushMoving" or child.Name == "AmbushMoving" or child.Name == "Eyes" then
            OrionLib:MakeNotification({
                Name = "⚠️ ระวังภัยอันตราย!",
                Content = "ตรวจพบ " .. child.Name .. " กำลังมาโจมตี!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
end)

OrionLib:Init()

-- ==================== FLOATING TOGGLE BUTTON ====================
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("CustomFloatingToggle") then
    CoreGui.CustomFloatingToggle:Destroy()
end

local floatGui = Instance.new("ScreenGui")
floatGui.Name = "CustomFloatingToggle"
floatGui.Parent = CoreGui
floatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = floatGui
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 128)
toggleBtn.BorderSizePixel = 2
toggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleBtn.Size = UDim2.new(0, 110, 0, 45)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Text = "UI Menu"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Active = true
toggleBtn.Draggable = true -- ปุ่มเลื่อนย้ายตำแหน่งได้อิสระ

local uiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    toggleBtn.Text = uiVisible and "UI Menu" or "Show UI"
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:FindFirstChild("Main") then
            gui.Main.Visible = uiVisible
        end
    end
end)
