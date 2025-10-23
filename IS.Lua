local IS = {}
IS.__index = IS

-- Servicios
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Estilos
local Colors = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(100, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(50, 50, 60),
    Toggle_On = Color3.fromRGB(100, 200, 100),
    Toggle_Off = Color3.fromRGB(60, 60, 70),
    Success = Color3.fromRGB(100, 200, 100),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 80, 80),
    Info = Color3.fromRGB(100, 150, 255)
}

-- Variables globales
IS.Notifications = {}
IS.NotificationOffset = 20
IS.Keybinds = {}

-- Función de animación suave
local function smoothTween(object, properties, duration)
    duration = duration or 0.3
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- Calcular tamaño responsivo
local function getResponsiveSize()
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    if isMobile then
        return {
            Width = math.min(ViewportSize.X * 0.9, 500),
            Height = math.min(ViewportSize.Y * 0.7, 400)
        }
    else
        return {
            Width = math.min(ViewportSize.X * 0.5, 600),
            Height = math.min(ViewportSize.Y * 0.6, 450)
        }
    end
end

-- Sistema de notificaciones mejorado
function IS:Notification(title, message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"
    
    local notifColors = {
        success = Colors.Success,
        warning = Colors.Warning,
        error = Colors.Error,
        info = Colors.Info
    }
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 0)
    notification.Position = UDim2.new(1, -320, 1, -(self.NotificationOffset))
    notification.BackgroundColor3 = Colors.Secondary
    notification.BorderSizePixel = 0
    notification.Parent = self.ScreenGui
    notification.ClipsDescendants = true
    notification.ZIndex = 10
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = notifColors[notifType] or Colors.Info
    stroke.Thickness = 2
    stroke.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Colors.SubText
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    
    table.insert(self.Notifications, notification)
    self.NotificationOffset = self.NotificationOffset + 95
    
    smoothTween(notification, {Size = UDim2.new(0, 300, 0, 85)}, 0.4)
    
    task.delay(duration, function()
        smoothTween(notification, {Size = UDim2.new(0, 300, 0, 0)}, 0.4)
        task.wait(0.4)
        
        for i, notif in ipairs(self.Notifications) do
            if notif == notification then
                table.remove(self.Notifications, i)
                break
            end
        end
        
        self.NotificationOffset = self.NotificationOffset - 95
        notification:Destroy()
        
        -- Reposicionar notificaciones
        for i, notif in ipairs(self.Notifications) do
            smoothTween(notif, {Position = UDim2.new(1, -320, 1, -(20 + (i - 1) * 95))}, 0.3)
        end
    end)
end

-- Crear ventana principal
function IS:CreateWindow(config)
    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.Minimized = false
    window.ConfigData = {}
    window.Keybinds = {}
    
    local title = type(config) == "string" and config or config.Title or "IS"
    local mobileButton = type(config) == "table" and config.MobileButton or false
    
    local size = getResponsiveSize()
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "IS_Library"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.CoreGui
    self.ScreenGui = screenGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, size.Width, 0, size.Height)
    mainFrame.Position = UDim2.new(0.5, -size.Width/2, 0.5, -size.Height/2)
    mainFrame.BackgroundColor3 = Colors.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Colors.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 10)
    titleFix.Position = UDim2.new(0, 0, 1, -10)
    titleFix.BackgroundColor3 = Colors.Secondary
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Función para crear botones de control
    local function createControlButton(color, position, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 25, 0, 25)
        button.Position = position
        button.BackgroundColor3 = color
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = titleBar
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(1, 0)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        
        button.MouseEnter:Connect(function()
            smoothTween(button, {BackgroundColor3 = Color3.new(math.min(color.R * 1.2, 1), math.min(color.G * 1.2, 1), math.min(color.B * 1.2, 1))}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            smoothTween(button, {BackgroundColor3 = color}, 0.2)
        end)
        
        return button
    end
    
    -- Botón amarillo (Minimizar)
    createControlButton(Color3.fromRGB(255, 200, 0), UDim2.new(1, -110, 0.5, -12.5), function()
        window.Minimized = not window.Minimized
        if window.Minimized then
            smoothTween(mainFrame, {Size = UDim2.new(0, size.Width, 0, 40)}, 0.3)
        else
            smoothTween(mainFrame, {Size = UDim2.new(0, size.Width, 0, size.Height)}, 0.3)
        end
    end)
    
    -- Botón rojo (Cerrar)
    createControlButton(Color3.fromRGB(255, 60, 60), UDim2.new(1, -75, 0.5, -12.5), function()
        mainFrame.Visible = false
        if mobileButton then
            self:Notification("GUI Cerrada", "Presiona el botón móvil para abrir", 2, "info")
        end
    end)
    
    -- Botón azul (Reiniciar)
    createControlButton(Color3.fromRGB(60, 150, 255), UDim2.new(1, -40, 0.5, -12.5), function()
        smoothTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.wait(0.2)
        mainFrame.Visible = true
        smoothTween(mainFrame, {Size = UDim2.new(0, size.Width, 0, size.Height)}, 0.3)
        self:Notification("Reiniciado", "GUI reiniciada correctamente", 2, "success")
    end)
    
    -- Botón móvil (si está activado)
    if mobileButton then
        local mobileBtn = Instance.new("TextButton")
        mobileBtn.Size = UDim2.new(0, 60, 0, 60)
        mobileBtn.Position = UDim2.new(0, 10, 0.5, -30)
        mobileBtn.BackgroundColor3 = Colors.Accent
        mobileBtn.BorderSizePixel = 0
        mobileBtn.Text = "IS"
        mobileBtn.TextColor3 = Colors.Text
        mobileBtn.TextSize = 20
        mobileBtn.Font = Enum.Font.GothamBold
        mobileBtn.Parent = screenGui
        
        local mbCorner = Instance.new("UICorner")
        mbCorner.CornerRadius = UDim.new(1, 0)
        mbCorner.Parent = mobileBtn
        
        mobileBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = not mainFrame.Visible
        end)
        
        -- Hacer draggable el botón móvil
        local dragging, dragInput, dragStart, startPos
        
        mobileBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mobileBtn.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        mobileBtn.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                mobileBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    -- Contenedor de tabs
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -50)
    tabContainer.Position = UDim2.new(0, 10, 0, 45)
    tabContainer.BackgroundColor3 = Colors.Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 4
    tabContainer.Parent = mainFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabContainer
    
    -- Contenedor de contenido
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -175, 1, -50)
    contentContainer.Position = UDim2.new(0, 165, 0, 45)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame
    
    -- Hacer draggable
    local dragging, dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentContainer = contentContainer
    window.TabLayout = tabLayout
    window.Size = size
    
    -- Crear tab de Settings por defecto
    local settingsTab = window:CreateTab("Settings", "rbxassetid://7733954760")
    window:CreateSettingsContent(settingsTab)
    
    return window
end

-- Crear tab
function IS:CreateTab(name, image)
    local tab = {}
    tab.Name = name
    tab.Elements = {}
    
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -10, 0, 35)
    tabButton.BackgroundColor3 = Colors.Background
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.Parent = self.TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    if image then
        local tabImage = Instance.new("ImageLabel")
        tabImage.Size = UDim2.new(0, 20, 0, 20)
        tabImage.Position = UDim2.new(0, 8, 0.5, -10)
        tabImage.BackgroundTransparency = 1
        tabImage.Image = image
        tabImage.Parent = tabButton
    end
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, image and -35 or -15, 1, 0)
    tabLabel.Position = UDim2.new(0, image and 35 or 10, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = name
    tabLabel.TextColor3 = Colors.SubText
    tabLabel.TextSize = 14
    tabLabel.Font = Enum.Font.Gotham
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabButton
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.Visible = false
    tabContent.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.Parent = tabContent
    
    tabButton.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Content.Visible = false
            smoothTween(self.CurrentTab.Button, {BackgroundColor3 = Colors.Background}, 0.2)
            self.CurrentTab.Label.TextColor3 = Colors.SubText
        end
        
        tabContent.Visible = true
        smoothTween(tabButton, {BackgroundColor3 = Colors.Accent}, 0.2)
        tabLabel.TextColor3 = Colors.Text
        
        self.CurrentTab = {Content = tabContent, Button = tabButton, Label = tabLabel}
    end)
    
    tab.Button = tabButton
    tab.Content = tabContent
    tab.Label = tabLabel
    tab.Layout = contentLayout
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        tabButton.MouseButton1Click:Fire()
    end
    
    return tab
end

-- Sección/Separador
function IS.CreateTab:AddSection(text)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, 0, 0, 30)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Parent = self.Content
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 5, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = text
    sectionLabel.TextColor3 = Colors.Accent
    sectionLabel.TextSize = 16
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -10, 0, 2)
    line.Position = UDim2.new(0, 5, 1, -5)
    line.BackgroundColor3 = Colors.Border
    line.BorderSizePixel = 0
    line.Parent = sectionFrame
end

-- Toggle
function IS.CreateTab:AddToggle(text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Colors.Secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = self.Content
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Colors.Text
    toggleLabel.TextSize = 14
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 45, 0, 24)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12)
    toggleButton.BackgroundColor3 = default and Colors.Toggle_On or Colors.Toggle_Off
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleBCorner = Instance.new("UICorner")
    toggleBCorner.CornerRadius = UDim.new(1, 0)
    toggleBCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    toggleCircle.BackgroundColor3 = Colors.Text
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local toggled = default
    
    local function updateToggle(value)
        toggled = value
        smoothTween(toggleButton, {BackgroundColor3 = toggled and Colors.Toggle_On or Colors.Toggle_Off}, 0.2)
        smoothTween(toggleCircle, {Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.2)
        callback(toggled)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        updateToggle(not toggled)
    end)
    
    return {
        SetValue = function(value)
            updateToggle(value)
        end,
        GetValue = function()
            return toggled
        end
    }
end

-- Mini Toggle (Switch compacto)
function IS.CreateTab:AddMiniToggle(text, default, callback)
    local miniFrame = Instance.new("Frame")
    miniFrame.Size = UDim2.new(1, 0, 0, 30)
    miniFrame.BackgroundTransparency = 1
    miniFrame.Parent = self.Content
    
    local miniLabel = Instance.new("TextLabel")
    miniLabel.Size = UDim2.new(1, -50, 1, 0)
    miniLabel.Position = UDim2.new(0, 10, 0, 0)
    miniLabel.BackgroundTransparency = 1
    miniLabel.Text = text
    miniLabel.TextColor3 = Colors.SubText
    miniLabel.TextSize = 13
    miniLabel.Font = Enum.Font.Gotham
    miniLabel.TextXAlignment = Enum.TextXAlignment.Left
    miniLabel.Parent = miniFrame
    
    local miniButton = Instance.new("TextButton")
    miniButton.Size = UDim2.new(0, 35, 0, 18)
    miniButton.Position = UDim2.new(1, -45, 0.5, -9)
    miniButton.BackgroundColor3 = default and Colors.Toggle_On or Colors.Toggle_Off
    miniButton.BorderSizePixel = 0
    miniButton.Text = ""
    miniButton.Parent = miniFrame
    
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(1, 0)
    miniCorner.Parent = miniButton
    
    local miniCircle = Instance.new("Frame")
    miniCircle.Size = UDim2.new(0, 14, 0, 14)
    miniCircle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    miniCircle.BackgroundColor3 = Colors.Text
    miniCircle.BorderSizePixel = 0
    miniCircle.Parent = miniButton
    
    local miniCCorner = Instance.new("UICorner")
    miniCCorner.CornerRadius = UDim.new(1, 0)
    miniCCorner.Parent = miniCircle
    
    local toggled = default
    
    miniButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        smoothTween(miniButton, {BackgroundColor3 = toggled and Colors.Toggle_On or Colors.Toggle_Off}, 0.2)
        smoothTween(miniCircle, {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}, 0.2)
        callback(toggled)
    end)
    
    return {
        SetValue = function(value)
            toggled = value
            miniButton.BackgroundColor3 = toggled and Colors.Toggle_On or Colors.Toggle_Off
            miniCircle.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        end
    }
end

-- Keybind Selector
function IS.CreateTab:AddKeybind(text, default, callback, linkedToggle)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Size = UDim2.new(1, 0, 0, 40)
    keybindFrame.BackgroundColor3 = Colors.Secondary
    keybindFrame.BorderSizePixel = 0
    keybindFrame.Parent = self.Content
    
    local kbCorner = Instance.new("UICorner")
    kbCorner.CornerRadius = UDim.new(0, 6)
    kbCorner.Parent = keybindFrame
    
    local kbLabel = Instance.new("TextLabel")
    kbLabel.Size = UDim2.new(1, -80, 1, 0)
    kbLabel.Position = UDim2.new(0, 10, 0, 0)
    kbLabel.BackgroundTransparency = 1
    kbLabel.Text = text
    kbLabel.TextColor3 = Colors.Text
    kbLabel.TextSize = 14
    kbLabel.Font = Enum.Font.Gotham
    kbLabel.TextXAlignment = Enum.TextXAlignment.Left
    kbLabel.Parent = keybindFrame
    
    local kbButton = Instance.new("TextButton")
    kbButton.Size = UDim2.new(0, 65, 0, 28)
    kbButton.Position = UDim2.new(1, -75, 0.5, -14)
    kbButton.BackgroundColor3 = Colors.Background
    kbButton.BorderSizePixel = 0
    kbButton.Text = default or "NONE"
    kbButton.TextColor3 = Colors.Text
    kbButton.TextSize = 13
    kbButton.Font = Enum.Font.GothamBold
    kbButton.Parent = keybindFrame
    
    local kbBCorner = Instance.new("UICorner")
    kbBCorner.CornerRadius = UDim.new(0, 4)
    kbBCorner.Parent = kbButton
    
    local currentKey = default
    local listening = false
    
    kbButton.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        kbButton.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode.Name
                kbButton.Text = currentKey
                listening = false
                connection:Disconnect()
                
                -- Registrar keybind global
                if IS.Keybinds[currentKey] then
                    table.insert(IS.Keybinds[currentKey], {callback = callback, toggle = linkedToggle})
                else
                    IS.Keybinds[currentKey] = {{callback = callback, toggle = linkedToggle}}
                end
            end
        end)
    end)
    
    return {
        SetKey = function(key)
            currentKey = key
            kbButton.Text = key
        end,
        GetKey = function()
            return currentKey
        end
    }
end

-- Textbox/Input
function IS.CreateTab:AddTextbox(text, placeholder, callback)
    local textboxFrame = Instance.new("Frame")
    textboxFrame.Size = UDim2.new(1, 0, 0, 70)
    textboxFrame.BackgroundColor3 = Colors.Secondary
    textboxFrame.BorderSizePixel = 0
    textboxFrame.Parent = self.Content
    
    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 6)
    tbCorner.Parent = textboxFrame
    
    local tbLabel = Instance.new("TextLabel")
    tbLabel.Size = UDim2.new(1, -20, 0, 25)
    tbLabel.Position = UDim2.new(0, 10, 0, 5)
    tbLabel.BackgroundTransparency = 1
    tbLabel.Text = text
    tbLabel.TextColor3 = Colors.Text
    tbLabel.TextSize = 14
    tbLabel.Font = Enum.Font.Gotham
    tbLabel.TextXAlignment = Enum.TextXAlignment.Left
    tbLabel.Parent = textboxFrame
    
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -20, 0, 30)
    textbox.Position = UDim2.new(0, 10, 0, 35)
    textbox.BackgroundColor3 = Colors.Background
    textbox.BorderSizePixel = 0
    textbox.Text = ""
    textbox.PlaceholderText = placeholder or "Escribe aquí..."
    textbox.TextColor3 = Colors.Text
    textbox.PlaceholderColor3 = Colors.SubText
    textbox.TextSize = 13
    textbox.Font = Enum.Font.Gotham
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.ClearTextOnFocus = false
    textbox.Parent = textboxFrame
    
    local tbInputCorner = Instance.new("UICorner")
    tbInputCorner.CornerRadius = UDim.new(0, 4)
    tbInputCorner.Parent = textbox
    
    local tbPadding = Instance.new("UIPadding")
    tbPadding.PaddingLeft = UDim.new(0, 8)
    tbPadding.PaddingRight = UDim.new(0, 8)
    tbPadding.Parent = textbox
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textbox.Text)
        end
    end)
    
    return {
        SetValue = function(value)
            textbox.Text = value
        end,
        GetValue = function()
            return textbox.Text
        end
    }
end

-- Dropdown
function IS.CreateTab:AddDropdown(text, options, default, multi, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    dropdownFrame.BackgroundColor3 = Colors.Secondary
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = self.Content
    dropdownFrame.ClipsDescendants = false
    
    local ddCorner = Instance.new("UICorner")
    ddCorner.CornerRadius = UDim.new(0, 6)
    ddCorner.Parent = dropdownFrame
    
    local ddLabel = Instance.new("TextLabel")
    ddLabel.Size = UDim2.new(1, -20, 0, 20)
    ddLabel.Position = UDim2.new(0, 10, 0, 5)
    ddLabel.BackgroundTransparency = 1
    ddLabel.Text = text
    ddLabel.TextColor3 = Colors.Text
    ddLabel.TextSize = 14
    ddLabel.Font = Enum.Font.Gotham
    ddLabel.TextXAlignment = Enum.TextXAlignment.Left
    ddLabel.Parent = dropdownFrame
    
    local ddButton = Instance.new("TextButton")
    ddButton.Size = UDim2.new(1, -20, 0, 25)
    ddButton.Position = UDim2.new(0, 10, 0, 30)
    ddButton.BackgroundColor3 = Colors.Background
    ddButton.BorderSizePixel = 0
    ddButton.Text = multi and "Seleccionar..." or (default or "Seleccionar...")
    ddButton.TextColor3 = Colors.SubText
    ddButton.TextSize = 13
    ddButton.Font = Enum.Font.Gotham
    ddButton.TextXAlignment = Enum.TextXAlignment.Left
    ddButton.Parent = dropdownFrame
    
    local ddBCorner = Instance.new("UICorner")
    ddBCorner.CornerRadius = UDim.new(0, 4)
    ddBCorner.Parent = ddButton
    
    local ddPadding = Instance.new("UIPadding")
    ddPadding.PaddingLeft = UDim.new(0, 8)
    ddPadding.PaddingRight = UDim.new(0, 25)
    ddPadding.Parent = ddButton
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Colors.SubText
    arrow.TextSize = 12
    arrow.Parent = ddButton
    
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Size = UDim2.new(1, -20, 0, 0)
    optionsFrame.Position = UDim2.new(0, 10, 0, 60)
    optionsFrame.BackgroundColor3 = Colors.Background
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ScrollBarThickness = 4
    optionsFrame.Visible = false
    optionsFrame.Parent = dropdownFrame
    optionsFrame.ZIndex = 5
    
    local ofCorner = Instance.new("UICorner")
    ofCorner.CornerRadius = UDim.new(0, 4)
    ofCorner.Parent = optionsFrame
    
    local ofLayout = Instance.new("UIListLayout")
    ofLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ofLayout.Padding = UDim.new(0, 2)
    ofLayout.Parent = optionsFrame
    
    local selected = multi and {} or default
    local isOpen = false
    
    local function updateText()
        if multi then
            if #selected > 0 then
                ddButton.Text = table.concat(selected, ", ")
            else
                ddButton.Text = "Seleccionar..."
            end
        else
            ddButton.Text = selected or "Seleccionar..."
        end
    end
    
    ddButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            local contentHeight = math.min(#options * 32, 150)
            smoothTween(optionsFrame, {Size = UDim2.new(1, -20, 0, contentHeight)}, 0.3)
            smoothTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 70 + contentHeight)}, 0.3)
            optionsFrame.Visible = true
            arrow.Text = "▲"
        else
            smoothTween(optionsFrame, {Size = UDim2.new(1, -20, 0, 0)}, 0.3)
            smoothTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 70)}, 0.3)
            task.wait(0.3)
            optionsFrame.Visible = false
            arrow.Text = "▼"
        end
    end)
    
    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, -10, 0, 30)
        optionButton.BackgroundColor3 = Colors.Secondary
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Colors.Text
        optionButton.TextSize = 13
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Parent = optionsFrame
        
        local obCorner = Instance.new("UICorner")
        obCorner.CornerRadius = UDim.new(0, 4)
        obCorner.Parent = optionButton
        
        local obPadding = Instance.new("UIPadding")
        obPadding.PaddingLeft = UDim.new(0, 8)
        obPadding.Parent = optionButton
        
        if multi then
            local checkbox = Instance.new("Frame")
            checkbox.Size = UDim2.new(0, 16, 0, 16)
            checkbox.Position = UDim2.new(1, -20, 0.5, -8)
            checkbox.BackgroundColor3 = Colors.Background
            checkbox.BorderSizePixel = 0
            checkbox.Parent = optionButton
            
            local cbCorner = Instance.new("UICorner")
            cbCorner.CornerRadius = UDim.new(0, 3)
            cbCorner.Parent = checkbox
            
            local checkmark = Instance.new("TextLabel")
            checkmark.Size = UDim2.new(1, 0, 1, 0)
            checkmark.BackgroundTransparency = 1
            checkmark.Text = "✓"
            checkmark.TextColor3 = Colors.Toggle_On
            checkmark.TextSize = 14
            checkmark.Font = Enum.Font.GothamBold
            checkmark.Visible = false
            checkmark.Parent = checkbox
            
            optionButton.MouseButton1Click:Connect(function()
                local index = table.find(selected, option)
                if index then
                    table.remove(selected, index)
                    checkmark.Visible = false
                else
                    table.insert(selected, option)
                    checkmark.Visible = true
                end
                updateText()
                callback(selected)
            end)
        else
            optionButton.MouseButton1Click:Connect(function()
                selected = option
                updateText()
                callback(selected)
                
                isOpen = false
                smoothTween(optionsFrame, {Size = UDim2.new(1, -20, 0, 0)}, 0.3)
                smoothTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 70)}, 0.3)
                task.wait(0.3)
                optionsFrame.Visible = false
                arrow.Text = "▼"
            end)
        end
    end
    
    ofLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, ofLayout.AbsoluteContentSize.Y)
    end)
    
    return {
        SetValue = function(value)
            selected = value
            updateText()
        end,
        GetValue = function()
            return selected
        end,
        Refresh = function(newOptions)
            for _, child in ipairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            options = newOptions
            -- Recrear opciones...
        end
    }
end

-- Slider
function IS.CreateTab:AddSlider(text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 60)
    sliderFrame.BackgroundColor3 = Colors.Secondary
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = self.Content
    
    local slCorner = Instance.new("UICorner")
    slCorner.CornerRadius = UDim.new(0, 6)
    slCorner.Parent = sliderFrame
    
    local slLabel = Instance.new("TextLabel")
    slLabel.Size = UDim2.new(0.7, 0, 0, 20)
    slLabel.Position = UDim2.new(0, 10, 0, 8)
    slLabel.BackgroundTransparency = 1
    slLabel.Text = text
    slLabel.TextColor3 = Colors.Text
    slLabel.TextSize = 14
    slLabel.Font = Enum.Font.Gotham
    slLabel.TextXAlignment = Enum.TextXAlignment.Left
    slLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Colors.Accent
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 0, 38)
    sliderBar.BackgroundColor3 = Colors.Background
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Colors.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Colors.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderButton
    
    local dragging = false
    local currentValue = default
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * pos)
        
        valueLabel.Text = tostring(currentValue)
        smoothTween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
        smoothTween(sliderButton, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.1)
        
        callback(currentValue)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)
    
    return {
        SetValue = function(value)
            currentValue = math.clamp(value, min, max)
            local pos = (currentValue - min) / (max - min)
            valueLabel.Text = tostring(currentValue)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderButton.Position = UDim2.new(pos, -8, 0.5, -8)
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- Button
function IS.CreateTab:AddButton(text, callback)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Size = UDim2.new(1, 0, 0, 40)
    buttonFrame.BackgroundColor3 = Colors.Secondary
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Text = ""
    buttonFrame.Parent = self.Content
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = buttonFrame
    
    local buttonLabel = Instance.new("TextLabel")
    buttonLabel.Size = UDim2.new(1, -20, 1, 0)
    buttonLabel.Position = UDim2.new(0, 10, 0, 0)
    buttonLabel.BackgroundTransparency = 1
    buttonLabel.Text = text
    buttonLabel.TextColor3 = Colors.Text
    buttonLabel.TextSize = 14
    buttonLabel.Font = Enum.Font.GothamSemibold
    buttonLabel.Parent = buttonFrame
    
    buttonFrame.MouseButton1Click:Connect(function()
        smoothTween(buttonFrame, {BackgroundColor3 = Colors.Accent}, 0.1)
        task.wait(0.1)
        smoothTween(buttonFrame, {BackgroundColor3 = Colors.Secondary}, 0.1)
        callback()
    end)
end

-- Settings Tab Content
function IS:CreateSettingsContent(tab)
    local savedConfigs = {}
    local configListFrame
    
    tab:AddSection("Configuraciones")
    
    local configName = tab:AddTextbox("Nombre de Config", "Mi Config", function(value) end)
    
    tab:AddButton("Guardar Configuración", function()
        local name = configName.GetValue()
        if name == "" then name = "Config_" .. os.date("%Y%m%d_%H%M%S") end
        
        self.ConfigData[name] = {
            name = name,
            data = {},
            timestamp = os.time()
        }
        
        table.insert(savedConfigs, name)
        self:Notification("Guardado", "Configuración guardada: " .. name, 2, "success")
        
        -- Actualizar lista
        if configListFrame then
            configListFrame:Destroy()
        end
        createConfigList()
    end)
    
    tab:AddButton("Cargar Configuración", function()
        if #savedConfigs > 0 then
            local lastConfig = savedConfigs[#savedConfigs]
            self:Notification("Cargado", "Configuración cargada: " .. lastConfig, 2, "success")
        else
            self:Notification("Error", "No hay configuraciones guardadas", 2, "error")
        end
    end)
    
    tab:AddSection("Lista de Configuraciones")
    
    function createConfigList()
        configListFrame = Instance.new("Frame")
        configListFrame.Size = UDim2.new(1, 0, 0, math.max(#savedConfigs * 45, 50))
        configListFrame.BackgroundColor3 = Colors.Secondary
        configListFrame.BorderSizePixel = 0
        configListFrame.Parent = tab.Content
        
        local clCorner = Instance.new("UICorner")
        clCorner.CornerRadius = UDim.new(0, 6)
        clCorner.Parent = configListFrame
        
        local clLayout = Instance.new("UIListLayout")
        clLayout.SortOrder = Enum.SortOrder.LayoutOrder
        clLayout.Padding = UDim.new(0, 5)
        clLayout.Parent = configListFrame
        
        local clPadding = Instance.new("UIPadding")
        clPadding.PaddingLeft = UDim.new(0, 10)
        clPadding.PaddingRight = UDim.new(0, 10)
        clPadding.PaddingTop = UDim.new(0, 10)
        clPadding.PaddingBottom = UDim.new(0, 10)
        clPadding.Parent = configListFrame
        
        if #savedConfigs == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Size = UDim2.new(1, 0, 1, 0)
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.Text = "No hay configuraciones guardadas"
            emptyLabel.TextColor3 = Colors.SubText
            emptyLabel.TextSize = 13
            emptyLabel.Font = Enum.Font.Gotham
            emptyLabel.Parent = configListFrame
        end
        
        for _, configN in ipairs(savedConfigs) do
            local configItem = Instance.new("Frame")
            configItem.Size = UDim2.new(1, 0, 0, 35)
            configItem.BackgroundColor3 = Colors.Background
            configItem.BorderSizePixel = 0
            configItem.Parent = configListFrame
            
            local ciCorner = Instance.new("UICorner")
            ciCorner.CornerRadius = UDim.new(0, 4)
            ciCorner.Parent = configItem
            
            local configLabel = Instance.new("TextLabel")
            configLabel.Size = UDim2.new(1, -80, 1, 0)
            configLabel.Position = UDim2.new(0, 10, 0, 0)
            configLabel.BackgroundTransparency = 1
            configLabel.Text = configN
            configLabel.TextColor3 = Colors.Text
            configLabel.TextSize = 13
            configLabel.Font = Enum.Font.Gotham
            configLabel.TextXAlignment = Enum.TextXAlignment.Left
            configLabel.Parent = configItem
            
            local loadBtn = Instance.new("TextButton")
            loadBtn.Size = UDim2.new(0, 35, 0, 25)
            loadBtn.Position = UDim2.new(1, -70, 0.5, -12.5)
            loadBtn.BackgroundColor3 = Colors.Accent
            loadBtn.BorderSizePixel = 0
            loadBtn.Text = "↓"
            loadBtn.TextColor3 = Colors.Text
            loadBtn.TextSize = 16
            loadBtn.Font = Enum.Font.GothamBold
            loadBtn.Parent = configItem
            
            local lbCorner = Instance.new("UICorner")
            lbCorner.CornerRadius = UDim.new(0, 4)
            lbCorner.Parent = loadBtn
            
            local deleteBtn = Instance.new("TextButton")
            deleteBtn.Size = UDim2.new(0, 25, 0, 25)
            deleteBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
            deleteBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            deleteBtn.BorderSizePixel = 0
            deleteBtn.Text = "×"
            deleteBtn.TextColor3 = Colors.Text
            deleteBtn.TextSize = 18
            deleteBtn.Font = Enum.Font.GothamBold
            deleteBtn.Parent = configItem
            
            local dbCorner = Instance.new("UICorner")
            dbCorner.CornerRadius = UDim.new(0, 4)
            dbCorner.Parent = deleteBtn
            
            loadBtn.MouseButton1Click:Connect(function()
                self:Notification("Cargado", "Config: " .. configN, 2, "success")
            end)
            
            deleteBtn.MouseButton1Click:Connect(function()
                self.ConfigData[configN] = nil
                for i, c in ipairs(savedConfigs) do
                    if c == configN then
                        table.remove(savedConfigs, i)
                        break
                    end
                end
                configListFrame:Destroy()
                createConfigList()
                self:Notification("Eliminado", "Config eliminada: " .. configN, 2, "warning")
            end)
        end
    end
    
    createConfigList()
    
    tab:AddSection("Opciones Generales")
    tab:AddMiniToggle("Auto-Guardar", false, function(state)
        self:Notification("Auto-Guardar", state and "Activado" or "Desactivado", 2, "info")
    end)
end

-- Sistema de keybinds global
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        if IS.Keybinds[keyName] then
            for _, bind in ipairs(IS.Keybinds[keyName]) do
                if bind.callback then
                    bind.callback()
                end
                if bind.toggle then
                    local currentValue = bind.toggle.GetValue()
                    bind.toggle.SetValue(not currentValue)
                end
            end
        end
    end
end)

return IS
