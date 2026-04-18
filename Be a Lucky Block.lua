repeat wait() until game:IsLoaded()

if not LPH_OBFUSCATED then
	LPH_JIT_MAX = function(...) return (...) end
	LPH_NO_VIRTUALIZE = function(...) return (...) end
	LPH_NO_UPVALUES = function(...) return (...) end
	LPH_NO_CRASH = function(...) return ... end
	LPH_CRASH = function(...) return ... end
else
	print = function() end
	warn = function() end
end

getgenv().type1 = getgenv().type1 or {}
getgenv().type2 = getgenv().type2 or {}
getgenv().type3 = getgenv().type3 or ()

local type1 = getgenv().type1
local type2 = getgenv().type2
local type3 = getgenv().type3

local Tasks = {}
local Connections = {}

local CoreGui             = cloneref(game:GetService("CoreGui"))
local CollectionService   = cloneref(game:GetService("CollectionService"))
local Debris              = cloneref(game:GetService("Debris"))
local GuiService          = cloneref(game:GetService("GuiService"))
local HttpService         = cloneref(game:GetService("HttpService"))
local Lighting            = cloneref(game:GetService("Lighting"))
local LocalizationService = cloneref(game:GetService("LocalizationService"))
local Players             = cloneref(game:GetService("Players"))
local ReplicatedFirst     = cloneref(game:GetService("ReplicatedFirst"))
local ReplicatedStorage   = cloneref(game:GetService("ReplicatedStorage"))
local RunService          = cloneref(game:GetService("RunService"))
local TeleportService     = cloneref(game:GetService("TeleportService"))
local TextChatService     = cloneref(game:GetService("TextChatService"))
local TweenService        = cloneref(game:GetService("TweenService"))
local UserInputService    = cloneref(game:GetService("UserInputService"))
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local VirtualUser         = cloneref(game:GetService("VirtualUser"))
local Workspace           = cloneref(game:GetService("Workspace"))
local PathfindingService  = cloneref(game:GetService("PathfindingService"))
local MarketplaceService = cloneref(game:GetService("MarketplaceService"))

local wait = task.wait
local spawn = task.spawn
local delay = task.delay
local Camera = Workspace.CurrentCamera

local plr = Players.LocalPlayer
local PlayerGUI = plr:FindFirstChildWhichIsA("PlayerGui")

local webhookUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/i-have-no-mouth-and-i-must-scream/37rXY2BbzPsBuyxp9hxrzsjiFD4zAl/vjQLEgzpAbTYwvwveMTXAQWmwsmitJ/QRJmhqMmynIonYP7Bh5FX7vtBfyid7.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/i-have-no-mouth-and-i-must-scream/37rXY2BbzPsBuyxp9hxrzsjiFD4zAl/vjQLEgzpAbTYwvwveMTXAQWmwsmitJ/vaHARNAHubAdzwt1xS2dLWqgGnETtV.lua"))()

local char, Flags = nil, Library.Flags

if plr:GetAttribute("InSpawn") then
	char = plr.Character or plr.CharacterAdded:Wait()
end

local function InsertTasks(Task)
	table.insert(Tasks, Task)
end

local function InsertConnections(Connection)
	table.insert(Connections, Connection)
end

local function AddCooldown(v, c)
	type1.CooldownList[v] = c and (tick() + c) or math.huge
end

local function HasCooldown(v)
	local c = type1.CooldownList[v]

	if c and tick() >= c then
		type1.CooldownList[v] = nil
		return false
	end

	return c ~= nil
end

local VIRTUALIZE112 = LPH_NO_VIRTUALIZE(function(a)
	a:WaitForChild("HumanoidRootPart", 9)
	a:WaitForChild("Humanoid", 9)
	a:WaitForChild("Head", 9)
	char = a
end)

InsertConnections(plr.CharacterAdded:Connect(VIRTUALIZE112))

if getconnections then
	local connections = getconnections(plr.Idled)

	for _, v in connections do
		if v.Disable then
			v:Disable()
		elseif v.Disconnect then
			v:Disconnect()
		end
	end
end

InsertConnections(plr.Idled:Connect(LPH_NO_VIRTUALIZE(function()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
	wait(0.01)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end)))

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local InstanceNew = Instance.new

local Tween = { } do
	Tween.__index = Tween

	Tween.Create = function(self, Item, Info, Goal, IsRawItem)
		Item = IsRawItem and Item or Item.Instance
		Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

		local NewTween = {
			Tween = TweenService:Create(Item, Info, Goal),
			Info = Info,
			Goal = Goal,
			Item = Item
		}

		NewTween.Tween:Play()

		setmetatable(NewTween, Tween)

		function NewTween:Wait()
			self.Tween.Completed:Wait()
			return self
		end

		function NewTween:Pause()
			self.Tween:Pause()
			return self
		end

		function NewTween:Resume()
			self.Tween:Resume()
			return self
		end

		function NewTween:Cancel()
			self.Tween:Cancel()
			self = nil
		end

		function NewTween:Destroy()
			self.Tween:Cancel()
			self = nil
		end

		function NewTween:Pause()
			self.Tween:Pause()
			self = nil
		end
	end
end

local Instances = { } do
	Instances.__index = Instances

	Instances.Create = function(self, Class, Properties)
		local Success, Result = pcall(function()
			local NewItem = {
				Instance = InstanceNew(Class),
				Properties = Properties,
				Class = Class
			}

			setmetatable(NewItem, Instances)

			for Property, Value in pairs(NewItem.Properties) do
				local PropSuccess = pcall(function()
					NewItem.Instance[Property] = Value
				end)
			end

			return NewItem
		end)

		if Success and Result then
			return Result
		end

		return {
			Instance = nil,
			Properties = Properties or {},
			Class = Class,
			_Protected = true
		}
	end

	Instances.Connect = function(self, Event, Callback, Name)
		if not self.Instance then 
			return
		end

		if not self.Instance[Event] then 
			return
		end

		if getgenv().relix then
			if Event == "MouseButton1Down" or Event == "MouseButton1Click" then
				Event = "TouchTap"
			end
		end

		return Library:Connect(self.Instance[Event], Callback, Name)
	end

	Instances.Tween = function(self, Info, Goal)
		if not self.Instance then
			return
		end

		return Tween:Create(self, Info, Goal)
	end

	Instances.MakeDraggable = function(self)
		if not self.Instance then 
			return
		end

		local Gui = self.Instance

		local Dragging = false 
		local DragStart
		local StartPosition 

		local Set = function(Input)
			local Scale = Library.UIScaleNum or 1
			local DragDelta = (Input.Position - DragStart) / Scale

			self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
		end

		local Changed

		self:Connect("InputBegan", function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true

				DragStart = Input.Position
				StartPosition = Gui.Position

				if Changed then
					return
				end

				Changed = Input.Changed:Connect(LPH_NO_VIRTUALIZE(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false

						if Changed then
							Changed:Disconnect()
							Changed = nil
						end
					end
				end))
			end
		end)

		InsertConnections(Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				if Dragging then
					Set(Input)
				end
			end
		end)))

		return Dragging
	end

	Instances.Clean = function(self)
		if not self.Instance then 
			return
		end

		self.Instance:Destroy()
		self = nil
	end
end

local GetUI = gethui or function()
	local Success, Result = pcall(function()
		return CoreGui
	end)
	return Success and Result or false
end

local function SafeGetUI()
	local Success, Result = pcall(GetUI)

	if Success and Result then
		return Result
	end
	return CoreGui or false
end

local function SafeGetFont(...)
	local Success, Result = pcall(function(...)
		return Font.new(...)
	end, ...)

	return Success and Result or nil
end

local Font = (function()
	local AssetFolder = "solixhub/Assets"
	local FontPath = AssetFolder .. "/InterSemiBold.Font"
	local FontUrl = "https://github.com/sametexe001/luas/Text/refs/heads/main/fonts/InterSemiBold.ttf"

	if not isfolder(AssetFolder) then
		makefolder(AssetFolder)
	end

	if not isfile(FontPath) then
		local Success, Response = pcall(function()
			return HttpService:GetAsync(FontUrl)
		end)

		if Success and Response and Response ~= "" then
			writefile(FontPath, Response)
		end
	end

	if isfile(FontPath) then
		local CustomAsset = getcustomasset(FontPath)

		if CustomAsset then
			local Loaded = SafeGetFont(CustomAsset)

			if Loaded then
				return Loaded
			end
		end
	end

	local Fallback = SafeGetFont(Enum.Font.GothamBold)

	if Fallback then
		return Fallback
	end
	return Enum.Font.GothamBold
end)()

local function FindPath(a, ...)
	for _, b in {...} do
		if not a then return false end
		a = a:FindFirstChild(b)
	end
	return a
end

local function WaitPath(a, ...)
	for _, b in {...} do
		if not a then return false end
		a = a:WaitForChild(b)
	end
	return a
end

local function IsActive(a)
	return a
		and a.Parent
		and a:FindFirstChild("HumanoidRootPart")
		and a:FindFirstChildOfClass("Humanoid")
		and a:FindFirstChildOfClass("Humanoid").Health > 0
end

local function ToTime(a)
	if a < 0 then
		return "I don't know either"
	end

	a = math.floor(a)

	local b = math.floor(a / 86400)

	a = a % 86400

	local c = math.floor(a / 3600)

	a = a % 3600

	local d = math.floor(a / 60)
	local e = a % 60

	if b > 0 then
		return string.format("%dd %02dh %02dm %02ds", b, c, d, e)
	else
		return string.format("%02dh %02dm %02ds", c, d, e)
	end
end

local function NormalizeName(a)
	a = tostring(a)
	a = string.lower(a)
	a = a:gsub("%s+", "")
	a = a:gsub("%d", "")
	return a
end

function NormalizeText(a)
	a = tostring(a)
	a = a:gsub("<.->", "")
	a = a:gsub("%d%d:%d%d:%d%d%s*", "")
	a = a:gsub("%.$", "")
	a = a:match("^%s*(.-)%s*$")
	return a
end

local function TP(a)
	if not a or not IsActive(char) then return end

	char.HumanoidRootPart.CFrame = a
end

local function SendTrue(a)
	VirtualInputManager:SendKeyEvent(true, a, false, game)
end

local function SendFalse(a)
	VirtualInputManager:SendKeyEvent(false, a, false, game)
end

local function SendKey(a)
	SendTrue(a)
	wait(0.01)
	SendFalse(a)
end

local function ClickGui(a)
	if not a or not a:IsA("GuiObject") then return false end

	local b = false

	for c = 1, 3 do
		if a 
			and a.Parent 
			and a.Visible 
			and a.Parent:IsDescendantOf(PlayerGUI) then
			local d = pcall(function() GuiService.SelectedObject = a end)

			if d and GuiService.SelectedObject == a then
				b = true
				break
			end
		end
	end

	if b then
		SendKey(Enum.KeyCode.Return)		
		wait(0.01)
		GuiService.SelectedObject = nil
	end
end

local function ProximityPrompt(a)
	if HasCooldown("Proximity Prompt") then return false end

	if a and a.Parent and a.Enabled then
		AddCooldown("Proximity Prompt", 0.03)
		a.HoldDuration = 0 fireproximityprompt(a)
	end
end

local function SendWebhook(a, b, c)
	local a = webhookUtil.createMessage({
		username = "solixhub",
		Url = Library.Flags["Webhook URL " .. a],
		content = Library.Flags["Mention Option " .. a]
	})

	local b = a.addEmbed("Be a Lucky Block", math.random(0, 16777215), "")
	b.addField("Name", "||" .. plr.Name .. " [" .. plr:GetAttribute("PlayerSkin") .. "]||")
	b.addField(b, c)

	pcall(function()
		a.sendMessage()
	end)
end

local function GetBrainrotSell()
	local a = type1.RaritySellSelect
	local b = type1.BrainrotKeepSelect
	local c = type1.MutationKeepSelect
	local d = {}

	for _, e in plr.Backpack:GetChildren() do
		if e:IsA("Tool") then
			local f = e:GetAttribute("BrainrotType")
			local g = e:GetAttribute("BrainrotMutation")
			local h = type1.BrainrotNameData[f]

			local i = false

			if a and next(a) and not table.find(a, h) then
				i = true
			end

			if not i and b and next(b) and table.find(b, f) then
				i = true
			end

			if not i and g and c and next(c) and table.find(c, g) then
				i = true
			end

			if not i then
				local j = type1.RarityData[h] or 0
				local k = type1.MutationData[g] or 0

				table.insert(d, {
					Instance = e,
					Rarity = h,
					RarityIndex = j,
					Mutation = g,
					MutationIndex = k
				})
			end
		end
	end

	table.sort(d, function(m, n)
		if m.RarityIndex ~= n.RarityIndex then
			return m.RarityIndex < n.RarityIndex
		end

		if m.MutationIndex ~= n.MutationIndex then
			return m.MutationIndex < n.MutationIndex
		end

		return m.RarityIndex < n.RarityIndex
	end)

	if #d > 0 then
		return d[1].Instance
	end
	return nil
end

local function GetBrainrotFuse()
	local a = type1.RarityFuseSelect
	local b = type1.BrainrotFuseSelect
	local c = type1.MutationFuseSelect
	local d = {}

	for _, e in plr.Backpack:GetChildren() do
		if e:IsA("Tool") then
			local f = e:GetAttribute("BrainrotType")
			local g = e:GetAttribute("BrainrotMutation")
			local h = type1.BrainrotNameData[f]

			local i = false

			if a and next(a) and not table.find(a, h) then
				i = true
			end

			if not i and b and next(b) and not table.find(b, f) then
				i = true
			end

			if not i and g and c and next(c) and not table.find(c, g) then
				i = true
			end

			if not i then
				local j = type1.RarityData[h] or 0
				local k = type1.MutationData[g] or 0

				table.insert(d, {
					Instance = e,
					Rarity = h,
					RarityIndex = j,
					Mutation = g,
					MutationIndex = k
				})
			end
		end
	end

	table.sort(d, function(m, n)
		if m.RarityIndex ~= n.RarityIndex then
			return m.RarityIndex > n.RarityIndex
		end

		if m.MutationIndex ~= n.MutationIndex then
			return m.MutationIndex > n.MutationIndex
		end

		return m.RarityIndex > n.RarityIndex
	end)

	if #d > 0 then
		return d[1].Instance
	end
	return nil
end

local function StopFly()
	type3.IsFlying = false

	if type3.KeyDown then
		type3.KeyDown:Disconnect()
		type3.KeyDown = nil
	end

	if type3.KeyUp then
		type3.KeyUp:Disconnect()
		type3.KeyUp = nil
	end

	if type3.Loop then
		type3.Loop:Disconnect()
		type3.Loop = nil
	end

	if type3.Connection1 then
		type3.Connection1:Disconnect()
		type3.Connection1 = nil
	end

	if type3.Connection2 then
		type3.Connection2:Disconnect()
		type3.Connection2 = nil
	end

	if type3.Velocity then
		type3.Velocity:Clean()
	end

	if type3.Gyro then
		type3.Gyro:Clean()
	end

	if IsActive(char) then
		char.Humanoid.PlatformStand = false
	end

	pcall(function()
		Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	end)
end

local function FlyNormal()
	StopFly()

	if not IsActive(char) then 
		return
	end

	type3.IsFlying = true
	char.Humanoid.PlatformStand = true

	type3.Velocity = Instances:Create("BodyVelocity", {
		Parent = char.HumanoidRootPart,
		Name = "Velocity " .. tick(),
		Velocity = Vector3.new(0, 0, 0),
		MaxForce = Vector3.new(9e9, 9e9, 9e9)
	})

	type3.Gyro = Instances:Create("BodyGyro", {
		Parent = char.HumanoidRootPart,
		Name = "Gyro " .. tick(),
		P = 9e4,
		MaxTorque = Vector3.new(9e9, 9e9, 9e9),
		CFrame = char.HumanoidRootPart.CFrame
	})

	local a = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local b = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local c = 0

	type3.Loop = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
		if not type3.IsFlying or not IsActive(char) then
			StopFly()
			return
		end

		if a.L + a.R ~= 0 or a.F + a.B ~= 0 or a.Q + a.E ~= 0 then
			c = Flags["Fly Speed"] or 30
		elseif c ~= 0 then
			c = 0
		end

		if (a.L + a.R) ~= 0 or (a.F + a.B) ~= 0 or (a.Q + a.E) ~= 0 then
			local d = ((Camera.CFrame.LookVector * (a.F + a.B)) + ((Camera.CFrame * CFrame.new(a.L + a.R, (a.F + a.B + a.Q + a.E) * 0.2, 0).p) - Camera.CFrame.p)) * c

			type3.Velocity.Instance.Velocity = d
			b = {F = a.F, B = a.B, L = a.L, R = a.R}
		elseif c ~= 0 then
			local d = ((Camera.CFrame.LookVector * (b.F + b.B)) + ((Camera.CFrame * CFrame.new(b.L + b.R, (b.F + b.B + b.Q + b.E) * 0.2, 0).p) - Camera.CFrame.p)) * c

			type3.Velocity.Instance.Velocity = d
		else
			type3.Velocity.Instance.Velocity = Vector3.new(0, 0, 0)
		end
		type3.Gyro.Instance.CFrame = Camera.CFrame
	end))

	if getgenv().relix then
		local d = plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")

		type3.Connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
			if not type3.IsFlying or not IsActive(char) then
				StopFly()
				return
			end

			type3.Velocity.Instance.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			type3.Gyro.Instance.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			type3.Gyro.Instance.CFrame = Workspace.CurrentCamera.CoordinateFrame
			type3.Velocity.Instance.Velocity = Vector3.new(0, 0, 0)

			local e = d:GetMoveVector()

			if e.X > 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity + Workspace.CurrentCamera.CFrame.RightVector * (e.X * ((Flags["Fly Speed"] or 30) * 50))
			end
			if e.X < 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity + Workspace.CurrentCamera.CFrame.RightVector * (e.X * ((Flags["Fly Speed"] or 30) * 50))
			end
			if e.Z > 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity - Workspace.CurrentCamera.CFrame.LookVector * (e.Z * ((Flags["Fly Speed"] or 30) * 50))
			end
			if e.Z < 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity - Workspace.CurrentCamera.CFrame.LookVector * (e.Z * ((Flags["Fly Speed"] or 30) * 50))
			end
		end))
	else
		type3.KeyDown = UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(f, g)
			if g then return end

			if f.KeyCode == Enum.KeyCode.W then
				a.F = Flags["Fly Speed"] or 30
			elseif f.KeyCode == Enum.KeyCode.S then
				a.B = -(Flags["Fly Speed"] or 30)
			elseif f.KeyCode == Enum.KeyCode.A then
				a.L = -(Flags["Fly Speed"] or 30)
			elseif f.KeyCode == Enum.KeyCode.D then
				a.R = Flags["Fly Speed"] or 30
			elseif f.KeyCode == Enum.KeyCode.E then
				a.Q = (Flags["Fly Speed"] or 30) * 2
			elseif f.KeyCode == Enum.KeyCode.Q then
				a.E = -(Flags["Fly Speed"] or 30) * 2
			end

			pcall(function()
				Workspace.CurrentCamera.CameraType = Enum.CameraType.Track
			end)
		end))

		type3.KeyUp = UserInputService.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(f, g)
			if g then return end

			if f.KeyCode == Enum.KeyCode.W then
				a.F = 0
			elseif f.KeyCode == Enum.KeyCode.S then
				a.B = 0
			elseif f.KeyCode == Enum.KeyCode.A then
				a.L = 0
			elseif f.KeyCode == Enum.KeyCode.D then
				a.R = 0
			elseif f.KeyCode == Enum.KeyCode.E then
				a.Q = 0
			elseif f.KeyCode == Enum.KeyCode.Q then
				a.E = 0
			end
		end))
	end

	type3.Connection2 = plr.CharacterAdded:Connect(LPH_NO_VIRTUALIZE(function()
		StopFly()
	end))
end

local function FlyVehicle()
	StopFly()

	if not IsActive(char) then 
		return
	end

	type3.IsFlying = true
	char.Humanoid.PlatformStand = true

	type3.Velocity = Instances:Create("BodyVelocity", {
		Parent = char.HumanoidRootPart,
		Name = "Velocity " .. tick(),
		Velocity = Vector3.new(0, 0, 0),
		MaxForce = Vector3.new(9e9, 9e9, 9e9)
	})

	type3.Gyro = Instances:Create("BodyGyro", {
		Parent = char.HumanoidRootPart,
		Name = "Gyro " .. tick(),
		P = 9e4,
		MaxTorque = Vector3.new(9e9, 9e9, 9e9),
		CFrame = char.HumanoidRootPart.CFrame
	})

	local a = {F = 0, B = 0, L = 0, R = 0}
	local b = {F = 0, B = 0, L = 0, R = 0}
	local c = 0

	type3.Loop = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
		if not type3.IsFlying or not IsActive(char) then
			StopFly()
			return
		end

		if a.L + a.R ~= 0 or a.F + a.B ~= 0 then
			c = Flags["Fly Speed"] or 30
		elseif c ~= 0 then
			c = 0
		end

		if (a.L + a.R) ~= 0 or (a.F + a.B) ~= 0 then
			local d = ((Camera.CFrame.LookVector * (a.F + a.B)) + ((Camera.CFrame * CFrame.new(a.L + a.R, 0, 0).p) - Camera.CFrame.p)) * c

			type3.Velocity.Instance.Velocity = d
			b = {F = a.F, B = a.B, L = a.L, R = a.R}
		elseif c ~= 0 then
			local d = ((Camera.CFrame.LookVector * (b.F + b.B)) + ((Camera.CFrame * CFrame.new(b.L + b.R, 0, 0).p) - Camera.CFrame.p)) * c

			type3.Velocity.Instance.Velocity = d
		else
			type3.Velocity.Instance.Velocity = Vector3.new(0, 0, 0)
		end
		type3.Gyro.Instance.CFrame = Camera.CFrame
	end))

	if getgenv().relix then
		local d = plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")

		type3.Connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
			if not type3.IsFlying or not IsActive(char) then
				StopFly()
				return
			end

			type3.Velocity.Instance.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			type3.Gyro.Instance.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			type3.Gyro.Instance.CFrame = Workspace.CurrentCamera.CoordinateFrame
			type3.Velocity.Instance.Velocity = Vector3.new(0, 0, 0)

			local e = d:GetMoveVector()

			if e.X > 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity + Workspace.CurrentCamera.CFrame.RightVector * (e.X * ((Flags["Fly Speed"] or 30) * 50))
			end
			if e.X < 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity + Workspace.CurrentCamera.CFrame.RightVector * (e.X * ((Flags["Fly Speed"] or 30) * 50))
			end
			if e.Z > 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity - Workspace.CurrentCamera.CFrame.LookVector * (e.Z * ((Flags["Fly Speed"] or 30) * 50))
			end
			if e.Z < 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity - Workspace.CurrentCamera.CFrame.LookVector * (e.Z * ((Flags["Fly Speed"] or 30) * 50))
			end
		end))
	else
		type3.KeyDown = UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(f, g)
			if g then return end

			if f.KeyCode == Enum.KeyCode.W then
				a.F = Flags["Fly Speed"] or 30
			elseif f.KeyCode == Enum.KeyCode.S then
				a.B = -(Flags["Fly Speed"] or 30)
			elseif f.KeyCode == Enum.KeyCode.A then
				a.L = -(Flags["Fly Speed"] or 30)
			elseif f.KeyCode == Enum.KeyCode.D then
				a.R = Flags["Fly Speed"] or 30
			end

			pcall(function()
				Workspace.CurrentCamera.CameraType = Enum.CameraType.Track
			end)
		end))

		type3.KeyUp = UserInputService.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(f, g)
			if g then return end

			if f.KeyCode == Enum.KeyCode.W then
				a.F = 0
			elseif f.KeyCode == Enum.KeyCode.S then
				a.B = 0
			elseif f.KeyCode == Enum.KeyCode.A then
				a.L = 0
			elseif f.KeyCode == Enum.KeyCode.D then
				a.R = 0
			end
		end))
	end

	type3.Connection2 = plr.CharacterAdded:Connect(LPH_NO_VIRTUALIZE(function()
		StopFly()
	end))
end

local function OptimizeObject(a)
	if not a or not a.Parent then
		return
	end

	if a:IsA("BasePart") or a:IsA("MeshPart") then
		a.Reflectance = 0
		a.CastShadow = false
		a.Material = Enum.Material.SmoothPlastic
		a.TopSurface = Enum.SurfaceType.Studs
		a.BottomSurface = Enum.SurfaceType.Studs
		a.LeftSurface = Enum.SurfaceType.Studs
		a.RightSurface = Enum.SurfaceType.Studs
		a.FrontSurface = Enum.SurfaceType.Studs
		a.BackSurface = Enum.SurfaceType.Studs
		if a:IsA("MeshPart") then
			a.TextureID = ""
		end

	elseif a:IsA("Decal") or a:IsA("Texture") then
		a.Transparency = 1

	elseif a:IsA("Sky") then
		a.Parent = nil

	elseif a:IsA("ParticleEmitter") then
		a.Enabled = false
		a.Rate = 0
		a.Lifetime = NumberRange.new(0)
		a.Speed = NumberRange.new(0)
		a.Transparency = NumberSequence.new(1)

	elseif a:IsA("Trail") then
		a.Enabled = false
		a.Transparency = NumberSequence.new(1)

	elseif a:IsA("Beam") then
		a.Enabled = false
		a.Transparency = NumberSequence.new(1)
		a.Width0 = 0
		a.Width1 = 0

	elseif a:IsA("Smoke") or a:IsA("Fire") or a:IsA("Sparkles") then
		a.Enabled = false

	elseif a:IsA("Explosion") then
		a.Parent = nil

	elseif a:IsA("SurfaceGui") or a:IsA("BillboardGui") then
		a.Enabled = false

	elseif a:IsA("PointLight") or a:IsA("SpotLight") or a:IsA("SurfaceLight") then
		a.Enabled = true
		a.Brightness = math.min(a.Brightness, 1)
		a.Range = math.max(8, math.floor((a.Range or 16) * 0.6))

	elseif a:IsA("Highlight") or a:IsA("SelectionBox") or a:IsA("SelectionSphere") then
		a.Enabled = false

	elseif a:IsA("BloomEffect") or a:IsA("BlurEffect") or a:IsA("ColorCorrectionEffect") or a:IsA("SunRaysEffect") or a:IsA("DepthOfFieldEffect") then
		a.Enabled = false

	elseif a:IsA("Atmosphere") then
		a.Density = 0.05
		a.Haze = 0.2
		a.Glare = 0

	elseif a:IsA("Sound") then
		a.Volume = 0
		a.Playing = false

	elseif a:IsA("Terrain") then
		a.WaterWaveSize = 0
		a.WaterWaveSpeed = 0
		a.WaterReflectance = 0
		a.WaterTransparency = 1

	elseif a:IsA("PostEffect") then
		a.Enabled = false
	end
end

local function Hop(a)
	if not game.JobId or not game.PlaceId then
		Library:Notification({
			Name = "Hop Server",
			Description = "Cannot get server info",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	local b = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	if not b then
		Library:Notification({
			Name = "Hop Server",
			Description = "HTTP not supported",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	local c, d = pcall(function()
		return b({
			Url = string.format(
				"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
				game.PlaceId
			)
		})
	end)

	if not c or not d or not d.Body then
		Library:Notification({
			Name = "Hop Server",
			Description = "Failed to fetch servers",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	local e = HttpService:JSONDecode(d.Body)
	if not e or not e.data then
		Library:Notification({
			Name = "Hop Server",
			Description = "No server data found",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	if a == "Low Population" then
		local f = {}
		local g = ""
		local h = os.date("!*t").hour

		local function LowPlayers()
			local i
			if g == "" then
				i = HttpService:JSONDecode(
					game:HttpGet(
						"https://games.roblox.com/v1/games/" ..
							game.PlaceId ..
							"/servers/Public?sortOrder=Asc&limit=100"
					)
				)
			else
				i = HttpService:JSONDecode(
					game:HttpGet(
						"https://games.roblox.com/v1/games/" ..
							game.PlaceId ..
							"/servers/Public?sortOrder=Asc&limit=100&cursor=" ..
							g
					)
				)
			end

			if i.nextPageCursor and i.nextPageCursor ~= "null" then
				g = i.nextPageCursor
			end

			for _, j in i.data do
				local k = true
				local l = tostring(j.id)

				if tonumber(j.maxPlayers) > tonumber(j.playing) then
					for m, n in f do
						if m ~= 0 and l == tostring(n) then
							k = false
						elseif m == 0 and tonumber(h) ~= tonumber(n) then
							f = {}
							table.insert(f, h)
						end
					end

					if k then
						table.insert(f, l)
						Library:Notification({
							Name = "Hop Server",
							Description = "Found low population server: " .. j.playing .. "/" .. j.maxPlayers,
							Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
							Duration = 3
						})
						wait()
						pcall(function()
							TeleportService:TeleportToPlaceInstance(game.PlaceId, l, plr)
						end)
						wait(4)
					end
				end
			end
		end

		while wait() do
			pcall(function()
				LowPlayers()
				if g ~= "" then
					LowPlayers()
				end
			end)
		end
	else
		local o = {}

		for _, p in e.data do
			if tonumber(p.playing) < tonumber(p.maxPlayers) and p.id ~= game.JobId then
				table.insert(o, p)
			end
		end

		if #o > 0 then
			local q = o[math.random(1, #o)]
			Library:Notification({
				Name = "Hop Server",
				Description = "Found normal population server: " .. q.playing .. "/" .. q.maxPlayers,
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				Duration = 3
			})
			wait(1)
			pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, q.id, plr)
			end)
		else
			Library:Notification({
				Name = "Hop Server",
				Description = "No suitable servers found",
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				Duration = 10
			})
		end
	end
end

local function HttpGet(a)
	local b = {
		{
			check = function() return syn and syn.request end,
			call = function() return syn.request({Url = a, Method = "GET"}) end,
			extract = function(r) return r and r.Body end
		},
		{
			check = function() return http_request end,
			call = function() return http_request({Url = a, Method = "GET"}) end,
			extract = function(r) return r and (r.Body or r.g) end
		},
		{
			check = function() return request end,
			call = function() return request({Url = a, Method = "GET"}) end,
			extract = function(r) return r and (r.Body or r.g) end
		},
		{
			check = function() return http and http.request end,
			call = function() return http.request("GET", a) end,
			extract = function(r) return r and r.g end
		},
		{
			check = function() return HttpService and HttpService.HttpEnabled end,
			call = function() return HttpService:GetAsync(a) end,
			extract = function(r) return r end
		},
	}

	for _, c in ipairs(b) do
		if c.check() then
			local e, f = pcall(c.call)

			if e then
				local g = c.extract(f)

				if g and type(g) == "string" and #g > 0 then
					return true, g
				end
			end
		end
	end
	return false, nil
end

repeat wait(0.3) until plr and char and Library and Library.Flags and plr:GetAttribute("PlayerSkin")

type1 = {
	BrainrotRarityData = {
		Common = {
			"cacto_hipopotamo",
			"cocofanto_elefanto",
			"ballerina_cappuccina",
		},
		Uncommon = {
			"gangster_foottera",
			"udin_din_din_dun",
			"brr_brr_patapim",
		},
		Rare = {
			"capuccino_assassino",
			"gorillo_watermellondrillo",
			"trippi_troppi_troppa_trippa",
		},
		Epic = {
			"raccooni_watermelunni",
			"ta_ta_ta_ta_sahur",
			"glorbo_frutodrillo",
		},
		Legendary = {
			"yoni",
			"frigo_camello",
			"orangutini_ananassini",
			"ballerino_lololo",
			"trikitrakatelas",
		},
		Mythic = {
			"svinina_bombobardino",
			"frulli_frula",
			"tracoducotulu_delapeladustuz",
			"francesco",
		},
		Divine = {
			"ganganzelli_trulala",
			"orcalero_orcala",
			"lerulerulerule",
			"nuclerucci",
		},
		Secret = {
			"cavallo_virtuoso",
			"rhino_toasterino",
			"te_te_te_te_sahur",
			"ti_ti_ti_sahur",
			"mateo",
			"quesadilla_crocodila",
		},
		Cosmic = {
			"burbaloni_luliloli",
			"torrtuginni_dragonfrutinni",
			"los_tralaleritos",
			"pingvinator_termoregullator",
		},
		Admin = {
			"dojonini_assassini",
			"magiani_tankiani",
			"i2perfectini_foxinini",
		},
		Eternal = {
			"tralalero_tralala",
			"trulimero_trulicina",
			"chicleteira_bicicleteira",
			"pot_hotspot",
			"los_crocodillitos",
			"antonio",
			"pi_pi_pie_pie",
		},
		SPECIAL = {
			"ding_sahur",
			"ferro_sahur",
			"toc_toc_sahur",
			"rang_ring_reng",
			"meowl",
			"67",
			"la_vacca_saturno_saturnita",
			"las_vaquitas_saturnitas",
			"pipi_potato",
			"cathinni_sushinni",
			"graipus_medus",
			"spaghetti_tualetti",
			"tigrrullini_watermellini",
			"dragoni_cannelloni",
			"boneca_ambalabu",
			"gorgonzilla",
			"spioniro_golubiro",
			"salamino_penguino",
			"karkirkur",
			"chachechi",
			"luminous_yoni",
			"strawberry_elephant",
			"agarrini_lapalini",
			"gigalitraktos_spidorobos",
			"bulbito_bandito_traktorito",
			"wizard_cat",
			"bomboclat_crocolat",
			"wormrot",
		},
		CYBER = {
			"to_to_to_sahur",
			"bisonte_giuppitere_giuppitercito",
		},
		Angelic = {
			"angelzini_bananini",
			"angela_larila",
			"angel_bisonte_giuppitere",
			"angel_job_job_sahur",
			"angelinni_octossini",
		},
		Demonic = {
			"devilcino_assassino",
			"devupat_kepat_prekupat",
			"diavolero_tralala",
			"malamevil",
			"devilivion",
		},
		Alien = {
			"spaceshipini_tortini",
			"astro_bandito",
			"chachelien",
			"aliensini_octosini",
			"la_vacca_galactica",
		},
		Ink = {
			"glorbo_inkdrillo",
			"inknina_bombobardino",
			"ink_din_din_dun",
			"cavallo_inkuoso",
			"la_vacca_singolarita",
		},
		LAW = {
			"tic_tac_tok_afammocc",
			"elefantino_frigorifero",
		},
		GOD = {
			"squalo_cavallo",
		},
		Circus = {
			"jestellerino_lololo",
			"cocofanto_magicano",
			"clownteo",
			"tic_toc_circhur",
			"dragoni_circusoni",
		},
		Easter = {
			"hopster_foottera",
			"cocosino_bunnyno",
			"karkirkurster",
			"bulu_bulu_bulu_bulben",
			"buni",
			"malame_easterale",
		},
		["Easter Secret"] = {
		},
		["1x1x1x1"] = {
			"ketupat_corrupt",
			"banananito_hackerito",
			"salamino_exploito404",
			"mellondrillo404",
			"1x1x1x1",
		},
		Cloud = {
			"pipi_poppa_pippo_peppe",
			"bombirdini_tortini",
			"orangutini_wingassini",
			"ganganzelli_chikala",
			"bombardino_crocodilo",
		},
	},

	BrainrotNameData = {
		["cacto_hipopotamo"] = "Common",
		["cocofanto_elefanto"] = "Common",
		["ballerina_cappuccina"] = "Common",
		["gangster_foottera"] = "Uncommon",
		["udin_din_din_dun"] = "Uncommon",
		["brr_brr_patapim"] = "Uncommon",
		["capuccino_assassino"] = "Rare",
		["gorillo_watermellondrillo"] = "Rare",
		["trippi_troppi_troppa_trippa"] = "Rare",
		["raccooni_watermelunni"] = "Epic",
		["ta_ta_ta_ta_sahur"] = "Epic",
		["glorbo_frutodrillo"] = "Epic",
		["yoni"] = "Legendary",
		["frigo_camello"] = "Legendary",
		["orangutini_ananassini"] = "Legendary",
		["ballerino_lololo"] = "Legendary",
		["svinina_bombobardino"] = "Mythic",
		["frulli_frula"] = "Mythic",
		["tracoducotulu_delapeladustuz"] = "Mythic",
		["cavallo_virtuoso"] = "Secret",
		["rhino_toasterino"] = "Secret",
		["te_te_te_te_sahur"] = "Secret",
		["ti_ti_ti_sahur"] = "Secret",
		["mateo"] = "Secret",
		["ganganzelli_trulala"] = "Divine",
		["orcalero_orcala"] = "Divine",
		["lerulerulerule"] = "Divine",
		["burbaloni_luliloli"] = "Cosmic",
		["torrtuginni_dragonfrutinni"] = "Cosmic",
		["los_tralaleritos"] = "Cosmic",
		["dojonini_assassini"] = "Admin",
		["magiani_tankiani"] = "Admin",
		["i2perfectini_foxinini"] = "Admin",
		["tralalero_tralala"] = "Eternal",
		["trulimero_trulicina"] = "Eternal",
		["chicleteira_bicicleteira"] = "Eternal",
		["pot_hotspot"] = "Eternal",
		["los_crocodillitos"] = "Eternal",
		["agarrini_lapalini"] = "SPECIAL",
		["ding_sahur"] = "SPECIAL",
		["pipi_potato"] = "SPECIAL",
		["spaghetti_tualetti"] = "SPECIAL",
		["toc_toc_sahur"] = "SPECIAL",
		["cathinni_sushinni"] = "SPECIAL",
		["ferro_sahur"] = "SPECIAL",
		["la_vacca_saturno_saturnita"] = "SPECIAL",
		["graipus_medus"] = "SPECIAL",
		["67"] = "SPECIAL",
		["meowl"] = "SPECIAL",
		["rang_ring_reng"] = "SPECIAL",
		["tigrrullini_watermellini"] = "SPECIAL",
		["dragoni_cannelloni"] = "SPECIAL",
		["boneca_ambalabu"] = "SPECIAL",
		["gorgonzilla"] = "SPECIAL",
		["las_vaquitas_saturnitas"] = "SPECIAL",
		["spioniro_golubiro"] = "SPECIAL",
		["salamino_penguino"] = "SPECIAL",
		["karkirkur"] = "SPECIAL",
		["chachechi"] = "SPECIAL",
		["luminous_yoni"] = "SPECIAL",
		["strawberry_elephant"] = "SPECIAL",
		["to_to_to_sahur"] = "CYBER",
		["bisonte_giuppitere_giuppitercito"] = "CYBER",
		["angelzini_bananini"] = "Angelic",
		["angela_larila"] = "Angelic",
		["angel_bisonte_giuppitere"] = "Angelic",
		["angel_job_job_sahur"] = "Angelic",
		["angelinni_octossini"] = "Angelic",
		["devilcino_assassino"] = "Demonic",
		["devupat_kepat_prekupat"] = "Demonic",
		["diavolero_tralala"] = "Demonic",
		["malamevil"] = "Demonic",
		["devilivion"] = "Demonic",
		["spaceshipini_tortini"] = "Alien",
		["astro_bandito"] = "Alien",
		["chachelien"] = "Alien",
		["aliensini_octosini"] = "Alien",
		["la_vacca_galactica"] = "Alien",
		["glorbo_inkdrillo"] = "Ink",
		["inknina_bombobardino"] = "Ink",
		["ink_din_din_dun"] = "Ink",
		["cavallo_inkuoso"] = "Ink",
		["la_vacca_singolarita"] = "Ink",
		["tic_tac_tok_afammocc"] = "LAW",
		["elefantino_frigorifero"] = "LAW",
		["squalo_cavallo"] = "GOD",
		["jestellerino_lololo"] = "Circus",
		["cocofanto_magicano"] = "Circus",
		["clownteo"] = "Circus",
		["tic_toc_circhur"] = "Circus",
		["dragoni_circusoni"] = "Circus",
		["hopster_foottera"] = "Easter",
		["cocosino_bunnyno"] = "Easter",
		["karkirkurster"] = "Easter",
		["bulu_bulu_bulu_bulben"] = "Easter",
		["buni"] = "Easter",
		["malame_easterale"] = "Easter",
		["trikitrakatelas"] = "Legendary",
		["francesco"] = "Mythic",
		["nuclerucci"] = "Divine",
		["quesadilla_crocodila"] = "Secret",
		["pingvinator_termoregullator"] = "Cosmic",
		["antonio"] = "Eternal",
		["pi_pi_pie_pie"] = "Eternal",
		["gigalitraktos_spidorobos"] = "SPECIAL",
		["bulbito_bandito_traktorito"] = "SPECIAL",
		["wizard_cat"] = "SPECIAL",
		["bomboclat_crocolat"] = "SPECIAL",
		["wormrot"] = "SPECIAL",
		["ketupat_corrupt"] = "1x1x1x1",
		["banananito_hackerito"] = "1x1x1x1",
		["salamino_exploito404"] = "1x1x1x1",
		["mellondrillo404"] = "1x1x1x1",
		["pipi_poppa_pippo_peppe"] = "Cloud",
		["bombirdini_tortini"] = "Cloud",
		["orangutini_wingassini"] = "Cloud",
		["ganganzelli_chikala"] = "Cloud",
		["bombardino_crocodilo"] = "Cloud",
	},

	MutationData = {
		["NORMAL"] = 1,
		["CANDY"] = 1.5,
		["GOLD"] = 2,
		["DIAMOND"] = 2.5,
		["VOID"] = 3,
	},

	BrainrotCashData = {
		["cacto_hipopotamo"] = 5,
		["cocofanto_elefanto"] = 10,
		["ballerina_cappuccina"] = 15,
		["gangster_foottera"] = 40,
		["udin_din_din_dun"] = 70,
		["brr_brr_patapim"] = 100,
		["capuccino_assassino"] = 175,
		["gorillo_watermellondrillo"] = 250,
		["trippi_troppi_troppa_trippa"] = 325,
		["raccooni_watermelunni"] = 500,
		["ta_ta_ta_ta_sahur"] = 700,
		["glorbo_frutodrillo"] = 900,
		["yoni"] = 10000,
		["frigo_camello"] = 1250,
		["orangutini_ananassini"] = 1600,
		["ballerino_lololo"] = 2000,
		["svinina_bombobardino"] = 2750,
		["frulli_frula"] = 3500,
		["tracoducotulu_delapeladustuz"] = 4250,
		["cavallo_virtuoso"] = 15000,
		["rhino_toasterino"] = 18500,
		["te_te_te_te_sahur"] = 22500,
		["ti_ti_ti_sahur"] = 30000,
		["mateo"] = 30000,
		["ganganzelli_trulala"] = 6500,
		["orcalero_orcala"] = 9000,
		["lerulerulerule"] = 11500,
		["burbaloni_luliloli"] = 35000,
		["torrtuginni_dragonfrutinni"] = 37500,
		["los_tralaleritos"] = 45000,
		["dojonini_assassini"] = 1000000,
		["magiani_tankiani"] = 1000000,
		["i2perfectini_foxinini"] = 1000000,
		["tralalero_tralala"] = 1000000,
		["trulimero_trulicina"] = 125000,
		["chicleteira_bicicleteira"] = 125000,
		["pot_hotspot"] = 70000,
		["los_crocodillitos"] = 95000,
		["agarrini_lapalini"] = 400000,
		["ding_sahur"] = 500000,
		["pipi_potato"] = 425000,
		["spaghetti_tualetti"] = 500000,
		["toc_toc_sahur"] = 2000000,
		["cathinni_sushinni"] = 500000,
		["ferro_sahur"] = 1000000,
		["la_vacca_saturno_saturnita"] = 225000,
		["graipus_medus"] = 600000,
		["67"] = 4000000,
		["meowl"] = 4500000,
		["rang_ring_reng"] = 5000000,
		["tigrrullini_watermellini"] = 750000,
		["dragoni_cannelloni"] = 1000000,
		["boneca_ambalabu"] = 1250000,
		["gorgonzilla"] = 1000000,
		["las_vaquitas_saturnitas"] = 325000,
		["spioniro_golubiro"] = 1750000,
		["salamino_penguino"] = 2250000,
		["karkirkur"] = 3500000,
		["chachechi"] = 5000000,
		["luminous_yoni"] = 3500000,
		["strawberry_elephant"] = 8000000,
		["to_to_to_sahur"] = 1500000,
		["bisonte_giuppitere_giuppitercito"] = 1750000,
		["angelzini_bananini"] = 500000,
		["angela_larila"] = 750000,
		["angel_bisonte_giuppitere"] = 1000000,
		["angel_job_job_sahur"] = 1750000,
		["angelinni_octossini"] = 2500000,
		["devilcino_assassino"] = 500000,
		["devupat_kepat_prekupat"] = 750000,
		["diavolero_tralala"] = 1000000,
		["malamevil"] = 1750000,
		["devilivion"] = 2500000,
		["spaceshipini_tortini"] = 550000,
		["astro_bandito"] = 825000,
		["chachelien"] = 1100000,
		["aliensini_octosini"] = 1925000,
		["la_vacca_galactica"] = 2750000,
		["glorbo_inkdrillo"] = 550000,
		["inknina_bombobardino"] = 825000,
		["ink_din_din_dun"] = 1100000,
		["cavallo_inkuoso"] = 1925000,
		["la_vacca_singolarita"] = 2750000,
		["tic_tac_tok_afammocc"] = 2000000,
		["elefantino_frigorifero"] = 2250000,
		["squalo_cavallo"] = 2000000,
		["jestellerino_lololo"] = 550000,
		["cocofanto_magicano"] = 825000,
		["clownteo"] = 1100000,
		["tic_toc_circhur"] = 1925000,
		["dragoni_circusoni"] = 2750000,
		["hopster_foottera"] = 575000,
		["cocosino_bunnyno"] = 875000,
		["karkirkurster"] = 1150000,
		["bulu_bulu_bulu_bulben"] = 750000,
		["buni"] = 2000000,
		["malame_easterale"] = 3000000,
		["trikitrakatelas"] = 1000,
		["francesco"] = 4750,
		["nuclerucci"] = 13000,
		["quesadilla_crocodila"] = 25000,
		["pingvinator_termoregullator"] = 50000,
		["antonio"] = 137500,
		["pi_pi_pie_pie"] = 175000,
		["gigalitraktos_spidorobos"] = 1500000,
		["bulbito_bandito_traktorito"] = 2000000,
		["wizard_cat"] = 3000000,
		["bomboclat_crocolat"] = 3500000,
		["wormrot"] = 5000000,
		["ketupat_corrupt"] = 575000,
		["banananito_hackerito"] = 875000,
		["salamino_exploito404"] = 1150000,
		["mellondrillo404"] = 2000000,
		["pipi_poppa_pippo_peppe"] = 575000,
		["bombirdini_tortini"] = 875000,
		["orangutini_wingassini"] = 1150000,
		["ganganzelli_chikala"] = 2000000,
		["bombardino_crocodilo"] = 3000000,
	},

	SpeedData = {
		{18, 1.165},
		{50, 1.17},
		{100, 1.175},
		{125, 1.1775},
		{150, 1.18},
		{175, 1.1825},
		{200, 1.185},
		{215, 1.19},
		{230, 1.195}
	},

	ContainerData = {
		["0"] = 5000000,
		["1"] = 10000000,
		["2"] = 20000000,
		["3"] = 40000000,
		["4"] = 80000000,
		["5"] = 160000000,
		["6"] = 350000000,
		["7"] = 750000000,
		["8"] = 1750000000,
		["9"] = 4000000000,
		["10"] = 10000000000,
		["11"] = 25000000000,
		["12"] = 75000000000,
		["13"] = 225000000000,
		["14"] = 675000000000,
		["15"] = 2000000000000,
		["16"] = 7500000000000,
		["17"] = 22500000000000,
		["18"] = 100000000000000,
		["19"] = 500000000000000,
		["20"] = math.huge
	},

	LuckyBlockData = {
		["default"] = 0,
		["fairy_luckyblock"] = 250000,
		["freezy_luckyblock"] = 10000000,
		["lava_luckyblock"] = 400000000,
		["gliched_luckyblock"] = 15000000000,
		["void_luckyblock"] = 500000000000,
		["cyborg_luckyblock"] = 25000000000000,
		["divine_luckyblock"] = 550000000000000,
		["inferno_luckyblock"] = 4e16,
		["colossus _luckyblock"] = 2.5e18,
		["twoface _luckyblock"] = 1e20,
		["spirit_luckyblock"] = 1e23,
		["mogging_luckyblock"] = 1e25,
		["luminous_block"] = 5e26,
		["strawberry_luckyblock"] = 5e28,
	},

	RebirthData = {
		["1"] = 250000,
		["2"] = 10000000,
		["3"] = 400000000,
		["4"] = 16000000000,
		["5"] = 625000000000,
		["6"] = 25000000000000,
		["7"] = 1000000000000000,
		["8"] = 4e16,
		["9"] = 2.75e18,
		["10"] = 7.5e19,
		["11"] = 1.5e21
	},

	RarityData = {
		["Common"] = 1,
		["Uncommon"] = 2,
		["Rare"] = 4,
		["Epic"] = 8,
		["Legendary"] = 16,
		["Mythic"] = 32,
		["Secret"] = 64,
		["Divine"] = 128,
		["Cosmic"] = 256,
		["Admin"] = 512,
		["SPECIAL"] = 1024,
		["Eternal"] = 2048,
		["CYBER"] = 4096,
		["Angelic"] = 8192,
		["Demonic"] = 16384,
		["Alien"] = 32768,
		["Ink"] = 65536,
		["LAW"] = 131072,
		["GOD"] = 262144,
		["Circus"] = 524288,
		["Easter"] = 1048576,
		["Easter Secret"] = 2097152,
		["1x1x1x1"] = 4194304,
		["Cloud"] = 8388608,
	},

	RarityList = {},
	RarityDisplay = {},

	BrainrotList = {},
	BrainrotDisplay = {},

	MutationList = {},
	MutationDisplay = {},

	RaritySellSelect = {},
	BrainrotKeepSelect = {},
	MutationKeepSelect = {},

	RarityFuseSelect = {},
	BrainrotFuseSelect = {},
	MutationFuseSelect = {},

	RaritySendSelect = {},
	BrainrotSendSelect = {},
	MutationSendSelect = {},

	CooldownList = {},

	CodeList = {},

	StuckTime = 30
}

type2 = {
	base = nil,
	plot = nil,

	buycontainer = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.ContainerService.RF.BuyContainer,
	buyeventshopitem = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.EventService.RF.BuyEventShopItem,
	buyskin = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.SkinService.RF.BuySkin,
	claim = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.FuserService.RF.Claim,
	collectalleggs = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.EventService.RF.CollectAllEggs,
	fuse = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.FuserService.RF.Fuse,
	open = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.LuckyBlockService.RF.Open,
	placebest = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.ContainerService.RF.PlaceBest,
	putbrainrot = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.FuserService.RF.PutBrainrot,
	rebirth = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.RebirthService.RF.Rebirth,
	redeemcode = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.CodesService.RF.RedeemCode,
	reloadcharacter = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.PlayerService.RF.ReloadCharacter,
	sellallbrainrots = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RF.SellAllBrainrots,
	sellbrainrot = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.InventoryService.RF.SellBrainrot,
	spinwheel = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.SpinWheelService.RF.SpinWheel,
	upgrade = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.UpgradesService.RF.Upgrade,
	upgradebrainrot = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.ContainerService.RF.UpgradeBrainrot
}

type3 = {
	IsFlying = false,
	KeyDown = nil,
	KeyUp = nil,
	Loop = nil,

	Velocity = nil,
	Gyro = nil,

	Connection1 = nil,
	Connection2 = nil
}

Flags = Library.Flags

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

repeat wait(0.3)
	for _, plot in Workspace.Plots:GetChildren() do
		if plot:GetAttribute("Owner") == plr.UserId then
			type2.plot = plot:FindFirstChildWhichIsA("Model")
			break
		end
	end

	for _, base in PlayerGUI.Effects:GetChildren() do
		if base.Name == "SurfaceGui" and base:FindFirstChild("BuyMax") and base.BuyMax:FindFirstChild("Base") then
			if string.find(base.BuyMax.Base.Text, "/") then
				type2.base = base.BuyMax.Base
				break
			end
		end
	end
until type2.plot and type2.base

for _, brainrot in plr.Backpack:GetChildren() do
	if brainrot:GetAttribute("BrainrotLevel") and brainrot:GetAttribute("BrainrotMutation") and brainrot:GetAttribute("BrainrotType") then
		AddCooldown(brainrot:GetAttribute("EntityId"))
	end
end

for rarity_name, rarity_index in type1.RarityData do
	if rarity_name and rarity_index then
		table.insert(type1.RarityList, {
			Name = rarity_name,
			Index = rarity_index,
			Display = rarity_name
		})
	end
end

table.sort(type1.RarityList, function(a, b)
	return (a.Index or 0) > (b.Index or 0)
end)

for _, rarity in type1.RarityList do
	table.insert(type1.RarityDisplay, rarity.Display)
end

for brainrot_name, brainrot_rarity in type1.BrainrotNameData do
	if brainrot_name and brainrot_rarity then
		table.insert(type1.BrainrotList, {
			Name = brainrot_name,
			Rarity = brainrot_rarity,
			Display = string.format("%s [%s]", brainrot_name, brainrot_rarity)
		})
	end
end

table.sort(type1.BrainrotList, function(a, b)
	return (type1.RarityData[a.Rarity] or 0) > (type1.RarityData[b.Rarity] or 0)
end)

for _, brainrot in type1.BrainrotList do
	table.insert(type1.BrainrotDisplay, brainrot.Display)
end

for mutation_name, mutation_index in type1.MutationData do
	if mutation_name and mutation_index then
		table.insert(type1.MutationList, {
			Name = mutation_name,
			Index = mutation_index,
			Display = string.format("%s [%s]", mutation_name, mutation_index)
		})
	end
end

table.sort(type1.MutationList, function(a, b)
	return (a.Index or 0) > (b.Index or 0)
end)

for _, mutation in type1.MutationList do
	table.insert(type1.MutationDisplay, mutation.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function type2.FarmBrainrot()
	if HasCooldown("Auto Farm Brainrot") then return false end

	local a = Workspace.RunningModels:FindFirstChild(plr.UserId) and Workspace.RunningModels[plr.UserId]:FindFirstChild("HumanoidRootPart")

	if a then
		for _, b in Workspace.CollectZones:GetChildren() do
			if table.find({"EASTER", "X1", "FLAPPY", "CIRCUS", "ALIEN", "INK", "DEVIL", "ZEUS"}, b.Name) then
				a.CFrame = b.CFrame * CFrame.new(0, -13, 0)
				wait(0.3)
				return true
			elseif b.Name == "base" .. Flags["Select Base to Farm"] then
				a.CFrame = b.CFrame * CFrame.new(0, -13, 0)
				wait(0.3)
				return true
			end
		end
	else
		if char:GetAttribute("Morphed") then
			TP(Workspace.SpawnLocation.CFrame)
			wait(0.3)
			return true
		elseif plr:GetAttribute("InSpawn") then
			TP(Workspace.CollectZones.base1.CFrame)
			wait(0.3)
			return true
		end
	end

	AddCooldown("Auto Farm Brainrot", 0.003)
	return false
end

function type2.SellBrainrot()
	if HasCooldown("Auto Sell Brainrot") then return false end

	local a = GetBrainrotSell()

	if a then
		type2.sellbrainrot:InvokeServer(a:GetAttribute("EntityId"))
		wait()
		return true
	end

	AddCooldown("Auto Sell Brainrot", 3)
	return false
end

function type2.SellBrainrotWhenFull()
	if HasCooldown("Auto Sell Brainrot when Full") then return false end

	if #plr.Backpack:GetChildren() >= 190 then
		type2.sellallbrainrots:InvokeServer()
		wait()
		return true
	end

	AddCooldown("Auto Sell Brainrot when Full", 3)
	return false
end

function type2.FuseBrainrot()
	if HasCooldown("Auto Fuse Brainrot") then return false end

	local a = Workspace.FuseMachine.Attachment.BillboardGui.Frame.Status
	local b = PlayerGUI.Windows.Fuse.RequiredItems
	local c = 0

	for _, d in b:GetChildren() do
		if d.Name == "BrainrotTemplate" then
			c = c + 1
		end
	end

	if a and b then
		if a.Visible and string.find(a.Text, "%d") then return false end

		if a.Text == "Ready" then
			type2.claim:InvokeServer()
			wait()
			return true
		elseif c == 4 then
			type2.fuse:InvokeServer()
			wait()
			return true
		else
			local e = GetBrainrotFuse()

			if e then
				type2.putbrainrot:InvokeServer(e:GetAttribute("EntityId"))
				wait()
				return true
			end
		end
	end

	AddCooldown("Auto Fuse Brainrot", 3)
	return false
end

function type2.BuyBunnyLuckyBlock()
	if HasCooldown("Auto Buy Bunny Lucky Block") then return false end

	local a = tonumber(PlayerGUI.Windows.Event.Frame.Frame.Windows.Shop.BB_TOWER.EasterEggs.EasterEggs.Text)

	if a and a >= 225 then
		type2.buyeventshopitem:InvokeServer("Buy1")
		wait()
		return true
	end

	AddCooldown("Auto Buy Bunny Lucky Block", 3)
	return false
end

function type2.LuminousSpin()
	if HasCooldown("Auto Luminous Spin") then return false end

	local a = tonumber(PlayerGUI.Windows.LuckyWheel.Frame.TicketsFrame.AmountLabel.Text)

	if a and a >= 10 then
		type2.spinwheel:InvokeServer()
		wait()
		return true
	end

	AddCooldown("Auto Luminous Spin", 3)
	return false
end

function type2.CircusEvent()
	if HasCooldown("Auto Circus Event", 0.003) then return false end 

	local a = PlayerGUI.HUD.CannonBar
	local b = a and a.TargetContainer.MovingTarget
	local c = a and a.ConsoleBTN.BTN 

	if a and a.Visible then
		b.Size = UDim2.new(0, 10, 0, 1)
		wait()
		ClickGui(c)
		return true
	end

	AddCooldown("Auto Circus Event", 0.003)
	return false
end

function type2.UpgradeBrainrot()
	if HasCooldown("Auto Upgrade Brainrot") then return false end

	for _, a in type2.plot.Containers:GetChildren() do
		local b = a:FindFirstChildWhichIsA("Model")
		local c = b and b:FindFirstChild("InnerModel"):FindFirstChildWhichIsA("Model")

		if c and c:GetAttribute("BrainrotType") and c:GetAttribute("BrainrotLevel") ~= 50 then
			if type1.BrainrotCashData[c:GetAttribute("BrainrotType")] * 1.5 ^ (c:GetAttribute("BrainrotLevel") + 1) <= plr.leaderstats.Cash.Value then
				type2.upgradebrainrot:InvokeServer(a.Name)
				wait()
				return true
			end
		end
	end

	AddCooldown("Auto Upgrade Brainrot", 3)
	return false
end

function type2.UpgradeSpeed()
	if HasCooldown("Auto Upgrade Speed") then return false end

	local a = plr.leaderstats.Speed.Value
	local b = type1.SpeedData[1][2]

	for _, c in type1.SpeedData do
		if c[1] <= a then
			b = c[2]
		else
			break
		end
	end

	if 100 * b ^ (a + 1 - 18) <= plr.leaderstats.Cash.Value then
		wait()
		type2.upgrade:InvokeServer("MovementSpeed", 1)
		wait()
		return true
	end

	AddCooldown("Auto Upgrade Speed", 3)
	return false
end

function type2.UpgradeContainer()
	if HasCooldown("Auto Upgrade Container") then return false end

	local a = type1.ContainerData[string.match(type2.base.Text, "^(%d+)")]

	if a and a <= plr.leaderstats.Cash.Value then
		wait()
		type2.buycontainer:InvokeServer()
		wait()
		return true
	end

	AddCooldown("Auto Upgrade Container", 3)
	return false
end

function type2.UpgradeLuckyBlock()
	if HasCooldown("Auto Upgrade Lucky Block") then return false end

	for a, b in type1.LuckyBlockData do
		local c = type1.LuckyBlockData[plr:GetAttribute("PlayerSkin")]

		if c and b > c and b <= plr.leaderstats.Cash.Value then
			wait()
			type2.buyskin:InvokeServer(a)
			wait()
			return true
		end
	end

	AddCooldown("Auto Upgrade Lucky Block", 3)
	return false
end

function type2.OpenLuckyBlock()
	if HasCooldown("Auto Open Lucky Block") then return false end

	for _, a in type2.plot.Containers:GetChildren() do
		local b = a:FindFirstChildWhichIsA("Model")
		local c = b and b:FindFirstChild("InnerModel"):FindFirstChildWhichIsA("Model")

		if c and c:GetAttribute("EntityId") and c:GetAttribute("LuckyBlockType") then
			type2.open:InvokeServer(c:GetAttribute("EntityId"))
			wait()
			return true
		end
	end

	AddCooldown("Auto Open Lucky Block", 6)
	return false
end

function type2.Rebirth()
	if HasCooldown("Auto Rebirth") then return false end

	local a = type1.RebirthData[PlayerGUI.Windows.Rebirth.Title.Amount.Text + 1]

	if a and a <= plr.leaderstats.Cash.Value then
		wait()
		type2.rebirth:InvokeServer()
		wait()
		return true
	end

	AddCooldown("Auto Rebirth", 3)
	return false
end

function type2.PlaceBest()
	if HasCooldown("Auto Place Best") then return false end

	AddCooldown("Auto Place Best", 9)
	wait()
	type2.placebest:InvokeServer()
	wait()
	return true
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Window = Library:Window({
	Name = "solixhub.com",
	FadeSpeed = 0.35,
	BackgroundIcon = ""
})

Window:Minimize(true)

local KeybindList = Library:KeybindList()
local Watermark = Library:Watermark((MarketplaceService:GetProductInfo(game.PlaceId) and MarketplaceService:GetProductInfo(game.PlaceId).Name) or "I don't know bro")

local Pages = {
	["Farm"] = Window:Page({ Name = "Farm", Columns = 1 }),
	["Misc"] = Window:Page({ Name = "Misc", Columns = 1 }),
	["Webhook"] = Window:Page({ Name = "Webhook", Columns = 1 })
}

Library:CreateSettingsPage(Window, Watermark, KeybindList)

Library:Notification({
	Name = "Solix Hub",
	Description = "The UI automatically hides once executed \nClick the '-' button on the left side of the screen to show the GUI.",
	Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
	Duration = 30
})

local FarmBrainrot_Section = Pages["Farm"]:Section({ Name = "Auto Farm Brainrot", Side = 1 })

FarmBrainrot_Section:Dropdown({
	Name = "Select Base to Farm",
	Flag = "Select Base to Farm",
	Description = "Select a base to farm",
	Items = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"},
	Default = "1",
	Callback = function(value)
		Flags["Select Base to Farm"] = value
	end
})

FarmBrainrot_Section:Toggle({
	Name = "Auto Farm Brainrot",
	Flag = "Auto Farm Brainrot",
	Description = "Automatically farm selected base",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Brainrot"] = value
	end
})

local SellBrainrot_Section = Pages["Farm"]:Section({ Name = "Auto Sell Brainrot", Side = 1 })

SellBrainrot_Section:Dropdown({
	Name = "Select Rarity to Sell",
	Flag = "Select Rarity to Sell",
	Description = "Select rarity to sell",
	Multi = true,
	Items = type1.RarityDisplay,
	Default = nil,
	Callback = function(value)
		type1.RaritySellSelect = {}
		Flags["Select Rarity to Sell"] = value

		for _, a in value do
			table.insert(type1.RaritySellSelect, a)
		end
	end
})

SellBrainrot_Section:Dropdown({
	Name = "Select Brainrot to Keep",
	Flag = "Select Brainrot to Keep",
	Description = "Select brainrot to keep",
	Multi = true,
	Items = type1.BrainrotDisplay,
	Default = nil,
	Callback = function(value)
		type1.BrainrotKeepSelect = {}
		Flags["Select Brainrot to Keep"] = value

		for _, a in value do
			local b = a:match("^(.-) %[[^%]]+%]$")

			if b then
				table.insert(type1.BrainrotKeepSelect, b)
			end
		end
	end
})

SellBrainrot_Section:Dropdown({
	Name = "Select Mutation to Keep",
	Flag = "Select Mutation to Keep",
	Description = "Select mutation to keep",
	Multi = true,
	Items = type1.MutationDisplay,
	Default = nil,
	Callback = function(value)
		type1.MutationKeepSelect = {}
		Flags["Select Mutation to Keep"] = value

		for _, a in value do
			local b = a:match("^(.-) %[[^%]]+%]$")

			if b then
				table.insert(type1.MutationKeepSelect, b)
			end
		end
	end
})

SellBrainrot_Section:Toggle({
	Name = "Auto Sell Brainrot",
	Flag = "Auto Sell Brainrot",
	Description = "Automatically sell selected rarity",
	Default = false,
	Callback = function(value)
		Flags["Auto Sell Brainrot"] = value
	end
})

SellBrainrot_Section:Toggle({
	Name = "Auto Sell Brainrot when Full",
	Flag = "Auto Sell Brainrot when Full",
	Description = "Automatically sell brainrot when full",
	Default = false,
	Callback = function(value)
		Flags["Auto Sell Brainrot when Full"] = value
	end
})

local FuseBrainrot_Section = Pages["Farm"]:Section({ Name = "Auto Fuse Brainrot", Side = 1 })

FuseBrainrot_Section:Dropdown({
	Name = "Select Rarity to Fuse",
	Flag = "Select Rarity to Fuse",
	Description = "Select rarity to fuse",
	Multi = true,
	Items = type1.RarityDisplay,
	Default = nil,
	Callback = function(value)
		type1.RarityFuseSelect = {}
		Flags["Select Rarity to Fuse"] = value

		for _, a in value do
			table.insert(type1.RarityFuseSelect, a)
		end
	end
})

FuseBrainrot_Section:Dropdown({
	Name = "Select Brainrot to Fuse",
	Flag = "Select Brainrot to Fuse",
	Description = "Select brainrot to fuse",
	Multi = true,
	Items = type1.BrainrotDisplay,
	Default = nil,
	Callback = function(value)
		type1.BrainrotFuseSelect = {}
		Flags["Select Brainrot to Fuse"] = value

		for _, a in value do
			local b = a:match("^(.-) %[[^%]]+%]$")

			if b then
				table.insert(type1.BrainrotFuseSelect, b)
			end
		end
	end
})

FuseBrainrot_Section:Dropdown({
	Name = "Select Mutation to Fuse",
	Flag = "Select Mutation to Fuse",
	Description = "Select mutation to fuse",
	Multi = true,
	Items = type1.MutationDisplay,
	Default = nil,
	Callback = function(value)
		type1.MutationFuseSelect = {}
		Flags["Select Mutation to Fuse"] = value

		for _, a in value do
			local b = a:match("^(.-) %[[^%]]+%]$")

			if b then
				table.insert(type1.MutationFuseSelect, b)
			end
		end
	end
})

FuseBrainrot_Section:Toggle({
	Name = "Auto Fuse Brainrot",
	Flag = "Auto Fuse Brainrot",
	Description = "Automatically fuse selected brainrot",
	Default = false,
	Callback = function(value)
		Flags["Auto Fuse Brainrot"] = value
	end
})

local Upgrade_Section = Pages["Farm"]:Section({ Name = "Auto Upgrade", Side = 1 })

Upgrade_Section:Toggle({
	Name = "Auto Upgrade Brainrot",
	Flag = "Auto Upgrade Brainrot",
	Description = "Automatically upgrade brainrot when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Upgrade Brainrot"] = value
	end
})

Upgrade_Section:Toggle({
	Name = "Auto Upgrade Speed",
	Flag = "Auto Upgrade Speed",
	Description = "Automatically upgrade speed when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Upgrade Speed"] = value
	end
})

Upgrade_Section:Toggle({
	Name = "Auto Upgrade Container",
	Flag = "Auto Upgrade Container",
	Description = "Automatically upgrade container when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Upgrade Container"] = value
	end
})

Upgrade_Section:Toggle({
	Name = "Auto Upgrade Lucky Block",
	Flag = "Auto Upgrade Lucky Block",
	Description = "Automatically upgrade lucky block when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Upgrade Lucky Block"] = value
	end
})

Upgrade_Section:Toggle({
	Name = "Auto Rebirth",
	Flag = "Auto Rebirth",
	Description = "Automatically rebirth when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Rebirth"] = value
	end
})

local EasterEgg_Section = Pages["Farm"]:Section({ Name = "Easter Egg", Side = 1 })

EasterEgg_Section:Toggle({
	Name = "Auto Buy Bunny Lucky Block",
	Flag = "Auto Buy Bunny Lucky Block",
	Description = "Automatically buy bunny lucky block when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Buy Bunny Lucky Block"] = value
	end
})

EasterEgg_Section:Toggle({
	Name = "Auto Open Lucky Block",
	Flag = "Auto Open Lucky Block",
	Description = "Automatically open lucky block when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Open Lucky Block"] = value
	end
})

EasterEgg_Section:Toggle({
	Name = "Auto Collect Egg",
	Flag = "Auto Collect Egg",
	Description = "Automatically collect egg when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Collect Egg"] = value
	end
})

local Event_Section = Pages["Farm"]:Section({ Name = "Event", Side = 1 })

Event_Section:Toggle({
	Name = "Auto Luminous Spin",
	Flag = "Auto Luminous Spin",
	Description = "Automatically luminous spin when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Luminous Spin"] = value
	end
})

Event_Section:Toggle({
	Name = "Auto Circus Event",
	Flag = "Auto Circus Event",
	Description = "Automatically circus event when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Circus Event"] = value
	end
})

local Misc_Section = Pages["Farm"]:Section({ Name = "Misc", Side = 1 })

Misc_Section:Toggle({
	Name = "Auto Place Best",
	Flag = "Auto Place Best",
	Description = "Automatically place best every 9 seconds",
	Default = false,
	Callback = function(value)
		Flags["Auto Place Best"] = value
	end
})

Misc_Section:Toggle({
	Name = "Auto Reconnect",
	Flag = "Auto Reconnect",
	Description = "Automatically reconnect every 15 minutes",
	Default = true,
	Callback = function(value)
		PlayerGUI.HUD.AutoReconnect.AutoReconnectScript.Disabled = value
		PlayerGUI.HUD_TEST.AutoReconnect.AutoReconnectScript.Disabled = value
	end
})

Misc_Section:Toggle({
	Name = "Anti Stuck",
	Flag = "Anti Stuck",
	Description = "Reset character if stuck for 30 seconds",
	Default = false,
	Callback = function(value)
		Flags["Anti Stuck"] = value

		if not value then
			type1.StuckTime = 30
		end 
	end
})

Misc_Section:Button():Add("Redeem All Code", function()
	local a, b = HttpGet("https://progameguides.com/roblox/be-a-lucky-block-codes/")

	if not a then
		Library:Notification({
			Name = "Solix Hub",
			Description = "Unable to get HTML from progameguides.",
			Color = Color3.fromRGB(255, 85, 85),
			Duration = 10
		})
		return
	end

	Library:Notification({
		Name = "Solix Hub",
		Description = "Data fetched from progameguides.com. Codes will be redeemed automatically.",
		Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Duration = 10
	})

	for c, d in b:gmatch('<span class="code%-text">(.-)</span>.-<span class="description%-text">(.-)</span>') do
		c = c:gsub("%s+", "")
		d = d:gsub("<.->", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
		table.insert(type1.CodeList, c)
	end

	for _, e in type1.CodeList do
		type2.redeemcode:InvokeServer(e)
		wait(0.3)
	end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Fly_Section = Pages["Misc"]:Section({ Name = "Fly Settings", Side = 1 })

Fly_Section:Dropdown({
	Name = "Fly Method",
	Flag = "Fly Method",
	Description = "Select method to fly",
	Items = {"Normal", "Vehicle"},
	Default = "Normal",
	Callback = function(value)
		Flags["Fly Method"] = value

		if Flags["Fly Toggle"] then
			StopFly()
			if value == "Normal" then
				FlyNormal()
			elseif value == "Vehicle" then
				FlyVehicle()
			end
		end
	end
})

Fly_Section:Toggle({
	Name = "Fly Toggle",
	Flag = "Fly Toggle",
	Description = "Can fly when turned on",
	Default = false,
	Callback = function(value)
		Flags["Fly Toggle"] = value

		if value then
			if Flags["Fly Method"] == "Normal" then
				FlyNormal()
			elseif Flags["Fly Method"] == "Vehicle" then
				FlyVehicle()
			end
		else
			StopFly()
		end
	end
})

Fly_Section:Slider({
	Name = "Fly Speed",
	Flag = "Fly Speed",
	Description = "Adjust fly speed",
	Default = 30,
	Min = 10,
	Max = 300,
	Decimals = 1,
	Suffix = "",
	Callback = function(value)
		Flags["Fly Speed"] = value
	end
})

local Player_Section = Pages["Misc"]:Section({ Name = "Player Settings", Side = 1 })

Player_Section:Toggle({
	Name = "Infinite Jump",
	Flag = "Infinite Jump",
	Tooltip = nil,
	Description = "Jump without cooldown",
	Default = false,
	Callback = function(value)
		Flags["Infinite Jump"] = value  

		if value then
			getgenv()["Infinite Jump"] = UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input, processed)
				if not processed and input.KeyCode == Enum.KeyCode.Space then
					if IsActive(char) then
						char.Humanoid:ChangeState(3)
					end
				end
			end))
		else
			if HasCooldown("Loaded") then
				wait(0.1)
				if getgenv()["Infinite Jump"] then
					getgenv()["Infinite Jump"]:Disconnect()
					getgenv()["Infinite Jump"] = nil
				end
			end
		end
	end
})

Player_Section:Slider({
	Name = "Walk Speed",
	Flag = "Walk Speed",
	Description = "Character walk speed",
	Default = 30,
	Min = 0,
	Max = 300,
	Decimals = 10,
	Suffix = "",
	Callback = function(value)
		if not IsActive(char) then return end

		Flags["Walk Speed"] = value
		char.Humanoid.WalkSpeed = value
	end
})

Player_Section:Slider({
	Name = "Jump Power",
	Flag = "Jump Power",
	Description = "Character jump power",
	Default = 50,
	Min = 0,
	Max = 300,
	Decimals = 10,
	Suffix = "",
	Callback = function(value)
		if not IsActive(char) then return end

		Flags["Jump Power"] = value
		char.Humanoid.JumpPower = value
	end
})

local Server_Section = Pages["Misc"]:Section({ Name = "Server Settings", Side = 1 })

Server_Section:Dropdown({
	Name = "Select Method to Hop",
	Flag = "Select Method to Hop",
	Description = "Server hop population type",
	Items = {"Normal Population", "Low Population"},
	Default = "Normal Population",
	Callback = function(value)
		Flags["Select Method to Hop"] = value
	end
})

local Server_Button = Server_Section:Button()

Server_Button:Add("Hop Server", function()
	Hop(Flags["Select Method to Hop"])
end)

Server_Button:Add("Rejoin Server", function()
	Library:Notification({
		Name = "Info",
		Description = "Rejoining the current server...",
		Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Duration = 5
	})

	local success, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
	end)

	if not success then
		Library:Notification({
			Name = "Error",
			Description = "Failed to rejoin server: " .. tostring(err),
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 8
		})
	end
end)

local FPS_Section = Pages["Misc"]:Section({ Name = "FPS Settings", Side = 1 })

FPS_Section:Toggle({
	Name = "Super Boost FPS",
	Flag = "Super Boost FPS",
	Tooltip = nil,
	Description = "Max FPS boost settings",
	Default = false,
	Callback = function(value)
		Flags["Super Boost FPS"] = value

		if value then
			pcall(function()
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

				local user = UserSettings():GetService("UserGameSettings")
				user.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
				user.GraphicsQualityLevel = 1
			end)

			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			Lighting.Brightness = 1
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0
			Lighting.Ambient = Color3.fromRGB(170, 170, 170)
			Lighting.OutdoorAmbient = Color3.fromRGB(160, 160, 160)

			local ColorCorrection = Lighting:FindFirstChild("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
			ColorCorrection.Name = "ColorCorrectionEffect"
			ColorCorrection.Brightness = -0.05
			ColorCorrection.Contrast = 0.1
			ColorCorrection.Saturation = -0.1
			ColorCorrection.Enabled = true
			ColorCorrection.Parent = Lighting

			local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
			if Atmosphere then
				Atmosphere.Density = 0.05
				Atmosphere.Haze = 0.2
				Atmosphere.Glare = 0
			end

			pcall(function()
				Lighting.Technology = Enum.Technology.Compatibility
			end)

			for _, effect in Lighting:GetChildren() do
				if effect:IsA("PostEffect") or effect:IsA("Sky") or effect:IsA("Atmosphere") then
					pcall(function()
						effect.Parent = nil
					end)
				end
			end

			pcall(function()
				Workspace.CurrentCamera.FieldOfView = 70
			end)

			pcall(function()
				Workspace.Terrain.Decoration = false
				Workspace.Terrain.WaterWaveSize = 0
				Workspace.Terrain.WaterWaveSpeed = 0
				Workspace.Terrain.WaterReflectance = 0
				Workspace.Terrain.WaterTransparency = 1
			end)

			pcall(function()
				if Workspace:FindFirstChild("StreamingEnabled") then
					Workspace.StreamingEnabled = true
					Workspace.StreamingMinRadius = 32
					Workspace.StreamingTargetRadius = 64
				end
			end)

			for _, v in Workspace:GetDescendants() do
				pcall(OptimizeObject, v)
			end

			local VIRTUALIZE622 = LPH_NO_VIRTUALIZE(function(v)
				pcall(OptimizeObject, v)
			end)

			InsertConnections(Workspace.DescendantAdded:Connect(VIRTUALIZE622))

			InsertTasks(spawn(function()
				while Flags["Super Boost FPS"] do
					pcall(function()
						collectgarbage("collect")
					end)
					wait(10)
				end
			end))

			pcall(function()
				if char and char:FindFirstChild("Animate") then
					char.Animate.Disabled = true
				end
			end)
		else
			pcall(function()
				settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic

				local user = UserSettings():GetService("UserGameSettings")
				user.SavedQualityLevel = Enum.SavedQualitySetting.Automatic
			end)
		end
	end
})

FPS_Section:Toggle({
	Name = "Black Screen",
	Flag = "Black Screen",
	Tooltip = nil,
	Description = "Enable black screen overlay",
	Default = false,
	Callback = function(value)

		if value then
			BlackScreen = Instances:Create("ScreenGui", {
				Name = "\0",
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				DisplayOrder = -1,
				Enabled = true,
				Parent = PlayerGUI
			})

			Frame = Instances:Create("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Parent = BlackScreen.Instance
			})

			local Theme = {
				Element = Color3.fromRGB(36, 32, 39),
				Border = Color3.fromRGB(41, 37, 45),
				Text = Color3.fromRGB(255, 255, 255)
			}

			Button = Instances:Create("TextButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, getgenv().relix and 150 or 220, 0, 45),
				BackgroundColor3 = Theme.Element,
				FontFace = Font,
				Text = "Toggle Black Screen",
				TextColor3 = Theme.Text,
				TextSize = getgenv().relix and 13 or 15,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				TextTransparency = 1,
				Parent = BlackScreen.Instance
			})

			Instances:Create("UICorner", {
				CornerRadius = UDim.new(0, 5),
				Parent = Button.Instance
			})

			Instances:Create("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 216, 216))
				}),
				Parent = Button.Instance
			})

			ButtonStroke = Instances:Create("UIStroke", {
				Color = Theme.Border,
				Thickness = 1,
				Transparency = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = Button.Instance
			})

			Button:MakeDraggable()

			InsertConnections(Button:Connect("MouseEnter", function()
				Button:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = getgenv().relix and UDim2.new(0, 160, 0, 48) or UDim2.new(0, 230, 0, 48)})
			end))

			InsertConnections(Button:Connect("MouseLeave", function()
				Button:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = getgenv().relix and UDim2.new(0, 150, 0, 45) or UDim2.new(0, 220, 0, 45)})
			end))

			InsertConnections(Button:Connect("MouseButton1Down", function()
				Button:Tween(TweenInfo.new(0.08), {Size = getgenv().relix and UDim2.new(0, 140, 0, 42) or UDim2.new(0, 210, 0, 42)})
			end))

			InsertConnections(Button:Connect("MouseButton1Up", function()
				Button:Tween(TweenInfo.new(0.08), {Size = getgenv().relix and UDim2.new(0, 150, 0, 45) or UDim2.new(0, 220, 0, 45)})
			end))

			InsertConnections(Button:Connect("MouseButton1Click", function()
				Frame.Instance.Visible = not Frame.Instance.Visible
				RunService:Set3dRenderingEnabled(not Frame.Instance.Visible)
			end))

			Button:Tween(TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = getgenv().relix and UDim2.new(0, 150, 0, 45) or UDim2.new(0, 220, 0, 45), BackgroundTransparency = 0, TextTransparency = 0})

			spawn(function()
				wait(0.3)
				ButtonStroke:Tween(TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
			end)
		else
			if HasCooldown("Loaded") then
				wait(0.1)
				BlackScreen:Clean()
				RunService:Set3dRenderingEnabled(true)			
			end
		end
	end
})

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Webhook_Section = {}

for _, webhook in {"Info", "Brainrot"} do
	Webhook_Section[webhook] = Pages["Webhook"]:Section({ Name = "Auto Send Webhook [" .. webhook .. "]", Side = 1 })

	if webhook == "Brainrot" then
		Webhook_Section[webhook]:Dropdown({
			Name = "Select Rarity to Send",
			Flag = "Select Rarity to Send",
			Description = "Select rarity to send",
			Multi = true,
			Items = type1.RarityDisplay,
			Default = nil,
			Callback = function(value)
				type1.RaritySendSelect = {}
				Flags["Select Rarity to Send"] = value

				for _, a in value do
					table.insert(type1.RaritySendSelect, a)
				end
			end
		})

		Webhook_Section[webhook]:Dropdown({
			Name = "Select Brainrot to Send",
			Flag = "Select Brainrot to Send",
			Description = "Select brainrot to send",
			Multi = true,
			Items = type1.BrainrotDisplay,
			Default = nil,
			Callback = function(value)
				type1.BrainrotWebhookSelect = {}
				Flags["Select Brainrot to Send"] = value

				for _, a in value do
					local b = a:match("^(.-) %[[^%]]+%]$")

					if b then
						table.insert(type1.BrainrotWebhookSelect, b)
					end
				end
			end
		})

		Webhook_Section[webhook]:Dropdown({
			Name = "Select Mutation to Send",
			Flag = "Select Mutation to Send",
			Description = "Select mutation to send",
			Multi = true,
			Items = type1.MutationDisplay,
			Default = nil,
			Callback = function(value)
				type1.MutationWebhookSelect = {}
				Flags["Select Mutation to Send"] = value

				for _, a in value do
					local b = a:match("^(.-) %[[^%]]+%]$")

					if b then
						table.insert(type1.MutationWebhookSelect, b)
					end
				end
			end
		})
	end

	Webhook_Section[webhook]:Textbox({
		Name = "Webhook URL",
		Flag = "Webhook URL " .. webhook,
		Description = "Enter webhook URL",
		Default = "",
		Placeholder = "Paste your webhook URL",
		Callback = function(value)
			Flags["Webhook URL " .. webhook] = value
		end
	})

	Webhook_Section[webhook]:Textbox({
		Name = "Mention Option",
		Flag = "Mention Option " .. webhook,
		Description = "Discord mention option",
		Default = "",
		Placeholder = "e.g. @everyone, @here",
		Callback = function(value)
			Flags["Mention Option " .. webhook] = value
		end
	})

	Webhook_Section[webhook]:Toggle({
		Name = "Auto Send Webhook",
		Flag = "Auto Send Webhook " .. webhook,
		Description = "Automatically send a webhook",
		Default = false,
		Callback = function(value)
			Flags["Auto Send Webhook " .. webhook] = value
		end
	})

	Webhook_Section[webhook]:Button():Add("Test Webhook", function()

		local webhook_info = webhookUtil.createMessage({
			Url = Flags["Webhook URL " .. webhook],
			username = "solixhub",
			content = "hi chat"
		})

		local a, b = pcall(function() webhook_info:sendMessage() end)

		if a then
			Library:Notification({
				Name = "Webhook",
				Description = "Webhook sent successfully!",
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				Duration = 5
			})
		else
			Library:Notification({
				Name = "Webhook",
				Description = "Failed to send webhook: " .. tostring(b),
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				Duration = 5
			})
		end
	end)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

InsertConnections(RunService.Heartbeat:Connect(function()
	if not Flags["Anti Stuck"] then return end

	type1.StuckTime = type1.StuckTime - 0.03

	if type1.StuckTime <= 0 then
		if IsActive(char) and not plr:GetAttribute("IsRunning") then
			type2.reloadcharacter:InvokeServer()
			wait()
			type1.StuckTime = 30
		end
	end
end))

local VIRTUALIZE732 = LPH_NO_VIRTUALIZE(function()
	type1.StuckTime = 30
	wait(0.3)
	if not Flags["Auto Send Webhook Info"] then return end
	if HasCooldown("Auto Send Webhook Info") then return end

	AddCooldown("Auto Send Webhook Info", 180)
	SendWebhook("Info", "Stat", "Cash: " .. (PlayerGUI.HUD.LeftContainer.Currency.Currency.Cash.Cash.Text:gsub("%$", "")) .. "\nRebirth: " .. PlayerGUI.Windows.Rebirth.Title.Amount.Text .. "\nContainer:" .. string.match(type2.base.Text, "^(%d+)"))
end)

InsertConnections(plr.leaderstats.Cash:GetPropertyChangedSignal("Value"):Connect(VIRTUALIZE732))

local VIRTUALIZE236 = LPH_NO_VIRTUALIZE(function(a)
	type1.StuckTime = 30
	wait(0.3)
	if not Flags["Auto Send Webhook Brainrot"] then return end
	if not a:GetAttribute("BrainrotType") or HasCooldown(a:GetAttribute("EntityId")) then return end

	local b = a:GetAttribute("BrainrotType")
	local c = nil

	for d, e in pairs(type1.BrainrotRarityData) do
		for _, f in ipairs(e) do
			if f == b then
				c = d
				break
			end
		end
		if c then 
			break
		end
	end

	local g = (#type1.BrainrotSendSelect > 0 and table.find(type1.BrainrotSendSelect, b))
	local h = (#type1.MutationSendSelect > 0 and table.find(type1.MutationSendSelect, a:GetAttribute("BrainrotMutation")))
	local i = c and (#type1.RaritySendSelect > 0 and table.find(type1.RaritySendSelect, c))

	if g or h then
		AddCooldown(a:GetAttribute("EntityId"))
		SendWebhook("Brainrot", "Brainrot", "Type: " .. b .. "\nLevel: " .. a:GetAttribute("BrainrotLevel") .. "\nRarity: " .. (c or "?") .. "\nMutation: " .. (a:GetAttribute("BrainrotMutation") or "NORMAl") .. "\nCashPerSec: " .. a:GetAttribute("CashPerSec"))
	end
end)

local VIRTUALIZE437 = LPH_NO_VIRTUALIZE(function(a)
	if a.Name == "Backpack" then
		InsertConnections(a.ChildAdded:Connect(VIRTUALIZE236))
	end
end)

InsertConnections(plr.ChildAdded:Connect(VIRTUALIZE437))

local VIRTUALIZ371 = LPH_NO_VIRTUALIZE(function(a)
	if not Flags["Auto Collect Egg"] then return end

	if a.Name == tostring(plr.UserId) then
		type2.collectalleggs:InvokeServer()
	end 
end)

InsertConnections(Workspace.RunningModels.ChildAdded:Connect(VIRTUALIZ371))

InsertTasks(spawn(function()
	while wait(0.3) do
		local valid_library, _ = pcall(function() return getgenv().Library end)
		local valid_webhook, _ = pcall(function()
			return loadstring(game:HttpGet("https://raw.githubusercontent.com/meobeo8/Misc/a/Webhook.lua"))()
		end)

		if valid_library and valid_webhook and valid_library ~= nil and valid_webhook ~= nil then
			AddCooldown("Loaded")
			getgenv().solix = true
			return
		end
	end
end))

InsertTasks(spawn(function()
	while wait() do
		local a, b = pcall(function()
			if not IsActive(char) then return end

			if char.HumanoidRootPart.Anchored then
				char.HumanoidRootPart.Anchored = false
			end

			if Flags["Become a Gymer"] then
				char.Humanoid.WalkSpeed = Flags["Walk Speed"]
				char.Humanoid.JumpPower = Flags["Jump Power"]
			end

			if Flags["Auto Farm Brainrot"] then
				type2.FarmBrainrot()
			end

			if Flags["Auto Sell Brainrot"] then
				type2.SellBrainrot()
			end

			if Flags["Auto Sell Brainrot when Full"] then
				type2.SellBrainrotWhenFull()
			end

			if Flags["Auto Fuse Brainrot"] then
				type2.FuseBrainrot()
			end

			if Flags["Auto Buy Bunny Lucky Block"] then
				type2.BuyBunnyLuckyBlock()
			end

			if Flags["Auto Open Lucky Block"] then
				type2.OpenLuckyBlock()
			end

			if Flags["Auto Luminous Spin"] then
				type2.LuminousSpin()
			end

			if Flags["Auto Circus Event"] then
				type2.CircusEvent()
			end

			if Flags["Auto Upgrade Lucky Block"] then
				type2.UpgradeLuckyBlock()
			end

			if Flags["Auto Upgrade Brainrot"] then
				type2.UpgradeBrainrot()
			end

			if Flags["Auto Upgrade Container"] then
				type2.UpgradeContainer()
			end

			if Flags["Auto Upgrade Speed"] then
				type2.UpgradeSpeed()
			end

			if Flags["Auto Rebirth"] then
				type2.Rebirth()
			end

			if Flags["Auto Place Best"] then
				type2.PlaceBest()
			end
		end)
		if not a then
			print(b)
		end
	end
end))

Library:CheckForAutoLoad()