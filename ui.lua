if not LPH_OBFUSCATED then
    LPH_JIT = function(...) return ... end
    LPH_JIT_MAX = function(...) return ... end
    LPH_JIT_ULTRA = function(...) return ... end
    LPH_NO_VIRTUALIZE = function(...) return ... end
    LPH_NO_UPVALUES = function(f) return(function(...) return f(...) end) end
    LPH_ENCSTR = function(...) return ... end
    LPH_STRENC = function(...) return ... end
    LPH_HOOK_FIX = function(...) return ... end
    LPH_CRASH = function() return print(debug.traceback()) end
end;

local RunService = game:GetService("RunService")
-- settings (so u dont have to scroll)
local settings = {
    folder_name = "anis private cracked";
    default_accent = Color3.fromRGB(255, 145, 240);
    drag_easying_style = "Quad";
    drag_easying_direction = "Out";
    drag_time = 0.3;
};

local drawing = loadstring(game:HttpGet("https://ani.yt/deadcell/utilities/code/drawing.lua"))();
local tween = loadstring(game:HttpGet("https://ani.yt/deadcell/utilities/code/tween.lua"))() -- shhhh
local signal = loadstring(game:HttpGet('https://ani.yt/Projects/furrydecapitator.rip/assetos/code/signal.lua'))()

-- library
if not isfolder(settings.folder_name) then
    makefolder(settings.folder_name);
    makefolder(settings.folder_name.."/configs");
    makefolder(settings.folder_name.."/assets");
end;
if not isfile(settings.folder_name.."/window_size.txt") then
    writefile(settings.folder_name.."/window_size.txt", "")
end;
local services = setmetatable({}, {
    __index = function(_, k)
        k = (k == "InputService" and "UserInputService") or k
        return game:GetService(k)
    end
})

local utility = {}
local totalunnamedflags = 0

function utility.dragify(main, dragoutline, object, allow_tween)
    local start, objectposition, dragging, currentpos

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            dragoutline.Visible = true
            objectposition = object.Position
        end
    end)

    utility.connect(services.InputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            currentpos = UDim2.new(objectposition.X.Scale, objectposition.X.Offset + (input.Position - start).X, objectposition.Y.Scale, objectposition.Y.Offset + (input.Position - start).Y)
            dragoutline.Position = currentpos
        end
    end)

    utility.connect(services.InputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then 
            dragging = false
            dragoutline.Visible = false
            if allow_tween then
                local pos = tween.new(object, TweenInfo.new(settings.drag_time, Enum.EasingStyle[settings.drag_easying_style], Enum.EasingDirection[settings.drag_easying_direction]), {Position = currentpos})
                pos:Play()
            else
                object.Position = currentpos
            end
        end
    end)
end
function utility.resize(object, background, dragoutline)
    pcall(function()
        local start, objectposition, dragging, currentpos
        object.MouseButton1Down:Connect(function(input)
            dragging = true
            start = input
            dragoutline.Visible = true
            objectsize = background.Size
        end)
        utility.connect(services.InputService.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local MouseLocation = game:GetService("UserInputService"):GetMouseLocation()
                local X = math.clamp(MouseLocation.X - background.AbsolutePosition.X, 500, 9999)
                local Y = math.clamp(MouseLocation.Y - background.AbsolutePosition.Y, 600, 9999)
                currentsize = UDim2.new(0,X,0,Y)
                vector2size = Vector2.new(X,Y)
                dragoutline.Size = currentsize
            end;
        end)
        utility.connect(services.InputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                dragoutline.Visible = false
                background.Size = currentsize
                if isfile(settings.folder_name.."/window_size.txt") then
                    writefile(settings.folder_name.."/window_size.txt", "sizeX=" .. tostring(vector2size.X) .. "\n" .. "sizeY=" .. tostring(vector2size.Y))
                end
            end
        end)
    end)
end

function utility.textlength(str, font, fontsize)
    local text = Drawing.new("Text")
    text.Text = str
    text.Font = font
    text.Size = fontsize

    local textbounds = text.TextBounds
    text:Remove()

    return textbounds
end
function utility.getcenter(sizeX, sizeY)
    return UDim2.new(0.5, math.floor(-(sizeX / 2)), 0.5, math.floor(-(sizeY / 2)))
end
function utility.table(tbl, usemt)
    tbl = tbl or {}

    local oldtbl = table.clone(tbl)
    table.clear(tbl)

    for i, v in next, oldtbl do
        if type(i) == "string" then
            tbl[i:lower()] = v
        else
            tbl[i] = v
        end
    end

    if usemt == true then
        setmetatable(tbl, {
            __index = function(t, k)
                return rawget(t, k:lower()) or rawget(t, k)
            end,

            __newindex = function(t, k, v)
                if type(k) == "string" then
                    rawset(t, k:lower(), v)
                else
                    rawset(t, k, v)
                end
            end
        })
    end

    return tbl
end
function utility.colortotable(color)
    local r, g, b = math.floor(color.R * 255),  math.floor(color.G * 255), math.floor(color.B * 255)
    return {r, g, b}
end
function utility.tabletocolor(tbl)
    return Color3.fromRGB(unpack(tbl))
end
function utility.round(number, float)
    return float * math.floor(number / float)
end
function utility.getrgb(color)
    local r = color.R * 255
    local g = color.G * 255
    local b = color.B * 255

    return r, g, b
end
function utility.changecolor(color, number)
    local r, g, b = utility.getrgb(color)
    r, g, b = math.clamp(r + number, 0, 255), math.clamp(g + number, 0, 255), math.clamp(b + number, 0, 255)
    return Color3.fromRGB(r, g, b)
end
function utility.nextflag()
    totalunnamedflags = totalunnamedflags + 1
    return string.format("%.14g", totalunnamedflags)
end
function utility.rgba(r, g, b, alpha)
    local rgb = Color3.fromRGB(r, g, b)
    local mt = table.clone(getrawmetatable(rgb))
    
    setreadonly(mt, false)
    local old = mt.__index
    
    mt.__index = newcclosure(function(self, key)
        if key:lower() == "a" then
            return alpha
        end
        
        return old(self, key)
    end)
    
    setrawmetatable(rgb, mt)
    
    return rgb
end

local themes = {
    ["Default"] = {
        ["Accent"] = settings.default_accent,
        ["Window Outline Background"] = Color3.fromRGB(39,39,47),
        ["Window Inline Background"] = Color3.fromRGB(23,23,30),
        ["Window Holder Background"] = Color3.fromRGB(32,32,38),
        ["Page Unselected"] = Color3.fromRGB(32,32,38),
        ["Page Selected"] = Color3.fromRGB(55,55,64),
        ["Section Background"] = Color3.fromRGB(27,27,34),
        ["Section Inner Border"] = Color3.fromRGB(50,50,58),
        ["Section Outer Border"] = Color3.fromRGB(19,19,27),
        ["Window Border"] = Color3.fromRGB(58,58,67),
        ["Text"] = Color3.fromRGB(255,255,255),
        ["Risky Text"] = Color3.fromRGB(245, 239, 120),
        ["Object Background"] = Color3.fromRGB(41,41,50)
    };
}

local themeobjects = {}
local library = {drawings = {}, drawing_amount = 0, theme = table.clone(themes.Default),currentcolor = nil, folder = "velocity", flags = {}, open = false, mousestate = services.InputService.MouseIconEnabled, cursor = nil, holder = nil, connections = {}, notifications = {}};
library.utility = utility

function utility.outline(obj, color, zin, ignore)
    local outline = drawing:new("Square")
    if not ignore then
        table.insert(library.drawings, outline)
    end
    library.drawing_amount = library.drawing_amount + 1
    outline.Parent = obj
    outline.Size = UDim2.new(1, 2, 1, 2)
    outline.Position = UDim2.new(0, -1, 0, -1)
    outline.ZIndex = zin or obj.ZIndex - 1

    if typeof(color) == "Color3" then
        outline.Color = color
    else
        outline.Color = library.theme[color]
        themeobjects[outline] = color
    end

    outline.Parent = obj
    outline.Filled = false
    outline.Thickness = 1

    return outline
end

function utility.create(class, properties, ignore)
    local obj = drawing:new(class)
    if not ignore then
        table.insert(library.drawings, obj)
    end
    library.drawing_amount = library.drawing_amount + 1
    for prop, v in next, properties do
        if prop == "Theme" then
            themeobjects[obj] = v
            obj.Color = library.theme[v]
        else
            obj[prop] = v
        end
    end

    return obj
end

function utility.changeobjecttheme(object, color)
    themeobjects[object] = color
    object.Color = library.theme[color]
end

function utility.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(library.connections, connection)

    return connection
end

function utility.disconnect(connection)
    local index = table.find(library.connections, connection)
    connection:Disconnect()

    if index then
        table.remove(library.connections, index)
    end
end

function utility.hextorgb(hex)
    return Color3.fromRGB(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x"..hex:sub(5, 6)))
end

local accentobjs = {}

local flags = {}

local configignores = {}

function library:ConfigIgnore(flag)
    table.insert(configignores, flag)
end

local visValues = {};

function library:SetOpen(bool)
    if typeof(bool) == 'boolean' then
        self.open = bool;

        task.spawn(function()
            if not bool then
                task.wait(.1);
            end
            self.holder.Visible = bool;
        end);

        local ContextActionService = game:GetService("ContextActionService");
        if bool then  
         local ContextActionService = game:GetService("ContextActionService")
            ContextActionService:BindAction(
                "Scrolling",
                function ()
                    return Enum.ContextActionResult.Sink
                end,
                false,
                Enum.UserInputType.MouseWheel
            );
            ContextActionService:BindAction(
                "Input",
                function()
                    return Enum.ContextActionResult.Sink
                end,
                false,
                Enum.UserInputType.MouseButton1
            );
        else
            ContextActionService:UnbindAction("Scrolling");
            ContextActionService:UnbindAction("Input");
        end;

        for _,v in next, library.drawings do
            if v.Transparency ~= 0 then
                task.spawn(function()
                    if bool then
                        local fadein = tween.new(v, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = visValues[v]})
                        fadein:Play()
                    else
                        local fadeout = tween.new(v, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = .05})
                        fadeout:Play()
                        visValues[v] = v.Transparency;
                    end
                end)
            end
        end

    end
end
function library:ChangeThemeOption(option, color)
    self.theme[option] = color

    for obj, theme in next, themeobjects do
        if rawget(obj, "exists") == true and theme == option then
            obj.Color = color
        end
    end
end
function library:SetTheme(theme)
    self.currenttheme = theme

    self.theme = table.clone(theme)

    for object, color in next, themeobjects do
        if rawget(object, "exists") == true then
            object.Color = self.theme[color]
        end
    end

end
local notifications = {};
local notificationAmount = 0
-- // notify 
function library.notify(message, time, color)
    time = time or 5

    local notification = {};

    library.notifications[notification] = true

    do
        local objs = notification;
        local z = 10;

        notification.holder = utility.create('Square', {
            Position = UDim2.new(0, 0, 0, 75);
            Transparency = 0;
            Thickness = 1;
        }, true)
        
        notification.background = utility.create('Square', {
            Size = UDim2.new(1,0,1,0);
            Position = UDim2.new(0, -500, 0, 0);
            Parent = notification.holder;
            Color = Color3.fromRGB(13,13,13);
            ZIndex = z;
            Thickness = 1;
            Filled = true;
        }, true)

        notification.border1 = utility.create('Square', {
            Size = UDim2.new(1,2,1,2);
            Position = UDim2.new(0,-1,0,-1);
            Color = Color3.fromRGB(50,50,50);
            Parent = notification.background;
            ZIndex = z-1;
            Thickness = 1;
            Filled = true;
        }, true)

        objs.border2 = utility.create('Square', {
            Size = UDim2.new(1,2,1,2);
            Position = UDim2.new(0,-1,0,-1);
            Color = Color3.fromRGB(0,0,0);
            Parent = objs.border1;
            ZIndex = z-2;
            Thickness = 1;
            Filled = true;
        }, true)

        notification.accentBar = utility.create('Square',{
            Size = UDim2.new(0,1,1,1);
            Position = UDim2.new(0,-1,0,0);
            Parent = notification.background;
            Theme = color == nil and 'Accent' or '';
            ZIndex = z+5;
            Thickness = 1;
            Filled = true;
        }, true)

        notification.accentBottomBar = utility.create('Square',{
            Size = UDim2.new(0,0,0,1);
            Position = UDim2.new(0,0,1,0);
            Parent = notification.background;
            Theme = color == nil and 'Accent' or '';
            ZIndex = z+5;
            Thickness = 1;
            Filled = true;
        }, true)

        notification.text = utility.create('Text', {
            Position = UDim2.new(0,5,0,2);
            Theme = 'Text';
            Text = message;
            Outline = true;
            Font = 2;
            Size = 13;
            ZIndex = z+4;
            Parent = notification.background;
        }, true)

        if color then
            notification.accentBar.Color = color;
        end

    end

    function notification:remove()
        self.holder:Remove();
        library.notifications[notification] = nil;
        library.update_notifications()
    end

    task.spawn(function()
        library.update_notifications();
        notification.background.Size = UDim2.new(0, notification.text.TextBounds.X + 10, 0, 19)
        local sizetween = tween.new(notification.accentBottomBar, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0, 1)})
        sizetween:Play()
        local postween = tween.new(notification.background, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)})
        postween:Play()
        task.wait(time);
        library.update_notifications2(notification)
        task.wait(1.2)
        notification:remove()
    end)

    return notification
end

function library.update_notifications()
    local i = 0
    for v in next, library.notifications do
        local tween = tween.new(v.holder, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,20,0, 75 + (i * 30))})
        tween:Play()
        i = i + 1
    end
end

function library.update_notifications2(drawing) -- i hate this i hate this...
    local tween = tween.new(drawing.background, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, -(drawing.background.Size.X.Offset + 10), 0, drawing.background.Position.Y)})
    tween:Play()

    for i,v in pairs(drawing) do
        if type(v) == "table" then
            local tween = tween.new(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0})
            tween:Play()
        end
    end
end

local tooltip_objects = {};
local tooltip_in_use = false;
do  
    local z = 10;
    tooltip_objects.holder = utility.create('Square', {
        Position = UDim2.new(0, 0, 0, 75);
        Transparency = 0;
        Thickness = 1;
    })
    
    tooltip_objects.background = utility.create('Square', {
        Size = UDim2.new(1,0,1,0);
        Position = UDim2.new(0, -500, 0, 0);
        Parent = tooltip_objects.holder;
        Color = Color3.fromRGB(13,13,13);
        ZIndex = z;
        Thickness = 1;
        Filled = true;
    })

    tooltip_objects.border1 = utility.create('Square', {
        Size = UDim2.new(1,2,1,2);
        Position = UDim2.new(0,-1,0,-1);
        Color = Color3.fromRGB(50,50,50);
        Parent = tooltip_objects.background;
        ZIndex = z-1;
        Thickness = 1;
        Filled = true;
    })

    tooltip_objects.border2 = utility.create('Square', {
        Size = UDim2.new(1,2,1,2);
        Position = UDim2.new(0,-1,0,-1);
        Color = Color3.fromRGB(0,0,0);
        Parent = tooltip_objects.border1;
        ZIndex = z-2;
        Thickness = 1;
        Filled = true;
    })

    tooltip_objects.accentBar = utility.create('Square',{
        Size = UDim2.new(0,1,1,1);
        Position = UDim2.new(0,-1,0,0);
        Parent = tooltip_objects.background;
        Theme = color == nil and 'Accent' or '';
        ZIndex = z+5;
        Thickness = 1;
        Filled = true;
    })

    tooltip_objects.text = utility.create('Text', {
        Position = UDim2.new(0,5,0,2);
        Theme = 'Text';
        Text = "";
        Outline = true;
        Font = 2;
        Size = 13;
        ZIndex = z+4;
        Parent = tooltip_objects.background;
    })
end;

-- // Function
function tooltip(options, text, obj)
    obj.MouseEnter:Connect(function()
        tooltip_objects.holder.Visible = (options.tooltip == '' or options.tooltip == nil) or (options.ToolTip == '' or options.ToolTip == nil) or (text == '' or text == nil) and false or true;
        tooltip_objects.text.Position = UDim2.new(0,3,0,0)
        tooltip_objects.text.Text = options.tip_text or options.Tip_Text or '';
        tooltip_in_use = obj;
    end);
    obj.MouseLeave:Connect(function()
        if tooltip_in_use == obj then
            tooltip_in_use = nil;
            tooltip_objects.holder.Visible = false;
        end;
    end);
end;

-- // Tooltip connection
utility.connect(services.InputService.InputChanged, function(input)
    if tooltip_in_use then
        local Position = services.InputService:GetMouseLocation();
        tooltip_objects.holder.Position = UDim2.new(0,Position.X + 525,0,Position.Y)
        tooltip_objects.holder.Size = UDim2.new(0,tooltip_objects.text.TextBounds.X + 6 , 0, tooltip_objects.text.TextBounds.Y + 2)
    end
end)

-- ui functions
local keys = {
    [Enum.KeyCode.LeftShift] = "LeftShift",
    [Enum.KeyCode.RightShift] = "RightShift",
    [Enum.KeyCode.LeftControl] = "LeftControl",
    [Enum.KeyCode.RightControl] = "RightControl",
    [Enum.KeyCode.LeftAlt] = "LeftAlt",
    [Enum.KeyCode.RightAlt] = "RightAlt",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Numpad1",
    [Enum.KeyCode.KeypadTwo] = "Numpad2",
    [Enum.KeyCode.KeypadThree] = "Numpad3",
    [Enum.KeyCode.KeypadFour] = "Numpad4",
    [Enum.KeyCode.KeypadFive] = "Numpad5",
    [Enum.KeyCode.KeypadSix] = "Numpad6",
    [Enum.KeyCode.KeypadSeven] = "Numpad7",
    [Enum.KeyCode.KeypadEight] = "Numpad8",
    [Enum.KeyCode.KeypadNine] = "Numpad9",
    [Enum.KeyCode.KeypadZero] = "Numpad0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3"
}
local allowedcharacters = {}
local shiftcharacters = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    ["["] = "{",
    ["\\"] = "|",
    [";"] = ":",
    ["'"] = "\"",
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["`"] = "~"
}
for i = 32, 126 do
    table.insert(allowedcharacters, utf8.char(i))
end
local pickers = {}

function library.object_colorpicker(default, defaultalpha, parent, count, flag, callback, offset)
    local icon = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Color = default,
        Parent = parent,
        Transparency = 1,
        Size = UDim2.new(0, 17, 0, 9),
        Position = UDim2.new(1, -17 - (count * 17) - (count * 6), 0, 4 + offset),
        ZIndex = 8
    })

    local outline = utility.outline(icon, Color3.fromRGB(50,50,50))
    utility.outline(outline, Color3.fromRGB(0,0,0))

    local window = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = icon,
        Color = Color3.fromRGB(13,13,13),
        Size = UDim2.new(0, 205, 0, 200),
        Visible = false,
        Position = UDim2.new(1, -185 + (count * 20) + (count * 6), 1, 6),
        ZIndex = 20
    })

    table.insert(pickers, window)

    local outline1 = utility.outline(window, Color3.fromRGB(50,50,50))
    utility.outline(outline1, Color3.fromRGB(0,0,0))

    local saturation = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Color = default,
        Size = UDim2.new(0, 154, 0, 150),
        Position = UDim2.new(0, 6, 0, 6),
        ZIndex = 24
    })

    utility.outline(saturation, Color3.fromRGB(0,0,0))

    local saturationpicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = saturation,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 2, 0, 2),
        ZIndex = 26
    })

    utility.outline(saturationpicker, Color3.fromRGB(0, 0, 0))

    local hueframe = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Size = UDim2.new(0,15, 0, 150),
        Position = UDim2.new(0, 165, 0, 6),
        ZIndex = 24
    })

    utility.outline(hueframe, Color3.fromRGB(0,0,0))

    local huepicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = hueframe,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1,0,0,1),
        ZIndex = 26
    })

    utility.outline(huepicker, Color3.fromRGB(0, 0, 0))

    local alphaframe = utility.create("Square", {
        Filled = true,
        Thickness = 1,
        Size = UDim2.new(0, 15, 0, 150),
        Position = UDim2.new(1, -20, 0, 6),
        ZIndex = 26,
        Parent = window
    })

    utility.outline(alphaframe, Color3.fromRGB(0,0,0))

    local alphapicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = alphaframe,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 27
    })

    utility.outline(alphapicker, Color3.fromRGB(0,0,0))

    local rgbinput = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Color = Color3.fromRGB(13,13,13),
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.new(0, 6, 0, 160),
        ZIndex = 24,
        Parent = window
    })

    local outline2 = utility.outline(rgbinput, Color3.fromRGB(50,50,50))
    utility.outline(outline2, Color3.fromRGB(0,0,0))

    local text = utility.create("Text", {
        Text = string.format("%s, %s, %s", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, 0),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = rgbinput
    })

    local copy = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Color = Color3.fromRGB(13,13,13),
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0, 6, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    local outline3 = utility.outline(copy, Color3.fromRGB(50,50,50))
    utility.outline(outline3, Color3.fromRGB(0,0,0))

    utility.create("Text", {
        Text = "copy",
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = copy
    })

    local paste = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Color = Color3.fromRGB(13,13,13),
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0.5, 15, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    utility.create("Text", {
        Text = "paste",
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = paste
    })

    local outline4 = utility.outline(paste, Color3.fromRGB(50,50,50))
    utility.outline(outline4, Color3.fromRGB(0,0,0))

    local mouseover = false

    local hue, sat, val = default:ToHSV()
    local hsv = default:ToHSV()
    local alpha = defaultalpha
    local oldcolor = hsv

    local function set(color, a, nopos, setcolor)
        if type(color) == "table" then
            a = color.alpha
            color = Color3.fromHex(color.color)
        end

        if type(color) == "string" then
            color = Color3.fromHex(color)
        end

        local oldcolor = hsv
        local oldalpha = alpha

        hue, sat, val = color:ToHSV()
        alpha = a or 1
        hsv = Color3.fromHSV(hue, sat, val)

        if hsv ~= oldcolor or alpha ~= oldalpha then
            icon.Color = hsv
            alphaframe.Color = hsv

            if not nopos then
                saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)), 0, (math.clamp((1 - val) * saturation.AbsoluteSize.Y, 0, saturation.AbsoluteSize.Y - 2)))
                huepicker.Position = UDim2.new(0, math.clamp(hue * hueframe.AbsoluteSize.X, 0, hueframe.AbsoluteSize.X - 2), 0, 0)
                alphapicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - alpha) * alphaframe.AbsoluteSize.Y, 0, alphaframe.AbsoluteSize.Y - 2))
                if setcolor then
                    saturation.Color = hsv
                end
            end

            text.Text = string.format("%s, %s, %s", math.round(hsv.R * 255), math.round(hsv.G * 255), math.round(hsv.B * 255))

            if flag then 
                library.flags[flag] = utility.rgba(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
            end

            callback(utility.rgba(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))

        end
    end

    utility.connect(copy.MouseButton1Click, function()
        library.currentcolor = hsv
    end)

    utility.connect(paste.MouseButton1Click, function()
        if library.currentcolor ~= nil then
            set(library.currentcolor, false, true)
        end;
    end)

    flags[flag] = set

    set(default, defaultalpha)

    local defhue, _, _ = default:ToHSV()

    local curhuesizey = defhue

    local function updatesatval(input, set_callback)
        local sizeX = math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
        local sizeY = 1 - math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) + 36) / saturation.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y) * saturation.AbsoluteSize.Y + 36, 0, saturation.AbsoluteSize.Y - 2)
        local posX = math.clamp(((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X) * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)

        saturationpicker.Position = UDim2.new(0, posX, 0, posY)

        if set_callback then
            set(Color3.fromHSV(curhuesizey or hue, sizeX, sizeY), alpha or defaultalpha, true, false)
        end
    end

    local slidingsaturation = false

    saturation.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidingsaturation = true
            updatesatval(input)
        end
    end)

    saturation.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidingsaturation = false
            updatesatval(input, true)
        end
    end)

    local slidinghue = false

    local function updatehue(input, set_callback)
        local sizeY = 1 - math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) + 36) / hueframe.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y + 36, 0, hueframe.AbsoluteSize.Y - 2)

        huepicker.Position = UDim2.new(0, 0, 0, posY)
        saturation.Color = Color3.fromHSV(sizeY, 1, 1)
        curhuesizey = sizeY
        if set_callback then
           set(Color3.fromHSV(sizeY, sat, val), alpha or defaultalpha, true, true)
        end
    end

    hueframe.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidinghue = true
            updatehue(input)
        end
    end)

    hueframe.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidinghue = false
            updatehue(input, true)
        end
    end)

    local slidingalpha = false

    local function updatealpha(input, set_callback)
        local sizeY = 1 - math.clamp(((input.Position.Y - alphaframe.AbsolutePosition.Y) + 36) / alphaframe.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - alphaframe.AbsolutePosition.Y) / alphaframe.AbsoluteSize.Y) * alphaframe.AbsoluteSize.Y + 36, 0, alphaframe.AbsoluteSize.Y - 2)

        alphapicker.Position = UDim2.new(0, 0, 0, posY)
        if set_callback then
           set(Color3.fromHSV(curhuesizey, sat, val), sizeY, true)
        end
    end

    alphaframe.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidingalpha = true
            updatealpha(input)
        end
    end)

    alphaframe.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidingalpha = false
            updatealpha(input, true)
        end
    end)

    utility.connect(services.InputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if slidingalpha then
                updatealpha(input)
            end

            if slidinghue then
                updatehue(input)
            end

            if slidingsaturation then
                updatesatval(input)
            end
        end
    end)

    icon.MouseButton1Click:Connect(function()
        for _, picker in next, pickers do
            if picker ~= window then
                picker.Visible = false
            end
        end

        window.Visible = not window.Visible

        if slidinghue then
            slidinghue = false
        end

        if slidingsaturation then
            slidingsaturation = false
        end

        if slidingalpha then
            slidingalpha = false
        end
    end)

    local colorpickertypes = {}

    function colorpickertypes:set(color, alpha)
        set(color)
        updatealpha(alpha)
    end

    return colorpickertypes, window
end
function library.object_textbox(box, text, callback, finishedcallback)
    box.MouseButton1Click:Connect(function()
        services.ContextActionService:BindActionAtPriority("disablekeyboard", function() return Enum.ContextActionResult.Sink end, false, 3000, Enum.UserInputType.Keyboard)

        local connection
        local backspaceconnection

        local keyqueue = 0

        if not connection then
            connection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode ~= Enum.KeyCode.Backspace then
                        local str = services.InputService:GetStringForKeyCode(input.KeyCode)

                        if table.find(allowedcharacters, str) then
                            keyqueue = keyqueue + 1
                            local currentqueue = keyqueue

                            if not services.InputService:IsKeyDown(Enum.KeyCode.RightShift) and not services.InputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                text.Text = text.Text .. str:lower()
                                callback(text.Text)

                                local ended = false

                                coroutine.wrap(function()
                                    task.wait(0.5)

                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. str:lower()
                                        callback(text.Text)

                                        task.wait(0.02)
                                    end
                                end)()
                            else
                                text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                callback(text.Text)

                                coroutine.wrap(function()
                                    task.wait(0.5)

                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                        callback(text.Text)

                                        task.wait(0.02)
                                    end
                                end)()
                            end
                        end
                    end

                    if input.KeyCode == Enum.KeyCode.Return then
                        services.ContextActionService:UnbindAction("disablekeyboard")
                        utility.disconnect(backspaceconnection)
                        utility.disconnect(connection)
                        finishedcallback(text.Text)
                    end
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    services.ContextActionService:UnbindAction("disablekeyboard")
                    utility.disconnect(backspaceconnection)
                    utility.disconnect(connection)
                    finishedcallback(text.Text)
                end
            end)

            local backspacequeue = 0

            backspaceconnection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Backspace then
                    backspacequeue = backspacequeue + 1

                    text.Text = text.Text:sub(1, -2)
                    callback(text.Text)

                    local currentqueue = backspacequeue

                    coroutine.wrap(function()
                        task.wait(0.5)

                        if backspacequeue == currentqueue then
                            while services.InputService:IsKeyDown(Enum.KeyCode.Backspace) do
                                text.Text = text.Text:sub(1, -2)
                                callback(text.Text)

                                task.wait(0.02)
                            end
                        end
                    end)()
                end
            end)
        end
    end)
end
function library.object_dropdown(holder, content, flag, callback, default, max, scrollable, scrollingmax, section)
    local dropdown = utility.create("Square", {
        Filled = true,
        Visible = true,
        Thickness = 1,
        Color = Color3.fromRGB(13,13,13),
        Size = UDim2.new(0, 100, 0, 15),
        Position = UDim2.new(0, 0, 0,0),
        ZIndex = 7,
        Parent = holder
    })

    local outline = utility.outline(dropdown, Color3.fromRGB(50,50,50), 7)
    utility.outline(outline, Color3.fromRGB(0,0,0), 7)

    local value = utility.create("Text", {
        Text = "",
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0, 2, 0, 0),
        Theme = "Text",
        ZIndex = 9,
        Outline = false,
        Parent = dropdown
    })

    local contentframe = utility.create("Square", {
        Filled = true,
        Visible = false,
        Thickness = 1,
        Color = Color3.fromRGB(13,13,13),
        Size = UDim2.new(1,0,0,0),
        Position = UDim2.new(0, 0, 1, 3),
        ZIndex = 12,
        Parent = dropdown
    })

    local outline1 = utility.outline(contentframe, Color3.fromRGB(50,50,50))
    utility.outline(outline1, Color3.fromRGB(0,0,0))

    local contentholder = utility.create("Square", {
        Transparency = 0,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        Parent = contentframe
    })

    if scrollable then
        contentholder:MakeScrollable()
    end

    contentholder:AddListLayout(3)

    local mouseover = false

    local opened = false

    if not islist then
        dropdown.MouseButton1Click:Connect(function()
            opened = not opened
            contentframe.Visible = opened
            icon.Data = opened
        end)
    end

    local optioninstances = {}
    local count = 0
    local countindex = {}

    local function createoption(name)
        optioninstances[name] = {}

        countindex[name] = count + 1

        local button = utility.create("Square", {
            Filled = true,
            Transparency = 0,
            Thickness = 1,
            Size = UDim2.new(1, 0, 0, 16),
            ZIndex = 14,
            Parent = contentholder
        })

        optioninstances[name].button = button

        local title = utility.create("Text", {
            Text = name,
            Font = Drawing.Fonts.Plex,
            Size = 13,
            Position = UDim2.new(0, 8, 0, 1),
            Theme = "Text",
            ZIndex = 15,
            Outline = true,
            Parent = button
        })

        optioninstances[name].text = title

        if scrollable then
            if count < scrollingmax then
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end
        else
            contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
        end

        count = count + 1

        return button, title
    end

    local chosen = max and {}

    local function handleoptionclick(option, button, text)
        button.MouseButton1Click:Connect(function()
            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    utility.changeobjecttheme(text, "Text")

                    library.flags[flag] = chosen
                    callback(chosen)
                else
                    if #chosen == max then
                        utility.changeobjecttheme(optioninstances[chosen[1]].text, "Text")

                        table.remove(chosen, 1)
                    end

                    table.insert(chosen, option)

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    utility.changeobjecttheme(text, "Accent")

                    library.flags[flag] = chosen
                    callback(chosen)
                end
            else
                for opt, tbl in next, optioninstances do
                    if opt ~= option then
                        utility.changeobjecttheme(tbl.text, "Text")
                    end
                end

                chosen = option

                value.Text = option

                utility.changeobjecttheme(text, "Accent")

                library.flags[flag] = option
                callback(option)

            end
        end)
    end

    local function createoptions(tbl)
        for _, option in next, tbl do
            local button, text = createoption(option)
            handleoptionclick(option, button, text)
        end
    end

    createoptions(content)

    local set
    set = function(option)
        if max then
            option = type(option) == "table" and option or {}
            table.clear(chosen)

            for opt, tbl in next, optioninstances do
                if not table.find(option, opt) then
                    --tbl.button.Transparency = 0
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end

            for i, opt in next, option do
                if table.find(content, opt) and #chosen < max then
                    table.insert(chosen, opt)
                    --optioninstances[opt].button.Transparency = 1
                    utility.changeobjecttheme(optioninstances[opt].text, "Accent")
                end
            end

            local textchosen = {}
            local cutobject = false

            for _, opt in next, chosen do
                table.insert(textchosen, opt)

                if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                    cutobject = true
                    table.remove(textchosen, #textchosen)
                end
            end

            value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

            library.flags[flag] = chosen
            callback(chosen)
        end

        if not max then
            for opt, tbl in next, optioninstances do
                if opt ~= option then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end

            if table.find(content, option) then
                chosen = option

                value.Text = option

                utility.changeobjecttheme(optioninstances[option].text, "Accent")

                library.flags[flag] = chosen
                callback(chosen)
            else
                chosen = nil

                value.Text = ""

                library.flags[flag] = chosen
                callback(chosen)
            end
        end
    end

    flags[flag] = set

    set(default)

    local dropdowntypes = utility.table({}, true)

    function dropdowntypes:set(option)
        set(option)
    end

    function dropdowntypes:refresh(tbl)
        content = table.clone(tbl)
        count = 0

        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Remove()
            end)()
        end

        table.clear(optioninstances)

        createoptions(tbl)

        if scrollable then
            contentholder:RefreshScrolling()
        end

        value.Text = ""

        if max then
            table.clear(chosen)
        else
            chosen = nil
        end

        library.flags[flag] = chosen
        callback(chosen)
    end

    function dropdowntypes:add(option)
        table.insert(content, option)
        local button, text = createoption(option)
        handleoptionclick(option, button, text)
    end

    function dropdowntypes:remove(option)
        if optioninstances[option] then
            count = count - 1

            optioninstances[option].button:Remove()

            if scrollable then
                contentframe.Size = UDim2.new(1, 0, 0, math.clamp(contentholder.AbsoluteContentSize, 0, (scrollingmax * 16) + ((scrollingmax - 1) * 3)) + 6)
            else
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end

            optioninstances[option] = nil

            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    library.flags[flag] = chosen
                    callback(chosen)
                end
            end
        end
    end

    return dropdowntypes
end
--
function library:load_config(cfg_name)
    if isfile(cfg_name) then
        local file = readfile(cfg_name)
        local config = game:GetService("HttpService"):JSONDecode(file)

        for flag, v in next, config do
            local func = flags[flag]
            if func then
                func(v)
            end
        end
    end
end;
function library:init_window(cfg)
    -- configuration
    local window_table = {pages = {}, buttons = {}, titles = {}};
    local window_size = cfg.size or cfg.Size or Vector2.new(600,400);
    local window_name = cfg.name or cfg.Name or "velocity.vip"
   
    -- window configuration
    local string = readfile(settings.folder_name.."/window_size.txt");
    local resize_sizeX, resize_sizeY;
    
    if string and tonumber(string.match(string, "sizeX=(%d+)")) ~= nil then  
        resize_sizeX = tonumber(string.match(string, "sizeX=(%d+)"))
        resize_sizeY = tonumber(string.match(string, "sizeY=(%d+)"));
    else
        resize_sizeX = cfg.size.X or 500;
        resize_sizeY = cfg.size.Y or 500;
    end

    local size_X = resize_sizeX;
    local size_Y = resize_sizeY;
    local drag_tween = cfg.drag_tween or cfg.Drag_Tween or false;
    -- drawings
    local window_main = utility.create("Square", {Size = UDim2.new(0,size_X,0,size_Y), Position = utility.getcenter(size_X,size_Y), Color = Color3.fromRGB(12,12,9), Thickness = 1, Filled = true, ZIndex = 2}); do
        local inline_outline = utility.outline(window_main, Color3.fromRGB(50,50,50), 4);
        utility.outline(inline_outline, Color3.fromRGB(0,0,0), 4);
    end;
    library.holder = window_main    
    --
    local window_top = utility.create("Square", {Size = UDim2.new(1,0,0,30), Position = UDim2.new(0,0,0,0), Color = Color3.fromRGB(25,25,25), Thickness = 1, Filled = true, ZIndex = 3, Parent = window_main}); do
        local inline_outline_top = utility.outline(window_top, Color3.fromRGB(50,50,50), 3);
        utility.outline(inline_outline_top, Color3.fromRGB(0,0,0), 3);
    end;
    local window_drag = utility.create("Square", {Parent = window_main, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,30), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 10})
    --
    local window_title = utility.create("Text", {Text = window_name, Parent = window_top, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 6});
    local window_title_shadow = utility.create("Text", {Text = window_name, Parent = window_top, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-5), ZIndex = 5});
    --
    local window_bottom = utility.create("Square", {Size = UDim2.new(1,0,0,30), Position = UDim2.new(0,0,1,-30), Color = Color3.fromRGB(25,25,25), Thickness = 1, Filled = true, ZIndex = 3, Parent = window_main}); do
        local inline_outline_bottom = utility.outline(window_bottom, Color3.fromRGB(50,50,50), 3);
        utility.outline(inline_outline_bottom, Color3.fromRGB(0,0,0), 3);
    end;
    local bottom_holder = utility.create("Square", {Parent = window_bottom, Visible = true, Transparency = 0, Size = UDim2.new(1,-2,1,-2), Position = UDim2.new(0,1,0,2), Thickness = 1, Filled = true, ZIndex = 4})
    local bottom_accent_line = utility.create("Square", {Parent = window_bottom, Visible = true, Transparency = 1, Size = UDim2.new(0,0,0,2), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 4, Theme = "Accent"})
    local window_resize = utility.create("Square", {Parent = window_main, Visible = true, Transparency = 0, Size = UDim2.new(0,10,0,10), Position = UDim2.new(1,-10,1,-10), Thickness = 1, Filled = true, ZIndex = 10})
    --
    local dragoutline = utility.create("Square", {Size = UDim2.new(0, size_X, 0, size_Y),Position = utility.getcenter(size_X, size_Y),Filled = false,Thickness = 1,Theme = "Accent",ZIndex = 1,Visible = false})
    --
    --utility.resize(window_resize, window_main, dragoutline, function() end)
    utility.dragify(window_drag, dragoutline, window_main, drag_tween)
    
    
    
    -- // ESP PREVIEW
    local esp_preview_window = utility.create("Square", {Parent = window_main; Size = UDim2.new(0, 231, 0, 339), Position = UDim2.new(1, 10, 0, 0), Color = Color3.fromRGB(12,12,9), Thickness = 1, Filled = true, ZIndex = 2}); do
        local inline_outline = utility.outline(esp_preview_window, Color3.fromRGB(50,50,50), 4);
        utility.outline(inline_outline, Color3.fromRGB(0,0,0), 4);

        local window_title = utility.create("Text", {Text = "ESP Preview", Parent = esp_preview_window, Visible = true, Transparency = 1, Color = Color3.new(12,12,9), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,6,0,3), ZIndex = 6});
        local inner_window = utility.create("Square", {Parent = esp_preview_window; Size = UDim2.new(0,219,0,313); Position = UDim2.new(0,6,0,19), Color = Color3.fromRGB(15,15,15), Thickness = 1, Filled = true, ZIndex = 2}); do  
            local inline_outline = utility.outline(inner_window, Color3.fromRGB(50,50,50), 4);
            utility.outline(inline_outline, Color3.fromRGB(0,0,0), 4);
        end;

        -- // ESP head
        local esp_head = utility.create("Square", {Parent = inner_window; Size = UDim2.new(0, 45, 0, 39), Position = UDim2.new(0, 91, 0, 85), Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Filled = true, ZIndex = 5}); 
        local esp_head_outline = utility.outline(esp_head, Color3.fromRGB(0, 0, 0), 4);

        -- // Toros
        local esp_torso = utility.create("Square", {Parent = inner_window; Size = UDim2.new(0, 147, 0, 77), Position = UDim2.new(0, 39, 0, 125), Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Filled = true, ZIndex = 5});
        local esp_torso_outline = utility.outline(esp_torso, Color3.fromRGB(0, 0, 0), 4);
        

        -- // Legs
        local esp_legs = utility.create("Square", {Parent = inner_window; Size = UDim2.new(0, 73, 0, 78), Position = UDim2.new(0, 77, 0, 203), Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Filled = true, ZIndex = 5});
        local esp_legs_outline = utility.outline(esp_legs, Color3.fromRGB(0, 0, 0), 4);

        -- // Position fix
        esp_head.Position = UDim2.new(0,90.5,0,85) - UDim2.new(0,0,0,25);
        esp_torso.Position = UDim2.new(0,39,0,125) - UDim2.new(0,0,0,25);
        esp_legs.Position = UDim2.new(0,77,0,203) - UDim2.new(0,0,0,25);

        -- // Bounding box
        local esp_bounding_box = utility.create("Square", {Parent = inner_window; Size = UDim2.new(0, 195, 0, 236), Position = UDim2.new(0, 13.4, 0, 40), Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Filled = false, ZIndex = 5}); 
        local esp_bounding_box_outline = utility.outline(esp_bounding_box, Color3.fromRGB(0, 0, 0), 4);

        -- // Healthbar
        local esp_health_bar = utility.create("Square", {Parent = inner_window; Size = UDim2.new(0, 2, 0, 236), Position = UDim2.new(0, 8, 0, 40), Color = Color3.fromRGB(0, 255, 42), Thickness = 1, Filled = true, ZIndex = 5});
        local esp_health_bar_outline = utility.outline(esp_health_bar, Color3.fromRGB(0, 0, 0), 4);

        -- // Text
        local esp_name = utility.create("Text", {Text = "OnlyTwentyCharacters", Parent = inner_window, Visible = false, Transparency = 1, Color = Color3.fromRGB(255, 255, 255), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0, 115, 0, 25), ZIndex = 6});
        local esp_distance = utility.create("Text", {Text = "0 meters", Parent = inner_window, Visible = false, Transparency = 1, Color = Color3.fromRGB(255, 255, 255), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0, 115, 0, 276), ZIndex = 6});
        local esp_weapon = utility.create("Text", {Text = "Weapon", Parent = inner_window, Visible = false, Transparency = 1, Color = Color3.fromRGB(255, 255, 255), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0, 115, 0, 286), ZIndex = 6});

        -- // Functions
        settings.SetPreviewChamColor = function(Color, Outline, Alpha, AlphaOutline)
            esp_head.Color = Color
            esp_head_outline.Color = Outline
            esp_head.Transparency = Alpha;
            esp_head_outline.Transparency = AlphaOutline;

            esp_torso.Color = Color
            esp_torso_outline.Color = Outline
            esp_torso.Transparency = Alpha;
            esp_torso_outline.Transparency = AlphaOutline;

            esp_legs.Color = Color
            esp_legs_outline.Color = Outline
            esp_legs.Transparency = Alpha;
            esp_legs_outline.Transparency = AlphaOutline;
        end;

        settings.SetPreviewBoxColor = function(Color, Outline)
            esp_bounding_box.Color = Color
            esp_bounding_box_outline.Color = Outline
        end;

        settings.SetPreviewHealthBarVisible = function(Visible)
            esp_health_bar.Visible = Visible
            esp_health_bar_outline.Visible = Visible
        end

        settings.SetPreviewBoxVisible = function(Visible)
            esp_bounding_box.Visible = Visible
            esp_bounding_box_outline.Visible = Visible
        end

        settings.SetPreviewNameProperty = function(Property, Value)
            esp_name[Property] = Value
        end

        settings.SetPreviewDistanceProperty = function(Property, Value)
            esp_distance[Property] = Value
        end

        settings.SetPreviewWeaponProperty = function(Property, Value)
            esp_weapon[Property] = Value
        end

        settings.TogglePreviewVisibility = function(Value)
            esp_bounding_box.Transparency = Value and 1 or 0
            esp_bounding_box_outline.Transparency = Value and 1 or 0
            esp_health_bar.Transparency = Value and 1 or 0
            esp_health_bar_outline.Transparency = Value and 1 or 0
            esp_name.Transparency = Value and 1 or 0
            esp_distance.Transparency = Value and 1 or 0
            esp_weapon.Transparency = Value and 1 or 0
        end

        settings.TogglePreviewVisibility(false)
        settings.SetPreviewBoxVisible(false)
        settings.SetPreviewHealthBarVisible(false)
        settings.SetPreviewChamColor(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0), 0.3, 0.5);
        settings.SetPreviewBoxColor(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0));
    end;
    
    
    
    
    
    
    
    
    
    
    
    -- create pages
    function window_table:create_page(cfg)
        -- configuration
        local page_table = {};
        local page_name = cfg.name or cfg.Name or "invalid name";
        -- drawingsf
        local page_button = utility.create("Square", {Color = Color3.fromRGB(20,20,20), Thickness = 1, Filled = true, ZIndex = 6, Parent = bottom_holder}); do
            local inline_outline_page = utility.outline(page_button, Color3.fromRGB(0,0,0), 6);
        end;
        table.insert(self.buttons, page_button)
        local page_title = utility.create("Text", {Text = page_name, Parent = page_button, Visible = true, Transparency = 0.5, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-7), ZIndex = 7});
        local page_title_shadow = utility.create("Text", {Text = page_name, Parent = page_button, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 6});
        table.insert(self.titles, page_title)
        --
        local page = utility.create("Square", {Parent = window_main, Visible = false, Transparency = 0, Size = UDim2.new(1,-20,1,-80), Position = UDim2.new(0,10,0,40), Thickness = 1, Filled = false, ZIndex = 4}) do
            table.insert(self.pages, page);
        end;
        --
        local left = utility.create("Square", {Color = Color3.fromRGB(22,22,22),Transparency = 0,Filled = true,Thickness = 1,ZIndex = 6,Parent = page,Size = UDim2.new(0.5, -6, 1, 0);})
        left:AddListLayout(8) 
        local right = utility.create("Square", {Color = Color3.fromRGB(22,22,22),Transparency = 0,Filled = true,Thickness = 1,Parent = page,ZIndex = 6,Size = UDim2.new(0.5, -6, 1, 0),Position = UDim2.new(0.5, 6, 0, 0);})
        right:AddListLayout(8) 
        -- update size
        for _,v in next, self.buttons do
            bottom_accent_line.Size = UDim2.new(1 / #self.buttons, _ == 1 and 1 or _ == #self.buttons and -2 or -1, 1, -2);
            v.Size = UDim2.new(1 / #self.buttons, _ == 1 and 1 or _ == #self.buttons and -2 or -1, 1, -2);
            v.Position = UDim2.new(1 / (#self.buttons / (_ - 1)), _ == 1 and 0 or 2, 0, 1);
        end;
        -- function
        utility.connect(page_button.MouseButton1Click, function()
            for i,v in next, self.titles do
                if v ~= page_title then
                    local vfade = tween.new(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.5})
                    vfade:Play()
                end;
            end;
            --
            for i,v in next, self.pages do
                if v ~= page then
                    v.Visible = false
                end;
            end;
            --
            local line_tween = tween.new(bottom_accent_line, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(page_button.Position.X.Scale, page_button.Position.X.Offset, 0,0)})
            line_tween:Play()
            local line_size = tween.new(bottom_accent_line, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(page_button.Size.X.Scale, page_button.Size.X.Offset, 0,2)})
            line_size:Play()
            local textfade = tween.new(page_title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
            textfade:Play()
            page.Visible = true;
        end);
        function page_table:set_default()
            for i,v in next, window_table.titles do
                if v ~= page_title then
                    local vfade = tween.new(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0.5})
                    vfade:Play()
                end;
            end;
            --
            for i,v in next, window_table.pages do
                if v ~= page then
                    v.Visible = false
                end;
            end;
            local textfade = tween.new(page_title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
            textfade:Play()
            page.Visible = true;
        end;
        -- create section
        function page_table:new_section(cfg)
            -- settings
            local section_table = {};
            local section_name = cfg.name or cfg.Name or "invalid name";
            local section_side = cfg.side == "left" and left or cfg.side == "right" and right or left;
            local section_size = cfg.size or cfg.Size or 200;
            -- drawings
            local section = utility.create("Square", {Color = Color3.fromRGB(22,22,22),Transparency = 1,Filled = true,Thickness = 1,ZIndex = 6,Parent = section_side,Size = UDim2.new(1,0,0, section_size);}) do
                local section_inline_outline = utility.outline(section, Color3.fromRGB(50,50,50), 7);
                utility.outline(section_inline_outline, Color3.fromRGB(0,0,0), 7);
            end;
            --
            local section_top = utility.create("Square", {Size = UDim2.new(1,0,0,30), Position = UDim2.new(0,0,0,0), Color = Color3.fromRGB(25,25,25), Thickness = 1, Filled = true, ZIndex = 6, Parent = section}); do
                local section_inline_outline_top = utility.outline(section_top, Color3.fromRGB(50,50,50), 6);
                utility.outline(section_inline_outline_top, Color3.fromRGB(0,0,0), 6);
            end;
            --
            local section_title = utility.create("Text", {Text = section_name, Parent = section_top, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 7});
            local section_title_shadow = utility.create("Text", {Text = section_name, Parent = section_top, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-5), ZIndex = 6});
            --
            local content = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, -32, 1, -45),Position = UDim2.new(0, 16, 0, 40),Parent = section,ZIndex = 6, Thickness = 1});
            content:AddListLayout(8)        -- create container
            function section_table:new_container(cfg)
                -- settings
                local container_tbl = {};
                local name = cfg.name or cfg.Name or "invalid name";
                local actualsize = cfg.size or cfg.Size or 60;
                local allow_scroll = cfg.scroll or cfg.Scroll or false;
                local open = cfg.open or cfg.Open or false;
                local isopened = open;
                local ismultiplesize = 0;
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or ''
                -- drawings
                local holder = utility.create("Square", {Parent = content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 7});
                --
                if allow_tool then
                    tooltip(cfg, tooltip_text, holder)
                end
                --
                local button = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 7});
                --
                local title = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,-3), ZIndex = 7});
                local title_shadow = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,-2), ZIndex = 6});
                --
                local multicontent = utility.create("Square", {Visible = false, Transparency = 0,Size = UDim2.new(1, -30, 0, actualsize),Position = UDim2.new(0, 15, 0, 15),Parent = holder,ZIndex = 6, Thickness = 1});
                multicontent:AddListLayout(8)
    
                if allow_scroll then
                    multicontent:MakeScrollable()
                end
                --UDim2.new(1, 0, 0, multicontent.AbsoluteContentSize + 28)
                -- function
                button.MouseButton1Click:Connect(function()
                    isopened = not isopened
                    if isopened then
                        multicontent.Visible = true
                        multicontent.Size = UDim2.new(1, -30, 0, actualsize)
                        holder.Size = UDim2.new(1,0,0,actualsize+ismultiplesize+8)
                        window_table:refresh_window()
                    else
                        multicontent.Visible = false
                        holder.Size = UDim2.new(1,0,0,8)
                        window_table:refresh_window()
                    end
                end)
                if isopened then
                    multicontent.Visible = true
                    multicontent.Size = UDim2.new(1, -30, 0, actualsize)
                    holder.Size = UDim2.new(1,0,0,actualsize+8)
                end
                -- create container
                function container_tbl:new_container(cfg)
                    -- settings
                    local multi_container_tbl = {};
                    local multi_name = cfg.name or cfg.Name or "invalid name";
                    local multi_actualsize = cfg.size or cfg.Size or 60;
                    local multi_allow_scroll = cfg.scroll or cfg.Scroll or false;
                    local multi_open = cfg.open or cfg.Open or false;
                    local multi_isopened = open;
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                    -- drawings
                    local multi_holder = utility.create("Square", {Parent = multicontent, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 7});
                    --
                    if allow_tool then
                        tooltip(cfg, tooltip_text, multi_holder)
                    end
                    local multi_button = utility.create("Square", {Parent = multi_holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 7});
                    --
                    local multi_title = utility.create("Text", {Text = multi_name, Parent = multi_holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,-3), ZIndex = 7});
                    local multi_title_shadow = utility.create("Text", {Text = multi_name, Parent = multi_holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,-2), ZIndex = 6});
                    --
                    local multi_multicontent = utility.create("Square", {Visible = false, Transparency = 0,Size = UDim2.new(1, -30, 0, multi_actualsize),Position = UDim2.new(0, 15, 0, 15),Parent = multi_holder,ZIndex = 6, Thickness = 1});
                    multi_multicontent:AddListLayout(8)
        
                    if multi_allow_scroll then
                        multi_multicontent:MakeScrollable()
                    end
                    --UDim2.new(1, 0, 0, multicontent.AbsoluteContentSize + 28)
                    -- function
                    multi_button.MouseButton1Click:Connect(function()
                        multi_isopened = not multi_isopened
                        if multi_isopened then
                            ismultiplesize += multi_actualsize
                            multi_multicontent.Visible = true
                            multi_multicontent.Size = UDim2.new(1, -30, 0, multi_actualsize)
                            multi_holder.Size = UDim2.new(1,0,0,multi_actualsize+8)
                            holder.Size = UDim2.new(1,0,0,actualsize+multi_actualsize+8)
                            window_table:refresh_window()
                        else
                            ismultiplesize -= multi_actualsize
                            multi_multicontent.Visible = false
                            multi_holder.Size = UDim2.new(1,0,0,8)
                            holder.Size = UDim2.new(1,0,0,actualsize+8)
                            window_table:refresh_window()
                        end
                    end)
                    if isopened then
                        multi_multicontent.Visible = true
                        multi_multicontent.Size = UDim2.new(1, -30, 0, multi_actualsize)
                        multi_holder.Size = UDim2.new(1,0,0,multi_actualsize+8)
                    end
                    
                    -- create toggle
                    function multi_container_tbl:new_toggle(cfg)
                        -- settings
                        local toggle_tbl = {colorpickers = 0};
                        local toggle_name = cfg.name or cfg.Name or "invalid name";
                        local toggle_risky = cfg.risky or cfg.Risky or false;
                        local toggle_state = cfg.state or cfg.State or false;
                        local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag();
                        local callback = cfg.callback or cfg.Callback or function() end;
                        local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                        local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                        local toggled = false;
                        -- drawings
                        local holder = utility.create("Square", {Parent = multi_multicontent, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 7});
                        if allow_tool then
                            tooltip(cfg, tooltip_text, holder)
                        end
                        --
                        local toggle_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Color = Color3.fromRGB(65,65,65), Size = UDim2.new(0,8,0,8), Thickness = 1, Filled = true, ZIndex = 7}) do
                            local outline = utility.outline(toggle_frame, Color3.fromRGB(85,85,85), 7);
                            utility.outline(outline, Color3.fromRGB(0,0,0), 7);
                        end;
                        local accent = utility.create("Square", {Parent = toggle_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 7, Theme = "Accent"})
                        --
                        local toggle_title = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = toggle_risky and Color3.fromRGB(255, 57, 57) or Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-3), ZIndex = 7});
                        local toggle_title_shadow = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-2), ZIndex = 6});
                        -- functions
                        local function setstate()
                            toggled = not toggled
                            if toggled then
                                local accentfade = tween.new(accent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
                                accentfade:Play()
                            else
                                local accentfadeout = tween.new(accent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                                accentfadeout:Play()
                            end
                            library.flags[toggle_flag] = toggled
                            callback(toggled)
                        end;
                        --
                        holder.MouseButton1Click:Connect(setstate);
                        --
                        local function set(bool)
                            bool = type(bool) == "boolean" and bool or false
                            if toggled ~= bool then
                                setstate()
                            end;
                        end;
                        set(toggle_state);
                        flags[toggle_flag] = set;
                        -- toggle functions
                        local toggletypes = {}
                        function toggletypes:set(bool)
                            set(bool)
                        end;
                        --
                        function toggletypes:new_colorpicker(cfg)
                            local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                            local flag = cfg.flag or cfg.Flag or utility.nextflag();
                            local callback = cfg.callback or function() end;
                            local defaultalpha = cfg.alpha or cfg.Alpha or 1
                            local colorpicker_tbl = {};
            
                            toggle_tbl.colorpickers += 1
            
                            local cp = library.object_colorpicker(default, defaultalpha, holder, toggle_tbl.colorpickers - 1, flag, callback, -4)
                            function colorpicker_tbl:set(color)
                                cp:set(color, false, true)
                            end
                            return colorpicker_tbl
                        end;
                        --
                        function toggletypes:new_slider(cfg)
                            -- settings
                            local slider_tbl = {};
                            local min = cfg.min or cfg.minimum or 0;
                            local max = cfg.max or cfg.maximum or 100;
                            local text = cfg.text or ("[value]");
                            local float = cfg.float or 1;
                            local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                            local flag = cfg.flag or utility.nextflag();
                            local callback = cfg.callback or function() end;
                            local val = default;
                            -- drawings
                            local slider_holder = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 2});
                            --
                            local slider_frame = utility.create("Square",{
                                Color = Color3.fromRGB(13,13,13),
                                Size = UDim2.new(0, 100, 0, 8),
                                Position = UDim2.new(0, utility.textlength(toggle_name, 2, 13).X + 20, 0,0),
                                Filled = true,
                                Parent = slider_holder,
                                Thickness = 1,
                                ZIndex = 6
                            })
                            local outline = utility.outline(slider_frame, Color3.fromRGB(50,50,50), 6)
                            utility.outline(outline, Color3.fromRGB(0,0,0), 6)
                            --
                            local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                            --
                            local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                            local slider_drag_bar = utility.create("Square", {Parent = slider_fill, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = UDim2.new(0,2,1,6), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(1,0,0,-3)});
                            --
                            local slider_drag = utility.create("Square", {Parent = slider_frame, Color = Color3.new(0.074509, 0.074509, 0.074509), Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                            --[[
                            local minus = utility.create("Text", {Text = "-", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,10), ZIndex = 7});
                            local plus = utility.create("Text", {Text = "+", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(1,-6,0,10), ZIndex = 7});
                            --
                            local minus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(minus.Position.X.Scale, minus.Position.X.Offset,minus.Position.Y.Scale,minus.Position.Y.Offset)});
                            local plus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(plus.Position.X.Scale, plus.Position.X.Offset,plus.Position.Y.Scale,plus.Position.Y.Offset)});
                            -- functions]]
                            local function set(value)
                                value = math.clamp(utility.round(value, float), min, max)
                        
                                slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
                        
                                local sizeX = ((value - min) / (max - min))
                                --slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                                local fill = tween.new(slider_fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)})
                                fill:Play()
                                library.flags[flag] = value
                                callback(value)
                                val = value
                            end
                        
                            set(default)
                        
                            local sliding = false
                        
                            local function slide(input)
                                local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                                local value = ((max - min) * sizeX) + min
                        
                                set(value)
                            end
                        
                            utility.connect(slider_drag.InputBegan, function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    sliding = true
                                    slide(input)
                                end
                            end)
                        
                            utility.connect(slider_drag.InputEnded, function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    sliding = false
                                end
                            end)
                        
                            utility.connect(slider_fill.InputBegan, function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    sliding = true
                                    slide(input)
                                end
                            end)
                        
                            utility.connect(slider_fill.InputEnded, function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    sliding = false
                                end
                            end)
                        
                            utility.connect(services.InputService.InputChanged, function(input)
                                if input.UserInputType == Enum.UserInputType.MouseMovement then
                                    if sliding then
                                        slide(input)
                                    end
                                end
                            end)
                
                            --[[utility.connect(plus_detect.MouseButton1Click, function()
                                set(val + 1)
                            end)
                
                            utility.connect(minus_detect.MouseButton1Click, function()
                                set(val - 1)
                            end)--]]
                        
                            flags[flag] = set
                        
                            function slider_tbl:set(value)
                                set(value)
                            end
                            --
                            return slider_tbl;
                        end;
                        --]]
                        return toggletypes;
                    end;
                    -- create slider
                    function multi_container_tbl:new_slider(cfg)
                        -- settings
                        local slider_tbl = {};
                        local name = cfg.name or cfg.Name or "new slider";
                        local min = cfg.min or cfg.minimum or 0;
                        local max = cfg.max or cfg.maximum or 100;
                        local text = cfg.text or ("[value]");
                        local float = cfg.float or 1;
                        local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                        local flag = cfg.flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local val = default;
                        local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                        local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                        -- drawings
                        local holder = utility.create("Square", {Parent = multi_multicontent, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 7});
                        --
                        if allow_tool then
                            tooltip(cfg, tooltip_text, holder)
                        end
                        local slider_frame = utility.create("Square",{
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0, 150, 0, 15),
                            Filled = true,
                            Parent = holder,
                            Thickness = 1,
                            ZIndex = 6
                        })
                        local outline = utility.outline(slider_frame, Color3.fromRGB(50,50,50), 6)
                        utility.outline(outline, Color3.fromRGB(0,0,0), 6)
                        --
                        local slider_title = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,155,0,0), ZIndex = 7});
                        local slider_title_shadow = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,155,0,1), ZIndex = 6});
                        --
                        local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                        --
                        local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                        local slider_drag_bar = utility.create("Square", {Parent = slider_fill, Visible = true, Transparency = 0.5, Color = Color3.new(0.168627, 0.168627, 0.168627), Size = UDim2.new(0,10,1,-2), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(1,-12,0,1)});
                        --
                        local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                        --[[
                        local minus = utility.create("Text", {Text = "-", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,10), ZIndex = 7});
                        local plus = utility.create("Text", {Text = "+", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(1,-6,0,10), ZIndex = 7});
                        --
                        local minus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(minus.Position.X.Scale, minus.Position.X.Offset,minus.Position.Y.Scale,minus.Position.Y.Offset)});
                        local plus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(plus.Position.X.Scale, plus.Position.X.Offset,plus.Position.Y.Scale,plus.Position.Y.Offset)});
                        -- functions]]
                        local function set(value)
                            value = math.clamp(utility.round(value, float), min, max)
                    
                            slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
                    
                            local sizeX = ((value - min) / (max - min))
                            --slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                            local fill = tween.new(slider_fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)})
                            fill:Play()
                            library.flags[flag] = value
                            callback(value)
                            if sizeX < 0.11 then
                                slider_drag_bar.Visible = false
                            else
                                slider_drag_bar.Visible = true
                            end
                            val = value
                        end
                    
                        set(default)
                    
                        local sliding = false
                    
                        local function slide(input)
                            local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                            local value = ((max - min) * sizeX) + min
                    
                            set(value)
                        end
                    
                        utility.connect(slider_drag.InputBegan, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = true
                                slide(input)
                            end
                        end)
                    
                        utility.connect(slider_drag.InputEnded, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = false
                            end
                        end)
                    
                        utility.connect(slider_fill.InputBegan, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = true
                                slide(input)
                            end
                        end)
                    
                        utility.connect(slider_fill.InputEnded, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = false
                            end
                        end)
                    
                        utility.connect(services.InputService.InputChanged, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                if sliding then
                                    slide(input)
                                end
                            end
                        end)
            
                        --[[utility.connect(plus_detect.MouseButton1Click, function()
                            set(val + 1)
                        end)
            
                        utility.connect(minus_detect.MouseButton1Click, function()
                            set(val - 1)
                        end)--]]
                    
                        flags[flag] = set
                    
                        function slider_tbl:set(value)
                            set(value)
                        end
                        --
                        return slider_tbl;
                    end;
                    -- create dropdown
                    function multi_container_tbl:new_dropdown(cfg)
                        local dropdown_tbl = {};
                        local name = cfg.name or cfg.Name or "new dropdown";
                        local default = cfg.default or cfg.Default or nil;
                        local content = type(cfg.options or cfg.Options) == "table" and cfg.options or cfg.Options or {};
                        local max = cfg.max or cfg.Max and (cfg.max > 1 and cfg.max) or nil;
                        local scrollable = cfg.scrollable or false;
                        local scrollingmax = cfg.scrollingmax or 10;
                        local flag = cfg.flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                        local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                        if not max and type(default) == "table" then
                            default = nil
                        end
                        if max and default == nil then
                            default = {}
                        end
                        if type(default) == "table" then
                            if max then
                                for i, opt in next, default do
                                    if not table.find(content, opt) then
                                        table.remove(default, i)
                                    elseif i > max then
                                        table.remove(default, i)
                                    end
                                end
                            else
                                default = nil
                            end
                        elseif default ~= nil then
                            if not table.find(content, default) then
                                default = nil
                            end
                        end
                        --
                        local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multi_multicontent});
                        if allow_tool then
                            tooltip(cfg, tooltip_text, holder)
                        end
                        --
                        local title = utility.create("Text", {
                            Text = name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0, 105, 0, 0),
                            Theme = "Text",
                            ZIndex = 7,
                            Outline = false,
                            Parent = holder
                        });
                        local title_shadow = utility.create("Text", {
                            Text = name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0, 105, 0, 1),
                            Color = Color3.new(0,0,0),
                            ZIndex = 6,
                            Outline = false,
                            Parent = holder
                        });
                        --
                        local dropdown = utility.create("Square", {
                            Filled = true,
                            Visible = true,
                            Thickness = 1,
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0, 100, 0, 15),
                            Position = UDim2.new(0, 0, 0,0),
                            ZIndex = 7,
                            Parent = holder
                        })
                    
                        local outline = utility.outline(dropdown, Color3.fromRGB(50,50,50), 7)
                        utility.outline(outline, Color3.fromRGB(0,0,0), 7)
                    
                        local value = utility.create("Text", {
                            Text = "",
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0, 2, 0, 0),
                            Theme = "Text",
                            ZIndex = 9,
                            Outline = false,
                            Parent = dropdown
                        })
                    
                    
                        local contentframe = utility.create("Square", {
                            Filled = true,
                            Visible = false,
                            Thickness = 1,
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(1,0,0,0),
                            Position = UDim2.new(0, 0, 1, 3),
                            ZIndex = 12,
                            Parent = dropdown
                        })
                    
                        local outline1 = utility.outline(contentframe, Color3.fromRGB(50,50,50))
                        utility.outline(outline1, Color3.fromRGB(0,0,0))
                    
                        local contentholder = utility.create("Square", {
                            Transparency = 0,
                            Size = UDim2.new(1, -6, 1, -6),
                            Position = UDim2.new(0, 3, 0, 3),
                            Parent = contentframe
                        })
                    
                        if scrollable then
                            contentholder:MakeScrollable()
                        end
                    
                        contentholder:AddListLayout(3)
                    
                        local mouseover = false
                    
                        local opened = false
                    
                        if not islist then
                            dropdown.MouseButton1Click:Connect(function()
                                opened = not opened
                                contentframe.Visible = opened
                            end)
                        end
                    
                        local optioninstances = {}
                        local count = 0
                        local countindex = {}
                    
                        local function createoption(name)
                            optioninstances[name] = {}
                    
                            countindex[name] = count + 1
                    
                            local button = utility.create("Square", {
                                Filled = true,
                                Transparency = 0,
                                Thickness = 1,
                                Size = UDim2.new(1, 0, 0, 16),
                                ZIndex = 14,
                                Parent = contentholder
                            })
                    
                            optioninstances[name].button = button
                    
                            local title = utility.create("Text", {
                                Text = name,
                                Font = Drawing.Fonts.Plex,
                                Size = 13,
                                Position = UDim2.new(0, 8, 0, 1),
                                Theme = "Text",
                                ZIndex = 15,
                                Outline = true,
                                Parent = button
                            })
                    
                            optioninstances[name].text = title
                    
                            if scrollable then
                                if count < scrollingmax then
                                    contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
                                end
                            else
                                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
                            end
                    
                            count = count + 1
                    
                            return button, title
                        end
                    
                        local chosen = max and {}
                    
                        local function handleoptionclick(option, button, text)
                            button.MouseButton1Click:Connect(function()
                                if max then
                                    if table.find(chosen, option) then
                                        table.remove(chosen, table.find(chosen, option))
                    
                                        local textchosen = {}
                                        local cutobject = false
                    
                                        for _, opt in next, chosen do
                                            table.insert(textchosen, opt)
                    
                                            if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                                                cutobject = true
                                                table.remove(textchosen, #textchosen)
                                            end
                                        end
                    
                                        value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                                        utility.changeobjecttheme(text, "Text")
                    
                                        library.flags[flag] = chosen
                                        callback(chosen)
                                    else
                                        if #chosen == max then
                                            utility.changeobjecttheme(optioninstances[chosen[1]].text, "Text")
                    
                                            table.remove(chosen, 1)
                                        end
                    
                                        table.insert(chosen, option)
                    
                                        local textchosen = {}
                                        local cutobject = false
                    
                                        for _, opt in next, chosen do
                                            table.insert(textchosen, opt)
                    
                                            if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                                                cutobject = true
                                                table.remove(textchosen, #textchosen)
                                            end
                                        end
                    
                                        value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                                        utility.changeobjecttheme(text, "Accent")
                    
                                        library.flags[flag] = chosen
                                        callback(chosen)
                                    end
                                else
                                    for opt, tbl in next, optioninstances do
                                        if opt ~= option then
                                            utility.changeobjecttheme(tbl.text, "Text")
                                        end
                                    end
                    
                                    chosen = option
                    
                                    value.Text = option
                    
                                    utility.changeobjecttheme(text, "Accent")
                    
                                    library.flags[flag] = option
                                    callback(option)
                    
                                end
                            end)
                        end
                    
                        local function createoptions(tbl)
                            for _, option in next, tbl do
                                local button, text = createoption(option)
                                handleoptionclick(option, button, text)
                            end
                        end
                    
                        createoptions(content)
                    
                        local set
                        set = function(option)
                            if max then
                                option = type(option) == "table" and option or {}
                                table.clear(chosen)
                    
                                for opt, tbl in next, optioninstances do
                                    if not table.find(option, opt) then
                                        --tbl.button.Transparency = 0
                                        utility.changeobjecttheme(tbl.text, "Text")
                                    end
                                end
                    
                                for i, opt in next, option do
                                    if table.find(content, opt) and #chosen < max then
                                        table.insert(chosen, opt)
                                        --optioninstances[opt].button.Transparency = 1
                                        utility.changeobjecttheme(optioninstances[opt].text, "Accent")
                                    end
                                end
                    
                                local textchosen = {}
                                local cutobject = false
                    
                                for _, opt in next, chosen do
                                    table.insert(textchosen, opt)
                    
                                    if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                                        cutobject = true
                                        table.remove(textchosen, #textchosen)
                                    end
                                end
                    
                                value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                                library.flags[flag] = chosen
                                callback(chosen)
                            end
                    
                            if not max then
                                for opt, tbl in next, optioninstances do
                                    if opt ~= option then
                                        utility.changeobjecttheme(tbl.text, "Text")
                                    end
                                end
                    
                                if table.find(content, option) then
                                    chosen = option
                    
                                    value.Text = option
                    
                                    utility.changeobjecttheme(optioninstances[option].text, "Accent")
                    
                                    library.flags[flag] = chosen
                                    callback(chosen)
                                else
                                    chosen = nil
                    
                                    value.Text = ""
                    
                                    library.flags[flag] = chosen
                                    callback(chosen)
                                end
                            end
                        end
                    
                        flags[flag] = set
                    
                        set(default)
                    
                        local dropdowntypes = utility.table({}, true)
                    
                        function dropdowntypes:set(option)
                            set(option)
                        end
                    
                        function dropdowntypes:refresh(tbl)
                            content = table.clone(tbl)
                            count = 0
                    
                            for _, opt in next, optioninstances do
                                coroutine.wrap(function()
                                    opt.button:Remove()
                                end)()
                            end
                    
                            table.clear(optioninstances)
                    
                            createoptions(tbl)
                    
                            if scrollable then
                                contentholder:RefreshScrolling()
                            end
                    
                            value.Text = ""
                    
                            if max then
                                table.clear(chosen)
                            else
                                chosen = nil
                            end
                    
                            library.flags[flag] = chosen
                            callback(chosen)
                        end
                    
                        function dropdowntypes:add(option)
                            table.insert(content, option)
                            local button, text = createoption(option)
                            handleoptionclick(option, button, text)
                        end
                    
                        function dropdowntypes:remove(option)
                            if optioninstances[option] then
                                count = count - 1
                    
                                optioninstances[option].button:Remove()
                    
                                if scrollable then
                                    contentframe.Size = UDim2.new(1, 0, 0, math.clamp(contentholder.AbsoluteContentSize, 0, (scrollingmax * 16) + ((scrollingmax - 1) * 3)) + 6)
                                else
                                    contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
                                end
                    
                                optioninstances[option] = nil
                    
                                if max then
                                    if table.find(chosen, option) then
                                        table.remove(chosen, table.find(chosen, option))
                    
                                        local textchosen = {}
                                        local cutobject = false
                    
                                        for _, opt in next, chosen do
                                            table.insert(textchosen, opt)
                    
                                            if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                                                cutobject = true
                                                table.remove(textchosen, #textchosen)
                                            end
                                        end
                    
                                        value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                    
                                        library.flags[flag] = chosen
                                        callback(chosen)
                                    end
                                end
                            end
                        end
                    
                        return dropdowntypes
                    end;
                    -- create keybind
                    function multi_container_tbl:new_keybind(cfg)
                        local dropdown_tbl = {};
                        local name = cfg.name or cfg.Name or "new keybind";
                        local key_name = cfg.keybind_name or cfg.KeyBind_Name or name;
                        local default = cfg.default or cfg.Default or nil;
                        local mode = cfg.mode or cfg.Mode or "Hold";
                        local blacklist = cfg.blacklist or cfg.Blacklist or {};
                        local flag = cfg.flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local ignore_list = cfg.ignore or cfg.Ignore or false;
                        local allow_modes = cfg.change_modes or cfg.Change_Modes or false;
                        local key_mode = mode;
                        local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                        local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                        --
                        local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multi_multicontent});
                        --
                        if allow_tool then
                            tooltip(cfg, tooltip_text, holder)
                        end
                        local title = utility.create("Text", {
                            Text = name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0, 105, 0, 0),
                            Color = Color3.new(1,1,1),
                            ZIndex = 7,
                            Outline = false,
                            Parent = holder
                        });
                        local shadowtitle = utility.create("Text", {
                            Text = name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0, 105, 0, 1),
                            Color = Color3.new(0,0,0),
                            ZIndex = 6,
                            Outline = false,
                            Parent = holder
                        });
                        --
                        if not offset then
                            offset = -1
                        end
                    
                        local keybindname = key_name or "";
                    
                        local frame = utility.create("Square",{
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0, 100, 0, 15),
                            Filled = true,
                            Parent = holder,
                            Thickness = 1,
                            ZIndex = 8
                        })
            
                        local outline = utility.outline(frame, Color3.fromRGB(50,50,50), 7)
                        utility.outline(outline, Color3.fromRGB(0,0,0), 7)
            
                        if allow_modes then
                            local mode_frame = utility.create("Square",{
                                Color = Color3.fromRGB(13,13,13),
                                Size = UDim2.new(0,44,0,35),
                                Position = UDim2.new(1,10,0,-10),
                                Filled = true,
                                Parent = frame,
                                Thickness = 1,
                                ZIndex = 8,
                                Visible = false
                            })
                        
                            local mode_outline1 = utility.outline(mode_frame, Color3.fromRGB(50,50,50), 8)
                            utility.outline(mode_outline1, Color3.fromRGB(0,0,0), 8)
                
                            local holdtext = utility.create("Text", {
                                Text = "Hold",
                                Font = Drawing.Fonts.Plex,
                                Size = 13,
                                Theme = key_mode == "Hold" and "Accent" or "Text",
                                Position = UDim2.new(0.5,0,0,2),
                                ZIndex = 8,
                                Parent = mode_frame,
                                Outline = false,
                                Center = true
                            })
                            
                            local toggletext = utility.create("Text", {
                                Text = "Toggle",
                                Font = Drawing.Fonts.Plex,
                                Size = 13,
                                Theme = key_mode == "Toggle" and "Accent" or "Text",
                                Position = UDim2.new(0.5,0,0,18),
                                ZIndex = 8,
                                Parent = mode_frame,
                                Outline = false,
                                Center = true
                            })
                
                            local holdbutton = utility.create("Square",{
                                Color = Color3.new(0,0,0),
                                Size = UDim2.new(0,44,0,12),
                                Position = UDim2.new(0,0,0,2),
                                Filled = false,
                                Parent = mode_frame,
                                Thickness = 1,
                                ZIndex = 8,
                                Transparency = 0
                            })
                
                            local togglebutton = utility.create("Square",{
                                Color = Color3.new(0,0,0),
                                Size = UDim2.new(0,44,0,12),
                                Position = UDim2.new(0,0,0,20),
                                Filled = false,
                                Parent = mode_frame,
                                Thickness = 1,
                                ZIndex = 8,
                                Transparency = 0
                            })
            
                            local remove = utility.create("Square", {Filled = true, Position = UDim2.new(1,-20,0,3),Thickness = 1, Transparency = 0, Visible = true, Parent = frame, Size = UDim2.new(0,utility.textlength("x", 2, 13).X + 10, 0, 10), ZIndex = 13});
                            remove.MouseButton1Click:Connect(function()
                                mode_frame.Visible = true
                            end)
            
                            local removetext = utility.create("Text", {
                                Font = Drawing.Fonts.Plex,
                                Size = 13,
                                Color = Color3.fromRGB(255,255,255),
                                Position = UDim2.new(1,-20,0,0),
                                ZIndex = 8,
                                Parent = frame,
                                Outline = false,
                                Center = false,
                                Text = "...",
                                Transparency = 0.5
                            })
                            local removetext_bold = utility.create("Text", {
                                Font = Drawing.Fonts.Plex,
                                Size = 13,
                                Color = Color3.fromRGB(255,255,255),
                                Position = UDim2.new(1,-21,0,0),
                                ZIndex = 8,
                                Parent = frame,
                                Outline = false,
                                Center = false,
                                Text = "...",
                                Transparency = 0.5
                            })
                    
            
                            holdbutton.MouseButton1Click:Connect(function()
                                key_mode = "Hold"
                                utility.changeobjecttheme(holdtext, "Accent")
                                utility.changeobjecttheme(toggletext, "Text")
                                mode_frame.Visible = false
                            end)
                            togglebutton.MouseButton1Click:Connect(function()
                                key_mode = "Toggle"
                                utility.changeobjecttheme(holdtext, "Text")
                                utility.changeobjecttheme(toggletext, "Accent")
                                mode_frame.Visible = false
                            end)
                        end
                    
                        local keytext = utility.create("Text", {
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Theme = "Text",
                            Position = UDim2.new(0,2,0,0),
                            ZIndex = 8,
                            Parent = frame,
                            Outline = false,
                            Center = false
                        })
                        local list_obj = nil;
                        if ignore_list == false then
                            --list_obj = window_key_list:add_keybind(keybindname, keytext.Text)
                        end;
                    
                        local key
                        local state = false
                        local binding
                    
                        local function set(newkey)
                            if c then
                                c:Disconnect();
                                if flag then
                                    library.flags[flag] = false;
                                end
                                callback(false);
                                if ignore_list == false then
                                   --list_obj:is_active(false)
                                end
                            end
                            if tostring(newkey):find("Enum.KeyCode.") then
                                newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                            elseif tostring(newkey):find("Enum.UserInputType.") then
                                newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                            end
                    
                            if newkey ~= nil and not table.find(blacklist, newkey) then
                                key = newkey
                    
                                local text = (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                    
                                keytext.Text = text
                                if ignore_list == false then
                                    --list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                                end
                            else
                                key = nil
                    
                                local text = ""
                    
                                keytext.Text = text
                                if ignore_list == false then
                                    --list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                                end
                            end
                    
                            if bind ~= '' or bind ~= nil then
                                state = false
                                if flag then
                                    library.flags[flag] = state;
                                end
                                callback(false)
                                if ignore_list == false then
                                   --list_obj:is_active(state)
                                end
                            end
                        end
                    
                        utility.connect(services.InputService.InputBegan, function(inp)
                            if (inp.KeyCode == key or inp.UserInputType == key) and not binding then
                                if key_mode == "Hold" then
                                    if flag then
                                        library.flags[flag] = true
                                    end
                                    if ignore_list == false then
                                       --list_obj:is_active(true)
                                    end
                                    c = utility.connect(game:GetService("RunService").RenderStepped, function()
                                        if callback then
                                            callback(true)
                                        end
                                    end)
                                else
                                    state = not state
                                    if flag then
                                        library.flags[flag] = state;
                                    end
                                    callback(state)
                                    if ignore_list == false then
                                       --list_obj:is_active(state)
                                    end
                                end
                            end
                        end)
                    
                        set(default)
                    
                        frame.MouseButton1Click:Connect(function()
                            if not binding then
                    
                                keytext.Text = "..."
                                
                                binding = utility.connect(services.InputService.InputBegan, function(input, gpe)
                                    set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                                    utility.disconnect(binding)
                                    task.wait()
                                    binding = nil
                                end)
                            end
                        end)
                    
                        utility.connect(services.InputService.InputEnded, function(inp)
                            if key_mode == "Hold" then
                                if key ~= '' or key ~= nil then
                                    if inp.KeyCode == key or inp.UserInputType == key then
                                        if c then
                                            c:Disconnect()
                                            if ignore_list == false then
                                               --list_obj:is_active(false)
                                            end
                                            if flag then
                                                library.flags[flag] = false;
                                            end
                                            if callback then
                                                callback(false)
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    
                        local keybindtypes = {};
                    
                        function keybindtypes:set(newkey)
                            set(newkey)
                        end
                        return keybindtypes
                    end;
                    -- create textbox
                    function multi_container_tbl:new_textbox(cfg)
                        -- settings
                        local textbox_tbl = {};
                        local placeholder = cfg.placeholder or cfg.Placeholder or "new textbox";
                        local default = cfg.Default or cfg.default or "";
                        local middle = cfg.middle or cfg.Middle or false;
                        local flag = cfg.flag or cfg.Flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                        local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                        -- drawings
                        local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multi_multicontent});
                        --
                        if allow_tool then
                            tooltip(cfg, tooltip_text, holder)
                        end
                        local textbox = utility.create("Square", {
                            Filled = true,
                            Visible = true,
                            Thickness = 0,
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0,100,0,15),
                            ZIndex = 7,
                            Parent = holder
                        })
                        local outline = utility.outline(textbox, Color3.fromRGB(50,50,50), 7)
                        utility.outline(outline, Color3.fromRGB(0,0,0), 7)
                        --
                        local text = utility.create("Text", {
                            Text = default,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Center = middle,
                            Position = middle and UDim2.new(0.5,0,0,1) or UDim2.new(0, 2, 0, 1),
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = 9,
                            Outline = false,
                            Parent = textbox
                        })
                        --
                        local placeholder = utility.create("Text", {
                            Text = placeholder,
                            Font = Drawing.Fonts.Plex,
                            Transparency = 0.5,
                            Size = 13,
                            Center = middle,
                            Position = middle and UDim2.new(0.5,0,0,1) or UDim2.new(0, 2, 0, 1),
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = 9,
                            Outline = false,
                            Parent = textbox
                        })
                        -- functions
                        library.object_textbox(textbox, text,  function(str) 
                            if str == "" then
                                placeholder.Visible = true
                                text.Visible = false
                            else
                                placeholder.Visible = false
                                text.Visible = true
                            end
                        end, function(str)
                            library.flags[flag] = str
                            callback(str)
                            if utility.textlength(str, 2, 13).X > (textbox.AbsoluteSize.X) then
                                textbox.Size = UDim2.new(0,utility.textlength(str, 2, 13).X + 5, 0, 15)
                            else
                                textbox.Size = UDim2.new(0, 100, 0, 15)
                            end
                        end)
            
                        local function set(str)
                            text.Visible = str ~= ""
                            placeholder.Visible = str == ""
                            text.Text = str
                            library.flags[flag] = str
                            callback(str)
                            if utility.textlength(str, 2, 13).X > textbox.Size.X.Offset then
                                textbox.Size = UDim2.new(0,utility.textlength(str, 2, 13).X + 5, 0, 15)
                            else
                                textbox.Size = UDim2.new(0, 100, 0, 15)
                            end
                        end
            
                        set(default)
            
                        flags[flag] = set
            
                        function textbox_tbl:Set(str)
                            set(str)
                        end
                        return textbox_tbl
                    end;
                    -- create cp
                    function multi_container_tbl:new_colorpicker(cfg)
                        local colorpicker_tbl = {}
                        local name = cfg.name or cfg.Name or "new colorpicker";
                        local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                        local flag = cfg.flag or cfg.Flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                        local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                        local defaultalpha = cfg.alpha or cfg.Alpha or 1
            
                        local holder = utility.create("Square", {
                            Transparency = 0,
                            Filled = true,
                            Thickness = 1,
                            Size = UDim2.new(1, 0, 0, 10),
                            ZIndex = 7,
                            Parent = multi_multicontent
                        })
                        if allow_tool then
                            tooltip(cfg, tooltip_text, holder)
                        end
            
                        local title = utility.create("Text", {
                            Text = name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0, -1, 0, -1),
                            Theme = "Text",
                            ZIndex = 7,
                            Outline = false,
                            Parent = holder
                        })
            
                        local colorpickers = 0
            
                        local colorpickertypes = library.object_colorpicker(default, defaultalpha, holder, colorpickers, flag, callback, -2)
            
                        function colorpickertypes:new_colorpicker(cfg)
                            colorpickers = colorpickers + 1
                            local cp_tbl = {}
            
                            utility.table(cfg)
                            local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                            local flag = cfg.flag or cfg.Flag or utility.nextflag();
                            local callback = cfg.callback or function() end;
                            local defaultalpha = cfg.alpha or cfg.Alpha or 1
            
                            local cp = library.object_colorpicker(default, defaultalpha, holder, colorpickers, flag, callback, -2)
                            function cp_tbl:set(color)
                                cp:set(color, false, true)
                            end
                            return cp_tbl
                        end
            
                        function colorpicker_tbl:set(color)
                            colorpickertypes:set(color, false, true)
                        end
                        return colorpicker_tbl
                    end;
                    -- create button
                    function multi_container_tbl:new_button(cfg)
                        local button_tbl = {};
                        local button_name = cfg.name or cfg.Name or "new button";
                        local button_confirm = cfg.confirm or cfg.Confirm or false;
                        local callback = cfg.callback or cfg.Callback or function() end;
                        local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                        local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                        --
                        local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multi_multicontent});
                        if allow_tool then
                           tooltip(cfg, tooltip_text, holder)
                        end
                        --
                        local frame = utility.create("Square",{
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0, utility.textlength(button_name, 2, 13).X + 5, 0, 15),
                            Filled = true,
                            Parent = holder,
                            Thickness = 1,
                            ZIndex = 8
                        })
                        utility.outline(frame, Color3.fromRGB(0,0,0), 7)
                        local title = utility.create("Text", {
                            Text = button_name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0.5,0,0,0),
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = 9,
                            Outline = false,
                            Center = true,
                            Parent = frame
                        });
                        -- functions
                        local clicked, counting = false, false
                        utility.connect(frame.MouseButton1Click, function()
                            task.spawn(function()
                                if button_confirm then
                                    if clicked then
                                        clicked = false
                                        counting = false
                                        title.Text = button_name
                                        callback()
                                    else
                                        clicked = true
                                        counting = true
                                        for i = 3,1,-1 do
                                            if not counting then
                                                break
                                            end
                                            title.Text = 'confirm ? ' .. tostring(i)
                                            wait(1)
                                        end
                                        clicked = false
                                        counting = false
                                        title.Text = button_name
                                    end
                                else
                                    callback()
                                end;
                            end);
                        end);
                        --
                        function button_tbl:new_button(cfg)
                            local button_name = cfg.name or cfg.Name or "new button";
                            local button_confirm = cfg.confirm or cfg.Confirm or false;
                            local callback = cfg.callback or cfg.Callback or function() end;
                            --
                            local button_frame = utility.create("Square",{
                                Color = Color3.fromRGB(13,13,13),
                                Size = UDim2.new(0, utility.textlength(button_name, 2, 13).X + 5, 0, 15),
                                Filled = true,
                                Parent = holder,
                                Thickness = 1,
                                ZIndex = 8,
                                Position = UDim2.new(0, frame.AbsoluteSize.X + 5,0,0)
                            })
                            utility.outline(button_frame, Color3.fromRGB(0,0,0), 7)
                            local title = utility.create("Text", {
                                Text = button_name,
                                Font = Drawing.Fonts.Plex,
                                Size = 13,
                                Position = UDim2.new(0.5,0,0,0),
                                Color = Color3.fromRGB(255,255,255),
                                ZIndex = 9,
                                Outline = false,
                                Center = true,
                                Parent = button_frame
                            });
                            -- functions
                            local clicked, counting = false, false
                            utility.connect(frame.MouseButton1Click, function()
                                task.spawn(function()
                                    if button_confirm then
                                        if clicked then
                                            clicked = false
                                            counting = false
                                            title.Text = button_name
                                            callback()
                                        else
                                            clicked = true
                                            counting = true
                                            for i = 3,1,-1 do
                                                if not counting then
                                                    break
                                                end
                                                title.Text = 'confirm ? ' .. tostring(i)
                                                wait(1)
                                            end
                                            clicked = false
                                            counting = false
                                            title.Text = button_name
                                        end
                                    else
                                        callback()
                                    end;
                                end);
                            end);
                        end;
                        return button_tbl
                    end;
                    --
                    return multi_container_tbl;
                end;
                -- create toggle
                function container_tbl:new_toggle(cfg)
                    -- settings
                    local toggle_tbl = {colorpickers = 0};
                    local toggle_name = cfg.name or cfg.Name or "invalid name";
                    local toggle_risky = cfg.risky or cfg.Risky or false;
                    local toggle_state = cfg.state or cfg.State or false;
                    local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or cfg.Callback or function() end;
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                    local toggled = false;
                    -- drawings
                    local holder = utility.create("Square", {Parent = multicontent, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 7});
                    --
                    if allow_tool then
                       tooltip(cfg, tooltip_text, holder)
                    end
                    local toggle_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Color = Color3.fromRGB(65,65,65), Size = UDim2.new(0,8,0,8), Thickness = 1, Filled = true, ZIndex = 7}) do
                        local outline = utility.outline(toggle_frame, Color3.fromRGB(85,85,85), 7);
                        utility.outline(outline, Color3.fromRGB(0,0,0), 7);
                    end;
                    local accent = utility.create("Square", {Parent = toggle_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 7, Theme = "Accent"})
                    --
                    local toggle_title = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = toggle_risky and Color3.fromRGB(255, 57, 57) or Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-3), ZIndex = 7});
                    local toggle_title_shadow = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-2), ZIndex = 6});
                    -- functions
                    local function setstate()
                        toggled = not toggled
                        if toggled then
                            local accentfade = tween.new(accent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
                            accentfade:Play()
                        else
                            local accentfadeout = tween.new(accent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                            accentfadeout:Play()
                        end
                        library.flags[toggle_flag] = toggled
                        callback(toggled)
                    end;
                    --
                    holder.MouseButton1Click:Connect(setstate);
                    --
                    local function set(bool)
                        bool = type(bool) == "boolean" and bool or false
                        if toggled ~= bool then
                            setstate()
                        end;
                    end;
                    set(toggle_state);
                    flags[toggle_flag] = set;
                    -- toggle functions
                    local toggletypes = {}
                    function toggletypes:set(bool)
                        set(bool)
                    end;
                    --
                    function toggletypes:new_colorpicker(cfg)
                        local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                        local flag = cfg.flag or cfg.Flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local defaultalpha = cfg.alpha or cfg.Alpha or 1
                        local colorpicker_tbl = {};
        
                        toggle_tbl.colorpickers += 1
        
                        local cp = library.object_colorpicker(default, defaultalpha, holder, toggle_tbl.colorpickers - 1, flag, callback, -4)
                        function colorpicker_tbl:set(color)
                            cp:set(color, false, true)
                        end
                        return colorpicker_tbl
                    end;
                    --
                    function toggletypes:new_slider(cfg)
                        -- settings
                        local slider_tbl = {};
                        local min = cfg.min or cfg.minimum or 0;
                        local max = cfg.max or cfg.maximum or 100;
                        local text = cfg.text or ("[value]");
                        local float = cfg.float or 1;
                        local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                        local flag = cfg.flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local val = default;
                        -- drawings
                        local slider_holder = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 2});
                        --
                        local slider_frame = utility.create("Square",{
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0, 100, 0, 8),
                            Position = UDim2.new(0, utility.textlength(toggle_name, 2, 13).X + 20, 0,0),
                            Filled = true,
                            Parent = slider_holder,
                            Thickness = 1,
                            ZIndex = 6
                        })
                        local outline = utility.outline(slider_frame, Color3.fromRGB(50,50,50), 6)
                        utility.outline(outline, Color3.fromRGB(0,0,0), 6)
                        --
                        local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                        --
                        local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                        local slider_drag_bar = utility.create("Square", {Parent = slider_fill, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = UDim2.new(0,2,1,6), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(1,0,0,-3)});
                        --
                        local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                        --[[
                        local minus = utility.create("Text", {Text = "-", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,10), ZIndex = 7});
                        local plus = utility.create("Text", {Text = "+", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(1,-6,0,10), ZIndex = 7});
                        --
                        local minus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(minus.Position.X.Scale, minus.Position.X.Offset,minus.Position.Y.Scale,minus.Position.Y.Offset)});
                        local plus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(plus.Position.X.Scale, plus.Position.X.Offset,plus.Position.Y.Scale,plus.Position.Y.Offset)});
                        -- functions]]
                        local function set(value)
                            value = math.clamp(utility.round(value, float), min, max)
                    
                            slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
                    
                            local sizeX = ((value - min) / (max - min))
                            --slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                            local fill = tween.new(slider_fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)})
                            fill:Play()
                            library.flags[flag] = value
                            callback(value)
                            val = value
                        end
                    
                        set(default)
                    
                        local sliding = false
                    
                        local function slide(input)
                            local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                            local value = ((max - min) * sizeX) + min
                    
                            set(value)
                        end
                    
                        utility.connect(slider_drag.InputBegan, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = true
                                slide(input)
                            end
                        end)
                    
                        utility.connect(slider_drag.InputEnded, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = false
                            end
                        end)
                    
                        utility.connect(slider_fill.InputBegan, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = true
                                slide(input)
                            end
                        end)
                    
                        utility.connect(slider_fill.InputEnded, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                sliding = false
                            end
                        end)
                    
                        utility.connect(services.InputService.InputChanged, function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                if sliding then
                                    slide(input)
                                end
                            end
                        end)
            
                        --[[utility.connect(plus_detect.MouseButton1Click, function()
                            set(val + 1)
                        end)
            
                        utility.connect(minus_detect.MouseButton1Click, function()
                            set(val - 1)
                        end)--]]
                    
                        flags[flag] = set
                    
                        function slider_tbl:set(value)
                            set(value)
                        end
                        --
                        return slider_tbl;
                    end;
                    --]]
                    return toggletypes;
                end;
                -- create slider
                function container_tbl:new_slider(cfg)
                    -- settings
                    local slider_tbl = {};
                    local name = cfg.name or cfg.Name or "new slider";
                    local min = cfg.min or cfg.minimum or 0;
                    local max = cfg.max or cfg.maximum or 100;
                    local text = cfg.text or ("[value]");
                    local float = cfg.float or 1;
                    local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                    local flag = cfg.flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local val = default;
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                    -- drawings
                    local holder = utility.create("Square", {Parent = multicontent, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 7});
                    --
                    if allow_tool then
                       tooltip(cfg, tooltip_text, holder)
                    end
                    local slider_frame = utility.create("Square",{
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0, 150, 0, 15),
                        Filled = true,
                        Parent = holder,
                        Thickness = 1,
                        ZIndex = 6
                    })
                    local outline = utility.outline(slider_frame, Color3.fromRGB(50,50,50), 6)
                    utility.outline(outline, Color3.fromRGB(0,0,0), 6)
                    --
                    local slider_title = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,155,0,0), ZIndex = 7});
                    local slider_title_shadow = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,155,0,1), ZIndex = 6});
                    --
                    local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                    --
                    local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                    local slider_drag_bar = utility.create("Square", {Parent = slider_fill, Visible = true, Transparency = 0.5, Color = Color3.new(0.168627, 0.168627, 0.168627), Size = UDim2.new(0,10,1,-2), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(1,-12,0,1)});
                    --
                    local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                    --[[
                    local minus = utility.create("Text", {Text = "-", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,10), ZIndex = 7});
                    local plus = utility.create("Text", {Text = "+", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(1,-6,0,10), ZIndex = 7});
                    --
                    local minus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(minus.Position.X.Scale, minus.Position.X.Offset,minus.Position.Y.Scale,minus.Position.Y.Offset)});
                    local plus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(plus.Position.X.Scale, plus.Position.X.Offset,plus.Position.Y.Scale,plus.Position.Y.Offset)});
                    -- functions]]
                    local function set(value)
                        value = math.clamp(utility.round(value, float), min, max)
                
                        slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
                
                        local sizeX = ((value - min) / (max - min))
                        --slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                        local fill = tween.new(slider_fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)})
                        fill:Play()
                        library.flags[flag] = value
                        callback(value)
                        if sizeX < 0.11 then
                            slider_drag_bar.Visible = false
                        else
                            slider_drag_bar.Visible = true
                        end
                        val = value
                    end
                
                    set(default)
                
                    local sliding = false
                
                    local function slide(input)
                        local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                        local value = ((max - min) * sizeX) + min
                
                        set(value)
                    end
                
                    utility.connect(slider_drag.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = true
                            slide(input)
                        end
                    end)
                
                    utility.connect(slider_drag.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = false
                        end
                    end)
                
                    utility.connect(slider_fill.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = true
                            slide(input)
                        end
                    end)
                
                    utility.connect(slider_fill.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = false
                        end
                    end)
                
                    utility.connect(services.InputService.InputChanged, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            if sliding then
                                slide(input)
                            end
                        end
                    end)
        
                    --[[utility.connect(plus_detect.MouseButton1Click, function()
                        set(val + 1)
                    end)
        
                    utility.connect(minus_detect.MouseButton1Click, function()
                        set(val - 1)
                    end)--]]
                
                    flags[flag] = set
                
                    function slider_tbl:set(value)
                        set(value)
                    end
                    --
                    return slider_tbl;
                end;
                -- create dropdown
                function container_tbl:new_dropdown(cfg)
                    local dropdown_tbl = {};
                    local name = cfg.name or cfg.Name or "new dropdown";
                    local default = cfg.default or cfg.Default or nil;
                    local content = type(cfg.options or cfg.Options) == "table" and cfg.options or cfg.Options or {};
                    local max = cfg.max or cfg.Max and (cfg.max > 1 and cfg.max) or nil;
                    local scrollable = cfg.scrollable or false;
                    local scrollingmax = cfg.scrollingmax or 10;
                    local flag = cfg.flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                    if not max and type(default) == "table" then
                        default = nil
                    end
                    if max and default == nil then
                        default = {}
                    end
                    if type(default) == "table" then
                        if max then
                            for i, opt in next, default do
                                if not table.find(content, opt) then
                                    table.remove(default, i)
                                elseif i > max then
                                    table.remove(default, i)
                                end
                            end
                        else
                            default = nil
                        end
                    elseif default ~= nil then
                        if not table.find(content, default) then
                            default = nil
                        end
                    end
                    --
                    local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multicontent});
                    if allow_tool then
                       tooltip(cfg, tooltip_text, holder)
                    end
                    --
                    local title = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, 105, 0, 0),
                        Theme = "Text",
                        ZIndex = 7,
                        Outline = false,
                        Parent = holder
                    });
                    local title_shadow = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, 105, 0, 1),
                        Color = Color3.new(0,0,0),
                        ZIndex = 6,
                        Outline = false,
                        Parent = holder
                    });
                    --
                    local dropdown = utility.create("Square", {
                        Filled = true,
                        Visible = true,
                        Thickness = 1,
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0, 100, 0, 15),
                        Position = UDim2.new(0, 0, 0,0),
                        ZIndex = 7,
                        Parent = holder
                    })
                
                    local outline = utility.outline(dropdown, Color3.fromRGB(50,50,50), 7)
                    utility.outline(outline, Color3.fromRGB(0,0,0), 7)
                
                    local value = utility.create("Text", {
                        Text = "",
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, 2, 0, 0),
                        Theme = "Text",
                        ZIndex = 9,
                        Outline = false,
                        Parent = dropdown
                    })
                
                    local contentframe = utility.create("Square", {
                        Filled = true,
                        Visible = false,
                        Thickness = 1,
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(1,0,0,0),
                        Position = UDim2.new(0, 0, 1, 3),
                        ZIndex = 12,
                        Parent = dropdown
                    })
                
                    local outline1 = utility.outline(contentframe, Color3.fromRGB(50,50,50))
                    utility.outline(outline1, Color3.fromRGB(0,0,0))
                
                    local contentholder = utility.create("Square", {
                        Transparency = 0,
                        Size = UDim2.new(1, -6, 1, -6),
                        Position = UDim2.new(0, 3, 0, 3),
                        Parent = contentframe
                    })
                
                    if scrollable then
                        contentholder:MakeScrollable()
                    end
                
                    contentholder:AddListLayout(3)
                
                    local mouseover = false
                
                    local opened = false
                
                    if not islist then
                        dropdown.MouseButton1Click:Connect(function()
                            opened = not opened
                            contentframe.Visible = opened
                        end)
                    end
                
                    local optioninstances = {}
                    local count = 0
                    local countindex = {}
                
                    local function createoption(name)
                        optioninstances[name] = {}
                
                        countindex[name] = count + 1
                
                        local button = utility.create("Square", {
                            Filled = true,
                            Transparency = 0,
                            Thickness = 1,
                            Size = UDim2.new(1, 0, 0, 16),
                            ZIndex = 14,
                            Parent = contentholder
                        })
                
                        optioninstances[name].button = button
                
                        local title = utility.create("Text", {
                            Text = name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0, 8, 0, 1),
                            Theme = "Text",
                            ZIndex = 15,
                            Outline = true,
                            Parent = button
                        })
                
                        optioninstances[name].text = title
                
                        if scrollable then
                            if count < scrollingmax then
                                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
                            end
                        else
                            contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
                        end
                
                        count = count + 1
                
                        return button, title
                    end
                
                    local chosen = max and {}
                
                    local function handleoptionclick(option, button, text)
                        button.MouseButton1Click:Connect(function()
                            if max then
                                if table.find(chosen, option) then
                                    table.remove(chosen, table.find(chosen, option))
                
                                    local textchosen = {}
                                    local cutobject = false
                
                                    for _, opt in next, chosen do
                                        table.insert(textchosen, opt)
                
                                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                                            cutobject = true
                                            table.remove(textchosen, #textchosen)
                                        end
                                    end
                
                                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                
                                    utility.changeobjecttheme(text, "Text")
                
                                    library.flags[flag] = chosen
                                    callback(chosen)
                                else
                                    if #chosen == max then
                                        utility.changeobjecttheme(optioninstances[chosen[1]].text, "Text")
                
                                        table.remove(chosen, 1)
                                    end
                
                                    table.insert(chosen, option)
                
                                    local textchosen = {}
                                    local cutobject = false
                
                                    for _, opt in next, chosen do
                                        table.insert(textchosen, opt)
                
                                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                                            cutobject = true
                                            table.remove(textchosen, #textchosen)
                                        end
                                    end
                
                                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                
                                    utility.changeobjecttheme(text, "Accent")
                
                                    library.flags[flag] = chosen
                                    callback(chosen)
                                end
                            else
                                for opt, tbl in next, optioninstances do
                                    if opt ~= option then
                                        utility.changeobjecttheme(tbl.text, "Text")
                                    end
                                end
                
                                chosen = option
                
                                value.Text = option
                
                                utility.changeobjecttheme(text, "Accent")
                
                                library.flags[flag] = option
                                callback(option)
                
                            end
                        end)
                    end
                
                    local function createoptions(tbl)
                        for _, option in next, tbl do
                            local button, text = createoption(option)
                            handleoptionclick(option, button, text)
                        end
                    end
                
                    createoptions(content)
                
                    local set
                    set = function(option)
                        if max then
                            option = type(option) == "table" and option or {}
                            table.clear(chosen)
                
                            for opt, tbl in next, optioninstances do
                                if not table.find(option, opt) then
                                    --tbl.button.Transparency = 0
                                    utility.changeobjecttheme(tbl.text, "Text")
                                end
                            end
                
                            for i, opt in next, option do
                                if table.find(content, opt) and #chosen < max then
                                    table.insert(chosen, opt)
                                    --optioninstances[opt].button.Transparency = 1
                                    utility.changeobjecttheme(optioninstances[opt].text, "Accent")
                                end
                            end
                
                            local textchosen = {}
                            local cutobject = false
                
                            for _, opt in next, chosen do
                                table.insert(textchosen, opt)
                
                                if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                                    cutobject = true
                                    table.remove(textchosen, #textchosen)
                                end
                            end
                
                            value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                
                            library.flags[flag] = chosen
                            callback(chosen)
                        end
                
                        if not max then
                            for opt, tbl in next, optioninstances do
                                if opt ~= option then
                                    utility.changeobjecttheme(tbl.text, "Text")
                                end
                            end
                
                            if table.find(content, option) then
                                chosen = option
                
                                value.Text = option
                
                                utility.changeobjecttheme(optioninstances[option].text, "Accent")
                
                                library.flags[flag] = chosen
                                callback(chosen)
                            else
                                chosen = nil
                
                                value.Text = ""
                
                                library.flags[flag] = chosen
                                callback(chosen)
                            end
                        end
                    end
                
                    flags[flag] = set
                
                    set(default)
                
                    local dropdowntypes = utility.table({}, true)
                
                    function dropdowntypes:set(option)
                        set(option)
                    end
                
                    function dropdowntypes:refresh(tbl)
                        content = table.clone(tbl)
                        count = 0
                
                        for _, opt in next, optioninstances do
                            coroutine.wrap(function()
                                opt.button:Remove()
                            end)()
                        end
                
                        table.clear(optioninstances)
                
                        createoptions(tbl)
                
                        if scrollable then
                            contentholder:RefreshScrolling()
                        end
                
                        value.Text = ""
                
                        if max then
                            table.clear(chosen)
                        else
                            chosen = nil
                        end
                
                        library.flags[flag] = chosen
                        callback(chosen)
                    end
                
                    function dropdowntypes:add(option)
                        table.insert(content, option)
                        local button, text = createoption(option)
                        handleoptionclick(option, button, text)
                    end
                
                    function dropdowntypes:remove(option)
                        if optioninstances[option] then
                            count = count - 1
                
                            optioninstances[option].button:Remove()
                
                            if scrollable then
                                contentframe.Size = UDim2.new(1, 0, 0, math.clamp(contentholder.AbsoluteContentSize, 0, (scrollingmax * 16) + ((scrollingmax - 1) * 3)) + 6)
                            else
                                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
                            end
                
                            optioninstances[option] = nil
                
                            if max then
                                if table.find(chosen, option) then
                                    table.remove(chosen, table.find(chosen, option))
                
                                    local textchosen = {}
                                    local cutobject = false
                
                                    for _, opt in next, chosen do
                                        table.insert(textchosen, opt)
                
                                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                                            cutobject = true
                                            table.remove(textchosen, #textchosen)
                                        end
                                    end
                
                                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")
                
                                    library.flags[flag] = chosen
                                    callback(chosen)
                                end
                            end
                        end
                    end
                
                    return dropdowntypes
                end;
                -- create keybind
                function container_tbl:new_keybind(cfg)
                    local dropdown_tbl = {};
                    local name = cfg.name or cfg.Name or "new keybind";
                    local key_name = cfg.keybind_name or cfg.KeyBind_Name or name;
                    local default = cfg.default or cfg.Default or nil;
                    local mode = cfg.mode or cfg.Mode or "Hold";
                    local blacklist = cfg.blacklist or cfg.Blacklist or {};
                    local flag = cfg.flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local ignore_list = cfg.ignore or cfg.Ignore or false;
                    local allow_modes = cfg.change_modes or cfg.Change_Modes or false;
                    local key_mode = mode;
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                    --
                    local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multicontent});
                    if allow_tool then
                       tooltip(cfg, tooltip_text, holder)
                    end
                    --
                    local title = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, 105, 0, 0),
                        Color = Color3.new(1,1,1),
                        ZIndex = 7,
                        Outline = false,
                        Parent = holder
                    });
                    local shadowtitle = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, 105, 0, 1),
                        Color = Color3.new(0,0,0),
                        ZIndex = 6,
                        Outline = false,
                        Parent = holder
                    });
                    --
                    if not offset then
                        offset = -1
                    end
                
                    local keybindname = key_name or "";
                
                    local frame = utility.create("Square",{
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0, 100, 0, 15),
                        Filled = true,
                        Parent = holder,
                        Thickness = 1,
                        ZIndex = 8
                    })
        
                    local outline = utility.outline(frame, Color3.fromRGB(50,50,50), 7)
                    utility.outline(outline, Color3.fromRGB(0,0,0), 7)
        
                    if allow_modes then
                        local mode_frame = utility.create("Square",{
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0,44,0,35),
                            Position = UDim2.new(1,10,0,-10),
                            Filled = true,
                            Parent = frame,
                            Thickness = 1,
                            ZIndex = 8,
                            Visible = false
                        })
                    
                        local mode_outline1 = utility.outline(mode_frame, Color3.fromRGB(50,50,50), 8)
                        utility.outline(mode_outline1, Color3.fromRGB(0,0,0), 8)
            
                        local holdtext = utility.create("Text", {
                            Text = "Hold",
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Theme = key_mode == "Hold" and "Accent" or "Text",
                            Position = UDim2.new(0.5,0,0,2),
                            ZIndex = 8,
                            Parent = mode_frame,
                            Outline = false,
                            Center = true
                        })
                        
                        local toggletext = utility.create("Text", {
                            Text = "Toggle",
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Theme = key_mode == "Toggle" and "Accent" or "Text",
                            Position = UDim2.new(0.5,0,0,18),
                            ZIndex = 8,
                            Parent = mode_frame,
                            Outline = false,
                            Center = true
                        })
            
                        local holdbutton = utility.create("Square",{
                            Color = Color3.new(0,0,0),
                            Size = UDim2.new(0,44,0,12),
                            Position = UDim2.new(0,0,0,2),
                            Filled = false,
                            Parent = mode_frame,
                            Thickness = 1,
                            ZIndex = 8,
                            Transparency = 0
                        })
            
                        local togglebutton = utility.create("Square",{
                            Color = Color3.new(0,0,0),
                            Size = UDim2.new(0,44,0,12),
                            Position = UDim2.new(0,0,0,20),
                            Filled = false,
                            Parent = mode_frame,
                            Thickness = 1,
                            ZIndex = 8,
                            Transparency = 0
                        })
        
                        local remove = utility.create("Square", {Filled = true, Position = UDim2.new(1,-20,0,3),Thickness = 1, Transparency = 0, Visible = true, Parent = frame, Size = UDim2.new(0,utility.textlength("x", 2, 13).X + 10, 0, 10), ZIndex = 13});
                        remove.MouseButton1Click:Connect(function()
                            mode_frame.Visible = true
                        end)
        
                        local removetext = utility.create("Text", {
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Color = Color3.fromRGB(255,255,255),
                            Position = UDim2.new(1,-20,0,0),
                            ZIndex = 8,
                            Parent = frame,
                            Outline = false,
                            Center = false,
                            Text = "...",
                            Transparency = 0.5
                        })
                        local removetext_bold = utility.create("Text", {
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Color = Color3.fromRGB(255,255,255),
                            Position = UDim2.new(1,-21,0,0),
                            ZIndex = 8,
                            Parent = frame,
                            Outline = false,
                            Center = false,
                            Text = "...",
                            Transparency = 0.5
                        })
                
        
                        holdbutton.MouseButton1Click:Connect(function()
                            key_mode = "Hold"
                            utility.changeobjecttheme(holdtext, "Accent")
                            utility.changeobjecttheme(toggletext, "Text")
                            mode_frame.Visible = false
                        end)
                        togglebutton.MouseButton1Click:Connect(function()
                            key_mode = "Toggle"
                            utility.changeobjecttheme(holdtext, "Text")
                            utility.changeobjecttheme(toggletext, "Accent")
                            mode_frame.Visible = false
                        end)
                    end
                
                    local keytext = utility.create("Text", {
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Theme = "Text",
                        Position = UDim2.new(0,2,0,0),
                        ZIndex = 8,
                        Parent = frame,
                        Outline = false,
                        Center = false
                    })
                    local list_obj = nil;
                    if ignore_list == false then
                        --list_obj = window_key_list:add_keybind(keybindname, keytext.Text)
                    end;
                
                    local key
                    local state = false
                    local binding
                
                    local function set(newkey)
                        if c then
                            c:Disconnect();
                            if flag then
                                library.flags[flag] = false;
                            end
                            callback(false);
                            if ignore_list == false then
                               --list_obj:is_active(false)
                            end
                        end
                        if tostring(newkey):find("Enum.KeyCode.") then
                            newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                        elseif tostring(newkey):find("Enum.UserInputType.") then
                            newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                        end
                
                        if newkey ~= nil and not table.find(blacklist, newkey) then
                            key = newkey
                
                            local text = (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                
                            keytext.Text = text
                            if ignore_list == false then
                                --list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                            end
                        else
                            key = nil
                
                            local text = ""
                
                            keytext.Text = text
                            if ignore_list == false then
                                --list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                            end
                        end
                
                        if bind ~= '' or bind ~= nil then
                            state = false
                            if flag then
                                library.flags[flag] = state;
                            end
                            callback(false)
                            if ignore_list == false then
                               --list_obj:is_active(state)
                            end
                        end
                    end
                
                    utility.connect(services.InputService.InputBegan, function(inp)
                        if (inp.KeyCode == key or inp.UserInputType == key) and not binding then
                            if key_mode == "Hold" then
                                if flag then
                                    library.flags[flag] = true
                                end
                                if ignore_list == false then
                                   --list_obj:is_active(true)
                                end
                                c = utility.connect(game:GetService("RunService").RenderStepped, function()
                                    if callback then
                                        callback(true)
                                    end
                                end)
                            else
                                state = not state
                                if flag then
                                    library.flags[flag] = state;
                                end
                                callback(state)
                                if ignore_list == false then
                                   --list_obj:is_active(state)
                                end
                            end
                        end
                    end)
                
                    set(default)
                
                    frame.MouseButton1Click:Connect(function()
                        if not binding then
                
                            keytext.Text = "..."
                            
                            binding = utility.connect(services.InputService.InputBegan, function(input, gpe)
                                set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                                utility.disconnect(binding)
                                task.wait()
                                binding = nil
                            end)
                        end
                    end)
                
                    utility.connect(services.InputService.InputEnded, function(inp)
                        if key_mode == "Hold" then
                            if key ~= '' or key ~= nil then
                                if inp.KeyCode == key or inp.UserInputType == key then
                                    if c then
                                        c:Disconnect()
                                        if ignore_list == false then
                                           --list_obj:is_active(false)
                                        end
                                        if flag then
                                            library.flags[flag] = false;
                                        end
                                        if callback then
                                            callback(false)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                
                    local keybindtypes = {};
                
                    function keybindtypes:set(newkey)
                        set(newkey)
                    end
                    return keybindtypes
                end;
                -- create textbox
                function container_tbl:new_textbox(cfg)
                    -- settings
                    local textbox_tbl = {};
                    local placeholder = cfg.placeholder or cfg.Placeholder or "new textbox";
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                    local default = cfg.Default or cfg.default or "";
                    local middle = cfg.middle or cfg.Middle or false;
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    -- drawings
                    local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multicontent});
                    if allow_tool then
                       tooltip(cfg, tooltip_text, holder)
                    end
                    --
                    local textbox = utility.create("Square", {
                        Filled = true,
                        Visible = true,
                        Thickness = 0,
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0,100,0,15),
                        ZIndex = 7,
                        Parent = holder
                    })
                    local outline = utility.outline(textbox, Color3.fromRGB(50,50,50), 7)
                    utility.outline(outline, Color3.fromRGB(0,0,0), 7)
                    --
                    local text = utility.create("Text", {
                        Text = default,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Center = middle,
                        Position = middle and UDim2.new(0.5,0,0,1) or UDim2.new(0, 2, 0, 1),
                        Color = Color3.fromRGB(255,255,255),
                        ZIndex = 9,
                        Outline = false,
                        Parent = textbox
                    })
                    --
                    local placeholder = utility.create("Text", {
                        Text = placeholder,
                        Font = Drawing.Fonts.Plex,
                        Transparency = 0.5,
                        Size = 13,
                        Center = middle,
                        Position = middle and UDim2.new(0.5,0,0,1) or UDim2.new(0, 2, 0, 1),
                        Color = Color3.fromRGB(255,255,255),
                        ZIndex = 9,
                        Outline = false,
                        Parent = textbox
                    })
                    -- functions
                    library.object_textbox(textbox, text,  function(str) 
                        if str == "" then
                            placeholder.Visible = true
                            text.Visible = false
                        else
                            placeholder.Visible = false
                            text.Visible = true
                        end
                    end, function(str)
                        library.flags[flag] = str
                        callback(str)
                        if utility.textlength(str, 2, 13).X > (textbox.AbsoluteSize.X) then
                            textbox.Size = UDim2.new(0,utility.textlength(str, 2, 13).X + 5, 0, 15)
                        else
                            textbox.Size = UDim2.new(0, 100, 0, 15)
                        end
                    end)
        
                    local function set(str)
                        text.Visible = str ~= ""
                        placeholder.Visible = str == ""
                        text.Text = str
                        library.flags[flag] = str
                        callback(str)
                        if utility.textlength(str, 2, 13).X > textbox.Size.X.Offset then
                            textbox.Size = UDim2.new(0,utility.textlength(str, 2, 13).X + 5, 0, 15)
                        else
                            textbox.Size = UDim2.new(0, 100, 0, 15)
                        end
                    end
        
                    set(default)
        
                    flags[flag] = set
        
                    function textbox_tbl:Set(str)
                        set(str)
                    end
                    return textbox_tbl
                end;
                -- create cp
                function container_tbl:new_colorpicker(cfg)
                    local colorpicker_tbl = {}
                    local name = cfg.name or cfg.Name or "new colorpicker";
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local defaultalpha = cfg.alpha or cfg.Alpha or 1
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
        
                    local holder = utility.create("Square", {
                        Transparency = 0,
                        Filled = true,
                        Thickness = 1,
                        Size = UDim2.new(1, 0, 0, 10),
                        ZIndex = 7,
                        Parent = multicontent
                    })
                    if allow_tool then
                       tooltip(cfg, tooltip_text, holder)
                    end
        
                    local title = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, -1, 0, -1),
                        Theme = "Text",
                        ZIndex = 7,
                        Outline = false,
                        Parent = holder
                    })
        
                    local colorpickers = 0
        
                    local colorpickertypes = library.object_colorpicker(default, defaultalpha, holder, colorpickers, flag, callback, -2)
        
                    function colorpickertypes:new_colorpicker(cfg)
                        colorpickers = colorpickers + 1
                        local cp_tbl = {}
        
                        utility.table(cfg)
                        local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                        local flag = cfg.flag or cfg.Flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local defaultalpha = cfg.alpha or cfg.Alpha or 1
        
                        local cp = library.object_colorpicker(default, defaultalpha, holder, colorpickers, flag, callback, -2)
                        function cp_tbl:set(color)
                            cp:set(color, false, true)
                        end
                        return cp_tbl
                    end
        
                    function colorpicker_tbl:set(color)
                        colorpickertypes:set(color, false, true)
                    end
                    return colorpicker_tbl
                end;
                -- create button
                function container_tbl:new_button(cfg)
                    local button_tbl = {};
                    local button_name = cfg.name or cfg.Name or "new button";
                    local button_confirm = cfg.confirm or cfg.Confirm or false;
                    local callback = cfg.callback or cfg.Callback or function() end;
                    local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                    local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                    --
                    local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = multicontent});
                    if allow_tool then
                       tooltip(cfg, tooltip_text, holder)
                    end
                    --
                    local frame = utility.create("Square",{
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0, utility.textlength(button_name, 2, 13).X + 5, 0, 15),
                        Filled = true,
                        Parent = holder,
                        Thickness = 1,
                        ZIndex = 8
                    })
                    utility.outline(frame, Color3.fromRGB(0,0,0), 7)
                    local title = utility.create("Text", {
                        Text = button_name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0.5,0,0,0),
                        Color = Color3.fromRGB(255,255,255),
                        ZIndex = 9,
                        Outline = false,
                        Center = true,
                        Parent = frame
                    });
                    -- functions
                    local clicked, counting = false, false
                    utility.connect(frame.MouseButton1Click, function()
                        task.spawn(function()
                            if button_confirm then
                                if clicked then
                                    clicked = false
                                    counting = false
                                    title.Text = button_name
                                    callback()
                                else
                                    clicked = true
                                    counting = true
                                    for i = 3,1,-1 do
                                        if not counting then
                                            break
                                        end
                                        title.Text = 'confirm ? ' .. tostring(i)
                                        wait(1)
                                    end
                                    clicked = false
                                    counting = false
                                    title.Text = button_name
                                end
                            else
                                callback()
                            end;
                        end);
                    end);
                    --
                    function button_tbl:new_button(cfg)
                        local button_name = cfg.name or cfg.Name or "new button";
                        local button_confirm = cfg.confirm or cfg.Confirm or false;
                        local callback = cfg.callback or cfg.Callback or function() end;
                        --
                        local button_frame = utility.create("Square",{
                            Color = Color3.fromRGB(13,13,13),
                            Size = UDim2.new(0, utility.textlength(button_name, 2, 13).X + 5, 0, 15),
                            Filled = true,
                            Parent = holder,
                            Thickness = 1,
                            ZIndex = 8,
                            Position = UDim2.new(0, frame.AbsoluteSize.X + 5,0,0)
                        })
                        utility.outline(button_frame, Color3.fromRGB(0,0,0), 7)
                        local title = utility.create("Text", {
                            Text = button_name,
                            Font = Drawing.Fonts.Plex,
                            Size = 13,
                            Position = UDim2.new(0.5,0,0,0),
                            Color = Color3.fromRGB(255,255,255),
                            ZIndex = 9,
                            Outline = false,
                            Center = true,
                            Parent = button_frame
                        });
                        -- functions
                        local clicked, counting = false, false
                        utility.connect(frame.MouseButton1Click, function()
                            task.spawn(function()
                                if button_confirm then
                                    if clicked then
                                        clicked = false
                                        counting = false
                                        title.Text = button_name
                                        callback()
                                    else
                                        clicked = true
                                        counting = true
                                        for i = 3,1,-1 do
                                            if not counting then
                                                break
                                            end
                                            title.Text = 'confirm ? ' .. tostring(i)
                                            wait(1)
                                        end
                                        clicked = false
                                        counting = false
                                        title.Text = button_name
                                    end
                                else
                                    callback()
                                end;
                            end);
                        end);
                    end;
                    return button_tbl
                end;
                --
                return container_tbl;
            end;
            -- create toggle
            function section_table:new_toggle(cfg)
                -- settings
                local toggle_tbl = {colorpickers = 0};
                local toggle_name = cfg.name or cfg.Name or "invalid name";
                local toggle_risky = cfg.risky or cfg.Risky or false;
                local toggle_state = cfg.state or cfg.State or false;
                local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag();
                local callback = cfg.callback or cfg.Callback or function() end;
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                local toggled = false;
                -- drawings
                local holder = utility.create("Square", {Parent = content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 7});
                --
                local toggle_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Color = Color3.fromRGB(65,65,65), Size = UDim2.new(0,8,0,8), Thickness = 1, Filled = true, ZIndex = 7}) do
                    local outline = utility.outline(toggle_frame, Color3.fromRGB(85,85,85), 7);
                    utility.outline(outline, Color3.fromRGB(0,0,0), 7);
                end;
                local accent = utility.create("Square", {Parent = toggle_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 7, Theme = "Accent"})
                --
                local toggle_title = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = toggle_risky and Color3.fromRGB(255, 57, 57) or Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-3), ZIndex = 7});
                local toggle_title_shadow = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-2), ZIndex = 6});
                -- functions
                local function setstate()
                    toggled = not toggled
                    if toggled then
                        local accentfade = tween.new(accent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
                        accentfade:Play()
                    else
                        local accentfadeout = tween.new(accent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                        accentfadeout:Play()
                    end
                    library.flags[toggle_flag] = toggled
                    callback(toggled)
                end;
                --
                holder.MouseButton1Click:Connect(setstate);
                if allow_tool then
                   tooltip(cfg, tooltip_text, holder)
                end
                --
                local function set(bool)
                    bool = type(bool) == "boolean" and bool or false
                    if toggled ~= bool then
                        setstate()
                    end;
                end;
                set(toggle_state);
                flags[toggle_flag] = set;
                -- toggle functions
                local toggletypes = {}
                function toggletypes:set(bool)
                    set(bool)
                end;
                --
                function toggletypes:new_colorpicker(cfg)
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local colorpicker_tbl = {};
                    local defaultalpha = cfg.alpha or cfg.Alpha or 1
    
                    toggle_tbl.colorpickers += 1
    
                    local cp = library.object_colorpicker(default, defaultalpha, holder, toggle_tbl.colorpickers - 1, flag, callback, -4)
                    function colorpicker_tbl:set(color)
                        cp:set(color, false, true)
                    end
                    return colorpicker_tbl
                end;
                --
                function toggletypes:new_slider(cfg)
                    -- settings
                    local slider_tbl = {};
                    local min = cfg.min or cfg.minimum or 0;
                    local max = cfg.max or cfg.maximum or 100;
                    local text = cfg.text or ("[value]");
                    local float = cfg.float or 1;
                    local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                    local flag = cfg.flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local val = default;
                    -- drawings
                    local slider_holder = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 2});
                    --
                    local slider_frame = utility.create("Square",{
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0, 100, 0, 8),
                        Position = UDim2.new(0, utility.textlength(toggle_name, 2, 13).X + 20, 0,0),
                        Filled = true,
                        Parent = slider_holder,
                        Thickness = 1,
                        ZIndex = 6
                    })
                    local outline = utility.outline(slider_frame, Color3.fromRGB(50,50,50), 6)
                    utility.outline(outline, Color3.fromRGB(0,0,0), 6)
                    --
                    local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                    --
                    local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                    local slider_drag_bar = utility.create("Square", {Parent = slider_fill, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = UDim2.new(0,2,1,6), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(1,0,0,-3)});
                    --
                    local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                    --[[
                    local minus = utility.create("Text", {Text = "-", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,10), ZIndex = 7});
                    local plus = utility.create("Text", {Text = "+", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(1,-6,0,10), ZIndex = 7});
                    --
                    local minus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(minus.Position.X.Scale, minus.Position.X.Offset,minus.Position.Y.Scale,minus.Position.Y.Offset)});
                    local plus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(plus.Position.X.Scale, plus.Position.X.Offset,plus.Position.Y.Scale,plus.Position.Y.Offset)});
                    -- functions]]
                    local function set(value)
                        value = math.clamp(utility.round(value, float), min, max)
                
                        slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
                
                        local sizeX = ((value - min) / (max - min))
                        --slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                        local fill = tween.new(slider_fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)})
                        fill:Play()
                        library.flags[flag] = value
                        callback(value)
                        val = value
                    end
                
                    set(default)
                
                    local sliding = false
                
                    local function slide(input)
                        local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                        local value = ((max - min) * sizeX) + min
                
                        set(value)
                    end
                
                    utility.connect(slider_drag.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = true
                            slide(input)
                        end
                    end)
                
                    utility.connect(slider_drag.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = false
                        end
                    end)
                
                    utility.connect(slider_fill.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = true
                            slide(input)
                        end
                    end)
                
                    utility.connect(slider_fill.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = false
                        end
                    end)
                
                    utility.connect(services.InputService.InputChanged, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            if sliding then
                                slide(input)
                            end
                        end
                    end)
        
                    --[[utility.connect(plus_detect.MouseButton1Click, function()
                        set(val + 1)
                    end)
        
                    utility.connect(minus_detect.MouseButton1Click, function()
                        set(val - 1)
                    end)--]]
                
                    flags[flag] = set
                
                    function slider_tbl:set(value)
                        set(value)
                    end
                    --
                    return slider_tbl;
                end;
                --]]
                return toggletypes;
            end;
            -- create slider
            function section_table:new_slider(cfg)
                -- settings
                local slider_tbl = {};
                local name = cfg.name or cfg.Name or "new slider";
                local min = cfg.min or cfg.minimum or 0;
                local max = cfg.max or cfg.maximum or 100;
                local text = cfg.text or ("[value]");
                local float = cfg.float or 1;
                local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                local flag = cfg.flag or utility.nextflag();
                local callback = cfg.callback or function() end;
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                local val = default;
                -- drawings
                local holder = utility.create("Square", {Parent = content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 7});
                --
                local slider_frame = utility.create("Square",{
                    Color = Color3.fromRGB(13,13,13),
                    Size = UDim2.new(0, 150, 0, 15),
                    Filled = true,
                    Parent = holder,
                    Thickness = 1,
                    ZIndex = 6
                })
                local outline = utility.outline(slider_frame, Color3.fromRGB(50,50,50), 6)
                utility.outline(outline, Color3.fromRGB(0,0,0), 6)
                --
                local slider_title = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,155,0,0), ZIndex = 7});
                local slider_title_shadow = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,155,0,1), ZIndex = 6});
                --
                local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                --
                local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                local slider_drag_bar = utility.create("Square", {Parent = slider_fill, Visible = true, Transparency = 0.5, Color = Color3.new(0.168627, 0.168627, 0.168627), Size = UDim2.new(0,10,1,-2), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(1,-12,0,1)});
                --
                local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                --[[
                local minus = utility.create("Text", {Text = "-", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,0,0,10), ZIndex = 7});
                local plus = utility.create("Text", {Text = "+", Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(1,1,1), Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(1,-6,0,10), ZIndex = 7});
                --
                local minus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(minus.Position.X.Scale, minus.Position.X.Offset,minus.Position.Y.Scale,minus.Position.Y.Offset)});
                local plus_detect = utility.create("Square", {Parent = holder, Visible = true, Transparency = 0, Size = UDim2.new(0,14,0,14), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(plus.Position.X.Scale, plus.Position.X.Offset,plus.Position.Y.Scale,plus.Position.Y.Offset)});
                -- functions]]
                local function set(value)
                    value = math.clamp(utility.round(value, float), min, max)
            
                    slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
            
                    local sizeX = ((value - min) / (max - min))
                    --slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                    local fill = tween.new(slider_fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)})
                    fill:Play()
                    library.flags[flag] = value
                    callback(value)
                    if sizeX < 0.11 then
                        slider_drag_bar.Visible = false
                    else
                        slider_drag_bar.Visible = true
                    end
                    val = value
                end
                if allow_tool then
                   tooltip(cfg, tooltip_text, holder)
                end
            
                set(default)
            
                local sliding = false
            
                local function slide(input)
                    local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                    local value = ((max - min) * sizeX) + min
            
                    set(value)
                end
            
                utility.connect(slider_drag.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        slide(input)
                    end
                end)
            
                utility.connect(slider_drag.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
            
                utility.connect(slider_fill.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        slide(input)
                    end
                end)
            
                utility.connect(slider_fill.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
            
                utility.connect(services.InputService.InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if sliding then
                            slide(input)
                        end
                    end
                end)
    
                --[[utility.connect(plus_detect.MouseButton1Click, function()
                    set(val + 1)
                end)
    
                utility.connect(minus_detect.MouseButton1Click, function()
                    set(val - 1)
                end)--]]
            
                flags[flag] = set
            
                function slider_tbl:set(value)
                    set(value)
                end
                --
                return slider_tbl;
            end;
            -- create dropdown
            function section_table:new_dropdown(cfg)
                local dropdown_tbl = {};
                local name = cfg.name or cfg.Name or "new dropdown";
                local default = cfg.default or cfg.Default or nil;
                local dropdown_content = type(cfg.options or cfg.Options) == "table" and cfg.options or cfg.Options or {};
                local max = cfg.max or cfg.Max and (cfg.max > 1 and cfg.max) or nil;
                local scrollable = cfg.scrollable or false;
                local scrollingmax = cfg.scrollingmax or 10;
                local flag = cfg.flag or utility.nextflag();
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                local callback = cfg.callback or function() end;
                if not max and type(default) == "table" then
                    default = nil
                end
                if max and default == nil then
                    default = {}
                end
                if type(default) == "table" then
                    if max then
                        for i, opt in next, default do
                            if not table.find(dropdown_content, opt) then
                                table.remove(default, i)
                            elseif i > max then
                                table.remove(default, i)
                            end
                        end
                    else
                        default = nil
                    end
                elseif default ~= nil then
                    if not table.find(dropdown_content, default) then
                        default = nil
                    end
                end
                --
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = content});
                if allow_tool then
                   tooltip(cfg, tooltip_text, holder)
                end
                --
                local title = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, 105, 0, 0),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                });
                local title_shadow = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, 105, 0, 1),
                    Color = Color3.new(0,0,0),
                    ZIndex = 6,
                    Outline = false,
                    Parent = holder
                });
                --
                return library.object_dropdown(holder, dropdown_content, flag, callback, default, max, scrollable, scrollingmax)
            end;
            -- create keybind
            function section_table:new_keybind(cfg)
                local dropdown_tbl = {};
                local name = cfg.name or cfg.Name or "new keybind";
                local key_name = cfg.keybind_name or cfg.KeyBind_Name or name;
                local default = cfg.default or cfg.Default or nil;
                local mode = cfg.mode or cfg.Mode or "Hold";
                local blacklist = cfg.blacklist or cfg.Blacklist or {};
                local flag = cfg.flag or utility.nextflag();
                local callback = cfg.callback or function() end;
                local ignore_list = cfg.ignore or cfg.Ignore or false;
                local allow_modes = cfg.change_modes or cfg.Change_Modes or false;
                local key_mode = mode;
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                --
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = content});
                if allow_tool then
                   tooltip(cfg, tooltip_text, holder)
                end
                --
                local title = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, 105, 0, 0),
                    Color = Color3.new(1,1,1),
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                });
                local shadowtitle = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, 105, 0, 1),
                    Color = Color3.new(0,0,0),
                    ZIndex = 6,
                    Outline = false,
                    Parent = holder
                });
                --
                if not offset then
                    offset = -1
                end
            
                local keybindname = key_name or "";
            
                local frame = utility.create("Square",{
                    Color = Color3.fromRGB(13,13,13),
                    Size = UDim2.new(0, 100, 0, 15),
                    Filled = true,
                    Parent = holder,
                    Thickness = 1,
                    ZIndex = 8
                })
    
                local outline = utility.outline(frame, Color3.fromRGB(50,50,50), 7)
                utility.outline(outline, Color3.fromRGB(0,0,0), 7)
    
                if allow_modes then
                    local mode_frame = utility.create("Square",{
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0,44,0,35),
                        Position = UDim2.new(1,10,0,-10),
                        Filled = true,
                        Parent = frame,
                        Thickness = 1,
                        ZIndex = 8,
                        Visible = false
                    })
                
                    local mode_outline1 = utility.outline(mode_frame, Color3.fromRGB(50,50,50), 8)
                    utility.outline(mode_outline1, Color3.fromRGB(0,0,0), 8)
        
                    local holdtext = utility.create("Text", {
                        Text = "Hold",
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Theme = key_mode == "Hold" and "Accent" or "Text",
                        Position = UDim2.new(0.5,0,0,2),
                        ZIndex = 8,
                        Parent = mode_frame,
                        Outline = false,
                        Center = true
                    })
                    
                    local toggletext = utility.create("Text", {
                        Text = "Toggle",
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Theme = key_mode == "Toggle" and "Accent" or "Text",
                        Position = UDim2.new(0.5,0,0,18),
                        ZIndex = 8,
                        Parent = mode_frame,
                        Outline = false,
                        Center = true
                    })
        
                    local holdbutton = utility.create("Square",{
                        Color = Color3.new(0,0,0),
                        Size = UDim2.new(0,44,0,12),
                        Position = UDim2.new(0,0,0,2),
                        Filled = false,
                        Parent = mode_frame,
                        Thickness = 1,
                        ZIndex = 8,
                        Transparency = 0
                    })
        
                    local togglebutton = utility.create("Square",{
                        Color = Color3.new(0,0,0),
                        Size = UDim2.new(0,44,0,12),
                        Position = UDim2.new(0,0,0,20),
                        Filled = false,
                        Parent = mode_frame,
                        Thickness = 1,
                        ZIndex = 8,
                        Transparency = 0
                    })
    
                    local remove = utility.create("Square", {Filled = true, Position = UDim2.new(1,-20,0,3),Thickness = 1, Transparency = 0, Visible = true, Parent = frame, Size = UDim2.new(0,utility.textlength("x", 2, 13).X + 10, 0, 10), ZIndex = 13});
                    remove.MouseButton1Click:Connect(function()
                        mode_frame.Visible = true
                    end)
    
                    local removetext = utility.create("Text", {
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Color = Color3.fromRGB(255,255,255),
                        Position = UDim2.new(1,-20,0,0),
                        ZIndex = 8,
                        Parent = frame,
                        Outline = false,
                        Center = false,
                        Text = "...",
                        Transparency = 0.5
                    })
                    local removetext_bold = utility.create("Text", {
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Color = Color3.fromRGB(255,255,255),
                        Position = UDim2.new(1,-21,0,0),
                        ZIndex = 8,
                        Parent = frame,
                        Outline = false,
                        Center = false,
                        Text = "...",
                        Transparency = 0.5
                    })
            
    
                    holdbutton.MouseButton1Click:Connect(function()
                        key_mode = "Hold"
                        utility.changeobjecttheme(holdtext, "Accent")
                        utility.changeobjecttheme(toggletext, "Text")
                        mode_frame.Visible = false
                    end)
                    togglebutton.MouseButton1Click:Connect(function()
                        key_mode = "Toggle"
                        utility.changeobjecttheme(holdtext, "Text")
                        utility.changeobjecttheme(toggletext, "Accent")
                        mode_frame.Visible = false
                    end)
                end
            
                local keytext = utility.create("Text", {
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Theme = "Text",
                    Position = UDim2.new(0,2,0,0),
                    ZIndex = 8,
                    Parent = frame,
                    Outline = false,
                    Center = false
                })
                local list_obj = nil;
                if ignore_list == false then
                    --list_obj = window_key_list:add_keybind(keybindname, keytext.Text)
                end;
            
                local key
                local state = false
                local binding
            
                local function set(newkey)
                    if c then
                        c:Disconnect();
                        if flag then
                            library.flags[flag] = false;
                        end
                        callback(false);
                        if ignore_list == false then
                           --list_obj:is_active(false)
                        end
                    end
                    if tostring(newkey):find("Enum.KeyCode.") then
                        newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                    elseif tostring(newkey):find("Enum.UserInputType.") then
                        newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                    end
            
                    if newkey ~= nil and not table.find(blacklist, newkey) then
                        key = newkey
            
                        local text = (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
            
                        keytext.Text = text
                        if ignore_list == false then
                            --list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                        end
                    else
                        key = nil
            
                        local text = ""
            
                        keytext.Text = text
                        if ignore_list == false then
                            --list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                        end
                    end
            
                    if bind ~= '' or bind ~= nil then
                        state = false
                        if flag then
                            library.flags[flag] = state;
                        end
                        callback(false)
                        if ignore_list == false then
                           --list_obj:is_active(state)
                        end
                    end
                end
            
                utility.connect(services.InputService.InputBegan, function(inp)
                    if (inp.KeyCode == key or inp.UserInputType == key) and not binding then
                        if key_mode == "Hold" then
                            if flag then
                                library.flags[flag] = true
                            end
                            if ignore_list == false then
                               --list_obj:is_active(true)
                            end
                            c = utility.connect(game:GetService("RunService").RenderStepped, function()
                                if callback then
                                    callback(true)
                                end
                            end)
                        else
                            state = not state
                            if flag then
                                library.flags[flag] = state;
                            end
                            callback(state)
                            if ignore_list == false then
                               --list_obj:is_active(state)
                            end
                        end
                    end
                end)
            
                set(default)
            
                frame.MouseButton1Click:Connect(function()
                    if not binding then
            
                        keytext.Text = "..."
                        
                        binding = utility.connect(services.InputService.InputBegan, function(input, gpe)
                            set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                            utility.disconnect(binding)
                            task.wait()
                            binding = nil
                        end)
                    end
                end)
            
                utility.connect(services.InputService.InputEnded, function(inp)
                    if key_mode == "Hold" then
                        if key ~= '' or key ~= nil then
                            if inp.KeyCode == key or inp.UserInputType == key then
                                if c then
                                    c:Disconnect()
                                    if ignore_list == false then
                                       --list_obj:is_active(false)
                                    end
                                    if flag then
                                        library.flags[flag] = false;
                                    end
                                    if callback then
                                        callback(false)
                                    end
                                end
                            end
                        end
                    end
                end)
            
                local keybindtypes = {};
            
                function keybindtypes:set(newkey)
                    set(newkey)
                end
            
                return keybindtypes
            end;
            -- create textbox
            function section_table:new_textbox(cfg)
                -- settings
                local textbox_tbl = {};
                local placeholder = cfg.placeholder or cfg.Placeholder or "new textbox";
                local default = cfg.Default or cfg.default or "";
                local middle = cfg.middle or cfg.Middle or false;
                local flag = cfg.flag or cfg.Flag or utility.nextflag();
                local callback = cfg.callback or function() end;
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                -- drawings
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = content});
                if allow_tool then
                    tooltip(cfg, tooltip_text, holder)
                end
                --
                local textbox = utility.create("Square", {
                    Filled = true,
                    Visible = true,
                    Thickness = 0,
                    Color = Color3.fromRGB(13,13,13),
                    Size = UDim2.new(0,100,0,15),
                    ZIndex = 7,
                    Parent = holder
                })
                local outline = utility.outline(textbox, Color3.fromRGB(50,50,50), 7)
                utility.outline(outline, Color3.fromRGB(0,0,0), 7)
                --
                local text = utility.create("Text", {
                    Text = default,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Center = middle,
                    Position = middle and UDim2.new(0.5,0,0,1) or UDim2.new(0, 2, 0, 1),
                    Color = Color3.fromRGB(255,255,255),
                    ZIndex = 9,
                    Outline = false,
                    Parent = textbox
                })
                --
                local placeholder = utility.create("Text", {
                    Text = placeholder,
                    Font = Drawing.Fonts.Plex,
                    Transparency = 0.5,
                    Size = 13,
                    Center = middle,
                    Position = middle and UDim2.new(0.5,0,0,1) or UDim2.new(0, 2, 0, 1),
                    Color = Color3.fromRGB(255,255,255),
                    ZIndex = 9,
                    Outline = false,
                    Parent = textbox
                })
                -- functions
                library.object_textbox(textbox, text,  function(str) 
                    if str == "" then
                        placeholder.Visible = true
                        text.Visible = false
                    else
                        placeholder.Visible = false
                        text.Visible = true
                    end
                end, function(str)
                    library.flags[flag] = str
                    callback(str)
                    if utility.textlength(str, 2, 13).X > (textbox.AbsoluteSize.X) then
                        textbox.Size = UDim2.new(0,utility.textlength(str, 2, 13).X + 5, 0, 15)
                    else
                        textbox.Size = UDim2.new(0, 100, 0, 15)
                    end
                end)
    
                local function set(str)
                    text.Visible = str ~= ""
                    placeholder.Visible = str == ""
                    text.Text = str
                    library.flags[flag] = str
                    callback(str)
                    if utility.textlength(str, 2, 13).X > textbox.Size.X.Offset then
                        textbox.Size = UDim2.new(0,utility.textlength(str, 2, 13).X + 5, 0, 15)
                    else
                        textbox.Size = UDim2.new(0, 100, 0, 15)
                    end
                end
    
                set(default)
    
                flags[flag] = set
    
                function textbox_tbl:Set(str)
                    set(str)
                end
    
                return textbox_tbl
            end;
            -- create cp
            function section_table:new_colorpicker(cfg)
                local colorpicker_tbl = {}
                local name = cfg.name or cfg.Name or "new colorpicker";
                local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                local flag = cfg.flag or cfg.Flag or utility.nextflag();
                local callback = cfg.callback or function() end;
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                local defaultalpha = cfg.alpha or cfg.Alpha or 1
    
                local holder = utility.create("Square", {
                    Transparency = 0,
                    Filled = true,
                    Thickness = 1,
                    Size = UDim2.new(1, 0, 0, 10),
                    ZIndex = 7,
                    Parent = content
                })
                if allow_tool then
                   tooltip(cfg, tooltip_text, holder)
                end
    
                local title = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, -1, 0, -1),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                })
    
                local colorpickers = 0
    
                local colorpickertypes = library.object_colorpicker(default, defaultalpha, holder, colorpickers, flag, callback, -2)
    
                function colorpickertypes:new_colorpicker(cfg)
                    colorpickers = colorpickers + 1
                    local cp_tbl = {}
    
                    utility.table(cfg)
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local defaultalpha = cfg.alpha or cfg.Alpha or 1
    
                    local cp = library.object_colorpicker(default, defaultalpha, holder, colorpickers, flag, callback, -2)
                    function cp_tbl:set(color)
                        cp:set(color, false, true)
                    end
                    return cp_tbl
                end
    
                function colorpicker_tbl:set(color)
                    colorpickertypes:set(color, false, true)
                end
                return colorpicker_tbl
            end;
            -- create button
            function section_table:new_button(cfg)
                local button_tbl = {};
                local button_name = cfg.name or cfg.Name or "new button";
                local button_confirm = cfg.confirm or cfg.Confirm or false;
                local callback = cfg.callback or cfg.Callback or function() end;
                local allow_tool = cfg.tooltip or cfg.ToolTip or false;
                local tooltip_text = cfg.tip_text or cfg.Tip_Text or '';
                --
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 15),Parent = content});
                if allow_tool then
                   tooltip(cfg, tooltip_text, holder)
                end
                --
                local frame = utility.create("Square",{
                    Color = Color3.fromRGB(13,13,13),
                    Size = UDim2.new(0, utility.textlength(button_name, 2, 13).X + 5, 0, 15),
                    Filled = true,
                    Parent = holder,
                    Thickness = 1,
                    ZIndex = 8
                })
                utility.outline(frame, Color3.fromRGB(0,0,0), 7)
                local title = utility.create("Text", {
                    Text = button_name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0.5,0,0,0),
                    Color = Color3.fromRGB(255,255,255),
                    ZIndex = 9,
                    Outline = false,
                    Center = true,
                    Parent = frame
                });
                -- functions
                local clicked, counting = false, false
                utility.connect(frame.MouseButton1Click, function()
                    task.spawn(function()
                        if button_confirm then
                            if clicked then
                                clicked = false
                                counting = false
                                title.Text = button_name
                                callback()
                            else
                                clicked = true
                                counting = true
                                for i = 3,1,-1 do
                                    if not counting then
                                        break
                                    end
                                    title.Text = 'confirm ? ' .. tostring(i)
                                    wait(1)
                                end
                                clicked = false
                                counting = false
                                title.Text = button_name
                            end
                        else
                            callback()
                        end;
                    end);
                end);
                --
                function button_tbl:new_button(cfg)
                    local button_name = cfg.name or cfg.Name or "new button";
                    local button_confirm = cfg.confirm or cfg.Confirm or false;
                    local callback = cfg.callback or cfg.Callback or function() end;
                    --
                    local button_frame = utility.create("Square",{
                        Color = Color3.fromRGB(13,13,13),
                        Size = UDim2.new(0, utility.textlength(button_name, 2, 13).X + 5, 0, 15),
                        Filled = true,
                        Parent = holder,
                        Thickness = 1,
                        ZIndex = 8,
                        Position = UDim2.new(0, frame.AbsoluteSize.X + 5,0,0)
                    })
                    utility.outline(button_frame, Color3.fromRGB(0,0,0), 7)
                    local title = utility.create("Text", {
                        Text = button_name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0.5,0,0,0),
                        Color = Color3.fromRGB(255,255,255),
                        ZIndex = 9,
                        Outline = false,
                        Center = true,
                        Parent = button_frame
                    });
                    -- functions
                    local clicked, counting = false, false
                    utility.connect(frame.MouseButton1Click, function()
                        task.spawn(function()
                            if button_confirm then
                                if clicked then
                                    clicked = false
                                    counting = false
                                    title.Text = button_name
                                    callback()
                                else
                                    clicked = true
                                    counting = true
                                    for i = 3,1,-1 do
                                        if not counting then
                                            break
                                        end
                                        title.Text = 'confirm ? ' .. tostring(i)
                                        wait(1)
                                    end
                                    clicked = false
                                    counting = false
                                    title.Text = button_name
                                end
                            else
                                callback()
                            end;
                        end);
                    end);
                end;
                return button_tbl
            end;
            -- return
            return section_table;
        end;
        -- return
        return page_table;
    end;
    -- function
    function window_table:rename_window(txt)
        window_title.Text = txt;
        window_title_shadow.Text = txt;
    end;
    --
    function window_table:get_config()
        local configtbl = {}

        for flag, _ in next, flags do
            if not table.find(configignores, flag) then
                local value = library.flags[flag]

                if typeof(value) == "EnumItem" then
                    configtbl[flag] = tostring(value)
                elseif typeof(value) == "Color3" then
                    configtbl[flag] = {color = value:ToHex(), alpha = value.A}
                else
                    configtbl[flag] = value
                end
            end
        end

        local config = game:GetService("HttpService"):JSONEncode(configtbl)
        --
        return config
    end;
    --
    function window_table:refresh_window()
        window_main.Position = UDim2.new(window_main.Position.X.Scale,window_main.Position.X.Offset,window_main.Position.Y.Scale,window_main.Position.Y.Offset)
    end;
    --
    function window_table:fix_zindex()
        for _,v in next, library.drawings do
            if v then
                v.ZIndex += 20
            end
        end
    end
    -- return
    return window_table;
end;

return library, settings
