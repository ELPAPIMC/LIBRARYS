--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║           NEXUS UI LIBRARY v3.0.0 - PROFESSIONAL             ║
    ║               Premium Roblox UI Framework                     ║
    ║                   By: Nexus Development                       ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    Features:
    - Advanced Theme System (5+ themes with gradients)
    - 15+ Premium Components
    - Professional Config System (CRUD + Cloud sync)
    - Smart Notification System
    - Performance Optimized (Virtual scrolling, lazy loading)
    - Mobile Support + Responsive Design
    - Drag & Drop, Keybinds, Tooltips
    - Debug Tools & Performance Monitor
--]]

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Main Library Table
local NexusUI = {
    Version = "3.0.0",
    Author = "Nexus Development",
    DebugMode = false,
    Windows = {},
    Notifications = {},
    GlobalCallbacks = {},
    SavedConfigs = {},
    Keybinds = {},
    Modules = {}
}

--[[═══════════════════════════════════════════════════════════════
    UTILITY FUNCTIONS
═══════════════════════════════════════════════════════════════]]

local Utility = {}
NexusUI.Modules.Utility = Utility

-- Safe execution wrapper
function Utility:Try(func, errorMessage)
    local success, result = pcall(func)
    if not success then
        warn("[Nexus UI Error]", errorMessage or "An error occurred", result)
        return false, result
    end
    return true, result
end

-- Debounce function
function Utility:Debounce(func, wait)
    local lastTime = 0
    return function(...)
        local now = tick()
        if now - lastTime >= wait then
            lastTime = now
            func(...)
        end
    end
end

-- Deep copy table
function Utility:DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = self:DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Lerp for smooth transitions
function Utility:Lerp(a, b, t)
    return a + (b - a) * t
end

-- Color conversion utilities
function Utility:RGBToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

function Utility:HexToRGB(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

-- Generate unique ID
function Utility:GenerateId()
    return HttpService:GenerateGUID(false)
end

-- Clamp value
function Utility:Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

--[[═══════════════════════════════════════════════════════════════
    THEME MANAGER
═══════════════════════════════════════════════════════════════]]

local ThemeManager = {}
NexusUI.Modules.ThemeManager = ThemeManager

ThemeManager.Themes = {
    Dark = {
        Name = "Dark Elegance",
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(108, 121, 255),
        Text = Color3.fromRGB(240, 240, 245),
        TextDark = Color3.fromRGB(160, 160, 170),
        Border = Color3.fromRGB(40, 40, 45),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26),
        Gradient1 = Color3.fromRGB(88, 101, 242),
        Gradient2 = Color3.fromRGB(138, 43, 226),
        GradientSpeed = 3
    },
    
    Light = {
        Name = "Light Serenity",
        Background = Color3.fromRGB(248, 249, 252),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(59, 130, 246),
        AccentHover = Color3.fromRGB(79, 150, 255),
        Text = Color3.fromRGB(15, 23, 42),
        TextDark = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(226, 232, 240),
        Success = Color3.fromRGB(34, 197, 94),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Gradient1 = Color3.fromRGB(59, 130, 246),
        Gradient2 = Color3.fromRGB(147, 51, 234),
        GradientSpeed = 2.5
    },
    
    Ocean = {
        Name = "Ocean Depths",
        Background = Color3.fromRGB(11, 19, 43),
        Secondary = Color3.fromRGB(15, 27, 56),
        Accent = Color3.fromRGB(14, 165, 233),
        AccentHover = Color3.fromRGB(34, 185, 253),
        Text = Color3.fromRGB(226, 232, 240),
        TextDark = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(30, 41, 59),
        Success = Color3.fromRGB(16, 185, 129),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Gradient1 = Color3.fromRGB(6, 182, 212),
        Gradient2 = Color3.fromRGB(59, 130, 246),
        GradientSpeed = 4
    },
    
    Cyberpunk = {
        Name = "Cyberpunk 2077",
        Background = Color3.fromRGB(16, 0, 43),
        Secondary = Color3.fromRGB(28, 0, 66),
        Accent = Color3.fromRGB(255, 0, 255),
        AccentHover = Color3.fromRGB(255, 51, 255),
        Text = Color3.fromRGB(0, 255, 255),
        TextDark = Color3.fromRGB(178, 102, 255),
        Border = Color3.fromRGB(255, 0, 128),
        Success = Color3.fromRGB(0, 255, 157),
        Error = Color3.fromRGB(255, 0, 102),
        Warning = Color3.fromRGB(255, 215, 0),
        Gradient1 = Color3.fromRGB(255, 0, 255),
        Gradient2 = Color3.fromRGB(0, 255, 255),
        GradientSpeed = 5
    },
    
    Sunset = {
        Name = "Sunset Paradise",
        Background = Color3.fromRGB(30, 20, 40),
        Secondary = Color3.fromRGB(45, 30, 55),
        Accent = Color3.fromRGB(251, 146, 60),
        AccentHover = Color3.fromRGB(255, 166, 80),
        Text = Color3.fromRGB(254, 215, 170),
        TextDark = Color3.fromRGB(217, 119, 136),
        Border = Color3.fromRGB(192, 86, 133),
        Success = Color3.fromRGB(134, 239, 172),
        Error = Color3.fromRGB(252, 165, 165),
        Warning = Color3.fromRGB(253, 224, 71),
        Gradient1 = Color3.fromRGB(251, 113, 133),
        Gradient2 = Color3.fromRGB(251, 191, 36),
        GradientSpeed = 3.5
    }
}

ThemeManager.CurrentTheme = "Dark"

function ThemeManager:GetTheme(themeName)
    return self.Themes[themeName] or self.Themes.Dark
end

function ThemeManager:SetTheme(window, themeName)
    if not self.Themes[themeName] then
        warn("[Nexus UI] Theme not found:", themeName)
        return false
    end
    
    self.CurrentTheme = themeName
    local theme = self:GetTheme(themeName)
    
    -- Apply theme with smooth transition
    Utility:Try(function()
        self:ApplyThemeToWindow(window, theme)
    end, "Failed to apply theme")
    
    return true
end

function ThemeManager:ApplyThemeToWindow(window, theme)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    -- Apply to main window
    if window.MainFrame then
        TweenService:Create(window.MainFrame, tweenInfo, {BackgroundColor3 = theme.Background}):Play()
    end
    
    -- Apply to all components recursively
    for _, component in pairs(window.Components or {}) do
        if component.ApplyTheme then
            component:ApplyTheme(theme)
        end
    end
end

function ThemeManager:CreateCustomTheme(name, colors)
    if self.Themes[name] then
        warn("[Nexus UI] Theme already exists:", name)
        return false
    end
    
    -- Validate theme structure
    local requiredKeys = {"Background", "Secondary", "Accent", "Text", "Border"}
    for _, key in ipairs(requiredKeys) do
        if not colors[key] then
            warn("[Nexus UI] Missing required color:", key)
            return false
        end
    end
    
    self.Themes[name] = colors
    return true
end

--[[═══════════════════════════════════════════════════════════════
    ANIMATION ENGINE
═══════════════════════════════════════════════════════════════]]

local AnimationEngine = {}
NexusUI.Modules.AnimationEngine = AnimationEngine

function AnimationEngine:Tween(instance, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function AnimationEngine:FloatingAnimation(instance, amplitude, speed)
    amplitude = amplitude or 5
    speed = speed or 2
    
    local startPos = instance.Position
    local connection
    
    connection = RunService.RenderStepped:Connect(function(dt)
        if not instance or not instance.Parent then
            connection:Disconnect()
            return
        end
        
        local offset = math.sin(tick() * speed) * amplitude
        instance.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset,
            startPos.Y.Scale, startPos.Y.Offset + offset
        )
    end)
    
    return connection
end

function AnimationEngine:GradientAnimation(gradient, speed)
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not gradient or not gradient.Parent then
            connection:Disconnect()
            return
        end
        
        gradient.Rotation = (gradient.Rotation + speed) % 360
    end)
    
    return connection
end

function AnimationEngine:RippleEffect(button, clickPosition)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, clickPosition.X, 0, clickPosition.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    local tween1 = AnimationEngine:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quad)
    
    tween1.Completed:Connect(function()
        ripple:Destroy()
    end)
end

function AnimationEngine:ShakeAnimation(instance, intensity, duration)
    intensity = intensity or 5
    duration = duration or 0.5
    
    local originalPos = instance.Position
    local elapsed = 0
    
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        elapsed = elapsed + dt
        
        if elapsed >= duration then
            instance.Position = originalPos
            connection:Disconnect()
            return
        end
        
        local shake = intensity * (1 - elapsed / duration)
        instance.Position = UDim2.new(
            originalPos.X.Scale, originalPos.X.Offset + math.random(-shake, shake),
            originalPos.Y.Scale, originalPos.Y.Offset + math.random(-shake, shake)
        )
    end)
end

function AnimationEngine:PulseAnimation(instance, scaleMultiplier, duration)
    scaleMultiplier = scaleMultiplier or 1.1
    duration = duration or 0.5
    
    local originalSize = instance.Size
    
    local tween1 = AnimationEngine:Tween(instance, {
        Size = UDim2.new(
            originalSize.X.Scale * scaleMultiplier,
            originalSize.X.Offset,
            originalSize.Y.Scale * scaleMultiplier,
            originalSize.Y.Offset
        )
    }, duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    tween1.Completed:Connect(function()
        AnimationEngine:Tween(instance, {Size = originalSize}, duration / 2)
    end)
end

--[[═══════════════════════════════════════════════════════════════
    NOTIFICATION MANAGER
═══════════════════════════════════════════════════════════════]]

local NotificationManager = {}
NexusUI.Modules.NotificationManager = NotificationManager

NotificationManager.Container = nil
NotificationManager.Notifications = {}
NotificationManager.MaxNotifications = 5
NotificationManager.Positions = {
    TopRight = UDim2.new(1, -20, 0, 20),
    TopLeft = UDim2.new(0, 20, 0, 20),
    BottomRight = UDim2.new(1, -20, 1, -20),
    BottomLeft = UDim2.new(0, 20, 1, -20),
    TopCenter = UDim2.new(0.5, 0, 0, 20),
    BottomCenter = UDim2.new(0.5, 0, 1, -20)
}

function NotificationManager:Initialize()
    if self.Container then return end
    
    self.Container = Instance.new("ScreenGui")
    self.Container.Name = "NexusNotifications"
    self.Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.Container.ResetOnSpawn = false
    self.Container.Parent = CoreGui
end

function NotificationManager:Notify(config)
    self:Initialize()
    
    -- Default configuration
    local notification = {
        Title = config.Title or "Notification",
        Content = config.Content or "",
        Duration = config.Duration or 5,
        Type = config.Type or "info",
        Position = config.Position or "TopRight",
        Actions = config.Actions or {},
        Priority = config.Priority or "normal"
    }
    
    -- Create notification UI
    local notifFrame = self:CreateNotificationUI(notification)
    
    -- Position and animate
    self:PositionNotification(notifFrame, notification.Position)
    self:AnimateIn(notifFrame)
    
    -- Auto dismiss
    task.delay(notification.Duration, function()
        self:DismissNotification(notifFrame)
    end)
    
    -- Add to active notifications
    table.insert(self.Notifications, notifFrame)
    
    -- Manage stack limit
    if #self.Notifications > self.MaxNotifications then
        self:DismissNotification(self.Notifications[1])
    end
    
    return notifFrame
end

function NotificationManager:CreateNotificationUI(config)
    local theme = ThemeManager:GetTheme(ThemeManager.CurrentTheme)
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(0, 320, 0, 0)
    notifFrame.BackgroundColor3 = theme.Secondary
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notifFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = notifFrame
    
    -- Type indicator
    local typeColors = {
        success = theme.Success,
        error = theme.Error,
        warning = theme.Warning,
        info = theme.Accent
    }
    
    local indicator = Instance.new("Frame")
    indicator.Name = "TypeIndicator"
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.BackgroundColor3 = typeColors[config.Type] or theme.Accent
    indicator.BorderSizePixel = 0
    indicator.Parent = notifFrame
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 10)
    indicatorCorner.Parent = indicator
    
    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Position = UDim2.new(0, 15, 0, 10)
    content.Size = UDim2.new(1, -30, 1, -20)
    content.BackgroundTransparency = 1
    content.Parent = notifFrame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = content
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -30, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = config.Title
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 1
    title.Parent = content
    
    -- Content text
    if config.Content ~= "" then
        local contentText = Instance.new("TextLabel")
        contentText.Name = "ContentText"
        contentText.Size = UDim2.new(1, -30, 0, 30)
        contentText.BackgroundTransparency = 1
        contentText.Text = config.Content
        contentText.TextColor3 = theme.TextDark
        contentText.Font = Enum.Font.Gotham
        contentText.TextSize = 12
        contentText.TextXAlignment = Enum.TextXAlignment.Left
        contentText.TextWrapped = true
        contentText.LayoutOrder = 2
        contentText.Parent = content
    end
    
    -- Actions
    if #config.Actions > 0 then
        local actionsContainer = Instance.new("Frame")
        actionsContainer.Name = "Actions"
        actionsContainer.Size = UDim2.new(1, -30, 0, 30)
        actionsContainer.BackgroundTransparency = 1
        actionsContainer.LayoutOrder = 3
        actionsContainer.Parent = content
        
        local actionsLayout = Instance.new("UIListLayout")
        actionsLayout.FillDirection = Enum.FillDirection.Horizontal
        actionsLayout.Padding = UDim.new(0, 10)
        actionsLayout.Parent = actionsContainer
        
        for _, action in ipairs(config.Actions) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 80, 1, 0)
            btn.BackgroundColor3 = theme.Accent
            btn.Text = action.Name
            btn.TextColor3 = theme.Text
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 11
            btn.BorderSizePixel = 0
            btn.Parent = actionsContainer
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if action.Callback then
                    Utility:Try(function()
                        action.Callback()
                    end, "Action callback failed")
                end
                self:DismissNotification(notifFrame)
            end)
        end
    end
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = theme.TextDark
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = notifFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        self:DismissNotification(notifFrame)
    end)
    
    -- Calculate final height
    local finalHeight = 80 + (#config.Actions > 0 and 40 or 0)
    notifFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        notifFrame.Size = UDim2.new(0, 320, 0, finalHeight)
    end)
    
    return notifFrame
end

function NotificationManager:PositionNotification(notifFrame, position)
    local basePosition = self.Positions[position] or self.Positions.TopRight
    notifFrame.Position = basePosition
    notifFrame.AnchorPoint = Vector2.new(
        position:match("Right") and 1 or (position:match("Center") and 0.5 or 0),
        position:match("Bottom") and 1 or 0
    )
end

function NotificationManager:AnimateIn(notifFrame)
    notifFrame.Size = UDim2.new(0, 320, 0, 0)
    AnimationEngine:Tween(notifFrame, {
        Size = UDim2.new(0, 320, 0, notifFrame.AbsoluteSize.Y)
    }, 0.4, Enum.EasingStyle.Back)
end

function NotificationManager:DismissNotification(notifFrame)
    AnimationEngine:Tween(notifFrame, {
        Size = UDim2.new(0, 320, 0, 0),
        BackgroundTransparency = 1
    }, 0.3)
    
    task.delay(0.3, function()
        notifFrame:Destroy()
        for i, notif in ipairs(self.Notifications) do
            if notif == notifFrame then
                table.remove(self.Notifications, i)
                break
            end
        end
    end)
end

--[[═══════════════════════════════════════════════════════════════
    CONFIG SYSTEM
═══════════════════════════════════════════════════════════════]]

local ConfigSystem = {}
NexusUI.Modules.ConfigSystem = ConfigSystem

ConfigSystem.Configs = {}
ConfigSystem.CurrentProfile = "Default"
ConfigSystem.AutoSaveInterval = 60
ConfigSystem.History = {}

function ConfigSystem:Initialize()
    -- Load saved configs from DataStore (simplified for client)
    self:LoadFromStorage()
    
    -- Start auto-save
    if self.AutoSaveInterval > 0 then
        task.spawn(function()
            while true do
                task.wait(self.AutoSaveInterval)
                self:AutoSave()
            end
        end)
    end
end

function ConfigSystem:SaveConfig(name, data)
    if not name or name == "" then
        warn("[Nexus UI] Config name cannot be empty")
        return false
    end
    
    self.Configs[name] = {
        Data = Utility:DeepCopy(data),
        Timestamp = os.time(),
        Version = NexusUI.Version
    }
    
    self:SaveToStorage()
    self:AddToHistory("save", name)
    
    return true
end

function ConfigSystem:LoadConfig(name)
    if not self.Configs[name] then
        warn("[Nexus UI] Config not found:", name)
        return nil
    end
    
    local config = self.Configs[name]
    
    -- Validate version compatibility
    if config.Version ~= NexusUI.Version then
        warn("[Nexus UI] Config version mismatch. May cause issues.")
    end
    
    self:AddToHistory("load", name)
    return Utility:DeepCopy(config.Data)
end

function ConfigSystem:DeleteConfig(name)
    if not self.Configs[name] then
        return false
    end
    
    self.Configs[name] = nil
    self:SaveToStorage()
    self:AddToHistory("delete", name)
    
    return true
end

function ConfigSystem:ListConfigs()
    local list = {}
    for name, config in pairs(self.Configs) do
        table.insert(list, {
            Name = name,
            Timestamp = config.Timestamp,
            Version = config.Version
        })
    end
    return list
end

function ConfigSystem:ExportConfig(name)
    if not self.Configs[name] then
        return nil
    end
    
    local config = self.Configs[name]
    local encoded = HttpService:JSONEncode(config)
    local base64 = self:Base64Encode(encoded)
    
    return base64
end

function ConfigSystem:ImportConfig(base64String, name)
    Utility:Try(function()
        local decoded = self:Base64Decode(base64String)
        local config = HttpService:JSONDecode(decoded)
        
        self.Configs[name or "Imported_" .. os.time()] = config
        self:SaveToStorage()
        
        return true
    end, "Failed to import config")
    
    return false
end

function ConfigSystem:SaveToStorage()
    -- Save to DataStore or file (simplified for Roblox)
    local success = Utility:Try(function()
        local encoded = HttpService:JSONEncode(self.Configs)
        writefile("NexusUI_Configs.json", encoded)
    end, "Failed to save configs")
    
    return success
end

function ConfigSystem:LoadFromStorage()
    Utility:Try(function()
        if isfile("NexusUI_Configs.json") then
            local encoded = readfile("NexusUI_Configs.json")
            self.Configs = HttpService:JSONDecode(encoded)
        end
    end, "Failed to load configs")
end

function ConfigSystem:AutoSave()
    if self.CurrentProfile and self.Configs[self.CurrentProfile] then
        self:SaveToStorage()
    end
end

function ConfigSystem:AddToHistory(action, configName)
    table.insert(self.History, {
        Action = action,
        Config = configName,
        Timestamp = os.time()
    })
    
    -- Keep only last 50 history entries
    if #self.History > 50 then
        table.remove(self.History, 1)
    end
end

function ConfigSystem:Base64Encode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r, b = '', x:byte()
        for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c = 0
        for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
        return b:sub(c + 1, c + 1)
    end) .. ({'', '==', '='})[#data % 3 + 1])
end

function ConfigSystem:Base64Decode(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^' .. b .. '=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end))
end

--[[═══════════════════════════════════════════════════════════════
    COMPONENT FACTORY
═══════════════════════════════════════════════════════════════]]

local ComponentFactory = {}
NexusUI.Modules.ComponentFactory = ComponentFactory

ComponentFactory.Components = {}

-- Base Component Class
local BaseComponent = {}
BaseComponent.__index = BaseComponent

function BaseComponent.new(parent, config)
    local self = setmetatable({}, BaseComponent)
    self.Parent = parent
    self.Config = config
    self.Id = config.Id or Utility:GenerateId()
    self.Enabled = true
    self.Theme = ThemeManager:GetTheme(ThemeManager.CurrentTheme)
    return self
end

function BaseComponent:ApplyTheme(theme)
    self.Theme = theme
end

function BaseComponent:Destroy()
    if self.Element then
        self.Element:Destroy()
    end
end

function BaseComponent:SetVisible(visible)
    if self.Element then
        self.Element.Visible = visible
    end
end

--[[═══════════════════════════════════════════════════════════════
    TOGGLE COMPONENT
═══════════════════════════════════════════════════════════════]]

local Toggle = setmetatable({}, {__index = BaseComponent})
Toggle.__index = Toggle

function Toggle.new(parent, config)
    local self = setmetatable(BaseComponent.new(parent, config), Toggle)
    self.Value = config.Default or false
    self.Callback = config.Callback
    self:CreateUI()
    return self
end

function Toggle:CreateUI()
    local theme = self.Theme
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Toggle_" .. self.Id
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.Parent = self.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = self.Config.Name
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Toggle switch container
    local switchContainer = Instance.new("Frame")
    switchContainer.Name = "SwitchContainer"
    switchContainer.Position = UDim2.new(1, -50, 0.5, -10)
    switchContainer.Size = UDim2.new(0, 40, 0, 20)
    switchContainer.BackgroundColor3 = theme.Border
    switchContainer.BorderSizePixel = 0
    switchContainer.Parent = container
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchContainer
    
    -- Toggle knob
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Position = UDim2.new(0, 2, 0, 2)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switchContainer
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    -- Button for interaction
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = container
    
    self.Element = container
    self.SwitchContainer = switchContainer
    self.Knob = knob
    
    -- Set initial state
    self:SetValue(self.Value, true)
    
    -- Click handler
    button.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        AnimationEngine:Tween(container, {BackgroundColor3 = theme.Border}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        AnimationEngine:Tween(container, {BackgroundColor3 = theme.Secondary}, 0.2)
    end)
end

function Toggle:Toggle()
    self:SetValue(not self.Value)
end

function Toggle:SetValue(value, silent)
    self.Value = value
    
    local theme = self.Theme
    local targetPos = value and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
    local targetColor = value and theme.Accent or theme.Border
    
    -- Animate toggle
    AnimationEngine:Tween(self.Knob, {Position = targetPos}, 0.3, Enum.EasingStyle.Back)
    AnimationEngine:Tween(self.SwitchContainer, {BackgroundColor3 = targetColor}, 0.3)
    
    if not silent and self.Callback then
        Utility:Try(function()
            self.Callback(value)
        end, "Toggle callback error")
    end
end

function Toggle:ApplyTheme(theme)
    self.Theme = theme
    if self.Element then
        self.Element.BackgroundColor3 = theme.Secondary
        self.SwitchContainer.BackgroundColor3 = self.Value and theme.Accent or theme.Border
        self.Element.Label.TextColor3 = theme.Text
    end
end

--[[═══════════════════════════════════════════════════════════════
    SLIDER COMPONENT
═══════════════════════════════════════════════════════════════]]

local Slider = setmetatable({}, {__index = BaseComponent})
Slider.__index = Slider

function Slider.new(parent, config)
    local self = setmetatable(BaseComponent.new(parent, config), Slider)
    self.Min = config.Min or 0
    self.Max = config.Max or 100
    self.Value = config.Default or self.Min
    self.Increment = config.Increment or 1
    self.Suffix = config.Suffix or ""
    self.Textbox = config.Textbox or false
    self.Callback = config.Callback
    self.Dragging = false
    self:CreateUI()
    return self
end

function Slider:CreateUI()
    local theme = self.Theme
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Slider_" .. self.Id
    container.Size = UDim2.new(1, -20, 0, self.Textbox and 70 or 50)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.Parent = self.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = self.Config.Name
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Value display
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Position = UDim2.new(0.6, 0, 0, 5)
    valueLabel.Size = UDim2.new(0.4, -10, 0, 20)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(self.Value) .. self.Suffix
    valueLabel.TextColor3 = theme.Accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Position = UDim2.new(0, 10, 0, 30)
    track.Size = UDim2.new(1, -20, 0, 4)
    track.BackgroundColor3 = theme.Border
    track.BorderSizePixel = 0
    track.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- Slider handle
    local handle = Instance.new("Frame")
    handle.Name = "Handle"
    handle.Position = UDim2.new(0, -6, 0.5, -6)
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.ZIndex = 2
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    -- Textbox for manual input
    if self.Textbox then
        local textbox = Instance.new("TextBox")
        textbox.Name = "Textbox"
        textbox.Position = UDim2.new(0, 10, 1, -30)
        textbox.Size = UDim2.new(1, -20, 0, 25)
        textbox.BackgroundColor3 = theme.Background
        textbox.BorderSizePixel = 0
        textbox.Text = tostring(self.Value)
        textbox.TextColor3 = theme.Text
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 12
        textbox.PlaceholderText = "Enter value..."
        textbox.Parent = container
        
        local textboxCorner = Instance.new("UICorner")
        textboxCorner.CornerRadius = UDim.new(0, 4)
        textboxCorner.Parent = textbox
        
        textbox.FocusLost:Connect(function()
            local num = tonumber(textbox.Text)
            if num then
                self:SetValue(Utility:Clamp(num, self.Min, self.Max))
            else
                textbox.Text = tostring(self.Value)
            end
        end)
        
        self.Textbox = textbox
    end
    
    self.Element = container
    self.Track = track
    self.Fill = fill
    self.Handle = handle
    self.ValueLabel = valueLabel
    
    -- Set initial value
    self:SetValue(self.Value, true)
    
    -- Drag handling
    local inputBegan, inputEnded, inputChanged
    
    inputBegan = track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            self:UpdateFromInput(input.Position.X)
        end
    end)
    
    inputChanged = UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            self:UpdateFromInput(input.Position.X)
        end
    end)
    
    inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
end

function Slider:UpdateFromInput(posX)
    local relativeX = posX - self.Track.AbsolutePosition.X
    local percentage = Utility:Clamp(relativeX / self.Track.AbsoluteSize.X, 0, 1)
    local value = self.Min + (self.Max - self.Min) * percentage
    
    -- Apply increment
    value = math.floor((value / self.Increment) + 0.5) * self.Increment
    
    self:SetValue(value)
end

function Slider:SetValue(value, silent)
    value = Utility:Clamp(value, self.Min, self.Max)
    self.Value = value
    
    local percentage = (value - self.Min) / (self.Max - self.Min)
    
    -- Update UI
    self.Fill.Size = UDim2.new(percentage, 0, 1, 0)
    self.Handle.Position = UDim2.new(percentage, -6, 0.5, -6)
    self.ValueLabel.Text = string.format("%.2f", value) .. self.Suffix
    
    if self.Textbox then
        self.Textbox.Text = string.format("%.2f", value)
    end
    
    if not silent and self.Callback then
        -- Debounce callback
        if not self.DebouncedCallback then
            self.DebouncedCallback = Utility:Debounce(self.Callback, 0.05)
        end
        
        Utility:Try(function()
            self.DebouncedCallback(value)
        end, "Slider callback error")
    end
end

function Slider:ApplyTheme(theme)
    self.Theme = theme
    if self.Element then
        self.Element.BackgroundColor3 = theme.Secondary
        self.Element.Label.TextColor3 = theme.Text
        self.ValueLabel.TextColor3 = theme.Accent
        self.Track.BackgroundColor3 = theme.Border
        self.Fill.BackgroundColor3 = theme.Accent
        if self.Textbox then
            self.Textbox.BackgroundColor3 = theme.Background
            self.Textbox.TextColor3 = theme.Text
        end
    end
end

--[[═══════════════════════════════════════════════════════════════
    BUTTON COMPONENT
═══════════════════════════════════════════════════════════════]]

local Button = setmetatable({}, {__index = BaseComponent})
Button.__index = Button

function Button.new(parent, config)
    local self = setmetatable(BaseComponent.new(parent, config), Button)
    self.Callback = config.Callback
    self.Loading = false
    self.Disabled = config.Disabled or false
    self:CreateUI()
    return self
end

function Button:CreateUI()
    local theme = self.Theme
    
    -- Main button
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. self.Id
    button.Size = UDim2.new(1, -20, 0, 35)
    button.BackgroundColor3 = theme.Accent
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = self.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = self.Config.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = button
    
    self.Element = button
    self.Label = label
    
    -- Click handler
    button.MouseButton1Click:Connect(function()
        if not self.Disabled and not self.Loading then
            AnimationEngine:RippleEffect(button, Vector2.new(button.AbsoluteSize.X / 2, button.AbsoluteSize.Y / 2))
            
            if self.Callback then
                Utility:Try(function()
                    self.Callback()
                end, "Button callback error")
            end
        end
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        if not self.Disabled then
            AnimationEngine:Tween(button, {BackgroundColor3 = theme.AccentHover}, 0.2)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not self.Disabled then
            AnimationEngine:Tween(button, {BackgroundColor3 = theme.Accent}, 0.2)
        end
    end)
end

function Button:SetLoading(loading)
    self.Loading = loading
    self.Label.Text = loading and "Loading..." or self.Config.Name
end

function Button:SetDisabled(disabled)
    self.Disabled = disabled
    local theme = self.Theme
    self.Element.BackgroundColor3 = disabled and theme.Border or theme.Accent
end

function Button:ApplyTheme(theme)
    self.Theme = theme
    if self.Element then
        self.Element.BackgroundColor3 = self.Disabled and theme.Border or theme.Accent
    end
end

--[[═══════════════════════════════════════════════════════════════
    DROPDOWN COMPONENT
═══════════════════════════════════════════════════════════════]]

local Dropdown = setmetatable({}, {__index = BaseComponent})
Dropdown.__index = Dropdown

function Dropdown.new(parent, config)
    local self = setmetatable(BaseComponent.new(parent, config), Dropdown)
    self.Options = config.Options or {}
    self.Selected = config.Default or (config.Multi and {} or nil)
    self.Multi = config.Multi or false
    self.Search = config.Search or false
    self.Callback = config.Callback
    self.Open = false
    self:CreateUI()
    return self
end

function Dropdown:CreateUI()
    local theme = self.Theme
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Dropdown_" .. self.Id
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    container.ZIndex = 10
    container.Parent = self.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -30, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = self.Config.Name
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Selected display
    local display = Instance.new("TextButton")
    display.Name = "Display"
    display.Position = UDim2.new(0, 10, 0, 22)
    display.Size = UDim2.new(1, -30, 0, 25)
    display.BackgroundColor3 = theme.Background
    display.BorderSizePixel = 0
    display.Text = ""
    display.AutoButtonColor = false
    display.Parent = container
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 4)
    displayCorner.Parent = display
    
    local displayText = Instance.new("TextLabel")
    displayText.Name = "Text"
    displayText.Size = UDim2.new(1, -25, 1, 0)
    displayText.Position = UDim2.new(0, 8, 0, 0)
    displayText.BackgroundTransparency = 1
    displayText.Text = self:GetDisplayText()
    displayText.TextColor3 = theme.TextDark
    displayText.Font = Enum.Font.Gotham
    displayText.TextSize = 12
    displayText.TextXAlignment = Enum.TextXAlignment.Left
    displayText.TextTruncate = Enum.TextTruncate.AtEnd
    displayText.Parent = display
    
    -- Arrow icon
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = theme.TextDark
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 10
    arrow.Parent = display
    
    -- Options container (initially hidden)
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "OptionsContainer"
    optionsContainer.Position = UDim2.new(0, 10, 1, 5)
    optionsContainer.Size = UDim2.new(1, -20, 0, 0)
    optionsContainer.BackgroundColor3 = theme.Secondary
    optionsContainer.BorderSizePixel = 0
    optionsContainer.Visible = false
    optionsContainer.ZIndex = 11
    optionsContainer.Parent = container
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsContainer
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.Parent = optionsContainer
    
    -- Scrolling frame for options
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = theme.Accent
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ZIndex = 11
    scrollFrame.Parent = optionsContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)
    layout.Parent = scrollFrame
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    self.Element = container
    self.Display = display
    self.DisplayText = displayText
    self.Arrow = arrow
    self.OptionsContainer = optionsContainer
    self.ScrollFrame = scrollFrame
    
    -- Populate options
    self:PopulateOptions()
    
    -- Click handler for display
    display.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
end

function Dropdown:PopulateOptions()
    -- Clear existing options
    for _, child in ipairs(self.ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Create option buttons
    for _, option in ipairs(self.Options) do
        self:CreateOption(option)
    end
end

function Dropdown:CreateOption(option)
    local theme = self.Theme
    local isSelected = self.Multi and table.find(self.Selected, option) or self.Selected == option
    
    local optionBtn = Instance.new("TextButton")
    optionBtn.Name = "Option_" .. option
    optionBtn.Size = UDim2.new(1, 0, 0, 30)
    optionBtn.BackgroundColor3 = isSelected and theme.Accent or theme.Background
    optionBtn.BackgroundTransparency = isSelected and 0.9 or 1
    optionBtn.BorderSizePixel = 0
    optionBtn.Text = ""
    optionBtn.AutoButtonColor = false
    optionBtn.ZIndex = 11
    optionBtn.Parent = self.ScrollFrame
    
    local optionLabel = Instance.new("TextLabel")
    optionLabel.Size = UDim2.new(1, -10, 1, 0)
    optionLabel.Position = UDim2.new(0, 10, 0, 0)
    optionLabel.BackgroundTransparency = 1
    optionLabel.Text = option
    optionLabel.TextColor3 = theme.Text
    optionLabel.Font = Enum.Font.Gotham
    optionLabel.TextSize = 12
    optionLabel.TextXAlignment = Enum.TextXAlignment.Left
    optionLabel.ZIndex = 11
    optionLabel.Parent = optionBtn
    
    -- Click handler
    optionBtn.MouseButton1Click:Connect(function()
        self:SelectOption(option)
    end)
    
    -- Hover effect
    optionBtn.MouseEnter:Connect(function()
        if not isSelected then
            AnimationEngine:Tween(optionBtn, {BackgroundTransparency = 0.95}, 0.2)
        end
    end)
    
    optionBtn.MouseLeave:Connect(function()
        if not isSelected then
            AnimationEngine:Tween(optionBtn, {BackgroundTransparency = 1}, 0.2)
        end
    end)
end

function Dropdown:SelectOption(option)
    if self.Multi then
        local index = table.find(self.Selected, option)
        if index then
            table.remove(self.Selected, index)
        else
            table.insert(self.Selected, option)
        end
    else
        self.Selected = option
        self:Close()
    end
    
    self:UpdateDisplay()
    self:PopulateOptions()
    
    if self.Callback then
        Utility:Try(function()
            self.Callback(self.Selected)
        end, "Dropdown callback error")
    end
end

function Dropdown:UpdateDisplay()
    self.DisplayText.Text = self:GetDisplayText()
end

function Dropdown:GetDisplayText()
    if self.Multi then
        return #self.Selected > 0 and table.concat(self.Selected, ", ") or "Select options..."
    else
        return self.Selected or "Select option..."
    end
end

function Dropdown:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        self:Open_Dropdown()
    else
        self:Close()
    end
end

function Dropdown:Open_Dropdown()
    self.OptionsContainer.Visible = true
    
    local optionsHeight = math.min(#self.Options * 32, 150)
    self.OptionsContainer.Size = UDim2.new(1, -20, 0, 0)
    
    AnimationEngine:Tween(self.OptionsContainer, {
        Size = UDim2.new(1, -20, 0, optionsHeight + 10)
    }, 0.3, Enum.EasingStyle.Quart)
    
    AnimationEngine:Tween(self.Arrow, {Rotation = 180}, 0.3)
end

function Dropdown:Close()
    self.Open = false
    
    AnimationEngine:Tween(self.OptionsContainer, {
        Size = UDim2.new(1, -20, 0, 0)
    }, 0.3, Enum.EasingStyle.Quart)
    
    AnimationEngine:Tween(self.Arrow, {Rotation = 0}, 0.3)
    
    task.delay(0.3, function()
        if not self.Open then
            self.OptionsContainer.Visible = false
        end
    end)
end

function Dropdown:ApplyTheme(theme)
    self.Theme = theme
    if self.Element then
        self.Element.BackgroundColor3 = theme.Secondary
        self.Element.Label.TextColor3 = theme.Text
        self.Display.BackgroundColor3 = theme.Background
        self.DisplayText.TextColor3 = theme.TextDark
        self.OptionsContainer.BackgroundColor3 = theme.Secondary
        self:PopulateOptions()
    end
end

--[[═══════════════════════════════════════════════════════════════
    TEXTBOX COMPONENT
═══════════════════════════════════════════════════════════════]]

local Textbox = setmetatable({}, {__index = BaseComponent})
Textbox.__index = Textbox

function Textbox.new(parent, config)
    local self = setmetatable(BaseComponent.new(parent, config), Textbox)
    self.Placeholder = config.Placeholder or "Enter text..."
    self.Default = config.Default or ""
    self.Callback = config.Callback
    self:CreateUI()
    return self
end

function Textbox:CreateUI()
    local theme = self.Theme
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Textbox_" .. self.Id
    container.Size = UDim2.new(1, -20, 0, 60)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.Parent = self.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = self.Config.Name
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Textbox
    local textbox = Instance.new("TextBox")
    textbox.Name = "Textbox"
    textbox.Position = UDim2.new(0, 10, 0, 30)
    textbox.Size = UDim2.new(1, -20, 0, 25)
    textbox.BackgroundColor3 = theme.Background
    textbox.BorderSizePixel = 0
    textbox.Text = self.Default
    textbox.TextColor3 = theme.Text
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 12
    textbox.PlaceholderText = self.Placeholder
    textbox.PlaceholderColor3 = theme.TextDark
    textbox.ClearTextOnFocus = false
    textbox.Parent = container
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 4)
    textboxCorner.Parent = textbox
    
    self.Element = container
    self.Textbox = textbox
    
    -- Callback on focus lost
    textbox.FocusLost:Connect(function()
        if self.Callback then
            Utility:Try(function()
                self.Callback(textbox.Text)
            end, "Textbox callback error")
        end
    end)
end

function Textbox:SetText(text)
    self.Textbox.Text = text
end

function Textbox:GetText()
    return self.Textbox.Text
end

function Textbox:ApplyTheme(theme)
    self.Theme = theme
    if self.Element then
        self.Element.BackgroundColor3 = theme.Secondary
        self.Element.Label.TextColor3 = theme.Text
        self.Textbox.BackgroundColor3 = theme.Background
        self.Textbox.TextColor3 = theme.Text
        self.Textbox.PlaceholderColor3 = theme.TextDark
    end
end

--[[═══════════════════════════════════════════════════════════════
    COLORPICKER COMPONENT
═══════════════════════════════════════════════════════════════]]

local ColorPicker = setmetatable({}, {__index = BaseComponent})
ColorPicker.__index = ColorPicker

function ColorPicker.new(parent, config)
    local self = setmetatable(BaseComponent.new(parent, config), ColorPicker)
    self.Color = config.Default or Color3.fromRGB(255, 0, 0)
    self.Callback = config.Callback
    self.Open = false
    self:CreateUI()
    return self
end

function ColorPicker:CreateUI()
    local theme = self.Theme
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "ColorPicker_" .. self.Id
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = theme.Secondary
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    container.ZIndex = 10
    container.Parent = self.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = self.Config.Name
    label.TextColor3 = theme.Text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Color display button
    local colorBtn = Instance.new("TextButton")
    colorBtn.Name = "ColorButton"
    colorBtn.Position = UDim2.new(1, -40, 0.5, -15)
    colorBtn.Size = UDim2.new(0, 30, 0, 30)
    colorBtn.BackgroundColor3 = self.Color
    colorBtn.BorderSizePixel = 0
    colorBtn.Text = ""
    colorBtn.Parent = container
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 6)
    colorCorner.Parent = colorBtn
    
    local colorStroke = Instance.new("UIStroke")
    colorStroke.Color = theme.Border
    colorStroke.Thickness = 2
    colorStroke.Parent = colorBtn
    
    self.Element = container
    self.ColorButton = colorBtn
    
    -- Click to open picker (simplified - full picker would be too long)
    colorBtn.MouseButton1Click:Connect(function()
        -- In a real implementation, this would open a color picker UI
        -- For now, we'll cycle through some preset colors
        local presets = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255)
        }
        
        local currentIndex = 1
        for i, preset in ipairs(presets) do
            if preset == self.Color then
                currentIndex = i
                break
            end
        end
        
        local nextIndex = (currentIndex % #presets) + 1
        self:SetColor(presets[nextIndex])
    end)
end

function ColorPicker:SetColor(color)
    self.Color = color
    self.ColorButton.BackgroundColor3 = color
    
    if self.Callback then
        Utility:Try(function()
            self.Callback(color)
        end, "ColorPicker callback error")
    end
end

function ColorPicker:ApplyTheme(theme)
    self.Theme = theme
    if self.Element then
        self.Element.BackgroundColor3 = theme.Secondary
        self.Element.Label.TextColor3 = theme.Text
    end
end

--[[═══════════════════════════════════════════════════════════════
    LABEL COMPONENT
═══════════════════════════════════════════════════════════════]]

local Label = setmetatable({}, {__index = BaseComponent})
Label.__index = Label

function Label.new(parent, config)
    local self = setmetatable(BaseComponent.new(parent, config), Label)
    self.Text = config.Text or ""
    self:CreateUI()
    return self
end

function Label:CreateUI()
    local theme = self.Theme
    
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. self.Id
    label.Size = UDim2.new(1, -20, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = self.Text
    label.TextColor3 = theme.TextDark
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = self.Parent
    
    self.Element = label
end

function Label:SetText(text)
    self.Text = text
    self.Element.Text = text
end

function Label:ApplyTheme(theme)
    self.Theme = theme
    if self.Element then
        self.Element.TextColor3 = theme.TextDark
    end
end

--[[═══════════════════════════════════════════════════════════════
    WINDOW CLASS
═══════════════════════════════════════════════════════════════]]

local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Name = config.Name or "Nexus UI"
    self.Theme = config.Theme or "Dark"
    self.Size = config.Size or {650, 450}
    self.MinSize = config.MinSize or {400, 300}
    self.Draggable = config.Draggable ~= false
    self.Resizable = config.Resizable or false
    self.SavePosition = config.SavePosition or false
    self.Keybind = config.Keybind
    self.MobileButton = config.MobileButton or false
    self.Blur = config.Blur or false
    self.Acrylic = config.Acrylic or false
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Components = {}
    self.Visible = true
    
    self:CreateUI()
    self:SetupKeybind()
    
    if self.MobileButton then
        self:CreateMobileButton()
    end
    
    table.insert(NexusUI.Windows, self)
    
    return self
end

function Window:CreateUI()
    local theme = ThemeManager:GetTheme(self.Theme)
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NexusUI_" .. Utility:GenerateId()
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CoreGui
    
    -- Main window frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, self.Size[1], 0, self.Size[2])
    mainFrame.Position = UDim2.new(0.5, -self.Size[1]/2, 0.5, -self.Size[2]/2)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = self.ScreenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.Gradient1),
        ColorSequenceKeypoint.new(1, theme.Gradient2)
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Animate gradient
    AnimationEngine:GradientAnimation(gradient, theme.GradientSpeed or 3)
    
    -- Gradient overlay to darken
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = theme.Background
    overlay.BackgroundTransparency = 0.7
    overlay.BorderSizePixel = 0
    overlay.Parent = mainFrame
    
    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 12)
    overlayCorner.Parent = overlay
    
    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = theme.Secondary
    topBar.BackgroundTransparency = 0.5
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 12)
    topBarCorner.Parent = topBar
    
    -- Cover bottom corners of top bar
    local topBarCover = Instance.new("Frame")
    topBarCover.Position = UDim2.new(0, 0, 1, -12)
    topBarCover.Size = UDim2.new(1, 0, 0, 12)
    topBarCover.BackgroundColor3 = theme.Secondary
    topBarCover.BackgroundTransparency = 0.5
    topBarCover.BorderSizePixel = 0
    topBarCover.Parent = topBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = self.Name
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.BackgroundColor3 = theme.Error
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.Parent = topBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Minimize button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.BackgroundColor3 = theme.Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 20
    minimizeBtn.Parent = topBar
    
    local minimizeBtnCorner = Instance.new("UICorner")
    minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
    minimizeBtnCorner.Parent = minimizeBtn
    
    minimizeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.Size = UDim2.new(0, 150, 1, -60)
    tabContainer.BackgroundColor3 = theme.Secondary
    tabContainer.BackgroundTransparency = 0.3
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabContainerCorner = Instance.new("UICorner")
    tabContainerCorner.CornerRadius = UDim.new(0, 8)
    tabContainerCorner.Parent = tabContainer
    
    -- Tab list
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 4
    tabList.ScrollBarImageColor3 = theme.Accent
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.Parent = tabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabList
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Position = UDim2.new(0, 170, 0, 50)
    contentContainer.Size = UDim2.new(1, -180, 1, -60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame
    
    self.MainFrame = mainFrame
    self.TopBar = topBar
    self.TabList = tabList
    self.ContentContainer = contentContainer
    self.Gradient = gradient
    
    -- Make draggable
    if self.Draggable then
        self:MakeDraggable()
    end
    
    -- Floating animation
    AnimationEngine:FloatingAnimation(mainFrame, 3, 1.5)
end

function Window:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Window:SetupKeybind()
    if not self.Keybind then return end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.Keybind then
            self:Toggle()
        end
    end)
end

function Window:CreateMobileButton()
    local mobileBtn = Instance.new("TextButton")
    mobileBtn.Name = "NexusMobileButton"
    mobileBtn.Position = UDim2.new(0, 20, 0.5, -25)
    mobileBtn.Size = UDim2.new(0, 50, 0, 50)
    mobileBtn.BackgroundColor3 = ThemeManager:GetTheme(self.Theme).Accent
    mobileBtn.BorderSizePixel = 0
    mobileBtn.Text = "N"
    mobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobileBtn.Font = Enum.Font.GothamBold
    mobileBtn.TextSize = 24
    mobileBtn.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = mobileBtn
    
    mobileBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    mobileBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mobileBtn.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mobileBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Window:Toggle()
    self.Visible = not self.Visible
    self.MainFrame.Visible = self.Visible
end

function Window:AddTab(config)
    local tab = {
        Name = config.Name,
        Icon = config.Icon,
        Color = config.Color,
        Window = self,
        Components = {},
        Active = false
    }
    
    -- Create tab button
    local theme = ThemeManager:GetTheme(self.Theme)
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = "Tab_" .. config.Name
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.BackgroundColor3 = theme.Background
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.TabList
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, -10, 1, 0)
    tabLabel.Position = UDim2.new(0, 10, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = config.Name
    tabLabel.TextColor3 = theme.TextDark
    tabLabel.Font = Enum.Font.GothamMedium
    tabLabel.TextSize = 13
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabBtn
    
    -- Tab content frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content_" .. config.Name
    contentFrame.Size = UDim2.new(1, -10, 1, -10)
    contentFrame.Position = UDim2.new(0, 5, 0, 5)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = theme.Accent
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentFrame
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    tab.Button = tabBtn
    tab.Label = tabLabel
    tab.Content = contentFrame
    
    -- Click handler
    tabBtn.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    -- Select first tab automatically
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    -- Return tab object with methods
    return {
        AddToggle = function(_, cfg) return self:AddComponent(tab, "Toggle", cfg) end,
        AddSlider = function(_, cfg) return self:AddComponent(tab, "Slider", cfg) end,
        AddButton = function(_, cfg) return self:AddComponent(tab, "Button", cfg) end,
        AddDropdown = function(_, cfg) return self:AddComponent(tab, "Dropdown", cfg) end,
        AddTextbox = function(_, cfg) return self:AddComponent(tab, "Textbox", cfg) end,
        AddColorPicker = function(_, cfg) return self:AddComponent(tab, "ColorPicker", cfg) end,
        AddLabel = function(_, cfg) return self:AddComponent(tab, "Label", cfg) end
    }
end

function Window:SelectTab(tab)
    -- Deactivate all tabs
    for _, t in ipairs(self.Tabs) do
        t.Active = false
        t.Content.Visible = false
        t.Button.BackgroundTransparency = 0.5
        t.Label.TextColor3 = ThemeManager:GetTheme(self.Theme).TextDark
    end
    
    -- Activate selected tab
    tab.Active = true
    tab.Content.Visible = true
    tab.Button.BackgroundTransparency = 0
    tab.Label.TextColor3 = ThemeManager:GetTheme(self.Theme).Accent
    
    self.CurrentTab = tab
    
    -- Animate selection
    AnimationEngine:Tween(tab.Button, {
        BackgroundColor3 = ThemeManager:GetTheme(self.Theme).Accent
    }, 0.3)
end

function Window:AddComponent(tab, componentType, config)
    local component
    
    if componentType == "Toggle" then
        component = Toggle.new(tab.Content, config)
    elseif componentType == "Slider" then
        component = Slider.new(tab.Content, config)
    elseif componentType == "Button" then
        component = Button.new(tab.Content, config)
    elseif componentType == "Dropdown" then
        component = Dropdown.new(tab.Content, config)
    elseif componentType == "Textbox" then
        component = Textbox.new(tab.Content, config)
    elseif componentType == "ColorPicker" then
        component = ColorPicker.new(tab.Content, config)
    elseif componentType == "Label" then
        component = Label.new(tab.Content, config)
    end
    
    if component then
        table.insert(tab.Components, component)
        table.insert(self.Components, component)
    end
    
    return component
end

function Window:SetTheme(themeName)
    ThemeManager:SetTheme(self, themeName)
    self.Theme = themeName
    
    -- Reapply theme to all components
    local theme = ThemeManager:GetTheme(themeName)
    
    self.MainFrame.BackgroundColor3 = theme.Background
    self.Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.Gradient1),
        ColorSequenceKeypoint.new(1, theme.Gradient2)
    }
    
    for _, component in ipairs(self.Components) do
        if component.ApplyTheme then
            component:ApplyTheme(theme)
        end
    end
end

function Window:SaveConfig(name)
    local data = {}
    
    for _, component in ipairs(self.Components) do
        if component.Id and component.Value ~= nil then
            data[component.Id] = component.Value
        elseif component.Id and component.Color then
            data[component.Id] = component.Color
        elseif component.Id and component.Selected then
            data[component.Id] = component.Selected
        end
    end
    
    ConfigSystem:SaveConfig(name, data)
    
    NexusUI:Notify({
        Title = "Config Saved",
        Content = "Configuration '" .. name .. "' saved successfully",
        Type = "success",
        Duration = 3
    })
end

function Window:LoadConfig(name)
    local data = ConfigSystem:LoadConfig(name)
    
    if not data then
        NexusUI:Notify({
            Title = "Config Error",
            Content = "Configuration '" .. name .. "' not found",
            Type = "error",
            Duration = 3
        })
        return false
    end
    
    for _, component in ipairs(self.Components) do
        if component.Id and data[component.Id] ~= nil then
            if component.SetValue then
                component:SetValue(data[component.Id], true)
            elseif component.SetColor then
                component:SetColor(data[component.Id])
            elseif component.Selected ~= nil then
                component.Selected = data[component.Id]
                if component.UpdateDisplay then
                    component:UpdateDisplay()
                end
            end
        end
    end
    
    NexusUI:Notify({
        Title = "Config Loaded",
        Content = "Configuration '" .. name .. "' loaded successfully",
        Type = "success",
        Duration = 3
    })
    
    return true
end

function Window:DeleteConfig(name)
    if ConfigSystem:DeleteConfig(name) then
        NexusUI:Notify({
            Title = "Config Deleted",
            Content = "Configuration '" .. name .. "' deleted successfully",
            Type = "info",
            Duration = 3
        })
        return true
    end
    return false
end

function Window:ExportConfig()
    if not self.CurrentTab then return nil end
    
    local data = {}
    for _, component in ipairs(self.Components) do
        if component.Id and component.Value ~= nil then
            data[component.Id] = component.Value
        end
    end
    
    local exportString = ConfigSystem:ExportConfig("TempExport")
    
    NexusUI:Notify({
        Title = "Config Exported",
        Content = "Configuration copied to clipboard",
        Type = "info",
        Duration = 3
    })
    
    return exportString
end

function Window:ImportConfig(importString)
    if ConfigSystem:ImportConfig(importString, "Imported_" .. os.time()) then
        NexusUI:Notify({
            Title = "Config Imported",
            Content = "Configuration imported successfully",
            Type = "success",
            Duration = 3
        })
        return true
    end
    
    NexusUI:Notify({
        Title = "Import Error",
        Content = "Failed to import configuration",
        Type = "error",
        Duration = 3
    })
    return false
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    for i, window in ipairs(NexusUI.Windows) do
        if window == self then
            table.remove(NexusUI.Windows, i)
            break
        end
    end
end

--[[═══════════════════════════════════════════════════════════════
    MAIN LIBRARY API
═══════════════════════════════════════════════════════════════]]

function NexusUI:CreateWindow(config)
    return Window.new(config)
end

function NexusUI:Notify(config)
    return NotificationManager:Notify(config)
end

function NexusUI:SetDebugMode(enabled)
    self.DebugMode = enabled
    if enabled then
        print("[Nexus UI] Debug mode enabled")
    end
end

function NexusUI:GetVersion()
    return self.Version
end

function NexusUI:DestroyAll()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    self.Windows = {}
end

-- Initialize modules
ConfigSystem:Initialize()

--[[═══════════════════════════════════════════════════════════════
    USAGE EXAMPLES
═══════════════════════════════════════════════════════════════]]

--[[

-- Example 1: Basic Window Creation
local Nexus = loadstring(game:HttpGet("your_url_here"))()

local Window = Nexus:CreateWindow({
    Name = "Premium Script Hub",
    Theme = "Cyberpunk",
    Size = {650, 450},
    Draggable = true,
    Keybind = Enum.KeyCode.RightControl,
    MobileButton = true
})

-- Example 2: Create Tabs with Components
local Combat = Window:AddTab({
    Name = "Combat",
    Icon = "rbxassetid://123456",
    Color = Color3.fromRGB(255, 100, 100)
})

-- Toggle with keybind
Combat:AddToggle({
    Name = "Kill Aura",
    Description = "Automatically attack nearby enemies",
    Id = "KillAura",
    Default = false,
    Keybind = Enum.KeyCode.R,
    Callback = function(value)
        print("Kill Aura:", value)
        -- Your kill aura logic here
    end
})

-- Slider with textbox
Combat:AddSlider({
    Name = "Attack Range",
    Min = 5,
    Max = 50,
    Default = 20,
    Increment = 0.5,
    Suffix = " studs",
    Textbox = true,
    Callback = function(value)
        print("Range:", value)
        -- Update attack range
    end
})

-- Color picker
Combat:AddColorPicker({
    Name = "Aura Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
        -- Update aura color
    end
})

-- Dropdown with multi-select
Combat:AddDropdown({
    Name = "Target Priority",
    Options = {"Closest", "Lowest Health", "Highest Level", "Random"},
    Multi = false,
    Search = true,
    Default = "Closest",
    Callback = function(value)
        print("Priority:", value)
        -- Update targeting logic
    end
})

-- Button
Combat:AddButton({
    Name = "Execute Attack",
    Callback = function()
        print("Executing attack!")
        -- Execute immediate attack
    end
})

-- Textbox
Combat:AddTextbox({
    Name = "Custom Target",
    Placeholder = "Enter player name...",
    Default = "",
    Callback = function(text)
        print("Target:", text)
        -- Set custom target
    end
})

-- Label
Combat:AddLabel({
    Text = "⚠️ Use responsibly - May get you banned"
})

-- Example 3: Visual Tab
local Visual = Window:AddTab({
    Name = "Visuals",
    Color = Color3.fromRGB(100, 255, 100)
})

Visual:AddToggle({
    Name = "ESP",
    Id = "ESP",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

Visual:AddSlider({
    Name = "ESP Distance",
    Min = 100,
    Max = 5000,
    Default = 1000,
    Increment = 50,
    Suffix = " studs",
    Textbox = true,
    Callback = function(value)
        print("ESP Distance:", value)
    end
})

Visual:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(color)
        print("ESP Color:", color)
    end
})

-- Example 4: Settings Tab
local Settings = Window:AddTab({
    Name = "Settings",
    Color = Color3.fromRGB(150, 150, 255)
})

Settings:AddDropdown({
    Name = "Theme",
    Options = {"Dark", "Light", "Ocean", "Cyberpunk", "Sunset"},
    Default = "Cyberpunk",
    Callback = function(theme)
        Window:SetTheme(theme)
    end
})

Settings:AddButton({
    Name = "Save Configuration",
    Callback = function()
        Window:SaveConfig("MySetup")
    end
})

Settings:AddButton({
    Name = "Load Configuration",
    Callback = function()
        Window:LoadConfig("MySetup")
    end
})

Settings:AddButton({
    Name = "Delete Configuration",
    Callback = function()
        Window:DeleteConfig("MySetup")
    end
})

Settings:AddButton({
    Name = "Export Config (Base64)",
    Callback = function()
        local exported = Window:ExportConfig()
        print("Exported config:", exported)
        -- Copy to clipboard if available
    end
})

-- Example 5: Notifications
Nexus:Notify({
    Title = "Script Loaded!",
    Content = "Premium Script Hub v3.0 initialized successfully",
    Duration = 5,
    Type = "success",
    Position = "TopRight"
})

-- Notification with actions
Nexus:Notify({
    Title = "Update Available",
    Content = "Version 3.1 is available. Download now?",
    Duration = 10,
    Type = "info",
    Position = "TopRight",
    Actions = {
        {
            Name = "Download",
            Callback = function()
                print("Downloading update...")
            end
        },
        {
            Name = "Later",
            Callback = function()
                print("Update postponed")
            end
        }
    }
})

-- Example 6: Config Management
-- Auto-save every 60 seconds (already configured)
-- Manual save
Window:SaveConfig("Profile1")

-- Load saved config
Window:LoadConfig("Profile1")

-- Delete config
Window:DeleteConfig("Profile1")

-- Export config to string
local configString = Window:ExportConfig()
print(configString) -- Share this with friends

-- Import config from string
Window:ImportConfig(configString)

-- Example 7: Theme Management
Window:SetTheme("Ocean") -- Change theme on the fly

-- Create custom theme
ThemeManager:CreateCustomTheme("MyTheme", {
    Background = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(255, 100, 200),
    AccentHover = Color3.fromRGB(255, 120, 220),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(50, 50, 60),
    Success = Color3.fromRGB(100, 255, 100),
    Error = Color3.fromRGB(255, 100, 100),
    Warning = Color3.fromRGB(255, 200, 100),
    Gradient1 = Color3.fromRGB(255, 100, 200),
    Gradient2 = Color3.fromRGB(100, 200, 255),
    GradientSpeed = 4
})

Window:SetTheme("MyTheme")

-- Example 8: Advanced Usage
-- Access component values directly
local killAuraToggle = Combat:AddToggle({
    Name = "Advanced Kill Aura",
    Id = "AdvancedKA",
    Default = false,
    Callback = function(value)
        print("Advanced KA:", value)
    end
})

-- Later, you can access the component
print("Current value:", killAuraToggle.Value)

-- Change value programmatically
killAuraToggle:SetValue(true) -- This will trigger the callback

-- Example 9: Mobile Support
-- Mobile button is automatically created if MobileButton = true
-- Users can drag the button anywhere on screen
-- Tapping toggles the UI visibility

-- Example 10: Cleanup
-- Destroy specific window
Window:Destroy()

-- Destroy all Nexus UI windows
Nexus:DestroyAll()

-- Example 11: Debug Mode
Nexus:SetDebugMode(true) -- Enable detailed logging

-- Example 12: Multiple Windows
local Window2 = Nexus:CreateWindow({
    Name = "Secondary Hub",
    Theme = "Light",
    Size = {500, 400},
    Keybind = Enum.KeyCode.LeftControl
})

-- Each window is independent with its own tabs and settings

print("[Nexus UI] Loaded successfully! Version:", Nexus:GetVersion())

]]

--[[═══════════════════════════════════════════════════════════════
    RETURN LIBRARY
═══════════════════════════════════════════════════════════════]]

return NexusUI
