getgenv().AltHackGen = (tonumber(getgenv().AltHackGen) or 0) + 1
local GEN = getgenv().AltHackGen

local previousLibrary = getgenv().Library
if previousLibrary then
    pcall(function()
        previousLibrary:Unload()
    end)
    for _, holderName in ipairs({"Holder", "UnusedHolder"}) do
        pcall(function()
            local holder = previousLibrary[holderName]
            if holder and holder.Instance then
                holder.Instance:Destroy()
            end
        end)
    end
end

local previousMenuBlur = game:GetService("Lighting"):FindFirstChild("AltHack_MenuBlur")
if previousMenuBlur then
    pcall(function()
        previousMenuBlur:Destroy()
    end)
end

local Library = (function()

if getgenv().AltHackPlayerESP then
    pcall(function()
        getgenv().AltHackPlayerESP:Destroy()
    end)
    getgenv().AltHackPlayerESP = nil
end

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    local function getSafeGuiParent()
        local parent
        pcall(function()
            if getgenv and type(getgenv().gethui) == "function" then
                parent = getgenv().gethui()
            elseif type(gethui) == "function" then
                parent = gethui()
            end
        end)
        if parent then return parent end

        local canUseCore = pcall(function()
            local test = Instance.new("Folder")
            test.Parent = CoreGui
            test:Destroy()
        end)
        if canUseCore then
            return CoreGui
        end

        local lp = Players.LocalPlayer or Players:GetPlayers()[1]
        if lp then
            local pg = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
            if pg then return pg end
        end
        return CoreGui
    end

    local gethui = function()
        return getSafeGuiParent()
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
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

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl),

        Flags = { },

        Tween = {
            Time = 0.28,
            Style = Enum.EasingStyle.Quint,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "homxiide",
            Configs = "homxiide/Configs",
            Assets = "homxiide/Assets",
        },

        Pages = { },
        Sections = { },
        SearchRows = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

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
            ["Background"] = FromRGB(7, 7, 9),
            ["Outline"] = FromRGB(22, 22, 28),
            ["Inline"] = FromRGB(12, 12, 15),
            ["Accent"] = FromRGB(139, 149, 246),
            ["Text"] = FromRGB(230, 230, 238),
            ["Element"] = FromRGB(16, 16, 21)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    for Index, Value in Library.Folders do
        if not isfolder(Value) then
            makefolder(Value)
        end
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
            return {}
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
                    task.wait()
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

        Instances.MakeDraggable = function(self, Handle)
            if not self.Instance then
                return
            end

            local Gui = self.Instance
            local DragTarget = (Handle and Handle.Instance) or Gui
            local Dragging = false
            local DragStart
            local StartPosition

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local NewX = StartPosition.X.Offset + DragDelta.X
                local NewY = StartPosition.Y.Offset + DragDelta.Y

                local ScreenSize = Gui.Parent.AbsoluteSize
                local GuiSize = Gui.AbsoluteSize

                NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
                NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
            end

            local InputChanged

            Library:Connect(DragTarget.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then
                        return
                    end

                    InputChanged = Library:Connect(Input.Changed, function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged.Connection:Disconnect()
                            InputChanged = nil
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

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then
                return
            end

            local Gui = self.Instance

            local Resizing = false
            local CurrentSide = nil

            local StartMouse = nil
            local StartPosition = nil
            local StartSize = nil

            local EdgeThickness = 2

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
                })
                Button:AddToTheme({BackgroundColor3 = "Accent"})

                return Button
            end

            local Edges = {
                {Button = MakeEdge(
                    "Left",
                    UDim2New(0, 0, 0, 0),
                    UDim2New(0, EdgeThickness, 1, 0)),
                    Side = "L"
                },

                {Button = MakeEdge(
                    "Right",
                    UDim2New(1, -EdgeThickness, 0, 0),
                    UDim2New(0, EdgeThickness, 1, 0)),
                    Side = "R"
                },

                {Button = MakeEdge(
                    "Top", UDim2New(0, 0, 0, 0),
                    UDim2New(1, 0, 0, EdgeThickness)),
                    Side = "T"
                },

                {Button = MakeEdge(
                    "Bottom",
                    UDim2New(0, 0, 1, -EdgeThickness),
                    UDim2New(1, 0, 0, EdgeThickness)),
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

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y

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

            writefile(`{Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Assets}/{Name}.font`))
        end

        do
            local loaded = pcall(function()
                Library.Font = CustomFont:New("SFProText", 400, "Regular", {
                    Id = "AltHack_SFProText",
                    Url = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts/raw/master/SF-Pro-Text-Regular.otf"
                })
            end)
            if not loaded then
                pcall(function() delfile("AltHack_SFProText") end)
                loaded = pcall(function()
                    Library.Font = CustomFont:New("Inter", 400, "Regular", {
                        Id = "AltHack_Inter",
                        Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Inter.ttf"
                    })
                end)
            end
            if not loaded then
                pcall(function() delfile("AltHack_Inter") end)
                Library.Font = CustomFont:New("OutfitMedium", 400, "Regular", {
                    Id = "OutfitMedium",
                    Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Outfit-Medium.ttf"
                })
            end
        end
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.Unload = function(self)
        if self.IsUnloaded then
            return
        end
        self.IsUnloaded = true

        for Index, Value in self.Connections do
            if Value.Connection then
                Value.Connection:Disconnect()
            end
        end

        for Index, Value in self.Threads do
            coroutine.close(Value)
        end

        if self.Holder then
            self.Holder:Clean()
        end
        if self.UnusedHolder then
            self.UnusedHolder:Clean()
        end

        if getgenv().AltHackPlayerESP then
            pcall(function()
                getgenv().AltHackPlayerESP:Destroy()
            end)
            getgenv().AltHackPlayerESP = nil
        end

        getgenv().Library = nil
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
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

        if type(Item) == "table" then
            Item = Item.Instance or Item
        end

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

        for Index, Value in Library.Flags do
            pcall(function()
                if type(Value) == "table" and Value.Key ~= nil then
                    Config[Index] = {Key = tostring(Value.Key), Mode = tostring(Value.Mode or "Toggle")}
                elseif type(Value) == "table" and Value.Color ~= nil then
                    local hex = "#FFFFFF"
                    if type(Value.HexValue) == "string" then
                        hex = "#" .. Value.HexValue
                    elseif typeof(Value.Color) == "Color3" then
                        hex = "#" .. Value.Color:ToHex()
                    end
                    Config[Index] = {Color = hex}
                else
                    Config[Index] = Value
                end
            end)
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local OkDecoded, Decoded = pcall(function()
            return HttpService:JSONDecode(Config)
        end)

        if not OkDecoded or type(Decoded) ~= "table" then
            warn("[alt.gg] LoadConfig: config file is corrupted")
            return false
        end

        for Index, Value in Decoded do
            local SetFunction = Library.SetFlags[Index]

            if SetFunction then
                pcall(function()
                    if type(Value) == "table" and Value.Key ~= nil then
                        SetFunction(Value)
                    elseif type(Value) == "table" and Value.Color ~= nil then
                        SetFunction(Value.Color)
                    else
                        SetFunction(Value)
                    end
                end)
            end
        end

        return true
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        if not Element then return end
        local List = { }
        local ReturnList = { }

        pcall(function()
            if type(listfiles) == "function" and type(isfolder) == "function" and isfolder(Library.Folders.Configs) then
                List = listfiles(Library.Folders.Configs) or { }
            end
        end)

        for Index = 1, #List do
            local File = List[Index]
            if type(File) == "string" and File:sub(-5) == ".json" then
                local filename = File:gsub("^.*[/\\]", ""):gsub("%.json$", "")
                if filename ~= "" then
                    TableInsert(ReturnList, filename)
                end
            end
        end

        pcall(function()
            Element:Refresh(ReturnList)
        end)
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        if type(Item) == "table" then
            Item = Item.Instance or Item
        end

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

        if self.OnThemeChanged then
            pcall(self.OnThemeChanged, Theme, Color)
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

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Flag = Data.Flag,

            Hue = 0,
            Saturation = 0,
            Value = 0,

            Color = Color3.fromRGB(0, 0, 0),
            Hex = "#000000",

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
                Size = UDim2New(0, 16, 0, 16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = Library.Theme["Outline"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = 'Outline'})

            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(148, 255, 237),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.800000011920929,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })

            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 94, 0, 60),
                Size = UDim2New(0, 160, 0, 160),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})

            Instances:Create("UICorner", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -40, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })

            Instances:Create("UICorner", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })

            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 0),
                BorderSizePixel = 0
            })

            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })

            Instances:Create("UICorner", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })

            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 1, 1, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })

            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })

            Instances:Create("UICorner", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })

            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 5, 0, 5),
                BorderSizePixel = 0
            })

            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0"
            })

            Instances:Create("UICorner", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -8, 0, 8),
                Size = UDim2New(0, 15, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14
            })

            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })

            Instances:Create("UICorner", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 15, 0, 15),
                BorderSizePixel = 0
            })

            Instances:Create("UICorner", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0"
            })
        end

        function Colorpicker:Get()
            return Colorpicker.Color
        end

        function Colorpicker:Update()
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()

            Library.Flags[Colorpicker.Flag] = {
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue
            }

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Glow"]:Tween(nil, {ImageColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

            if Data.Callback then
                Library:SafeCall(Data.Callback, Colorpicker.Color)
            end
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

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.955)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        local SlidingHue = false
        local HueChanged

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.91)

            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
            Colorpicker:Update()
        end

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

                RenderStepped = Library:Connect(RunService.RenderStepped, function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(
                        0,
                        Items["ColorpickerButton"].Instance.AbsolutePosition.X,
                        0,
                        Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)

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
                    RenderStepped.Connection:Disconnect()
                    RenderStepped = nil
                end
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
                    Value.ZIndex = Colorpicker.IsOpen and 100 or 1
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
                if Library.IsUnloaded then return end
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Colorpicker:Set(Color)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end

            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()

            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.955)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.955)

            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
            Colorpicker:Update()
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingPalette = true

                Colorpicker:SlidePalette(Input)

                if PaletteChanged then
                    return
                end

                PaletteChanged = Library:Connect(Input.Changed, function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false

                        PaletteChanged.Connection:Disconnect()
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

                HueChanged = Library:Connect(Input.Changed, function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false

                        HueChanged.Connection:Disconnect()
                        HueChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Colorpicker.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end

                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then
            Colorpicker:Set(Data.Default)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Value)
            Colorpicker:Set(Value)
        end

        return Colorpicker, Items
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Flag = Data.Flag,

            Value = "",
            Key = "",
            Mode = Data.Mode or Data.mode or "Toggle",

            Toggled = false,
            Picking = false,
            IsOpen = false
        }

        local Items = { } do
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                Text = "[NONE]",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = Library.Theme["Element"],
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12
            }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})

            Instances:Create("UICorner", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                PaddingLeft = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7)
            })

            Items["KeybindWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})

            Instances:Create("UICorner", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })

            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})

            Instances:Create("UIListLayout", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Instances:Create("UIPadding", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 10),
                PaddingBottom = UDimNew(0, 10),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 10)
            })

            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Hold",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})

            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Always",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
        end

        local Modes = {
            Toggle = Items["Toggle"],
            Hold = Items["Hold"],
            Always = Items["Always"]
        }

        local Debounce = false
        local RenderStepped

        function Keybind:SetOpen(Bool)
            if Debounce then
                return
            end

            Keybind.IsOpen = Bool

            Debounce = true

            if Keybind.IsOpen then
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance

                RenderStepped = Library:Connect(RunService.RenderStepped, function()
                    Items["KeybindWindow"].Instance.Position = UDim2New(
                        0,
                        Items["KeyButton"].Instance.AbsolutePosition.X,
                        0,
                        Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5
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
                    RenderStepped.Connection:Disconnect()
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
                if Library.IsUnloaded then return end
                Debounce = false
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                task.wait(0.2)
                Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do
                if Index == Mode then
                    Value:Tween(nil, {TextTransparency = 0})
                else
                    Value:Tween(nil, {TextTransparency = 0.5})
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
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
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
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Key)

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            Keybind.Picking = true

            Items["KeyButton"].Instance.Text = "..."

            local InputBegan
            InputBegan = Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if Input.KeyCode == Enum.KeyCode.Escape then

                        Keybind:Set(Enum.KeyCode.Backspace)
                    else
                        Keybind:Set(Input.KeyCode)
                    end
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan.Connection:Disconnect()
                InputBegan = nil
            end)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Keybind.Value == "None" then
                return
            end

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

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
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
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
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

        return Keybind, Items
    end

    do
        Library.Watermark = function(self, Name, Logo)
            local Watermark = { }

            local Items = { } do
                Items["Watermark"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0),
                    Position = UDim2New(0.5, 0, 0, 20),
                    Size = UDim2New(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Watermark"]:MakeDraggable()

                Instances:Create("UICorner", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 10)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 25, 0, 25),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Perccss in my sodaa",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 34, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})
            end

            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetCenter()
                local CenterPosition = Items["Watermark"].Instance.AbsolutePosition
                task.wait()
                Items["Watermark"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["Watermark"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            Watermark:SetText(Name)
            Watermark:SetCenter()

            return Watermark
        end

        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "swatware",
                SubName = Data.SubName or Data.subname or "",
                Logo = Data.Logo or Data.logo or "rbxassetid://134242818164054",
                KeyTime = Data.KeyTime or Data.keytime or "30d left",

                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "Swatware_Main",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 920, 0, 600),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    ClipsDescendants = true
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["MainFrame"]:MakeResizeable(Vector2New(760, 480), Vector2New(1400, 950))

                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 14)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    Transparency = 0.2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["TopBar"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "TopBar",
                    BackgroundColor3 = Library.Theme["Inline"],
                    BackgroundTransparency = 0.1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 48),
                    ClipsDescendants = true,
                    ZIndex = 5
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("UICorner", {
                    Parent = Items["TopBar"].Instance,
                    CornerRadius = UDimNew(0, 14)
                })

                local Grain = Instances:Create("ImageLabel", {
                    Parent = Items["TopBar"].Instance,
                    Name = "GrainOverlay",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://9968344510",
                    ImageTransparency = 0.95,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2New(0, 128, 0, 128),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    ZIndex = 6
                })

                Instances:Create("UICorner", {
                    Parent = Grain.Instance,
                    CornerRadius = UDimNew(0, 14)
                })

                Instances:Create("Frame", {
                    Parent = Items["TopBar"].Instance,
                    Name = "TopBarBottomFill",
                    Position = UDim2New(0, 0, 1, -14),
                    Size = UDim2New(1, 0, 0, 14),
                    BackgroundColor3 = Library.Theme["Inline"],
                    BackgroundTransparency = 0.1,
                    BorderSizePixel = 0,
                    ZIndex = 6
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("Frame", {
                    Parent = Items["TopBar"].Instance,
                    Name = "TopBarBorder",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 1),
                    BackgroundColor3 = Library.Theme["Outline"],
                    BackgroundTransparency = 0.3,
                    ZIndex = 7
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["TopContainer"] = Instances:Create("Frame", {
                    Parent = Items["TopBar"].Instance,
                    Name = "TopContainer",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 10
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["TopContainer"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["TopContainer"].Instance,
                    PaddingLeft = UDimNew(0, 14),
                    PaddingRight = UDimNew(0, 14)
                })

                Items["TitleArea"] = Instances:Create("TextButton", {
                    Parent = Items["TopContainer"].Instance,
                    Name = "TitleArea",
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    Text = "",
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    LayoutOrder = 2,
                    ZIndex = 11
                })

                Items["MainFrame"]:MakeDraggable(Items["TitleArea"])

                Instances:Create("UIListLayout", {
                    Parent = Items["TitleArea"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["TitleArea"].Instance,
                    Name = "Logo",
                    BackgroundTransparency = 1,
                    ScaleType = Enum.ScaleType.Fit,
                    Image = Window.Logo,
                    Size = UDim2New(0, 22, 0, 22),
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    ZIndex = 12
                })

                Items["TitleText"] = Instances:Create("TextLabel", {
                    Parent = Items["TitleArea"].Instance,
                    Name = "TitleText",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = (Window.Name ~= "Window" and Window.Name ~= "alt.gg") and Window.Name or "swatware",
                    Size = UDim2New(0, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16,
                    LayoutOrder = 2,
                    ZIndex = 12
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Pages"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["TopContainer"].Instance,
                    Name = "TabsList",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, -240, 1, 0),
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.X,
                    ScrollBarThickness = 0,
                    ClipsDescendants = true,
                    LayoutOrder = 2,
                    ZIndex = 15
                })

                local PagesFlex = Instance.new("UIFlexItem")
                PagesFlex.FlexMode = Enum.UIFlexMode.Fill
                PagesFlex.Parent = Items["Pages"].Instance

                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    PaddingLeft = UDimNew(0, 6),
                    PaddingTop = UDimNew(0, 4),
                    PaddingBottom = UDimNew(0, 4)
                })

                Items["TopRight"] = Instances:Create("Frame", {
                    Parent = Items["TopContainer"].Instance,
                    Name = "TopRight",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    LayoutOrder = 5,
                    ZIndex = 15
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["TopRight"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["KeyBubble"] = Instances:Create("Frame", {
                    Parent = Items["TopRight"].Instance,
                    Name = "KeyBubble",
                    BackgroundColor3 = Library.Theme["Element"],
                    BackgroundTransparency = 0.4,
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 0, 26),
                    AutomaticSize = Enum.AutomaticSize.X,
                    LayoutOrder = 1,
                    ZIndex = 16
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["KeyBubble"].Instance,
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["KeyBubble"].Instance,
                    Color = Library.Theme["Outline"],
                    Transparency = 0.35,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Instances:Create("UIPadding", {
                    Parent = Items["KeyBubble"].Instance,
                    PaddingLeft = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 10)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["KeyBubble"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["GlowDot"] = Instances:Create("Frame", {
                    Parent = Items["KeyBubble"].Instance,
                    Name = "GlowDot",
                    BackgroundColor3 = FromRGB(56, 239, 125),
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 7, 0, 7),
                    LayoutOrder = 1,
                    ZIndex = 17
                })

                Instances:Create("UICorner", {
                    Parent = Items["GlowDot"].Instance,
                    CornerRadius = UDimNew(1, 0)
                })

                local DotStroke = Instances:Create("UIStroke", {
                    Parent = Items["GlowDot"].Instance,
                    Color = FromRGB(56, 239, 125),
                    Transparency = 0.35,
                    Thickness = 1.5,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                task.spawn(function()
                    while DotStroke and DotStroke.Instance and DotStroke.Instance.Parent do
                        local t = tick()
                        local pulse = (math.sin(t * 3) + 1) * 0.5
                        DotStroke.Instance.Transparency = 0.2 + pulse * 0.55
                        task.wait(0.05)
                    end
                end)

                Items["KeyTimeText"] = Instances:Create("TextLabel", {
                    Parent = Items["KeyBubble"].Instance,
                    Name = "KeyTimeText",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.15,
                    Text = Window.KeyTime or "30d left",
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    LayoutOrder = 2,
                    ZIndex = 17
                }):AddToTheme({TextColor3 = 'Text'})

                Items["OptsBtn"] = Instances:Create("TextButton", {
                    Parent = Items["TopRight"].Instance,
                    Name = "OptsBtn",
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 26, 0, 26),
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderSizePixel = 0,
                    LayoutOrder = 2,
                    ZIndex = 16
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["OptsBtn"].Instance,
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["OptsBtn"].Instance,
                    Color = Library.Theme["Outline"],
                    Transparency = 0.35,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Instances:Create("ImageLabel", {
                    Parent = Items["OptsBtn"].Instance,
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://85538382643347",
                    ImageColor3 = Library.Theme["Text"],
                    ImageTransparency = 0.25,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 13, 0, 13),
                    BorderSizePixel = 0,
                    ZIndex = 17
                }):AddToTheme({ImageColor3 = 'Text'})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "Content",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 48),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, -48),
                    BorderSizePixel = 0,
                    ZIndex = 1
                })

                local PreviousPage = nil
                local function ToggleSettings()
                    local SettingsPage = nil
                    for _, P in ipairs(Window.Pages) do
                        if P.Name == "Settings" then
                            SettingsPage = P
                            break
                        end
                    end

                    if not SettingsPage then return end

                    if SettingsPage.Active then
                        local Target = PreviousPage
                        if not Target or Target == SettingsPage then
                            for _, P in ipairs(Window.Pages) do
                                if P ~= SettingsPage then
                                    Target = P
                                    break
                                end
                            end
                        end
                        if Target then
                            for _, Other in ipairs(Window.Pages) do
                                Other:Turn(Other == Target)
                            end
                        end
                    else
                        for _, P in ipairs(Window.Pages) do
                            if P.Active and P ~= SettingsPage then
                                PreviousPage = P
                                break
                            end
                        end
                        for _, Other in ipairs(Window.Pages) do
                            Other:Turn(Other == SettingsPage)
                        end
                    end
                end

                Items["OptsBtn"]:Connect("MouseButton1Click", ToggleSettings)

                Window.Items = Items
            end

            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)
                Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            function Window:SetOpen(Bool)
                Window.IsOpen = not not Bool

                if Window.IsOpen then
                    Items["MainFrame"].Instance.Visible = true
                end

                task.delay(0.2, function()
                    local MainFrame = Items["MainFrame"].Instance
                    if MainFrame and MainFrame.Parent then
                        MainFrame.Visible = Window.IsOpen
                    end
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Icon = Data.Icon or Data.icon or "rbxassetid://72196061405823",

                Items = { },
                Active = false,

                Tabs = { },
                TabOrder = { },
                            }

            Page.Window._NavCounter = (Page.Window._NavCounter or 0) + 1

            local Items = { } do

                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = Page.Name,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Active = true,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Size = UDim2New(0, 0, 0, 28),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    LayoutOrder = (Page.Name == "Home" or Page.Name == "home") and 1 or (Page.Window._NavCounter + 1),
                    BackgroundColor3 = Library.Theme["Accent"],
                    ZIndex = 20
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    CornerRadius = UDimNew(0, 6)
                })

                local TabBtnLayout = Instances:Create("UIListLayout", {
                    Parent = Items["Inactive"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Inactive"].Instance,
                    PaddingLeft = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8)
                })

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "Icon",
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.45,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    ZIndex = 21
                }):AddToTheme({ImageColor3 = 'Text'})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "Text",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.45,
                    Text = Page.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    LayoutOrder = 2,
                    ZIndex = 21
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = Page.Name .. "_Container",
                    Visible = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    ZIndex = 2
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Page"].Instance,
                    PaddingLeft = UDimNew(0, 14),
                    PaddingRight = UDimNew(0, 14),
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8)
                })

                local Columns = { }
                for ColumnIndex = 1, 2 do
                    local Column = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        Name = "Column_" .. ColumnIndex,
                        ScrollBarImageColor3 = Library.Theme["Outline"],
                        ScrollBarThickness = 2,
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2New(0.5, -6, 1, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        CanvasSize = UDim2New(0, 0, 0, 0),
                        ZIndex = 4
                    }):AddToTheme({ScrollBarImageColor3 = 'Outline'})

                    Instances:Create("UIPadding", {
                        Parent = Column.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 4),
                        PaddingBottom = UDimNew(0, 10),
                        PaddingRight = UDimNew(0, 4),
                        PaddingLeft = UDimNew(0, 4)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Column.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    Columns[ColumnIndex] = Column
                end

                Page.Columns = Columns
                Page.Items = Items
            end

            function Page:GetTab(TabName)
                return self
            end

            function Page:Turn(Bool)
                Page.Active = Bool
                local pageInstance = Items["Page"].Instance

                if Bool then
                    pageInstance.Visible = true
                    pageInstance.Parent = Page.Window.Items["Content"].Instance
                    pageInstance.Position = UDim2New(0, 0, 0, 8)
                    TweenService:Create(pageInstance, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Position = UDim2New(0, 0, 0, 0)
                    }):Play()

                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0.85})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})

                    if Page.OnSelect then
                        Page.OnSelect()
                    end
                else
                    pageInstance.Visible = false
                    pageInstance.Parent = Library.UnusedHolder.Instance

                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})

                    Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.45})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.45})

                    if Page.OnHide then
                        Page.OnHide()
                    end
                end
            end

            Items["Inactive"]:Connect("MouseEnter", function()
                if not Page.Active then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.15})
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0.15})
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0.92})
                end
            end)

            Items["Inactive"]:Connect("MouseLeave", function()
                if not Page.Active then
                    Items["Text"]:Tween(nil, {TextTransparency = 0.45})
                    Items["Icon"]:Tween(nil, {ImageTransparency = 0.45})
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
                end
            end)

            local function OnTabClicked()
                for _, Value in ipairs(Page.Window.Pages) do
                    Value:Turn(Value == Page)
                end
            end

            Items["Inactive"]:Connect("MouseButton1Click", OnTabClicked)

            if #Page.Window.Pages == 0 then
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Group = function(self, Name)
            self._NavCounter = (self._NavCounter or 0) + 1
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Side = math.clamp(Data.Side or Data.side or 1, 1, 2),
                Icon = Data.Icon or Data.icon or "rbxassetid://127136375066593",
                Collapsed = false,

                Items = { }
            }

            local TargetColumn = (self.Columns and self.Columns[Section.Side] and self.Columns[Section.Side].Instance)
                or (self.Items and self.Items["Page"] and self.Items["Page"].Instance)

            local Items = { } do
                Items["SectionOutline"] = Instances:Create("Frame", {
                    Parent = TargetColumn,
                    Name = Section.Name .. "_Outline",
                    Size = UDim2New(1, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Outline"],
                    BackgroundTransparency = 0.4,
                    ClipsDescendants = true,
                    ZIndex = 4
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Instances:Create("UICorner", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 10)
                })

                Items["Section"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "SectionInner",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"],
                    ClipsDescendants = true,
                    ZIndex = 5
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 9)
                })

                Items["Top"] = Instances:Create("TextButton", {
                    Parent = Items["Section"].Instance,
                    Name = "Header",
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    Text = "",
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 36),
                    ZIndex = 6,
                    Active = true
                })

                local TopLayout = Instances:Create("UIListLayout", {
                    Parent = Items["Top"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Top"].Instance,
                    PaddingLeft = UDimNew(0, 12),
                    PaddingRight = UDimNew(0, 12)
                })

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "SectionIcon",
                    BackgroundTransparency = 1,
                    Image = Section.Icon,
                    ImageColor3 = Library.Theme["Accent"],
                    Size = UDim2New(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    ZIndex = 7
                }):AddToTheme({ImageColor3 = 'Accent'})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "Title",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    LayoutOrder = 2,
                    ZIndex = 7
                }):AddToTheme({TextColor3 = 'Text'})

                local HeaderSpacer = Instance.new("UIFlexItem")
                HeaderSpacer.FlexMode = Enum.UIFlexMode.Fill
                HeaderSpacer.Parent = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 1, 0),
                    LayoutOrder = 3
                }).Instance

                Items["Arrow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "Chevron",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://10709790948",
                    ImageColor3 = Library.Theme["Text"],
                    ImageTransparency = 0.4,
                    Size = UDim2New(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    Rotation = 0,
                    LayoutOrder = 4,
                    ZIndex = 7
                }):AddToTheme({ImageColor3 = 'Text'})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "Content",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 36),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 5
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 2),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 12),
                    PaddingLeft = UDimNew(0, 12)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                function Section:SetCollapsed(collapsed)
                    collapsed = not not collapsed
                    Section.Collapsed = collapsed

                    local Content = Items["Content"].Instance
                    Content.AutomaticSize = collapsed and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
                    Content.Size = UDim2New(1, 0, 0, 0)
                    Content.Visible = not collapsed

                    Items["Arrow"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Rotation = collapsed and -90 or 0,
                        ImageTransparency = collapsed and 0.65 or 0.35
                    })
                end

                local function ToggleCollapse()
                    Section:SetCollapsed(not Section.Collapsed)
                end

                Items["Top"]:Connect("MouseButton1Down", ToggleCollapse)

                Items["Top"]:Connect("MouseEnter", function()
                    Items["Arrow"]:Tween(nil, {ImageTransparency = 0.1})
                    Items["Text"]:Tween(nil, {TextTransparency = 0.1})
                end)

                Items["Top"]:Connect("MouseLeave", function()
                    Items["Arrow"]:Tween(nil, {ImageTransparency = Section.Collapsed and 0.65 or 0.4})
                    Items["Text"]:Tween(nil, {TextTransparency = 0})
                end)

                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false
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
                    AnchorPoint = Vector2New(0, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Toggle.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 32, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "SubElements",
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -38, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Circle"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 0.5,
                    Position = UDim2New(0, 4, 0.5, 0),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})

                Instances:Create("UICorner", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
            end

            table.insert(Library.SearchRows, {Frame = Items["Toggle"].Instance, Text = StringLower(Toggle.Name), Page = Toggle.Page})

            function Toggle:Get()
                return Toggle.Value
            end

            function Toggle:Set(Value)
                Toggle.Value = Value
                Library.Flags[Toggle.Flag] = Value

                if Toggle.Value then
                    Items["Glow"]:Tween(nil, {ImageTransparency = 0.7})

                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                    Items["Circle"]:Tween(TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        AnchorPoint = Vector2New(1, 0.5),
                        Position = UDim2New(1, -3, 0.5, 0),
                        BackgroundTransparency = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Items["Text"]:Tween(nil, {TextTransparency = 0})
                else
                    Items["Glow"]:Tween(nil, {ImageTransparency = 1})

                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})

                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                    Items["Circle"]:Tween(TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 3, 0.5, 0),
                        BackgroundTransparency = 0.45,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    Items["Text"]:Tween(nil, {TextTransparency = 0.45})
                end

                if Toggle.Callback then
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
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

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 30),
                    Selectable = false,
                    Active = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"],
                    ClipsDescendants = true
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://117716971575946",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                Items["Stroke"]:ChangeItemTheme({Color = "Accent"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Accent})
                task.wait(0.1)
                Library:SafeCall(Button.Callback)
                Items["Stroke"]:ChangeItemTheme({Color = "Outline"})
                Items["Stroke"]:Tween(nil, {Color = Library.Theme.Outline})
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Min = Data.Min or Data.min or 0,
                Default = Data.Default or Data.default or 0,
                Max = Data.Max or Data.max or 100,
                Suffix = Data.Suffix or Data.suffix or "",
                Decimals = Data.Decimals or Data.decimals or 1,
                Callback = Data.Callback or Data.callback or function() end,

                Value = 0,
                Sliding = false
            }

            local Items = { } do
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    Position = UDim2New(0, 0, 0, 0),
                    Size = UDim2New(1, -65, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = 13
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = "0",
                    Position = UDim2New(1, -60, 0, 0),
                    Size = UDim2New(0, 60, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = 12
                }):AddToTheme({TextColor3 = 'Text'})

                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 0, 0, 19),
                    Size = UDim2New(1, 0, 0, 6),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 10, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UICorner", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
            end

            table.insert(Library.SearchRows, {Frame = Items["Slider"].Instance, Text = StringLower(Slider.Name), Page = Slider.Page})

            function Slider:Get()
                return Slider.Value
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                local pct = (Slider.Max == Slider.Min) and 0 or MathClamp((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1)
                Items["Accent"].Instance.Size = UDim2New(pct, 0, 1, 0)
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

                if Slider.Callback then
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            local function updateSliderPos()
                local sliderInst = Items["RealSlider"].Instance
                local mouseX = UserInputService:GetMouseLocation().X
                local relX = mouseX - sliderInst.AbsolutePosition.X
                local sizeX = MathClamp(relX / math.max(sliderInst.AbsoluteSize.X, 1), 0, 1)
                local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
                Slider:Set(value)
            end

            Items["RealSlider"].Instance.MouseButton1Down:Connect(function()
                Slider.Sliding = true
                updateSliderPos()
            end)

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true
                    updateSliderPos()
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Slider.Sliding and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    updateSliderPos()
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = false
                end
            end)

            if Slider.Default then
                Slider:Set(Slider.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
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
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { "One", "Two", "Three" },
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 26),
                    BorderSizePixel = 0
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    LayoutOrder = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 0, 26),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    LayoutOrder = 2,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                local DropdownFlex = Instance.new("UIFlexItem")
                DropdownFlex.FlexMode = Enum.UIFlexMode.Fill
                DropdownFlex.Parent = Items["RealDropdown"].Instance

                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.15,
                    Text = "--",
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://72690112230014",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -8, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})

                Instances:Create("Frame", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -32, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["OptionHolder"] = Instances:Create("TextButton", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 200, 0, 0),
                    Position = UDim2New(0, 54, 0, 236),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0"
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 10),
                    PaddingBottom = UDimNew(0, 10),
                    PaddingRight = UDimNew(0, 10),
                    PaddingLeft = UDimNew(0, 10)
                })
            end

            table.insert(Library.SearchRows, {Frame = Items["Dropdown"].Instance, Text = StringLower(Dropdown.Name), Page = Dropdown.Page})

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local RenderStepped

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true

                if Dropdown.IsOpen then
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.ZIndex = 100
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance

                RenderStepped = Library:Connect(RunService.RenderStepped, function()
                        Items["OptionHolder"].Instance.Position = UDim2New(
                            0,
                            Items["RealDropdown"].Instance.AbsolutePosition.X,
                            0,
                            Items["RealDropdown"].Instance.AbsolutePosition.Y + Items["RealDropdown"].Instance.AbsoluteSize.Y + 4
                        )
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0)
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown
                else
                    if Library.OpenFrames[Dropdown] then
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then
                        RenderStepped.Connection:Disconnect()
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
                        Value.ZIndex = Dropdown.IsOpen and 100 or 1
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
                    if Library.IsUnloaded then return end
                    Debounce = false
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Dropdown:Set(Option)
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
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14
                })

                local OptionLiner = Instances:Create("Frame", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 3, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                local OptionGlow = Instances:Create("ImageLabel", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})

                Instances:Create("UICorner", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Option,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Liner = OptionLiner,
                    Glow = OptionGlow,
                    Text = OptionText,
                    Selected = false
                }

                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 3, 1, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 0.7})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 12, 0.5 ,0), TextTransparency = 0})
                    else
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 3, 0, 0)})
                        OptionData.Glow:Tween(nil, {ImageTransparency = 1})
                        OptionData.Text:Tween(nil, {Position = UDim2New(0, 0, 0.5 ,0), TextTransparency = 0.5})
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
                end

                OptionData.Button:Connect("MouseButton1Click", function()
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

            Items["RealDropdown"]:Connect("MouseButton1Click", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

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

            return Dropdown
        end

        Library.Sections.Label = function(self, NameOrData)
            local labelText = "Label"
            if type(NameOrData) == "table" then
                labelText = NameOrData.Name or NameOrData.name or NameOrData.Text or NameOrData.text or "Label"
            elseif type(NameOrData) == "string" then
                labelText = NameOrData
            end

            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = labelText
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function Label:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
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

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
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
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,

                Value = ""
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    Active = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 1),
                    Size = UDim2New(0, 0, 0, 30),
                    Position = UDim2New(1, 0, 1, 0),
                    Selectable = true,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Instances:Create("UIPadding", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })

                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    Active = false,
                    TextTransparency = 0,
                    AnchorPoint = Vector2New(0, 0.5),
                    PlaceholderColor3 = FromRGB(133, 139, 143),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 16,
                    Size = UDim2New(0, 0, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Selectable = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    CursorPosition = -1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                }):AddToTheme({TextColor3 = 'Text'})
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            if Textbox.Finished then
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end
    end

    Library.CreateSettingsPage = function(self, Window, Watermark)
            local SettingsPage = Window:Page({Name = "Settings", Icon = "rbxassetid://80758916183665"})

        do
            local ThemingSection = SettingsPage:Section({Name = "Theming", Icon = "rbxassetid://73803440257131"})

            do
                for Index, Value in Library.Theme do
                    ThemingSection:Label(Index):Colorpicker({
                        Flag = Index.."_ThemingThing",
                        Default = Value,
                        Alpha = 0,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end

            local ConfigsSection = SettingsPage:Section({Name = "Configs", Icon = "rbxassetid://74885853379841"}) do
                local ConfigName
                local ConfigSelected

                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs",
                    Flag = "Configs",
                    Items = { },
                    Multi = false,
                    MaxSize = 120,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({
                    Name = "Config name",
                    Placeholder = "Config name",
                    Flag = "ConfigName",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if ConfigName and ConfigName ~= "" then
                            if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                                writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                                Library:RefreshConfigsList(ConfigsDropdown)
                            end
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json"))
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            writefile(Library.Folders.Configs .. "/" .. ConfigSelected..".json", Library:GetConfig())
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if ConfigSelected and ConfigSelected ~= "" then
                            delfile(Library.Folders.Configs .. "/" .. ConfigSelected..".json")
                            Library:RefreshConfigsList(ConfigsDropdown)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Refresh",
                    Callback = function()
                        Library:RefreshConfigsList(ConfigsDropdown)
                    end
                })

                Library:RefreshConfigsList(ConfigsDropdown)
            end
        end

        return SettingsPage
    end
end

Library.LucideIconsUrl = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
Library.IconPacks = Library.IconPacks or {}
Library.ActiveIconPack = "lucide"

function Library:LoadIconPack(Url, PackName)
    PackName = PackName or "lucide"

    if self.IconPacks[PackName] then
        return self.IconPacks[PackName]
    end

    local Success, Result = pcall(function()
        local Source = game:HttpGet(Url)
        local Chunk = loadstring(Source)
        if not Chunk then
            return {}
        end

        local Icons = Chunk()
        if type(Icons) ~= "table" then
            return {}
        end

        return Icons
    end)

    self.IconPacks[PackName] = Success and Result or {}
    return self.IconPacks[PackName]
end

function Library:SetIconPack(PackName)
    self.ActiveIconPack = PackName or "lucide"
end

function Library:GetIconPack(PackName)
    PackName = PackName or self.ActiveIconPack or "lucide"

    if not self.IconPacks[PackName] then
        if PackName == "lucide" then
            self:LoadIconPack(self.LucideIconsUrl, "lucide")
        else
            self.IconPacks[PackName] = {}
        end
    end

    return self.IconPacks[PackName] or {}
end

function Library:ResolveIcon(Icon, PackName)
    if not Icon or Icon == "" then
        return Icon
    end

    if typeof(Icon) ~= "string" then
        return Icon
    end

    if Icon:match("^rbxassetid://") or Icon:match("^https?://") then
        return Icon
    end

    local Icons = self:GetIconPack(PackName)
    return Icons[string.lower(Icon)] or Icon
end

local OriginalWindowFunction = Library.Window
Library.Window = function(self, Data)
    Data = Data or {}

    Data.Logo = self:ResolveIcon(Data.Logo)
    Data.logo = self:ResolveIcon(Data.logo)

    if Data.WatermarkLogo then
        Data.WatermarkLogo = self:ResolveIcon(Data.WatermarkLogo)
    end

    return OriginalWindowFunction(self, Data)
end

local OriginalSectionFunction = Library.Pages.Section
Library.Pages.Section = function(self, Data)
    Data = Data or {}
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon
    return OriginalSectionFunction(self, Data)
end

Library.CreateWindow = function(self, Data)
    Data = Data or {}

    local Window = self:Window(Data)
    local Watermark

    if Data.WatermarkEnabled then
        Watermark = self:Watermark(
            Data.WatermarkText or Data.Name or "Window",
            self:ResolveIcon(Data.WatermarkLogo or Data.Logo)
        )
        Window.Watermark = Watermark
    end

    Window._AutoSettingsEnabled = Data.SettingsTabEnabled and true or false
    Window._AutoSettingsWatermark = Watermark

    local OriginalPage = Window.Page
    local CreatingSettings = false

    local function ReorderTabs()
        local Order = 1

        for _, Value in Window.Pages do
            if Value ~= Window.SettingsPage and Value.Items and Value.Items["Inactive"] then
                Value.Items["Inactive"].Instance.LayoutOrder = Order
                Order += 1
            end
        end

        if Window.SettingsPage and Window.SettingsPage.Items and Window.SettingsPage.Items["Inactive"] then
            Window.SettingsPage.Items["Inactive"].Instance.LayoutOrder = 999999
        end
    end

    local function EnsureSettings()
        if not Window._AutoSettingsEnabled or Window.SettingsPage or CreatingSettings then
            ReorderTabs()
            return
        end

        CreatingSettings = true
        Window.SettingsPage = Library:CreateSettingsPage(Window, Window._AutoSettingsWatermark)
        CreatingSettings = false

        ReorderTabs()
    end

    local function WrappedPage(_, TabData)
        TabData = TabData or {}
        TabData.Icon = Library:ResolveIcon(TabData.Icon or TabData.icon)
        TabData.icon = TabData.Icon

        local Page = OriginalPage(Window, TabData)

        EnsureSettings()
        ReorderTabs()

        return Page
    end

    Window.Page = WrappedPage
    Window.CreateTab = WrappedPage
    Window.CreatePage = WrappedPage

    return Window
end

Library.CreateTab = Library.Page
Library.Pages.CreateSection = Library.Pages.Section

Library.Sections.CreateButton = Library.Sections.Button
Library.Sections.CreateToggle = Library.Sections.Toggle
Library.Sections.CreateSlider = Library.Sections.Slider
Library.Sections.CreateDropdown = Library.Sections.Dropdown
Library.Sections.CreateTextbox = Library.Sections.Textbox
Library.Sections.CreateLabel = Library.Sections.Label

local function NormalizeNamedData(NameOrData, Icon)
    if type(NameOrData) == "table" then
        local Data = table.clone(NameOrData)

        if Data.Title and not (Data.Name or Data.name) then
            Data.Name = Data.Title
        end

        if Data.title and not (Data.Name or Data.name) then
            Data.Name = Data.title
        end

        if Icon and not (Data.Icon or Data.icon) then
            Data.Icon = Icon
        end

        return Data
    end

    local Data = {
        Name = NameOrData
    }

    if Icon ~= nil then
        Data.Icon = Icon
    end

    return Data
end

function Library:AddTab(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = self:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateTab then
        return self:CreateTab(Data)
    end

    return self:Page(Data)
end

function Library.Pages:AddSection(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateSection then
        return self:CreateSection(Data)
    end

    return self:Section(Data)
end

function Library.Sections:AddButton(NameOrData, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateButton(Data)
    end

    return self:CreateButton({
        Name = NameOrData,
        Callback = Callback
    })
end

function Library.Sections:AddToggle(NameOrData, FlagOrCallback, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateToggle(Data)
    end

    local RealCallback = type(FlagOrCallback) == "function" and FlagOrCallback or Callback

    return self:CreateToggle({
        Name = NameOrData,
        Flag = type(FlagOrCallback) == "string" and FlagOrCallback or nil,
        Default = Default,
        Callback = RealCallback
    })
end

function Library.Sections:AddSlider(NameOrData, Min, Max, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateSlider(Data)
    end

    return self:CreateSlider({
        Name = NameOrData,
        Min = Min,
        Max = Max,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddDropdown(NameOrData, Items, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateDropdown(Data)
    end

    return self:CreateDropdown({
        Name = NameOrData,
        Items = Items,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddTextbox(NameOrData, Placeholder, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateTextbox(Data)
    end

    return self:CreateTextbox({
        Name = NameOrData,
        Placeholder = Placeholder,
        Callback = Callback
    })
end

function Library.Sections:AddLabel(TextOrData)
    if type(TextOrData) == "table" then
        local Data = NormalizeNamedData(TextOrData)
        return self:CreateLabel(Data.Name or Data.Text or Data.text or "Label")
    end

    return self:CreateLabel(TextOrData)
end

getgenv().Library = Library
return Library
end)()

local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

local function getSafeGuiParent()
    local parent
    pcall(function()
        if getgenv and type(getgenv().gethui) == "function" then
            parent = getgenv().gethui()
        elseif type(gethui) == "function" then
            parent = gethui()
        end
    end)
    if parent then return parent end

    local canUseCore = pcall(function()
        local test = Instance.new("Folder")
        test.Parent = CoreGui
        test:Destroy()
    end)
    if canUseCore then
        return CoreGui
    end

    local lp = Players.LocalPlayer or Players:GetPlayers()[1]
    if lp then
        local pg = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
        if pg then return pg end
    end
    return CoreGui
end

local gethui = function()
    return getSafeGuiParent()
end


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local Watermark = nil
local allToggles = {}
local combatState = {
    AimbotTarget = nil,
    TargetLocked = nil,
    SilentTarget = nil,
    SilentLocked = nil,
    FOVRotationAngle = 0,
    SilentFOVRotationAngle = 0,
    LastTriggerShot = 0,
}

local targetHudGroup = nil
local hpBarFill = nil
local hpText = nil
local targetHudName = nil
local targetHudUser = nil
local targetHudMeta = nil
local targetAvatar = nil
local hsBadge = nil
local hsBadgeText = nil

local player = Players.LocalPlayer
local localUserName = (player and player.Name) or "Player"
local Theme = Library.Theme

local function getPing()
    local success, ping = pcall(function()
        local stats = game:GetService("Stats")
        local net = stats:FindFirstChild("Network")
        local item = net and net:FindFirstChild("ServerStatsItem") and net.ServerStatsItem:FindFirstChild("Data Ping")
        if item then
            return math.floor(tonumber(item:GetValueString():match("%d+")) or 0)
        end
        return 0
    end)
    return (success and ping) or 0
end

local function makePageSubtabs(page, tabsList, defaultTab)
    local activeTab = defaultTab or tabsList[1]
    local tabButtons = {}
    local tabSections = {}

    local col1 = page.Columns and page.Columns[1] and page.Columns[1].Instance
    local subtabHolder = Instance.new("Frame")
    subtabHolder.Name = "SubtabHolder_" .. page.Name
    subtabHolder.Parent = col1
    subtabHolder.Size = UDim2.new(1, 0, 0, 36)
    subtabHolder.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    subtabHolder.BorderSizePixel = 0
    subtabHolder.LayoutOrder = -100
    Library:AddToTheme(subtabHolder, {BackgroundColor3 = "Element"})

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 8)
    sc.Parent = subtabHolder

    local ss = Instance.new("UIStroke")
    ss.Color = Color3.fromRGB(30, 30, 42)
    ss.Transparency = 0.3
    ss.Thickness = 1
    ss.Parent = subtabHolder
    Library:AddToTheme(ss, {Color = "Outline"})

    local sp = Instance.new("UIPadding")
    sp.PaddingTop = UDim.new(0, 4)
    sp.PaddingBottom = UDim.new(0, 4)
    sp.PaddingLeft = UDim.new(0, 4)
    sp.PaddingRight = UDim.new(0, 4)
    sp.Parent = subtabHolder

    local sl = Instance.new("UIListLayout")
    sl.Parent = subtabHolder
    sl.FillDirection = Enum.FillDirection.Horizontal
    sl.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sl.VerticalAlignment = Enum.VerticalAlignment.Center
    sl.Padding = UDim.new(0, 4)

    local numTabs = #tabsList
    local function updateTabVisibility(tabName)
        activeTab = tabName
        for name, btn in pairs(tabButtons) do
            local isAct = (name == tabName)
            local bg = isAct and (Theme.Accent or Color3.fromRGB(139, 149, 246)) or Color3.fromRGB(16, 16, 22)
            local txt = isAct and (Theme.Background or Color3.fromRGB(7, 7, 9)) or Color3.fromRGB(160, 165, 185)
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if stroke then
                TweenService:Create(stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = isAct and 0.2 or 0.8,
                    Color = isAct and (Theme.Accent or Color3.fromRGB(139, 149, 246)) or Color3.fromRGB(32, 32, 44)
                }):Play()
            end
            TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = bg,
                TextColor3 = txt
            }):Play()
        end
        for name, secs in pairs(tabSections) do
            for _, sec in ipairs(secs) do
                if sec.Items and sec.Items["SectionOutline"] then
                    sec.Items["SectionOutline"].Instance.Visible = (name == tabName)
                end
            end
        end
    end

    for _, tabName in ipairs(tabsList) do
        tabSections[tabName] = {}
        local btn = Instance.new("TextButton")
        btn.Name = "SubtabBtn_" .. tabName:gsub("%s+", "")
        btn.Parent = subtabHolder
        btn.Size = UDim2.new(1 / numTabs, -4, 1, 0)
        btn.BackgroundColor3 = (tabName == activeTab) and (Theme.Accent or Color3.fromRGB(139, 149, 246)) or Color3.fromRGB(16, 16, 22)
        btn.BorderSizePixel = 0
        btn.FontFace = Library.Font
        btn.Text = tabName
        btn.TextColor3 = (tabName == activeTab) and (Theme.Background or Color3.fromRGB(7, 7, 9)) or Color3.fromRGB(160, 165, 185)
        btn.TextSize = 11
        btn.AutoButtonColor = false

        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 6)
        bc.Parent = btn

        local bs = Instance.new("UIStroke")
        bs.Thickness = 1
        bs.Color = (tabName == activeTab) and (Theme.Accent or Color3.fromRGB(139, 149, 246)) or Color3.fromRGB(32, 32, 44)
        bs.Transparency = (tabName == activeTab) and 0.2 or 0.8
        bs.Parent = btn

        btn.MouseEnter:Connect(function()
            if tabName ~= activeTab then
                TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(24, 24, 34),
                    TextColor3 = Color3.fromRGB(225, 230, 245)
                }):Play()
            end
        end)

        btn.MouseLeave:Connect(function()
            if tabName ~= activeTab then
                TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(16, 16, 22),
                    TextColor3 = Color3.fromRGB(160, 165, 185)
                }):Play()
            end
        end)

        btn.MouseButton1Click:Connect(function()
            updateTabVisibility(tabName)
        end)
        tabButtons[tabName] = btn
    end

    local function registerSection(tabName, section)
        if not tabSections[tabName] then tabSections[tabName] = {} end
        table.insert(tabSections[tabName], section)
        if section.Items and section.Items["SectionOutline"] then
            section.Items["SectionOutline"].Instance.Visible = (tabName == activeTab)
        end
    end

    return registerSection, updateTabVisibility
end

Library.MenuKeybind = tostring(Enum.KeyCode.Insert)

local LOGO = "rbxassetid://134242818164054"
local PAGE_ICON = "rbxassetid://72196061405823"

local ICON_MOVE = "rbxassetid://114551690399915"
local ICON_VISUALS = "rbxassetid://100033680381365"
local ICON_CLIENT = "rbxassetid://93142176757189"
local ICON_SETTINGS = "rbxassetid://80758916183665"
local ICON_SEARCH = "rbxassetid://121018724060431"
local ICON_SLIDERS = "rbxassetid://85538382643347"
local ICON_TROLL = "rbxassetid://104491311361166"
local ICON_COMBAT = "rbxassetid://87563802520297"
local ICON_MUSIC = "rbxassetid://113343203848535"
local ICON_SKIP_BACK = "rbxassetid://70466132711334"
local ICON_SKIP_FORWARD = "rbxassetid://124844823753990"
local ICON_PLAY = "rbxassetid://135609604299893"
local ICON_PAUSE = "rbxassetid://74873705394436"
local ICON_FLAME = "rbxassetid://98218034436456"
local ICON_BIRD = "rbxassetid://132284145117371"
local ICON_CIRCLEI = "rbxassetid://130359823580534"
local ICON_CROWN = "rbxassetid://127843403295538"
local ICON_FOOTPRINTS = "rbxassetid://139192589041315"
local ICON_CLOCK = "rbxassetid://121808839832144"
local ICON_SUN = "rbxassetid://110150589884127"
local ICON_CLOUD = "rbxassetid://121226497050352"
local ICON_CAMERA = "rbxassetid://79950339943067"
local ICON_WAND = "rbxassetid://114580617777835"
local ICON_LIGHTBULB = "rbxassetid://103871245626488"
local ICON_GAUGE = "rbxassetid://110273524101447"
local ICON_SPARKLES = "rbxassetid://138635884129147"
local ICON_SKULL = "rbxassetid://137726256442333"
local ICON_SCANEYE = "rbxassetid://99244790601968"
local ICON_BOT = "rbxassetid://80451686744860"
local ICON_THEME = "rbxassetid://73803440257131"
local ICON_CONFIGS = "rbxassetid://74885853379841"
local ICON_DEFAULT_SEC = "rbxassetid://127136375066593"
local ICON_CHEVRON = "rbxassetid://10709790948"

local holderGui = Library.Holder.Instance
pcall(function()
    holderGui.DisplayOrder = 100
end)

local Window = Library:Window({
    Name = "swatware",
    Logo = LOGO,
})

if Window.Items["OptsBtn"] then
    Window.Items["OptsBtn"].Instance.Visible = false
    Window.Items["OptsBtn"].Instance.Size = UDim2.new(0, 0, 0, 0)
end

local unloaded = false
local updatePreviewOverlay = nil
local syncPreviewPosition = nil

local menuBlurSize = 14
local menuOpenState = false
local menuBlur = nil
local hudBlurFrames = {}

local function applyMenuVisuals(open)
    menuOpenState = open

    if open and menuBlurSize > 0 then
        if not menuBlur then
            menuBlur = Instance.new("BlurEffect")
            menuBlur.Name = "AltHack_MenuBlur"
            menuBlur.Size = 0
            menuBlur.Parent = Lighting
        end

        TweenService:Create(menuBlur, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = menuBlurSize}):Play()
    else
        if menuBlur then
            local b = menuBlur
            menuBlur = nil

            local tw = TweenService:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = 0})
            tw.Completed:Connect(function()
                b:Destroy()
            end)
            tw:Play()
        end
    end
end

local originalUnload = Library.Unload
local cleanupComplete = false
function Library:Unload()
    if cleanupComplete then
        return
    end
    cleanupComplete = true
    unloaded = true

    if getgenv().AltHackGen == GEN then
        getgenv().AltHackGen = GEN + 1
    end

    if menuBlur then
        pcall(function()
            menuBlur:Destroy()
        end)
        menuBlur = nil
    end

    for _, object in ipairs(hudBlurFrames) do
        pcall(function()
            object:Destroy()
        end)
    end

    originalUnload(self)
end

local function safeConnect(event, handler)
    local conn
    conn = event:Connect(function(...)
        if getgenv().AltHackGen ~= GEN then
            conn:Disconnect()
            return
        end
        handler(...)
    end)
    return conn
end

local origSetOpen = Window.SetOpen
function Window:SetOpen(v)
    origSetOpen(self, v)
    applyMenuVisuals(v)
    if syncPreviewPosition then
        syncPreviewPosition()
    end
    if updatePreviewOverlay then
        updatePreviewOverlay()
    end

    local mainFrame = Window.Items["MainFrame"].Instance
    local uiScale = mainFrame:FindFirstChild("AltHack_Pop")
    if not uiScale then
        uiScale = Instance.new("UIScale")
        uiScale.Name = "AltHack_Pop"
        uiScale.Parent = mainFrame
    end

    if v then
        uiScale.Scale = 0.93
        TweenService:Create(uiScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

        local pos = mainFrame.Position
        mainFrame.Position = pos + UDim2.new(0, 0, 0, 28)
        TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos}):Play()
    else
        TweenService:Create(uiScale, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.95}):Play()
    end
end

task.defer(applyMenuVisuals, Window.IsOpen)

local fps = 0
do
    local frames = 0
    Library:Connect(RunService.RenderStepped, function()
        frames = frames + 1
    end)
    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            task.wait(0.5)
            fps = frames * 2
            frames = 0
        end
    end)
end

local SwatwareAPI = {
    Users = {},
    Loaded = false,
    Url = "https://swatware-api.avgavg193.workers.dev/users.txt",
    TagColors = {
        ["admin"]     = { Text = Color3.fromRGB(255, 75, 95), Bg = Color3.fromRGB(42, 14, 18), Border = Color3.fromRGB(150, 30, 45) },
        ["dev"]       = { Text = Color3.fromRGB(195, 135, 255), Bg = Color3.fromRGB(32, 16, 48), Border = Color3.fromRGB(120, 55, 175) },
        ["developer"] = { Text = Color3.fromRGB(195, 135, 255), Bg = Color3.fromRGB(32, 16, 48), Border = Color3.fromRGB(120, 55, 175) },
        ["media"]     = { Text = Color3.fromRGB(255, 185, 45), Bg = Color3.fromRGB(42, 28, 10), Border = Color3.fromRGB(160, 105, 20) },
        ["verified"]  = { Text = Color3.fromRGB(60, 210, 255), Bg = Color3.fromRGB(12, 32, 45), Border = Color3.fromRGB(30, 120, 165) },
        ["verifed"]   = { Text = Color3.fromRGB(60, 210, 255), Bg = Color3.fromRGB(12, 32, 45), Border = Color3.fromRGB(30, 120, 165) },
        ["vip"]       = { Text = Color3.fromRGB(60, 245, 145), Bg = Color3.fromRGB(14, 38, 24), Border = Color3.fromRGB(35, 150, 80) },
        ["buyer"]     = { Text = Color3.fromRGB(60, 245, 145), Bg = Color3.fromRGB(14, 38, 24), Border = Color3.fromRGB(35, 150, 80) },
        ["premium"]   = { Text = Color3.fromRGB(60, 245, 145), Bg = Color3.fromRGB(14, 38, 24), Border = Color3.fromRGB(35, 150, 80) },
        ["user"]      = { Text = Color3.fromRGB(180, 190, 205), Bg = Color3.fromRGB(20, 22, 28), Border = Color3.fromRGB(52, 58, 72) },
    }
}

function SwatwareAPI:GetTagStyle(rawTag)
    local t = string.lower(rawTag or "user"):gsub("%s+", "")
    return self.TagColors[t] or self.TagColors["user"]
end

function SwatwareAPI:GetTags(username)
    if not username then return {"user"} end
    local u = string.lower(tostring(username)):gsub("%s+", "")
    local data = self.Users[u]
    if data and data.Tags and #data.Tags > 0 then
        return data.Tags
    end
    return {"user"}
end

function SwatwareAPI:IsRegistered(username)
    if not username then return false end
    local u = string.lower(tostring(username)):gsub("%s+", "")
    return self.Users[u] ~= nil
end

function SwatwareAPI:AutoRegister()
    task.spawn(function()
        pcall(function()
            local lp = Players.LocalPlayer
            if not lp then return end
            local uName = lp.Name
            local uId = lp.UserId
            local exec = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
            local queryParams = string.format("&reg=1&user=%s&uid=%d&exec=%s", game:GetService("HttpService"):UrlEncode(uName), uId, game:GetService("HttpService"):UrlEncode(exec))
            game:HttpGet(SwatwareAPI.Url .. "?t=" .. tostring(tick()) .. queryParams)
        end)
    end)
end

function SwatwareAPI:Fetch()
    task.spawn(function()
        local lp = Players.LocalPlayer
        local uName = lp and lp.Name or "Unknown"
        local uId = lp and lp.UserId or 0
        local exec = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Native"
        local regQuery = string.format("&u=%s&id=%s&ex=%s", game:GetService("HttpService"):UrlEncode(uName), tostring(uId), game:GetService("HttpService"):UrlEncode(exec))

        local success, result = pcall(function()
            return game:HttpGet(SwatwareAPI.Url .. "?t=" .. tostring(tick()) .. regQuery)
        end)
        if success and type(result) == "string" and result ~= "" then
            local newUsers = {}
            for line in string.gmatch(result, "[^\r\n]+") do
                line = line:match("^%s*(.-)%s*$")
                if line ~= "" and not line:match("^#") and not line:match("^%-%-") then
                    local userPart, tagsPart = line:match("^([^=]+)=(.*)$")
                    if userPart and tagsPart then
                        userPart = userPart:match("^%s*(.-)%s*$")
                        local lowerU = string.lower(userPart)
                        local tagsList = {}
                        for tag in string.gmatch(tagsPart, "([^,]+)") do
                            local cleanTag = tag:match("^%s*(.-)%s*$")
                            if cleanTag ~= "" then
                                table.insert(tagsList, string.lower(cleanTag))
                            end
                        end
                        if #tagsList == 0 then
                            table.insert(tagsList, "user")
                        end
                        newUsers[lowerU] = {
                            Raw = userPart,
                            Tags = tagsList
                        }
                    end
                end
            end
            SwatwareAPI.Users = newUsers
            SwatwareAPI.Loaded = true
        end
    end)
end

SwatwareAPI:AutoRegister()
SwatwareAPI:Fetch()
task.spawn(function()
    while not unloaded and getgenv().AltHackGen == GEN do
        task.wait(45)
        SwatwareAPI:Fetch()
    end
end)

local BUILT_IN_THEMES = {
    ["Violet"] = {
        Background = Color3.fromRGB(7, 7, 9),
        Inline = Color3.fromRGB(12, 12, 15),
        Element = Color3.fromRGB(16, 16, 21),
        Outline = Color3.fromRGB(28, 28, 36),
        Accent = Color3.fromRGB(139, 149, 246),
        Text = Color3.fromRGB(235, 235, 245)
    },
    ["Cyan"] = {
        Background = Color3.fromRGB(6, 10, 14),
        Inline = Color3.fromRGB(10, 16, 22),
        Element = Color3.fromRGB(14, 22, 30),
        Outline = Color3.fromRGB(22, 38, 52),
        Accent = Color3.fromRGB(0, 240, 255),
        Text = Color3.fromRGB(230, 245, 255)
    },
    ["Crimson"] = {
        Background = Color3.fromRGB(10, 6, 7),
        Inline = Color3.fromRGB(16, 10, 11),
        Element = Color3.fromRGB(22, 13, 15),
        Outline = Color3.fromRGB(42, 20, 24),
        Accent = Color3.fromRGB(255, 59, 78),
        Text = Color3.fromRGB(255, 235, 238)
    },
    ["Emerald"] = {
        Background = Color3.fromRGB(5, 10, 7),
        Inline = Color3.fromRGB(9, 16, 12),
        Element = Color3.fromRGB(13, 23, 17),
        Outline = Color3.fromRGB(20, 42, 28),
        Accent = Color3.fromRGB(46, 234, 138),
        Text = Color3.fromRGB(230, 255, 240)
    },
    ["Amber"] = {
        Background = Color3.fromRGB(10, 8, 6),
        Inline = Color3.fromRGB(16, 12, 9),
        Element = Color3.fromRGB(23, 17, 12),
        Outline = Color3.fromRGB(45, 30, 18),
        Accent = Color3.fromRGB(255, 165, 38),
        Text = Color3.fromRGB(255, 243, 230)
    },
    ["Tokyo"] = {
        Background = Color3.fromRGB(8, 7, 14),
        Inline = Color3.fromRGB(13, 11, 22),
        Element = Color3.fromRGB(18, 15, 30),
        Outline = Color3.fromRGB(35, 28, 58),
        Accent = Color3.fromRGB(244, 91, 211),
        Text = Color3.fromRGB(245, 235, 255)
    },
    ["Frost"] = {
        Background = Color3.fromRGB(8, 12, 16),
        Inline = Color3.fromRGB(13, 18, 24),
        Element = Color3.fromRGB(18, 25, 33),
        Outline = Color3.fromRGB(28, 42, 56),
        Accent = Color3.fromRGB(114, 195, 255),
        Text = Color3.fromRGB(235, 245, 255)
    },
    ["Monochrome"] = {
        Background = Color3.fromRGB(10, 10, 10),
        Inline = Color3.fromRGB(16, 16, 16),
        Element = Color3.fromRGB(22, 22, 22),
        Outline = Color3.fromRGB(36, 36, 36),
        Accent = Color3.fromRGB(220, 220, 225),
        Text = Color3.fromRGB(250, 250, 250)
    },
    ["Sunset"] = {
        Background = Color3.fromRGB(12, 7, 12),
        Inline = Color3.fromRGB(18, 11, 18),
        Element = Color3.fromRGB(25, 15, 25),
        Outline = Color3.fromRGB(48, 26, 48),
        Accent = Color3.fromRGB(255, 94, 148),
        Text = Color3.fromRGB(255, 235, 245)
    },
    ["Tactical"] = {
        Background = Color3.fromRGB(8, 9, 11),
        Inline = Color3.fromRGB(13, 15, 18),
        Element = Color3.fromRGB(18, 21, 26),
        Outline = Color3.fromRGB(30, 36, 46),
        Accent = Color3.fromRGB(77, 166, 255),
        Text = Color3.fromRGB(235, 240, 248)
    }
}

do
    local oldLogo = Window.Items["Logo"]
    if oldLogo and oldLogo.Instance then
        oldLogo.Instance.Visible = false
        oldLogo.Instance.Size = UDim2.new(0, 0, 0, 0)
    end
    local oldTitle = Window.Items["TitleText"]
    if oldTitle and oldTitle.Instance then
        oldTitle.Instance.Visible = false
    end

    local titleArea = Window.Items["TitleArea"] and Window.Items["TitleArea"].Instance
    if titleArea then
        for _, child in ipairs(titleArea:GetChildren()) do
            if child.Name == "Swatware_TitleGroup" or child.Name == "AltHack_Logo" then
                child:Destroy()
            end
        end

        local titleGroup = Instance.new("Frame")
        titleGroup.Name = "Swatware_TitleGroup"
        titleGroup.Parent = titleArea
        titleGroup.BackgroundTransparency = 1
        titleGroup.Size = UDim2.new(0, 0, 1, 0)
        titleGroup.AutomaticSize = Enum.AutomaticSize.X
        titleGroup.LayoutOrder = 1

        local titleLayout = Instance.new("UIListLayout")
        titleLayout.Parent = titleGroup
        titleLayout.FillDirection = Enum.FillDirection.Horizontal
        titleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        titleLayout.Padding = UDim.new(0, 8)
        titleLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local brandLabel = Instance.new("TextLabel")
        brandLabel.Name = "BrandLabel"
        brandLabel.Parent = titleGroup
        brandLabel.BackgroundTransparency = 1
        brandLabel.FontFace = Library.Font
        brandLabel.Text = "swatware"
        brandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        brandLabel.TextSize = 17
        brandLabel.Size = UDim2.new(0, 0, 1, 0)
        brandLabel.AutomaticSize = Enum.AutomaticSize.X
        brandLabel.LayoutOrder = 1

        local brandGradient = Instance.new("UIGradient")
        brandGradient.Parent = brandLabel
        brandGradient.Rotation = 0

        task.spawn(function()
            while not unloaded and getgenv().AltHackGen == GEN do
                local t = tick()
                local accent = Library.Theme.Accent or Color3.fromRGB(139, 149, 246)
                local white = Color3.fromRGB(255, 255, 255)

                local wavePos = (math.sin(t * 2.2) + 1) * 0.5
                brandGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, accent),
                    ColorSequenceKeypoint.new(math.clamp(wavePos * 0.6 + 0.2, 0.01, 0.99), white),
                    ColorSequenceKeypoint.new(1, accent)
                })
                brandGradient.Offset = Vector2.new(math.sin(t * 1.6) * 0.35, 0)
                task.wait(0.03)
            end
        end)
    end
end

do
    local HomePage = Window:Page({
        Name = "Home",
        Icon = ICON_CROWN,
    })

    local ProfileSection = HomePage:Section({
        Name = "Operator & Identity",
        Icon = ICON_CROWN,
        Side = 1,
    })

    local lp = Players.LocalPlayer
    local userName = lp and lp.Name or "Unknown"
    local displayName = lp and lp.DisplayName or userName
    local userId = lp and lp.UserId or 0
    local accountAge = lp and lp.AccountAge or 0
    local execName = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Native x64"
    local profileContent = ProfileSection.Items["Content"].Instance

    local profileCard = Instance.new("Frame")
    profileCard.Name = "HomeProfileCard"
    profileCard.Parent = profileContent
    profileCard.Size = UDim2.new(1, 0, 0, 108)
    profileCard.BackgroundColor3 = Theme.Element
    profileCard.BorderSizePixel = 0
    profileCard.ClipsDescendants = true
    profileCard.LayoutOrder = -2
    Library:AddToTheme(profileCard, {BackgroundColor3 = "Element"})

    local profileCorner = Instance.new("UICorner")
    profileCorner.CornerRadius = UDim.new(0, 10)
    profileCorner.Parent = profileCard

    local profileStroke = Instance.new("UIStroke")
    profileStroke.Color = Theme.Outline
    profileStroke.Transparency = 0.35
    profileStroke.Thickness = 1
    profileStroke.Parent = profileCard
    Library:AddToTheme(profileStroke, {Color = "Outline"})

    local avatarContainer = Instance.new("Frame")
    avatarContainer.Name = "AvatarWrap"
    avatarContainer.Parent = profileCard
    avatarContainer.BackgroundTransparency = 1
    avatarContainer.AnchorPoint = Vector2.new(0, 0.5)
    avatarContainer.Position = UDim2.new(0, 12, 0.5, 0)
    avatarContainer.Size = UDim2.fromOffset(72, 72)

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "ProfileHeadshot"
    avatar.Parent = avatarContainer
    avatar.BackgroundColor3 = Theme.Background
    avatar.BackgroundTransparency = 0
    avatar.BorderSizePixel = 0
    avatar.ClipsDescendants = true
    avatar.Size = UDim2.fromScale(1, 1)
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.Image = ""

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 12)
    avatarCorner.Parent = avatar

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Theme.Accent
    avatarStroke.Thickness = 1.8
    avatarStroke.Parent = avatar
    Library:AddToTheme(avatarStroke, {Color = "Accent"})

    local avatarDot = Instance.new("Frame")
    avatarDot.Name = "ActiveDot"
    avatarDot.Parent = avatarContainer
    avatarDot.BackgroundColor3 = Color3.fromRGB(56, 239, 125)
    avatarDot.BorderSizePixel = 0
    avatarDot.AnchorPoint = Vector2.new(1, 1)
    avatarDot.Position = UDim2.new(1, 2, 1, 2)
    avatarDot.Size = UDim2.fromOffset(12, 12)
    avatarDot.ZIndex = 5

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = avatarDot

    local dotStroke = Instance.new("UIStroke")
    dotStroke.Color = Theme.Element
    dotStroke.Thickness = 2
    dotStroke.Parent = avatarDot
    Library:AddToTheme(dotStroke, {Color = "Element"})

    local profileName = Instance.new("TextLabel")
    profileName.Name = "DisplayName"
    profileName.Parent = profileCard
    profileName.BackgroundTransparency = 1
    profileName.Position = UDim2.new(0, 96, 0, 14)
    profileName.Size = UDim2.new(1, -108, 0, 22)
    profileName.FontFace = Library.Font
    profileName.Text = displayName
    profileName.TextColor3 = Theme.Text
    profileName.TextSize = 16
    profileName.TextXAlignment = Enum.TextXAlignment.Left
    profileName.TextTruncate = Enum.TextTruncate.AtEnd
    Library:AddToTheme(profileName, {TextColor3 = "Text"})

    local profileHandle = Instance.new("TextLabel")
    profileHandle.Name = "Username"
    profileHandle.Parent = profileCard
    profileHandle.BackgroundTransparency = 1
    profileHandle.Position = UDim2.new(0, 96, 0, 36)
    profileHandle.Size = UDim2.new(1, -108, 0, 16)
    profileHandle.FontFace = Library.Font
    profileHandle.Text = "@" .. userName
    profileHandle.TextColor3 = Theme.Accent
    profileHandle.TextSize = 12
    profileHandle.TextXAlignment = Enum.TextXAlignment.Left
    profileHandle.TextTruncate = Enum.TextTruncate.AtEnd
    Library:AddToTheme(profileHandle, {TextColor3 = "Accent"})

    local badgesRow = Instance.new("Frame")
    badgesRow.Name = "BadgesRow"
    badgesRow.Parent = profileCard
    badgesRow.BackgroundTransparency = 1
    badgesRow.Position = UDim2.new(0, 96, 0, 58)
    badgesRow.Size = UDim2.new(1, -108, 0, 20)

    local brLayout = Instance.new("UIListLayout")
    brLayout.Parent = badgesRow
    brLayout.FillDirection = Enum.FillDirection.Horizontal
    brLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    brLayout.Padding = UDim.new(0, 6)

    local function updateHomeProfileBadges()
        for _, c in ipairs(badgesRow:GetChildren()) do
            if c:IsA("Frame") then
                c:Destroy()
            end
        end

        local execBadge = Instance.new("Frame")
        execBadge.Name = "ExecBadge"
        execBadge.Parent = badgesRow
        execBadge.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
        execBadge.BorderSizePixel = 0
        execBadge.Size = UDim2.new(0, 0, 0, 18)
        execBadge.AutomaticSize = Enum.AutomaticSize.X

        local ebCorner = Instance.new("UICorner")
        ebCorner.CornerRadius = UDim.new(0, 4)
        ebCorner.Parent = execBadge

        local ebStroke = Instance.new("UIStroke")
        ebStroke.Color = Color3.fromRGB(40, 120, 180)
        ebStroke.Thickness = 1
        ebStroke.Transparency = 0.3
        ebStroke.Parent = execBadge

        local ebPad = Instance.new("UIPadding")
        ebPad.PaddingLeft = UDim.new(0, 6)
        ebPad.PaddingRight = UDim.new(0, 6)
        ebPad.Parent = execBadge

        local ebLabel = Instance.new("TextLabel")
        ebLabel.Parent = execBadge
        ebLabel.BackgroundTransparency = 1
        ebLabel.FontFace = Library.Font
        ebLabel.Text = "EXECUTOR: " .. string.upper(tostring(execName))
        ebLabel.TextColor3 = Color3.fromRGB(120, 210, 255)
        ebLabel.TextSize = 9
        ebLabel.Size = UDim2.new(0, 0, 1, 0)
        ebLabel.AutomaticSize = Enum.AutomaticSize.X

        local myTags = SwatwareAPI:GetTags(userName)
        for _, rawTag in ipairs(myTags) do
            local tagStyle = SwatwareAPI:GetTagStyle(rawTag)
            local badge = Instance.new("Frame")
            badge.Name = "TagBadge_" .. tostring(rawTag)
            badge.Parent = badgesRow
            badge.BackgroundColor3 = tagStyle.Bg
            badge.BorderSizePixel = 0
            badge.Size = UDim2.new(0, 0, 0, 18)
            badge.AutomaticSize = Enum.AutomaticSize.X

            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 4)
            bc.Parent = badge

            local bs = Instance.new("UIStroke")
            bs.Color = tagStyle.Border
            bs.Thickness = 1
            bs.Transparency = 0.2
            bs.Parent = badge

            local bp = Instance.new("UIPadding")
            bp.PaddingLeft = UDim.new(0, 6)
            bp.PaddingRight = UDim.new(0, 6)
            bp.Parent = badge

            local bl = Instance.new("TextLabel")
            bl.Parent = badge
            bl.BackgroundTransparency = 1
            bl.FontFace = Library.Font
            bl.Text = string.upper(tostring(rawTag))
            bl.TextColor3 = tagStyle.Text
            bl.TextSize = 9
            bl.Size = UDim2.new(0, 0, 1, 0)
            bl.AutomaticSize = Enum.AutomaticSize.X
        end
    end

    updateHomeProfileBadges()
    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            task.wait(4)
            pcall(updateHomeProfileBadges)
        end
    end)

    task.spawn(function()
        local success, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                userId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if success and avatar.Parent then
            avatar.Image = image
        end
    end)

    local sessionStats = Instance.new("Frame")
    sessionStats.Name = "SessionStats"
    sessionStats.Parent = profileContent
    sessionStats.BackgroundTransparency = 1
    sessionStats.Size = UDim2.new(1, 0, 0, 100)
    sessionStats.BorderSizePixel = 0
    sessionStats.LayoutOrder = -1

    local statsLayout = Instance.new("UIGridLayout")
    statsLayout.Parent = sessionStats
    statsLayout.CellSize = UDim2.new(1 / 3, -4, 0, 46)
    statsLayout.CellPadding = UDim2.new(0, 6, 0, 6)
    statsLayout.FillDirectionMaxCells = 3
    statsLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function makeHomeStat(title, value, order)
        local tile = Instance.new("Frame")
        tile.Name = title:gsub("%s+", "") .. "Stat"
        tile.Parent = sessionStats
        tile.Size = UDim2.new(1 / 3, -4, 0, 46)
        tile.BackgroundColor3 = Theme.Element
        tile.BorderSizePixel = 0
        tile.ClipsDescendants = true
        tile.LayoutOrder = order
        Library:AddToTheme(tile, {BackgroundColor3 = "Element"})

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = tile

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.Outline
        stroke.Transparency = 0.5
        stroke.Thickness = 1
        stroke.Parent = tile
        Library:AddToTheme(stroke, {Color = "Outline"})

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Parent = tile
        titleLabel.BackgroundTransparency = 1
        titleLabel.Position = UDim2.new(0, 8, 0, 6)
        titleLabel.Size = UDim2.new(1, -16, 0, 12)
        titleLabel.FontFace = Library.Font
        titleLabel.Text = string.upper(title)
        titleLabel.TextColor3 = Theme.Text
        titleLabel.TextTransparency = 0.4
        titleLabel.TextSize = 9
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        Library:AddToTheme(titleLabel, {TextColor3 = "Text"})

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = tile
        valueLabel.BackgroundTransparency = 1
        valueLabel.Position = UDim2.new(0, 8, 0, 20)
        valueLabel.Size = UDim2.new(1, -16, 0, 20)
        valueLabel.FontFace = Library.Font
        valueLabel.Text = tostring(value)
        valueLabel.TextColor3 = Theme.Accent
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
        Library:AddToTheme(valueLabel, {TextColor3 = "Accent"})
        return valueLabel
    end

    local accountStat = makeHomeStat("Account age", accountAge .. " days", 1)
    local userIdStat = makeHomeStat("User ID", userId, 2)
    local execStat = makeHomeStat("Executor", execName, 3)
    local fpsStat = makeHomeStat("Client FPS", tostring(fps or 60) .. " FPS", 4)
    local pingStat = makeHomeStat("Server Ping", tostring(getPing()) .. " ms", 5)
    local tierStat = makeHomeStat("User Tier", string.upper(SwatwareAPI:GetTags(userName)[1] or "USER"), 6)

    ProfileSection:Label("Build: SWATWARE v2.4 (Enterprise)")
    ProfileSection:Label("Status: Active • Premium")

    local ActionSection = HomePage:Section({
        Name = "Quick Actions",
        Icon = ICON_BOT,
        Side = 1,
    })

    ActionSection:Button({
        Name = "Copy Discord Invite",
        Callback = function()
            if setclipboard then
                setclipboard("https://discord.gg/swatware")
                Library:Notify("Discord link copied to clipboard!")
            end
        end,
    })

    ActionSection:Button({
        Name = "Copy Server Job ID",
        Callback = function()
            if setclipboard then
                setclipboard(tostring(game.JobId))
                Library:Notify("Server Job ID copied!")
            end
        end,
    })

    ActionSection:Button({
        Name = "Quick Server Hop",
        Callback = function()
            pcall(function()
                local HttpService = game:GetService("HttpService")
                local TeleportService = game:GetService("TeleportService")
                local placeId = game.PlaceId
                local servers = HttpService:JSONDecode(game:HttpGet(
                    "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=50"
                ))
                for _, s in ipairs(servers.data or {}) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(placeId, s.id, Players.LocalPlayer)
                        break
                    end
                end
            end)
        end,
    })

    ActionSection:Button({
        Name = "Rejoin Current Server",
        Callback = function()
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId,
                    Players.LocalPlayer
                )
            end)
        end,
    })

    local SessionSection = HomePage:Section({
        Name = "Live Server & Game",
        Icon = ICON_CLOCK,
        Side = 2,
    })
    SessionSection:Label("Experience: " .. tostring(game.Name))
    SessionSection:Label("Place ID: " .. tostring(game.PlaceId))
    SessionSection:Label("Place Version: " .. tostring(game.PlaceVersion))
    local serverId = game.JobId ~= "" and string.sub(game.JobId, 1, 8) or "Studio"
    SessionSection:Label("Server Job ID: " .. serverId)
    local playersStat = SessionSection:Label(
        string.format("Players in Server: %d / %d", #Players:GetPlayers(), Players.MaxPlayers)
    )

    local NewsSection = HomePage:Section({
        Name = "Updates & Changelog",
        Icon = ICON_SPARKLES,
        Side = 2,
    })

    local changelogData = {
        ["v2.4 (Current)"] = {
            "Multi-Game Hub Loader Engine & Fast Execution",
            "Unified Ultra-Smooth FOV Circles (Aimbot & Silent)",
            "Zero-Default Safe Startup Configuration",
            "Modern Pill Subtab Navigation Bar",
            "Tactical Screen HUD Overlays & Target HUD",
            "Dynamic Multi-Version Interactive Changelogs"
        },
        ["v2.3 (Tactical Engine)"] = {
            "Real-Time Dynamic Target HUD & Keybinds",
            "Keybinds Monitor & Target Profile HUD Cards",
            "Movement Prediction Engine (Ground & Air Tracking)",
            "Sticky Aim Lock & Dynamic Hitpart Resolver",
            "Hitbox Expander with Custom Transparency",
            "RGB & Monochrome Wave ESP Gradient Styling"
        },
        ["v2.2 (Visuals Overhaul)"] = {
            "3D Interactive Viewport ESP Character Preview",
            "Dynamic Atmospheric Fog & Celestial Body Controls",
            "High-Definition Custom Skybox Texture Engine",
            "Enhanced Health Bar Gradients & Distance Tags",
            "Offscreen Indicator Arrows with Custom Radius",
            "Custom Cham Highlights with AlwaysOnTop Support"
        },
        ["v2.1 (Performance)"] = {
            "Unlocked Maximum Frame Rate (240+ FPS Cap)",
            "Optimized RenderStepped Pipelines & Low CPU Usage",
            "Custom Config Profile Import, Export & Deletion",
            "Instant Server Hop & Auto Reconnect Utilities",
            "Discord Integration & Job ID Sharing",
            "Executor Level Safety & Anti-Detection Layer"
        },
        ["v2.0 (Core Engine)"] = {
            "Brand New SWATWARE Sleek Dark Theming Engine",
            "Universal Game Compatibility Architecture",
            "Fast Loadstring Executor Bridge API",
            "Responsive Dual-Column UI Layout System",
            "Interactive Theming Color Pickers & Live Updates",
            "Complete Client Protection & Clean Unload System"
        }
    }

    local logLabels = {}
    for i = 1, 6 do
        logLabels[i] = NewsSection:Label(changelogData["v2.4 (Current)"][i] or "")
    end

    NewsSection:Dropdown({
        Name = "Select Version",
        Flag = "Home_ChangelogVersion",
        Items = {
            "v2.4 (Current)",
            "v2.3 (Tactical Engine)",
            "v2.2 (Visuals Overhaul)",
            "v2.1 (Performance)",
            "v2.0 (Core Engine)"
        },
        Default = "v2.4 (Current)",
        Callback = function(selectedVer)
            local entries = changelogData[selectedVer] or changelogData["v2.4 (Current)"]
            for i = 1, 6 do
                if logLabels[i] then
                    logLabels[i]:SetText(entries[i] or "")
                end
            end
        end
    })

    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            task.wait(0.5)
            pcall(function()
                accountStat.Text = tostring(accountAge) .. " days"
                userIdStat.Text = tostring(userId)
                tierStat.Text = string.upper(SwatwareAPI:GetTags(userName)[1] or "USER")
                playersStat:SetText(
                    string.format("Players in Server: %d / %d", #Players:GetPlayers(), Players.MaxPlayers)
                )
                fpsStat.Text = tostring(fps or 60) .. " FPS"
                local stats = game:GetService("Stats")
                local pingVal = stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                local pingNum = math.floor(tonumber(pingVal:match("%d+")) or 0)
                pingStat.Text = tostring(pingNum) .. " ms"
            end)
        end
    end)
end

do
    local CombatPage = Window:Page({
        Name = "Combat",
        Icon = ICON_COMBAT,
    })

    local registerCombatSubtab, setCombatSubtab = makePageSubtabs(
        CombatPage,
        {"Aimbot", "Silent Aim", "Triggerbot / Hitbox"},
        "Aimbot"
    )

    local AimbotMainSection = CombatPage:Section({
        Name = "Main Aimbot",
        Icon = ICON_COMBAT,
        Side = 1,
    })
    registerCombatSubtab("Aimbot", AimbotMainSection)

    local aimbotGroundDropdown, aimbotAirDropdown, smoothToggle, smoothSlider, easeToggle, easeDropdown, predToggle, predXSlider, predYSlider, offsetToggle, offsetYSlider, offsetXSlider, airYSlider, stickyToggle, checksDropdown

    local aimbotToggle = AimbotMainSection:Toggle({
        Name = "Enable Aimbot",
        Flag = "Combat_Aimbot",
        Default = false,
        Callback = function(val)
            if aimbotGroundDropdown then aimbotGroundDropdown:SetVisibility(val) end
            if aimbotAirDropdown then aimbotAirDropdown:SetVisibility(val) end
            if smoothToggle then smoothToggle:SetVisibility(val) end
            if smoothSlider then smoothSlider:SetVisibility(val and Library.Flags["Combat_UseSmoothing"] == true) end
            if easeToggle then easeToggle:SetVisibility(val) end
            if easeDropdown then easeDropdown:SetVisibility(val and Library.Flags["Combat_UseEasing"] == true) end
            if predToggle then predToggle:SetVisibility(val) end
            if predXSlider then predXSlider:SetVisibility(val and Library.Flags["Combat_UsePrediction"] == true) end
            if predYSlider then predYSlider:SetVisibility(val and Library.Flags["Combat_UsePrediction"] == true) end
            if offsetToggle then offsetToggle:SetVisibility(val) end
            if offsetYSlider then offsetYSlider:SetVisibility(val and Library.Flags["Combat_UseOffsets"] == true) end
            if offsetXSlider then offsetXSlider:SetVisibility(val and Library.Flags["Combat_UseOffsets"] == true) end
            if airYSlider then airYSlider:SetVisibility(val and Library.Flags["Combat_UseOffsets"] == true) end
            if stickyToggle then stickyToggle:SetVisibility(val) end
            if checksDropdown then checksDropdown:SetVisibility(val) end
        end,
    })
    aimbotToggle:Keybind({
        Mode = "Hold",
        Default = Enum.KeyCode.E,
    })

    aimbotGroundDropdown = AimbotMainSection:Dropdown({
        Name = "Hitpart (Ground)",
        Flag = "Combat_HitpartGround",
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"},
        Default = "Head",
    })

    aimbotAirDropdown = AimbotMainSection:Dropdown({
        Name = "Hitpart (Air)",
        Flag = "Combat_HitpartAir",
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"},
        Default = "HumanoidRootPart",
    })

    smoothToggle = AimbotMainSection:Toggle({
        Name = "Use Smoothing",
        Flag = "Combat_UseSmoothing",
        Default = false,
        Callback = function(val)
            if smoothSlider then smoothSlider:SetVisibility(val and Library.Flags["Combat_Aimbot"] == true) end
        end,
    })

    smoothSlider = AimbotMainSection:Slider({
        Name = "Smoothing Amount",
        Flag = "Combat_SmoothingValue",
        Default = 6,
        Min = 1,
        Max = 100,
        Decimals = 1,
    })

    easeToggle = AimbotMainSection:Toggle({
        Name = "Use Easing",
        Flag = "Combat_UseEasing",
        Default = false,
        Callback = function(val)
            if easeDropdown then easeDropdown:SetVisibility(val and Library.Flags["Combat_Aimbot"] == true) end
        end,
    })

    easeDropdown = AimbotMainSection:Dropdown({
        Name = "Easing Style",
        Flag = "Combat_EasingStyle",
        Items = {"Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular"},
        Default = "Quad",
    })

    predToggle = AimbotMainSection:Toggle({
        Name = "Use Movement Prediction",
        Flag = "Combat_UsePrediction",
        Default = false,
        Callback = function(val)
            if predXSlider then predXSlider:SetVisibility(val and Library.Flags["Combat_Aimbot"] == true) end
            if predYSlider then predYSlider:SetVisibility(val and Library.Flags["Combat_Aimbot"] == true) end
        end,
    })

    predXSlider = AimbotMainSection:Slider({
        Name = "Prediction X",
        Flag = "Combat_PredictionX",
        Default = 13.5,
        Min = 0.0,
        Max = 100.0,
        Decimals = 2,
        Suffix = " %",
    })

    predYSlider = AimbotMainSection:Slider({
        Name = "Prediction Y",
        Flag = "Combat_PredictionY",
        Default = 12.0,
        Min = 0.0,
        Max = 100.0,
        Decimals = 2,
        Suffix = " %",
    })

    offsetToggle = AimbotMainSection:Toggle({
        Name = "Custom Offsets",
        Flag = "Combat_UseOffsets",
        Default = false,
        Callback = function(val)
            if offsetYSlider then offsetYSlider:SetVisibility(val and Library.Flags["Combat_Aimbot"] == true) end
            if offsetXSlider then offsetXSlider:SetVisibility(val and Library.Flags["Combat_Aimbot"] == true) end
            if airYSlider then airYSlider:SetVisibility(val and Library.Flags["Combat_Aimbot"] == true) end
        end,
    })

    offsetYSlider = AimbotMainSection:Slider({
        Name = "Offset Up / Down",
        Flag = "Combat_OffsetY",
        Default = 0,
        Min = -100,
        Max = 100,
        Suffix = " px",
    })

    offsetXSlider = AimbotMainSection:Slider({
        Name = "Offset Left / Right",
        Flag = "Combat_OffsetX",
        Default = 0,
        Min = -100,
        Max = 100,
        Suffix = " px",
    })

    airYSlider = AimbotMainSection:Slider({
        Name = "Air Y Offset",
        Flag = "Combat_AirYOffset",
        Default = 0,
        Min = -100,
        Max = 100,
        Suffix = " px",
    })

    stickyToggle = AimbotMainSection:Toggle({
        Name = "Sticky Aim",
        Flag = "Combat_StickyAim",
        Default = false,
    })

    checksDropdown = AimbotMainSection:Dropdown({
        Name = "Target Checks",
        Flag = "Combat_Checks",
        Multi = true,
        Items = {"Team Check", "Wall Check", "Dead Check", "Knocked Check", "ForceField Check", "Ignore Swatware Users"},
        Default = {"Team Check", "Wall Check", "Dead Check"},
    })

    local HumanizationSection = CombatPage:Section({
        Name = "Aimbot Humanization",
        Icon = ICON_BOT,
        Side = 2,
    })
    registerCombatSubtab("Aimbot", HumanizationSection)

    local reactionSlider, jumpDelaySlider, pullResXSlider, pullResYSlider

    local reactionToggle = HumanizationSection:Toggle({
        Name = "Reaction Time Delay",
        Flag = "Combat_ReactionTimeToggle",
        Default = false,
        Callback = function(val)
            if reactionSlider then reactionSlider:SetVisibility(val) end
        end,
    })

    reactionSlider = HumanizationSection:Slider({
        Name = "Reaction Time",
        Flag = "Combat_ReactionTime",
        Default = 50,
        Min = 0,
        Max = 500,
        Suffix = " ms",
    })

    local jumpDelayToggle = HumanizationSection:Toggle({
        Name = "Jump Target Delay",
        Flag = "Combat_JumpDelayToggle",
        Default = false,
        Callback = function(val)
            if jumpDelaySlider then jumpDelaySlider:SetVisibility(val) end
        end,
    })

    jumpDelaySlider = HumanizationSection:Slider({
        Name = "Jump Delay",
        Flag = "Combat_JumpDelay",
        Default = 100,
        Min = 0,
        Max = 1000,
        Suffix = " ms",
    })

    local pullResToggle = HumanizationSection:Toggle({
        Name = "Pull Resolution",
        Flag = "Combat_PullResToggle",
        Default = false,
        Callback = function(val)
            if pullResXSlider then pullResXSlider:SetVisibility(val) end
            if pullResYSlider then pullResYSlider:SetVisibility(val) end
        end,
    })

    pullResXSlider = HumanizationSection:Slider({
        Name = "Pull Resolution X",
        Flag = "Combat_PullResX",
        Default = 10,
        Min = 1,
        Max = 100,
    })

    pullResYSlider = HumanizationSection:Slider({
        Name = "Pull Resolution Y",
        Flag = "Combat_PullResY",
        Default = 10,
        Min = 1,
        Max = 100,
    })

    HumanizationSection:Slider({
        Name = "User Depth Factor",
        Flag = "Combat_UserDepth",
        Default = 20,
        Min = 1,
        Max = 100,
    })

    local AimbotFOVSection = CombatPage:Section({
        Name = "Aimbot FOV",
        Icon = ICON_SCANEYE,
        Side = 2,
    })
    registerCombatSubtab("Aimbot", AimbotFOVSection)

    local drawFovToggle, fovSizeSlider, fovOutlineAlphaSlider, fovFillAlphaSlider, fovSidesSlider, fovSpinToggle, fovSpinSpeedSlider, fovPlacementDropdown

    local useFovToggle = AimbotFOVSection:Toggle({
        Name = "Use FOV Limit",
        Flag = "Combat_UseFOV",
        Default = false,
        Callback = function(val)
            if drawFovToggle then drawFovToggle:SetVisibility(val) end
            if fovSizeSlider then fovSizeSlider:SetVisibility(val) end
            if fovOutlineAlphaSlider then fovOutlineAlphaSlider:SetVisibility(val) end
            if fovFillAlphaSlider then fovFillAlphaSlider:SetVisibility(val) end
            if fovSidesSlider then fovSidesSlider:SetVisibility(val) end
            if fovSpinToggle then fovSpinToggle:SetVisibility(val) end
            if fovSpinSpeedSlider then fovSpinSpeedSlider:SetVisibility(val and Library.Flags["Combat_FOVSpin"] == true) end
            if fovPlacementDropdown then fovPlacementDropdown:SetVisibility(val) end
        end,
    })

    drawFovToggle = AimbotFOVSection:Toggle({
        Name = "Draw FOV Circle",
        Flag = "Combat_DrawFOV",
        Default = false,
    })
    drawFovToggle:Colorpicker({
        Flag = "Combat_FOVColor",
        Default = Theme.Accent or Color3.fromRGB(139, 149, 246),
    })
    drawFovToggle:Colorpicker({
        Flag = "Combat_FOVFillColor",
        Default = Color3.fromRGB(139, 149, 246),
    })

    fovSizeSlider = AimbotFOVSection:Slider({
        Name = "FOV Size",
        Flag = "Combat_FOVRadius",
        Default = 140,
        Min = 10,
        Max = 800,
        Suffix = " px",
    })

    fovOutlineAlphaSlider = AimbotFOVSection:Slider({
        Name = "FOV Outline Alpha",
        Flag = "Combat_FOVOutlineAlpha",
        Default = 0,
        Min = 0,
        Max = 100,
        Suffix = " %",
    })

    fovFillAlphaSlider = AimbotFOVSection:Slider({
        Name = "FOV Fill Alpha",
        Flag = "Combat_FOVFillAlpha",
        Default = 85,
        Min = 0,
        Max = 100,
        Suffix = " %",
    })

    fovSidesSlider = AimbotFOVSection:Slider({
        Name = "FOV Sides",
        Flag = "Combat_FOVSides",
        Default = 64,
        Min = 3,
        Max = 64,
    })

    fovSpinToggle = AimbotFOVSection:Toggle({
        Name = "FOV Rotation Spin",
        Flag = "Combat_FOVSpin",
        Default = false,
        Callback = function(val)
            if fovSpinSpeedSlider then fovSpinSpeedSlider:SetVisibility(val and Library.Flags["Combat_UseFOV"] == true) end
        end,
    })

    fovSpinSpeedSlider = AimbotFOVSection:Slider({
        Name = "FOV Spin Speed",
        Flag = "Combat_FOVSpinSpeed",
        Default = 5,
        Min = 1,
        Max = 50,
    })

    fovPlacementDropdown = AimbotFOVSection:Dropdown({
        Name = "FOV Placement",
        Flag = "Combat_FOVPlacement",
        Items = {"Middle", "Mouse", "On Tool", "On Target"},
        Default = "Middle",
    })

    task.spawn(function()
        local aActive = Library.Flags["Combat_Aimbot"] == true
        if aimbotGroundDropdown then aimbotGroundDropdown:SetVisibility(aActive) end
        if aimbotAirDropdown then aimbotAirDropdown:SetVisibility(aActive) end
        if smoothToggle then smoothToggle:SetVisibility(aActive) end
        if smoothSlider then smoothSlider:SetVisibility(aActive and Library.Flags["Combat_UseSmoothing"] == true) end
        if easeToggle then easeToggle:SetVisibility(aActive) end
        if easeDropdown then easeDropdown:SetVisibility(aActive and Library.Flags["Combat_UseEasing"] == true) end
        if predToggle then predToggle:SetVisibility(aActive) end
        if predXSlider then predXSlider:SetVisibility(aActive and Library.Flags["Combat_UsePrediction"] == true) end
        if predYSlider then predYSlider:SetVisibility(aActive and Library.Flags["Combat_UsePrediction"] == true) end
        if offsetToggle then offsetToggle:SetVisibility(aActive) end
        if offsetYSlider then offsetYSlider:SetVisibility(aActive and Library.Flags["Combat_UseOffsets"] == true) end
        if offsetXSlider then offsetXSlider:SetVisibility(aActive and Library.Flags["Combat_UseOffsets"] == true) end
        if airYSlider then airYSlider:SetVisibility(aActive and Library.Flags["Combat_UseOffsets"] == true) end
        if stickyToggle then stickyToggle:SetVisibility(aActive) end
        if checksDropdown then checksDropdown:SetVisibility(aActive) end
        if reactionSlider then reactionSlider:SetVisibility(Library.Flags["Combat_ReactionTimeToggle"] == true) end
        if jumpDelaySlider then jumpDelaySlider:SetVisibility(Library.Flags["Combat_JumpDelayToggle"] == true) end
        if pullResXSlider then pullResXSlider:SetVisibility(Library.Flags["Combat_PullResToggle"] == true) end
        if pullResYSlider then pullResYSlider:SetVisibility(Library.Flags["Combat_PullResToggle"] == true) end
        if fovSpinSpeedSlider then fovSpinSpeedSlider:SetVisibility(Library.Flags["Combat_FOVSpin"] == true) end
    end)

    local SilentAimMainSection = CombatPage:Section({
        Name = "Silent Aim Main",
        Icon = ICON_SPARKLES,
        Side = 1,
    })
    registerCombatSubtab("Silent Aim", SilentAimMainSection)

    local sPredToggle, sPredSlider, sPredType, sGroundDrop, sAirDrop, sHitChance, sChecks

    local silentAimToggle = SilentAimMainSection:Toggle({
        Name = "Enable Silent Aim",
        Flag = "SilentAim_Enable",
        Default = false,
        Callback = function(val)
            if sPredToggle then sPredToggle:SetVisibility(val) end
            if sPredSlider then sPredSlider:SetVisibility(val and Library.Flags["SilentAim_UsePrediction"] == true) end
            if sPredType then sPredType:SetVisibility(val and Library.Flags["SilentAim_UsePrediction"] == true) end
            if sGroundDrop then sGroundDrop:SetVisibility(val) end
            if sAirDrop then sAirDrop:SetVisibility(val) end
            if sHitChance then sHitChance:SetVisibility(val) end
            if sChecks then sChecks:SetVisibility(val) end
        end,
    })
    silentAimToggle:Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.None,
    })

    sPredToggle = SilentAimMainSection:Toggle({
        Name = "Use Prediction",
        Flag = "SilentAim_UsePrediction",
        Default = false,
        Callback = function(val)
            local sAct = Library.Flags["SilentAim_Enable"] == true
            if sPredSlider then sPredSlider:SetVisibility(val and sAct) end
            if sPredType then sPredType:SetVisibility(val and sAct) end
        end,
    })

    sPredSlider = SilentAimMainSection:Slider({
        Name = "Prediction Amount",
        Flag = "SilentAim_PredictionSlider",
        Default = 13.5,
        Min = 0.0,
        Max = 100.0,
        Decimals = 2,
        Suffix = " %",
    })

    sPredType = SilentAimMainSection:Dropdown({
        Name = "Prediction Type",
        Flag = "SilentAim_PredType",
        Items = {"Manual", "Auto"},
        Default = "Manual",
    })

    sGroundDrop = SilentAimMainSection:Dropdown({
        Name = "Hitpart (Ground)",
        Flag = "SilentAim_HitpartGround",
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"},
        Default = "Head",
    })

    sAirDrop = SilentAimMainSection:Dropdown({
        Name = "Hitpart (Air)",
        Flag = "SilentAim_HitpartAir",
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"},
        Default = "Head",
    })

    sHitChance = SilentAimMainSection:Slider({
        Name = "Hit Chance",
        Flag = "SilentAim_HitChance",
        Default = 100,
        Min = 1,
        Max = 100,
        Suffix = " %",
    })

    sChecks = SilentAimMainSection:Dropdown({
        Name = "Silent Aim Checks",
        Flag = "SilentAim_Checks",
        Multi = true,
        Items = {"Team Check", "Wall Check", "Ignore Swatware Users"},
        Default = {"Team Check", "Wall Check"},
    })

    local SilentAimFOVSection = CombatPage:Section({
        Name = "Silent Aim FOV",
        Icon = ICON_SCANEYE,
        Side = 2,
    })
    registerCombatSubtab("Silent Aim", SilentAimFOVSection)

    local sDrawFov, sFovSize, sOutlineAlpha, sFillAlpha, sFovSides, sFovSpin, sSpinSpeed, sFovPlacement

    local sUseFovToggle = SilentAimFOVSection:Toggle({
        Name = "Use FOV Limit",
        Flag = "SilentAim_UseFOV",
        Default = false,
        Callback = function(val)
            if sDrawFov then sDrawFov:SetVisibility(val) end
            if sFovSize then sFovSize:SetVisibility(val) end
            if sOutlineAlpha then sOutlineAlpha:SetVisibility(val) end
            if sFillAlpha then sFillAlpha:SetVisibility(val) end
            if sFovSides then sFovSides:SetVisibility(val) end
            if sFovSpin then sFovSpin:SetVisibility(val) end
            if sSpinSpeed then sSpinSpeed:SetVisibility(val and Library.Flags["SilentAim_FOVSpin"] == true) end
            if sFovPlacement then sFovPlacement:SetVisibility(val) end
        end,
    })

    sDrawFov = SilentAimFOVSection:Toggle({
        Name = "Draw Silent FOV Circle",
        Flag = "SilentAim_DrawFOV",
        Default = false,
    })
    sDrawFov:Colorpicker({
        Flag = "SilentAim_FOVColor",
        Default = Color3.fromRGB(255, 75, 95),
    })
    sDrawFov:Colorpicker({
        Flag = "SilentAim_FOVFillColor",
        Default = Color3.fromRGB(255, 75, 95),
    })

    sFovSize = SilentAimFOVSection:Slider({
        Name = "Silent FOV Size",
        Flag = "SilentAim_FOVSize",
        Default = 180,
        Min = 10,
        Max = 800,
        Suffix = " px",
    })

    sOutlineAlpha = SilentAimFOVSection:Slider({
        Name = "Outline Alpha",
        Flag = "SilentAim_FOVOutlineAlpha",
        Default = 0,
        Min = 0,
        Max = 100,
        Suffix = " %",
    })

    sFillAlpha = SilentAimFOVSection:Slider({
        Name = "Fill Alpha",
        Flag = "SilentAim_FOVFillAlpha",
        Default = 90,
        Min = 0,
        Max = 100,
        Suffix = " %",
    })

    sFovSides = SilentAimFOVSection:Slider({
        Name = "FOV Sides",
        Flag = "SilentAim_FOVSides",
        Default = 64,
        Min = 3,
        Max = 64,
    })

    sFovSpin = SilentAimFOVSection:Toggle({
        Name = "FOV Spin",
        Flag = "SilentAim_FOVSpin",
        Default = false,
        Callback = function(val)
            if sSpinSpeed then sSpinSpeed:SetVisibility(val and Library.Flags["SilentAim_UseFOV"] == true) end
        end,
    })

    sSpinSpeed = SilentAimFOVSection:Slider({
        Name = "Spin Speed",
        Flag = "SilentAim_FOVSpinSpeed",
        Default = 4,
        Min = 1,
        Max = 50,
    })

    sFovPlacement = SilentAimFOVSection:Dropdown({
        Name = "FOV Placement",
        Flag = "SilentAim_FOVPlacement",
        Items = {"Middle", "Mouse", "On Tool", "On Target"},
        Default = "Mouse",
    })

    task.spawn(function()
        local sAct = Library.Flags["SilentAim_Enable"] == true
        if sPredToggle then sPredToggle:SetVisibility(sAct) end
        if sPredSlider then sPredSlider:SetVisibility(sAct and Library.Flags["SilentAim_UsePrediction"] == true) end
        if sPredType then sPredType:SetVisibility(sAct and Library.Flags["SilentAim_UsePrediction"] == true) end
        if sGroundDrop then sGroundDrop:SetVisibility(sAct) end
        if sAirDrop then sAirDrop:SetVisibility(sAct) end
        if sHitChance then sHitChance:SetVisibility(sAct) end
        if sChecks then sChecks:SetVisibility(sAct) end
        if sSpinSpeed then sSpinSpeed:SetVisibility(Library.Flags["SilentAim_FOVSpin"] == true) end
    end)

    local TriggerbotSection = CombatPage:Section({
        Name = "Triggerbot",
        Icon = ICON_FLAME,
        Side = 1,
    })
    registerCombatSubtab("Triggerbot / Hitbox", TriggerbotSection)

    local trigDelay, trigDist, trigHitChance, trigHeadOnly, trigTeamCheck, trigWallCheck

    local trigToggle = TriggerbotSection:Toggle({
        Name = "Enable Triggerbot",
        Flag = "Triggerbot_Enable",
        Default = false,
        Callback = function(val)
            if trigDelay then trigDelay:SetVisibility(val) end
            if trigDist then trigDist:SetVisibility(val) end
            if trigHitChance then trigHitChance:SetVisibility(val) end
            if trigHeadOnly then trigHeadOnly:SetVisibility(val) end
            if trigTeamCheck then trigTeamCheck:SetVisibility(val) end
            if trigWallCheck then trigWallCheck:SetVisibility(val) end
        end,
    })
    trigToggle:Keybind({
        Mode = "Hold",
        Default = Enum.KeyCode.F,
    })

    trigDelay = TriggerbotSection:Slider({
        Name = "Trigger Delay",
        Flag = "Triggerbot_Delay",
        Default = 15,
        Min = 0,
        Max = 300,
        Suffix = " ms",
    })

    trigDist = TriggerbotSection:Slider({
        Name = "Max Trigger Distance",
        Flag = "Triggerbot_Distance",
        Default = 500,
        Min = 10,
        Max = 2000,
        Suffix = " studs",
    })

    trigHitChance = TriggerbotSection:Slider({
        Name = "Trigger Hit Chance",
        Flag = "Triggerbot_HitChance",
        Default = 100,
        Min = 1,
        Max = 100,
        Suffix = " %",
    })

    trigHeadOnly = TriggerbotSection:Toggle({
        Name = "Head Only",
        Flag = "Triggerbot_HeadOnly",
        Default = false,
    })

    trigTeamCheck = TriggerbotSection:Toggle({
        Name = "Team Check",
        Flag = "Triggerbot_TeamCheck",
        Default = false,
    })

    trigWallCheck = TriggerbotSection:Toggle({
        Name = "Wall / Vis Check",
        Flag = "Triggerbot_WallCheck",
        Default = false,
    })

    local HitboxSection = CombatPage:Section({
        Name = "Hitbox Expander",
        Icon = ICON_SKULL,
        Side = 2,
    })
    registerCombatSubtab("Triggerbot / Hitbox", HitboxSection)

    local hbSize, hbPart, hbTrans, hbColLabel

    local hbToggle = HitboxSection:Toggle({
        Name = "Enable Hitbox Expander",
        Flag = "Hitbox_Enable",
        Default = false,
        Callback = function(val)
            if hbSize then hbSize:SetVisibility(val) end
            if hbPart then hbPart:SetVisibility(val) end
            if hbTrans then hbTrans:SetVisibility(val) end
            if hbColLabel then hbColLabel:SetVisibility(val) end
        end,
    })

    hbSize = HitboxSection:Slider({
        Name = "Hitbox Size",
        Flag = "Hitbox_Size",
        Default = 10,
        Min = 2,
        Max = 50,
        Suffix = " studs",
    })

    hbPart = HitboxSection:Dropdown({
        Name = "Expanded Hitbox Part",
        Flag = "Hitbox_Part",
        Items = {"Head", "HumanoidRootPart", "Torso", "All"},
        Default = "Head",
    })

    hbTrans = HitboxSection:Slider({
        Name = "Hitbox Transparency",
        Flag = "Hitbox_Transparency",
        Default = 60,
        Min = 0,
        Max = 100,
        Suffix = " %",
    })

    hbColLabel = HitboxSection:Label("Hitbox Color")
    hbColLabel:Colorpicker({
        Flag = "Hitbox_Color",
        Default = Color3.fromRGB(255, 60, 60),
    })

    task.spawn(function()
        local tAct = Library.Flags["Triggerbot_Enable"] == true
        if trigDelay then trigDelay:SetVisibility(tAct) end
        if trigDist then trigDist:SetVisibility(tAct) end
        if trigHitChance then trigHitChance:SetVisibility(tAct) end
        if trigHeadOnly then trigHeadOnly:SetVisibility(tAct) end
        if trigTeamCheck then trigTeamCheck:SetVisibility(tAct) end
        if trigWallCheck then trigWallCheck:SetVisibility(tAct) end

        local hAct = Library.Flags["Hitbox_Enable"] == true
        if hbSize then hbSize:SetVisibility(hAct) end
        if hbPart then hbPart:SetVisibility(hAct) end
        if hbTrans then hbTrans:SetVisibility(hAct) end
        if hbColLabel then hbColLabel:SetVisibility(hAct) end
    end)

    local combatState = {
        AimbotActive = false,
        AimbotTarget = nil,
        SilentTarget = nil,
        TriggerbotActive = false,
        LastTriggerShot = 0,
        TargetLocked = nil,
        FOVRotationAngle = 0,
    }

    local fovGui = Instance.new("ScreenGui")
    fovGui.Name = "Swatware_FOVOverlays"
    fovGui.ResetOnSpawn = false
    fovGui.DisplayOrder = 999
    fovGui.IgnoreGuiInset = true
    pcall(function()
        fovGui.Parent = getSafeGuiParent()
    end)

    local fovCircleFrame = Instance.new("Frame")
    fovCircleFrame.Name = "AimbotFOVCircle"
    fovCircleFrame.Parent = fovGui
    fovCircleFrame.BackgroundTransparency = 0.85
    fovCircleFrame.BorderSizePixel = 0
    fovCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircleFrame.Visible = false

    local fovCorner = Instance.new("UICorner")
    fovCorner.CornerRadius = UDim.new(1, 0)
    fovCorner.Parent = fovCircleFrame

    local fovStroke = Instance.new("UIStroke")
    fovStroke.Thickness = 1.5
    fovStroke.Color = Theme.Accent or Color3.fromRGB(139, 149, 246)
    fovStroke.Parent = fovCircleFrame

    local sFovCircleFrame = Instance.new("Frame")
    sFovCircleFrame.Name = "SilentAimFOVCircle"
    sFovCircleFrame.Parent = fovGui
    sFovCircleFrame.BackgroundTransparency = 0.85
    sFovCircleFrame.BorderSizePixel = 0
    sFovCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    sFovCircleFrame.Visible = false

    local sFovCorner = Instance.new("UICorner")
    sFovCorner.CornerRadius = UDim.new(1, 0)
    sFovCorner.Parent = sFovCircleFrame

    local sFovStroke = Instance.new("UIStroke")
    sFovStroke.Thickness = 1.5
    sFovStroke.Color = Color3.fromRGB(255, 75, 95)
    sFovStroke.Parent = sFovCircleFrame

    local function getTargetHitpart(char, hitpartName)
        if not char then return nil end
        if hitpartName == "Random" then
            local parts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}
            local valid = {}
            for _, pName in ipairs(parts) do
                local p = char:FindFirstChild(pName)
                if p then table.insert(valid, p) end
            end
            return (#valid > 0) and valid[math.random(1, #valid)] or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        end
        return char:FindFirstChild(hitpartName) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    end

    local function validateTarget(p, checksList)
        if not p or p == Players.LocalPlayer then return false end
        local char = p.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return false end

        checksList = checksList or {}
        local hasCheck = function(name)
            for _, c in ipairs(checksList) do
                if c == name then return true end
            end
            return false
        end

        if hasCheck("Dead Check") and hum.Health <= 0 then
            return false
        end

        if hasCheck("Team Check") then
            if p.Team ~= nil and Players.LocalPlayer.Team ~= nil and p.Team == Players.LocalPlayer.Team then
                return false
            end
        end

        if hasCheck("ForceField Check") and char:FindFirstChildOfClass("ForceField") then
            return false
        end

        if hasCheck("Knocked Check") then
            local isKnocked = char:FindFirstChild("Knocked") or char:FindFirstChild("KO") or char:GetAttribute("Knocked") or (hum.PlatformStand and hum.Health < 25)
            if isKnocked then return false end
        end

        if hasCheck("Ignore Swatware Users") or hasCheck("Ignore Users - Swatware Users") then
            if p:GetAttribute("SwatwareUser") or p:FindFirstChild("SwatwareUser") then
                return false
            end
        end

        if hasCheck("Wall Check") or hasCheck("Wall / Vis Check") then
            local cam = Workspace.CurrentCamera
            if cam then
                local origin = cam.CFrame.Position
                local targetPos = root.Position
                local dir = (targetPos - origin)
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {Players.LocalPlayer.Character, char}
                rayParams.IgnoreWater = true
                local result = Workspace:Raycast(origin, dir, rayParams)
                if result then
                    return false
                end
            end
        end

        return true
    end

    local function getFOVOrigin(placementMode)
        local cam = Workspace.CurrentCamera
        if not cam then return Vector2.zero end
        local screenCenter = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)

        if placementMode == "Mouse" then
            local mouseLoc = UserInputService:GetMouseLocation()
            return mouseLoc
        elseif placementMode == "On Tool" then
            local char = Players.LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            local handle = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))
            if handle then
                local pos2d, onScreen = cam:WorldToViewportPoint(handle.Position)
                if onScreen and pos2d.Z > 0 then
                    return Vector2.new(pos2d.X, pos2d.Y)
                end
            end
        end
        return screenCenter
    end

    local function getBestAimbotTarget()
        local cam = Workspace.CurrentCamera
        if not cam then return nil, nil end

        local fovOrigin = getFOVOrigin(Library.Flags["Combat_FOVPlacement"] or "Middle")
        local fovRadius = Library.Flags["Combat_FOVRadius"] or 140
        local useFOV = Library.Flags["Combat_UseFOV"] ~= false
        local checks = Library.Flags["Combat_Checks"] or {"Team Check", "Wall Check", "Dead Check"}

        if Library.Flags["Combat_StickyAim"] and combatState.TargetLocked and combatState.TargetLocked.Parent then
            local p = Players:GetPlayerFromCharacter(combatState.TargetLocked)
            if p and validateTarget(p, checks) then
                local char = p.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local isAir = hum and (hum.FloorMaterial == Enum.Material.Air or (char.PrimaryPart and math.abs(char.PrimaryPart.Velocity.Y) > 2))
                local hitPartName = isAir and (Library.Flags["Combat_HitpartAir"] or "HumanoidRootPart") or (Library.Flags["Combat_HitpartGround"] or "Head")
                local part = getTargetHitpart(char, hitPartName)
                if part then
                    local pos2d, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen and pos2d.Z > 0 then
                        local distToOrigin = (Vector2.new(pos2d.X, pos2d.Y) - fovOrigin).Magnitude
                        if not useFOV or distToOrigin <= fovRadius * 1.5 then
                            return p, part
                        end
                    end
                end
            end
        end

        local closestDist = math.huge
        local bestPlayer = nil
        local bestPart = nil

        for _, p in ipairs(Players:GetPlayers()) do
            if validateTarget(p, checks) then
                local char = p.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local isAir = hum and (hum.FloorMaterial == Enum.Material.Air or (char.PrimaryPart and math.abs(char.PrimaryPart.Velocity.Y) > 2))
                local hitPartName = isAir and (Library.Flags["Combat_HitpartAir"] or "HumanoidRootPart") or (Library.Flags["Combat_HitpartGround"] or "Head")
                local part = getTargetHitpart(char, hitPartName)

                if part then
                    local pos2d, onScreen = cam:WorldToViewportPoint(part.Position)
                    if onScreen and pos2d.Z > 0 then
                        local screenDist = (Vector2.new(pos2d.X, pos2d.Y) - fovOrigin).Magnitude
                        if (not useFOV or screenDist <= fovRadius) and screenDist < closestDist then
                            closestDist = screenDist
                            bestPlayer = p
                            bestPart = part
                        end
                    end
                end
            end
        end

        return bestPlayer, bestPart
    end

    local function applyEasing(alpha, style)
        if style == "Sine" then
            return math.sin(alpha * (math.pi / 2))
        elseif style == "Quad" then
            return alpha * alpha
        elseif style == "Cubic" then
            return alpha * alpha * alpha
        elseif style == "Quart" then
            return alpha * alpha * alpha * alpha
        elseif style == "Quint" then
            return alpha * alpha * alpha * alpha * alpha
        elseif style == "Exponential" then
            return (alpha == 0) and 0 or math.pow(2, 10 * (alpha - 1))
        elseif style == "Circular" then
            return 1 - math.sqrt(1 - math.pow(alpha, 2))
        else
            return alpha
        end
    end

    Library:Connect(RunService.RenderStepped, function(dt)
        if unloaded or getgenv().AltHackGen ~= GEN then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end

        local aimDraw = Library.Flags["Combat_DrawFOV"] == true
        if aimDraw then
            local placement = Library.Flags["Combat_FOVPlacement"] or "Middle"
            local fovOrigin = getFOVOrigin(placement)
            local fovRadius = Library.Flags["Combat_FOVRadius"] or 140
            local outlineAlpha = (Library.Flags["Combat_FOVOutlineAlpha"] or 0) / 100
            local fillAlpha = (Library.Flags["Combat_FOVFillAlpha"] or 85) / 100
            local fovColor = Library.Flags["Combat_FOVColor"] or (Theme.Accent or Color3.fromRGB(139, 149, 246))
            local fovFillColor = Library.Flags["Combat_FOVFillColor"] or fovColor

            fovCircleFrame.Visible = true
            fovCircleFrame.Position = UDim2.fromOffset(fovOrigin.X, fovOrigin.Y)
            fovCircleFrame.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
            fovCircleFrame.BackgroundColor3 = fovFillColor
            fovCircleFrame.BackgroundTransparency = fillAlpha
            fovStroke.Color = fovColor
            fovStroke.Transparency = outlineAlpha

            if Library.Flags["Combat_FOVSpin"] then
                local speed = Library.Flags["Combat_FOVSpinSpeed"] or 5
                combatState.FOVRotationAngle = (combatState.FOVRotationAngle + (speed * 40 * dt)) % 360
                fovCircleFrame.Rotation = combatState.FOVRotationAngle
            else
                fovCircleFrame.Rotation = 0
            end
        else
            fovCircleFrame.Visible = false
        end

        local silentDraw = Library.Flags["SilentAim_DrawFOV"] == true
        if silentDraw then
            local placement = Library.Flags["SilentAim_FOVPlacement"] or "Middle"
            local fovOrigin = getFOVOrigin(placement)
            local fovRadius = Library.Flags["SilentAim_FOVSize"] or 180
            local outlineAlpha = (Library.Flags["SilentAim_FOVOutlineAlpha"] or 0) / 100
            local fillAlpha = (Library.Flags["SilentAim_FOVFillAlpha"] or 90) / 100
            local fovColor = Library.Flags["SilentAim_FOVColor"] or Color3.fromRGB(255, 75, 95)
            local fovFillColor = Library.Flags["SilentAim_FOVFillColor"] or fovColor

            sFovCircleFrame.Visible = true
            sFovCircleFrame.Position = UDim2.fromOffset(fovOrigin.X, fovOrigin.Y)
            sFovCircleFrame.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
            sFovCircleFrame.BackgroundColor3 = fovFillColor
            sFovCircleFrame.BackgroundTransparency = fillAlpha
            sFovStroke.Color = fovColor
            sFovStroke.Transparency = outlineAlpha

            if Library.Flags["SilentAim_FOVSpin"] then
                local speed = Library.Flags["SilentAim_SpinSpeed"] or 5
                combatState.SilentFOVRotationAngle = ((combatState.SilentFOVRotationAngle or 0) + (speed * 40 * dt)) % 360
                sFovCircleFrame.Rotation = combatState.SilentFOVRotationAngle
            else
                sFovCircleFrame.Rotation = 0
            end
        else
            sFovCircleFrame.Visible = false
        end

        local aimbotEnabled = Library.Flags["Combat_Aimbot"] == true
        if aimbotEnabled then
            local bestPlayer, targetPart = getBestAimbotTarget()
            if bestPlayer and targetPart then
                combatState.AimbotTarget = bestPlayer
                combatState.TargetLocked = bestPlayer.Character

                local targetPos = targetPart.Position
                local targetVel = targetPart.AssemblyLinearVelocity or targetPart.Velocity or Vector3.zero

                if Library.Flags["Combat_UsePrediction"] then
                    local predX = (Library.Flags["Combat_PredictionX"] or 13.5) / 100
                    local predY = (Library.Flags["Combat_PredictionY"] or 12.0) / 100
                    targetPos = targetPos + Vector3.new(targetVel.X * predX, targetVel.Y * predY, targetVel.Z * predX)
                end

                if Library.Flags["Combat_UseOffsets"] then
                    local offX = (Library.Flags["Combat_OffsetX"] or 0) / 10
                    local offY = (Library.Flags["Combat_OffsetY"] or 0) / 10
                    local hum = bestPlayer.Character:FindFirstChildOfClass("Humanoid")
                    local isAir = hum and hum.FloorMaterial == Enum.Material.Air
                    local airOffY = isAir and ((Library.Flags["Combat_AirYOffset"] or 0) / 10) or 0
                    targetPos = targetPos + Vector3.new(offX, offY + airOffY, 0)
                end

                if Library.Flags["Combat_PullResToggle"] then
                    local rx = (Library.Flags["Combat_PullResX"] or 10) / 50
                    local ry = (Library.Flags["Combat_PullResY"] or 10) / 50
                    targetPos = targetPos + Vector3.new(math.sin(tick() * 10) * rx, math.cos(tick() * 10) * ry, 0)
                end

                local camPos = cam.CFrame.Position
                local targetCF = CFrame.new(camPos, targetPos)

                if Library.Flags["Combat_UseSmoothing"] then
                    local smoothVal = math.clamp(Library.Flags["Combat_SmoothingValue"] or 6, 1, 100)
                    local alpha = math.clamp(dt * (60 / smoothVal), 0.01, 1)

                    if Library.Flags["Combat_UseEasing"] then
                        alpha = applyEasing(alpha, Library.Flags["Combat_EasingStyle"] or "Quad")
                    end

                    cam.CFrame = cam.CFrame:Lerp(targetCF, alpha)
                else
                    cam.CFrame = targetCF
                end
            else
                combatState.AimbotTarget = nil
                combatState.TargetLocked = nil
            end
        else
            combatState.AimbotTarget = nil
            combatState.TargetLocked = nil
        end

        if Library.Flags["Hitbox_Enable"] then
            local hbSizeVal = Library.Flags["Hitbox_Size"] or 10
            local hbPartName = Library.Flags["Hitbox_Part"] or "Head"
            local hbTransVal = (Library.Flags["Hitbox_Transparency"] or 60) / 100
            local hbCol = Library.Flags["Hitbox_Color"] or Color3.fromRGB(255, 60, 60)

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Players.LocalPlayer and p.Character then
                    local passTeam = not Library.Flags["Combat_Checks"] or not table.find(Library.Flags["Combat_Checks"], "Team Check") or (p.Team == nil or p.Team ~= Players.LocalPlayer.Team)
                    if passTeam then
                        local partsToExpand = {}
                        if hbPartName == "All" then
                            for _, part in ipairs(p.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                    table.insert(partsToExpand, part)
                                end
                            end
                        else
                            local part = p.Character:FindFirstChild(hbPartName)
                            if part and part:IsA("BasePart") then
                                table.insert(partsToExpand, part)
                            end
                        end

                        for _, part in ipairs(partsToExpand) do
                            pcall(function()
                                part.Size = Vector3.new(hbSizeVal, hbSizeVal, hbSizeVal)
                                part.Transparency = hbTransVal
                                part.Color = hbCol
                                part.CanCollide = false
                            end)
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            task.wait(0.02)
            if Library.Flags["Triggerbot_Enable"] then
                local cam = Workspace.CurrentCamera
                if cam then
                    local mousePos = UserInputService:GetMouseLocation()
                    local unitRay = cam:ViewportPointToRay(mousePos.X, mousePos.Y)
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {Players.LocalPlayer.Character}
                    rayParams.IgnoreWater = true

                    local maxDist = Library.Flags["Triggerbot_Distance"] or 500
                    local hitResult = Workspace:Raycast(unitRay.Origin, unitRay.Direction * maxDist, rayParams)

                    if hitResult and hitResult.Instance then
                        local hitPart = hitResult.Instance
                        local targetChar = hitPart:FindFirstAncestorOfClass("Model")
                        local targetPlayer = targetChar and Players:GetPlayerFromCharacter(targetChar)

                        if targetPlayer and targetPlayer ~= Players.LocalPlayer then
                            local checks = {}
                            if Library.Flags["Triggerbot_TeamCheck"] then table.insert(checks, "Team Check") end
                            if Library.Flags["Triggerbot_WallCheck"] then table.insert(checks, "Wall Check") end
                            table.insert(checks, "Dead Check")

                            if validateTarget(targetPlayer, checks) then
                                local headOnly = Library.Flags["Triggerbot_HeadOnly"]
                                if not headOnly or hitPart.Name == "Head" then
                                    local hitChance = Library.Flags["Triggerbot_HitChance"] or 100
                                    if math.random(1, 100) <= hitChance then
                                        local delayMs = Library.Flags["Triggerbot_Delay"] or 15
                                        if delayMs > 0 then task.wait(delayMs / 1000) end

                                        pcall(function()
                                            if mouse1click then
                                                mouse1click()
                                            elseif mouse1press and mouse1release then
                                                mouse1press()
                                                task.wait(0.02)
                                                mouse1release()
                                            else
                                                local tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                                if tool then tool:Activate() end
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

do
    local VisualsPage = Window:Page({
        Name = "Visuals",
        Icon = ICON_VISUALS,
    })

    local registerVisualsSubtab, setVisualsSubtab = makePageSubtabs(
        VisualsPage,
        {"Player ESP", "World"},
        "Player ESP"
    )

    local espConfig = {
        MasterEnabled = false,
        ThemeSync = false,
        ShowPreview = false,
        AutoRotatePreview = false,
        PreviewSpeed = 1.0,
        PreviewZoom = 9.2,

        Box = false,
        BoxStyle = "Corner Box",
        BoxColor = Theme.Accent or Color3.fromRGB(139, 149, 246),

        Name = false,
        NameColor = Color3.fromRGB(255, 255, 255),

        Health = false,
        HealthColor = Color3.fromRGB(56, 239, 125),
        HealthBarWidth = 2,
        HealthBarMode = "Gradient (Green-Red)",
        HealthText = false,

        HeadDot = false,
        HeadDotColor = Color3.fromRGB(255, 255, 255),
        HeadDotSize = 5,

        Distance = false,
        DistanceColor = Color3.fromRGB(180, 190, 210),

        Weapon = false,
        WeaponColor = Color3.fromRGB(255, 215, 0),

        GradientText = false,
        GradientMode = "Static Dual Color",
        GradientColor1 = Color3.fromRGB(255, 255, 255),
        GradientColor2 = Theme.Accent or Color3.fromRGB(139, 149, 246),
        AnimatedGradientText = false,

        Skeleton = false,
        SkeletonColor = Color3.fromRGB(255, 255, 255),

        Tracers = false,
        TracerColor = Theme.Accent or Color3.fromRGB(139, 149, 246),
        TracerOrigin = "Bottom Screen",

        Offscreen = false,
        OffscreenColor = Theme.Accent or Color3.fromRGB(139, 149, 246),
        OffscreenRadius = 220,

        Chams = false,
        ChamsColor = Theme.Accent or Color3.fromRGB(139, 149, 246),
        ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
        ChamsMaterial = "Highlight",
        ChamsFillTransparency = 0.4,
        ChamsOutlineTransparency = 0.1,
        ChamsThroughWalls = true,
        ChamsPulse = false,

        TeamCheck = true,
        MaxDistance = 2500
    }
    Library.ESPConfig = espConfig

    local function getEspTextGradientSequence(mode, c1, c2)
        c1 = c1 or espConfig.GradientColor1 or Color3.fromRGB(255, 255, 255)
        c2 = c2 or espConfig.GradientColor2 or (Library.Theme.Accent or Color3.fromRGB(139, 149, 246))
        if mode == "Monochrome Wave" then
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.3, Color3.fromRGB(180, 180, 190)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 30)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 180, 190)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
            })
        elseif mode == "Theme Shimmer" then
            local acc = Library.Theme.Accent or c2
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, acc),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
            })
        elseif mode == "Rainbow Wave" then
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 80, 80)),
                ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 200, 80)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 255, 120)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(80, 200, 255)),
                ColorSequenceKeypoint.new(0.8, Color3.fromRGB(180, 80, 255)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 80, 80)),
            })
        else
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, c1),
                ColorSequenceKeypoint.new(1.0, c2),
            })
        end
    end

    local bwGradientSequence = getEspTextGradientSequence("Monochrome Wave")

    updatePreviewOverlay = nil
    local buildOrUpdatePreviewAvatar = nil
    local syncPreviewPosition = nil

    Library.OnThemeChanged = function(themeKey, newColor)
        if themeKey == "Accent" and espConfig.ThemeSync then
            espConfig.BoxColor = newColor
            espConfig.TracerColor = newColor
            espConfig.ChamsColor = newColor
            espConfig.OffscreenColor = newColor
            espConfig.GradientColor2 = newColor
            if updatePreviewOverlay then
                updatePreviewOverlay()
            end
        end
    end

    local PlayerESPSection = VisualsPage:Section({
        Name = "Player ESP",
        Icon = ICON_VISUALS,
        Side = 1,
    })
    registerVisualsSubtab("Player ESP", PlayerESPSection)

    local boxStyleDropdown
    local gradStyleDropdown
    local healthBarWidthSlider, healthBarModeDropdown, healthTextToggle
    local headDotSizeSlider
    local tracerOriginDropdown
    local offscreenRadiusSlider

    PlayerESPSection:Toggle({
        Name = "Master ESP Toggle",
        Flag = "Visuals_MasterESP",
        Default = false,
        Callback = function(val)
            espConfig.MasterEnabled = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    PlayerESPSection:Toggle({
        Name = "Sync ESP Colors with Theme",
        Flag = "Visuals_ThemeSyncESP",
        Default = false,
        Callback = function(val)
            espConfig.ThemeSync = val
            if val and Library.Theme.Accent then
                espConfig.BoxColor = Library.Theme.Accent
                espConfig.TracerColor = Library.Theme.Accent
                espConfig.ChamsColor = Library.Theme.Accent
                espConfig.OffscreenColor = Library.Theme.Accent
                espConfig.GradientColor2 = Library.Theme.Accent
                if updatePreviewOverlay then updatePreviewOverlay() end
            end
        end,
    })

    local boxToggle = PlayerESPSection:Toggle({
        Name = "Box ESP",
        Flag = "Visuals_BoxESP",
        Default = false,
        Callback = function(val)
            espConfig.Box = val
            if boxStyleDropdown then boxStyleDropdown:SetVisibility(val) end
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    boxToggle:Colorpicker({
        Flag = "Visuals_BoxColor",
        Default = Color3.fromRGB(139, 149, 246),
        Callback = function(val)
            espConfig.BoxColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    boxStyleDropdown = PlayerESPSection:Dropdown({
        Name = "Box Style",
        Flag = "Visuals_BoxStyle",
        Items = {"Corner Box", "2D Full Box"},
        Default = "Corner Box",
        Callback = function(val)
            espConfig.BoxStyle = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    local nameToggle = PlayerESPSection:Toggle({
        Name = "Name ESP",
        Flag = "Visuals_NameESP",
        Default = false,
        Callback = function(val)
            espConfig.Name = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    nameToggle:Colorpicker({
        Flag = "Visuals_NameColor",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(val)
            espConfig.NameColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    local gradToggle = PlayerESPSection:Toggle({
        Name = "Gradient ESP Text",
        Flag = "Visuals_GradientText",
        Default = false,
        Callback = function(val)
            espConfig.GradientText = val
            if gradStyleDropdown then gradStyleDropdown:SetVisibility(val) end
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    gradToggle:Colorpicker({
        Flag = "Visuals_GradColor1",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(val)
            espConfig.GradientColor1 = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    gradToggle:Colorpicker({
        Flag = "Visuals_GradColor2",
        Default = Color3.fromRGB(139, 149, 246),
        Callback = function(val)
            espConfig.GradientColor2 = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    gradStyleDropdown = PlayerESPSection:Dropdown({
        Name = "Gradient Style",
        Flag = "Visuals_GradientStyle",
        Items = {"Static Dual Color", "Monochrome Wave", "Theme Shimmer", "Rainbow Wave"},
        Default = "Static Dual Color",
        Callback = function(val)
            espConfig.GradientMode = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    local healthToggle = PlayerESPSection:Toggle({
        Name = "Health Bar & Number",
        Flag = "Visuals_HealthESP",
        Default = false,
        Callback = function(val)
            espConfig.Health = val
            if healthBarWidthSlider then healthBarWidthSlider:SetVisibility(val) end
            if healthBarModeDropdown then healthBarModeDropdown:SetVisibility(val) end
            if healthTextToggle then healthTextToggle:SetVisibility(val) end
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    healthToggle:Colorpicker({
        Flag = "Visuals_HealthColor",
        Default = Color3.fromRGB(56, 239, 125),
        Callback = function(val)
            espConfig.HealthColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    healthBarWidthSlider = PlayerESPSection:Slider({
        Name = "Health Bar Width",
        Flag = "Visuals_HealthBarWidth",
        Default = 2,
        Min = 1,
        Max = 8,
        Suffix = " px",
        Callback = function(val)
            espConfig.HealthBarWidth = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    healthBarModeDropdown = PlayerESPSection:Dropdown({
        Name = "Health Bar Mode",
        Flag = "Visuals_HealthBarMode",
        Items = {"Gradient (Green-Red)", "Theme Accent", "Solid Health Color"},
        Default = "Gradient (Green-Red)",
        Callback = function(val)
            espConfig.HealthBarMode = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    healthTextToggle = PlayerESPSection:Toggle({
        Name = "Show Health Number",
        Flag = "Visuals_HealthText",
        Default = false,
        Callback = function(val)
            espConfig.HealthText = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    local headDotToggle = PlayerESPSection:Toggle({
        Name = "Head Dot ESP",
        Flag = "Visuals_HeadDot",
        Default = false,
        Callback = function(val)
            espConfig.HeadDot = val
            if headDotSizeSlider then headDotSizeSlider:SetVisibility(val) end
        end,
    })
    headDotToggle:Colorpicker({
        Flag = "Visuals_HeadDotColor",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(val)
            espConfig.HeadDotColor = val
        end,
    })

    headDotSizeSlider = PlayerESPSection:Slider({
        Name = "Head Dot Radius",
        Flag = "Visuals_HeadDotSize",
        Default = 5,
        Min = 2,
        Max = 14,
        Suffix = " px",
        Callback = function(val)
            espConfig.HeadDotSize = val
        end,
    })

    local distToggle = PlayerESPSection:Toggle({
        Name = "Distance ESP",
        Flag = "Visuals_DistanceESP",
        Default = false,
        Callback = function(val)
            espConfig.Distance = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    distToggle:Colorpicker({
        Flag = "Visuals_DistanceColor",
        Default = Color3.fromRGB(180, 190, 210),
        Callback = function(val)
            espConfig.DistanceColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    local weaponToggle = PlayerESPSection:Toggle({
        Name = "Equipped Weapon ESP",
        Flag = "Visuals_WeaponESP",
        Default = false,
        Callback = function(val)
            espConfig.Weapon = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    weaponToggle:Colorpicker({
        Flag = "Visuals_WeaponColor",
        Default = Color3.fromRGB(255, 215, 0),
        Callback = function(val)
            espConfig.WeaponColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    local skelToggle = PlayerESPSection:Toggle({
        Name = "Skeleton / Joints ESP",
        Flag = "Visuals_SkeletonESP",
        Default = false,
        Callback = function(val)
            espConfig.Skeleton = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    skelToggle:Colorpicker({
        Flag = "Visuals_SkeletonColor",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(val)
            espConfig.SkeletonColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    local tracerToggle = PlayerESPSection:Toggle({
        Name = "Tracers ESP",
        Flag = "Visuals_TracerESP",
        Default = false,
        Callback = function(val)
            espConfig.Tracers = val
            if tracerOriginDropdown then tracerOriginDropdown:SetVisibility(val) end
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    tracerToggle:Colorpicker({
        Flag = "Visuals_TracerColor",
        Default = Color3.fromRGB(139, 149, 246),
        Callback = function(val)
            espConfig.TracerColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    tracerOriginDropdown = PlayerESPSection:Dropdown({
        Name = "Tracer Origin",
        Flag = "Visuals_TracerOrigin",
        Items = {"Bottom Screen", "Center Screen", "Mouse Position"},
        Default = "Bottom Screen",
        Callback = function(val)
            espConfig.TracerOrigin = val
        end,
    })

    local offscreenToggle = PlayerESPSection:Toggle({
        Name = "Offscreen Direction Arrows",
        Flag = "Visuals_OffscreenArrows",
        Default = false,
        Callback = function(val)
            espConfig.Offscreen = val
            if offscreenRadiusSlider then offscreenRadiusSlider:SetVisibility(val) end
        end,
    })
    offscreenToggle:Colorpicker({
        Flag = "Visuals_OffscreenColor",
        Default = Color3.fromRGB(139, 149, 246),
        Callback = function(val)
            espConfig.OffscreenColor = val
        end,
    })

    offscreenRadiusSlider = PlayerESPSection:Slider({
        Name = "Offscreen Arrow Radius",
        Flag = "Visuals_OffscreenRadius",
        Default = 220,
        Min = 100,
        Max = 450,
        Suffix = " px",
        Callback = function(val)
            espConfig.OffscreenRadius = val
        end,
    })

    local ChamsSection = VisualsPage:Section({
        Name = "Chams & Materials",
        Icon = ICON_SHIELD,
        Side = 1,
    })
    registerVisualsSubtab("Player ESP", ChamsSection)

    local chamsMaterialDropdown, chamsFillTransSlider, chamsOutlineTransSlider, chamsThroughWallsToggle, chamsPulseToggle

    local chamsToggle = ChamsSection:Toggle({
        Name = "Enable Chams",
        Flag = "Visuals_ChamsESP",
        Default = false,
        Callback = function(val)
            espConfig.Chams = val
            if chamsMaterialDropdown then chamsMaterialDropdown:SetVisibility(val) end
            if chamsFillTransSlider then chamsFillTransSlider:SetVisibility(val) end
            if chamsOutlineTransSlider then chamsOutlineTransSlider:SetVisibility(val) end
            if chamsThroughWallsToggle then chamsThroughWallsToggle:SetVisibility(val) end
            if chamsPulseToggle then chamsPulseToggle:SetVisibility(val) end
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    chamsToggle:Colorpicker({
        Flag = "Visuals_ChamsFillColor",
        Default = Color3.fromRGB(139, 149, 246),
        Callback = function(val)
            espConfig.ChamsColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    chamsToggle:Colorpicker({
        Flag = "Visuals_ChamsOutlineColor",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(val)
            espConfig.ChamsOutlineColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    chamsMaterialDropdown = ChamsSection:Dropdown({
        Name = "Chams Material",
        Flag = "Visuals_ChamsMaterial",
        Items = {"Highlight", "Neon", "ForceField", "Glass", "Wireframe", "Ghost", "SmoothPlastic"},
        Default = "Highlight",
        Callback = function(val)
            espConfig.ChamsMaterial = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    chamsFillTransSlider = ChamsSection:Slider({
        Name = "Fill Transparency",
        Flag = "Visuals_ChamsFillTrans",
        Default = 0.4,
        Min = 0.0,
        Max = 1.0,
        Decimals = 2,
        Callback = function(val)
            espConfig.ChamsFillTransparency = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    chamsOutlineTransSlider = ChamsSection:Slider({
        Name = "Outline Transparency",
        Flag = "Visuals_ChamsOutlineTrans",
        Default = 0.1,
        Min = 0.0,
        Max = 1.0,
        Decimals = 2,
        Callback = function(val)
            espConfig.ChamsOutlineTransparency = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    chamsThroughWallsToggle = ChamsSection:Toggle({
        Name = "Through Walls (AlwaysOnTop)",
        Flag = "Visuals_ChamsThroughWalls",
        Default = false,
        Callback = function(val)
            espConfig.ChamsThroughWalls = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    chamsPulseToggle = ChamsSection:Toggle({
        Name = "Chams Breathing Pulse",
        Flag = "Visuals_ChamsPulse",
        Default = false,
        Callback = function(val)
            espConfig.ChamsPulse = val
        end,
    })

    task.spawn(function()
        if boxStyleDropdown then boxStyleDropdown:SetVisibility(espConfig.Box) end
        if gradStyleDropdown then gradStyleDropdown:SetVisibility(espConfig.GradientText) end
        if healthBarWidthSlider then healthBarWidthSlider:SetVisibility(espConfig.Health) end
        if healthBarModeDropdown then healthBarModeDropdown:SetVisibility(espConfig.Health) end
        if healthTextToggle then healthTextToggle:SetVisibility(espConfig.Health) end
        if headDotSizeSlider then headDotSizeSlider:SetVisibility(espConfig.HeadDot) end
        if tracerOriginDropdown then tracerOriginDropdown:SetVisibility(espConfig.Tracers) end
        if offscreenRadiusSlider then offscreenRadiusSlider:SetVisibility(espConfig.Offscreen) end
        if chamsMaterialDropdown then chamsMaterialDropdown:SetVisibility(espConfig.Chams) end
        if chamsFillTransSlider then chamsFillTransSlider:SetVisibility(espConfig.Chams) end
        if chamsOutlineTransSlider then chamsOutlineTransSlider:SetVisibility(espConfig.Chams) end
        if chamsThroughWallsToggle then chamsThroughWallsToggle:SetVisibility(espConfig.Chams) end
        if chamsPulseToggle then chamsPulseToggle:SetVisibility(espConfig.Chams) end
    end)

    local PreviewSection = VisualsPage:Section({
        Name = "3D ESP Preview System",
        Icon = ICON_SCANEYE,
        Side = 2,
    })
    registerVisualsSubtab("Player ESP", PreviewSection)
    PreviewSection.Items["SectionOutline"].Instance.LayoutOrder = -10

    local previewWindow = Instance.new("Frame")
    previewWindow.Name = "Swatware_DockedESPPreview"
    previewWindow.Parent = holderGui
    previewWindow.Size = UDim2.new(0, 230, 0, 310)
    previewWindow.BackgroundColor3 = Theme.Background
    previewWindow.BorderSizePixel = 0
    previewWindow.ClipsDescendants = true
    previewWindow.ZIndex = 50
    previewWindow.Visible = espConfig.ShowPreview and Window.IsOpen
    Library:AddToTheme(previewWindow, {BackgroundColor3 = "Background"})

    local pwCorner = Instance.new("UICorner")
    pwCorner.CornerRadius = UDim.new(0, 8)
    pwCorner.Parent = previewWindow

    local pwStroke = Instance.new("UIStroke")
    pwStroke.Color = Theme.Outline
    pwStroke.Transparency = 0.25
    pwStroke.Thickness = 1
    pwStroke.Parent = previewWindow
    Library:AddToTheme(pwStroke, {Color = "Outline"})

    local pwHeader = Instance.new("Frame")
    pwHeader.Name = "HeaderBar"
    pwHeader.Parent = previewWindow
    pwHeader.Size = UDim2.new(1, 0, 0, 30)
    pwHeader.BackgroundColor3 = Theme.Inline
    pwHeader.BorderSizePixel = 0
    pwHeader.ZIndex = 51
    Library:AddToTheme(pwHeader, {BackgroundColor3 = "Inline"})

    local pwHeaderCorner = Instance.new("UICorner")
    pwHeaderCorner.CornerRadius = UDim.new(0, 8)
    pwHeaderCorner.Parent = pwHeader

    local pwHeaderLine = Instance.new("Frame")
    pwHeaderLine.Name = "BottomLine"
    pwHeaderLine.Parent = pwHeader
    pwHeaderLine.BackgroundColor3 = Theme.Outline
    pwHeaderLine.BorderSizePixel = 0
    pwHeaderLine.Position = UDim2.new(0, 0, 1, -1)
    pwHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    pwHeaderLine.ZIndex = 52
    Library:AddToTheme(pwHeaderLine, {BackgroundColor3 = "Outline"})

    local pwHeaderPad = Instance.new("UIPadding")
    pwHeaderPad.PaddingLeft = UDim.new(0, 8)
    pwHeaderPad.PaddingRight = UDim.new(0, 8)
    pwHeaderPad.Parent = pwHeader

    local pwHeaderLayout = Instance.new("UIListLayout")
    pwHeaderLayout.Parent = pwHeader
    pwHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    pwHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    pwHeaderLayout.Padding = UDim.new(0, 6)
    pwHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local pwIcon = Instance.new("ImageLabel")
    pwIcon.Name = "Icon"
    pwIcon.Parent = pwHeader
    pwIcon.BackgroundTransparency = 1
    pwIcon.Size = UDim2.fromOffset(13, 13)
    pwIcon.Image = ICON_SCANEYE
    pwIcon.ImageColor3 = Theme.Accent
    pwIcon.LayoutOrder = 1
    pwIcon.ZIndex = 53
    Library:AddToTheme(pwIcon, {ImageColor3 = "Accent"})

    local pwTitle = Instance.new("TextLabel")
    pwTitle.Name = "Title"
    pwTitle.Parent = pwHeader
    pwTitle.BackgroundTransparency = 1
    pwTitle.FontFace = Library.Font
    pwTitle.Text = "ESP PREVIEW"
    pwTitle.TextColor3 = Theme.Text
    pwTitle.TextSize = 11
    pwTitle.Size = UDim2.new(0, 0, 1, 0)
    pwTitle.AutomaticSize = Enum.AutomaticSize.X
    pwTitle.LayoutOrder = 2
    pwTitle.ZIndex = 53
    Library:AddToTheme(pwTitle, {TextColor3 = "Text"})

    local pwBadge = Instance.new("Frame")
    pwBadge.Name = "Badge"
    pwBadge.Parent = pwHeader
    pwBadge.BackgroundColor3 = Theme.Element
    pwBadge.BackgroundTransparency = 0.3
    pwBadge.BorderSizePixel = 0
    pwBadge.Size = UDim2.new(0, 0, 0, 16)
    pwBadge.AutomaticSize = Enum.AutomaticSize.X
    pwBadge.LayoutOrder = 3
    pwBadge.ZIndex = 53
    Library:AddToTheme(pwBadge, {BackgroundColor3 = "Element"})

    local pwBadgeCorner = Instance.new("UICorner")
    pwBadgeCorner.CornerRadius = UDim.new(0, 4)
    pwBadgeCorner.Parent = pwBadge

    local pwBadgePad = Instance.new("UIPadding")
    pwBadgePad.PaddingLeft = UDim.new(0, 5)
    pwBadgePad.PaddingRight = UDim.new(0, 5)
    pwBadgePad.Parent = pwBadge

    local pwBadgeLayout = Instance.new("UIListLayout")
    pwBadgeLayout.Parent = pwBadge
    pwBadgeLayout.FillDirection = Enum.FillDirection.Horizontal
    pwBadgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    pwBadgeLayout.Padding = UDim.new(0, 4)

    local pwLiveDot = Instance.new("Frame")
    pwLiveDot.Name = "Dot"
    pwLiveDot.Parent = pwBadge
    pwLiveDot.Size = UDim2.fromOffset(5, 5)
    pwLiveDot.BackgroundColor3 = Color3.fromRGB(56, 239, 125)
    pwLiveDot.BorderSizePixel = 0
    pwLiveDot.ZIndex = 54
    local pwLiveDotCorner = Instance.new("UICorner")
    pwLiveDotCorner.CornerRadius = UDim.new(1, 0)
    pwLiveDotCorner.Parent = pwLiveDot

    local pwBadgeText = Instance.new("TextLabel")
    pwBadgeText.Name = "Text"
    pwBadgeText.Parent = pwBadge
    pwBadgeText.BackgroundTransparency = 1
    pwBadgeText.FontFace = Library.Font
    pwBadgeText.Text = "LOCKED"
    pwBadgeText.TextColor3 = Theme.Accent
    pwBadgeText.TextSize = 9
    pwBadgeText.Size = UDim2.new(0, 0, 1, 0)
    pwBadgeText.AutomaticSize = Enum.AutomaticSize.X
    pwBadgeText.ZIndex = 54
    Library:AddToTheme(pwBadgeText, {TextColor3 = "Accent"})

    local mainFrame = Window.Items["MainFrame"] and Window.Items["MainFrame"].Instance
    syncPreviewPosition = function()
        if mainFrame and previewWindow then
            if Window.IsOpen and espConfig.ShowPreview then
                local mPos = mainFrame.AbsolutePosition
                local mSize = mainFrame.AbsoluteSize
                previewWindow.Position = UDim2.fromOffset(mPos.X + mSize.X + 8, mPos.Y)
                previewWindow.Visible = true
            else
                previewWindow.Visible = false
            end
        end
    end
    if mainFrame then
        mainFrame:GetPropertyChangedSignal("Position"):Connect(syncPreviewPosition)
        mainFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncPreviewPosition)
        mainFrame:GetPropertyChangedSignal("Size"):Connect(syncPreviewPosition)
        mainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncPreviewPosition)
    end
    syncPreviewPosition()

    local previewCard = Instance.new("Frame")
    previewCard.Name = "ViewportContainer"
    previewCard.Parent = previewWindow
    previewCard.Position = UDim2.new(0, 8, 0, 36)
    previewCard.Size = UDim2.new(1, -16, 1, -44)
    previewCard.BackgroundColor3 = Theme.Inline
    previewCard.BorderSizePixel = 0
    previewCard.ClipsDescendants = true
    previewCard.ZIndex = 52
    Library:AddToTheme(previewCard, {BackgroundColor3 = "Inline"})

    local pCardCorner = Instance.new("UICorner")
    pCardCorner.CornerRadius = UDim.new(0, 6)
    pCardCorner.Parent = previewCard

    local pCardStroke = Instance.new("UIStroke")
    pCardStroke.Color = Theme.Outline
    pCardStroke.Transparency = 0.5
    pCardStroke.Thickness = 1
    pCardStroke.Parent = previewCard
    Library:AddToTheme(pCardStroke, {Color = "Outline"})

    local gridLayer = Instance.new("Frame")
    gridLayer.Name = "GridDecor"
    gridLayer.Parent = previewCard
    gridLayer.Size = UDim2.fromScale(1, 1)
    gridLayer.BackgroundTransparency = 1
    gridLayer.ZIndex = 53

    local function makeGuide(pos, size)
        local f = Instance.new("Frame")
        f.Parent = gridLayer
        f.BackgroundColor3 = Theme.Outline
        f.BackgroundTransparency = 0.8
        f.BorderSizePixel = 0
        f.Position = pos
        f.Size = size
        f.ZIndex = 53
        Library:AddToTheme(f, {BackgroundColor3 = "Outline"})
        return f
    end
    makeGuide(UDim2.new(0.5, -60, 0.5, 0), UDim2.new(0, 120, 0, 1))
    makeGuide(UDim2.new(0.5, 0, 0.5, -60), UDim2.new(0, 1, 0, 120))

    local viewportFrame = Instance.new("ViewportFrame")
    viewportFrame.Name = "Player3DViewport"
    viewportFrame.Parent = previewCard
    viewportFrame.Size = UDim2.fromScale(1, 1)
    viewportFrame.BackgroundTransparency = 1
    viewportFrame.BorderSizePixel = 0
    viewportFrame.Ambient = Color3.fromRGB(200, 200, 215)
    viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
    viewportFrame.LightDirection = Vector3.new(-1, -1.8, -1.2)
    viewportFrame.ZIndex = 54

    local viewportCamera = Instance.new("Camera")
    viewportCamera.Parent = viewportFrame
    viewportCamera.FieldOfView = 40
    viewportCamera.CFrame = CFrame.lookAt(Vector3.new(0, -0.4, espConfig.PreviewZoom), Vector3.new(0, -0.4, 0))
    viewportFrame.CurrentCamera = viewportCamera

    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = viewportFrame

    local function projectToPreview(pos)
        local cardSize = previewCard.AbsoluteSize
        local w = (cardSize.X > 10) and cardSize.X or 214
        local h = (cardSize.Y > 10) and cardSize.Y or 258

        local pCam = viewportCamera.CFrame:PointToObjectSpace(pos)
        local z = -pCam.Z
        if z <= 0.05 then
            return Vector2.new(w * 0.5, h * 0.5), false, z
        end

        local halfFovY = math.tan(math.rad(viewportCamera.FieldOfView) / 2)
        local aspect = w / h
        local halfFovX = halfFovY * aspect

        local normX = pCam.X / (z * halfFovX)
        local normY = pCam.Y / (z * halfFovY)

        local screenX = (normX * 0.5 + 0.5) * w
        local screenY = (-normY * 0.5 + 0.5) * h

        return Vector2.new(screenX, screenY), true, z
    end

    local previewCharModel = nil
    local originalPartMaterials = {}
    local originalPartColors = {}
    local originalPartTrans = {}

    local overlayContainer = Instance.new("Frame")
    overlayContainer.Name = "ESPOverlayCanvas"
    overlayContainer.Parent = previewCard
    overlayContainer.Size = UDim2.fromScale(1, 1)
    overlayContainer.BackgroundTransparency = 1
    overlayContainer.ZIndex = 60

    local previewBoxFrame = Instance.new("Frame")
    previewBoxFrame.Name = "PreviewBoxFrame"
    previewBoxFrame.Parent = overlayContainer
    previewBoxFrame.BackgroundTransparency = 1
    previewBoxFrame.BorderSizePixel = 0
    previewBoxFrame.AnchorPoint = Vector2.new(0.5, 0)
    previewBoxFrame.Position = UDim2.new(0.5, 0, 0.15, 0)
    previewBoxFrame.Size = UDim2.new(0, 80, 0, 160)
    previewBoxFrame.ZIndex = 62

    local previewBoxOuterStroke = Instance.new("UIStroke")
    previewBoxOuterStroke.Name = "BoxOuterStroke"
    previewBoxOuterStroke.Thickness = 1.0
    previewBoxOuterStroke.LineJoinMode = Enum.LineJoinMode.Miter
    previewBoxOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    previewBoxOuterStroke.Color = Color3.fromRGB(0, 0, 0)
    previewBoxOuterStroke.Parent = previewBoxFrame

    local previewBoxInner = Instance.new("Frame")
    previewBoxInner.Name = "InnerStrokeFrame"
    previewBoxInner.Parent = previewBoxFrame
    previewBoxInner.Size = UDim2.fromScale(1, 1)
    previewBoxInner.BackgroundTransparency = 1
    previewBoxInner.BorderSizePixel = 0
    previewBoxInner.ZIndex = 63

    local previewBoxStroke = Instance.new("UIStroke")
    previewBoxStroke.Name = "BoxStroke"
    previewBoxStroke.Thickness = 1.0
    previewBoxStroke.LineJoinMode = Enum.LineJoinMode.Miter
    previewBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    previewBoxStroke.Color = espConfig.BoxColor
    previewBoxStroke.Parent = previewBoxInner

    local cornerGroup = Instance.new("Frame")
    cornerGroup.Name = "CornerGroup"
    cornerGroup.Parent = previewBoxFrame
    cornerGroup.Size = UDim2.fromScale(1, 1)
    cornerGroup.BackgroundTransparency = 1
    cornerGroup.ZIndex = 64

    local function rebuildPreviewCorners()
        for _, ch in ipairs(cornerGroup:GetChildren()) do ch:Destroy() end
        local col = espConfig.BoxColor
        local L = 10

        local function addCorner(hPos, vPos, hSize, vSize, hForePos, vForePos, hForeSize, vForeSize)
            local hb = Instance.new("Frame")
            hb.Parent = cornerGroup
            hb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            hb.BorderSizePixel = 0
            hb.Position = hPos
            hb.Size = hSize
            hb.ZIndex = 64

            local hf = Instance.new("Frame")
            hf.Parent = cornerGroup
            hf.BackgroundColor3 = col
            hf.BorderSizePixel = 0
            hf.Position = hForePos
            hf.Size = hForeSize
            hf.ZIndex = 65

            local vb = Instance.new("Frame")
            vb.Parent = cornerGroup
            vb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            vb.BorderSizePixel = 0
            vb.Position = vPos
            vb.Size = vSize
            vb.ZIndex = 64

            local vf = Instance.new("Frame")
            vf.Parent = cornerGroup
            vf.BackgroundColor3 = col
            vf.BorderSizePixel = 0
            vf.Position = vForePos
            vf.Size = vForeSize
            vf.ZIndex = 65
        end

        addCorner(
            UDim2.new(0, -1, 0, -1), UDim2.new(0, -1, 0, -1),
            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
            UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0),
            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
        )

        addCorner(
            UDim2.new(1, -L - 1, 0, -1), UDim2.new(1, -2, 0, -1),
            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
            UDim2.new(1, -L, 0, 0), UDim2.new(1, -1, 0, 0),
            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
        )

        addCorner(
            UDim2.new(0, -1, 1, -2), UDim2.new(0, -1, 1, -L - 1),
            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
            UDim2.new(0, 0, 1, -1), UDim2.new(0, 0, 1, -L),
            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
        )

        addCorner(
            UDim2.new(1, -L - 1, 1, -2), UDim2.new(1, -2, 1, -L - 1),
            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
            UDim2.new(1, -L, 1, -1), UDim2.new(1, -1, 1, -L),
            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
        )
    end
    rebuildPreviewCorners()

    local previewHealthBg = Instance.new("Frame")
    previewHealthBg.Name = "HealthBg"
    previewHealthBg.Parent = previewBoxFrame
    previewHealthBg.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    previewHealthBg.BorderSizePixel = 0
    previewHealthBg.Position = UDim2.new(0, -(espConfig.HealthBarWidth + 3), 0, 0)
    previewHealthBg.Size = UDim2.new(0, espConfig.HealthBarWidth, 1, 0)
    previewHealthBg.ZIndex = 65

    local hpStroke = Instance.new("UIStroke")
    hpStroke.Color = Color3.fromRGB(0, 0, 0)
    hpStroke.Thickness = 1
    hpStroke.LineJoinMode = Enum.LineJoinMode.Miter
    hpStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    hpStroke.Parent = previewHealthBg

    local previewHealthFill = Instance.new("Frame")
    previewHealthFill.Name = "HealthFill"
    previewHealthFill.Parent = previewHealthBg
    previewHealthFill.BackgroundColor3 = espConfig.HealthColor
    previewHealthFill.BorderSizePixel = 0
    previewHealthFill.AnchorPoint = Vector2.new(0, 1)
    previewHealthFill.Position = UDim2.new(0, 0, 1, 0)
    previewHealthFill.Size = UDim2.new(1, 0, 1.0, 0)
    previewHealthFill.ZIndex = 66

    local previewHealthNum = Instance.new("TextLabel")
    previewHealthNum.Name = "HealthNum"
    previewHealthNum.Parent = previewHealthBg
    previewHealthNum.BackgroundTransparency = 1
    previewHealthNum.FontFace = Library.Font
    previewHealthNum.Text = "100"
    previewHealthNum.TextColor3 = espConfig.HealthColor
    previewHealthNum.TextStrokeTransparency = 0
    previewHealthNum.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    previewHealthNum.TextSize = 9
    previewHealthNum.Position = UDim2.new(0, -22, 0, 0)
    previewHealthNum.Size = UDim2.new(0, 18, 0, 12)
    previewHealthNum.TextXAlignment = Enum.TextXAlignment.Right
    previewHealthNum.ZIndex = 66

    local function makePreviewLabel(name, pos, anchor, size, text, col, txtSize)
        local lbl = Instance.new("TextLabel")
        lbl.Name = name
        lbl.Parent = previewBoxFrame
        lbl.BackgroundTransparency = 1
        lbl.FontFace = Library.Font
        lbl.Text = text
        lbl.TextColor3 = col
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextSize = txtSize
        lbl.Position = pos
        lbl.AnchorPoint = anchor
        lbl.Size = size
        lbl.ZIndex = 66

        local grad = Instance.new("UIGradient")
        grad.Name = "TextGradient"
        grad.Color = bwGradientSequence
        grad.Enabled = espConfig.AnimatedGradientText
        grad.Parent = lbl

        return lbl, grad
    end

    local previewNameLabel, previewNameGrad = makePreviewLabel("NameLabel", UDim2.new(0.5, 0, 0, -15), Vector2.new(0.5, 0), UDim2.new(0, 150, 0, 13), Players.LocalPlayer.DisplayName .. " (@" .. Players.LocalPlayer.Name .. ")", espConfig.NameColor, 10)
    local previewDistLabel, previewDistGrad = makePreviewLabel("DistLabel", UDim2.new(0.5, 0, 1, 3), Vector2.new(0.5, 0), UDim2.new(0, 110, 0, 11), "[ 24 studs ]", espConfig.DistanceColor, 9)
    local previewWeaponLabel, previewWeaponGrad = makePreviewLabel("WeaponLabel", UDim2.new(0.5, 0, 1, 15), Vector2.new(0.5, 0), UDim2.new(0, 130, 0, 11), "SWAT M4A1 [30/90]", espConfig.WeaponColor, 9)

    local previewTracer = Instance.new("Frame")
    previewTracer.Name = "Tracer"
    previewTracer.Parent = overlayContainer
    previewTracer.BorderSizePixel = 0
    previewTracer.BackgroundColor3 = espConfig.TracerColor
    previewTracer.AnchorPoint = Vector2.new(0.5, 0.5)
    previewTracer.Position = UDim2.new(0.5, 0, 1, 0)
    previewTracer.Size = UDim2.new(0, 1.5, 0, 65)
    previewTracer.ZIndex = 61

    local tracerStroke = Instance.new("UIStroke")
    tracerStroke.Color = Color3.fromRGB(0, 0, 0)
    tracerStroke.Thickness = 0.8
    tracerStroke.Parent = previewTracer

    local previewSkelLines = Instance.new("Frame")
    previewSkelLines.Name = "SkelLines"
    previewSkelLines.Parent = overlayContainer
    previewSkelLines.Size = UDim2.fromScale(1, 1)
    previewSkelLines.BackgroundTransparency = 1
    previewSkelLines.ZIndex = 61

    local function makeSkelLine()
        local line = Instance.new("Frame")
        line.Parent = previewSkelLines
        line.BackgroundColor3 = espConfig.SkeletonColor
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.ZIndex = 61

        local lineStroke = Instance.new("UIStroke")
        lineStroke.Color = Color3.fromRGB(0, 0, 0)
        lineStroke.Thickness = 0.8
        lineStroke.Parent = line

        return line
    end

    local skelSegments = {}
    for i = 1, 12 do
        table.insert(skelSegments, makeSkelLine())
    end

    updatePreviewOverlay = function()
        previewWindow.Visible = espConfig.ShowPreview and Window.IsOpen
        if not previewWindow.Visible then return end

        local active = espConfig.MasterEnabled

        previewBoxFrame.Visible = active and espConfig.Box
        previewBoxOuterStroke.Enabled = (espConfig.BoxStyle == "2D Full Box")
        previewBoxInner.Visible = (espConfig.BoxStyle == "2D Full Box")
        previewBoxStroke.Color = espConfig.BoxColor
        cornerGroup.Visible = (espConfig.BoxStyle == "Corner Box")
        rebuildPreviewCorners()

        previewHealthBg.Visible = active and espConfig.Health
        previewHealthBg.Position = UDim2.new(0, -(espConfig.HealthBarWidth + 3), 0, 0)
        previewHealthBg.Size = UDim2.new(0, espConfig.HealthBarWidth, 1, 0)
        previewHealthFill.BackgroundColor3 = (espConfig.HealthBarMode == "Theme Accent" and (Library.Theme.Accent or espConfig.HealthColor)) or espConfig.HealthColor
        previewHealthNum.Visible = espConfig.HealthText
        previewHealthNum.TextColor3 = espConfig.HealthColor

        local curGradSeq = getEspTextGradientSequence(espConfig.GradientMode, espConfig.GradientColor1, espConfig.GradientColor2)
        local gradActive = active and espConfig.GradientText

        previewNameLabel.Visible = active and espConfig.Name
        previewNameLabel.TextColor3 = espConfig.NameColor
        previewNameGrad.Enabled = gradActive
        previewNameGrad.Color = curGradSeq

        previewDistLabel.Visible = active and espConfig.Distance
        previewDistLabel.TextColor3 = espConfig.DistanceColor
        previewDistGrad.Enabled = gradActive
        previewDistGrad.Color = curGradSeq

        previewWeaponLabel.Visible = active and espConfig.Weapon
        previewWeaponLabel.TextColor3 = espConfig.WeaponColor
        previewWeaponGrad.Enabled = gradActive
        previewWeaponGrad.Color = curGradSeq

        previewTracer.Visible = active and espConfig.Tracers
        previewTracer.BackgroundColor3 = espConfig.TracerColor

        previewSkelLines.Visible = active and espConfig.Skeleton
        for _, l in ipairs(skelSegments) do
            l.BackgroundColor3 = espConfig.SkeletonColor
        end

        if previewCharModel then
            local pulse = espConfig.ChamsPulse and ((math.sin(tick() * 4) + 1) / 2) or 0
            local effectiveFillTrans = math.clamp(espConfig.ChamsFillTransparency + (pulse * 0.4), 0, 1)

            for _, p in ipairs(previewCharModel:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    if active and espConfig.Chams then
                        p.Color = espConfig.ChamsColor
                        p.Transparency = (espConfig.ChamsMaterial == "Neon") and 0 or effectiveFillTrans

                        if espConfig.ChamsMaterial == "ForceField" then
                            p.Material = Enum.Material.ForceField
                        elseif espConfig.ChamsMaterial == "Neon" then
                            p.Material = Enum.Material.Neon
                        elseif espConfig.ChamsMaterial == "Glass" then
                            p.Material = Enum.Material.Glass
                            p.Transparency = math.clamp(effectiveFillTrans + 0.2, 0.2, 0.9)
                        elseif espConfig.ChamsMaterial == "Ghost" then
                            p.Material = Enum.Material.ForceField
                            p.Transparency = 0.75
                        elseif espConfig.ChamsMaterial == "Wireframe" then
                            p.Material = Enum.Material.SmoothPlastic
                            p.Transparency = 0.85
                        else
                            p.Material = Enum.Material.SmoothPlastic
                        end
                    else
                        p.Material = originalPartMaterials[p] or Enum.Material.SmoothPlastic
                        p.Color = originalPartColors[p] or Color3.fromRGB(60, 65, 80)
                        p.Transparency = originalPartTrans[p] or 0
                    end
                end
            end
        end
    end

    buildOrUpdatePreviewAvatar = function()
        if previewCharModel then
            pcall(function() previewCharModel:Destroy() end)
            previewCharModel = nil
            table.clear(originalPartMaterials)
            table.clear(originalPartColors)
            table.clear(originalPartTrans)
        end

        local realChar = Players.LocalPlayer.Character
        local clone = nil

        if realChar then
            realChar.Archivable = true
            local success, cl = pcall(function() return realChar:Clone() end)
            realChar.Archivable = false
            if success and cl then
                clone = cl
            end
        end

        if not clone then
            clone = Instance.new("Model")
            clone.Name = "FallbackRig"
            local function mkP(nm, sz, cf, col)
                local p = Instance.new("Part")
                p.Name = nm
                p.Size = sz
                p.CFrame = cf
                p.Color = col or Color3.fromRGB(50, 55, 68)
                p.Material = Enum.Material.SmoothPlastic
                p.Anchored = true
                p.CanCollide = false
                p.Parent = clone
                return p
            end
            local hrp = mkP("HumanoidRootPart", Vector3.new(2, 2, 1), CFrame.new(0, 0, 0))
            hrp.Transparency = 1
            clone.PrimaryPart = hrp
            mkP("Head", Vector3.new(1.2, 1.2, 1.2), CFrame.new(0, 1.5, 0), Color3.fromRGB(60, 65, 80))
            mkP("Torso", Vector3.new(2, 2, 1), CFrame.new(0, 0, 0), Color3.fromRGB(40, 44, 56))
            mkP("Left Arm", Vector3.new(1, 2, 1), CFrame.new(-1.5, 0, 0), Color3.fromRGB(50, 55, 70))
            mkP("Right Arm", Vector3.new(1, 2, 1), CFrame.new(1.5, 0, 0), Color3.fromRGB(50, 55, 70))
            mkP("Left Leg", Vector3.new(1, 2, 1), CFrame.new(-0.5, -2, 0), Color3.fromRGB(35, 38, 50))
            mkP("Right Leg", Vector3.new(1, 2, 1), CFrame.new(0.5, -2, 0), Color3.fromRGB(35, 38, 50))
            local hum = Instance.new("Humanoid")
            hum.Parent = clone
        else

            for _, desc in ipairs(clone:GetDescendants()) do
                if desc:IsA("LuaSourceContainer") or desc:IsA("Sound") or desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") or desc:IsA("ScreenGui") or desc:IsA("Highlight") then
                    desc:Destroy()
                elseif desc:IsA("BasePart") then
                    desc.Anchored = true
                    desc.CanCollide = false
                    desc.CanTouch = false
                    desc.CanQuery = false
                    desc.CastShadow = false
                    desc.Massless = true
                    desc.Velocity = Vector3.zero
                    desc.RotVelocity = Vector3.zero
                    originalPartMaterials[desc] = desc.Material
                    originalPartColors[desc] = desc.Color
                    originalPartTrans[desc] = desc.Transparency
                end
            end

            local hrp = clone:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Transparency = 1
            end

            local hum = clone:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                hum.PlatformStand = true
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end

            local root = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso") or clone:FindFirstChild("UpperTorso") or clone.PrimaryPart
            if not root then
                for _, p in ipairs(clone:GetChildren()) do
                    if p:IsA("BasePart") then
                        root = p
                        break
                    end
                end
            end
            if root then
                clone.PrimaryPart = root
                clone:PivotTo(CFrame.new(0, 0, 0))
            end
        end

        clone.Parent = worldModel
        previewCharModel = clone

        if updatePreviewOverlay then
            updatePreviewOverlay()
        end
    end

    Players.LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        buildOrUpdatePreviewAvatar()
    end)
    Players.LocalPlayer.CharacterAppearanceLoaded:Connect(function()
        task.wait(0.2)
        buildOrUpdatePreviewAvatar()
    end)
    task.spawn(buildOrUpdatePreviewAvatar)

    local previewRotAngle = 0
    local previewRenderConn = nil
    previewRenderConn = RunService.RenderStepped:Connect(function(dt)
        if unloaded or getgenv().AltHackGen ~= GEN then
            if previewRenderConn then
                previewRenderConn:Disconnect()
                previewRenderConn = nil
            end
            return
        end

        if syncPreviewPosition then
            syncPreviewPosition()
        end

        if previewWindow and previewWindow.Visible and Window.IsOpen then
                if espConfig.AutoRotatePreview then
                    previewRotAngle = (previewRotAngle + (45 * espConfig.PreviewSpeed * dt)) % 360
                end

                if espConfig.GradientText then
                    local gOffset = Vector2.new((tick() * 1.2) % 2 - 1, 0)
                    previewNameGrad.Offset = gOffset
                    previewDistGrad.Offset = gOffset
                    previewWeaponGrad.Offset = gOffset
                end

                if previewCharModel and previewCharModel.PrimaryPart then
                    local rotCF = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(previewRotAngle), 0)
                    previewCharModel:PivotTo(rotCF)

                    if espConfig.Chams and espConfig.ChamsPulse then
                        updatePreviewOverlay()
                    end

                    pcall(function()
                        local head = previewCharModel:FindFirstChild("Head")
                        local leftFoot = previewCharModel:FindFirstChild("LeftFoot") or previewCharModel:FindFirstChild("Left Leg") or previewCharModel:FindFirstChild("LeftLowerLeg")
                        local rightFoot = previewCharModel:FindFirstChild("RightFoot") or previewCharModel:FindFirstChild("Right Leg") or previewCharModel:FindFirstChild("RightLowerLeg")
                        local root = previewCharModel.PrimaryPart or previewCharModel:FindFirstChild("HumanoidRootPart") or head

                        if head and root then
                            local headTopPos = head.Position + Vector3.new(0, (head.Size.Y * 0.5) + 0.15, 0)
                            local feetBotPos = (leftFoot and rightFoot and (((leftFoot.Position + rightFoot.Position) * 0.5) - Vector3.new(0, 0.9, 0)))
                                or (leftFoot and (leftFoot.Position - Vector3.new(0, 0.9, 0)))
                                or (root.Position - Vector3.new(0, 2.75, 0))
                            local midPos = (headTopPos + feetBotPos) * 0.5

                            local top2d, okTop = projectToPreview(headTopPos)
                            local btm2d, okBtm = projectToPreview(feetBotPos)
                            local mid2d, okMid = projectToPreview(midPos)

                            if okTop and okBtm and okMid then
                                local cardSize = previewCard.AbsoluteSize
                                local cardW = (cardSize.X > 10) and cardSize.X or 214
                                local cardH = (cardSize.Y > 10) and cardSize.Y or 258

                                local boxH = math.max(30, math.abs(btm2d.Y - top2d.Y))
                                local boxW = math.clamp(boxH * 0.52, 35, 110)

                                previewBoxFrame.Position = UDim2.fromOffset(mid2d.X, top2d.Y)
                                previewBoxFrame.Size = UDim2.fromOffset(boxW, boxH)

                                if espConfig.Tracers and espConfig.MasterEnabled then
                                    local startPos = Vector2.new(cardW * 0.5, cardH)
                                    local endPos = Vector2.new(mid2d.X, btm2d.Y)
                                    local tDx = endPos.X - startPos.X
                                    local tDy = endPos.Y - startPos.Y
                                    local tLen = math.sqrt(tDx * tDx + tDy * tDy)

                                    previewTracer.Visible = true
                                    previewTracer.Position = UDim2.fromOffset((startPos.X + endPos.X) * 0.5, (startPos.Y + endPos.Y) * 0.5)
                                    previewTracer.Size = UDim2.fromOffset(tLen, 1.5)
                                    previewTracer.Rotation = math.deg(math.atan2(tDy, tDx))
                                else
                                    previewTracer.Visible = false
                                end

                                if espConfig.Skeleton and espConfig.MasterEnabled then
                                    local r6Pairs = {
                                        {"Head", "Torso"},
                                        {"Torso", "Left Arm"},
                                        {"Torso", "Right Arm"},
                                        {"Torso", "Left Leg"},
                                        {"Torso", "Right Leg"},
                                    }
                                    local r15Pairs = {
                                        {"Head", "UpperTorso"},
                                        {"UpperTorso", "LowerTorso"},
                                        {"UpperTorso", "LeftUpperArm"},
                                        {"LeftUpperArm", "LeftLowerArm"},
                                        {"LeftLowerArm", "LeftHand"},
                                        {"UpperTorso", "RightUpperArm"},
                                        {"RightUpperArm", "RightLowerArm"},
                                        {"RightLowerArm", "RightHand"},
                                        {"LowerTorso", "LeftUpperLeg"},
                                        {"LeftUpperLeg", "LeftLowerLeg"},
                                        {"LowerTorso", "RightUpperLeg"},
                                        {"RightUpperLeg", "RightLowerLeg"},
                                    }

                                    local isR15 = previewCharModel:FindFirstChild("UpperTorso") ~= nil
                                    local pairsList = isR15 and r15Pairs or r6Pairs

                                    for idx, seg in ipairs(skelSegments) do
                                        local pair = pairsList[idx]
                                        if pair then
                                            local p1 = previewCharModel:FindFirstChild(pair[1])
                                            local p2 = previewCharModel:FindFirstChild(pair[2])
                                            if p1 and p2 then
                                                local v1, ok1 = projectToPreview(p1.Position)
                                                local v2, ok2 = projectToPreview(p2.Position)
                                                if ok1 and ok2 then
                                                    local dx = v2.X - v1.X
                                                    local dy = v2.Y - v1.Y
                                                    local len = math.sqrt(dx*dx + dy*dy)
                                                    seg.Visible = true
                                                    seg.Size = UDim2.fromOffset(len, 1.5)
                                                    seg.Position = UDim2.fromOffset((v1.X + v2.X) * 0.5, (v1.Y + v2.Y) * 0.5)
                                                    seg.Rotation = math.deg(math.atan2(dy, dx))
                                                else
                                                    seg.Visible = false
                                                end
                                            else
                                                seg.Visible = false
                                            end
                                        else
                                            seg.Visible = false
                                        end
                                    end
                                else
                                    for _, seg in ipairs(skelSegments) do seg.Visible = false end
                                end
                            end
                        end
                    end)
                end
            end
    end)

    if updatePreviewOverlay then
        updatePreviewOverlay()
    end

    PreviewSection:Toggle({
        Name = "Show ESP Preview Window",
        Flag = "Visuals_ShowESPPreview",
        Default = false,
        Callback = function(val)
            espConfig.ShowPreview = val
            if syncPreviewPosition then
                syncPreviewPosition()
            end
        end,
    })

    PreviewSection:Toggle({
        Name = "Theme Sync Preview",
        Flag = "Visuals_ThemeSyncESPPreview",
        Default = false,
        Callback = function(val)
            espConfig.ThemeSync = val
            if val and Library.Theme.Accent then
                espConfig.BoxColor = Library.Theme.Accent
                espConfig.TracerColor = Library.Theme.Accent
                espConfig.ChamsColor = Library.Theme.Accent
                if updatePreviewOverlay then updatePreviewOverlay() end
            end
        end,
    })

    PreviewSection:Slider({
        Name = "Preview Camera Zoom",
        Flag = "Visuals_PreviewZoom",
        Default = 9.2,
        Min = 6.0,
        Max = 14.0,
        Decimals = 1,
        Callback = function(val)
            espConfig.PreviewZoom = val
            viewportCamera.CFrame = CFrame.lookAt(Vector3.new(0, -0.4, val), Vector3.new(0, -0.4, 0))
        end,
    })

    PreviewSection:Toggle({
        Name = "Auto-Rotate 3D Character",
        Flag = "Visuals_AutoRotatePreview",
        Default = false,
        Callback = function(val)
            espConfig.AutoRotatePreview = val
        end,
    })

    PreviewSection:Slider({
        Name = "Rotation Speed",
        Flag = "Visuals_PreviewSpeed",
        Default = 1.0,
        Min = 0.2,
        Max = 4.0,
        Decimals = 1,
        Callback = function(val)
            espConfig.PreviewSpeed = val
        end,
    })

    local skyboxData = {
        Active = false,
        Preset = "Synthwave Sunset",
        Spin = false,
        SpinSpeed = 15,
        CurrentAngle = 0,
        SkyInstance = nil,
        CustomBk = "rbxassetid://600830446",
        CustomDn = "rbxassetid://600831635",
        CustomFt = "rbxassetid://600832720",
        CustomLf = "rbxassetid://600886090",
        CustomRt = "rbxassetid://600833862",
        CustomUp = "rbxassetid://600835177",
        SunTexture = "rbxassetid://10843921215",
        MoonTexture = "rbxassetid://644432000",
        SunSize = 11,
        MoonSize = 11,
    }

    local skyboxPresets = {
        ["Synthwave Sunset"] = {
            Bk = "rbxassetid://600830446",
            Dn = "rbxassetid://600831635",
            Ft = "rbxassetid://600832720",
            Lf = "rbxassetid://600886090",
            Rt = "rbxassetid://600833862",
            Up = "rbxassetid://600835177"
        },
        ["Cyberpunk Purple"] = {
            Bk = "rbxassetid://159454299",
            Dn = "rbxassetid://159454296",
            Ft = "rbxassetid://159454293",
            Lf = "rbxassetid://159454286",
            Rt = "rbxassetid://159454300",
            Up = "rbxassetid://159454288"
        },
        ["Deep Space Nebula"] = {
            Bk = "rbxassetid://159454299",
            Dn = "rbxassetid://159454296",
            Ft = "rbxassetid://159454293",
            Lf = "rbxassetid://159454286",
            Rt = "rbxassetid://159454300",
            Up = "rbxassetid://159454288"
        },
        ["Pure Dark Space"] = {
            Bk = "rbxassetid://64448843",
            Dn = "rbxassetid://64448847",
            Ft = "rbxassetid://64448843",
            Lf = "rbxassetid://64448843",
            Rt = "rbxassetid://64448843",
            Up = "rbxassetid://64448847"
        },
        ["Red Nebula"] = {
            Bk = "rbxassetid://401664839",
            Dn = "rbxassetid://401664862",
            Ft = "rbxassetid://401664960",
            Lf = "rbxassetid://401664881",
            Rt = "rbxassetid://401664901",
            Up = "rbxassetid://401664936"
        },
        ["Vaporwave Pink"] = {
            Bk = "rbxassetid://418952356",
            Dn = "rbxassetid://418952578",
            Ft = "rbxassetid://418952379",
            Lf = "rbxassetid://418952399",
            Rt = "rbxassetid://418952424",
            Up = "rbxassetid://418952449"
        },
        ["Twilight Blue"] = {
            Bk = "rbxassetid://264908339",
            Dn = "rbxassetid://264907956",
            Ft = "rbxassetid://264909758",
            Lf = "rbxassetid://264908920",
            Rt = "rbxassetid://264909264",
            Up = "rbxassetid://264909998"
        }
    }

    local function applySkybox()
        pcall(function()
            if not skyboxData.Active then
                if skyboxData.SkyInstance then
                    skyboxData.SkyInstance:Destroy()
                    skyboxData.SkyInstance = nil
                end
                return
            end

            if not skyboxData.SkyInstance then
                local s = Instance.new("Sky")
                s.Name = "Swatware_Sky"
                s.Parent = Lighting
                skyboxData.SkyInstance = s
            end

            local preset = skyboxPresets[skyboxData.Preset]
            local bk = (preset and preset.Bk) or skyboxData.CustomBk
            local dn = (preset and preset.Dn) or skyboxData.CustomDn
            local ft = (preset and preset.Ft) or skyboxData.CustomFt
            local lf = (preset and preset.Lf) or skyboxData.CustomLf
            local rt = (preset and preset.Rt) or skyboxData.CustomRt
            local up = (preset and preset.Up) or skyboxData.CustomUp

            skyboxData.SkyInstance.SkyboxBk = bk
            skyboxData.SkyInstance.SkyboxDn = dn
            skyboxData.SkyInstance.SkyboxFt = ft
            skyboxData.SkyInstance.SkyboxLf = lf
            skyboxData.SkyInstance.SkyboxRt = rt
            skyboxData.SkyInstance.SkyboxUp = up
            skyboxData.SkyInstance.SunTextureId = skyboxData.SunTexture
            skyboxData.SkyInstance.MoonTextureId = skyboxData.MoonTexture
            skyboxData.SkyInstance.SunAngularSize = skyboxData.SunSize
            skyboxData.SkyInstance.MoonAngularSize = skyboxData.MoonSize
            skyboxData.SkyInstance.CelestialBodiesShown = true
        end)
    end

    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            if skyboxData.Active and skyboxData.Spin and skyboxData.SkyInstance then
                pcall(function()
                    skyboxData.CurrentAngle = (skyboxData.CurrentAngle + (skyboxData.SpinSpeed * 0.05)) % 360
                    local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
                    if atmos then
                        atmos.Offset = math.sin(math.rad(skyboxData.CurrentAngle)) * 0.25
                    end
                end)
            end
            task.wait(0.03)
        end
    end)

    local SkyboxSection = VisualsPage:Section({
        Name = "Skybox Changer",
        Icon = ICON_CLOUD,
        Side = 1,
    })
    registerVisualsSubtab("World", SkyboxSection)

    local skyboxPresetDrop, skyboxSpinToggle, skyboxSpinSpeedSlider

    SkyboxSection:Toggle({
        Name = "Enable Custom Skybox",
        Flag = "World_SkyboxEnabled",
        Default = false,
        Callback = function(val)
            skyboxData.Active = val
            if skyboxPresetDrop then skyboxPresetDrop:SetVisibility(val) end
            if skyboxSpinToggle then skyboxSpinToggle:SetVisibility(val) end
            if skyboxSpinSpeedSlider then skyboxSpinSpeedSlider:SetVisibility(val and Library.Flags["World_SkyboxSpin"] == true) end
            applySkybox()
        end,
    })

    skyboxPresetDrop = SkyboxSection:Dropdown({
        Name = "Skybox Preset",
        Flag = "World_SkyboxPreset",
        Items = {"Synthwave Sunset", "Cyberpunk Purple", "Deep Space Nebula", "Pure Dark Space", "Red Nebula", "Vaporwave Pink", "Twilight Blue"},
        Default = "Synthwave Sunset",
        Callback = function(val)
            skyboxData.Preset = val
            if skyboxData.Active then
                applySkybox()
            end
        end,
    })

    skyboxSpinToggle = SkyboxSection:Toggle({
        Name = "Skybox Spin",
        Flag = "World_SkyboxSpin",
        Default = false,
        Callback = function(val)
            skyboxData.Spin = val
            if skyboxSpinSpeedSlider then skyboxSpinSpeedSlider:SetVisibility(val and Library.Flags["World_SkyboxEnabled"] == true) end
        end,
    })

    skyboxSpinSpeedSlider = SkyboxSection:Slider({
        Name = "Skybox Spin Speed",
        Flag = "World_SkyboxSpinSpeed",
        Default = 15,
        Min = 1,
        Max = 100,
        Callback = function(val)
            skyboxData.SpinSpeed = val
        end,
    })

    local CelestialSection = VisualsPage:Section({
        Name = "Sun & Moon Modifiers",
        Icon = ICON_SUN,
        Side = 1,
    })
    registerVisualsSubtab("World", CelestialSection)

    CelestialSection:Slider({
        Name = "Sun Size",
        Flag = "World_SunSize",
        Default = 11,
        Min = 0,
        Max = 60,
        Callback = function(val)
            skyboxData.SunSize = val
            if skyboxData.SkyInstance then
                pcall(function() skyboxData.SkyInstance.SunAngularSize = val end)
            end
        end,
    })

    CelestialSection:Slider({
        Name = "Moon Size",
        Flag = "World_MoonSize",
        Default = 11,
        Min = 0,
        Max = 60,
        Callback = function(val)
            skyboxData.MoonSize = val
            if skyboxData.SkyInstance then
                pcall(function() skyboxData.SkyInstance.MoonAngularSize = val end)
            end
        end,
    })

    CelestialSection:Toggle({
        Name = "Celestial Bodies Visible",
        Flag = "World_CelestialVisible",
        Default = false,
        Callback = function(val)
            if skyboxData.SkyInstance then
                pcall(function() skyboxData.SkyInstance.CelestialBodiesShown = val end)
            end
        end,
    })

    local AmbienceSection = VisualsPage:Section({
        Name = "Ambience & Lighting",
        Icon = ICON_LIGHTBULB,
        Side = 2,
    })
    registerVisualsSubtab("World", AmbienceSection)

    local ambToggle = AmbienceSection:Toggle({
        Name = "Custom Ambient",
        Flag = "World_CustomAmbient",
        Default = false,
        Callback = function(val)
            if not val then
                pcall(function() Lighting.Ambient = Color3.fromRGB(128, 128, 128) end)
            end
        end,
    })
    ambToggle:Colorpicker({
        Flag = "World_AmbientColor",
        Default = Color3.fromRGB(120, 130, 180),
        Callback = function(col)
            if Library.Flags["World_CustomAmbient"] then
                pcall(function() Lighting.Ambient = col end)
            end
        end,
    })

    local outAmbToggle = AmbienceSection:Toggle({
        Name = "Custom Outdoor Ambient",
        Flag = "World_CustomOutdoorAmbient",
        Default = false,
        Callback = function(val)
            if not val then
                pcall(function() Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128) end)
            end
        end,
    })
    outAmbToggle:Colorpicker({
        Flag = "World_OutdoorAmbientColor",
        Default = Color3.fromRGB(80, 90, 120),
        Callback = function(col)
            if Library.Flags["World_CustomOutdoorAmbient"] then
                pcall(function() Lighting.OutdoorAmbient = col end)
            end
        end,
    })

    AmbienceSection:Toggle({
        Name = "Fullbright",
        Flag = "Visuals_Fullbright",
        Default = false,
        Callback = function(enabled)
            pcall(function()
                if enabled then
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 14
                    Lighting.FogEnd = 100000
                    Lighting.GlobalShadows = false
                else
                    Lighting.Brightness = 1
                    Lighting.FogEnd = 1000
                    Lighting.GlobalShadows = true
                end
            end)
        end,
    })

    AmbienceSection:Slider({
        Name = "Clock Time (Time of Day)",
        Flag = "World_ClockTime",
        Default = 14,
        Min = 0,
        Max = 24,
        Decimals = 1,
        Suffix = " h",
        Callback = function(v)
            pcall(function() Lighting.ClockTime = v end)
        end,
    })

    AmbienceSection:Slider({
        Name = "Exposure Compensation",
        Flag = "World_Exposure",
        Default = 0,
        Min = -3,
        Max = 3,
        Decimals = 2,
        Callback = function(v)
            pcall(function() Lighting.ExposureCompensation = v end)
        end,
    })

    AmbienceSection:Slider({
        Name = "Field of View (FOV)",
        Flag = "Visuals_FOVChanger",
        Default = 90,
        Min = 60,
        Max = 120,
        Suffix = "°",
        Callback = function(v)
            pcall(function() Workspace.CurrentCamera.FieldOfView = v end)
        end,
    })

    local AtmosphereFogSection = VisualsPage:Section({
        Name = "Atmosphere & Fog",
        Icon = ICON_WAND,
        Side = 2,
    })
    registerVisualsSubtab("World", AtmosphereFogSection)

    local fogStartSlider, fogEndSlider

    local customFogToggle = AtmosphereFogSection:Toggle({
        Name = "Custom Fog Settings",
        Flag = "World_CustomFog",
        Default = false,
        Callback = function(val)
            if fogStartSlider then fogStartSlider:SetVisibility(val) end
            if fogEndSlider then fogEndSlider:SetVisibility(val) end
            if not val then
                pcall(function()
                    Lighting.FogStart = 0
                    Lighting.FogEnd = 100000
                end)
            end
        end,
    })
    customFogToggle:Colorpicker({
        Flag = "World_FogColor",
        Default = Color3.fromRGB(140, 150, 200),
        Callback = function(col)
            if Library.Flags["World_CustomFog"] then
                pcall(function() Lighting.FogColor = col end)
            end
        end,
    })

    fogStartSlider = AtmosphereFogSection:Slider({
        Name = "Fog Start Distance",
        Flag = "World_FogStart",
        Default = 50,
        Min = 0,
        Max = 1000,
        Suffix = " st",
        Callback = function(v)
            if Library.Flags["World_CustomFog"] then
                pcall(function() Lighting.FogStart = v end)
            end
        end,
    })

    fogEndSlider = AtmosphereFogSection:Slider({
        Name = "Fog End Distance",
        Flag = "World_FogEnd",
        Default = 500,
        Min = 50,
        Max = 5000,
        Suffix = " st",
        Callback = function(v)
            if Library.Flags["World_CustomFog"] then
                pcall(function() Lighting.FogEnd = v end)
            end
        end,
    })

    AtmosphereFogSection:Toggle({
        Name = "Remove Fog",
        Flag = "Visuals_NoFog",
        Default = false,
        Callback = function(enabled)
            pcall(function()
                Lighting.FogEnd = enabled and 9e9 or 1000
            end)
        end,
    })

    task.spawn(function()
        local sAct = Library.Flags["World_SkyboxEnabled"] == true
        if skyboxPresetDrop then skyboxPresetDrop:SetVisibility(sAct) end
        if skyboxSpinToggle then skyboxSpinToggle:SetVisibility(sAct) end
        if skyboxSpinSpeedSlider then skyboxSpinSpeedSlider:SetVisibility(sAct and Library.Flags["World_SkyboxSpin"] == true) end
        local fAct = Library.Flags["World_CustomFog"] == true
        if fogStartSlider then fogStartSlider:SetVisibility(fAct) end
        if fogEndSlider then fogEndSlider:SetVisibility(fAct) end
    end)

    AtmosphereFogSection:Slider({
        Name = "Atmosphere Density",
        Flag = "World_AtmosDensity",
        Default = 0.3,
        Min = 0.0,
        Max = 1.0,
        Decimals = 2,
        Callback = function(v)
            pcall(function()
                local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
                if atmos then atmos.Density = v end
            end)
        end,
    })

    AtmosphereFogSection:Slider({
        Name = "Atmosphere Haze",
        Flag = "World_AtmosHaze",
        Default = 0,
        Min = 0,
        Max = 10,
        Decimals = 1,
        Callback = function(v)
            pcall(function()
                local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
                if atmos then atmos.Haze = v end
            end)
        end,
    })

    local InGameESPHolder = Instance.new("ScreenGui")
    InGameESPHolder.Name = "Swatware_InGameESP"
    InGameESPHolder.Parent = gethui()
    InGameESPHolder.ResetOnSpawn = false
    InGameESPHolder.DisplayOrder = 1
    InGameESPHolder.IgnoreGuiInset = true
    getgenv().AltHackPlayerESP = InGameESPHolder

    local playerESPCache = {}
    local playerMaterialCache = {}

    local function createPlayerESP(p)
        if playerESPCache[p] then return playerESPCache[p] end

        local data = {
            Player = p,
            Box = nil,
            BoxStroke = nil,
            Corners = nil,
            HealthBarBg = nil,
            HealthBarFill = nil,
            HealthNum = nil,
            HeadDot = nil,
            OffscreenArrow = nil,
            NameLabel = nil,
            NameGrad = nil,
            DistLabel = nil,
            DistGrad = nil,
            WeaponLabel = nil,
            WeaponGrad = nil,
            TracerLine = nil,
            Highlight = nil,
            SkeletonLines = {},
            Visible = false
        }

        local box = Instance.new("Frame")
        box.Name = "ESP_Box"
        box.Parent = InGameESPHolder
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.Visible = false

        local boxStroke = Instance.new("UIStroke")
        boxStroke.Name = "Stroke"
        boxStroke.Thickness = 1.0
        boxStroke.LineJoinMode = Enum.LineJoinMode.Miter
        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxStroke.Color = espConfig.BoxColor
        boxStroke.Parent = box
        data.Box = box
        data.BoxStroke = boxStroke

        local corners = Instance.new("Frame")
        corners.Name = "Corners"
        corners.Parent = box
        corners.Size = UDim2.fromScale(1, 1)
        corners.BackgroundTransparency = 1
        data.Corners = corners

        local hpBg = Instance.new("Frame")
        hpBg.Name = "HP_Bg"
        hpBg.Parent = InGameESPHolder
        hpBg.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        hpBg.BorderSizePixel = 0
        hpBg.Visible = false

        local hpOutline = Instance.new("UIStroke")
        hpOutline.Color = Color3.fromRGB(0, 0, 0)
        hpOutline.Thickness = 1
        hpOutline.LineJoinMode = Enum.LineJoinMode.Miter
        hpOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        hpOutline.Parent = hpBg

        local hpFill = Instance.new("Frame")
        hpFill.Name = "HP_Fill"
        hpFill.Parent = hpBg
        hpFill.BackgroundColor3 = espConfig.HealthColor
        hpFill.BorderSizePixel = 0
        hpFill.AnchorPoint = Vector2.new(0, 1)
        hpFill.Position = UDim2.new(0, 0, 1, 0)
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        data.HealthBarBg = hpBg
        data.HealthBarFill = hpFill

        local hpNum = Instance.new("TextLabel")
        hpNum.Name = "HP_Num"
        hpNum.Parent = InGameESPHolder
        hpNum.BackgroundTransparency = 1
        hpNum.FontFace = Library.Font
        hpNum.TextSize = 10
        hpNum.TextColor3 = espConfig.HealthColor
        hpNum.TextStrokeTransparency = 0
        hpNum.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        hpNum.Visible = false
        data.HealthNum = hpNum

        local hd = Instance.new("Frame")
        hd.Name = "Head_Dot"
        hd.Parent = InGameESPHolder
        hd.BackgroundColor3 = espConfig.HeadDotColor
        hd.BorderSizePixel = 0
        hd.AnchorPoint = Vector2.new(0.5, 0.5)
        hd.Visible = false

        local hdCorner = Instance.new("UICorner")
        hdCorner.CornerRadius = UDim.new(1, 0)
        hdCorner.Parent = hd

        local hdStroke = Instance.new("UIStroke")
        hdStroke.Color = Color3.fromRGB(0, 0, 0)
        hdStroke.Thickness = 1
        hdStroke.Parent = hd
        data.HeadDot = hd

        local arrow = Instance.new("ImageLabel")
        arrow.Name = "Offscreen_Arrow"
        arrow.Parent = InGameESPHolder
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://6031094678"
        arrow.ImageColor3 = espConfig.OffscreenColor
        arrow.AnchorPoint = Vector2.new(0.5, 0.5)
        arrow.Size = UDim2.fromOffset(18, 18)
        arrow.Visible = false
        data.OffscreenArrow = arrow

        local function makeText(name, size, xalign)
            local lbl = Instance.new("TextLabel")
            lbl.Name = name
            lbl.Parent = InGameESPHolder
            lbl.BackgroundTransparency = 1
            lbl.FontFace = Library.Font
            lbl.TextSize = size
            lbl.TextXAlignment = xalign or Enum.TextXAlignment.Center
            lbl.TextStrokeTransparency = 0
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.Visible = false

            local gr = Instance.new("UIGradient")
            gr.Name = "TextGradient"
            gr.Color = bwGradientSequence
            gr.Enabled = espConfig.AnimatedGradientText
            gr.Parent = lbl

            return lbl, gr
        end

        data.NameLabel, data.NameGrad = makeText("Name_Label", 12)
        data.DistLabel, data.DistGrad = makeText("Dist_Label", 10)
        data.WeaponLabel, data.WeaponGrad = makeText("Weapon_Label", 10)

        local tr = Instance.new("Frame")
        tr.Name = "Tracer_Line"
        tr.Parent = InGameESPHolder
        tr.BorderSizePixel = 0
        tr.AnchorPoint = Vector2.new(0.5, 0.5)
        tr.Visible = false
        local trStroke = Instance.new("UIStroke")
        trStroke.Color = Color3.fromRGB(0, 0, 0)
        trStroke.Thickness = 0.8
        trStroke.Parent = tr
        data.TracerLine = tr

        for i = 1, 12 do
            local sl = Instance.new("Frame")
            sl.Name = "Skel_" .. i
            sl.Parent = InGameESPHolder
            sl.BorderSizePixel = 0
            sl.AnchorPoint = Vector2.new(0.5, 0.5)
            sl.Visible = false
            local slStroke = Instance.new("UIStroke")
            slStroke.Color = Color3.fromRGB(0, 0, 0)
            slStroke.Thickness = 0.8
            slStroke.Parent = sl
            table.insert(data.SkeletonLines, sl)
        end

        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Cham_" .. p.Name
        hl.Enabled = false
        hl.Parent = InGameESPHolder
        data.Highlight = hl

        playerESPCache[p] = data
        return data
    end

    local function restorePlayerMaterials(p)
        local matMap = playerMaterialCache[p]
        if matMap then
            for part, original in pairs(matMap) do
                if part and part.Parent then
                    pcall(function()
                        part.Material = original.Material
                        part.Color = original.Color
                        part.Transparency = original.Transparency
                    end)
                end
            end
            playerMaterialCache[p] = nil
        end
    end

    local function removePlayerESP(p)
        restorePlayerMaterials(p)
        local data = playerESPCache[p]
        if data then
            if data.Box then data.Box:Destroy() end
            if data.HealthBarBg then data.HealthBarBg:Destroy() end
            if data.HealthNum then data.HealthNum:Destroy() end
            if data.HeadDot then data.HeadDot:Destroy() end
            if data.OffscreenArrow then data.OffscreenArrow:Destroy() end
            if data.NameLabel then data.NameLabel:Destroy() end
            if data.DistLabel then data.DistLabel:Destroy() end
            if data.WeaponLabel then data.WeaponLabel:Destroy() end
            if data.TracerLine then data.TracerLine:Destroy() end
            if data.Highlight then data.Highlight:Destroy() end
            for _, l in ipairs(data.SkeletonLines) do l:Destroy() end
            playerESPCache[p] = nil
        end
    end

    local function hidePlayerESP(data)
        if data.Box then data.Box.Visible = false end
        if data.HealthBarBg then data.HealthBarBg.Visible = false end
        if data.HealthNum then data.HealthNum.Visible = false end
        if data.HeadDot then data.HeadDot.Visible = false end
        if data.OffscreenArrow then data.OffscreenArrow.Visible = false end
        if data.NameLabel then data.NameLabel.Visible = false end
        if data.DistLabel then data.DistLabel.Visible = false end
        if data.WeaponLabel then data.WeaponLabel.Visible = false end
        if data.TracerLine then data.TracerLine.Visible = false end
        if data.Highlight then data.Highlight.Enabled = false end
        for _, l in ipairs(data.SkeletonLines) do l.Visible = false end
        if data.Player then
            restorePlayerMaterials(data.Player)
        end
    end

    Players.PlayerRemoving:Connect(removePlayerESP)

    Library:Connect(RunService.RenderStepped, function()
        if not espConfig.MasterEnabled or unloaded or getgenv().AltHackGen ~= GEN then
            for _, data in pairs(playerESPCache) do
                hidePlayerESP(data)
            end
            return
        end

        local localChar = Players.LocalPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
        local cam = Workspace.CurrentCamera
        if not cam then return end

        local screenW = cam.ViewportSize.X
        local screenH = cam.ViewportSize.Y
        local screenCenter = Vector2.new(screenW * 0.5, screenH * 0.5)

        local animGradOffset = espConfig.GradientText and Vector2.new((tick() * 1.2) % 2 - 1, 0) or Vector2.zero
        local curGradSeq = getEspTextGradientSequence(espConfig.GradientMode, espConfig.GradientColor1, espConfig.GradientColor2)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer then
                local data = playerESPCache[p] or createPlayerESP(p)
                local char = p.Character

                local passTeam = not espConfig.TeamCheck
                    or (p.Team == nil or Players.LocalPlayer.Team == nil or p.Team ~= Players.LocalPlayer.Team)

                if char and passTeam then
                    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                    local hum = char:FindFirstChildOfClass("Humanoid")

                    if root and hum and hum.Health > 0 then
                        local dist = localRoot and (root.Position - localRoot.Position).Magnitude or 0

                        if dist <= espConfig.MaxDistance then
                            local head = char:FindFirstChild("Head") or root
                            local leftFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftLowerLeg")
                            local rightFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")

                            local headTopPos = head.Position + Vector3.new(0, (head.Size.Y * 0.5) + 0.1, 0)
                            local lowestY
                            if leftFoot and rightFoot then
                                lowestY = math.min(leftFoot.Position.Y - (leftFoot.Size.Y * 0.5), rightFoot.Position.Y - (rightFoot.Size.Y * 0.5))
                            elseif leftFoot then
                                lowestY = leftFoot.Position.Y - (leftFoot.Size.Y * 0.5)
                            elseif rightFoot then
                                lowestY = rightFoot.Position.Y - (rightFoot.Size.Y * 0.5)
                            else
                                lowestY = root.Position.Y - ((hum.RigType == Enum.HumanoidRigType.R15) and 2.75 or 2.95)
                            end

                            local feetBotPos = Vector3.new(root.Position.X, lowestY, root.Position.Z)
                            local rootPos = root.Position

                            local top2d, topOnScreen = cam:WorldToViewportPoint(headTopPos)
                            local bottom2d, bottomOnScreen = cam:WorldToViewportPoint(feetBotPos)
                            local root2d, rootOnScreen = cam:WorldToViewportPoint(rootPos)

                            if (topOnScreen or bottomOnScreen or rootOnScreen) and top2d.Z > 0 and bottom2d.Z > 0 then
                                if data.OffscreenArrow then data.OffscreenArrow.Visible = false end

                                local boxH = math.max(6, math.abs(bottom2d.Y - top2d.Y))
                                local boxW = math.clamp(boxH * 0.55, 6, 450)
                                local boxX = math.floor(root2d.X - (boxW * 0.5))
                                local boxY = math.floor(top2d.Y)

                                if espConfig.Box then
                                    data.Box.Visible = true
                                    data.Box.Position = UDim2.fromOffset(boxX, boxY)
                                    data.Box.Size = UDim2.fromOffset(boxW, boxH)
                                    data.BoxStroke.Color = espConfig.BoxColor
                                    data.BoxStroke.Enabled = (espConfig.BoxStyle == "2D Full Box")

                                    data.Corners.Visible = (espConfig.BoxStyle == "Corner Box")
                                    if data.Corners.Visible then
                                        local col = espConfig.BoxColor
                                        local L = math.clamp(math.floor(boxW * 0.28), 6, 18)

                                        local function syncCorner(cName, hPos, vPos, hSize, vSize, hfPos, vfPos, hfSize, vfSize)
                                            local c = data.Corners:FindFirstChild(cName)
                                            if not c then
                                                c = Instance.new("Frame")
                                                c.Name = cName
                                                c.Parent = data.Corners
                                                c.BackgroundTransparency = 1
                                                c.Size = UDim2.fromScale(1, 1)

                                                local hb = Instance.new("Frame")
                                                hb.Name = "HB"
                                                hb.Parent = c
                                                hb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                                hb.BorderSizePixel = 0

                                                local hf = Instance.new("Frame")
                                                hf.Name = "HF"
                                                hf.Parent = c
                                                hf.BorderSizePixel = 0

                                                local vb = Instance.new("Frame")
                                                vb.Name = "VB"
                                                vb.Parent = c
                                                vb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                                vb.BorderSizePixel = 0

                                                local vf = Instance.new("Frame")
                                                vf.Name = "VF"
                                                vf.Parent = c
                                                vf.BorderSizePixel = 0
                                            end

                                            c.HB.Position = hPos
                                            c.HB.Size = hSize
                                            c.HF.Position = hfPos
                                            c.HF.Size = hfSize
                                            c.HF.BackgroundColor3 = col

                                            c.VB.Position = vPos
                                            c.VB.Size = vSize
                                            c.VF.Position = vfPos
                                            c.VF.Size = vfSize
                                            c.VF.BackgroundColor3 = col
                                        end

                                        syncCorner(
                                            "TL",
                                            UDim2.new(0, -1, 0, -1), UDim2.new(0, -1, 0, -1),
                                            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
                                            UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0),
                                            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
                                        )

                                        syncCorner(
                                            "TR",
                                            UDim2.new(1, -L - 1, 0, -1), UDim2.new(1, -2, 0, -1),
                                            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
                                            UDim2.new(1, -L, 0, 0), UDim2.new(1, -1, 0, 0),
                                            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
                                        )

                                        syncCorner(
                                            "BL",
                                            UDim2.new(0, -1, 1, -2), UDim2.new(0, -1, 1, -L - 1),
                                            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
                                            UDim2.new(0, 0, 1, -1), UDim2.new(0, 0, 1, -L),
                                            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
                                        )

                                        syncCorner(
                                            "BR",
                                            UDim2.new(1, -L - 1, 1, -2), UDim2.new(1, -2, 1, -L - 1),
                                            UDim2.new(0, L + 2, 0, 3), UDim2.new(0, 3, 0, L + 2),
                                            UDim2.new(1, -L, 1, -1), UDim2.new(1, -1, 1, -L),
                                            UDim2.new(0, L, 0, 1), UDim2.new(0, 1, 0, L)
                                        )
                                    end
                                else
                                    data.Box.Visible = false
                                end

                                if espConfig.Health then
                                    local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                                    local barW = espConfig.HealthBarWidth or 2
                                    local barX = boxX - (barW + 3)

                                    data.HealthBarBg.Visible = true
                                    data.HealthBarBg.Position = UDim2.fromOffset(barX, boxY)
                                    data.HealthBarBg.Size = UDim2.fromOffset(barW, boxH)
                                    data.HealthBarFill.Size = UDim2.new(1, 0, hpPct, 0)

                                    if espConfig.HealthBarMode == "Gradient (Green-Red)" then
                                        local hpColor
                                        if hpPct > 0.5 then
                                            hpColor = Color3.fromRGB(56, 239, 125):Lerp(Color3.fromRGB(255, 215, 0), (1 - hpPct) * 2)
                                        else
                                            hpColor = Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(255, 60, 60), (0.5 - hpPct) * 2)
                                        end
                                        data.HealthBarFill.BackgroundColor3 = hpColor
                                    elseif espConfig.HealthBarMode == "Theme Accent" then
                                        data.HealthBarFill.BackgroundColor3 = Library.Theme.Accent or espConfig.HealthColor
                                    else
                                        data.HealthBarFill.BackgroundColor3 = espConfig.HealthColor
                                    end

                                    if espConfig.HealthText then
                                        data.HealthNum.Visible = true
                                        data.HealthNum.Text = tostring(math.floor(hum.Health))
                                        data.HealthNum.Position = UDim2.fromOffset(barX - 22, boxY + math.floor(boxH * (1 - hpPct)) - 5)
                                        data.HealthNum.Size = UDim2.fromOffset(20, 12)
                                        data.HealthNum.TextColor3 = data.HealthBarFill.BackgroundColor3
                                    else
                                        data.HealthNum.Visible = false
                                    end
                                else
                                    data.HealthBarBg.Visible = false
                                    data.HealthNum.Visible = false
                                end

                                if espConfig.HeadDot then
                                    local head2d, headOn = cam:WorldToViewportPoint(head.Position)
                                    if headOn and head2d.Z > 0 then
                                        local sz = espConfig.HeadDotSize or 5
                                        data.HeadDot.Visible = true
                                        data.HeadDot.Size = UDim2.fromOffset(sz * 2, sz * 2)
                                        data.HeadDot.Position = UDim2.fromOffset(head2d.X, head2d.Y)
                                        data.HeadDot.BackgroundColor3 = espConfig.HeadDotColor
                                    else
                                        data.HeadDot.Visible = false
                                    end
                                else
                                    data.HeadDot.Visible = false
                                end

                                if espConfig.Name then
                                    data.NameLabel.Visible = true
                                    data.NameLabel.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                                    data.NameLabel.TextColor3 = espConfig.NameColor
                                    data.NameLabel.Position = UDim2.fromOffset(root2d.X - 100, boxY - 16)
                                    data.NameLabel.Size = UDim2.fromOffset(200, 14)
                                    data.NameGrad.Enabled = espConfig.GradientText
                                    data.NameGrad.Color = curGradSeq
                                    if espConfig.GradientText then
                                        data.NameGrad.Offset = animGradOffset
                                    end
                                else
                                    data.NameLabel.Visible = false
                                end

                                if espConfig.Distance then
                                    data.DistLabel.Visible = true
                                    data.DistLabel.Text = string.format("[ %.0f studs ]", dist)
                                    data.DistLabel.TextColor3 = espConfig.DistanceColor
                                    data.DistLabel.Position = UDim2.fromOffset(root2d.X - 60, boxY + boxH + 2)
                                    data.DistLabel.Size = UDim2.fromOffset(120, 12)
                                    data.DistGrad.Enabled = espConfig.GradientText
                                    data.DistGrad.Color = curGradSeq
                                    if espConfig.GradientText then
                                        data.DistGrad.Offset = animGradOffset
                                    end
                                else
                                    data.DistLabel.Visible = false
                                end

                                if espConfig.Weapon then
                                    local tool = char:FindFirstChildOfClass("Tool")
                                    data.WeaponLabel.Visible = true
                                    data.WeaponLabel.Text = tool and tool.Name or "Holstered"
                                    data.WeaponLabel.TextColor3 = espConfig.WeaponColor
                                    data.WeaponLabel.Position = UDim2.fromOffset(root2d.X - 70, boxY + boxH + (espConfig.Distance and 15 or 2))
                                    data.WeaponLabel.Size = UDim2.fromOffset(140, 12)
                                    data.WeaponGrad.Enabled = espConfig.GradientText
                                    data.WeaponGrad.Color = curGradSeq
                                    if espConfig.GradientText then
                                        data.WeaponGrad.Offset = animGradOffset
                                    end
                                else
                                    data.WeaponLabel.Visible = false
                                end

                                if espConfig.Tracers then
                                    local origin = (espConfig.TracerOrigin == "Center Screen" and Vector2.new(screenW/2, screenH/2))
                                        or (espConfig.TracerOrigin == "Mouse Position" and UserInputService:GetMouseLocation())
                                        or Vector2.new(screenW/2, screenH)

                                    local target = Vector2.new(root2d.X, bottom2d.Y)
                                    local dx = target.X - origin.X
                                    local dy = target.Y - origin.Y
                                    local length = math.sqrt(dx*dx + dy*dy)

                                    data.TracerLine.Visible = true
                                    data.TracerLine.BackgroundColor3 = espConfig.TracerColor
                                    data.TracerLine.Size = UDim2.fromOffset(length, 1.5)
                                    data.TracerLine.Position = UDim2.fromOffset((origin.X + target.X)/2, (origin.Y + target.Y)/2)
                                    data.TracerLine.Rotation = math.deg(math.atan2(dy, dx))
                                else
                                    data.TracerLine.Visible = false
                                end

                                if espConfig.Skeleton then
                                    local r6Bones = {
                                        {"Head", "Torso"},
                                        {"Torso", "Left Arm"},
                                        {"Torso", "Right Arm"},
                                        {"Torso", "Left Leg"},
                                        {"Torso", "Right Leg"},
                                    }
                                    local r15Bones = {
                                        {"Head", "UpperTorso"},
                                        {"UpperTorso", "LowerTorso"},
                                        {"UpperTorso", "LeftUpperArm"},
                                        {"LeftUpperArm", "LeftLowerArm"},
                                        {"UpperTorso", "RightUpperArm"},
                                        {"RightUpperArm", "RightLowerArm"},
                                        {"LowerTorso", "LeftUpperLeg"},
                                        {"LeftUpperLeg", "LeftLowerLeg"},
                                        {"LowerTorso", "RightUpperLeg"},
                                        {"RightUpperLeg", "RightLowerLeg"},
                                    }
                                    local boneList = (hum.RigType == Enum.HumanoidRigType.R15) and r15Bones or r6Bones

                                    for idx, sl in ipairs(data.SkeletonLines) do
                                        local bone = boneList[idx]
                                        if bone then
                                            local p1 = char:FindFirstChild(bone[1])
                                            local p2 = char:FindFirstChild(bone[2])
                                            if p1 and p2 then
                                                local v1, ok1 = cam:WorldToViewportPoint(p1.Position)
                                                local v2, ok2 = cam:WorldToViewportPoint(p2.Position)
                                                if ok1 and ok2 and v1.Z > 0 and v2.Z > 0 then
                                                    local dx = v2.X - v1.X
                                                    local dy = v2.Y - v1.Y
                                                    local l = math.sqrt(dx*dx + dy*dy)
                                                    sl.Visible = true
                                                    sl.BackgroundColor3 = espConfig.SkeletonColor
                                                    sl.Size = UDim2.fromOffset(l, 1.5)
                                                    sl.Position = UDim2.fromOffset((v1.X + v2.X)/2, (v1.Y + v2.Y)/2)
                                                    sl.Rotation = math.deg(math.atan2(dy, dx))
                                                else
                                                    sl.Visible = false
                                                end
                                            else
                                                sl.Visible = false
                                            end
                                        else
                                            sl.Visible = false
                                        end
                                    end
                                else
                                    for _, sl in ipairs(data.SkeletonLines) do sl.Visible = false end
                                end

                                if espConfig.Chams then
                                    local pulse = espConfig.ChamsPulse and ((math.sin(tick() * 4) + 1) / 2) or 0
                                    local effectiveFillTrans = math.clamp(espConfig.ChamsFillTransparency + (pulse * 0.4), 0, 1)

                                    if espConfig.ChamsMaterial == "Highlight" then
                                        if data.Highlight then
                                            data.Highlight.Adornee = char
                                            data.Highlight.Enabled = true
                                            data.Highlight.FillColor = espConfig.ChamsColor
                                            data.Highlight.OutlineColor = espConfig.ChamsOutlineColor
                                            data.Highlight.FillTransparency = effectiveFillTrans
                                            data.Highlight.OutlineTransparency = espConfig.ChamsOutlineTransparency
                                            data.Highlight.DepthMode = espConfig.ChamsThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                                        end
                                        restorePlayerMaterials(p)
                                    else

                                        if data.Highlight then
                                            data.Highlight.Enabled = false
                                        end

                                        if not playerMaterialCache[p] then
                                            playerMaterialCache[p] = {}
                                            for _, desc in ipairs(char:GetDescendants()) do
                                                if desc:IsA("BasePart") and desc.Name ~= "HumanoidRootPart" then
                                                    playerMaterialCache[p][desc] = {
                                                        Material = desc.Material,
                                                        Color = desc.Color,
                                                        Transparency = desc.Transparency
                                                    }
                                                end
                                            end
                                        end

                                        for part, _ in pairs(playerMaterialCache[p]) do
                                            if part and part.Parent then
                                                pcall(function()
                                                    if espConfig.ChamsMaterial == "ForceField" then
                                                        part.Material = Enum.Material.ForceField
                                                        part.Transparency = effectiveFillTrans
                                                    elseif espConfig.ChamsMaterial == "Neon" then
                                                        part.Material = Enum.Material.Neon
                                                        part.Transparency = 0
                                                    elseif espConfig.ChamsMaterial == "Glass" then
                                                        part.Material = Enum.Material.Glass
                                                        part.Transparency = math.clamp(effectiveFillTrans + 0.2, 0.2, 0.9)
                                                    elseif espConfig.ChamsMaterial == "Ghost" then
                                                        part.Material = Enum.Material.ForceField
                                                        part.Transparency = 0.75
                                                    elseif espConfig.ChamsMaterial == "Wireframe" then
                                                        part.Material = Enum.Material.SmoothPlastic
                                                        part.Transparency = 0.85
                                                    else
                                                        part.Material = Enum.Material.SmoothPlastic
                                                        part.Transparency = effectiveFillTrans
                                                    end
                                                    part.Color = espConfig.ChamsColor
                                                end)
                                            end
                                        end
                                    end
                                else
                                    if data.Highlight then
                                        data.Highlight.Enabled = false
                                    end
                                    restorePlayerMaterials(p)
                                end
                            else
                                hidePlayerESP(data)
                                if espConfig.Offscreen and data.OffscreenArrow and rootPos then
                                    local camCFrame = cam.CFrame
                                    local toTarget = (rootPos - camCFrame.Position).Unit
                                    local forward = camCFrame.LookVector
                                    local right = camCFrame.RightVector
                                    local up = camCFrame.UpVector

                                    local dotRight = right:Dot(toTarget)
                                    local dotUp = up:Dot(toTarget)

                                    local angle = math.atan2(-dotRight, dotUp)
                                    local radius = espConfig.OffscreenRadius or 220
                                    local arrowPos = screenCenter + Vector2.new(math.sin(angle) * radius, -math.cos(angle) * radius)

                                    data.OffscreenArrow.Visible = true
                                    data.OffscreenArrow.Position = UDim2.fromOffset(arrowPos.X, arrowPos.Y)
                                    data.OffscreenArrow.Rotation = math.deg(angle) + 180
                                    data.OffscreenArrow.ImageColor3 = espConfig.OffscreenColor
                                end
                            end
                        else
                            hidePlayerESP(data)
                        end
                    else
                        hidePlayerESP(data)
                    end
                else
                    hidePlayerESP(data)
                end
            end
        end
    end)
end

do
    local MiscPage = Window:Page({
        Name = "Misc",
        Icon = ICON_SETTINGS,
    })

    pcall(function()
        Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
        Players.LocalPlayer.CameraMinZoomDistance = 0.5
        Players.LocalPlayer.CameraMaxZoomDistance = 128
    end)

    local miscState = {
        Fly = false,
        FlySpeed = 50,
        Noclip = false,
        VoidHide = false,
        VoidSavedCF = nil,
        VoidPlatform = nil,
        Spinbot = false,
        SpinSpeed = 25,
        AntiAimMode = "Spinbot",
        PitchMode = "None",
        YawInverted = false,
        Desync = false,
        DesyncTicks = 4,
        AntiFling = false,
        BHop = false,
        ClickTPActive = false,
    }

    local MovementSection = MiscPage:Section({
        Name = "Movement & Physics",
        Icon = ICON_MOVE,
        Side = 1,
    })

    MovementSection:Toggle({
        Name = "Speed Multiplier",
        Flag = "Misc_SpeedToggle",
        Default = false,
        Callback = function(val)
            if not val then
                pcall(function()
                    local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = 16 end
                end)
            end
        end,
    })

    MovementSection:Slider({
        Name = "WalkSpeed",
        Flag = "Misc_SpeedValue",
        Default = 32,
        Min = 16,
        Max = 300,
        Suffix = " ws",
        Callback = function(val)
            pcall(function()
                local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and Library.Flags["Misc_SpeedToggle"] then
                    hum.WalkSpeed = val
                end
            end)
        end,
    })

    MovementSection:Toggle({
        Name = "JumpPower Multiplier",
        Flag = "Misc_JumpToggle",
        Default = false,
        Callback = function(val)
            if not val then
                pcall(function()
                    local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.JumpPower = 50 end
                end)
            end
        end,
    })

    MovementSection:Slider({
        Name = "JumpPower",
        Flag = "Misc_JumpValue",
        Default = 100,
        Min = 50,
        Max = 500,
        Suffix = " jp",
        Callback = function(val)
            pcall(function()
                local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and Library.Flags["Misc_JumpToggle"] then
                    hum.UseJumpPower = true
                    hum.JumpPower = val
                end
            end)
        end,
    })

    MovementSection:Toggle({
        Name = "Infinite Jump",
        Flag = "Misc_InfJump",
        Default = false,
        Callback = function(val) end,
    })

    UserInputService.JumpRequest:Connect(function()
        if Library.Flags["Misc_InfJump"] then
            pcall(function()
                local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end)

    local flySpeedSlider
    local flyToggle = MovementSection:Toggle({
        Name = "Fly Mode",
        Flag = "Misc_FlyToggle",
        Default = false,
        Callback = function(val)
            miscState.Fly = val
            if flySpeedSlider then flySpeedSlider:SetVisibility(val) end
        end,
    })
    flyToggle:Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.X,
        Callback = function(state)
            miscState.Fly = state
            if flySpeedSlider then flySpeedSlider:SetVisibility(state) end
        end,
    })

    flySpeedSlider = MovementSection:Slider({
        Name = "Fly Speed",
        Flag = "Misc_FlySpeed",
        Default = 50,
        Min = 10,
        Max = 300,
        Suffix = " spd",
        Callback = function(val)
            miscState.FlySpeed = val
        end,
    })

    local noclipToggle = MovementSection:Toggle({
        Name = "Noclip",
        Flag = "Misc_Noclip",
        Default = false,
        Callback = function(val)
            miscState.Noclip = val
        end,
    })
    noclipToggle:Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.V,
        Callback = function(state)
            miscState.Noclip = state
        end,
    })

    MovementSection:Toggle({
        Name = "Bunny Hop (Auto Jump)",
        Flag = "Misc_BHop",
        Default = false,
        Callback = function(val)
            miscState.BHop = val
        end,
    })

    MovementSection:Toggle({
        Name = "Anti-Fling",
        Flag = "Misc_AntiFling",
        Default = false,
        Callback = function(val)
            miscState.AntiFling = val
        end,
    })

    local AntiAimSection = MiscPage:Section({
        Name = "Anti-Aim & Spinbot",
        Icon = ICON_SPARKLES,
        Side = 1,
    })

    local aaModeDropdown, spinSpeedSlider, pitchModeDropdown, invKeyToggle, desyncToggle, desyncTicksSlider

    AntiAimSection:Toggle({
        Name = "Enable Anti-Aim / Spinbot",
        Flag = "Misc_AntiAimEnabled",
        Default = false,
        Callback = function(val)
            miscState.Spinbot = val
            if aaModeDropdown then aaModeDropdown:SetVisibility(val) end
            if spinSpeedSlider then spinSpeedSlider:SetVisibility(val) end
            if pitchModeDropdown then pitchModeDropdown:SetVisibility(val) end
            if invKeyToggle then invKeyToggle:SetVisibility(val) end
            if desyncToggle then desyncToggle:SetVisibility(val) end
            if desyncTicksSlider then desyncTicksSlider:SetVisibility(val and Library.Flags["Misc_Desync"] == true) end
        end,
    })

    aaModeDropdown = AntiAimSection:Dropdown({
        Name = "Anti-Aim Mode",
        Flag = "Misc_AntiAimMode",
        Items = {"Spinbot", "Jitter Yaw", "Backwards", "Static Yaw", "Random Yaw"},
        Default = "Spinbot",
        Callback = function(val)
            miscState.AntiAimMode = val
        end,
    })

    spinSpeedSlider = AntiAimSection:Slider({
        Name = "Spinbot Speed",
        Flag = "Misc_SpinSpeed",
        Default = 25,
        Min = 1,
        Max = 100,
        Callback = function(val)
            miscState.SpinSpeed = val
        end,
    })

    pitchModeDropdown = AntiAimSection:Dropdown({
        Name = "Pitch Angle Modifier",
        Flag = "Misc_PitchMode",
        Items = {"None", "Look Down", "Look Up", "Jitter Pitch", "Spin Pitch"},
        Default = "None",
        Callback = function(val)
            miscState.PitchMode = val
        end,
    })

    invKeyToggle = AntiAimSection:Toggle({
        Name = "Invert Yaw Keybind",
        Flag = "Misc_InvertYawToggle",
        Default = false,
        Callback = function(val)
            miscState.YawInverted = val
        end,
    })
    invKeyToggle:Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.Z,
        Callback = function(state)
            miscState.YawInverted = state
        end,
    })

    desyncToggle = AntiAimSection:Toggle({
        Name = "Desync (Fake Lag)",
        Flag = "Misc_Desync",
        Default = false,
        Callback = function(val)
            miscState.Desync = val
            if desyncTicksSlider then desyncTicksSlider:SetVisibility(val and Library.Flags["Misc_AntiAimEnabled"] == true) end
        end,
    })

    desyncTicksSlider = AntiAimSection:Slider({
        Name = "Desync Ticks",
        Flag = "Misc_DesyncTicks",
        Default = 4,
        Min = 1,
        Max = 15,
        Callback = function(val)
            miscState.DesyncTicks = val
        end,
    })

    task.spawn(function()
        local flyAct = Library.Flags["Misc_FlyToggle"] == true
        if flySpeedSlider then flySpeedSlider:SetVisibility(flyAct) end
        local aaAct = Library.Flags["Misc_AntiAimEnabled"] == true
        if aaModeDropdown then aaModeDropdown:SetVisibility(aaAct) end
        if spinSpeedSlider then spinSpeedSlider:SetVisibility(aaAct) end
        if pitchModeDropdown then pitchModeDropdown:SetVisibility(aaAct) end
        if invKeyToggle then invKeyToggle:SetVisibility(aaAct) end
        if desyncToggle then desyncToggle:SetVisibility(aaAct) end
        if desyncTicksSlider then desyncTicksSlider:SetVisibility(aaAct and Library.Flags["Misc_Desync"] == true) end
    end)

    local RageSection = MiscPage:Section({
        Name = "Rage & Survival Mods",
        Icon = ICON_SKULL,
        Side = 2,
    })

    local voidToggle = RageSection:Toggle({
        Name = "Void Hide (Safe Haven)",
        Flag = "Misc_VoidHide",
        Default = false,
        Callback = function(val)
            miscState.VoidHide = val
            pcall(function()
                local char = Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end

                if val then
                    miscState.VoidSavedCF = root.CFrame
                    if not miscState.VoidPlatform then
                        local p = Instance.new("Part")
                        p.Name = "Swatware_VoidPlatform"
                        p.Size = Vector3.new(20, 2, 20)
                        p.Position = Vector3.new(0, 30000, 0)
                        p.Anchored = true
                        p.CanCollide = true
                        p.Transparency = 0.5
                        p.Color = Theme.Accent or Color3.fromRGB(139, 149, 246)
                        p.Parent = Workspace
                        miscState.VoidPlatform = p
                    end
                    root.CFrame = CFrame.new(0, 30005, 0)
                else
                    if miscState.VoidSavedCF then
                        root.CFrame = miscState.VoidSavedCF
                        miscState.VoidSavedCF = nil
                    end
                    if miscState.VoidPlatform then
                        miscState.VoidPlatform:Destroy()
                        miscState.VoidPlatform = nil
                    end
                end
            end)
        end,
    })
    voidToggle:Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.H,
        Callback = function(state)
            voidToggle:Set(state)
        end,
    })

    RageSection:Toggle({
        Name = "Anti-Stomp / Auto-Respawn",
        Flag = "Misc_AntiStomp",
        Default = false,
        Callback = function(val) end,
    })

    local clickTpToggle = RageSection:Toggle({
        Name = "Click Teleport (On Keybind)",
        Flag = "Misc_ClickTP",
        Default = false,
        Callback = function(val) end,
    })
    clickTpToggle:Keybind({
        Mode = "Hold",
        Default = Enum.KeyCode.T,
        Callback = function(isDown)
            miscState.ClickTPActive = isDown
            if isDown and Library.Flags["Misc_ClickTP"] then
                pcall(function()
                    local mouse = Players.LocalPlayer:GetMouse()
                    local char = Players.LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if mouse and root and mouse.Hit then
                        root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                    end
                end)
            end
        end,
    })

    RageSection:Toggle({
        Name = "No Fall Damage",
        Flag = "Misc_NoFallDamage",
        Default = false,
        Callback = function(val) end,
    })

    local UtilitiesSection = MiscPage:Section({
        Name = "Client & Server Utilities",
        Icon = ICON_TROLL,
        Side = 2,
    })

    UtilitiesSection:Toggle({
        Name = "Third Person View",
        Flag = "Misc_ThirdPerson",
        Default = false,
        Callback = function(val)
            pcall(function()
                if val then
                    local dist = Library.Flags["Misc_ThirdPersonDist"] or 15
                    Players.LocalPlayer.CameraMinZoomDistance = dist
                    Players.LocalPlayer.CameraMaxZoomDistance = dist
                else
                    Players.LocalPlayer.CameraMinZoomDistance = 0.5
                    Players.LocalPlayer.CameraMaxZoomDistance = 128
                end
            end)
        end,
    })

    UtilitiesSection:Slider({
        Name = "Third Person Distance",
        Flag = "Misc_ThirdPersonDist",
        Default = 15,
        Min = 5,
        Max = 80,
        Suffix = " studs",
        Callback = function(val)
            pcall(function()
                if Library.Flags["Misc_ThirdPerson"] then
                    Players.LocalPlayer.CameraMaxZoomDistance = val
                    Players.LocalPlayer.CameraMinZoomDistance = val
                end
            end)
        end,
    })

    UtilitiesSection:Toggle({
        Name = "Unlock Max FPS",
        Flag = "Misc_UnlockFPS",
        Default = false,
        Callback = function(val)
            if setfpscap then
                setfpscap(val and (Library.Flags["Misc_MaxFPS"] or 240) or 60)
            end
        end,
    })

    UtilitiesSection:Slider({
        Name = "Max FPS Cap",
        Flag = "Misc_MaxFPS",
        Default = 240,
        Min = 60,
        Max = 360,
        Suffix = " fps",
        Callback = function(val)
            if setfpscap and Library.Flags["Misc_UnlockFPS"] then
                setfpscap(val)
            end
        end,
    })

    UtilitiesSection:Button({
        Name = "Copy Server Job ID",
        Callback = function()
            if setclipboard then
                setclipboard(tostring(game.JobId))
            end
        end,
    })

    UtilitiesSection:Button({
        Name = "Server Hop",
        Callback = function()
            pcall(function()
                local HttpService = game:GetService("HttpService")
                local TeleportService = game:GetService("TeleportService")
                local placeId = game.PlaceId
                local servers = HttpService:JSONDecode(game:HttpGet(
                    "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=50"
                ))
                for _, s in ipairs(servers.data or {}) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(placeId, s.id, Players.LocalPlayer)
                        break
                    end
                end
            end)
        end,
    })

    UtilitiesSection:Button({
        Name = "Rejoin Server",
        Callback = function()
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId,
                    Players.LocalPlayer
                )
            end)
        end,
    })

    local spinAngle = 0
    Library:Connect(RunService.Heartbeat, function(dt)
        if unloaded or getgenv().AltHackGen ~= GEN then return end

        local char = Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        if miscState.Fly and hum.Health > 0 then
            local cam = Workspace.CurrentCamera
            if cam then
                local moveDir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                if moveDir.Magnitude > 0 then
                    root.AssemblyLinearVelocity = moveDir.Unit * miscState.FlySpeed
                else
                    root.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end

        if miscState.AntiFling then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Players.LocalPlayer and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.AssemblyLinearVelocity = Vector3.zero
                            part.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end
        end

        if miscState.BHop and hum.FloorMaterial ~= Enum.Material.Air and hum.MoveDirection.Magnitude > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    Library:Connect(RunService.Stepped, function()
        if unloaded or getgenv().AltHackGen ~= GEN then return end

        local char = Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not root then return end

        if miscState.Noclip then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end

        if miscState.Spinbot then
            spinAngle = (spinAngle + (miscState.SpinSpeed * 5)) % 360
            local yaw = 0
            if miscState.AntiAimMode == "Spinbot" then
                yaw = math.rad(spinAngle)
            elseif miscState.AntiAimMode == "Jitter Yaw" then
                yaw = math.rad((tick() % 0.2 > 0.1) and 90 or -90)
            elseif miscState.AntiAimMode == "Backwards" then
                yaw = math.rad(180)
            elseif miscState.AntiAimMode == "Static Yaw" then
                yaw = math.rad(90)
            elseif miscState.AntiAimMode == "Random Yaw" then
                yaw = math.rad(math.random(0, 360))
            end

            if miscState.YawInverted then
                yaw = yaw + math.pi
            end

            local pitch = 0
            if miscState.PitchMode == "Look Down" then
                pitch = math.rad(-89)
            elseif miscState.PitchMode == "Look Up" then
                pitch = math.rad(89)
            elseif miscState.PitchMode == "Jitter Pitch" then
                pitch = math.rad((tick() % 0.2 > 0.1) and 70 or -70)
            elseif miscState.PitchMode == "Spin Pitch" then
                pitch = math.rad(math.sin(tick() * 10) * 85)
            end

            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(pitch, yaw, 0)
        end
    end)
end

do
    local PlayerlistPage = Window:Page({
        Name = "Playerlist",
        Icon = ICON_CLIENT,
    })

    local selectedTarget = nil
    local searchQuery = ""
    local activeSubtab = "local"

    local function createTagBadge(parent, rawTag)
        local tagStyle = SwatwareAPI:GetTagStyle(rawTag)
        local badge = Instance.new("Frame")
        badge.Name = "TagBadge_" .. tostring(rawTag)
        badge.Parent = parent
        badge.BackgroundColor3 = tagStyle.Bg
        badge.BorderSizePixel = 0
        badge.Size = UDim2.new(0, 0, 0, 18)
        badge.AutomaticSize = Enum.AutomaticSize.X

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 4)
        bCorner.Parent = badge

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = tagStyle.Border
        bStroke.Thickness = 1
        bStroke.Transparency = 0.2
        bStroke.Parent = badge

        local bPad = Instance.new("UIPadding")
        bPad.PaddingLeft = UDim.new(0, 6)
        bPad.PaddingRight = UDim.new(0, 6)
        bPad.Parent = badge

        local bLabel = Instance.new("TextLabel")
        bLabel.Parent = badge
        bLabel.BackgroundTransparency = 1
        bLabel.FontFace = Library.Font
        bLabel.Text = string.upper(tostring(rawTag))
        bLabel.TextColor3 = tagStyle.Text
        bLabel.TextSize = 9
        bLabel.Size = UDim2.new(0, 0, 1, 0)
        bLabel.AutomaticSize = Enum.AutomaticSize.X
        return badge
    end

    local PlayersListSection = PlayerlistPage:Section({
        Name = "Player Explorer",
        Icon = ICON_CLIENT,
        Side = 1,
    })

    local leftContent = PlayersListSection.Items["Content"].Instance

    local subtabContainer = Instance.new("Frame")
    subtabContainer.Name = "SubtabSwitcher"
    subtabContainer.Parent = leftContent
    subtabContainer.Size = UDim2.new(1, 0, 0, 32)
    subtabContainer.BackgroundColor3 = Theme.Background
    subtabContainer.BorderSizePixel = 0
    subtabContainer.LayoutOrder = -10
    Library:AddToTheme(subtabContainer, {BackgroundColor3 = "Background"})

    local stCorner = Instance.new("UICorner")
    stCorner.CornerRadius = UDim.new(0, 8)
    stCorner.Parent = subtabContainer

    local stStroke = Instance.new("UIStroke")
    stStroke.Color = Theme.Outline
    stStroke.Transparency = 0.4
    stStroke.Parent = subtabContainer
    Library:AddToTheme(stStroke, {Color = "Outline"})

    local stLayout = Instance.new("UIListLayout")
    stLayout.Parent = subtabContainer
    stLayout.FillDirection = Enum.FillDirection.Horizontal
    stLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    stLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    stLayout.Padding = UDim.new(0, 4)

    local localTabBtn = Instance.new("TextButton")
    localTabBtn.Name = "LocalPlayersTab"
    localTabBtn.Parent = subtabContainer
    localTabBtn.Size = UDim2.new(0.5, -4, 1, -6)
    localTabBtn.BackgroundColor3 = Theme.Accent
    localTabBtn.BorderSizePixel = 0
    localTabBtn.FontFace = Library.Font
    localTabBtn.Text = "Local Players"
    localTabBtn.TextColor3 = Theme.Background
    localTabBtn.TextSize = 11
    localTabBtn.AutoButtonColor = false
    Library:AddToTheme(localTabBtn, {
        BackgroundColor3 = function() return activeSubtab == "local" and Theme.Accent or Theme.Element end,
        TextColor3 = function() return activeSubtab == "local" and Theme.Background or Theme.Text end
    })

    local lCorner = Instance.new("UICorner")
    lCorner.CornerRadius = UDim.new(0, 6)
    lCorner.Parent = localTabBtn

    local swatwareTabBtn = Instance.new("TextButton")
    swatwareTabBtn.Name = "SwatwareUsersTab"
    swatwareTabBtn.Parent = subtabContainer
    swatwareTabBtn.Size = UDim2.new(0.5, -4, 1, -6)
    swatwareTabBtn.BackgroundColor3 = Theme.Element
    swatwareTabBtn.BorderSizePixel = 0
    swatwareTabBtn.FontFace = Library.Font
    swatwareTabBtn.Text = "Swatware Users"
    swatwareTabBtn.TextColor3 = Theme.Text
    swatwareTabBtn.TextSize = 11
    swatwareTabBtn.AutoButtonColor = false
    Library:AddToTheme(swatwareTabBtn, {
        BackgroundColor3 = function() return activeSubtab == "swatware" and Theme.Accent or Theme.Element end,
        TextColor3 = function() return activeSubtab == "swatware" and Theme.Background or Theme.Text end
    })

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 6)
    sCorner.Parent = swatwareTabBtn

    local refreshPlayerListUI

    local function setSubtab(tab)
        if activeSubtab == tab and playerListContainer and #playerListContainer:GetChildren() > 1 then return end
        activeSubtab = tab

        local activeBg = Theme.Accent or Color3.fromRGB(139, 149, 246)
        local inactiveBg = Theme.Element or Color3.fromRGB(16, 16, 21)
        local activeTxt = Theme.Background or Color3.fromRGB(7, 7, 9)
        local inactiveTxt = Theme.Text or Color3.fromRGB(235, 235, 245)

        local twInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        if activeSubtab == "local" then
            TweenService:Create(localTabBtn, twInfo, {BackgroundColor3 = activeBg, TextColor3 = activeTxt}):Play()
            TweenService:Create(swatwareTabBtn, twInfo, {BackgroundColor3 = inactiveBg, TextColor3 = inactiveTxt}):Play()
        else
            TweenService:Create(swatwareTabBtn, twInfo, {BackgroundColor3 = activeBg, TextColor3 = activeTxt}):Play()
            TweenService:Create(localTabBtn, twInfo, {BackgroundColor3 = inactiveBg, TextColor3 = inactiveTxt}):Play()
        end

        if playerListContainer then
            local fadeOut = TweenService:Create(playerListContainer, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, -8, 0, 0)
            })
            fadeOut.Completed:Connect(function()
                if refreshPlayerListUI then
                    refreshPlayerListUI()
                end
                playerListContainer.Position = UDim2.new(0, 8, 0, 0)
                TweenService:Create(playerListContainer, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()
            end)
            fadeOut:Play()
        else
            if refreshPlayerListUI then
                refreshPlayerListUI()
            end
        end
    end

    localTabBtn.MouseButton1Click:Connect(function()
        setSubtab("local")
    end)

    swatwareTabBtn.MouseButton1Click:Connect(function()
        setSubtab("swatware")
    end)

    local filterInput = PlayersListSection:Textbox({
        Name = "Filter Search",
        Placeholder = "Search username, display name or tag...",
        Flag = "Playerlist_Search",
        Finished = false,
        Callback = function(val)
            searchQuery = string.lower(val or "")
            if refreshPlayerListUI then
                refreshPlayerListUI()
            end
        end,
    })

    local playerListContainer = Instance.new("Frame")
    playerListContainer.Name = "DynamicPlayerList"
    playerListContainer.Parent = leftContent
    playerListContainer.Size = UDim2.new(1, 0, 0, 0)
    playerListContainer.AutomaticSize = Enum.AutomaticSize.Y
    playerListContainer.BackgroundTransparency = 1
    playerListContainer.BorderSizePixel = 0

    local plLayout = Instance.new("UIListLayout")
    plLayout.Parent = playerListContainer
    plLayout.Padding = UDim.new(0, 6)
    plLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local TargetDetailsSection = PlayerlistPage:Section({
        Name = "Target Details & Controls",
        Icon = ICON_COMBAT,
        Side = 2,
    })

    local targetContent = TargetDetailsSection.Items["Content"].Instance

    local targetCard = Instance.new("Frame")
    targetCard.Name = "TargetProfileCard"
    targetCard.Parent = targetContent
    targetCard.Size = UDim2.new(1, 0, 0, 120)
    targetCard.BackgroundColor3 = Theme.Element
    targetCard.BorderSizePixel = 0
    targetCard.ClipsDescendants = true
    Library:AddToTheme(targetCard, {BackgroundColor3 = "Element"})

    local tcCorner = Instance.new("UICorner")
    tcCorner.CornerRadius = UDim.new(0, 10)
    tcCorner.Parent = targetCard

    local tcStroke = Instance.new("UIStroke")
    tcStroke.Color = Theme.Outline
    tcStroke.Transparency = 0.35
    tcStroke.Parent = targetCard
    Library:AddToTheme(tcStroke, {Color = "Outline"})

    local targetAvatar = Instance.new("ImageLabel")
    targetAvatar.Name = "Avatar"
    targetAvatar.Parent = targetCard
    targetAvatar.BackgroundColor3 = Theme.Background
    targetAvatar.BorderSizePixel = 0
    targetAvatar.Position = UDim2.new(0, 12, 0, 14)
    targetAvatar.Size = UDim2.fromOffset(64, 64)
    targetAvatar.Image = ""
    Library:AddToTheme(targetAvatar, {BackgroundColor3 = "Background"})

    local taCorner = Instance.new("UICorner")
    taCorner.CornerRadius = UDim.new(0, 12)
    taCorner.Parent = targetAvatar

    local taStroke = Instance.new("UIStroke")
    taStroke.Color = Theme.Accent
    taStroke.Thickness = 2
    taStroke.Parent = targetAvatar
    Library:AddToTheme(taStroke, {Color = "Accent"})

    local targetNameLabel = Instance.new("TextLabel")
    targetNameLabel.Name = "Name"
    targetNameLabel.Parent = targetCard
    targetNameLabel.BackgroundTransparency = 1
    targetNameLabel.FontFace = Library.Font
    targetNameLabel.Text = "Select a target"
    targetNameLabel.TextColor3 = Theme.Text
    targetNameLabel.TextSize = 15
    targetNameLabel.Position = UDim2.new(0, 88, 0, 14)
    targetNameLabel.Size = UDim2.new(1, -98, 0, 20)
    targetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    Library:AddToTheme(targetNameLabel, {TextColor3 = "Text"})

    local targetUserLabel = Instance.new("TextLabel")
    targetUserLabel.Name = "User"
    targetUserLabel.Parent = targetCard
    targetUserLabel.BackgroundTransparency = 1
    targetUserLabel.FontFace = Library.Font
    targetUserLabel.Text = "@none"
    targetUserLabel.TextColor3 = Theme.Accent
    targetUserLabel.TextSize = 12
    targetUserLabel.Position = UDim2.new(0, 88, 0, 34)
    targetUserLabel.Size = UDim2.new(1, -98, 0, 16)
    targetUserLabel.TextXAlignment = Enum.TextXAlignment.Left
    Library:AddToTheme(targetUserLabel, {TextColor3 = "Accent"})

    local targetInfoLabel = Instance.new("TextLabel")
    targetInfoLabel.Name = "Info"
    targetInfoLabel.Parent = targetCard
    targetInfoLabel.BackgroundTransparency = 1
    targetInfoLabel.FontFace = Library.Font
    targetInfoLabel.Text = "Status: Idle • Select from list"
    targetInfoLabel.TextColor3 = Theme.Text
    targetInfoLabel.TextTransparency = 0.4
    targetInfoLabel.TextSize = 11
    targetInfoLabel.Position = UDim2.new(0, 88, 0, 52)
    targetInfoLabel.Size = UDim2.new(1, -98, 0, 16)
    targetInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    Library:AddToTheme(targetInfoLabel, {TextColor3 = "Text"})

    local targetBadgesRow = Instance.new("Frame")
    targetBadgesRow.Name = "TargetBadgesRow"
    targetBadgesRow.Parent = targetCard
    targetBadgesRow.BackgroundTransparency = 1
    targetBadgesRow.Position = UDim2.new(0, 12, 0, 88)
    targetBadgesRow.Size = UDim2.new(1, -24, 0, 22)

    local tbLayout = Instance.new("UIListLayout")
    tbLayout.Parent = targetBadgesRow
    tbLayout.FillDirection = Enum.FillDirection.Horizontal
    tbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tbLayout.Padding = UDim.new(0, 6)

    local function updateTargetDetailsUI()
        for _, c in ipairs(targetBadgesRow:GetChildren()) do
            if c:IsA("Frame") then
                c:Destroy()
            end
        end

        if not selectedTarget then
            targetNameLabel.Text = "Select a target"
            targetUserLabel.Text = "@none"
            targetInfoLabel.Text = "Status: Idle • Select from list"
            targetAvatar.Image = ""
            return
        end

        targetNameLabel.Text = selectedTarget.DisplayName or selectedTarget.Name
        targetUserLabel.Text = "@" .. selectedTarget.Name .. (selectedTarget.UserId and (" (ID: " .. selectedTarget.UserId .. ")") or "")

        if selectedTarget.Player and selectedTarget.Player.Character then
            local myRoot = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local tRoot = selectedTarget.Player.Character:FindFirstChild("HumanoidRootPart")
            local dist = (myRoot and tRoot) and math.floor((myRoot.Position - tRoot.Position).Magnitude) or 0
            local tHum = selectedTarget.Player.Character:FindFirstChildOfClass("Humanoid")
            local hp = tHum and math.floor(tHum.Health) or 100
            targetInfoLabel.Text = string.format("Health: %d HP • Dist: %d studs • Online", hp, dist)
        elseif selectedTarget.IsInServer then
            targetInfoLabel.Text = "In Current Server (Spawning...)"
        else
            targetInfoLabel.Text = "Swatware Database Registry • Offline / Other Server"
        end

        local tags = selectedTarget.Tags or SwatwareAPI:GetTags(selectedTarget.Name)
        for _, tag in ipairs(tags) do
            createTagBadge(targetBadgesRow, tag)
        end

        if selectedTarget.UserId then
            task.spawn(function()
                local ok, img = pcall(function()
                    return Players:GetUserThumbnailAsync(selectedTarget.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                end)
                if ok and targetAvatar.Parent then
                    targetAvatar.Image = img
                end
            end)
        end
    end

    TargetDetailsSection:Button({
        Name = "Teleport to Player",
        Callback = function()
            if selectedTarget and selectedTarget.Player and selectedTarget.Player.Character then
                pcall(function()
                    local targetRoot = selectedTarget.Player.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot and myRoot then
                        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                    end
                end)
            end
        end,
    })

    local spectating = false
    TargetDetailsSection:Button({
        Name = "Spectate Player (Toggle)",
        Callback = function()
            pcall(function()
                if not spectating and selectedTarget and selectedTarget.Player and selectedTarget.Player.Character then
                    local hum = selectedTarget.Player.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        Workspace.CurrentCamera.CameraSubject = hum
                        spectating = true
                    end
                else
                    local myHum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if myHum then
                        Workspace.CurrentCamera.CameraSubject = myHum
                    end
                    spectating = false
                end
            end)
        end,
    })

    TargetDetailsSection:Button({
        Name = "Prioritize Target (Aimbot)",
        Callback = function()
            if selectedTarget and selectedTarget.Player then
                getgenv().SwatwarePriorityTarget = selectedTarget.Player
            end
        end,
    })

    TargetDetailsSection:Button({
        Name = "Copy Target User ID",
        Callback = function()
            if selectedTarget and selectedTarget.UserId and setclipboard then
                setclipboard(tostring(selectedTarget.UserId))
            end
        end,
    })

    TargetDetailsSection:Button({
        Name = "Copy Target Username",
        Callback = function()
            if selectedTarget and selectedTarget.Name and setclipboard then
                setclipboard(selectedTarget.Name)
            end
        end,
    })

    TargetDetailsSection:Button({
        Name = "Refresh Database & Players",
        Callback = function()
            SwatwareAPI:Fetch()
            if refreshPlayerListUI then
                refreshPlayerListUI()
            end
        end,
    })

    refreshPlayerListUI = function()
        if not playerListContainer.Parent then return end

        for _, child in ipairs(playerListContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then
                child:Destroy()
            end
        end

        if activeSubtab == "local" then

            local allPlayers = Players:GetPlayers()
            for _, p in ipairs(allPlayers) do
                local matches = searchQuery == ""
                    or string.find(string.lower(p.Name), searchQuery, 1, true)
                    or string.find(string.lower(p.DisplayName), searchQuery, 1, true)

                if matches then
                    local isLocal = (p == Players.LocalPlayer)
                    local isSelected = selectedTarget and selectedTarget.Name == p.Name

                    local row = Instance.new("TextButton")
                    row.Name = "Player_" .. p.Name
                    row.Parent = playerListContainer
                    row.Size = UDim2.new(1, 0, 0, 44)
                    row.BackgroundColor3 = isSelected and Theme.Accent or Theme.Element
                    row.BackgroundTransparency = isSelected and 0.85 or 0.4
                    row.BorderSizePixel = 0
                    row.AutoButtonColor = false
                    row.Text = ""

                    local rCorner = Instance.new("UICorner")
                    rCorner.CornerRadius = UDim.new(0, 8)
                    rCorner.Parent = row

                    local rStroke = Instance.new("UIStroke")
                    rStroke.Color = isSelected and Theme.Accent or Theme.Outline
                    rStroke.Transparency = 0.4
                    rStroke.Parent = row

                    local pAvatar = Instance.new("ImageLabel")
                    pAvatar.Name = "Thumb"
                    pAvatar.Parent = row
                    pAvatar.BackgroundTransparency = 1
                    pAvatar.Position = UDim2.new(0, 8, 0.5, -14)
                    pAvatar.Size = UDim2.fromOffset(28, 28)
                    pAvatar.Image = ""

                    local paCorner = Instance.new("UICorner")
                    paCorner.CornerRadius = UDim.new(1, 0)
                    paCorner.Parent = pAvatar

                    task.spawn(function()
                        local ok, img = pcall(function()
                            return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                        end)
                        if ok and pAvatar.Parent then
                            pAvatar.Image = img
                        end
                    end)

                    local pName = Instance.new("TextLabel")
                    pName.Name = "DisplayName"
                    pName.Parent = row
                    pName.BackgroundTransparency = 1
                    pName.FontFace = Library.Font
                    pName.Text = p.DisplayName .. (isLocal and " (YOU)" or "")
                    pName.TextColor3 = Theme.Text
                    pName.TextSize = 13
                    pName.Position = UDim2.new(0, 44, 0, 6)
                    pName.Size = UDim2.new(1, -140, 0, 16)
                    pName.TextXAlignment = Enum.TextXAlignment.Left
                    pName.TextTruncate = Enum.TextTruncate.AtEnd

                    local pUser = Instance.new("TextLabel")
                    pUser.Name = "Username"
                    pUser.Parent = row
                    pUser.BackgroundTransparency = 1
                    pUser.FontFace = Library.Font
                    pUser.Text = "@" .. p.Name
                    pUser.TextColor3 = Theme.Accent
                    pUser.TextTransparency = 0.25
                    pUser.TextSize = 10
                    pUser.Position = UDim2.new(0, 44, 0, 22)
                    pUser.Size = UDim2.new(1, -140, 0, 14)
                    pUser.TextXAlignment = Enum.TextXAlignment.Left

                    local pTagWrap = Instance.new("Frame")
                    pTagWrap.Name = "TagWrap"
                    pTagWrap.Parent = row
                    pTagWrap.BackgroundTransparency = 1
                    pTagWrap.AnchorPoint = Vector2.new(1, 0.5)
                    pTagWrap.Position = UDim2.new(1, -8, 0.5, 0)
                    pTagWrap.Size = UDim2.new(0, 0, 0, 20)
                    pTagWrap.AutomaticSize = Enum.AutomaticSize.X

                    local pTagLayout = Instance.new("UIListLayout")
                    pTagLayout.Parent = pTagWrap
                    pTagLayout.FillDirection = Enum.FillDirection.Horizontal
                    pTagLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                    pTagLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    pTagLayout.Padding = UDim.new(0, 4)

                    local pTags = SwatwareAPI:GetTags(p.Name)
                    for _, tag in ipairs(pTags) do
                        createTagBadge(pTagWrap, tag)
                    end

                    row.MouseButton1Click:Connect(function()
                        selectedTarget = {
                            Name = p.Name,
                            DisplayName = p.DisplayName,
                            UserId = p.UserId,
                            Tags = pTags,
                            IsInServer = true,
                            Player = p
                        }
                        updateTargetDetailsUI()
                        refreshPlayerListUI()
                    end)
                end
            end
        else

            local count = 0
            for lowerU, uData in pairs(SwatwareAPI.Users) do
                local rawName = uData.Raw or lowerU
                local tags = uData.Tags or {"user"}
                local tagMatch = false
                for _, t in ipairs(tags) do
                    if string.find(t, searchQuery, 1, true) then
                        tagMatch = true
                        break
                    end
                end

                local matches = searchQuery == ""
                    or string.find(lowerU, searchQuery, 1, true)
                    or tagMatch

                if matches then
                    count = count + 1
                    local inServerPlayer = nil
                    for _, sp in ipairs(Players:GetPlayers()) do
                        if string.lower(sp.Name) == lowerU then
                            inServerPlayer = sp
                            break
                        end
                    end

                    local isSelected = selectedTarget and string.lower(selectedTarget.Name) == lowerU

                    local row = Instance.new("TextButton")
                    row.Name = "SwatwareUser_" .. rawName
                    row.Parent = playerListContainer
                    row.Size = UDim2.new(1, 0, 0, 44)
                    row.BackgroundColor3 = isSelected and Theme.Accent or Theme.Element
                    row.BackgroundTransparency = isSelected and 0.85 or 0.4
                    row.BorderSizePixel = 0
                    row.AutoButtonColor = false
                    row.Text = ""

                    local rCorner = Instance.new("UICorner")
                    rCorner.CornerRadius = UDim.new(0, 8)
                    rCorner.Parent = row

                    local rStroke = Instance.new("UIStroke")
                    rStroke.Color = isSelected and Theme.Accent or Theme.Outline
                    rStroke.Transparency = 0.4
                    rStroke.Parent = row

                    local pAvatar = Instance.new("ImageLabel")
                    pAvatar.Name = "Thumb"
                    pAvatar.Parent = row
                    pAvatar.BackgroundTransparency = 1
                    pAvatar.Position = UDim2.new(0, 8, 0.5, -14)
                    pAvatar.Size = UDim2.fromOffset(28, 28)
                    pAvatar.Image = ""

                    local paCorner = Instance.new("UICorner")
                    paCorner.CornerRadius = UDim.new(1, 0)
                    paCorner.Parent = pAvatar

                    task.spawn(function()
                        local uId = inServerPlayer and inServerPlayer.UserId
                        if not uId then
                            local ok, id = pcall(function()
                                return Players:GetUserIdFromNameAsync(rawName)
                            end)
                            if ok then uId = id end
                        end
                        if uId then
                            local ok, img = pcall(function()
                                return Players:GetUserThumbnailAsync(uId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                            end)
                            if ok and pAvatar.Parent then
                                pAvatar.Image = img
                            end
                        end
                    end)

                    local pName = Instance.new("TextLabel")
                    pName.Name = "DisplayName"
                    pName.Parent = row
                    pName.BackgroundTransparency = 1
                    pName.FontFace = Library.Font
                    pName.Text = rawName
                    pName.TextColor3 = Theme.Text
                    pName.TextSize = 13
                    pName.Position = UDim2.new(0, 44, 0, 6)
                    pName.Size = UDim2.new(1, -150, 0, 16)
                    pName.TextXAlignment = Enum.TextXAlignment.Left
                    pName.TextTruncate = Enum.TextTruncate.AtEnd

                    local pStatus = Instance.new("TextLabel")
                    pStatus.Name = "Status"
                    pStatus.Parent = row
                    pStatus.BackgroundTransparency = 1
                    pStatus.FontFace = Library.Font
                    pStatus.Text = inServerPlayer and "• IN SERVER" or "• SWATWARE USER"
                    pStatus.TextColor3 = inServerPlayer and Color3.fromRGB(60, 245, 145) or Theme.Accent
                    pStatus.TextTransparency = 0.2
                    pStatus.TextSize = 10
                    pStatus.Position = UDim2.new(0, 44, 0, 22)
                    pStatus.Size = UDim2.new(1, -150, 0, 14)
                    pStatus.TextXAlignment = Enum.TextXAlignment.Left

                    local pTagWrap = Instance.new("Frame")
                    pTagWrap.Name = "TagWrap"
                    pTagWrap.Parent = row
                    pTagWrap.BackgroundTransparency = 1
                    pTagWrap.AnchorPoint = Vector2.new(1, 0.5)
                    pTagWrap.Position = UDim2.new(1, -8, 0.5, 0)
                    pTagWrap.Size = UDim2.new(0, 0, 0, 20)
                    pTagWrap.AutomaticSize = Enum.AutomaticSize.X

                    local pTagLayout = Instance.new("UIListLayout")
                    pTagLayout.Parent = pTagWrap
                    pTagLayout.FillDirection = Enum.FillDirection.Horizontal
                    pTagLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                    pTagLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    pTagLayout.Padding = UDim.new(0, 4)

                    for _, tag in ipairs(tags) do
                        createTagBadge(pTagWrap, tag)
                    end

                    row.MouseButton1Click:Connect(function()
                        local resolvedId = inServerPlayer and inServerPlayer.UserId
                        if not resolvedId then
                            pcall(function()
                                resolvedId = Players:GetUserIdFromNameAsync(rawName)
                            end)
                        end
                        selectedTarget = {
                            Name = rawName,
                            DisplayName = inServerPlayer and inServerPlayer.DisplayName or rawName,
                            UserId = resolvedId,
                            Tags = tags,
                            IsInServer = inServerPlayer ~= nil,
                            Player = inServerPlayer
                        }
                        updateTargetDetailsUI()
                        refreshPlayerListUI()
                    end)
                end
            end

            if count == 0 then
                local emptyLabel = Instance.new("TextLabel")
                emptyLabel.Name = "EmptyLabel"
                emptyLabel.Parent = playerListContainer
                emptyLabel.BackgroundTransparency = 1
                emptyLabel.Size = UDim2.new(1, 0, 0, 36)
                emptyLabel.FontFace = Library.Font
                emptyLabel.Text = SwatwareAPI.Loaded and "No registered Swatware users match filter" or "Fetching Swatware API database..."
                emptyLabel.TextColor3 = Theme.Text
                emptyLabel.TextTransparency = 0.5
                emptyLabel.TextSize = 11
            end
        end
    end

    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            pcall(refreshPlayerListUI)
            task.wait(2.5)
        end
    end)
end

local hudConfig = {
    Master = false,
    Watermark = false,
    Keybinds = false,
    GameData = false,
    TargetHUD = false,
}
Library.HUDConfig = hudConfig

do
    local SettingsPage = Window:Page({
        Name = "Settings",
        Icon = ICON_SETTINGS,
    })

    local ThemingSection = SettingsPage:Section({
        Name = "Themes & Colors",
        Icon = ICON_THEME,
        Side = 1,
    })

    local themeNames = {
        "Violet",
        "Cyan",
        "Crimson",
        "Emerald",
        "Amber",
        "Tokyo",
        "Frost",
        "Monochrome",
        "Sunset",
        "Tactical"
    }

    ThemingSection:Dropdown({
        Name = "Built-in Themes",
        Flag = "Theme_PresetDropdown",
        Items = themeNames,
        Default = "Violet",
        Callback = function(themeName)
            local preset = BUILT_IN_THEMES[themeName]
            if preset then
                for k, color in pairs(preset) do
                    Library.Theme[k] = color
                    Library:ChangeTheme(k, color)
                    if Library.SetFlags["Example_Theme_" .. k] then
                        pcall(function()
                            Library.SetFlags["Example_Theme_" .. k](color)
                        end)
                    end
                end
                if Library.ESPConfig and Library.ESPConfig.ThemeSync and preset.Accent then
                    Library.ESPConfig.BoxColor = preset.Accent
                    Library.ESPConfig.TracerColor = preset.Accent
                    Library.ESPConfig.ChamsColor = preset.Accent
                    Library.ESPConfig.OffscreenColor = preset.Accent
                    if updatePreviewOverlay then
                        updatePreviewOverlay()
                    end
                end
            end
        end,
    })

    ThemingSection:Toggle({
        Name = "Recolor ESP with Theme",
        Flag = "Theme_SyncESP",
        Default = false,
        Callback = function(val)
            if Library.ESPConfig then
                Library.ESPConfig.ThemeSync = val
                if val and Library.Theme.Accent then
                    Library.ESPConfig.BoxColor = Library.Theme.Accent
                    Library.ESPConfig.TracerColor = Library.Theme.Accent
                    Library.ESPConfig.ChamsColor = Library.Theme.Accent
                    Library.ESPConfig.OffscreenColor = Library.Theme.Accent
                    if updatePreviewOverlay then
                        updatePreviewOverlay()
                    end
                end
            end
        end,
    })

    local themeColorKeys = {"Accent", "Background", "Inline", "Outline", "Text", "Element"}
    for _, ThemeKey in ipairs(themeColorKeys) do
        if Library.Theme[ThemeKey] then
            ThemingSection:Label(ThemeKey):Colorpicker({
                Flag = "Example_Theme_" .. ThemeKey,
                Default = Library.Theme[ThemeKey],
                Callback = function(newColor)
                    Library.Theme[ThemeKey] = newColor
                    Library:ChangeTheme(ThemeKey, newColor)
                end,
            })
        end
    end

    local rgbMenuOn = false
    local rgbMenuSpeed = 1
    local accentBackup = nil

    ThemingSection:Toggle({
        Name = "RGB Accent Cycle",
        Flag = "Example_RGB_Accent",
        Default = false,
        Callback = function(enabled)
            if enabled then
                accentBackup = Library.Theme.Accent
                rgbMenuOn = true
            else
                rgbMenuOn = false
                if accentBackup then
                    Library.Theme.Accent = accentBackup
                    Library:ChangeTheme("Accent", accentBackup)
                    accentBackup = nil
                end
            end
        end,
    })

    ThemingSection:Slider({
        Name = "RGB Speed",
        Flag = "Example_RGB_Speed",
        Default = 1,
        Min = 0.1,
        Max = 5,
        Decimals = 1,
        Callback = function(v)
            rgbMenuSpeed = v
        end,
    })

    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            if rgbMenuOn then
                local dynamicColor = Color3.fromHSV((tick() * rgbMenuSpeed * 0.35) % 1, 1, 1)
                Library.Theme.Accent = dynamicColor
                Library:ChangeTheme("Accent", dynamicColor)
            end
            task.wait(0.05)
        end
    end)

    local ConfigsSection = SettingsPage:Section({
        Name = "Configs & Profiles",
        Icon = ICON_CONFIGS,
        Side = 1,
    })

    local selectedConfigName = nil
    local customConfigInput = ""

    local ConfigsDropdown = ConfigsSection:Dropdown({
        Name = "Saved Configs",
        Flag = "Example_Config_Dropdown",
        Items = {},
        Multi = false,
        MaxSize = 120,
        Callback = function(val)
            selectedConfigName = val
        end,
    })

    ConfigsSection:Textbox({
        Name = "Config Name",
        Placeholder = "Type config name...",
        Flag = "Example_Config_NameInput",
        Finished = true,
        Callback = function(val)
            customConfigInput = val
        end,
    })

    ConfigsSection:Button({
        Name = "Create Config",
        Callback = function()
            if customConfigInput and customConfigInput ~= "" then
                local path = Library.Folders.Configs .. "/" .. customConfigInput .. ".json"
                if not isfile(path) then
                    writefile(path, Library:GetConfig())
                    Library:RefreshConfigsList(ConfigsDropdown)
                end
            end
        end,
    })

    ConfigsSection:Button({
        Name = "Load Config",
        Callback = function()
            if selectedConfigName and selectedConfigName ~= "" then
                local path = Library.Folders.Configs .. "/" .. selectedConfigName .. ".json"
                if isfile(path) then
                    Library:LoadConfig(readfile(path))
                end
            end
        end,
    })

    ConfigsSection:Button({
        Name = "Save Config",
        Callback = function()
            if selectedConfigName and selectedConfigName ~= "" then
                local path = Library.Folders.Configs .. "/" .. selectedConfigName .. ".json"
                writefile(path, Library:GetConfig())
            end
        end,
    })

    ConfigsSection:Button({
        Name = "Delete Config",
        Callback = function()
            if selectedConfigName and selectedConfigName ~= "" then
                local path = Library.Folders.Configs .. "/" .. selectedConfigName .. ".json"
                if isfile(path) then
                    delfile(path)
                    Library:RefreshConfigsList(ConfigsDropdown)
                end
            end
        end,
    })

    ConfigsSection:Button({
        Name = "Refresh List",
        Callback = function()
            Library:RefreshConfigsList(ConfigsDropdown)
        end,
    })

    Library:RefreshConfigsList(ConfigsDropdown)

    local OverlaysSection = SettingsPage:Section({
        Name = "Tactical Screen Overlays",
        Icon = ICON_CAMERA,
        Side = 2,
    })

    Library.HUDConfig = hudConfig

    local masterHudToggle = OverlaysSection:Toggle({
        Name = "Master Overlays Toggle",
        Flag = "Overlay_Master",
        Default = false,
        Callback = function(val)
            hudConfig.Master = val
            if Library.UpdateOverlays then Library.UpdateOverlays() end
        end,
    })
    masterHudToggle:Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.F11,
    })

    OverlaysSection:Toggle({
        Name = "Watermark Overlay",
        Flag = "Overlay_Watermark",
        Default = false,
        Callback = function(val)
            hudConfig.Watermark = val
            if Library.UpdateOverlays then Library.UpdateOverlays() end
        end,
    })

    OverlaysSection:Toggle({
        Name = "Keybind List Overlay",
        Flag = "Overlay_Keybinds",
        Default = false,
        Callback = function(val)
            hudConfig.Keybinds = val
            if Library.UpdateOverlays then Library.UpdateOverlays() end
        end,
    })

    OverlaysSection:Toggle({
        Name = "Game Data Overlay",
        Flag = "Overlay_GameData",
        Default = false,
        Callback = function(val)
            hudConfig.GameData = val
            if Library.UpdateOverlays then Library.UpdateOverlays() end
        end,
    })

    OverlaysSection:Toggle({
        Name = "Target HUD Overlay",
        Flag = "Overlay_TargetHUD",
        Default = false,
        Callback = function(val)
            hudConfig.TargetHUD = val
            if Library.UpdateOverlays then Library.UpdateOverlays() end
        end,
    })

    
    local MenuSection = SettingsPage:Section({
        Name = "Menu Settings",
        Icon = ICON_DEFAULT_SEC,
        Side = 2,
    })

    local menuKeybindObj
    menuKeybindObj = MenuSection:Label("Toggle Menu Key"):Keybind({
        Mode = "Toggle",
        Default = Enum.KeyCode.Insert,
        Callback = function()
            if menuKeybindObj and menuKeybindObj.Picking and menuKeybindObj.Value ~= "None" then
                Library.MenuKeybind = tostring(menuKeybindObj.Key)
            end
        end,
    })

    local mainFrame = Window.Items["MainFrame"] and Window.Items["MainFrame"].Instance
    local baseWindowSize = Vector2.new(900, 600)

    MenuSection:Slider({
        Name = "Menu Scale",
        Flag = "Example_MenuScale",
        Default = 100,
        Min = 70,
        Max = 140,
        Suffix = "%",
        Callback = function(scalePercent)
            if mainFrame then
                local sc = scalePercent / 100
                mainFrame.Size = UDim2.fromOffset(
                    math.floor(baseWindowSize.X * sc + 0.5),
                    math.floor(baseWindowSize.Y * sc + 0.5)
                )
                if syncPreviewPosition then
                    syncPreviewPosition()
                end
            end
        end,
    })

    MenuSection:Slider({
        Name = "Menu Blur Size",
        Flag = "Example_MenuBlur",
        Default = menuBlurSize or 14,
        Min = 0,
        Max = 24,
        Suffix = "px",
        Callback = function(v)
            menuBlurSize = v
            if applyMenuVisuals then
                applyMenuVisuals(menuOpenState)
            end
        end,
    })

    MenuSection:Button({
        Name = "Unload Script",
        Callback = function()
            unloaded = true
            for _, toggleObj in ipairs(allToggles) do
                if toggleObj.Get and toggleObj:Get() then
                    toggleObj:Set(false)
                end
            end
            task.delay(0.2, function()
                Library:Unload()
            end)
        end,
    })
end

do
    local overlayGui = Instance.new("ScreenGui")
    overlayGui.Name = "Swatware_TacticalHUDOverlays"
    overlayGui.ResetOnSpawn = false
    overlayGui.DisplayOrder = 9999
    overlayGui.IgnoreGuiInset = true

    pcall(function()
        overlayGui.Parent = getSafeGuiParent()
    end)

    local function makeDraggable(frame, handle)
        handle = handle or frame
        local dragging = false
        local dragInput, dragStart, startPos

        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    local function addCloseBtn(headerParent, flagKey, configKey)
        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseBtn"
        closeBtn.Parent = headerParent
        closeBtn.BackgroundTransparency = 1
        closeBtn.Size = UDim2.fromOffset(18, 18)
        closeBtn.AnchorPoint = Vector2.new(1, 0.5)
        closeBtn.Position = UDim2.new(1, -6, 0.5, 0)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Theme.Text
        closeBtn.TextTransparency = 0.4
        closeBtn.TextSize = 10
        closeBtn.FontFace = Library.Font
        closeBtn.BorderSizePixel = 0
        closeBtn.AutoButtonColor = false
        closeBtn.ZIndex = 12
        Library:AddToTheme(closeBtn, {TextColor3 = "Text"})

        closeBtn.MouseEnter:Connect(function()
            closeBtn.TextTransparency = 0.0
            closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
        end)
        closeBtn.MouseLeave:Connect(function()
            closeBtn.TextTransparency = 0.4
            closeBtn.TextColor3 = Theme.Text
        end)
        closeBtn.MouseButton1Click:Connect(function()
            hudConfig[configKey] = false
            if Library.SetFlags and Library.SetFlags[flagKey] then
                Library.SetFlags[flagKey](false)
            end
            if Library.UpdateOverlays then Library.UpdateOverlays() end
        end)
    end

    local watermarkFrame = Instance.new("Frame")
    watermarkFrame.Name = "WatermarkHUD"
    watermarkFrame.Parent = overlayGui
    watermarkFrame.Size = UDim2.new(0, 0, 0, 28)
    watermarkFrame.AutomaticSize = Enum.AutomaticSize.X
    watermarkFrame.Position = UDim2.new(0, 20, 0, 20)
    watermarkFrame.BackgroundColor3 = Theme.Background
    watermarkFrame.BorderSizePixel = 0
    watermarkFrame.ClipsDescendants = true
    Library:AddToTheme(watermarkFrame, {BackgroundColor3 = "Background"})

    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 6)
    wmCorner.Parent = watermarkFrame

    local wmStroke = Instance.new("UIStroke")
    wmStroke.Color = Theme.Outline
    wmStroke.Thickness = 1
    wmStroke.Transparency = 0.25
    wmStroke.Parent = watermarkFrame
    Library:AddToTheme(wmStroke, {Color = "Outline"})

    local wmPad = Instance.new("UIPadding")
    wmPad.PaddingLeft = UDim.new(0, 12)
    wmPad.PaddingRight = UDim.new(0, 12)
    wmPad.PaddingTop = UDim.new(0, 5)
    wmPad.PaddingBottom = UDim.new(0, 5)
    wmPad.Parent = watermarkFrame

    local wmLabel = Instance.new("TextLabel")
    wmLabel.Name = "WatermarkText"
    wmLabel.Parent = watermarkFrame
    wmLabel.BackgroundTransparency = 1
    wmLabel.FontFace = Library.Font
    wmLabel.Text = string.format("swatware  |  %s  |  %d FPS  |  %d ms  |  %s", userName or "user", math.floor(fps or 60), getPing(), os.date("%X"))
    wmLabel.TextColor3 = Theme.Text
    wmLabel.TextSize = 12
    wmLabel.Size = UDim2.new(0, 0, 1, 0)
    wmLabel.AutomaticSize = Enum.AutomaticSize.X
    Library:AddToTheme(wmLabel, {TextColor3 = "Text"})

    makeDraggable(watermarkFrame)

    local keybindsFrame = Instance.new("Frame")
    keybindsFrame.Name = "KeybindsHUD"
    keybindsFrame.Parent = overlayGui
    keybindsFrame.Size = UDim2.new(0, 190, 0, 32)
    keybindsFrame.AutomaticSize = Enum.AutomaticSize.Y
    keybindsFrame.Position = UDim2.new(0, 20, 0, 65)
    keybindsFrame.BackgroundColor3 = Theme.Background
    keybindsFrame.BorderSizePixel = 0
    keybindsFrame.ClipsDescendants = true
    Library:AddToTheme(keybindsFrame, {BackgroundColor3 = "Background"})

    local kbCorner = Instance.new("UICorner")
    kbCorner.CornerRadius = UDim.new(0, 8)
    kbCorner.Parent = keybindsFrame

    local kbStroke = Instance.new("UIStroke")
    kbStroke.Color = Theme.Outline
    kbStroke.Thickness = 1
    kbStroke.Transparency = 0.3
    kbStroke.Parent = keybindsFrame
    Library:AddToTheme(kbStroke, {Color = "Outline"})

    local kbHeader = Instance.new("Frame")
    kbHeader.Name = "Header"
    kbHeader.Parent = keybindsFrame
    kbHeader.Size = UDim2.new(1, 0, 0, 28)
    kbHeader.BackgroundColor3 = Theme.Element
    kbHeader.BorderSizePixel = 0
    Library:AddToTheme(kbHeader, {BackgroundColor3 = "Element"})

    local kbhCorner = Instance.new("UICorner")
    kbhCorner.CornerRadius = UDim.new(0, 8)
    kbhCorner.Parent = kbHeader

    addCloseBtn(kbHeader, "Overlay_Keybinds", "Keybinds")

    local kbTitle = Instance.new("TextLabel")
    kbTitle.Parent = kbHeader
    kbTitle.BackgroundTransparency = 1
    kbTitle.FontFace = Library.Font
    kbTitle.Text = "KEYBINDS"
    kbTitle.TextColor3 = Theme.Text
    kbTitle.TextSize = 11
    kbTitle.Position = UDim2.new(0, 10, 0, 0)
    kbTitle.Size = UDim2.new(1, -40, 1, 0)
    kbTitle.TextXAlignment = Enum.TextXAlignment.Left
    Library:AddToTheme(kbTitle, {TextColor3 = "Text"})

    local kbList = Instance.new("Frame")
    kbList.Name = "List"
    kbList.Parent = keybindsFrame
    kbList.BackgroundTransparency = 1
    kbList.Position = UDim2.new(0, 0, 0, 30)
    kbList.Size = UDim2.new(1, 0, 0, 0)
    kbList.AutomaticSize = Enum.AutomaticSize.Y

    local kbLayout = Instance.new("UIListLayout")
    kbLayout.Parent = kbList
    kbLayout.Padding = UDim.new(0, 3)

    local kbListPad = Instance.new("UIPadding")
    kbListPad.PaddingLeft = UDim.new(0, 8)
    kbListPad.PaddingRight = UDim.new(0, 8)
    kbListPad.PaddingTop = UDim.new(0, 4)
    kbListPad.PaddingBottom = UDim.new(0, 8)
    kbListPad.Parent = kbList

    makeDraggable(keybindsFrame, kbHeader)

    local gameDataFrame = Instance.new("Frame")
    gameDataFrame.Name = "GameDataHUD"
    gameDataFrame.Parent = overlayGui
    gameDataFrame.Size = UDim2.new(0, 220, 0, 110)
    gameDataFrame.Position = UDim2.new(1, -240, 0, 20)
    gameDataFrame.BackgroundColor3 = Theme.Background
    gameDataFrame.BorderSizePixel = 0
    gameDataFrame.ClipsDescendants = true
    Library:AddToTheme(gameDataFrame, {BackgroundColor3 = "Background"})

    local gdCorner = Instance.new("UICorner")
    gdCorner.CornerRadius = UDim.new(0, 8)
    gdCorner.Parent = gameDataFrame

    local gdStroke = Instance.new("UIStroke")
    gdStroke.Color = Theme.Outline
    gdStroke.Thickness = 1
    gdStroke.Transparency = 0.3
    gdStroke.Parent = gameDataFrame
    Library:AddToTheme(gdStroke, {Color = "Outline"})

    local gdHeader = Instance.new("Frame")
    gdHeader.Name = "Header"
    gdHeader.Parent = gameDataFrame
    gdHeader.Size = UDim2.new(1, 0, 0, 26)
    gdHeader.BackgroundColor3 = Theme.Element
    gdHeader.BorderSizePixel = 0
    Library:AddToTheme(gdHeader, {BackgroundColor3 = "Element"})

    local gdhCorner = Instance.new("UICorner")
    gdhCorner.CornerRadius = UDim.new(0, 8)
    gdhCorner.Parent = gdHeader

    addCloseBtn(gdHeader, "Overlay_GameData", "GameData")

    local gdTitle = Instance.new("TextLabel")
    gdTitle.Parent = gdHeader
    gdTitle.BackgroundTransparency = 1
    gdTitle.FontFace = Library.Font
    gdTitle.Text = "SERVER & GAME DATA"
    gdTitle.TextColor3 = Theme.Text
    gdTitle.TextSize = 10
    gdTitle.Position = UDim2.new(0, 10, 0, 0)
    gdTitle.Size = UDim2.new(1, -40, 1, 0)
    gdTitle.TextXAlignment = Enum.TextXAlignment.Left
    Library:AddToTheme(gdTitle, {TextColor3 = "Text"})

    local gdContent = Instance.new("Frame")
    gdContent.Parent = gameDataFrame
    gdContent.BackgroundTransparency = 1
    gdContent.Position = UDim2.new(0, 10, 0, 30)
    gdContent.Size = UDim2.new(1, -20, 1, -34)

    local gdLayout = Instance.new("UIListLayout")
    gdLayout.Parent = gdContent
    gdLayout.Padding = UDim.new(0, 2)

    local function makeGdRow(labelTxt)
        local lbl = Instance.new("TextLabel")
        lbl.Parent = gdContent
        lbl.BackgroundTransparency = 1
        lbl.FontFace = Library.Font
        lbl.Text = labelTxt
        lbl.TextColor3 = Theme.Text
        lbl.TextTransparency = 0.3
        lbl.TextSize = 10
        lbl.Size = UDim2.new(1, 0, 0, 13)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        Library:AddToTheme(lbl, {TextColor3 = "Text"})
        return lbl
    end

    local gdGame = makeGdRow("Game: " .. tostring(game.Name))
    local gdPlace = makeGdRow("Place: " .. tostring(game.PlaceId))
    local gdJob = makeGdRow("Job ID: " .. (game.JobId ~= "" and string.sub(game.JobId, 1, 10) .. "..." or "Studio"))
    local gdPlayers = makeGdRow("Players: 1 / 1")
    local gdUptime = makeGdRow("Session: 00:00:00")

    makeDraggable(gameDataFrame, gdHeader)

    local targetHudCard = Instance.new("Frame")
    targetHudCard.Name = "TargetHUD"
    targetHudCard.Parent = overlayGui
    targetHudCard.Size = UDim2.new(0, 260, 0, 84)
    targetHudCard.Position = UDim2.new(0.5, -130, 0.72, 0)
    targetHudCard.BackgroundColor3 = Theme.Background
    targetHudCard.BorderSizePixel = 0
    targetHudCard.ClipsDescendants = true
    Library:AddToTheme(targetHudCard, {BackgroundColor3 = "Background"})

    local thCorner = Instance.new("UICorner")
    thCorner.CornerRadius = UDim.new(0, 10)
    thCorner.Parent = targetHudCard

    local thStroke = Instance.new("UIStroke")
    thStroke.Color = Theme.Outline
    thStroke.Thickness = 1
    thStroke.Transparency = 0.3
    thStroke.Parent = targetHudCard
    Library:AddToTheme(thStroke, {Color = "Outline"})

    addCloseBtn(targetHudCard, "Overlay_TargetHUD", "TargetHUD")

    local thAvatar = Instance.new("ImageLabel")
    thAvatar.Name = "Avatar"
    thAvatar.Parent = targetHudCard
    thAvatar.BackgroundColor3 = Theme.Element
    thAvatar.BorderSizePixel = 0
    thAvatar.Position = UDim2.new(0, 10, 0, 14)
    thAvatar.Size = UDim2.fromOffset(54, 54)
    thAvatar.Image = ""
    Library:AddToTheme(thAvatar, {BackgroundColor3 = "Element"})

    local thaCorner = Instance.new("UICorner")
    thaCorner.CornerRadius = UDim.new(0, 8)
    thaCorner.Parent = thAvatar

    local thaStroke = Instance.new("UIStroke")
    thaStroke.Color = Theme.Accent
    thaStroke.Thickness = 1.2
    thaStroke.Parent = thAvatar
    Library:AddToTheme(thaStroke, {Color = "Accent"})

    local thName = Instance.new("TextLabel")
    thName.Name = "DisplayName"
    thName.Parent = targetHudCard
    thName.BackgroundTransparency = 1
    thName.FontFace = Library.Font
    thName.Text = "Target Name"
    thName.TextColor3 = Theme.Text
    thName.TextSize = 13
    thName.Position = UDim2.new(0, 72, 0, 12)
    thName.Size = UDim2.new(1, -95, 0, 16)
    thName.TextXAlignment = Enum.TextXAlignment.Left
    thName.TextTruncate = Enum.TextTruncate.AtEnd
    Library:AddToTheme(thName, {TextColor3 = "Text"})

    local thUser = Instance.new("TextLabel")
    thUser.Name = "Username"
    thUser.Parent = targetHudCard
    thUser.BackgroundTransparency = 1
    thUser.FontFace = Library.Font
    thUser.Text = "@target • 0 studs"
    thUser.TextColor3 = Theme.Accent
    thUser.TextSize = 10
    thUser.Position = UDim2.new(0, 72, 0, 29)
    thUser.Size = UDim2.new(1, -95, 0, 14)
    thUser.TextXAlignment = Enum.TextXAlignment.Left
    thUser.TextTruncate = Enum.TextTruncate.AtEnd
    Library:AddToTheme(thUser, {TextColor3 = "Accent"})

    local thHealthBg = Instance.new("Frame")
    thHealthBg.Name = "HealthBarBg"
    thHealthBg.Parent = targetHudCard
    thHealthBg.BackgroundColor3 = Theme.Element
    thHealthBg.BorderSizePixel = 0
    thHealthBg.Position = UDim2.new(0, 72, 0, 48)
    thHealthBg.Size = UDim2.new(1, -82, 0, 8)
    Library:AddToTheme(thHealthBg, {BackgroundColor3 = "Element"})

    local thhCorner = Instance.new("UICorner")
    thhCorner.CornerRadius = UDim.new(0, 4)
    thhCorner.Parent = thHealthBg

    local thHealthFill = Instance.new("Frame")
    thHealthFill.Name = "HealthFill"
    thHealthFill.Parent = thHealthBg
    thHealthFill.BackgroundColor3 = Color3.fromRGB(56, 239, 125)
    thHealthFill.BorderSizePixel = 0
    thHealthFill.Size = UDim2.new(1, 0, 1, 0)

    local thhfCorner = Instance.new("UICorner")
    thhfCorner.CornerRadius = UDim.new(0, 4)
    thhfCorner.Parent = thHealthFill

    local thHealthText = Instance.new("TextLabel")
    thHealthText.Name = "HealthText"
    thHealthText.Parent = targetHudCard
    thHealthText.BackgroundTransparency = 1
    thHealthText.FontFace = Library.Font
    thHealthText.Text = "100 HP (100%)"
    thHealthText.TextColor3 = Theme.Text
    thHealthText.TextTransparency = 0.3
    thHealthText.TextSize = 9
    thHealthText.Position = UDim2.new(0, 72, 0, 60)
    thHealthText.Size = UDim2.new(1, -82, 0, 12)
    thHealthText.TextXAlignment = Enum.TextXAlignment.Left
    Library:AddToTheme(thHealthText, {TextColor3 = "Text"})

    makeDraggable(targetHudCard)

    local sessionStartTime = tick()

    local targetThumbCache = {}
    local function getActiveTarget()
        local lp = Players.LocalPlayer
        local myChar = lp and lp.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local cam = Workspace.CurrentCamera

        if combatState.AimbotTarget and combatState.AimbotTarget.Parent then
            local p = combatState.AimbotTarget
            local char = p.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                return p, char, hum
            end
        end

        if combatState.TargetLocked and combatState.TargetLocked.Parent then
            local char = combatState.TargetLocked
            local p = Players:GetPlayerFromCharacter(char)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if p and hum and hum.Health > 0 then
                return p, char, hum
            end
        end

        local mouseLoc = UserInputService:GetMouseLocation()
        local bestPlayer, bestChar, bestHum = nil, nil, nil
        local closestDist = math.huge

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local char = p.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                if hum and hum.Health > 0 and hrp and cam then
                    local pos2d, onScreen = cam:WorldToViewportPoint(hrp.Position)
                    if onScreen and pos2d.Z > 0 then
                        local screenDist = (Vector2.new(pos2d.X, pos2d.Y) - mouseLoc).Magnitude
                        if screenDist < 250 and screenDist < closestDist then
                            closestDist = screenDist
                            bestPlayer = p
                            bestChar = char
                            bestHum = hum
                        end
                    end
                end
            end
        end

        if not bestPlayer and myHrp then
            local worldDist = math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local char = p.Character
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and hrp then
                        local d = (hrp.Position - myHrp.Position).Magnitude
                        if d < 120 and d < worldDist then
                            worldDist = d
                            bestPlayer = p
                            bestChar = char
                            bestHum = hum
                        end
                    end
                end
            end
        end

        return bestPlayer, bestChar, bestHum
    end

    local function refreshTargetHUD()
        if not hudConfig.TargetHUD then return end

        local targetPlayer, targetChar, targetHum = getActiveTarget()
        local lp = Players.LocalPlayer
        local myChar = lp and lp.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if targetPlayer and targetChar and targetHum then
            local curHp = math.max(0, math.floor(targetHum.Health))
            local maxHp = math.max(1, math.floor(targetHum.MaxHealth))
            local hpRatio = math.clamp(curHp / maxHp, 0, 1)

            local dist = 0
            local targetHrp = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head")
            if targetHrp and myHrp then
                dist = math.floor((targetHrp.Position - myHrp.Position).Magnitude)
            end

            local tool = targetChar:FindFirstChildOfClass("Tool")
            local toolName = tool and tool.Name or "None"

            thName.Text = targetPlayer.DisplayName
            thUser.Text = "@" .. targetPlayer.Name .. " - " .. dist .. " studs - [" .. toolName .. "]"
            thHealthText.Text = string.format("%d / %d HP (%d%%)", curHp, maxHp, math.floor(hpRatio * 100))

            TweenService:Create(thHealthFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(hpRatio, 0, 1, 0),
                BackgroundColor3 = Color3.fromHSV(hpRatio * 0.33, 0.85, 0.95)
            }):Play()

            if not targetThumbCache[targetPlayer.UserId] then
                task.spawn(function()
                    local s, img = pcall(function()
                        return Players:GetUserThumbnailAsync(
                            targetPlayer.UserId,
                            Enum.ThumbnailType.HeadShot,
                            Enum.ThumbnailSize.Size100x100
                        )
                    end)
                    if s and img then
                        targetThumbCache[targetPlayer.UserId] = img
                        if thAvatar.Parent then thAvatar.Image = img end
                    end
                end)
            else
                thAvatar.Image = targetThumbCache[targetPlayer.UserId]
            end
        else
            thName.Text = "No Target Locked"
            thUser.Text = "Awaiting target acquisition..."
            thHealthText.Text = "0 / 0 HP (0%)"
            TweenService:Create(thHealthFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            }):Play()
            thAvatar.Image = ""
        end
    end

    local sessionStartTime = tick()
    task.spawn(function()
        while not unloaded and getgenv().AltHackGen == GEN do
            task.wait(0.1)
            pcall(function()
                local stats = game:GetService("Stats")
                local pingVal = stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                local pingNum = math.floor(tonumber(pingVal:match("%d+")) or 0)
                local timeStr = os.date("%X")

                local elapsedSec = math.floor(tick() - sessionStartTime)
                local hours = math.floor(elapsedSec / 3600)
                local mins = math.floor((elapsedSec % 3600) / 60)
                local secs = elapsedSec % 60
                local uptimeStr = string.format("%02d:%02d:%02d", hours, mins, secs)

                wmLabel.Text = string.format("swatware  |  %s  |  %d FPS  |  %d ms  |  %s", userName, fps or 60, pingNum, timeStr)

                gdPlayers.Text = string.format("Players: %d / %d", #Players:GetPlayers(), Players.MaxPlayers)
                gdUptime.Text = "Session: " .. uptimeStr

                refreshKeybindsHUD()
                refreshTargetHUD()
            end)
        end
    end)
end
