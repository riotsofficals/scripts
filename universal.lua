getgenv().CrypticalGen = (tonumber(getgenv().CrypticalGen) or 0) + 1
local GEN = getgenv().CrypticalGen

pcall(function()
    getgenv().debugInfo = false
end)

local g = getinfo or debug.getinfo
local d = false
local h = {}

local x, y

setthreadidentity(2)

for i, v in getgc(true) do
    if typeof(v) == "table" then
        local a = rawget(v, "Detected")
        local b = rawget(v, "Kill")
    
        if typeof(a) == "function" and not x then
            x = a
            
            local o; o = hookfunction(x, function(c, f, n)
                if c ~= "_" then
                    if d then
                        warn(`Adonis AntiCheat flagged\nMethod: {c}\nInfo: {f}`)
                    end
                end
                
                return true
            end)

            table.insert(h, x)
        end

        if rawget(v, "Variables") and rawget(v, "Process") and typeof(b) == "function" and not y then
            y = b
            local o; o = hookfunction(y, function(f)
                if d then
                    warn(`Adonis AntiCheat tried to kill (fallback): {f}`)
                end
            end)

            table.insert(h, y)
        end
    end
end

local o; o = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local a, f = ...

    if x and a == x then
        if d then
            warn(`zins | adonis bypassed`)
        end

        return coroutine.yield(coroutine.running())
    end
    
    return o(...)
end))

setthreadidentity(7)

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

local previousMenuBlur = game:GetService("Lighting"):FindFirstChild("Cryptical_MenuBlur")
if previousMenuBlur then
    pcall(function()
        previousMenuBlur:Destroy()
    end)
end

local Library = (function()

if getgenv().CrypticalPlayerESP then
    pcall(function()
        getgenv().CrypticalPlayerESP:Destroy()
    end)
    getgenv().CrypticalPlayerESP = nil
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
    Library.CreateWidgetContextMenu = Library.CreateWidgetContextMenu or function() end

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

            if NewItem.Properties then
                for Property, Value in pairs(NewItem.Properties) do
                    pcall(function()
                        NewItem.Instance[Property] = Value
                    end)
                end
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
            local DragTarget = (Handle and typeof(Handle) == "Instance" and Handle) or (Handle and Handle.Instance) or Gui
            local Dragging = false
            local DragStart
            local StartPosition
            local DragInput

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                Gui.Position = UDim2New(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset + DragDelta.X,
                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset + DragDelta.Y
                )
            end

            Library:Connect(DragTarget.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    local changedConn
                    changedConn = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            if changedConn then
                                changedConn:Disconnect()
                                changedConn = nil
                            end
                        end
                    end)
                end
            end)

            Library:Connect(DragTarget.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    DragInput = Input
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if (Input == DragInput or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
                    Set(Input)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
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
                    Id = "Cryptical_SFProText",
                    Url = "https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts/raw/master/SF-Pro-Text-Regular.otf"
                })
            end)
            if not loaded then
                pcall(function() delfile("Cryptical_SFProText") end)
                loaded = pcall(function()
                    Library.Font = CustomFont:New("Inter", 400, "Regular", {
                        Id = "Cryptical_Inter",
                        Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Inter.ttf"
                    })
                end)
            end
            if not loaded then
                pcall(function() delfile("Cryptical_Inter") end)
                pcall(function()
                    Library.Font = CustomFont:New("OutfitMedium", 400, "Regular", {
                        Id = "OutfitMedium",
                        Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Outfit-Medium.ttf"
                    })
                end)
            end
            if not Library.Font then
                Library.Font = Font.fromEnum(Enum.Font.GothamMedium)
            end
        end
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "Cryptical_MainGui",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Enabled = false,
        ResetOnSpawn = false
    })

    local NotifContainer = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "NotifContainer",
        Position = UDim2New(1, -20, 1, -20),
        Size = UDim2New(0, 280, 1, -40),
        AnchorPoint = Vector2New(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 9999
    })

    Instances:Create("UIListLayout", {
        Parent = NotifContainer.Instance,
        Name = "\0",
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDimNew(0, 8)
    })

    function Library:Notify(Config, Content, Duration)
        local Title = "cryptical"
        local Text = ""
        local Time = Duration or 3.5

        if type(Config) == "table" then
            Title = Config.Title or Config.title or Config.Name or Config.name or Title
            Text = Config.Text or Config.text or Config.Content or Config.content or Config.Message or Config.message or ""
            Time = Config.Time or Config.time or Config.Duration or Config.duration or Time
        elseif type(Config) == "string" then
            if Content then
                Title = Config
                Text = tostring(Content)
            else
                Text = Config
            end
        end

        local Toast = Instances:Create("Frame", {
            Parent = NotifContainer.Instance,
            Name = "Notification",
            Size = UDim2New(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Library.Theme["Inline"] or Color3.fromRGB(12, 12, 15),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 10000
        }):AddToTheme({BackgroundColor3 = 'Inline'})

        Instances:Create("UICorner", {
            Parent = Toast.Instance,
            CornerRadius = UDimNew(0, 8)
        })

        Instances:Create("UIStroke", {
            Parent = Toast.Instance,
            Color = Library.Theme["Outline"] or Color3.fromRGB(28, 28, 36),
            Thickness = 1,
            Transparency = 0.3
        }):AddToTheme({Color = 'Outline'})

        local AccentBar = Instances:Create("Frame", {
            Parent = Toast.Instance,
            Name = "AccentBar",
            Position = UDim2New(0, 0, 0, 0),
            Size = UDim2New(0, 4, 1, 0),
            BackgroundColor3 = Library.Theme["Accent"] or Color3.fromRGB(139, 149, 246),
            BorderSizePixel = 0,
            ZIndex = 10001
        }):AddToTheme({BackgroundColor3 = 'Accent'})

        Instances:Create("UICorner", {
            Parent = AccentBar.Instance,
            CornerRadius = UDimNew(0, 2)
        })

        local ContentFrame = Instances:Create("Frame", {
            Parent = Toast.Instance,
            Name = "ContentFrame",
            Position = UDim2New(0, 10, 0, 0),
            Size = UDim2New(1, -14, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10001
        })

        Instances:Create("UIPadding", {
            Parent = ContentFrame.Instance,
            PaddingTop = UDimNew(0, 8),
            PaddingBottom = UDimNew(0, 10),
            PaddingLeft = UDimNew(0, 4),
            PaddingRight = UDimNew(0, 8)
        })

        Instances:Create("UIListLayout", {
            Parent = ContentFrame.Instance,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDimNew(0, 3)
        })

        local HeaderRow = Instances:Create("Frame", {
            Parent = ContentFrame.Instance,
            Name = "HeaderRow",
            Size = UDim2New(1, 0, 0, 16),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1
        })

        Instances:Create("TextLabel", {
            Parent = HeaderRow.Instance,
            Name = "Title",
            FontFace = Library.Font,
            Text = Title,
            TextColor3 = Library.Theme["Accent"] or Color3.fromRGB(139, 149, 246),
            TextSize = 12,
            BackgroundTransparency = 1,
            Size = UDim2New(1, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 10002
        }):AddToTheme({TextColor3 = 'Accent'})

        Instances:Create("TextLabel", {
            Parent = ContentFrame.Instance,
            Name = "Message",
            FontFace = Library.Font,
            Text = Text,
            TextColor3 = Library.Theme["Text"] or Color3.fromRGB(235, 235, 245),
            TextTransparency = 0.15,
            TextSize = 11,
            TextWrapped = true,
            BackgroundTransparency = 1,
            Size = UDim2New(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 10002
        }):AddToTheme({TextColor3 = 'Text'})

        local ProgressBarTrack = Instances:Create("Frame", {
            Parent = Toast.Instance,
            Name = "ProgressTrack",
            Position = UDim2New(0, 0, 1, -2),
            Size = UDim2New(1, 0, 0, 2),
            BackgroundColor3 = Color3.fromRGB(20, 20, 28),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = 10003
        })

        local ProgressBar = Instances:Create("Frame", {
            Parent = ProgressBarTrack.Instance,
            Name = "ProgressBar",
            Size = UDim2New(1, 0, 1, 0),
            BackgroundColor3 = Library.Theme["Accent"] or Color3.fromRGB(139, 149, 246),
            BorderSizePixel = 0,
            ZIndex = 10004
        }):AddToTheme({BackgroundColor3 = 'Accent'})

        local toastInst = Toast.Instance
        toastInst.Position = UDim2New(1, 50, 0, 0)
        TweenService:Create(toastInst, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2New(0, 0, 0, 0)
        }):Play()

        local progressInst = ProgressBar.Instance
        TweenService:Create(progressInst, TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Size = UDim2New(0, 0, 1, 0)
        }):Play()

        task.delay(Time, function()
            if toastInst and toastInst.Parent then
                local tw = TweenService:Create(toastInst, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Position = UDim2New(1, 60, 0, 0)
                })
                tw.Completed:Connect(function()
                    Toast:Clean()
                end)
                tw:Play()
            end
        end)

        return Toast
    end

    Library.Notification = function(self, ...) return Library:Notify(...) end

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

        if getgenv().CrypticalPlayerESP then
            pcall(function()
                getgenv().CrypticalPlayerESP:Destroy()
            end)
            getgenv().CrypticalPlayerESP = nil
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

        local function matchesKeybind(Input)
            if not Keybind.Key or Keybind.Key == "" or Keybind.Key == "None" or Keybind.Key == "Enum.KeyCode.Unknown" or Keybind.Value == "None" or Keybind.Value == "Unknown" or Keybind.Value == "" then
                return false
            end
            if Keybind.Picking then
                return false
            end
            if UserInputService:GetFocusedTextBox() then
                return false
            end

            local keyStr = tostring(Keybind.Key)
            local codeStr = tostring(Input.KeyCode)
            local typeStr = tostring(Input.UserInputType)
            local codeName = Input.KeyCode.Name
            local typeName = Input.UserInputType.Name

            return (codeStr == keyStr) or (typeStr == keyStr) or (codeName == keyStr) or (typeName == keyStr)
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if matchesKeybind(Input) then
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
            if matchesKeybind(Input) then
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
                Name = Data.Name or Data.name or "cryptical",
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
                    Name = "Cryptical_Main",
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
                Items["MainFrame"]:MakeDraggable(Items["TopBar"])
                Items["MainFrame"]:MakeDraggable(Items["TopContainer"])

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
                    Text = "build: cryptical beta",
                    Size = UDim2New(0, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    LayoutOrder = 2,
                    ZIndex = 12
                }):AddToTheme({TextColor3 = 'Text'})

                Items["TitleDot"] = Instances:Create("Frame", {
                    Parent = Items["TitleArea"].Instance,
                    Name = "TitleDot",
                    BackgroundColor3 = FromRGB(255, 153, 0),
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 6, 0, 6),
                    LayoutOrder = 3,
                    ZIndex = 12
                })

                Instances:Create("UICorner", {
                    Parent = Items["TitleDot"].Instance,
                    CornerRadius = UDimNew(1, 0)
                })

                Items["StatusText"] = Instances:Create("TextLabel", {
                    Parent = Items["TitleArea"].Instance,
                    Name = "StatusText",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(140, 145, 165),
                    Text = "status: active",
                    Size = UDim2New(0, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 13,
                    LayoutOrder = 4,
                    ZIndex = 12
                })

                Items["StatusDot"] = Instances:Create("Frame", {
                    Parent = Items["TitleArea"].Instance,
                    Name = "StatusDot",
                    BackgroundColor3 = FromRGB(56, 239, 125),
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 6, 0, 6),
                    LayoutOrder = 5,
                    ZIndex = 12
                })

                Instances:Create("UICorner", {
                    Parent = Items["StatusDot"].Instance,
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Pages"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["TopContainer"].Instance,
                    Name = "TabsList",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(1, -260, 1, 0),
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.X,
                    ScrollBarThickness = 0,
                    ClipsDescendants = true,
                    LayoutOrder = 3,
                    ZIndex = 15
                })

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
                    LayoutOrder = 2,
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
                    LayoutOrder = 1,
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

                Items["BottomBar"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "BottomBar",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 20),
                    BackgroundColor3 = Library.Theme["Inline"],
                    BackgroundTransparency = 0.4,
                    BorderSizePixel = 0,
                    ZIndex = 5
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                local BottomBarBorder = Instances:Create("Frame", {
                    Parent = Items["BottomBar"].Instance,
                    Name = "Border",
                    Size = UDim2New(1, 0, 0, 1),
                    Position = UDim2New(0, 0, 0, 0),
                    BackgroundColor3 = Library.Theme["Outline"],
                    BackgroundTransparency = 0.3,
                    BorderSizePixel = 0,
                    ZIndex = 6
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["MainFrame"]:MakeDraggable(Items["BottomBar"])

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "Content",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 48),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, -68),
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
                local MainFrame = Items["MainFrame"] and Items["MainFrame"].Instance
                if MainFrame then
                    MainFrame.AnchorPoint = Vector2New(0.5, 0.5)
                    MainFrame.Position = UDim2New(0.5, 0, 0.5, 0)
                end
            end

            function Window:SetOpen(Bool)
                Window.IsOpen = not not Bool
                local MainFrame = Items["MainFrame"] and Items["MainFrame"].Instance
                if MainFrame and MainFrame.Parent then
                    MainFrame.Visible = Window.IsOpen
                end
                if applyMenuVisuals then
                    applyMenuVisuals(Window.IsOpen)
                end
                if syncPreviewPosition then
                    syncPreviewPosition()
                end
            end

            Library:Connect(UserInputService.InputBegan, function(Input, gameProcessed)
                if gameProcessed and Input.UserInputType == Enum.UserInputType.Keyboard then
                    local focused = UserInputService:GetFocusedTextBox()
                    if focused then return end
                end

                local inputCode = Input.KeyCode
                local inputType = Input.UserInputType
                local bind = Library.MenuKeybind

                local matches = false
                if typeof(bind) == "EnumItem" then
                    matches = (inputCode == bind or inputType == bind)
                elseif type(bind) == "string" and bind ~= "" and bind ~= "None" and bind ~= "Enum.KeyCode.Unknown" then
                    matches = (tostring(inputCode) == bind or inputCode.Name == bind or tostring(inputType) == bind or inputType.Name == bind)
                end

                if matches then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
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

                Instances:Create("UIPadding", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 1),
                    PaddingBottom = UDimNew(0, 1),
                    PaddingLeft = UDimNew(0, 1),
                    PaddingRight = UDimNew(0, 1)
                })

                Items["Section"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "SectionInner",
                    Position = UDim2New(0, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 0),
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

                Instances:Create("UIListLayout", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDimNew(0, 0)
                })

                Items["Top"] = Instances:Create("TextButton", {
                    Parent = Items["Section"].Instance,
                    Name = "Header",
                    BackgroundTransparency = 1,
                    AutoButtonColor = false,
                    Text = "",
                    BorderSizePixel = 0,
                    Size = UDim2New(1, 0, 0, 36),
                    LayoutOrder = 1,
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
                    Position = UDim2New(0, 0, 0, 0),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 2,
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
                    Items["Arrow"]:Tween(TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Rotation = collapsed and -90 or 0,
                        ImageTransparency = collapsed and 0.65 or 0.35
                    })

                    if collapsed then
                        Content.AutomaticSize = Enum.AutomaticSize.None
                        local tw = TweenService:Create(Content, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2New(1, 0, 0, 0)
                        })
                        tw:Play()
                        tw.Completed:Connect(function()
                            if Section.Collapsed then
                                Content.Visible = false
                            end
                        end)
                    else
                        Content.Visible = true
                        Content.Size = UDim2New(1, 0, 0, 0)
                        Content.AutomaticSize = Enum.AutomaticSize.Y
                        local outline = Items["SectionOutline"].Instance
                        TweenService:Create(outline, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.2
                        }):Play()
                        task.delay(0.22, function()
                            if not Section.Collapsed then
                                TweenService:Create(outline, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                    BackgroundTransparency = 0.4
                                }):Play()
                            end
                        end)
                    end
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

                local userCallback = Data.Callback or Data.callback
                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default,
                    Mode = Data.Mode or Data.mode or "Toggle",
                    Callback = function(state)
                        if userCallback then
                            Library:SafeCall(userCallback, state)
                        end
                    end
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

            Library:CreateWidgetContextMenu(Items["Toggle"], {
                {
                    Name = "Toggle State",
                    Callback = function() Toggle:Set(not Toggle.Value) end
                },
                {
                    Name = "Reset Default",
                    Callback = function() Toggle:Set(Toggle.Default) end
                },
                {
                    Name = "Copy Flag Name",
                    Callback = function() if setclipboard then setclipboard(tostring(Toggle.Flag)) end end
                }
            })

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

            Library:CreateWidgetContextMenu(Items["Slider"], {
                {
                    Name = "Reset Default",
                    Callback = function() Slider:Set(Slider.Default) end
                },
                {
                    Name = "Copy Current Value",
                    Callback = function() if setclipboard then setclipboard(tostring(Slider.Value)) end end
                },
                {
                    Name = "Copy Flag Name",
                    Callback = function() if setclipboard then setclipboard(tostring(Slider.Flag)) end end
                }
            })

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

                Items["OptionHolder"] = Instances:Create("ScrollingFrame", {
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
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    ClipsDescendants = true,
                    Active = true,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline', ScrollBarImageColor3 = 'Accent'})

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

                if Items["Icon"] and Items["Icon"].Instance then
                    TweenService:Create(Items["Icon"].Instance, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Rotation = Dropdown.IsOpen and 180 or 0
                    }):Play()
                end

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
                        local optionCount = 0
                        for _, child in ipairs(Items["OptionHolder"].Instance:GetChildren()) do
                            if child:IsA("GuiButton") or child:IsA("TextButton") then
                                optionCount = optionCount + 1
                            end
                        end
                        local visibleCount = math.min(optionCount, 5)
                        local targetHeight = (visibleCount > 0) and ((visibleCount * 26) + 14) or 40
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, targetHeight)
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

            Library:CreateWidgetContextMenu(Items["Dropdown"], {
                {
                    Name = "Reset Default",
                    Callback = function() if Dropdown.Default then Dropdown:Set(Dropdown.Default) end end
                },
                {
                    Name = "Copy Flag Name",
                    Callback = function() if setclipboard then setclipboard(tostring(Dropdown.Flag)) end end
                }
            })

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

            Library:CreateWidgetContextMenu(Items["Textbox"], {
                {
                    Name = "Clear Text",
                    Callback = function() Textbox:Set("") end
                },
                {
                    Name = "Reset Default",
                    Callback = function() Textbox:Set(Textbox.Default or "") end
                },
                {
                    Name = "Copy Flag Name",
                    Callback = function() if setclipboard then setclipboard(tostring(Textbox.Flag)) end end
                }
            })

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

local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local Lighting = cloneref and cloneref(game:GetService("Lighting")) or game:GetService("Lighting")
local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")

local function getSafeGuiParent()
    local parent = nil
    pcall(function()
        if getgenv and type(getgenv().gethui) == "function" then
            parent = getgenv().gethui()
        end
    end)
    if parent then return parent end

    local canUseCore = false
    pcall(function()
        local test = Instance.new("Folder")
        test.Parent = CoreGui
        test:Destroy()
        canUseCore = true
    end)
    if canUseCore then
        return CoreGui
    end

    local lp = Players.LocalPlayer or (Players:GetPlayers() and Players:GetPlayers()[1])
    if lp then
        local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui")
        if pg then return pg end
    end

    return CoreGui
end

local gethui = function()
    return getSafeGuiParent()
end

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
                    local frame = sec.Items["SectionOutline"].Instance
                    if name == tabName then
                        frame.Visible = true
                        frame.Position = UDim2.new(0, 0, 0, 0)
                    else
                        frame.Visible = false
                    end
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
local ICON_SHIELD = "rbxassetid://127136375066593"
local ICON_CUBE = "rbxassetid://89470265972291"
local ICON_COLOR = "rbxassetid://93142176757189"

local holderGui = Library.Holder and Library.Holder.Instance
if holderGui then
    pcall(function()
        holderGui.DisplayOrder = 100
        holderGui.Enabled = true
        if not holderGui.Parent or holderGui.Parent == game then
            holderGui.Parent = getSafeGuiParent()
        end
    end)
end

local Window = Library:Window({
    Name = "cryptical",
    Logo = LOGO,
})

pcall(function()
    if Window.Items and Window.Items["MainFrame"] and Window.Items["MainFrame"].Instance then
        Window.Items["MainFrame"].Instance.Visible = true
    end
end)

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
            menuBlur.Name = "Cryptical_MenuBlur"
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

    if getgenv().CrypticalGen == GEN then
        getgenv().CrypticalGen = GEN + 1
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
        if getgenv().CrypticalGen ~= GEN then
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
    local uiScale = mainFrame:FindFirstChild("Cryptical_Pop")
    if not uiScale then
        uiScale = Instance.new("UIScale")
        uiScale.Name = "Cryptical_Pop"
        uiScale.Parent = mainFrame
    end

    if v then
        mainFrame.Visible = true
        uiScale.Scale = 0.95
        TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    else
        local tw = TweenService:Create(uiScale, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.95})
        tw:Play()
        tw.Completed:Connect(function()
            if not menuOpenState and mainFrame and mainFrame.Parent then
                mainFrame.Visible = false
            end
        end)
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
        while not unloaded and getgenv().CrypticalGen == GEN do
            task.wait(0.5)
            fps = frames * 2
            frames = 0
        end
    end)
end

local CrypticalAPI = {
    Users = {},
    Loaded = false,
    Url = "https://cryptical-api.avgavg193.workers.dev/users.txt",
    TagColors = {
        ["owner"]     = { Text = Color3.fromRGB(255, 215, 0), Bg = Color3.fromRGB(45, 36, 10), Border = Color3.fromRGB(180, 140, 20) },
        ["admin"]     = { Text = Color3.fromRGB(255, 75, 95), Bg = Color3.fromRGB(42, 14, 18), Border = Color3.fromRGB(150, 30, 45) },
        ["dev"]       = { Text = Color3.fromRGB(195, 135, 255), Bg = Color3.fromRGB(32, 16, 48), Border = Color3.fromRGB(120, 55, 175) },
        ["developer"] = { Text = Color3.fromRGB(195, 135, 255), Bg = Color3.fromRGB(32, 16, 48), Border = Color3.fromRGB(120, 55, 175) },
        ["staff"]     = { Text = Color3.fromRGB(160, 120, 255), Bg = Color3.fromRGB(28, 18, 45), Border = Color3.fromRGB(110, 45, 170) },
        ["mod"]       = { Text = Color3.fromRGB(255, 100, 100), Bg = Color3.fromRGB(40, 15, 15), Border = Color3.fromRGB(160, 40, 40) },
        ["moderator"] = { Text = Color3.fromRGB(255, 100, 100), Bg = Color3.fromRGB(40, 15, 15), Border = Color3.fromRGB(160, 40, 40) },
        ["media"]     = { Text = Color3.fromRGB(255, 185, 45), Bg = Color3.fromRGB(42, 28, 10), Border = Color3.fromRGB(160, 105, 20) },
        ["verified"]  = { Text = Color3.fromRGB(60, 210, 255), Bg = Color3.fromRGB(12, 32, 45), Border = Color3.fromRGB(30, 120, 165) },
        ["verifed"]   = { Text = Color3.fromRGB(60, 210, 255), Bg = Color3.fromRGB(12, 32, 45), Border = Color3.fromRGB(30, 120, 165) },
        ["vip"]       = { Text = Color3.fromRGB(60, 245, 145), Bg = Color3.fromRGB(14, 38, 24), Border = Color3.fromRGB(35, 150, 80) },
        ["buyer"]     = { Text = Color3.fromRGB(60, 245, 145), Bg = Color3.fromRGB(14, 38, 24), Border = Color3.fromRGB(35, 150, 80) },
        ["premium"]   = { Text = Color3.fromRGB(60, 245, 145), Bg = Color3.fromRGB(14, 38, 24), Border = Color3.fromRGB(35, 150, 80) },
        ["booster"]   = { Text = Color3.fromRGB(255, 120, 200), Bg = Color3.fromRGB(42, 16, 32), Border = Color3.fromRGB(160, 45, 120) },
        ["tester"]    = { Text = Color3.fromRGB(255, 230, 80), Bg = Color3.fromRGB(40, 36, 12), Border = Color3.fromRGB(160, 140, 25) },
        ["friend"]    = { Text = Color3.fromRGB(120, 200, 255), Bg = Color3.fromRGB(16, 32, 45), Border = Color3.fromRGB(45, 120, 170) },
        ["partner"]   = { Text = Color3.fromRGB(255, 190, 60), Bg = Color3.fromRGB(42, 30, 10), Border = Color3.fromRGB(170, 120, 20) },
        ["user"]      = { Text = Color3.fromRGB(180, 190, 205), Bg = Color3.fromRGB(20, 22, 28), Border = Color3.fromRGB(52, 58, 72) },
    }
}

function CrypticalAPI:GetTagStyle(rawTag)
    local t = string.lower(rawTag or "user"):gsub("%s+", "")
    return self.TagColors[t] or self.TagColors["user"]
end

function CrypticalAPI:GetTags(username)
    if not username then return {"user"} end
    local u = string.lower(tostring(username)):gsub("%s+", "")
    local data = self.Users[u]
    if data and data.Tags and #data.Tags > 0 then
        return data.Tags
    end
    return {"user"}
end

function CrypticalAPI:IsRegistered(username)
    if not username then return false end
    local u = string.lower(tostring(username)):gsub("%s+", "")
    return self.Users[u] ~= nil
end

function CrypticalAPI:AutoRegister()
end

function CrypticalAPI:Fetch()
    self.Users = {}
    self.Loaded = true
end

CrypticalAPI:AutoRegister()
CrypticalAPI:Fetch()
task.spawn(function()
    while not unloaded and getgenv().CrypticalGen == GEN do
        task.wait(45)
        CrypticalAPI:Fetch()
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
            if child.Name == "Cryptical_TitleGroup" or child.Name == "Cryptical_Logo" then
                child:Destroy()
            end
        end

        local titleGroup = Instance.new("Frame")
        titleGroup.Name = "Cryptical_TitleGroup"
        titleGroup.Parent = titleArea
        Window.Items["MainFrame"]:MakeDraggable(titleGroup)
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
        brandLabel.Text = "cryptical"
        brandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        brandLabel.TextSize = 17
        brandLabel.Size = UDim2.new(0, 0, 1, 0)
        brandLabel.AutomaticSize = Enum.AutomaticSize.X
        brandLabel.LayoutOrder = 1

        local brandGradient = Instance.new("UIGradient")
        brandGradient.Parent = brandLabel
        brandGradient.Rotation = 0

        task.spawn(function()
        while not unloaded and getgenv().CrypticalGen == GEN do
            local t = tick()
            local accent = Library.Theme.Accent or Color3.fromRGB(139, 149, 246)
            local white = Color3.fromRGB(255, 255, 255)
            local wavePos = (math.sin(t * 2.2) + 1) * 0.5
            brandGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, accent),
                ColorSequenceKeypoint.new(math.clamp(wavePos * 0.6 + 0.2, 0.01, 0.99), white),
                ColorSequenceKeypoint.new(1, accent)
            })
            task.wait(0.06)
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
        Name = "Identity",
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

        local myTags = CrypticalAPI:GetTags(userName)
        for _, rawTag in ipairs(myTags) do
            local tagStyle = CrypticalAPI:GetTagStyle(rawTag)
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
        while not unloaded and getgenv().CrypticalGen == GEN do
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
    local fpsStat = makeHomeStat("Client FPS", "60 FPS", 4)
    local pingStat = makeHomeStat("Server Ping", tostring(getPing()) .. " ms", 5)
    local tierStat = makeHomeStat("User Tier", string.upper(CrypticalAPI:GetTags(userName)[1] or "USER"), 6)

    task.spawn(function()
        while not unloaded and getgenv().CrypticalGen == GEN do
            task.wait(0.5)
            if fpsStat and fpsStat.Label then
                pcall(function()
                    fpsStat.Label.Text = tostring(fps or 60) .. " FPS"
                end)
            end
        end
    end)

    ProfileSection:Label("Build: CRYPTICAL v2.4 (Enterprise)")
    ProfileSection:Label("Status: Active • Premium")

    local ActionSection = HomePage:Section({
        Name = "Actions",
        Icon = ICON_BOT,
        Side = 1,
    })

    ActionSection:Button({
        Name = "Copy Discord Invite",
        Callback = function()
            if setclipboard then
                setclipboard("https://discord.gg/cryptical")
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
        Name = "Server",
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

    
    task.spawn(function()
        while not unloaded and getgenv().CrypticalGen == GEN do
            task.wait(0.5)
            pcall(function()
                accountStat.Text = tostring(accountAge) .. " days"
                userIdStat.Text = tostring(userId)
                tierStat.Text = string.upper(CrypticalAPI:GetTags(userName)[1] or "USER")
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
        Name = "Aimbot",
        Icon = ICON_COMBAT,
        Side = 1,
    })
    registerCombatSubtab("Aimbot", AimbotMainSection)

    local aimbotToggleKeybindObj = nil
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
    aimbotToggleKeybindObj = aimbotToggle:Keybind({
        Mode = "Hold",
        Default = Enum.KeyCode.E,
    })

    aimbotGroundDropdown = AimbotMainSection:Dropdown({
        Name = "Hitpart (Ground)",
        Flag = "Combat_HitpartGround",
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Closest", "Random"},
        Default = "Head",
    })

    aimbotAirDropdown = AimbotMainSection:Dropdown({
        Name = "Hitpart (Air)",
        Flag = "Combat_HitpartAir",
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Closest", "Random"},
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
        Items = {"Team Check", "Wall Check", "Dead Check", "Knocked Check", "ForceField Check", "Ignore Cryptical Users"},
        Default = {"Team Check", "Wall Check", "Dead Check"},
    })

    local HumanizationSection = CombatPage:Section({
        Name = "Humanizer",
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
        Name = "Pull Resistance",
        Flag = "Combat_PullResToggle",
        Default = false,
        Callback = function(val)
            if pullResXSlider then pullResXSlider:SetVisibility(val) end
            if pullResYSlider then pullResYSlider:SetVisibility(val) end
        end,
    })

    pullResXSlider = HumanizationSection:Slider({
        Name = "Pull Resistance X",
        Flag = "Combat_PullResX",
        Default = 10,
        Min = 1,
        Max = 100,
    })

    pullResYSlider = HumanizationSection:Slider({
        Name = "Pull Resistance Y",
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

    local drawFovToggle, fovSizeSlider, fovOutlineAlphaSlider, fovFillAlphaSlider, fovSidesSlider, fovSpinToggle, fovSpinSpeedSlider, fovRainbowToggle, fovPulseToggle, fovDynamicToggle, fovThicknessSlider, fovPlacementDropdown

    local useFovToggle = AimbotFOVSection:Toggle({
        Name = "Use FOV Limit",
        Flag = "Combat_UseFOV",
        Default = false,
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

    fovPulseToggle = AimbotFOVSection:Toggle({
        Name = "Pulsing FOV Effect",
        Flag = "Combat_FOVPulse",
        Default = false,
    })

    fovRainbowToggle = AimbotFOVSection:Toggle({
        Name = "Rainbow FOV Color",
        Flag = "Combat_FOVRainbow",
        Default = false,
    })

    fovDynamicToggle = AimbotFOVSection:Toggle({
        Name = "Dynamic Camera FOV Scaling",
        Flag = "Combat_FOVDynamic",
        Default = false,
    })

    fovThicknessSlider = AimbotFOVSection:Slider({
        Name = "FOV Stroke Thickness",
        Flag = "Combat_FOVThickness",
        Default = 2,
        Min = 1,
        Max = 10,
        Suffix = " px",
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
        local fovLimitActive = Library.Flags["Combat_UseFOV"] == true
        if drawFovToggle then drawFovToggle:SetVisibility(fovLimitActive) end
        if fovSizeSlider then fovSizeSlider:SetVisibility(fovLimitActive) end
        if fovOutlineAlphaSlider then fovOutlineAlphaSlider:SetVisibility(fovLimitActive) end
        if fovFillAlphaSlider then fovFillAlphaSlider:SetVisibility(fovLimitActive) end
        if fovSidesSlider then fovSidesSlider:SetVisibility(fovLimitActive) end
        if fovSpinToggle then fovSpinToggle:SetVisibility(fovLimitActive) end
        if fovSpinSpeedSlider then fovSpinSpeedSlider:SetVisibility(fovLimitActive and Library.Flags["Combat_FOVSpin"] == true) end
        if fovRainbowToggle then fovRainbowToggle:SetVisibility(fovLimitActive) end
        if fovPulseToggle then fovPulseToggle:SetVisibility(fovLimitActive) end
        if fovDynamicToggle then fovDynamicToggle:SetVisibility(fovLimitActive) end
        if fovThicknessSlider then fovThicknessSlider:SetVisibility(fovLimitActive) end
        if fovPlacementDropdown then fovPlacementDropdown:SetVisibility(fovLimitActive) end
    end)

    local SilentAimMainSection = CombatPage:Section({
        Name = "Silent Aim",
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
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Closest", "Random"},
        Default = "Head",
    })

    sAirDrop = SilentAimMainSection:Dropdown({
        Name = "Hitpart (Air)",
        Flag = "SilentAim_HitpartAir",
        Items = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Closest", "Random"},
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
        Items = {"Team Check", "Wall Check", "Ignore Cryptical Users"},
        Default = {"Team Check", "Wall Check"},
    })

    local SilentAimFOVSection = CombatPage:Section({
        Name = "Silent Aim FOV",
        Icon = ICON_SCANEYE,
        Side = 2,
    })
    registerCombatSubtab("Silent Aim", SilentAimFOVSection)

    local sDrawFov, sFovSize, sOutlineAlpha, sFillAlpha, sFovSides, sFovSpin, sSpinSpeed, sRainbowToggle, sPulseToggle, sDynamicToggle, sThicknessSlider, sFovPlacement

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
            if sRainbowToggle then sRainbowToggle:SetVisibility(val) end
            if sPulseToggle then sPulseToggle:SetVisibility(val) end
            if sDynamicToggle then sDynamicToggle:SetVisibility(val) end
            if sThicknessSlider then sThicknessSlider:SetVisibility(val) end
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

    sRainbowToggle = SilentAimFOVSection:Toggle({
        Name = "Rainbow FOV Color",
        Flag = "SilentAim_FOVRainbow",
        Default = false,
    })

    sPulseToggle = SilentAimFOVSection:Toggle({
        Name = "Pulsing FOV Effect",
        Flag = "SilentAim_FOVPulse",
        Default = false,
    })

    sDynamicToggle = SilentAimFOVSection:Toggle({
        Name = "Dynamic Camera FOV Scaling",
        Flag = "SilentAim_FOVDynamic",
        Default = false,
    })

    sThicknessSlider = SilentAimFOVSection:Slider({
        Name = "FOV Stroke Thickness",
        Flag = "SilentAim_FOVThickness",
        Default = 2,
        Min = 1,
        Max = 10,
        Suffix = " px",
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
        Items = {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "All"},
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


    local fovGui = Instance.new("ScreenGui")
    fovGui.Name = "Cryptical_FOVOverlays"
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
        
        local allParts = {
            "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", 
            "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", 
            "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
            "LeftFoot", "RightFoot", "Torso"
        }
        
        if hitpartName == "Random" then
            local valid = {}
            for _, pName in ipairs(allParts) do
                local p = char:FindFirstChild(pName)
                if p and p:IsA("BasePart") then table.insert(valid, p) end
            end
            return (#valid > 0) and valid[math.random(1, #valid)] or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        end
        
        if hitpartName == "Closest" then
            local cam = Workspace.CurrentCamera
            if not cam then return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") end
            
            local closestPart = nil
            local closestDist = math.huge
            local screenCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            
            for _, pName in ipairs(allParts) do
                local p = char:FindFirstChild(pName)
                if p and p:IsA("BasePart") then
                    local pos2d, onScreen = cam:WorldToViewportPoint(p.Position)
                    if onScreen and pos2d.Z > 0 then
                        local dist = (Vector2.new(pos2d.X, pos2d.Y) - screenCenter).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestPart = p
                        end
                    end
                end
            end
            return closestPart or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        end
        
        local direct = char:FindFirstChild(hitpartName)
        if direct then return direct end
        
        local fallbackMap = {
            ["LeftHand"] = {"LeftHand", "Left Arm"},
            ["RightHand"] = {"RightHand", "Right Arm"},
            ["LeftArm"] = {"LeftUpperArm", "LeftLowerArm", "Left Arm"},
            ["RightArm"] = {"RightUpperArm", "RightLowerArm", "Right Arm"},
            ["LeftLeg"] = {"LeftUpperLeg", "LeftLowerLeg", "Left Leg"},
            ["RightLeg"] = {"RightUpperLeg", "RightLowerLeg", "Right Leg"},
        }
        
        if fallbackMap[hitpartName] then
            for _, fallback in ipairs(fallbackMap[hitpartName]) do
                local p = char:FindFirstChild(fallback)
                if p then return p end
            end
        end
        
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
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

        if hasCheck("Ignore Cryptical Users") or hasCheck("Ignore Users - Cryptical Users") then
            if p:GetAttribute("CrypticalUser") or p:FindFirstChild("CrypticalUser") then
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

    local function getAllTargetCandidates()
        local candidates = {}
        local added = {}

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer then
                table.insert(candidates, p)
                if p.Character then added[p.Character] = true end
            end
        end

        local searchFolders = {"Players", "players", "Bots", "NPCs", "Enemies"}
        for _, folderName in ipairs(searchFolders) do
            local folder = Workspace:FindFirstChild(folderName)
            if folder then
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("Model") and not added[child] and child ~= Players.LocalPlayer.Character then
                        local hum = child:FindFirstChildOfClass("Humanoid")
                        local root = child:FindFirstChild("HumanoidRootPart") or child:FindFirstChild("Torso") or child.PrimaryPart
                        if hum and root then
                            table.insert(candidates, {
                                Name = child.Name,
                                DisplayName = child.Name,
                                UserId = 1,
                                Character = child,
                                IsBot = true,
                                Team = nil
                            })
                            added[child] = true
                        end
                    end
                end
            end
        end

        return candidates
    end

    local function getBestAimbotTarget()
        local cam = Workspace.CurrentCamera
        if not cam then return nil, nil end

        local fovOrigin = getFOVOrigin(Library.Flags["Combat_FOVPlacement"] or "Middle")
        local fovRadius = Library.Flags["Combat_FOVRadius"] or 140
        local useFOV = Library.Flags["Combat_UseFOV"] ~= false
        local checks = Library.Flags["Combat_Checks"] or {"Team Check", "Wall Check", "Dead Check"}

        if Library.Flags["Combat_StickyAim"] and combatState.TargetLocked and combatState.TargetLocked.Parent then
            local char = combatState.TargetLocked
            local p = Players:GetPlayerFromCharacter(char) or { Name = char.Name, DisplayName = char.Name, UserId = 1, Character = char }
            if validateTarget(p, checks) then
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

        for _, p in ipairs(getAllTargetCandidates()) do
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

    
    local function getBestSilentTarget()
        local cam = Workspace.CurrentCamera
        if not cam then return nil, nil end

        local fovOrigin = getFOVOrigin(Library.Flags["SilentAim_FOVPlacement"] or "Middle")
        local fovRadius = Library.Flags["SilentAim_FOVSize"] or 180
        local useFOV = Library.Flags["SilentAim_UseFOV"] ~= false
        local checks = Library.Flags["SilentAim_Checks"] or {"Team Check", "Dead Check"}
        local hitChance = Library.Flags["SilentAim_HitChance"] or 100

        if math.random(1, 100) > hitChance then
            return nil, nil
        end

        local closestDist = math.huge
        local bestPlayer = nil
        local bestPart = nil

        for _, p in ipairs(getAllTargetCandidates()) do
            if validateTarget(p, checks) then
                local char = p.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local isAir = hum and (hum.FloorMaterial == Enum.Material.Air or (char.PrimaryPart and math.abs(char.PrimaryPart.Velocity.Y) > 2))
                local hitPartName = isAir and (Library.Flags["SilentAim_HitpartAir"] or "HumanoidRootPart") or (Library.Flags["SilentAim_HitpartGround"] or "Head")
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

    local function getSilentAimPosition()
        if not Library.Flags["SilentAim_Enable"] then return nil end
        local p, part = getBestSilentTarget()
        if not p or not part then return nil end

        combatState.SilentTarget = p
        combatState.SilentLocked = part

        local pos = part.Position
        local vel = part.AssemblyLinearVelocity or part.Velocity or Vector3.zero
        if Library.Flags["SilentAim_UsePrediction"] then
            local predScale = (Library.Flags["SilentAim_PredictionSlider"] or 12.0) / 100
            pos = pos + (vel * predScale)
        end
        return pos, part
    end

    pcall(function()
        if hookmetamethod then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}

                if not unloaded and Library.Flags["SilentAim_Enable"] and (method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithWhitelist" or method == "FindPartOnRayWithIgnoreList") then
                    local silentPos, silentPart = getSilentAimPosition()
                    if silentPos and silentPart then
                        if method == "Raycast" and args[1] and typeof(args[1]) == "Vector3" then
                            local origin = args[1]
                            local dir = (silentPos - origin).Unit * 1000
                            args[2] = dir
                            return oldNamecall(self, table.unpack(args))
                        end
                    end
                end

                return oldNamecall(self, ...)
            end)
        end
    end)

    Library:Connect(RunService.RenderStepped, function(dt)
        if unloaded or getgenv().CrypticalGen ~= GEN then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end

        local t = tick()
        local aimDraw = Library.Flags["Combat_DrawFOV"] == true
        if aimDraw then
            local placement = Library.Flags["Combat_FOVPlacement"] or "Middle"
            local fovOrigin = getFOVOrigin(placement)
            local fovRadius = Library.Flags["Combat_FOVRadius"] or 140
            
            if Library.Flags["Combat_FOVDynamic"] and cam then
                local baseFov = 70
                fovRadius = fovRadius * (baseFov / math.max(cam.FieldOfView, 1))
            end
            if Library.Flags["Combat_FOVPulse"] then
                local pulseScale = 1 + (math.sin(t * 5) * 0.15)
                fovRadius = fovRadius * pulseScale
            end

            local outlineAlpha = (Library.Flags["Combat_FOVOutlineAlpha"] or 0) / 100
            local fillAlpha = (Library.Flags["Combat_FOVFillAlpha"] or 85) / 100
            local fovColor = Library.Flags["Combat_FOVColor"] or (Theme.Accent or Color3.fromRGB(139, 149, 246))
            local fovFillColor = Library.Flags["Combat_FOVFillColor"] or fovColor

            if Library.Flags["Combat_FOVRainbow"] then
                local hue = (t * 0.4) % 1
                fovColor = Color3.fromHSV(hue, 0.85, 1)
                fovFillColor = fovColor
            end

            fovCircleFrame.Visible = true
            fovCircleFrame.Position = UDim2.fromOffset(fovOrigin.X, fovOrigin.Y)
            fovCircleFrame.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
            fovCircleFrame.BackgroundColor3 = fovFillColor
            fovCircleFrame.BackgroundTransparency = fillAlpha
            fovStroke.Color = fovColor
            fovStroke.Transparency = outlineAlpha
            fovStroke.Thickness = Library.Flags["Combat_FOVThickness"] or 2

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

            if Library.Flags["SilentAim_FOVDynamic"] and cam then
                local baseFov = 70
                fovRadius = fovRadius * (baseFov / math.max(cam.FieldOfView, 1))
            end
            if Library.Flags["SilentAim_FOVPulse"] then
                local pulseScale = 1 + (math.sin(t * 5) * 0.15)
                fovRadius = fovRadius * pulseScale
            end

            local outlineAlpha = (Library.Flags["SilentAim_FOVOutlineAlpha"] or 0) / 100
            local fillAlpha = (Library.Flags["SilentAim_FOVFillAlpha"] or 90) / 100
            local fovColor = Library.Flags["SilentAim_FOVColor"] or Color3.fromRGB(255, 75, 95)
            local fovFillColor = Library.Flags["SilentAim_FOVFillColor"] or fovColor

            if Library.Flags["SilentAim_FOVRainbow"] then
                local hue = (t * 0.4 + 0.5) % 1
                fovColor = Color3.fromHSV(hue, 0.85, 1)
                fovFillColor = fovColor
            end

            sFovCircleFrame.Visible = true
            sFovCircleFrame.Position = UDim2.fromOffset(fovOrigin.X, fovOrigin.Y)
            sFovCircleFrame.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
            sFovCircleFrame.BackgroundColor3 = fovFillColor
            sFovCircleFrame.BackgroundTransparency = fillAlpha
            sFovStroke.Color = fovColor
            sFovStroke.Transparency = outlineAlpha
            sFovStroke.Thickness = Library.Flags["SilentAim_FOVThickness"] or 2

            if Library.Flags["SilentAim_FOVSpin"] then
                local speed = Library.Flags["SilentAim_FOVSpinSpeed"] or Library.Flags["SilentAim_SpinSpeed"] or 5
                combatState.SilentFOVRotationAngle = ((combatState.SilentFOVRotationAngle or 0) + (speed * 40 * dt)) % 360
                sFovCircleFrame.Rotation = combatState.SilentFOVRotationAngle
            else
                sFovCircleFrame.Rotation = 0
            end
        else
            sFovCircleFrame.Visible = false
        end

        if Library.Flags["SilentAim_Enable"] then
            local sPlayer, sPart = getBestSilentTarget()
            combatState.SilentTarget = sPlayer
            combatState.SilentLocked = sPart
        else
            combatState.SilentTarget = nil
            combatState.SilentLocked = nil
        end

        local aimbotMaster = Library.Flags["Combat_Aimbot"] == true
        local aimbindState = aimbotToggleKeybindObj and aimbotToggleKeybindObj.Toggled
        local aimbotActive = aimbotMaster and (aimbindState == nil or aimbindState == true)

        if aimbotActive then
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
                    local mouseDelta = UserInputService:GetMouseDelta()
                    local rx = (Library.Flags["Combat_PullResX"] or 10) / 100
                    local ry = (Library.Flags["Combat_PullResY"] or 10) / 100
                    
                    local userInfluenceX = mouseDelta.X * rx
                    local userInfluenceY = mouseDelta.Y * ry
                    
                    targetPos = targetPos + Vector3.new(userInfluenceX * 0.1, userInfluenceY * 0.1, 0)
                end

                local camPos = cam.CFrame.Position
                local targetCF = CFrame.new(camPos, targetPos)

                if Library.Flags["Combat_UseSmoothing"] then
                    local smoothVal = math.clamp(Library.Flags["Combat_SmoothingValue"] or 5, 1, 100)
                    local alpha = 1 - math.exp(- (105 - smoothVal) * 0.28 * dt)
                    alpha = math.clamp(alpha, 0.005, 1.0)

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
        while not unloaded and getgenv().CrypticalGen == GEN do
            if not Library.Flags["Triggerbot_Enable"] then
                task.wait(0.1)
            else
                task.wait(0.03)
                local cam = Workspace.CurrentCamera
                if cam then
                    local mousePos = UserInputService:GetMouseLocation()
                    local unitRay = cam:ViewportPointToRay(mousePos.X, mousePos.Y)
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {Players.LocalPlayer.Character}
                    rayParams.IgnoreWater = true

                    local result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, rayParams)
                    if result and result.Instance then
                        local hitChar = result.Instance:FindFirstAncestorOfClass("Model")
                        local hitPlayer = hitChar and Players:GetPlayerFromCharacter(hitChar)
                        if hitPlayer and hitPlayer ~= Players.LocalPlayer then
                            local hum = hitChar:FindFirstChildOfClass("Humanoid")
                            local isAlive = hum and hum.Health > 0
                            local teamPass = true
                            if Library.Flags["Triggerbot_TeamCheck"] and hitPlayer.Team and Players.LocalPlayer.Team and hitPlayer.Team == Players.LocalPlayer.Team then
                                teamPass = false
                            end

                            if isAlive and teamPass then
                                local now = tick()
                                local delaySec = (Library.Flags["Triggerbot_Delay"] or 0) / 1000
                                local cooldownSec = (Library.Flags["Triggerbot_Cooldown"] or 150) / 1000
                                if (now - combatState.LastTriggerShot) >= (delaySec + cooldownSec) then
                                    combatState.LastTriggerShot = now
                                    pcall(function()
                                        if mouse1click then
                                            mouse1click()
                                        elseif mouse1press then
                                            mouse1press()
                                            task.wait(0.015)
                                            mouse1release()
                                        end
                                    end)
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
        AutoRotatePreview = true,
        PreviewSpeed = 1.0,
        PreviewZoom = 9.2,
        ShowNPCs = true,

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
        TracerThickness = 1,

        Offscreen = false,
        OffscreenColor = Theme.Accent or Color3.fromRGB(139, 149, 246),
        OffscreenRadius = 220,
        OffscreenSize = 14,

        Chams = false,
        ChamsColor = Theme.Accent or Color3.fromRGB(139, 149, 246),
        ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
        ChamsMaterial = "Highlight",
        ChamsFillTransparency = 0.4,
        ChamsOutlineTransparency = 0.1,
        ChamsThroughWalls = true,
        ChamsPulse = false,

        LookVector = false,
        LookVectorColor = Color3.fromRGB(255, 255, 255),
        LookVectorLength = 10,

        RainbowESP = false,
        TextOutline = true,
        TeamCheck = true,
        UseTeamColors = false,
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
        Name = "Show NPCs/Bots in ESP",
        Flag = "Visuals_ShowNPCs",
        Default = true,
        Callback = function(val)
            espConfig.ShowNPCs = val
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

    local lookVectorToggle = PlayerESPSection:Toggle({
        Name = "Head Look Vector ESP",
        Flag = "Visuals_LookVectorESP",
        Default = false,
        Callback = function(val)
            espConfig.LookVector = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })
    lookVectorToggle:Colorpicker({
        Flag = "Visuals_LookVectorColor",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(val)
            espConfig.LookVectorColor = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    PlayerESPSection:Toggle({
        Name = "Rainbow ESP Mode",
        Flag = "Visuals_RainbowESP",
        Default = false,
        Callback = function(val)
            espConfig.RainbowESP = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    PlayerESPSection:Toggle({
        Name = "Use Team Colors for ESP",
        Flag = "Visuals_UseTeamColors",
        Default = false,
        Callback = function(val)
            espConfig.UseTeamColors = val
            if updatePreviewOverlay then updatePreviewOverlay() end
        end,
    })

    PlayerESPSection:Slider({
        Name = "Max Render Distance",
        Flag = "Visuals_MaxDistance",
        Default = 2500,
        Min = 100,
        Max = 5000,
        Suffix = " studs",
        Callback = function(val)
            espConfig.MaxDistance = val
        end,
    })

    local ChamsSection = VisualsPage:Section({
        Name = "Chams",
        Icon = ICON_SHIELD,
        Side = 2,
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
        Name = "ESP Preview",
        Icon = ICON_SCANEYE,
        Side = 2,
    })
    registerVisualsSubtab("Player ESP", PreviewSection)
    PreviewSection.Items["SectionOutline"].Instance.LayoutOrder = -10

    local previewWindow = Instance.new("Frame")
    previewWindow.Name = "Cryptical_DockedESPPreview"
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

            local cf, size = previewCharModel:GetBoundingBox()
            local half = size * 0.5
            local corners3D = {
                cf * Vector3.new(-half.X,  half.Y, -half.Z),
                cf * Vector3.new( half.X,  half.Y, -half.Z),
                cf * Vector3.new(-half.X, -half.Y, -half.Z),
                cf * Vector3.new( half.X, -half.Y, -half.Z),
                cf * Vector3.new(-half.X,  half.Y,  half.Z),
                cf * Vector3.new( half.X,  half.Y,  half.Z),
                cf * Vector3.new(-half.X, -half.Y,  half.Z),
                cf * Vector3.new( half.X, -half.Y,  half.Z),
            }

            local minX, maxX = math.huge, -math.huge
            local minY, maxY = math.huge, -math.huge
            local validCount = 0

            for _, c3 in ipairs(corners3D) do
                local pos2D, vis = projectToPreview(c3)
                if pos2D and vis then
                    minX = math.min(minX, pos2D.X)
                    maxX = math.max(maxX, pos2D.X)
                    minY = math.min(minY, pos2D.Y)
                    maxY = math.max(maxY, pos2D.Y)
                    validCount += 1
                end
            end

            if validCount >= 4 and maxX > minX and maxY > minY then
                local boxW = math.clamp(maxX - minX, 16, 180)
                local boxH = math.clamp(maxY - minY, 24, 240)
                local boxX = minX + (maxX - minX) * 0.5
                local boxY = minY

                previewBoxFrame.Position = UDim2.new(0, boxX, 0, boxY)
                previewBoxFrame.Size = UDim2.new(0, boxW, 0, boxH)

                local cardSize = previewCard.AbsoluteSize
                local cw = cardSize.X > 10 and cardSize.X or 214
                local ch = cardSize.Y > 10 and cardSize.Y or 258

                local originY = ch
                if espConfig.TracerOrigin == "Top" then
                    originY = 0
                elseif espConfig.TracerOrigin == "Center" then
                    originY = ch * 0.5
                end

                local tracerOrigin = Vector2.new(cw * 0.5, originY)
                local tracerTarget = Vector2.new(boxX, boxY + boxH)
                local dir = tracerTarget - tracerOrigin
                local dist = dir.Magnitude
                local angle = math.deg(math.atan2(dir.Y, dir.X)) - 90

                previewTracer.Position = UDim2.fromOffset(tracerOrigin.X, tracerOrigin.Y)
                previewTracer.Size = UDim2.new(0, espConfig.TracerThickness or 1.5, 0, dist)
                previewTracer.AnchorPoint = Vector2.new(0.5, 0)
                previewTracer.Rotation = angle
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
        if unloaded or getgenv().CrypticalGen ~= GEN then
            if previewRenderConn then
                previewRenderConn:Disconnect()
                previewRenderConn = nil
            end
            return
        end

        if not espConfig.ShowPreview or not previewWindow or not previewWindow.Visible then
            return
        end

        if syncPreviewPosition then
            syncPreviewPosition()
        end

        if espConfig.AutoRotatePreview and previewCharModel and previewCharModel.PrimaryPart then
            previewRotAngle = (previewRotAngle + (dt * 45 * (espConfig.PreviewSpeed or 1.0))) % 360
            local root = previewCharModel:FindFirstChild("HumanoidRootPart") or previewCharModel.PrimaryPart
            if root then
                local center = root.Position
                local rad = math.rad(previewRotAngle)
                local zoom = espConfig.PreviewZoom or 9.2
                local camPos = center + Vector3.new(math.sin(rad) * zoom, 0.4, math.cos(rad) * zoom)
                viewportCamera.CFrame = CFrame.lookAt(camPos, center + Vector3.new(0, -0.2, 0))
                if updatePreviewOverlay then
                    updatePreviewOverlay()
                end
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
        Default = true,
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
        Piss={Up="rbxassetid://2651437350",Rt="rbxassetid://2651436979",Lf="rbxassetid://2651436494",Ft="rbxassetid://2651435990",Bk="rbxassetid://2651432901",Dn="rbxassetid://2651434974"},
        Space={Up="rbxassetid://15983964246",Rt="rbxassetid://15983966246",Lf="rbxassetid://15983967420",Ft="rbxassetid://15983965025",Bk="rbxassetid://15983968922",Dn="rbxassetid://15983966825"},
        Dark={Up="rbxassetid://15470160563",Rt="rbxassetid://15470158022",Lf="rbxassetid://15470155938",Ft="rbxassetid://15470153860",Bk="rbxassetid://15470149279",Dn="rbxassetid://15470151245"},
        ["Space V2"]={Up="rbxassetid://16262366016",Rt="rbxassetid://16262363873",Lf="rbxassetid://16262362003",Ft="rbxassetid://16262360469",Bk="rbxassetid://16262356578",Dn="rbxassetid://16262358026"},
        Pink={Up="rbxassetid://12635316856",Rt="rbxassetid://12635315817",Lf="rbxassetid://12635313718",Ft="rbxassetid://12635312870",Bk="rbxassetid://12635309703",Dn="rbxassetid://12635311686"},
        Forest={Up="rbxassetid://237593929",Rt="rbxassetid://237593835",Lf="rbxassetid://237593861",Ft="rbxassetid://237593922",Bk="rbxassetid://237593887",Dn="rbxassetid://237593849"},
        Night={Up="rbxassetid://154185031",Rt="rbxassetid://154184972",Lf="rbxassetid://154184943",Ft="rbxassetid://154185021",Bk="rbxassetid://154185004",Dn="rbxassetid://154184960"},
        Lava={Up="rbxassetid://4776130793",Rt="rbxassetid://4776133150",Lf="rbxassetid://4776128425",Ft="rbxassetid://4776131365",Bk="rbxassetid://4776124334",Dn="rbxassetid://4776125375"},
        Rainy={Up="rbxassetid://4495867486",Rt="rbxassetid://4495866584",Lf="rbxassetid://4495866035",Ft="rbxassetid://4495865458",Bk="rbxassetid://4495864450",Dn="rbxassetid://4495864887"},
        Green={Up="rbxassetid://566611218",Rt="rbxassetid://566611300",Lf="rbxassetid://566611266",Ft="rbxassetid://566611142",Bk="rbxassetid://566611187",Dn="rbxassetid://566613198"},
        Nebulous={Up="rbxassetid://131036626982613",Rt="rbxassetid://103716549795832",Lf="rbxassetid://126542804346203",Ft="rbxassetid://107665368823185",Bk="rbxassetid://95020137072033",Dn="rbxassetid://92862258103959"},
        ["Blue Clouds"]={Lf="rbxassetid://113877479719528",Dn="rbxassetid://79704090322682",Up="rbxassetid://83295215834464",Bk="rbxassetid://130432680623409",Rt="rbxassetid://84246762168898",Ft="rbxassetid://114966033937119"},
        ["Candy Floss"]={Bk="rbxassetid://103994796436499",Dn="rbxassetid://88135141884296",Ft="rbxassetid://71705651078185",Lf="rbxassetid://83560072752341",Rt="rbxassetid://96879039628172",Up="rbxassetid://131043401069407"},
        ["Green Skies"]={Up="rbxassetid://11941773718",Rt="rbxassetid://11941774042",Lf="rbxassetid://11941774369",Ft="rbxassetid://11941774655",Dn="rbxassetid://11941774975",Bk="rbxassetid://11941775243"},
        ["White Skies"]={Up="rbxassetid://14638329084",Rt="rbxassetid://14627242578",Lf="rbxassetid://14627253604",Ft="rbxassetid://14627298624",Dn="rbxassetid://14638334572",Bk="rbxassetid://14627238543"},
        ["Blood Red"]={Bk="rbxassetid://108929045660200",Dn="rbxassetid://78646480540009",Ft="rbxassetid://90546017435179",Lf="rbxassetid://109838453114563",Rt="rbxassetid://94190734796082",Up="rbxassetid://126944775797063"},
        ["Scary"]={Up="rbxassetid://48020383",Rt="rbxassetid://48020254",Lf="rbxassetid://48020211",Ft="rbxassetid://48020234",Bk="rbxassetid://48020371",Dn="rbxassetid://48020144"},
        ["Realistic Day"]={Up="rbxassetid://15502526102",Rt="rbxassetid://15502523711",Lf="rbxassetid://15502522129",Ft="rbxassetid://15502524520",Bk="rbxassetid://15502525195",Dn="rbxassetid://15502522797"},
        ["Realistic Space"]={Up="rbxassetid://155441905",Rt="rbxassetid://155441874",Lf="rbxassetid://155441777",Ft="rbxassetid://155441818",Bk="rbxassetid://155441936",Dn="rbxassetid://155441802"},
        ["Classic"]={Up="rbxassetid://16960183792",Rt="rbxassetid://16960180775",Lf="rbxassetid://16960173960",Ft="rbxassetid://16960177173",Bk="rbxassetid://16960168607",Dn="rbxassetid://16960171251"},
        ["Sunset"]={Up="rbxassetid://541743441",Rt="rbxassetid://541743435",Lf="rbxassetid://541743436",Ft="rbxassetid://541743446",Bk="rbxassetid://541743453",Dn="rbxassetid://541743443"},
        ["HD Space"]={Up="rbxassetid://16876771721",Rt="rbxassetid://16876769447",Lf="rbxassetid://16876767659",Ft="rbxassetid://16876765234",Bk="rbxassetid://16876760844",Dn="rbxassetid://16876762818"},
        ["Cold Winter"]={Up="rbxassetid://5346761509",Rt="rbxassetid://5346761335",Lf="rbxassetid://5346761102",Ft="rbxassetid://5346760919",Bk="rbxassetid://5346760450",Dn="rbxassetid://5346760689"},
        ["Shiverfrost"]={Up="rbxassetid://11941773718",Rt="rbxassetid://11941774042",Lf="rbxassetid://11941774369",Ft="rbxassetid://11941774655",Bk="rbxassetid://11941775243",Dn="rbxassetid://11941774975"},
        ["Blue Nebula"]={Up="rbxassetid://88174897344210",Rt="rbxassetid://81731245279712",Lf="rbxassetid://72493016739936",Ft="rbxassetid://92947876187368",Bk="rbxassetid://135908594667929",Dn="rbxassetid://139584143501514"},
        ["Red Space"]={Up="rbxassetid://16563527042",Rt="rbxassetid://16563525361",Lf="rbxassetid://16563524305",Ft="rbxassetid://16563522248",Bk="rbxassetid://16563515269",Dn="rbxassetid://16563519063"},
        ["Green Clouds"]={Up="rbxassetid://921882259",Rt="rbxassetid://921881989",Lf="rbxassetid://921881811",Ft="rbxassetid://921882121",Bk="rbxassetid://921882045",Dn="rbxassetid://921881907"},
        ["Purple Clouds"]={Up="rbxassetid://17279864507",Rt="rbxassetid://17279862234",Lf="rbxassetid://17279860360",Ft="rbxassetid://17279858447",Bk="rbxassetid://17279854976",Dn="rbxassetid://17279856318"},
        ["Nibiru"]={Up="rbxassetid://16888795319",Rt="rbxassetid://16888793222",Lf="rbxassetid://16888791272",Ft="rbxassetid://16888789063",Bk="rbxassetid://16888782970",Dn="rbxassetid://16888785001"},
        ["Nebulae"]={Up="rbxassetid://15410066351",Rt="rbxassetid://15410065410",Lf="rbxassetid://15410064356",Ft="rbxassetid://15410062941",Bk="rbxassetid://15410060765",Dn="rbxassetid://15410061776"},
        ["Moody"]={Up="rbxassetid://16094726650",Rt="rbxassetid://16094722121",Lf="rbxassetid://16094718550",Ft="rbxassetid://16094725387",Bk="rbxassetid://16094723769",Dn="rbxassetid://16094720620"},
        ["Whistle"]={Up="rbxassetid://119554574473335",Rt="rbxassetid://73230217205735",Lf="rbxassetid://106597220421789",Ft="rbxassetid://134876166747769",Bk="rbxassetid://111497829836471",Dn="rbxassetid://85772401772303"},
        ["Crossroads"]={Up="http://www.roblox.com/asset/?id=144931564",Rt="http://www.roblox.com/asset/?id=144933299",Lf="http://www.roblox.com/asset/?id=144933244",Ft="http://www.roblox.com/asset/?id=144933262",Bk="http://www.roblox.com/asset/?id=144933338",Dn="http://www.roblox.com/asset/?id=144931530"},
        ["Abyss Blue"]={Up="rbxassetid://16269829700",Rt="rbxassetid://16269814948",Lf="rbxassetid://16269813852",Ft="rbxassetid://16269798011",Bk="rbxassetid://16269815885",Dn="rbxassetid://16269839652",Moon="rbxassetid://sky/moon.jpg"},
        ["Red Castle Dark"]={Up="rbxassetid://15832429401",Rt="rbxassetid://15832431198",Lf="rbxassetid://15832430671",Ft="rbxassetid://15832430210",Bk="rbxassetid://15832429892",Dn="rbxassetid://15832430998"},
        Red1={Up="rbxassetid://126944775797063",Rt="rbxassetid://94190734796082",Lf="rbxassetid://109838453114563",Ft="rbxassetid://90546017435179",Bk="rbxassetid://108929045660200",Dn="rbxassetid://78646480540009"},
        Red2={Up="rbxassetid://1014449",Rt="rbxassetid://1012888",Lf="rbxassetid://1012889",Ft="rbxassetid://1012887",Bk="rbxassetid://1012890",Dn="rbxassetid://1012891"},
        Purple={Up="rbxassetid://16553667750",Rt="rbxassetid://16553665766",Lf="rbxassetid://16553664042",Ft="rbxassetid://16553662144",Bk="rbxassetid://16553658937",Dn="rbxassetid://16553660713"},
        Blue_Nebula={Up="rbxassetid://88174897344210",Rt="rbxassetid://81731245279712",Lf="rbxassetid://72493016739936",Ft="rbxassetid://92947876187368",Bk="rbxassetid://135908594667929",Dn="rbxassetid://139584143501514"},
        Eyes={Up="rbxassetid://6823346883",Rt="rbxassetid://6823346883",Lf="rbxassetid://6823346883",Ft="rbxassetid://6823346883",Bk="rbxassetid://6823346883",Dn="rbxassetid://6823346883"},
        Purple_Green={Up="rbxassetid://678556362",Rt="rbxassetid://678556360",Lf="rbxassetid://678556373",Ft="rbxassetid://678556368",Bk="rbxassetid://678556371",Dn="rbxassetid://678556361"},
        Red3={Up="rbxassetid://80526725",Rt="rbxassetid://80526715",Lf="rbxassetid://80526703",Ft="rbxassetid://80526692",Bk="rbxassetid://80526657",Dn="rbxassetid://80526668"},
        Dark_Forest={Up="rbxassetid://1100975263",Rt="rbxassetid://1100975263",Lf="rbxassetid://1100975263",Ft="rbxassetid://1100975263",Bk="rbxassetid://1100975263",Dn="rbxassetid://1100975263"},
        Red4={Up="rbxassetid://157785145",Rt="rbxassetid://157785104",Lf="rbxassetid://157785128",Ft="rbxassetid://157785081",Bk="rbxassetid://157785163",Dn="rbxassetid://157785059"},
        Fire={Up="rbxassetid://5250886",Rt="rbxassetid://7315949",Lf="rbxassetid://7315949",Ft="rbxassetid://7315949",Bk="rbxassetid://7315949",Dn="rbxassetid://6869705"},
        icemountain={Up="rbxassetid://653026555",Rt="rbxassetid://653024934",Lf="rbxassetid://653025971",Ft="rbxassetid://653026058",Bk="rbxassetid://653026312",Dn="rbxassetid://58992866"},
        nightcity={Up="rbxassetid://8777332629",Rt="rbxassetid://8773001251",Lf="rbxassetid://8773005696",Ft="rbxassetid://8772999470",Bk="rbxassetid://8773003048",Dn="rbxassetid://8773048741"},
        Evangelion={Up="rbxassetid://18705044890",Rt="rbxassetid://18705041280",Lf="rbxassetid://18705037452",Ft="rbxassetid://18705034432",Bk="rbxassetid://18705029692",Dn="rbxassetid://18705031833"},
        galaxy={Up="rbxassetid://10542144815",Rt="rbxassetid://10542160123",Lf="rbxassetid://10542168961",Ft="rbxassetid://10542165376",Bk="rbxassetid://10542151848",Dn="rbxassetid://10542185888"},
        Dark_Sky1={Up="rbxassetid://12439607581",Rt="rbxassetid://12439607950",Lf="rbxassetid://12439608186",Ft="rbxassetid://12439608455",Bk="rbxassetid://12439608844",Dn="rbxassetid://12439608685"},
        foggy_ocean={Up="rbxassetid://14365033585",Rt="rbxassetid://14365031934",Lf="rbxassetid://14365032507",Ft="rbxassetid://14365032240",Bk="rbxassetid://14365032806",Dn="rbxassetid://14365033150"},
        Skybox_34={Up="rbxassetid://171410789",Rt="rbxassetid://171410798",Lf="rbxassetid://171410807",Ft="rbxassetid://171410775",Bk="rbxassetid://171410784",Dn="rbxassetid://171410792"},
        Warped_Void={Up="rbxassetid://121817740729732",Rt="rbxassetid://112228356210291",Lf="rbxassetid://95118757111741",Ft="rbxassetid://137075766318919",Bk="rbxassetid://70654291823771",Dn="rbxassetid://85052177900589"},
        Rain_Sky={Up="rbxassetid://4495867486",Rt="rbxassetid://4495866584",Lf="rbxassetid://4495866035",Ft="rbxassetid://4495865458",Bk="rbxassetid://4495864450",Dn="rbxassetid://4495864887"},
        Snow={Up="rbxassetid://155674931",Rt="rbxassetid://155657619",Lf="rbxassetid://155657671",Ft="rbxassetid://155657609",Bk="rbxassetid://155657655",Dn="rbxassetid://155674246"},
        Asteroid={Up="rbxassetid://198433823",Rt="rbxassetid://198437454",Lf="rbxassetid://198437520",Ft="rbxassetid://198433337",Bk="rbxassetid://198433424",Dn="rbxassetid://198442292"},
        Space3={Up="rbxassetid://15729027326",Rt="rbxassetid://15728919919",Lf="rbxassetid://15728922364",Ft="rbxassetid://15728920952",Bk="rbxassetid://15728920607",Dn="rbxassetid://15728995236"},
        nebula3={Up="rbxassetid://102883325511503",Rt="rbxassetid://79330588619695",Lf="rbxassetid://76599902191457",Ft="rbxassetid://131992003320527",Bk="rbxassetid://86243508936975",Dn="rbxassetid://89903191408472"},
        Oblivion={Up="rbxassetid://1013848",Rt="rbxassetid://1013841",Lf="rbxassetid://1013843",Ft="rbxassetid://1013842",Bk="rbxassetid://1013844",Dn="rbxassetid://1013845"},
        The_Utter_East={Up="rbxassetid://1014352",Rt="rbxassetid://1014347",Lf="rbxassetid://1014349",Ft="rbxassetid://1014348",Bk="rbxassetid://1014350",Dn="rbxassetid://1014351"},
        Walls_Of_Autumn={Up="rbxassetid://1013854",Rt="rbxassetid://1013849",Lf="rbxassetid://1013851",Ft="rbxassetid://1013850",Bk="rbxassetid://1013852",Dn="rbxassetid://1013853"},
        Winterness={Up="rbxassetid://1327360",Rt="rbxassetid://1327356",Lf="rbxassetid://1327357",Ft="rbxassetid://1327355",Bk="rbxassetid://1327358",Dn="rbxassetid://1327359"},
        Sunset_Orange={Up="rbxassetid://458016792",Rt="rbxassetid://458016782",Lf="rbxassetid://458016655",Ft="rbxassetid://458016532",Bk="rbxassetid://458016711",Dn="rbxassetid://458016826"},
        green_clouds_v1={Up="rbxassetid://921882259",Rt="rbxassetid://921881989",Lf="rbxassetid://921881811",Ft="rbxassetid://921882121",Bk="rbxassetid://921882045",Dn="rbxassetid://921881907"},
        Flames_a_Jegabert={Up="rbxassetid://157785145",Rt="rbxassetid://157785104",Lf="rbxassetid://157785128",Ft="rbxassetid://157785081",Bk="rbxassetid://157785163",Dn="rbxassetid://157785059"},
        Close_to_Heaven={Up="rbxassetid://7951703855",Rt="rbxassetid://7951700251",Lf="rbxassetid://7951697216",Ft="rbxassetid://7951694757",Bk="rbxassetid://7951826533",Dn="rbxassetid://7951706908"},
        Black_White={Up="rbxassetid://14133942685",Rt="rbxassetid://14133939547",Lf="rbxassetid://14133939547",Ft="rbxassetid://14133939547",Bk="rbxassetid://14133939547",Dn="rbxassetid://14133938465"},
        Abyssal_blues={Up="rbxassetid://16269829700",Rt="rbxassetid://16269814948",Lf="rbxassetid://16269813852",Ft="rbxassetid://16269798011",Bk="rbxassetid://16269815885",Dn="rbxassetid://16269839652"},
        Dark_World_Sky={Up="rbxassetid://282641570",Rt="rbxassetid://282641564",Lf="rbxassetid://282641575",Ft="rbxassetid://282641568",Bk="rbxassetid://282641582",Dn="rbxassetid://282641577"},
        Alien_Moon_Landscape={Up="rbxassetid://167773415",Rt="rbxassetid://167773257",Lf="rbxassetid://167781312",Ft="rbxassetid://167773289",Bk="rbxassetid://167773380",Dn="rbxassetid://167782033"},
        SpaceEnginePlanet={Up="rbxassetid://87015174865972",Rt="rbxassetid://96985335287535",Lf="rbxassetid://115474632610950",Ft="rbxassetid://96057940895723",Bk="rbxassetid://123450674043674",Dn="rbxassetid://84892181423810"},
        Pink_v2={Up="rbxassetid://79190209626172",Rt="rbxassetid://87570388049514",Lf="rbxassetid://80395333901607",Ft="rbxassetid://104560113223878",Bk="rbxassetid://71607054149497",Dn="rbxassetid://78865378050055"},
        Autumn={Up="rbxassetid://921878634",Rt="rbxassetid://921878250",Lf="rbxassetid://921878103",Ft="rbxassetid://921878504",Bk="rbxassetid://921878400",Dn="rbxassetid://921878168"},
        Warring_Wetlands={Up="rbxassetid://113506887858143",Rt="rbxassetid://138544626872403",Lf="rbxassetid://93686789437855",Ft="rbxassetid://112896929374279",Bk="rbxassetid://110735171905334",Dn="rbxassetid://112900091431292"},
        Spectral_Sapphire_City={Up="rbxassetid://72481099740761",Rt="rbxassetid://138652243792119",Lf="rbxassetid://101886569555681",Ft="rbxassetid://140362222097849",Bk="rbxassetid://106274872872587",Dn="rbxassetid://125461093276390"},
        Red5={Up="rbxassetid://36267076",Rt="rbxassetid://36267071",Lf="rbxassetid://36267064",Ft="rbxassetid://36267061",Bk="rbxassetid://36267052",Dn="rbxassetid://36267057"},
        HL2={Up="rbxassetid://8991307329",Rt="rbxassetid://8991307660",Lf="rbxassetid://8991308038",Ft="rbxassetid://8991308320",Bk="rbxassetid://8991308822",Dn="rbxassetid://8991308505"},
        Jungle={Up="rbxassetid://525546479",Rt="rbxassetid://525545319",Lf="rbxassetid://525550171",Ft="rbxassetid://525548536",Bk="rbxassetid://525546178",Dn="rbxassetid://525544628"},
        Sky_Heat={Up="rbxassetid://1836923808",Rt="rbxassetid://1836921497",Lf="rbxassetid://1836922224",Ft="rbxassetid://1836921842",Bk="rbxassetid://1836922613",Dn="rbxassetid://1836928757"},
        pinkv4={Up="rbxassetid://13695007103",Rt="rbxassetid://13695002700",Lf="rbxassetid://13694998113",Ft="rbxassetid://13694980654",Bk="rbxassetid://13694952867",Dn="rbxassetid://13694968325"},
        green3={Up="rbxassetid://47974909",Rt="rbxassetid://47974859",Lf="rbxassetid://47974776",Ft="rbxassetid://47974821",Bk="rbxassetid://47974894",Dn="rbxassetid://47974690"},
        Clouds1={Up="rbxassetid://11809140538",Rt="rbxassetid://11809142163",Lf="rbxassetid://11809143436",Ft="rbxassetid://11809144799",Bk="rbxassetid://11809146646",Dn="rbxassetid://11809145618"},
        Sun_Walk={Up="rbxassetid://16585819275",Rt="rbxassetid://16585746262",Lf="rbxassetid://16585752140",Ft="rbxassetid://16585739980",Bk="rbxassetid://16585695976",Dn="rbxassetid://16585737244"},
        TTS_Cursed_Dungeon={Up="rbxassetid://70995614183929",Rt="rbxassetid://130460024662043",Lf="rbxassetid://85184275905908",Ft="rbxassetid://108221764412107",Bk="rbxassetid://81459605791935",Dn="rbxassetid://115255645689819"},
        Deep_Into_Miasma={Up="rbxassetid://135069128989138",Rt="rbxassetid://79519533052164",Lf="rbxassetid://90741785278939",Ft="rbxassetid://98580344134812",Bk="rbxassetid://77130679029961",Dn="rbxassetid://124419409741010"},
        monolith={Up="rbxassetid://106290888678594",Rt="rbxassetid://116466339227587",Lf="rbxassetid://130511077687387",Ft="rbxassetid://77493170564247",Bk="rbxassetid://74065908042365",Dn="rbxassetid://136534841768726"},
        Sky_Halloween={Up="rbxassetid://497258157",Rt="rbxassetid://497258064",Lf="rbxassetid://497258112",Ft="rbxassetid://497258077",Bk="rbxassetid://497258127",Dn="rbxassetid://497258189"},
        idk={Up="rbxassetid://70945531",Rt="rbxassetid://70945508",Lf="rbxassetid://70945523",Ft="rbxassetid://70945487",Bk="rbxassetid://70945545",Dn="rbxassetid://70945449"},
        Fog_on_the_water={Up="rbxassetid://15876639348",Rt="rbxassetid://15876595486",Lf="rbxassetid://15876638420",Ft="rbxassetid://15876640231",Bk="rbxassetid://15876597103",Dn="rbxassetid://15876592775"},
        Blue_Night={Up="rbxassetid://5346761509",Rt="rbxassetid://5346761335",Lf="rbxassetid://5346761102",Ft="rbxassetid://5346760919",Bk="rbxassetid://5346760450",Dn="rbxassetid://5346760689"},
        Tattletail={Up="rbxassetid://120327360847306",Rt="rbxassetid://104710795412949",Lf="rbxassetid://75856428387182",Ft="rbxassetid://123928107244181",Bk="rbxassetid://140303809601361",Dn="rbxassetid://120327360847306"},
        Spettra_Sky={Up="rbxassetid://17150193",Rt="rbxassetid://17150186",Lf="rbxassetid://17150180",Ft="rbxassetid://17150163",Bk="rbxassetid://17150136",Dn="rbxassetid://17150148"},
        Above_the_Clouds={Up="rbxassetid://96933043812138",Rt="rbxassetid://111749399946832",Lf="rbxassetid://91138773974890",Ft="rbxassetid://114547356324218",Bk="rbxassetid://74258544564321",Dn="rbxassetid://75418092548143"},
        SpaceR={Up="rbxassetid://1735500898",Rt="rbxassetid://1735466772",Lf="rbxassetid://1735467682",Ft="rbxassetid://1735467260",Bk="rbxassetid://1735468027",Dn="rbxassetid://1735500192"},
        Purple_Space={Up="rbxassetid://137817405681365",Rt="rbxassetid://87408857415924",Lf="rbxassetid://73372229972523",Ft="rbxassetid://104400530594543",Bk="rbxassetid://129876530632297",Dn="rbxassetid://108406529909981"},
        GalaxyPurple={Up="rbxassetid://15983964246",Rt="rbxassetid://15983966246",Lf="rbxassetid://15983967420",Ft="rbxassetid://15983965025",Bk="rbxassetid://15983968922",Dn="rbxassetid://15983966825"},
        Star_Space={Up="rbxassetid://139978133063167",Rt="rbxassetid://128695913787010",Lf="rbxassetid://85660931047117",Ft="rbxassetid://95548607759941",Bk="rbxassetid://126758452864724",Dn="rbxassetid://80862418317956"},
        Uncanny_Sky={Up="rbxassetid://13720335408",Rt="rbxassetid://13720354336",Lf="rbxassetid://13720356894",Ft="rbxassetid://13720423714",Bk="rbxassetid://13720421689",Dn="rbxassetid://13720333936"},
        HL2BETA18={Up="rbxassetid://8974642505",Rt="rbxassetid://8974643731",Lf="rbxassetid://8974644763",Ft="rbxassetid://8974646042",Bk="rbxassetid://8974647550",Dn="rbxassetid://8974646772"},
        Amalgamate={Up="rbxassetid://108851549045654",Rt="rbxassetid://87202745437876",Lf="rbxassetid://122268666657177",Ft="rbxassetid://131487205762354",Bk="rbxassetid://105894972155701",Dn="rbxassetid://94242960710341"},
        Photongative={Up="rbxassetid://94627487431483",Rt="rbxassetid://128035491366705",Lf="rbxassetid://116474481819186",Ft="rbxassetid://72155384220281",Bk="rbxassetid://100907787722690",Dn="rbxassetid://78538004977437"},
        Torment={Up="rbxassetid://171561009",Rt="rbxassetid://171561026",Lf="rbxassetid://171561065",Ft="rbxassetid://171560968",Bk="rbxassetid://171560994",Dn="rbxassetid://171561019"},
        CagedBeast={Up="rbxassetid://128364186959855",Rt="rbxassetid://140516331245253",Lf="rbxassetid://79024854946964",Ft="rbxassetid://110109858023307",Bk="rbxassetid://100717462124891",Dn="rbxassetid://99419325764670"},
        Halloween={Up="rbxassetid://10735997102",Rt="rbxassetid://10735998096",Lf="rbxassetid://10735998682",Ft="rbxassetid://10735998943",Bk="rbxassetid://10735998453",Dn="rbxassetid://10735997670"},
        Ame_Emerald={Up="rbxassetid://160190474",Rt="rbxassetid://160190478",Lf="rbxassetid://160190486",Ft="rbxassetid://160190467",Bk="rbxassetid://160190417",Dn="rbxassetid://160190420"},
        Sky_c17={Up="rbxassetid://12446408696",Rt="rbxassetid://12446408511",Lf="rbxassetid://12446409485",Ft="rbxassetid://12446409637",Bk="rbxassetid://12446407892",Dn="rbxassetid://12446408052"},
        Sky_Mars={Up="rbxassetid://71753420067871",Rt="rbxassetid://76778121603376",Lf="rbxassetid://117145883766059",Ft="rbxassetid://114701180360882",Bk="rbxassetid://125383756066434",Dn="rbxassetid://94218621015509"},
        Dusty={Up="rbxassetid://16586348931",Rt="rbxassetid://16586347442",Lf="rbxassetid://16586345484",Ft="rbxassetid://16586333428",Bk="rbxassetid://16586327630",Dn="rbxassetid://16586330338"},
        Riddling={Up="rbxassetid://126564325711034",Rt="rbxassetid://102967958876608",Lf="rbxassetid://88691568829789",Ft="rbxassetid://70675854195087",Bk="rbxassetid://112056446240148",Dn="rbxassetid://136599597706612"},
        Firestorm={Up="rbxassetid://118584157282137",Rt="rbxassetid://135144997646815",Lf="rbxassetid://72343185589096",Ft="rbxassetid://98305824909316",Bk="rbxassetid://127987072983087",Dn="rbxassetid://129824093617776"},
        _7thWorld={Up="rbxassetid://87618031968838",Rt="rbxassetid://129868587364678",Lf="rbxassetid://132529615545338",Ft="rbxassetid://140013493187018",Bk="rbxassetid://83662685305307",Dn="rbxassetid://71354245253759"},
        AWorldThatDoesNotExist={Up="rbxassetid://110966283267842",Rt="rbxassetid://90104715010645",Lf="rbxassetid://134858296780658",Ft="rbxassetid://120342300263855",Bk="rbxassetid://103619731446391",Dn="rbxassetid://130644987951004"},
        Absolute_Zero={Up="rbxassetid://135764995563017",Rt="rbxassetid://108751650442886",Lf="rbxassetid://93132783922820",Ft="rbxassetid://94166993436571",Bk="rbxassetid://135759842345736",Dn="rbxassetid://131618619061341"},
        Abyssal_Flames={Up="rbxassetid://83295215834464",Rt="rbxassetid://84246762168898",Lf="rbxassetid://113877479719528",Ft="rbxassetid://114966033937119",Bk="rbxassetid://130432680623409",Dn="rbxassetid://79704090322682"},
        Accursed_Nocturne={Up="rbxassetid://118221204423574",Rt="rbxassetid://134426370297801",Lf="rbxassetid://120144069402159",Ft="rbxassetid://113314212696290",Bk="rbxassetid://73102975380834",Dn="rbxassetid://128523311870326"},
        Aero={Up="rbxassetid://91513725397080",Rt="rbxassetid://95302707013256",Lf="rbxassetid://76899879427701",Ft="rbxassetid://123383193198259",Bk="rbxassetid://83503059034904",Dn="rbxassetid://113028334604288"},
        Aethergrave={Up="rbxassetid://132503158454333",Rt="rbxassetid://92780915143619",Lf="rbxassetid://76682446720030",Ft="rbxassetid://120691824695949",Bk="rbxassetid://92969820764082",Dn="rbxassetid://87895652661462"},
        After_Storm={Up="rbxassetid://126294943510976",Rt="rbxassetid://137936238812572",Lf="rbxassetid://105862133131731",Ft="rbxassetid://88506726200354",Bk="rbxassetid://119824584843522",Dn="rbxassetid://98042187810047"},
        Aldebaran={Up="rbxassetid://93689288090492",Rt="rbxassetid://127949444339516",Lf="rbxassetid://111474218298921",Ft="rbxassetid://97075573997799",Bk="rbxassetid://80730701944910",Dn="rbxassetid://106133932287410"},
        AlienTropic={Up="rbxassetid://89052351475608",Rt="rbxassetid://92135645223283",Lf="rbxassetid://117548298616475",Ft="rbxassetid://104223878213435",Bk="rbxassetid://98862264304349",Dn="rbxassetid://133455685252778"},
        All_Roads={Up="rbxassetid://78705599095990",Rt="rbxassetid://75881044055224",Lf="rbxassetid://90190885468771",Ft="rbxassetid://98522516617737",Bk="rbxassetid://71445474874238",Dn="rbxassetid://119372515145714"},
        Zephyr={Up="rbxassetid://98099546963151",Rt="rbxassetid://129423971289613",Lf="rbxassetid://74637332261113",Ft="rbxassetid://96366965773383",Bk="rbxassetid://76893414020568",Dn="rbxassetid://77822179611622"},
        Ambrosia={Up="rbxassetid://104457048278276",Rt="rbxassetid://113831242587174",Lf="rbxassetid://114617415031683",Ft="rbxassetid://76746637872691",Bk="rbxassetid://88752981309539",Dn="rbxassetid://92897433203639"},
        Anemometer={Up="rbxassetid://95143298872119",Rt="rbxassetid://128044171873411",Lf="rbxassetid://131092647577353",Ft="rbxassetid://91645681309833",Bk="rbxassetid://129588181646675",Dn="rbxassetid://117389325697191"},
        Antiquity={Up="rbxassetid://114756225856229",Rt="rbxassetid://90901798550817",Lf="rbxassetid://105476349624478",Ft="rbxassetid://118736231252478",Bk="rbxassetid://79381520462647",Dn="rbxassetid://78192039826513"},
        ApocSky={Up="rbxassetid://76809713206876",Rt="rbxassetid://70483669688820",Lf="rbxassetid://87748108468781",Ft="rbxassetid://110646450144886",Bk="rbxassetid://107261903030269",Dn="rbxassetid://100844808000363"},
        Aquaspace={Up="rbxassetid://108485857408038",Rt="rbxassetid://76152772099517",Lf="rbxassetid://90581955859545",Ft="rbxassetid://140391648541306",Bk="rbxassetid://88523152196801",Dn="rbxassetid://115223004558393"},
        Aquatic_World={Up="rbxassetid://111344532865244",Rt="rbxassetid://110971401278063",Lf="rbxassetid://85974668489038",Ft="rbxassetid://98672970310102",Bk="rbxassetid://73144225252523",Dn="rbxassetid://79036962414464"},
        Arctic_Circle={Up="rbxassetid://106718315217809",Rt="rbxassetid://132898391114260",Lf="rbxassetid://94278282583686",Ft="rbxassetid://108386011853576",Bk="rbxassetid://96649620439187",Dn="rbxassetid://97847220217058"},
        Astra={Up="rbxassetid://128467902879354",Rt="rbxassetid://103272481464483",Lf="rbxassetid://85506874778994",Ft="rbxassetid://119193822833750",Bk="rbxassetid://118782045245916",Dn="rbxassetid://131960699845379"},
        Astray={Up="rbxassetid://128044283040420",Rt="rbxassetid://91705290961229",Lf="rbxassetid://88184968523195",Ft="rbxassetid://73441663553096",Bk="rbxassetid://124374184953812",Dn="rbxassetid://121332671129552"},
        Atmosphere2={Up="rbxassetid://78248650887105",Rt="rbxassetid://82682371579462",Lf="rbxassetid://109940749190933",Ft="rbxassetid://112735178758893",Bk="rbxassetid://81578897644599",Dn="rbxassetid://97251698868517"},
        Atmosphere3={Up="rbxassetid://138687755116451",Rt="rbxassetid://106871585128706",Lf="rbxassetid://127066801668855",Ft="rbxassetid://88135337152593",Bk="rbxassetid://112620572259384",Dn="rbxassetid://76401330265974"},
        Avalon={Up="rbxassetid://87887080251646",Rt="rbxassetid://97810534870343",Lf="rbxassetid://84579319411552",Ft="rbxassetid://123880222194259",Bk="rbxassetid://111706151863487",Dn="rbxassetid://80349583404573"},
        Azurewrath={Up="rbxassetid://116548738377147",Rt="rbxassetid://118260239525431",Lf="rbxassetid://92285484779867",Ft="rbxassetid://74555940038230",Bk="rbxassetid://92959784890176",Dn="rbxassetid://88931048884703"},
        Bahia={Up="rbxassetid://82309142664610",Rt="rbxassetid://81616771473209",Lf="rbxassetid://89614055735926",Ft="rbxassetid://87773542547204",Bk="rbxassetid://139789987448571",Dn="rbxassetid://84737047028323"},
        Baleful_Dusk={Up="rbxassetid://120200548287321",Rt="rbxassetid://78214207350930",Lf="rbxassetid://105777343853266",Ft="rbxassetid://101077748533800",Bk="rbxassetid://86368398761466",Dn="rbxassetid://135687896343411"},
        BioWaves={Up="rbxassetid://85274111313597",Rt="rbxassetid://96209555850373",Lf="rbxassetid://114081157848860",Ft="rbxassetid://111762076306662",Bk="rbxassetid://122669874272841",Dn="rbxassetid://85526993973353"},
        Biohazard={Up="rbxassetid://110419560118363",Rt="rbxassetid://139093255508654",Lf="rbxassetid://81053943927813",Ft="rbxassetid://130844636812278",Bk="rbxassetid://134110455800353",Dn="rbxassetid://137033022469922"},
        Bioluminescence={Up="rbxassetid://119996521618255",Rt="rbxassetid://81798933748828",Lf="rbxassetid://138371735275178",Ft="rbxassetid://90078781700648",Bk="rbxassetid://108980815679814",Dn="rbxassetid://108803938292011"},
        Bitter_Evening={Up="rbxassetid://96853717322806",Rt="rbxassetid://90095830826586",Lf="rbxassetid://94377147142642",Ft="rbxassetid://71670205357860",Bk="rbxassetid://99060310245891",Dn="rbxassetid://112313979536943"},
        Black_Magic={Up="rbxassetid://115395907924105",Rt="rbxassetid://75334723154662",Lf="rbxassetid://87322153546646",Ft="rbxassetid://99056270809729",Bk="rbxassetid://88494196679618",Dn="rbxassetid://82523703232569"},
        Blizzard={Up="rbxassetid://84163705564089",Rt="rbxassetid://95374054662437",Lf="rbxassetid://126900194752494",Ft="rbxassetid://106215989252748",Bk="rbxassetid://129268287314772",Dn="rbxassetid://84786064655282"},
        Blu_Torrice={Up="rbxassetid://102377757433463",Rt="rbxassetid://137768947112043",Lf="rbxassetid://88310294425658",Ft="rbxassetid://80802838669281",Bk="rbxassetid://126027050580843",Dn="rbxassetid://100097978480503"},
        Blue_Gem={Up="rbxassetid://87110989970432",Rt="rbxassetid://128920830159142",Lf="rbxassetid://130581310417470",Ft="rbxassetid://114140523171972",Bk="rbxassetid://135988598767904",Dn="rbxassetid://83096140816604"},
        Blue_Ice={Up="rbxassetid://129690943291210",Rt="rbxassetid://117802704786028",Lf="rbxassetid://126675497045926",Ft="rbxassetid://131769847064706",Bk="rbxassetid://117226309084413",Dn="rbxassetid://139188332401731"},
        Bluesteel={Up="rbxassetid://83238652393282",Rt="rbxassetid://137662396581041",Lf="rbxassetid://84349687220958",Ft="rbxassetid://102114311769847",Bk="rbxassetid://97967371583461",Dn="rbxassetid://115584895873143"},
        Bounds={Up="rbxassetid://120379910612270",Rt="rbxassetid://76889886117767",Lf="rbxassetid://84047574816976",Ft="rbxassetid://96630179540990",Bk="rbxassetid://103732260632814",Dn="rbxassetid://74844763985872"},
        Broken_Nature={Up="rbxassetid://97093679207514",Rt="rbxassetid://97039981652175",Lf="rbxassetid://102066390589104",Ft="rbxassetid://133811551640507",Bk="rbxassetid://88726933256066",Dn="rbxassetid://126437913947764"},
        BuildSite={Up="rbxassetid://100555704055774",Rt="rbxassetid://122382376576129",Lf="rbxassetid://80726321848158",Ft="rbxassetid://97821928658917",Bk="rbxassetid://130663324673413",Dn="rbxassetid://91826169959939"},
        BuildSite_LowRes={Up="rbxassetid://131993837984663",Rt="rbxassetid://132652148344611",Lf="rbxassetid://107821074180930",Ft="rbxassetid://84744510180488",Bk="rbxassetid://112717153458546",Dn="rbxassetid://116679289932183"},
        CORE={Up="rbxassetid://125758354994081",Rt="rbxassetid://136696233166595",Lf="rbxassetid://109538907055107",Ft="rbxassetid://125983921378532",Bk="rbxassetid://131309423383458",Dn="rbxassetid://112031436062556"},
        Cage_Sky={Up="rbxassetid://103228097221818",Rt="rbxassetid://81130133475980",Lf="rbxassetid://78304287877893",Ft="rbxassetid://98842511600378",Bk="rbxassetid://80117228741142",Dn="rbxassetid://81824593936915"},
        Candlelight={Up="rbxassetid://103301532444668",Rt="rbxassetid://106516918881325",Lf="rbxassetid://140577797043705",Ft="rbxassetid://90381636269576",Bk="rbxassetid://134929427873950",Dn="rbxassetid://86422192300663"},
        Canvas={Up="rbxassetid://91017618643188",Rt="rbxassetid://114929351826805",Lf="rbxassetid://135493529958812",Ft="rbxassetid://114593852803618",Bk="rbxassetid://121562230021390",Dn="rbxassetid://76994206205180"},
        Cascade={Up="rbxassetid://113983773859479",Rt="rbxassetid://117639323770479",Lf="rbxassetid://139550094058487",Ft="rbxassetid://139559205619193",Bk="rbxassetid://127598359438227",Dn="rbxassetid://76150557501420"},
        Celestial_Tiles={Up="rbxassetid://87094654760400",Rt="rbxassetid://93614408700227",Lf="rbxassetid://114189311478582",Ft="rbxassetid://102771432609350",Bk="rbxassetid://79255205383680",Dn="rbxassetid://96737447799924"},
        Clean_Slate={Up="rbxassetid://138836672309861",Rt="rbxassetid://135269316530959",Lf="rbxassetid://84483737934563",Ft="rbxassetid://110977893728415",Bk="rbxassetid://72068475634877",Dn="rbxassetid://128084035362620"},
        Cold_Front={Up="rbxassetid://86105102312765",Rt="rbxassetid://89235828670703",Lf="rbxassetid://98173057585290",Ft="rbxassetid://120342636439535",Bk="rbxassetid://90142082237876",Dn="rbxassetid://77239701780450"},
        Collision={Up="rbxassetid://121891460835963",Rt="rbxassetid://116415956335424",Lf="rbxassetid://85354656808312",Ft="rbxassetid://87311278292919",Bk="rbxassetid://138801143454740",Dn="rbxassetid://137023334442758"},
        Compound={Up="rbxassetid://80568302323450",Rt="rbxassetid://115180883721658",Lf="rbxassetid://134756607970631",Ft="rbxassetid://86959807197050",Bk="rbxassetid://136944734869495",Dn="rbxassetid://75959455141791"},
        Compound_No_Objects={Up="rbxassetid://116583610433169",Rt="rbxassetid://71264664827663",Lf="rbxassetid://136689233950462",Ft="rbxassetid://118425914976653",Bk="rbxassetid://89844171051087",Dn="rbxassetid://90970712226258"},
        Coupled_Decay={Up="rbxassetid://76945082350815",Rt="rbxassetid://84707990641395",Lf="rbxassetid://94937165714294",Ft="rbxassetid://96551135040603",Bk="rbxassetid://126486130548875",Dn="rbxassetid://92145073329676"},
        Crystal_Teardrops={Up="rbxassetid://126289688945348",Rt="rbxassetid://84005200650081",Lf="rbxassetid://84016685883120",Ft="rbxassetid://89356801860480",Bk="rbxassetid://115722892948156",Dn="rbxassetid://109725483758578"},
        Crystalline_Web={Up="rbxassetid://101904753380808",Rt="rbxassetid://111083892579373",Lf="rbxassetid://105292574711923",Ft="rbxassetid://91306398891725",Bk="rbxassetid://94611201709987",Dn="rbxassetid://98503803956351"},
        Cyber_Tundra={Up="rbxassetid://82371390349352",Rt="rbxassetid://74322015302293",Lf="rbxassetid://129076935342629",Ft="rbxassetid://94135001742121",Bk="rbxassetid://127670256306525",Dn="rbxassetid://91396433107004"},
        Darkseed_Tempest={Up="rbxassetid://73266889841653",Rt="rbxassetid://132119306856099",Lf="rbxassetid://110326015462164",Ft="rbxassetid://128917736612441",Bk="rbxassetid://133854954580135",Dn="rbxassetid://100031444644192"},
        Daybreak={Up="rbxassetid://114132345913471",Rt="rbxassetid://103539093037468",Lf="rbxassetid://138768496668157",Ft="rbxassetid://103920069425748",Bk="rbxassetid://119649710796381",Dn="rbxassetid://76811639791167"},
        Dead_Leaves={Up="rbxassetid://119526466390797",Rt="rbxassetid://137621885253705",Lf="rbxassetid://103266941129857",Ft="rbxassetid://130768807670548",Bk="rbxassetid://139155190854069",Dn="rbxassetid://94049099430291"},
        Deciduous={Up="rbxassetid://103524822056470",Rt="rbxassetid://131152630286823",Lf="rbxassetid://84559535392961",Ft="rbxassetid://106151354831484",Bk="rbxassetid://77543520536404",Dn="rbxassetid://87492412788594"},
        Decommissioned={Up="rbxassetid://72293820235920",Rt="rbxassetid://112167028632951",Lf="rbxassetid://111073082891297",Ft="rbxassetid://109823070194342",Bk="rbxassetid://140660141009582",Dn="rbxassetid://139114754083175"},
        Demo_Sky={Up="rbxassetid://132386333178103",Rt="rbxassetid://133948024280505",Lf="rbxassetid://111533146227237",Ft="rbxassetid://117887011174824",Bk="rbxassetid://102041306808953",Dn="rbxassetid://121581196532937"},
        Desert_Outpost_Dusk={Up="rbxassetid://107716949901042",Rt="rbxassetid://128339076097313",Lf="rbxassetid://89700695657204",Ft="rbxassetid://118198239518836",Bk="rbxassetid://110525531837345",Dn="rbxassetid://93761100901497"},
        DesolateWorld={Up="rbxassetid://98899069659815",Rt="rbxassetid://134106854765432",Lf="rbxassetid://117093291982066",Ft="rbxassetid://124803934206947",Bk="rbxassetid://88133015767809",Dn="rbxassetid://140651385939252"},
        Digital_Ocean={Up="rbxassetid://89383696302712",Rt="rbxassetid://136655464256071",Lf="rbxassetid://80653995391575",Ft="rbxassetid://131093690806418",Bk="rbxassetid://102182089220023",Dn="rbxassetid://103315496705315"},
        Distant_Beacons={Up="rbxassetid://122570533890970",Rt="rbxassetid://140001333983730",Lf="rbxassetid://70971326814040",Ft="rbxassetid://89786835792749",Bk="rbxassetid://118570390186118",Dn="rbxassetid://89831983791297"},
        Doorway_to_the_Abyss={Up="rbxassetid://77531517029763",Rt="rbxassetid://115841964665180",Lf="rbxassetid://83759900096153",Ft="rbxassetid://132859617731476",Bk="rbxassetid://134195667886536",Dn="rbxassetid://110684624769187"},
        Ectoplasm={Up="rbxassetid://122408819800973",Rt="rbxassetid://134449110988555",Lf="rbxassetid://96927881898513",Ft="rbxassetid://73406089961736",Bk="rbxassetid://115197075894668",Dn="rbxassetid://91826534475258"},
        Enchant={Up="rbxassetid://130777771463549",Rt="rbxassetid://97341458700757",Lf="rbxassetid://80131877671285",Ft="rbxassetid://130332065908561",Bk="rbxassetid://126516810683973",Dn="rbxassetid://116674105465617"},
        End_Times={Up="rbxassetid://112394465644459",Rt="rbxassetid://133295661436741",Lf="rbxassetid://81084674474897",Ft="rbxassetid://108921679597586",Bk="rbxassetid://107222685097436",Dn="rbxassetid://139305263903135"},
        EndOfSeason={Up="rbxassetid://107314041503250",Rt="rbxassetid://73754098071285",Lf="rbxassetid://119403005680368",Ft="rbxassetid://102427933851670",Bk="rbxassetid://113747397228795",Dn="rbxassetid://70511288137275"},
        Energy_Flow={Up="rbxassetid://85718348811159",Rt="rbxassetid://98037765363993",Lf="rbxassetid://85039161518723",Ft="rbxassetid://93848466797566",Bk="rbxassetid://135641913828326",Dn="rbxassetid://127182922880146"},
        Essence1={Up="rbxassetid://119924914818748",Rt="rbxassetid://133719659908269",Lf="rbxassetid://132682851433625",Ft="rbxassetid://121837569499829",Bk="rbxassetid://92922273829172",Dn="rbxassetid://122924766458910"},
        Eventide={Up="rbxassetid://109992324761761",Rt="rbxassetid://119813543743499",Lf="rbxassetid://125240332573191",Ft="rbxassetid://119628428633801",Bk="rbxassetid://70788290258528",Dn="rbxassetid://126919164089819"},
        Exfil={Up="rbxassetid://77271343365989",Rt="rbxassetid://138264362836921",Lf="rbxassetid://104251847582411",Ft="rbxassetid://87111746498318",Bk="rbxassetid://118271786468770",Dn="rbxassetid://76374380971519"},
        Ezra_s_Lament={Up="rbxassetid://105266086678430",Rt="rbxassetid://114102368832986",Lf="rbxassetid://79895634365895",Ft="rbxassetid://98203700311449",Bk="rbxassetid://82271913882933",Dn="rbxassetid://118836751775005"},
        Fallen_Sky={Up="rbxassetid://112139243672837",Rt="rbxassetid://81490591698392",Lf="rbxassetid://90412711736777",Ft="rbxassetid://101037027253138",Bk="rbxassetid://104392780233546",Dn="rbxassetid://73439571145025"},
        Fastlane={Up="rbxassetid://134876183149116",Rt="rbxassetid://84259469635113",Lf="rbxassetid://79971559119990",Ft="rbxassetid://129385162515911",Bk="rbxassetid://119600895367548",Dn="rbxassetid://120997206862534"},
        File_Select={Up="rbxassetid://138246504974028",Rt="rbxassetid://118371168989536",Lf="rbxassetid://86303659691397",Ft="rbxassetid://123998123488968",Bk="rbxassetid://129115544845598",Dn="rbxassetid://140473238122863"},
        Firestorm_2={Up="rbxassetid://118584157282137",Rt="rbxassetid://135144997646815",Lf="rbxassetid://72343185589096",Ft="rbxassetid://98305824909316",Bk="rbxassetid://127987072983087",Dn="rbxassetid://129824093617776"},
        Firmament={Up="rbxassetid://112172731432425",Rt="rbxassetid://123817715945946",Lf="rbxassetid://122138472291175",Ft="rbxassetid://93558125878405",Bk="rbxassetid://113540272886160",Dn="rbxassetid://103159903428913"},
        Flash_Point={Up="rbxassetid://90386320854672",Rt="rbxassetid://126059389263803",Lf="rbxassetid://78870322947032",Ft="rbxassetid://133127635208882",Bk="rbxassetid://87617830391080",Dn="rbxassetid://76821403561576"},
        Force_Field={Up="rbxassetid://82108835145115",Rt="rbxassetid://88309658844725",Lf="rbxassetid://108793838053866",Ft="rbxassetid://87308285491201",Bk="rbxassetid://112703644983924",Dn="rbxassetid://87347779644450"},
        Formation={Up="rbxassetid://110667848320539",Rt="rbxassetid://123940989247130",Lf="rbxassetid://99998029976882",Ft="rbxassetid://110178202130740",Bk="rbxassetid://82535205188255",Dn="rbxassetid://123359899460713"},
        Frigid_Void={Up="rbxassetid://137495464524905",Rt="rbxassetid://138540784295848",Lf="rbxassetid://122259138221404",Ft="rbxassetid://71319264944150",Bk="rbxassetid://137416817637525",Dn="rbxassetid://140171230318489"},
        Generic_Day={Up="rbxassetid://119720925351405",Rt="rbxassetid://120426535170775",Lf="rbxassetid://130825273391961",Ft="rbxassetid://129364670229925",Bk="rbxassetid://116615670683631",Dn="rbxassetid://94411411849459"},
        Golden_Atmosphere={Up="rbxassetid://95516774315162",Rt="rbxassetid://94454559905274",Lf="rbxassetid://127905600318108",Ft="rbxassetid://74780520544846",Bk="rbxassetid://105974132636614",Dn="rbxassetid://126718862147407"},
        Gridlock={Up="rbxassetid://95190935097362",Rt="rbxassetid://134070390627392",Lf="rbxassetid://70684628521982",Ft="rbxassetid://140337990286031",Bk="rbxassetid://95957029334845",Dn="rbxassetid://79025070740050"},
        Gridlock2={Up="rbxassetid://127763470426729",Rt="rbxassetid://122766455721874",Lf="rbxassetid://135448136641123",Ft="rbxassetid://129231858918688",Bk="rbxassetid://121593265943010",Dn="rbxassetid://88660294340644"},
        Hallow_s_Eve={Up="rbxassetid://76505374315791",Rt="rbxassetid://119664342885692",Lf="rbxassetid://76753162901470",Ft="rbxassetid://128035520996613",Bk="rbxassetid://72049075028634",Dn="rbxassetid://123619025855406"},
        Harvest={Up="rbxassetid://101505436286697",Rt="rbxassetid://120959955311861",Lf="rbxassetid://80732559617526",Ft="rbxassetid://83453401601387",Bk="rbxassetid://101635041889544",Dn="rbxassetid://114555278196655"},
        Haunted_House={Up="rbxassetid://129200659822783",Rt="rbxassetid://92984246710939",Lf="rbxassetid://121186440657838",Ft="rbxassetid://106479882191174",Bk="rbxassetid://106294281857582",Dn="rbxassetid://79289177868594"},
        Hollow_Realm={Up="rbxassetid://110535185837388",Rt="rbxassetid://84025580672537",Lf="rbxassetid://134542132457476",Ft="rbxassetid://78915938970277",Bk="rbxassetid://86814052866742",Dn="rbxassetid://122196600448089"},
        Honeycomb={Up="rbxassetid://127499200029552",Rt="rbxassetid://132257042391786",Lf="rbxassetid://99739731513456",Ft="rbxassetid://86024052434545",Bk="rbxassetid://73758973895627",Dn="rbxassetid://115288403186484"},
        Ice_Lake={Up="rbxassetid://140406723135316",Rt="rbxassetid://74615595108173",Lf="rbxassetid://127754724816331",Ft="rbxassetid://77284207812785",Bk="rbxassetid://70469813053218",Dn="rbxassetid://115837022979059"},
        In_Memory={Up="rbxassetid://73150166592363",Rt="rbxassetid://130348071846638",Lf="rbxassetid://134775232792821",Ft="rbxassetid://95291810267706",Bk="rbxassetid://116553839606666",Dn="rbxassetid://77536659938763"},
        Inferno_Old={Up="rbxassetid://89833562027838",Rt="rbxassetid://83350262775378",Lf="rbxassetid://137135203573237",Ft="rbxassetid://89835467426436",Bk="rbxassetid://99615852307210",Dn="rbxassetid://105944990330585"},
        Inferno_Sunset={Up="rbxassetid://122609737860352",Rt="rbxassetid://130162906362666",Lf="rbxassetid://127251257979196",Ft="rbxassetid://91335659902084",Bk="rbxassetid://95429228463886",Dn="rbxassetid://131503227407777"},
        InfoPage={Up="rbxassetid://104299585411932",Rt="rbxassetid://81290090016471",Lf="rbxassetid://86728394405335",Ft="rbxassetid://108531437183094",Bk="rbxassetid://98427422342055",Dn="rbxassetid://75214364196250"},
        Just_Perfect={Up="rbxassetid://76367907718795",Rt="rbxassetid://76707610244115",Lf="rbxassetid://130395382803391",Ft="rbxassetid://72789051663436",Bk="rbxassetid://118985726606286",Dn="rbxassetid://119140796260420"},
        Last_Days={Up="rbxassetid://79779097463909",Rt="rbxassetid://125409014744528",Lf="rbxassetid://70375033173187",Ft="rbxassetid://130184127758033",Bk="rbxassetid://74350278906564",Dn="rbxassetid://94630450051158"},
        Late_Autumn_Night={Up="rbxassetid://86637425582046",Rt="rbxassetid://139538872885067",Lf="rbxassetid://140422476660163",Ft="rbxassetid://86512033475129",Bk="rbxassetid://77121200397957",Dn="rbxassetid://76443849666996"},
        Lavender={Up="rbxassetid://110919796576251",Rt="rbxassetid://106225185707321",Lf="rbxassetid://100852076364027",Ft="rbxassetid://134592545901104",Bk="rbxassetid://80859009736692",Dn="rbxassetid://83606926893899"},
        Lichen={Up="rbxassetid://98937239876023",Rt="rbxassetid://85113272197706",Lf="rbxassetid://98576952095350",Ft="rbxassetid://115789622099744",Bk="rbxassetid://117904036372739",Dn="rbxassetid://85588733139448"},
        Light_Wave={Up="rbxassetid://88224528897401",Rt="rbxassetid://99885408522508",Lf="rbxassetid://129532671282815",Ft="rbxassetid://131678701996071",Bk="rbxassetid://92449042730273",Dn="rbxassetid://94222137710938"},
        Lilac={Up="rbxassetid://78055639712264",Rt="rbxassetid://101483570792681",Lf="rbxassetid://96368934634208",Ft="rbxassetid://71644753679928",Bk="rbxassetid://96494381856539",Dn="rbxassetid://73413590863839"},
        Liquid_Plastic={Up="rbxassetid://126337545555991",Rt="rbxassetid://78806017680210",Lf="rbxassetid://94282406383435",Ft="rbxassetid://95683356476744",Bk="rbxassetid://75379419502514",Dn="rbxassetid://71045942062088"},
        Lotus={Up="rbxassetid://126341168182942",Rt="rbxassetid://127252016785725",Lf="rbxassetid://89801504092291",Ft="rbxassetid://130594720922248",Bk="rbxassetid://130046676156361",Dn="rbxassetid://107897161843366"},
        Mameshiba={Up="rbxassetid://89773355654703",Rt="rbxassetid://76192642876034",Lf="rbxassetid://105945337643287",Ft="rbxassetid://118305202099561",Bk="rbxassetid://96078167627227",Dn="rbxassetid://80284816825154"},
        Marble_Gallery={Up="rbxassetid://90650564452229",Rt="rbxassetid://73371000432459",Lf="rbxassetid://117681947279644",Ft="rbxassetid://134706755579898",Bk="rbxassetid://105531630256983",Dn="rbxassetid://114593479828248"},
        Mirage={Up="rbxassetid://101690318525684",Rt="rbxassetid://114234606369216",Lf="rbxassetid://138395860476738",Ft="rbxassetid://128851302733659",Bk="rbxassetid://129341700282698",Dn="rbxassetid://72200403390416"},
        Monochrome_Horizon={Up="rbxassetid://113697821997832",Rt="rbxassetid://129400811348015",Lf="rbxassetid://93845403992330",Ft="rbxassetid://107459131946998",Bk="rbxassetid://136367280195640",Dn="rbxassetid://70631820163080"},
        Monolith={Up="rbxassetid://106290888678594",Rt="rbxassetid://116466339227587",Lf="rbxassetid://130511077687387",Ft="rbxassetid://77493170564247",Bk="rbxassetid://74065908042365",Dn="rbxassetid://136534841768726"},
        Monowinter={Up="rbxassetid://85936284392151",Rt="rbxassetid://120888253473039",Lf="rbxassetid://110367763729337",Ft="rbxassetid://109116307052886",Bk="rbxassetid://103487155571972",Dn="rbxassetid://104896930231967"},
        Moonlight={Up="rbxassetid://119018311700084",Rt="rbxassetid://130264551455960",Lf="rbxassetid://76940804922026",Ft="rbxassetid://106864140891426",Bk="rbxassetid://89258740698406",Dn="rbxassetid://136601030375824"},
        More_Winterness={Up="rbxassetid://127184800626970",Rt="rbxassetid://96787814024791",Lf="rbxassetid://107380786317173",Ft="rbxassetid://96920939052507",Bk="rbxassetid://85197211727598",Dn="rbxassetid://112779172131776"},
        Motif={Up="rbxassetid://140080098433126",Rt="rbxassetid://81011627135110",Lf="rbxassetid://106956220883166",Ft="rbxassetid://89772559045858",Bk="rbxassetid://78149796135468",Dn="rbxassetid://76096968615142"},
        Nacht={Up="rbxassetid://81079781097781",Rt="rbxassetid://125297308992449",Lf="rbxassetid://90316502470283",Ft="rbxassetid://139879254315715",Bk="rbxassetid://137092472877638",Dn="rbxassetid://109547601931745"},
        Nevermoor={Up="rbxassetid://122975292077225",Rt="rbxassetid://123310439121518",Lf="rbxassetid://78607739289723",Ft="rbxassetid://134655523665482",Bk="rbxassetid://109011058956075",Dn="rbxassetid://96605132056708"},
        NewDay={Up="rbxassetid://74408054834741",Rt="rbxassetid://120026694462039",Lf="rbxassetid://124875718414519",Ft="rbxassetid://131329567940529",Bk="rbxassetid://76505330582189",Dn="rbxassetid://138771251365999"},
        Night_Sky={Up="rbxassetid://85961336496861",Rt="rbxassetid://94113792116609",Lf="rbxassetid://99335379899605",Ft="rbxassetid://84200355270281",Bk="rbxassetid://70504772380301",Dn="rbxassetid://85385526976694"},
        Night_on_the_Sea={Up="rbxassetid://99437219622125",Rt="rbxassetid://93311286292026",Lf="rbxassetid://104155473523338",Ft="rbxassetid://87080448753496",Bk="rbxassetid://76164718684754",Dn="rbxassetid://133842076458400"},
        Northern_Hemisphere={Up="rbxassetid://77002880562809",Rt="rbxassetid://88152092141274",Lf="rbxassetid://129513648700012",Ft="rbxassetid://70894769243360",Bk="rbxassetid://126899901113818",Dn="rbxassetid://88113301492734"},
        NorthernLight={Up="rbxassetid://117950889232520",Rt="rbxassetid://85408088260363",Lf="rbxassetid://99985397260656",Ft="rbxassetid://132753233231083",Bk="rbxassetid://101081669163254",Dn="rbxassetid://74973848679640"},
        NorthernValley={Up="rbxassetid://97726745928834",Rt="rbxassetid://80348141054191",Lf="rbxassetid://133033250855142",Ft="rbxassetid://115565465781681",Bk="rbxassetid://117520467869783",Dn="rbxassetid://134793637490421"},
        Obscurity={Up="rbxassetid://132239109136607",Rt="rbxassetid://86915007381870",Lf="rbxassetid://98686774405670",Ft="rbxassetid://128400496653932",Bk="rbxassetid://95373201131265",Dn="rbxassetid://116012037315741"},
        Observation_Deck={Up="rbxassetid://110209417283602",Rt="rbxassetid://120626672648445",Lf="rbxassetid://93180437703849",Ft="rbxassetid://105823660923050",Bk="rbxassetid://130010536275007",Dn="rbxassetid://72030417907899"},
        Ocher_Veil={Up="rbxassetid://123913843330353",Rt="rbxassetid://113722957849983",Lf="rbxassetid://97158305829978",Ft="rbxassetid://108451367123891",Bk="rbxassetid://120104765042487",Dn="rbxassetid://130715749431571"},
        Orchard={Up="rbxassetid://76588473888208",Rt="rbxassetid://84175080022209",Lf="rbxassetid://112222930616433",Ft="rbxassetid://113849476173081",Bk="rbxassetid://108079595887995",Dn="rbxassetid://96326201643749"},
        Otherworldly_Overcast={Up="rbxassetid://98696172336807",Rt="rbxassetid://138568751391370",Lf="rbxassetid://96606152231252",Ft="rbxassetid://126173248483769",Bk="rbxassetid://77473193213229",Dn="rbxassetid://78388766364641"},
        Outbreak={Up="rbxassetid://108823136187254",Rt="rbxassetid://78979479013884",Lf="rbxassetid://116033946162539",Ft="rbxassetid://82399046345873",Bk="rbxassetid://94418952938046",Dn="rbxassetid://75800907070236"},
        Outer_Wall={Up="rbxassetid://78419105197430",Rt="rbxassetid://92862034990369",Lf="rbxassetid://119888806528215",Ft="rbxassetid://129022574831122",Bk="rbxassetid://111467169010655",Dn="rbxassetid://120727997270498"},
        Overworld2={Up="rbxassetid://98437320521092",Rt="rbxassetid://140582923623563",Lf="rbxassetid://114307781639354",Ft="rbxassetid://131670489873635",Bk="rbxassetid://95710728677303",Dn="rbxassetid://128084912031789"},
        PeacefulNight={Up="rbxassetid://96396353505348",Rt="rbxassetid://135276626311052",Lf="rbxassetid://93570260472629",Ft="rbxassetid://106560098614195",Bk="rbxassetid://106471072829278",Dn="rbxassetid://88332612806654"},
        Permafrost={Up="rbxassetid://86675866351324",Rt="rbxassetid://116745046618753",Lf="rbxassetid://86034262957145",Ft="rbxassetid://125787399877771",Bk="rbxassetid://118269338216867",Dn="rbxassetid://132369942350262"},
        Photochemical_Smog={Up="rbxassetid://78337530610341",Rt="rbxassetid://105973366673701",Lf="rbxassetid://104870441549457",Ft="rbxassetid://90441657325271",Bk="rbxassetid://114459799251439",Dn="rbxassetid://111298463826808"},
        Photonegative={Up="rbxassetid://94627487431483",Rt="rbxassetid://128035491366705",Lf="rbxassetid://116474481819186",Ft="rbxassetid://72155384220281",Bk="rbxassetid://100907787722690",Dn="rbxassetid://78538004977437"},
        Pink_Shell={Up="rbxassetid://99961658475382",Rt="rbxassetid://120970123456421",Lf="rbxassetid://75735698536501",Ft="rbxassetid://86337283235138",Bk="rbxassetid://96062995971236",Dn="rbxassetid://139735964957203"},
        Planets={Up="rbxassetid://129555505238482",Rt="rbxassetid://132622240593075",Lf="rbxassetid://95532525408808",Ft="rbxassetid://88534895293594",Bk="rbxassetid://110159773931562",Dn="rbxassetid://134900245082822"},
        Plasma_Globe={Up="rbxassetid://126454883620661",Rt="rbxassetid://137767677843533",Lf="rbxassetid://122772141950664",Ft="rbxassetid://132302631512408",Bk="rbxassetid://85561613801902",Dn="rbxassetid://90900132296822"},
        Plasma_Grid={Up="rbxassetid://129421913236518",Rt="rbxassetid://114753769542596",Lf="rbxassetid://84154957678866",Ft="rbxassetid://99234358863571",Bk="rbxassetid://114603952006807",Dn="rbxassetid://117994007231833"},
        Porcelain={Up="rbxassetid://104512200286714",Rt="rbxassetid://100240978991021",Lf="rbxassetid://70625071816364",Ft="rbxassetid://140651884658832",Bk="rbxassetid://135282587104077",Dn="rbxassetid://132514811927832"},
        Pumpkin_Patch={Up="rbxassetid://138006307730252",Rt="rbxassetid://107508632280744",Lf="rbxassetid://90204023784570",Ft="rbxassetid://134268841801572",Bk="rbxassetid://75792839052585",Dn="rbxassetid://75573727444557"},
        Pumpkinhead={Up="rbxassetid://77210668991513",Rt="rbxassetid://121381927221673",Lf="rbxassetid://110792895789035",Ft="rbxassetid://108329248917886",Bk="rbxassetid://131355605067630",Dn="rbxassetid://81344191271490"},
        Recall={Up="rbxassetid://135639354928930",Rt="rbxassetid://136873356202780",Lf="rbxassetid://73030976691381",Ft="rbxassetid://84885870904455",Bk="rbxassetid://108960091841564",Dn="rbxassetid://139668634685801"},
        Reconnected={Up="rbxassetid://97924003886344",Rt="rbxassetid://122957565915203",Lf="rbxassetid://113962030551390",Ft="rbxassetid://134770057969317",Bk="rbxassetid://77822743340681",Dn="rbxassetid://126769264190752"},
        Recurrence={Up="rbxassetid://101363766549972",Rt="rbxassetid://85712357801772",Lf="rbxassetid://110858557687445",Ft="rbxassetid://119445524584376",Bk="rbxassetid://128086577524772",Dn="rbxassetid://78303260098252"},
        Red_Truss={Up="rbxassetid://79617024725954",Rt="rbxassetid://78796831391585",Lf="rbxassetid://73303641956518",Ft="rbxassetid://136127320126395",Bk="rbxassetid://76245894783138",Dn="rbxassetid://135379630216790"},
        Reflex={Up="rbxassetid://108291314563603",Rt="rbxassetid://72138319933622",Lf="rbxassetid://115188496120009",Ft="rbxassetid://124237728866537",Bk="rbxassetid://77291847927476",Dn="rbxassetid://78523812264114"},
        Refraction={Up="rbxassetid://123654558736549",Rt="rbxassetid://127791660749706",Lf="rbxassetid://82327956385635",Ft="rbxassetid://136080305658787",Bk="rbxassetid://92789947565804",Dn="rbxassetid://107903080016933"},
        Rendition={Up="rbxassetid://135238800252320",Rt="rbxassetid://120980285219543",Lf="rbxassetid://94655344055360",Ft="rbxassetid://110874354594380",Bk="rbxassetid://81394679885657",Dn="rbxassetid://86006896447963"},
        Requiem={Up="rbxassetid://94045963744643",Rt="rbxassetid://91874841281616",Lf="rbxassetid://118516842368424",Ft="rbxassetid://71251312667971",Bk="rbxassetid://78578251824862",Dn="rbxassetid://130677640946658"},
        Resting_Place={Up="rbxassetid://133768524847431",Rt="rbxassetid://123540928833214",Lf="rbxassetid://93213558411050",Ft="rbxassetid://82789123540403",Bk="rbxassetid://95153918826417",Dn="rbxassetid://86628682809155"},
        Restless_Jungle={Up="rbxassetid://105563567371496",Rt="rbxassetid://138345330486209",Lf="rbxassetid://114737479634352",Ft="rbxassetid://71756512359312",Bk="rbxassetid://130099895286384",Dn="rbxassetid://101029321375585"},
        Revenant={Up="rbxassetid://99341763926040",Rt="rbxassetid://116667223354064",Lf="rbxassetid://108693396038468",Ft="rbxassetid://128515897341237",Bk="rbxassetid://99103425749129",Dn="rbxassetid://120224627028036"},
        Riddling_Sky={Up="rbxassetid://126564325711034",Rt="rbxassetid://102967958876608",Lf="rbxassetid://88691568829789",Ft="rbxassetid://70675854195087",Bk="rbxassetid://112056446240148",Dn="rbxassetid://136599597706612"},
        Rutaceae={Up="rbxassetid://117627522369851",Rt="rbxassetid://129409996032742",Lf="rbxassetid://75491956900354",Ft="rbxassetid://106993729647419",Bk="rbxassetid://95787549099379",Dn="rbxassetid://126425844970619"},
        Sapphire={Up="rbxassetid://124851138696276",Rt="rbxassetid://76698338513348",Lf="rbxassetid://110481573705232",Ft="rbxassetid://93036601815673",Bk="rbxassetid://95939056801980",Dn="rbxassetid://77655731493493"},
        Seeing_Stars={Up="rbxassetid://82233494358076",Rt="rbxassetid://73507088074350",Lf="rbxassetid://123113334415775",Ft="rbxassetid://88408425137498",Bk="rbxassetid://81135332033010",Dn="rbxassetid://122162052771879"},
        Semiconductor={Up="rbxassetid://87084585802771",Rt="rbxassetid://91075123527804",Lf="rbxassetid://113663237442915",Ft="rbxassetid://137583661731588",Bk="rbxassetid://121141335722574",Dn="rbxassetid://96252168665991"},
        Serenade={Up="rbxassetid://91284901903530",Rt="rbxassetid://110944149162783",Lf="rbxassetid://135117331568447",Ft="rbxassetid://94615548907952",Bk="rbxassetid://78069745854425",Dn="rbxassetid://74724498948531"},
        Sherbert={Up="rbxassetid://74159394113670",Rt="rbxassetid://118850118899523",Lf="rbxassetid://119958258734986",Ft="rbxassetid://87443209446007",Bk="rbxassetid://122747794116672",Dn="rbxassetid://131016403097224"},
        Shroud={Up="rbxassetid://113132408903373",Rt="rbxassetid://108970007211767",Lf="rbxassetid://134637323079756",Ft="rbxassetid://70472027317250",Bk="rbxassetid://80331182091389",Dn="rbxassetid://95047075796753"},
        Silver_Bullet={Up="rbxassetid://78695466095279",Rt="rbxassetid://129328263845291",Lf="rbxassetid://81247234256576",Ft="rbxassetid://106252020193945",Bk="rbxassetid://135835201505314",Dn="rbxassetid://94715769242480"},
        Simple_Atmosphere={Up="rbxassetid://73579880904923",Rt="rbxassetid://124648901000860",Lf="rbxassetid://71105321342302",Ft="rbxassetid://90319615102760",Bk="rbxassetid://112890141005522",Dn="rbxassetid://136890881443236"},
        Simple_Nice={Up="rbxassetid://132960802310480",Rt="rbxassetid://134620499754692",Lf="rbxassetid://122929711896628",Ft="rbxassetid://83516149512132",Bk="rbxassetid://73804117962771",Dn="rbxassetid://89053328878181"},
        Sixth_Sanctuary={Up="rbxassetid://116748041656542",Rt="rbxassetid://77911629837712",Lf="rbxassetid://78770897891383",Ft="rbxassetid://122136977599218",Bk="rbxassetid://75685751830147",Dn="rbxassetid://119270455112733"},
        Sky_Grate={Up="rbxassetid://132208868618844",Rt="rbxassetid://89057569793877",Lf="rbxassetid://135165355738925",Ft="rbxassetid://123723617230238",Bk="rbxassetid://107867307239407",Dn="rbxassetid://80685290350552"},
        Sleepy_Hollow={Up="rbxassetid://103669333067386",Rt="rbxassetid://80292933172277",Lf="rbxassetid://128463472521216",Ft="rbxassetid://116647631063027",Bk="rbxassetid://86424442388701",Dn="rbxassetid://95261308591244"},
        Slightly_Cloudy={Up="rbxassetid://82994095494631",Rt="rbxassetid://136105744447156",Lf="rbxassetid://112248242487921",Ft="rbxassetid://81450011705272",Bk="rbxassetid://115508035455509",Dn="rbxassetid://140588560233834"},
        Snow_Level={Up="rbxassetid://73385878883299",Rt="rbxassetid://106911665823902",Lf="rbxassetid://82461595461093",Ft="rbxassetid://84282220720218",Bk="rbxassetid://112235492205308",Dn="rbxassetid://71900751271799"},
        Snowdon={Up="rbxassetid://127254574460742",Rt="rbxassetid://134506694683787",Lf="rbxassetid://71763376858985",Ft="rbxassetid://135004571760711",Bk="rbxassetid://128965985861678",Dn="rbxassetid://110348980912057"},
        Snowfall={Up="rbxassetid://126062849245092",Rt="rbxassetid://107426974445077",Lf="rbxassetid://99278869992380",Ft="rbxassetid://125017185069120",Bk="rbxassetid://93880674630038",Dn="rbxassetid://87148454178590"},
        Snowfall2={Up="rbxassetid://95084147275471",Rt="rbxassetid://138105402858424",Lf="rbxassetid://137284644473913",Ft="rbxassetid://90021477042795",Bk="rbxassetid://115218132364372",Dn="rbxassetid://112778453716611"},
        Snowglobe={Up="rbxassetid://135664000795769",Rt="rbxassetid://134531548836050",Lf="rbxassetid://110172445228076",Ft="rbxassetid://78449998699868",Bk="rbxassetid://73410321753840",Dn="rbxassetid://127275263042682"},
        Solitude={Up="rbxassetid://103888793794702",Rt="rbxassetid://94744927603341",Lf="rbxassetid://108880510406395",Ft="rbxassetid://84564591187044",Bk="rbxassetid://101432771094258",Dn="rbxassetid://109829288991652"},
        Sorting_Operation={Up="rbxassetid://115038801237016",Rt="rbxassetid://92874217443704",Lf="rbxassetid://136433770262275",Ft="rbxassetid://86132070559175",Bk="rbxassetid://72944775385889",Dn="rbxassetid://108472503075536"},
        Soulbound={Up="rbxassetid://126336981296116",Rt="rbxassetid://74153013470837",Lf="rbxassetid://80596739029240",Ft="rbxassetid://100895490049594",Bk="rbxassetid://89469467362953",Dn="rbxassetid://124659781793026"},
        Spectre={Up="rbxassetid://111089716530102",Rt="rbxassetid://140359011526969",Lf="rbxassetid://116353449728881",Ft="rbxassetid://124463049080144",Bk="rbxassetid://90602659732998",Dn="rbxassetid://97852258288405"},
        Spiderweb={Up="rbxassetid://127650442596811",Rt="rbxassetid://99813279159920",Lf="rbxassetid://106685529536255",Ft="rbxassetid://123549211348898",Bk="rbxassetid://127069582939132",Dn="rbxassetid://137235779482807"},
        Spirit_of_the_Season={Up="rbxassetid://73629202781478",Rt="rbxassetid://118210119057245",Lf="rbxassetid://82740518622457",Ft="rbxassetid://82972773932502",Bk="rbxassetid://127163383659909",Dn="rbxassetid://131180862099497"},
        Stained_Glass={Up="rbxassetid://140356190688475",Rt="rbxassetid://133379321296494",Lf="rbxassetid://80955407293318",Ft="rbxassetid://76210911608060",Bk="rbxassetid://74057287874349",Dn="rbxassetid://89066844502973"},
        Stratus1={Up="rbxassetid://80925853824357",Rt="rbxassetid://92324220981430",Lf="rbxassetid://94527217317594",Ft="rbxassetid://123337886173038",Bk="rbxassetid://90615946451162",Dn="rbxassetid://75834421405010"},
        Subspace={Up="rbxassetid://94807140159597",Rt="rbxassetid://131284324685695",Lf="rbxassetid://122830566598963",Ft="rbxassetid://104528971286225",Bk="rbxassetid://85797675491247",Dn="rbxassetid://123101914829054"},
        Substrate={Up="rbxassetid://80721894771092",Rt="rbxassetid://105721100032639",Lf="rbxassetid://116623261534017",Ft="rbxassetid://85381969239861",Bk="rbxassetid://80356537958379",Dn="rbxassetid://76077642470612"},
        Subzero={Up="rbxassetid://112800994038309",Rt="rbxassetid://132148899165073",Lf="rbxassetid://82978361446479",Ft="rbxassetid://119163370963039",Bk="rbxassetid://82979525303080",Dn="rbxassetid://138494036697632"},
        Summer_Soul={Up="rbxassetid://104594380666782",Rt="rbxassetid://85823484365483",Lf="rbxassetid://110781870058540",Ft="rbxassetid://139904798281863",Bk="rbxassetid://122554935968902",Dn="rbxassetid://90148411736325"},
        Sunset_Plain={Up="rbxassetid://93361062230743",Rt="rbxassetid://118707710216803",Lf="rbxassetid://126528780579974",Ft="rbxassetid://87973100405334",Bk="rbxassetid://78823265427138",Dn="rbxassetid://137426958880904"},
        Superstition={Up="rbxassetid://125857959697828",Rt="rbxassetid://84183586704661",Lf="rbxassetid://116597624838380",Ft="rbxassetid://78787167691925",Bk="rbxassetid://113381753254869",Dn="rbxassetid://103778445777949"},
        Technoblivion={Up="rbxassetid://128677915955843",Rt="rbxassetid://122684869079313",Lf="rbxassetid://120216715804121",Ft="rbxassetid://127832394583049",Bk="rbxassetid://119455248031888",Dn="rbxassetid://122688602170952"},
        Temperate={Up="rbxassetid://103820962757365",Rt="rbxassetid://84090378218851",Lf="rbxassetid://138374841343096",Ft="rbxassetid://101185512155979",Bk="rbxassetid://115935604700747",Dn="rbxassetid://127805578769403"},
        Tenebrous={Up="rbxassetid://131698665262227",Rt="rbxassetid://125211566246699",Lf="rbxassetid://80646047709737",Ft="rbxassetid://106928648213093",Bk="rbxassetid://112593468544956",Dn="rbxassetid://109731457224082"},
        Terminus_Est={Up="rbxassetid://101002226598171",Rt="rbxassetid://126737037609260",Lf="rbxassetid://127950391291489",Ft="rbxassetid://83938954954381",Bk="rbxassetid://97544423536461",Dn="rbxassetid://137545335651438"},
        Test_Site={Up="rbxassetid://128866049849983",Rt="rbxassetid://140601088554888",Lf="rbxassetid://75972413629531",Ft="rbxassetid://115763676276973",Bk="rbxassetid://100504794494055",Dn="rbxassetid://99001637485839"},
        The_Seacoast={Up="rbxassetid://97394510624374",Rt="rbxassetid://115278193132476",Lf="rbxassetid://139673352254304",Ft="rbxassetid://114397838517239",Bk="rbxassetid://113586200568511",Dn="rbxassetid://82249902921609"},
        The_Unknown={Up="rbxassetid://99766920650855",Rt="rbxassetid://114256051084689",Lf="rbxassetid://106242511504352",Ft="rbxassetid://134605237834413",Bk="rbxassetid://80249286771497",Dn="rbxassetid://124889366244980"},
        Thorns={Up="rbxassetid://129372472090129",Rt="rbxassetid://83334529674695",Lf="rbxassetid://130592373973061",Ft="rbxassetid://112548232836873",Bk="rbxassetid://79057599418167",Dn="rbxassetid://93328177621164"},
        Through_the_Fog={Up="rbxassetid://106275786351258",Rt="rbxassetid://110722125416130",Lf="rbxassetid://105849831494919",Ft="rbxassetid://83842796397122",Bk="rbxassetid://95148476009586",Dn="rbxassetid://128599105806679"},
        Tileset={Up="rbxassetid://124075177064188",Rt="rbxassetid://102049446797504",Lf="rbxassetid://123793826057924",Ft="rbxassetid://140123161046837",Bk="rbxassetid://97017814625040",Dn="rbxassetid://109069578635209"},
        Timeless_Sky={Up="rbxassetid://135283147753201",Rt="rbxassetid://121945916638247",Lf="rbxassetid://107332323417914",Ft="rbxassetid://140378076495519",Bk="rbxassetid://100980167097767",Dn="rbxassetid://103386005400567"},
        Title_Screen={Up="rbxassetid://119772764421686",Rt="rbxassetid://113266593484750",Lf="rbxassetid://87558234868445",Ft="rbxassetid://109506086757178",Bk="rbxassetid://118705856466636",Dn="rbxassetid://90461091910422"},
        Torrid_Zone={Up="rbxassetid://121863234491824",Rt="rbxassetid://75288222217410",Lf="rbxassetid://85983798248705",Ft="rbxassetid://120972918055340",Bk="rbxassetid://101376231995481",Dn="rbxassetid://134878439544760"},
        Traversal={Up="rbxassetid://107803107138716",Rt="rbxassetid://123063422570418",Lf="rbxassetid://104342345351775",Ft="rbxassetid://73736779369038",Bk="rbxassetid://104091251049579",Dn="rbxassetid://75198869783890"},
        Undead_Sky={Up="rbxassetid://124035240448145",Rt="rbxassetid://124172652899941",Lf="rbxassetid://91123239009284",Ft="rbxassetid://98817607941040",Bk="rbxassetid://131570755110015",Dn="rbxassetid://83644506043375"},
        Utopia={Up="rbxassetid://130667993174989",Rt="rbxassetid://86830862632715",Lf="rbxassetid://133371480535896",Ft="rbxassetid://105137247624695",Bk="rbxassetid://74343551027851",Dn="rbxassetid://110192998737848"},
        VenomFoil={Up="rbxassetid://124855801591046",Rt="rbxassetid://115090216625978",Lf="rbxassetid://123688313415768",Ft="rbxassetid://112947233115796",Bk="rbxassetid://123499692234350",Dn="rbxassetid://136299689354639"},
        Very_Blue={Up="rbxassetid://74809972380735",Rt="rbxassetid://131798635065630",Lf="rbxassetid://126365048155049",Ft="rbxassetid://139418046180382",Bk="rbxassetid://108715727724100",Dn="rbxassetid://109503855131291"},
        Viridian_Shore={Up="rbxassetid://77476027377440",Rt="rbxassetid://91739342332797",Lf="rbxassetid://109143025186034",Ft="rbxassetid://88415983736428",Bk="rbxassetid://105755456946392",Dn="rbxassetid://91316752702527"},
        Vortex={Up="rbxassetid://116045937427579",Rt="rbxassetid://128591231863844",Lf="rbxassetid://108286511336959",Ft="rbxassetid://128611491692154",Bk="rbxassetid://125016218210857",Dn="rbxassetid://118072008459667"},
        Wallpaper={Up="rbxassetid://113917517882944",Rt="rbxassetid://99728816753172",Lf="rbxassetid://124796841385471",Ft="rbxassetid://136643685066360",Bk="rbxassetid://83175916347223",Dn="rbxassetid://129535985148561"},
        Western_Haze={Up="rbxassetid://105432970334552",Rt="rbxassetid://92045177058177",Lf="rbxassetid://103444130313433",Ft="rbxassetid://86434287626150",Bk="rbxassetid://99839160719568",Dn="rbxassetid://95742862698208"},
        What_Lies_Beyond_the_Trees={Up="rbxassetid://82140050647885",Rt="rbxassetid://128205959036079",Lf="rbxassetid://105211486426146",Ft="rbxassetid://123737823891201",Bk="rbxassetid://121947164053996",Dn="rbxassetid://113846226775177"},
        Wild_West={Up="rbxassetid://87032098293001",Rt="rbxassetid://117359398052773",Lf="rbxassetid://122604640601064",Ft="rbxassetid://106750238859843",Bk="rbxassetid://111544984068501",Dn="rbxassetid://134263674550795"},
        Wingaersheek={Up="rbxassetid://78359832807228",Rt="rbxassetid://111073075612163",Lf="rbxassetid://92998680060140",Ft="rbxassetid://90193683631375",Bk="rbxassetid://114598419159071",Dn="rbxassetid://99270451877857"},
        Winter_Atmosphere_2={Up="rbxassetid://74700431955895",Rt="rbxassetid://121160068241795",Lf="rbxassetid://134511380642302",Ft="rbxassetid://119125633779324",Bk="rbxassetid://111657809236262",Dn="rbxassetid://76522484367354"},
        Winter_Atmosphere1={Up="rbxassetid://91574980988140",Rt="rbxassetid://104197535336429",Lf="rbxassetid://132421294830898",Ft="rbxassetid://96609055788972",Bk="rbxassetid://79590458251309",Dn="rbxassetid://102322145261625"},
        Winter_Day={Up="rbxassetid://132645440880575",Rt="rbxassetid://133782439715579",Lf="rbxassetid://105257399480578",Ft="rbxassetid://95220931821733",Bk="rbxassetid://114315255663271",Dn="rbxassetid://101558296792695"},
        Winter_Night={Up="rbxassetid://101217480346758",Rt="rbxassetid://111144250094221",Lf="rbxassetid://108120567600064",Ft="rbxassetid://119317723805370",Bk="rbxassetid://101235809925931",Dn="rbxassetid://73790381940532"},
        Winter_Scene={Up="rbxassetid://86105149667271",Rt="rbxassetid://106741360463350",Lf="rbxassetid://101665301114377",Ft="rbxassetid://122483533880950",Bk="rbxassetid://84791327424422",Dn="rbxassetid://108122894461136"},
        Winter_Storm={Up="rbxassetid://84634822855545",Rt="rbxassetid://138568623801495",Lf="rbxassetid://73131702893115",Ft="rbxassetid://100106391612523",Bk="rbxassetid://112891312270390",Dn="rbxassetid://132986532267834"},
        Winterness2={Up="rbxassetid://132830884614932",Rt="rbxassetid://76444838120005",Lf="rbxassetid://85568849803850",Ft="rbxassetid://73598639699982",Bk="rbxassetid://103709603934432",Dn="rbxassetid://77557766543337"},
        WiredAllWrong={Up="rbxassetid://84644244515095",Rt="rbxassetid://83465238503057",Lf="rbxassetid://134057960839575",Ft="rbxassetid://76480588402735",Bk="rbxassetid://83485645927302",Dn="rbxassetid://127585864305388"},
        Wispy_Sky={Up="rbxassetid://110847521372147",Rt="rbxassetid://128750195822818",Lf="rbxassetid://104575715984214",Ft="rbxassetid://137631394364179",Bk="rbxassetid://110571369462573",Dn="rbxassetid://111657358850945"},
        Witching_Hour={Up="rbxassetid://125514389745777",Rt="rbxassetid://123400932970275",Lf="rbxassetid://116708139309155",Ft="rbxassetid://135076363348514",Bk="rbxassetid://119674690870569",Dn="rbxassetid://102909710176802"},
        WorldAbove={Up="rbxassetid://83903245191059",Rt="rbxassetid://81171946326449",Lf="rbxassetid://84218502716097",Ft="rbxassetid://133322487976445",Bk="rbxassetid://78921566885237",Dn="rbxassetid://85156704190227"},
        Your_World={Up="rbxassetid://122235153570774",Rt="rbxassetid://126947428036093",Lf="rbxassetid://81964901806245",Ft="rbxassetid://127674810298099",Bk="rbxassetid://123711830741704",Dn="rbxassetid://98472498935029"},
        Sky_Sunset={Up="rbxassetid://1834275027",Rt="rbxassetid://1834274473",Lf="rbxassetid://1834273831",Ft="rbxassetid://1834274132",Bk="rbxassetid://1834274752",Dn="rbxassetid://1010389"},
        Sky_Sunny={Up="rbxassetid://1834229758",Rt="rbxassetid://1834228794",Lf="rbxassetid://1834229297",Ft="rbxassetid://1834229057",Bk="rbxassetid://1834229521",Dn="rbxassetid://1834229889"},
        Sky_Spooky_3={Up="rbxassetid://1834300849",Rt="rbxassetid://1834299629",Lf="rbxassetid://1834300149",Ft="rbxassetid://1834300904",Bk="rbxassetid://1834300604",Dn="rbxassetid://1834301064"},
        Sky_Spooky_2={Up="rbxassetid://1014344",Rt="rbxassetid://1014339",Lf="rbxassetid://1014341",Ft="rbxassetid://1014340",Bk="rbxassetid://1014342",Dn="rbxassetid://1014343"},
        Sky_Spooky_1={Up="rbxassetid://1836617387",Rt="rbxassetid://1836610101",Lf="rbxassetid://1836616965",Ft="rbxassetid://1836610655",Bk="rbxassetid://1836609583",Dn="rbxassetid://1836617859"},
        Sky_Slate_Desert={Up="rbxassetid://1836662216",Rt="rbxassetid://1836658455",Lf="rbxassetid://1836660285",Ft="rbxassetid://1836659589",Bk="rbxassetid://1836661335",Dn="rbxassetid://1836617859"},
        Sky_Skylands={Up="rbxassetid://1836780535",Rt="rbxassetid://1836786715",Lf="rbxassetid://1836781364",Ft="rbxassetid://1836781747",Bk="rbxassetid://1836781025",Dn="rbxassetid://1836787095"},
        Pink_v3={Up="rbxassetid://271077958",Rt="rbxassetid://271042467",Lf="rbxassetid://271042310",Ft="rbxassetid://271042556",Bk="rbxassetid://271042516",Dn="rbxassetid://271077243"},
        Red_Castle={Up="rbxassetid://15832429401",Rt="rbxassetid://15832431198",Lf="rbxassetid://15832430671",Ft="rbxassetid://15832430210",Bk="rbxassetid://15832429892",Dn="rbxassetid://15832430998"},
        RedNight={Up="rbxassetid://401664936",Rt="rbxassetid://401664901",Lf="rbxassetid://401664881",Ft="rbxassetid://401664960",Bk="rbxassetid://401664839",Dn="rbxassetid://401664862"},
        Purple_Night_Sky={Up="rbxassetid://5084576400",Rt="rbxassetid://5103948784",Lf="rbxassetid://5103948542",Ft="rbxassetid://5103949679",Bk="rbxassetid://5084575798",Dn="rbxassetid://5084575916"}
    }

    local skyboxNames = {}
    for name in pairs(skyboxPresets) do
        table.insert(skyboxNames, name)
    end
    table.sort(skyboxNames)

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
                s.Name = "Cryptical_Sky"
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

    Library:Connect(RunService.Heartbeat, function(dt)
        if unloaded or getgenv().CrypticalGen ~= GEN then return end
        if skyboxData.Active and skyboxData.Spin then
            local sky = skyboxData.SkyInstance or Lighting:FindFirstChildOfClass("Sky")
            if sky then
                local spd = skyboxData.SpinSpeed or 20
                skyboxData.CurrentAngle = ((skyboxData.CurrentAngle or 0) + (spd * dt)) % 360
                pcall(function()
                    sky.SkyboxOrientation = Vector3.new(0, skyboxData.CurrentAngle, 0)
                end)
                pcall(function()
                    sky.SkyboxRotation = skyboxData.CurrentAngle
                end)
            end
        end
    end)

    local SkyboxSection = VisualsPage:Section({
        Name = "Skybox",
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
        Items = skyboxNames,
        Default = skyboxNames[1] or "Piss",
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
        Name = "Celestials",
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
        Name = "Ambience",
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

    local initialClockTime = pcall(function() return Lighting.ClockTime end) and Lighting.ClockTime or 14
    AmbienceSection:Slider({
        Name = "Clock Time (Time of Day)",
        Flag = "World_ClockTime",
        Default = math.floor(initialClockTime),
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

    local initialFOV = pcall(function() return Workspace.CurrentCamera.FieldOfView end) and Workspace.CurrentCamera.FieldOfView or 70
    AmbienceSection:Slider({
        Name = "Field of View (FOV)",
        Flag = "Visuals_FOVChanger",
        Default = math.floor(initialFOV),
        Min = 60,
        Max = 120,
        Suffix = "°",
        Callback = function(v)
            pcall(function() Workspace.CurrentCamera.FieldOfView = v end)
        end,
    })

    local AtmosphereFogSection = VisualsPage:Section({
        Name = "Atmosphere",
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

    local RAIN_TEX = "rbxassetid://124528706254337"
    local SPLASH_TEX = "rbxassetid://123240546708836"
    local SNOW_TEX = "rbxassetid://6490035152"

    local _W = {}
    _W.getCol3 = function(val, default)
        if typeof(val) == "Color3" then return val end
        if typeof(val) == "table" then
            if typeof(val.Color) == "Color3" then return val.Color end
            if type(val.Color) == "string" then
                local ok, c = pcall(function() return Color3.fromHex(val.Color) end)
                if ok then return c end
            end
        end
        return default or Color3.fromRGB(255, 255, 255)
    end
    _W.rainSettings = { Rate = 300, Speed = 120, Size = 8, Width = 30, Radius = 100, Splashes = true, RainFogEnd = 1500, RainFogDensity = 30 }
    _W.snowSettings = { Rate = 200, Speed = 25, Size = 3, Radius = 100, SnowFogEnd = 1800, SnowFogDensity = 25 }
    _W.cherrySettings = { MaxPetals = 60, SpawnRate = 0.08, FallSpeed = 1.8, SpawnRadius = 50, FogEnd = 2000, FogDensity = 15 }
    _W.rainRunning, _W.snowRunning, _W.cherryRunning = false, false, false
    _W.originalLightingState = nil
    _W.rainPart, _W.snowPart, _W.cherryPart = nil, nil, nil
    _W.snowEmitter = nil
    _W._rainFollowConn, _W._snowFollowConn, _W._cherryFollowConn = nil, nil, nil
    _W._splashConn = nil
    _W._splashFolder = nil
    _W._rainStreaks = {}
    _W._rainVolFolder = nil

    _W.destroyRainPart = function()
        if _W.rainPart then pcall(function() _W.rainPart:Destroy() end) _W.rainPart = nil end
    end
    _W.destroySnowPart = function()
        if _W.snowPart then pcall(function() _W.snowPart:Destroy() end) _W.snowPart = nil end
    end
    _W.destroyCherryPart = function()
        if _W.cherryPart then pcall(function() _W.cherryPart:Destroy() end) _W.cherryPart = nil end
    end

    _W.saveOriginalLighting = function()
        if _W.originalLightingState then return end
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        _W.originalLightingState = {
            FogColor = Lighting.FogColor, FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd,
            Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
            AtmoData = atmo and { Density = atmo.Density, Offset = atmo.Offset, Color = atmo.Color, Decay = atmo.Decay, Glare = atmo.Glare, Haze = atmo.Haze } or nil
        }
    end

    _W.restoreOriginalLighting = function()
        if not _W.originalLightingState then return end
        Lighting.FogColor = _W.originalLightingState.FogColor
        Lighting.FogStart = _W.originalLightingState.FogStart
        Lighting.FogEnd = _W.originalLightingState.FogEnd
        Lighting.Ambient = _W.originalLightingState.Ambient
        Lighting.OutdoorAmbient = _W.originalLightingState.OutdoorAmbient
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        if _W.originalLightingState.AtmoData then
            if not atmo then atmo = Instance.new("Atmosphere") atmo.Parent = Lighting end
            local d = _W.originalLightingState.AtmoData
            atmo.Density = d.Density atmo.Offset = d.Offset atmo.Color = d.Color
            atmo.Decay = d.Decay atmo.Glare = d.Glare atmo.Haze = d.Haze
        else
            if atmo then atmo:Destroy() end
        end
        _W.originalLightingState = nil
    end

    _W.applyWeatherAtmosphere = function(weatherName)
        _W.saveOriginalLighting()
        local color = Color3.fromRGB(255, 255, 255)
        local density, fogEnd, haze = 0.42, 2000, 3.5
        if weatherName == "Cherry" then
            color = Library.Flags["c_cherry_fog"] and _W.getCol3(Library.Flags["c_cherry_fog"]) or Color3.fromRGB(255, 230, 240)
            density = (Library.Flags["CherryFogDensity"] or 15) / 100
            fogEnd = Library.Flags["CherryFogEnd"] or 2000
            haze = 2.0
        elseif weatherName == "Rain" then
            color = Library.Flags["c_rain_fog"] and _W.getCol3(Library.Flags["c_rain_fog"]) or Color3.fromRGB(150, 160, 170)
            density = (Library.Flags["RainFogDensity"] or 30) / 100
            fogEnd = Library.Flags["RainFogEnd"] or 1500
            haze = 4.0
        elseif weatherName == "Snow" then
            color = Library.Flags["c_snow_fog"] and _W.getCol3(Library.Flags["c_snow_fog"]) or Color3.fromRGB(220, 225, 235)
            density = (Library.Flags["SnowFogDensity"] or 25) / 100
            fogEnd = Library.Flags["SnowFogEnd"] or 1800
            haze = 3.0
        end
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        if not atmo then atmo = Instance.new("Atmosphere") atmo.Parent = Lighting end
        atmo.Name = "CrypticalWeatherAtmo"
        atmo.Color = color
        atmo.Decay = color
        atmo.Density = density
        atmo.Haze = haze
        atmo.Glare = 0.5
        atmo.Offset = 0
        Lighting.FogColor = color
        Lighting.FogStart = 50
        Lighting.FogEnd = fogEnd
    end

    _W._stopRain = function()
        if _W._rainFollowConn then _W._rainFollowConn:Disconnect() _W._rainFollowConn = nil end
        if _W._splashConn then _W._splashConn:Disconnect() _W._splashConn = nil end
        _W.destroyRainPart()
        for _, s in ipairs(_W._rainStreaks) do pcall(function() s.part:Destroy() end) end
        table.clear(_W._rainStreaks)
        if _W._rainVolFolder then pcall(function() _W._rainVolFolder:Destroy() end) _W._rainVolFolder = nil end
        if _W._splashFolder then pcall(function() _W._splashFolder:Destroy() end) _W._splashFolder = nil end
    end

    _W._enableRain = function()
        local cam = Workspace.CurrentCamera
        if not cam then return end
        _W._stopRain()
        _W.applyWeatherAtmosphere("Rain")
        local rate = _W.rainSettings.Rate or 300
        local spd = _W.rainSettings.Speed or 120
        local sz = _W.rainSettings.Size or 8
        local radius = _W.rainSettings.Radius or 100
        local widthPct = (_W.rainSettings.Width or 30) / 100

        local halfX = radius
        local halfZ = radius
        local topY = 45
        local botY = -25
        local span = topY - botY

        local streakLen = sz * 0.9
        local streakWid = streakLen * widthPct
        local count = math.clamp(math.floor(rate), 10, 800)

        _W._rainVolFolder = Instance.new("Folder")
        _W._rainVolFolder.Name = "_RainVolume"
        _W._rainVolFolder.Parent = Workspace

        local baseColor = Library.Flags["c_rain"] and _W.getCol3(Library.Flags["c_rain"]) or Color3.fromRGB(190, 205, 240)
        local camPos = cam.CFrame.Position

        for i = 1, count do
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.CastShadow = false
            part.Transparency = 1
            part.Size = Vector3.new(0.2, 0.2, 0.2)
            part.Parent = _W._rainVolFolder

            local depthScale = 0.45 + math.random() * 1.3

            local bb = Instance.new("BillboardGui")
            bb.Adornee = part
            bb.AlwaysOnTop = false
            bb.LightInfluence = 0
            bb.Size = UDim2.fromScale(streakWid * depthScale, streakLen * depthScale)
            bb.Parent = part

            local img = Instance.new("ImageLabel")
            img.BackgroundTransparency = 1
            img.Size = UDim2.fromScale(1, 1)
            img.Image = RAIN_TEX
            img.ImageColor3 = baseColor
            img.ImageTransparency = 0.25 + math.random() * 0.25
            img.Parent = bb

            local ox = (math.random() * 2 - 1) * halfX
            local oz = (math.random() * 2 - 1) * halfZ
            local oy = botY + math.random() * span
            part.CFrame = CFrame.new(camPos + Vector3.new(ox, oy, oz))

            table.insert(_W._rainStreaks, {
                part = part,
                ox = ox,
                oz = oz,
                y = oy,
                speed = spd * (0.8 + depthScale * 0.4),
            })
        end

        _W._splashFolder = Instance.new("Folder")
        _W._splashFolder.Name = "_RainSplashes"
        _W._splashFolder.Parent = Workspace

        _W._rainFollowConn = RunService.Heartbeat:Connect(function(dt)
            if not _W.rainRunning then return end
            local cpos = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position or Vector3.zero
            for _, s in ipairs(_W._rainStreaks) do
                if not s.part.Parent then continue end
                s.y = s.y - s.speed * dt
                if s.y <= botY then
                    s.y = topY
                    s.ox = (math.random() * 2 - 1) * halfX
                    s.oz = (math.random() * 2 - 1) * halfZ
                end
                s.part.CFrame = CFrame.new(cpos.X + s.ox, cpos.Y + s.y, cpos.Z + s.oz)
            end
        end)

        local splashTimer = 0
        if _W.rainSettings.Splashes ~= false then
            _W._splashConn = RunService.Heartbeat:Connect(function(dt)
                if not _W.rainRunning or not _W._splashFolder or not _W._rainVolFolder then return end
                splashTimer = splashTimer + dt
                if splashTimer < 0.08 then return end
                splashTimer = 0
                local char = Players.LocalPlayer.Character
                local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                if not hrp then return end
                local hrpPos = hrp.Position
                local splashCount = math.clamp(math.floor(rate / 80), 2, 5)

                for i = 1, splashCount do
                    local angle = math.random() * math.pi * 2
                    local dist = math.random() * math.min(radius, 50)
                    local origin = hrpPos + Vector3.new(math.cos(angle) * dist, 30, math.sin(angle) * dist)
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.FilterDescendantsInstances = {char, _W._splashFolder, _W._rainVolFolder}
                    local result = Workspace:Raycast(origin, Vector3.new(0, -60, 0), rayParams)
                    if result and result.Position then
                        local normal = result.Normal or Vector3.new(0, 1, 0)
                        local splashSz = sz * 0.65
                        local splashPart = Instance.new("Part")
                        splashPart.Anchored = true
                        splashPart.CanCollide = false
                        splashPart.CanQuery = false
                        splashPart.CanTouch = false
                        splashPart.CastShadow = false
                        splashPart.Transparency = 1
                        splashPart.Size = Vector3.new(splashSz, 0.05, splashSz)

                        local up = Vector3.new(0, 1, 0)
                        if math.abs(normal:Dot(up)) > 0.99 then
                            splashPart.CFrame = CFrame.new(result.Position + normal * 0.03) * CFrame.Angles(0, math.random() * math.pi * 2, 0)
                        else
                            splashPart.CFrame = CFrame.lookAt(result.Position + normal * 0.03, result.Position + normal * 0.03 + normal) * CFrame.Angles(math.pi / 2, 0, math.random() * math.pi * 2)
                        end
                        splashPart.Parent = _W._splashFolder

                        local decal = Instance.new("Decal")
                        decal.Texture = SPLASH_TEX
                        decal.Color3 = baseColor
                        decal.Face = Enum.NormalId.Top
                        decal.Transparency = 0.15
                        decal.Parent = splashPart

                        task.spawn(function()
                            local t = 0
                            local dur = 0.38
                            while t < dur and splashPart and splashPart.Parent do
                                t = t + RunService.Heartbeat:Wait()
                                local a = math.min(t / dur, 1)
                                local s = splashSz * (0.5 + a * 0.8)
                                splashPart.Size = Vector3.new(s, 0.05, s)
                                decal.Transparency = 0.15 + (a * 0.85)
                            end
                            if splashPart and splashPart.Parent then splashPart:Destroy() end
                        end)
                    end
                end
            end)
        end
    end

    _W.enableRain = function()
        if _W.rainRunning then return end
        _W.rainRunning = true
        _W._enableRain()
    end
    _W.disableRain = function()
        _W.rainRunning = false
        _W._stopRain()
        _W.restoreOriginalLighting()
    end
    _W.refreshRain = function()
        if _W.rainRunning then _W._stopRain() _W._enableRain() end
    end

    _W._stopSnow = function()
        if _W._snowFollowConn then _W._snowFollowConn:Disconnect() _W._snowFollowConn = nil end
        if _W.snowEmitter then pcall(function() _W.snowEmitter:Destroy() end) _W.snowEmitter = nil end
        _W.destroySnowPart()
    end

    _W._enableSnow = function()
        local cam = Workspace.CurrentCamera
        if not cam then return end
        _W._stopSnow()
        _W.applyWeatherAtmosphere("Snow")
        local rate = _W.snowSettings.Rate or 200
        local spd = _W.snowSettings.Speed or 25
        local sz = _W.snowSettings.Size or 3

        _W.snowPart = Instance.new("Part")
        _W.snowPart.Anchored = true
        _W.snowPart.CanCollide = false
        _W.snowPart.CastShadow = false
        _W.snowPart.Transparency = 1
        _W.snowPart.Size = Vector3.new(120, 1, 120)
        _W.snowPart.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 50, 0))
        _W.snowPart.Parent = cam

        local closeEmitter = Instance.new("ParticleEmitter")
        closeEmitter.Name = "_SnowClose"
        closeEmitter.Texture = SNOW_TEX
        closeEmitter.Color = ColorSequence.new(Color3.fromRGB(245, 250, 255))
        closeEmitter.LightEmission = 0.8
        closeEmitter.LightInfluence = 0
        closeEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.7, 0.1),
            NumberSequenceKeypoint.new(1, 1),
        })
        local closeSz = sz * 0.15
        closeEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, closeSz),
            NumberSequenceKeypoint.new(0.5, closeSz * 0.8),
            NumberSequenceKeypoint.new(1, 0),
        })
        closeEmitter.Rate = rate * 0.4
        closeEmitter.Lifetime = NumberRange.new(4, 8)
        closeEmitter.Speed = NumberRange.new(spd * 0.8, spd * 1.2)
        closeEmitter.SpreadAngle = Vector2.new(45, 45)
        closeEmitter.Rotation = NumberRange.new(0, 360)
        closeEmitter.RotSpeed = NumberRange.new(-40, 40)
        closeEmitter.VelocitySpread = 20
        closeEmitter.Acceleration = Vector3.new(8, -6, 4)
        closeEmitter.Drag = 0.5
        closeEmitter.EmissionDirection = Enum.NormalId.Bottom
        closeEmitter.Parent = _W.snowPart
        _W.snowEmitter = closeEmitter

        local midEmitter = Instance.new("ParticleEmitter")
        midEmitter.Name = "_SnowMid"
        midEmitter.Texture = SNOW_TEX
        midEmitter.Color = ColorSequence.new(Color3.fromRGB(240, 246, 255))
        midEmitter.LightEmission = 0.85
        midEmitter.LightInfluence = 0
        midEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(0.7, 0.25),
            NumberSequenceKeypoint.new(1, 1),
        })
        local midSz = sz * 0.08
        midEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, midSz),
            NumberSequenceKeypoint.new(0.5, midSz),
            NumberSequenceKeypoint.new(1, 0),
        })
        midEmitter.Rate = rate * 0.35
        midEmitter.Lifetime = NumberRange.new(6, 10)
        midEmitter.Speed = NumberRange.new(spd * 0.6, spd * 0.9)
        midEmitter.SpreadAngle = Vector2.new(60, 60)
        midEmitter.Rotation = NumberRange.new(0, 360)
        midEmitter.RotSpeed = NumberRange.new(-25, 25)
        midEmitter.VelocitySpread = 30
        midEmitter.Acceleration = Vector3.new(12, -4, 8)
        midEmitter.Drag = 0.3
        midEmitter.EmissionDirection = Enum.NormalId.Bottom
        midEmitter.Parent = _W.snowPart

        local farEmitter = Instance.new("ParticleEmitter")
        farEmitter.Name = "_SnowFar"
        farEmitter.Texture = SNOW_TEX
        farEmitter.Color = ColorSequence.new(Color3.fromRGB(235, 242, 255))
        farEmitter.LightEmission = 0.9
        farEmitter.LightInfluence = 0
        farEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.7, 0.4),
            NumberSequenceKeypoint.new(1, 1),
        })
        local farSz = sz * 0.04
        farEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, farSz),
            NumberSequenceKeypoint.new(0.5, farSz),
            NumberSequenceKeypoint.new(1, 0),
        })
        farEmitter.Rate = rate * 0.5
        farEmitter.Lifetime = NumberRange.new(8, 14)
        farEmitter.Speed = NumberRange.new(spd * 0.4, spd * 0.7)
        farEmitter.SpreadAngle = Vector2.new(90, 90)
        farEmitter.Rotation = NumberRange.new(0, 360)
        farEmitter.RotSpeed = NumberRange.new(-15, 15)
        farEmitter.VelocitySpread = 40
        farEmitter.Acceleration = Vector3.new(15, -3, 10)
        farEmitter.Drag = 0.2
        farEmitter.EmissionDirection = Enum.NormalId.Bottom
        farEmitter.Parent = _W.snowPart

        local windTime = 0
        _W._snowFollowConn = RunService.RenderStepped:Connect(function()
            if not _W.snowRunning or not _W.snowPart then return end
            windTime = windTime + 0.016
            local windX = 8 + math.sin(windTime * 0.3) * 6
            local windZ = 4 + math.cos(windTime * 0.25) * 4
            closeEmitter.Acceleration = Vector3.new(windX, -6, windZ)
            midEmitter.Acceleration = Vector3.new(windX * 1.5, -4, windZ * 1.5)
            farEmitter.Acceleration = Vector3.new(windX * 2, -3, windZ * 2)
            if cam then
                _W.snowPart.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 50, 0))
            end
        end)
    end

    _W.enableSnow = function()
        if _W.snowRunning then return end
        _W.snowRunning = true
        _W._enableSnow()
    end
    _W.disableSnow = function()
        _W.snowRunning = false
        _W._stopSnow()
        _W.restoreOriginalLighting()
    end
    _W.refreshSnow = function()
        if _W.snowRunning then _W._stopSnow() _W._enableSnow() end
    end

    _W._stopCherry = function()
        if _W._cherryFollowConn then _W._cherryFollowConn:Disconnect() _W._cherryFollowConn = nil end
        _W.destroyCherryPart()
    end

    _W._enableCherry = function()
        local cam = Workspace.CurrentCamera
        if not cam then return end
        _W._stopCherry()
        _W.applyWeatherAtmosphere("Cherry")
        _W.cherryPart = Instance.new("Part")
        _W.cherryPart.Anchored = true
        _W.cherryPart.CanCollide = false
        _W.cherryPart.CastShadow = false
        _W.cherryPart.Transparency = 1
        _W.cherryPart.Size = Vector3.new(100, 1, 100)
        _W.cherryPart.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 40, 0))
        _W.cherryPart.Parent = cam

        local pe = Instance.new("ParticleEmitter")
        pe.Name = "CherryPetals"
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 182, 193))
        pe.LightEmission = 0.5
        pe.LightInfluence = 0.2
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(0.5, 0.6),
            NumberSequenceKeypoint.new(1, 0.3),
        })
        pe.Lifetime = NumberRange.new(4, 8)
        pe.Rate = _W.cherrySettings.MaxPetals or 60
        pe.Speed = NumberRange.new(5, 15)
        pe.SpreadAngle = Vector2.new(60, 60)
        pe.Rotation = NumberRange.new(0, 360)
        pe.RotSpeed = NumberRange.new(-50, 50)
        pe.Acceleration = Vector3.new(3, -2, 2)
        pe.EmissionDirection = Enum.NormalId.Bottom
        pe.Parent = _W.cherryPart

        _W._cherryFollowConn = RunService.RenderStepped:Connect(function()
            if not _W.cherryRunning or not _W.cherryPart then return end
            if cam then
                _W.cherryPart.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 40, 0))
            end
        end)
    end

    _W.enableCherry = function()
        if _W.cherryRunning then return end
        _W.cherryRunning = true
        _W._enableCherry()
    end
    _W.disableCherry = function()
        _W.cherryRunning = false
        _W._stopCherry()
        _W.restoreOriginalLighting()
    end

    _W.clearAllWeather = function()
        _W.disableRain()
        _W.disableSnow()
        _W.disableCherry()
    end

    local WeatherSection = VisualsPage:Section({
        Name = "Weather",
        Icon = ICON_SPARKLES,
        Side = 1,
    })
    registerVisualsSubtab("World", WeatherSection)

    local rainToggle, snowToggle, cherryToggle
    local rainRateSlider, rainSpeedSlider, rainSizeSlider, rainWidthSlider, rainAreaSlider, rainSplashToggle
    local snowRateSlider, snowSpeedSlider, snowSizeSlider, snowAreaSlider

    rainToggle = WeatherSection:Toggle({
        Name = "Enable Rain",
        Flag = "World_Rain",
        Default = false,
        Callback = function(val)
            if val then
                if snowToggle then snowToggle:Set(false) end
                if cherryToggle then cherryToggle:Set(false) end
                _W.clearAllWeather()
                _W.enableRain()
            else
                _W.disableRain()
            end
            if rainRateSlider then rainRateSlider:SetVisibility(val) end
            if rainSpeedSlider then rainSpeedSlider:SetVisibility(val) end
            if rainSizeSlider then rainSizeSlider:SetVisibility(val) end
            if rainWidthSlider then rainWidthSlider:SetVisibility(val) end
            if rainAreaSlider then rainAreaSlider:SetVisibility(val) end
            if rainSplashToggle then rainSplashToggle:SetVisibility(val) end
        end,
    })

    rainRateSlider = WeatherSection:Slider({
        Name = "Rain Rate",
        Flag = "World_RainRate",
        Min = 10,
        Max = 800,
        Default = 300,
        Callback = function(v)
            _W.rainSettings.Rate = v
            _W.refreshRain()
        end,
    })

    rainSpeedSlider = WeatherSection:Slider({
        Name = "Rain Speed",
        Flag = "World_RainSpeed",
        Min = 10,
        Max = 300,
        Default = 120,
        Callback = function(v)
            _W.rainSettings.Speed = v
            _W.refreshRain()
        end,
    })

    rainSizeSlider = WeatherSection:Slider({
        Name = "Rain Size",
        Flag = "World_RainSize",
        Min = 1,
        Max = 40,
        Default = 8,
        Callback = function(v)
            _W.rainSettings.Size = v
            _W.refreshRain()
        end,
    })

    rainWidthSlider = WeatherSection:Slider({
        Name = "Rain Width",
        Flag = "World_RainWidth",
        Min = 1,
        Max = 100,
        Default = 30,
        Suffix = "%",
        Callback = function(v)
            _W.rainSettings.Width = v
            _W.refreshRain()
        end,
    })

    rainAreaSlider = WeatherSection:Slider({
        Name = "Rain Radius",
        Flag = "World_RainRadius",
        Min = 10,
        Max = 300,
        Default = 100,
        Callback = function(v)
            _W.rainSettings.Radius = v
            _W.refreshRain()
        end,
    })

    rainSplashToggle = WeatherSection:Toggle({
        Name = "Rain Splashes",
        Flag = "World_RainSplashes",
        Default = true,
        Callback = function(v)
            _W.rainSettings.Splashes = v
            _W.refreshRain()
        end,
    })

    rainRateSlider:SetVisibility(false)
    rainSpeedSlider:SetVisibility(false)
    rainSizeSlider:SetVisibility(false)
    rainWidthSlider:SetVisibility(false)
    rainAreaSlider:SetVisibility(false)
    rainSplashToggle:SetVisibility(false)

    snowToggle = WeatherSection:Toggle({
        Name = "Enable Snow",
        Flag = "World_Snow",
        Default = false,
        Callback = function(val)
            if val then
                if rainToggle then rainToggle:Set(false) end
                if cherryToggle then cherryToggle:Set(false) end
                _W.clearAllWeather()
                _W.enableSnow()
            else
                _W.disableSnow()
            end
            if snowRateSlider then snowRateSlider:SetVisibility(val) end
            if snowSpeedSlider then snowSpeedSlider:SetVisibility(val) end
            if snowSizeSlider then snowSizeSlider:SetVisibility(val) end
            if snowAreaSlider then snowAreaSlider:SetVisibility(val) end
        end,
    })

    snowRateSlider = WeatherSection:Slider({
        Name = "Snow Rate",
        Flag = "World_SnowRate",
        Min = 10,
        Max = 500,
        Default = 200,
        Callback = function(v)
            _W.snowSettings.Rate = v
            _W.refreshSnow()
        end,
    })

    snowSpeedSlider = WeatherSection:Slider({
        Name = "Snow Speed",
        Flag = "World_SnowSpeed",
        Min = 5,
        Max = 150,
        Default = 25,
        Callback = function(v)
            _W.snowSettings.Speed = v
            _W.refreshSnow()
        end,
    })

    snowSizeSlider = WeatherSection:Slider({
        Name = "Snow Size",
        Flag = "World_SnowSize",
        Min = 1,
        Max = 15,
        Default = 3,
        Callback = function(v)
            _W.snowSettings.Size = v
            _W.refreshSnow()
        end,
    })

    snowAreaSlider = WeatherSection:Slider({
        Name = "Snow Radius",
        Flag = "World_SnowRadius",
        Min = 10,
        Max = 300,
        Default = 100,
        Callback = function(v)
            _W.snowSettings.Radius = v
            _W.refreshSnow()
        end,
    })

    snowRateSlider:SetVisibility(false)
    snowSpeedSlider:SetVisibility(false)
    snowSizeSlider:SetVisibility(false)
    snowAreaSlider:SetVisibility(false)

    cherryToggle = WeatherSection:Toggle({
        Name = "Enable Cherry Blossoms",
        Flag = "World_Cherry",
        Default = false,
        Callback = function(val)
            if val then
                if rainToggle then rainToggle:Set(false) end
                if snowToggle then snowToggle:Set(false) end
                _W.clearAllWeather()
                _W.enableCherry()
            else
                _W.disableCherry()
            end
        end,
    })
    local ShadingSection = VisualsPage:Section({
        Name = "Shading",
        Icon = ICON_COLOR,
        Side = 2,
    })
    registerVisualsSubtab("World", ShadingSection)

    local ccEffect, bloomEffect, sunRaysEffect

    ShadingSection:Toggle({
        Name = "Color Correction (Shading)",
        Flag = "World_ColorCorrection",
        Default = false,
        Callback = function(val)
            pcall(function()
                if val then
                    if not ccEffect then
                        ccEffect = Instance.new("ColorCorrectionEffect")
                        ccEffect.Name = "Cryptical_CC"
                        ccEffect.Parent = Lighting
                    end
                    ccEffect.Enabled = true
                else
                    if ccEffect then ccEffect.Enabled = false end
                end
            end)
        end,
    })

    ShadingSection:Slider({
        Name = "Saturation",
        Flag = "World_Saturation",
        Default = 0,
        Min = -1,
        Max = 2,
        Decimals = 2,
        Callback = function(v)
            pcall(function()
                if ccEffect then ccEffect.Saturation = v end
            end)
        end,
    })

    ShadingSection:Slider({
        Name = "Contrast",
        Flag = "World_Contrast",
        Default = 0,
        Min = -1,
        Max = 2,
        Decimals = 2,
        Callback = function(v)
            pcall(function()
                if ccEffect then ccEffect.Contrast = v end
            end)
        end,
    })

    ShadingSection:Toggle({
        Name = "Bloom Effect",
        Flag = "World_Bloom",
        Default = false,
        Callback = function(val)
            pcall(function()
                if val then
                    if not bloomEffect then
                        bloomEffect = Instance.new("BloomEffect")
                        bloomEffect.Name = "Cryptical_Bloom"
                        bloomEffect.Parent = Lighting
                    end
                    bloomEffect.Enabled = true
                else
                    if bloomEffect then bloomEffect.Enabled = false end
                end
            end)
        end,
    })

    ShadingSection:Slider({
        Name = "Bloom Intensity",
        Flag = "World_BloomIntensity",
        Default = 1.0,
        Min = 0.0,
        Max = 5.0,
        Decimals = 1,
        Callback = function(v)
            pcall(function()
                if bloomEffect then bloomEffect.Intensity = v end
            end)
        end,
    })

    ShadingSection:Toggle({
        Name = "Sun Rays Effect",
        Flag = "World_SunRays",
        Default = false,
        Callback = function(val)
            pcall(function()
                if val then
                    if not sunRaysEffect then
                        sunRaysEffect = Instance.new("SunRaysEffect")
                        sunRaysEffect.Name = "Cryptical_SunRays"
                        sunRaysEffect.Parent = Lighting
                    end
                    sunRaysEffect.Enabled = true
                else
                    if sunRaysEffect then sunRaysEffect.Enabled = false end
                end
            end)
        end,
    })

    local WorldMaterialSection = VisualsPage:Section({
        Name = "World Materials",
        Icon = ICON_CUBE,
        Side = 2,
    })
    registerVisualsSubtab("World", WorldMaterialSection)

    local worldMaterialData = {
        Enabled = false,
        Material = "SmoothPlastic",
        ForceAll = false,
        OriginalMaterials = {},
    }

    WorldMaterialSection:Toggle({
        Name = "Enable World Material",
        Flag = "World_MaterialEnabled",
        Default = false,
        Callback = function(val)
            worldMaterialData.Enabled = val
            if not val then
                for part, original in pairs(worldMaterialData.OriginalMaterials) do
                    pcall(function()
                        part.Material = original
                    end)
                end
                worldMaterialData.OriginalMaterials = {}
            end
        end,
    })

    WorldMaterialSection:Dropdown({
        Name = "Material Type",
        Flag = "World_MaterialType",
        Items = {"SmoothPlastic", "Neon", "ForceField", "Glass", "Metal", "Marble", "Granite", "Slate", "Wood", "Ice", "Fabric", "Plastic"},
        Default = "SmoothPlastic",
        Callback = function(val)
            worldMaterialData.Material = val
            if worldMaterialData.Enabled then
                local materialMap = {
                    SmoothPlastic = Enum.Material.SmoothPlastic,
                    Neon = Enum.Material.Neon,
                    ForceField = Enum.Material.ForceField,
                    Glass = Enum.Material.Glass,
                    Metal = Enum.Material.Metal,
                    Marble = Enum.Material.Marble,
                    Granite = Enum.Material.Granite,
                    Slate = Enum.Material.Slate,
                    Wood = Enum.Material.Wood,
                    Ice = Enum.Material.Ice,
                    Fabric = Enum.Material.Fabric,
                    Plastic = Enum.Material.Plastic,
                }
                local targetMaterial = materialMap[val] or Enum.Material.SmoothPlastic
                for part, _ in pairs(worldMaterialData.OriginalMaterials) do
                    pcall(function() part.Material = targetMaterial end)
                end
            end
        end,
    })

    WorldMaterialSection:Toggle({
        Name = "Force All Parts",
        Flag = "World_ForceAllMaterials",
        Default = false,
        Callback = function(val)
            worldMaterialData.ForceAll = val
        end,
    })

    WorldMaterialSection:Button({
        Name = "Apply Material Now",
        Callback = function()
            if not worldMaterialData.Enabled then return end
            
            local materialMap = {
                SmoothPlastic = Enum.Material.SmoothPlastic,
                Neon = Enum.Material.Neon,
                ForceField = Enum.Material.ForceField,
                Glass = Enum.Material.Glass,
                Metal = Enum.Material.Metal,
                Marble = Enum.Material.Marble,
                Granite = Enum.Material.Granite,
                Slate = Enum.Material.Slate,
                Wood = Enum.Material.Wood,
                Ice = Enum.Material.Ice,
                Fabric = Enum.Material.Fabric,
                Plastic = Enum.Material.Plastic,
            }

            local targetMaterial = materialMap[worldMaterialData.Material] or Enum.Material.SmoothPlastic

            local allParts = {}
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                    local isPlayerPart = false
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Character and obj:IsDescendantOf(player.Character) then
                            isPlayerPart = true
                            break
                        end
                    end
                    if not isPlayerPart then
                        table.insert(allParts, obj)
                    end
                end
            end

            task.spawn(function()
                for i, obj in ipairs(allParts) do
                    if not worldMaterialData.OriginalMaterials[obj] then
                        worldMaterialData.OriginalMaterials[obj] = obj.Material
                    end
                    pcall(function() obj.Material = targetMaterial end)
                    if i % 100 == 0 then task.wait() end -- Prevent lag spike
                end
            end)
        end,
    })

    local FullbrightSection = VisualsPage:Section({
        Name = "Fullbright",
        Icon = ICON_SUN,
        Side = 1,
    })
    registerVisualsSubtab("World", FullbrightSection)

    FullbrightSection:Toggle({
        Name = "Fullbright (No Shadows)",
        Flag = "World_Fullbright",
        Default = false,
        Callback = function(val)
            pcall(function()
                Lighting.Brightness = val and 3 or 2
                Lighting.Ambient = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
                Lighting.OutdoorAmbient = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
                
                for _, v in ipairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") then
                        v.Density = val and 0 or v.Density
                    end
                end
            end)
        end,
    })

    FullbrightSection:Toggle({
        Name = "Remove Fog",
        Flag = "World_RemoveFog",
        Default = false,
        Callback = function(val)
            pcall(function()
                for _, v in ipairs(Lighting:GetChildren()) do
                    if v:IsA("Atmosphere") then
                        v.Density = val and 0 or 0.4
                    end
                end
            end)
        end,
    })

    FullbrightSection:Toggle({
        Name = "No Shadows",
        Flag = "World_NoShadows",
        Default = false,
        Callback = function(val)
            pcall(function()
                Lighting.GlobalShadows = not val
            end)
        end,
    })


    local InGameESPHolder = Instance.new("ScreenGui")
    InGameESPHolder.Name = "Cryptical_InGameESP"
    InGameESPHolder.Parent = gethui()
    InGameESPHolder.ResetOnSpawn = false
    InGameESPHolder.DisplayOrder = 1
    InGameESPHolder.IgnoreGuiInset = true
    getgenv().CrypticalPlayerESP = InGameESPHolder

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
        local masterOn = espConfig.MasterEnabled or espConfig.Box or espConfig.Name or espConfig.Health or espConfig.Distance or espConfig.Weapon or espConfig.Tracers or espConfig.Skeleton or espConfig.Chams or espConfig.HeadDot or espConfig.Offscreen
        if not masterOn or unloaded or getgenv().CrypticalGen ~= GEN then
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

        local currentFrameCandidates = {}
        local candidates = getAllTargetCandidates()

        for _, p in ipairs(candidates) do
            local isRealPlayer = (typeof(p) == "Instance" and p:IsA("Player"))
            local isLocal = (isRealPlayer and p == Players.LocalPlayer)

            if not isLocal then
                currentFrameCandidates[p] = true
                local data = playerESPCache[p] or createPlayerESP(p)
                local char = p.Character
                if not char and isRealPlayer then
                    local pFolder = Workspace:FindFirstChild("Players") or Workspace:FindFirstChild("players")
                    if pFolder then
                        char = pFolder:FindFirstChild(p.Name)
                    end
                end

                local passTeam = not espConfig.TeamCheck
                    or not isRealPlayer
                    or (p.Team == nil or Players.LocalPlayer.Team == nil or p.Team ~= Players.LocalPlayer.Team)

                if char and passTeam then
                    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char.PrimaryPart
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

                            if root2d.Z > 0 and (rootOnScreen or topOnScreen or bottomOnScreen or (root2d.X >= -100 and root2d.X <= screenW + 100 and root2d.Y >= -100 and root2d.Y <= screenH + 100)) then
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
                                    local dispName = p.DisplayName or p.Name
                                    data.NameLabel.Visible = true
                                    data.NameLabel.Text = (dispName ~= p.Name) and (dispName .. " (@" .. p.Name .. ")") or p.Name
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

        for cachedP, data in pairs(playerESPCache) do
            if not currentFrameCandidates[cachedP] then
                hidePlayerESP(data)
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

    local AnimChangerSection = MiscPage:Section({
        Name = "Animations",
        Icon = ICON_BOT,
        Side = 1,
    })

    local animPacks = {
        ["Default"] = { Idle1 = 180435571, Idle2 = 180435792, Walk = 180436334, Run = 180436148, Jump = 125750702, Fall = 157931322 },
        ["Mage"] = { Idle1 = 707742142, Idle2 = 707855907, Walk = 707897309, Run = 707861613, Jump = 707853674, Fall = 707829716 },
        ["Ninja"] = { Idle1 = 656117400, Idle2 = 656118341, Walk = 656121766, Run = 656124103, Jump = 656121766, Fall = 656115606 },
        ["Zombie"] = { Idle1 = 616158929, Idle2 = 616160626, Walk = 616168032, Run = 616163682, Jump = 616161997, Fall = 616157476 },
        ["Vampire"] = { Idle1 = 1083445855, Idle2 = 1083450166, Walk = 1083451631, Run = 1083452667, Jump = 1083453712, Fall = 1083443587 },
        ["Toy"] = { Idle1 = 782841498, Idle2 = 782845736, Walk = 782843345, Run = 782842708, Jump = 782847020, Fall = 782843869 },
        ["Knight"] = { Idle1 = 657564596, Idle2 = 657565701, Walk = 657552424, Run = 657555620, Jump = 657553854, Fall = 657563584 }
    }

    local animSettings = {
        Enabled = false,
        Idle = "Default",
        Walk = "Default",
        Run = "Default",
        Jump = "Default",
        Fall = "Default"
    }

    local function updateCharacterAnimations()
        if not animSettings.Enabled then return end
        pcall(function()
            local char = Players.LocalPlayer.Character
            local animate = char and char:FindFirstChild("Animate")
            if not animate then return end

            local idlePack = animPacks[animSettings.Idle]
            if idlePack and animate:FindFirstChild("idle") then
                if animate.idle:FindFirstChild("Animation1") then animate.idle.Animation1.AnimationId = "rbxassetid://" .. idlePack.Idle1 end
                if animate.idle:FindFirstChild("Animation2") then animate.idle.Animation2.AnimationId = "rbxassetid://" .. idlePack.Idle2 end
            end

            local walkPack = animPacks[animSettings.Walk]
            if walkPack and animate:FindFirstChild("walk") and animate.walk:FindFirstChild("WalkAnim") then
                animate.walk.WalkAnim.AnimationId = "rbxassetid://" .. walkPack.Walk
            end

            local runPack = animPacks[animSettings.Run]
            if runPack and animate:FindFirstChild("run") and animate.run:FindFirstChild("RunAnim") then
                animate.run.RunAnim.AnimationId = "rbxassetid://" .. runPack.Run
            end

            local jumpPack = animPacks[animSettings.Jump]
            if jumpPack and animate:FindFirstChild("jump") and animate.jump:FindFirstChild("JumpAnim") then
                animate.jump.JumpAnim.AnimationId = "rbxassetid://" .. jumpPack.Jump
            end

            local fallPack = animPacks[animSettings.Fall]
            if fallPack and animate:FindFirstChild("fall") and animate.fall:FindFirstChild("FallAnim") then
                animate.fall.FallAnim.AnimationId = "rbxassetid://" .. fallPack.Fall
            end
        end)
    end

    local isHeadless = false
    local isKorblox = false

    local function updateCosmeticParts(char)
        char = char or Players.LocalPlayer.Character
        if not char then return end

        pcall(function()
            if isHeadless then
                local head = char:FindFirstChild("Head")
                if head then
                    head.Transparency = 1
                    for _, child in ipairs(head:GetChildren()) do
                        if child:IsA("Decal") or child:IsA("SpecialMesh") then
                            child.Transparency = 1
                        end
                    end
                end
            end

            if isKorblox then
                local rightLegParts = {"RightLeg", "RightLowerLeg", "RightUpperLeg", "RightFoot"}
                for _, partName in ipairs(rightLegParts) do
                    local part = char:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        part.Transparency = 1
                    end
                end
                local rightMesh = char:FindFirstChild("Right Leg")
                if rightMesh and rightMesh:IsA("CharacterMesh") then
                    rightMesh:Destroy()
                end
            end
        end)
    end

    Players.LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid", 5)
        task.wait(0.3)
        updateCharacterAnimations()
        updateCosmeticParts(char)
    end)

    AnimChangerSection:Toggle({
        Name = "Enable Animation Changer",
        Flag = "Visuals_AnimMaster",
        Default = false,
        Callback = function(val)
            animSettings.Enabled = val
            if val then
                updateCharacterAnimations()
            end
        end,
    })

    AnimChangerSection:Dropdown({
        Name = "Idle Animation",
        Flag = "Visuals_AnimIdle",
        Items = {"Default", "Mage", "Ninja", "Zombie", "Vampire", "Toy", "Knight"},
        Default = "Default",
        Callback = function(val)
            animSettings.Idle = val
            updateCharacterAnimations()
        end,
    })

    AnimChangerSection:Dropdown({
        Name = "Walk Animation",
        Flag = "Visuals_AnimWalk",
        Items = {"Default", "Mage", "Ninja", "Zombie", "Vampire", "Toy", "Knight"},
        Default = "Default",
        Callback = function(val)
            animSettings.Walk = val
            updateCharacterAnimations()
        end,
    })

    AnimChangerSection:Dropdown({
        Name = "Run Animation",
        Flag = "Visuals_AnimRun",
        Items = {"Default", "Mage", "Ninja", "Zombie", "Vampire", "Toy", "Knight"},
        Default = "Default",
        Callback = function(val)
            animSettings.Run = val
            updateCharacterAnimations()
        end,
    })

    AnimChangerSection:Dropdown({
        Name = "Jump Animation",
        Flag = "Visuals_AnimJump",
        Items = {"Default", "Mage", "Ninja", "Zombie", "Vampire", "Toy", "Knight"},
        Default = "Default",
        Callback = function(val)
            animSettings.Jump = val
            updateCharacterAnimations()
        end,
    })

    AnimChangerSection:Dropdown({
        Name = "Fall Animation",
        Flag = "Visuals_AnimFall",
        Items = {"Default", "Mage", "Ninja", "Zombie", "Vampire", "Toy", "Knight"},
        Default = "Default",
        Callback = function(val)
            animSettings.Fall = val
            updateCharacterAnimations()
        end,
    })

    AnimChangerSection:Toggle({
        Name = "Headless Horseman",
        Flag = "Visuals_Headless",
        Default = false,
        Callback = function(val)
            isHeadless = val
            updateCosmeticParts()
        end,
    })

    AnimChangerSection:Toggle({
        Name = "Korblox Right Leg",
        Flag = "Visuals_Korblox",
        Default = false,
        Callback = function(val)
            isKorblox = val
            updateCosmeticParts()
        end,
    })

    local SkinChangerSection = MiscPage:Section({
        Name = "Skins",
        Icon = ICON_BOT,
        Side = 1,
    })

    local skinSettings = {
        Enabled = false,
        DoubleBarrel = "Ascension",
        Revolver = "Ascension",
        TacticalShotgun = "Ascension",
        SMG = "Ascension",
        Shotgun = "Ascension",
        Knife = "Beta"
    }

    local handleMap = {
        DB_HANDLE = "DoubleBarrel",
        REV_HANDLE = "Revolver"
    }

    local function prepSkinParts(model, isKnife)
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Anchored = false
                part.Massless = true
            end
            if isKnife and part:IsA("MeshPart") then
                local sa = part:FindFirstChildOfClass("SurfaceAppearance")
                if sa then sa:Destroy() end
                if part.TextureID == "" then
                    local name = part.Name:lower()
                    if name:find("box") or name:find("cube") or name:find("part") or name:find("hit") then
                        part.Transparency = 1
                    end
                end
            end
        end
    end

    local function getWrapSkinModel(weaponName, skinName)
        local wraps = game:GetService("ReplicatedStorage"):FindFirstChild("Wraps")
        if not wraps then return nil end
        local folder = wraps:FindFirstChild("[" .. weaponName .. "]")
        if not folder then return nil end
        return folder:FindFirstChild(skinName)
    end

    local function applyModelOnHolder(holder, skinModel)
        if not holder or not skinModel then return end
        local handle = holder:FindFirstChild("Handle")
        if not (handle and handle:IsA("BasePart")) then return end
        local old = holder:FindFirstChild("SkinModel")
        if old then old:Destroy() end

        local clone = skinModel:Clone()
        clone.Name = "SkinModel"

        local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
        if not primary then return end
        clone.PrimaryPart = primary

        local isKnife = holder.Name:find("Knife") and true or false
        prepSkinParts(clone, isKnife)
        clone.Parent = holder
        clone:PivotTo(handle.CFrame)

        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = handle
                weld.Part1 = part
                weld.Parent = handle
            end
        end
        handle.Transparency = 1
    end

    local function applyToolSkin(tool)
        if not (skinSettings.Enabled and tool and tool:IsA("Tool")) then return end
        local weaponName = tool.Name:match("^%[(.+)%]$")
        if weaponName and skinSettings[weaponName] then
            local skinModel = getWrapSkinModel(weaponName, skinSettings[weaponName])
            if skinModel then applyModelOnHolder(tool, skinModel) end
        elseif tool.Name == "[Knife]" and skinSettings.Knife ~= "" then
            local knives = game:GetService("ReplicatedStorage"):FindFirstChild("Knives")
            if knives then
                local skinModel = knives:FindFirstChild(skinSettings.Knife)
                if skinModel then applyModelOnHolder(tool, skinModel) end
            end
        end
    end

    local function applyHandleSkin(char, handleFolderName)
        if not skinSettings.Enabled then return end
        local weaponName = handleMap[handleFolderName]
        if not weaponName or not skinSettings[weaponName] then return end
        local handleFolder = char:FindFirstChild(handleFolderName)
        if not handleFolder then return end
        local skinModel = getWrapSkinModel(weaponName, skinSettings[weaponName])
        if skinModel then applyModelOnHolder(handleFolder, skinModel) end
    end

    local function applyAllSkins(char)
        if not (skinSettings.Enabled and char) then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then applyToolSkin(tool) end
        end
        for handleFolderName, _ in pairs(handleMap) do
            applyHandleSkin(char, handleFolderName)
        end
    end

    local function connectSkinChar(char)
        if not char then return end
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.defer(function() applyToolSkin(child) end)
            elseif handleMap[child.Name] then
                task.defer(function() applyHandleSkin(char, child.Name) end)
            end
        end)
        applyAllSkins(char)
    end

    Players.LocalPlayer.CharacterAdded:Connect(connectSkinChar)
    if Players.LocalPlayer.Character then connectSkinChar(Players.LocalPlayer.Character) end

    SkinChangerSection:Toggle({
        Name = "Enable Skin Changer",
        Flag = "Misc_SkinChangerEnabled",
        Default = false,
        Callback = function(val)
            skinSettings.Enabled = val
            if val and Players.LocalPlayer.Character then
                applyAllSkins(Players.LocalPlayer.Character)
            end
        end,
    })

    SkinChangerSection:Dropdown({
        Name = "Double Barrel Skin",
        Flag = "Misc_DBSkin",
        Items = {"Ascension", "Default", "Gold", "Vanguard", "Galaxy"},
        Default = "Ascension",
        Callback = function(val)
            skinSettings.DoubleBarrel = val
            if skinSettings.Enabled and Players.LocalPlayer.Character then applyAllSkins(Players.LocalPlayer.Character) end
        end,
    })

    SkinChangerSection:Dropdown({
        Name = "Revolver Skin",
        Flag = "Misc_RevSkin",
        Items = {"Ascension", "Default", "Gold", "Vanguard", "Galaxy"},
        Default = "Ascension",
        Callback = function(val)
            skinSettings.Revolver = val
            if skinSettings.Enabled and Players.LocalPlayer.Character then applyAllSkins(Players.LocalPlayer.Character) end
        end,
    })

    SkinChangerSection:Dropdown({
        Name = "Knife Skin",
        Flag = "Misc_KnifeSkin",
        Items = {"Beta", "Default", "Karambit", "Butterfly"},
        Default = "Beta",
        Callback = function(val)
            skinSettings.Knife = val
            if skinSettings.Enabled and Players.LocalPlayer.Character then applyAllSkins(Players.LocalPlayer.Character) end
        end,
    })

    local MovementSection = MiscPage:Section({
        Name = "Movement",
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
        Name = "Anti-Aim",
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
        Name = "Rage",
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
                    if root.Position.Y < 20000 then
                        miscState.VoidSavedCF = root.CFrame
                    end
                    if not miscState.VoidPlatform then
                        local p = Instance.new("Part")
                        p.Name = "Cryptical_VoidPlatform"
                        p.Size = Vector3.new(30, 2, 30)
                        p.Position = Vector3.new(0, 30000, 0)
                        p.Anchored = true
                        p.CanCollide = true
                        p.Transparency = 1
                        p.Parent = Workspace
                        miscState.VoidPlatform = p
                    end
                    root.CFrame = CFrame.new(0, 30005, 0)
                else
                    if miscState.VoidSavedCF and miscState.VoidSavedCF.Position.Y < 20000 then
                        root.CFrame = miscState.VoidSavedCF
                        miscState.VoidSavedCF = nil
                    else
                        local spawnPos = Workspace:FindFirstChildOfClass("SpawnLocation")
                        if spawnPos then
                            root.CFrame = spawnPos.CFrame + Vector3.new(0, 5, 0)
                        else
                            root.CFrame = CFrame.new(root.Position.X, 10, root.Position.Z)
                        end
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



    local UtilitiesSection = MiscPage:Section({
        Name = "Utilities",
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
                setfpscap(val and (Library.Flags["Misc_MaxFPS"] or 240) or 0)
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
        if unloaded or getgenv().CrypticalGen ~= GEN then return end

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

        if miscState.Spinbot and hum.Health > 0 and not miscState.Fly then
            local mode = miscState.AntiAimMode
            if mode == "Spinbot" then
                spinAngle = (spinAngle + (miscState.SpinSpeed * 30 * dt)) % 360
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
            elseif mode == "Jitter Yaw" then
                local jitter = math.random(-180, 180)
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(jitter), 0)
            elseif mode == "Backwards" then
                local cam = Workspace.CurrentCamera
                if cam then
                    local look = cam.CFrame.LookVector
                    local yaw = math.atan2(-look.X, -look.Z) + math.pi
                    if miscState.YawInverted then yaw = yaw + math.pi end
                    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, yaw, 0)
                end
            elseif mode == "Static Yaw" then
                local yaw = miscState.YawInverted and math.pi or 0
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, yaw, 0)
            elseif mode == "Random Yaw" then
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
            end
        end



        if Library.Flags["Misc_AntiStomp"] and hum and hum.Health < 15 and hum.Health > 0 then
            pcall(function()
                local myChar = Players.LocalPlayer.Character
                if myChar then
                    for _, tool in ipairs(myChar:GetChildren()) do
                        if tool:IsA("Tool") then tool.Parent = Players.LocalPlayer.Backpack end
                    end
                end
            end)
        end
    end)

    Library:Connect(RunService.Stepped, function()
        if unloaded or getgenv().CrypticalGen ~= GEN then return end
        if not miscState.Noclip then return end

        local char = Players.LocalPlayer.Character
        if not char then return end

        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
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
        local tagStyle = CrypticalAPI:GetTagStyle(rawTag)
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
        Name = "Players",
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

    local crypticalTabBtn = Instance.new("TextButton")
    crypticalTabBtn.Name = "CrypticalUsersTab"
    crypticalTabBtn.Parent = subtabContainer
    crypticalTabBtn.Size = UDim2.new(0.5, -4, 1, -6)
    crypticalTabBtn.BackgroundColor3 = Theme.Element
    crypticalTabBtn.BorderSizePixel = 0
    crypticalTabBtn.FontFace = Library.Font
    crypticalTabBtn.Text = "Cryptical Users"
    crypticalTabBtn.TextColor3 = Theme.Text
    crypticalTabBtn.TextSize = 11
    crypticalTabBtn.AutoButtonColor = false
    Library:AddToTheme(crypticalTabBtn, {
        BackgroundColor3 = function() return activeSubtab == "cryptical" and Theme.Accent or Theme.Element end,
        TextColor3 = function() return activeSubtab == "cryptical" and Theme.Background or Theme.Text end
    })

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 6)
    sCorner.Parent = crypticalTabBtn

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
            TweenService:Create(crypticalTabBtn, twInfo, {BackgroundColor3 = inactiveBg, TextColor3 = inactiveTxt}):Play()
        else
            TweenService:Create(crypticalTabBtn, twInfo, {BackgroundColor3 = activeBg, TextColor3 = activeTxt}):Play()
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

    crypticalTabBtn.MouseButton1Click:Connect(function()
        setSubtab("cryptical")
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
        Name = "Target",
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
            targetInfoLabel.Text = "Cryptical Database Registry • Offline / Other Server"
        end

        local tags = selectedTarget.Tags or CrypticalAPI:GetTags(selectedTarget.Name)
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
                getgenv().CrypticalPriorityTarget = selectedTarget.Player
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
            CrypticalAPI:Fetch()
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

                    local pTags = CrypticalAPI:GetTags(p.Name)
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
            for lowerU, uData in pairs(CrypticalAPI.Users) do
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
                    row.Name = "CrypticalUser_" .. rawName
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
                    pStatus.Text = inServerPlayer and "• IN SERVER" or "• CRYPTICAL USER"
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
                emptyLabel.Text = CrypticalAPI.Loaded and "No registered Cryptical users match filter" or "Fetching Cryptical API database..."
                emptyLabel.TextColor3 = Theme.Text
                emptyLabel.TextTransparency = 0.5
                emptyLabel.TextSize = 11
            end
        end
    end

    task.spawn(function()
        while not unloaded and getgenv().CrypticalGen == GEN do
            pcall(refreshPlayerListUI)
            task.wait(2.5)
        end
    end)
end

local hudConfig = {
    Master = false,
    Watermark = false,
    WatermarkType = "Text",
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
        Name = "Themes",
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
        while not unloaded and getgenv().CrypticalGen == GEN do
            if rgbMenuOn then
                local dynamicColor = Color3.fromHSV((tick() * rgbMenuSpeed * 0.35) % 1, 1, 1)
                Library.Theme.Accent = dynamicColor
                Library:ChangeTheme("Accent", dynamicColor)
            end
            task.wait(0.05)
        end
    end)

    local ConfigsSection = SettingsPage:Section({
        Name = "Configs",
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
        Name = "Overlays",
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

    local wmTypeDrop

    OverlaysSection:Toggle({
        Name = "Watermark Overlay",
        Flag = "Overlay_Watermark",
        Default = false,
        Callback = function(val)
            hudConfig.Watermark = val
            if wmTypeDrop then wmTypeDrop:SetVisibility(val) end
            if Library.UpdateOverlays then Library.UpdateOverlays() end
        end,
    })

    wmTypeDrop = OverlaysSection:Dropdown({
        Name = "Watermark Type",
        Flag = "Overlay_WatermarkType",
        Items = {"Text", "Image"},
        Default = "Text",
        Callback = function(val)
            hudConfig.WatermarkType = val
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
        Name = "Menu",
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
        Name = "Open Dex Explorer",
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
            end)
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
    overlayGui.Name = "Cryptical_TacticalHUDOverlays"
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


    local watermarkFrame = Instance.new("Frame")
    watermarkFrame.Name = "WatermarkHUD"
    watermarkFrame.Parent = overlayGui
    watermarkFrame.Size = UDim2.new(0, 0, 0, 48)
    watermarkFrame.AutomaticSize = Enum.AutomaticSize.X
    watermarkFrame.Position = UDim2.new(0, 20, 1, -70)
    watermarkFrame.BackgroundTransparency = 1
    watermarkFrame.BorderSizePixel = 0
    watermarkFrame.ClipsDescendants = false

    local wmPad = Instance.new("UIPadding")
    wmPad.PaddingLeft = UDim.new(0, 0)
    wmPad.PaddingRight = UDim.new(0, 0)
    wmPad.PaddingTop = UDim.new(0, 0)
    wmPad.PaddingBottom = UDim.new(0, 0)
    wmPad.Parent = watermarkFrame

    local wmLabel = Instance.new("TextLabel")
    wmLabel.Name = "WatermarkText"
    wmLabel.Parent = watermarkFrame
    wmLabel.BackgroundTransparency = 1
    wmLabel.FontFace = Library.Font
    wmLabel.Text = "cryptical.net"
    wmLabel.TextColor3 = Theme.Accent or Color3.fromRGB(139, 149, 246)
    wmLabel.TextSize = 26
    wmLabel.Size = UDim2.new(0, 0, 1, 0)
    wmLabel.AutomaticSize = Enum.AutomaticSize.X
    Library:AddToTheme(wmLabel, {TextColor3 = "Accent"})

    local wmGrad = Instance.new("UIGradient")
    wmGrad.Name = "MonoWaveGrad"
    wmGrad.Parent = wmLabel
    wmGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(180, 180, 195)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 180, 195)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
    })

    local wmImage = Instance.new("ImageLabel")
    wmImage.Name = "WatermarkImage"
    wmImage.Parent = watermarkFrame
    wmImage.BackgroundTransparency = 1
    wmImage.Size = UDim2.fromOffset(240, 48)
    wmImage.Image = "rbxassetid://112709740803927"
    wmImage.ScaleType = Enum.ScaleType.Fit
    wmImage.Visible = false

    watermarkFrame.Visible = hudConfig.Master and hudConfig.Watermark
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

    keybindsFrame.Visible = hudConfig.Master and hudConfig.Keybinds
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

    gameDataFrame.Visible = hudConfig.Master and hudConfig.GameData
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
    thName.Text = "No Target Locked"
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
    thUser.Text = "Awaiting target acquisition..."
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
    thHealthText.Text = "0 / 0 HP (0%)"
    thHealthText.TextColor3 = Theme.Text
    thHealthText.TextTransparency = 0.3
    thHealthText.TextSize = 9
    thHealthText.Position = UDim2.new(0, 72, 0, 60)
    thHealthText.Size = UDim2.new(1, -82, 0, 12)
    thHealthText.TextXAlignment = Enum.TextXAlignment.Left
    Library:AddToTheme(thHealthText, {TextColor3 = "Text"})

    targetHudCard.Visible = hudConfig.Master and hudConfig.TargetHUD
    makeDraggable(targetHudCard)

    local function updateOverlaysVisibility()
        local master = (hudConfig.Master ~= false)
        if watermarkFrame then
            watermarkFrame.Visible = master and (hudConfig.Watermark == true)
            local isImage = (hudConfig.WatermarkType == "Image")
            if wmLabel then wmLabel.Visible = not isImage end
            if wmImage then wmImage.Visible = isImage end
        end
        if keybindsFrame then
            keybindsFrame.Visible = master and (hudConfig.Keybinds == true)
        end
        if gameDataFrame then
            gameDataFrame.Visible = master and (hudConfig.GameData == true)
        end
        if targetHudCard then
            targetHudCard.Visible = master and (hudConfig.TargetHUD == true)
        end
    end
    Library.UpdateOverlays = updateOverlaysVisibility
    updateOverlaysVisibility()

    local function refreshKeybindsHUD()
        if not (hudConfig.Master and hudConfig.Keybinds) then return end
        for _, child in ipairs(kbList:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local activeBinds = {}
        for flagName, bindInfo in pairs(Library.Keybinds or {}) do
            local state = Library.Flags[flagName]
            if state == true or (type(state) == "table" and state.Enabled) then
                local keyName = tostring(bindInfo.Key or "None")
                if keyName ~= "None" and keyName ~= "" then
                    table.insert(activeBinds, {Name = flagName:gsub("^[A-Za-z]+_", ""), Key = keyName})
                end
            end
        end

        if #activeBinds == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Parent = kbList
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.FontFace = Library.Font
            emptyLabel.Text = "No active keybinds"
            emptyLabel.TextColor3 = Theme.Text
            emptyLabel.TextTransparency = 0.5
            emptyLabel.TextSize = 10
            emptyLabel.Size = UDim2.new(1, 0, 0, 14)
            emptyLabel.TextXAlignment = Enum.TextXAlignment.Left
        else
            for _, b in ipairs(activeBinds) do
                local row = Instance.new("Frame")
                row.Parent = kbList
                row.BackgroundTransparency = 1
                row.Size = UDim2.new(1, 0, 0, 14)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Parent = row
                nameLbl.BackgroundTransparency = 1
                nameLbl.FontFace = Library.Font
                nameLbl.Text = b.Name
                nameLbl.TextColor3 = Theme.Text
                nameLbl.TextSize = 10
                nameLbl.Size = UDim2.new(0.65, 0, 1, 0)
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left

                local keyLbl = Instance.new("TextLabel")
                keyLbl.Parent = row
                keyLbl.BackgroundTransparency = 1
                keyLbl.FontFace = Library.Font
                keyLbl.Text = "[" .. b.Key .. "]"
                keyLbl.TextColor3 = Theme.Accent
                keyLbl.TextSize = 10
                keyLbl.Size = UDim2.new(0.35, 0, 1, 0)
                keyLbl.TextXAlignment = Enum.TextXAlignment.Right
            end
        end
    end

    local lastAvatarUserId = nil
    local function getActiveTarget()
        local lp = Players.LocalPlayer
        local myChar = lp and lp.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if combatState.AimbotTarget and combatState.AimbotTarget.Parent then
            local p = combatState.AimbotTarget
            local char = p.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                return p, char, hum
            end
        end

        if combatState.SilentTarget and combatState.SilentTarget.Parent then
            local p = combatState.SilentTarget
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
            if hum and hum.Health > 0 then
                return p or { Name = char.Name, DisplayName = char.Name, UserId = 1 }, char, hum
            end
        end

        return nil, nil, nil
    end

    local function refreshTargetHUD()
        if not (hudConfig.Master and hudConfig.TargetHUD) then return end

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
            local toolName = tool and tool.Name or "Holstered"

            local dName = tostring(targetPlayer.DisplayName or targetPlayer.Name or "Unknown")
            local uName = tostring(targetPlayer.Name or "Player")

            thName.Text = dName
            thUser.Text = "@" .. uName .. " • " .. dist .. " studs • [" .. toolName .. "]"
            thHealthText.Text = string.format("%d / %d HP (%d%%)", curHp, maxHp, math.floor(hpRatio * 100))

            TweenService:Create(thHealthFill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(hpRatio, 0, 1, 0),
                BackgroundColor3 = Color3.fromHSV(hpRatio * 0.33, 0.85, 0.95)
            }):Play()

            local uid = targetPlayer.UserId
            if uid and uid ~= lastAvatarUserId then
                lastAvatarUserId = uid
                if tonumber(uid) and tonumber(uid) > 1 then
                    thAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=150&h=150&filters=0"
                else
                    thAvatar.Image = ""
                end
            end
        else
            thName.Text = "No Target Locked"
            thUser.Text = "Awaiting target acquisition..."
            thHealthText.Text = "0 / 0 HP (0%)"
            TweenService:Create(thHealthFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            }):Play()
            if lastAvatarUserId ~= 0 then
                lastAvatarUserId = 0
                thAvatar.Image = ""
            end
        end
    end

    local sessionStartTime = tick()
    task.spawn(function()
        while not unloaded and getgenv().CrypticalGen == GEN do
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

                wmLabel.Text = string.format("cryptical  |  %s  |  %d FPS  |  %d ms  |  %s", userName, fps or 60, pingNum, timeStr)

                gdPlayers.Text = string.format("Players: %d / %d", #Players:GetPlayers(), Players.MaxPlayers)
                gdUptime.Text = "Session: " .. uptimeStr

                refreshKeybindsHUD()
                refreshTargetHUD()
            end)
        end
    end)
end

pcall(function()
    if Window and Window.SetOpen then
        Window:SetOpen(true)
    end
    if Library.Holder and Library.Holder.Instance then
        Library.Holder.Instance.Enabled = true
    end
    if Window and Window.Items and Window.Items["MainFrame"] and Window.Items["MainFrame"].Instance then
        Window.Items["MainFrame"].Instance.Visible = true
    end
    if Window and Window.Pages and #Window.Pages > 0 then
        local activeFound = false
        for _, page in ipairs(Window.Pages) do
            if page.Active then
                activeFound = true
                page:Turn(true)
                break
            end
        end
        if not activeFound then
            Window.Pages[1]:Turn(true)
        end
    end
end)


