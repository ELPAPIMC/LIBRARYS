--[[
    IS UI Library v1.0
    Librería UI completa para Roblox
    Características: Tabs, Toggles, Sliders, Dropdowns, Keybinds, Notificaciones, Sistema de Config
]]

local IS = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Utilidades
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function Tween(obj, props, duration)
    duration = duration or 0.25
    local tween = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
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

-- Sistema de configuración
local ConfigSystem = {
    CurrentConfig = {},
    SavedConfigs = {}
}

function ConfigSystem:SaveConfig(name)
    self.SavedConfigs[name] = HttpService:JSONEncode(self.CurrentConfig)
    return true
end

function ConfigSystem:LoadConfig(name)
    if self.SavedConfigs[name] then
        self.CurrentConfig = HttpService:JSONDecode(self.SavedConfigs[name])
        return true
    end
    return false
end

function ConfigSystem:DeleteConfig(name)
    self.SavedConfigs[name] = nil
end

function ConfigSystem:GetConfigList()
    local list = {}
    for name, _ in pairs(self.SavedConfigs) do
        table.insert(list, name)
    end
    return list
end

function ConfigSystem:SetValue(key, value)
    self.CurrentConfig[key] = value
end

function ConfigSystem:GetValue(key, default)
    return self.CurrentConfig[key] or default
end

-- Sistema de Keybinds
local KeybindSystem = {
    Binds = {}
}

function KeybindSystem:Register(key, callback, toggleObj)
    self.Binds[key] = {
        Callback = callback,
        Toggle = toggleObj
    }
end

function KeybindSystem:Unregister(key)
    self.Binds[key] = nil
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode.Name
    if KeybindSystem.Binds[key] then
        local bind = KeybindSystem.Binds[key]
        if bind.Toggle then
            bind.Toggle:SetValue(not bind.Toggle:GetValue())
        end
        if bind.Callback then
            bind.Callback()
        end
    end
end)

-- Sistema de Notificaciones
local NotificationSystem = {}
NotificationSystem.Container = nil
NotificationSystem.Notifications = {}

function NotificationSystem:Init(parent)
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.Size = UDim2.new(0, 300, 1, 0)
    self.Container.Position = UDim2.new(1, -310, 0, 10)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = parent
    
    local layout = Instance.new("UIListLayout")
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 5)
    layout.Parent = self.Container
end

function NotificationSystem:Send(title, message, type, duration)
    type = type or "info"
    duration = duration or 3
    
    local colors = {
        success = Color3.fromRGB(46, 204, 113),
        warning = Color3.fromRGB(241, 196, 15),
        error = Color3.fromRGB(231, 76, 60),
        info = Color3.fromRGB(52, 152, 219)
    }
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = colors[type]
    accent.BorderSizePixel = 0
    accent.Parent = notif
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -15, 0, 20)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -15, 0, 30)
    messageLabel.Position = UDim2.new(0, 10, 0, 25)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextSize = 12
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notif
    
    -- Animación de entrada
    Tween(notif, {Size = UDim2.new(1, 0, 0, 65)}, 0.3)
    
    -- Auto-destrucción
    delay(duration, function()
        Tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        wait(0.3)
        notif:Destroy()
    end)
end

-- Crear ventana principal
function IS:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "IS Library"
    local MobileButton = config.MobileButton or false
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ISLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Inicializar notificaciones
    NotificationSystem:Init(ScreenGui)
    
    -- Determinar tamaño según dispositivo
    local isMobile = IsMobile()
    local windowSize = isMobile and UDim2.new(0.7, 0, 0, 300) or UDim2.new(0, 600, 0, 450)
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = TitleBar
    
    -- Fix bottom corners
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    titleFix.BorderSizePixel = 0
    titleFix.Parent = TitleBar
    
    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Control Buttons
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 90, 0, 20)
    controlsFrame.Position = UDim2.new(1, -100, 0.5, 0)
    controlsFrame.AnchorPoint = Vector2.new(0, 0.5)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = TitleBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.Padding = UDim.new(0, 5)
    controlsLayout.Parent = controlsFrame
    
    local function CreateControlButton(color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 20, 0, 20)
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.Parent = controlsFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)}, 0.2)
        end)
        
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = color}, 0.2)
        end)
        
        return btn
    end
    
    -- Minimize Button (Amarillo)
    local minimized = false
    CreateControlButton(Color3.fromRGB(241, 196, 15), function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(windowSize.X.Scale, windowSize.X.Offset, 0, 40)}, 0.3)
        else
            Tween(MainFrame, {Size = windowSize}, 0.3)
        end
    end)
    
    -- Close Button (Rojo)
    CreateControlButton(Color3.fromRGB(231, 76, 60), function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        MainFrame.Visible = false
    end)
    
    -- Reset Button (Azul)
    CreateControlButton(Color3.fromRGB(52, 152, 219), function()
        MainFrame.Rotation = 0
        Tween(MainFrame, {Rotation = 360}, 0.5)
        wait(0.5)
        MainFrame.Rotation = 0
        NotificationSystem:Send("Reset", "Interface reiniciada", "info", 2)
    end)
    
    -- Draggable
    MakeDraggable(MainFrame, TitleBar)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = TabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = TabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingBottom = UDim.new(0, 5)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
    tabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -175, 1, -50)
    ContentContainer.Position = UDim2.new(0, 165, 0, 45)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = ContentContainer
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:CreateTab(name, icon)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 6)
        tabBtnCorner.Parent = TabButton
        
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 8, 0.5, 0)
        tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = icon or ""
        tabIcon.Parent = TabButton
        
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -40, 1, 0)
        tabLabel.Position = UDim2.new(0, 35, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = name
        tabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabLabel.TextSize = 14
        tabLabel.Font = Enum.Font.Gotham
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(52, 152, 219)
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = ContentContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.Parent = TabContent
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingBottom = UDim.new(0, 10)
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.Parent = TabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                tab.Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
            tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = Tab
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Label = tabLabel
        Tab.Elements = {}
        
        -- Activar primer tab
        if #Window.Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
            tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = Tab
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- COMPONENTES DEL TAB
        
        function Tab:AddSection(name)
            local Section = Instance.new("Frame")
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundTransparency = 1
            Section.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = name
            SectionLabel.TextColor3 = Color3.fromRGB(52, 152, 219)
            SectionLabel.TextSize = 16
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Section
            
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 1)
            Divider.Position = UDim2.new(0, 0, 1, -5)
            Divider.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
            Divider.BorderSizePixel = 0
            Divider.Parent = Section
        end
        
        function Tab:AddToggle(name, default, callback)
            default = default or false
            callback = callback or function() end
            
            local Toggle = {Value = default}
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 8)
            toggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, 0)
            ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 65)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local toggleBtnCorner = Instance.new("UICorner")
            toggleBtnCorner.CornerRadius = UDim.new(1, 0)
            toggleBtnCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = default and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            function Toggle:SetValue(val)
                Toggle.Value = val
                ConfigSystem:SetValue(name, val)
                
                Tween(ToggleButton, {
                    BackgroundColor3 = val and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 65)
                }, 0.25)
                
                Tween(ToggleCircle, {
                    Position = val and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                }, 0.25)
                
                callback(val)
            end
            
            function Toggle:GetValue()
                return Toggle.Value
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggle:SetValue(not Toggle.Value)
            end)
            
            -- Cargar valor guardado
            local saved = ConfigSystem:GetValue(name)
            if saved ~= nil then
                Toggle:SetValue(saved)
            end
            
            return Toggle
        end
        
        function Tab:AddButton(name, callback)
            callback = callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
            Button.Text = name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamBold
            Button.BorderSizePixel = 0
            Button.Parent = TabContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = Button
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(41, 128, 185)}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(52, 152, 219)}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(callback)
            
            return Button
        end
        
        function Tab:AddTextbox(name, placeholder, callback)
            placeholder = placeholder or ""
            callback = callback or function() end
            
            local Textbox = {Value = ""}
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, 0, 0, 70)
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local textboxCorner = Instance.new("UICorner")
            textboxCorner.CornerRadius = UDim.new(0, 8)
            textboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = name
            TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local TextboxInput = Instance.new("TextBox")
            TextboxInput.Size = UDim2.new(1, -20, 0, 35)
            TextboxInput.Position = UDim2.new(0, 10, 0, 30)
            TextboxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            TextboxInput.Text = ""
            TextboxInput.PlaceholderText = placeholder
            TextboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            TextboxInput.TextSize = 13
            TextboxInput.Font = Enum.Font.Gotham
            TextboxInput.BorderSizePixel = 0
            TextboxInput.ClearTextOnFocus = false
            TextboxInput.Parent = TextboxFrame
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = TextboxInput
            
            function Textbox:SetValue(val)
                Textbox.Value = val
                TextboxInput.Text = val
                ConfigSystem:SetValue(name, val)
            end
            
            function Textbox:GetValue()
                return Textbox.Value
            end
            
            TextboxInput.FocusLost:Connect(function()
                Textbox.Value = TextboxInput.Text
                ConfigSystem:SetValue(name, TextboxInput.Text)
                callback(TextboxInput.Text)
            end)
            
            -- Cargar valor guardado
            local saved = ConfigSystem:GetValue(name)
            if saved then
                Textbox:SetValue(saved)
            end
            
            return Textbox
        end
        
        function Tab:AddSlider(name, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            
            local Slider = {Value = default}
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 8)
            sliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
            SliderLabel.Position = UDim2.new(0, 12, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0.3, 0, 0, 20)
            SliderValue.Position = UDim2.new(0.7, 0, 0, 8)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(52, 152, 219)
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 1, -18)
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar
            
            local dragging = false
            
            function Slider:SetValue(val)
                val = math.clamp(val, min, max)
                Slider.Value = val
                SliderValue.Text = tostring(math.floor(val))
                ConfigSystem:SetValue(name, val)
                
                local percent = (val - min) / (max - min)
                Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                
                callback(val)
            end
            
            function Slider:GetValue()
                return Slider.Value
            end
            
            local function UpdateSlider(input)
                local pos = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                pos = math.clamp(pos, 0, 1)
                local value = min + (max - min) * pos
                Slider:SetValue(value)
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            SliderButton.MouseButton1Click:Connect(function()
                UpdateSlider(UserInputService:GetMouseLocation())
            end)
            
            -- Cargar valor guardado
            local saved = ConfigSystem:GetValue(name)
            if saved then
                Slider:SetValue(saved)
            end
            
            return Slider
        end
        
        function Tab:AddDropdown(name, options, multi, default, callback)
            options = options or {}
            multi = multi or false
            default = default or (multi and {} or nil)
            callback = callback or function() end
            
            local Dropdown = {
                Value = default,
                Options = options,
                Multi = multi,
                Open = false
            }
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 8)
            dropCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = name .. ": " .. (multi and "Multiple" or (default or "None"))
            DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.TextTruncate = Enum.TextTruncate.AtEnd
            DropdownLabel.Parent = DropdownFrame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 1, 0)
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            Arrow.TextSize = 12
            Arrow.Parent = DropdownFrame
            
            local OptionsList = Instance.new("Frame")
            OptionsList.Size = UDim2.new(1, 0, 0, 0)
            OptionsList.Position = UDim2.new(0, 0, 0, 40)
            OptionsList.BackgroundTransparency = 1
            OptionsList.Parent = DropdownFrame
            
            local optionsLayout = Instance.new("UIListLayout")
            optionsLayout.Parent = OptionsList
            
            function Dropdown:SetValue(val)
                Dropdown.Value = val
                ConfigSystem:SetValue(name, val)
                
                if multi then
                    local text = ""
                    for _, v in pairs(val) do
                        text = text .. v .. ", "
                    end
                    text = text:sub(1, -3)
                    DropdownLabel.Text = name .. ": " .. (text ~= "" and text or "None")
                else
                    DropdownLabel.Text = name .. ": " .. (val or "None")
                end
                
                callback(val)
            end
            
            function Dropdown:GetValue()
                return Dropdown.Value
            end
            
            function Dropdown:Toggle()
                Dropdown.Open = not Dropdown.Open
                
                if Dropdown.Open then
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + #options * 30)}, 0.25)
                    Tween(Arrow, {Rotation = 180}, 0.25)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.25)
                    Tween(Arrow, {Rotation = 0}, 0.25)
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                Dropdown:Toggle()
            end)
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = OptionsList
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(52, 152, 219)}, 0.2)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    if multi then
                        local selected = Dropdown.Value or {}
                        local index = table.find(selected, option)
                        
                        if index then
                            table.remove(selected, index)
                            OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                        else
                            table.insert(selected, option)
                            OptionButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                        end
                        
                        Dropdown:SetValue(selected)
                    else
                        Dropdown:SetValue(option)
                        Dropdown:Toggle()
                    end
                end)
            end
            
            -- Cargar valor guardado
            local saved = ConfigSystem:GetValue(name)
            if saved then
                Dropdown:SetValue(saved)
            end
            
            return Dropdown
        end
        
        function Tab:AddKeybind(name, default, callback, toggleObj)
            default = default or "NONE"
            callback = callback or function() end
            
            local Keybind = {Value = default, Toggle = toggleObj}
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 8)
            keyCorner.Parent = KeybindFrame
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -90, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = name
            KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 70, 0, 28)
            KeybindButton.Position = UDim2.new(1, -80, 0.5, 0)
            KeybindButton.AnchorPoint = Vector2.new(0, 0.5)
            KeybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            KeybindButton.Text = default
            KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.TextSize = 13
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Parent = KeybindFrame
            
            local keyBtnCorner = Instance.new("UICorner")
            keyBtnCorner.CornerRadius = UDim.new(0, 6)
            keyBtnCorner.Parent = KeybindButton
            
            local binding = false
            
            function Keybind:SetValue(val)
                if Keybind.Value ~= "NONE" then
                    KeybindSystem:Unregister(Keybind.Value)
                end
                
                Keybind.Value = val
                KeybindButton.Text = val
                ConfigSystem:SetValue(name, val)
                
                if val ~= "NONE" then
                    KeybindSystem:Register(val, function()
                        callback()
                    end, toggleObj)
                end
            end
            
            function Keybind:GetValue()
                return Keybind.Value
            end
            
            KeybindButton.MouseButton1Click:Connect(function()
                binding = true
                KeybindButton.Text = "..."
                KeybindButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if binding and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        Keybind:SetValue(input.KeyCode.Name)
                        binding = false
                        KeybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                    end
                end
            end)
            
            -- Cargar y registrar keybind guardado
            local saved = ConfigSystem:GetValue(name)
            if saved then
                Keybind:SetValue(saved)
            else
                Keybind:SetValue(default)
            end
            
            return Keybind
        end
        
        function Tab:AddMiniToggle(name, default, callback)
            default = default or false
            callback = callback or function() end
            
            local MiniToggle = {Value = default}
            
            local MiniFrame = Instance.new("Frame")
            MiniFrame.Size = UDim2.new(1, 0, 0, 35)
            MiniFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            MiniFrame.BorderSizePixel = 0
            MiniFrame.Parent = TabContent
            
            local miniCorner = Instance.new("UICorner")
            miniCorner.CornerRadius = UDim.new(0, 8)
            miniCorner.Parent = MiniFrame
            
            local MiniLabel = Instance.new("TextLabel")
            MiniLabel.Size = UDim2.new(1, -50, 1, 0)
            MiniLabel.Position = UDim2.new(0, 10, 0, 0)
            MiniLabel.BackgroundTransparency = 1
            MiniLabel.Text = name
            MiniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            MiniLabel.TextSize = 13
            MiniLabel.Font = Enum.Font.Gotham
            MiniLabel.TextXAlignment = Enum.TextXAlignment.Left
            MiniLabel.Parent = MiniFrame
            
            local MiniButton = Instance.new("TextButton")
            MiniButton.Size = UDim2.new(0, 35, 0, 18)
            MiniButton.Position = UDim2.new(1, -40, 0.5, 0)
            MiniButton.AnchorPoint = Vector2.new(0, 0.5)
            MiniButton.BackgroundColor3 = default and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 65)
            MiniButton.Text = ""
            MiniButton.BorderSizePixel = 0
            MiniButton.Parent = MiniFrame
            
            local miniBtnCorner = Instance.new("UICorner")
            miniBtnCorner.CornerRadius = UDim.new(1, 0)
            miniBtnCorner.Parent = MiniButton
            
            local MiniCircle = Instance.new("Frame")
            MiniCircle.Size = UDim2.new(0, 14, 0, 14)
            MiniCircle.Position = default and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            MiniCircle.AnchorPoint = Vector2.new(0, 0.5)
            MiniCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            MiniCircle.BorderSizePixel = 0
            MiniCircle.Parent = MiniButton
            
            local miniCircleCorner = Instance.new("UICorner")
            miniCircleCorner.CornerRadius = UDim.new(1, 0)
            miniCircleCorner.Parent = MiniCircle
            
            function MiniToggle:SetValue(val)
                MiniToggle.Value = val
                ConfigSystem:SetValue(name, val)
                
                Tween(MiniButton, {
                    BackgroundColor3 = val and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 65)
                }, 0.2)
                
                Tween(MiniCircle, {
                    Position = val and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                }, 0.2)
                
                callback(val)
            end
            
            function MiniToggle:GetValue()
                return MiniToggle.Value
            end
            
            MiniButton.MouseButton1Click:Connect(function()
                MiniToggle:SetValue(not MiniToggle.Value)
            end)
            
            -- Cargar valor guardado
            local saved = ConfigSystem:GetValue(name)
            if saved ~= nil then
                MiniToggle:SetValue(saved)
            end
            
            return MiniToggle
        end
        
        return Tab
    end
    
    -- Crear tab de Settings al final
    function Window:CreateSettingsTab()
        local SettingsTab = Window:CreateTab("Settings", "rbxassetid://7733955511")
        
        SettingsTab:AddSection("💾 Configuration System")
        
        local configNameBox
        configNameBox = SettingsTab:AddTextbox("Config Name", "Enter config name", function() end)
        
        SettingsTab:AddButton("Save Config", function()
            local configName = configNameBox:GetValue()
            if configName and configName ~= "" then
                ConfigSystem:SaveConfig(configName)
                NotificationSystem:Send("Config Saved", "Configuration '" .. configName .. "' saved successfully!", "success", 3)
            else
                NotificationSystem:Send("Error", "Please enter a config name", "error", 3)
            end
        end)
        
        SettingsTab:AddButton("Load Config", function()
            local configName = configNameBox:GetValue()
            if configName and configName ~= "" then
                if ConfigSystem:LoadConfig(configName) then
                    NotificationSystem:Send("Config Loaded", "Configuration '" .. configName .. "' loaded!", "success", 3)
                    -- Recargar todos los valores en la UI
                    for _, tab in pairs(Window.Tabs) do
                        -- Aquí se actualizarían automáticamente los componentes
                    end
                else
                    NotificationSystem:Send("Error", "Config not found", "error", 3)
                end
            else
                NotificationSystem:Send("Error", "Please enter a config name", "error", 3)
            end
        end)
        
        SettingsTab:AddButton("Delete Config", function()
            local configName = configNameBox:GetValue()
            if configName and configName ~= "" then
                ConfigSystem:DeleteConfig(configName)
                NotificationSystem:Send("Config Deleted", "Configuration '" .. configName .. "' deleted", "warning", 3)
            else
                NotificationSystem:Send("Error", "Please enter a config name", "error", 3)
            end
        end)
        
        SettingsTab:AddSection("📋 Saved Configs")
        
        SettingsTab:AddButton("List All Configs", function()
            local configs = ConfigSystem:GetConfigList()
            if #configs > 0 then
                local list = table.concat(configs, ", ")
                NotificationSystem:Send("Configs", "Available: " .. list, "info", 5)
            else
                NotificationSystem:Send("No Configs", "No saved configurations found", "info", 3)
            end
        end)
    end
    
    -- Botón flotante móvil
    if MobileButton and IsMobile() then
        local FloatingButton = Instance.new("TextButton")
        FloatingButton.Size = UDim2.new(0, 60, 0, 60)
        FloatingButton.Position = UDim2.new(1, -70, 0, 10)
        FloatingButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        FloatingButton.Text = "☰"
        FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FloatingButton.TextSize = 24
        FloatingButton.Font = Enum.Font.GothamBold
        FloatingButton.BorderSizePixel = 0
        FloatingButton.Parent = ScreenGui
        
        local floatCorner = Instance.new("UICorner")
        floatCorner.CornerRadius = UDim.new(1, 0)
        floatCorner.Parent = FloatingButton
        
        FloatingButton.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
        end)
        
        MakeDraggable(FloatingButton, FloatingButton)
    end
    
    return Window
end

-- Función de notificación global
function IS:Notify(title, message, type, duration)
    NotificationSystem:Send(title, message, type, duration)
end

return IS
