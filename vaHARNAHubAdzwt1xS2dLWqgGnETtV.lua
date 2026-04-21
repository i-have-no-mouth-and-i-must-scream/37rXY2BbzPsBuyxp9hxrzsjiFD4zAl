repeat wait() until game:IsLoaded()

getgenv().lilix = getgenv().lilix or nil
getgenv().relix = getgenv().relix or nil

getgenv().key = getgenv().key or nil
getgenv().luarmor_api = getgenv().luarmor_api or nil
getgenv().key_expire = getgenv().key_expire or nil
getgenv().key_note = getgenv().key_note or nil
getgenv().key_executions = getgenv().key_executions or nil

if not LPH_OBFUSCATED then
	LPH_JIT_MAX = function(...) return ... end
	LPH_NO_VIRTUALIZE = function(f) return f end
	LPH_NO_UPVALUES = function(...) return ... end
	LPH_CRASH = function(...) return ... end
else
	print = function() end
	warn = function() end
end

local Library = getgenv().Library

if type(Library) ~= "table" or not next(Library) then
	Library = {}
	getgenv().Library = Library
else
	if type(Library.Unload) == "function" then
		local Success = pcall(Library.Unload, Library)

		if Success then
			Library = {}
			getgenv().Library = Library
		else
			for Key, _ in pairs(Library) do
				Library[Key] = nil
			end
		end
	end
end

local Folder_Configs = {
	Directory = "solixhub",
	Assets = "solixhub/Assets",
	Configs = "solixhub/Configs",
	Images = "solixhub/Images",
	Themes = "solixhub/Themes"
}

local function GetFolders()
	local Library = getgenv().Library

	if Library and (Library["Folders"] or Library.Folders_Path) then 
		return Library["Folders"] or Library.Folders_Path
	end

	return Folder_Configs
end

local function GetAutoloadPath()
	return GetFolders().Configs .. "/" .. tostring(game.GameId) .. "/autoload.json"
end

for _, Image in {"pleco.png", "tonight.png"} do
	local ImagePath = Folder_Configs.Images .. "/" .. Image

	if isfile(ImagePath) then
		delfile(ImagePath)
	end
end

for _, Folder in {"solixhub", "solixhub/Assets", "solixhub/Configs", "solixhub/Images", "solixhub/Themes"} do
	if not isfolder(Folder) then
		makefolder(Folder)
	end
end

Library["Folders"] = Folder_Configs
Library.Folders_Path = Folder_Configs

local Library do 
	local wait = task.wait
	local spawn = task.spawn
	local delay = task.delay
	local defer = task.defer

	local cloneref = cloneref or function(o) return o end

	local CoreGui = cloneref(game:GetService("CoreGui"))
	local Debris = cloneref(game:GetService("Debris"))
	local TweenService = cloneref(game:GetService("TweenService"))
	local UserInputService = cloneref(game:GetService("UserInputService"))
	local Players = cloneref(game:GetService("Players"))
	local TextService = cloneref(game:GetService("TextService"))
	local HttpService = cloneref(game:GetService("HttpService"))
	local RunService = cloneref(game:GetService("RunService"))

	local GetUI = gethui or function()
		local Success, Result = pcall(function()
			local CoreGui = game:GetService("CoreGui")

			return CoreGui
		end)

		return Success and Result or nil
	end

	local function SafeGetUI()
		local Success, Result = pcall(GetUI)

		if Success and Result then
			return Result
		end

		return game:GetService("CoreGui")
	end

	local LocalPlayer = Players.LocalPlayer
	local Mouse = LocalPlayer:GetMouse()

	local FromRGB = Color3.fromRGB
	local FromHSV = Color3.fromHSV
	local FromHex = Color3.fromHex

	local RGBSequence = ColorSequence.new
	local RGBSequenceKeypoint = ColorSequenceKeypoint.new
	local NumSequence = NumberSequence.new
	local NumSequenceKeypoint = NumberSequenceKeypoint.new

	local UDim2New = UDim2.new
	local UDimNew = UDim.new
	local UDim2FromOffset = UDim2.fromOffset
	local Vector2New = Vector2.new
	local Vector3New = Vector3.new

	local MathClamp = math.clamp
	local MathFloor = math.floor
	local MathAbs = math.abs
	local MathSin = math.sin

	local TableInsert = table.insert
	local TableFind = table.find
	local TableRemove = table.remove
	local TableConcat = table.concat
	local TableClone = table.clone
	local TableUnpack = table.unpack

	local StringFormat = string.format
	local StringFind = string.find
	local StringGSub = string.gsub
	local StringLower = string.lower
	local StringLen = string.len

	local InstanceNew = Instance.new

	local RectNew = Rect.new

	local IsMobile = false

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		IsMobile = true
	elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		IsMobile = false
	elseif UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then 
		IsMobile = false
	end 

	Library = {
		Theme =  {},

		MenuKeybind = tostring(Enum.KeyCode.RightControl), 

		Flags = {},

		Tween = {
			Time = 0.3,
			Style = Enum.EasingStyle.Quad,
			Direction = Enum.EasingDirection.Out
		},

		FadeSpeed = 0.2,

		BackgroundTransparency = 0.25,

		Folders_Path = {
			Assets = "solixhub/Assets",
			Configs = "solixhub/Configs",
			Directory = "solixhub",
			Images = "solixhub/Images",
			Themes = "solixhub/Themes"
		},

		Pages = {},
		Sections = {},

		Windows = {},
		AllSections = {},

		SearchItems = {},
		CurrentPage = nil,

		Connections = {},
		Threads = {},

		ThemeMap = {},
		ThemeItems = {},

		OpenFrames = {},

		SliderElements = {},
		TextboxElements = {},
		SectionElements = {},

		HideOnOverlap = function(self, IsOpen, OptionHolder)
			if not IsOpen then
				for _, TextboxData in Library.TextboxElements do
					TextboxData.Input.Instance.TextTransparency = 0
				end
				return
			end

			if not OptionHolder or not OptionHolder.Parent then return end

			local DropTop = OptionHolder.AbsolutePosition.Y
			local DropBottom = DropTop + OptionHolder.AbsoluteSize.Y

			for _, TextboxData in Library.TextboxElements do
				local TextboxTop = TextboxData.Background.Instance.AbsolutePosition.Y
				local TextboxBottom = TextboxTop + TextboxData.Background.Instance.AbsoluteSize.Y

				if TextboxBottom > DropTop and TextboxTop < DropBottom then
					TextboxData.Input.Instance.TextTransparency = 1
				else
					TextboxData.Input.Instance.TextTransparency = 0
				end
			end
		end,

		SetFlags = {},
		Themes = {},

		UnnamedConnections = 0,
		UnnamedFlags = 0,

		Holder = nil,
		NotifHolder = nil,
		UnusedHolder = nil,

		Font = nil
	}

	Library.__index = Library
	Library.Sections.__index = Library.Sections
	Library.Pages.__index = Library.Pages

	Library["Folders"] = Folder_Configs
	Library.Folders_Path = Folder_Configs

	local Keys = {
		["Unknown"]           = "Unknown",
		["Backspace"]         = "Back",
		["Tab"]               = "Tab",
		["Clear"]             = "Clear",
		["Return"]            = "Return",
		["Pause"]             = "Pause",
		["Escape"]            = "Escape",
		["Space"]             = "Space",
		["QuotedDouble"]      = '"',
		["Hash"]              = "#",
		["Dollar"]            = "$",
		["Percent"]           = "%",
		["Ampersand"]         = "&",
		["Quote"]             = "'",
		["LeftParenthesis"]   = "(",
		["RightParenthesis"]  = " )",
		["Asterisk"]          = "*",
		["Plus"]              = "+",
		["Comma"]             = ",",
		["Minus"]             = "-",
		["Period"]            = ".",
		["Slash"]             = "`",
		["Three"]             = "3",
		["Seven"]             = "7",
		["Eight"]             = "8",
		["Colon"]             = ":",
		["Semicolon"]         = ";",
		["LessThan"]          = "<",
		["GreaterThan"]       = ">",
		["Question"]          = "?",
		["Equals"]            = "=",
		["At"]                = "@",
		["LeftBracket"]       = "LeftBracket",
		["RightBracket"]      = "RightBracked",
		["BackSlash"]         = "BackSlash",
		["Caret"]             = "^",
		["Underscore"]        = "_",
		["Backquote"]         = "`",
		["LeftCurly"]         = "{",
		["Pipe"]              = "|",
		["RightCurly"]        = "}",
		["Tilde"]             = "~",
		["Delete"]            = "Delete",
		["End"]               = "End",
		["KeypadZero"]        = "Keypad0",
		["KeypadOne"]         = "Keypad1",
		["KeypadTwo"]         = "Keypad2",
		["KeypadThree"]       = "Keypad3",
		["KeypadFour"]        = "Keypad4",
		["KeypadFive"]        = "Keypad5",
		["KeypadSix"]         = "Keypad6",
		["KeypadSeven"]       = "Keypad7",
		["KeypadEight"]       = "Keypad8",
		["KeypadNine"]        = "Keypad9",
		["KeypadPeriod"]      = "KeypadP",
		["KeypadDivide"]      = "KeypadD",
		["KeypadMultiply"]    = "KeypadM",
		["KeypadMinus"]       = "KeypadM",
		["KeypadPlus"]        = "KeypadP",
		["KeypadEnter"]       = "KeypadE",
		["KeypadEquals"]      = "KeypadE",
		["Insert"]            = "Insert",
		["Home"]              = "Home",
		["PageUp"]            = "PageUp",
		["PageDown"]          = "PageDown",
		["RightShift"]        = "RightShift",
		["LeftShift"]         = "LeftShift",
		["RightControl"]      = "RightControl",
		["LeftControl"]       = "LeftControl",
		["LeftAlt"]           = "LeftAlt",
		["RightAlt"]          = "RightAlt"
	}

	local Themes = {
		["Preset"] = {
			["Background"] = FromRGB(15, 12, 16),
			["Inline"] = FromRGB(22, 20, 24),
			["Border"] = FromRGB(41, 37, 45),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(185, 185, 185),
			["Accent"] = FromRGB(232, 186, 248),
			["Element"] = FromRGB(36, 32, 39),
		},

		["Halloween"] = {
			["Background"] = FromRGB(48, 24, 7),
			["Inline"] = FromRGB(34, 14, 8),
			["Border"] = FromRGB(79, 40, 16),
			["Shadow"] = FromRGB(255, 98, 0),
			["Text"] = FromRGB(195, 195, 195),
			["Inactive Text"] = FromRGB(116, 116, 116),
			["Accent"] = FromRGB(255, 98, 0),
			["Element"] = FromRGB(68, 28, 0),
			["Gradient"] = FromRGB(150, 150, 150)
		},

		["Aqua"] = {
			["Background"] = FromRGB(19, 21, 23),
			["Inline"] = FromRGB(31, 35, 39),
			["Border"] = FromRGB(48, 56, 63),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(245, 245, 245),
			["Inactive Text"] = FromRGB(185, 185, 185),
			["Accent"] = FromRGB(31, 106, 181),
			["Element"] = FromRGB(58, 66, 77),
			["Gradient"] = FromRGB(211, 211, 211)
		},

		["Onetap"] = {
			["Background"] = FromRGB(51, 51, 51),
			["Inline"] = FromRGB(30, 30, 30),
			["Border"] = FromRGB(0, 0, 0),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(185, 185, 185),
			["Accent"] = FromRGB(237, 170, 0),
			["Element"] = FromRGB(45, 45, 45),
			["Gradient"] = FromRGB(211, 211, 211)
		},

		["Bitchbot"] = {
			["Background"] = FromRGB(33, 33, 33),
			["Inline"] = FromRGB(14, 14, 14),
			["Border"] = FromRGB(0, 0, 0),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(185, 185, 185),
			["Accent"] = FromRGB(158, 79, 249),
			["Element"] = FromRGB(22, 20, 20),
			["Gradient"] = FromRGB(211, 211, 211)
		},

		["Gamesense"] = {
			["Background"] = FromRGB(22, 22, 22),
			["Inline"] = FromRGB(17, 17, 17),
			["Border"] = FromRGB(37, 37, 37),
			["Shadow"] = FromRGB(34, 34, 34),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(185, 185, 185),
			["Accent"] = FromRGB(211, 255, 53),
			["Element"] = FromRGB(53, 53, 53),
			["Gradient"] = FromRGB(156, 156, 156)
		},

		["Midnight"] = {
			["Background"] = FromRGB(14, 16, 24),
			["Inline"] = FromRGB(22, 26, 40),
			["Border"] = FromRGB(40, 48, 72),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(160, 170, 200),
			["Accent"] = FromRGB(88, 166, 255),
			["Element"] = FromRGB(30, 38, 58),
			["Gradient"] = FromRGB(180, 190, 220)
		},

		["Rose"] = {
			["Background"] = FromRGB(28, 14, 18),
			["Inline"] = FromRGB(40, 22, 28),
			["Border"] = FromRGB(68, 38, 48),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 240, 245),
			["Inactive Text"] = FromRGB(200, 165, 180),
			["Accent"] = FromRGB(255, 105, 180),
			["Element"] = FromRGB(48, 26, 34),
			["Gradient"] = FromRGB(255, 200, 220)
		},

		["Nature"] = {
			["Background"] = FromRGB(14, 22, 16),
			["Inline"] = FromRGB(22, 34, 26),
			["Border"] = FromRGB(38, 58, 44),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(160, 200, 170),
			["Accent"] = FromRGB(72, 200, 100),
			["Element"] = FromRGB(28, 44, 32),
			["Gradient"] = FromRGB(180, 230, 195)
		},

		["Crimson"] = {
			["Background"] = FromRGB(24, 12, 12),
			["Inline"] = FromRGB(36, 18, 18),
			["Border"] = FromRGB(60, 30, 30),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(200, 160, 160),
			["Accent"] = FromRGB(220, 60, 60),
			["Element"] = FromRGB(40, 22, 22),
			["Gradient"] = FromRGB(230, 180, 180)
		},

		["Lavender"] = {
			["Background"] = FromRGB(18, 16, 26),
			["Inline"] = FromRGB(28, 24, 40),
			["Border"] = FromRGB(50, 42, 72),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(185, 175, 210),
			["Accent"] = FromRGB(170, 130, 255),
			["Element"] = FromRGB(32, 28, 52),
			["Gradient"] = FromRGB(210, 190, 255)
		},

		["Ocean"] = {
			["Background"] = FromRGB(12, 20, 26),
			["Inline"] = FromRGB(18, 32, 40),
			["Border"] = FromRGB(30, 54, 68),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(155, 195, 210),
			["Accent"] = FromRGB(50, 210, 230),
			["Element"] = FromRGB(24, 40, 50),
			["Gradient"] = FromRGB(170, 230, 240)
		},

		["Solar"] = {
			["Background"] = FromRGB(26, 20, 12),
			["Inline"] = FromRGB(40, 30, 18),
			["Border"] = FromRGB(68, 50, 30),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(210, 190, 150),
			["Accent"] = FromRGB(255, 180, 50),
			["Element"] = FromRGB(44, 34, 22),
			["Gradient"] = FromRGB(255, 220, 160)
		},

		["Stealth"] = {
			["Background"] = FromRGB(25, 25, 25),
			["Inline"] = FromRGB(35, 35, 35),
			["Border"] = FromRGB(55, 55, 55),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(160, 160, 160),
			["Accent"] = FromRGB(0, 200, 255),
			["Element"] = FromRGB(40, 40, 40),
			["Gradient"] = FromRGB(200, 200, 200)
		},

		["Nebula"] = {
			["Background"] = FromRGB(16, 10, 24),
			["Inline"] = FromRGB(26, 16, 40),
			["Border"] = FromRGB(50, 30, 75),
			["Shadow"] = FromRGB(100, 50, 150),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(185, 165, 220),
			["Accent"] = FromRGB(200, 100, 255),
			["Element"] = FromRGB(32, 20, 50),
			["Gradient"] = FromRGB(220, 180, 255)
		},

		["Neverlose"] = {
			["Background"] = FromRGB(12, 12, 12),
			["Inline"] = FromRGB(20, 20, 20),
			["Border"] = FromRGB(35, 35, 35),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(150, 150, 150),
			["Accent"] = FromRGB(220, 30, 30),
			["Element"] = FromRGB(25, 25, 25),
			["Gradient"] = FromRGB(200, 200, 200)
		},

		["Aimware"] = {
			["Background"] = FromRGB(18, 22, 28),
			["Inline"] = FromRGB(28, 34, 42),
			["Border"] = FromRGB(48, 58, 72),
			["Shadow"] = FromRGB(0, 0, 0),
			["Text"] = FromRGB(255, 255, 255),
			["Inactive Text"] = FromRGB(160, 175, 195),
			["Accent"] = FromRGB(0, 200, 120),
			["Element"] = FromRGB(38, 48, 62),
			["Gradient"] = FromRGB(180, 210, 200)
		}
	}

	Library.Theme = TableClone(Themes["Preset"])
	Library.Themes = Themes

	local LibFolders = GetFolders()

	for Index, Value in LibFolders do 
		if not isfolder(Value) then
			makefolder(Value)
		end
	end

	local GameName = tostring(game.GameId)
	local GameConfigFolder = LibFolders.Configs .. "/" .. GameName

	if not isfolder(GameConfigFolder) then
		makefolder(GameConfigFolder)
	end

	local Tween = {} do
		Tween.__index = Tween

		Tween.Create = function(self, Item, Info, Goal, IsRawItem)
			if not Library then
				return
			end

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

			return NewTween
		end

		Tween.GetProperty = function(self, Item)
			local className = Item.ClassName

			if className == "Frame" then
				return { "BackgroundTransparency" }
			elseif className == "TextLabel" or className == "TextButton" then
				return { "TextTransparency", "BackgroundTransparency" }
			elseif className == "ImageLabel" or className == "ImageButton" then
				return { "BackgroundTransparency", "ImageTransparency" }
			elseif className == "ScrollingFrame" then
				return { "BackgroundTransparency", "ScrollBarImageTransparency" }
			elseif className == "TextBox" then
				return { "TextTransparency", "BackgroundTransparency" }
			elseif className == "UIStroke" then
				return { "Transparency" }
			end
		end

		Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
			local Item = Item or self.Item 
			local OldTransparency = Item[Property]

			Item[Property] = Visibility and 1 or OldTransparency

			local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
				[Property] = Visibility and OldTransparency or 1
			}, true)

			if NewTween and NewTween.Tween then
				Library:Connect(NewTween.Tween.Completed, function()
					if not Visibility then
						wait()
						Item[Property] = OldTransparency
					end
				end)
			end

			return NewTween
		end

		Tween.Get = function(self)
			if not self.Tween then 
				return
			end

			return self.Tween, self.Info, self.Goal
		end

		Tween.Pause = function(self)
			if not self.Tween then 
				return
			end

			self.Tween:Pause()
		end

		Tween.Play = function(self)
			if not self.Tween then 
				return
			end

			self.Tween:Play()
		end

		Tween.Clean = function(self)
			if not self.Tween then
				return
			end

			self.Tween:Pause()
			self = nil
		end
	end

	local Instances = {} do
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

		Instances.AddToTheme = function(self, Properties)
			if not self.Instance then 
				return
			end

			Library:AddToTheme(self, Properties)

			return self
		end

		Instances.ChangeItemTheme = function(self, Properties)
			if not self.Instance then 
				return
			end

			Library:ChangeItemTheme(self, Properties)
		end

		Instances.Connect = function(self, Event, Callback, Name)
			if not self.Instance then 
				return
			end

			if not self.Instance[Event] then 
				return
			end

			if IsMobile then
				if Event == "MouseButton1Down" or Event == "MouseButton1Click" then
					Event = "TouchTap"
				end
			end

			return Library:Connect(self.Instance[Event], Callback, Name)
		end

		Instances.Set = function(self, Property, Value)
			if not self.Instance then
				return
			end

			self.Instance[Property] = Value
			return self
		end

		Instances.Tween = function(self, Info, Goal)
			if not self.Instance then
				return
			end

			if not Library then
				return
			end

			return Tween:Create(self, Info, Goal)
		end

		Instances.Disconnect = function(self, Name)
			if not self.Instance then 
				return
			end

			return Library:Disconnect(Name)
		end

		Instances.Clean = function(self)
			if not self.Instance then 
				return
			end

			Debris:AddItem(self.Instance, 0)
			self = nil
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

				self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
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

					Changed = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							Dragging = false

							if Changed then
								Changed:Disconnect()
								Changed = nil
							end
						end
					end)
				end
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					if Dragging then
						Set(Input)
					end
				end
			end)

			return Dragging
		end

		Instances.MakeResizeable = function(self, Minimum)
			if not self.Instance then 
				return
			end

			local Gui = self.Instance

			local Resizing = false 
			local CurrentSide = nil

			local StartMouse = nil
			local StartPosition = nil
			local StartSize = nil

			local MakeEdge = function(Name, Position, Size)
				local Button = Instances:Create("TextButton", {
					Parent = Gui,
					Name = "\0",
					Size = Size,
					Position = Position,
					BackgroundColor3 = FromRGB(166, 147, 243),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 99999
				})  Button:AddToTheme({BackgroundColor3 = "Accent"})

				return Button
			end

			local Edges = {
				{Button = MakeEdge(
					"Left", 
					UDim2New(0, 0, 0, 0), 
					UDim2New(0, 1, 1, 0)), 
					Side = "L"
				},

				{Button = MakeEdge(
					"Right", 
					UDim2New(1, -1, 0, 0), 
					UDim2New(0, 1, 1, 0)), 
					Side = "R"
				},

				{Button = MakeEdge(
					"Top", UDim2New(0, 0, 0, 0), 
					UDim2New(1, 0, 0, 1)), 
					Side = "T"
				},

				{Button = MakeEdge(
					"Bottom", 
					UDim2New(0, 0, 1, -1), 
					UDim2New(1, 0, 0, 1)),
					Side = "B"
				},
			}

			local BeginResizing = function(Side)
				Resizing = true
				CurrentSide = Side

				StartMouse = UserInputService:GetMouseLocation()

				StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
				StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)

				for _, Edge in Edges do
					Edge.Button.Instance.BackgroundTransparency = Edge.Side == Side and 0 or 1
				end
			end

			local EndResizing = function()
				Resizing = false
				CurrentSide = nil

				for _, Edge in Edges do
					Edge.Button.Instance.BackgroundTransparency = 1
				end
			end

			for _, Edge in Edges do
				local Side = Edge.Side
				Edge.Button:Connect("InputBegan", function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						BeginResizing(Side)
					end
				end)
			end

			Library:Connect(UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if Resizing then
						EndResizing()
					end
				end
			end)

			Library:Connect(RunService.RenderStepped, function()
				if not Resizing or not CurrentSide then
					return
				end

				local Scale = Library.UIScaleNum or 1
				local MouseLocation = UserInputService:GetMouseLocation()
				local MouseX = (MouseLocation.X - StartMouse.X) / Scale
				local MouseY = (MouseLocation.Y - StartMouse.Y) / Scale

				local PostionX, PostionY = StartPosition.X, StartPosition.Y
				local SizeX, SizeY = StartSize.X, StartSize.Y

				if CurrentSide == "L" then
					PostionX = StartPosition.X + MouseX
					SizeX = StartSize.X - MouseX
				elseif CurrentSide == "R" then
					SizeX = StartSize.X + MouseX
				elseif CurrentSide == "T" then
					PostionY = StartPosition.Y + MouseY
					SizeY = StartSize.Y - MouseY
				elseif CurrentSide == "B" then
					SizeY = StartSize.Y + MouseY
				end

				if SizeX < Minimum.X then
					if CurrentSide == "L" then
						PostionX = PostionX - (Minimum.X - SizeX)
					end
					SizeX = Minimum.X
				end

				if SizeY < Minimum.Y then
					if CurrentSide == "T" then
						PostionY = PostionY - (Minimum.Y - SizeY)
					end
					SizeY = Minimum.Y
				end

				self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(PostionX, PostionY)})
				self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(SizeX, SizeY)})
			end)
		end

		Instances.OnHover = function(self, Function)
			if not self.Instance then 
				return
			end

			return Library:Connect(self.Instance.MouseEnter, Function)
		end

		Instances.OnHoverLeave = function(self, Function)
			if not self.Instance then 
				return
			end

			return Library:Connect(self.Instance.MouseLeave, Function)
		end

		Instances.Tooltip = function(self, Text)
			if not self.Instance then 
				return
			end

			if Text == nil or Text == "" then 
				return
			end

			local Gui = self.Instance

			local MouseLocation = UserInputService:GetMouseLocation()
			local RenderStepped
			local Scale = Library.UIScaleNum or 1

			local Items = {} do
				Items["Tooltip"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					Size = UDim2New(0, 0, 0, 0),
					Position = UDim2New(0, MouseLocation.X / Scale, 0, (MouseLocation.Y - 22) / Scale),
					BackgroundColor3 = Library.Theme["Background"],
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					ZIndex = 99,
					Visible = true
				}):AddToTheme({BackgroundColor3 = 'Background'})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Tooltip"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 1, 0),
					BackgroundColor3 = FromRGB(15, 12, 16),
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Text = Text,
					TextColor3 = Library.Theme["Text"],
					TextSize = 14,
					FontFace = Library.Font,
					TextTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClipsDescendants = true,
					AutomaticSize = Enum.AutomaticSize.XY,
					ZIndex = 99
				}):AddToTheme({TextColor3 = 'Text'})

				Instances:Create("UIPadding", {
					Parent = Items["Text"].Instance,
					Name = "\0",
					PaddingLeft = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 8),
					PaddingTop = UDimNew(0, 8),
					PaddingBottom = UDimNew(0, 8)
				})

				Instances:Create("UICorner", {
					Parent = Items["Tooltip"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})
			end

			Library:Connect(Gui.MouseEnter, function()
				Items["Tooltip"].Instance.Position = UDim2New(0, MouseLocation.X / Scale, 0, (MouseLocation.Y - 42) / Scale)
				Items["Tooltip"]:Tween(nil, {BackgroundTransparency = 0})
				Items["Text"]:Tween(nil, {TextTransparency = 0})

				RenderStepped = RunService.RenderStepped:Connect(function()
					MouseLocation = UserInputService:GetMouseLocation()

					local Scale = Library.UIScaleNum or 1

					Items["Tooltip"]:Tween(nil, {Position = UDim2New(0, MouseLocation.X / Scale, 0, (MouseLocation.Y - 42) / Scale)})
				end)
			end)

			Library:Connect(Gui.MouseLeave, function()
				Items["Tooltip"]:Tween(nil, {BackgroundTransparency = 1})
				Items["Text"]:Tween(nil, {TextTransparency = 1})

				if RenderStepped then 
					RenderStepped:Disconnect()
					RenderStepped = nil
				end
			end)
		end
	end

	local CustomFont = {} do
		function CustomFont:New(Name, Weight, Style, Data)
			if not isfile(Data.Id) then
				writefile(Data.Id, game:HttpGet(Data.Url))
			end

			local AssetSuccess, AssetId = pcall(getcustomasset, Data.Id)
			if not AssetSuccess then
				return Font.fromEnum(Enum.Font.Gotham)
			end

			local FontData = {
				name = Name,
				faces = {
					{
						name = Name,
						weight = Weight,
						style = Style,
						assetId = AssetId
					}
				}
			}

			local FontPath = GetFolders().Assets .. "/" .. Name .. ".font"
			if not isfile(FontPath) then
				writefile(FontPath, HttpService:JSONEncode(FontData))
			end

			local FontAssetSuccess, FontAssetId = pcall(getcustomasset, FontPath)
			if not FontAssetSuccess then
				return Font.fromEnum(Enum.Font.Gotham)
			end

			return Font.new(FontAssetId)
		end

		local FontSuccess = pcall(function()
			Library.Font = CustomFont:New("InterSemibold", 400, "Regular", {
				Id = "InterSemibold",
				Url = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/InterSemibold.ttf"
			})
		end)

		if not FontSuccess then
			Library.Font = Font.fromEnum(Enum.Font.Gotham)
		end
	end

	Library.Holder = Instances:Create("ScreenGui", {
		Parent = SafeGetUI(),
		Name = "\0",
		DisplayOrder = 2,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	})

	if not Library.Holder.Instance then
		local Success, Result = pcall(function()
			return Instance.new("ScreenGui")
		end)

		if Success then
			Library.Holder = {
				Instance = Result,
				Properties = {},
				Class = "ScreenGui"
			}

			Library.Holder.Instance.Parent = SafeGetUI()
			Library.Holder.Instance.Name = "\0"
			Library.Holder.Instance.ZIndexBehavior = Enum.ZIndexBehavior.Global
			Library.Holder.Instance.DisplayOrder = 2
			Library.Holder.Instance.ResetOnSpawn = false
		end
	end

	wait()

	local ViewportSize = function()
		local Camera = Workspace.CurrentCamera

		return (Camera and Camera.ViewportSize) or Vector2New(1920, 1080)
	end

	Library.UIScaleDesignSize = Vector2New(770, 526)
	Library.UIScaleScreenPercent = 2.3 / 3
	Library.UIScaleObject = Instances:Create("UIScale", {
		Parent = Library.Holder.Instance,
		Name = "\0",
		Scale = 1
	})

	Library.UIScaleNum = 1

	function Library:SetScaleFromScreenPercent(Percent)
		Percent = MathClamp(Percent, 0.2, 1)

		self.UIScaleScreenPercent = Percent

		local DesignWidth, DesignHeight = self.UIScaleDesignSize.X, self.UIScaleDesignSize.Y
		local Scale

		if IsMobile then
			local Viewport = ViewportSize()

			Scale = Viewport.Y / 450
			Scale = Scale * Percent
			Scale = MathClamp(Scale, 0.8, 2.5)
		else
			local Viewport = ViewportSize()
			local TargetWidth = math.min(DesignWidth, Viewport.X * Percent)
			local TargetHeight = math.min(DesignHeight, Viewport.Y * Percent)

			local ScaleWidth = TargetWidth / DesignWidth
			local ScaleHeight = TargetHeight / DesignHeight

			Scale = math.min(ScaleWidth, ScaleHeight)
			Scale = MathClamp(Scale, 0.5, 1.2)
		end

		self.UIScaleObject.Instance.Scale = Scale
		self.UIScaleNum = Scale
	end

	function Library:SetScaleNumeric(Value)
		Value = MathClamp(Value, 300, 1400)

		self.UIScaleNumeric = Value
		self.UIScaleScreenPercent = Value / 1400

		local Viewport = ViewportSize()
		local Scale = Viewport.Y / Value
		Scale = MathClamp(Scale, 0.3, 3)

		self.UIScaleObject.Instance.Scale = Scale
		self.UIScaleNum = Scale
	end

	Library:SetScaleNumeric(1000)

	local ScaleValues = {
		["Very Small"] = 1200,
		["Small"] = 1100,
		["Medium"] = 1000,
		["Large"] = 800,
		["Bigger"] = 600,
		["Massive"] = 500,
	}

	defer(function()
		local Camera = Workspace.CurrentCamera

		if Camera then
			Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				if Library.UIScaleNumeric then
					Library:SetScaleNumeric(Library.UIScaleNumeric)
				end
			end)
		end
	end)

	Library.OtherHolder = Instances:Create("ScreenGui", {
		Parent = SafeGetUI(),
		Name = "\0",
		DisplayOrder = 2,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	})

	Library.FloatingButtonHolder = Instances:Create("ScreenGui", {
		Parent = SafeGetUI(),
		Name = "\0",
		DisplayOrder = 3,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	})

	Library.UnusedHolder = Instances:Create("ScreenGui", {
		Parent = SafeGetUI(),
		Name = "\0",
		Enabled = false,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global
	})

	wait()

	Library.NotifHolder = Instances:Create("Frame", {
		Parent = Library.Holder.Instance,
		Name = "\0",
		Size = UDim2New(0, 0, 1, 0),
		Position = UDim2New(1, 0, 0, 0),
		AnchorPoint = Vector2New(1, 0),
		BackgroundTransparency = 1,
		BorderColor3 = FromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X
	})
	Library.NotifLayoutOrder = 0

	Instances:Create("UIListLayout", {
		Parent = Library.NotifHolder.Instance,
		Name = "\0",
		Padding = UDimNew(0, 20),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right
	})

	Instances:Create("UIPadding", {
		Parent = Library.NotifHolder.Instance,
		Name = "\0",
		PaddingLeft = UDimNew(0, 12),
		PaddingRight = UDimNew(0, 12),
		PaddingTop = UDimNew(0, 12),
		PaddingBottom = UDimNew(0, 12)
	})    

	Library.GetDataFromPlayer = function(self, Section)
		local Player = Players.LocalPlayer

		Section:Label("Username: " .. Player.Name, "")
		Section:Label("UserId: " .. Player.UserId, "")
		Section:Label("Account Age: " .. Player.AccountAge, "")
		Section:Label("PlaceId: " .. (game.PlaceId or "N/A"), "")
	end

	Library.GetDataFromLuarmor = function(self, Section)
		local Labels = {}
		local KeyVars = {
			get = function(var)
				return getgenv()[var]
			end,

			current_key = getgenv().key
		}

		local WarningFrame = nil
		local ExpireThreshold = 550

		local ToTime do
			local UnitMultipliers = {
				{86400, "%dd %dh %dm %ds"},
				{3600, "%dh %dm %ds"},
				{60, "%dm %ds"},
				{1, "%ds"}
			}

			function ToTime(v)
				if not v then
					return "No Key"
				elseif v < 0 then
					return "Lifetime"
				end

				local Days = MathFloor(v / 86400)
				local Hours = MathFloor((v % 86400) / 3600)
				local Minutes = MathFloor((v % 3600) / 60)
				local Seconds = v % 60

				if Days > 0 then
					return StringFormat("%dd %dh %dm %ds", Days, Hours, Minutes, Seconds)
				elseif Hours > 0 then
					return StringFormat("%dh %dm %ds", Hours, Minutes, Seconds)
				elseif Minutes > 0 then
					return StringFormat("%dm %ds", Minutes, Seconds)
				else
					return StringFormat("%ds", Seconds)
				end
			end
		end

		local function UpdateKeyInfo()
			local Expire = KeyVars.get("key_expire")

			if Expire and Expire > 0 then
				local Remaining = Expire - os.time()

				if Remaining > 0 then
					Labels.Expires:SetText("Expires: " .. ToTime(Remaining))
				else
					Players.LocalPlayer:Kick("Your key has expired.")
				end
			else
				Labels.Expires:SetText("Expires: Lifetime")
			end

			Labels.Note:SetText("Note: " .. (KeyVars.get("key_note") or "None"))
			Labels.Executions:SetText("Executions: " .. tostring(KeyVars.get("key_executions") or 0))
		end

		local function ShowKeyWarning()
			if WarningFrame and WarningFrame.Instance then
				return
			end

			WarningFrame = Instances:Create("ImageLabel", {
				Parent = Library.Holder.Instance,
				Name = "\0",
				Size = UDim2New(0, 300, 0, 300),
				Position = UDim2New(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2New(0.5, 0.5),
				BackgroundColor3 = FromRGB(30, 30, 30),
				BorderSizePixel = 0,
				Image = "rbxassetid://75498856718303",
				ImageTransparency = 0,
				ZIndex = 9999
			})

			Instances:Create("UICorner", {
				Parent = WarningFrame.Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 8)
			})

			Instances:Create("TextLabel", {
				Parent = WarningFrame.Instance,
				Name = "\0",
				AnchorPoint = Vector2New(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				FontFace = Library.Font,
				Position = UDim2New(0.5, 0, 0.55, 0),
				RichText = false,
				Size = UDim2New(1, -20, 0, 40),
				Text = "Your key is expiring soon 😭🙏",
				TextColor3 = Library.Theme["Text"],
				TextSize = 20,
				TextWrapped = true,
				ZIndex = 10000
			})
		end

		local function HideKeyWarning()
			if WarningFrame and WarningFrame.Instance then
				Debris:AddItem(WarningFrame.Instance, 0)
				WarningFrame = nil
			end
		end

		local function RefreshKeyFromAPI()
			local Key = KeyVars.get("key")
			local Api = KeyVars.get("luarmor_api")

			if not Key or Key == "" or not Api then
				HideKeyWarning()
				return
			end

			local Success, Result = pcall(Api.check_key, Key)

			if Success and Result and Result.code == "KEY_VALID" then
				local Data = Result.data

				getgenv().key_expire = Data.auth_expire
				getgenv().key_note = Data.note
				getgenv().key_executions = Data.total_executions or 0

				UpdateKeyInfo()

				local Expire = Data.auth_expire

				if Expire and Expire > 0 then
					local Remaining = Expire - os.time()

					if Remaining > 0 and Remaining <= ExpireThreshold then
						ShowKeyWarning()
					elseif Remaining > ExpireThreshold then
						HideKeyWarning()
					end
				elseif Expire == 0 then
					HideKeyWarning()
				end
			end
		end

		local function InitLabels(v)
			if v then
				local Expire = KeyVars.get("key_expire")
				local Text = (Expire and Expire > 0) and ToTime(Expire - os.time()) or "Lifetime"

				Labels = {
					Status = Section:Label("Status: Active", ""),
					Expires = Section:Label("Expires: " .. Text, ""),
					Executions = Section:Label("Executions: " .. tostring(KeyVars.get("key_executions") or 0), ""),
					Note = Section:Label("Note: " .. (KeyVars.get("key_note") or "None"), "")
				}
			else
				Labels = {
					Status = Section:Label("Status: No Key", ""),
					Expires = Section:Label("Expires: Lifetime", ""),
					Executions = Section:Label("Executions: N/A", ""),
					Note = Section:Label("Note: N/A", "")
				}
			end
		end

		local HasKey = KeyVars.current_key and KeyVars.current_key ~= ""

		InitLabels(HasKey)

		Library:Thread(LPH_NO_VIRTUALIZE(function()
			while true do
				wait(1)
				pcall(UpdateKeyInfo)
			end
		end))

		Library:Thread(LPH_NO_VIRTUALIZE(function()
			while true do
				wait(30)
				pcall(RefreshKeyFromAPI)
			end
		end))
	end

	Library.Unload = function(self)
		for Index, Value in self.Connections do 
			Value.Connection:Disconnect()
		end

		for Index, Value in self.Threads do 
			coroutine.close(Value)
		end

		if self.Holder then 
			self.Holder:Clean()
		end

		if self.FloatingButtonHolder then
			Debris:AddItem(self.FloatingButtonHolder.Instance, 0)
		end

		Library = nil 
		getgenv().Library = nil
	end

	Library.Round = function(self, Number, Decimals)
		if not Decimals or Decimals <= 0 then
			return MathFloor(Number + 0.5)
		end

		local Multiplier = 10 ^ Decimals
		return MathFloor(Number * Multiplier + 0.5) / Multiplier
	end

	Library.Thread = function(self, Function)
		local NewThread = coroutine.create(Function)

		coroutine.wrap(function()
			coroutine.resume(NewThread)
		end)()

		TableInsert(self.Threads, NewThread)
		return NewThread
	end

	Library.SafeCall = function(self, Function, ...)
		local Arguements = { ... }
		local Success, Result = pcall(Function, TableUnpack(Arguements))

		if not Success then
			warn(Result)
			return false
		end

		return Success
	end

	Library.Connect = function(self, Event, Callback, Name)
		Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

		local NewConnection = {
			Event = Event,
			Callback = Callback,
			Name = Name,
			Connection = nil
		}

		Library:Thread(function()
			NewConnection.Connection = Event:Connect(Callback)
		end)

		TableInsert(self.Connections, NewConnection)
		return NewConnection
	end

	Library.Disconnect = function(self, Name)
		for _, Connection in self.Connections do 
			if Connection.Name == Name then
				Connection.Connection:Disconnect()
				break
			end
		end
	end

	Library.NextFlag = function(self)
		local FlagNumber = self.UnnamedFlags + 1

		return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
	end

	Library.IsLifetime = function(self)
		local Expire = getgenv().key_expire

		return Expire and Expire == -1
	end

	Library.CheckLifetime = function(self, Element, ElementType)
		if Element.Lifetime then
			if not self:IsLifetime() then
				if not self.UILoadded then
					return true
				end

				Element.ClickCount = (Element.ClickCount or 0) + 1

				self:Notification({
					Name = "Lifetime Required",
					Description = "This feature is only available for Solix Hub Lifetime users, Buy Lifetime key at https://solixhub.com",
					Color = Color3.fromRGB(255, 0, 0),
					Duration = 5
				})

				if Element.ClickCount >= 30 then
					if Element.SetDisabled then
						Element:SetDisabled(true)
					end
				end

				return false
			end
		end

		return true
	end

	Library.AddToTheme = function(self, Item, Properties)
		Item = Item.Instance or Item 

		local ThemeData = {
			Item = Item,
			Properties = Properties,
		}

		for Property, Value in ThemeData.Properties do
			if type(Value) == "string" then

				if not self.Theme[Value] then
					Item[Property] = Value 
				end

				Item[Property] = self.Theme[Value]
			else
				Item[Property] = Value()
			end
		end

		TableInsert(self.ThemeItems, ThemeData)
		self.ThemeMap[Item] = ThemeData
	end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

	Library.GetConfig = function(self)
		local Config = {} 

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Library.Flags do 
				if type(Value) == "table" and Value.Key then
					Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
				elseif type(Value) == "table" and Value.Color then
					Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
				else
					Config[Index] = Value
				end
			end

			if Library.FloatingButton and Library.FloatingButton.Instance then
				local Pos = Library.FloatingButton.Instance.Position

				Config["FloatingButtonPosition"] = {
					X = {Scale = Pos.X.Scale, Offset = Pos.X.Offset},
					Y = {Scale = Pos.Y.Scale, Offset = Pos.Y.Offset}
				}
			end
		end)

		return HttpService:JSONEncode(Config)
	end

	Library.LoadConfig = function(self, Config)
		local Decoded = HttpService:JSONDecode(Config)

		self.LoadingConfig = true

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Decoded do 
				if Index == "FloatingButtonPosition" then
					if Library.FloatingButton and Library.FloatingButton.Instance then
						Library.FloatingButton.Instance.Position = UDim2New(Value.X.Scale, Value.X.Offset, Value.Y.Scale, Value.Y.Offset)
					end
					continue
				end

				if Index == "Auto Save Config" and type(Value) == "boolean" then
					Library.AutoSave = Value
				end

				local SetFunction = Library.SetFlags[Index]

				if not SetFunction then
					continue
				end

				if type(Value) == "table" and Value.Key then 
					SetFunction(Value)
				elseif type(Value) == "table" and Value.Color then
					SetFunction(Value.Color, Value.Alpha)
				else
					SetFunction(Value)
				end
			end
		end)

		self.LoadingConfig = false
		return Success, Result
	end

	Library.RefreshConfigsList = function(self, Element)
		local List = {}
		local ReturnList = {}

		List = listfiles(Library:GetFolder())

		for Index = 1, #List do 
			local File = List[Index]

			if File:sub(-5) == ".json" then
				local Position = File:find(".json", 1, true)
				local StartPosition = Position

				local Character = File:sub(Position, Position)

				while Character ~= "/" and Character ~= "\\" and Character ~= "" do
					Position = Position - 1
					Character = File:sub(Position, Position)
				end

				if Character == "/" or Character == "\\" then
					TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
				end
			end
		end

		Element:Refresh(ReturnList)
	end

	Library.GetTheme = function(self)
		local Config = {} 

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Library.Flags do 
				if type(Value) == "table" and Value.Color and StringFind(Value.Flag, "ThemingThing") then
					Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
				end
			end
		end)

		return HttpService:JSONEncode(Config)
	end

	Library.LoadTheme = function(self, Config)
		local Decoded = HttpService:JSONDecode(Config)

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Decoded do 
				local SetFunction = Library.SetFlags[Index]

				if not SetFunction then
					continue
				end

				if type(Value) == "table" and Value.Color then
					SetFunction(Value.Color, Value.Alpha)
				end
			end
		end)

		return Success, Result
	end

	Library.RefreshThemeList = function(self, Element)
		local List = {}
		local ReturnList = {}

		List = listfiles(GetFolders().Themes)

		for Index = 1, #List do 
			local File = List[Index]

			if File:sub(-5) == ".json" then
				local Position = File:find(".json", 1, true)
				local StartPosition = Position

				local Character = File:sub(Position, Position)

				while Character ~= "/" and Character ~= "\\" and Character ~= "" do
					Position = Position - 1
					Character = File:sub(Position, Position)
				end

				if Character == "/" or Character == "\\" then
					TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
				end
			end
		end

		Element:Refresh(ReturnList)
	end

	Library.ChangeItemTheme = function(self, Item, Properties)
		Item = Item.Instance or Item

		if not self.ThemeMap[Item] then 
			return
		end

		self.ThemeMap[Item].Properties = Properties
		self.ThemeMap[Item] = self.ThemeMap[Item]
	end

	Library.ChangeTheme = function(self, Theme, Color)
		self.Theme[Theme] = Color

		for _, Item in self.ThemeItems do
			for Property, Value in Item.Properties do
				if type(Value) == "string" and Value == Theme then
					Item.Item[Property] = Color
				elseif type(Value) == "function" then
					Item.Item[Property] = Value()
				end
			end
		end
	end

	Library.IsMouseOverFrame = function(self, Frame)
		Frame = Frame.Instance

		local MousePosition = Vector2New(Mouse.X, Mouse.Y)

		return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
			and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
	end

	Library.Lerp = function(self, Start, Finish, Time)
		return Start + (Finish - Start) * Time
	end

	Library.CompareVectors = function(self, PointA, PointB)
		return (PointA.X < PointB.X) and (PointA.Y < PointB.Y)
	end

	Library.IsClipped = function(self, Object, Column)
		local Parent = Column

		local BoundryTop = Parent.AbsolutePosition
		local BoundryBottom = BoundryTop + Parent.AbsoluteSize

		local Top = Object.AbsolutePosition
		local Bottom = Top + Object.AbsoluteSize 

		return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
	end

	Library.GetFolder = function(self)
		return GetFolders().Configs .. "/" .. GameName .. "/"
	end 

	Library.GetFolderTheme = function(self)
		return GetFolders().Themes .. "/"
	end

	Library.SaveAutoloadIfEnabled = function(self)
		if not self.LoadingConfig and self.AutoSave then
			pcall(function()
				writefile(GetAutoloadPath(), self:GetConfig())
			end)
		end
	end

	Library.CheckForAutoLoad = function(self)
		local AutoLoadPath = GetAutoloadPath()

		if not isfile(AutoLoadPath) then
			return
		end

		local ConfigContent = readfile(AutoLoadPath)

		if ConfigContent == "" then
			return
		end

		local Success, Error = Library:LoadConfig(ConfigContent)

		if Success then
			Library:Notification({
				Name = "Success",
				Description = "Succesfully autoloaded config",
				Color = Color3.fromRGB(0, 255, 0),
				Duration = 5
			})
		else
			Library:Notification({
				Name = "Error",
				Description = "Failed to load config: " .. (Error or "Unknown error"),
				Color = Color3.fromRGB(255, 0, 0),
				Duration = 5
			})
		end
	end
	Library.Sections.Toggle = function(self, Data)
		Data = Data or {}

		local Toggle = {
			Window = self.Window,
			Page = self.Page,
			Section = self,

			Name = Data.Name or Data.name or "Toggle",
			Description = Data.Description or Data.description or nil,
			Flag = Data.Flag or Data.flag or Library:NextFlag(),
			Default = Data.Default or Data.default or false,
			Tooltip = Data.Tooltip or Data.tooltip or nil,
			Callback = Data.Callback or Data.callback or function() end,
			Lifetime = Data.Lifetime or Data.lifetime or false,

			Value = false,
			Disabled = false,
		}

		local Items = {} do 
			Items["Toggle"] = Instances:Create("TextButton", {
				Parent = Toggle.Section.Items["Content"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, Toggle.Description and Toggle.Description ~= "" and 40 or 20),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 2
			})

			Items["Toggle"]:Tooltip(Toggle.Tooltip)

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 0, 15),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Toggle.Name,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				AutomaticSize = Enum.AutomaticSize.X,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})

			if Toggle.Description and Toggle.Description ~= "" then
				Items["Description"] = Instances:Create("TextLabel", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					Size = UDim2New(0, 0, 0, 15),
					Position = UDim2New(0, 0, 0, 22),
					AnchorPoint = Vector2New(0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Text = Toggle.Description,
					TextColor3 = Library.Theme["Text"],
					TextSize = 14,
					FontFace = Library.Font,
					TextTransparency = 0.4000000059604645,
					AutomaticSize = Enum.AutomaticSize.X,
					ZIndex = 2
				}):AddToTheme({TextColor3 = 'Text'})
			end

			Items["Indicator"] = Instances:Create("TextButton", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				Size = UDim2New(0, 40, 0, 20),
				Position = UDim2New(1, 0, 0.5, 0),
				AnchorPoint = Vector2New(1, 0.5),
				BackgroundColor3 = Library.Theme["Element"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Element'})

			Instances:Create("UICorner", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})

			Instances:Create("UIGradient", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
			})

			Items["Circle"] = Instances:Create("Frame", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				Size = UDim2New(0, 14, 0, 14),
				Position = UDim2New(0, 3, 0, 3),
				BackgroundTransparency = 0.4000000059604645,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = function()
				return FromRGB(255, 255, 255)
			end})

			Instances:Create("UICorner", {
				Parent = Items["Circle"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})				

			Items["SubElements"] = Instances:Create("Frame", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 1, 0),
				Position = UDim2New(1, -48, 0, 0),
				AnchorPoint = Vector2New(1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0
			})

			Instances:Create("UIListLayout", {
				Parent = Items["SubElements"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})			
		end

		function Toggle:Get()
			return Toggle.Value 
		end

		function Toggle:Set(Value)
			if Toggle.Disabled then
				return
			end

			if not Library:CheckLifetime(Toggle) then
				return
			end

			Toggle.Value = Value
			Library.Flags[Toggle.Flag] = Value

			local ThemeKey = Value and "Accent" or "Element"
			local TextTrans = Value and 0 or 0.4
			local CircleTrans = Value and 0 or 0.4

			Items["Text"]:Tween(nil, {TextTransparency = TextTrans})

			Items["Circle"]:Tween(TweenInfo.new(Library.Tween.Time + 0.2, Enum.EasingStyle.Quart, Library.Tween.Direction), {
				AnchorPoint = Value and Vector2New(1, 0) or Vector2New(0, 0),
				Position = Value and UDim2New(1, -3, 0, 3) or UDim2New(0, 3, 0, 3),
				BackgroundTransparency = CircleTrans,
			})

			Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = ThemeKey})
			Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme[ThemeKey]})

			if Toggle.Callback then
				Library:SafeCall(Toggle.Callback, Toggle.Value)
			end

			Library:SaveAutoloadIfEnabled()
		end

		function Toggle:SetDisabled(Bool)
			Toggle.Disabled = Bool

			local TextTrans = Bool and 0.6 or (Toggle.Value and 0 or 0.4)
			local CircleTrans = Bool and 0.6 or (Toggle.Value and 0 or 0.4)
			local IndicatorTrans = Bool and 0.6 or 0

			Items["Text"]:Tween(nil, {TextTransparency = TextTrans})
			Items["Circle"]:Tween(nil, {BackgroundTransparency = CircleTrans})
			Items["Indicator"]:Tween(nil, {BackgroundTransparency = IndicatorTrans})
		end

		function Toggle:SetVisibility(Bool)
			Items["Toggle"].Instance.Visible = Bool 
		end

		function Toggle:Colorpicker(Data)
			Data = Data or {}

			local Colorpicker = {
				Window = Toggle.Window,
				Page = Toggle.Page,
				Section = Toggle.Section,

				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
				Callback = Data.Callback or Data.callback or function() end,
				Alpha = Data.Alpha or Data.alpha or false
			}

			local NewColorpicker = Library:CreateColorpicker({
				Parent = Items["SubElements"],
				Page = Colorpicker.Page,
				Section = Colorpicker.Section,
				Flag = Colorpicker.Flag,
				Default = Colorpicker.Default,
				Callback = Colorpicker.Callback,
				Alpha = Colorpicker.Alpha
			})

			return NewColorpicker
		end

		function Toggle:Keybind(Data)
			Data = Data or {}

			local Keybind = {
				Window = Toggle.Window,
				Page = Toggle.Page,
				Section = Toggle.Section,

				Name = Data.Name or Data.name or Toggle.Name,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Enum.KeyCode.E,
				Callback = Data.Callback or Data.callback or function() end,
				Mode = Data.Mode or Data.mode or "Toggle"
			}

			local NewKeybind = Library:CreateKeybind({
				Parent = Items["SubElements"],
				Page = Keybind.Page,
				Section = Keybind.Section,
				Flag = Keybind.Flag,
				Name = Keybind.Name,
				Default = Keybind.Default,
				Mode = Keybind.Mode,
				Callback = Keybind.Callback
			})

			return NewKeybind
		end

		local PageSearchData = Library.SearchItems[Toggle.Page] 

		if PageSearchData then
			local SearchData = { 
				Element = Items["Toggle"],
				Name = Toggle.Name,
			}

			TableInsert(PageSearchData, SearchData)
		end

		Items["Indicator"]:Connect("InputBegan", function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Toggle:Set(not Toggle.Value)
			end
		end)

		Items["Toggle"]:Connect("MouseButton1Down", function()
			Toggle:Set(not Toggle.Value)
		end)

		Toggle:Set(Toggle.Default)

		Library.SetFlags[Toggle.Flag] = function(Value)
			if Toggle.Disabled then 
				return 
			end
			Toggle:Set(Value)
		end

		function Toggle:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end
			return Toggle
		end

		Toggle.Items = Items
		return Toggle 
	end

	Library.CreateColorpicker = function(self, Data)
		local Colorpicker = {
			Hue = 0,
			Saturation = 0,
			Value = 0,
			Alpha = 0,

			Flag = Data.Flag,
			Color = FromRGB(255, 255, 255),
			HexValue = "#FFFFFF",

			Disabled = false,
			IsOpen = false
		}

		local Items = {} do 
			Items["ColorpickerButton"] = Instances:Create("TextButton", {
				Parent = Data.Parent.Instance,
				Name = "\0",
				Size = UDim2New(0, 15, 0, 15),
				Position = UDim2New(0, 0, 0, 0),
				BackgroundColor3 = FromRGB(255, 215, 160),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 2
			})

			Instances:Create("UIGradient", {
				Parent = Items["ColorpickerButton"].Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
			})

			Instances:Create("UICorner", {
				Parent = Items["ColorpickerButton"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})                

			Items["ColorpickerWindow"] = Instances:Create("TextButton", {
				Parent = Library.UnusedHolder.Instance,
				Name = "\0",
				Size = UDim2New(0, 218, 0, 0),
				Position = UDim2New(0.005806451663374901, 0, 0.016434893012046814, 0),
				BackgroundColor3 = Library.Theme["Background"],
				BackgroundTransparency = 0.30000001192092896,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				ClipsDescendants = true,
				AutoButtonColor = false
			}):AddToTheme({BackgroundColor3 = 'Background'})

			Instances:Create("UICorner", {
				Parent = Items["ColorpickerWindow"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Hue"] = Instances:Create("TextButton", {
				Parent = Items["ColorpickerWindow"].Instance,
				Name = "\0",
				Size = UDim2New(1, -16, 0, 18),
				Position = UDim2New(0, 8, 1, -75),
				AnchorPoint = Vector2New(0, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2
			})

			Instances:Create("UICorner", {
				Parent = Items["Hue"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["HueDragger"] = Instances:Create("Frame", {
				Parent = Items["Hue"].Instance,
				Name = "\0",
				Size = UDim2New(0, 2, 1, -10),
				Position = UDim2New(0, 12, 0.5, 0),
				AnchorPoint = Vector2New(0, 0.5),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			})

			Instances:Create("UIStroke", {
				Parent = Items["HueDragger"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 1.2000000476837158
			})

			Instances:Create("UICorner", {
				Parent = Items["HueDragger"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})

			Instances:Create("UIGradient", {
				Parent = Items["Hue"].Instance,
				Name = "\0",
				Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
			})                

			Items["Alpha"] = Instances:Create("TextButton", {
				Parent = Items["ColorpickerWindow"].Instance,
				Name = "\0",
				Size = UDim2New(0, 18, 1, -110),
				Position = UDim2New(1, -8, 0, 8),
				AnchorPoint = Vector2New(1, 0),
				BackgroundColor3 = FromRGB(255, 215, 160),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 2
			})

			Instances:Create("UICorner", {
				Parent = Items["Alpha"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["AlphaDragger"] = Instances:Create("Frame", {
				Parent = Items["Alpha"].Instance,
				Name = "\0",
				Size = UDim2New(1, -10, 0, 2),
				Position = UDim2New(0.5, 0, 0, 3),
				AnchorPoint = Vector2New(0.5, 0),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			})

			Instances:Create("UIStroke", {
				Parent = Items["AlphaDragger"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 1.2000000476837158
			})

			Instances:Create("UICorner", {
				Parent = Items["AlphaDragger"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})

			Items["Checkers"] = Instances:Create("ImageLabel", {
				Parent = Items["Alpha"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://18274452449",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2New(0, 6, 0, 6),
				ZIndex = 2
			})

			Instances:Create("UIGradient", {
				Parent = Items["Checkers"].Instance,
				Name = "\0",
				Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)},
				Rotation = 90
			})

			Instances:Create("UICorner", {
				Parent = Items["Checkers"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Palette"] = Instances:Create("TextButton", {
				Parent = Items["ColorpickerWindow"].Instance,
				Name = "\0",
				Size = UDim2New(1, -44, 1, -110),
				Position = UDim2New(0, 9, 0, 8),
				BackgroundColor3 = FromRGB(255, 215, 160),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 2
			})

			Instances:Create("UICorner", {
				Parent = Items["Palette"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Saturation"] = Instances:Create("ImageLabel", {
				Parent = Items["Palette"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://130624743341203",
				ZIndex = 2
			})

			Instances:Create("UICorner", {
				Parent = Items["Saturation"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Value"] = Instances:Create("ImageLabel", {
				Parent = Items["Palette"].Instance,
				Name = "\0",
				Size = UDim2New(1, 2, 1, 0),
				Position = UDim2New(0, -1, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://96192970265863",
				ZIndex = 3
			})

			Instances:Create("UICorner", {
				Parent = Items["Value"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["PaletteDragger"] = Instances:Create("Frame", {
				Parent = Items["Palette"].Instance,
				Name = "\0",
				Size = UDim2New(0, 4, 0, 4),
				Position = UDim2New(0, 5, 0, 5),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			})

			Instances:Create("UICorner", {
				Parent = Items["PaletteDragger"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})

			Instances:Create("UIStroke", {
				Parent = Items["PaletteDragger"].Instance,
				Name = "\0",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 1.2000000476837158
			})

			Items["Background"] = Instances:Create("Frame", {
				Parent = Items["ColorpickerWindow"].Instance,
				Name = "\0",
				Size = UDim2New(1, -16, 0, 25),
				Position = UDim2New(0, 8, 1, -8),
				AnchorPoint = Vector2New(0, 1),
				BackgroundColor3 = Library.Theme["Element"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Element'})

			Instances:Create("UIGradient", {
				Parent = Items["Background"].Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
			})

			Instances:Create("UICorner", {
				Parent = Items["Background"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Input"] = Instances:Create("TextBox", {
				Parent = Items["Background"].Instance,
				Name = "\0",
				Size = UDim2New(1, -16, 1, 0),
				Position = UDim2New(0, 8, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextStrokeColor3 = Library.Theme["Text"],
				PlaceholderText = "Enter RGB..",
				PlaceholderColor3 = Library.Theme["Inactive Text"],
				ClearTextOnFocus = false,
				CursorPosition = -1,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})                
		end

		local AnimDropdown = {
			Value = {},
			Multi = true,
			Callback = function() end,
			Flag = Colorpicker.Flag .. " Animation",
			Options = {},
			MaxSize = 280,
		}

		Items["AnimationsDropdown"] = Instances:Create("Frame", {
			Parent = Items["ColorpickerWindow"].Instance,
			Name = "\0",
			Size = UDim2New(1, -16, 0, 25),
			Position = UDim2New(0, 8, 1, -38),
			AnchorPoint = Vector2New(0, 1),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 2
		})

		Items["Text"] = Instances:Create("TextLabel", {
			Parent = Items["AnimationsDropdown"].Instance,
			Name = "\0",
			Size = UDim2New(0, 0, 0, 15),
			Position = UDim2New(0, 0, 0.5, 0),
			AnchorPoint = Vector2New(0, 0.5),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "Animations",
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = 2
		}):AddToTheme({TextColor3 = 'Text'})

		Items["RealDropdown"] = Instances:Create("TextButton", {
			Parent = Items["AnimationsDropdown"].Instance,
			Name = "\0",
			Size = UDim2New(0, 125, 0, 25),
			Position = UDim2New(1, 0, 0, 0),
			AnchorPoint = Vector2New(1, 0),
			BackgroundColor3 = Library.Theme["Element"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Element'})

		Instances:Create("UICorner", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Instances:Create("UIGradient", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			Rotation = 90,
			Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
		})

		Items["Value"] = Instances:Create("TextLabel", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			Size = UDim2New(1, -25, 0, 15),
			Position = UDim2New(0, 8, 0.5, 0),
			AnchorPoint = Vector2New(0, 0.5),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "None",
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
			TextTruncate = Enum.TextTruncate.None
		}):AddToTheme({TextColor3 = 'Text'})

		Instances:Create("UIGradient", {
			Parent = Items["Value"].Instance,
			Name = "\0",
			Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.676, 0), NumSequenceKeypoint(1, 1)}
		})

		Items["Icon"] = Instances:Create("ImageLabel", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			Size = UDim2New(0, 23, 0, 23),
			Position = UDim2New(1, -13, 0.5, 0),
			AnchorPoint = Vector2New(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = "rbxassetid://126603363478667",
			ImageColor3 = Library.Theme["Text"],
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 2
		})    

		Items["OptionHolder"] = Instances:Create("TextButton", {
			Parent = Library.UnusedHolder.Instance,
			Name = "\0",
			Size = UDim2New(0, 125, 0, 125),
			Position = UDim2New(0, 0, 0, 5),
			AnchorPoint = Vector2New(0, 0),
			BackgroundColor3 = Library.Theme["Background"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "",
			ClipsDescendants = true,
			AutoButtonColor = false,
			ZIndex = 5,
			Visible = false,
			SelectionGroup = true
		}):AddToTheme({BackgroundColor3 = 'Background'})

		Instances:Create("UICorner", {
			Parent = Items["OptionHolder"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Instances:Create("UIPadding", {
			Parent = Items["OptionHolder"].Instance,
			Name = "\0",
			PaddingLeft = UDimNew(0, 5),
			PaddingRight = UDimNew(0, 5),
			PaddingTop = UDimNew(0, 5),
			PaddingBottom = UDimNew(0, 8)
		})

		Instances:Create("UIListLayout", {
			Parent = Items["OptionHolder"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local Debounce = false 
		local RenderStepped 

		local UIScale = Library.Holder.Instance:FindFirstChildOfClass("UIScale")
		local Scale = UIScale and UIScale.Scale or 1

		function Colorpicker:SetDisabled(Bool)
			Colorpicker.Disabled = Bool

			if Colorpicker.Disabled then 
				Items["ColorpickerButton"]:Tween(nil, {BackgroundTransparency = 0.6})
			else
				Items["ColorpickerButton"]:Tween(nil, {BackgroundTransparency = 0})
			end
		end

		local function UpdateColorpickerPosition()
			if not Library or not Items or not Items["OptionHolder"] or not Items["OptionHolder"].Instance then return end
			if not Items["AnimationsDropdown"] or not Items["AnimationsDropdown"].Instance then return end

			local Scale = Library.UIScaleNum or 1

			local Real = Items["RealDropdown"].Instance
			local Animations = Items["AnimationsDropdown"].Instance

			local PostionX = Real.AbsolutePosition.X
			local SizeX = Real.AbsoluteSize.X
			local PostionY = Animations.AbsolutePosition.Y - 130
			local MaxSize = math.min(AnimDropdown.MaxSize, 125)

			Items["OptionHolder"].Instance.Position = UDim2New(0, PostionX / Scale, 0, PostionY / Scale)
			Items["OptionHolder"].Instance.Size = UDim2New(0, SizeX / Scale, 0, MaxSize / Scale)
		end

		function AnimDropdown:SetOpen(Bool)
			if Debounce then
				return
			end

			AnimDropdown.IsOpen = Bool

			Debounce = true

			if AnimDropdown.IsOpen then
				wait()
				if Items["Icon"] and Items["Icon"].Instance then
					Items["Icon"]:Tween(TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Rotation = 90,
						ImageColor3 = Library.Theme["Accent"]
					})
				end
			else
				if Items["Icon"] and Items["Icon"].Instance then
					Items["Icon"]:Tween(TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Rotation = 0,
						ImageColor3 = Library.Theme["Text"]
					})
				end
			end

			if not Items["OptionHolder"] or not Items["OptionHolder"].Instance then
				Debounce = false
				return
			end

			if AnimDropdown.IsOpen then
				Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

				UpdateColorpickerPosition()

				Items["OptionHolder"].Instance.Visible = true

				RenderStepped = RunService.RenderStepped:Connect(function()
					if not Library then return end
					UpdateColorpickerPosition()
				end)

				for Index, Value in Library.OpenFrames do
					if Value ~= AnimDropdown and Value ~= Colorpicker then
						Value:SetOpen(false)
					end
				end

				Library.OpenFrames[AnimDropdown] = AnimDropdown
			else
				if Library.OpenFrames[AnimDropdown] then
					Library.OpenFrames[AnimDropdown] = nil
				end

				if RenderStepped then
					RenderStepped:Disconnect()
					RenderStepped = nil
				end
			end

			local Descendants = Items["OptionHolder"].Instance:GetDescendants()
			TableInsert(Descendants, Items["OptionHolder"].Instance)

			local NewTween

			for Index, Value in Descendants do 
				local TransparencyProperty = Tween:GetProperty(Value)

				if not TransparencyProperty then
					continue 
				end

				if not Value.ClassName:find("UI") then 
					Value.ZIndex = AnimDropdown.IsOpen and 127 or 1
				end

				if type(TransparencyProperty) == "table" then 
					for _, Property in TransparencyProperty do 
						NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
					end
				else
					NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
				end
			end

			if not NewTween or not NewTween.Tween then
				Debounce = false

				Items["OptionHolder"].Instance.Visible = AnimDropdown.IsOpen
				wait(0.2)
				Items["OptionHolder"].Instance.Parent = not AnimDropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
				return
			end

			NewTween.Tween.Completed:Connect(function()
				Debounce = false

				Items["OptionHolder"].Instance.Visible = AnimDropdown.IsOpen
				wait(0.2)
				Items["OptionHolder"].Instance.Parent = not AnimDropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
			end)
		end

		function AnimDropdown:Add(Option)
			local OptionButton = Instances:Create("TextButton", {
				Parent = Items["OptionHolder"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 25),
				BackgroundColor3 = Library.Theme["Inline"],
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 5
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = OptionButton.Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			local OptionText = Instances:Create("TextLabel", {
				Parent = OptionButton.Instance,
				Name = "\0",
				Size = UDim2New(1, -15, 1, 0),
				Position = UDim2New(0, 4, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Option,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 5
			}):AddToTheme({TextColor3 = 'Text'})                

			local OptionData = {
				Button = OptionButton,
				Name = Option,
				Text = OptionText,
				Selected = false
			}

			function OptionData:Toggle(Value)
				if Value == "Active" then
					OptionData.Text:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 8, 0, 0)})
					OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
				else
					OptionData.Text:Tween(nil, {TextTransparency = 0.4, Position = UDim2New(0, 4, 0, 0)})
					OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
				end
			end

			function OptionData:Set()
				OptionData.Selected = not OptionData.Selected

				if AnimDropdown.Multi then 
					local Index = TableFind(AnimDropdown.Value, OptionData.Name)

					if Index then 
						TableRemove(AnimDropdown.Value, Index)
					else
						TableInsert(AnimDropdown.Value, OptionData.Name)
					end

					OptionData:Toggle(Index and "Inactive" or "Active")

					Library.Flags[AnimDropdown.Flag] = AnimDropdown.Value

					local TextFormat = #AnimDropdown.Value > 0 and TableConcat(AnimDropdown.Value, ", ") or "..."
					Items["Value"].Instance.Text = TextFormat
				else
					if OptionData.Selected then 
						AnimDropdown.Value = OptionData.Name
						Library.Flags[AnimDropdown.Flag] = OptionData.Name

						OptionData.Selected = true
						OptionData:Toggle("Active")

						for Index, Value in AnimDropdown.Options do 
							if Value ~= OptionData then
								Value.Selected = false 
								Value:Toggle("Inactive")
							end
						end

						Items["Value"].Instance.Text = OptionData.Name
					else
						AnimDropdown.Value = nil
						Library.Flags[AnimDropdown.Flag] = nil

						OptionData.Selected = false
						OptionData:Toggle("Inactive")

						Items["Value"].Instance.Text = "..."
					end
				end

				if AnimDropdown.Callback then
					Library:SafeCall(AnimDropdown.Callback, AnimDropdown.Value)
				end
			end

			OptionData.Button:Connect("MouseButton1Down", function()
				OptionData:Set()
			end)

			AnimDropdown.Options[OptionData.Name] = OptionData
			return OptionData
		end

		if IsMobile then
			Items["RealDropdown"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.Touch then
					AnimDropdown:SetOpen(not AnimDropdown.IsOpen)
				end
			end)
		else
			Items["RealDropdown"]:Connect("MouseButton1Down", function()
				AnimDropdown:SetOpen(not AnimDropdown.IsOpen)
			end)
		end

		Library:Connect(UserInputService.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if AnimDropdown.IsOpen and Colorpicker.IsOpen then
					if Library:IsMouseOverFrame(Items["OptionHolder"]) then
						return
					end

					AnimDropdown:SetOpen(false)
				end
			end
		end)

		Items["RealDropdown"]:Connect("Changed", function(Property)
			if Property == "AbsolutePosition" and AnimDropdown.IsOpen then
				AnimDropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Data.Section.Items["Section"].Instance.Parent)
				Items["OptionHolder"].Instance.Visible = AnimDropdown.IsOpen
			end
		end)

		AnimDropdown:Add("Rainbow")
		AnimDropdown:Add("Breathing")

		local Debounce = false
		local RenderStepped  

		function Colorpicker:SetOpen(Bool)
			if Debounce then 
				return
			end

			Colorpicker.IsOpen = Bool

			Debounce = true 

			if Colorpicker.IsOpen then 
				wait()
				Items["ColorpickerWindow"].Instance.Visible = true
				Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance

				RenderStepped = RunService.RenderStepped:Connect(function()
					local Button = Items["ColorpickerButton"].Instance

					Items["ColorpickerWindow"].Instance.Position = UDim2New(
						0, Button.AbsolutePosition.X,
						0, Button.AbsolutePosition.Y - 280
					)
				end)

				Items["ColorpickerWindow"]:Tween(nil, {Size = UDim2New(0, 218, 0, 275)})

				for Index, Value in Library.OpenFrames do 
					if Value ~= Colorpicker then
						Value:SetOpen(false)
					end
				end

				Library.OpenFrames[Colorpicker] = Colorpicker 
			else
				if Library.OpenFrames[Colorpicker] then
					Library.OpenFrames[Colorpicker] = nil
				end

				if RenderStepped then
					RenderStepped:Disconnect()
					RenderStepped = nil
				end

				if AnimDropdown then
					AnimDropdown:SetOpen(false)
				end

				Items["ColorpickerWindow"]:Tween(nil, {Size = UDim2New(0, 218, 0, 0)})
			end

			local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
			TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

			local NewTween

			for Index, Value in Descendants do 
				local TransparencyProperty = Tween:GetProperty(Value)

				if not TransparencyProperty then
					continue 
				end

				if not Value.ClassName:find("UI") then 
					Value.ZIndex = Colorpicker.IsOpen and 125 or 1
					Items["AlphaDragger"].Instance.ZIndex = 126
				end

				if type(TransparencyProperty) == "table" then 
					for _, Property in TransparencyProperty do 
						NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
					end
				else
					NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
				end
			end

			if not NewTween or not NewTween.Tween then
				Debounce = false

				Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
				wait(0.2)
				Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
				return
			end

			NewTween.Tween.Completed:Connect(function()
				Debounce = false

				Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
				wait(0.2)
				Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
			end)
		end

		function Colorpicker:Get()
			return Colorpicker.Color, Colorpicker.Alpha
		end

		function Colorpicker:Update(IsFromAlpha)
			local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value

			Colorpicker.Color = FromHSV(Hue, Saturation, Value)
			Colorpicker.HexValue = Colorpicker.Color:ToHex()

			Library.Flags[Colorpicker.Flag] = {
				Alpha = Colorpicker.Alpha,
				Color = Colorpicker.Color,
				HexValue = Colorpicker.HexValue,
				Flag = Colorpicker.Flag,
				Transparency = 1 - Colorpicker.Alpha
			}

			local Color = Colorpicker.Color
			local R, G, B = MathFloor(Color.R * 255), MathFloor(Color.G * 255), MathFloor(Color.B * 255)

			Items["Input"].Instance.Text = R .. ", " .. G .. ", " .. B

			Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Color})
			Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

			if not IsFromAlpha then
				Items["Alpha"]:Tween(nil, {BackgroundColor3 = Color})
			end

			if Data.Callback then
				Library:SafeCall(Data.Callback, Color, Colorpicker.Alpha)
			end

			Library:SaveAutoloadIfEnabled()
		end

		local SlidingPalette = false
		local PaletteChanged

		function Colorpicker:SlidePalette(Input)
			if not Input or not SlidingPalette then
				return
			end

			local PaletteInst = Items["Palette"].Instance
			local PaletteSize = PaletteInst.AbsoluteSize
			local PalettePos = PaletteInst.AbsolutePosition

			local SlideX = (Input.Position.X - PalettePos.X) / PaletteSize.X
			local SlideY = (Input.Position.Y - PalettePos.Y) / PaletteSize.Y

			local ValueX = MathClamp(1 - SlideX, 0, 1)
			local ValueY = MathClamp(1 - SlideY, 0, 1)

			Colorpicker.Saturation = ValueX
			Colorpicker.Value = ValueY

			Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2New(MathClamp(SlideX, 0, 0.98), 0, MathClamp(SlideY, 0, 0.98), 0)
			})
			Colorpicker:Update()
		end

		local SlidingHue = false
		local HueChanged

		function Colorpicker:SlideHue(Input)
			if not Input or not SlidingHue then
				return
			end

			local HueInst = Items["Hue"].Instance
			local HueSize = HueInst.AbsoluteSize
			local HuePos = HueInst.AbsolutePosition
			local SlideX = (Input.Position.X - HuePos.X) / HueSize.X

			Colorpicker.Hue = MathClamp(SlideX, 0, 1)

			Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2New(MathClamp(SlideX, 0, 0.985), 0, 0.5, 0)
			})
			Colorpicker:Update()
		end

		local SlidingAlpha = false
		local AlphaChanged

		function Colorpicker:SlideAlpha(Input)
			if not Input or not SlidingAlpha then
				return
			end

			local AlphaInst = Items["Alpha"].Instance
			local AlphaSize = AlphaInst.AbsoluteSize
			local AlphaPos = AlphaInst.AbsolutePosition
			local SlideY = (Input.Position.Y - AlphaPos.Y) / AlphaSize.Y

			Colorpicker.Alpha = MathClamp(SlideY, 0, 1)

			Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2New(0.5, 0, MathClamp(SlideY, 0, 0.98), 0)
			})

			Colorpicker:Update(true)
		end

		function Colorpicker:Set(Color, Alpha)
			if type(Color) == "table" then
				Color = FromRGB(Color[1], Color[2], Color[3])
			elseif type(Color) == "string" then
				Color = FromHex(Color)
			end

			Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
			Colorpicker.Alpha = Alpha or 0

			local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.985)
			local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.985)
			local AlphaPositionY = MathClamp(Colorpicker.Alpha, 0, 0.99)
			local HuePositionX = MathClamp(Colorpicker.Hue, 0, 0.98)

			Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)
			})
			Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2New(HuePositionX, 0, 0.5, 0)
			})
			Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2New(0.5, 0, AlphaPositionY, 0)
			})

			Colorpicker:Update()
		end

		AnimDropdown.Callback = function(Value)
			local HasRainbow = TableFind(Value, "Rainbow")
			local HasBreathing = TableFind(Value, "Breathing")

			if HasRainbow then
				local SavedColor = Colorpicker.Color

				Library:Thread(LPH_NO_VIRTUALIZE(function()
					while wait(0.07) do
						local RainbowHue = MathAbs(MathSin(tick() * 0.33))
						Colorpicker:Set(FromHSV(RainbowHue, 1, 1), Colorpicker.Alpha)

						if not TableFind(AnimDropdown.Value, "Rainbow") then
							Colorpicker:Set(SavedColor, Colorpicker.Alpha)
							break
						end
					end
				end))
			end

			if HasBreathing then
				local SavedAlpha = Colorpicker.Alpha

				Library:Thread(LPH_NO_VIRTUALIZE(function()
					while wait(0.07) do
						local AlphaValue = MathAbs(MathSin(tick() * 0.8))
						Colorpicker:Set(Colorpicker.Color, AlphaValue)

						if not TableFind(AnimDropdown.Value, "Breathing") then
							Colorpicker:Set(Colorpicker.Color, SavedAlpha)
							break
						end
					end
				end))
			end
		end

		Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
			if Colorpicker.Disabled then 
				return 
			end

			Colorpicker:SetOpen(not Colorpicker.IsOpen)
		end)

		Items["Palette"]:Connect("InputBegan", function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if Colorpicker.Disabled then
					return
				end

				SlidingPalette = true

				Colorpicker:SlidePalette(Input)

				if PaletteChanged then
					return
				end

				PaletteChanged = Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						SlidingPalette = false

						PaletteChanged:Disconnect()
						PaletteChanged = nil
					end
				end)
			end
		end)

		Items["Hue"]:Connect("InputBegan", function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if Colorpicker.Disabled then
					return
				end

				SlidingHue = true

				Colorpicker:SlideHue(Input)

				if HueChanged then
					return
				end

				HueChanged = Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						SlidingHue = false

						HueChanged:Disconnect()
						HueChanged = nil
					end
				end)
			end
		end)

		Items["Alpha"]:Connect("InputBegan", function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if Colorpicker.Disabled then
					return
				end

				SlidingAlpha = true

				Colorpicker:SlideAlpha(Input)

				if AlphaChanged then
					return
				end

				AlphaChanged = Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						SlidingAlpha = false

						AlphaChanged:Disconnect()
						AlphaChanged = nil
					end
				end)
			end
		end)

		Items["Input"]:Connect("FocusLost", function()
			if Colorpicker.Disabled then
				return
			end

			local Text  = Items["Input"].Instance.Text
			local R, G, B = Text:match("(%d+),%s*(%d+),%s*(%d+)")

			R, G, B = tonumber(R), tonumber(G), tonumber(B)
			Colorpicker:Set(FromRGB(R, G, B), Colorpicker.Alpha)
		end)

		Library:Connect(UserInputService.InputChanged, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				if Colorpicker.Disabled then
					return
				end

				if SlidingPalette then
					Colorpicker:SlidePalette(Input)
				end

				if SlidingHue then
					Colorpicker:SlideHue(Input)
				end

				if SlidingAlpha then
					Colorpicker:SlideAlpha(Input)
				end
			end
		end)

		Library:Connect(UserInputService.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if Colorpicker.Disabled then
					return
				end

				if not Colorpicker.IsOpen then
					return
				end

				if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) or Library:IsMouseOverFrame(Items["OptionHolder"]) then
					return
				end

				Colorpicker:SetOpen(false)
			end
		end)

		if Data.Default then
			Colorpicker:Set(Data.Default, Data.Alpha)
		end

		Library.SetFlags[Colorpicker.Flag] = function(Value, Alpha)
			if Colorpicker.Disabled then
				return
			end

			Colorpicker:Set(Value, Alpha)
		end

		Library.SetFlags[AnimDropdown.Flag] = function(Value)
			if type(Value) == "string" then
				Value = { Value }
			end

			if type(Value) ~= "table" then
				Value = {}
			end

			AnimDropdown.Value = Value
			Library.Flags[AnimDropdown.Flag] = AnimDropdown.Value

			local TextFormat = #AnimDropdown.Value > 0 and TableConcat(AnimDropdown.Value, ", ") or "..."
			Items["Value"].Instance.Text = TextFormat

			for OptName, OptionData in AnimDropdown.Options do
				local Selected = TableFind(AnimDropdown.Value, OptName)

				OptionData.Selected = Selected ~= nil
				OptionData:Toggle(Selected and "Active" or "Inactive")
			end

			if AnimDropdown.Callback then
				Library:SafeCall(AnimDropdown.Callback, AnimDropdown.Value)
			end
		end

		function Colorpicker:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Colorpicker
		end

		return Colorpicker, Items 
	end

	Library.CreateKeybind = function(self, Data)
		local Keybind = {
			Flag = Data.Flag,

			Value = "",
			Key  = "",
			Mode = "",

			Toggled = false,
			Disabled = false,
			Picking = false,

			IsOpen = false 
		}

		local Items = {} do 
			Items["KeyButton"] = Instances:Create("TextButton", {
				Parent = Data.Parent.Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 0, 20),
				Position = UDim2New(1, 0, 0, 0),
				AnchorPoint = Vector2New(1, 0),
				BackgroundColor3 = Library.Theme["Background"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "RightShift",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				AutomaticSize = Enum.AutomaticSize.X,
				AutoButtonColor = false,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Background'})

			Instances:Create("UIPadding", {
				Parent = Items["KeyButton"].Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, 5),
				PaddingRight = UDimNew(0, 5)
			})

			Instances:Create("UICorner", {
				Parent = Items["KeyButton"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})                

			Items["KeybindWindow"] = Instances:Create("Frame", {
				Parent = Library.UnusedHolder.Instance,
				Name = "\0",
				Size = UDim2New(0, 100, 0, 100),
				Position = UDim2New(0.005164622329175472, 0, 0.34007585048675537, 0),
				BackgroundColor3 = Library.Theme["Background"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			}):AddToTheme({BackgroundColor3 = 'Background'})

			Instances:Create("UICorner", {
				Parent = Items["KeybindWindow"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Shadow"] = Instances:Create("ImageLabel", {
				Parent = Items["KeybindWindow"].Instance,
				Name = "\0",
				Size = UDim2New(1, 55, 1, 55),
				Position = UDim2New(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2New(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://112971167999062",
				ImageColor3 = FromRGB(0, 0, 0),
				ImageTransparency = 0.5600000023841858,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
				SliceScale = 0.6000000238418579,
				ZIndex = -1
			}):AddToTheme({ImageColor3 = 'Shadow'})

			Items["Toggle"] = Instances:Create("TextButton", {
				Parent = Items["KeybindWindow"].Instance,
				Name = "\0",
				Size = UDim2New(1, -16, 0, 25),
				Position = UDim2New(0, 8, 0, 8),
				BackgroundColor3 = Library.Theme["Inline"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["ToggleText"] = Instances:Create("TextLabel", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				Size = UDim2New(1, -15, 1, 0),
				Position = UDim2New(0, 8, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "Toggle",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})

			Items["Hold"] = Instances:Create("TextButton", {
				Parent = Items["KeybindWindow"].Instance,
				Name = "\0",
				Size = UDim2New(1, -16, 0, 25),
				Position = UDim2New(0, 8, 0, 33),
				BackgroundColor3 = Library.Theme["Inline"],
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = Items["Hold"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["HoldText"] = Instances:Create("TextLabel", {
				Parent = Items["Hold"].Instance,
				Name = "\0",
				Size = UDim2New(1, -15, 1, 0),
				Position = UDim2New(0, 4, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "Hold",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})

			Items["Always"] = Instances:Create("TextButton", {
				Parent = Items["KeybindWindow"].Instance,
				Name = "\0",
				Size = UDim2New(1, -16, 0, 25),
				Position = UDim2New(0, 8, 0, 58),
				BackgroundColor3 = Library.Theme["Inline"],
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = Items["Always"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["AlwaysText"] = Instances:Create("TextLabel", {
				Parent = Items["Always"].Instance,
				Name = "\0",
				Size = UDim2New(1, -15, 1, 0),
				Position = UDim2New(0, 4, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "Always",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})                
		end

		local KeyListItem 

		if Library.KeyList then
			KeyListItem = Library.KeyList:Add("", "", "")
		end

		local Update = function()
			if KeyListItem then 
				KeyListItem:Set(Keybind.Value, Data.Name, Keybind.Mode)
				KeyListItem:SetStatus(Keybind.Toggled)
			end
		end

		local Modes = {
			["Toggle"] = {Items["Toggle"], Items["ToggleText"]},
			["Hold"] = {Items["Hold"], Items["HoldText"]},
			["Always"] = {Items["Always"], Items["AlwaysText"]}
		}

		local Debounce = false
		local RenderStepped  

		function Keybind:SetDisabled(Bool)
			Keybind.Disabled = Bool 

			if Keybind.Disabled then 
				Items["KeyButton"]:Tween(nil, {BackgroundTransparency = 0.6, TextTransparency = 0.6})
			else
				Items["KeyButton"]:Tween(nil, {BackgroundTransparency = 0, TextTransparency = 0})
			end
		end

		function Keybind:SetOpen(Bool)
			if Debounce then 
				return
			end

			Keybind.IsOpen = Bool

			Debounce = true 

			if Keybind.IsOpen then 
				wait()
				Items["KeybindWindow"].Instance.Visible = true
				Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance

				RenderStepped = RunService.RenderStepped:Connect(function()
					local Button = Items["KeyButton"].Instance

					Items["KeybindWindow"].Instance.Position = UDim2New(
						0, Button.AbsolutePosition.X,
						0, Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 5
					)
				end)

				for Index, Value in Library.OpenFrames do 
					if Value ~= Keybind then
						Value:SetOpen(false)
					end
				end

				Library.OpenFrames[Keybind] = Keybind 
			else
				if Library.OpenFrames[Keybind] then 
					Library.OpenFrames[Keybind] = nil
				end

				if RenderStepped then 
					RenderStepped:Disconnect()
					RenderStepped = nil
				end
			end

			local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
			TableInsert(Descendants, Items["KeybindWindow"].Instance)

			local NewTween

			for Index, Value in Descendants do 
				local TransparencyProperty = Tween:GetProperty(Value)

				if not TransparencyProperty then
					continue 
				end

				if not Value.ClassName:find("UI") then 
					Value.ZIndex = Keybind.IsOpen and 4 or 1
				end

				if type(TransparencyProperty) == "table" then 
					for _, Property in TransparencyProperty do 
						NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
					end
				else
					NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
				end
			end

			if not NewTween or not NewTween.Tween then
				Debounce = false

				Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
				wait(0.2)
				Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
				return
			end

			NewTween.Tween.Completed:Connect(function()
				Debounce = false

				Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
				wait(0.2)
				Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
			end)
		end

		function Keybind:SetMode(Mode)
			for Index, Value in Modes do 
				if Index == Mode then 
					Value[1]:Tween(nil, {BackgroundTransparency = 0})
					Value[2]:Tween(nil, {TextTransparency = 0})
				else
					Value[1]:Tween(nil, {BackgroundTransparency = 1})
					Value[2]:Tween(nil, {TextTransparency = 0.4})
				end
			end

			Library.Flags[Keybind.Flag] = {
				Mode = Keybind.Mode,
				Key = Keybind.Key,
				Toggled = Keybind.Toggled
			}

			if Data.Callback then 
				Library:SafeCall(Data.Callback, Keybind.Toggled)
			end

			Update()
		end

		function Keybind:Press(Bool)
			if Keybind.Mode == "Toggle" then 
				Keybind.Toggled = not Keybind.Toggled
			elseif Keybind.Mode == "Hold" then 
				Keybind.Toggled = Bool
			elseif Keybind.Mode == "Always" then 
				Keybind.Toggled = true
			end

			Library.Flags[Keybind.Flag] = {
				Mode = Keybind.Mode,
				Key = Keybind.Key,
				Toggled = Keybind.Toggled
			}

			if Data.Callback then 
				Library:SafeCall(Data.Callback, Keybind.Toggled)
			end

			Update()
		end

		function Keybind:Get()
			return Keybind.Key, Keybind.Mode, Keybind.Toggled
		end

		function Keybind:Set(Key)
			if StringFind(tostring(Key), "Enum") then 
				Keybind.Key = tostring(Key)

				Key = Key.Name == "Backspace" and "None" or Key.Name

				local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
				local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

				Keybind.Value = TextToDisplay
				Items["KeyButton"].Instance.Text = TextToDisplay

				Library.Flags[Keybind.Flag] = {
					Mode = Keybind.Mode,
					Key = Keybind.Key,
					Toggled = Keybind.Toggled
				}

				if Data.Callback then 
					Library:SafeCall(Data.Callback, Keybind.Toggled)
				end

				Update()
			elseif type(Key) == "table" then
				local RealKey = Key.Key == "Backspace" and "None" or Key.Key

				Keybind.Key = tostring(Key.Key)

				if Key.Mode then
					Keybind.Mode = Key.Mode
					Keybind:SetMode(Key.Mode)
				else
					Keybind.Mode = "Toggle"
					Keybind:SetMode("Toggle")
				end

				local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
				local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

				TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

				Keybind.Value = TextToDisplay
				Items["KeyButton"].Instance.Text = TextToDisplay

				if Data.Callback then 
					Library:SafeCall(Data.Callback, Keybind.Toggled)
				end

				Update()
			elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
				Keybind.Mode = Key
				Keybind:SetMode(Key)

				if Data.Callback then 
					Library:SafeCall(Data.Callback, Keybind.Toggled)
				end

				Update()
			end

			Keybind.Picking = false
			Library:SaveAutoloadIfEnabled()
		end

		Items["KeyButton"]:Connect("MouseButton1Click", function()
			if Keybind.Disabled then 
				return 
			end

			Keybind.Picking = true 

			Items["KeyButton"].Instance.Text = "press a key"

			local InputBegan

			InputBegan = UserInputService.InputBegan:Connect(function(Input)

				if Input.UserInputType == Enum.UserInputType.Keyboard then 
					Keybind:Set(Input.KeyCode)
				else
					Keybind:Set(Input.UserInputType)
				end

				InputBegan:Disconnect()
				InputBegan = nil
			end)
		end)

		Library:Connect(UserInputService.InputBegan, function(Input, Gpe)
			if Keybind.Disabled then
				return
			end

			if Keybind.Value == "None" then
				return
			end

			if not Gpe then
				if tostring(Input.KeyCode) == Keybind.Key then
					if Keybind.Mode == "Toggle" then
						Keybind:Press()
					elseif Keybind.Mode == "Hold" then
						Keybind:Press(true)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				elseif tostring(Input.UserInputType) == Keybind.Key then
					if Keybind.Mode == "Toggle" then
						Keybind:Press()
					elseif Keybind.Mode == "Hold" then
						Keybind:Press(true)
					elseif Keybind.Mode == "Always" then
						Keybind:Press(true)
					end
				end
			end

			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not Keybind.IsOpen then
					return
				end

				if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
					return
				end

				Keybind:SetOpen(false)
			end
		end)

		Library:Connect(UserInputService.InputEnded, function(Input, Gpe)
			if Keybind.Disabled then
				return
			end

			if Gpe then
				return
			end

			if Keybind.Value == "None" then
				return
			end

			if tostring(Input.KeyCode) == Keybind.Key then
				if Keybind.Mode == "Hold" then
					Keybind:Press(false)
				elseif Keybind.Mode == "Always" then
					Keybind:Press(true)
				end
			elseif tostring(Input.UserInputType) == Keybind.Key then
				if Keybind.Mode == "Hold" then
					Keybind:Press(false)
				elseif Keybind.Mode == "Always" then
					Keybind:Press(true)
				end
			end
		end)

		Items["KeyButton"]:Connect("MouseButton2Down", function()
			if Keybind.Disabled then 
				return 
			end

			Keybind:SetOpen(not Keybind.IsOpen)
		end)

		Items["Toggle"]:Connect("MouseButton1Down", function()
			Keybind.Mode = "Toggle"
			Keybind.Toggled = false
			Keybind:SetMode("Toggle")
		end)

		Items["Hold"]:Connect("MouseButton1Down", function()
			Keybind.Mode = "Hold"
			Keybind.Toggled = false
			Keybind:SetMode("Hold")
		end)

		Items["Always"]:Connect("MouseButton1Down", function()
			Keybind.Mode = "Always"
			Keybind.Toggled = true
			Keybind:SetMode("Always")
		end)

		if Data.Default then 
			Keybind:Set({
				Mode = Data.Mode or "Toggle",
				Key = Data.Default,
			})
		end

		Library.SetFlags[Keybind.Flag] = function(Value)
			if Keybind.Disabled then
				return
			end
			Keybind:Set(Value)
		end

		function Keybind:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Keybind
		end

		return Keybind, Items 
	end

	Library.Watermark = function(self, Name)
		local Watermark = {}

		local Items = {} do
			Items["Watermark"] = Instances:Create("Frame", {
				Parent = Library.Holder.Instance,
				Name = "\0",
				Size = UDim2New(0, 100, 0, 35),
				Position = UDim2New(0.5, 0, 0, 15),
				AnchorPoint = Vector2New(0.5, 0),
				BackgroundColor3 = FromRGB(16, 18, 21),
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Items["Watermark"]:MakeDraggable()

			Instances:Create("UIGradient", {
				Parent = Items["Watermark"].Instance,
				Name = "\0",
				Rotation = 84,
				Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(211, 211, 211))}
			})

			Instances:Create("UICorner", {
				Parent = Items["Watermark"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["Watermark"].Instance,
				Name = "\0",
				Position = UDim2New(0, 0, 0.5, 0),
				AnchorPoint = Vector2New(0, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY
			}):AddToTheme({TextColor3 = 'Text'})

			Instances:Create("UIPadding", {
				Parent = Items["Watermark"].Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, 10),
				PaddingRight = UDimNew(0, 10),
				PaddingTop = UDimNew(0, 8),
				PaddingBottom = UDimNew(0, 8)
			})                
		end

		function Watermark:SetText(Text)
			Items["Text"].Instance.Text = tostring(Text)
		end

		function Watermark:SetVisibility(Bool)
			Items["Watermark"].Instance.Visible = Bool 
		end

		function Watermark:SetCenter()
			local CenterPosition = Items["Watermark"].Instance.AbsolutePosition

			wait()

			Items["Watermark"].Instance.AnchorPoint = Vector2New(0, 0)
			Items["Watermark"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
		end

		Watermark:SetText(Name)
		Watermark:SetCenter()

		return Watermark 
	end

	Library.KeybindList = function(self, Name)
		Name = Name or "Keybinds"

		local KeybindList = {}

		Library.KeyList = KeybindList

		local Items = {} do 
			Items["KeybindList"] = Instances:Create("Frame", {
				Parent = Library.Holder.Instance,
				Name = "\0",
				Position = UDim2New(0.005164622329175472, 0, 0.4690265357494354, 0),
				BackgroundColor3 = Library.Theme["Background"],
				BackgroundTransparency = 0.30000001192092896,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.None
			}):AddToTheme({BackgroundColor3 = 'Background'})

			Items["KeybindList"]:MakeDraggable()

			Instances:Create("UICorner", {
				Parent = Items["KeybindList"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["KeybindList"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 0, 15),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "Keybinds",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				AutomaticSize = Enum.AutomaticSize.X
			}):AddToTheme({TextColor3 = 'Text'})

			Instances:Create("UIPadding", {
				Parent = Items["KeybindList"].Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, 8),
				PaddingRight = UDimNew(0, 8),
				PaddingTop = UDimNew(0, 8),
				PaddingBottom = UDimNew(0, 8)
			})

			Items["Content"] = Instances:Create("Frame", {
				Parent = Items["KeybindList"].Instance,
				Name = "\0",
				Position = UDim2New(0, 8, 0, 20),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY
			})

			Instances:Create("UIListLayout", {
				Parent = Items["Content"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})                
		end

		local VisibleItems = {}

		function KeybindList:SetTransparency()
			Items["KeybindList"].Instance.BackgroundTransparency = Library.BackgroundTransparency
		end

		function KeybindList:SetText(Text)
			Items["Text"].Instance.Text = tostring(Text)
		end

		function KeybindList:SetVisibility(Bool)
			Items["KeybindList"].Instance.Visible = Bool 
		end

		function KeybindList:SetCenter()
			local CenterPosition = Items["KeybindList"].Instance.AbsolutePosition

			Items["KeybindList"].Instance.AnchorPoint = Vector2New(0, 0)
			Items["KeybindList"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
		end

		function KeybindList:Resize()
			local SizeY = 0
			local SizeX = 0

			table.clear(VisibleItems)

			for Index, Value in Items["Content"].Instance:GetChildren() do 
				if Value.ClassName:find("UI") then continue end
				if not Value.Visible then continue end

				SizeY = SizeY + Value.AbsoluteSize.Y + 5
				SizeX = math.max(SizeX, Value.AbsoluteSize.X)

				table.insert(VisibleItems, Value)
			end

			if #VisibleItems == 0 then 
				SizeX = Items["Text"].Instance.TextBounds.X + 14
				SizeY = 32

				Items["KeybindList"]:Tween(nil, {Size = UDim2New(0, SizeX, 0, SizeY)})
				return 
			end

			Items["KeybindList"]:Tween(nil, {Size = UDim2New(0, SizeX + 30, 0, SizeY + 30)})
		end

		function KeybindList:Add(Key, Name, Mode)
			local NewKey = Instances:Create("TextLabel", {
				Parent = Items["Content"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 0, 20),
				BackgroundColor3 = FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = ""..Key.." - ".. Name .. " (".. Mode .. ")",
				TextColor3 = Library.Theme['Text'],
				TextSize = 14,
				FontFace = Library.Font,
				AutomaticSize = Enum.AutomaticSize.X
			})  NewKey:AddToTheme({TextColor3 = "Text"})

			Instances:Create("UIPadding", {
				Parent = NewKey.Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, 0),
				PaddingRight = UDimNew(0, 0)
			})

			function NewKey:Set(Key, Name, Mode)
				NewKey.Instance.Text = ""..Key.." - ".. Name .. " (".. Mode .. ")"
				KeybindList:Resize()
			end

			function NewKey:SetStatus(Bool)
				if Bool then 
					NewKey:ChangeItemTheme({TextColor3 = "Accent"})
					NewKey:Tween(nil, {TextColor3 = Library.Theme.Accent})
				else
					NewKey:ChangeItemTheme({TextColor3 = "Text"})
					NewKey:Tween(nil, {TextColor3 = Library.Theme.Text})
				end
			end

			KeybindList:Resize()
			return NewKey
		end

		KeybindList:SetText(Name)
		KeybindList:SetCenter()
		KeybindList:Resize()

		return KeybindList
	end

	Library.Notification = function(self, Data)
		wait()
		Library.NotifLayoutOrder = (Library.NotifLayoutOrder or 0) + 1

		local TitleText = Data.Title or Data.Name or ""
		local DescText = Data.Description or ""
		local Duration = Data.Duration or 5

		local PaddingH = 6
		local PaddingV = 5
		local Gap = 5
		local BarGap = 4
		local BarH = 3
		local MaxWidth = 330

		local function GetTextSize(Text, FontSize, Width)
			local Font = Library.Font

			if typeof(Font) ~= "EnumItem" or Font.EnumType ~= Enum.Font then
				Font = Enum.Font.Gotham
			end

			if Width <= 0 then
				Width = 10000
			end

			return TextService:GetTextSize(Text, FontSize, Font, Vector2.new(Width, 10000))
		end

		local TitleSize = GetTextSize(TitleText, 14, MaxWidth)
		local DescAvailableWidth = MaxWidth - PaddingH * 2
		local DescSize = DescText ~= "" and GetTextSize(DescText, 12, DescAvailableWidth) or Vector2.new(DescAvailableWidth, 28)

		local TitleH = math.max(math.ceil(math.max(TitleSize.Y, 1)), 15)
		local DescH = math.max(math.ceil(math.max(DescSize.Y, 1)), 14)

		if DescH < 28 then DescH = 28 end

		local ContentWidth = math.max(math.ceil(math.max(TitleSize.X, 1)), math.ceil(math.max(DescSize.X, 1)), 100)
		ContentWidth = math.min(math.max(ContentWidth + PaddingH * 2, 100), MaxWidth)

		local SizeY = PaddingV + TitleH + Gap + DescH + BarGap + BarH + PaddingV

		local Items = {} do
			Items["Notification"] = Instances:Create("Frame", {
				Parent = Library.NotifHolder.Instance,
				Name = "\0",
				BackgroundColor3 = Library.Theme["Background"],
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = Library.NotifLayoutOrder,
				Size = UDim2New(0, ContentWidth, 0, SizeY)
			}):AddToTheme({BackgroundColor3 = 'Background'})

			Instances:Create("UICorner", {
				Parent = Items["Notification"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Instances:Create("UIPadding", {
				Parent = Items["Notification"].Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, PaddingH),
				PaddingRight = UDimNew(0, PaddingH),
				PaddingTop = UDimNew(0, PaddingV),
				PaddingBottom = UDimNew(0, PaddingV)
			})

			Items["Title"] = Instances:Create("TextLabel", {
				Parent = Items["Notification"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, TitleH),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = TitleText,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				TextTransparency = 1
			}):AddToTheme({TextColor3 = 'Text'})

			Items["Description"] = Instances:Create("TextLabel", {
				Parent = Items["Notification"].Instance,
				Name = "\0",
				Size = UDim2New(1, -PaddingH * 2, 0, DescH),
				Position = UDim2New(0, PaddingH, 0, TitleH + Gap),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = DescText,
				TextColor3 = Library.Theme["Text"],
				TextSize = 12,
				FontFace = Library.Font,
				TextTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None,
				RichText = false,
				TextScaled = false,
				AutomaticSize = Enum.AutomaticSize.Y
			}):AddToTheme({TextColor3 = 'Text'})

			Instances:Create("UITextSizeConstraint", {
				Parent = Items["Description"].Instance,
				Name = "\0",
				MinTextSize = 12,
				MaxTextSize = 12
			})

			Items["Duration"] = Instances:Create("Frame", {
				Parent = Items["Notification"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, BarH),
				Position = UDim2New(0, 0, 0, TitleH + Gap + DescH + BarGap),
				BackgroundColor3 = Library.Theme["Inline"],
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = Items["Duration"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Accent"] = Instances:Create("Frame", {
				Parent = Items["Duration"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 1, 0),
				BackgroundColor3 = Data.Color,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0
			})

			Instances:Create("UICorner", {
				Parent = Items["Accent"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})
		end

		local FadeInfo = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)
		local BarInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

		local Frames = { Items["Notification"], Items["Duration"] }
		local TextLabels = { Items["Title"] }
		local DescLabel = Items["Description"]

		Library:Thread(function()
			for _, Item in Frames do
				Item:Tween(FadeInfo, {BackgroundTransparency = 0})
			end

			for _, Item in TextLabels do
				Item:Tween(FadeInfo, {TextTransparency = 0})
			end

			DescLabel:Tween(FadeInfo, {TextTransparency = 0.4})

			Items["Notification"]:Tween(FadeInfo, {Size = UDim2New(0, ContentWidth, 0, SizeY)})
			Items["Accent"]:Tween(BarInfo, {Size = UDim2New(0, 0, 1, 0)})

			delay(Duration + 0.1, function()
				for _, Item in Frames do
					Item:Tween(FadeInfo, {BackgroundTransparency = 1})
				end

				for _, Item in TextLabels do
					Item:Tween(FadeInfo, {TextTransparency = 1})
				end

				DescLabel:Tween(FadeInfo, {TextTransparency = 1})

				Items["Notification"]:Tween(FadeInfo, {Size = UDim2New(0, 0, 0, SizeY)})
				wait(0.5)
				Items["Notification"]:Clean()
			end)
		end)
	end

	Library.Window = function(self, Data)
		Data = Data or {}

		local Window = {
			Name = Data.Name or Data.name or "Window",

			Pages = {},
			Items = {},
			IsOpen = false,
			IsMinimized = false
		}

		local Items = {} do
			Items["MainFrame"] = Instances:Create("Frame", {
				Parent = Library.Holder.Instance,
				Name = "\0",
				Size = UDim2New(0, 770, 0, 526),
				Position = UDim2New(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2New(0.5, 0.5),
				BackgroundColor3 = Library.Theme["Background"],
				BackgroundTransparency = 0.30000001192092896,
				BorderColor3 = Library.Theme["Shadow"],
				BorderSizePixel = 0,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Background'})

			wait()

			Library:SetScaleFromScreenPercent(Library.UIScaleScreenPercent)

			Items["MainFrame"]:MakeDraggable()
			Items["MainFrame"]:MakeResizeable(Vector2New(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y))

			Instances:Create("UICorner", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Shadow"] = Instances:Create("ImageLabel", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				Size = UDim2New(1, 55, 1, 55),
				Position = UDim2New(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2New(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = Library.Theme["Shadow"],
				BorderSizePixel = 0,
				Image = "rbxassetid://112971167999062",
				ImageColor3 = Library.Theme["Shadow"],
				ImageTransparency = 0.5600000023841858,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
				SliceScale = 0.6000000238418579,
				ZIndex = -1
			}):AddToTheme({ImageColor3 = 'Shadow'})

			Items["Title"] = Instances:Create("TextLabel", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 0, 15),
				Position = UDim2New(0, 9, 0, 8),
				BackgroundTransparency = 1,
				BorderColor3 = Library.Theme["Shadow"],
				BorderSizePixel = 0,
				Text = Window.Name,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				AutomaticSize = Enum.AutomaticSize.X,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})  

			Items["Pages"] = Instances:Create("ScrollingFrame", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				Size = UDim2New(0, 150, 1, -30),
				Position = UDim2New(0, 0, 0, 30),
				BackgroundColor3 = FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BottomImage = "rbxassetid://136419474381965",
				CanvasSize = UDim2New(0, 0, 0, 0),
				MidImage = "rbxassetid://136419474381965",
				ScrollBarImageColor3 = Library.Theme["Accent"],
				ScrollBarThickness = 3,
				TopImage = "rbxassetid://136419474381965"
			}):AddToTheme({ScrollBarImageColor3 = 'Accent'})

			Instances:Create("UIListLayout", {
				Parent = Items["Pages"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			Instances:Create("UIPadding", {
				Parent = Items["Pages"].Instance,
				Name = "\0",
				PaddingLeft = UDimNew(0, 8),
				PaddingRight = UDimNew(0, 8)
			})

			Items["CloseButton"] = Instances:Create("ImageButton", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				Size = UDim2New(0, 23, 0, 23),
				Position = UDim2New(1, -12, 0, 5),
				AnchorPoint = Vector2New(1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://76001605964586",
				ScaleType = Enum.ScaleType.Fit,
				AutoButtonColor = false,
				ZIndex = 2
			})                

			Items["MinimizeButton"] = Instances:Create("ImageButton", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				Size = UDim2New(0, 23, 0, 23),
				Position = UDim2New(1, -40, 0, -1.75),
				AnchorPoint = Vector2New(1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://94817928404736",
				AutoButtonColor = false,
				ZIndex = 2
			})                

			Items["Content"] = Instances:Create("Frame", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				Size = UDim2New(1, -171, 1, -38),
				Position = UDim2New(0, 163, 0, 30),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			})

			Items["Search"] = Instances:Create("Frame", {
				Parent = Items["Content"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 35),
				BackgroundColor3 = Library.Theme["Inline"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = Items["Search"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Icon"] = Instances:Create("ImageLabel", {
				Parent = Items["Search"].Instance,
				Name = "\0",
				Size = UDim2New(0, 20, 0, 20),
				Position = UDim2New(0, 8, 0.5, 0),
				AnchorPoint = Vector2New(0, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://71924825350727",
				ImageTransparency = 0.4000000059604645,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 2
			})

			Items["Input"] = Instances:Create("TextBox", {
				Parent = Items["Search"].Instance,
				Name = "\0",
				Size = UDim2New(1, -43, 0, 15),
				Position = UDim2New(0, 35, 0.5, 0),
				AnchorPoint = Vector2New(0, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				PlaceholderText = "Search..",
				PlaceholderColor3 = Library.Theme["Inactive Text"],
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})    

			Instances:Create("Frame", {
				Parent = Items["MainFrame"].Instance,
				Name = "\0",
				Size = UDim2New(0, 1, 1, 0),
				Position = UDim2New(0, 152, 0, 0),
				BackgroundColor3 = Library.Theme["Border"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Border'})   

			Items["FloatingButton"] = Instances:Create("ImageButton", {
				Parent = Library.FloatingButtonHolder.Instance,
				Name = "\0",
				Size = UDim2New(0, 50, 0, 50),
				Position = UDim2New(0, 15, 0, 50),
				AnchorPoint = Vector2New(0, 0),
				BackgroundColor3 = Library.Theme['Background'],
				Image = "rbxassetid://137698471325689",
				ImageColor3 = Library.Theme['Accent'],
				AutoButtonColor = false,
				ZIndex = 128
			}):AddToTheme({BackgroundColor3 = 'Background'})

			Instances:Create("UICorner", {
				Parent = Items["FloatingButton"].Instance,
				CornerRadius = UDimNew(0, 10)
			})

			Library.FloatingButton = Items["FloatingButton"]
			Library.FloatingButtonLocked = false
			Library.FloatingButtonVisibility = 0

			local FloatingButtonDragging = false
			local FloatingButtonDragStart
			local FloatingButtonStartPosition
			local FloatingButtonChanged

			local FloatingButtonSet = function(Input)
				if Library.FloatingButtonLocked then
					return
				end

				local Scale = Library.UIScaleNum or 1
				local DragDelta = (Input.Position - FloatingButtonDragStart) / Scale

				Items["FloatingButton"]:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(FloatingButtonStartPosition.X.Scale, FloatingButtonStartPosition.X.Offset + DragDelta.X, FloatingButtonStartPosition.Y.Scale, FloatingButtonStartPosition.Y.Offset + DragDelta.Y)})
			end

			Items["FloatingButton"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if Library.FloatingButtonLocked then
						return
					end

					FloatingButtonDragging = true
					FloatingButtonDragStart = Input.Position
					FloatingButtonStartPosition = Items["FloatingButton"].Instance.Position

					if FloatingButtonChanged then
						return
					end

					FloatingButtonChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							FloatingButtonDragging = false

							if FloatingButtonChanged then
								FloatingButtonChanged:Disconnect()
								FloatingButtonChanged = nil
							end
						end
					end)
				end
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					if FloatingButtonDragging and not Library.FloatingButtonLocked then
						FloatingButtonSet(Input)
					end
				end
			end)

			Items["FloatingButton"]:Connect("MouseButton1Down", function(Input)
				Window:SetOpen(not Window.IsOpen)
			end)

			Window.Items = Items
		end

		local OldSize = Items["MainFrame"].Instance.AbsoluteSize
		local MinimizedSize = UDim2New(0, 285, 0, 35)

		Items["MainFrame"].Instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not Window.IsMinimized then
				OldSize = Items["MainFrame"].Instance.AbsoluteSize
			end
		end)

		function Window:Minimize(Bool)
			for Index, Value in Library.OpenFrames do
				Value:SetOpen(false)
			end

			Window.IsMinimized = Bool

			if Window.IsMinimized then
				Items["MainFrame"]:Tween(nil, {Size = MinimizedSize})

				Items["Pages"].Instance.Visible = false
				Items["Content"].Instance.Visible = false
			else
				Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, OldSize.X, 0, OldSize.Y)})

				Items["Pages"].Instance.Visible = true
				Items["Content"].Instance.Visible = true

				wait()

				local CurrentPage = Library.CurrentPage
				if CurrentPage then
					CurrentPage:Turn(true)
				end
			end
		end

		function Window:ChangeSize(XSize, YSize)
			Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, XSize, 0, YSize)})
		end

		local Debounce = false

		function Window:SetCenter()
			Items["MainFrame"].Instance.AnchorPoint = Vector2New(0.5, 0.5)
			Items["MainFrame"].Instance.Position = UDim2New(0.5, 0, 0.5, 0)
		end

		function Window:SetTransparency()
			Items["MainFrame"].Instance.BackgroundTransparency = Library.BackgroundTransparency
		end

		function Window:SetOpen(Bool)
			if Debounce then 
				return
			end

			Window.IsOpen = Bool

			Debounce = true 

			if Window.IsOpen then 
				wait()
				Items["MainFrame"].Instance.Visible = true 
			end

			for Index, Value in Library.OpenFrames do 
				Value:SetOpen(false)
			end

			local Descendants = Items["MainFrame"].Instance:GetDescendants()
			TableInsert(Descendants, Items["MainFrame"].Instance)

			local NewTween

			for Index, Value in Descendants do 
				local TransparencyProperty = Tween:GetProperty(Value)

				if not TransparencyProperty then
					continue 
				end

				if type(TransparencyProperty) == "table" then 
					for _, Property in TransparencyProperty do 
						NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
					end
				else
					NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
				end
			end

			if not NewTween or not NewTween.Tween then
				Debounce = false

				Items["MainFrame"].Instance.Visible = Window.IsOpen
				return
			end

			NewTween.Tween.Completed:Connect(function()
				Debounce = false

				Items["MainFrame"].Instance.Visible = Window.IsOpen
			end)
		end

		function Window:Init()
			Library:Connect(Players.PlayerRemoving, function(Player)
				if Player == LocalPlayer and Library.AutoSave then
					pcall(function()
						writefile(GetAutoloadPath(), Library:GetConfig())
					end)
				end
			end)
		end

		Library:Connect(UserInputService.InputBegan, function(Input)
			if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
				Window:SetOpen(not Window.IsOpen)
			end
		end)

		Items["MinimizeButton"]:Connect("MouseButton1Down", function()
			Window:Minimize(not Window.IsMinimized)
		end)

		Items["CloseButton"]:Connect("MouseButton1Down", function()
			Library:Unload()
		end)

		Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
			local PageSearchData = Library.SearchItems[Library.CurrentPage]

			if not PageSearchData then
				return
			end

			local SearchText = Items["Input"].Instance.Text
			local SearchActive = SearchText and SearchText ~= ""

			for Index, Value in PageSearchData do
				local Name = Value.Name
				local Element = Value.Element
				local Matches = SearchActive and StringFind(StringLower(Name), StringLower(SearchText)) ~= nil

				if Matches then
					Element.Instance.Visible = true

					if Value.Type and Value.Type == "Button" then
						Value.Element2.Instance.Visible = true
					end

					local ContentParent = Element.Instance.Parent
					if ContentParent then
						local ContentHolder = ContentParent
						local SectionFrame = ContentHolder.Parent

						if SectionFrame and SectionFrame:IsA("Frame") then
							local IsSection = false

							for _, Section in Library.AllSections do
								if Section.Items and Section.Items["Section"] and Section.Items["Section"].Instance == SectionFrame then
									IsSection = true

									if Section.Collapsed then
										Section:SetCollapsed(false)
									end

									break
								end
							end
						end
					end
				else
					Element.Instance.Visible = not SearchActive

					if Value.Type and Value.Type == "Button" then
						Value.Element2.Instance.Visible = not SearchActive
					end
				end
			end
		end)

		Window:SetCenter()
		wait()
		if Data.Minimized or Data.minimized then
			Window.IsMinimized = true

			Items["MainFrame"].Instance.Size = UDim2New(0, 285, 0, 35)
			Items["Pages"].Instance.Visible = false
			Items["Content"].Instance.Visible = false
		end

		Window:SetOpen(true)

		return setmetatable(Window, Library)
	end

	Library.Page = function(self, Data)
		Data = Data or {}

		local Page = {
			Window = self,

			Name = Data.Name or Data.name or "Page",
			Columns = Data.Columns or Data.columns or 2,
			IsKeyPage = Data.IsKeyPage or Data.iskeypage or false,

			Items = {},
			ColumnsData = {},
			Active = false
		}

		local Items = {} do
			Items["Inactive"] = Instances:Create("TextButton", {
				Parent = Page.Window.Items["Pages"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 35),
				BackgroundColor3 = Library.Theme["Inline"],
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				ClipsDescendants = true,
				AutoButtonColor = false,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = Items["Inactive"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Items["Liner"] = Instances:Create("Frame", {
				Parent = Items["Inactive"].Instance,
				Name = "\0",
				Size = UDim2New(0, 6, 0, 0),
				Position = UDim2New(0, -3, 0.5, 0),
				AnchorPoint = Vector2New(0, 0.5),
				BackgroundColor3 = FromRGB(255, 174, 254),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Accent'})

			Instances:Create("UICorner", {
				Parent = Items["Liner"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["Inactive"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 0, 15),
				Position = UDim2New(0, 4, 0.5, 0),
				AnchorPoint = Vector2New(0, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Page.Name,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				AutomaticSize = Enum.AutomaticSize.X,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})           

			Items["Page"] = Instances:Create("Frame", {
				Parent = Library.UnusedHolder.Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 1, 0),
				BackgroundColor3 = FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2,
				Visible = false
			})

			if not Page.IsKeyPage then
				Items["Columns"] = Instances:Create("Frame", {
					Parent = Items["Page"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 1, -43),
					Position = UDim2New(0, 0, 0, 43),
					BackgroundColor3 = FromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 2
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Columns"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					VerticalFlex = Enum.UIFlexAlignment.Fill
				})

				for Index = 1, Page.Columns do 
					local NewColumn = Instances:Create("ScrollingFrame", {
						Parent = Items["Columns"].Instance,
						Name = "\0",
						Size = UDim2New(0, 100, 0, 100),
						BackgroundColor3 = FromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderColor3 = FromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Active = true,
						ZIndex = 2,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						BottomImage = "rbxassetid://128693616966482",
						CanvasSize = UDim2New(0, 0, 0, 0),
						MidImage = "rbxassetid://128693616966482",
						ScrollBarImageColor3 = FromRGB(0, 0, 0),
						ScrollBarThickness = 4,
						TopImage = "rbxassetid://128693616966482"
					})  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})

					Instances:Create("UIListLayout", {
						Parent = NewColumn.Instance,
						Name = "\0",
						Padding = UDimNew(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder
					})

					Instances:Create("UIPadding", {
						Parent = NewColumn.Instance,
						Name = "\0",
						PaddingRight = UDimNew(0, 12),
						PaddingBottom = UDimNew(0, 24)
					})

					local ColumnLayout = NewColumn.Instance:FindFirstChildOfClass("UIListLayout")
					if ColumnLayout then
						ColumnLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
							NewColumn.Instance.CanvasSize = UDim2.new(0, 0, 0, ColumnLayout.AbsoluteContentSize.Y + 24)
						end)
					end

					Page.ColumnsData[Index] = NewColumn
				end
			else
				Items["Page"].Instance.Size = UDim2New(1, 0, 1, -43)
				Items["Page"].Instance.Position = UDim2New(0, 0, 0, 43)

				Instances:Create("UIListLayout", {
					Parent = Items["Page"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 15),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				})
			end

			Page.Items = Items
		end

		Library.SearchItems[Page] = {}

		local Debounce = false

		function Page:Turn(Bool)
			Page.Active = Bool

			if Page.Active then
				local ContentFrame = Page.Window.Items["Content"].Instance
				local IsWindowMinimized = Page.Window.IsMinimized

				if not IsWindowMinimized then
					ContentFrame.Visible = true
					wait()
					Items["Page"].Instance.Parent = ContentFrame
					Items["Page"].Instance.Visible = true
				else
					Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
					Items["Page"].Instance.Visible = false
				end

				Items["Liner"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 6, 1, -20)})
				Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0})
				Items["Text"]:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 12, 0.5, 0)})
				wait()
				Library.CurrentPage = Page
			else
				Items["Liner"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 6, 0, 0)})
				Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
				Items["Text"]:Tween(nil, {TextTransparency = 0.4, Position = UDim2New(0, 4, 0.5, 0)})
				Items["Page"].Instance.Visible = false
				wait()
				Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
			end
		end

		Items["Inactive"]:Connect("MouseButton1Down", function()
			for Index, Value in Page.Window.Pages do 
				if Value == Page and Page.Active then
					return
				end

				Value:Turn(Value == Page)
			end
		end)

		if #Page.Window.Pages == 0 then 
			Page:Turn(true)
		end

		TableInsert(Page.Window.Pages, Page)

		return setmetatable(Page, Library.Pages)
	end

	Library.Pages.Section = function(self, Data)
		Data = Data or {}

		local CollapsedDefault = true
		if Data.Collapsed == false then
			CollapsedDefault = false
		end

		local Section = {
			Window = self.Window,
			Page = self,

			Name = Data.Name or Data.name or "Section",
			Side = Data.Side or Data.side or 1,
			Collapsed = CollapsedDefault,

			Items = {}
		}

		local Items = {}

		Items["Section"] = Instances:Create("Frame", {
			Parent = Section.Page.ColumnsData[Section.Side].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 28),
			BackgroundColor3 = Library.Theme["Inline"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Inline'})

		Instances:Create("UICorner", {
			Parent = Items["Section"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Instances:Create("UIGradient", {
			Parent = Items["Section"].Instance,
			Name = "\0"
		})

		Items["Header"] = Instances:Create("TextButton", {
			Parent = Items["Section"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 28),
			Position = UDim2New(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 2
		})

		Items["Text"] = Instances:Create("TextLabel", {
			Parent = Items["Header"].Instance,
			Name = "\0",
			Size = UDim2New(0, 0, 0, 15),
			Position = UDim2New(0, 8, 0, 7),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = Section.Name,
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			AutomaticSize = Enum.AutomaticSize.X,
			ZIndex = 2
		}):AddToTheme({TextColor3 = 'Text'})

		Items["Indicator"] = Instances:Create("ImageLabel", {
			Parent = Items["Header"].Instance,
			Name = "\0",
			Size = UDim2New(0, 23, 0, 23),
			Position = UDim2New(1, -15, 0.5, 0),
			AnchorPoint = Vector2New(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = "rbxassetid://126603363478667",
			ImageColor3 = Library.Theme["Text"],
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 2
		})

		Items["Line"] = Instances:Create("Frame", {
			Parent = Items["Section"].Instance,
			Name = "\0",
			Size = UDim2New(1, -16, 0, 1),
			Position = UDim2New(0, 8, 0, 28),
			BackgroundColor3 = Library.Theme["Border"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Border'})

		Items["ContentHolder"] = Instances:Create("Frame", {
			Parent = Items["Section"].Instance,
			Name = "\0",
			Size = UDim2New(1, -16, 0, 0),
			Position = UDim2New(0, 8, 0, 32),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 2
		})

		Items["Content"] = Instances:Create("Frame", {
			Parent = Items["ContentHolder"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 0),
			Position = UDim2New(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 2
		})

		Instances:Create("UIPadding", {
			Parent = Items["Content"].Instance,
			Name = "\0",
			PaddingTop = UDimNew(0, 6),
			PaddingBottom = UDimNew(0, 6)
		})

		local ListLayout = Instances:Create("UIListLayout", {
			Parent = Items["Content"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local CurrentHeight = 0
		local SizeDebounce = false

		local TweenInfo_Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local TweenInfo_Normal = TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

		local UpdateSize_Connection = nil

		local function UpdateSize()
			if Section.Collapsed or SizeDebounce then return end

			SizeDebounce = true
			defer(function()
				SizeDebounce = false

				if not Section.Collapsed then
					local TargetHeight = Items["Content"].Instance.AbsoluteSize.Y

					if TargetHeight ~= CurrentHeight then
						CurrentHeight = TargetHeight
						Items["ContentHolder"]:Tween(TweenInfo_Fast, {
							Size = UDim2New(1, -16, 0, TargetHeight)
						})
					end
				end
			end)
		end

		UpdateSize_Connection = ListLayout.Instance:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)

		Items["Header"]:Connect("MouseButton1Down", function()
			Section:SetCollapsed(not Section.Collapsed)
		end)

		function Section:SetCollapsed(Bool)
			Section.Collapsed = Bool
			Items["Line"].Instance.Visible = not Section.Collapsed

			if Section.Collapsed then
				Items["Indicator"]:Tween(TweenInfo_Normal, {
					Rotation = 0,
					ImageColor3 = Library.Theme["Text"]
				})
				Items["Content"].Instance.Visible = false
				Items["ContentHolder"]:Tween(TweenInfo_Normal, {
					Size = UDim2New(1, -16, 0, 0)
				})
			else
				Items["Indicator"]:Tween(TweenInfo_Normal, {
					Rotation = 90,
					ImageColor3 = Library.Theme["Accent"]
				})
				Items["Content"].Instance.Visible = true
				Items["ContentHolder"]:Tween(TweenInfo_Normal, {
					Size = UDim2New(1, -16, 0, Items["Content"].Instance.AbsoluteSize.Y)
				})
			end
		end

		Section.Items = Items
		Section.Collapsed = Section.Collapsed
		Section:SetCollapsed(Section.Collapsed)

		table.insert(Library.AllSections, Section)
		return setmetatable(Section, Library.Sections)
	end

	Library.Sections.Toggle = function(self, Data)
		Data = Data or {}

		local Toggle = {
			Window = self.Window,
			Page = self.Page,
			Section = self,

			Name = Data.Name or Data.name or "Toggle",
			Description = Data.Description or Data.description or nil,
			Flag = Data.Flag or Data.flag or Library:NextFlag(),
			Default = Data.Default or Data.default or false,
			Tooltip = Data.Tooltip or Data.tooltip or nil,
			Callback = Data.Callback or Data.callback or function() end,
			Lifetime = Data.Lifetime or Data.lifetime or false,

			Value = false,
			Disabled = false,
		}

		local Items = {} do 
			Items["Toggle"] = Instances:Create("Frame", {
				Parent = Toggle.Section.Items["Content"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2
			})

			Items["Toggle"]:Tooltip(Toggle.Tooltip)

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				Size = UDim2New(1, -96, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Toggle.Name,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})

			Items["Indicator"] = Instances:Create("TextButton", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				Size = UDim2New(0, 40, 0, 20),
				Position = UDim2New(1, 0, 0.5, 0),
				AnchorPoint = Vector2New(1, 0.5),
				BackgroundColor3 = Library.Theme["Element"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2,
				LayoutOrder = 2
			}):AddToTheme({BackgroundColor3 = 'Element'})

			Instances:Create("UICorner", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})

			Instances:Create("UIGradient", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
			})

			Items["Circle"] = Instances:Create("Frame", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				Size = UDim2New(0, 14, 0, 14),
				Position = UDim2New(0, 3, 0, 3),
				BackgroundTransparency = 0.4000000059604645,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ZIndex = 2
			})

			Instances:Create("UICorner", {
				Parent = Items["Circle"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(1, 0)
			})

			Items["SubElements"] = Instances:Create("Frame", {
				Parent = Items["Toggle"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 1, 0),
				Position = UDim2New(1, -48, 0, 0),
				AnchorPoint = Vector2New(1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			})

			Instances:Create("UISizeConstraint", {
				Parent = Items["SubElements"].Instance,
				Name = "\0",
				MinSize = Vector2New(0, 20)
			})

			Instances:Create("UIListLayout", {
				Parent = Items["SubElements"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})

			if Toggle.Description ~= nil and Toggle.Description ~= "" then
				Items["Description"] = Instances:Create("TextLabel", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 16.5),
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Text = Toggle.Description,
					TextColor3 = Library.Theme["Text"],
					TextSize = 12,
					FontFace = Library.Font,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 2
				}):AddToTheme({TextColor3 = 'Text'})
			end
		end

		function Toggle:Get()
			return Toggle.Value 
		end

		function Toggle:Set(Value)
			if Toggle.Disabled then
				return
			end

			if not Library:CheckLifetime(Toggle) then
				return
			end

			Toggle.Value = Value
			Library.Flags[Toggle.Flag] = Value

			local ThemeKey = Value and "Accent" or "Element"
			local TextTrans = Value and 0 or 0.4
			local CircleTrans = Value and 0 or 0.4

			Items["Text"]:Tween(nil, {TextTransparency = TextTrans})

			Items["Circle"]:Tween(TweenInfo.new(Library.Tween.Time + 0.2, Enum.EasingStyle.Quart, Library.Tween.Direction), {
				AnchorPoint = Value and Vector2New(1, 0) or Vector2New(0, 0),
				Position = Value and UDim2New(1, -3, 0, 3) or UDim2New(0, 3, 0, 3),
				BackgroundTransparency = CircleTrans,
			})

			Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = ThemeKey})
			Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme[ThemeKey]})

			if Toggle.Callback then
				Library:SafeCall(Toggle.Callback, Toggle.Value)
			end

			Library:SaveAutoloadIfEnabled()
		end

		function Toggle:SetDisabled(Bool)
			Toggle.Disabled = Bool

			local TextTrans = Bool and 0.6 or (Toggle.Value and 0 or 0.4)
			local CircleTrans = Bool and 0.6 or (Toggle.Value and 0 or 0.4)
			local IndicatorTrans = Bool and 0.6 or 0

			Items["Text"]:Tween(nil, {TextTransparency = TextTrans})
			Items["Circle"]:Tween(nil, {BackgroundTransparency = CircleTrans})
			Items["Indicator"]:Tween(nil, {BackgroundTransparency = IndicatorTrans})
		end

		function Toggle:SetVisibility(Bool)
			Items["Toggle"].Instance.Visible = Bool 
		end

		function Toggle:Colorpicker(Data)
			Data = Data or {}

			local Colorpicker = {
				Window = Toggle.Window,
				Page = Toggle.Page,
				Section = Toggle.Section,

				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
				Callback = Data.Callback or Data.callback or function() end,
				Alpha = Data.Alpha or Data.alpha or false
			}

			local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
				Parent = Items["SubElements"],
				Page = Colorpicker.Page,
				Section = Colorpicker.Section,
				Flag = Colorpicker.Flag,
				Default = Colorpicker.Default,
				Callback = Colorpicker.Callback,
				Alpha = Colorpicker.Alpha
			})

			return NewColorpicker
		end

		function Toggle:Keybind(Data)
			Data = Data or {}

			local Keybind = {
				Window = Toggle.Window,
				Page = Toggle.Page,
				Section = Toggle.Section,

				Name = Data.Name or Data.name or Toggle.Name,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Enum.KeyCode.E,
				Callback = Data.Callback or Data.callback or function() end,
				Mode = Data.Mode or Data.mode or "Toggle"
			}

			local NewKeybind, KeybindItems = Library:CreateKeybind({
				Parent = Items["SubElements"],
				Page = Keybind.Page,
				Section = Keybind.Section,
				Flag = Keybind.Flag,
				Name = Keybind.Name,
				Default = Keybind.Default,
				Mode = Keybind.Mode,
				Callback = Keybind.Callback
			})

			return NewKeybind
		end

		local PageSearchData = Library.SearchItems[Toggle.Page] 

		if PageSearchData then
			local SearchData = { 
				Element = Items["Toggle"],
				Name = Toggle.Name,
			}

			TableInsert(PageSearchData, SearchData)
		end

		Items["Indicator"]:Connect("MouseButton1Down", function()
			Toggle:Set(not Toggle.Value)
		end)

		Toggle:Set(Toggle.Default)

		Library.SetFlags[Toggle.Flag] = function(Value)
			if Toggle.Disabled then
				return
			end

			Toggle:Set(Value)
		end

		function Toggle:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Toggle
		end

		Toggle.Items = Items
		return Toggle 
	end

	Library.Sections.Checkbox = function(self, Data)
		Data = Data or {}

		local Checkbox = {
			Window = self.Window,
			Page = self.Page,
			Section = self,

			Name = Data.Name or Data.name or "Checkbox",
			Description = Data.Description or Data.description or nil,
			Flag = Data.Flag or Data.flag or Library:NextFlag(),
			Default = Data.Default or Data.default or false,
			Tooltip = Data.Tooltip or Data.tooltip or nil,
			Callback = Data.Callback or Data.callback or function() end,
			Lifetime = Data.Lifetime or Data.lifetime or false,

			Value = false,
			Disabled = false,
		}

		local Items = {} do 
			Items["Checkbox"] = Instances:Create("Frame", {
				Parent = Checkbox.Section.Items["Content"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2
			})

			Items["Checkbox"]:Tooltip(Checkbox.Tooltip)

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["Checkbox"].Instance,
				Name = "\0",
				Size = UDim2New(1, -96, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Checkbox.Name,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2
			}):AddToTheme({TextColor3 = 'Text'})

			if Checkbox.Description ~= nil and Checkbox.Description ~= "" then
				Items["Description"] = Instances:Create("TextLabel", {
					Parent = Items["Checkbox"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 16.5),
					AnchorPoint = Vector2New(0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Text = Checkbox.Description,
					TextColor3 = Library.Theme["Text"],
					TextSize = 12,
					FontFace = Library.Font,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 2
				}):AddToTheme({TextColor3 = 'Text'})
			end

			Items["Indicator"] = Instances:Create("TextButton", {
				Parent = Items["Checkbox"].Instance,
				Name = "\0",
				Size = UDim2New(0, 20, 0, 20),
				Position = UDim2New(1, 0, 0.5, 0),
				AnchorPoint = Vector2New(1, 0.5),
				BackgroundColor3 = Library.Theme["Element"],
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 2
			}):AddToTheme({BackgroundColor3 = 'Element'})

			Instances:Create("UICorner", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Instances:Create("UIGradient", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				Rotation = 90,
				Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
			})

			Items["Check"] = Instances:Create("ImageLabel", {
				Parent = Items["Indicator"].Instance,
				Name = "\0",
				Size = UDim2New(1, -2, 1, -2),
				Position = UDim2New(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2New(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Image = "rbxassetid://116339777575852",
				ImageColor3 = FromRGB(0, 0, 0),
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 2
			})

			Items["SubElements"] = Instances:Create("Frame", {
				Parent = Items["Checkbox"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 1, 0),
				Position = UDim2New(1, -28, 0, 0),
				AnchorPoint = Vector2New(1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1
			})

			Instances:Create("UIListLayout", {
				Parent = Items["SubElements"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		end

		function Checkbox:Get()
			return Checkbox.Value
		end

		function Checkbox:Set(Value)
			if Checkbox.Disabled then
				return
			end

			if not Library:CheckLifetime(Checkbox) then
				return
			end

			Checkbox.Value = Value
			Library.Flags[Checkbox.Flag] = Checkbox.Value

			local ThemeKey = Value and "Accent" or "Element"
			local TextTrans = Value and 0 or 0.4
			local CheckTrans = Value and 0 or 1

			Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = ThemeKey})
			Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme[ThemeKey]})
			Items["Check"]:Tween(nil, {ImageTransparency = CheckTrans})
			Items["Text"]:Tween(nil, {TextTransparency = TextTrans})

			if Checkbox.Callback then
				Library:SafeCall(Checkbox.Callback, Checkbox.Value)
			end

			Library:SaveAutoloadIfEnabled()
		end

		function Checkbox:SetDisabled(Bool)
			Checkbox.Disabled = Bool

			local TextTrans = Bool and 0.6 or (Checkbox.Value and 0 or 0.4)
			local IndicatorTrans = Bool and 0.6 or 0
			local CheckTrans = Bool and 1 or (Checkbox.Value and 0 or 1)

			Items["Text"]:Tween(nil, {TextTransparency = TextTrans})
			Items["Indicator"]:Tween(nil, {BackgroundTransparency = IndicatorTrans})
			Items["Check"]:Tween(nil, {ImageTransparency = CheckTrans})
		end

		function Checkbox:SetVisibility(Bool)
			Items["Checkbox"].Instance.Visible = Bool
		end

		function Checkbox:Colorpicker(Data)
			Data = Data or {}

			local Colorpicker = {
				Window = Checkbox.Window,
				Page = Checkbox.Page,
				Section = Checkbox.Section,

				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
				Callback = Data.Callback or Data.callback or function() end,
				Alpha = Data.Alpha or Data.alpha or false
			}

			local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
				Parent = Items["SubElements"],
				Page = Colorpicker.Page,
				Section = Colorpicker.Section,
				Flag = Colorpicker.Flag,
				Default = Colorpicker.Default,
				Callback = Colorpicker.Callback,
				Alpha = Colorpicker.Alpha
			})

			return NewColorpicker
		end

		function Checkbox:Keybind(Data)
			Data = Data or {}

			local Keybind = {
				Window = Checkbox.Window,
				Page = Checkbox.Page,
				Section = Checkbox.Section,

				Name = Data.Name or Data.name or Checkbox.Name,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Enum.KeyCode.E,
				Callback = Data.Callback or Data.callback or function() end,
				Mode = Data.Mode or Data.mode or "Toggle"
			}

			local NewKeybind, KeybindItems = Library:CreateKeybind({
				Parent = Items["SubElements"],
				Page = Keybind.Page,
				Section = Keybind.Section,
				Flag = Keybind.Flag,
				Name = Keybind.Name,
				Default = Keybind.Default,
				Mode = Keybind.Mode,
				Callback = Keybind.Callback
			})

			return NewKeybind
		end

		local PageSearchData = Library.SearchItems[Checkbox.Page]

		if PageSearchData then
			local SearchData = {
				Element = Items["Checkbox"],
				Name = Checkbox.Name,
			}

			TableInsert(PageSearchData, SearchData)
		end

		Items["Indicator"]:Connect("InputBegan", function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Checkbox:Set(not Checkbox.Value)
			end
		end)

		Checkbox:Set(Checkbox.Default)

		Library.SetFlags[Checkbox.Flag] = function(Value)
			Checkbox:Set(Value)
		end

		function Checkbox:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Checkbox
		end

		Checkbox.Items = Items
		return Checkbox
	end

	Library.Sections.Button = function(self)
		local Button = {
			Window = self.Window,
			Page = self.Page,
			Section = self,
		}

		local Items = {}

		Items["ButtonContainer"] = Instances:Create("Frame", {
			Parent = Button.Section.Items["Content"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 25),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 2
		})

		Instances:Create("UIListLayout", {
			Parent = Items["ButtonContainer"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			VerticalFlex = Enum.UIFlexAlignment.Fill
		})

		function Button:Add(Name, Callback, Data)
			Data = Data or {}

			local NewButton = {
				Disabled = false,
				Lifetime = Data.Lifetime or Data.lifetime or false
			}

			local NewItems = {}
			do
				NewItems["NewButton"] = Instances:Create("TextButton", {
					Parent = Items["ButtonContainer"].Instance,
					Name = "\0",
					Size = UDim2New(0, 200, 0, 50),
					BackgroundColor3 = Library.Theme["Element"],
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Text = "",
					TextColor3 = FromRGB(0, 0, 0),
					TextSize = 14,
					FontFace = Library.Font,
					AutoButtonColor = false,
					ZIndex = 2
				}):AddToTheme({BackgroundColor3 = 'Element'})

				Instances:Create("UICorner", {
					Parent = NewItems["NewButton"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Instances:Create("UIGradient", {
					Parent = NewItems["NewButton"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
				})

				NewItems["Text"] = Instances:Create("TextLabel", {
					Parent = NewItems["NewButton"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 1, 0),
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Text = Name,
					TextColor3 = Library.Theme["Text"],
					TextSize = 14,
					FontFace = Library.Font,
					ZIndex = 2
				}):AddToTheme({TextColor3 = 'Text'})
			end

			function NewButton:SetVisibility(Bool)
				NewItems["NewButton"].Instance.Visible = Bool
			end

			function NewButton:Press()
				if NewButton.Disabled then
					return
				end

				if not Library:CheckLifetime(NewButton) then
					return
				end

				if not Library:CheckLifetime(NewButton) then
					return
				end

				NewItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
				NewItems["NewButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
				wait(0.1)
				Library:SafeCall(Callback)
				NewItems["NewButton"]:ChangeItemTheme({BackgroundColor3 = "Element"})
				NewItems["NewButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
			end

			function NewButton:SetDisabled(Bool)
				NewButton.Disabled = Bool

				if NewButton.Disabled then
					NewItems["NewButton"]:Tween(nil, {BackgroundTransparency = 0.6})
					NewItems["Text"]:Tween(nil, {TextTransparency = 0.6})
				else
					NewItems["NewButton"]:Tween(nil, {BackgroundTransparency = 0})
					NewItems["Text"]:Tween(nil, {TextTransparency = 0})
				end
			end

			local PageSearchData = Library.SearchItems[Button.Page]

			if PageSearchData then
				local SearchData = {
					Element = NewItems["NewButton"],
					Element2 = Items["ButtonContainer"],
					Name = Name,
					Type = "Button",
				}

				TableInsert(PageSearchData, SearchData)
			end

			NewItems["NewButton"]:Connect("MouseButton1Down", function()
				NewButton:Press()
			end)

			NewButton.Items = NewItems
			return Button, NewButton
		end

		function Button:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end
			return Button
		end

		Button.Items = Items
		return Button
	end

	Library.Sections.Slider = function(self, Data)
		Data = Data or {}

		local Min = Data.Min or Data.min or 0
		local Max = Data.Max or Data.max or 100
		local Decimals = Data.Decimals or Data.decimals
		local AutoDecimals = (Decimals == nil)

		local SuggestedDecimals = 0
		local Range = Max - Min
		if Range <= 1 then
			SuggestedDecimals = 2
		elseif Range <= 10 then
			SuggestedDecimals = 1
		elseif Range <= 100 then
			SuggestedDecimals = 0
		else
			SuggestedDecimals = math.max(math.ceil(math.log10(Range)) - 2, 0)
		end

		local Slider = {
			Window = self.Window,
			Page = self.Page,
			Section = self,

			Name = Data.Name or Data.name or "Slider",
			Description = Data.Description or Data.description or nil,
			Flag = Data.Flag or Data.flag or Library:NextFlag(),
			Min = Min,
			Default = Data.Default or Data.default or Min,
			Max = Max,
			Suffix = Data.Suffix or Data.suffix or "",
			Tooltip = Data.Tooltip or Data.tooltip or nil,
			Decimals = Decimals,
			DisplayDecimals = AutoDecimals and SuggestedDecimals or 0,
			Callback = Data.Callback or Data.callback or function() end,
			Lifetime = Data.Lifetime or Data.lifetime or false,

			Value = 0,
			Sliding = false,
			Disabled = false,
			InputChangedConnection = nil,
		}

		local Items = {}

		Items["SliderContainer"] = Instances:Create("Frame", {
			Parent = Slider.Section.Items["Content"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 2
		})

		Instances:Create("UIListLayout", {
			Parent = Items["SliderContainer"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})

		Items["Text"] = Instances:Create("TextLabel", {
			Parent = Items["SliderContainer"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 15),
			Position = UDim2New(0, 0, 0, 0),
			AnchorPoint = Vector2New(0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = Slider.Name,
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 4,
			LayoutOrder = 0
		}):AddToTheme({TextColor3 = 'Text'})

		if Slider.Description ~= nil and Slider.Description ~= "" then
			Items["Description"] = Instances:Create("TextLabel", {
				Parent = Items["SliderContainer"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Slider.Description,
				TextColor3 = Library.Theme["Text"],
				TextSize = 12,
				FontFace = Library.Font,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 4,
				LayoutOrder = 1
			}):AddToTheme({TextColor3 = 'Text'})
		end

		Items["SliderRow"] = Instances:Create("Frame", {
			Parent = Items["SliderContainer"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 15),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.None,
			ZIndex = 2,
			LayoutOrder = 2
		})

		Instances:Create("UIListLayout", {
			Parent = Items["SliderRow"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})

		Items["ValueBackground"] = Instances:Create("Frame", {
			Parent = Items["SliderRow"].Instance,
			Name = "\0",
			Size = UDim2New(0, 55, 1, 0),
			BackgroundColor3 = Library.Theme["Element"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = false,
			ZIndex = 3,
			LayoutOrder = 1
		}):AddToTheme({BackgroundColor3 = 'Element'})

		Instances:Create("UICorner", {
			Parent = Items["ValueBackground"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Items["Value"] = Instances:Create("TextBox", {
			Parent = Items["ValueBackground"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 1, 0),
			Position = UDim2New(0, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = StringFormat("%s%s", Slider.Value, Slider.Suffix),
			TextColor3 = Library.Theme["Text"],
			TextSize = 12,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextScaled = false,
			PlaceholderColor3 = Library.Theme["Inactive Text"],
			ClearTextOnFocus = false,
			CursorPosition = -1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			ZIndex = 4
		}):AddToTheme({TextColor3 = 'Text'})

		Items["RealSlider"] = Instances:Create("TextButton", {
			Parent = Items["SliderRow"].Instance,
			Name = "\0",
			Size = UDim2New(1, -60, 1, 0),
			BackgroundColor3 = Library.Theme["Element"],
			BackgroundTransparency = 0,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "",
			ClipsDescendants = true,
			AutoButtonColor = false,
			Active = false,
			Selectable = false,
			ZIndex = 2,
			LayoutOrder = 0
		}):AddToTheme({BackgroundColor3 = 'Element'})

		Instances:Create("UICorner", {
			Parent = Items["RealSlider"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Instances:Create("UIGradient", {
			Parent = Items["RealSlider"].Instance,
			Name = "\0",
			Rotation = 90,
			Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
		})

		Items["Accent"] = Instances:Create("Frame", {
			Parent = Items["RealSlider"].Instance,
			Name = "\0",
			Size = UDim2New(0.5, 0, 1, 0),
			BackgroundColor3 = Library.Theme["Accent"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 2
		}):AddToTheme({BackgroundColor3 = 'Accent'})

		Instances:Create("UIGradient", {
			Parent = Items["Accent"].Instance,
			Name = "\0",
			Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
		})

		Instances:Create("UICorner", {
			Parent = Items["Accent"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Items["Drag"] = Instances:Create("Frame", {
			Parent = Items["Accent"].Instance,
			Name = "\0",
			Size = UDim2New(0, 7, 1, 0),
			Position = UDim2New(1, 0, 0.5, 0),
			AnchorPoint = Vector2New(1, 0.5),
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 5
		})

		Instances:Create("UICorner", {
			Parent = Items["Drag"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Items["Text"]:Tooltip(Slider.Tooltip)

		local SliderFocused = false

		Items["Value"]:Connect("Focused", function()
			if Slider.Disabled then
				return
			end

			SliderFocused = true

			local Stripped = StringGSub(Items["Value"].Instance.Text, "[^0-9%.%-]", "")

			Items["Value"].Instance.Text = Stripped
		end)

		Items["Value"]:Connect("focusLost", function(enterPressed)
			if Slider.Disabled then
				return
			end

			SliderFocused = false

			local Text = Items["Value"].Instance.Text
			local Stripped = StringGSub(Text, "[^0-9%.%-]", "")
			local InputValue = tonumber(Stripped)

			if InputValue then
				Slider:Set(InputValue)
				Items["Value"].Instance.TextColor3 = Library.Theme["Text"]
			else
				Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)
				Items["Value"].Instance.TextColor3 = Library.Theme["Text"]
			end
		end)

		Items["Value"]:Connect("Changed", function(Property)
			if Property == "Text" and SliderFocused then

				local Text = Items["Value"].Instance.Text
				local Stripped = StringGSub(Text, "[^0-9%.%-]", "")
				local NumValue = tonumber(Stripped)

				if NumValue then
					Items["Value"].Instance.TextColor3 = Library.Theme["Text"]
				elseif Text ~= "" then
					Items["Value"].Instance.TextColor3 = FromRGB(255, 80, 80)
				end
			end
		end)

		Library.SliderElements[Slider] = {
			Slider = Items["SliderContainer"],
			RealSlider = Items["RealSlider"],
			Accent = Items["Accent"],
			Drag = Items["Drag"]
		}

		function Slider:Get()
			return Slider.Value
		end

		function Slider:SetVisibility(Bool)
			Items["SliderContainer"].Instance.Visible = Bool
		end

		function Slider:Set(Value)
			if Slider.Disabled then
				return
			end

			if not Library:CheckLifetime(Slider) then
				return
			end

			local ClampedValue = MathClamp(Value, Slider.Min, Slider.Max)

			if Slider.Decimals then
				local Offset = ClampedValue - Slider.Min
				local StepFrac = Offset / Slider.Decimals
				local NearestStep = MathFloor(StepFrac + 0.5)

				Slider.Value = Slider.Min + NearestStep * Slider.Decimals
				Slider.Value = MathClamp(Slider.Value, Slider.Min, Slider.Max)
			else
				Slider.Value = Library:Round(ClampedValue, 0)
			end

			Library.Flags[Slider.Flag] = Slider.Value

			Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})

			local DisplayValue = string.format("%g", Slider.Value)
			Items["Value"].Instance.Text = StringFormat("%s%s", DisplayValue, Slider.Suffix)

			if Slider.Callback then
				Library:SafeCall(Slider.Callback, Slider.Value)
			end

			Library:SaveAutoloadIfEnabled()
		end

		function Slider:SetDisabled(Bool)
			Slider.Disabled = Bool

			if Slider.Disabled then
				Items["RealSlider"]:Tween(nil, {BackgroundTransparency = 0.6})
				Items["Accent"]:Tween(nil, {BackgroundTransparency = 0.6})
				Items["Value"]:Tween(nil, {TextTransparency = 0.6})
				Items["ValueBackground"]:Tween(nil, {BackgroundTransparency = 0.6})
			else
				Items["RealSlider"]:Tween(nil, {BackgroundTransparency = 0})
				Items["Accent"]:Tween(nil, {BackgroundTransparency = 0})
				Items["Value"]:Tween(nil, {TextTransparency = 0})
				Items["ValueBackground"]:Tween(nil, {BackgroundTransparency = 0})
			end
		end

		local PageSearchData = Library.SearchItems[Slider.Page]

		if PageSearchData then
			local SearchData = {
				Element = Items["SliderContainer"],
				Name = Slider.Name,
			}

			TableInsert(PageSearchData, SearchData)
		end

		local function UpdateSliderValue()
			if Slider.Disabled or not Slider.Sliding then
				return
			end

			local MouseLocation = UserInputService:GetMouseLocation()
			local SliderAbs = Items["RealSlider"].Instance.AbsolutePosition
			local SliderSize = Items["RealSlider"].Instance.AbsoluteSize
			local SizeX = MathClamp((MouseLocation.X - SliderAbs.X) / SliderSize.X, 0, 1)
			local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

			Slider:Set(Value)
		end

		Items["RealSlider"]:Connect("InputBegan", function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if Slider.Disabled then
					return
				end

				Slider.Sliding = true

				local MouseLocation = UserInputService:GetMouseLocation()
				local SliderAbs = Items["RealSlider"].Instance.AbsolutePosition
				local SliderSize = Items["RealSlider"].Instance.AbsoluteSize
				local SizeX = MathClamp((MouseLocation.X - SliderAbs.X) / SliderSize.X, 0, 1)
				local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

				Slider:Set(Value)

				Slider.InputChangedConnection = Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Slider.Sliding = false
						Slider.InputChangedConnection:Disconnect()
						Slider.InputChangedConnection = nil
					end
				end)
			end
		end)

		Slider.InputChangedConnection = Library:Connect(UserInputService.InputChanged, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				UpdateSliderValue()
			end
		end)

		if Slider.Default then
			Slider:Set(Slider.Default)
		end

		Library.SetFlags[Slider.Flag] = function(Value)
			if Slider.Disabled then
				return
			end
			Slider:Set(Value)
		end

		function Slider:Destroy()
			if Slider.InputChangedConnection then
				Slider.InputChangedConnection:Disconnect()
				Slider.InputChangedConnection = nil
			end

			if Library.SliderElements[Slider] then
				Library.SliderElements[Slider] = nil
			end

			if Library.SetFlags[Slider.Flag] then
				Library.SetFlags[Slider.Flag] = nil
			end

			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Slider
		end

		Slider.Items = Items
		return Slider
	end

	Library.Sections.Dropdown = function(self, Data)
		Data = Data or {}

		local Dropdown = {
			Window = self.Window,
			Page = self.Page,
			Section = self,

			Name = Data.Name or Data.name or "Dropdown",
			Description = Data.Description or Data.description or nil,
			Flag = Data.Flag or Data.flag or Library:NextFlag(),
			Items = Data.Items or Data.items or { "One", "Two", "Three" },
			MaxSize = Data.MaxSize or Data.maxsize or 280,
			Tooltip = Data.Tooltip or Data.tooltip or nil,
			Default = Data.Default or Data.default or nil,
			Callback = Data.Callback or Data.callback or function() end,
			Multi = Data.Multi or Data.multi or false,
			Lifetime = Data.Lifetime or Data.lifetime or false,

			Value = {},
			Options = {},
			IsOpen = false,
			Disabled = false,
		}

		local Items = {}

		Items["DropdownContainer"] = Instances:Create("Frame", {
			Parent = Dropdown.Section.Items["Content"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 2
		})

		Instances:Create("UIListLayout", {
			Parent = Items["DropdownContainer"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})

		Items["Text"] = Instances:Create("TextLabel", {
			Parent = Items["DropdownContainer"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 15),
			Position = UDim2New(0, 0, 0, 0),
			AnchorPoint = Vector2New(0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = Dropdown.Name,
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 4,
			LayoutOrder = 0
		}):AddToTheme({TextColor3 = 'Text'})

		Items["Text"]:Tooltip(Dropdown.Tooltip)

		if Dropdown.Description ~= nil and Dropdown.Description ~= "" then
			Items["Description"] = Instances:Create("TextLabel", {
				Parent = Items["DropdownContainer"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 15),
				Position = UDim2New(0, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Dropdown.Description,
				TextColor3 = Library.Theme["Text"],
				TextSize = 12,
				FontFace = Library.Font,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 4,
				LayoutOrder = 1
			}):AddToTheme({TextColor3 = 'Text'})
		end

		Items["RealDropdown"] = Instances:Create("TextButton", {
			Parent = Items["DropdownContainer"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 25),
			Position = UDim2New(0, 0, 0, 0),
			AnchorPoint = Vector2New(0, 0),
			BackgroundColor3 = Library.Theme["Element"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			Active = false,
			Selectable = false,
			ZIndex = 2,
			LayoutOrder = 2
		}):AddToTheme({BackgroundColor3 = 'Element'})

		Instances:Create("UICorner", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Instances:Create("UIGradient", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			Rotation = 90,
			Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
		})

		Items["Value"] = Instances:Create("TextLabel", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			Size = UDim2New(1, -25, 0, 15),
			Position = UDim2New(0, 8, 0.5, 0),
			AnchorPoint = Vector2New(0, 0.5),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "...",
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,
			TextTruncate = Enum.TextTruncate.None
		}):AddToTheme({TextColor3 = 'Text'})

		Instances:Create("UIGradient", {
			Parent = Items["Value"].Instance,
			Name = "\0",
			Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.676, 0), NumSequenceKeypoint(1, 1)}
		})

		Items["Icon"] = Instances:Create("ImageLabel", {
			Parent = Items["RealDropdown"].Instance,
			Name = "\0",
			Size = UDim2New(0, 23, 0, 23),
			Position = UDim2New(1, -13, 0.5, 0),
			AnchorPoint = Vector2New(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "rbxassetid://126603363478667",
			ImageColor3 = Library.Theme["Text"],
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 2
		})

		Items["OptionHolder"] = Instances:Create("TextButton", {
			Parent = Library.UnusedHolder.Instance,
			Name = "\0",
			Size = UDim2New(0, 155, 0, 125),
			Position = UDim2New(0, 0, 0, 5),
			AnchorPoint = Vector2New(0, 0),
			BackgroundColor3 = Library.Theme["Background"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "",
			ClipsDescendants = true,
			AutoButtonColor = false,
			ZIndex = 5,
			Visible = false,
			SelectionGroup = true
		}):AddToTheme({BackgroundColor3 = 'Background'})

		Instances:Create("UICorner", {
			Parent = Items["OptionHolder"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Items["Holder"] = Instances:Create("ScrollingFrame", {
			Parent = Items["OptionHolder"].Instance,
			Name = "\0",
			Size = UDim2New(1, -16, 1, -48),
			Position = UDim2New(0, 8, 0, 40),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Active = true,
			ZIndex = 5,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BottomImage = "rbxassetid://128693616966482",
			CanvasSize = UDim2New(0, 0, 0, 0),
			MidImage = "rbxassetid://128693616966482",
			ScrollBarImageColor3 = Library.Theme["Accent"],
			ScrollBarThickness = 3,
			TopImage = "rbxassetid://128693616966482"
		}):AddToTheme({ScrollBarImageColor3 = 'Accent'})

		Instances:Create("UIPadding", {
			Parent = Items["Holder"].Instance,
			Name = "\0",
			PaddingLeft = UDimNew(0, 5),
			PaddingRight = UDimNew(0, 8),
			PaddingTop = UDimNew(0, 5),
			PaddingBottom = UDimNew(0, 8)
		})

		Instances:Create("UIListLayout", {
			Parent = Items["Holder"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		Items["Search"] = Instances:Create("Frame", {
			Parent = Items["OptionHolder"].Instance,
			Name = "\0",
			Size = UDim2New(1, -16, 0, 30),
			Position = UDim2New(0, 8, 0, 8),
			BackgroundColor3 = Library.Theme["Inline"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 5
		}):AddToTheme({BackgroundColor3 = 'Inline'})

		Instances:Create("UICorner", {
			Parent = Items["Search"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Items["SearchIcon"] = Instances:Create("ImageLabel", {
			Parent = Items["Search"].Instance,
			Name = "\0",
			Size = UDim2New(0, 20, 0, 20),
			Position = UDim2New(0, 8, 0.5, 0),
			AnchorPoint = Vector2New(0, 0.5),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Image = "rbxassetid://71924825350727",
			ImageTransparency = 0.4000000059604645,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 5
		})

		Items["Input"] = Instances:Create("TextBox", {
			Parent = Items["Search"].Instance,
			Name = "\0",
			Size = UDim2New(1, -43, 0, 15),
			Position = UDim2New(0, 35, 0.5, 0),
			AnchorPoint = Vector2New(0, 0.5),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "",
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			PlaceholderText = "Search..",
			PlaceholderColor3 = Library.Theme["Inactive Text"],
			ZIndex = 5
		}):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})

		function Dropdown:Get()
			return Dropdown.Value
		end

		function Dropdown:SetVisibility(Bool)
			Items["DropdownContainer"].Instance.Visible = Bool
		end

		function Dropdown:SetDisabled(Bool)
			Dropdown.Disabled = Bool

			if Dropdown.Disabled then
				if Items["Text"] then
					Items["Text"]:Tween(nil, {TextTransparency = 0.6})
				end
				Items["RealDropdown"]:Tween(nil, {BackgroundTransparency = 0.6})
				Items["Value"]:Tween(nil, {TextTransparency = 0.6})
				Items["Icon"]:Tween(nil, {ImageTransparency = 0.6})

				Dropdown:SetOpen(false)
			else
				if Items["Text"] then
					Items["Text"]:Tween(nil, {TextTransparency = 0})
				end
				Items["RealDropdown"]:Tween(nil, {BackgroundTransparency = 0})
				Items["Value"]:Tween(nil, {TextTransparency = 0})
				Items["Icon"]:Tween(nil, {ImageTransparency = 0})
			end
		end

		local Debounce = false
		local RenderStepped

		local function UpdatePosition()
			if not Library or not Items["OptionHolder"].Instance.Parent then return end

			local Scale = (Library.Holder.Instance:FindFirstChildOfClass("UIScale") or {Scale = 1}).Scale
			local Button = Items["RealDropdown"].Instance
			local MainFrame = Dropdown.Window.Items["MainFrame"].Instance
			local MainFrameRight = MainFrame.AbsolutePosition.X + MainFrame.AbsoluteSize.X - 8
			local MainFrameBottom = MainFrame.AbsolutePosition.Y + MainFrame.AbsoluteSize.Y - 8

			local DropdownSize = Dropdown.MaxSize
			local Left = math.max(Button.AbsolutePosition.X, MainFrame.AbsolutePosition.X + 8)
			local Out = math.min(Button.AbsolutePosition.X + Button.AbsoluteSize.X, MainFrameRight) - Left
			local Below = MainFrameBottom - (Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 5)

			if Below >= DropdownSize then
				Items["OptionHolder"].Instance.Position = UDim2New(0, Left / Scale, 0, (Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 5) / Scale)
				Items["OptionHolder"].Instance.Size = UDim2New(0, Out / Scale, 0, (math.min(Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 5 + DropdownSize, MainFrameBottom) - (Button.AbsolutePosition.Y + Button.AbsoluteSize.Y + 5)) / Scale)
			else
				local List = Button.AbsolutePosition.Y - 5
				local Top = math.max(List - DropdownSize, MainFrame.AbsolutePosition.Y + 8)

				Items["OptionHolder"].Instance.Position = UDim2New(0, Left / Scale, 0, Top / Scale)
				Items["OptionHolder"].Instance.Size = UDim2New(0, Out / Scale, 0, (List - Top) / Scale)
			end
		end

		function Dropdown:SetOpen(Bool)
			if Debounce then
				return
			end

			if not Library:CheckLifetime(Dropdown) then
				return
			end

			Dropdown.IsOpen = Bool
			Debounce = true

			local Theme = Library.Theme
			local TweenInfoArgs = {Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction}

			if Dropdown.IsOpen then
				wait()
				Items["Icon"]:Tween(TweenInfo.new(unpack(TweenInfoArgs)), {
					Rotation = 90,
					ImageColor3 = Theme["Accent"]
				})
			else
				Items["Icon"]:Tween(TweenInfo.new(unpack(TweenInfoArgs)), {
					Rotation = 0,
					ImageColor3 = Theme["Text"]
				})
			end

			if Dropdown.IsOpen then
				Items["OptionHolder"].Instance.Visible = true
				Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

				UpdatePosition()

				RenderStepped = RunService.RenderStepped:Connect(function()
					if not Library then return end
					UpdatePosition()
				end)

				for Index, Value in Library.OpenFrames do
					if Value ~= Dropdown then
						Value:SetOpen(false)
					end
				end

				Library.OpenFrames[Dropdown] = Dropdown
			else
				if Library.OpenFrames[Dropdown] then
					Library.OpenFrames[Dropdown] = nil
				end

				if RenderStepped then
					RenderStepped:Disconnect()
					RenderStepped = nil
				end
			end

			local Descendants = Items["OptionHolder"].Instance:GetDescendants()
			TableInsert(Descendants, Items["OptionHolder"].Instance)

			local NewTween

			for Index, Value in Descendants do
				local TransparencyProperty = Tween:GetProperty(Value)

				if not TransparencyProperty then
					continue
				end

				if not Value.ClassName:find("UI") then
					Value.ZIndex = Dropdown.IsOpen and 127 or 1
				end

				if type(TransparencyProperty) == "table" then
					for _, Property in TransparencyProperty do
						NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
					end
				else
					NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
				end
			end

			if not NewTween or not NewTween.Tween then
				Debounce = false

				Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
				wait(0.2)
				Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
				return
			end

			NewTween.Tween.Completed:Connect(function()
				Debounce = false

				Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
				wait(0.2)
				Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
			end)
		end

		function Dropdown:Set(Option)
			if Option == nil then
				return
			end

			local Flags = Library.Flags
			local Flag = Dropdown.Flag

			if Dropdown.Multi then
				if type(Option) ~= "table" then
					return
				end

				Dropdown.Value = Option
				Flags[Flag] = Option

				for _, Value in Option do
					local OptionData = Dropdown.Options[Value]

					if OptionData then
						OptionData.Selected = true
						OptionData:Toggle("Active")
					end
				end

				Items["Value"].Instance.Text = TableConcat(Option, ", ")
			else
				local String = tostring(Option)
				if String == "" or String == "nil" then
					return
				end

				local OptionData = Dropdown.Options[String]
				if not OptionData then
					return
				end

				Dropdown.Value = String
				Flags[Flag] = String

				for _, Value in Dropdown.Options do
					Value:Toggle(Value == OptionData and "Active" or "Inactive")
				end

				Items["Value"].Instance.Text = String
			end

			if Dropdown.Callback then
				Library:SafeCall(Dropdown.Callback, Dropdown.Value)
			end

			Library:SaveAutoloadIfEnabled()
		end

		function Dropdown:Add(Option)
			local OptionButton = Instances:Create("TextButton", {
				Parent = Items["Holder"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 25),
				BackgroundColor3 = Library.Theme["Inline"],
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = "",
				TextColor3 = FromRGB(0, 0, 0),
				TextSize = 14,
				FontFace = Library.Font,
				AutoButtonColor = false,
				ZIndex = 5
			}):AddToTheme({BackgroundColor3 = 'Inline'})

			Instances:Create("UICorner", {
				Parent = OptionButton.Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			local OptionText = Instances:Create("TextLabel", {
				Parent = OptionButton.Instance,
				Name = "\0",
				Size = UDim2New(1, -15, 1, 0),
				Position = UDim2New(0, 4, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Option,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextTransparency = 0.4000000059604645,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 5
			}):AddToTheme({TextColor3 = 'Text'})

			local OptionData = {
				Button = OptionButton,
				Name = Option,
				Text = OptionText,
				Selected = false
			}

			function OptionData:Toggle(Value)
				if Value == "Active" then
					OptionData.Text:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 8, 0, 0)})
					OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
				else
					OptionData.Text:Tween(nil, {TextTransparency = 0.4, Position = UDim2New(0, 4, 0, 0)})
					OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
				end
			end

			function OptionData:Set()
				if not Library:CheckLifetime(Dropdown) then
					return
				end

				OptionData.Selected = not OptionData.Selected

				local Flags = Library.Flags
				local Flag = Dropdown.Flag

				if Dropdown.Multi then
					local Index = TableFind(Dropdown.Value, OptionData.Name)

					if Index then
						TableRemove(Dropdown.Value, Index)
					else
						TableInsert(Dropdown.Value, OptionData.Name)
					end

					OptionData:Toggle(Index and "Inactive" or "Active")
					Flags[Flag] = Dropdown.Value

					Items["Value"].Instance.Text = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
				else
					if OptionData.Selected then
						Dropdown.Value = OptionData.Name
						Flags[Flag] = OptionData.Name

						for _, Value in Dropdown.Options do
							if Value ~= OptionData then
								Value.Selected = false
								Value:Toggle("Inactive")
							end
						end

						OptionData:Toggle("Active")
						Items["Value"].Instance.Text = OptionData.Name
					else
						Dropdown.Value = nil
						Flags[Flag] = nil

						OptionData:Toggle("Inactive")
						Items["Value"].Instance.Text = "..."
					end
				end

				if Dropdown.Callback then
					Library:SafeCall(Dropdown.Callback, Dropdown.Value)
				end

				Library:SaveAutoloadIfEnabled()
			end

			OptionData.Button:Connect("MouseButton1Down", function(Input)
				if Dropdown.Disabled then
					return
				end
				OptionData:Set()
			end)

			Dropdown.Options[OptionData.Name] = OptionData
			return OptionData
		end

		function Dropdown:Remove(Option)
			if Dropdown.Options[Option] then
				Dropdown.Options[Option].Button:Clean()
				Dropdown.Options[Option] = nil
			end
		end

		function Dropdown:Refresh(List)
			for Index, Value in Dropdown.Options do
				Dropdown:Remove(Value.Name)
			end

			for Index, Value in List do
				Dropdown:Add(Value)
			end
		end

		local PageSearchData = Library.SearchItems[Dropdown.Page]

		if PageSearchData then
			local SearchData = {
				Element = Items["DropdownContainer"],
				Name = Dropdown.Name,
			}

			TableInsert(PageSearchData, SearchData)
		end

		if IsMobile then
			Items["RealDropdown"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.Touch then
					if Dropdown.Disabled then
						return
					end

					Dropdown:SetOpen(not Dropdown.IsOpen)
				end
			end)
		else
			Items["RealDropdown"]:Connect("MouseButton1Down", function()
				if Dropdown.Disabled then
					return
				end

				Dropdown:SetOpen(not Dropdown.IsOpen)
			end)
		end

		Library:Connect(UserInputService.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if Dropdown.Disabled then
					return
				end

				if Dropdown.IsOpen then
					if Library:IsMouseOverFrame(Items["OptionHolder"]) then
						return
					end

					Dropdown:SetOpen(false)
				end
			end
		end)

		Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
			local SearchText = Items["Input"].Instance.Text

			for Index, Value in Dropdown.Options do
				if StringFind(StringLower(Value.Name), StringLower(SearchText)) then
					Value.Button.Instance.Visible = true
				else
					Value.Button.Instance.Visible = false
				end
			end
		end)

		Items["RealDropdown"]:Connect("Changed", function(Property)
			if Property == "AbsolutePosition" and Dropdown.IsOpen then
				Dropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
				Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
			end
		end)

		for Index, Value in Dropdown.Items do
			Dropdown:Add(Value)
		end

		if Dropdown.Default then
			Dropdown:Set(Dropdown.Default)
		end

		Items["Icon"].Instance.Rotation = 0

		Library.SetFlags[Dropdown.Flag] = function(Value)
			if Dropdown.Disabled then
				return
			end

			Dropdown:Set(Value)
		end

		function Dropdown:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Dropdown
		end

		Dropdown.Items = Items
		return Dropdown
	end

	Library.Sections.Label = function(self, Name, Description, Tooltip)
		local Label = {
			Window = self.Window,
			Page = self.Page,
			Section = self,

			Name = Name or "Label",
			Description = Description or nil,
			HasSubElements = false,
		}

		local Items = {} do
			Items["Label"] = Instances:Create("Frame", {
				Parent = Label.Section.Items["Content"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2
			})

			Items["Label"]:Tooltip(Tooltip)

			Instances:Create("UIListLayout", {
				Parent = Items["Label"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})

			Items["MainRow"] = Instances:Create("Frame", {
				Parent = Items["Label"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2,
				LayoutOrder = 0
			})

			Instances:Create("UIListLayout", {
				Parent = Items["MainRow"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})

			Items["TextContainer"] = Instances:Create("Frame", {
				Parent = Items["MainRow"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2,
				LayoutOrder = 0
			})

			Instances:Create("UIListLayout", {
				Parent = Items["TextContainer"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["TextContainer"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Label.Name,
				TextColor3 = Library.Theme["Text"],
				TextSize = 14,
				FontFace = Library.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 2,
				LayoutOrder = 0
			}):AddToTheme({TextColor3 = 'Text'})

			if Label.Description ~= nil and Label.Description ~= "" then
				Items["Description"] = Instances:Create("TextLabel", {
					Parent = Items["TextContainer"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 0),
					AnchorPoint = Vector2New(0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Text = Label.Description,
					TextColor3 = Library.Theme["Text"],
					TextSize = 12,
					FontFace = Library.Font,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 2,
					LayoutOrder = 1
				}):AddToTheme({TextColor3 = 'Text'})
			end

			Items["SubElements"] = Instances:Create("Frame", {
				Parent = Items["MainRow"].Instance,
				Name = "\0",
				Size = UDim2New(0, 0, 1, 0),
				Position = UDim2New(1, 0, 0, 0),
				AnchorPoint = Vector2New(1, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1
			})

			Instances:Create("UIListLayout", {
				Parent = Items["SubElements"].Instance,
				Name = "\0",
				Padding = UDimNew(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		end

		function Label:Colorpicker(Data)
			Data = Data or {}

			Label.HasSubElements = true

			local NewColorpicker = Library:CreateColorpicker({
				Parent = Items["SubElements"],
				Page = Label.Page,
				Section = Label.Section,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
				Callback = Data.Callback or Data.callback or function() end,
				Alpha = Data.Alpha or Data.alpha or false
			})

			return NewColorpicker
		end

		function Label:Keybind(Data)
			Data = Data or {}

			Label.HasSubElements = true

			local NewKeybind = Library:CreateKeybind({
				Parent = Items["SubElements"],
				Name = Data.Name or Data.name or Label.Name,
				Page = Label.Page,
				Section = Label.Section,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or Enum.KeyCode.E,
				Mode = Data.Mode or Data.mode or "Toggle",
				Callback = Data.Callback or Data.callback or function() end
			})

			return NewKeybind
		end

		function Label:SetText(Text)
			if Items["Text"] and Items["Text"].Instance then
				Items["Text"].Instance.Text = tostring(Text)
			end
		end

		function Label:SetTextColor(Color)
			if not Items["Text"] or not Items["Text"].Instance then
				return
			end

			if type(Color) == "table" then
				Color = FromRGB(Color[1], Color[2], Color[3])
			elseif type(Color) == "string" then
				Color = FromHex(Color)
			end

			Items["Text"].Instance.TextColor3 = Color
		end

		function Label:SetVisibility(Bool)
			if Items["Label"] and Items["Label"].Instance then
				Items["Label"].Instance.Visible = Bool
			end
		end

		function Label:Destroy()
			for _, Item in Items do
				if Item and Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Label
		end

		Label.Items = Items
		return Label
	end
	Library.Sections.Textbox = function(self, Data)
		Data = Data or {}

		local Textbox = {
			Window = self.Window,
			Page = self.Page,
			Section = self,

			Name = Data.Name or Data.name or "Textbox",
			Description = Data.Description or Data.description or nil,
			Flag = Data.Flag or Data.flag or Library:NextFlag(),
			Default = Data.Default or Data.default or "",
			Tooltip = Data.Tooltip or Data.tooltip or nil,
			Callback = Data.Callback or Data.callback or function() end,
			Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
			Numeric = Data.Numeric or Data.numeric or false,
			Finished = Data.Finished or Data.finished or false,
			Lifetime = Data.Lifetime or Data.lifetime or false,

			Disabled = false,

			Value = ""
		}

		local Items = {}

		Items["TextboxContainer"] = Instances:Create("Frame", {
			Parent = Textbox.Section.Items["Content"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 2
		})

		Instances:Create("UIListLayout", {
			Parent = Items["TextboxContainer"].Instance,
			Name = "\0",
			Padding = UDimNew(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})

		Items["Text"] = Instances:Create("TextLabel", {
			Parent = Items["TextboxContainer"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 0),
			Position = UDim2New(0, 0, 0, 0),
			AnchorPoint = Vector2New(0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = Textbox.Name,
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 4,
			LayoutOrder = 0
		}):AddToTheme({TextColor3 = 'Text'})

		Items["Text"]:Tooltip(Textbox.Tooltip)

		if Textbox.Description ~= nil and Textbox.Description ~= "" then
			Items["Description"] = Instances:Create("TextLabel", {
				Parent = Items["TextboxContainer"].Instance,
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderColor3 = FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Text = Textbox.Description,
				TextColor3 = Library.Theme["Text"],
				TextSize = 12,
				FontFace = Library.Font,
				TextTransparency = 0.5,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 4,
				LayoutOrder = 1
			}):AddToTheme({TextColor3 = 'Text'})
		end

		Items["Background"] = Instances:Create("Frame", {
			Parent = Items["TextboxContainer"].Instance,
			Name = "\0",
			Size = UDim2New(1, 0, 0, 25),
			Position = UDim2New(0, 0, 0, 0),
			AnchorPoint = Vector2New(0, 0),
			BackgroundColor3 = Library.Theme["Element"],
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ClipsDescendants = false,
			ZIndex = 2,
			LayoutOrder = 2
		}):AddToTheme({BackgroundColor3 = 'Element'})

		Instances:Create("UIGradient", {
			Parent = Items["Background"].Instance,
			Name = "\0",
			Rotation = 90,
			Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
		})

		Instances:Create("UICorner", {
			Parent = Items["Background"].Instance,
			Name = "\0",
			CornerRadius = UDimNew(0, 5)
		})

		Items["Input"] = Instances:Create("TextBox", {
			Parent = Items["Background"].Instance,
			Name = "\0",
			Size = UDim2New(1, -16, 1, 0),
			Position = UDim2New(0, 8, 0, 0),
			BackgroundTransparency = 1,
			BorderColor3 = FromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Text = "",
			TextColor3 = Library.Theme["Text"],
			TextSize = 14,
			FontFace = Library.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextStrokeColor3 = Library.Theme["Text"],
			PlaceholderText = Textbox.Placeholder,
			PlaceholderColor3 = Library.Theme["Inactive Text"],
			ClearTextOnFocus = false,
			CursorPosition = -1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			ZIndex = 2
		}):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})

		Library.TextboxElements[Textbox] = {
			Textbox = Items["TextboxContainer"],
			Background = Items["Background"],
			Input = Items["Input"]
		}

		local InputInstance = Items["Input"].Instance

		function Textbox:Get()
			return Textbox.Value
		end

		function Textbox:SetDisabled(Bool)
			Textbox.Disabled = Bool

			if Textbox.Disabled then
				if Items["Text"] then
					Items["Text"]:Tween(nil, {TextTransparency = 0.6})
				end
				Items["Background"]:Tween(nil, {BackgroundTransparency = 0.6})
				Items["Input"]:Tween(nil, {TextTransparency = 0.6})
				InputInstance.Interactable = false
			else
				if Items["Text"] then
					Items["Text"]:Tween(nil, {TextTransparency = 0})
				end
				Items["Background"]:Tween(nil, {BackgroundTransparency = 0})
				Items["Input"]:Tween(nil, {TextTransparency = 0})
				InputInstance.Interactable = true
			end
		end

		function Textbox:SetVisibility(Bool)
			Items["TextboxContainer"].Instance.Visible = Bool
		end

		function Textbox:Set(Value)
			if Textbox.Disabled then
				return
			end

			if not Library:CheckLifetime(Textbox, "Textbox") then
				return
			end

			local String = tostring(Value)

			if Textbox.Numeric then
				if (not tonumber(String)) and StringLen(String) > 0 then
					return
				end
			end

			Textbox.Value = Value

			if InputInstance.Text ~= String then
				InputInstance.Text = String
			end

			Library.Flags[Textbox.Flag] = Value

			if Textbox.Callback then
				Library:SafeCall(Textbox.Callback, Value)
			end

			Library:SaveAutoloadIfEnabled()
		end

		local PageSearchData = Library.SearchItems[Textbox.Page]

		if PageSearchData then
			local SearchData = {
				Element = Items["TextboxContainer"],
				Name = Textbox.Name,
			}

			TableInsert(PageSearchData, SearchData)
		end

		if Textbox.Finished then
			Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
				if Textbox.Disabled then
					return
				end

				if not Library:CheckLifetime(Textbox) then
					return
				end

				if PressedEnterQuestionMark then
					Textbox:Set(InputInstance.Text)
				end
			end)
		else
			Library:Connect(InputInstance:GetPropertyChangedSignal("Text"), function()
				if Textbox.Disabled then
					return
				end

				if not Library:CheckLifetime(Textbox) then
					return
				end

				Textbox:Set(InputInstance.Text)
			end)
		end

		if Textbox.Default then
			Textbox:Set(Textbox.Default)
		end

		Library.SetFlags[Textbox.Flag] = function(Value)
			if Textbox.Disabled then
				return
			end

			Textbox:Set(Value)
		end

		function Textbox:Destroy()
			for _, Item in Items do
				if Item.Instance then
					Debris:AddItem(Item.Instance, 0)
				end
			end

			return Textbox
		end

		Textbox.Items = Items
		return Textbox
	end

	Library.CreateSettingsPage = function(self, Window, Watermark, KeybindList)
		local Settings = Window:Page({Name = "Settings", Columns = 2})

		do 
			local PlayerInfo_Section = Settings:Section({Name = "Player Info", Side = 1})

			Library:GetDataFromPlayer(PlayerInfo_Section)
		end

		do
			local ThemeSetting_Section = Settings:Section({Name = "Theme Setting", Side = 1})
			local ThemeConfig_Section = Settings:Section({Name = "Theme Config", Side = 1})
			local Theme_Colorpicker = {}

			local ThemeFolder = Library:GetFolderTheme()

			local function NotifySuccessTheme(Message)
				Library:Notification({
					Name = "Success",
					Description = Message,
					Color = Color3.fromRGB(0, 255, 0),
					Duration = 5
				})
			end

			local function NotifyErrorTheme(Message)
				Library:Notification({
					Name = "Error",
					Description = Message,
					Color = Color3.fromRGB(255, 0, 0),
					Duration = 5
				})
			end

			do
				for Index, Value in Library.Theme do
					Theme_Colorpicker[Index] = ThemeSetting_Section:Label(Index, Index:lower() .. " theme color"):Colorpicker({
						Flag = Index,
						Default = Value,
						Alpha = 0,
						Callback = function(Value)
							Library.Theme[Index] = Value
							Library:ChangeTheme(Index, Value)
						end
					})
				end
			end

			do
				local Theme_Name
				local Theme_Selected

				local Theme_Dropdown = ThemeConfig_Section:Dropdown({
					Name = "Themes Select",
					Flag = "Themes Select",
					Description = "Select a theme preset",
					Items = {},
					Multi = false,
					Callback = function(Value)
						Theme_Selected = Value
					end
				})

				ThemeConfig_Section:Textbox({
					Name = "Theme Name",
					Flag = "Theme Name",
					Description = "Enter a name for your theme",
					Placeholder = "Theme name...",
					Finished = true,
					Callback = function(Value)
						Theme_Name = Value
					end
				})

				ThemeConfig_Section:Button():Add("Create", function()
					if not Theme_Name or Theme_Name == "" then
						return
					end

					local Success, Error = pcall(function()
						writefile(ThemeFolder .. Theme_Name .. ".json", Library:GetTheme())
					end)

					if Success then
						Library:RefreshThemeList(Theme_Dropdown)
						NotifySuccessTheme("Succesfully created theme: " .. Theme_Name)
					else
						NotifyErrorTheme("Failed to create theme: " .. Theme_Name .. " " .. tostring(Error))
					end
				end):Add("Delete", function()
					if not Theme_Selected then
						NotifyErrorTheme("Please select a theme first")
						return
					end

					local ThemePath = ThemeFolder .. Theme_Selected .. ".json"
					local Success, Error = pcall(function()
						if isfile(ThemePath) then
							delfile(ThemePath)
						end
					end)

					if Success then
						Library:RefreshThemeList(Theme_Dropdown)
						NotifySuccessTheme("Succesfully deleted theme: " .. Theme_Selected)
					else
						NotifyErrorTheme("Failed to delete theme: " .. Theme_Selected .. " " .. tostring(Error))
					end
				end)

				ThemeSetting_Section:Button():Add("Load", function()
					if not Theme_Selected then
						NotifyErrorTheme("Please select a theme first")
						return
					end

					local ThemePath = ThemeFolder .. Theme_Selected .. ".json"

					if not isfile(ThemePath) then
						NotifyErrorTheme("Failed to find theme: " .. Theme_Selected)
						return
					end

					local ThemeContent = readfile(ThemePath)
					local Success, Error = Library:LoadTheme(ThemeContent)

					if Success then
						NotifySuccessTheme("Succesfully loaded theme: " .. Theme_Selected)
					else
						NotifyErrorTheme("Failed to load theme: " .. Theme_Selected .. " " .. tostring(Error))
					end
				end):Add("Save", function()
					if not Theme_Selected then
						NotifyErrorTheme("Please select a theme first")
						return
					end

					local ThemePath = ThemeFolder .. Theme_Selected .. ".json"

					if not isfile(ThemePath) then
						NotifyErrorTheme("Failed to find theme: " .. Theme_Selected)
						return
					end

					local Success, Error = pcall(function()
						writefile(ThemePath, Library:GetTheme())
					end)

					if Success then
						NotifySuccessTheme("Succesfully saved theme: " .. Theme_Selected)
					else
						NotifyErrorTheme("Failed to save theme: " .. Theme_Selected .. " " .. tostring(Error))
					end
				end)

				ThemeSetting_Section:Button():Add("Refresh", function()
					Library:RefreshThemeList(Theme_Dropdown)
				end)

				local Preset_Section = ThemeSetting_Section:Dropdown({
					Name = "Themes Preset",
					Flag = "Themes Preset",
					Description = "Select a theme",
					Items = {},
					Default = "Preset",
					Multi = false,
					Callback = function(Value)
						local ThemeData = Library.Themes[Value]

						if not ThemeData then
							return
						end

						for Index, Value in Library.Theme do
							Library.Theme[Index] = ThemeData[Index]
							Library:ChangeTheme(Index, ThemeData[Index])

							Theme_Colorpicker[Index]:Set(ThemeData[Index])
						end
					end
				})

				for Index, Value in Library.Themes do
					Preset_Section:Add(Index)
				end

				Library:RefreshThemeList(Theme_Dropdown)
			end
		end

		do
			local KeyInfo_Section = Settings:Section({Name = "Key Info", Side = 2})

			Library:GetDataFromLuarmor(KeyInfo_Section)
		end

		do
			local MenuSetting_Section = Settings:Section({Name = "Menu Setting", Side = 2})

			do
				MenuSetting_Section:Button():Add("Unload", function()
					Library:Unload()
				end)

				MenuSetting_Section:Label("Menu keybind", "Keybind to open/close the menu"):Keybind({
					Name = "Menu Keybind",
					Flag = "Menu Keybind",
					Default = Enum.KeyCode.RightControl,
					Mode = "Toggle",
					Callback = function(Value)
						Library.MenuKeybind = Library.Flags["Menu Keybind"].Key
					end
				})

				MenuSetting_Section:Slider({
					Name = "Background Transparency",
					Flag = "Background Transparency",
					Description = "Menu background transparency",
					Min = 0,
					Max = 1,
					Default = Library.BackgroundTransparency,
					Decimals = 0.01,                
					Callback = function(Value)
						Library.BackgroundTransparency = Value
						Window:SetTransparency(Value)
						KeybindList:SetTransparency(Value)
					end
				})

				MenuSetting_Section:Slider({
					Name = "Menu Tween Time",
					Flag = "Menu Tween Time",
					Description = "Menu animation tween time",
					Min = 0,
					Max = 5,
					Default = Library.Tween.Time,
					Decimals = 0.01,                 
					Callback = function(Value)
						Library.Tween.Time = Value
					end
				})

				MenuSetting_Section:Slider({
					Name = "Menu Fade Time",
					Flag = "Menu Fade Time",
					Description = "Menu fade animation time",
					Min = 0,
					Max = 5,
					Default = Library.FadeSpeed,
					Decimals = 0.01,
					Callback = function(Value)
						Library.FadeSpeed = Value
					end
				})

				MenuSetting_Section:Dropdown({
					Name = "Menu Scale Preset",
					Flag = "Menu Scale Preset",
					Description = "Select Menu scale preset",
					Default = IsMobile and "Bigger" or "Medium",
					Items = {"Very Small", "Small", "Medium", "Large", "Bigger", "Massive"},
					Callback = function(Value)
						Library:SetScaleNumeric(ScaleValues[Value])
					end
				})

				MenuSetting_Section:Dropdown({
					Name = "Menu Tween Style",
					Flag = "Menu Tween Style",
					Description = "Menu animation easing style",                  
					Default = "Cubic",
					Items = {"Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular", "Back", "Elastic", "Bounce"},
					Callback = function(Value)
						Library.Tween.Style = Enum.EasingStyle[Value]
					end
				})

				MenuSetting_Section:Dropdown({
					Name = "Menu Tween Direction",
					Flag = "Menu Tween Direction",
					Description = "Menu animation easing direction",
					Default = "Out",
					Items = {"In", "Out", "InOut"},
					Callback = function(Value)
						Library.Tween.Direction = Enum.EasingDirection[Value]
					end
				})

				MenuSetting_Section:Toggle({
					Name = "Show Watermark",
					Flag = "Show Watermark",
					Description = "Show/hide the Watermark",
					Default = false,
					Callback = function(Value)
						Watermark:SetVisibility(Value)
					end
				})

				MenuSetting_Section:Toggle({
					Name = "Show Keybind List",
					Flag = "Show Keybind List",
					Description = "Show/hide list of all keybinds",
					Default = false,
					Callback = function(Value)
						KeybindList:SetVisibility(Value)
					end
				})

				MenuSetting_Section:Toggle({
					Name = "Show Floating Button",
					Flag = "Show Floating Button",
					Description = "Show/hide the floating button",
					Default = true,
					Callback = function(Value)
						if Library.FloatingButtonHolder then
							Library.FloatingButtonHolder.Instance.Enabled = Value
						end
					end
				})

				MenuSetting_Section:Toggle({
					Name = "Auto Save Config",
					Flag = "Auto Save Config",
					Description = "Automatically save your config",
					Default = false,
					Callback = function(Value)
						Library.AutoSave = Value
					end
				})
			end
		end

		do
			local ScriptConfig_Section = Settings:Section({Name = "Script Config", Side = 2})

			local ConfigFolder = Library:GetFolder()
			local AutoloadPath = GetAutoloadPath()

			local function NotifySuccessConfig(Message)
				Library:Notification({
					Name = "Success",
					Description = Message,
					Color = Color3.fromRGB(0, 255, 0),
					Duration = 5
				})
			end

			local function NotifyErrorConfig(Message)
				Library:Notification({
					Name = "Error",
					Description = Message,
					Color = Color3.fromRGB(255, 0, 0),
					Duration = 5
				})
			end

			do
				local Config_Name
				local Config_Selected

				local Config_Dropdown = ScriptConfig_Section:Dropdown({
					Name = "Config Select",
					Flag = "Config Select",
					Description = "List of the configs",
					Items = {},
					Multi = false,
					Callback = function(Value)
						Config_Selected = Value
					end
				})

				ScriptConfig_Section:Textbox({
					Name = "Config Name",
					Flag = "Config Name",
					Description = "Name of the config",
					Placeholder = "Config name...",
					Finished = false,
					Callback = function(Value)
						Config_Name = Value
					end
				})

				ScriptConfig_Section:Button():Add("Create", function()
					if not Config_Name or Config_Name == "" then
						return
					end

					local Success, Error = pcall(function()
						writefile(ConfigFolder .. Config_Name .. ".json", Library:GetConfig())
					end)

					if Success then
						Library:RefreshConfigsList(Config_Dropdown)
						NotifySuccessConfig("Succesfully created config: " .. Config_Name)
					else
						NotifyErrorConfig("Failed to create config: " .. Config_Name .. " " .. tostring(Error))
					end
				end):Add("Delete", function()
					if not Config_Selected then
						NotifyErrorConfig("Please select a config first")
						return
					end

					local ConfigPath = ConfigFolder .. Config_Selected .. ".json"
					local Success, Error = pcall(function()
						if isfile(ConfigPath) then
							delfile(ConfigPath)
						end
					end)

					if Success then
						Library:RefreshConfigsList(Config_Dropdown)
						NotifySuccessConfig("Succesfully deleted config: " .. Config_Selected)
					else
						NotifyErrorConfig("Failed to delete config: " .. Config_Selected .. " " .. tostring(Error))
					end
				end)

				ScriptConfig_Section:Button():Add("Load", function()
					if not Config_Selected then
						NotifyErrorConfig("Please select a config first")
						return
					end

					local ConfigPath = ConfigFolder .. Config_Selected .. ".json"

					if not isfile(ConfigPath) then
						NotifyErrorConfig("Failed to find config: " .. Config_Selected)
						return
					end

					local ConfigContent = readfile(ConfigPath)
					local Success, Error = Library:LoadConfig(ConfigContent)

					if Success then
						NotifySuccessConfig("Succesfully loaded config: " .. Config_Selected)
					else
						NotifyErrorConfig("Failed to load config: " .. (Config_Selected or "Unknown") .. " " .. tostring(Error))
					end
				end):Add("Save", function()
					if not Config_Selected then
						NotifyErrorConfig("Please select a config first")
						return
					end

					local ConfigPath = ConfigFolder .. Config_Selected .. ".json"

					if not isfile(ConfigPath) then
						NotifyErrorConfig("Failed to find config: " .. Config_Selected)
						return
					end

					local Success, Error = pcall(function()
						writefile(ConfigPath, Library:GetConfig())
					end)

					if Success then
						NotifySuccessConfig("Succesfully saved config: " .. Config_Selected)
					else
						NotifyErrorConfig("Failed to save config: " .. Config_Selected .. " " .. tostring(Error))
					end
				end)

				ScriptConfig_Section:Button():Add("Refresh", function()
					Library:RefreshConfigsList(Config_Dropdown)
				end)

				ScriptConfig_Section:Button():Add("Set Autoload", function()
					local Success, Error = pcall(function()
						writefile(AutoloadPath, Library:GetConfig())
					end)

					if Success then
						NotifySuccessConfig("Autoload set to current config")
					else
						NotifyErrorConfig("Failed to set autoload: " .. tostring(Error))
					end
				end):Add("Remove Autoload", function()
					local Success, Error = pcall(function()
						writefile(AutoloadPath, "")
					end)

					if Success then
						NotifySuccessConfig("Succesfully removed autoload")
					else
						NotifyErrorConfig("Failed to remove autoload: " .. tostring(Error))
					end
				end)

				local Pasted_Config = ""

				ScriptConfig_Section:Textbox({
					Name = "Paste Shared Config",
					Flag = "Paste Shared Config",
					Description = "Paste config here",
					Placeholder = "Paste config here...",
					Finished = true,
					Callback = function(Value)
						Pasted_Config = Value
					end
				})

				ScriptConfig_Section:Button():Add("Share Config", function()
					local CurrentConfig = Library:GetConfig()
					local Success, Error = pcall(setclipboard, CurrentConfig)

					if Success then
						NotifySuccessConfig("Config copied to clipboard")
					else
						NotifyErrorConfig("Failed to copy config: " .. tostring(Error))
					end
				end):Add("Import Pasted", function()
					if not Pasted_Config or Pasted_Config == "" then
						NotifyErrorConfig("No config pasted")
						return
					end

					local Success, Error = Library:LoadConfig(Pasted_Config)

					if Success then
						NotifySuccessConfig("Succesfully imported config")
					else
						NotifyErrorConfig("Failed to import config: " .. tostring(Error))
					end
				end)

				Library:RefreshConfigsList(Config_Dropdown)
			end
		end
	end
end

getgenv().Library = Library
return Library