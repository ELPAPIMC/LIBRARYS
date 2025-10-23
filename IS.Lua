local IS = {}
IS.__index = IS

-- Configuración
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Estilos
local Colors = {
    Background = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(100, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(50, 50, 60),
    Toggle_On = Color3.fromRGB(100, 200, 100),
    Toggle_Off = Color3.fromRGB(60, 60, 70)
}

-- Función de animación suave
local function smoothTween(object, properties, duration)
    duration = duration or 0.3
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- Crear notificación
function IS:Notification(title, message, duration)
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 0)
    notification.Position = UDim2.new(1, -320, 1, -20)
    notification.BackgroundColor3 = Colors.Secondary
    notification.BorderSizePixel = 0
    notification.Parent = self.ScreenGui
    notification.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
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
    
    smoothTween(notification, {Size = UDim2.new(0, 300, 0, 85)}, 0.4)
    
    task.delay(duration, function()
        smoothTween(notification, {Size = UDim2.new(0, 300, 0, 0)}, 0.4)
        task.wait(0.4)
        notification:Destroy()
    end)
end

-- Crear ventana principal
function IS:CreateWindow(title)
    local window = {}
    window.Tabs = {}
    window.CurrentTab = nil
    window.Minimized = false
    window.ConfigData = {}
    
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
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
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
    titleLabel.Size = UDim2.new(1, -150, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "IS"
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Botones de control (Amarillo, Rojo, Azul)
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
            smoothTween(button, {BackgroundColor3 = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)}, 0.2)
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
            smoothTween(mainFrame, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
        else
            smoothTween(mainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
        end
    end)
    
    -- Botón rojo (Destruir)
    createControlButton(Color3.fromRGB(255, 60, 60), UDim2.new(1, -75, 0.5, -12.5), function()
        smoothTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Botón azul (Reiniciar)
    createControlButton(Color3.fromRGB(60, 150, 255), UDim2.new(1, -40, 0.5, -12.5), function()
        smoothTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.wait(0.2)
        smoothTween(mainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
    end)
    
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
    
    -- Imagen del tab
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
    
    -- Activar primer tab
    if #self.Tabs == 1 then
        tabButton.MouseButton1Click:Fire()
    end
    
    return tab
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
    
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        smoothTween(toggleButton, {BackgroundColor3 = toggled and Colors.Toggle_On or Colors.Toggle_Off}, 0.2)
        smoothTween(toggleCircle, {Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.2)
        
        callback(toggled)
    end)
    
    return {
        SetValue = function(value)
            toggled = value
            toggleButton.BackgroundColor3 = toggled and Colors.Toggle_On or Colors.Toggle_Off
            toggleCircle.Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
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
    
    tab:AddButton("Guardar Configuración", function()
        local configName = "Config_" .. os.date("%Y%m%d_%H%M%S")
        self.ConfigData[configName] = {
            name = configName,
            data = {},
            timestamp = os.time()
        }
        
        table.insert(savedConfigs, configName)
        self:Notification("Guardado", "Configuración guardada: " .. configName, 2)
    end)
    
    tab:AddButton("Cargar Configuración", function()
        if #savedConfigs > 0 then
            local lastConfig = savedConfigs[#savedConfigs]
            self:Notification("Cargado", "Configuración cargada: " .. lastConfig, 2)
        else
            self:Notification("Error", "No hay configuraciones guardadas", 2)
        end
    end)
    
    tab:AddToggle("Auto-Guardar", false, function(state)
        self:Notification("Auto-Guardar", state and "Activado" or "Desactivado", 2)
    end)
end

return IS
