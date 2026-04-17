local cloneref = cloneref or function(o) return o end

local game = game
local GetService = game.GetService
local Service = function(Name)
	return cloneref(GetService(game, Name))
end

local Players = Service("Players")
local RunService = Service("RunService")
local HttpService = Service("HttpService")
local Workspace = Service("Workspace")
local UserInputService = Service("UserInputService")

local Color3FromRGB, Color3New = Color3.fromRGB, Color3.new
local TableClear, TableInsert, TableRemove, TableUnpack, TableFind, TableSort, TableConcat = table.clear, table.insert, table.remove, table.unpack, table.find, table.sort, table.concat
local StringFind, StringMatch, StringFormat, StringGsub, StringLower, StringUpper, StringSub = string.find, string.match, string.format, string.gsub, string.lower, string.upper, string.sub
local TaskWait, TaskSpawn, TaskDelay, TaskDefer = task.wait, task.spawn, task.delay, task.defer
local OsClock, OsDate = os.clock, os.date
local Vector2New, Vector3New, Vector3One, Vector3Zero = Vector2.new, Vector3.new, Vector3.one, Vector3.zero
local UDim2New, UDim2FromScale, UDim2FromOffset, UDimNew = UDim2.new, UDim2.fromScale, UDim2.fromOffset, UDim.new
local CFrameAngles, CFrameNew = CFrame.Angles, CFrame.new
local RectNew = Rect.new
local MathClamp, MathRound, MathFloor, MathHuge, MathSin, MathCos, MathPi, MathMin, MathDeg, MathMax = math.clamp, math.round, math.floor, math.huge, math.sin, math.cos, math.pi, math.min, math.deg, math.max
local FontNew = Font.new
local ColorSequenceNew, ColorSequenceKeypointNew = ColorSequence.new, ColorSequenceKeypoint.new
local NumberSequenceNew, NumberSequenceKeypointNew = NumberSequence.new, NumberSequenceKeypoint.new
local FindFirstChild, GetChildren, GetDescendants, WaitForChild, FindFirstChildWhichIsA, IsA = game.FindFirstChild, game.GetChildren, game.GetDescendants, game.WaitForChild, game.FindFirstChildWhichIsA, game.IsA
local InstanceNew = Instance.new

pcall(function() setfflag("AdornShadingAPI", "true") end)

local IsMobile = false

local Utility = {}

function Utility.CreateObject(Type, Properties)
	local Object = InstanceNew(Type)
	for Index, Value in Properties do
		Object[Index] = Value
	end
	return Object
end

local CustomFont = {}
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

	local FontPath = "Esp/Fonts/" .. Name .. ".font"
	if not isfile(FontPath) then
		writefile(FontPath, HttpService:JSONEncode(FontData))
	end

	local FontAssetSuccess, FontAssetId = pcall(getcustomasset, FontPath)
	if not FontAssetSuccess then
		return Font.fromEnum(Enum.Font.Gotham)
	end

	return Font.new(FontAssetId)
end

local BonesR15 = {
	{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
	{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
	{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
	{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
	{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}

local BonesR6 = {
	{"Head", "Torso"},
	{"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
	{"Head", "Left Arm"}, {"Head", "Right Arm"},
	{"Left Arm", "Right Arm"},
	{"Left Leg", "Right Leg"},
}

local function RemoveChamAdornments(Part)
	if not Part then return end

	for _, Obj in GetChildren(Part) do
		if Obj.Name == "\0" or Obj.Name == "Chams" then
			Obj:Destroy()
		end
	end
end

local function CreateChamAdornment(Part, Type, Color, Transparency, ZIndex, SizeOffset, Extra)
	Extra = Extra or {}

	local Adornment

	if Type == "Cylinder" then
		Adornment = Utility.CreateObject("CylinderHandleAdornment", {
			Name = "\0",
			Height = Part.Size.Y + (Extra.HeightOffset or 0),
			Radius = (Part.Size.X * 0.5) + (Extra.RadiusOffset or 0),
			CFrame = CFrameNew(Vector3Zero, Vector3New(0, 1, 0)),
			AlwaysOnTop = true,
			ZIndex = ZIndex,
			Adornee = Part,
			Color3 = Color,
			Transparency = Transparency or 0,
			Parent = Part
		})
	else
		Adornment = Utility.CreateObject("BoxHandleAdornment", {
			Name = "\0",
			Size = Part.Size + (SizeOffset or Vector3Zero),
			AlwaysOnTop = true,
			ZIndex = ZIndex,
			Adornee = Part,
			Color3 = Color,
			Transparency = Transparency or 0,
			Parent = Part
		})
	end

	if Extra.Shading then
		Adornment.Shading = Extra.Shading
	end

	return Adornment
end

local CharacterHelper = {}

function CharacterHelper:GetCharacter(Player)
	if not Player then return nil end

	return Player.Character
end

function CharacterHelper:GetChildren(Character)
	if not Character then return {} end

	return Character:GetChildren()
end

function CharacterHelper:GetDescendants(Character)
	if not Character then return {} end

	return Character:GetDescendants()
end

function CharacterHelper:GetTool(Player)
	if not Player then return nil end

	return nil
end

local Animation = {}
Animation.__index = Animation

do
	local  FillSpeed = 18
	local GradientSpeed = 1.2

	function Animation.GetDefaults()
		return  FillSpeed, GradientSpeed
	end

	function Animation.LerpNumber(CurrentValue, TargetValue, Speed, DeltaTime)
		if Speed == 0 or DeltaTime <= 0 then return TargetValue end

		DeltaTime = MathClamp(DeltaTime, 0, 0.05)

		local Decay = 1 - math.exp(-Speed * DeltaTime)
		Decay = Decay * Decay

		return CurrentValue + (TargetValue - CurrentValue) * MathClamp(Decay, 0, 1)
	end

	local function ColorAtSmooth(Colors, Time)
		Time = Time % 1

		if Time < 1/3 then
			return Colors[1]:Lerp(Colors[2], Time * 3)
		elseif Time < 2/3 then
			return Colors[2]:Lerp(Colors[3], (Time - 1/3) * 3)
		else
			return Colors[3]:Lerp(Colors[1], (Time - 2/3) * 3)
		end
	end

	function Animation.GetGradientColors(Colors, IsEnabled, Time, Speed)
		if not IsEnabled then
			return ColorSequenceNew{
				ColorSequenceKeypointNew(0, Colors[1]),
				ColorSequenceKeypointNew(0.5, Colors[2]),
				ColorSequenceKeypointNew(1, Colors[3]),
			}
		end

		local Phase = (Time * (Speed or GradientSpeed) * 0.4) % 1
		local NumKeyPoints = 6
		local KeyPoints = {}

		for i = 0, NumKeyPoints do
			local PositionRatio = i / NumKeyPoints
			TableInsert(KeyPoints, ColorSequenceKeypointNew(PositionRatio, ColorAtSmooth(Colors, PositionRatio + Phase)))
		end

		return ColorSequenceNew(KeyPoints)
	end

	local function ColorAtTwo(Color1, Color2, Time)
		Time = Time % 1
		if Time < 0.5 then return Color1:Lerp(Color2, Time * 2) else return Color2:Lerp(Color1, (Time - 0.5) * 2) end
	end

	function Animation.GetGradientColors2(Colors, IsEnabled, Time, Speed)
		if not IsEnabled or IsEnabled == "Vortex" or #Colors < 2 then
			return ColorSequenceNew{ColorSequenceKeypointNew(0, Colors[1]), ColorSequenceKeypointNew(1, Colors[2])}
		end

		local Color1, Color2 = Colors[1], Colors[2]
		local Phase = (Time * (Speed or GradientSpeed) * 0.4) % 1
		local NumKeyPoints = 5
		local KeyPoints = {}

		for i = 0, NumKeyPoints do
			local PositionRatio = i / NumKeyPoints
			TableInsert(KeyPoints, ColorSequenceKeypointNew(PositionRatio, ColorAtTwo(Color1, Color2, PositionRatio + Phase)))
		end

		return ColorSequenceNew(KeyPoints)
	end

	function Animation.GetVortexRotation(Time, Speed)
		return (Time * (Speed or 1) * 120) % 360
	end
end

local TextAlignments = {
	["Left"] = "Right",
	["Right"] = "Left",
	["Top"] = "Center",
	["Bottom"] = "Center",
}

local CornerLayout = {
	{UDim2New(0, -1, 0, -1), UDim2New(0.3, 0, 0, 1), Vector2New(0, 0), 0},
	{UDim2New(0, -1, 0, -1), UDim2New(0, 1, 0.3, 0), Vector2New(0, 0), 180},
	{UDim2New(1, 1, 0, -1), UDim2New(0.3, 0, 0, 1), Vector2New(1, 0), 0},
	{UDim2New(1, 1, 0, -1), UDim2New(0, 1, 0.3, 0), Vector2New(1, 0), 180},
	{UDim2New(0, -1, 1, 1), UDim2New(0.3, 0, 0, 1), Vector2New(0, 1), 0},
	{UDim2New(0, -1, 1, 1), UDim2New(0, 1, 0.3, 0), Vector2New(0, 1), -180},
	{UDim2New(1, 1, 1, 1), UDim2New(0.3, 0, 0, 1), Vector2New(1, 1), 0},
	{UDim2New(1, 1, 1, 1), UDim2New(0, 1, 0.3, 0), Vector2New(1, 1), -180},
}

local Esp
do
	local Client = Players.LocalPlayer
	local Camera = FindFirstChildWhichIsA(Workspace, "Camera")
	local ViewportCache = { value = Camera.ViewportSize }
	local CameraPosCache = { value = Camera.CFrame.Position }
	local WorldToViewportPoint = Camera.WorldToViewportPoint
	local ExecutorName = getexecutorname()

	local RaycastParamsCache = RaycastParams.new()
	RaycastParamsCache.FilterType = Enum.RaycastFilterType.Exclude

	local RaycastFilter = {}

	local FolderLocation = "solixhub/Esp"
	do
		local BaseFolder = FolderLocation
		local FontsFolder = FolderLocation .. "/Fonts"

		if not isfolder(BaseFolder) then
			makefolder(BaseFolder)
		end

		if not isfolder(FontsFolder) then
			makefolder(FontsFolder)
		end
	end

	local function GetLocalFont()
		local FontPath = "solixhub/Assets/InterSemibold.font"
		if isfile(FontPath) then
			local Success, AssetId = pcall(getcustomasset, FontPath)
			if Success then
				return Font.new(AssetId, Enum.FontWeight.SemiBold)
			end
		end
		return Font.new(Enum.Font.Gotham)
	end

	local InterFont = GetLocalFont()

	local function AddConnection(Signal, Function)
		local Connection = Signal:Connect(function(...)
			local Args = {...}
			local Success, Result = pcall(function() 
				coroutine.wrap(Function)(TableUnpack(Args))
			end)

			if not Success then
				warn("[Esp Error] ", Result)
			end
		end)

		if Connection then
			TableInsert(Esp.Connections, Connection)
		end

		return Connection
	end

	local function CalculateBox(ESPSettings, Target, RootPart, Parts)
		local MinX, MinY, MaxX, MaxY = 9000, 9000, -9000, -9000
		local BoxWidth, BoxHeight = 0, 0
		local Position, OnScreen = WorldToViewportPoint(Camera, RootPart.Position)

		if ESPSettings.BoundingBox.DynamicBox then
			local PartCount = 0
			local MaxDynamicParts = 12

			for _, Part in Parts do
				if PartCount >= MaxDynamicParts then break end
				if IsA(Part, "BasePart") and Part.Name ~= "HumanoidRootPart" and Part.Transparency ~= 1 then
					PartCount = PartCount + 1

					local PartCFrame = Part.CFrame
					local PartSize = Part.Size
					local Corners = {
						PartCFrame * Vector3New(PartSize.X / 2, PartSize.Y / 2, PartSize.Z / 2),
						PartCFrame * Vector3New(-PartSize.X / 2, PartSize.Y / 2, PartSize.Z / 2),
						PartCFrame * Vector3New(PartSize.X / 2, -PartSize.Y / 2, PartSize.Z / 2),
						PartCFrame * Vector3New(-PartSize.X / 2, -PartSize.Y / 2, PartSize.Z / 2),
						PartCFrame * Vector3New(PartSize.X / 2, PartSize.Y / 2, -PartSize.Z / 2),
						PartCFrame * Vector3New(-PartSize.X / 2, PartSize.Y / 2, -PartSize.Z / 2),
						PartCFrame * Vector3New(PartSize.X / 2, -PartSize.Y / 2, -PartSize.Z / 2),
						PartCFrame * Vector3New(-PartSize.X / 2, -PartSize.Y / 2, -PartSize.Z / 2),
					}

					for _, Corner in Corners do
						local ScreenPosition, OnScreen = WorldToViewportPoint(Camera, Corner)
						MinX = MathMin(MinX, ScreenPosition.X)
						MinY = MathMin(MinY, ScreenPosition.Y)
						MaxX = MathMax(MaxX, ScreenPosition.X)
						MaxY = MathMax(MaxY, ScreenPosition.Y)
					end
				end
			end
			BoxWidth, BoxHeight = MaxX - MinX, MaxY - MinY
		else
			local Scale = (RootPart.Size.Y * ViewportCache.value.Y) / (Position.Z * 2)

			BoxWidth, BoxHeight = 3 * Scale, 4.5 * Scale
			MinX, MinY = Position.X - (BoxWidth / 2), Position.Y - (BoxHeight / 2)
		end
		return BoxWidth, BoxHeight, MinX, MinY, OnScreen
	end

	local function IsPointVisible(WorldPoint, CharacterToIgnore)
		local CamPos = CameraPosCache.value
		local Direction = WorldPoint - CamPos
		local DistSq = Direction.X * Direction.X + Direction.Y * Direction.Y + Direction.Z * Direction.Z

		if DistSq < 0.0001 then return true end
		local Dist = math.sqrt(DistSq)

		TableClear(RaycastFilter)

		if CharacterToIgnore then TableInsert(RaycastFilter, CharacterToIgnore) end
		if Client and Client.Character then TableInsert(RaycastFilter, Client.Character) end

		RaycastParamsCache.FilterDescendantsInstances = RaycastFilter

		local Result = Workspace:Raycast(CamPos, Direction.Unit * Dist, RaycastParamsCache)
		return Result == nil
	end

	local function ShouldShowTarget(LocalPlayer, Target, PlayerSettings)
		local TeamCheck = PlayerSettings and PlayerSettings.TeamCheck
		if not TeamCheck or not TeamCheck.Enabled or type(TeamCheck.Function) ~= "function" then return true end

		local Success, Result = pcall(TeamCheck.Function, LocalPlayer, Target)
		return Success and Result ~= false
	end

	local function GetFontType(ESPSettings, Text)
		local FontType = StringLower(ESPSettings.FontType)

		if FontType == "uppercase" then
			return StringUpper(Text)
		elseif FontType == "lowercase" then
			return StringLower(Text)
		else
			return Text
		end
	end

	Esp = {
		Settings = {
			Players = {
				Enabled = true,
				LocalPlayer = true,
				Font = InterFont,
				FontSize = 12,
				FontType = "none",
				MaxDistance = 1000,
				RefreshRate = 60,
				BoundingBox = {
					Enabled = true,
					DynamicBox = true,
					IncludeAccessories = false,
					Type = "Corner",
					Rotation = 0,
					Animation = "",
					AnimationSpeed = 1,
					Color = {Color3FromRGB(180, 120, 255), Color3FromRGB(255, 250, 255)},
					Transparency = {0, 0},
					Glow = {
						Enabled = false,
						Rotation = 0,
						Color = {Color3FromRGB(180, 120, 255), Color3FromRGB(255, 250, 255)},
						Transparency = {0.35, 0.5},
					},
					Fill = {
						Enabled = false,
						Rotation = 0,
						Color = {Color3FromRGB(180, 120, 255), Color3FromRGB(200, 150, 255)},
						Transparency = {0.85, 0.9},
					},
				},
				Bars = {
					HealthBar = {
						Enabled = true,
						Position = "Left",
						Color = {Color3FromRGB(120, 80, 200), Color3FromRGB(200, 150, 255), Color3FromRGB(255, 250, 255)},
						Animation = "",
						Type = function(Player, CharacterObjects)
							if not IsA(Player, "Player") then return end

							local Humanoid = CharacterObjects.Humanoid
							if not Humanoid then return end
							return Humanoid.Health / Humanoid.MaxHealth
						end,
						Text = {
							Enabled = false,
							FollowBar = true,
							Ending = "",
							Position = "Left",
							Color = Color3FromRGB(255, 250, 255),
							Transparency = 0,
							Type = function(Player, CharacterObjects)
								if not IsA(Player, "Player") then return end

								local Humanoid = CharacterObjects.Humanoid
								if not Humanoid then return end
								return Humanoid.Health, Humanoid.Health ~= Humanoid.MaxHealth
							end,
						},
					},
				},
				Chams = {
					Enabled = true,
					DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
					Fill = {Color3FromRGB(180, 120, 255), 0.4},
					Outline = {Color3FromRGB(255, 250, 255), 0.25},
					Glow = {
						Enabled = true,
						Color = Color3FromRGB(200, 150, 255),
						Transparency = 0.55,
					},
					AdornmentTransparency = 0.4,
				},
				Name = {
					Enabled = true,
					UseDisplay = true,
					Position = "Top",
					Color = Color3FromRGB(255, 250, 255),
					Transparency = 0,
				},
				Distance = {
					Enabled = true,
					Ending = "m",
					Position = "Bottom",
					Color = Color3FromRGB(230, 210, 255),
					Transparency = 0,
				},
				Weapon = {
					Enabled = false,
					Position = "Bottom",
					Color = Color3FromRGB(200, 150, 255),
					Transparency = 0,
				},
				Flags = {
					Enabled = false,
					Position = "Right",
					Color = Color3FromRGB(230, 210, 255),
					Transparency = 0,
					DeadColor = Color3FromRGB(120, 80, 180),
					FriendColor = Color3FromRGB(200, 150, 255),
					Type = function(Player, CharacterObjects)
						local Flags = {}

						if not IsA(Player, "Player") then return Flags end

						local Humanoid = CharacterObjects.Humanoid
						if not Humanoid then return Flags end

						if Humanoid.Health <= 0 then
							TableInsert(Flags, "Dead")
							return Flags
						end

						if Humanoid.MoveDirection.Magnitude > 0 then
							TableInsert(Flags, "moving")
						end

						if Humanoid.Jump then
							TableInsert(Flags, "jumping")
						end

						local Success, Result = pcall(function()
							return Humanoid:GetState()
						end)

						if Success and Result then
							local StateName = tostring(Result)

							if StateName == "Freefall" then TableInsert(Flags, "falling")
							elseif StateName == "Ragdoll" then TableInsert(Flags, "ragdoll")
							elseif StateName == "Flying" then TableInsert(Flags, "flying")
							end
						end

						if Humanoid.Sit then TableInsert(Flags, "sitting") end

						local LocalPlayer = Players.LocalPlayer

						if LocalPlayer and Player ~= LocalPlayer then
							local Success, IsFriend = pcall(function() 
								return Player:IsFriendsWith(LocalPlayer.UserId)
							end)

							if Success and IsFriend then 
								TableInsert(Flags, "Friend")
							end
						end
						return Flags
					end,
				},
				Snapline = {
					Enabled = false,
					Origin = "Bottom",
					Color = Color3FromRGB(200, 150, 255),
					Thickness = 1,
					Transparency = 0,
					Outline = {
						Enabled = false,
						Color = Color3FromRGB(0, 0, 0),
						Thickness = 1,
					},
				},
				Trail = {
					Enabled = false,
					Origin = "Feet",
					Lifetime = 5,
					Color = Color3FromRGB(180, 120, 255),
					Transparency = {0, 0.25},
					WidthScale = 1,
				},
				ChinaHat = {
					Enabled = false,
					Material = Enum.Material.ForceField,
					Color = Color3FromRGB(180, 120, 255),
					Transparency = 0.45,
					SizeScale = {1.8, 0.9, 1.8},
				},
				Skeleton = {
					Enabled = false,
					Color = Color3FromRGB(200, 150, 255),
					Thickness = 1,
					Transparency = 0,
					Outline = {
						Enabled = false,
						Color = Color3FromRGB(255, 250, 255),
						Thickness = 1,
					},
				},
				VisibilityCheck = {
					Enabled = false,
					VisibleColor = Color3FromRGB(255, 250, 255),
					OccludedColor = Color3FromRGB(180, 120, 255),
				},
				TeamCheck = {
					Enabled = false,
					Function = function(LocalPlayer, Target)
						if not IsA(Target, "Player") then return true end

						local MyTeam = LocalPlayer and LocalPlayer.Team
						local TheirTeam = Target.Team

						if not MyTeam or not TheirTeam then return true end
						return MyTeam ~= TheirTeam
					end,
				},
			},
		},
		Connections = {},
		Objects = {},
		Targets = {},
		Folder = FolderLocation,
		Holder = nil,
	}

	local ESPSettings = Esp.Settings
	local ObjectsTable = Esp.Objects

	Esp.Holder = Utility.CreateObject("ScreenGui", {
		Parent = gethui(),
		Name = "\0",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 10000,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	})

	function Esp:AddTarget(Target, Type)
		if Target == nil then return end
		if not Esp.Targets[Type] then Esp.Targets[Type] = {} end
		if Esp.Targets[Type][Target] then return end

		local TargetInfo = {
			Objects = {},
			CharacterObjects = {},
			CharacterConnection = nil,
			ToolConnection = {Added = nil, Removed = nil},
			CurrentTool = "none",
			LastTick = OsClock(),
			ChamAdornments = {},
			AnimatedBars = {},
			BarGradientTime = {},
			BoxGradientTime = 0,
			SkeletonLines = {},
			CachedBones = nil,
			SkeletonBones = nil,
			CachedFlags = nil,
			CachedFlagsTick = 0,
			StructureDirty = true,
			BarSizes = nil,
			OutlineSizes = nil,
			GradientRotations = nil,
			BarPositions = nil,
		}

		local IsPlayer = IsA(Target, "Player")
		local IsBasePart = IsA(Target, "BasePart")
		local Objects = TargetInfo.Objects
		local LastTick = TargetInfo.LastTick
		local ToolConnection = TargetInfo.ToolConnection
		local CharacterObjects = TargetInfo.CharacterObjects
		local PlayerSettings = ESPSettings[Type]
		local ESPFont = PlayerSettings.Font or InterFont
		local ESPFontSize = PlayerSettings.FontSize
		local ESPHolder = Esp.Holder

		CharacterObjects.Character = IsPlayer and CharacterHelper:GetCharacter(Target) or Target
		CharacterObjects.Children = CharacterHelper:GetChildren(CharacterObjects.Character)
		CharacterObjects.Descendants = CharacterHelper:GetDescendants(CharacterObjects.Character)

		if IsPlayer and CharacterObjects.Character then
			CharacterObjects.HumanoidRootPart = CharacterObjects.Character:FindFirstChild("HumanoidRootPart")
			CharacterObjects.Humanoid = CharacterObjects.Character:FindFirstChildWhichIsA("Humanoid")
		elseif not IsPlayer then
			CharacterObjects.HumanoidRootPart = CharacterObjects.Character
			CharacterObjects.Humanoid = nil
		end

		function TargetInfo:Init()
			if #Objects > 0 then return end

			if IsPlayer then
				TargetInfo.CharacterConnection = AddConnection(Target.CharacterAdded, function(Character)
					if TargetInfo.ChamAdornments then
						for _, Adorns in TargetInfo.ChamAdornments do
							for _, Ad in Adorns do
								if Ad.Destroy then Ad:Destroy() end
							end
						end
						TableClear(TargetInfo.ChamAdornments)
					end

					CharacterObjects.Character = Character
					CharacterObjects.HumanoidRootPart = WaitForChild(Character, "HumanoidRootPart", 10)
					CharacterObjects.Humanoid = WaitForChild(Character, "Humanoid", 10)
					CharacterObjects.Children = CharacterHelper:GetChildren(Character)
					CharacterObjects.Descendants = CharacterHelper:GetDescendants(Character)

					TargetInfo.CachedBones = nil
					TargetInfo.SkeletonBones = nil
					TargetInfo.StructureDirty = true

					local Highlight = Objects["Highlight"]
					if Highlight then
						Highlight.Adornee = CharacterObjects.Character
					end
				end)

				if CharacterObjects.Character then
					ToolConnection.Added = AddConnection(CharacterObjects.Character.ChildAdded, function(Child)
						if IsA(Child, "Tool") then
							TargetInfo.CurrentTool = Child.Name
						end
						TargetInfo.StructureDirty = true
					end)

					ToolConnection.Removed = AddConnection(CharacterObjects.Character.ChildRemoved, function(Child)
						if IsA(Child, "Tool") then
							TargetInfo.CurrentTool = "none"
						end
						TargetInfo.StructureDirty = true
					end)
				end
			end

			if CharacterObjects.Character then
				Objects["Highlight"] = Utility.CreateObject("Highlight", {
					Parent = CharacterObjects.Character,
					Adornee = CharacterObjects.Character
				})
			end

			Objects["TargetHolder"] = Utility.CreateObject("Frame", {
				Parent = ESPHolder,
				Name = "\0",
				Size = UDim2New(0, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Objects["Snapline"] = Utility.CreateObject("Frame", {
				Parent = ESPHolder,
				Name = "\0",
				Size = UDim2New(0, 1, 0, 1),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0.5, 0.5),
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 0,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Objects["SnaplineStroke"] = Utility.CreateObject("UIStroke", {
				Parent = Objects["Snapline"],
				Name = "\0",
				Color = Color3FromRGB(0, 0, 0),
				Thickness = 1,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			Objects["TopTextContainer"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(1, 4, 0, 0),
				Position = UDim2New(0, -2, 0, -5),
				AnchorPoint = Vector2New(0, 1),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Objects["BottomTextContainer"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(1, 4, 0, 0),
				Position = UDim2New(0, -2, 1, 3),
				AnchorPoint = Vector2New(0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Objects["LeftTextContainer"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 1, 4),
				Position = UDim2New(0, -4, 0, -2),
				AnchorPoint = Vector2New(1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Objects["RightTextContainer"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 1, 4),
				Position = UDim2New(1, 8, 0, -2),
				AnchorPoint = Vector2New(0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Objects["TopTextHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["TopTextContainer"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDimNew(0, 0)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["TopTextContainer"],
				Name = "\0",
				PaddingBottom = UDimNew(0, 2)
			})

			Objects["LeftTextHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["LeftTextHolder"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDimNew(0, 0)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["LeftTextHolder"],
				Name = "\0",
				PaddingTop = UDimNew(0, 2)
			})

			Objects["RightTextHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["RightTextHolder"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDimNew(0, 0)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["RightTextHolder"],
				Name = "\0",
				PaddingTop = UDimNew(0, -3)
			})

			Objects["TopFlagsHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 2,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["TopFlagsHolder"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDimNew(0, 0)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["TopFlagsHolder"],
				Name = "\0",
				PaddingTop = UDimNew(0, -3)
			})

			Objects["BottomTextHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["BottomTextHolder"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDimNew(0, 1)
			})

			Objects["LeftBarHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["LeftBarHolder"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDimNew(0, 1)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["LeftBarHolder"],
				Name = "\0",
				PaddingTop = UDimNew(0, 2)
			})

			Objects["RightBarHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 1, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["RightBarHolder"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDimNew(0, 1)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["RightBarHolder"],
				Name = "\0",
				PaddingRight = UDimNew(0, 1)
			})

			Objects["TopBarHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 1, 0),
				Position = UDim2New(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["TopBarHolder"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDimNew(0, 1)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["TopBarHolder"],
				Name = "\0",
				PaddingLeft = UDimNew(0, -3)
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["BottomTextContainer"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDimNew(0, 3)
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["LeftTextContainer"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDimNew(0, 1)
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["LeftTextContainer"],
				Name = "\0",
				PaddingRight = UDimNew(0, 1)
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["RightTextContainer"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDimNew(0, 5)
			})

			Utility.CreateObject("UIListLayout", {
				Parent = Objects["RightTextContainer"],
				Name = "\0",
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDimNew(0, 2)
			})

			Objects["BoxGlow"] = Utility.CreateObject("ImageLabel", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 0, 0),
				Position = UDim2New(0, -21, 0, -21),
				Image = "rbxassetid://110204605000367",
				ImageColor3 = Color3FromRGB(255, 255, 255),
				ImageTransparency = 0.65,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79)),
				SliceScale = 1,
				ResampleMode = Enum.ResamplerMode.Pixelated,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = true
			})

			Objects["BoxGlowGradient"] = Utility.CreateObject("UIGradient", {
				Parent = Objects["BoxGlow"],
				Name = "\0",
				Rotation = 90,
				Color = ColorSequenceNew{
					ColorSequenceKeypointNew(0, Color3FromRGB(0, 0, 0)),
					ColorSequenceKeypointNew(1, Color3FromRGB(0, 0, 0))
				},
				Transparency = NumberSequenceNew{
					NumberSequenceKeypointNew(0, 0),
					NumberSequenceKeypointNew(1, 0)
				}
			})

			Utility.CreateObject("UIPadding", {
				Parent = Objects["BoxGlow"],
				Name = "\0",
				PaddingTop = UDimNew(0, 21),
				PaddingBottom = UDimNew(0, 20),
				PaddingLeft = UDimNew(0, 21),
				PaddingRight = UDimNew(0, 20)
			})

			Objects["BoxOutline"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Objects["BoxOutlineStroke"] = Utility.CreateObject("UIStroke", {
				Parent = Objects["BoxOutline"],
				Name = "\0",
				Thickness = 3,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			Objects["BoxOutlineGradient"] = Utility.CreateObject("UIGradient", {
				Parent = Objects["BoxOutline"],
				Name = "\0",
				Rotation = 90,
				Color = ColorSequenceNew{
					ColorSequenceKeypointNew(0, Color3FromRGB(0, 0, 0)),
					ColorSequenceKeypointNew(1, Color3FromRGB(0, 0, 0))
				},
				Transparency = NumberSequenceNew{
					NumberSequenceKeypointNew(0, 0),
					NumberSequenceKeypointNew(1, 0)
				}
			})

			Objects["BoxInline"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 0, 0),
				Position = UDim2New(0, -1, 0, -1),
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Objects["BoxInlineStroke"] = Utility.CreateObject("UIStroke", {
				Parent = Objects["BoxInline"],
				Name = "\0",
				Color = Color3FromRGB(255, 255, 255),
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			Objects["BoxInlineGradient"] = Utility.CreateObject("UIGradient", {
				Parent = Objects["BoxInline"],
				Name = "\0",
				Rotation = 90,
				Color = ColorSequenceNew{
					ColorSequenceKeypointNew(0, Color3FromRGB(0, 0, 0)),
					ColorSequenceKeypointNew(1, Color3FromRGB(255, 255, 255))
				},
				Transparency = NumberSequenceNew{
					NumberSequenceKeypointNew(0, 0),
					NumberSequenceKeypointNew(1, 0)
				}
			})

			Objects["BoxFill"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 0,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			Objects["BoxFillGradient"] = Utility.CreateObject("UIGradient", {
				Parent = Objects["BoxFill"],
				Name = "\0",
				Rotation = 90,
				Color = ColorSequenceNew{
					ColorSequenceKeypointNew(0, Color3FromRGB(0, 0, 0)),
					ColorSequenceKeypointNew(1, Color3FromRGB(255, 255, 255))
				},
				Transparency = NumberSequenceNew{
					NumberSequenceKeypointNew(0, 1),
					NumberSequenceKeypointNew(1, 1)
				}
			})

			Objects["CornerHolder"] = Utility.CreateObject("Frame", {
				Parent = Objects["TargetHolder"],
				Name = "\0",
				Size = UDim2New(0, 0, 0, 0),
				Position = UDim2New(0, -1, 0, -1),
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			local OutlineZIndex = 1
			local OutlineCount = 8

			for i = 1, OutlineCount do
				local outline = Utility.CreateObject("Frame", {
					Parent = Objects["CornerHolder"],
					Name = "\0",
					Size = UDim2New(0, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 0),
					ZIndex = OutlineZIndex + i,
					BackgroundColor3 = Color3FromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					BorderColor3 = Color3FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false
				})

				local outlineStroke = Utility.CreateObject("UIStroke", {
					Parent = outline,
					Name = "\0",
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				Objects[" Line " .. i] = outline
				Objects[" Line " .. i .. "Stroke"] = outlineStroke
			end

			local InlineZIndex = OutlineCount + 1

			for i = 1, OutlineCount do
				Objects[" Line " .. i .. " Fill"] = Utility.CreateObject("Frame", {
					Parent = Objects["CornerHolder"],
					Name = "\0",
					Size = UDim2New(0, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 0),
					ZIndex = InlineZIndex + i,
					BackgroundColor3 = Color3FromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					BorderColor3 = Color3FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false
				})
			end

			for BarName, Bar in PlayerSettings.Bars do
				Objects[BarName .. "BarHolder"] = Utility.CreateObject("Frame", {
					Parent = Objects["TargetHolder"],
					Name = "\0",
					Size = UDim2New(0, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3FromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = true
				})
			end

			for BarName, Bar in PlayerSettings.Bars do
				Objects[BarName .. "TextHolder"] = Utility.CreateObject("Frame", {
					Parent = Objects["TargetHolder"],
					Name = "\0",
					Size = UDim2New(0, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = Color3FromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = true
				})
			end

			for BarName, Bar in PlayerSettings.Bars do
				Objects[BarName .. "Outline"] = Utility.CreateObject("Frame", {
					Parent = Objects[BarName .. "BarHolder"],
					Name = "\0",
					Size = UDim2New(1, 0, 0, 1),
					Position = UDim2New(0, 0, 0, 0),
					LayoutOrder = 0,
					ZIndex = 5,
					BackgroundColor3 = Color3FromRGB(0, 0, 0),
					BackgroundTransparency = 0,
					BorderColor3 = Color3FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = true
				})

				Utility.CreateObject("UIStroke", {
					Parent = Objects[BarName .. "Outline"],
					Name = "\0",
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				Objects[BarName] = Utility.CreateObject("Frame", {
					Parent = Objects[BarName .. "Outline"],
					Name = "\0",
					Size = UDim2New(1, 0, 0, 1),
					Position = UDim2New(0, 0, 0, 0),
					LayoutOrder = 0,
					ZIndex = 6,
					BackgroundColor3 = Color3FromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					BorderColor3 = Color3FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = true
				})

				Objects[BarName .. "Gradient"] = Utility.CreateObject("UIGradient", {
					Parent = Objects[BarName],
					Name = "\0",
					Rotation = 90,
					Color = ColorSequenceNew{
						ColorSequenceKeypointNew(0, Color3FromRGB(0, 0, 0)),
						ColorSequenceKeypointNew(0, Color3FromRGB(0, 0, 0)),
						ColorSequenceKeypointNew(1, Color3FromRGB(255, 255, 255))
					},
					Transparency = NumberSequenceNew{
						NumberSequenceKeypointNew(0, 0),
						NumberSequenceKeypointNew(1, 0)
					}
				})

				Objects[BarName .. "Text"] = Utility.CreateObject("TextLabel", {
					Parent = Objects[BarName .. "TextHolder"],
					Name = "\0",
					Size = UDim2New(1, 0, 0, 0),
					Position = UDim2New(0, 0, 0, 0),
					AnchorPoint = Vector2New(0, 1),
					Text = "",
					TextColor3 = Color3FromRGB(255, 255, 255),
					TextTransparency = 0,
					TextSize = ESPFontSize,
					FontFace = ESPFont,
					LayoutOrder = 2,
					ZIndex = 5,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = Color3FromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					BorderColor3 = Color3FromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false
				})

				local BarTextStroke = Utility.CreateObject("UIStroke", {
					Parent = Objects[BarName .. "Text"],
					Name = "\0",
					Color = Color3FromRGB(0, 0, 0),
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				Objects[BarName .. "TextStroke"] = BarTextStroke
			end

			Objects["TargetName"] = Utility.CreateObject("TextLabel", {
				Parent = Objects["TopTextHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 1),
				Text = "",
				TextColor3 = Color3FromRGB(255, 255, 255),
				TextTransparency = 0,
				TextSize = ESPFontSize,
				FontFace = ESPFont,
				LayoutOrder = 2,
				ZIndex = 5,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			local NameStroke = Utility.CreateObject("UIStroke", {
				Parent = Objects["TargetName"],
				Name = "\0",
				Color = Color3FromRGB(0, 0, 0),
				Thickness = 1,
				LineJoinMode = Enum.LineJoinMode.Miter
			})
			Objects["TargetNameStroke"] = NameStroke

			Objects["Distance"] = Utility.CreateObject("TextLabel", {
				Parent = Objects["BottomTextHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 1),
				Text = "",
				TextColor3 = Color3FromRGB(255, 255, 255),
				TextTransparency = 0,
				TextSize = ESPFontSize,
				FontFace = ESPFont,
				LayoutOrder = 2,
				ZIndex = 5,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			local DistanceStroke = Utility.CreateObject("UIStroke", {
				Parent = Objects["Distance"],
				Name = "\0",
				Color = Color3FromRGB(0, 0, 0),
				Thickness = 1,
				LineJoinMode = Enum.LineJoinMode.Miter
			})
			Objects["DistanceStroke"] = DistanceStroke

			Objects["Flags"] = Utility.CreateObject("TextLabel", {
				Parent = Objects["RightTextHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 1),
				Text = "",
				TextColor3 = Color3FromRGB(255, 255, 255),
				TextTransparency = 0,
				TextSize = ESPFontSize,
				FontFace = ESPFont,
				LayoutOrder = 2,
				ZIndex = 5,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			local FlagsStroke = Utility.CreateObject("UIStroke", {
				Parent = Objects["Flags"],
				Name = "\0",
				Color = Color3FromRGB(0, 0, 0),
				LineJoinMode = Enum.LineJoinMode.Miter
			})
			Objects["FlagsStroke"] = FlagsStroke

			Objects["Weapon"] = Utility.CreateObject("TextLabel", {
				Parent = Objects["BottomTextHolder"],
				Name = "\0",
				Size = UDim2New(1, 0, 0, 0),
				Position = UDim2New(0, 0, 0, 0),
				AnchorPoint = Vector2New(0, 1),
				Text = "none",
				TextColor3 = Color3FromRGB(255, 255, 255),
				TextTransparency = 0,
				TextSize = ESPFontSize,
				FontFace = ESPFont,
				LayoutOrder = 2,
				ZIndex = 5,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3FromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				BorderColor3 = Color3FromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Visible = false
			})

			local WeaponStroke = Utility.CreateObject("UIStroke", {
				Parent = Objects["Weapon"],
				Name = "\0",
				Color = Color3FromRGB(0, 0, 0),
				Thickness = 1,
				LineJoinMode = Enum.LineJoinMode.Miter
			})
			Objects["WeaponStroke"] = WeaponStroke

			local SkeletonSettings = PlayerSettings.Skeleton

			if SkeletonSettings and SkeletonSettings.Enabled and IsPlayer and #TargetInfo.SkeletonLines == 0 then
				local OutlineEnabled = SkeletonSettings.Outline and SkeletonSettings.Outline.Enabled
				local OutlineThickness = OutlineEnabled and math.min(1, SkeletonSettings.Outline and SkeletonSettings.Outline.Thickness or 1) or 0
				local FillThickness = 1
				local FillColor = SkeletonSettings.Color or Color3FromRGB(255, 255, 255)
				local OutlineColor = OutlineEnabled and (SkeletonSettings.Outline.Color or Color3FromRGB(0, 0, 0)) or SkeletonSettings.Color

				for i = 1, 15 do
					local line = Utility.CreateObject("Frame", {
						Parent = ESPHolder,
						Name = "\0",
						Size = UDim2New(0, 1, 0, math.max(1, FillThickness)),
						Position = UDim2New(0, 0, 0, 0),
						AnchorPoint = Vector2New(0.5, 0.5),
						BackgroundColor3 = FillColor,
						BackgroundTransparency = SkeletonSettings.Transparency or 0,
						BorderSizePixel = 0,
						Visible = false
					})

					local Stroke = nil

					if OutlineEnabled and OutlineThickness > 0 then
						Stroke = Utility.CreateObject("UIStroke", {
							Parent = line,
							Name = "\0",
							Color = OutlineColor,
							Thickness = OutlineThickness,
							LineJoinMode = Enum.LineJoinMode.Miter
						})
					end
					TableInsert(TargetInfo.SkeletonLines, { line = line, Stroke = Stroke })
				end
			end
			Esp.Targets[Type][Target] = TargetInfo
		end

		function TargetInfo:Update()
			local Now = OsClock()
			local Throttled = (Now - LastTick) < (1 / PlayerSettings.RefreshRate)

			if Throttled then
				local FrameDt = 1 / 60

				if IsPlayer then
					local DefFill, DefGrad = Animation.GetDefaults()

					for BarName, BarInfo in PlayerSettings.Bars do
						if not BarInfo.Enabled or not BarInfo.Animation or BarInfo.Animation == "" then continue end

						local AnimCfg = type(BarInfo.Animation) == "table" and BarInfo.Animation or {}
						local GradSpeed = AnimCfg.GradientSpeed or DefGrad
						local BarGradientTime = TargetInfo.BarGradientTime

						BarGradientTime[BarName] = (BarGradientTime[BarName] or 0) + FrameDt * GradSpeed

						local BarGradient = Objects[BarName .. "Gradient"]
						if BarGradient and BarGradient.Parent then
							BarGradient.Color = Animation.GetGradientColors(BarInfo.Color, true, BarGradientTime[BarName], GradSpeed)
						end
					end
				end

				local BoxAnimRaw = PlayerSettings.BoundingBox.Animation

				if PlayerSettings.BoundingBox.Enabled and BoxAnimRaw and BoxAnimRaw ~= "" then
					local BoxAnim = BoxAnimRaw
					local BoxAnimSpeed = (type(BoxAnim) == "table" and BoxAnim.AnimationSpeed) or PlayerSettings.BoundingBox.AnimationSpeed or 1.2

					TargetInfo.BoxGradientTime = (TargetInfo.BoxGradientTime or 0) + FrameDt * BoxAnimSpeed

					local TimeValue = TargetInfo.BoxGradientTime or 0
					local IsVortex = BoxAnim == "Vortex"
					local VortexRotation = IsVortex and Animation.GetVortexRotation(TimeValue, BoxAnimSpeed) or 0
					local BoxGlowGradient = Objects["BoxGlowGradient"]

					if BoxGlowGradient and PlayerSettings.BoundingBox.Glow.Enabled then
						BoxGlowGradient.Color = Animation.GetGradientColors2(PlayerSettings.BoundingBox.Glow.Color, BoxAnim, TimeValue, BoxAnimSpeed)
						if IsVortex then BoxGlowGradient.Rotation = (PlayerSettings.BoundingBox.Glow.Rotation or 90) + VortexRotation end
					end

					local BoxInlineGradient = Objects["BoxInlineGradient"]
					local BoxOutlineGradient = Objects["BoxOutlineGradient"]

					if BoxInlineGradient then
						BoxInlineGradient.Color = Animation.GetGradientColors2(PlayerSettings.BoundingBox.Color, BoxAnim, TimeValue, BoxAnimSpeed)
						if IsVortex then BoxInlineGradient.Rotation = (PlayerSettings.BoundingBox.Rotation or 90) + VortexRotation end
					end

					if BoxOutlineGradient then
						BoxOutlineGradient.Color = Animation.GetGradientColors2(PlayerSettings.BoundingBox.Color, BoxAnim, TimeValue, BoxAnimSpeed)
						if IsVortex then BoxOutlineGradient.Rotation = (PlayerSettings.BoundingBox.Rotation or 90) + VortexRotation end
					end

					local BoxFillGradient = Objects["BoxFillGradient"]

					if BoxFillGradient and PlayerSettings.BoundingBox.Fill.Enabled then
						BoxFillGradient.Color = Animation.GetGradientColors2(PlayerSettings.BoundingBox.Fill.Color, BoxAnim, TimeValue, BoxAnimSpeed)
						if IsVortex then BoxFillGradient.Rotation = (PlayerSettings.BoundingBox.Fill.Rotation or 90) + VortexRotation end
					end
				end
				return
			end

			if not CharacterObjects.Children then return end
			if not CharacterObjects.Descendants then return end

			local Delta = OsClock() - LastTick
			LastTick = OsClock()

			Objects["TargetHolder"].Visible = false
			Objects["Snapline"].Visible = false
			Objects["Highlight"].Enabled = false

			if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end

			if (not PlayerSettings.LocalPlayer) and Target == Client then
				Objects["Snapline"].Visible = false

				if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
				if Objects["ChinaHat"] then Objects["ChinaHat"]:Destroy() end
				if Objects["ChinaHatWeld"] then Objects["ChinaHatWeld"]:Destroy() end
			end

			if IsPlayer and not PlayerSettings.Enabled then return end
			if IsPlayer and not ShouldShowTarget(Client, Target, PlayerSettings) then return end
			if not CharacterObjects.Character then return end

			if not CharacterObjects.Character.Parent then
				Objects["TargetHolder"].Visible = false
				Objects["Snapline"].Visible = false
				Objects["Highlight"].Enabled = false

				if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
				if Objects["ChinaHat"] then Objects["ChinaHat"]:Destroy() end
				if Objects["ChinaHatWeld"] then Objects["ChinaHatWeld"]:Destroy() end
				return
			end

			if IsPlayer then
				if not CharacterObjects.HumanoidRootPart then
					if CharacterObjects.Character then
						CharacterObjects.HumanoidRootPart = FindFirstChild(CharacterObjects.Character, "HumanoidRootPart")
					end

					if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
					return
				end

				if not CharacterObjects.Humanoid then
					if CharacterObjects.Character then
						CharacterObjects.Humanoid = FindFirstChildWhichIsA(CharacterObjects.Character, "Humanoid")
					end

					if not CharacterObjects.Humanoid then
						if Objects["ChinaHat"] then Objects["ChinaHat"]:Destroy() end
						if Objects["ChinaHatWeld"] then Objects["ChinaHatWeld"]:Destroy() end
						return
					end
				end

				local Humanoid = CharacterObjects.Humanoid
				local IsDead = (Humanoid.Health ~= nil and Humanoid.Health <= 0)

				if not IsDead then
					local Success, Result = pcall(function() return Humanoid:GetState() end)
					if Success and Result == Enum.HumanoidStateType.Dead then IsDead = true end
				end

				if IsDead then
					Objects["TargetHolder"].Visible = false
					Objects["Snapline"].Visible = false
					Objects["Highlight"].Enabled = false

					if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
					if Objects["ChinaHat"] then Objects["ChinaHat"]:Destroy() end
					if Objects["ChinaHatWeld"] then Objects["ChinaHatWeld"]:Destroy() end
					return
				end
			else
				if not CharacterObjects.HumanoidRootPart then
					if IsA(Target, "BasePart") then
						CharacterObjects.HumanoidRootPart = Target
					elseif CharacterObjects.Character and CharacterObjects.Character.PrimaryPart then
						CharacterObjects.HumanoidRootPart = CharacterObjects.Character.PrimaryPart
					end

					if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
					return
				end
			end

			local MaxDistSq = PlayerSettings.MaxDistance * PlayerSettings.MaxDistance
			local ToRoot = CameraPosCache.value - CharacterObjects.HumanoidRootPart.Position
			local DistSqToRoot = ToRoot.X * ToRoot.X + ToRoot.Y * ToRoot.Y + ToRoot.Z * ToRoot.Z

			if DistSqToRoot > MaxDistSq then
				if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
				return
			end

			if TargetInfo.StructureDirty then
				CharacterObjects.Children = CharacterHelper:GetChildren(CharacterObjects.Character)
				CharacterObjects.Descendants = CharacterHelper:GetDescendants(CharacterObjects.Character)
				TargetInfo.StructureDirty = nil
			end

			local BodyParts = PlayerSettings.BoundingBox.IncludeAccessories and CharacterObjects.Descendants or CharacterObjects.Children
			local RootPos = CharacterObjects.HumanoidRootPart.Position
			local _, RootOnScreen = WorldToViewportPoint(Camera, RootPos)

			if not RootOnScreen then
				Objects["TargetHolder"].Visible = false
				Objects["Snapline"].Visible = false
				Objects["Highlight"].Enabled = false

				if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
				return
			end

			local BoxWidth, BoxHeight, BoxPositionX, BoxPositionY, OnScreen = CalculateBox(PlayerSettings, Target, CharacterObjects.HumanoidRootPart, IsBasePart and {Target} or BodyParts)

			if not OnScreen then
				Objects["TargetHolder"].Visible = false
				Objects["Snapline"].Visible = false
				Objects["Highlight"].Enabled = false

				if TargetInfo.SkeletonLines then for _, b in TargetInfo.SkeletonLines do b.line.Visible = false end end
				return
			end

			local VisibilityCheck = PlayerSettings.VisibilityCheck
			local TargetVisible = (not VisibilityCheck or not VisibilityCheck.Enabled) or IsPointVisible(CharacterObjects.HumanoidRootPart.Position, CharacterObjects.Character)
			local VisibilityColor = (VisibilityCheck and VisibilityCheck.Enabled) and (TargetVisible and VisibilityCheck.VisibleColor or VisibilityCheck.OccludedColor) or nil

			if PlayerSettings.LocalPlayer or Target ~= Client then
				local BoxSize = UDim2FromOffset(MathFloor(BoxWidth), MathFloor(BoxHeight))
				local BoxPosition = UDim2FromOffset(MathFloor(BoxPositionX), MathFloor(BoxPositionY))
				local TargetHolder = Objects["TargetHolder"]

				TargetHolder.Visible = true

				if TargetHolder.Position ~= BoxPosition then TargetHolder.Position = BoxPosition end
				if TargetHolder.Size ~= BoxSize then TargetHolder.Size = BoxSize end

				local SnaplineCfg = PlayerSettings.Snapline
				local SnaplineFrame = Objects["Snapline"]

				if Target == Client then
					SnaplineFrame.Visible = false
				elseif SnaplineCfg.Enabled and SnaplineCfg.Thickness > 0 then
					local ViewportX, ViewportY = ViewportCache.value.X, ViewportCache.value.Y
					local OriginX, OriginY

					if SnaplineCfg.Origin == "Top" then
						OriginX, OriginY = ViewportX * 0.5, 0
					elseif SnaplineCfg.Origin == "Center" then
						OriginX, OriginY = ViewportX * 0.5, ViewportY * 0.5
					else
						OriginX, OriginY = ViewportX * 0.5, ViewportY
					end

					local RootPos = CharacterObjects.HumanoidRootPart.Position
					local FeetScreen = WorldToViewportPoint(Camera, RootPos)
					local EndX, EndY = FeetScreen.X, FeetScreen.Y
					local DeltaX, DeltaY = EndX - OriginX, EndY - OriginY
					local Length = MathFloor(math.sqrt(DeltaX * DeltaX + DeltaY * DeltaY))

					if Length > 1 then
						local Angle = MathDeg(math.atan2(DeltaY, DeltaX))
						local MidX = MathFloor((OriginX + EndX) * 0.5)
						local MidY = MathFloor((OriginY + EndY) * 0.5)

						SnaplineFrame.Visible = true
						SnaplineFrame.Position = UDim2FromOffset(MidX, MidY)
						SnaplineFrame.Size = UDim2FromOffset(Length, math.max(1, MathFloor(SnaplineCfg.Thickness)))
						SnaplineFrame.Rotation = Angle
						SnaplineFrame.BackgroundColor3 = VisibilityColor or SnaplineCfg.Color
						SnaplineFrame.BackgroundTransparency = SnaplineCfg.Transparency

						local Outline = SnaplineCfg.Outline
						local Stroke = Objects["SnaplineStroke"]

						if Stroke and Outline and Outline.Enabled then
							Stroke.Enabled = true
							Stroke.Color = VisibilityColor or Outline.Color
							Stroke.Thickness = Outline.Thickness
						elseif Stroke then
							Stroke.Enabled = false
						end
					else
						SnaplineFrame.Visible = false
					end
				else
					SnaplineFrame.Visible = false
				end

				local SkeletonSettings = PlayerSettings.Skeleton
				local SkeletonLines = TargetInfo.SkeletonLines

				if SkeletonSettings and SkeletonSettings.Enabled and IsPlayer and SkeletonLines and #SkeletonLines > 0 and CharacterObjects.Character then
					local Character = CharacterObjects.Character

					if not TargetInfo.SkeletonBones then
						TargetInfo.SkeletonBones = Character:FindFirstChild("UpperTorso") and BonesR15 or BonesR6
					end

					local Bones = TargetInfo.SkeletonBones
					if not TargetInfo.CachedBones then
						local Cached = {}

						for i = 1, #Bones do
							local Pair = Bones[i]
							local PartA = Character:FindFirstChild(Pair[1])
							local PartB = Character:FindFirstChild(Pair[2])

							if PartA and PartB and PartA:IsA("BasePart") and PartB:IsA("BasePart") then
								TableInsert(Cached, { PartA, PartB })
							else
								TableInsert(Cached, {})
							end
						end
						TargetInfo.CachedBones = Cached
					end

					local CachedBonesData = TargetInfo.CachedBones
					local OutlineEnabled = SkeletonSettings.Outline and SkeletonSettings.Outline.Enabled
					local FillThickness = 1
					local OutlineThickness = OutlineEnabled and math.min(1, SkeletonSettings.Outline and SkeletonSettings.Outline.Thickness or 1) or 0
					local UseVisibility = VisibilityCheck and VisibilityCheck.Enabled
					local FillColor = SkeletonSettings.Color or Color3FromRGB(255, 255, 255)
					local OutlineColor = OutlineEnabled and (SkeletonSettings.Outline.Color or Color3FromRGB(0, 0, 0)) or FillColor
					local SkeletonColor = UseVisibility and (VisibilityColor or FillColor) or FillColor

					for i = 1, #CachedBonesData do
						local BoneParts = CachedBonesData[i]
						local BoneLines = SkeletonLines[i]

						if not BoneLines then continue end
						if not BoneParts[1] or not BoneParts[2] then
							BoneLines.line.Visible = false
						else
							local PartA, PartB = BoneParts[1], BoneParts[2]
							local PosA, OnA = WorldToViewportPoint(Camera, PartA.Position)
							local PosB, OnB = WorldToViewportPoint(Camera, PartB.Position)
							local Show = (Target == Client) or (OnA and OnB)

							if Show then
								local StartX, StartY = PosA.X, PosA.Y
								local EndX, EndY = PosB.X, PosB.Y
								local DeltaX, DeltaY = EndX - StartX, EndY - StartY
								local LineLength = MathFloor(math.sqrt(DeltaX * DeltaX + DeltaY * DeltaY))

								if LineLength >= 1 then
									local MidX = MathFloor((StartX + EndX) * 0.5)
									local MidY = MathFloor((StartY + EndY) * 0.5)
									local Angle = MathDeg(math.atan2(DeltaY, DeltaX))

									BoneLines.line.Position = UDim2FromOffset(MidX, MidY)
									BoneLines.line.Size = UDim2FromOffset(LineLength, FillThickness)
									BoneLines.line.Rotation = Angle
									BoneLines.line.BackgroundColor3 = UseVisibility and SkeletonColor or FillColor

									local Stroke = BoneLines.Stroke
									if Stroke then Stroke.Color = UseVisibility and SkeletonColor or OutlineColor end

									BoneLines.line.Visible = true
								else
									BoneLines.line.Visible = false
								end
							else
								BoneLines.line.Visible = false
							end
						end
					end
					for i = #CachedBonesData + 1, #SkeletonLines do
						local BoneLines = SkeletonLines[i]
						if BoneLines then BoneLines.line.Visible = false end
					end
				elseif SkeletonLines then
					for _, BoneLines in SkeletonLines do
						if BoneLines then BoneLines.line.Visible = false end
					end
				end

				local BoxOutline, BoxInline, BoxFill, BoxGlow = Objects["BoxOutline"], Objects["BoxInline"], Objects["BoxFill"], Objects["BoxGlow"]
				local BoxEnabled, BoxColor, BoxTransparency, BoxRotation, BoxType = PlayerSettings.BoundingBox.Enabled, PlayerSettings.BoundingBox.Color, PlayerSettings.BoundingBox.Transparency, PlayerSettings.BoundingBox.Rotation, PlayerSettings.BoundingBox.Type
				local BoxAnim = PlayerSettings.BoundingBox.Animation

				if BoxAnim == "" then BoxAnim = false end

				local BoxAnimSpeed = (type(BoxAnim) == "table" and BoxAnim.AnimationSpeed) or PlayerSettings.BoundingBox.AnimationSpeed or 1.2
				if BoxEnabled and BoxAnim then
					TargetInfo.BoxGradientTime = (TargetInfo.BoxGradientTime or 0) + Delta * BoxAnimSpeed
				end

				local IsVortex = BoxAnim == "Vortex"
				local VortexRotation = IsVortex and Animation.GetVortexRotation(TargetInfo.BoxGradientTime or 0, BoxAnimSpeed) or 0

				if BoxEnabled then
					local BoxGlowGradient = Objects["BoxGlowGradient"]
					local GlowEnabled, GlowColor, GlowTransparency, GlowRotation = PlayerSettings.BoundingBox.Glow.Enabled, PlayerSettings.BoundingBox.Glow.Color, PlayerSettings.BoundingBox.Glow.Transparency, PlayerSettings.BoundingBox.Glow.Rotation

					if GlowEnabled then
						BoxGlow.ImageTransparency = 0
						BoxGlowGradient.Rotation = GlowRotation + VortexRotation
						BoxGlowGradient.Color = Animation.GetGradientColors2(GlowColor, BoxAnim, TargetInfo.BoxGradientTime or 0, BoxAnimSpeed)
						BoxGlowGradient.Transparency = NumberSequenceNew{NumberSequenceKeypointNew(0, GlowTransparency[1]), NumberSequenceKeypointNew(1, GlowTransparency[2])}
					else
						BoxGlow.ImageTransparency = 1
					end

					if BoxType == "2D" then
						BoxOutline.Parent.Visible = true
						BoxOutline.Parent.Size = UDim2FromOffset(BoxWidth, BoxHeight)
						BoxInline.Parent.Visible = true
						BoxInline.Parent.Size = UDim2FromOffset(BoxWidth + 2, BoxHeight + 2)

						local BoxInlineGradient, BoxOutlineGradient = Objects["BoxInlineGradient"], Objects["BoxOutlineGradient"]
						local OutlineColorSeq = VisibilityColor and ColorSequenceNew{ColorSequenceKeypointNew(0, VisibilityColor), ColorSequenceKeypointNew(1, VisibilityColor)} or Animation.GetGradientColors2(BoxColor, BoxAnim, TargetInfo.BoxGradientTime or 0, BoxAnimSpeed)

						BoxInlineGradient.Color = OutlineColorSeq
						BoxOutlineGradient.Color = OutlineColorSeq
						BoxInlineGradient.Transparency = NumberSequenceNew{NumberSequenceKeypointNew(0, BoxTransparency[1]), NumberSequenceKeypointNew(1, BoxTransparency[2])}
						BoxOutlineGradient.Transparency = NumberSequenceNew{NumberSequenceKeypointNew(0, BoxTransparency[1]), NumberSequenceKeypointNew(1, BoxTransparency[2])}
						BoxInlineGradient.Rotation = BoxRotation + VortexRotation
						BoxOutlineGradient.Rotation = BoxRotation + VortexRotation

						local BoxFillGradient = Objects["BoxFillGradient"]
						local FillColor, FillTransparency, FillRotation = PlayerSettings.BoundingBox.Fill.Color, PlayerSettings.BoundingBox.Fill.Transparency, PlayerSettings.BoundingBox.Fill.Rotation

						BoxFill.Visible = PlayerSettings.BoundingBox.Fill.Enabled
						BoxFill.Size = UDim2FromOffset(BoxWidth, BoxHeight)
						BoxFillGradient.Rotation = FillRotation + VortexRotation
						BoxFillGradient.Color = VisibilityColor and ColorSequenceNew{ColorSequenceKeypointNew(0, VisibilityColor), ColorSequenceKeypointNew(1, VisibilityColor)} or Animation.GetGradientColors2(FillColor, BoxAnim, TargetInfo.BoxGradientTime or 0, BoxAnimSpeed)
						BoxFillGradient.Transparency = NumberSequenceNew{NumberSequenceKeypointNew(0, FillTransparency[1]), NumberSequenceKeypointNew(1, FillTransparency[2])}
					else
						local CornerHolder = Objects["CornerHolder"]
						CornerHolder.Visible = true
						CornerHolder.Size = UDim2FromOffset(BoxWidth + 2, BoxHeight + 2)

						for i = 1, 8 do
							local Line = Objects[" Line " .. i]
							local LineFill = Objects[" Line " .. i .. " Fill"]
							local Stroke = Objects[" Line " .. i .. "Stroke"]
							local LayoutPosition = CornerLayout[i]
							local Position, Size, AnchorPoint, Rotation = LayoutPosition[1], LayoutPosition[2], LayoutPosition[3], LayoutPosition[4]

							if Stroke then Stroke.Transparency = BoxTransparency[1] end

							Line.Position = Position
							Line.Rotation = Rotation
							Line.BackgroundColor3 = VisibilityColor or BoxColor[1]
							Line.BackgroundTransparency = BoxTransparency[1]
							Line.Size = Size
							Line.AnchorPoint = AnchorPoint
							Line.Visible = true
							LineFill.Position = Position
							LineFill.Rotation = Rotation
							LineFill.BackgroundColor3 = VisibilityColor or BoxColor[1]
							LineFill.BackgroundTransparency = BoxTransparency[1]
							LineFill.Size = Size
							LineFill.AnchorPoint = AnchorPoint
							LineFill.Visible = true
						end
					end
				else
					BoxGlow.ImageTransparency = 1
					BoxOutline.Parent.Visible = false
					BoxInline.Parent.Visible = false
					BoxFill.Visible = false

					for i = 1, 8 do
						Objects[" Line " .. i].Visible = false
						if Objects[" Line " .. i .. " Fill"] then Objects[" Line " .. i .. " Fill"].Visible = false end
					end
				end

				for BarName, BarInfo in PlayerSettings.Bars do
					local Bar, BarOutline, BarGradient = Objects[BarName], Objects[BarName .. "Outline"], Objects[BarName .. "Gradient"]
					local BarEnabled, BarColor = BarInfo.Enabled, BarInfo.Color
					local NewParent = Objects[BarName .. "BarHolder"]

					if BarEnabled and IsPlayer then
						local TargetValue = BarInfo.Type(Target, CharacterObjects)

						if TargetValue == nil then
							NewParent.Visible = false
						else
							local BarAnim = BarInfo.Animation
							if BarAnim == "" then BarAnim = false end

							local AnimCfg = type(BarInfo.Animation) == "table" and BarInfo.Animation or {}
							local DefFill, DefGrad = Animation.GetDefaults()
							local FillSpeed = BarAnim and (AnimCfg.BarFillSpeed or DefFill) or 0
							local GradSpeed = AnimCfg.GradientSpeed or DefGrad
							local AnimatedBars = TargetInfo.AnimatedBars
							local BarGradientTime = TargetInfo.BarGradientTime

							AnimatedBars[BarName] = Animation.LerpNumber(AnimatedBars[BarName] or TargetValue, TargetValue, FillSpeed, Delta)
							BarGradientTime[BarName] = (BarGradientTime[BarName] or 0) + Delta * GradSpeed

							local BarValue = AnimatedBars[BarName]

							if not TargetInfo.BarSizes then
								TargetInfo.BarSizes = {
									["Top"] = UDim2New(0, 0, 0, 1),
									["Bottom"] = UDim2New(0, 0, 0, 1),
									["Left"] = UDim2New(0, 1, 0, 0),
									["Right"] = UDim2New(0, 1, 0, 0),
								}
								TargetInfo.OutlineSizes = {
									["Top"] = UDim2New(1, 0, 0, 1),
									["Bottom"] = UDim2New(1, 0, 0, 1),
									["Left"] = UDim2New(0, 1, 1, 0),
									["Right"] = UDim2New(0, 1, 1, 0),
								}
								TargetInfo.GradientRotations = {
									["Top"] = { -180, Vector2New(0, 0) },
									["Bottom"] = { -180, Vector2New(0, 0) },
									["Left"] = { 90, Vector2New(0, 0) },
									["Right"] = { 90, Vector2New(0, 0) },
								}
								TargetInfo.BarPositions = {
									["Top"] = {Vector2New(0, 0), UDim2New(0, 0, 0, 0)},
									["Bottom"] = {Vector2New(0, 0), UDim2New(0, 0, 0, 0)},
									["Left"] = {Vector2New(0, 1), UDim2New(0, 0, 1, 0)},
									["Right"] = {Vector2New(0, 1), UDim2New(0, 0, 1, 0)},
								}
							end

							local BarSizes = TargetInfo.BarSizes
							BarSizes["Top"] = UDim2New(BarValue, 0, 0, 1)
							BarSizes["Bottom"] = UDim2New(BarValue, 0, 0, 1)
							BarSizes["Left"] = UDim2New(0, 1, BarValue, 0)
							BarSizes["Right"] = UDim2New(0, 1, BarValue, 0)

							local BaseRot = ({ ["Top"] = -180, ["Bottom"] = -180, ["Left"] = 90, ["Right"] = 90 })[BarInfo.Position]

							local GradientRotations = TargetInfo.GradientRotations
							GradientRotations["Top"] = { BaseRot, Vector2New(1 - BarValue, 0) }
							GradientRotations["Bottom"] = { BaseRot, Vector2New(1 - BarValue, 0) }
							GradientRotations["Left"] = { BaseRot, Vector2New(0, BarValue - 1) }
							GradientRotations["Right"] = { BaseRot, Vector2New(0, BarValue - 1) }
							NewParent.Visible = true

							local BarPositions = TargetInfo.BarPositions
							local OutlineSizes = TargetInfo.OutlineSizes

							Bar.AnchorPoint = BarPositions[BarInfo.Position][1]
							Bar.Position = BarPositions[BarInfo.Position][2]
							Bar.Size = BarSizes[BarInfo.Position]
							BarOutline.Parent = NewParent
							BarOutline.Size = OutlineSizes[BarInfo.Position]
							BarGradient.Rotation = GradientRotations[BarInfo.Position][1]
							BarGradient.Offset = GradientRotations[BarInfo.Position][2]
							BarGradient.Color = VisibilityColor and ColorSequenceNew{ColorSequenceKeypointNew(0, VisibilityColor), ColorSequenceKeypointNew(1, VisibilityColor)} or Animation.GetGradientColors(BarColor, BarAnim, BarGradientTime[BarName], GradSpeed)
						end
					else
						NewParent.Visible = false
					end

					local BarText = Objects[BarName .. "Text"]
					local BarTextEnabled, BarTextColor, BarTextTransparency = BarInfo.Text.Enabled, BarInfo.Text.Color, BarInfo.Text.Transparency
					local AnchorPoints = {
						["Top"] = Vector2New(0, 0.5),
						["Bottom"] = Vector2New(0, 0.5),
						["Left"] = Vector2New(0.5, 0),
						["Right"] = Vector2New(0.5, 0),
					}
					local Alignments = {
						["Top"] = Enum.TextXAlignment.Right,
						["Bottom"] = Enum.TextXAlignment.Right,
						["Left"] = Enum.TextXAlignment.Center,
						["Right"] = Enum.TextXAlignment.Center,
					}

					if BarTextEnabled and IsPlayer then
						local TextValue, TextVisible = BarInfo.Text.Type(Target, CharacterObjects)
						BarText.Text = tostring(MathFloor(TextValue)) .. BarInfo.Text.Ending
						BarText.TextColor3 = VisibilityColor or BarTextColor
						BarText.TextTransparency = BarTextTransparency
						local BarTextStroke = Objects[BarName .. "TextStroke"]
						if BarTextStroke then BarTextStroke.Transparency = BarTextTransparency end

						if BarInfo.Text.FollowBar then
							BarText.Visible = TextVisible
							BarText.Parent = Bar
							BarText.ZIndex = 10
							BarText.TextXAlignment = Alignments[BarInfo.Position]
							BarText.AnchorPoint = AnchorPoints[BarInfo.Position]
						else
							BarText.Visible = true
							BarText.Parent = Objects[BarName .. "TextHolder"]
							BarText.TextXAlignment = TextAlignments[BarInfo.Text.Position]
							BarText.AnchorPoint = Vector2New(0, 0)
						end
					else
						BarText.Visible = false
					end
				end

				local Chams = Objects["Highlight"]
				local ChamsEnabled, ChamsFill, ChamsOutline = PlayerSettings.Chams.Enabled, PlayerSettings.Chams.Fill, PlayerSettings.Chams.Outline
				local Glow = PlayerSettings.Chams.Glow
				local ChamAdornments = TargetInfo.ChamAdornments

				if ChamsEnabled and Target ~= Client then
					Chams.Enabled = false

					local Character = CharacterObjects.Character
					if Character and (not IsPlayer or CharacterObjects.HumanoidRootPart) then
						for Part, Adorns in ChamAdornments do
							for _, Ad in Adorns do
								if Ad.Destroy then 
									Ad:Destroy()
								end
							end
						end

						TableClear(ChamAdornments)

						local MainColor = VisibilityColor or ChamsFill[1]
						local GlowColor = VisibilityColor or (Glow and Glow.Color or ChamsFill[1])
						local MainTrans = PlayerSettings.Chams.AdornmentTransparency or 0.5
						local XRayShaded = Enum.AdornShading.XRayShaded

						for _, Part in GetChildren(Character) do
							if IsA(Part, "BasePart") and Part.Transparency < 1 then
								RemoveChamAdornments(Part)

								local PartColor = MainColor

								if VisibilityCheck and VisibilityCheck.Enabled then
									local PartVisible = IsPointVisible(Part.Position, Character)

									PartColor = PartVisible and VisibilityCheck.VisibleColor or VisibilityCheck.OccludedColor
								end

								local GlowPartColor = PartColor
								local IsHead = Part.Name == "Head" or Part.Name == "FakeHead"
								local SizeOffset = Vector3New(0.03, 0.03, 0.03)
								local GlowAd = CreateChamAdornment(Part, IsHead and "Cylinder" or "Box", Color3New(GlowPartColor.R * 5, GlowPartColor.G * 5, GlowPartColor.B * 5), -1, IsHead and 10 or 9, SizeOffset, { Shading = XRayShaded })
								local MainAd = CreateChamAdornment(Part, IsHead and "Cylinder" or "Box", PartColor, MainTrans, 10, Vector3New(0.02, 0.02, 0.02))

								ChamAdornments[Part] = { GlowAd, MainAd }
							end
						end
					end
				else
					if ChamAdornments then
						for Part, Adorns in ChamAdornments do
							for _, Ad in Adorns do
								if Ad.Destroy then Ad:Destroy() end
							end
						end
						TableClear(ChamAdornments)
					end

					local Character = CharacterObjects.Character
					if Character then
						for _, Part in GetChildren(Character) do
							if IsA(Part, "BasePart") then RemoveChamAdornments(Part) end
						end
					end

					if ChamsEnabled and Target ~= Client then
						Chams.Enabled = true
						Chams.DepthMode = PlayerSettings.Chams.DepthMode
						Chams.FillColor = VisibilityColor or ChamsFill[1]
						Chams.FillTransparency = ChamsFill[2]
						Chams.OutlineColor = VisibilityColor or ChamsOutline[1]
						Chams.OutlineTransparency = ChamsOutline[2]
					else
						Chams.Enabled = false
					end
				end

				local NameText = Objects["TargetName"]
				local NameEnabled, NameColor, NameTransparency = PlayerSettings.Name.Enabled, PlayerSettings.Name.Color, PlayerSettings.Name.Transparency

				if NameEnabled then
					local TargetName = PlayerSettings.Name.UseDisplay and IsPlayer and Target.DisplayName or Target.Name
					NameText.Visible = true
					NameText.Text = GetFontType(PlayerSettings, TargetName)
					NameText.TextColor3 = NameColor
					NameText.TextTransparency = NameTransparency
					local NameStroke = Objects["TargetNameStroke"]
					if NameStroke then NameStroke.Transparency = NameTransparency end
				else
					NameText.Visible = false
				end

				local DistanceText = Objects["Distance"]
				local DistanceEnabled, DistanceColor, DistanceTransparency = PlayerSettings.Distance.Enabled, PlayerSettings.Distance.Color, PlayerSettings.Distance.Transparency

				if DistanceEnabled then
					local DistForDisplay = (CameraPosCache.value - CharacterObjects.HumanoidRootPart.Position).Magnitude
					DistanceText.Visible = true
					DistanceText.TextColor3 = DistanceColor
					DistanceText.TextTransparency = DistanceTransparency
					local DistanceStroke = Objects["DistanceStroke"]
					if DistanceStroke then DistanceStroke.Transparency = DistanceTransparency end
					DistanceText.Text = GetFontType(PlayerSettings, tostring(MathFloor(DistForDisplay)) .. PlayerSettings.Distance.Ending)
				else
					DistanceText.Visible = false
				end

				local WeaponText = Objects["Weapon"]
				local WeaponEnabled, WeaponColor, WeaponTransparency = PlayerSettings.Weapon.Enabled, PlayerSettings.Weapon.Color, PlayerSettings.Weapon.Transparency

				if IsPlayer and WeaponEnabled then
					local Tool = CharacterHelper:GetTool(Target) or TargetInfo.CurrentTool
					WeaponText.Visible = true
					WeaponText.TextColor3 = VisibilityColor or WeaponColor
					WeaponText.TextTransparency = WeaponTransparency
					local WeaponStroke = Objects["WeaponStroke"]
					if WeaponStroke then WeaponStroke.Transparency = WeaponTransparency end
					WeaponText.Text = GetFontType(PlayerSettings, Tool)
				else
					WeaponText.Visible = false
				end

				local FlagsText = Objects["Flags"]
				local FlagsEnabled, FlagsColor, FlagsTransparency = PlayerSettings.Flags.Enabled, PlayerSettings.Flags.Color, PlayerSettings.Flags.Transparency
				local DeadColor = PlayerSettings.Flags.DeadColor or Color3FromRGB(255, 60, 60)
				local FriendColor = PlayerSettings.Flags.FriendColor or Color3FromRGB(80, 255, 80)

				if FlagsEnabled then
					if (Now - (TargetInfo.CachedFlagsTick or 0)) >= 0.2 then
						TargetInfo.CachedFlags = PlayerSettings.Flags.Type(Target, CharacterObjects)
						TargetInfo.CachedFlagsTick = Now
					end

					local Flags = TargetInfo.CachedFlags or {}
					FlagsText.Visible = true

					local HasDead = TableFind(Flags, "Dead") ~= nil
					local HasFriend = TableFind(Flags, "Friend") ~= nil

					FlagsText.TextColor3 = HasDead and DeadColor or (HasFriend and FriendColor or FlagsColor)
					FlagsText.TextTransparency = FlagsTransparency
					local FlagsStroke = Objects["FlagsStroke"]
					if FlagsStroke then FlagsStroke.Transparency = FlagsTransparency end
					FlagsText.Text = TableConcat(Flags, "\n")
				else
					FlagsText.Visible = false
				end

				local TrailSettings = PlayerSettings.Trail
				if TrailSettings and TrailSettings.Enabled and IsPlayer and Target == Client and CharacterObjects.HumanoidRootPart then
					local function GetTrailPart()
						local Root = CharacterObjects.HumanoidRootPart
						if not Root or not Root.Parent then return nil end

						local Origin = TrailSettings.Origin or "Root"
						if Origin == "Feet" then
							local Char = Root.Parent
							if not Char or not IsA(Char, "Model") then return nil end

							local GroundPart = Objects["TrailGroundPart"]
							local GroundWeld = Objects["TrailGroundWeld"]

							if GroundPart and GroundPart.Parent == Char and GroundWeld and GroundWeld.Parent then
								return GroundPart
							end

							if GroundPart then GroundPart:Destroy() end
							if GroundWeld then GroundWeld:Destroy() end

							local Part = Utility.CreateObject("Part", {
								Parent = Char,
								Name = "\0",
								Size = Vector3New(0.1, 0.1, 0.1),
								CFrame = Root.CFrame * CFrameNew(0, -3, 0),
								Anchored = false,
								CanCollide = false,
								CastShadow = false,
								Transparency = 1
							})

							local Weld = Utility.CreateObject("WeldConstraint", {
								Parent = Part,
								Name = "\0",
								Part0 = Root,
								Part1 = Part
							})

							Objects["TrailGroundPart"] = Part
							Objects["TrailGroundWeld"] = Weld
							return Part
						end

						if Objects["TrailGroundPart"] then Objects["TrailGroundPart"]:Destroy() Objects["TrailGroundPart"] = nil end
						if Objects["TrailGroundWeld"] then Objects["TrailGroundWeld"]:Destroy() Objects["TrailGroundWeld"] = nil end
						return Root
					end

					local Root = GetTrailPart()
					if not Root then
						if Objects["Trail"] then Objects["Trail"]:Destroy() end
						if Objects["TrailAttachment0"] then Objects["TrailAttachment0"]:Destroy() end
						if Objects["TrailAttachment1"] then Objects["TrailAttachment1"]:Destroy() end
						if Objects["TrailGroundPart"] then Objects["TrailGroundPart"]:Destroy() Objects["TrailGroundPart"] = nil end
						if Objects["TrailGroundWeld"] then Objects["TrailGroundWeld"]:Destroy() Objects["TrailGroundWeld"] = nil end
					elseif Root.Parent then
						local Trail = Objects["Trail"]
						if not Trail or not Trail.Parent or Trail.Parent ~= Root then
							for _, child in GetChildren(Root) do
								if (child.Name == "\0" or child.Name == "Trail0" or child.Name == "Trail1") and IsA(child, "Attachment") then
									child:Destroy()
								elseif IsA(child, "Trail") then
									child:Destroy()
								end
							end

							if Trail then Trail:Destroy() end
							if Objects["TrailAttachment0"] then Objects["TrailAttachment0"]:Destroy() end
							if Objects["TrailAttachment1"] then Objects["TrailAttachment1"]:Destroy() end

							local Attachment0 = Utility.CreateObject("Attachment", {
								Parent = Root,
								Name = "\0",
								Position = Vector3New(0, 0, 0)
							})

							local Attachment1 = Utility.CreateObject("Attachment", {
								Parent = Root,
								Name = "\0",
								Position = Vector3New(0, 0.02, 0)
							})

							local TrailInstance = Utility.CreateObject("Trail", {
								Parent = Root,
								Name = "\0",
								Attachment0 = Attachment0,
								Attachment1 = Attachment1,
								FaceCamera = false,
								Lifetime = TrailSettings.Lifetime or 2,
								MinLength = 0.01,
								Color = ColorSequenceNew{ColorSequenceKeypointNew(0, TrailSettings.Color or Color3FromRGB(255, 255, 255)), ColorSequenceKeypointNew(1, TrailSettings.Color or Color3FromRGB(255, 255, 255))},
								Transparency = NumberSequenceNew{NumberSequenceKeypointNew(0, (TrailSettings.Transparency and TrailSettings.Transparency[1]) or 0), NumberSequenceKeypointNew(1, (TrailSettings.Transparency and TrailSettings.Transparency[2]) or 1)},
								WidthScale = NumberSequenceNew{NumberSequenceKeypointNew(0, TrailSettings.WidthScale or 1), NumberSequenceKeypointNew(1, TrailSettings.WidthScale or 1)}
							})

							Objects["Trail"] = TrailInstance
							Objects["TrailAttachment0"] = Attachment0
							Objects["TrailAttachment1"] = Attachment1
						else
							Trail.Lifetime = TrailSettings.Lifetime or 2
							Trail.Color = ColorSequenceNew{ColorSequenceKeypointNew(0, TrailSettings.Color), ColorSequenceKeypointNew(1, TrailSettings.Color)}
							Trail.Transparency = NumberSequenceNew{NumberSequenceKeypointNew(0, (TrailSettings.Transparency and TrailSettings.Transparency[1]) or 0), NumberSequenceKeypointNew(1, (TrailSettings.Transparency and TrailSettings.Transparency[2]) or 1)}
							Trail.WidthScale = NumberSequenceNew{NumberSequenceKeypointNew(0, TrailSettings.WidthScale or 1), NumberSequenceKeypointNew(1, TrailSettings.WidthScale or 1)}
						end
					end
				else
					if Objects["Trail"] then Objects["Trail"]:Destroy() end
					if Objects["TrailAttachment0"] then Objects["TrailAttachment0"]:Destroy() end
					if Objects["TrailAttachment1"] then Objects["TrailAttachment1"]:Destroy() end
					if Objects["TrailGroundPart"] then Objects["TrailGroundPart"]:Destroy() Objects["TrailGroundPart"] = nil end
					if Objects["TrailGroundWeld"] then Objects["TrailGroundWeld"]:Destroy() Objects["TrailGroundWeld"] = nil end
				end

				local ChinaHatSettings = PlayerSettings.ChinaHat
				if ChinaHatSettings and ChinaHatSettings.Enabled and IsPlayer and Target == Client and PlayerSettings.LocalPlayer and CharacterObjects.Character then
					local Character = CharacterObjects.Character
					local Head = Character:FindFirstChild("Head")
					local Hat = Objects["ChinaHat"]

					if Head and Head.Parent and (not Hat or not Hat.Parent or Hat.Parent ~= Character) then
						for _, child in GetChildren(Character) do
							if child.Name == "\0" and IsA(child, "BasePart") then
								child:Destroy()
							end
						end

						if Hat then Hat:Destroy() end
						if Objects["ChinaHatWeld"] then Objects["ChinaHatWeld"]:Destroy() end

						local SizeScaleValue = ChinaHatSettings.SizeScale or {1.8, 0.9, 1.8}
						local HatPart = Utility.CreateObject("Part", {
							Parent = Character,
							Name = "\0",
							Size = Vector3New(0.5, 0.5, 0.5),
							CFrame = Head.CFrame * CFrameNew(0, Head.Size.Y * 0.5 + 0.5, 0),
							Anchored = false,
							CanCollide = false,
							CastShadow = false,
							Transparency = ChinaHatSettings.Transparency or 0.5,
							Material = ChinaHatSettings.Material or Enum.Material.ForceField,
							Color = ChinaHatSettings.Color or Color3FromRGB(255, 255, 255)
						})

						local Mesh = Utility.CreateObject("SpecialMesh", {
							Parent = HatPart,
							Name = "\0",
							MeshId = "rbxassetid://1033714",
							Scale = Vector3New(SizeScaleValue[1] or 1.8, SizeScaleValue[2] or 0.9, SizeScaleValue[3] or 1.8)
						})

						local Weld = Utility.CreateObject("WeldConstraint", {
							Parent = HatPart,
							Name = "\0",
							Part0 = Head,
							Part1 = HatPart
						})

						Objects["ChinaHat"] = HatPart
						Objects["ChinaHatWeld"] = Weld
					elseif Hat and Hat.Parent then
						Hat.Material = ChinaHatSettings.Material or Enum.Material.ForceField
						Hat.Color = ChinaHatSettings.Color or Color3FromRGB(255, 255, 255)
						Hat.Transparency = ChinaHatSettings.Transparency or 0.5

						local Mesh = Hat:FindFirstChildOfClass("SpecialMesh")
						if Mesh and ChinaHatSettings.SizeScale then
							local SizeScaleValue = ChinaHatSettings.SizeScale
							Mesh.Scale = Vector3New(SizeScaleValue[1] or 1.8, SizeScaleValue[2] or 0.9, SizeScaleValue[3] or 1.8)
						end
					end
				else
					if Objects["ChinaHat"] then Objects["ChinaHat"]:Destroy() end
					if Objects["ChinaHatWeld"] then Objects["ChinaHatWeld"]:Destroy() end
				end
			end
		end

		function TargetInfo:Remove()
			if TargetInfo.ChamAdornments then
				for _, Adorns in TargetInfo.ChamAdornments do
					for _, Ad in Adorns do
						if Ad.Destroy then Ad:Destroy() end
					end
				end
				TargetInfo.ChamAdornments = nil
			end

			if TargetInfo.SkeletonLines then
				for _, BoneLines in TargetInfo.SkeletonLines do
					if BoneLines.line and BoneLines.line.Destroy then BoneLines.line:Destroy() end
				end
				TargetInfo.SkeletonLines = nil
			end

			for _, Object in TargetInfo.Objects do
				if Object and Object.Destroy then Object:Destroy() end
			end

			if TargetInfo.CharacterConnection then
				TargetInfo.CharacterConnection:Disconnect()
				TargetInfo.CharacterConnection = nil
			end

			if ToolConnection.Added then
				ToolConnection.Added:Disconnect()
				ToolConnection.Added = nil
			end

			if ToolConnection.Removed then
				ToolConnection.Removed:Disconnect()
				ToolConnection.Removed = nil
			end

			Esp.Targets[Type][Target] = nil
		end

		TargetInfo:Init()
	end

	function Esp:RemoveTarget(NewTarget, Type)
		if not Esp.Targets[Type] then return end

		local TargetInfo = Esp.Targets[Type][NewTarget]
		if not TargetInfo then return end

		TargetInfo:Remove()
		Esp.Targets[Type][NewTarget] = nil
	end

	function Esp:Init()
		for Type, _ in ESPSettings do
			if not Esp.Targets[Type] then
				Esp.Targets[Type] = {}
			end
		end
	end

	function Esp:Unload()
		for _, Connection in Esp.Connections do
			Connection:Disconnect()
		end

		for _, Object in ObjectsTable do
			if Object and Object.Destroy then
				Object:Destroy()
			end
		end

		getgenv().Fonts = nil
	end
end

Esp:Init()

RunService.PreRender:Connect(function()
	for Type, _ in Esp.Targets do
		for _, Target in Esp.Targets[Type] do
			Target.Update()
		end
	end
end)

return Esp