if not LPH_OBFUSCATED then
	LPH_JIT_MAX = function(...) return ... end
	LPH_NO_VIRTUALIZE = function(f) return f end
	LPH_NO_UPVALUES = function(...) return ... end
	LPH_CRASH = function(...) return ... end
else
	print = function() end
	warn = function() end
end

local Folder_Configs = {
	Directory = "solixhub",
	Configs = "solixhub/Configs",
	Assets = "solixhub/Assets",
	Themes = "solixhub/Themes"
}

local function GetFolders()
	local Library = getgenv().Library

	if Library and (Library["Folders"] or Library.Folders_Path) then 
		return Library["Folders"] or Library.Folders_Path
	end

	return Folder_Configs
end

local Library = getgenv().Library

if type(Library) ~= "table" then
	Library = { }
	getgenv().Library = Library
end

if not getgenv().LibraryUnloading then
	getgenv().LibraryUnloading = true

	if type(Library.Unload) == "function" then
		pcall(Library.Unload, Library)
	end

	getgenv().LibraryUnloading = false
end

for _, folder in {"solixhub", "solixhub/Configs", "solixhub/Assets", "solixhub/Themes"} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

Library["Folders"] = Folder_Configs
Library.Folders_Path = Folder_Configs

local Library do 
	local wait = task.wait
	local spawn = task.spawn
	local delay = task.delay
	local defer = task.defer

	local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
	local TweenService = cloneref(game:GetService("TweenService"))
	local UserInputService = cloneref(game:GetService("UserInputService"))
	local Players = cloneref(game:GetService("Players"))
	local HttpService = cloneref(game:GetService("HttpService"))
	local RunService = cloneref(game:GetService("RunService"))

	gethui = gethui or function()
		return CoreGui
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
		Theme =  { },

		MenuKeybind = tostring(Enum.KeyCode.RightControl), 

		Flags = { },

		Tween = {
			Time = 0.3,
			Style = Enum.EasingStyle.Quad,
			Direction = Enum.EasingDirection.Out
		},

		FadeSpeed = 0.2,

		BackgroundTransparency = 0.25,

		CustomCursor = true,

		Folders_Path = {
			Directory = "solixhub",
			Configs = "solixhub/Configs",
			Assets = "solixhub/Assets",
			Themes = "solixhub/Themes"
		},

		Pages = { },
		Sections = { },

		Windows = { },
		AllSections = { },

		SearchItems = { },
		CurrentPage = nil,

		Connections = { },
		Threads = { },

		ThemeMap = { },
		ThemeItems = { },

		OpenFrames = { },

		SetFlags = { },
		Themes = { },

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

			return NewTween
		end

		Tween.GetProperty = function(self, Item)
			Item = Item or self.Item 

			if Item:IsA("Frame") then
				return { "BackgroundTransparency" }
			elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
				return { "TextTransparency", "BackgroundTransparency" }
			elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
				return { "BackgroundTransparency", "ImageTransparency" }
			elseif Item:IsA("ScrollingFrame") then
				return { "BackgroundTransparency", "ScrollBarImageTransparency" }
			elseif Item:IsA("TextBox") then
				return { "TextTransparency", "BackgroundTransparency" }
			elseif Item:IsA("UIStroke") then 
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

			Library:Connect(NewTween.Tween.Completed, function()
				if not Visibility then 
					wait()
					Item[Property] = OldTransparency
				end
			end)

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

			Tween:Pause()
			self = nil
		end
	end

	local Instances = { } do
		Instances.__index = Instances

		Instances.Create = function(self, Class, Properties)
			local NewItem = {
				Instance = InstanceNew(Class),
				Properties = Properties,
				Class = Class
			}

			setmetatable(NewItem, Instances)

			for Property, Value in NewItem.Properties do
				NewItem.Instance[Property] = Value
			end

			return NewItem
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

		Instances.Tween = function(self, Info, Goal)
			if not self.Instance then 
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

			self.Instance:Destroy()
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
					Name = "\0",
					Size = Size,
					Position = Position,
					BackgroundColor3 = FromRGB(166, 147, 243),
					BackgroundTransparency = 1,
					Text = "",
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Parent = Gui,
					ZIndex = 99999,
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

				for Index, Value in Edges do 
					Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
				end
			end

			local EndResizing = function()
				Resizing = false 
				CurrentSide = nil

				for Index, Value in Edges do 
					Value.Button.Instance.BackgroundTransparency = 1
				end
			end

			for Index, Value in Edges do 
				Value.Button:Connect("InputBegan", function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						BeginResizing(Value.Side)
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
				local dx = (MouseLocation.X - StartMouse.X) / Scale
				local dy = (MouseLocation.Y - StartMouse.Y) / Scale

				local x, y = StartPosition.X, StartPosition.Y
				local w, h = StartSize.X, StartSize.Y

				if CurrentSide == "L" then
					x = StartPosition.X + dx
					w = StartSize.X - dx
				elseif CurrentSide == "R" then
					w = StartSize.X + dx
				elseif CurrentSide == "T" then
					y = StartPosition.Y + dy
					h = StartSize.Y - dy
				elseif CurrentSide == "B" then
					h = StartSize.Y + dy
				end

				if w < Minimum.X then
					if CurrentSide == "L" then
						x = x - (Minimum.X - w)
					end
					w = Minimum.X
				end
				if h < Minimum.Y then
					if CurrentSide == "T" then
						y = y - (Minimum.Y - h)
					end
					h = Minimum.Y
				end

				self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
				self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
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

			local Items = { } do
				Items["Tooltip"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					BackgroundColor3 = Library.Theme["Background"],
					BorderSizePixel = 0,
					Position = UDim2New(0, MouseLocation.X / Scale, 0, (MouseLocation.Y - 22) / Scale),
					Size = UDim2New(0, 0, 0, 0),
					BackgroundTransparency = 1,
					Visible = true,
					AutomaticSize = Enum.AutomaticSize.XY,
					ZIndex = 99
				}):AddToTheme({BackgroundColor3 = 'Background'})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Tooltip"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Text,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 1, 0),
					ClipsDescendants = true,
					ZIndex = 99,
					TextTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextSize = 14,
					BackgroundColor3 = FromRGB(15, 12, 16)
				}):AddToTheme({TextColor3 = 'Text'})

				Instances:Create("UIPadding", {
					Parent = Items["Text"].Instance,
					Name = "\0",
					PaddingBottom = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 8),
					PaddingTop = UDimNew(0, 8),
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
					local S = Library.UIScaleNum or 1
					Items["Tooltip"]:Tween(nil, {Position = UDim2New(0, MouseLocation.X / S, 0, (MouseLocation.Y - 42) / S)})
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

	local CustomFont = { } do
		function CustomFont:New(Name, Weight, Style, Data)
			if not isfile(Data.Id) then 
				writefile(Data.Id, game:HttpGet(Data.Url))
			end

			local Data = {
				name = Name,
				faces = {
					{
						name = Name,
						weight = Weight,
						style = Style,
						assetId = getcustomasset(Data.Id)
					}
				}
			}

			writefile(`{GetFolders().Assets}/{Name}.font`, HttpService:JSONEncode(Data))
			return Font.new(getcustomasset(`{GetFolders().Assets}/{Name}.font`))
		end

		Library.Font = CustomFont:New("InterSemiBold", 400, "Regular", {
			Id = "InterSemiBold",
			Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
		})
	end

	Library.Holder = Instances:Create("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 2,
		ResetOnSpawn = false
	})

	local ViewportSize = function()
		local Camera = workspace.CurrentCamera
		return (Camera and Camera.ViewportSize) or Vector2New(1920, 1080)
	end
	Library.UIScaleDesignSize = Vector2New(770, 526)
	Library.UIScaleScreenPercent = 2.3 / 3
	Library.UIScaleObject = Instances:Create("UIScale", {
		Parent = Library.Holder.Instance,
		Name = "UIScale",
		Scale = 1
	})
	Library.UIScaleNum = 1

	function Library:SetScaleFromScreenPercent(Percent)
		Percent = MathClamp(Percent, 0.2, 1)
		self.UIScaleScreenPercent = Percent

		local Viewport = ViewportSize()
		local DesignWidth, DesignHeight = self.UIScaleDesignSize.X, self.UIScaleDesignSize.Y

		local ShortSide = math.min(Viewport.X, Viewport.Y)
		local ScreenPercent
		if ShortSide <= 600 then
			ScreenPercent = 0.95
		elseif ShortSide <= 800 then
			ScreenPercent = 0.85
		elseif ShortSide <= 1000 then
			ScreenPercent = 0.78
		else
			ScreenPercent = 0.72
		end

		local TargetWidth = math.min(DesignWidth, Viewport.X * ScreenPercent)
		local TargetHeight = math.min(DesignHeight, Viewport.Y * ScreenPercent)

		local ScaleWidth = TargetWidth / DesignWidth
		local ScaleHeight = TargetHeight / DesignHeight
		local Scale = math.min(ScaleWidth, ScaleHeight)

		Scale = MathClamp(Scale, 0.25, 1.2)
		self.UIScaleObject.Instance.Scale = Scale
		self.UIScaleNum = Scale
	end

	if IsMobile then
		Library:SetScaleFromScreenPercent(2.3 / 3)
	else
		Library.UIScaleObject.Instance.Scale = 1
		Library.UIScaleNum = 1
	end
	defer(function()
		local Camera = Workspace.CurrentCamera

		if Camera then
			Library:Connect(Camera:GetPropertyChangedSignal("ViewportSize"), function()
				if IsMobile then
					Library:SetScaleFromScreenPercent(Library.UIScaleScreenPercent)
				else
					Library.UIScaleObject.Instance.Scale = 1
					Library.UIScaleNum = 1
				end
			end)
		end
	end)

	Library.OtherHolder = Instances:Create("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 2,
		ResetOnSpawn = false
	})

	Library.UnusedHolder = Instances:Create("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		Enabled = false,
		ResetOnSpawn = false
	})

	Library.NotifHolder = Instances:Create("Frame", {
		Parent = Library.Holder.Instance,
		Name = "\0",
		BorderColor3 = FromRGB(0, 0, 0),
		AnchorPoint = Vector2New(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2New(1, 0, 0, 0),
		Size = UDim2New(0, 0, 1, 0),
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
		PaddingTop = UDimNew(0, 12),
		PaddingBottom = UDimNew(0, 12),
		PaddingRight = UDimNew(0, 12),
		PaddingLeft = UDimNew(0, 12)
	})    

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

		Library = nil 
		getgenv().Library = nil
	end

	Library.Round = function(self, Number, Float)
		if not Float or Float >= 1 then
			return MathFloor(Number)
		end

		local Multiplier = 1 / Float
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
		local Config = { } 

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

			if IsMobile and Library.FloatingButton and Library.FloatingButton.Instance then
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
		self._LoadingConfig = true
		local Success, Result = Library:SafeCall(function()
			for Index, Value in Decoded do 
				if Index == "FloatingButtonPosition" then
					if IsMobile and Library.FloatingButton and Library.FloatingButton.Instance then
						Library.FloatingButton.Instance.Position = UDim2New(Value.X.Scale, Value.X.Offset, Value.Y.Scale, Value.Y.Offset)
					end
					continue
				end

				if Index == "Auto Save" and type(Value) == "boolean" then
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
		self._LoadingConfig = false
		return Success, Result
	end

	Library.RefreshConfigsList = function(self, Element)
		local List = { }
		local ReturnList = { }

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
		local Config = { } 

		local Success, Result = Library:SafeCall(function()
			for Index, Value in Library.Flags do 
				if type(Value) == "table" and Value.Color and StringFind(Value.Flag, "ThemingThing") then
					print("FOUND")
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
		local List = { }
		local ReturnList = { }

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
		return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
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
		if not self._LoadingConfig and self.AutoSave then
			pcall(function()
				writefile(self.Folders.Directory .. "/autoload.json", self:GetConfig())
			end)
		end
	end

	Library.CheckForAutoLoad = function(self)
		local ConfigContent = readfile(Library.Folders_Path.Directory .. "/autoload.json")

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
				Description = "Failed to load config: \n" .. (Error or "Unknown error"),
				Color = Color3.fromRGB(255, 0, 0),
				Duration = 5
			})
		end
	end
	do 
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

			local Items = { } do 
				Items["ColorpickerButton"] = Instances:Create("TextButton", {
					Parent = Data.Parent.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(1, 0),
					BorderSizePixel = 0,
					Position = UDim2New(1, 0, 0, 0),
					Size = UDim2New(0, 20, 0, 20),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 215, 160)
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
					AutoButtonColor = false,
					Text = "",
					Name = "\0",
					ClipsDescendants = true,
					BackgroundTransparency = 0.30000001192092896,
					Position = UDim2New(0.005806451663374901, 0, 0.016434893012046814, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 218, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Background"]
				}):AddToTheme({BackgroundColor3 = 'Background'})

				Instances:Create("UICorner", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Hue"] = Instances:Create("TextButton", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 8, 1, -75),
					Size = UDim2New(1, -16, 0, 18),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Instances:Create("UICorner", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["HueDragger"] = Instances:Create("Frame", {
					Parent = Items["Hue"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 0.5),
					Position = UDim2New(0, 12, 0.5, 0),
					Size = UDim2New(0, 2, 1, -10),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Instances:Create("UIStroke", {
					Parent = Items["HueDragger"].Instance,
					Name = "\0",
					Thickness = 1.2000000476837158,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(1, 0),
					BorderSizePixel = 0,
					Position = UDim2New(1, -8, 0, 8),
					Size = UDim2New(0, 18, 1, -110),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 215, 160)
				})

				Instances:Create("UICorner", {
					Parent = Items["Alpha"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["AlphaDragger"] = Instances:Create("Frame", {
					Parent = Items["Alpha"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0.5, 0),
					Position = UDim2New(0.5, 0, 0, 3),
					Size = UDim2New(1, -10, 0, 2),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Instances:Create("UIStroke", {
					Parent = Items["AlphaDragger"].Instance,
					Name = "\0",
					Thickness = 1.2000000476837158,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				})

				Instances:Create("UICorner", {
					Parent = Items["AlphaDragger"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0)
				})

				Items["Checkers"] = Instances:Create("ImageLabel", {
					Parent = Items["Alpha"].Instance,
					Name = "\0",
					ScaleType = Enum.ScaleType.Tile,
					BorderColor3 = FromRGB(0, 0, 0),
					TileSize = UDim2New(0, 6, 0, 6),
					Image = "http://www.roblox.com/asset/?id=18274452449",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 1, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Instances:Create("UIGradient", {
					Parent = Items["Checkers"].Instance,
					Name = "\0",
					Rotation = 90,
					Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
				})

				Instances:Create("UICorner", {
					Parent = Items["Checkers"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Palette"] = Instances:Create("TextButton", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Position = UDim2New(0, 9, 0, 8),
					Size = UDim2New(1, -44, 1, -110),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 215, 160)
				})

				Instances:Create("UICorner", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Saturation"] = Instances:Create("ImageLabel", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Image = "rbxassetid://130624743341203",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 1, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Instances:Create("UICorner", {
					Parent = Items["Saturation"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Value"] = Instances:Create("ImageLabel", {
					Parent = Items["Palette"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 2, 1, 0),
					Image = "rbxassetid://96192970265863",
					BackgroundTransparency = 1,
					Position = UDim2New(0, -1, 0, 0),
					ZIndex = 3,
					BorderSizePixel = 0
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
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Instances:Create("UICorner", {
					Parent = Items["PaletteDragger"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0)
				})

				Instances:Create("UIStroke", {
					Parent = Items["PaletteDragger"].Instance,
					Name = "\0",
					Thickness = 1.2000000476837158,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				})

				Items["Background"] = Instances:Create("Frame", {
					Parent = Items["ColorpickerWindow"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 8, 1, -8),
					Size = UDim2New(1, -16, 0, 25),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Element"]
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
					FontFace = Library.Font,
					TextStrokeColor3 = Library.Theme["Text"],
					PlaceholderColor3 = Library.Theme["Inactive Text"],
					PlaceholderText = "Enter RGB..",
					TextSize = 14,
					Size = UDim2New(1, -16, 1, 0),
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					ClearTextOnFocus = false,
					Text = "",
					ZIndex = 2,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					CursorPosition = -1,
					Position = UDim2New(0, 8, 0, 0),
					BorderSizePixel = 0
				}):AddToTheme({TextColor3 = 'Text'})                
			end

			local AnimDropdown = {
				Value = {},
				Multi = true,
				Callback = function() end,
				Flag = Colorpicker.Flag .. "Animation_",
				Options = { },
				MaxSize = 280,
			}

			Items["AnimationsDropdown"] = Instances:Create("Frame", {
				Parent = Items["ColorpickerWindow"].Instance,
				Name = "\0",
				BorderColor3 = FromRGB(0, 0, 0),
				AnchorPoint = Vector2New(0, 1),
				BackgroundTransparency = 1,
				Position = UDim2New(0, 8, 1, -38),
				Size = UDim2New(1, -16, 0, 25),
				ZIndex = 2,
				BorderSizePixel = 0
			})

			Items["Text"] = Instances:Create("TextLabel", {
				Parent = Items["AnimationsDropdown"].Instance,
				Name = "\0",
				FontFace = Library.Font,
				TextColor3 = Library.Theme["Text"],
				BorderColor3 = FromRGB(0, 0, 0),
				Text = "Animations",
				AutomaticSize = Enum.AutomaticSize.X,
				AnchorPoint = Vector2New(0, 0.5),
				Size = UDim2New(0, 0, 0, 15),
				BackgroundTransparency = 1,
				Position = UDim2New(0, 0, 0.5, 0),
				BorderSizePixel = 0,
				ZIndex = 2,
				TextSize = 14
			}):AddToTheme({TextColor3 = 'Text'})

			Items["RealDropdown"] = Instances:Create("TextButton", {
				Parent = Items["AnimationsDropdown"].Instance,
				AutoButtonColor = false,
				Text = "",
				Name = "\0",
				BorderColor3 = FromRGB(0, 0, 0),
				AnchorPoint = Vector2New(1, 0),
				Position = UDim2New(1, 0, 0, 0),
				Size = UDim2New(0, 125, 0, 25),
				ZIndex = 2,
				BorderSizePixel = 0,
				BackgroundColor3 = Library.Theme["Element"]
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
				FontFace = Library.Font,
				TextColor3 = Library.Theme["Text"],
				BorderColor3 = FromRGB(0, 0, 0),
				Text = "None",
				TextTruncate = Enum.TextTruncate.None,
				Size = UDim2New(1, -25, 0, 15),
				AnchorPoint = Vector2New(0, 0.5),
				Position = UDim2New(0, 8, 0.5, 0),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				ZIndex = 2,
				TextSize = 14
			}):AddToTheme({TextColor3 = 'Text'})

			Instances:Create("UIGradient", {
				Parent = Items["Value"].Instance,
				Name = "\0",
				Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.676, 0), NumSequenceKeypoint(1, 1)}
			})

			Items["Icon"] = Instances:Create("ImageLabel", {
				Parent = Items["RealDropdown"].Instance,
				Name = "\0",
				ImageColor3 = Library.Theme["Accent"],
				ScaleType = Enum.ScaleType.Fit,
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 25, 0, 25),
				AnchorPoint = Vector2New(1, 0.5),
				Image = "rbxassetid://96215562143920",
				BackgroundTransparency = 1,
				Position = UDim2New(1, -1, 0.5, 0),
				ZIndex = 2,
				BorderSizePixel = 0
			}):AddToTheme({ImageColor3 = 'Accent'})    

			Items["OptionHolder"] = Instances:Create("TextButton", {
				Parent = Library.UnusedHolder.Instance,
				Name = "\0",
				Visible = false,
				ClipsDescendants = true,
				BorderColor3 = FromRGB(0, 0, 0),
				Text = "",
				AutoButtonColor = false,
				AnchorPoint = Vector2New(0, 0),
				SelectionGroup = true,
				Position = UDim2New(0, 0, 0, 5),
				Size = UDim2New(0, 155, 0, 125),
				ZIndex = 5,
				BorderSizePixel = 0,
				BackgroundColor3 = Library.Theme["Background"]
			}):AddToTheme({BackgroundColor3 = 'Background'})

			Instances:Create("UICorner", {
				Parent = Items["OptionHolder"].Instance,
				Name = "\0",
				CornerRadius = UDimNew(0, 5)
			})

			Instances:Create("UIPadding", {
				Parent = Items["OptionHolder"].Instance,
				Name = "\0",
				PaddingTop = UDimNew(0, 5),
				PaddingBottom = UDimNew(0, 8),
				PaddingRight = UDimNew(0, 5),
				PaddingLeft = UDimNew(0, 5)
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

			local function updateOptionHolderPosition()
				if not Library or not Items["OptionHolder"].Instance.Parent then return end
				local S = Library.UIScaleNum or 1
				local btn = Items["RealDropdown"].Instance
				local mf = Colorpicker.Window.Items["MainFrame"].Instance
				local mf_x, mf_y = mf.AbsolutePosition.X, mf.AbsolutePosition.Y
				local mf_right = mf_x + mf.AbsoluteSize.X - 8
				local mf_bottom = mf_y + mf.AbsoluteSize.Y - 8

				local left = math.max(btn.AbsolutePosition.X, mf_x + 8)
				local out_w = math.min(btn.AbsolutePosition.X + btn.AbsoluteSize.X, mf_right) - left
				local drop_h = AnimDropdown.MaxSize
				local space_below = mf_bottom - (btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 5)

				if space_below >= drop_h then
					local top = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 5

					Items["OptionHolder"].Instance.Position = UDim2New(0, left / S, 0, top / S)
					Items["OptionHolder"].Instance.Size = UDim2New(0, out_w / S, 0, (math.min(top + drop_h, mf_bottom) - top) / S)
				else
					local list_bottom = btn.AbsolutePosition.Y - 5
					local top = math.max(list_bottom - drop_h, mf_y + 8)

					Items["OptionHolder"].Instance.Position = UDim2New(0, left / S, 0, top / S)
					Items["OptionHolder"].Instance.Size = UDim2New(0, out_w / S, 0, (list_bottom - top) / S)
				end
			end

			function AnimDropdown:SetOpen(Bool)
				if Debounce then 
					return
				end

				AnimDropdown.IsOpen = Bool

				Debounce = true 

				if AnimDropdown.IsOpen then 
					Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
					updateOptionHolderPosition()
					Items["OptionHolder"].Instance.Visible = true

					RenderStepped = RunService.RenderStepped:Connect(function()
						if not Library then return end
						updateOptionHolderPosition()
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
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 0, 25),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = OptionButton.Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				local OptionText = Instances:Create("TextLabel", {
					Parent = OptionButton.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					TextTransparency = 0.4000000059604645,
					Text = Option,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, -15, 1, 0),
					Position = UDim2New(0, 4, 0, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					ZIndex = 5,
					TextSize = 14
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
					Items["ColorpickerWindow"].Instance.Visible = true
					Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance

					RenderStepped = RunService.RenderStepped:Connect(function()
						local btn = Items["ColorpickerButton"].Instance
						Items["ColorpickerWindow"].Instance.Position = UDim2New(
							0, btn.AbsolutePosition.X,
							0, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 5
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

					AnimDropdown:SetOpen(false)

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

				local Red, Green, Blue = MathFloor(Colorpicker.Color.R * 255), MathFloor(Colorpicker.Color.G * 255), MathFloor(Colorpicker.Color.B * 255)
				Items["Input"].Instance.Text = Red .. ", " .. Green .. ", " .. Blue

				Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
				Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

				if not IsFromAlpha then 
					Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
				end

				if Data.Callback then 
					Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
				end

				Library:SaveAutoloadIfEnabled()
			end

			local SlidingPalette = false
			local PaletteChanged

			function Colorpicker:SlidePalette(Input)
				if not Input or not SlidingPalette then
					return
				end

				local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
				local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

				Colorpicker.Saturation = ValueX
				Colorpicker.Value = ValueY

				local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.98)
				local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.98)

				Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
				Colorpicker:Update()
			end

			local SlidingHue = false
			local HueChanged

			function Colorpicker:SlideHue(Input)
				if not Input or not SlidingHue then
					return
				end

				local ValueX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)

				Colorpicker.Hue = ValueX

				local SlideX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.985)

				Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0.5, 0)})
				Colorpicker:Update()
			end

			local SlidingAlpha = false 
			local AlphaChanged

			function Colorpicker:SlideAlpha(Input)
				if not Input or not SlidingAlpha then
					return
				end

				local ValueY = MathClamp((Input.Position.Y - Items["Alpha"].Instance.AbsolutePosition.Y) / Items["Alpha"].Instance.AbsoluteSize.Y, 0, 1)

				Colorpicker.Alpha = ValueY

				local SlideY = MathClamp((Input.Position.Y - Items["Alpha"].Instance.AbsolutePosition.Y) / Items["Alpha"].Instance.AbsoluteSize.Y, 0, 0.98)

				Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0.5, 0, SlideY, 0)})
				Colorpicker:Update(true)
			end

			function Colorpicker:Set(Color, Alpha)
				if type(Color) == "table" then
					Color = FromRGB(Color[1], Color[2], Color[3])
				elseif type(Color) == "string" then
					Color = FromHex(Color)
				else
					Color = Color
				end 

				Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
				Colorpicker.Alpha = Alpha or 0  

				local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.985)
				local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.985)

				local AlphaPositionY = MathClamp(Colorpicker.Alpha, 0, 0.99)

				local HuePositionX = MathClamp(Colorpicker.Hue, 0, 0.98)

				Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
				Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(HuePositionX, 0, 0.5, 0)})
				Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0.5, 0, AlphaPositionY, 0)})
				Colorpicker:Update()
			end

			local OldAlpha = Colorpicker.Alpha
			local OldColor

			AnimDropdown.Callback = function(Value)
				if TableFind(Value, "Rainbow") then 
					OldColor = Colorpicker.Color

					Library:Thread(LPH_NO_VIRTUALIZE(function()
						while wait() do 
							local RainbowHue = MathAbs(MathSin(tick() * 0.32))
							local Color = FromHSV(RainbowHue, 1, 1)

							Colorpicker:Set(Color, Colorpicker.Alpha)

							if not TableFind(Value, "Rainbow") then
								Colorpicker:Set(OldColor, Colorpicker.Alpha)
								break
							end
						end
					end))
				end

				if TableFind(Value, "Breathing") then 
					Library:Thread(LPH_NO_VIRTUALIZE(function()
						OldAlpha = Colorpicker.Alpha
						while wait() do 
							local AlphaValue = MathAbs(MathSin(tick() * 0.8))

							Colorpicker:Set(Colorpicker.Color, AlphaValue)

							if not TableFind(Value, "Breathing") then
								Colorpicker:Set(Colorpicker.Color, OldAlpha)
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
				local RGBText  = Items["Input"].Instance.Text
				local R, G, B = RGBText:match("(%d+),%s*(%d+),%s*(%d+)")
				R, G, B = tonumber(R), tonumber(G), tonumber(B)
				Colorpicker:Set(FromRGB(R, G, B), Colorpicker.Alpha)
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
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
				Colorpicker:Set(Value, Alpha)
			end

			Library.SetFlags[AnimDropdown.Flag] = function(Value)
				if type(Value) == "string" then
					Value = { Value }
				end
				if type(Value) ~= "table" then
					Value = { }
				end
				AnimDropdown.Value = Value
				Library.Flags[AnimDropdown.Flag] = AnimDropdown.Value
				local TextFormat = #AnimDropdown.Value > 0 and TableConcat(AnimDropdown.Value, ", ") or "..."
				Items["Value"].Instance.Text = TextFormat
				for OptName, OptionData in AnimDropdown.Options do
					local selected = TableFind(AnimDropdown.Value, OptName)
					OptionData.Selected = selected ~= nil
					OptionData:Toggle(selected and "Active" or "Inactive")
				end
				if AnimDropdown.Callback then
					Library:SafeCall(AnimDropdown.Callback, AnimDropdown.Value)
				end
			end

			function Colorpicker:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
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

			local Items = { } do 
				Items["KeyButton"] = Instances:Create("TextButton", {
					Parent = Data.Parent.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "RightShift",
					Size = UDim2New(0, 0, 0, 20),
					AutoButtonColor = false,
					AnchorPoint = Vector2New(1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					Position = UDim2New(1, 0, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = Library.Theme["Background"]
				}):AddToTheme({BackgroundColor3 = 'Background'})

				Instances:Create("UIPadding", {
					Parent = Items["KeyButton"].Instance,
					Name = "\0",
					PaddingRight = UDimNew(0, 5),
					PaddingLeft = UDimNew(0, 5)
				})

				Instances:Create("UICorner", {
					Parent = Items["KeyButton"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})                

				Items["KeybindWindow"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					Position = UDim2New(0.005164622329175472, 0, 0.34007585048675537, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 90, 0, 90),
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Background"]
				}):AddToTheme({BackgroundColor3 = 'Background'})

				Instances:Create("UICorner", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Shadow"] = Instances:Create("ImageLabel", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					ImageColor3 = FromRGB(0, 0, 0),
					ImageTransparency = 0.5600000023841858,
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://112971167999062",
					ZIndex = -1,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
					ScaleType = Enum.ScaleType.Slice,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					SliceScale = 0.6000000238418579,
					Size = UDim2New(1, 55, 1, 55)
				}):AddToTheme({ImageColor3 = 'Shadow'})

				Items["Toggle"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Position = UDim2New(0, 8, 0, 8),
					Size = UDim2New(1, -16, 0, 25),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["ToggleText"] = Instances:Create("TextLabel", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Toggle",
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 0),
					Size = UDim2New(1, -15, 1, 0),
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Items["Hold"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 33),
					Size = UDim2New(1, -16, 0, 25),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = Items["Hold"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["HoldText"] = Instances:Create("TextLabel", {
					Parent = Items["Hold"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					TextTransparency = 0.4000000059604645,
					Text = "Hold",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, -15, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 4, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Items["Always"] = Instances:Create("TextButton", {
					Parent = Items["KeybindWindow"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 58),
					Size = UDim2New(1, -16, 0, 25),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = Items["Always"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["AlwaysText"] = Instances:Create("TextLabel", {
					Parent = Items["Always"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					TextTransparency = 0.4000000059604645,
					Text = "Always",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, -15, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 4, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
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
					Items["KeybindWindow"].Instance.Visible = true
					Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance

					RenderStepped = RunService.RenderStepped:Connect(function()
						local btn = Items["KeyButton"].Instance
						Items["KeybindWindow"].Instance.Position = UDim2New(
							0, btn.AbsolutePosition.X,
							0, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 5
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

			Library:Connect(UserInputService.InputBegan, function(Input, GPE)
				if Keybind.Value == "None" then
					return
				end

				if not GPE then
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

			Library:Connect(UserInputService.InputEnded, function(Input, GPE)
				if GPE then
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
				Keybind:Set(Value)
			end

			function Keybind:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				return Keybind
			end

			return Keybind, Items 
		end


		Library.Watermark = function(self, Name)
			local Watermark = { }

			local Items = { } do
				Items["Watermark"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0.5, 0),
					Position = UDim2New(0.5, 0, 0, 15),
					Size = UDim2New(0, 100, 0, 35),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = FromRGB(16, 18, 21)
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
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AnchorPoint = Vector2New(0, 0.5),
					Position = UDim2New(0, 0, 0.5, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Instances:Create("UIPadding", {
					Parent = Items["Watermark"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 8),
					PaddingBottom = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 10),
					PaddingLeft = UDimNew(0, 10)
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

			local KeybindList = { }
			Library.KeyList = KeybindList

			local Items = { } do 
				Items["KeybindList"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					BackgroundTransparency = 0.30000001192092896,
					Position = UDim2New(0.005164622329175472, 0, 0.4690265357494354, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.None,
					BackgroundColor3 = Library.Theme["Background"]
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
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "Keybinds",
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Instances:Create("UIPadding", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 8),
					PaddingBottom = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 8)
				})

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["KeybindList"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 20),
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

			local VisibleItems = { }

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
				wait()
				Items["KeybindList"].Instance.AnchorPoint = Vector2New(0, 0)

				Items["KeybindList"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
			end

			function KeybindList:Resize()
				local y_size = 0
				local x_size = 0

				table.clear(VisibleItems)

				for Index, Value in Items["Content"].Instance:GetChildren() do 
					if Value.ClassName:find("UI") then continue end
					if not Value.Visible then continue end

					y_size = y_size + Value.AbsoluteSize.Y + 5
					x_size = math.max(x_size, Value.AbsoluteSize.X)

					table.insert(VisibleItems, Value)
				end

				if #VisibleItems == 0 then 
					x_size = Items["Text"].Instance.TextBounds.X + 14
					y_size = 32

					Items["KeybindList"]:Tween(nil, {Size = UDim2New(0, x_size, 0, y_size)})
					return 
				end

				Items["KeybindList"]:Tween(nil, {Size = UDim2New(0, x_size + 30, 0, y_size + 30)})
			end

			function KeybindList:Add(Key, Name, Mode)
				local NewKey = Instances:Create("TextLabel", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme['Text'],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = ""..Key.." - ".. Name .. " (".. Mode .. ")",
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 20),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255)
				})  NewKey:AddToTheme({TextColor3 = "Text"})

				Instances:Create("UIPadding", {
					Parent = NewKey.Instance,
					Name = "\0",
					PaddingRight = UDimNew(0, 0),
					PaddingLeft = UDimNew(0, 0)
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
			wait(0)
			Library.NotifLayoutOrder = (Library.NotifLayoutOrder or 0) + 1
			local notiOrder = Library.NotifLayoutOrder
			local Items = { } do
				Items["Notification"] = Instances:Create("Frame", {
					Parent = Library.NotifHolder.Instance,
					Name = "\0",
					LayoutOrder = notiOrder,
					BackgroundTransparency = 0.30000001192092896,
					BorderColor3 = FromRGB(0, 0, 0),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.None,
					BackgroundColor3 = Library.Theme["Background"]
				}):AddToTheme({BackgroundColor3 = 'Background'})

				Instances:Create("UICorner", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Instances:Create("UIPadding", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 5),
					PaddingBottom = UDimNew(0, 5),
					PaddingRight = UDimNew(0, 6),
					PaddingLeft = UDimNew(0, 6)
				})

				Items["Title"] = Instances:Create("TextLabel", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Data.Title or Data.Name,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Items["Description"] = Instances:Create("TextLabel", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextWrapped = true,
					TextColor3 = Library.Theme["Text"],
					TextTransparency = 0.4000000059604645,
					Text = Data.Description,
					Size = UDim2New(0, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 20),
					BorderSizePixel = 0,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Items["Duration"] = Instances:Create("Frame", {
					Parent = Items["Notification"].Instance,
					Name = "\0",
					Position = UDim2New(0, 0, 0, 40),
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 0, 3),
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = Items["Duration"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Accent"] = Instances:Create("Frame", {
					Parent = Items["Duration"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Data.Color
				})

				Instances:Create("UICorner", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})                
			end

			wait()
			local TextService = cloneref(game:GetService("TextService"))
			local desc_text = Data.Description or ""
			local font = Library.Font
			if not pcall(function() return font end) then font = Enum.Font.SourceSans end

			local function getTextSize(text, width)
				local ok, sz = pcall(function()
					return TextService:GetTextSize(text, 14, font, Vector2.new(width, 10000))
				end)
				if not ok or not sz then
					sz = TextService:GetTextSize(text, 14, Enum.Font.SourceSans, Vector2.new(width, 10000))
				end
				return sz
			end

			local unwrapped_w = math.ceil(getTextSize(desc_text, 10000).X)
			local content_w = math.min(unwrapped_w, 300)
			local desc_h = math.max(math.ceil(getTextSize(desc_text, content_w).Y), 14)
			local title_w = math.ceil(Items["Title"].Instance.TextBounds.X)
			local final_w = math.min(math.max(title_w, content_w), 300)

			local y_size = 5 + 20 + desc_h + 4 + 3 + 5

			Items["Description"].Instance.Size = UDim2New(0, final_w, 0, 0)
			Items["Duration"].Instance.Position = UDim2New(0, 0, 0, 5 + 20 + desc_h + 4)
			Items["Notification"].Instance.Size = UDim2New(0, 0, 0, y_size)

			for Index, Value in Items do 
				if Value.Instance:IsA("Frame") then
					Value.Instance.BackgroundTransparency = 1
				elseif Value.Instance:IsA("TextLabel") then 
					Value.Instance.TextTransparency = 1
				end
			end 

			local Info = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0)

			Library:Thread(function()
				for Index, Value in Items do 
					if Value.Instance:IsA("Frame") then
						Value:Tween(Info, {BackgroundTransparency = 0})
					elseif Value.Instance:IsA("TextLabel") and Index ~= "Description" then 
						Value:Tween(Info, {TextTransparency = 0})
					elseif Value.Instance:IsA("TextLabel") and Index == "Description" then 
						Value:Tween(Info, {TextTransparency = 0.4})
					end
				end

				Items["Notification"]:Tween(Info, {Size = UDim2New(0, final_w, 0, y_size)})
				Items["Accent"]:Tween(TweenInfo.new(Data.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2New(0, 0, 1, 0)})

				delay(Data.Duration + 0.1, function()
					for Index, Value in Items do 
						if Value.Instance:IsA("Frame") then
							Value:Tween(nil, {BackgroundTransparency = 1})
						elseif Value.Instance:IsA("TextLabel") then 
							Value:Tween(nil, {TextTransparency = 1})
						end
					end

					Items["Notification"]:Tween(Info, {Size = UDim2New(0, 0, 0, y_size)})
					wait(0.5)
					Items["Notification"]:Clean()
				end)
			end)
		end


		Library.Window = function(self, Data)
			Data = Data or { }

			local Window = {
				Name = Data.Name or Data.name or "Window",

				Pages = { },
				Items = { },
				IsOpen = false
			}

			local Items = { } do
				Items["MainFrame"] = Instances:Create("Frame", {
					Parent = Library.Holder.Instance,
					Name = "\0",
					BorderColor3 = Library.Theme["Shadow"],
					AnchorPoint = Vector2New(0.5, 0.5),
					BackgroundTransparency = 0.30000001192092896,
					Position = UDim2New(0.5, 0, 0.5, 0),
					Size = UDim2New(0, 770, 0, 526),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Background"]
				}):AddToTheme({BackgroundColor3 = 'Background'})

				if IsMobile then
					Library:SetScaleFromScreenPercent(2.3 / 3)
				else
					Library.UIScaleObject.Instance.Scale = 1
					Library.UIScaleNum = 1
				end

				do
					local Vps = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2New(1920, 1080)
					local Scale = Library.UIScaleNum or 1
					Items["MainFrame"].Instance.Position = UDim2New(0, Vps.X / (2 * Scale), 0, Vps.Y / (2 * Scale))
				end

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
					ImageColor3 = Library.Theme["Shadow"],
					ImageTransparency = 0.5600000023841858,
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://112971167999062",
					ZIndex = -1,
					BorderSizePixel = 0,
					SliceCenter = RectNew(Vector2New(112, 112), Vector2New(147, 147)),
					ScaleType = Enum.ScaleType.Slice,
					BorderColor3 = Library.Theme["Shadow"],
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					SliceScale = 0.6000000238418579,
					Size = UDim2New(1, 55, 1, 55)
				}):AddToTheme({ImageColor3 = 'Shadow'})

				Items["Title"] = Instances:Create("TextLabel", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = Library.Theme["Shadow"],
					Text = Window.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 9, 0, 8),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})  

				Items["Pages"] = Instances:Create("ScrollingFrame", {
					Parent = Items["MainFrame"].Instance,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarImageColor3 = Library.Theme["Accent"],
					ScrollBarThickness = 3,
					CanvasSize = UDim2New(0, 0, 0, 0),
					BottomImage = "rbxassetid://136419474381965",
					TopImage = "rbxassetid://136419474381965",
					MidImage = "rbxassetid://136419474381965",
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 30),
					Size = UDim2New(0, 150, 1, -30),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255)
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
					PaddingRight = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 8)
				})

				Items["CloseButton"] = Instances:Create("ImageButton", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					ScaleType = Enum.ScaleType.Fit,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 17, 0, 17),
					AutoButtonColor = false,
					AnchorPoint = Vector2New(1, 0),
					Image = "rbxassetid://76001605964586",
					BackgroundTransparency = 1,
					Position = UDim2New(1, -8, 0, 8),
					ZIndex = 2,
					BorderSizePixel = 0
				})                

				Items["MinimizeButton"] = Instances:Create("ImageButton", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 17, 0, 17),
					AutoButtonColor = false,
					AnchorPoint = Vector2New(1, 0),
					Image = "rbxassetid://94817928404736",
					BackgroundTransparency = 1,
					Position = UDim2New(1, -27, 0, 3),
					ZIndex = 2,
					BorderSizePixel = 0
				})                

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 163, 0, 30),
					Size = UDim2New(1, -171, 1, -38),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Items["Search"] = Instances:Create("Frame", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					Size = UDim2New(1, 0, 0, 35),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = Items["Search"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Icon"] = Instances:Create("ImageLabel", {
					Parent = Items["Search"].Instance,
					Name = "\0",
					ScaleType = Enum.ScaleType.Fit,
					ImageTransparency = 0.4000000059604645,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 20, 0, 20),
					AnchorPoint = Vector2New(0, 0.5),
					Image = "rbxassetid://71924825350727",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0.5, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Items["Input"] = Instances:Create("TextBox", {
					Parent = Items["Search"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					AnchorPoint = Vector2New(0, 0.5),
					PlaceholderColor3 = Library.Theme["Inactive Text"],
					PlaceholderText = "Search..",
					TextSize = 14,
					Size = UDim2New(1, -43, 0, 15),
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 2,
					Position = UDim2New(0, 35, 0.5, 0),
					BorderSizePixel = 0
				}):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})    

				Instances:Create("Frame", {
					Parent = Items["MainFrame"].Instance,
					Name = "\0",
					Size = UDim2New(0, 1, 1, 0),
					Position = UDim2New(0, 152, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Border"]
				}):AddToTheme({BackgroundColor3 = 'Border'})   

				if not IsMobile then
					Items["Cursor"] = Instances:Create("Frame", {
						Parent = Library.Holder.Instance,
						Name = "\0",
						BackgroundTransparency = 1,
						Position = UDim2New(0, 0, 0, 0),
						BorderColor3 = FromRGB(0, 0, 0),
						Size = UDim2New(0, 16, 0, 16),
						BorderSizePixel = 0,
						BackgroundColor3 = FromRGB(0, 0, 0)
					})

					Items["Image"] = Instances:Create("ImageLabel", {
						Parent = Items["Cursor"].Instance,
						Name = "\0",
						ImageColor3 = FromRGB(232, 186, 248),
						BorderColor3 = FromRGB(0, 0, 0),
						Image = "rbxassetid://132511743665753",
						BackgroundTransparency = 1,
						Size = UDim2New(0, 16, 0, 16),
						BorderSizePixel = 0,
						ZIndex = 10001,
						Rotation = -90,
						BackgroundColor3 = FromRGB(232, 186, 248)
					})  Items["Image"]:AddToTheme({ImageColor3 = "Accent"})
				end

				if IsMobile then 
					Items["FloatingButton"] = Instances:Create("TextButton", {
						Parent = Library.OtherHolder.Instance,
						Text = "",
						AutoButtonColor = false,
						Name = "\0",
						Position = UDim2New(0, 125, 0, 125),
						BorderColor3 = FromRGB(0, 0, 0),
						Size = UDim2New(0, 50, 0, 50),
						BorderSizePixel = 0,
						ZIndex = 127,
						BackgroundColor3 = Library.Theme['Background']
					}):AddToTheme({BackgroundColor3 = 'Background'})

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

					Items["OpenTitle"] = Instances:Create("TextLabel", {
						Parent = Items["FloatingButton"].Instance,
						BorderColor3 = FromRGB(0, 0, 0),
						Name = "\0",
						Text = "Close",
						FontFace = Library.Font,
						TextColor3 = Library.Theme['Text'],
						TextSize = 14,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2New(0.5, 0.5),
						Position = UDim2New(0.5, 0, 0.5, 0),
						ZIndex = 127,
						Size = UDim2New(1, -10, 1, -10),
						BorderSizePixel = 0,
						BackgroundColor3 = FromRGB(255, 255, 255)
					}):AddToTheme({TextColor3 = 'Text'})

					Instances:Create("UICorner", {
						Parent = Items["FloatingButton"].Instance,
						CornerRadius = UDimNew(1, 0)
					}) 

					Items["FloatingButton"]:Connect("MouseButton1Down", function(Input)
						Window:SetOpen(not Window.IsOpen)

						if Items["Image"] then
							Items["Image"].Instance.Visible = Window.IsOpen
						end
						UserInputService.MouseIconEnabled = not Window.IsOpen

						Items["OpenTitle"].Instance.Text = Window.IsOpen and "Close" or "Open"
					end)
				end

				if not IsMobile then
					Library:Connect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
						if not Library.CustomCursor then 
							UserInputService.MouseIconEnabled = true
							Items["Cursor"].Instance.Visible = false
							return 
						end

						if Window.IsOpen then
							UserInputService.MouseIconEnabled = false
							Items["Cursor"].Instance.Visible = true
							local MouseLocation = UserInputService:GetMouseLocation()
							local Scale = Library.UIScaleNum or 1
							Items["Cursor"].Instance.Position = UDim2New(0, (MouseLocation.X - 1) / Scale, 0, (MouseLocation.Y - 56) / Scale)           
						end
					end))
				end

				Window.Items = Items
			end

			local IsMinimized = false
			local ExpandCount = 0
			local ContentUnlocked = not (Data.Minimized or Data.minimized)
			local OldSize = Items["MainFrame"].Instance.AbsoluteSize

			function Window:Minimize(Bool)
				for Index, Value in Library.OpenFrames do 
					Value:SetOpen(false)
				end

				IsMinimized = Bool

				if IsMinimized then 
					Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, OldSize.X, 0, 35)})
					Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, 285, 0, 35)})

					Items["Pages"].Instance.Visible = false
					Items["Content"].Instance.Visible = false
				else
					ContentUnlocked = true
					Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, OldSize.X, 0, OldSize.Y)})

					Items["Pages"].Instance.Visible = true
					Items["Content"].Instance.Visible = true
				end
			end

			function Window:ChangeSize(XSize, YSize)
				Items["MainFrame"]:Tween(nil, {Size = UDim2New(0, XSize, 0, YSize)})
			end

			local Debounce = false

			function Window:SetCenter()
				local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
				wait()
				Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)
				local Scale = Library.UIScaleNum or 1
				Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X / Scale, 0, CenterPosition.Y / Scale)
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

				NewTween.Tween.Completed:Connect(function()
					Debounce = false 
					Items["MainFrame"].Instance.Visible = Window.IsOpen
					if Items["Cursor"] then
						Items["Cursor"].Instance.Visible = Window.IsOpen
					end
					UserInputService.MouseIconEnabled = not Window.IsOpen
				end)
			end

			function Window:Init()
				Library:Connect(Players.PlayerRemoving, function(Player)
					if Player == LocalPlayer and Library.AutoSave then
						pcall(function()
							writefile(Library.Folders_Path.Directory .. "/autoload.json", Library:GetConfig())
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
				Window:Minimize(not IsMinimized)
			end)

			Items["CloseButton"]:Connect("MouseButton1Down", function()
				Library:Unload()
				UserInputService.MouseIconEnabled = true
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
								for _, sec in ipairs(Library.AllSections) do
									if sec.Items and sec.Items["Section"] and sec.Items["Section"].Instance == SectionFrame then
										IsSection = true
										if sec.Collapsed then
											sec:SetCollapsed(false)
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
				IsMinimized = true
				Items["MainFrame"].Instance.Size = UDim2New(0, 285, 0, 35)
				Items["Pages"].Instance.Visible = false
				Items["Content"].Instance.Visible = false
			end
			Window:SetOpen(true)
			return setmetatable(Window, Library)
		end

		Library.Page = function(self, Data)
			Data = Data or { }

			local Page = {
				Window = self,

				Name = Data.Name or Data.name or "Page",
				Columns = Data.Columns or Data.columns or 2,
				IsKeyPage = Data.IsKeyPage or Data.iskeypage or false,

				Items = { },
				ColumnsData = { },
				Active = false
			}

			local Items = { } do
				Items["Inactive"] = Instances:Create("TextButton", {
					Parent = Page.Window.Items["Pages"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 35),
					ClipsDescendants = true,
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Liner"] = Instances:Create("Frame", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2New(0, -3, 0.5, 0),
					Size = UDim2New(0, 6, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 174, 254)
				}):AddToTheme({BackgroundColor3 = 'Accent'})

				Instances:Create("UICorner", {
					Parent = Items["Liner"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0)
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Inactive"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					TextTransparency = 0.4000000059604645,
					Text = Page.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0, 0.5),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 4, 0.5, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})           

				Items["Page"] = Instances:Create("Frame", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 1, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255)
				})

				if not Page.IsKeyPage then
					Items["Columns"] = Instances:Create("Frame", {
						Parent = Items["Page"].Instance,
						Name = "\0",
						BorderColor3 = FromRGB(0, 0, 0),
						BackgroundTransparency = 1,
						Position = UDim2New(0, 0, 0, 43),
						Size = UDim2New(1, 0, 1, -43),
						ZIndex = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = FromRGB(255, 255, 255)
					})

					Instances:Create("UIListLayout", {
						Parent = Items["Columns"].Instance,
						Name = "\0",
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalFlex = Enum.UIFlexAlignment.Fill,
						Padding = UDimNew(0, 8),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalFlex = Enum.UIFlexAlignment.Fill
					})

					for Index = 1, Page.Columns do 
						local NewColumn = Instances:Create("ScrollingFrame", {
							Parent = Items["Columns"].Instance,
							Name = "\0",
							ScrollBarImageColor3 = FromRGB(0, 0, 0),
							Active = true,
							AutomaticCanvasSize = Enum.AutomaticSize.Y,
							ScrollBarThickness = 4,
							BorderColor3 = FromRGB(0, 0, 0),
							BackgroundTransparency = 1,
							Size = UDim2New(0, 100, 0, 100),
							BackgroundColor3 = FromRGB(255, 255, 255),
							ZIndex = 2,
							BorderSizePixel = 0,
							CanvasSize = UDim2New(0, 0, 0, 0),
							MidImage = "rbxassetid://128693616966482",
							TopImage = "rbxassetid://128693616966482",
							BottomImage = "rbxassetid://128693616966482",
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
							PaddingBottom = UDimNew(0, 24),
							PaddingRight = UDimNew(0, 12)
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
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDimNew(0, 15)
					})
				end

				Page.Items = Items
			end

			Library.SearchItems[Page] = { }

			local Debounce = false

			function Page:Turn(Bool)
				Page.Active = Bool 
				Items["Page"].Instance.Parent = Page.Active and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

				if Page.Active then
					Items["Page"].Instance.Visible = true

					Items["Liner"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 6, 1, -20)})
					Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0})
					Items["Text"]:Tween(nil, {TextTransparency = 0, Position = UDim2New(0, 12, 0.5, 0)})

					Library.CurrentPage = Page
				else
					Items["Liner"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 6, 0, 0)})
					Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
					Items["Text"]:Tween(nil, {TextTransparency = 0.4, Position = UDim2New(0, 4, 0.5, 0)})
					Items["Page"].Instance.Visible = false
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
			Data = Data or { }

			local Section = {
				Window = self.Window,
				Page = self,

				Name = Data.Name or Data.name or "Section",
				Side = Data.Side or Data.side or 1,
				DefaultCollapsed = Data.DefaultCollapsed or Data.defaultcollapsed or true,

				Items = { },
				Collapsed = true,
			}

			local Items = { } do
				Items["Section"] = Instances:Create("Frame", {
					Parent = Section.Page.ColumnsData[Section.Side].Instance,
					Name = "\0",
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 0, 28),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Library.Theme["Inline"]
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
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Section.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 7),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Items["Indicator"] = Instances:Create("TextLabel", {
					Parent = Items["Header"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "▼",
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(1, -19, 0, 7),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 10
				}):AddToTheme({TextColor3 = 'Text'})

				Items["Line"] = Instances:Create("Frame", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					Size = UDim2New(1, -16, 0, 1),
					Position = UDim2New(0, 8, 0, 28),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Border"]
				}):AddToTheme({BackgroundColor3 = 'Border'})

				Items["ContentHolder"] = Instances:Create("Frame", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					ClipsDescendants = true,
					BorderSizePixel = 0,
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 32),
					Size = UDim2New(1, -16, 0, 0),
					ZIndex = 2
				})

				Items["Content"] = Instances:Create("Frame", {
					Parent = Items["ContentHolder"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 0),
					Size = UDim2New(1, 0, 0, 0),
					ZIndex = 2,
					AutomaticSize = Enum.AutomaticSize.Y
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Content"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				Instances:Create("UIPadding", {
					Parent = Items["Section"].Instance,
					Name = "\0",
					PaddingBottom = UDimNew(0, 8)
				})

				Items["Header"]:Connect("MouseButton1Down", function()
					Section:SetCollapsed(not Section.Collapsed)
				end)

				Section.Items = Items
			end

			function Section:SetCollapsed(Bool)
				if Section.Collapsed == Bool then
					return
				end
				Section.Collapsed = Bool
				Items["Line"].Instance.Visible = not Section.Collapsed
				Items["Indicator"].Instance.Text = Section.Collapsed and "▶" or "▼"

				if Section.Collapsed then
					Items["Content"].Instance.Visible = false
					Items["ContentHolder"]:Tween(TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2New(1, -16, 0, 0)
					})
				else
					Items["Content"].Instance.Visible = true
					defer(function()
						local ContentHeight = Items["Content"].Instance.AbsoluteSize.Y
						Items["ContentHolder"].Instance.Size = UDim2New(1, -16, 0, 0)
						Items["ContentHolder"]:Tween(TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2New(1, -16, 0, ContentHeight)
						})
					end)
				end
			end

			Items["ContentHolder"].Instance.Size = UDim2New(1, -16, 0, 0)
			Items["Content"].Instance.Visible = false
			Items["Line"].Instance.Visible = false
			Section.Collapsed = true
			Section:SetCollapsed(Section.DefaultCollapsed)
			Items["Indicator"].Instance.Text = Section.Collapsed and "▶" or "▼"

			TableInsert(Library.AllSections, Section)

			return setmetatable(Section, Library.Sections)
		end

		Library.Sections.Toggle = function(self, Data)
			Data = Data or { }

			local Toggle = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Toggle",
				Description = Data.Description or Data.Description or nil,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or false,
				Tooltip = Data.Tooltip or Data.tooltip or nil,
				Callback = Data.Callback or Data.callback or function() end,

				Value = false,
				Disabled = false,
			}

			local Items = { } do 
				Items["Toggle"] = Instances:Create("TextButton", {
					Parent = Toggle.Section.Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 0, Toggle.Description ~= nil and Toggle.Description ~= "" and 28 or 20),
					ZIndex = 2,
					TextSize = 14
				})

				Items["Toggle"]:Tooltip(Toggle.Tooltip)

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Toggle"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					TextTransparency = 0.4000000059604645,
					Text = Toggle.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				if Toggle.Description ~= nil and Toggle.Description ~= "" then
					Items["Description"] = Instances:Create("TextLabel", {
						Parent = Items["Toggle"].Instance,
						Name = "\0",
						FontFace = Library.Font,
						TextColor3 = Library.Theme["Text"],
						TextTransparency = 0.5,
						Text = Toggle.Description,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2New(0, 0, 0, 15),
						AnchorPoint = Vector2New(0, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Position = UDim2New(0, 0, 0, 14),
						BorderColor3 = FromRGB(0, 0, 0),
						ZIndex = 2,
						TextSize = 12
					}):AddToTheme({TextColor3 = 'Text'})
				end

				Items["Indicator"] = Instances:Create("TextButton", {
					Parent = Items["Toggle"].Instance,
					Text = "",
					AutoButtonColor = false,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0.5),
					Position = UDim2New(1, 0, 0.5, 0),
					Size = UDim2New(0, 40, 0, 20),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Element"]
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
					BorderColor3 = FromRGB(0, 0, 0),
					BackgroundTransparency = 0.4000000059604645,
					Position = UDim2New(0, 3, 0, 3),
					Size = UDim2New(0, 14, 0, 14),
					ZIndex = 2,
					BorderSizePixel = 0
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
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(1, -48, 0, 0),
					Size = UDim2New(0, 0, 1, 0),
					BorderSizePixel = 0
				})

				Instances:Create("UIListLayout", {
					Parent = Items["SubElements"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDimNew(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder
				})           
			end

			function Toggle:Get()
				return Toggle.Value 
			end

			function Toggle:Set(Value)
				if Toggle.Disabled then 
					return 
				end

				Toggle.Value = Value 
				Library.Flags[Toggle.Flag] = Value 

				if Toggle.Value then 
					Items["Text"]:Tween(nil, {TextTransparency = 0})

					Items["Circle"]:Tween(TweenInfo.new(Library.Tween.Time + 0.2, Enum.EasingStyle.Quart, Library.Tween.Direction), {
						AnchorPoint = Vector2New(1, 0),
						Position = UDim2New(1, -3, 0, 3),
						BackgroundTransparency = 0,
					})

					Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
					Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
				else
					Items["Text"]:Tween(nil, {TextTransparency = 0.4})

					Items["Circle"]:Tween(TweenInfo.new(Library.Tween.Time + 0.2, Enum.EasingStyle.Quart, Library.Tween.Direction), {
						AnchorPoint = Vector2New(0, 0),
						Position = UDim2New(0, 3, 0, 3),
						BackgroundTransparency = 0.4,
					})

					Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
					Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
				end

				if Toggle.Callback then 
					Library:SafeCall(Toggle.Callback, Toggle.Value)
				end

				Library:SaveAutoloadIfEnabled()
			end

			function Toggle:SetDisabled(Bool)
				Toggle.Disabled = Bool

				if Toggle.Disabled then
					Items["Text"]:Tween(nil, {TextTransparency = 0.6})
					Items["Indicator"]:Tween(nil, {BackgroundTransparency = 0.6})
					Items["Circle"]:Tween(nil, {BackgroundTransparency = 0.6})
				else
					if Toggle.Value then
						Items["Text"]:Tween(nil, {TextTransparency = 0})
						Items["Circle"]:Tween(nil, {BackgroundTransparency = 0})
						Items["Indicator"]:Tween(nil, {BackgroundTransparency = 0})
					else
						Items["Text"]:Tween(nil, {TextTransparency = 0.4})
						Items["Circle"]:Tween(nil, {BackgroundTransparency = 0.4})
						Items["Indicator"]:Tween(nil, {BackgroundTransparency = 0})
					end
				end
			end

			function Toggle:SetVisibility(Bool)
				Items["Toggle"].Instance.Visible = Bool 
			end

			function Toggle:Colorpicker(Data)
				Data = Data or { }

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
				Data = Data or { }

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
				Toggle:Set(Value)
			end

			function Toggle:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				return Toggle
			end

			return Toggle 
		end

		Library.Sections.Checkbox = function(self, Data)
			Data = Data or { }

			local Toggle = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Checkbox",
				Description = Data.Description or Data.Description or nil,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or false,
				Tooltip = Data.Tooltip or Data.tooltip or nil,
				Callback = Data.Callback or Data.callback or function() end,

				Value = false,
				Disabled = false,
			}

			local Items = { } do
				Items["Checkbox"] = Instances:Create("TextButton", {
					Parent = Toggle.Section.Items["Content"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 0, Toggle.Description ~= nil and Toggle.Description ~= "" and 28 or 20),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255)
				})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Checkbox"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					TextTransparency = 0.4000000059604645,
					Text = Toggle.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2New(0, 0, 0, 15),
					AnchorPoint = Vector2New(0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					TextSize = 14,
					BackgroundColor3 = FromRGB(255, 255, 255)
				}):AddToTheme({TextColor3 = 'Text'})

				if Toggle.Description ~= nil and Toggle.Description ~= "" then
					Items["Description"] = Instances:Create("TextLabel", {
						Parent = Items["Checkbox"].Instance,
						Name = "\0",
						FontFace = Library.Font,
						TextColor3 = FromRGB(255, 255, 255),
						TextTransparency = 0.5,
						Text = Toggle.Description,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2New(0, 0, 0, 15),
						AnchorPoint = Vector2New(0, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Position = UDim2New(0, 0, 0, 14),
						BorderColor3 = FromRGB(0, 0, 0),
						ZIndex = 2,
						TextSize = 12,
						BackgroundColor3 = FromRGB(255, 255, 255)
					}):AddToTheme({TextColor3 = 'Text'})
				end

				Items["Indicator"] = Instances:Create("Frame", {
					Parent = Items["Checkbox"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0.5),
					Position = UDim2New(1, 0, 0.5, 0),
					Size = UDim2New(0, 20, 0, 20),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(36, 32, 39)
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
					ImageColor3 = FromRGB(0, 0, 0),
					ScaleType = Enum.ScaleType.Fit,
					ImageTransparency = 1,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, -2, 1, -2),
					AnchorPoint = Vector2New(0.5, 0.5),
					Image = "rbxassetid://116339777575852",
					BackgroundTransparency = 1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = FromRGB(255, 255, 255)
				})

				Items["SubElements"] = Instances:Create("Frame", {
					Parent = Items["Checkbox"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					AnchorPoint = Vector2New(1, 0),
					Size = UDim2New(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					Position = UDim2New(1, -24, 0, 0)
				})

				Instances:Create("UIListLayout", {
					Parent = Items["SubElements"].Instance,
					Name = "\0",
					Padding = UDimNew(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal
				})
			end

			function Toggle:Get()
				return Toggle.Value 
			end

			function Toggle:Set(Value)
				if Toggle.Disabled then
					return
				end

				Toggle.Value = Value
				Library.Flags[Toggle.Flag] = Toggle.Value

				if Toggle.Value then
					Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

					Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
					Items["Check"]:Tween(nil, {ImageTransparency = 0})
					Items["Text"]:Tween(nil, {TextTransparency = 0})
				else
					Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})

					Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
					Items["Check"]:Tween(nil, {ImageTransparency = 1})
					Items["Text"]:Tween(nil, {TextTransparency = 0.4})
				end

				if Data.Callback then 
					Library:SafeCall(Data.Callback, Toggle.Value)
				end

			end

			function Toggle:SetDisabled(Bool)
				Toggle.Disabled = Bool

				if Toggle.Disabled then
					Items["Text"]:Tween(nil, {TextTransparency = 0.6})
					Items["Indicator"]:Tween(nil, {BackgroundTransparency = 0.6})
					Items["Check"]:Tween(nil, {ImageTransparency = 1})
				else
					if Toggle.Value then
						Items["Text"]:Tween(nil, {TextTransparency = 0})
						Items["Indicator"]:Tween(nil, {BackgroundTransparency = 0})
						Items["Check"]:Tween(nil, {ImageTransparency = 0})
					else
						Items["Text"]:Tween(nil, {TextTransparency = 0.4})
						Items["Indicator"]:Tween(nil, {BackgroundTransparency = 0})
						Items["Check"]:Tween(nil, {ImageTransparency = 1})
					end
				end
			end

			function Toggle:SetVisibility(Bool)
				Items["Toggle"].Instance.Visible = Bool 
			end

			function Toggle:Colorpicker(Data)
				Data = Data or { }

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
				Data = Data or { }

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
					Element = Items["Checkbox"],
					Name = Toggle.Name,
				}

				TableInsert(PageSearchData, SearchData)
			end

			Items["Indicator"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Toggle:Set(not Toggle.Value)
				end
			end)

			Toggle:Set(Toggle.Default)

			Library.SetFlags[Toggle.Flag] = function(Value)
				Toggle:Set(Value)
			end

			function Toggle:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				return Toggle
			end

			return Toggle 
		end

		Library.Sections.Button = function(self)
			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
			}

			local Items = { } do 
				Items["Button"] = Instances:Create("Frame", {
					Parent = Button.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, 25),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Instances:Create("UIListLayout", {
					Parent = Items["Button"].Instance,
					Name = "\0",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = UDimNew(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill
				})                
			end 

			function Button:Add(Name, Callback)
				local NewButton = { 
					Disabled = false
				}

				local NewItems = { } do 
					NewItems["NewButton"] = Instances:Create("TextButton", {
						Parent = Items["Button"].Instance,
						Name = "\0",
						FontFace = Library.Font,
						TextColor3 = FromRGB(0, 0, 0),
						BorderColor3 = FromRGB(0, 0, 0),
						Text = "",
						AutoButtonColor = false,
						BorderSizePixel = 0,
						Size = UDim2New(0, 200, 0, 50),
						ZIndex = 2,
						TextSize = 14,
						BackgroundColor3 = Library.Theme["Element"]
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
						FontFace = Library.Font,
						TextColor3 = Library.Theme["Text"],
						BorderColor3 = FromRGB(0, 0, 0),
						Text = Name,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2New(1, 0, 1, 0),
						ZIndex = 2,
						TextSize = 14
					}):AddToTheme({TextColor3 = 'Text'})
				end

				function NewButton:SetVisibility(Bool)
					NewItems["NewButton"].Instance.Visible = Bool
				end

				function NewButton:Press()
					if NewButton.Disabled then 
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
						Element2 = Items["Button"],
						Name = Name,
						Type = "Button",
					}

					TableInsert(PageSearchData, SearchData)
				end

				NewItems["NewButton"]:Connect("MouseButton1Down", function()
					NewButton:Press()
				end)

				return Button, NewButton
			end

			function Button:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				return Button
			end

			return Button
		end

		Library.Sections.Slider = function(self, Data)
			Data = Data or { }

			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Slider",
				Description = Data.Description or Data.Description or nil,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Min = Data.Min or Data.min or 0,
				Default = Data.Default or Data.default or 0,
				Max = Data.Max or Data.max or 100,
				Suffix = Data.Suffix or Data.suffix or "",
				Tooltip = Data.Tooltip or Data.tooltip or nil,
				Decimals = Data.Decimals or Data.decimals or 1,
				Callback = Data.Callback or Data.callback or function() end,

				Value = 0,
				Sliding = false,
				Disabled = false,
			}

			local Items = { } do 
				Items["Slider"] = Instances:Create("Frame", {
					Parent = Slider.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, Slider.Description ~= nil and Slider.Description ~= "" and 54 or 40),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Items["Slider"]:Tooltip(Slider.Tooltip)

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Slider.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				if Slider.Description ~= nil and Slider.Description ~= "" then
					Items["Description"] = Instances:Create("TextLabel", {
						Parent = Items["Slider"].Instance,
						Name = "\0",
						FontFace = Library.Font,
						TextColor3 = Library.Theme["Text"],
						BorderColor3 = FromRGB(0, 0, 0),
						TextTransparency = 0.5,
						Text = Slider.Description,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						Position = UDim2New(0, 0, 0, 14),
						Size = UDim2New(0, 0, 0, 15),
						BorderSizePixel = 0,
						ZIndex = 2,
						TextSize = 12
					}):AddToTheme({TextColor3 = 'Text'})
				end

				Items["ValueBackground"] = Instances:Create("Frame", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0),
					Position = UDim2New(1, 0, 0, 0),
					Size = UDim2New(0, 30, 0, 25),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Element"],
					ClipsDescendants = true
				}):AddToTheme({BackgroundColor3 = 'Element'})

				Instances:Create("UIGradient", {
					Parent = Items["ValueBackground"].Instance,
					Name = "\0",
					Rotation = 90,
					Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(216, 216, 216))}
				})

				Instances:Create("UICorner", {
					Parent = Items["ValueBackground"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Value"] = Instances:Create("TextBox", {
					Parent = Items["ValueBackground"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextStrokeColor3 = Library.Theme["Text"],
					PlaceholderColor3 = Library.Theme["Inactive Text"],
					TextSize = 14,
					ClearTextOnFocus = false,
					Size = UDim2New(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					ZIndex = 2,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Center,
					CursorPosition = -1,
					Position = UDim2New(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2New(0.5, 0.5),
					BorderSizePixel = 0
				}):AddToTheme({TextColor3 = 'Text'})

				local SliderFocused = false

				Items["Value"]:Connect("Focused", function()
					SliderFocused = true
				end)

				Items["Value"]:Connect("focusLost", function(enterPressed)
					SliderFocused = false
					if enterPressed then
						local raw = Items["Value"].Instance.Text
						local stripped = StringGSub(raw, "[^0-9%.%-]", "")
						local InputValue = tonumber(stripped)
						if InputValue then
							Slider:Set(InputValue)
						else
							Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)
						end
					else
						Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)
					end
				end)

				Items["Value"]:Connect("Changed", function(Property)
					if Property == "Text" then
						local raw = Items["Value"].Instance.Text
						local stripped = StringGSub(raw, "[^0-9%.%-]", "")
						local NumValue = tonumber(stripped)
						if NumValue then
							Items["Value"].Instance.TextColor3 = Library.Theme["Text"]
						elseif raw ~= "" and raw ~= Slider.Suffix then
							Items["Value"].Instance.TextColor3 = FromRGB(255, 80, 80)
						end
					end
				end)

				Items["RealSlider"] = Instances:Create("TextButton", {
					Parent = Items["Slider"].Instance,
					Name = "\0",
					Active = false,
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					Size = UDim2New(1, 0, 0, 15),
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					ClipsDescendants = true,
					Position = UDim2New(0, 0, 1, 0),
					Selectable = false,
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundTransparency = 0,
					BackgroundColor3 = Library.Theme["Element"]
				}):AddToTheme({BackgroundColor3 = 'Element'})

				Instances:Create("UICorner", {
					Parent = Items["RealSlider"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0)
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
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Accent"]
				}):AddToTheme({BackgroundColor3 = 'Accent'})

				Instances:Create("UIGradient", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
				})

				Instances:Create("UICorner", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0)
				})

				Items["Drag"] = Instances:Create("Frame", {
					Parent = Items["Accent"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0.5),
					Position = UDim2New(1, 0, 0.5, 0),
					Size = UDim2New(0, 7, 1, 0),
					ZIndex = 5,
					BorderSizePixel = 0
				})

				Instances:Create("UICorner", {
					Parent = Items["Drag"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(1, 0)
				})
			end

			function Slider:Get()
				return Slider.Value 
			end

			function Slider:SetVisibility(Bool)
				Items["Slider"].Instance.Visible = Bool
			end

			function Slider:Set(Value)
				if Slider.Disabled then 
					return 
				end

				Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
				Library.Flags[Slider.Flag] = Slider.Value

				local DisplayText = StringFormat("%s%s", Slider.Value, Slider.Suffix)
				if Items["Value"].Instance.Text ~= DisplayText then
					Items["Value"].Instance.Text = DisplayText
				end

				defer(function()
					local TextBounds = Items["Value"].Instance.TextBounds
					Items["ValueBackground"].Instance.Size = UDim2New(0, math.max(30, TextBounds.X + 20), 0, 25)
				end)

				Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})

				if Slider.Callback then 
					Library:SafeCall(Slider.Callback, Slider.Value)
				end

				Library:SaveAutoloadIfEnabled()
			end

			function Slider:SetDisabled(Bool)
				Slider.Disabled = Bool

				if Slider.Disabled then
					for Index, Value in Items do 
						if Index == "Slider" then
							continue
						end

						if Value.Instance:IsA("Frame") then
							Value:Tween(nil, {BackgroundTransparency = 0.6})
						elseif Value.Instance:IsA("TextLabel") or Value.Instance:IsA("TextBox") then 
							Value:Tween(nil, {TextTransparency = 0.6})
						end
					end
				else
					for Index, Value in Items do 
						if Index == "Slider" then
							continue
						end

						if Value.Instance:IsA("Frame") then
							Value:Tween(nil, {BackgroundTransparency = 0})
						elseif Value.Instance:IsA("TextLabel") or Value.Instance:IsA("TextBox") then 
							Value:Tween(nil, {TextTransparency = 0})
						end
					end
				end
			end

			local PageSearchData = Library.SearchItems[Slider.Page] 

			if PageSearchData then
				local SearchData = { 
					Element = Items["Slider"],
					Name = Slider.Name,
				}

				TableInsert(PageSearchData, SearchData)
			end

			local InputChanged 

			Items["RealSlider"]:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Slider.Sliding = true

					local MouseLocation = UserInputService:GetMouseLocation()
					local SliderAbs = Items["RealSlider"].Instance.AbsolutePosition
					local SliderSize = Items["RealSlider"].Instance.AbsoluteSize
					local SizeX = MathClamp((MouseLocation.X - SliderAbs.X) / SliderSize.X, 0, 1)
					local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

					Slider:Set(Value)

					if InputChanged then
						return
					end

					InputChanged = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							Slider.Sliding = false

							InputChanged:Disconnect()
							InputChanged = nil
						end
					end)
				end
			end)

			Library:Connect(UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					if Slider.Sliding then
						local MouseLocation = UserInputService:GetMouseLocation()
						local SliderAbs = Items["RealSlider"].Instance.AbsolutePosition
						local SliderSize = Items["RealSlider"].Instance.AbsoluteSize
						local SizeX = MathClamp((MouseLocation.X - SliderAbs.X) / SliderSize.X, 0, 1)
						local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

						Slider:Set(Value)
					end
				end
			end)

			if Slider.Default then
				Slider:Set(Slider.Default)
			end

			Library.SetFlags[Slider.Flag] = function(Value)
				Slider:Set(Value)
			end

			function Slider:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				return Slider
			end

			return Slider 
		end

		Library.Sections.Dropdown = function(self, Data)
			Data = Data or { }

			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Dropdown",
				Description = Data.Description or Data.Description or nil,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Items = Data.Items or Data.items or { "One", "Two", "Three" },
				MaxSize = Data.MaxSize or Data.maxsize or 280,
				Tooltip = Data.Tooltip or Data.tooltip or nil,
				Default = Data.Default or Data.default or nil,
				Callback = Data.Callback or Data.callback or function() end,
				Multi = Data.Multi or Data.multi or false,

				Value = { },
				Options = { },
				IsOpen = false,
				Disabled = false,
			}

			local Items = { } do 
				Items["Dropdown"] = Instances:Create("Frame", {
					Parent = Dropdown.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, Dropdown.Description ~= nil and Dropdown.Description ~= "" and 59 or 50),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})                

				Items["Dropdown"]:Tooltip(Dropdown.Tooltip)

				Items["RealDropdown"] = Instances:Create("TextButton", {
					Parent = Items["Dropdown"].Instance,
					Name = "\0",
					Active = false,
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 1),
					Selectable = false,
					Position = UDim2New(0, 0, 1, 3),
					Size = UDim2New(1, 0, 0, 25),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Element"]
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
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "...",
					TextTruncate = Enum.TextTruncate.None,
					Size = UDim2New(1, -25, 0, 15),
					AnchorPoint = Vector2New(0, 0.5),
					Position = UDim2New(0, 8, 0.5, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				Instances:Create("UIGradient", {
					Parent = Items["Value"].Instance,
					Name = "\0",
					Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.676, 0), NumSequenceKeypoint(1, 1)}
				})

				Items["Icon"] = Instances:Create("ImageLabel", {
					Parent = Items["RealDropdown"].Instance,
					Name = "\0",
					ImageColor3 = Library.Theme["Accent"],
					ScaleType = Enum.ScaleType.Fit,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 25, 0, 25),
					AnchorPoint = Vector2New(1, 0.5),
					Image = "rbxassetid://96215562143920",
					BackgroundTransparency = 1,
					Position = UDim2New(1, -1, 0.5, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				}):AddToTheme({ImageColor3 = 'Accent'})

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Dropdown"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Dropdown.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})     

				if Dropdown.Description ~= nil and Dropdown.Description ~= "" then
					Items["Description"] = Instances:Create("TextLabel", {
						Parent = Items["Dropdown"].Instance,
						Name = "\0",
						FontFace = Library.Font,
						TextColor3 = Library.Theme["Text"],
						BorderColor3 = FromRGB(0, 0, 0),
						Position = UDim2New(0, 0, 0, 16),
						Text = Dropdown.Description,
						TextTransparency = 0.5,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						Size = UDim2New(0, 0, 0, 15),
						BorderSizePixel = 0,
						ZIndex = 2,
						TextSize = 12
					}):AddToTheme({TextColor3 = 'Text'})     
				end

				Items["OptionHolder"] = Instances:Create("TextButton", {
					Parent = Library.UnusedHolder.Instance,
					Name = "\0",
					Visible = false,
					ClipsDescendants = true,
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					AnchorPoint = Vector2New(0, 0),
					SelectionGroup = true,
					Position = UDim2New(0, 0, 0, 5),
					Size = UDim2New(0, 155, 0, 125),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Background"]
				}):AddToTheme({BackgroundColor3 = 'Background'})

				Instances:Create("UICorner", {
					Parent = Items["OptionHolder"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["Holder"] = Instances:Create("ScrollingFrame", {
					Parent = Items["OptionHolder"].Instance,
					Name = "\0",
					Active = true,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ZIndex = 5,
					BorderSizePixel = 0,
					CanvasSize = UDim2New(0, 0, 0, 0),
					ScrollBarImageColor3 = Library.Theme["Accent"],
					MidImage = "rbxassetid://128693616966482",
					BorderColor3 = FromRGB(0, 0, 0),
					ScrollBarThickness = 3,
					Size = UDim2New(1, -16, 1, -48),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0, 40),
					BottomImage = "rbxassetid://128693616966482",
					TopImage = "rbxassetid://128693616966482"
				}):AddToTheme({ScrollBarImageColor3 = 'Accent'})

				Instances:Create("UIPadding", {
					Parent = Items["Holder"].Instance,
					Name = "\0",
					PaddingTop = UDimNew(0, 5),
					PaddingBottom = UDimNew(0, 8),
					PaddingRight = UDimNew(0, 8),
					PaddingLeft = UDimNew(0, 5)
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
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = Items["Search"].Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				Items["SearchIcon"] = Instances:Create("ImageLabel", {
					Parent = Items["Search"].Instance,
					Name = "\0",
					ScaleType = Enum.ScaleType.Fit,
					ImageTransparency = 0.4000000059604645,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(0, 20, 0, 20),
					AnchorPoint = Vector2New(0, 0.5),
					Image = "rbxassetid://71924825350727",
					BackgroundTransparency = 1,
					Position = UDim2New(0, 8, 0.5, 0),
					ZIndex = 5,
					BorderSizePixel = 0
				})

				Items["Input"] = Instances:Create("TextBox", {
					Parent = Items["Search"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					AnchorPoint = Vector2New(0, 0.5),
					PlaceholderColor3 = Library.Theme["Inactive Text"],
					PlaceholderText = "Search..",
					TextSize = 14,
					Size = UDim2New(1, -43, 0, 15),
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5,
					Position = UDim2New(0, 35, 0.5, 0),
					BorderSizePixel = 0
				}):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})                
			end

			function Dropdown:Get()
				return Dropdown.Value
			end

			function Dropdown:SetVisibility(Bool)
				Items["Dropdown"].Instance.Visible = Bool
			end

			function Dropdown:SetDisabled(Bool)
				Dropdown.Disabled = Bool

				if Dropdown.Disabled then 
					Items["Text"]:Tween(nil, {TextTransparency = 0.6})
					Items["RealDropdown"]:Tween(nil, {BackgroundTransparency = 0.6})
					Items["Value"]:Tween(nil, {TextTransparency = 0.6})
					Items["Icon"]:Tween(nil, {ImageTransparency = 0.6})

					Dropdown:SetOpen(false)
				else
					Items["Text"]:Tween(nil, {TextTransparency = 0})
					Items["RealDropdown"]:Tween(nil, {BackgroundTransparency = 0})
					Items["Value"]:Tween(nil, {TextTransparency = 0})
					Items["Icon"]:Tween(nil, {ImageTransparency = 0})
				end
			end

			local Debounce = false
			local RenderStepped

			local function updateOptionHolderPosition()
				if not Library or not Items["OptionHolder"].Instance.Parent then return end
				local S = (Library.Holder.Instance:FindFirstChildOfClass("UIScale") or {Scale = 1}).Scale
				local btn = Items["RealDropdown"].Instance
				local mf = Dropdown.Window.Items["MainFrame"].Instance
				local mf_x, mf_y = mf.AbsolutePosition.X, mf.AbsolutePosition.Y
				local mf_right = mf_x + mf.AbsoluteSize.X - 8
				local mf_bottom = mf_y + mf.AbsoluteSize.Y - 8

				local left = math.max(btn.AbsolutePosition.X, mf_x + 8)
				local out_w = math.min(btn.AbsolutePosition.X + btn.AbsoluteSize.X, mf_right) - left
				local drop_h = Dropdown.MaxSize
				local space_below = mf_bottom - (btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 5)

				if space_below >= drop_h then
					local top = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y + 5
					Items["OptionHolder"].Instance.Position = UDim2New(0, left / S, 0, top / S)
					Items["OptionHolder"].Instance.Size = UDim2New(0, out_w / S, 0, (math.min(top + drop_h, mf_bottom) - top) / S)
				else
					local list_bottom = btn.AbsolutePosition.Y - 5
					local top = math.max(list_bottom - drop_h, mf_y + 8)
					Items["OptionHolder"].Instance.Position = UDim2New(0, left / S, 0, top / S)
					Items["OptionHolder"].Instance.Size = UDim2New(0, out_w / S, 0, (list_bottom - top) / S)
				end
			end

			function Dropdown:SetOpen(Bool)
				if Debounce then 
					return
				end

				Dropdown.IsOpen = Bool

				Debounce = true 

				if Dropdown.IsOpen then 
					Items["OptionHolder"].Instance.Visible = true
					Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

					updateOptionHolderPosition()

					RenderStepped = RunService.RenderStepped:Connect(function()
						if not Library then return end
						updateOptionHolderPosition()
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
						Value.ZIndex = Dropdown.IsOpen and 3 or 1
					end

					if type(TransparencyProperty) == "table" then 
						for _, Property in TransparencyProperty do 
							NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
						end
					else
						NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
					end
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

				if Dropdown.Multi then 
					if type(Option) ~= "table" then 
						return
					end

					Dropdown.Value = Option
					Library.Flags[Dropdown.Flag] = Option

					for Index, Value in Option do
						local OptionData = Dropdown.Options[Value]

						if not OptionData then
							continue
						end

						OptionData.Selected = true 
						OptionData:Toggle("Active")
					end

					Items["Value"].Instance.Text = TableConcat(Option, ", ")
				else

					local OptionStr = tostring(Option)
					if OptionStr == "" or OptionStr == "nil" then
						return
					end

					if not Dropdown.Options[OptionStr] then
						return
					end

					local OptionData = Dropdown.Options[OptionStr]

					Dropdown.Value = OptionStr
					Library.Flags[Dropdown.Flag] = OptionStr

					for Index, Value in Dropdown.Options do
						if Value ~= OptionData then
							Value.Selected = false 
							Value:Toggle("Inactive")
						else
							Value.Selected = true 
							Value:Toggle("Active")
						end
					end

					Items["Value"].Instance.Text = OptionStr
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
					FontFace = Library.Font,
					TextColor3 = FromRGB(0, 0, 0),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2New(1, 0, 0, 25),
					ZIndex = 5,
					TextSize = 14,
					BackgroundColor3 = Library.Theme["Inline"]
				}):AddToTheme({BackgroundColor3 = 'Inline'})

				Instances:Create("UICorner", {
					Parent = OptionButton.Instance,
					Name = "\0",
					CornerRadius = UDimNew(0, 5)
				})

				local OptionText = Instances:Create("TextLabel", {
					Parent = OptionButton.Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					TextTransparency = 0.4000000059604645,
					Text = Option,
					BorderColor3 = FromRGB(0, 0, 0),
					Size = UDim2New(1, -15, 1, 0),
					Position = UDim2New(0, 4, 0, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					ZIndex = 5,
					TextSize = 14
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

					if Dropdown.Multi then 
						local Index = TableFind(Dropdown.Value, OptionData.Name)

						if Index then 
							TableRemove(Dropdown.Value, Index)
						else
							TableInsert(Dropdown.Value, OptionData.Name)
						end

						OptionData:Toggle(Index and "Inactive" or "Active")

						Library.Flags[Dropdown.Flag] = Dropdown.Value

						local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
						Items["Value"].Instance.Text = TextFormat
					else
						if OptionData.Selected then 
							Dropdown.Value = OptionData.Name
							Library.Flags[Dropdown.Flag] = OptionData.Name

							OptionData.Selected = true
							OptionData:Toggle("Active")

							for Index, Value in Dropdown.Options do 
								if Value ~= OptionData then
									Value.Selected = false 
									Value:Toggle("Inactive")
								end
							end

							Items["Value"].Instance.Text = OptionData.Name
						else
							Dropdown.Value = nil
							Library.Flags[Dropdown.Flag] = nil

							OptionData.Selected = false
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
					Element = Items["Dropdown"],
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

			Library.SetFlags[Dropdown.Flag] = function(Value)
				Dropdown:Set(Value)
			end

			function Dropdown:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				return Dropdown
			end

			return Dropdown
		end

		Library.Sections.Label = function(self, Name, Description, Tooltip)
			local Label = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Name or "Label",
				Description = Description or nil,
			}

			local Items = { } do 
				Items["Label"] = Instances:Create("Frame", {
					Parent = Label.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, Label.Description ~= nil and Label.Description ~= "" and 28 or 20),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Items["Label"]:Tooltip(Tooltip)

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Label"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = FromRGB(255, 255, 255),
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Label.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					AnchorPoint = Vector2New(0, 0),
					Size = UDim2New(0, 0, 0, 15),
					BackgroundTransparency = 1,
					Position = UDim2New(0, 0, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				if Label.Description ~= nil and Label.Description ~= "" then
					Items["Description"] = Instances:Create("TextLabel", {
						Parent = Items["Label"].Instance,
						Name = "\0",
						FontFace = Library.Font,
						TextColor3 = FromRGB(255, 255, 255),
						BorderColor3 = FromRGB(0, 0, 0),
						Text = Label.Description,
						AutomaticSize = Enum.AutomaticSize.X,
						AnchorPoint = Vector2New(0, 0),
						Size = UDim2New(0, 0, 0, 15),
						BackgroundTransparency = 1,
						Position = UDim2New(0, 0, 0, 14),
						BorderSizePixel = 0,
						TextTransparency = 0.5,
						ZIndex = 2,
						TextSize = 12
					}):AddToTheme({TextColor3 = 'Text'})
				end

				Items["SubElements"] = Instances:Create("Frame", {
					Parent = Items["Label"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(1, 0),
					BackgroundTransparency = 1,
					Position = UDim2New(1, 0, 0, 0),
					Size = UDim2New(0, 0, 1, 0),
					BorderSizePixel = 0
				})

				Instances:Create("UIListLayout", {
					Parent = Items["SubElements"].Instance,
					Name = "\0",
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDimNew(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder
				})                
			end

			function Label:SetText(Text)
				Text = tostring(Text)
				Items["Text"].Instance.Text = Text
			end

			function Label:SetTextColor(Color)
				if type(Color) == "table" then
					Color = FromRGB(Color[1], Color[2], Color[3])
				elseif type(Color) == "string" then
					Color = FromHex(Color)
				end
				Items["Text"].Instance.TextColor3 = Color
			end

			function Label:SetVisibility(Bool)
				Items["Label"].Instance.Visible = Bool
			end

			function Label:Colorpicker(Data)
				Data = Data or { }

				local Colorpicker = {
					Window = Label.Window,
					Page = Label.Page,
					Section = Label.Section,

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

			function Label:Keybind(Data)
				Data = Data or { }

				local Keybind = {
					Window = Label.Window,
					Page = Label.Page,
					Section = Label.Section,

					Name = Data.Name or Data.name or Label.Name,
					Flag = Data.Flag or Data.flag or Library:NextFlag(),
					Default = Data.Default or Data.default or Enum.KeyCode.E,
					Callback = Data.Callback or Data.callback or function() end,
					Mode = Data.Mode or Data.mode or "Toggle"
				}

				local NewKeybind, KeybindItems = Library:CreateKeybind({
					Parent = Items["SubElements"],
					Name = Keybind.Name,
					Page = Keybind.Page,
					Section = Keybind.Section,
					Flag = Keybind.Flag,
					Default = Keybind.Default,
					Mode = Keybind.Mode,
					Callback = Keybind.Callback
				})

				return NewKeybind
			end

			local PageSearchData = Library.SearchItems[Label.Page] 

			if PageSearchData then
				local SearchData = { 
					Element = Items["Label"],
					Name = Label.Name,
				}

				TableInsert(PageSearchData, SearchData)
			end

			function Label:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				return Label
			end

			return Label
		end

		Library.Sections.Textbox = function(self, Data)
			Data = Data or { }

			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,

				Name = Data.Name or Data.name or "Textbox",
				Description = Data.Description or Data.Description or nil,
				Flag = Data.Flag or Data.flag or Library:NextFlag(),
				Default = Data.Default or Data.default or "",
				Tooltip = Data.Tooltip or Data.tooltip or nil,
				Callback = Data.Callback or Data.callback or function() end,
				Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
				Numeric = Data.Numeric or Data.numeric or false,
				Finished = Data.Finished or Data.finished or false,
				Disabled = false,

				Value = ""
			}

			local Items = { } do 
				Items["Textbox"] = Instances:Create("Frame", {
					Parent = Textbox.Section.Items["Content"].Instance,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = UDim2New(1, 0, 0, Textbox.Description ~= nil and Textbox.Description ~= "" and 59 or 50),
					BorderColor3 = FromRGB(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0
				})

				Items["Textbox"]:Tooltip(Textbox.Tooltip)

				Items["Text"] = Instances:Create("TextLabel", {
					Parent = Items["Textbox"].Instance,
					Name = "\0",
					FontFace = Library.Font,
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = Textbox.Name,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Size = UDim2New(0, 0, 0, 15),
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 14
				}):AddToTheme({TextColor3 = 'Text'})

				if Textbox.Description ~= nil and Textbox.Description ~= "" then
					Items["Description"] = Instances:Create("TextLabel", {
						Parent = Items["Textbox"].Instance,
						Name = "\0",
						FontFace = Library.Font,
						TextColor3 = Library.Theme["Text"],
						BorderColor3 = FromRGB(0, 0, 0),
						Text = Textbox.Description,
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						Size = UDim2New(0, 0, 0, 15),
						BorderSizePixel = 0,
						Position = UDim2New(0, 0, 0, 16),
						TextTransparency = 0.5,
						ZIndex = 2,
						TextSize = 12
					}):AddToTheme({TextColor3 = 'Text'})
				end

				Items["Background"] = Instances:Create("Frame", {
					Parent = Items["Textbox"].Instance,
					Name = "\0",
					BorderColor3 = FromRGB(0, 0, 0),
					AnchorPoint = Vector2New(0, 1),
					Position = UDim2New(0, 0, 1, 3),
					Size = UDim2New(1, 0, 0, 25),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = Library.Theme["Element"],
					ClipsDescendants = true
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
					FontFace = Library.Font,
					TextStrokeColor3 = Library.Theme["Text"],
					PlaceholderColor3 = Library.Theme["Inactive Text"],
					PlaceholderText = Textbox.Placeholder,
					TextSize = 14,
					ClearTextOnFocus = false,
					Size = UDim2New(1, -16, 1, 0),
					TextColor3 = Library.Theme["Text"],
					BorderColor3 = FromRGB(0, 0, 0),
					Text = "",
					ZIndex = 2,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					CursorPosition = -1,
					Position = UDim2New(0, 8, 0, 0),
					BorderSizePixel = 0
				}):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})     

				Instances:Create("UIGradient", {
					Parent = Items["Input"].Instance,
					Name = "\0",
					Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.676, 0), NumSequenceKeypoint(1, 1)}
				})
			end

			function Textbox:Get()
				return Textbox.Value
			end

			function Textbox:SetDisabled(Bool)
				Textbox.Disabled = Bool 

				if Textbox.Disabled then 
					Items["Text"]:Tween(nil, {TextTransparency = 0.6})
					Items["Background"]:Tween(nil, {BackgroundTransparency = 0.6})
					Items["Input"]:Tween(nil, {TextTransparency = 0.6})
					Items["Input"].Instance.Interactable = false
				else
					Items["Text"]:Tween(nil, {TextTransparency = 0})
					Items["Background"]:Tween(nil, {BackgroundTransparency = 0})
					Items["Input"]:Tween(nil, {TextTransparency = 0})
					Items["Input"].Instance.Interactable = true
				end
			end

			function Textbox:SetVisibility(Bool)
				Items["Textbox"].Instance.Visible = Bool
			end

			function Textbox:Set(Value)
				local StrValue = tostring(Value)

				if Textbox.Numeric then
					if (not tonumber(StrValue)) and StringLen(StrValue) > 0 then
						return
					end
				end

				Textbox.Value = Value
				if Items["Input"].Instance.Text ~= StrValue then
					Items["Input"].Instance.Text = StrValue
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
					Element = Items["Textbox"],
					Name = Textbox.Name,
				}

				TableInsert(PageSearchData, SearchData)
			end

			local TextFocused = false
			local LastStableValue = Textbox.Value

			if Textbox.Finished then
				Items["Input"]:Connect("Focused", function()
					TextFocused = true
				end)

				Items["Input"]:Connect("FocusLost", function(pressedEnter)
					TextFocused = false
					local newText = Items["Input"].Instance.Text
					if Textbox.Numeric then
						local stripped = StringGSub(newText, "[^0-9%.%-]", "")
						if stripped == "" then
							Items["Input"].Instance.Text = LastStableValue
						else
							local parsed = tonumber(stripped)
							if parsed then
								Textbox:Set(parsed)
								LastStableValue = Textbox.Value
							else
								Items["Input"].Instance.Text = LastStableValue
							end
						end
					else
						if newText ~= LastStableValue then
							Textbox:Set(newText)
							LastStableValue = Textbox.Value
						else
							Items["Input"].Instance.Text = LastStableValue
						end
					end
				end)
			else
				Items["Input"]:Connect("Focused", function()
					TextFocused = true
				end)

				Items["Input"]:Connect("FocusLost", function()
					TextFocused = false
					LastStableValue = Textbox.Value
				end)

				Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
					local currentText = Items["Input"].Instance.Text
					if TextFocused then
						if Textbox.Numeric then
							local stripped = StringGSub(currentText, "[^0-9%.%-]", "")
							if stripped == "" or stripped == "-" or stripped == "." or stripped == "-." then
								return
							end
							local parsed = tonumber(stripped)
							if parsed then
								Textbox.Value = parsed
								Library.Flags[Textbox.Flag] = parsed
							end
						end
					else
						if Textbox.Value ~= currentText then
							Textbox:Set(currentText)
						end
					end
				end)
			end

			if Textbox.Default then
				Textbox:Set(Textbox.Default)
			end

			Library.SetFlags[Textbox.Flag] = function(Value)
				Textbox:Set(Value)
			end

			function Textbox:Destroy()
				for _, item in pairs(Items) do
					if item.Instance then
						item.Instance:Destroy()
					end
				end
				for _, conn in pairs(Library.Connections) do
					if conn.Event and conn.Event.Instance == Items["Input"].Instance then
						conn.Connection:Disconnect()
					end
				end
				Library.ThemeItems = Library.ThemeItems or {}
				for i = #Library.ThemeItems, 1, -1 do
					local theme_item = Library.ThemeItems[i]
					if theme_item.Item and Items["Input"].Instance and theme_item.Item:IsDescendantOf(Items["Input"].Instance) then
						table.remove(Library.ThemeItems, i)
					end
				end
				return Textbox
			end

			return Textbox
		end
	end

	Library.CreateSettingsPage = function(self, Window, Watermark, KeybindList)
		local Settings = Window:Page({Name = "Settings", Columns = 2})

		do
			local ConfigHub_Section = Settings:Section({Name = "Config Hub", Side = 2})

			do
				local Config_Name 
				local Config_Selected 

				local Config_Dropdown = ConfigHub_Section:Dropdown({
					Name = "Config Select",
					Flag = "Config Select",
					Description = "List of the configs",
					Items = { },
					Multi = false,
					Callback = function(Value)
						Config_Selected = Value 
					end
				})

				ConfigHub_Section:Textbox({
					Name = "Config Name",
					Flag = "Config Name",
					Description = "Name of the config",                   
					Placeholder = "Config name...",
					Callback = function(Value)
						Config_Name = Value 
					end
				})

				ConfigHub_Section:Button():Add("Create", function()
					if Config_Name then 
						if Config_Name == "" then 
							return
						end

						writefile(Library:GetFolder().. Config_Name .. ".json", Library:GetConfig())
						Library:RefreshConfigsList(Config_Dropdown)

						Library:Notification({
							Name = "Success",
							Description = "Succesfully created config: ".. Config_Name,
							Color = Color3.fromRGB(0, 255, 0),
							Duration = 5
						})
					end
				end):Add("Delete", function()
					if Config_Selected then 
						if isfile(Library:GetFolder().. Config_Selected .. ".json") then
							delfile(Library:GetFolder().. Config_Selected .. ".json")
							Library:RefreshConfigsList(Config_Dropdown)

							Library:Notification({
								Name = "Success",
								Description = "Succesfully deleted config: ".. Config_Selected,
								Color = Color3.fromRGB(0, 255, 0),
								Duration = 5
							})
						end
					end
				end)

				ConfigHub_Section:Button():Add("Load", function()
					if Config_Selected then 
						if isfile(Library:GetFolder().. Config_Selected .. ".json") then
							local ConfigContent = readfile(Library:GetFolder().. Config_Selected .. ".json")
							local Success, Error = Library:LoadConfig(ConfigContent)

							if Success then 
								Library:Notification({
									Name = "Success",
									Description = "Succesfully loaded config: ".. Config_Selected,
									Color = Color3.fromRGB(0, 255, 0),
									Duration = 5
								})
							else
								Library:Notification({
									Name = "Error",
									Description = "Failed to load config: ".. (Config_Selected or "Unknown") .. "\n" .. (Error or "Unknown error"),
									Color = Color3.fromRGB(255, 0, 0),
									Duration = 5
								})
							end
						else
							Library:Notification({
								Name = "Error",
								Description = "Failed to find config: ".. Config_Selected,
								Color = Color3.fromRGB(255, 0, 0),
								Duration = 5
							})
						end
					end
				end):Add("Save", function()
					if Config_Selected then
						if isfile(Library:GetFolder().. Config_Selected .. ".json") then
							local Success, Error = pcall(function()
								writefile(Library:GetFolder().. Config_Selected .. ".json", Library:GetConfig())
							end)

							if Success then 
								Library:Notification({
									Name = "Success",
									Description = "Succesfully saved config: ".. Config_Selected,
									Color = Color3.fromRGB(0, 255, 0),
									Duration = 5
								})
							else
								Library:Notification({
									Name = "Error",
									Description = "Failed to save config: ".. Config_Selected .. "\n" .. Error,
									Color = Color3.fromRGB(255, 0, 0),
									Duration = 5
								})
							end
						else
							Library:Notification({
								Name = "Error",
								Description = "Failed to find config: ".. Config_Selected,
								Color = Color3.fromRGB(255, 0, 0),
								Duration = 5
							})
						end
					end
				end)

				ConfigHub_Section:Button():Add("Refresh", function()
					Library:RefreshConfigsList(Config_Dropdown)
				end)

				ConfigHub_Section:Button():Add("Set Autoload", function()
					pcall(function()
						writefile(Library.Folders_Path.Directory .. "/autoload.json", Library:GetConfig())
					end)
					Library:Notification({
						Name = "Success",
						Description = "Autoload set to current config",
						Color = Color3.fromRGB(0, 255, 0),
						Duration = 5
					})
				end):Add("Remove Autoload", function()
					writefile(Library.Folders_Path.Directory .. "/autoload.json", "")

					Library:Notification({
						Name = "Success",
						Description = "Succesfully removed autoload",
						Color = Color3.fromRGB(0, 255, 0),
						Duration = 5
					})
				end)

				local Pasted_Config = ""
				ConfigHub_Section:Textbox({
					Name = "Paste Shared Config",
					Flag = "Paste Shared Config",
					Description = "Paste config here",
					Placeholder = "Paste config here...",
					Finished = true,
					Callback = function(Value)
						Pasted_Config = Value
					end
				})

				ConfigHub_Section:Button():Add("Share Config", function()
					local CurrentConfig = Library:GetConfig()
					setclipboard(CurrentConfig)

					Library:Notification({
						Name = "Success",
						Description = "Config copied to clipboard",
						Color = Color3.fromRGB(0, 255, 0),
						Duration = 5
					})
				end):Add("Import Pasted", function()
					if Pasted_Config and Pasted_Config ~= "" then
						local Success, Error = Library:LoadConfig(Pasted_Config)

						if Success then
							Library:Notification({
								Name = "Success",
								Description = "Succesfully imported config",
								Color = Color3.fromRGB(0, 255, 0),
								Duration = 5
							})
						else
							Library:Notification({
								Name = "Error",
								Description = "Failed to import config: ".. tostring(Error),
								Color = Color3.fromRGB(255, 0, 0),
								Duration = 5
							})
						end
					else
						Library:Notification({
							Name = "Error",
							Description = "No config pasted",
							Color = Color3.fromRGB(255, 0, 0),
							Duration = 5
						})
					end
				end)

				Library:RefreshConfigsList(Config_Dropdown)
			end
		end

		do
			local ThemeSetting_Section = Settings:Section({Name = "Theme Setting", Side = 1})
			local ThemeConfig_Section = Settings:Section({Name = "Theme Config", Side = 1})
			local Theme_Colorpicker = { }

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
					Items = { },
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
					Callback = function(Value)
						Theme_Name = Value 
					end
				})

				ThemeConfig_Section:Button():Add("Create", function()
					if Theme_Name then 
						if Theme_Name == "" then 
							return
						end

						writefile(Library:GetFolderTheme().. Theme_Name .. ".json", Library:GetTheme())
						Library:RefreshThemeList(Theme_Dropdown)

						Library:Notification({
							Name = "Success",
							Description = "Succesfully created theme: ".. Theme_Name,
							Color = Color3.fromRGB(0, 255, 0),
							Duration = 5
						})
					end
				end):Add("Delete", function()
					if Theme_Selected then 
						if isfile(Library:GetFolderTheme().. Theme_Selected .. ".json") then
							delfile(Library:GetFolderTheme().. Theme_Selected .. ".json")
							Library:RefreshThemeList(Theme_Dropdown)

							Library:Notification({
								Name = "Success",
								Description = "Succesfully deleted theme: ".. Theme_Selected,
								Color = Color3.fromRGB(0, 255, 0),
								Duration = 5
							})
						end
					end
				end)

				ThemeSetting_Section:Button():Add("Load", function()
					if Theme_Selected then 
						if isfile(Library:GetFolderTheme().. Theme_Selected .. ".json") then
							local ThemeContent = readfile(Library:GetFolderTheme().. Theme_Selected .. ".json")
							local Success, Error = Library:LoadTheme(ThemeContent)

							if Success then 
								Library:Notification({
									Name = "Success",
									Description = "Succesfully loaded theme: ".. Theme_Selected,
									Color = Color3.fromRGB(0, 255, 0),
									Duration = 5
								})
							else
								Library:Notification({
									Name = "Error",
									Description = "Failed to load theme: ".. Theme_Selected .. "\n" .. Error,
									Color = Color3.fromRGB(255, 0, 0),
									Duration = 5
								})
							end
						else
							Library:Notification({
								Name = "Error",
								Description = "Failed to find theme: ".. Theme_Selected,
								Color = Color3.fromRGB(255, 0, 0),
								Duration = 5
							})
						end
					end
				end):Add("Save", function()
					if Theme_Selected then
						if isfile(Library:GetFolderTheme().. Theme_Selected .. ".json") then
							local Success, Error = pcall(function()
								writefile(Library:GetFolderTheme().. Theme_Selected .. ".json", Library:GetTheme())
							end)

							if Success then 
								Library:Notification({
									Name = "Success",
									Description = "Succesfully saved theme: ".. Theme_Selected,
									Color = Color3.fromRGB(0, 255, 0),
									Duration = 5
								})
							else
								Library:Notification({
									Name = "Error",
									Description = "Failed to save theme: ".. Theme_Selected .. "\n" .. Error,
									Color = Color3.fromRGB(255, 0, 0),
									Duration = 5
								})
							end
						else
							Library:Notification({
								Name = "Error",
								Description = "Failed to find theme: ".. Theme_Selected,
								Color = Color3.fromRGB(255, 0, 0),
								Duration = 5
							})
						end
					end
				end)

				ThemeSetting_Section:Button():Add("Refresh", function()
					Library:RefreshThemeList(Theme_Dropdown)
				end)

				local Preset_Section = ThemeSetting_Section:Dropdown({
					Name = "Themes Preset", 
					Flag = "Themes Preset", 
					Description = "Select a theme",
					Items = { }, 
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
					Name = "Custom cursor",
					Flag = "Custom Cursor",
					Description = "Enable/disable custom cursor",
					Default = true,
					Callback = function(Value)
						Library.CustomCursor = Value
					end
				})

				MenuSetting_Section:Toggle({
					Name = "Auto Save",
					Flag = "Auto Save",
					Description = "Automatically save your config",
					Default = false,
					Callback = function(Value)
						Library.AutoSave = Value
					end
				})

				if IsMobile then
					MenuSetting_Section:Toggle({
						Name = "Lock Floating Button",
						Flag = "Lock Floating Button",
						Description = "Lock/unlock the floating button position",
						Default = false,
						Callback = function(Value)
							Library.FloatingButtonLocked = Value
						end
					})

					MenuSetting_Section:Slider({
						Name = "Floating button Transparency",
						Flag = "Floating Button Transparency",
						Description = "Floating button transparency",
						Min = 0,
						Max = 1,
						Default = 0,
						Decimals = 0.01,
						Callback = function(Value)
							Library.FloatingButtonVisibility = Value

							if Library.FloatingButton then
								Library.FloatingButton.Instance.BackgroundTransparency = Value
								for _, v in pairs(Library.FloatingButton.Instance:GetChildren()) do
									if v:IsA("TextLabel") then
										v.TextTransparency = Value
									end
								end
							end
						end
					})
				end
			end
		end
	end
end

getgenv().Library = Library
return Library