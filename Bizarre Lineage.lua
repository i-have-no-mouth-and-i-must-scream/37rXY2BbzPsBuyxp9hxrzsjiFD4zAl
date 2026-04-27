repeat wait() until game:IsLoaded()

if game.PlaceId == 14890802310 then
	IsWorld = true
elseif game.PlaceId == 74747090658891 then
	IsRaid = true
end

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

getgenv().RaidShop = getgenv().RaidShop or {}
getgenv().Ability = getgenv().Ability or {}

getgenv().type1 = getgenv().type1 or {}
getgenv().type2 = getgenv().type2 or {}
getgenv().type3 = getgenv().type3 or {}
getgenv().type4 = getgenv().type4 or {}

local type1 = getgenv().type1
local type2 = getgenv().type2
local type3 = getgenv().type3
local type4 = getgenv().type4

local Tasks = {}
local Connections = {}

local CoreGui = cloneref(game:GetService("CoreGui"))
local CollectionService = cloneref(game:GetService("CollectionService"))
local Debris = cloneref(game:GetService("Debris"))
local GuiService = cloneref(game:GetService("GuiService"))
local HttpService = cloneref(game:GetService("HttpService"))
local Lighting = cloneref(game:GetService("Lighting"))
local LocalizationService = cloneref(game:GetService("LocalizationService"))
local Players = cloneref(game:GetService("Players"))
local ReplicatedFirst = cloneref(game:GetService("ReplicatedFirst"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local Workspace = cloneref(game:GetService("Workspace"))
local PathfindingService = cloneref(game:GetService("PathfindingService"))

local wait = task.wait
local spawn = task.spawn
local delay = task.delay
local Camera = Workspace.CurrentCamera

local plr = Players.LocalPlayer
local PlayerGUI = plr:FindFirstChildWhichIsA("PlayerGui")

local Webhook = loadstring(game:HttpGet("https://raw.githubusercontent.com/i-have-no-mouth-and-i-must-scream/37rXY2BbzPsBuyxp9hxrzsjiFD4zAl/vjQLEgzpAbTYwvwveMTXAQWmwsmitJ/hEM49vEj52iPuC1a8YPBfgBELspUX1.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/i-have-no-mouth-and-i-must-scream/37rXY2BbzPsBuyxp9hxrzsjiFD4zAl/vjQLEgzpAbTYwvwveMTXAQWmwsmitJ/vaHARNAHubAdzwt1xS2dLWqgGnETtV.lua"))()

local char, Flags = nil, Library.Flags

if plr:GetAttribute("Loaded") then
	char = plr.Character or plr.CharacterAdded:Wait()
end

type4.InsertTasks = function(Task)
	table.insert(Tasks, Task)
end

type4.InsertConnections = function(Connection)
	table.insert(Connections, Connection)
end

type4.AddCooldown = function(name, duration)
	if not type1.CooldownList then return end

	type1.CooldownList[name] = duration and (tick() + duration) or math.huge
end

type4.HasCooldown = function(name)
	if not type1.CooldownList then return end

	local stored_tick = type1.CooldownList[name]

	if stored_tick and tick() >= stored_tick then
		type1.CooldownList[name] = nil
		return false
	end

	return stored_tick ~= nil
end

local VIRTUALIZE011 = LPH_NO_VIRTUALIZE(function(character_tag)
	wait(6)
	if character_tag.Name == "CharacterTag" and (character_tag:FindFirstChild("Title") and character_tag.Title:FindFirstChild("shadow")) then
		local title_text = "solixhub.com"

		spawn(function()
			for index = 1, #title_text do
				character_tag.Title.Text = title_text:sub(1, index)
				character_tag.Title.shadow.Text = title_text:sub(1, index)
				wait(0.1)
			end
		end)

		local Variant = {"Original", "Viltrumite", "Mohawk", "Sinister", "Mustache", "Goggles", "Cape", "Prisoner", "Scarred", "Dark Suit", "Battle Damaged"}

		for _, leaderboard_entry in PlayerGUI.Leaderboard.frame.holder.scrollingframe.holder:GetChildren() do
			if leaderboard_entry.Name == "Template" then
				if string.find(leaderboard_entry.name.username.Text, plr.Name) then
					leaderboard_entry.name.username.Text = Variant[math.random(1, 11)] .. " Mark, Viltrumite"
					leaderboard_entry.name.gang.Text = "solix gang verry tuff and dangerous"
					break
				end
			end
		end
	end
end)

local VIRTUALIZE112 = LPH_NO_VIRTUALIZE(function(character)
	character:WaitForChild("HumanoidRootPart", 9)
	character:WaitForChild("Humanoid", 9)
	character:WaitForChild("Head", 9)
	char = character

	type4.InsertConnections(character.Head.ChildAdded:Connect(VIRTUALIZE011))
end)

type4.InsertConnections(plr.CharacterAdded:Connect(VIRTUALIZE112))

if getconnections then
	local connections = getconnections(plr.Idled)

	for _, connection in connections do
		if connection.Disable then
			connection:Disable()
		elseif connection.Disconnect then
			connection:Disconnect()
		end
	end
end

type4.InsertConnections(plr.Idled:Connect(function()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
	wait(0.01)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end))

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Theme = {
	Background = Color3.fromRGB(15, 12, 16),
	Inline = Color3.fromRGB(22, 20, 24),
	Border = Color3.fromRGB(41, 37, 45),
	Shadow = Color3.fromRGB(0, 0, 0),
	Text = Color3.fromRGB(255, 255, 255),
	InactiveText = Color3.fromRGB(185, 185, 185),
	Accent = Color3.fromRGB(232, 186, 248),
	Element = Color3.fromRGB(36, 32, 39),
	Success = Color3.fromRGB(60, 255, 60),
	Error = Color3.fromRGB(255, 60, 60)
}

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

			for Property, Value in NewItem.Properties do
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

		type4.InsertConnections(Library:Connect(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
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

		Debris:AddItem(self.Instance, 0)
		self = nil
	end
end

type4.GetUI = function()
	local Success, Result = pcall(function()
		return CoreGui
	end)
	return Success and Result or false
end

type4.SafeGetUI = function()
	local Success, Result = pcall(type4.GetUI)

	if Success and Result then
		return Result
	end
	return CoreGui or false
end

type4.SafeGetFont = function(...)
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
			local Loaded = type4.SafeGetFont(CustomAsset)

			if Loaded then
				return Loaded
			end
		end
	end

	local Fallback = type4.SafeGetFont(Enum.Font.GothamBold)

	if Fallback then
		return Fallback
	end
	return Enum.Font.GothamBold
end)()

type4.FindPath = function(inst, ...)
	for _, child_name in {...} do
		if not inst then return false end
		inst = inst:FindFirstChild(child_name)
	end
	return inst
end

type4.WaitPath = function(inst, ...)
	for _, child_name in {...} do
		if not inst then return false end
		inst = inst:WaitForChild(child_name)
	end
	return inst
end

type4.IsActive = function(char)
	return char
		and char.Parent
		and char:FindFirstChild("HumanoidRootPart")
		and char:FindFirstChildOfClass("Humanoid")
		and char:FindFirstChildOfClass("Humanoid").Health > 0
end

type4.IsGood = function(char)
	return char
		and char.Parent
		and not char:FindFirstChild("IFrame")
		and not char:GetAttribute("Invisible")
		and not char:GetAttribute("Evading")
		and not char:GetAttribute("Blocking")
		and not char:GetAttribute("PerfectBlock")
end

type4.CanTP = function(target)
	return target and target.Parent and ((target:IsA("Model") and ((target:FindFirstChild("HumanoidRootPart") and target.HumanoidRootPart.CFrame) or target:GetPivot())) or (target:IsA("BasePart") and target.CFrame))
end

type4.ToTime = function(seconds)
	if seconds < 0 then
		return "I don't know either"
	end

	seconds = math.floor(seconds)

	local days = math.floor(seconds / 86400)

	seconds = seconds % 86400

	local hours = math.floor(seconds / 3600)

	seconds = seconds % 3600

	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60

	if days > 0 then
		return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, secs)
	else
		return string.format("%02dh %02dm %02ds", hours, minutes, secs)
	end
end

type4.NormalizeName = function(name)
	name = tostring(name)
	name = string.lower(name)
	name = name:gsub("%s+", "")
	return name
end

type4.NormalizeText = function(text)
	text = tostring(text)
	text = text:gsub("<.->", "")
	text = text:gsub("%d%d:%d%d:%d%d%s*", "")
	text = text:gsub("%.$", "")
	text = text:match("^%s*(.-)%s*$")
	return text
end

type4.TP = function(cframe)
	if not cframe or not type4.IsActive(char) or (not type3.CanInstant[type4.GetName()] and char:FindFirstChild("IFrame") and char.IFrame:IsA("Folder")) then return false end

	if IsRaid and type3.CanInstant[type4.GetName()] and Flags["Instant Kill"] then
		if char:FindFirstChild("IFrame") and (type4.IsActive(mob) and mob:GetAttribute("Miniboss")) then
			delay(Flags["Instant Kill Hold Delay"], function()
				char.HumanoidRootPart.CFrame = CFrame.new(0, -470, 0)
			end)
		else
			char.HumanoidRootPart.CFrame = cframe
		end
	else
		char.HumanoidRootPart.CFrame = cframe
	end
end

type4.GetMethod = function()
	local method = Flags["Teleport Method"]
	local offset = Flags["Position Offset"]

	if method == "Behind" then
		return CFrame.new(0, 0, offset)
	elseif method == "Below" then
		return CFrame.new(0, -offset, 0) * CFrame.Angles(math.rad(90), 0, 0)
	elseif method == "Above" then
		return CFrame.new(0, offset, 0) * CFrame.Angles(math.rad(-90), 0, 0)
	else
		return CFrame.new(0, 0, 0)
	end
end

type4.SendTrue = function(key_code)
	VirtualInputManager:SendKeyEvent(true, key_code, false, game)
end

type4.SendFalse = function(key_code)
	VirtualInputManager:SendKeyEvent(false, key_code, false, game)
end

type4.SendKey = function(key_code)
	type4.SendTrue(key_code)
	wait(0.01)
	type4.SendFalse(key_code)
end

type4.ClickGui = function(gui_object)
	if not gui_object or not gui_object:IsA("GuiObject") then return false end

	local success = false

	for attempt = 1, 3 do
		if gui_object
			and gui_object.Parent
			and gui_object.Visible
			and gui_object.Parent:IsDescendantOf(PlayerGUI) then
			local clicked = pcall(function() GuiService.SelectedObject = gui_object end)

			if clicked and GuiService.SelectedObject == gui_object then
				success = true
				break
			end
		end
	end

	if success then
		type4.SendKey(Enum.KeyCode.Return)
		wait(0.01)
		GuiService.SelectedObject = nil
	end
end

type4.ProximityPrompt = function(prompt)
	if type4.HasCooldown("Proximity Prompt") then return false end

	if prompt and prompt.Parent and prompt.Enabled then
		type4.AddCooldown("Proximity Prompt", 0.03)
		prompt.HoldDuration = 0 fireproximityprompt(prompt)
	end
end

type4.GetMob = function(filter, max_distance)
	if not type4.IsActive(char) then return false end

	local closest_mob, closest_distance, max_dist = nil, math.huge, max_distance or math.huge

	for _, entity in Workspace.Live:GetChildren() do
		if not type4.IsActive(entity) then continue end
		if entity:FindFirstChild("client_character_controller") then continue end

		local display_name = entity:GetAttribute("DisplayName") or entity.Name
		if display_name == "Hostage" or display_name == "Server" then continue end

		local is_valid = false

		if filter == nil then
			local normalized_name = type4.NormalizeName(display_name)

			is_valid = (normalized_name ~= "netherstar3") and ((not Flags["Ingore Snark, Vern"]) or (normalized_name ~= "snark" and normalized_name ~= "vern"))
		elseif typeof(filter) == "string" then
			is_valid = type4.NormalizeName(display_name) == type4.NormalizeName(filter)
		elseif typeof(filter) == "table" then
			for _, name in filter do
				if type4.NormalizeName(display_name) == type4.NormalizeName(name) then
					is_valid = true
					break
				end
			end
		end

		if is_valid then
			local distance = (entity.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude

			if distance and distance <= max_dist and distance < closest_distance then
				closest_mob = entity
				closest_distance = distance
			end
		end
	end
	return closest_mob
end

type4.GetMobHighlight = function()
	if not type4.IsActive(char) then return false end

	local closest_entity, closest_dist = nil, math.huge

	for _, entity in Workspace.Live:GetChildren() do
		if not type4.IsActive(entity) then continue end
		if entity:FindFirstChild("client_character_controller") then continue end

		local display_name = entity:GetAttribute("DisplayName") or entity.Name
		if display_name == "Hostage" or display_name == "Server" then continue end

		if entity:FindFirstChild("Highlight") and type4.CheckColor(entity.Highlight.FillColor, 255, 0, 25) then
			local dist = (entity.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude

			if dist < closest_dist then
				closest_entity = entity
				closest_dist = dist
			end
		end
	end
	return closest_entity
end

type4.GetMobEntityClone = function()
	if not type4.IsActive(char) then return false end

	local closest_entity, closest_dist = nil, math.huge

	for _, entity in Workspace.Live:GetChildren() do
		if not type4.IsActive(entity) then continue end
		if entity:FindFirstChild("client_character_controller") then continue end

		local display_name = entity:GetAttribute("DisplayName") or entity.Name
		if display_name == "Hostage" or display_name == "Server" then continue end

		if entity:GetAttribute("Miniboss") and entity:GetAttribute("Miniboss") == plr.Name then
			local dist = (entity.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude

			if dist < closest_dist then
				closest_entity = entity
				closest_dist = dist
			end
		end
	end
	return closest_entity
end

type4.GetPlayer = function(filter, max_distance)
	if not type4.IsActive(char) then return false end

	local closest_player, closest_distance, max_dist = nil, math.huge, max_distance or math.huge

	for _, other_player in Players:GetChildren() do
		if other_player ~= plr and type4.IsActive(other_player.Character) then
			local is_match = false

			if filter == nil then
				is_match = true
			elseif typeof(filter) == "string" then
				is_match = type4.NormalizeName(other_player.Name) == type4.NormalizeName(filter)
			elseif typeof(filter) == "table" then
				for _, name in filter do
					if type4.NormalizeName(other_player.Name) == type4.NormalizeName(name) then
						is_match = true
						break
					end
				end
			end

			if is_match then
				local distance = (other_player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude

				if distance and distance <= max_dist and distance < closest_distance then
					closest_player = other_player.Character
					closest_distance = distance
				end
			end
		end
	end
	return closest_player
end

type4.GetPlayerOtherTeam = function()
	if not type4.IsActive(char) then return false end

	local closest_entity, closest_dist = nil, math.huge

	for _, player in Players:GetChildren() do
		if player ~= plr and type4.IsActive(player.Character) and player.Character:GetAttribute("MissionHighlight") then 
			if player.Character:FindFirstChild("Highlight") and type4.CheckColor(player.Character.Highlight.FillColor, 255, 0, 25) then
				local dist = (player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude

				if dist < closest_dist then
					closest_entity = player.Character
					closest_dist = dist
				end
			end
		end
	end
	return closest_entity
end

type4.CheckColor = function(color, red, green, blue)
	if not color or not red or not green or not blue then return end
	return math.floor(color.R * 255 + 0.5) == red and math.floor(color.G * 255 + 0.5) == green and math.floor(color.B * 255 + 0.5) == blue
end

type4.CheckSkill = function(keybind)
	local stand_a, stand_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.StandSkills.Value)
	end)

	if not stand_a or not stand_b then
		return false
	end

	local skill_table = {}

	for _, skill in stand_b do
		skill_table[skill] = true
	end

	for ability_name, ability_data in getgenv().Ability do
		if type(ability_data) == "table" and ability_data.AbilityType == "Stand" then
			if string.split(tostring(ability_name), ": ")[1] == char:GetAttribute("SummonedStand") and tostring(ability_data.Keybind):upper() == tostring(keybind):upper() then
				if next(skill_table) == nil or skill_table[ability_name] then
					return type4.HasCooldown(ability_data.Name) or false
				end
			end
		end
	end
	return true
end

type4.CheckAbility = function(slot_number)
	local slot = PlayerGUI:FindFirstChild("Inventory"):FindFirstChild("Holder"):FindFirstChild("Slot" .. slot_number)
	local ability_button = slot and slot:FindFirstChildOfClass("TextButton")
	local cooldown = ability_button and ability_button:FindFirstChild("Holder"):FindFirstChild("Background"):FindFirstChild("CD")

	return cooldown and cooldown.Transparency < 1, ability_button and ability_button.Name
end

type4.Skill = function()
	if char.Boosts:FindFirstChild("Skill_HardSet") or type4.HasCooldown("Auto Use Skill") or type4.HasCooldown("Doge Blocked") or not Flags["Auto Use Skill"] then return end

	local used_skill = false
	local skills_to_use = nil
	local skip_grab_in_dio = false

	if IsRaid and Flags["Instant Kill"] and type3.CanInstant[type4.GetName()] then
		skills_to_use = type1.SkillGrabSelect
	elseif type3.MapName == "Heaven Ascension DIO" then
		skills_to_use = type1.SkillSelect
		skip_grab_in_dio = true
	else
		skills_to_use = type1.SkillSelect
	end

	for _, skill in skills_to_use do
		if skip_grab_in_dio then
			local is_grab_skill = false

			for _, grab_skill in type1.SkillGrabSelect do
				if grab_skill == skill then
					is_grab_skill = true
					break
				end
			end
			if is_grab_skill then
				continue
			end
		end

		if not type4.CheckSkill(skill) then
			used_skill = true

			type4.AddCooldown("M1 Blocked", Flags["Use Skill Delay"])
			char.client_character_controller.Skill:FireServer(skill, true)

			delay(Flags["Use Skill Delay"], function()
				char.client_character_controller.Skill:FireServer(skill, false)
			end)
			break
		end
	end

	if used_skill then
		type4.AddCooldown("Auto Use Skill", Flags["Use Skill Delay"])
	end
end

type4.Ability = function()
	if char.Boosts:FindFirstChild("Skill_HardSet") or type4.HasCooldown("Auto Use Ability") or type4.HasCooldown("Doge Blocked") or not Flags["Auto Use Ability"] then return end

	local used_ability = false
	local abilities_to_use = nil
	local skip_grab_in_dio = false

	if IsRaid and Flags["Instant Kill"] and type3.CanInstant[type4.GetName()] then
		abilities_to_use = type1.AbilityGrabSelect
	elseif type3.MapName == "Heaven Ascension DIO" then
		abilities_to_use = type1.AbilitySelect
		skip_grab_in_dio = true
	else
		abilities_to_use = type1.AbilitySelect
	end

	for _, ability in abilities_to_use do
		if skip_grab_in_dio then
			local is_grab_ability = false

			for _, grab_ability in type1.AbilityGrabSelect do
				if grab_ability == ability then
					is_grab_ability = true
					break
				end
			end
			if is_grab_ability then
				continue
			end
		end

		local is_ready, ability_name = type4.CheckAbility(ability)

		if not is_ready then
			used_ability = true

			type4.AddCooldown("M1 BLOCKED", Flags["Use Ability Delay"])
			type2.general.skillcast:FireServer(ability_name, true)

			delay(Flags["Use Ability Delay"], function()
				type2.general.skillcast:FireServer(ability_name, false)
			end)
			break
		end
	end

	if used_ability then
		type4.AddCooldown("Auto Use Ability", Flags["Use Ability Delay"])
	end
end

type4.M1 = function()
	if char.Boosts:FindFirstChild("M1 Finish Slow") or char.Boosts:FindFirstChild("Skill_HardSet") or type4.HasCooldown("M1 Blocked") or type4.HasCooldown("Doge Blocked") then return end

	type4.AddCooldown("M1 Blocked", 0.1)
	char.client_character_controller.M1:FireServer(true, false)
end

type4.GetRaid = function(raid_title)
	for _, ring in Workspace.Effects:GetChildren() do
		if ring.Name == "thering" and ring:FindFirstChild("BillboardGui") and ring.BillboardGui:FindFirstChild("title") and ring.BillboardGui.title.Text == raid_title then
			return ring
		end
	end
	return false
end

type4.GetName = function()
	return (mob and mob.Name) or ""
end

type4.GetMission = function()
	for _, quest_brick in Workspace.Effects:GetChildren() do
		if quest_brick.Name == "questbrick" then
			local title_text = quest_brick["Quest Marker"].Image.Title.Text
			local mission_target = title_text and title_text:match("^Delivery for (.+) %(")

			if title_text and title_text:match("^Delivery for .+ %(%d+m%)$") then			
				return mission_target
			end
		end
	end
	return false
end

type4.GetStoryline = function()
	local quest_a, quest_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.CurrentQuests.Value)
	end)

	if not quest_a or not quest_b then
		return false
	end

	for _, quest in quest_b do
		if string.find(quest.Name, "Storyline") then

			if quest.Talk then
				if type(quest.Talk) == "table" then
					for talk_index, talk_text in quest.Talk do
						if not talk_text then
							return "Talk", talk_index
						end
					end
				elseif type(quest.Talk) == "string" then
					return "Talk", quest.Talk
				end
			end

			if quest.Kills and type(quest.Kills) == "table" then
				if quest.Name == "Storyline 18" then
					if quest.Kills["Yakuza"] and quest.Kills["Yakuza"] < 4 then
						return "Kills", "Yakuza"
					elseif quest.Kills["Thug"] and quest.Kills["Thug"] < 4 then
						return "Kills", "Thug"
					end
				else
					for kill_target, kill_count in quest.Kills do
						return "Kills", kill_target
					end
				end
			end

			if quest.ObtainItem and type(quest.ObtainItem) == "table" then
				for item_name, item_count in quest.ObtainItem do
					if not item_count then
						if item_name == "Maigot Recipe" then
							return "ObtainItem", "Mr. Rengatei"
						end
					end
				end
			end

			if quest.SpecialRaids and type(quest.SpecialRaids) == "table" then
				for raid_name, raid_status in quest.SpecialRaids do
					return "SpecialRaids", raid_name
				end
			end
		end
	end
	return false
end

type4.GetWorkouts = function()
	local workout_a, workout_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.Workouts.Value)
	end)

	if not workout_a or not workout_b then
		return false
	end

	for workout_name, workout_time in workout_b do
		if table.find(type1.WorkoutSelect, workout_name) then
			if (900 - (os.time() - workout_time)) <= 0 then
				return tostring(workout_name)
			end
		end
	end
	return false
end

type4.GetStand = function(names_filter, skins_filter, strength_filter, speed_filter, specialty_filter, traits_filter)
	local stand_a, stand_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.Stand.Value)
	end)

	if not stand_a or not stand_b then
		return false
	end

	if #traits_filter > 0 and not table.find(traits_filter, stand_b.Trait) then
		return false
	end

	if #names_filter > 0 and not table.find(names_filter, stand_b.Name) then
		return false
	end

	if #skins_filter > 0 then
		if not stand_b.Skin or not table.find(skins_filter, stand_b.Skin) then
			return false
		end
	end

	if #strength_filter > 0 then
		local meets_requirement = false

		for _, stat in strength_filter do
			if type1.StatRollData[stat] and stand_b.Strength >= type1.StatRollData[stat] then
				meets_requirement = true
				break
			end
		end
		if not meets_requirement then
			return false
		end
	end

	if #speed_filter > 0 then
		local meets_requirement = false

		for _, stat in speed_filter do
			if type1.StatRollData[stat] and stand_b.Speed >= type1.StatRollData[stat] then
				meets_requirement = true
				break
			end
		end
		if not meets_requirement then
			return false
		end
	end

	if #specialty_filter > 0 then
		local meets_requirement = false

		for _, stat in specialty_filter do
			if type1.StatRollData[stat] and stand_b.Specialty >= type1.StatRollData[stat] then
				meets_requirement = true
				break
			end
		end
		if not meets_requirement then
			return false
		end
	end
	return stand_b.Name or false
end

type4.GetInventory = function(item_name)
	local inventory_a, inventory_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.Inventory.Value)
	end)

	if not inventory_a or not inventory_b then 
		return false
	end

	for _, item in inventory_b do
		if item.Name == item_name then
			return tonumber(item.Amount)
		end
	end
	return 0
end

type4.GetItem = function()
	local inventory_a, inventory_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.Inventory.Value)
	end)

	if not inventory_a or not inventory_b then
		return false
	end

	for _, item in inventory_b do
		if item.Amount and item.Amount >= Flags["Auto Sell Item Threshold"] then
			return {Amount = item.Amount, Name = item.Name, duplicates = item.Amount}
		end
	end
	return false
end

type4.GetAccessories = function()
	local inventory_a, inventory_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.Inventory.Value)
	end)

	local equipped_a, equipped_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.EquippedAccessories.Value)
	end)

	if not inventory_a or not inventory_b or not equipped_a or not equipped_b then
		return false
	end

	local rarity_filter = type1.AccessoriesRaritySelect
	local pip_filter = type1.PipKeepSelect
	local accessories_to_sell = {}
	local equipped_ids = {}

	if equipped_a and equipped_b then
		for _, item in pairs(equipped_b) do
			if item and item.ID then
				equipped_ids[item.ID] = true
			end
		end
	end

	for _, accessory in inventory_b do
		if equipped_ids[accessory.ID] or accessory.Locked or not accessory.Pips then continue end

		local rarity_name = type1.AccessoriesNameData[accessory.Name]

		if not rarity_name then
			for rarity_type, items in type1.AccessoriesRarityData do
				if table.find(items, accessory.Name) then
					rarity_name = rarity_type
					break
				end
			end
		end

		if not rarity_name then continue end

		local count = type1.RarityData[rarity_name] or 0
		local should_sell = false

		if rarity_filter and next(rarity_filter) and count < 3 then
			for _, rarity_type in rarity_filter do
				if rarity_type == "Legendary" or rarity_type == "Mythical" then
					should_sell = true
					break
				end
			end
		end

		if not should_sell and table.find(type1.AccessoriesKeepSelect, accessory.Name) then
			continue
		end

		if not should_sell and pip_filter and next(pip_filter) then
			local has_matching_pip = false

			for _, pip in accessory.Pips do
				if table.find(pip_filter, pip) then
					has_matching_pip = true
					break
				end
			end

			if has_matching_pip then
				continue
			end
		end

		if not should_sell and rarity_filter and next(rarity_filter) and rarity_name and table.find(rarity_filter, rarity_name) then
			should_sell = true
		end

		if not should_sell and rarity_filter and next(rarity_filter) then
			local has_high_rarity = false

			for _, rarity_type in rarity_filter do
				if rarity_type == "Legendary" or rarity_type == "Mythical" then
					has_high_rarity = true
					break
				end
			end

			if has_high_rarity and count < 3 then
				should_sell = true
			end
		end

		if not should_sell and count >= 3 and rarity_name and table.find(rarity_filter, rarity_name) then
			should_sell = true
		end

		if should_sell then
			table.insert(accessories_to_sell, {
				ID = accessory.ID,
				Name = accessory.Name,
				duplicates = 1,
				Pips = accessory.Pips
			})
		end
	end

	return accessories_to_sell
end

type4.GetCashShop = function()
	local shop_a, shop_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.CashShop.Value)
	end)

	local purchase_a, purchase_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.CashShopPurchases.Value)
	end)

	if not shop_a or not shop_b or not purchase_a or not purchase_b then
		return false
	end

	for item_name, shop_item in shop_b do
		if table.find(type1.CashShopSelect, item_name) then
			if shop_item.Price <= type2.slot.Money.Value and shop_item.Stock > (purchase_b[item_name] or 0) then
				return item_name
			end
		end
	end
	return false
end

type4.GetGangShop = function()
	local success, shop_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.GangShop.Value)
	end)

	local purchase_a, purchase_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.GangShopPurchases.Value)
	end)

	if not success or not shop_b or not purchase_a or not purchase_b then
		return false
	end

	for item_name, shop_item in shop_b do
		if table.find(type1.GangShopSelect, item_name) then
			if shop_item.Price <= type2.slot.GangPoints.Value and shop_item.Stock > (purchase_b[item_name] or 0) then
				return item_name
			end
		end
	end
	return false
end

type4.GetRaidShop = function()
	local raid_shop = getgenv().RaidShop

	local purchase_a, purchase_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.RaidShopPurchases.Value)
	end)

	local tokens_a, tokens_b = pcall(function()
		return HttpService:JSONDecode(type2.slot.RaidTokens.Value)
	end)

	if not raid_shop or not purchase_a or not purchase_b or not tokens_a or not tokens_b then
		return false
	end

	local version_key = tostring(raid_shop.Version)
	local previous_purchases = version_key and purchase_b[version_key] or {}

	for raid_name, raid_items in raid_shop do
		if raid_name ~= "Version" then
			for _, item_name in type1.RaidShopSelect do
				local shop_item = raid_items[item_name]

				if shop_item then
					local previous_count = (previous_purchases[raid_name] and previous_purchases[raid_name][item_name]) or 0
					local remaining_stock = shop_item.Stock - previous_count

					if (tokens_b[raid_name] or 0) >= shop_item.Price and remaining_stock > 0 then
						return item_name, raid_name
					end
				end
			end
		end
	end
	return false
end

type4.GetDialogue = function(choice, name)
	local dialogue = PlayerGUI:FindFirstChild("Dialogue") and PlayerGUI.Dialogue:FindFirstChild("Holder")

	if dialogue.Visible and dialogue.NPCName.Text ~= name then
		for _, button in dialogue.Choices:GetDescendants() do
			if button:IsA("TextButton") and button.Text == "Goodbye." then
				type4.ClickGui(button)
				break
			end
		end
	end

	return choice or (dialogue.Visible and dialogue.Choices.Holder1["1"].Choice.Text) or 1
end

type4.GetNPC1 = function(npc_name)
	return Workspace.Npcs:FindFirstChild(npc_name), ReplicatedStorage.assets.npc_cache:FindFirstChild(npc_name)
end

type4.GetNPC2 = function(npc_name)
	return Workspace.Npcs:FindFirstChild(npc_name) or ReplicatedStorage.assets.npc_cache:FindFirstChild(npc_name)
end

type4.SendWebhook = function(webhook_type, field_name, field_value)
	local message = Webhook.CreateMessage(Flags["Webhook URL " .. webhook_type], "solixhub", Flags["Mention Option " .. webhook_type])

	local embed = message:AddEmbed("Bizarre Lineage", "")
	embed:AddField("Name", "||" .. plr.Name .. " [" .. type2.slot.Level.Value .. "]||")
	embed:AddField(field_name, field_value)

	message:SendMessage()
end

function type4.StopFly()
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

	if type4.Connection1 then
		type4.Connection1:Disconnect()
		type4.Connection1 = nil
	end

	if type3.Connection2 then
		type3.Connection2:Disconnect()
		type3.Connection2 = nil
	end

	if type3.Velocity then
		type3.Velocity:Clean()
		type3.Velocity = nil
	end

	if type3.Gyro then
		type3.Gyro:Clean()
		type3.Gyro = nil
	end

	if type4.IsActive(char) then
		char.Humanoid.PlatformStand = false
		char.client_character_controller.Enabled = true
	end

	pcall(function()
		Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	end)
end

function type4.FlyNormal()
	type4.StopFly()

	if not type4.IsActive(char) then 
		return
	end

	type3.IsFlying = true
	char.Humanoid.PlatformStand = true
	char.client_character_controller.Enabled = false

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

	local key_states = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local prev_key_states = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local speed = 0

	type3.Loop = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
		if not type3.IsFlying or not type4.IsActive(char) then
			type4.StopFly()
			return
		end

		if key_states.L + key_states.R ~= 0 or key_states.F + key_states.B ~= 0 or key_states.Q + key_states.E ~= 0 then
			speed = Flags["Fly Speed"] or 30
		elseif speed ~= 0 then
			speed = 0
		end

		if (key_states.L + key_states.R) ~= 0 or (key_states.F + key_states.B) ~= 0 or (key_states.Q + key_states.E) ~= 0 then
			local velocity_vector = ((Camera.CFrame.LookVector * (key_states.F + key_states.B)) + ((Camera.CFrame * CFrame.new(key_states.L + key_states.R, (key_states.F + key_states.B + key_states.Q + key_states.E) * 0.2, 0).p) - Camera.CFrame.p)) * speed

			type3.Velocity.Instance.Velocity = velocity_vector
			prev_key_states = {F = key_states.F, B = key_states.B, L = key_states.L, R = key_states.R}
		elseif speed ~= 0 then
			local velocity_vector = ((Camera.CFrame.LookVector * (prev_key_states.F + prev_key_states.B)) + ((Camera.CFrame * CFrame.new(prev_key_states.L + prev_key_states.R, (prev_key_states.F + prev_key_states.B + prev_key_states.Q + prev_key_states.E) * 0.2, 0).p) - Camera.CFrame.p)) * speed

			type3.Velocity.Instance.Velocity = velocity_vector
		else
			type3.Velocity.Instance.Velocity = Vector3.new(0, 0, 0)
		end
		type3.Gyro.Instance.CFrame = Camera.CFrame
	end))

	if getgenv().relix then
		local control_module = plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")

		type4.Connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
			if not type3.IsFlying or not type4.IsActive(char) then
				type4.StopFly()
				return
			end

			type3.Velocity.Instance.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			type3.Gyro.Instance.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			type3.Gyro.Instance.CFrame = Workspace.CurrentCamera.CoordinateFrame
			type3.Velocity.Instance.Velocity = Vector3.new(0, 0, 0)

			local input_direction = control_module:GetMoveVector()

			if input_direction.X > 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity + Workspace.CurrentCamera.CFrame.RightVector * (input_direction.X * ((Flags["Fly Speed"] or 30) * 50))
			end
			if input_direction.X < 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity + Workspace.CurrentCamera.CFrame.RightVector * (input_direction.X * ((Flags["Fly Speed"] or 30) * 50))
			end
			if input_direction.Z > 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity - Workspace.CurrentCamera.CFrame.LookVector * (input_direction.Z * ((Flags["Fly Speed"] or 30) * 50))
			end
			if input_direction.Z < 0 then
				type3.Velocity.Instance.Velocity = type3.Velocity.Instance.Velocity - Workspace.CurrentCamera.CFrame.LookVector * (input_direction.Z * ((Flags["Fly Speed"] or 30) * 50))
			end
		end))
	else
		type3.KeyDown = UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(key_code, is_gamepad)
			if is_gamepad then return end

			if key_code.KeyCode == Enum.KeyCode.W then
				key_states.F = Flags["Fly Speed"] or 30
			elseif key_code.KeyCode == Enum.KeyCode.S then
				key_states.B = -(Flags["Fly Speed"] or 30)
			elseif key_code.KeyCode == Enum.KeyCode.A then
				key_states.L = -(Flags["Fly Speed"] or 30)
			elseif key_code.KeyCode == Enum.KeyCode.D then
				key_states.R = Flags["Fly Speed"] or 30
			elseif key_code.KeyCode == Enum.KeyCode.E then
				key_states.Q = (Flags["Fly Speed"] or 30) * 2
			elseif key_code.KeyCode == Enum.KeyCode.Q then
				key_states.E = -(Flags["Fly Speed"] or 30) * 2
			end

			pcall(function()
				Workspace.CurrentCamera.CameraType = Enum.CameraType.Track
			end)
		end))

		type3.KeyUp = UserInputService.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(key_code, is_gamepad)
			if is_gamepad then return end

			if key_code.KeyCode == Enum.KeyCode.W then
				key_states.F = 0
			elseif key_code.KeyCode == Enum.KeyCode.S then
				key_states.B = 0
			elseif key_code.KeyCode == Enum.KeyCode.A then
				key_states.L = 0
			elseif key_code.KeyCode == Enum.KeyCode.D then
				key_states.R = 0
			elseif key_code.KeyCode == Enum.KeyCode.E then
				key_states.Q = 0
			elseif key_code.KeyCode == Enum.KeyCode.Q then
				key_states.E = 0
			end
		end))
	end

	type3.Connection2 = plr.CharacterAdded:Connect(LPH_NO_VIRTUALIZE(function()
		type4.StopFly()
	end))
end

type4.OptimizeObject = function(object)
	if not object or not object.Parent then
		return
	end

	if object:IsA("BasePart") or object:IsA("MeshPart") then
		object.Reflectance = 0
		object.CastShadow = false
		object.Material = Enum.Material.SmoothPlastic
		object.TopSurface = Enum.SurfaceType.Studs
		object.BottomSurface = Enum.SurfaceType.Studs
		object.LeftSurface = Enum.SurfaceType.Studs
		object.RightSurface = Enum.SurfaceType.Studs
		object.FrontSurface = Enum.SurfaceType.Studs
		object.BackSurface = Enum.SurfaceType.Studs
		if object:IsA("MeshPart") then
			object.TextureID = ""
		end

	elseif object:IsA("Decal") or object:IsA("Texture") then
		object.Transparency = 1

	elseif object:IsA("Sky") then
		object.Parent = nil

	elseif object:IsA("ParticleEmitter") then
		object.Enabled = false
		object.Rate = 0
		object.Lifetime = NumberRange.new(0)
		object.Speed = NumberRange.new(0)
		object.Transparency = NumberSequence.new(1)

	elseif object:IsA("Trail") then
		object.Enabled = false
		object.Transparency = NumberSequence.new(1)

	elseif object:IsA("Beam") then
		object.Enabled = false
		object.Transparency = NumberSequence.new(1)
		object.Width0 = 0
		object.Width1 = 0

	elseif object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles") then
		object.Enabled = false

	elseif object:IsA("Explosion") then
		object.Parent = nil

	elseif object:IsA("SurfaceGui") or object:IsA("BillboardGui") then
		object.Enabled = false

	elseif object:IsA("PointLight") or object:IsA("SpotLight") or object:IsA("SurfaceLight") then
		object.Enabled = true
		object.Brightness = math.min(object.Brightness, 1)
		object.Range = math.max(8, math.floor((object.Range or 16) * 0.6))

	elseif object:IsA("Highlight") or object:IsA("SelectionBox") or object:IsA("SelectionSphere") then
		object.Enabled = false

	elseif object:IsA("BloomEffect") or object:IsA("BlurEffect") or object:IsA("ColorCorrectionEffect") or object:IsA("SunRaysEffect") or object:IsA("DepthOfFieldEffect") then
		object.Enabled = false

	elseif object:IsA("Atmosphere") then
		object.Density = 0.05
		object.Haze = 0.2
		object.Glare = 0

	elseif object:IsA("Sound") then
		object.Volume = 0
		object.Playing = false

	elseif object:IsA("Terrain") then
		object.WaterWaveSize = 0
		object.WaterWaveSpeed = 0
		object.WaterReflectance = 0
		object.WaterTransparency = 1

	elseif object:IsA("PostEffect") then
		object.Enabled = false
	end
end

type4.Hop = function(server_type)
	if not game.JobId or not game.PlaceId then
		Library:Notification({
			Name = "Hop Server",
			Description = "Cannot get server info",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	local http_request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	if not http_request then
		Library:Notification({
			Name = "Hop Server",
			Description = "HTTP not supported",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	local success, response = pcall(function()
		return http_request({
			Url = string.format(
				"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
				game.PlaceId
			)
		})
	end)

	if not success or not response or not response.Body then
		Library:Notification({
			Name = "Hop Server",
			Description = "Failed to fetch servers",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	local server_data = HttpService:JSONDecode(response.Body)
	if not server_data or not server_data.data then
		Library:Notification({
			Name = "Hop Server",
			Description = "No server data found",
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 10
		})
		return
	end

	if server_type == "Low Population" then
		local found_servers = {}
		local cursor = ""
		local current_hour = os.date("!*t").hour

		local function LowPlayers()
			local servers
			if cursor == "" then
				servers = HttpService:JSONDecode(
					game:HttpGet(
						"https://games.roblox.com/v1/games/" ..
							game.PlaceId ..
							"/servers/Public?sortOrder=Asc&limit=100"
					)
				)
			else
				servers = HttpService:JSONDecode(
					game:HttpGet(
						"https://games.roblox.com/v1/games/" ..
							game.PlaceId ..
							"/servers/Public?sortOrder=Asc&limit=100&cursor=" ..
							cursor
					)
				)
			end

			if servers.nextPageCursor and servers.nextPageCursor ~= "null" then
				cursor = servers.nextPageCursor
			end

			for _, server in servers.data do
				local is_valid = true
				local server_id = tostring(server.id)

				if tonumber(server.maxPlayers) > tonumber(server.playing) then
					for index, stored_id in found_servers do
						if index ~= 0 and server_id == tostring(stored_id) then
							is_valid = false
						elseif index == 0 and tonumber(current_hour) ~= tonumber(stored_id) then
							found_servers = {}
							table.insert(found_servers, current_hour)
						end
					end

					if is_valid then
						table.insert(found_servers, server_id)
						Library:Notification({
							Name = "Hop Server",
							Description = "Found low population server: " .. server.playing .. "/" .. server.maxPlayers,
							Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
							Duration = 3
						})
						wait()
						pcall(function()
							TeleportService:TeleportToPlaceInstance(game.PlaceId, server_id, plr)
						end)
						wait(4)
					end
				end
			end
		end

		while wait() do
			pcall(function()
				LowPlayers()
				if cursor ~= "" then
					LowPlayers()
				end
			end)
		end
	else
		local available_servers = {}

		for _, server in server_data.data do
			if tonumber(server.playing) < tonumber(server.maxPlayers) and server.id ~= game.JobId then
				table.insert(available_servers, server)
			end
		end

		if #available_servers > 0 then
			local target_server = available_servers[math.random(1, #available_servers)]
			Library:Notification({
				Name = "Hop Server",
				Description = "Found normal population server: " .. target_server.playing .. "/" .. target_server.maxPlayers,
				Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
				Duration = 3
			})
			wait(1)
			pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, target_server.id, plr)
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

type4.CreateInfo = function()
	local Theme = {
		Background = Color3.fromRGB(15, 12, 16),
		Inline = Color3.fromRGB(22, 20, 24),
		Border = Color3.fromRGB(41, 37, 45),
		Shadow = Color3.fromRGB(0, 0, 0),
		Text = Color3.fromRGB(255, 255, 255),
		InactiveText = Color3.fromRGB(185, 185, 185),
		Accent = Color3.fromRGB(232, 186, 248),
		Element = Color3.fromRGB(36, 32, 39),
		Success = Color3.fromRGB(60, 255, 60),
		Error = Color3.fromRGB(255, 60, 60)
	}

	local FrameSize = getgenv().relix and UDim2.new(0, 180, 0, 380) or UDim2.new(0, 390, 0, 340)
	local ButtonSize = getgenv().relix and UDim2.new(0, 150, 0, 45) or UDim2.new(0, 220, 0, 45)
	local ButtonSizeHover = getgenv().relix and UDim2.new(0, 160, 0, 48) or UDim2.new(0, 230, 0, 48)
	local ButtonSizeDown = getgenv().relix and UDim2.new(0, 140, 0, 42) or UDim2.new(0, 210, 0, 42)
	local TextSize = getgenv().relix and 13 or 15
	local TitleSize = getgenv().relix and 22 or 28

	local Items = {} do
		Items["Gui"] = Instances:Create("ScreenGui", {
			Parent = PlayerGUI,
			Name = "\0",
			DisplayOrder = -9e9,
			ResetOnSpawn = false,
			IgnoreGuiInset = true
		})

		Items["MainFrame"] = Instances:Create("Frame", {
			Parent = Items["Gui"].Instance,
			Name = "\0",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Theme.Background,
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0
		})

		Instances:Create("UICorner", {
			Parent = Items["MainFrame"].Instance,
			Name = "\0",
			CornerRadius = UDim.new(0, 8)
		})

		Items["MainStroke"] = Instances:Create("UIStroke", {
			Parent = Items["MainFrame"].Instance,
			Name = "\0",
			Color = Theme.Border,
			Thickness = 1,
			Transparency = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		})

		Items["TitleLabel"] = Instances:Create("TextLabel", {
			Parent = Items["MainFrame"].Instance,
			Name = "\0",
			Position = UDim2.new(0, 0, 0, 15),
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Stand Info",
			TextColor3 = Theme.Accent,
			TextSize = TitleSize,
			TextTransparency = 1
		})

		Items["CloseButton"] = Instances:Create("TextButton", {
			Parent = Items["MainFrame"].Instance,
			Name = "\0",
			Position = UDim2.new(1, -40, 0, 10),
			Size = UDim2.new(0, 30, 0, 30),
			BackgroundColor3 = Theme.Element,
			FontFace = Font,
			Text = "X",
			TextColor3 = Theme.Text,
			TextSize = 18,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			TextTransparency = 1
		})

		Instances:Create("UICorner", {
			Parent = Items["CloseButton"].Instance,
			Name = "\0",
			CornerRadius = UDim.new(0, 5)
		})

		Items["CloseStroke"] = Instances:Create("UIStroke", {
			Parent = Items["CloseButton"].Instance,
			Name = "\0",
			Color = Theme.Border,
			Thickness = 1,
			Transparency = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		})

		Instances:Create("Frame", {
			Parent = Items["MainFrame"].Instance,
			Name = "\0",
			Position = UDim2.new(0.08, 0, 0, 60),
			Size = UDim2.new(0.84, 0, 0, 1),
			BackgroundColor3 = Theme.Border,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		})

		Items["InfoContainer"] = Instances:Create("Frame", {
			Parent = Items["MainFrame"].Instance,
			Name = "\0",
			Position = UDim2.new(0, 15, 0, 75),
			Size = UDim2.new(1, -30, 1, -150),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		})

		Instances:Create("UIListLayout", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		Items["StandName"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["StandName"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Name:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["StandNameValue"] = Instances:Create("TextLabel", {
			Parent = Items["StandName"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Accent,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Items["StandSkin"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["StandSkin"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Skin:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["StandSkinValue"] = Instances:Create("TextLabel", {
			Parent = Items["StandSkin"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Items["StandStrength"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["StandStrength"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Strength:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["StandStrengthValue"] = Instances:Create("TextLabel", {
			Parent = Items["StandStrength"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Items["StandSpeed"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["StandSpeed"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Speed:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["StandSpeedValue"] = Instances:Create("TextLabel", {
			Parent = Items["StandSpeed"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Items["StandSpecialty"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["StandSpecialty"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Specialty:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["StandSpecialtyValue"] = Instances:Create("TextLabel", {
			Parent = Items["StandSpecialty"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Items["StandTrait"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["StandTrait"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Personality:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["StandTraitValue"] = Instances:Create("TextLabel", {
			Parent = Items["StandTrait"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 5),
			BackgroundTransparency = 1
		})

		Items["StandArrow"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["StandArrow"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Stand Arrow:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["StandArrowValue"] = Instances:Create("TextLabel", {
			Parent = Items["StandArrow"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Items["LuckyArrow"] = Instances:Create("Frame", {
			Parent = Items["InfoContainer"].Instance,
			Name = "\0",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Instances:Create("TextLabel", {
			Parent = Items["LuckyArrow"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "Lucky Arrow:",
			TextColor3 = Theme.InactiveText,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y
		})

		Items["LuckyArrowValue"] = Instances:Create("TextLabel", {
			Parent = Items["LuckyArrow"].Instance,
			Name = "\0",
			Size = UDim2.new(0.5, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			FontFace = Font,
			Text = "",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			TextXAlignment = Enum.TextXAlignment.Right,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true
		})

		Items["TestButton"] = Instances:Create("TextButton", {
			Parent = Items["MainFrame"].Instance,
			Name = "\0",
			Position = UDim2.new(0.5, 0, 1, -55),
			AnchorPoint = Vector2.new(0.5, 0),
			Size = ButtonSize,
			BackgroundColor3 = Theme.Element,
			FontFace = Font,
			Text = "Auto Roll Stand Toogle",
			TextColor3 = Theme.Text,
			TextSize = TextSize,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			TextTransparency = 1
		})

		Instances:Create("UICorner", {
			Parent = Items["TestButton"].Instance,
			Name = "\0",
			CornerRadius = UDim.new(0, 5)
		})

		Instances:Create("UIGradient", {
			Parent = Items["TestButton"].Instance,
			Name = "\0",
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 216, 216))
			})
		})

		Items["TestButtonStroke"] = Instances:Create("UIStroke", {
			Parent = Items["TestButton"].Instance,
			Name = "\0",
			Color = Theme.Border,
			Thickness = 1,
			Transparency = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		})
	end

	local function CloseUI()
		local TweenData = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		Items["MainFrame"]:Tween(TweenData, {Size = UDim2.new(0, 0, 0, 0)})
		Items["MainStroke"]:Tween(TweenData, {Transparency = 1})
		Items["TitleLabel"]:Tween(TweenData, {TextTransparency = 1})
		Items["CloseButton"]:Tween(TweenData, {BackgroundTransparency = 1, TextTransparency = 1})
		Items["CloseStroke"]:Tween(TweenData, {Transparency = 1})

		for _, v in Items["InfoContainer"].Instance:GetChildren() do
			if v:IsA("Frame") then
				for _, child in v:GetChildren() do
					if child:IsA("TextLabel") then
						TweenService:Create(child, TweenData, {TextTransparency = 1}):Play()
					end
				end
			end
		end

		Items["TestButton"]:Tween(TweenData, {BackgroundTransparency = 1, TextTransparency = 1})
		Items["TestButtonStroke"]:Tween(TweenData, {Transparency = 1})

		if Items["Gui"] then
			Items["Gui"]:Clean()
			Items["Gui"] = nil
		end
	end

	Items["TestButton"]:MakeDraggable()

	Items["TestButton"]:Connect("MouseButton1Click", function()
		RollStand_Toogle:Set(not Flags["Auto Roll Stand"])
	end)

	Items["CloseButton"]:Connect("MouseButton1Click", CloseUI)

	Items["CloseButton"]:Connect("MouseEnter", function()
		Items["CloseButton"]:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 35, 0, 35)})
	end)

	Items["CloseButton"]:Connect("MouseLeave", function()
		Items["CloseButton"]:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 30, 0, 30)})
	end)

	Items["TestButton"]:Connect("MouseEnter", function()
		Items["TestButton"]:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = ButtonSizeHover})
	end)

	Items["TestButton"]:Connect("MouseLeave", function()
		Items["TestButton"]:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = ButtonSize})
	end)

	Items["TestButton"]:Connect("MouseButton1Down", function()
		Items["TestButton"]:Tween(TweenInfo.new(0.08), {Size = ButtonSizeDown})
	end)

	Items["TestButton"]:Connect("MouseButton1Up", function()
		Items["TestButton"]:Tween(TweenInfo.new(0.08), {Size = ButtonSize})
	end)

	Items["MainFrame"]:MakeDraggable()

	Items["MainFrame"]:Tween(TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = FrameSize})

	local TweenInfos = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

	spawn(function()
		wait(0.3)
		Items["MainStroke"]:Tween(TweenInfos, {Transparency = 0})
		Items["TitleLabel"]:Tween(TweenInfos, {TextTransparency = 0})
		Items["CloseButton"]:Tween(TweenInfos, {BackgroundTransparency = 0, TextTransparency = 0})
		Items["CloseStroke"]:Tween(TweenInfos, {Transparency = 0})
		Items["TestButton"]:Tween(TweenInfos, {BackgroundTransparency = 0, TextTransparency = 0})
		Items["TestButtonStroke"]:Tween(TweenInfos, {Transparency = 0})

		for _, a in Items["InfoContainer"].Instance:GetChildren() do
			if a:IsA("Frame") then
				for _, b in a:GetChildren() do
					if b:IsA("TextLabel") then
						TweenService:Create(b, TweenInfos, {TextTransparency = 0}):Play()
					end
				end
			end
		end
	end)

	local function UpdateInfo()
		if not Items["Gui"] then
			return
		end

		local stand_a, stand_b = pcall(function()
			return HttpService:JSONDecode(type2.slot.Stand.Value)
		end)

		if stand_a and stand_b then
			Items["StandNameValue"].Instance.Text = stand_b.Name or "No Stand"
			Items["StandSkinValue"].Instance.Text = stand_b.Skin or "Default"
			Items["StandStrengthValue"].Instance.Text = tostring(stand_b.Strength) or "0"
			Items["StandSpeedValue"].Instance.Text = tostring(stand_b.Speed) or "0"
			Items["StandSpecialtyValue"].Instance.Text = tostring(stand_b.Specialty) or "0"
			Items["StandTraitValue"].Instance.Text = (stand_b.Trait or "None") .. " [" .. (type1.PersonalityData[stand_b.Trait] or "N/A") .. "]"
			Items["StandArrowValue"].Instance.Text = tostring(type4.GetInventory("Stand Arrow")) or "0"
			Items["LuckyArrowValue"].Instance.Text = tostring(type4.GetInventory("Lucky Arrow")) or "0"
		else
			Items["StandNameValue"].Instance.Text = "No Stand"
			Items["StandSkinValue"].Instance.Text = "N/A"
			Items["StandStrengthValue"].Instance.Text = "N/A"
			Items["StandSpeedValue"].Instance.Text = "N/A"
			Items["StandSpecialtyValue"].Instance.Text = "N/A"
			Items["StandTraitValue"].Instance.Text = "N/A"
			Items["StandArrowValue"].Instance.Text = "N/A"
			Items["LuckyArrowValue"].Instance.Text = "N/A"
		end
	end

	UpdateInfo()

	spawn(function()
		while wait(0.3) do
			if Items["Gui"] then
				UpdateInfo()
			else
				return
			end
		end
	end)
end

repeat wait(0.3) until ReplicatedStorage:FindFirstChild("requests") and ReplicatedStorage.requests:FindFirstChild("character") and ReplicatedStorage.requests.character:FindFirstChild("raid_shop")

type4.InsertTasks(spawn(function()
	while wait(0.3) do
		local main_menu = PlayerGUI:FindFirstChild("Main Menu")

		if main_menu then
			ReplicatedStorage.requests.character.spawn:FireServer()
			wait(3)
			Debris:AddItem(main_menu, 0)
			wait()
			return
		else 
			return
		end
	end
end))

local VIRTUALIZE558 = LPH_NO_VIRTUALIZE(function(data)
	if type(data) == "table" and data.Type == "UpdateRaidShop" then
		getgenv().RaidShop = table.clone(data.RaidShop)
	end
end)

type4.InsertConnections(ReplicatedStorage.requests.character.raid_shop.OnClientEvent:Connect(VIRTUALIZE558))

repeat wait(0.3) until plr and char and Library and Library.Flags and plr:GetAttribute("Loaded") and not PlayerGUI:FindFirstChild("Main Menu")

type1 = {
	MobData = {
		["Delinquent"] = {1, CFrame.new(1482.071, 901.103, -574.649)},
		["Thug"] = {2, CFrame.new(834.016, 916.893, -406.566)},
		["Okuyasu Nijimura"] = {3, CFrame.new(2194.647, 874.663, -444.199)},
		["Corrupt Police Officer"] = {4, CFrame.new(1195.878, 908.492, -866.173)},
		["Toyohiro"] = {5, CFrame.new(483.568, 896.896, -901.386)},
		["Yakuza"] = {6, CFrame.new(1465.97, 905.41, -227.715)},
		["Akira Otoishi"] = {7, CFrame.new(-1634.449, 920.649, 996.819)},
		["Mafia Member"] = {8, CFrame.new(-1634.449, 920.649, 996.819)},
		["Prison Escapee"] = {9, CFrame.new(840.01, 915.893, -579.991)},
		["Thief"] = {10, CFrame.new(1657.999, 905.103, -271.98)},
		["Zombie Grunt"] = {11, CFrame.new(798.252, 913.303, -772.738)},
		["Josuke Higashikata"] = {12, CFrame.new(477.956, 886.418, -183.685)},
		["Boxer"] = {13, CFrame.new(1082.868, 941.69, 10.78)},
		["Boxing Coach"] = {14, CFrame.new(1082.868, 941.69, 10.78)},
		["Vampire"] = {15, CFrame.new(2249.828, 940.109, 1453.347)},
		["Yoshikage Kira"] = {16, CFrame.new(807.741, 915.291, 62.577)},
		["Cultist"] = {17, CFrame.new(2249.828, 940.109, 1453.347)},
		["Cultist Leaders"] = {18, CFrame.new(2249.828, 940.109, 1453.347)},
		["Zombie"] = {19, CFrame.new(2249.828, 940.109, 1453.347)},
		["Yoshikage Kira Bites the Dust"] = {20, CFrame.new(1020.549, 905.103, -652.344)},
		["Okuyasu Nijimura PRIME"] = {21, CFrame.new(2330.727, 883.017, 392.013)},
		["Rock Human"] = {22, CFrame.new(1466.19, 961.247, 1930.983)},
		["Miyamoto Musashi"] = {23, CFrame.new(476.1, 887.694, -73.226)},
		["Samurai"] = {24, CFrame.new(2071.067, 879.648, -37.998)},
		["Samurai Master"] = {25, CFrame.new(2071.067, 874.648, -37.998)},
		["Rogue Rock Human"] = {26, CFrame.new(1423.591, 944.862, 2130.069)},
		["Zombie Rudol von Stroheim"] = {27, CFrame.new(1872.018, 956.799, 1895.535)},
		["Speedwagon Agent"] = {28, CFrame.new(1161.501, 879.318, -348.017)},
		["Elder Vampire"] = {29, CFrame.new(2249.828, 940.109, 1453.347)},
		["Cyborg"] = {30, CFrame.new(2249.828, 940.109, 1453.347)},
		["Zombie Cyborg"] = {31, CFrame.new(2249.828, 940.109, 1453.347)},
		["Spin User"] = {32, CFrame.new(1082.868, 941.69, 10.78)},
		["Night Vampire"] = {33, CFrame.new(2249.828, 940.109, 1453.347)},
		["Dr. Bosconovitch"] = {34, CFrame.new(2249.828, 940.109, 1453.347)},
		["Hamon Apprentice"] = {35, CFrame.new(1082.868, 941.69, 10.78)},
		["Hamon Master"] = {36, CFrame.new(1082.868, 941.69, 10.78)},
		["Elite Vampire"] = {37, CFrame.new(2249.828, 940.109, 1453.347)},
		["Elite Mafia Member"] = {38, CFrame.new(-1634.449, 920.649, 996.819)}
	},

	BossData = {
		["Akira Otoishi"] = {7, CFrame.new(-1634.449, 920.649, 996.819)},
		["Yoshikage Kira"] = {16, CFrame.new(807.741, 915.291, 62.577)},
		["Okuyasu Nijimura PRIME"] = {21, CFrame.new(2330.727, 883.017, 392.013)},
		["Miyamoto Musashi"] = {23, CFrame.new(476.1, 887.694, -73.226)},
		["Zombie Rudol von Stroheim"] = {27, CFrame.new(1872.018, 956.799, 1895.535)},
		["Dr. Bosconovitch"] = {34, CFrame.new(2249.828, 940.109, 1453.347)}
	},

	RaidData = {
		["Muhammad Avdol"] = {1, "Muhammad Avdol"},
		["Jotaro Kujo"] = {2, "Chumbo"},
		["DIO"] = {3, "???"},
		["Yoshikage Kira Bites the Dust"] = {4, "Yoshikage Kira"},
		["Heaven Ascension DIO"] = {5, "Heaven Ascension DIO"},
		["Prison Escape"] = {6, "Prison Escape Raid"},
		["Death 13"] = {7, "Death 13 Raid"}
	},

	StandData = {
		["Anubis"] = "Common",
		["Red Hot Chili Pepper"] = "Common",
		["Silver Chariot"] = "Common",
		["The Hand"] = "Common",

		["Crazy Diamond"] = "Uncommon",
		["Magician's Red"] = "Uncommon",
		["Purple Haze"] = "Uncommon",

		["Gold Experience"] = "Rare",
		["Killer Queen"] = "Rare",
		["Stone Free"] = "Rare",
		["Weather Report"] = "Rare",

		["King Crimson"] = "Legendary",
		["Star Platinum"] = "Legendary",
		["The World"] = "Legendary",
		["The World, High Voltage"] = "Legendary",

		["Whitesnake"] = "Mythical"
	},

	SkinData = {
		"Greyscale (Red Hot Chili Pepper)",
		"Purple (Red Hot Chili Pepper)",
		"Yoruichi (Red Hot Chili Pepper)",

		"Greyscale (The Hand)",
		"Purple (The Hand)",

		"Greyscale (Purple Haze)",
		"Poison (Purple Haze)",
		"Purple Monarch (Purple Haze)",

		"Greyscale (Crazy Diamond)",
		"Luffy (Crazy Diamond)",
		"Reverso (Crazy Diamond)",
		"Light Armored (Crazy Diamond)",
		"Dark Armored (Crazy Diamond)",

		"Greyscale (Magician's Red)",
		"King (Magician's Red)",
		"Orange (Magician's Red)",
		"Sun Deity (Magician's Red)",
		"Greyscale (Gold Experience)",
		"Green (Gold Experience)",
		"Atom Eve (Gold Experience)",

		"Greyscale (Killer Queen)",
		"Bomb Devil (Killer Queen)",
		"One Who Laughs (Killer Queen)",
		"Tan (Killer Queen)",

		"Greyscale (Stone Free)",
		"Makima (Stone Free)",
		"Turqoise (Stone Free)",
		"Carnage (Stone Free)",
		"Ultimate Makima (Stone Free)",

		"Greyscale (Weather Report)",
		"Esdeath (Weather Report)",
		"Nami (Weather Report)",
		"Pinky (Weather Report)",
		"Fubuki (Weather Report)",

		"Greyscale (King Crimson)",
		"Blue (King Crimson)",
		"Deimos (King Crimson)",
		"Kawaii (King Crimson)",
		"Omni Man (King Crimson)",
		"Igris (King Crimson)",
		"Sukuna (King Crimson)",

		"Greyscale (Star Platinum)",
		"Deimos (Star Platinum)",
		"Galaxy Garou (Star Platinum)",
		"Kawaii (Star Platinum)",

		"Greyscale (The World)",
		"Dark (The World)",
		"Egyptian (The World)",
		"Goku (The World)",
		"Kawaii (The World)",
		"Comic Omni Man (The World)",

		"Greyscale (The World, High Voltage)",
		"Lima (The World, High Voltage)",
		"Baby SJW (The World, High Voltage)",
		"Violence (The World, High Voltage)",
		"Prestige (The World, High Voltage)",
		"GOD SJW (The World, High Voltage)",

		"Greyscale (Whitesnake)",
		"Ryuk (Whitesnake)",
		"Velvet (Whitesnake)"
	},

	StatRollData = {
		["D"] = 1,
		["C"] = 2,
		["B"] = 3,
		["A"] = 4,
		["S"] = 5
	},

	PersonalityData = {
		["Arrogant"] = "Common",
		["Cowardly"] = "Common",
		["Energetic"] = "Common",
		["Erratic"] = "Common",
		["Firm"] = "Common",
		["Happy"] = "Common",

		["Astute"] = "Uncommon",
		["Curious"] = "Uncommon",
		["Kind"] = "Uncommon",
		["Predictive"] = "Uncommon",

		["Compassionate"] = "Rare",
		["Determined"] = "Rare",
		["Durable"] = "Rare",
		["Fearful"] = "Rare",
		["Furious"] = "Rare",
		["Slugger"] = "Rare",

		["Artistic"] = "Legendary",
		["Cursed"] = "Legendary",
		["Dominant"] = "Legendary",
		["Methodical"] = "Legendary",
		["Rhythmic"] = "Legendary",
		["Suffocating"] = "Legendary",

		["Demonic"] = "Mythical",
		["Elegant"] = "Mythical",
		["Feral"] = "Mythical",
		["Transcendent"] = "Mythical"
	},

	ItemData = {
		["Stand Arrow"] = "Uncommon",

		["Stone Mask"] = "Rare",

		["Lucky Arrow"] = "Legendary",
	},

	ChestData = {
		["Common Chest"] = "Common",

		["Rare Chest"] = "Rare",

		["Legendary Chest"] = "Legendary"
	},

	CraftRequirementData = {
		["Plank Skateboard"] = {
			["Leather"] = 5,
			["Stand Arrow"] = 1,
			["Fabric"] = 5,
			["Common Chest"] = 3
		},

		["Rare Chest"] = {
			["Acid"] = 1,
			["Ruby"] = 10,
			["Opal"] = 10,
			["Sapphire"] = 10,
			["Gold Fragments"] = 10,
			["Lost Spirit"] = 1,
			["Silver Fragments"] = 10,
			["Bronze Fragments"] = 10
		},

		["Common Chest"] = {
			["Acid"] = 1,
			["Ruby"] = 1,
			["Opal"] = 1,
			["Bronze Fragments"] = 10,
			["Sapphire"] = 1,
			["Fabric"] = 10,
			["Leather"] = 10
		},

		["Luck & Pluck"] = {
			["Vampire Fang"] = 3,
			["Gold Fragments"] = 10,
			["Silver Fragments"] = 15,
			["Imperfect Aja"] = 1,
			["Leather"] = 20,
			["RequiresRecipe"] = true,
			["Bronze Fragments"] = 20,
			["Lost Spirit"] = 2,
			["Legendary Chest"] = 3,
			["Meteor Fragments"] = 1
		},

		["Motorcycle"] = {
			["Bones"] = 1,
			["Lost Spirit"] = 1,
			["Silver Fragments"] = 10,
			["Motorcycle Tire"] = 2,
			["Stone Mask"] = 1,
			["Skulls"] = 1,
			["Motorcycle Body"] = 1
		},

		["Meteorite Arrow"] = {
			["Mysterious Arrow"] = 1,
			["Meteor Fragments"] = 1
		},

		["The Singularity"] = {
			["DIO's Diary"] = 1,
			["Heaven Ascended Elixir"] = 5,
			["Mysterious Arrow"] = 1,
			["Deep Stone"] = 1,
			["Nightmare Soul"] = 1,
			["Darkened Soul"] = 1
		},

		["Death 13 Tarot Card"] = {
			["Nightmare Soul"] = 1,
			["Mysterious Arrow"] = 1
		},

		["Legendary Chest"] = {
			["Opal"] = 20,
			["Sapphire"] = 20,
			["Acid"] = 1,
			["Ruby"] = 20,
			["Bronze Fragments"] = 20,
			["Cosmic Radiation"] = 1,
			["Lost Spirit"] = 3,
			["Gold Fragments"] = 15,
			["Silver Fragments"] = 15
		},

		["Elemental Essence"] = {
			["Heaven Ascended Elixir"] = 3,
			["Cosmic Radiation"] = 1,
			["Ice Essence"] = 15,
			["Flame Essence"] = 15,
			["Imperfect Aja"] = 1
		},

		["Shadow Axe"] = {
			["Bones"] = 1,
			["RequiresRecipe"] = true,
			["Silver Fragments"] = 10,
			["Vampire Fang"] = 1,
			["Stone Mask"] = 1,
			["Skulls"] = 1,
			["Lost Spirit"] = 1
		},

		["Deep Dive Arrow"] = {
			["Deep Stone"] = 1,
			["Mysterious Arrow"] = 1
		}
	},

	CraftData = {
		["Plank Skateboard"] = "Common",
		["Rare Chest"] = "Rare",
		["Common Chest"] = "Common",
		["Luck & Pluck"] = "Rare",
		["Motorcycle"] = "Rare",
		["Meteorite Arrow"] = "Mythical",
		["The Singularity"] = "Secret",
		["Death 13 Tarot Card"] = "Legendary",
		["Legendary Chest"] = "Legendary",
		["Elemental Essence"] = "Secret",
		["Shadow Axe"] = "Rare",
		["Deep Dive Arrow"] = "Mythical"
	},

	AccessoriesRarityData = {
		Common = {
			"Arm Wraps",
			"Balaclava",
			"Black Jacket",
			"Blue Belt",
			"Eye Patch",
			"Green Belt",
			"Grey Jacket",
			"Hood",
			"Mask",
			"Orange Belt",
			"Plain White Scarf",
			"Purple Belt",
			"Red Belt",
			"Shades",
			"Simple Cape",
			"White Belt",
			"White Jacket",
			"Yellow Belt"
		},

		Uncommon = {
			"Bandage Mask",
			"Baseball Cap",
			"Biker Chain",
			"Brown Belt",
			"Face Goggles",
			"Gold Crown",
			"Grey Topcoat",
			"Head Goggles",
			"Red Topcoat",
			"Sailor Boy",
			"Sailor Uniform",
			"White Topcoat"
		},

		Rare = {
			"Black Belt",
			"Black Ripped Jacket",
			"Boxing Gloves",
			"Chef's Hat",
			"Crimson Ripped Jacket",
			"Cultist Cowl",
			"Cultist Hood",
			"Dark Cowl",
			"Fancy White Scarf",
			"Fighter Hand Wraps",
			"Full Bandage Mask",
			"Green Ripped Jacket",
			"Oni Beads",
			"Pink Choker",
			"Police Cap",
			"Ruby Earrings",
			"Straw Hat",
			"Ushanka",
			"White Ripped Jacket"
		},

		Legendary = {
			"American Flag Cape",
			"Beetle Earrings",
			"Black Overcoat",
			"Bowler Hat",
			"Chain Arm Wraps",
			"Crimson Overcoat",
			"Flaming Medallion Necklace",
			"Futuristic Goggles",
			"Inversion Cape",
			"Jolyne's Earrings",
			"Jotaro's Coat",
			"Jotaro's Coat, Stone Ocean",
			"Jotaro's Hat",
			"Kira's Coat",
			"Money Chain",
			"Oni Mask",
			"Roundabout Cape",
			"Sailor Hat",
			"Safari Hat",
			"Spiked Choker",
			"Strawberry Tie",
			"White Overcoat"
		},

		Mythical = {
			"Crucifix Pendant",
			"Diego's Hat",
			"Disc Belt",
			"Double Belt",
			"Graviton Bands",
			"Heart Headband",
			"Heaven Ascended Belt",
			"Heaven Ascended Necklace",
			"Jotaro's Hat, Stone Ocean",
			"Prime Jotaro's Coat",
			"Prime Jotaro's Hat",
			"Skull Tie",
			"Swaggy Glasses",
			"The Bosses Watch",
			"White Fur Hat"
		},

		Secret = {
			"Cultist Cowl",
			"Heaven Ascended Arm Bands",
			"Heaven Ascended Belt",
			"Heaven Ascended Necklace",
			"Jotaro's Coat, Stone Ocean",
			"Pocoloco's Hat",
			"Pocket Diary",
			"Pucci's Coat",
			"Pucci's Hat",
			"Soul Resonance Belt",
			"Soul Resonance Hat",
			"Speedwagon's Hat",
			"The Eye of Ra"
		}
	},

	AccessoriesNameData = {
		["Black Belt"] = "Rare",
		["Black Ripped Jacket"] = "Rare",
		["Boxing Gloves"] = "Rare",
		["Chef's Hat"] = "Rare",
		["Crimson Ripped Jacket"] = "Rare",
		["Cultist Cowl"] = "Rare",
		["Cultist Hood"] = "Rare",
		["Dark Cowl"] = "Rare",
		["Fancy White Scarf"] = "Rare",
		["Fighter Hand Wraps"] = "Rare",
		["Full Bandage Mask"] = "Rare",
		["Green Ripped Jacket"] = "Rare",
		["Oni Beads"] = "Rare",
		["Pink Choker"] = "Rare",
		["Police Cap"] = "Rare",
		["Ruby Earrings"] = "Rare",
		["Straw Hat"] = "Rare",
		["Ushanka"] = "Rare",
		["White Ripped Jacket"] = "Rare",

		["American Flag Cape"] = "Legendary",
		["Beetle Earrings"] = "Legendary",
		["Black Overcoat"] = "Legendary",
		["Bowler Hat"] = "Legendary",
		["Chain Arm Wraps"] = "Legendary",
		["Crimson Overcoat"] = "Legendary",
		["Flaming Medallion Necklace"] = "Legendary",
		["Futuristic Goggles"] = "Legendary",
		["Inversion Cape"] = "Legendary",
		["Jolyne's Earrings"] = "Legendary",
		["Jotaro's Coat"] = "Legendary",
		["Jotaro's Coat, Stone Ocean"] = "Legendary",
		["Jotaro's Hat"] = "Legendary",
		["Kira's Coat"] = "Legendary",
		["Money Chain"] = "Legendary",
		["Oni Mask"] = "Legendary",
		["Roundabout Cape"] = "Legendary",
		["Sailor Hat"] = "Legendary",
		["Safari Hat"] = "Legendary",
		["Spiked Choker"] = "Legendary",
		["Strawberry Tie"] = "Legendary",
		["White Overcoat"] = "Legendary",

		["Crucifix Pendant"] = "Mythical",
		["Diego's Hat"] = "Mythical",
		["Disc Belt"] = "Mythical",
		["Double Belt"] = "Mythical",
		["Graviton Bands"] = "Mythical",
		["Heart Headband"] = "Mythical",
		["Heaven Ascended Belt"] = "Mythical",
		["Heaven Ascended Necklace"] = "Mythical",
		["Jotaro's Hat, Stone Ocean"] = "Mythical",
		["Prime Jotaro's Coat"] = "Mythical",
		["Prime Jotaro's Hat"] = "Mythical",
		["Skull Tie"] = "Mythical",
		["Swaggy Glasses"] = "Mythical",
		["The Bosses Watch"] = "Mythical",
		["White Fur Hat"] = "Mythical",

		["Cultist Cowl"] = "Secret",
		["Heaven Ascended Arm Bands"] = "Secret",
		["Heaven Ascended Belt"] = "Secret",
		["Heaven Ascended Necklace"] = "Secret",
		["Jotaro's Coat, Stone Ocean"] = "Secret",
		["Pocoloco's Hat"] = "Secret",
		["Pocket Diary"] = "Secret",
		["Pucci's Coat"] = "Secret",
		["Pucci's Hat"] = "Secret",
		["Soul Resonance Belt"] = "Secret",
		["Soul Resonance Hat"] = "Secret",
		["Speedwagon's Hat"] = "Secret",
		["The Eye of Ra"] = "Secret"
	},

	PipData = {
		["Health"] = 1,
		["HealthRegeneration"] = 2,
		["Defense"] = 3,
		["Power"] = 4,
		["PowerRegeneration"] = 5,
		["Penetration"] = 6,
		["PvEDamage"] = 7
	},

	ShopData = {
		["Bronze Fragments"] = "Common",
		["Acid"] = "Common",
		["Leather"] = "Common",
		["Fabric"] = "Common",

		["Stand Arrow"] = "Uncommon",
		["Low Level Keycard"] = "Uncommon",
		["Ruby"] = "Uncommon",
		["Bones"] = "Uncommon",
		["Sapphire"] = "Uncommon",
		["Silver Fragments"] = "Uncommon",
		["Opal"] = "Uncommon",

		["Vampire Fang"] = "Rare",
		["Stone Mask"] = "Rare",
		["Flame Essence"] = "Rare",
		["Gold Fragments"] = "Rare",
		["Skulls"] = "Rare",
		["Gold Coins"] = "Rare",
		["Enchanted Stone"] = "Rare",
		["Ice Essence"] = "Rare",
		["Manga Manuscripts"] = "Rare",

		["DIO's Bone"] = "Legendary",
		["Deep Stone"] = "Legendary",
		["Lost Spirit"] = "Legendary",
		["High Level Keycard"] = "Legendary",
		["Lucky Arrow"] = "Legendary",
		["Death 13 Tarot Card"] = "Legendary",

		["Meteorite Arrow"] = "Mythical",
		["Stand Conjuration Essence"] = "Mythical",
		["Heaven Ascended Elixir"] = "Mythical",
		["Stat Point Essence"] = "Mythical",
		["Stand Personality Essence"] = "Mythical",
		["Stand Stat Essence"] = "Mythical",
		["Requiem Arrow"] = "Mythical",
		["Meteor Fragments"] = "Mythical",
		["Darkened Soul"] = "Mythical",
		["Cosmic Radiation"] = "Mythical",
		["Nightmare Soul"] = "Mythical",
		["Imperfect Aja"] = "Mythical",
		["Green Baby"] = "Mythical",
		["Deep Dive Arrow"] = "Mythical",

		["Mysterious Arrow"] = "Secret",
		["Custom Clothing Essence"] = "Secret",
		["Lucky Personality Essence"] = "Secret",
		["Stand Skin Essence"] = "Secret",
		["Face Reroll"] = "Secret",
		["The Singularity"] = "Secret",
		["Elemental Essence"] = "Secret",

		["Common Chest"] = "Common",
		["Rare Chest"] = "Rare",
		["Legendary Chest"] = "Legendary"
	},

	RarityData = {
		["Common"] = 1,
		["Uncommon"] = 2,
		["Rare"] = 3,
		["Legendary"] = 4,
		["Mythical"] = 5,
		["Secret"] = 6,
		["Special"] = 7
	},

	MissionList = {
		"Left PvP Mission Queue",
		"Left PvE Mission Queue",
		"Mission Complete",
		"Mission Failed"
	},

	WorldEventList = {
		"World Event Complete!",
		"This World Event has expired",
		"You have been Eliminated. If your team wins, you will still receive Rewards"
	},

	PlayerList = {},
	PlayerSelect = {},

	MobList = {},
	MobDisplay = {},
	MobSelect = {},

	BossList = {},
	BossDisplay = {},
	BossSelect = {},

	SkillList = {"E", "R", "Z", "X", "C", "V"},
	SkillSelect = {},
	SkillGrabSelect = {},

	AbilityList = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
	AbilitySelect = {},
	AbilityGrabSelect = {},

	RaidList = {},
	RaidDisplay = {},
	RaidSelect = {},

	WorkoutList = {"Bench Press", "Dumbbells", "Situps", "Squat Rack", "Treadmill"},
	WorkoutSelect = {},

	StandList = {},
	StandDisplay = {},
	StandSelect = {},

	SkinList = {},
	SkinDisplay = {},
	SkinSelect = {},

	StatRollList = {},
	StatRollDisplay = {},

	StandStrengthSelect = {},
	StandSpeedSelect = {},
	StandSpecialtySelect = {},
	StandPersonalitySelect = {},

	PersonalityList = {},
	PersonalityDisplay = {},
	PersonalitySelect = {},

	ItemList = {},
	ItemDisplay = {},
	ItemSelect = {},

	ChestList = {},
	ChestDisplay = {},
	ChestSelect = {},

	CraftList = {},
	CraftDisplay = {},
	CraftSelect = {},

	AccessoriesRarityList = {},
	AccessoriesRarityDisplay = {},
	AccessoriesRaritySelect = {},

	AccessoriesNameList = {},
	AccessoriesNameDisplay = {},
	AccessoriesNameSelect = {},

	PipList = {},
	PipDisplay = {},
	PipSelect = {},

	AccessoriesKeepSelect = {},
	PipKeepSelect = {},

	ShopList = {},
	ShopDisplay = {},

	CashShopSelect = {},
	GangShopSelect = {},
	RaidShopSelect = {},

	OpenShopList = {},
	OpenShopDisplay = {},
	OpenShopSelect = {},

	StatList = {"Strength", "Defense", "Power", "Weapon", "Destructive Power", "Destructive Energy"},
	StatSelect = {},

	CodeList = {"Delay1", "Delay2", "Delay3", "Update1", "BizarreLineage1", "LikeTheGameForMore1", "Update2=2027", "250kLikes", "500kLikes", "750LikesforNextCode"},

	CooldownList = {},

	BusList = {},

	NPCList = {},

	ChangeSkinList = {}
}

type2 = {
	slot = plr.PlayerData:WaitForChild("SlotData"),

	character = ReplicatedStorage:WaitForChild("requests"):WaitForChild("character"),
	general = ReplicatedStorage:WaitForChild("requests"):WaitForChild("general"),
	get = ReplicatedStorage:WaitForChild("requests"):WaitForChild("miscellaneous"):WaitForChild("get_data"),
	redeemcode = ReplicatedStorage:WaitForChild("requests"):WaitForChild("general"):WaitForChild("redeemcode"),
}

type3 = {
	WorldEvent = false,

	MapName = "",

	BossHealth = {},
	BossMaxHealth = {},

	BossPhase2 = {},
	CanInstant = {},

	CanRetry = false,

	PvP = false,
	PvE = false,

	GangContract = false,

	IsFlying = false,
	KeyDown = nil,
	KeyUp = nil,
	Loop = nil,

	Velocity = nil,
	Gyro = nil,

	Connection1 = nil,
	Connection2 = nil
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local maps = type4.FindPath(Workspace, "Map")
local buses = type4.FindPath(Workspace, "Map", "Bus Stops")
local npcs1 = type4.FindPath(Workspace, "Npcs")
local npcs2 = type4.FindPath(ReplicatedStorage, "assets", "npc_cache")
local skin1 = type4.FindPath(ReplicatedStorage, "assets", "models", "stands")
local skin2 = type4.FindPath(ReplicatedStorage, "assets", "models", "stands", "Skins")

if maps then
	for _, child in maps:GetDescendants() do
		if child.Name == "Gamemode Rooms" then
			type3.MapName = child.Parent.Name
			break
		end
	end
end

if buses then
	for i = 1, 19 do
		table.insert(type1.BusList, tostring(i))
	end
end

if npcs1 then
	for _, npc in npcs1:GetChildren() do
		if npc:IsA("Model") and not table.find(type1.NPCList, npc.Name) then
			table.insert(type1.NPCList, npc.Name)
		end
	end
	table.sort(type1.NPCList)
end

if npcs2 then
	for _, npc in npcs2:GetChildren() do
		if npc:IsA("Model") and not table.find(type1.NPCList, npc.Name) then
			table.insert(type1.NPCList, npc.Name)
		end
	end
	table.sort(type1.NPCList)
end

if skin1 then
	for _, skin in skin1:GetChildren() do
		if skin:IsA("Model") and not table.find(type1.ChangeSkinList, skin.Name) then
			table.insert(type1.ChangeSkinList, skin.Name)
		end
	end
	table.sort(type1.ChangeSkinList)
end

if skin2 then
	for _, skin in skin2:GetChildren() do
		if skin:IsA("Model") and not table.find(type1.ChangeSkinList, skin.Name) then
			table.insert(type1.ChangeSkinList, skin.Name)
		end
	end
	table.sort(type1.ChangeSkinList)
end

for mob_name, mob_data in type1.MobData do
	if mob_data then
		table.insert(type1.MobList, {
			Name = mob_name,
			Index = mob_data[1],
			CFrame = mob_data[2],
			Display = string.format("%s [%d]", mob_name, mob_data[1])
		})
	end
end

table.sort(type1.MobList, function(mob_a, mob_b)
	return (mob_a.Index or 0) < (mob_b.Index or 0)
end)

for _, mob in type1.MobList do
	table.insert(type1.MobDisplay, mob.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for boss_name, boss_data in type1.BossData do
	if boss_data then
		table.insert(type1.BossList, {
			Name = boss_name,
			Index = boss_data[1],
			CFrame = boss_data[2],
			Display = string.format("%s [%d]", boss_name, boss_data[1])
		})
	end
end

table.sort(type1.BossList, function(boss_a, boss_b)
	return (boss_a.Index or 0) < (boss_b.Index or 0)
end)

for _, boss in type1.BossList do
	table.insert(type1.BossDisplay, boss.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for raid_name, raid_data in type1.RaidData do
	if raid_data then
		table.insert(type1.RaidList, {
			Name = raid_name,
			Index = raid_data[1],
			Value = raid_data[2],
			Display = string.format("%s [%d]", raid_name, raid_data[1])
		})
	end
end

table.sort(type1.RaidList, function(raid_a, raid_b)
	return (raid_a.Index or 0) < (raid_b.Index or 0)
end)

for _, raid in type1.RaidList do
	table.insert(type1.RaidDisplay, raid.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for stand_name, stand_rarity in type1.StandData do
	if stand_rarity then
		table.insert(type1.StandList, {
			Name = stand_name,
			Rarity = stand_rarity,
			Display = string.format("%s [%s]", stand_name, stand_rarity)
		})
	end
end

table.sort(type1.StandList, function(stand_a, stand_b)
	return (type1.RarityData[stand_a.Rarity] or 0) > (type1.RarityData[stand_b.Rarity] or 0)
end)

for _, stand in type1.StandList do
	table.insert(type1.StandDisplay, stand.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for stat_name, stat_rarity in pairs(type1.StatRollData) do
	table.insert(type1.StatRollList, {
		Name = stat_name,
		Rarity = stat_rarity,
		Display = string.format("%s [%s]", stat_name, stat_rarity)
	})
end

table.sort(type1.StatRollList, function(stat_a, stat_b)
	return (stat_a.Rarity or 0) > (stat_b.Rarity or 0)
end)

for _, stat in type1.StatRollList do
	table.insert(type1.StatRollDisplay, stat.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for personality_name, personality_rarity in type1.PersonalityData do
	if personality_rarity then
		table.insert(type1.PersonalityList, {
			Name = personality_name,
			Rarity = personality_rarity,
			Display = string.format("%s [%s]", personality_name, personality_rarity)
		})
	end
end

table.sort(type1.PersonalityList, function(personality_a, personality_b)
	return (type1.RarityData[personality_a.Rarity] or 0) > (type1.RarityData[personality_b.Rarity] or 0)
end)

for _, personality in type1.PersonalityList do
	table.insert(type1.PersonalityDisplay, personality.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for item_name, item_data in type1.ItemData do
	if item_data then
		table.insert(type1.ItemList, {
			Name = item_name,
			Rarity = item_data,
			Display = string.format("%s [%s]", item_name, item_data)
		})
	end
end

table.sort(type1.ItemList, function(item_a, item_b)
	return (type1.RarityData[item_a.Rarity] or 0) > (type1.RarityData[item_b.Rarity] or 0)
end)

for _, item in type1.ItemList do
	table.insert(type1.ItemDisplay, item.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for chest_name, chest_rarity in type1.ChestData do
	if chest_rarity then
		table.insert(type1.ChestList, {
			Name = chest_name,
			Rarity = chest_rarity,
			Display = string.format("%s [%s]", chest_name, chest_rarity)
		})
	end
end

table.sort(type1.ChestList, function(chest_a, chest_b)
	return (type1.RarityData[chest_a.Rarity] or 0) < (type1.RarityData[chest_b.Rarity] or 0)
end)

for _, chest in type1.ChestList do
	table.insert(type1.ChestDisplay, chest.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for craft_name, craft_rarity in type1.CraftData do
	if craft_name and craft_rarity then
		table.insert(type1.CraftList, {
			Name = craft_name,
			Rarity = craft_rarity,
			Display = string.format("%s [%s]", craft_name, craft_rarity)
		})
	end
end

table.sort(type1.CraftList, function(acc_a, acc_b)
	return (type1.RarityData[acc_a.Rarity] or 0) < (type1.RarityData[acc_b.Rarity] or 0)
end)

for _, craft_name in type1.CraftList do
	table.insert(type1.CraftDisplay, craft_name.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for rarity_name, rarity_index in type1.RarityData do
	if rarity_name and rarity_index then
		table.insert(type1.AccessoriesRarityList, {
			Name = rarity_name,
			Index = rarity_index,
			Display = rarity_name
		})
	end
end

table.sort(type1.AccessoriesRarityList, function(rarity_a, rarity_b)
	return (rarity_a.Index or 0) < (rarity_b.Index or 0)
end)

for _, accessories_rarity in type1.AccessoriesRarityList do
	table.insert(type1.AccessoriesRarityDisplay, accessories_rarity.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for acc_name, acc_rarity in type1.AccessoriesNameData do
	if acc_name and acc_rarity then
		table.insert(type1.AccessoriesNameList, {
			Name = acc_name,
			Rarity = acc_rarity,
			Display = string.format("%s [%s]", acc_name, acc_rarity)
		})
	end
end

table.sort(type1.AccessoriesNameList, function(acc_a, acc_b)
	return (type1.RarityData[acc_a.Rarity] or 0) < (type1.RarityData[acc_b.Rarity] or 0)
end)

for _, accessories_name in type1.AccessoriesNameList do
	table.insert(type1.AccessoriesNameDisplay, accessories_name.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for pip_name, pip_index in type1.PipData do
	if pip_name and pip_index then
		table.insert(type1.PipList, {
			Name = pip_name,
			Index = pip_index,
			Display = string.format("%s [%d]", pip_name, pip_index)
		})
	end
end

table.sort(type1.PipList, function(pip_a, pip_b)
	return (pip_a.Index or 0) < (pip_b.Index or 0)
end)

for _, pip in type1.PipList do
	table.insert(type1.PipDisplay, pip.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

for name, rarity in type1.ShopData do
	if rarity then
		table.insert(type1.ShopList, {
			Name = name,
			Rarity = rarity,
			Display = string.format("%s [%s]", name, rarity)
		})
	end
end

table.sort(type1.ShopList, function(a, b)
	return (type1.RarityData[a.Rarity] or 0) < (type1.RarityData[b.Rarity] or 0)
end)

for _, shop in type1.ShopList do
	table.insert(type1.ShopDisplay, shop.Display)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function type4.FarmNearest() 
	if not mob or not type4.IsActive(mob) then 
		mob = type4.GetMob(nil, Flags["Range to Detect"]) 
	end 

	if mob and type4.IsActive(mob) then 
		type4.TP(type4.CanTP(mob) * type4.GetMethod()) 	 

		if type4.IsGood(mob) then 
			type4.Ability() type4.Skill() type4.M1() 
		end 
		return true 
	else 
		mob = nil
		return false
	end 
	return false 
end 

function type4.FarmPlayer() 
	if not player or not type4.IsActive(player) then 
		player = type4.GetPlayer(Flags["Select Player to Farm"]) 
	end 

	if player and type4.IsActive(player) then 
		type4.TP(type4.CanTP(player) * type4.GetMethod()) 	 

		if not player:FindFirstChild("IFrame") then 
			type4.Ability() type4.Skill() type4.M1() 
		end 
		return true 
	else 
		player = nil
		return false 
	end 
	return false 
end

function type4.FarmMob() 
	local mob_name = Flags["Select Mob to Farm"]:match("^(.-) %[[^%]]+%]$") 

	if not mob or not type4.IsActive(mob) then 
		mob = type4.GetMob(mob_name) 
	end 

	if mob and type4.IsActive(mob) then 
		type4.TP(type4.CanTP(mob) * type4.GetMethod()) 	 

		if type4.IsGood(mob) then 
			type4.Ability() type4.Skill() type4.M1() 
		end 
		return true 
	else 
		mob = nil
		wait()
		type4.TP(type1.MobData[mob_name][2]) 
		return true 
	end 
	return false
end

function type4.FarmBoss() 
	if not mob or not type4.IsActive(mob) then 
		mob = type4.GetMob(type1.BossSelect) 
	end 

	if mob and type4.IsActive(mob) then 
		type4.TP(type4.CanTP(mob) * type4.GetMethod()) 	 

		if type4.IsGood(mob) then 
			type4.Ability() type4.Skill() type4.M1() 
		end
		return true 
	else 
		mob = nil
		return false
	end  
	return false 
end 

function type4.WorldEvent() 
	local world_event = PlayerGUI.MainHud:FindFirstChild("worldevent")

	if world_event and world_event.Visible then 
		if world_event.mode.Text == "Graveyard Uprising" then 
			if not mob or not type4.IsActive(mob) then 
				mob = type4.GetMobHighlight() 
			end 

			if mob and type4.IsActive(mob) then 
				type4.TP(type4.CanTP(mob) * type4.GetMethod())

				if type4.IsGood(mob) then 
					type4.Ability() type4.Skill() type4.M1() 
				end
				return true 
			else 
				mob = nil
				return false
			end 

		elseif world_event.mode.Text == "Deathmatch" then 
			if not player or not type4.IsActive(player) then 
				player = type4.GetPlayerOtherTeam() 
			end 

			if player and type4.IsActive(player) then 
				type4.TP(type4.CanTP(player) * type4.GetMethod()) 	 

				if not player:FindFirstChild("IFrame") then 
					type4.Ability() type4.Skill() type4.M1() 
					return true 
				end 
				return false
			else 
				player = nil
				return false
			end 
		end 
		return false
	else 
		local raid = type4.GetRaid("Deathmatch World Event") or type4.GetRaid("Graveyard Uprising World Event")

		if raid then 
			type4.TP(type4.CanTP(raid) * CFrame.new(0, 3, 0)) 
			wait(0.3)
			return true 
		elseif type3.WorldEvent then 
			type4.TP(CFrame.new(1195, 872, -666, 1, 0, 0, 0, 1, 0, 0, 0, 1)) 
			wait(0.3)
			return true 
		else 
			if Flags["Hop when no World Event"] then 
				wait(3)
				type4.Hop("Low Population") 
				wait(0.3)
				return true 
			end 
		end 
	end 
	return false 
end

function type4.FarmJeanPierrePolnareff() 
	if not mob or not type4.IsActive(mob) then 
		mob = type4.GetMob("Jean Pierre Polnareff") 
	end 

	if mob and type4.IsActive(mob) then 
		type4.TP(type4.CanTP(mob) * type4.GetMethod()) 	 

		if type4.IsGood(mob) then 
			type4.Ability() type4.Skill() type4.M1() 
		end
		return true 
	else 
		if Flags["Hop when no Jean Pierre Polnareff"] then 
			wait(3)
			type4.Hop("Low Population") 
			wait(0.3)
			return true 
		end 
	end  
	return false 
end 

function type4.JoinRaid()
	if type4.HasCooldown("Auto Join Raid") then return false end

	local raid_name = Flags["Select Raid to Join"]:match("^(.-) %[[^%]]+%]$")
	local raid_pos = type4.GetRaid(raid_name .. " Raid")
	local npc1, npc2 = type4.GetNPC1(type1.RaidData[raid_name][2])

	if raid_pos then
		type4.TP(type4.CanTP(raid_pos) * CFrame.new(0, 3, 0))
		wait(0.3)
		return true
	end

	if npc1 then
		type4.TP(type4.CanTP(npc1))
		wait(0.3)
		type2.character.dialogue:FireServer(npc1, type4.GetDialogue("Raid.", npc1.Name))
		return true
	elseif npc2 then
		type4.TP(type4.CanTP(npc2))
		wait(0.3)
		return true
	end

	type4.AddCooldown("Auto Join Raid", 0.003)
	return false
end 

function type4.FarmRaid()
	if Workspace.Live:FindFirstChild("Netherstar1") or Workspace.Live:FindFirstChild("Netherstar2") then
		if not mob or (mob.Name ~= "Netherstar1" and mob.Name ~= "Netherstar2") then
			mob = type4.GetMob({"Netherstar1", "Netherstar2"})
		end
	else
		if not mob or not type4.IsActive(mob) then
			mob = type4.GetMob()
		end
	end

	if type4.GetInventory("DIO's Bone") >= 3 and Flags["Auto Exchange High Level Keycard"] then
		local npc1, npc2 = type4.GetNPC1("Prisoner Conner")

		if npc1 then
			type4.TP(type4.CanTP(npc1))
			wait(0.3)
			type2.character.dialogue:FireServer(npc1, type4.GetDialogue("Okay.", npc1.Name))
			wait(0.3)
			return true
		elseif npc2 then 
			type4.TP(type4.CanTP(npc2)) 
			wait(0.3)
			return true 
		end
	end

	if type2.slot.Money.Value >= 100 and Flags["Auto Spawn Anasui"] then
		local npc1, npc2 = type4.GetNPC1("Anasui")

		if npc1 then
			type4.TP(type4.CanTP(npc1))
			wait(0.3)
			type2.character.dialogue:FireServer(npc1, type4.GetDialogue("Okay.", npc1.Name))
			wait(0.3)
			Debris:AddItem(npc1, 0)
			return true
		elseif npc2 then 
			type4.TP(type4.CanTP(npc2)) 
			wait(0.3)
			return true 
		end
	end 

	if type4.GetInventory("High Level Keycard") >= 1 and Flags["Auto Spawn Jotaro Kujo"] then
		local npc1, npc2 = type4.GetNPC1("Jotaro Kujo, Stone Ocean")

		if npc1 then
			type4.TP(type4.CanTP(npc1))
			wait(0.3)
			type2.character.dialogue:FireServer(npc1, type4.GetDialogue("Sure.", npc1.Name))
			wait(0.3)
			Debris:AddItem(npc1, 0)
			return true
		elseif npc2 then 
			type4.TP(type4.CanTP(npc2)) 
			wait(0.3)
			return true 
		end
	end 

	if Flags["Auto Spawn Viviano"] then
		local npc1, npc2 = type4.GetNPC1("Prison Security Guard")

		if npc1 then
			type4.TP(type4.CanTP(npc1))
			wait(0.3)
			type2.character.dialogue:FireServer(npc1, type4.GetDialogue("Sure.", npc1.Name))
			wait(0.3)
			Debris:AddItem(npc1, 0)
			return true
		elseif npc2 then 
			type4.TP(type4.CanTP(npc2)) 
			wait(0.3)
			return true 
		end
	end 

	if mob and type4.IsActive(mob) then
		type4.TP(type4.CanTP(mob) * type4.GetMethod())

		if type4.IsGood(mob) then 
			type4.Ability() type4.Skill() type4.M1() 
		end 

		if mob:GetAttribute("Miniboss") then
			local boss_health = mob.Humanoid.Health
			local boss_max_health = mob.Humanoid.MaxHealth

			if type3.BossHealth[type4.GetName()] and type3.BossHealth[type4.GetName()] > 0 and boss_health > type3.BossHealth[type4.GetName()] + 300 then
				type3.BossPhase2[type4.GetName()] = true
			end

			if type3.BossMaxHealth[type4.GetName()] and type3.BossMaxHealth[type4.GetName()] > 0 and boss_max_health > type3.BossMaxHealth[type4.GetName()] then
				type3.BossPhase2[type4.GetName()] = true
			end

			type3.BossHealth[type4.GetName()] = boss_health
			type3.BossMaxHealth[type4.GetName()] = boss_max_health

			if not type3.CanInstant[type4.GetName()] and (type3.BossPhase2[type4.GetName()] or (table.find({"Anasui", "Jotaro Kujo, Stone Ocean", "Pucci", "Evolved Pucci", "Viviano"}, mob:GetAttribute("DisplayName")) and boss_health <= boss_max_health * 0.99) or (boss_health <= boss_max_health * Flags["Instant Kill Threshold"] / 100)) then
				delay(Flags["Instant Kill Cast Delay"], function()
					type3.CanInstant[type4.GetName()] = true
				end)
			end
		end
		return true
	else 
		mob = nil
		wait()
		type4.TP(type4.CanTP(Workspace.Live.Server) * CFrame.new(0, 6, 0))
		return true
	end 
	return false 
end 

function type4.Meditate() 
	if type4.GetMobEntityClone() ~= nil then 
		if not mob or not type4.IsActive(mob) then 
			mob = type4.GetMobEntityClone() 
		end 

		if mob and type4.IsActive(mob) then 
			type4.TP(type4.CanTP(mob) * type4.GetMethod())

			if type4.IsGood(mob) then 
				type4.Ability() type4.Skill() type4.M1() 
			end
			return true 
		end 
		return false 

	elseif Workspace.Npcs:FindFirstChild("The Self") then 
		local self_npc = Workspace.Npcs["The Self"] 

		type4.TP(type4.CanTP(self_npc)) 
		wait(0.3) 
		type2.character.dialogue:FireServer(self_npc, type4.GetDialogue(nil, self_npc.Name)) 
		wait(0.3)
		return true 
	else 
		local yoga_mat = Workspace.Map.Meditation:FindFirstChild("Yoga Mat") 

		if yoga_mat then 
			type4.TP(type4.CanTP(yoga_mat)) 
			wait(0.3) 
			type4.ProximityPrompt(yoga_mat:FindFirstChildOfClass("ProximityPrompt")) 
			wait(3) 
			return true 
		else 
			type4.TP(CFrame.new(1105, 881, 87, 0, 0, 1, 0, 1, -0, -1, 0, 0)) 
			wait(0.3)
			return true 
		end 
	end 
	return false
end 

function type4.Workouts() 
	if type4.HasCooldown("Auto Workouts") then return false end

	local workout_name = type4.GetWorkouts() 

	if workout_name then 
		local workout = Workspace.Map.Workouts:FindFirstChild(workout_name) 

		if workout then 
			type4.TP(type4.CanTP(workout.Main)) 
			wait(3) 
			type4.ProximityPrompt(workout:FindFirstChildOfClass("ProximityPrompt")) 
			wait(9) 
			return true 
		end 
	end 

	type4.AddCooldown("Auto Workouts", 0.003) 
	return false 
end 

function type4.FarmPvP() 
	local main_player = Players:FindFirstChild(Flags["Select Main to Farm"]) 
	local alt_player = Players:FindFirstChild(Flags["Select Alt to Farm"]) 

	if not main_player or not alt_player then return false end 
	if not type4.IsActive(main_player.Character) or not type4.IsActive(alt_player.Character) then return false end 

	if type3.PvP then 
		if plr == alt_player and alt_player.Character:GetAttribute("MissionHighlight") then 
			char.Humanoid.Health = 0 
			return true 
		end 
	else 
		if type3.PvE then
			char.Humanoid.Health = 0 
			return true
		else	
			local pvp_mission = Workspace.Map["Mission Boards"].PvP:GetChildren()[math.random(1, 15)]

			if pvp_mission then
				type4.TP(type4.CanTP(pvp_mission["Speedwagon Notes"])) 
				wait(0.3) 
				type4.ProximityPrompt(pvp_mission:FindFirstChildOfClass("ProximityPrompt")) 
				wait(0.3)
				return true 
			end
		end
	end 
	return false
end 

function type4.Storyline() 
	if IsWorld then 
		local mission_type, mission_name = type4.GetStoryline() 
		if not mission_type or not mission_name then return false end 

		if mission_type == "Talk" then 
			local npc1, npc2 = type4.GetNPC1(mission_name) 	 

			if npc1 then             
				type4.TP(type4.CanTP(npc1))
				wait(0.3) 
				type2.character.dialogue:FireServer(npc1, type4.GetDialogue(nil, npc1.Name)) 
				wait(0.3)
				return true 
			elseif npc2 then 
				type4.TP(type4.CanTP(npc2)) 
				wait(0.3)
				return true 
			end 
			return false 

		elseif mission_type == "Kills" and mission_name ~= "Muhammad Avdol" then 
			if not mob or not type4.IsActive(mob) then 
				mob = type4.GetMob(mission_name) 
			end 

			if mob and type4.IsActive(mob) then 
				type4.TP(type4.CanTP(mob) * type4.GetMethod())

				if type4.IsGood(mob) then 
					type4.Ability() type4.Skill() type4.M1() 
				end
				return true 
			else 
				mob = nil
				local npc1, npc2 = type4.GetNPC1(mission_name) 

				if npc1 then 
					type4.TP(type4.CanTP(npc1))
					wait(0.3) 
					type2.character.dialogue:FireServer(npc1, type4.GetDialogue(nil, npc1.Name)) 
					wait(0.3)
					return true 
				elseif npc2 then 
					if mission_name == "Yoshikage Kira" then
						return false 
					end 

					type4.TP(type4.CanTP(npc2)) 
					wait(0.3)
					return true 
				else 
					type4.TP(type1.MobData[mission_name][2]) 
					wait(0.3)
					return true 
				end 
			end 

		elseif mission_type == "ObtainItem" then 
			local npc1, npc2 = type4.GetNPC1(mission_name) 

			if npc1 then    
				type4.TP(type4.CanTP(npc1))
				wait(0.3)         
				type2.character.dialogue:FireServer(npc1, type4.GetDialogue(nil, npc1.Name)) 
				wait(0.3)
				return true
			elseif npc2 then 
				type4.TP(type4.CanTP(npc2)) 
				wait(0.3)
				return true 
			end 
			return false 

		elseif mission_type == "SpecialRaids" or (mission_type == "Kills" and mission_name == "Muhammad Avdol") then 
			local npc1, npc2 = type4.GetNPC1((mission_name == "Yoshikage Kira Bites the Dust") and "Yoshikage Kira" or mission_name) 
			local raid = type4.GetRaid(mission_name .. " Raid") 

			if raid then 
				type4.TP(type4.CanTP(raid) * CFrame.new(0, 3, 0)) 
				wait(0.3)
				return true 
			end 

			if npc1 then 
				type4.TP(type4.CanTP(npc1))
				wait(0.3) 
				type2.character.dialogue:FireServer(npc1, type4.GetDialogue("Raid.", npc1.Name)) 
				wait(0.3)
				return true 
			elseif npc2 then 
				type4.TP(type4.CanTP(npc2)) 
				wait(0.3)
				return true 
			end 
			return false 
		end 
		return false 

	elseif IsRaid then 
		if not mob or not type4.IsActive(mob) then 
			mob = type4.GetMob() 
		end 

		if mob and type4.IsActive(mob) then 
			type4.TP(type4.CanTP(mob) * type4.GetMethod())

			if type4.IsGood(mob) then 
				type4.Ability() type4.Skill() type4.M1() 
			end
			return true 
		end 
	end 
	return false 
end

function type4.FarmCivilian() 
	if not mob or not type4.IsActive(mob) then 
		mob = type4.GetMob("Civilian") 
	end 

	if mob and type4.IsActive(mob) then 
		type4.TP(type4.CanTP(mob) * type4.GetMethod()) 	 

		if type4.IsGood(mob) then 
			type4.Ability() type4.Skill() type4.M1() 
		end
		return true 
	else 
		mob = nil
		type4.TP(type4.CanTP(Workspace.Map.map_meat.Lights:GetChildren()[math.random(1, 267)])) 
		wait(3) 
		return true 
	end 
	return false
end 

function type4.FarmGang()
	if char:GetAttribute("Mission") then
		if type3.GangContract == "Your Contract is to rescue a Gang Member" then
			local gang_member = Workspace:FindFirstChild("Capture Gang Member")

			if gang_member then
				type4.TP(type4.CanTP(gang_member))
				wait(0.3)
				type4.ProximityPrompt(gang_member.HumanoidRootPart:FindFirstChildOfClass("ProximityPrompt"))
				wait(0.3)
				return true
			end
		elseif type3.GangContract == "Your Contract is to capture a Gang Territory" then
			local territory = Workspace.Map["Gang Territories"]:GetChildren()[math.random(1, 3)]

			if territory and territory:FindFirstChild("Graffiti") then
				type4.TP(type4.CanTP(territory.Graffiti))
				wait(0.3)
				type4.ProximityPrompt(territory.Graffiti:FindFirstChildOfClass("ProximityPrompt"))
				wait(0.3)
				return true
			end
		else
			char.Humanoid.Health = 0
			wait(0.3)
			return true
		end
	else
		local npc1, npc2 = type4.GetNPC1("Gang Contractor")

		if npc1 then
			type4.TP(type4.CanTP(npc1))
			wait(0.3)
			type2.character.dialogue:FireServer(npc1, type4.GetDialogue(nil, npc1.Name))
			wait(0.3)
			return true	
		elseif npc2 then
			type4.TP(type4.CanTP(npc2))
			wait(0.3)
			return true
		end
	end
	return false
end

function type4.FarmPvE()
	if type3.PvE and type3.PvE == "Exterminate the targets" or type4.GetMobHighlight() ~= nil then
		if not mob or not type4.IsActive(mob) then
			mob = type4.GetMobHighlight()
		end

		if mob and type4.IsActive(mob) then
			type4.TP(type4.CanTP(mob) * type4.GetMethod())

			if type4.IsGood(mob) then
				type4.Ability() type4.Skill() type4.M1()
			end
			return true
		else
			mob = nil
			return false
		end
	elseif type3.PvE and string.find(type3.PvE, "Deliver the") or char:GetAttribute("Mission") then
		local mission_name = type4.GetMission()
		local npc1, npc2 = type4.GetNPC1(mission_name)

		if npc1 then
			type4.TP(type4.CanTP(npc1))
			wait(3)
			type2.character.dialogue:FireServer(npc1, type4.GetDialogue(nil, npc1.Name))
			wait(3)
			return true
		elseif npc2 then
			type4.TP(type4.CanTP(npc2))
			wait(3)
			return true
		end
		return false
	else
		if type3.PvP then 
			char.Humanoid.Health = 0 
			return true
		else
			local pve_mission = Workspace.Map["Mission Boards"].PvE["PvE Mission Board"]

			if pve_mission and not type3.PvE then
				type4.TP(type4.CanTP(pve_mission:FindFirstChild("Speedwagon Notes")))
				wait(3)
				type4.ProximityPrompt(pve_mission:FindFirstChildOfClass("ProximityPrompt"))
				wait(3)
				return true
			end
		end
	end
	return false
end

function type4.SummonStand() 
	if char:GetAttribute("SummonedStand") then return false end 

	char.client_character_controller.SummonStand:FireServer() 
	return true 
end 

function type4.StandPose() 
	if type4.HasCooldown("Auto Stand Pose") then return false end

	type4.AddCooldown("Auto Stand Pose", 3)
	char.client_character_controller.Pose:FireServer() 
	return true 
end 

function type4.Prestige() 
	if type4.HasCooldown("Auto Prestige") then return false end
	if type2.slot.Level.Value < 50 or type2.slot.Money.Value < 10000 then return false end 

	if IsWorld then 
		local npc1, npc2 = type4.GetNPC1("Arch Mage") 

		if npc1 then 
			type4.TP(type4.CanTP(npc1))
			wait(0.3)
			type2.character.dialogue:FireServer(npc1, type4.GetDialogue("Prestige.", npc1.Name)) 
			wait(0.3)
			return true 
		else 
			type4.TP(type4.CanTP(npc2))
			wait(0.3)
			return true 
		end 
	else 
		TeleportService:Teleport(14890802310, plr) 
		return true 
	end 

	type4.AddCooldown("Auto Prestige", 0.003) 
	return false 
end 

function type4.RollStand() 
	if type4.HasCooldown("Auto Roll Stand") then return false end 

	local stand_result = type4.GetStand(type1.StandSelect, type1.SkinSelect, type1.StandStrengthSelect, type1.StandSpeedSelect, type1.StandSpecialtySelect, type1.StandPersonalitySelect)
	local arrow_item = type4.GetInventory(Flags["Select Arrow to Roll"]) or 0 

	if stand_result then 
		Library:Notification({ 
			Name = "Auto Roll Stand", 
			Description = "You have obtained the Stand: " .. stand_result, 
			Color = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)), 
			Duration = 9 
		}) 

		if Flags["Auto Send Webhook Stand"] then 
			type4.SendWebhook("Stand", "Auto Roll Stand", stand_result) 
		end 

		type4.AddCooldown("Auto Roll Stand", 8) 
		return true 
	end 

	if arrow_item ~= 0 then 
		type2.character.use_item:FireServer(Flags["Select Arrow to Roll"]) 
		wait(0.3)
		return true 
	end 

	type4.AddCooldown("Auto Roll Stand", 8) 
	return false 
end

function type4.CollectItem() 
	if type4.HasCooldown("Auto Collect Item") then return false end

	for _, model in Workspace:GetChildren() do 
		if model.Name == "Model" then 
			for _, item_name in type1.ItemSelect do 
				local found_item = model:FindFirstChild(item_name) 

				if found_item then 
					item = found_item 
				end 
			end 
		end 
	end 

	local target_item = item 
	local item_part = target_item and target_item:IsA("BasePart") and target_item 
	local item_prompt = target_item and target_item:FindFirstChildOfClass("ProximityPrompt") 

	if item_part and item_prompt then 
		type4.TP(type4.CanTP(item_part)) 
		wait(0.3) 
		type4.ProximityPrompt(item_prompt) 
		wait(0.3) 
		if Flags["Auto Send Webhook Item"] then 
			type4.SendWebhook("Item", "Auto Collect Item", item.Name) 
		end 
		wait(0.3)
		return true 
	else 
		if Flags["Hop when no Item"] then 
			wait(3)
			type4.Hop("Low Population") 
			wait(0.3)
			return true 
		end 
	end 

	type4.AddCooldown("Auto Collect Item", 0.003) 
	return false 
end 

function type4.OpenChest() 
	if type4.HasCooldown("Open All Chest") then return false end 

	for _, chest_name in type1.ChestSelect do 
		local chest_count = type4.GetInventory(chest_name) 

		if chest_count and chest_count >= Flags["Auto Open Chest Threshold"] then 
			type2.character.use_item:FireServer(chest_name, {UseAll = true}) 
			return true 
		end 
	end 

	type4.AddCooldown("Open All Chest", 0.3) 
	return false 
end 

function type4.CraftItem()
	if type4.HasCooldown("Auto Craft Item") then return false end

	for _, craft_name in type1.CraftSelect do
		local requirements = type1.CraftRequirementData[craft_name]

		if requirements then
			local can_craft = true

			for item_name, required_amount in pairs(requirements) do
				if type4.GetInventory(item_name) < required_amount then
					can_craft = false
					break
				end
			end

			if can_craft then
				type2.character.craft:FireServer(craft_name)
				return true
			end
		end
	end

	type4.AddCooldown("Auto Craft Item", 0.3)
	return false
end

function type4.SellItem()
	if type4.HasCooldown("Auto Sell Item") then return false end

	local item_to_sell = type4.GetItem()

	if item_to_sell then
		type2.general.SellItem:FireServer({item_to_sell})
		return true
	end

	type4.AddCooldown("Auto Sell Item", 0.3)
	return false
end

function type4.SellAccessories() 
	if type4.HasCooldown("Auto Sell Accessories") then return false end 

	local accessory_list = type4.GetAccessories()

	if accessory_list and #accessory_list >= 3 then 
		type2.general.SellItem:FireServer(accessory_list) 
		return true 
	end 

	type4.AddCooldown("Auto Sell Accessories", 0.3) 
	return false 
end 

function type4.CashShop() 
	if type4.HasCooldown("Auto Buy Cash Shop") then return false end

	local cash_shop_item = type4.GetCashShop() 

	if cash_shop_item then 
		type2.character.cash_shop:FireServer(cash_shop_item) 
		return true 
	end 

	type4.AddCooldown("Auto Buy Cash Shop", 0.3) 
	return false 
end

function type4.GangShop() 
	if type4.HasCooldown("Auto Buy Gang Shop") then return false end

	local gang_shop_item = type4.GetGangShop() 

	if gang_shop_item then 
		type2.character.gang_shop:FireServer(gang_shop_item) 
		return true 
	end 

	type4.AddCooldown("Auto Buy Gang Shop", 0.3) 
	return false 
end

function type4.RaidShop() 
	if type4.HasCooldown("Auto Buy Raid Shop") then return false end 

	if not IsRaid and next(getgenv().RaidShop) == nil then 
		char.Humanoid.Health = 0 
		return false 
	end 

	local shop_item, shop_slot = type4.GetRaidShop() 

	if shop_item and shop_slot then 
		type2.character.raid_shop:FireServer(shop_item, shop_slot) 
		return true 
	end 

	type4.AddCooldown("Auto Buy Raid Shop", 0.3) 
	return false 
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Window = Library:Window({
	Name = "solixhub.com",
	FadeSpeed = 0.30,
	BackgroundIcon = ""
})

local KeybindList = Library:KeybindList()
local Watermark = Library:Watermark("solixhub.com")

local Pages = {
	["Farm"] = Window:Page({ Name = "Farm", Columns = 1 }),
	["Raid"] = Window:Page({ Name = "Raid", Columns = 1 }),
	["Quest"] = Window:Page({ Name = "Quest", Columns = 1 }),
	["Item"] = Window:Page({ Name = "Item", Columns = 1 }),
	["Shop"] = Window:Page({ Name = "Shop", Columns = 1 }),
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

local FarmNearest_Section = Pages["Farm"]:Section({ Name = "Auto Farm Nearest", Side = 1 })

FarmNearest_Section:Toggle({
	Name = "Auto Farm Nearest",
	Flag = "Auto Farm Nearest",
	Description = "Automatically farm the nearest mob",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Nearest"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

FarmNearest_Section:Slider({
	Name = "Range to Detect",
	Flag = "Range to Detect",
	Description = "Detection range for nearest mob",
	Default = 300,
	Min = 0,
	Max = 3000,
	Decimals = 10,
	Suffix = "m",
	Callback = function(value)
		Flags["Range to Detect"] = value
	end
})

local FarmPlayer_Section = Pages["Farm"]:Section({ Name = "Auto Farm Player", Side = 1 })

local FarmPlayer_Dropdown = FarmPlayer_Section:Dropdown({
	Name = "Select Player to Farm",
	Flag = "Select Player to Farm",
	Description = "Select a player to farm",
	Items = type1.PlayerList,
	Default = nil,
	Callback = function(value)
		Flags["Select Player to Farm"] = value
	end
})

FarmPlayer_Section:Toggle({
	Name = "Auto Farm Player",
	Flag = "Auto Farm Player",
	Description = "Automatically farm selected player",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Player"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

FarmPlayer_Section:Button():Add("Refresh List", function()
	type1.PlayerList = {}

	for _, player in Players:GetPlayers() do
		if player ~= plr and type4.IsActive(player.Character) then
			table.insert(type1.PlayerList, player.Name)
		end
	end

	table.sort(type1.PlayerList, function(player_a, player_b)
		return string.lower(player_a) < string.lower(player_b)
	end)

	FarmPlayer_Dropdown:Refresh(type1.PlayerList)
end)

local FarmMob_Section = Pages["Farm"]:Section({ Name = "Auto Farm Mob", Side = 1 })

FarmMob_Section:Dropdown({
	Name = "Select Mob to Farm",
	Flag = "Select Mob to Farm",
	Description = "Select a mob type to farm",
	Items = type1.MobDisplay,
	Default = nil,
	Callback = function(value)
		Flags["Select Mob to Farm"] = value
	end
})

FarmMob_Section:Toggle({
	Name = "Auto Farm Mob",
	Flag = "Auto Farm Mob",
	Description = "Automatically farm selected mob",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Mob"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

local FarmBoss_Section = Pages["Farm"]:Section({ Name = "Auto Farm Boss", Side = 1 })

FarmBoss_Section:Dropdown({
	Name = "Select Boss to Farm",
	Flag = "Select Boss to Farm",
	Description = "Select boss type to farm",
	Multi = true,
	Items = type1.BossDisplay,
	Default = nil,
	Callback = function(value)
		type1.BossSelect = {}
		Flags["Select Boss to Farm"] = value

		for _, boss_item in value do
			local boss_name = boss_item:match("^(.-) %[[^%]]+%]$")

			if boss_name then
				table.insert(type1.BossSelect, boss_name)
			end
		end
	end
})

FarmBoss_Section:Toggle({
	Name = "Auto Farm Boss",
	Flag = "Auto Farm Boss",
	Description = "Automatically farm selected boss",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Boss"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

local WorldEvent_Section = Pages["Farm"]:Section({ Name = "Auto Farm World Event", Side = 1 })

WorldEvent_Section:Toggle({
	Name = "Auto Farm World Event",
	Flag = "Auto Farm World Event",
	Description = "Automatically farm world event",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm World Event"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

WorldEvent_Section:Toggle({
	Name = "Hop when no World Event",
	Flag = "Hop when no World Event",
	Description = "Auto hop server when no world event",
	Default = false,
	Callback = function(value)
		Flags["Hop when no World Event"] = value
	end
})

local JeanPierrePolnareff_Section = Pages["Farm"]:Section({ Name = "Auto Farm Jean Pierre Polnareff", Side = 1 })

JeanPierrePolnareff_Section:Toggle({
	Name = "Auto Farm Jean Pierre Polnareff",
	Flag = "Auto Farm Jean Pierre Polnareff",
	Description = "Automatically farm the Jean Pierre Polnareff",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Jean Pierre Polnareff"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

JeanPierrePolnareff_Section:Toggle({
	Name = "Hop when no Jean Pierre Polnareff",
	Flag = "Hop when no Jean Pierre Polnareff",
	Description = "Auto hop server when no Jean Pierre Polnareff",
	Default = false,
	Callback = function(value)
		Flags["Hop when no Jean Pierre Polnareff"] = value
	end
})

local Setting_Section = Pages["Farm"]:Section({ Name = "Farm Settings", Side = 1 })

Setting_Section:Dropdown({
	Name = "Teleport Method",
	Flag = "Teleport Method",
	Description = "Teleport position relative to target",
	Items = {"Above", "Below", "Behind"},
	Default = "Above",
	Callback = function(value)
		Flags["Teleport Method"] = value
	end
})

Setting_Section:Toggle({
	Name = "Auto Summon Stand",
	Flag = "Auto Summon Stand",
	Description = "Automatically summon your stand",
	Default = true,
	Callback = function(value)
		Flags["Auto Summon Stand"] = value
	end
})

Setting_Section:Slider({
	Name = "Position Offset",
	Flag = "Position Offset",
	Description = "Offset distance from target",
	Default = 10,
	Min = -30,
	Max = 30,
	Decimals = 1,
	Suffix = "m",
	Callback = function(value)
		Flags["Position Offset"] = value
	end
})

local UseSkill_Section = Pages["Farm"]:Section({ Name = "Auto Use Skill", Side = 1 })

UseSkill_Section:Dropdown({
	Name = "Select Skill to Use",
	Flag = "Select Skill to Use",
	Description = "Select skills to auto use",
	Multi = true,
	Items = type1.SkillList,
	Default = nil,
	Callback = function(value)
		type1.SkillSelect = {}
		Flags["Select Skill to Use"] = value

		for _, skill_name in value do
			table.insert(type1.SkillSelect, skill_name)
		end
	end
})

UseSkill_Section:Toggle({
	Name = "Auto Use Skill",
	Flag = "Auto Use Skill",
	Description = "Automatically use selected skills",
	Default = false,
	Callback = function(value)
		Flags["Auto Use Skill"] = value

		if value then
			getgenv().Ability = type2.get:InvokeServer("ability")
		end
	end
})

UseSkill_Section:Slider({
	Name = "Use Skill Delay",
	Flag = "Use Skill Delay",
	Description = "Delay before use kill",
	Default = 0.3,
	Min = 0,
	Max = 9,
	Decimals = 0.1,
	Suffix = "s",
	Callback = function(value)
		Flags["Use Skill Delay"] = value
	end
})

local UseAbility_Section = Pages["Farm"]:Section({ Name = "Auto Use Ability", Side = 1 })

UseAbility_Section:Dropdown({
	Name = "Select Ability to Use",
	Flag = "Select Ability to Use",
	Description = "Select abilities to auto use",
	Multi = true,
	Items = type1.AbilityList,
	Default = nil,
	Callback = function(value)
		type1.AbilitySelect = {}
		Flags["Select Ability to Use"] = value

		for _, ability_name in value do
			table.insert(type1.AbilitySelect, ability_name)
		end
	end
})

UseAbility_Section:Toggle({
	Name = "Auto Use Ability",
	Flag = "Auto Use Ability",
	Description = "Automatically use selected abilities",
	Default = false,
	Callback = function(value)
		Flags["Auto Use Ability"] = value
	end
})

UseAbility_Section:Slider({
	Name = "Use Ability Delay",
	Flag = "Use Ability Delay",
	Description = "Delay before use ability",
	Default = 0.3,
	Min = 0,
	Max = 9,
	Decimals = 0.1,
	Suffix = "s",
	Callback = function(value)
		Flags["Use Ability Delay"] = value
	end
})

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local JoinRaid_Section = Pages["Raid"]:Section({ Name = "Auto Join Raid", Side = 1 })

JoinRaid_Section:Dropdown({
	Name = "Select Raid to Join",
	Flag = "Select Raid to Join",
	Description = "Select raid to auto join",
	Items = type1.RaidDisplay,
	Default = nil,
	Callback = function(value)
		Flags["Select Raid to Join"] = value
	end
})

JoinRaid_Section:Toggle({
	Name = "Auto Join Raid",
	Flag = "Auto Join Raid",
	Description = "Automatically join selected raid",
	Default = false,
	Callback = function(value)
		Flags["Auto Join Raid"] = value
	end
})

local FarmRaid_Section = Pages["Raid"]:Section({ Name = "Auto Farm Raid", Side = 1 })

FarmRaid_Section:Dropdown({
	Name = "Select Action to Teleport",
	Flag = "Select Action to Teleport",
	Description = "Action when raid completed",
	Items = {"Retry", "Teleport"},
	Default = "Retry",
	Callback = function(value)
		Flags["Select Action to Teleport"] = value
	end
})

FarmRaid_Section:Toggle({
	Name = "Auto Farm Raid",
	Flag = "Auto Farm Raid",
	Description = "Automatically farm raid",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Raid"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			wait()
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

local PrisonEscape_Section = Pages["Raid"]:Section({ Name = "Prison Escape", Side = 1 })

PrisonEscape_Section:Toggle({
	Name = "Auto Exchange High Level Keycard (Option)",
	Flag = "Auto Exchange High Level Keycard",
	Description = "Automatically exchange high level keycard",
	Default = false,
	Callback = function(value)
		Flags["Auto Exchange High Level Keycard"] = value
	end
})

PrisonEscape_Section:Toggle({
	Name = "Ingore Snark, Vern (Option)",
	Flag = "Ingore Snark, Vern",
	Description = "Ingnore Snark and Vern in Prison Escape",
	Default = false,
	Callback = function(value)
		Flags["Ingore Snark, Vern"] = value
	end
})

PrisonEscape_Section:Toggle({
	Name = "Auto Spawn Anasui (Option)",
	Flag = "Auto Spawn Anasui",
	Description = "Spawn the Anasui in Prison Escape",
	Default = false,
	Callback = function(value)
		Flags["Auto Spawn Anasui"] = value
	end
})

PrisonEscape_Section:Toggle({
	Name = "Auto Spawn Jotaro Kujo (Option)",
	Flag = "Auto Spawn Jotaro Kujo",
	Description = "Spawn the Jotaro Kujo in Prison Escape",
	Default = false,
	Callback = function(value)
		Flags["Auto Spawn Jotaro Kujo"] = value
	end
})

PrisonEscape_Section:Toggle({
	Name = "Auto Spawn Viviano (Option)",
	Flag = "Auto Spawn Viviano",
	Description = "Spawn the Viviano in Prison Escape",
	Default = false,
	Callback = function(value)
		Flags["Auto Spawn Viviano"] = value
	end
})

local Retry_Section = Pages["Raid"]:Section({ Name = "Auto Retry", Side = 1 })

Retry_Section:Toggle({
	Name = "Auto Retry",
	Flag = "Auto Retry",
	Description = "Auto retry when no mob found",
	Default = true,
	Callback = function(value)
		Flags["Auto Retry"] = value
	end
})

Retry_Section:Slider({
	Name = "Auto Retry Delay",
	Flag = "Auto Retry Delay",
	Description = "Delay before auto retry",
	Default = 20,
	Min = 20,
	Max = 30,
	Decimals = 1,
	Suffix = "s",
	Callback = function(value)
		Flags["Auto Retry Delay"] = value
	end
})

Retry_Section:Slider({
	Name = "Auto Retry Timeout",
	Flag = "Auto Retry Timeout",
	Description = "Timeout before teleport to lobby",
	Default = 20,
	Min = 20,
	Max = 30,
	Decimals = 1,
	Suffix = "m",
	Callback = function(value)
		Flags["Auto Retry Timeout"] = value
	end
})

local InstantKill_Section = Pages["Raid"]:Section({ Name = "Instant Kill", Side = 1 })

InstantKill_Section:Dropdown({
	Name = "Select Grab Skill to Use",
	Flag = "Select Grab Skill to Use",
	Description = "Select grab skills for instant kill",
	Multi = true,
	Items = type1.SkillList,
	Default = nil,
	Callback = function(value)
		type1.SkillGrabSelect = {}
		Flags["Select Grab Skill to Use"] = value

		for _, skill_name in value do
			table.insert(type1.SkillGrabSelect, skill_name)
		end
	end
})

InstantKill_Section:Dropdown({
	Name = "Select Grab Ability to Use",
	Flag = "Select Grab Ability to Use",
	Description = "Select grab abilities for instant kill",
	Multi = true,
	Items = type1.AbilityList,
	Default = nil,
	Callback = function(value)
		type1.AbilityGrabSelect = {}
		Flags["Select Ability to Use"] = value

		for _, ability_name in value do
			table.insert(type1.AbilityGrabSelect, ability_name)
		end
	end
})

InstantKill_Section:Toggle({
	Name = "Instant Kill",
	Flag = "Instant Kill",
	Description = "Instant kill mob when low health",
	Default = false,
	Callback = function(value)
		Flags["Instant Kill"] = value
	end
})

InstantKill_Section:Slider({
	Name = "Instant Kill Threshold",
	Flag = "Instant Kill Threshold",
	Description = "Threshold to trigger instant kill",
	Default = 50,
	Min = 0,
	Max = 100,
	Decimals = 1,
	Suffix = "%",
	Callback = function(value)
		Flags["Instant Kill Threshold"] = value
	end
})

InstantKill_Section:Slider({
	Name = "Instant Kill Cast Delay",
	Flag = "Instant Kill Cast Delay",
	Description = "Delay before executing instant kill",
	Default = 0.3,
	Min = 0,
	Max = 9,
	Decimals = 0.1,
	Suffix = "s",
	Callback = function(value)
		Flags["Instant Kill Cast Delay"] = value
	end
})

InstantKill_Section:Slider({
	Name = "Instant Kill Hold Delay",
	Flag = "Instant Kill Hold Delay",
	Description = "Delay before teleport to void",
	Default = 0.1,
	Min = 0,
	Max = 9,
	Decimals = 0.1,
	Suffix = "s",
	Callback = function(value)
		Flags["Instant Kill Hold Delay"] = value
	end
})

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local MissionBoards_Section = Pages["Quest"]:Section({ Name = "Auto Mission Boards", Side = 1 })

local Main_Dropdown = MissionBoards_Section:Dropdown({
	Name = "Select Main to Farm",
	Flag = "Select Main to Farm",
	Description = "Select your main character",
	Items = type1.PlayerList,
	Default = nil,
	Callback = function(value)
		Flags["Select Main to Farm"] = value
	end
})

local Alt_Dropdown = MissionBoards_Section:Dropdown({
	Name = "Select Alt to Farm",
	Flag = "Select Alt to Farm",
	Description = "Select your alt character",
	Items = type1.PlayerList,
	Default = nil,
	Callback = function(value)
		Flags["Select Alt to Farm"] = value
	end
})

MissionBoards_Section:Button():Add("Refresh List", function()
	type1.PlayerList = {}

	for _, player in Players:GetPlayers() do
		if type4.IsActive(player.Character) then
			table.insert(type1.PlayerList, player.Name)
		end
	end

	table.sort(type1.PlayerList, function(player_a, player_b)
		return string.lower(player_a) < string.lower(player_b)
	end)

	Main_Dropdown:Refresh(type1.PlayerList)
	Alt_Dropdown:Refresh(type1.PlayerList)
end)

MissionBoards_Section:Toggle({
	Name = "Auto Farm PvP",
	Flag = "Auto Farm PvP",
	Description = "Auto farm PvP mission",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm PvP"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

MissionBoards_Section:Toggle({
	Name = "Auto Farm PvE",
	Flag = "Auto Farm PvE",
	Description = "Auto farm PvE mission",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm PvE"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

local FarmQuest_Section = Pages["Quest"]:Section({ Name = "Auto Farm Quest", Side = 1 })

FarmQuest_Section:Toggle({
	Name = "Auto Farm Storyline",
	Flag = "Auto Farm Storyline",
	Description = "Auto farm storyline quest",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Storyline"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

FarmQuest_Section:Toggle({
	Name = "Auto Farm Civilian",
	Flag = "Auto Farm Civilian",
	Description = "Auto farm civilian quest",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Civilian"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

FarmQuest_Section:Toggle({
	Name = "Auto Farm Gang",
	Flag = "Auto Farm Gang",
	Description = "Auto farm gang quest",
	Default = false,
	Callback = function(value)
		Flags["Auto Farm Gang"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

local Gym_Section = Pages["Quest"]:Section({ Name = "Auto Gym", Side = 1 })

Gym_Section:Dropdown({
	Name = "Select Workout to Farm",
	Flag = "Select Workout to Farm",
	Description = "Select workout type to farm",
	Multi = true,
	Items = type1.WorkoutList,
	Default = nil,
	Callback = function(value)
		type1.WorkoutSelect = {}
		Flags["Select Workout to Farm"] = value

		for _, workout_name in value do
			table.insert(type1.WorkoutSelect, workout_name)
		end
	end
})

Gym_Section:Toggle({
	Name = "Auto Workouts",
	Flag = "Auto Workouts",
	Description = "Automatically do workouts",
	Default = false,
	Callback = function(value)
		Flags["Auto Workouts"] = value
	end
})

Gym_Section:Toggle({
	Name = "Auto Meditate",
	Flag = "Auto Meditate",
	Description = "Automatically meditate",
	Default = false,
	Callback = function(value)
		Flags["Auto Meditate"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

local Misc_Section = Pages["Quest"]:Section({ Name = "Misc HeHe", Side = 1 })

Misc_Section:Toggle({
	Name = "Auto Stand Pose",
	Flag = "Auto Stand Pose",
	Description = "Auto pose your stand",
	Default = false,
	Callback = function(value)
		Flags["Auto Stand Pose"] = value

		if not value and type4.HasCooldown("Loaded") then
			mob = nil
			player = nil
			type4.TP((type4.IsActive(char) and char.HumanoidRootPart.CFrame))
		end
	end
})

Misc_Section:Toggle({
	Name = "Auto Prestige",
	Flag = "Auto Prestige",
	Description = "Auto prestige when possible",
	Default = false,
	Callback = function(value)
		Flags["Auto Prestige"] = value
	end
})

Misc_Section:Button():Add("Redeem All Code", function()
	spawn(function()
		for _, code in type1.CodeList do
			type2.redeemcode:FireServer(code)
			wait(0.3)
		end
	end)
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local RollStand_Section = Pages["Item"]:Section({ Name = "Auto Roll Stand", Side = 1 })

RollStand_Section:Dropdown({
	Name = "Select Arrow to Roll",
	Flag = "Select Arrow to Roll",
	Description = "Select arrow type to roll",
	Items = {"Stand Arrow", "Lucky Arrow"},
	Default = "Stand Arrow",
	Callback = function(value)
		Flags["Select Arrow to Roll"] = value
	end
})

RollStand_Section:Dropdown({
	Name = "Select Stand to Roll",
	Flag = "Select Stand to Roll",
	Description = "Select stand to wait for",
	Multi = true,
	Items = type1.StandDisplay,
	Default = nil,
	Callback = function(value)
		type1.StandSelect = {}
		Flags["Select Stand to Roll"] = value

		for _, display_text in value do
			local stand_name = display_text:match("^(.-) %[[^%]]+%]$")

			if stand_name then
				table.insert(type1.StandSelect, stand_name)
			end
		end
	end
})

RollStand_Section:Dropdown({
	Name = "Select Skin to Roll",
	Flag = "Select Skin to Roll",
	Description = "Select skin to wait for",
	Multi = true,
	Items = type1.SkinData,
	Default = nil,
	Callback = function(value)
		type1.SkinSelect = {}
		Flags["Select Skin to Roll"] = value

		for _, skin_name in value do
			table.insert(type1.SkinSelect, skin_name)
		end
	end
})

RollStand_Section:Dropdown({
	Name = "Select Strength to Roll",
	Flag = "Select Strength to Roll",
	Description = "Select stand strength to wait for",
	Multi = true,
	Items = type1.StatRollDisplay,
	Default = nil,
	Callback = function(value)
		type1.StandStrengthSelect = {}
		Flags["Select Strength to Roll"] = value

		for _, display_text in value do
			local stat_name = display_text:match("^(.-) %[[^%]]+%]$")

			if stat_name then
				table.insert(type1.StandStrengthSelect, stat_name)
			end
		end
	end
})

RollStand_Section:Dropdown({
	Name = "Select Speed to Roll",
	Flag = "Select Speed to Roll",
	Description = "Select stand speed to wait for",
	Multi = true,
	Items = type1.StatRollDisplay,
	Default = nil,
	Callback = function(value)
		type1.StandSpeedSelect = {}
		Flags["Select Speed to Roll"] = value

		for _, display_text in value do
			local stat_name = display_text:match("^(.-) %[[^%]]+%]$")

			if stat_name then
				table.insert(type1.StandSpeedSelect, stat_name)
			end
		end
	end
})

RollStand_Section:Dropdown({
	Name = "Select Specialty to Roll",
	Flag = "Select Specialty to Roll",
	Description = "Select stand specialty to wait for",
	Multi = true,
	Items = type1.StatRollDisplay,
	Default = nil,
	Callback = function(value)
		type1.StandSpecialtySelect = {}
		Flags["Select Specialty to Roll"] = value

		for _, display_text in value do
			local stat_name = display_text:match("^(.-) %[[^%]]+%]$")

			if stat_name then
				table.insert(type1.StandSpecialtySelect, stat_name)
			end
		end
	end
})

RollStand_Section:Dropdown({
	Name = "Select Personality to Roll",
	Flag = "Select Personality to Roll",
	Description = "Select stand personality to wait for",
	Multi = true,
	Items = type1.PersonalityDisplay,
	Default = nil,
	Callback = function(value)
		type1.StandPersonalitySelect = {}
		Flags["Select Personality to Roll"] = value

		for _, display_text in value do
			local personality_name = display_text:match("^(.-) %[[^%]]+%]$")

			if personality_name then
				table.insert(type1.StandPersonalitySelect, personality_name)
			end
		end
	end
})

RollStand_Toogle = RollStand_Section:Toggle({
	Name = "Auto Roll Stand",
	Flag = "Auto Roll Stand",
	Description = "Auto roll for selected stand",
	Default = false,
	Callback = function(value)
		Flags["Auto Roll Stand"] = value
	end
})

RollStand_Section:Button():Add("Open a Stand Info", function()
	if StandInfo then 
		StandInfo:Clean()
		StandInfo = nil
	end
	wait()
	type4.CreateInfo()
end)

local CollectItem_Section = Pages["Item"]:Section({ Name = "Auto Collect Item", Side = 1 })

CollectItem_Section:Dropdown({
	Name = "Select Item to Collect",
	Flag = "Select Item to Collect",
	Description = "Select item type to collect",
	Multi = true,
	Items = type1.ItemDisplay,
	Default = {type1.ItemDisplay[1]},
	Callback = function(value)
		type1.ItemSelect = {}
		Flags["Select Item to Collect"] = value

		for _, display_text in value do
			local item_name = display_text:match("^(.-) %[[^%]]+%]$")

			if item_name then
				table.insert(type1.ItemSelect, item_name)
			end
		end
	end
})

CollectItem_Section:Toggle({
	Name = "Auto Collect Item",
	Flag = "Auto Collect Item",
	Description = "Auto collect selected items",
	Default = false,
	Callback = function(value)
		Flags["Auto Collect Item"] = value
	end
})

CollectItem_Section:Toggle({
	Name = "Hop when no Item",
	Flag = "Hop when no Item",
	Description = "Hop when no item found",
	Default = false,
	Callback = function(value)
		Flags["Hop when no Item"] = value
	end
})

local OpenChest_Section = Pages["Item"]:Section({ Name = "Auto Open Chest", Side = 1 })

OpenChest_Section:Dropdown({
	Name = "Select Chest to Open",
	Flag = "Select Chest to Open",
	Description = "Select chest type to open",
	Multi = true,
	Items = type1.ChestDisplay,
	Default = nil,
	Callback = function(value)
		type1.ChestSelect = {}
		Flags["Select Chest to Open"] = value

		for _, display_text in value do
			local chest_name = display_text:match("^(.-) %[[^%]]+%]$")

			if chest_name then
				table.insert(type1.ChestSelect, chest_name)
			end
		end
	end
})

OpenChest_Section:Toggle({
	Name = "Auto Open Chest",
	Flag = "Auto Open Chest",
	Description = "Auto open selected chests",
	Default = false,
	Callback = function(value)
		Flags["Auto Open Chest"] = value
	end
})

OpenChest_Section:Slider({
	Name = "Auto Open Chest Threshold",
	Flag = "Auto Open Chest Threshold",
	Description = "Max chest open attempts",
	Default = 3,
	Min = 0,
	Max = 99,
	Decimals = 1,
	Suffix = "",
	Callback = function(value)
		Flags["Auto Open Chest Threshold"] = value
	end
})

local CraftItem_Section = Pages["Item"]:Section({ Name = "Auto Craft Item", Side = 1 })

CraftItem_Section:Dropdown({
	Name = "Select Item to Craft",
	Flag = "Select Item to Craft",
	Description = "Select item to open",
	Multi = true,
	Items = type1.CraftDisplay,
	Default = nil,
	Callback = function(value)
		type1.CraftSelect = {}
		Flags["Select Item to Craft"] = value

		for _, display_text in value do
			local item_name = display_text:match("^(.-) %[[^%]]+%]$")

			if item_name then
				table.insert(type1.CraftSelect, item_name)
			end
		end
	end
})

CraftItem_Section:Toggle({
	Name = "Auto Craft Item",
	Flag = "Auto Craft Item",
	Description = "Auto craft selected items",
	Default = false,
	Callback = function(value)
		Flags["Auto Craft Item"] = value
	end
})

local SellItem_Section = Pages["Item"]:Section({ Name = "Auto Sell Item", Side = 1 })

SellItem_Section:Toggle({
	Name = "Auto Sell Item",
	Flag = "Auto Sell Item",
	Description = "Auto sell items below threshold",
	Default = false,
	Callback = function(value)
		Flags["Auto Sell Item"] = value
	end
})

SellItem_Section:Slider({
	Name = "Auto Sell Item Threshold",
	Flag = "Auto Sell Item Threshold",
	Description = "Sell items below this value",
	Default = 300,
	Min = 0,
	Max = 999,
	Decimals = 1,
	Suffix = "",
	Callback = function(value)
		Flags["Auto Sell Item Threshold"] = value
	end
})

local SellAccessories_Section = Pages["Item"]:Section({ Name = "Auto Sell Accessories", Side = 1 })

SellAccessories_Section:Dropdown({
	Name = "Select Rarity to Sell",
	Flag = "Select Rarity to Sell",
	Description = "Select rarity to sell",
	Multi = true,
	Items = type1.AccessoriesRarityDisplay,
	Default = nil,
	Callback = function(value)
		type1.AccessoriesRaritySelect = {}
		Flags["Select Rarity to Sell"] = value

		for _, rarity_name in value do
			table.insert(type1.AccessoriesRaritySelect, rarity_name)
		end
	end
})

SellAccessories_Section:Dropdown({
	Name = "Select Accessories to Keep",
	Flag = "Select Accessories to Keep",
	Description = "Select accessories to keep",
	Multi = true,
	Items = type1.AccessoriesNameDisplay,
	Default = nil,
	Callback = function(value)
		type1.AccessoriesKeepSelect = {}
		Flags["Select Accessories to Keep"] = value

		for _, display_text in value do
			local accessory_name = display_text:match("^(.-) %[[^%]]+%]$")

			if accessory_name then
				table.insert(type1.AccessoriesKeepSelect, accessory_name)
			end
		end
	end
})

SellAccessories_Section:Dropdown({
	Name = "Select Pip to Keep",
	Flag = "Select Pip to Keep",
	Description = "Select pip type to keep",
	Multi = true,
	Items = type1.PipDisplay,
	Default = nil,
	Callback = function(value)
		type1.PipKeepSelect = {}
		Flags["Select Pip to Keep"] = value

		for _, display_text in value do
			local pip_name = display_text:match("^(.-) %[[^%]]+%]$")

			if pip_name then
				table.insert(type1.PipKeepSelect, pip_name)
			end
		end
	end
})

SellAccessories_Section:Toggle({
	Name = "Auto Sell Accessories",
	Flag = "Auto Sell Accessories",
	Description = "Auto sell selected accessories",
	Default = false,
	Callback = function(value)
		Flags["Auto Sell Accessories"] = value
	end
})

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local CashShop_Section = Pages["Shop"]:Section({ Name = "Auto Buy Cash Shop", Side = 1 })

CashShop_Section:Dropdown({
	Name = "Select Cash Item to Buy",
	Flag = "Select Cash Item to Buy",
	Description = "Select item to auto buy",
	Multi = true,
	Items = type1.ShopDisplay,
	Default = nil,
	Callback = function(value)
		type1.CashShopSelect = {}
		Flags["Select Cash Item to Buy"] = value

		for _, display_text in value do
			local shop_item = display_text:match("^(.-) %[[^%]]+%]$")

			if shop_item then
				table.insert(type1.CashShopSelect, shop_item)
			end
		end
	end
})

CashShop_Section:Toggle({
	Name = "Auto Buy Cash Shop",
	Flag = "Auto Buy Cash Shop",
	Description = "Auto buy selected items",
	Default = false,
	Callback = function(value)
		Flags["Auto Buy Cash Shop"] = value
	end
})

local GangShop_Section = Pages["Shop"]:Section({ Name = "Auto Buy Gang Shop", Side = 1 })

GangShop_Section:Dropdown({
	Name = "Select Gang Item to Buy",
	Flag = "Select Gang Item to Buy",
	Description = "Select item to auto buy",
	Multi = true,
	Items = type1.ShopDisplay,
	Default = nil,
	Callback = function(value)
		type1.GangShopSelect = {}
		Flags["Select Gang Item to Buy"] = value

		for _, display_text in value do
			local shop_item = display_text:match("^(.-) %[[^%]]+%]$")

			if shop_item then
				table.insert(type1.GangShopSelect, shop_item)
			end
		end
	end
})

GangShop_Section:Toggle({
	Name = "Auto Buy Gang Shop",
	Flag = "Auto Buy Gang Shop",
	Description = "Auto buy selected items",
	Default = false,
	Callback = function(value)
		Flags["Auto Buy Gang Shop"] = value
	end
})

local RaidShop_Section = Pages["Shop"]:Section({ Name = "Auto Buy Raid Shop", Side = 1 })

RaidShop_Section:Dropdown({
	Name = "Select Raid Item to Buy",
	Flag = "Select Raid Item to Buy",
	Description = "Select item to auto buy",
	Multi = true,
	Items = type1.ShopDisplay,
	Default = nil,
	Callback = function(value)
		type1.RaidShopSelect = {}
		Flags["Select Raid Item to Buy"] = value

		for _, display_text in value do
			local shop_item = display_text:match("^(.-) %[[^%]]+%]$")

			if shop_item then
				table.insert(type1.RaidShopSelect, shop_item)
			end
		end
	end
})

RaidShop_Section:Toggle({
	Name = "Auto Buy Raid Shop",
	Flag = "Auto Buy Raid Shop",
	Description = "Auto buy selected items",
	Default = false,
	Callback = function(value)
		Flags["Auto Buy Raid Shop"] = value
	end
})

local OpenGui_Section = Pages["Shop"]:Section({ Name = "Open Gui", Side = 1 })

OpenGui_Section:Dropdown({
	Name = "Select Gui to Open",
	Flag = "Select Gui to Open",
	Description = "Select gui to open",
	Multi = false,
	Items = {"Crafting", "Cash Shop", "Gang Shop", "Prestige Shop", "Raid Shop"},
	Default = nil,
	Callback = function(value)
		Flags["Select Gui to Open"] = value
	end
})

OpenGui_Section:Button():Add("Open a Gui", function()
	local shop1 = PlayerGUI:FindFirstChild(Flags["Select Gui to Open"])
	local shop2 = shop1 and shop1:FindFirstChildOfClass("ImageLabel")

	if shop2 then
		shop2.Visible = true
	end
end)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local AddStat_Section = Pages["Misc"]:Section({ Name = "Auto Add Stat", Side = 1 })

AddStat_Section:Dropdown({
	Name = "Select Stat to Add",
	Flag = "Select Stat to Add",
	Description = "Select stat type to add",
	Multi = true,
	Items = type1.StatList,
	Default = nil,
	Callback = function(value)
		type1.StatSelect = {}
		Flags["Select Stat to Add"] = value

		for _, stat in value do
			table.insert(type1.StatSelect, stat)
		end
	end
})

AddStat_Section:Toggle({
	Name = "Auto Add Stat",
	Flag = "Auto Add Stat",
	Description = "Auto add selected stats",
	Tooltip = "Automatically add the selected Stats",
	Default = false,
	Callback = function(value)
		Flags["Auto Add Stat"] = value

		if value then
			for _, stat in type1.StatSelect do
				if type2.slot.StatPoints.Value < Flags["Stat Amount"] then
					break
				end

				type2.character.increase_stat:FireServer(stat:gsub("%s+", "") .. "Stat", Flags["Stat Amount"])
				wait(0.3)
			end
		end
	end
})

AddStat_Section:Slider({
	Name = "Stat Amount",
	Flag = "Stat Amount",
	Description = "Amount of stat to add",
	Default = 1,
	Min = 0,
	Max = 30,
	Decimals = 1,
	Suffix = "",
	Callback = function(value)
		Flags["Stat Amount"] = value
	end
})

local Bus_Section = Pages["Misc"]:Section({Name = "TP to Bus", Side = 1})

Bus_Section:Dropdown({
	Name = "Select Bus to TP",
	Flag = "Select Bus to TP",
	Description = "Select bus to teleport",
	Items = type1.BusList,
	Default = nil,
	Callback = function(value)
		Flags["Select Bus to TP"] = value
	end
})

Bus_Section:Button():Add("TP to Bus", function()
	for _, bus in buses:GetChildren() do
		if bus.Name == Flags["Select Bus to TP"] then
			type4.TP(type4.CanTP(bus))
			break
		end
	end
end)

local NPC_Section = Pages["Misc"]:Section({Name = "TP to NPC", Side = 1})

NPC_Section:Dropdown({
	Name = "Select NPC to TP",
	Flag = "Select NPC to TP",
	Description = "Select NPC to teleport",
	Multi = false,
	Items = type1.NPCList,
	Default = nil,
	Callback = function(value)
		Flags["Select NPC to TP"] = value
	end
})

NPC_Section:Button():Add("TP to NPC", function()
	local npc = type4.GetNPC2(Flags["Select NPC to TP"])

	if npc then
		type4.TP(type4.CanTP(npc))
	end
end)

local Fly_Section = Pages["Misc"]:Section({ Name = "Fly Settings", Side = 1 })

local FlyToggle = Fly_Section:Toggle({
	Name = "Fly Toggle",
	Flag = "Fly Toggle",
	Description = "Can fly when turned on",
	Default = false,
	Callback = function(value)
		Flags["Fly Toggle"] = value

		if type4.HasCooldown("Loaded") then
			if value then
				type4.FlyNormal()
			else
				type4.StopFly()
			end
		end
	end
})

FlyToggle:Keybind({
	Name = "Fly Keybind",
	Flag = "Fly Keybind",
	Mode = "Toggle",
	Default = nil,
	Callback = function(value)
		Flags["Fly Keybind"] = value

		if type4.HasCooldown("Loaded") then
			FlyToggle:Set(value)
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
	Name = "Touch the Grass",
	Flag = "Touch the Grass",
	Description = "Set walk speed and jump power",
	Default = false,
	Callback = function(value)
		Flags["Touch the Grass"] = value
	end
})

Player_Section:Toggle({
	Name = "Infinite Jump",
	Flag = "Infinite Jump",
	Description = "Jump without cooldown",
	Default = false,
	Callback = function(value)
		Flags["Infinite Jump"] = value  

		if value then
			getgenv()["Infinite Jump"] = UserInputService.InputBegan:Connect(function(input, processed)
				if not processed and input.KeyCode == Enum.KeyCode.Space then
					if type4.IsActive(char) then
						char.Humanoid:ChangeState(3)
					end
				end
			end)
		else
			if type4.HasCooldown("Loaded") then
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
		if not type4.IsActive(char) then return end

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
		if not type4.IsActive(char) then return end

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
	type4.Hop(Flags["Select Method to Hop"])
end)

Server_Button:Add("Rejoin Server", function()
	Library:Notification({
		Name = "Info",
		Description = "Rejoining the current server...",
		Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Duration = 5
	})

	local rejoin_a, rejoin_b = pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
	end)

	if not rejoin_a then
		Library:Notification({
			Name = "Error",
			Description = "Failed to rejoin server: " .. tostring(rejoin_b),
			Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
			Duration = 8
		})
	end
end)

local FPS_Section = Pages["Misc"]:Section({ Name = "FPS Settings", Side = 1 })

FPS_Section:Toggle({
	Name = "Super Boost FPS",
	Flag = "Super Boost FPS",
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

			local color_correction = Lighting:FindFirstChild("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
			color_correction.Name = "ColorCorrectionEffect"
			color_correction.Brightness = -0.05
			color_correction.Contrast = 0.1
			color_correction.Saturation = -0.1
			color_correction.Enabled = true
			color_correction.Parent = Lighting

			local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
			if atmosphere then
				atmosphere.Density = 0.05
				atmosphere.Haze = 0.2
				atmosphere.Glare = 0
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

			type4.InsertConnections(Workspace.DescendantAdded:Connect(VIRTUALIZE622))

			type4.InsertTasks(spawn(function()
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
	Description = "Enable black screen overlay",
	Default = false,
	Callback = function(value)

		if value then
			BlackScreen = Instances:Create("ScreenGui", {
				Parent = PlayerGUI,
				Name = "\0",
				DisplayOrder = -9e9,
				ResetOnSpawn = false,
				IgnoreGuiInset = true
			})

			BlackFrame = Instances:Create("Frame", {
				Parent = BlackScreen.Instance,
				Name = "\0",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0,
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
			})

			BlackButton = Instances:Create("TextButton", {
				Parent = BlackScreen.Instance,
				Name = "\0",
				Size = UDim2.new(0, getgenv().relix and 150 or 220, 0, 45),
				Position = UDim2.new(0.5, 0, 0.66, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Theme.Element,
				BackgroundTransparency = 1,
				BorderColor3 = Color3.new(0, 0, 0),
				BorderSizePixel = 0,
				Text = "Toggle Black Screen",
				TextColor3 = Theme.Text,
				TextTransparency = 1,
				TextSize = getgenv().relix and 13 or 15,
				FontFace = Font
			})

			BlackStroke = Instances:Create("UIStroke", {
				Name = "\0",
				Parent = BlackButton.Instance,
				Color = Theme.Border,
				Thickness = 1,
				Transparency = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			})

			Instances:Create("UICorner", {
				Name = "\0",
				Parent = BlackButton.Instance,
				CornerRadius = UDim.new(0, 5)
			})

			Instances:Create("UIGradient", {
				Name = "\0",
				Parent = BlackButton.Instance,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(216, 216, 216))
				}),
				Rotation = 90
			})

			BlackButton:MakeDraggable()

			type4.InsertConnections(BlackButton:Connect("MouseEnter", function()
				BlackButton:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = getgenv().relix and UDim2.new(0, 160, 0, 48) or UDim2.new(0, 230, 0, 48)})
			end))

			type4.InsertConnections(BlackButton:Connect("MouseLeave", function()
				BlackButton:Tween(TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = getgenv().relix and UDim2.new(0, 150, 0, 45) or UDim2.new(0, 220, 0, 45)})
			end))

			type4.InsertConnections(BlackButton:Connect("MouseButton1Down", function()
				BlackButton:Tween(TweenInfo.new(0.08), {Size = getgenv().relix and UDim2.new(0, 140, 0, 42) or UDim2.new(0, 210, 0, 42)})
			end))

			type4.InsertConnections(BlackButton:Connect("MouseButton1Up", function()
				BlackButton:Tween(TweenInfo.new(0.08), {Size = getgenv().relix and UDim2.new(0, 150, 0, 45) or UDim2.new(0, 220, 0, 45)})
			end))

			type4.InsertConnections(BlackButton:Connect("MouseButton1Click", function()
				BlackFrame.Instance.Visible = not BlackFrame.Instance.Visible
				RunService:Set3dRenderingEnabled(not BlackFrame.Instance.Visible)
			end))

			BlackButton:Tween(TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = getgenv().relix and UDim2.new(0, 150, 0, 45) or UDim2.new(0, 220, 0, 45), BackgroundTransparency = 0, TextTransparency = 0})

			spawn(function()
				wait(0.3)
				BlackStroke:Tween(TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
			end)
		else
			if BlackScreen then
				BlackScreen:Clean()
				BlackScreen = nil 
			end
			wait()
			RunService:Set3dRenderingEnabled(true)			
		end
	end
})

local ChangeSkin_Section = Pages["Misc"]:Section({ Name = "Skin Settings", Side = 1 })

ChangeSkin_Section:Dropdown({
	Name = "Select Skin to Change",
	Flag = "Select Skin to Change",
	Description = "Select stand skin to use",
	Items = type1.ChangeSkinList,
	Default = nil,
	Callback = function(value)
		Flags["Select Skin to Change"] = value
	end
})

ChangeSkin_Section:Button():Add("Change a Skin", function()
	local selected_skin = ReplicatedStorage.assets.models.stands:FindFirstChild(Flags["Select Skin to Change"]) or ReplicatedStorage.assets.models.stands.Skins:FindFirstChild(Flags["Select Skin to Change"])
	local player_stand = Workspace.Effects:FindFirstChild("." .. plr.Name .. "'s Stand")

	if selected_skin and player_stand then
		local stand_parts = selected_skin:FindFirstChild("StandParts") or selected_skin
		local stand_parts = player_stand:FindFirstChild("StandParts") or player_stand

		for _, target_part in stand_parts:GetChildren() do
			if target_part:IsA("BasePart") then
				local source_part = stand_parts:FindFirstChild(target_part.Name)

				if source_part and source_part:IsA("BasePart") then
					target_part.Color = source_part.Color
					target_part.Material = source_part.Material
					target_part.Reflectance = source_part.Reflectance
					target_part.Transparency = 0

					if target_part:IsA("MeshPart") and source_part:IsA("MeshPart") then
						target_part.MeshId = source_part.MeshId
						target_part.TextureID = source_part.TextureID
					end

					local old_surface_appearance = target_part:FindFirstChildWhichIsA("SurfaceAppearance")
					if old_surface_appearance then Debris:AddItem(old_surface_appearance, 0) end

					local source_surface_appearance = source_part:FindFirstChildWhichIsA("SurfaceAppearance")
					if source_surface_appearance then source_surface_appearance:Clone().Parent = target_part end

					for _, source_child in source_part:GetChildren() do
						if source_child:IsA("ParticleEmitter") or source_child:IsA("Decal") or source_child:IsA("Texture") then

							local target_child = target_part:FindFirstChild(source_child.Name)
							if target_child then Debris:AddItem(target_child, 0) end

							local cloned_child = source_child:Clone()
							if cloned_child:IsA("ParticleEmitter") then cloned_child.Enabled = true end

							cloned_child.Parent = target_part
						end
					end
				end
			end
		end
	end
end)

for _, part_name in {"Hair", "Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso"} do 
	ChangeSkin_Section:Slider({
		Name = part_name .. " Size",
		Flag = part_name .. " Size",
		Description = "Stand " .. part_name:lower() .. " size",
		Default = 0.3,
		Min = 0,
		Max = 3,
		Decimals = 0.001,
		Suffix = "",
		Callback = function(value)
			if not type4.HasCooldown("Loaded") then return end

			local player_stand = Workspace.Effects:FindFirstChild("." .. plr.Name .. "'s Stand")

			if player_stand and player_stand:FindFirstChild("StandParts") and player_stand.StandParts:FindFirstChild(part_name) then 
				player_stand.StandParts[part_name].Size = Vector3.new(value, value, value)
			end
		end
	})

	ChangeSkin_Section:Slider({
		Name = part_name .. " Transparency",
		Flag = part_name .. " Transparency",
		Description = "Stand " .. part_name:lower() .. " transparency",
		Default = 0.3,
		Min = 0,
		Max = 1,
		Decimals = 0.001,
		Suffix = "",
		Callback = function(value)
			if not type4.HasCooldown("Loaded") then return end

			local player_stand = Workspace.Effects:FindFirstChild("." .. plr.Name .. "'s Stand")

			if player_stand and player_stand:FindFirstChild("StandParts") and player_stand.StandParts:FindFirstChild(part_name) then 
				player_stand.StandParts[part_name].Transparency = value
			end
		end
	})
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Webhook_Section = {}

for _, mode in {"Raid", "Stand", "Item", "Build"} do
	local name = mode == "Raid" and "Auto Farm Raid" or mode == "Stand" and "Auto Roll Stand" or mode == "Item" and "Auto Collect Item" or mode == "Build" and "Build and Settings"

	Webhook_Section[mode] = Pages["Webhook"]:Section({ Name = "Auto Send Webhook [" .. name .. "]", Side = 1 })

	Webhook_Section[mode]:Textbox({
		Name = "Webhook URL",
		Flag = "Webhook URL " .. mode,
		Description = "Enter webhook URL",
		Default = "",
		Placeholder = "Paste your webhook URL",
		Callback = function(value)
			Flags["Webhook URL " .. mode] = value
		end
	})

	if mode ~= "Build" then
		Webhook_Section[mode]:Textbox({
			Name = "Mention Option",
			Flag = "Mention Option " .. mode,
			Description = "Discord mention option",
			Default = "",
			Placeholder = "e.g. @everyone, @here",
			Callback = function(value)
				Flags["Mention Option " .. mode] = value
			end
		})

		Webhook_Section[mode]:Toggle({
			Name = "Auto Send Webhook",
			Flag = "Auto Send Webhook " .. mode,
			Description = "Automatically send a webhook",
			Default = false,
			Callback = function(value)
				Flags["Auto Send Webhook " .. mode] = value
			end
		})
	end

	if mode == "Build" then
		Webhook_Section[mode]:Button():Add("Send Webhook", function()
			local stand_a, stand_b = pcall(function()
				return HttpService:JSONDecode(type2.slot.Stand.Value)
			end)

			local accessories_a, accessories_b = pcall(function()
				return HttpService:JSONDecode(type2.slot.EquippedAccessories.Value)
			end)

			local perk_a, perk_b = pcall(function()
				return HttpService:JSONDecode(type2.slot.EquippedPerks.Value)
			end)

			if not stand_a or not stand_b or not accessories_a or not accessories_b or not perk_a or not perk_b then
				return false
			end

			local random_name = ""
			local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

			for i = 1, 30 do
				local index = math.random(1, #chars)

				random_name = random_name .. chars:sub(index, index)
			end

			local accessories_text = ""

			for slot, data in pairs(accessories_b) do
				if data.Name then
					local pips = ""

					if data.Pips and #data.Pips > 0 then
						pips = ": " .. table.concat(data.Pips, ", ")
					end
					accessories_text = accessories_text .. data.Name .. pips .. "\n"
				end
			end

			accessories_text = accessories_text:gsub("\n$", "")

			local perk_text = ""

			for i = 1, 4 do
				local perk_key = tostring(i)

				if perk_b[perk_key] then
					perk_text = perk_text .. i .. ": " .. perk_b[perk_key] .. "\n"
				end
			end

			perk_text = perk_text:gsub("\n$", "")

			local settings_text = ""

			settings_text = settings_text .. "Instant Kill: " .. tostring(Flags["Instant Kill"]) .. "\n"
			settings_text = settings_text .. "Grab Skill: " .. (next(type1.SkillGrabSelect) and table.concat(type1.SkillGrabSelect, ", ") or "None") .. "\n"
			settings_text = settings_text .. "Instant Kill Threshold: " .. tostring(Flags["Instant Kill Threshold"]) .. "%\n"
			settings_text = settings_text .. "Instant Kill Cast Delay: " .. tostring(Flags["Instant Kill Cast Delay"]) .. "s"
			settings_text = settings_text .. "Instant Kill Hold Delay: " .. tostring(Flags["Instant Kill Hold Delay"]) .. "s"

			local discord_message = Webhook.CreateMessage(Flags["Webhook URL " .. mode], "solixhub", nil)

			local embed = discord_message:AddEmbed("Bizarre Lineage", "")
			embed:AddField("Name", random_name)
			embed:AddField("Stand", "Name: " .. stand_b.Name .. "\n" .. "Strength: " .. stand_b.Strength .. "\n" .. "Speed: " .. stand_b.Speed .. "\n" .. "Specialty: " .. stand_b.Specialty .. "\n" .. "Personality: " .. stand_b.Trait)
			embed:AddField("Perk", perk_text)
			embed:AddField("Stat", "Strength: " .. type2.slot.StrengthStat.Value .. "\n" .. "Defense: " .. type2.slot.DefenseStat.Value .. "\n" .. "Power: " .. type2.slot.PowerStat.Value .. "\n" .. "Weapon: " .. type2.slot.WeaponStat.Value .. "\n" .. "Destructive Power: " .. type2.slot.DestructivePowerStat.Value .. "\n" .. "Destructive Energy: " .. type2.slot.DestructiveEnergyStat.Value)
			embed:AddField("Accessories", accessories_text)
			embed:AddField("Settings", settings_text)

			pcall(function()
				type4.AddCooldown("Auto Send Webhook", 3)
				discord_message:SendMessage()
			end)
		end)
	end

	Webhook_Section[mode]:Button():Add("Test Webhook", function()
		local webhook_url = Flags["Webhook URL " .. mode]

		if not webhook_url or webhook_url == "" then
			Library:Notification({
				Name = "Webhook",
				Description = "Please enter a valid Webhook URL",
				Color = Color3.fromRGB(255, 0, 0),
				Duration = 5
			})
			return
		end

		local webhook = Webhook.CreateMessage(webhook_url, "solixhub", "hi chat")

		webhook:SendMessage()
	end)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if type2.slot.Stand.Value == "{}" then
	plr:Kick("Get a stand first 😭🙏")
end

if IsRaid then
	delay(Flags["Auto Retry Timeout"] * 60, function()
		TeleportService:Teleport(14890802310, plr)
	end)
end

local VIRTUALIZE204 = LPH_NO_VIRTUALIZE(function(name, duration)
	type4.AddCooldown(name, duration)
end)

type2.general.StandCooldown.OnClientEvent:Connect(VIRTUALIZE204)

local VIRTUALIZE732 = LPH_NO_VIRTUALIZE(function()
	wait(0.3)
	if not Flags["Auto Add Stat"] then return end

	for _, stat in type1.StatSelect do
		if type2.slot.StatPoints.Value < Flags["Stat Amount"] then
			break
		end

		type2.character.increase_stat:FireServer(stat:gsub("%s+", "") .. "Stat", Flags["Stat Amount"])
		wait(0.3)
	end
end)

type4.InsertConnections(type2.slot.StatPoints:GetPropertyChangedSignal("Value"):Connect(VIRTUALIZE732))

local VIRTUALIZE933 = LPH_NO_VIRTUALIZE(function(message)
	local normalized_text = type4.NormalizeText(message)

	print(normalized_text)

	if string.find(normalized_text, "Your opponent is") then
		type3.PvP = true
	elseif normalized_text == "Joined PvP Mission Queue" then
		type3.PvP = true
	elseif table.find(type1.MissionList, normalized_text) then
		type3.PvP = false
	end

	if normalized_text == "Exterminate the targets" then
		type3.PvE = normalized_text
	elseif string.find(normalized_text, "Deliver the") then
		type3.PvE = normalized_text
	elseif table.find(type1.MissionList, normalized_text) then
		type3.PvE = nil
	end

	if string.find(normalized_text, "Your Contract is to") then
		type3.GangContract = normalized_text
	elseif normalized_text == "Contract failed" then
		type3.GangContract = nil
	end

	if normalized_text == "A World Event is starting. Head to the Morioh Train Station to participate" then
		type3.WorldEvent = true

		delay(110, function()
			type3.WorldEvent = false
		end)
	elseif table.find(type1.WorldEventList, normalized_text) then
		type3.WorldEvent = false
	end
end)

type4.InsertConnections(type2.general.notification.OnClientEvent:Connect(VIRTUALIZE933))

local VIRTUALIZE893 = LPH_NO_VIRTUALIZE(function()
	wait(0.3)
	if type4.HasCooldown("Auto Send Webhook") then return end
	if not PlayerGUI:FindFirstChild("raidcomplete") then return end

	repeat wait(0.3) until type4.FindPath(PlayerGUI, "raidcomplete", "raid", "stand_info_holder", "list", "ScrollingFrame", "holder")

	if Flags["Auto Send Webhook Raid"] then
		local discord_message = Webhook.CreateMessage(Flags["Webhook URL Raid"], "solixhub", Flags["Mention Option Raid"])

		local embed = discord_message:AddEmbed("Bizarre Lineage", "")
		local stand_info_holder = type4.FindPath(PlayerGUI, "raidcomplete", "raid", "stand_info_holder")
		local timer_text = type4.FindPath(PlayerGUI, "MainHud", "topsection", "fourth", "timer")
		local rating_text = type4.FindPath(stand_info_holder, "list", "ScrollingFrame", "holder", "rating")
		local rewards_holder = type4.FindPath(stand_info_holder, "list", "ScrollingFrame", "holder")

		embed:AddField("Name", "||" .. plr.Name .. " [" .. type2.slot.Level.Value .. "]||")

		local reward_items = {}

		if stand_info_holder then
			embed:AddField("Match", "Map: " .. tostring(type3.MapName) .. "\n" .. ("Rating: " .. (rating_text and rating_text.Text) or "?") .. "\n" .. ((timer_text and timer_text.Text) or "Time Elapsed: ?") .. "\n" .. "Server Age: " .. type4.ToTime(os.time() - tonumber(ReplicatedStorage.server_start.Value)))

			local token_a, token_b = pcall(function()
				return HttpService:JSONDecode(type2.slot.RaidTokens.Value)
			end)

			local total_raid = "solixhub/Datas/5130394318/" .. type3.MapName
			local current_total = 0

			if isfile(total_raid) then
				current_total = tonumber(readfile(total_raid)) or 0
			end

			writefile(total_raid, tostring(current_total + 1))

			if token_a and token_b then
				embed:AddField("Raid", "Tokens: " .. tostring(token_b[type3.MapName] or 0) .. "\nTotal Raid: " .. tostring(current_total + 1))
			end

			local rewards_loaded = false
			local last_count = 0
			local stable_frames = 0

			for iteration = 1, 30 do
				local item_count = 0

				for _, child_item in rewards_holder:GetChildren() do
					if child_item:IsA("Frame") then
						local misc_text = child_item:FindFirstChild("misc")
						local item_text = child_item:FindFirstChild("item")
						local name_text = child_item:FindFirstChild("TextLabel")

						if misc_text or item_text or (name_text and name_text.Name == "TextLabel") then
							item_count = item_count + 1
						end
					end
				end

				if item_count >= 3 and item_count == last_count then
					stable_frames = stable_frames + 1
				else
					stable_frames = 0
				end

				last_count = item_count

				if stable_frames >= 3 then
					rewards_loaded = true
					break
				end
				wait(0.3)
			end

			for _, reward_frame in rewards_holder:GetChildren() do
				if reward_frame:IsA("Frame") then
					local reward_text = nil
					if reward_frame:FindFirstChild("misc") then
						reward_text = reward_frame.misc.Text
					elseif reward_frame:FindFirstChild("item") then
						reward_text = reward_frame.item.Text
					elseif reward_frame:FindFirstChild("name") then
						reward_text = reward_frame.name.Text
					end

					if reward_text and not table.find(reward_items, reward_text) then
						table.insert(reward_items, string.format("%s [%s]", reward_text, tostring(type4.GetInventory(reward_text) or "?")))
					end
				end
			end

			if #reward_items > 0 then
				table.sort(reward_items, function(item_a, item_b) return item_a < item_b end)
				embed:AddField("Rewards", table.concat(reward_items, "\n"))
			else
				embed:AddField("Rewards", "I don't know 😭🙏")
			end
		end

		pcall(function()
			type4.AddCooldown("Auto Send Webhook", 36)
			discord_message:SendMessage()
		end)
	end

	wait(3)

	local teleport_action = Flags["Select Action to Teleport"]

	if Flags["Auto Farm Storyline"] and type4.GetStoryline() ~= nil then
		TeleportService:Teleport(14890802310, plr)
	elseif teleport_action == "Retry" then
		type2.character.retryraid:FireServer()
	elseif teleport_action == "Teleport" then
		TeleportService:Teleport(14890802310, plr)
	end
end)

type4.InsertConnections(PlayerGUI.ChildAdded:Connect(VIRTUALIZE893))

local VIRTUALIZE152 = LPH_NO_VIRTUALIZE(function()
	getgenv().Ability = type2.get:InvokeServer("ability")
end)

type4.InsertConnections(plr.PlayerData.Conjuration:GetPropertyChangedSignal("Value"):Connect(VIRTUALIZE152))

local VIRTUALIZE970 = LPH_NO_VIRTUALIZE(function()
	if not Flags["Auto Retry"] or not IsRaid or type3.CanRetry then return end

	if type4.GetMob() == nil then
		type3.CanRetry = true

		delay(Flags["Auto Retry Delay"], function()
			if type4.GetMob() == nil then
				local action = Flags["Select Action to Teleport"]

				if Flags["Auto Farm Storyline"] and type4.GetStoryline() ~= nil then
					TeleportService:Teleport(14890802310, plr)
				elseif action == "Retry" then
					type2.character.retryraid:FireServer()
				elseif action == "Teleport" then
					TeleportService:Teleport(14890802310, plr)
				end
			end
			type3.CanRetry = false
		end)
	end
end)

type4.InsertConnections(Workspace.Effects.ChildAdded:Connect(VIRTUALIZE970))
type4.InsertConnections(Workspace.Effects.ChildRemoved:Connect(VIRTUALIZE970))
type4.InsertConnections(Workspace.Live.ChildAdded:Connect(VIRTUALIZE970))
type4.InsertConnections(Workspace.Live.ChildRemoved:Connect(VIRTUALIZE970))

local VIRTUALIZE466 = LPH_NO_VIRTUALIZE(function()
	wait(30) 
	TeleportService:Teleport(14890802310, plr)
end)

type4.InsertConnections(GuiService.ErrorMessageChanged:Connect(VIRTUALIZE466))

local VIRTUALIZE472 = LPH_NO_VIRTUALIZE(function(v)
	if v.Name == "ErrorPrompt" then
		wait(30)
		TeleportService:Teleport(14890802310, plr)
	end
end)

type4.InsertConnections(CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(VIRTUALIZE472))

type4.InsertTasks(spawn(function()
	while wait(0.3) do
		local valid_library, _ = pcall(function() return getgenv().Library end)
		local valid_webhook, _ = pcall(function()
			return loadstring(game:HttpGet("https://raw.githubusercontent.com/meobeo8/Misc/a/Webhook.lua"))()
		end)

		if valid_library and valid_webhook and valid_library ~= nil and valid_webhook ~= nil then
			getgenv().solix = true
			type4.AddCooldown("Loaded")
			return
		end
	end
end))

type4.InsertTasks(spawn(function() 
	local mob, player, item = nil, nil 

	while wait() do 
		local a, b = pcall(function() 
			if not type4.IsActive(char) then return end 

			if char.HumanoidRootPart.Anchored then 
				char.HumanoidRootPart.Anchored = false 
			end 

			if Flags["Touch the Grass"] then 
				char.Humanoid.WalkSpeed = Flags["Walk Speed"] 
				char.Humanoid.JumpPower = Flags["Jump Power"] 
			end 

			if Flags["Auto Summon Stand"] then
				type4.SummonStand()
			end 

			if Flags["Auto Open Chest"] then
				type4.OpenChest() 
			end

			if Flags["Auto Craft Item"] then
				type4.CraftItem() 
			end

			if Flags["Auto Sell Item"] then
				type4.SellItem() 
			end

			if Flags["Auto Sell Accessories"] then
				type4.SellAccessories()
			end

			if Flags["Auto Buy Cash Shop"] then
				type4.CashShop() 
			end

			if Flags["Auto Buy Gang Shop"] then
				type4.GangShop() 
			end

			if Flags["Auto Buy Raid Shop"] then
				type4.RaidShop() 
			end

			if Flags["Auto Prestige"] then
				if type4.Prestige() then return end
			end

			if Flags["Auto Workouts"] and IsWorld then
				if type4.Workouts() then return end
			end

			if Flags["Auto Roll Stand"] then
				if type4.RollStand() then return end
			end

			if Flags["Auto Collect Item"] and IsWorld then
				if type4.CollectItem() then return end
			end

			if Flags["Auto Join Raid"] and IsWorld then
				type4.JoinRaid() 
			end

			if Flags["Auto Farm World Event"] and IsWorld then
				if type4.WorldEvent() then return end
			end

			if Flags["Auto Farm Jean Pierre Polnareff"] and IsWorld then
				if type4.FarmJeanPierrePolnareff() then return end
			end

			if Flags["Auto Farm Raid"] and IsRaid then
				if type4.FarmRaid() then return end
			end

			if Flags["Auto Farm Boss"] and IsWorld then
				if type4.FarmBoss() then return end
			end

			if Flags["Auto Farm Storyline"] then
				if type4.Storyline() then return end
			end

			if Flags["Auto Farm Gang"] and IsWorld then
				if type4.FarmGang() then return end
			end

			if Flags["Auto Farm PvE"] and IsWorld then
				if type4.FarmPvE() then return end
			end

			if Flags["Auto Farm Mob"] then
				if type4.FarmMob() then return end
			end

			if Flags["Auto Farm Nearest"] then
				if type4.FarmNearest() then return end
			end

			if Flags["Auto Farm Civilian"] and IsWorld then
				if type4.FarmCivilian() then return end
			end

			if Flags["Auto Farm PvP"] and IsWorld then
				if type4.FarmPvP() then return end
			end

			if Flags["Auto Farm Player"] then
				if type4.FarmPlayer() then return end
			end

			if Flags["Auto Meditate"] and IsWorld then
				if type4.Meditate() then return end
			end

			if Flags["Auto Stand Pose"] then
				if type4.StandPose() then return end
			end
		end) 
		if not a then 
			print(b) 
		end 
	end 
end))

Library:CheckForAutoLoad()