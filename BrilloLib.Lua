local BrilloHub = {}
BrilloHub.__index = BrilloHub

-- Configuración
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

function BrilloHub.new(titulo)
    local self = setmetatable({}, BrilloHub)
    
    -- Crear interfaz principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "BrilloHub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Intentar colocarla en CoreGui para scripts ejecutados
    pcall(function()
        self.ScreenGui.Parent = CoreGui
    end)
    
    -- Si falla, usar PlayerGui como alternativa
    if not self.ScreenGui.Parent then
        self.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Frame principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 650, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Barra de título
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Título
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -40, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.TextSize = 16
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Text = titulo or "BrilloHub"
    self.Title.Parent = self.TitleBar
    
    -- Botón de cerrar
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 24, 0, 24)
    self.CloseButton.Position = UDim2.new(1, -27, 0, 3)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    self.CloseButton.Text = ""
    self.CloseButton.Parent = self.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = self.CloseButton
    
    -- Categorías
    self.CategoryFrame = Instance.new("Frame")
    self.CategoryFrame.Name = "CategoryFrame"
    self.CategoryFrame.Size = UDim2.new(0, 120, 1, -30)
    self.CategoryFrame.Position = UDim2.new(0, 0, 0, 30)
    self.CategoryFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    self.CategoryFrame.BorderSizePixel = 0
    self.CategoryFrame.Parent = self.MainFrame
    
    local categoryCorner = Instance.new("UICorner")
    categoryCorner.CornerRadius = UDim.new(0, 8)
    categoryCorner.Parent = self.CategoryFrame
    
    -- Contenido
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -130, 1, -40)
    self.ContentFrame.Position = UDim2.new(0, 125, 0, 35)
    self.ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = self.ContentFrame
    
    -- Scroll para contenido
    self.ContentScroll = Instance.new("ScrollingFrame")
    self.ContentScroll.Name = "ContentScroll"
    self.ContentScroll.Size = UDim2.new(1, -10, 1, -10)
    self.ContentScroll.Position = UDim2.new(0, 5, 0, 5)
    self.ContentScroll.BackgroundTransparency = 1
    self.ContentScroll.ScrollBarThickness = 4
    self.ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    self.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentScroll.Parent = self.ContentFrame
    
    -- Layout para contenido
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = self.ContentScroll
    
    -- Padding
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 5)
    contentPadding.PaddingLeft = UDim.new(0, 5)
    contentPadding.PaddingRight = UDim.new(0, 5)
    contentPadding.PaddingBottom = UDim.new(0, 5)
    contentPadding.Parent = self.ContentScroll
    
    -- Variables para controlar categorías
    self.Categories = {}
    self.ActiveCategory = nil
    
    -- Arrastrar ventana
    local dragging = false
    local dragStart
    local startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
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
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Cerrar ventana
    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Variable para notificaciones
    self.NotificationFrame = Instance.new("Frame")
    self.NotificationFrame.Name = "NotificationFrame"
    self.NotificationFrame.Size = UDim2.new(0, 250, 1, 0)
    self.NotificationFrame.Position = UDim2.new(1, -260, 0, 10)
    self.NotificationFrame.BackgroundTransparency = 1
    self.NotificationFrame.Parent = self.ScreenGui
    
    local notifLayout = Instance.new("UIListLayout")
    notifLayout.Padding = UDim.new(0, 10)
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    notifLayout.Parent = self.NotificationFrame
    
    return self
end

-- Crear categoría
function BrilloHub:AddCategory(nombre, icono)
    local categoryButton = Instance.new("TextButton")
    categoryButton.Name = nombre.."Category"
    categoryButton.Size = UDim2.new(1, -10, 0, 30)
    categoryButton.Position = UDim2.new(0, 5, 0, 5 + (#self.Categories * 35))
    categoryButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    categoryButton.Text = nombre
    categoryButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    categoryButton.Font = Enum.Font.GothamSemibold
    categoryButton.TextSize = 14
    categoryButton.Parent = self.CategoryFrame
    
    local categoryCorner = Instance.new("UICorner")
    categoryCorner.CornerRadius = UDim.new(0, 6)
    categoryCorner.Parent = categoryButton
    
    -- Contenedor para los elementos de esta categoría
    local container = Instance.new("Frame")
    container.Name = nombre.."Container"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Visible = false
    container.Parent = self.ContentScroll
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 8)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Parent = container
    
    local category = {
        Button = categoryButton,
        Container = container,
        Name = nombre
    }
    
    table.insert(self.Categories, category)
    
    categoryButton.MouseButton1Click:Connect(function()
        if self.ActiveCategory then
            self.ActiveCategory.Container.Visible = false
            self.ActiveCategory.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            self.ActiveCategory.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        container.Visible = true
        categoryButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        categoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.ActiveCategory = category
    end)
    
    -- Activar la primera categoría automáticamente
    if #self.Categories == 1 then
        categoryButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        categoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        container.Visible = true
        self.ActiveCategory = category
    end
    
    return category
end

-- Añadir botón
function BrilloHub:AddButton(categoria, titulo, callback)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    local button = Instance.new("TextButton")
    button.Name = titulo.."Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    button.Text = titulo
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Parent = category.Container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Efectos visuales
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return button
end

-- Añadir toggle
function BrilloHub:AddToggle(categoria, titulo, predeterminado, callback)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    local toggled = predeterminado or false
    
    local toggle = Instance.new("Frame")
    toggle.Name = titulo.."Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 35)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    toggle.Parent = category.Container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titulo
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = toggle
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    toggleButton.Parent = toggle
    
    local toggleButtonCorner = Instance.new("UICorner")
    toggleButtonCorner.CornerRadius = UDim.new(1, 0)
    toggleButtonCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleCircle.Parent = toggleButton
    
    local toggleCircleCorner = Instance.new("UICorner")
    toggleCircleCorner.CornerRadius = UDim.new(1, 0)
    toggleCircleCorner.Parent = toggleCircle
    
    local toggleClickArea = Instance.new("TextButton")
    toggleClickArea.Name = "ClickArea"
    toggleClickArea.Size = UDim2.new(1, 0, 1, 0)
    toggleClickArea.BackgroundTransparency = 1
    toggleClickArea.Text = ""
    toggleClickArea.Parent = toggle
    
    -- Actualizar estado
    local function updateToggle()
        if toggled then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
        
        pcall(callback, toggled)
    end
    
    -- Configurar estado inicial
    if toggled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        toggleCircle.Position = UDim2.new(0, 22, 0.5, -8)
    end
    
    -- Eventos
    toggleClickArea.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
    end)
    
    toggle.MouseEnter:Connect(function()
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
    end)
    
    toggle.MouseLeave:Connect(function()
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    
    -- Función para obtener/establecer valor
    local toggleFunctions = {}
    
    function toggleFunctions:Set(value)
        toggled = value
        updateToggle()
    end
    
    function toggleFunctions:Get()
        return toggled
    end
    
    return toggleFunctions
end

-- Añadir slider
function BrilloHub:AddSlider(categoria, titulo, min, max, predeterminado, callback)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    min = min or 0
    max = max or 100
    predeterminado = predeterminado or min
    local value = math.clamp(predeterminado, min, max)
    
    local slider = Instance.new("Frame")
    slider.Name = titulo.."Slider"
    slider.Size = UDim2.new(1, 0, 0, 45)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    slider.Parent = category.Container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = slider
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titulo
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = slider
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = slider
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Size = UDim2.new(1, -20, 0, 10)
    sliderBar.Position = UDim2.new(0, 10, 0, 25)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    sliderBar.Parent = slider
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(1, 0)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    sliderFill.Parent = sliderBar
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local sliderClickArea = Instance.new("TextButton")
    sliderClickArea.Name = "ClickArea"
    sliderClickArea.Size = UDim2.new(1, 0, 1, 0)
    sliderClickArea.BackgroundTransparency = 1
    sliderClickArea.Text = ""
    sliderClickArea.Parent = slider
    
    -- Actualizar slider
    local function updateSlider(newValue, fireCallback)
        value = math.clamp(newValue, min, max)
        valueLabel.Text = tostring(math.floor(value * 10) / 10)
        sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        
        if fireCallback then
            pcall(callback, value)
        end
    end
    
    -- Eventos
    local dragging = false
    
    sliderClickArea.MouseButton1Down:Connect(function(x)
        dragging = true
        local relativeX = math.clamp((x - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local newValue = min + (relativeX * (max - min))
        updateSlider(newValue, true)
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relativeX = math.clamp((mousePos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local newValue = min + (relativeX * (max - min))
            updateSlider(newValue, true)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    slider.MouseEnter:Connect(function()
        TweenService:Create(slider, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
    end)
    
    slider.MouseLeave:Connect(function()
        TweenService:Create(slider, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    
    -- Función para obtener/establecer valor
    local sliderFunctions = {}
    
    function sliderFunctions:Set(newValue)
        updateSlider(newValue, true)
    end
    
    function sliderFunctions:Get()
        return value
    end
    
    return sliderFunctions
end

-- Mostrar notificación
function BrilloHub:Notify(titulo, mensaje, duracion, tipo)
    duracion = duracion or 3
    tipo = tipo or "info"
    
    local colors = {
        info = Color3.fromRGB(0, 120, 255),
        success = Color3.fromRGB(0, 200, 80),
        warning = Color3.fromRGB(255, 150, 0),
        error = Color3.fromRGB(255, 50, 50)
    }
    
    local color = colors[tipo] or colors.info
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(1, 0, 0, 80)
    notification.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    notification.BackgroundTransparency = 0.1
    notification.Position = UDim2.new(1, 20, 0, 0)
    notification.Parent = self.NotificationFrame
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Name = "Title"
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0, 10, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = titulo
    notifTitle.TextColor3 = color
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notification
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Name = "Message"
    notifMessage.Size = UDim2.new(1, -20, 0, 40)
    notifMessage.Position = UDim2.new(0, 10, 0, 30)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = mensaje
    notifMessage.TextColor3 = Color3.fromRGB(220, 220, 220)
    notifMessage.Font = Enum.Font.Gotham
    notifMessage.TextSize = 14
    notifMessage.TextWrapped = true
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    notifMessage.Parent = notification
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.Parent = notification
    
    -- Animación de entrada
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    -- Cierre automático
    local closing = false
    
    local function closeNotification()
        if closing then return end
        closing = true
        
        TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, 0, 0)}):Play()
        wait(0.5)
        notification:Destroy()
    end
    
    closeButton.MouseButton1Click:Connect(closeNotification)
    
    delay(duracion, closeNotification)
    
    return notification
end

-- Obtener categoría por nombre
function BrilloHub:GetCategory(nombre)
    for _, category in pairs(self.Categories) do
        if category.Name == nombre then
            return category
        end
    end
    return nil
end

-- Añadir Dropdown
function BrilloHub:AddDropdown(categoria, titulo, opciones, predeterminado, callback)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    opciones = opciones or {}
    local selected = predeterminado or opciones[1] or ""
    
    local dropdown = Instance.new("Frame")
    dropdown.Name = titulo.."Dropdown"
    dropdown.Size = UDim2.new(1, 0, 0, 35)
    dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    dropdown.ClipsDescendants = true
    dropdown.Parent = category.Container
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 35)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titulo
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = dropdown
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 0, 35)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(220, 220, 220)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 14
    arrow.Parent = dropdown
    
    local selectedValue = Instance.new("TextLabel")
    selectedValue.Name = "SelectedValue"
    selectedValue.Size = UDim2.new(0, 100, 0, 35)
    selectedValue.Position = UDim2.new(1, -130, 0, 0)
    selectedValue.BackgroundTransparency = 1
    selectedValue.Text = selected
    selectedValue.TextColor3 = Color3.fromRGB(0, 120, 255)
    selectedValue.Font = Enum.Font.GothamSemibold
    selectedValue.TextSize = 14
    selectedValue.TextXAlignment = Enum.TextXAlignment.Right
    selectedValue.Parent = dropdown
    
    -- Opciones
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.Size = UDim2.new(1, -20, 0, #opciones * 25)
    optionsFrame.Position = UDim2.new(0, 10, 0, 35)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 5
    optionsFrame.Parent = dropdown
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsFrame
    
    -- Crear opciones
    for i, option in ipairs(opciones) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option.."Option"
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.ZIndex = 6
        optionButton.Parent = optionsFrame
        
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            selected = option
            selectedValue.Text = selected
            
            TweenService:Create(dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
            optionsFrame.Visible = false
            arrow.Text = "▼"
            
            pcall(callback, selected)
        end)
    end
    
    -- Botón para abrir/cerrar dropdown
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 35)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = ""
    dropdownButton.Parent = dropdown
    
    local isOpen = false
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            TweenService:Create(dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35 + optionsFrame.Size.Y.Offset + 10)}):Play()
            optionsFrame.Visible = true
            arrow.Text = "▲"
        else
            TweenService:Create(dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
            optionsFrame.Visible = false
            arrow.Text = "▼"
        end
    end)
    
    dropdown.MouseEnter:Connect(function()
        TweenService:Create(dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
    end)
    
    dropdown.MouseLeave:Connect(function()
        TweenService:Create(dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    
    -- Función para obtener/establecer valor
    local dropdownFunctions = {}
    
    function dropdownFunctions:Set(newValue)
        if table.find(opciones, newValue) then
            selected = newValue
            selectedValue.Text = selected
            pcall(callback, selected)
        end
    end
    
    function dropdownFunctions:Get()
        return selected
    end
    
    function dropdownFunctions:Refresh(newOptions)
        optionsFrame:ClearAllChildren()
        opciones = newOptions
        
        optionsFrame.Size = UDim2.new(1, -20, 0, #opciones * 25)
        
        for i, option in ipairs(opciones) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = option.."Option"
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
            optionButton.BackgroundTransparency = 1
            optionButton.Text = option
            optionButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 14
            optionButton.ZIndex = 6
            optionButton.Parent = optionsFrame
            
            optionButton.MouseEnter:Connect(function()
                TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
            end)
            
            optionButton.MouseLeave:Connect(function()
                TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selected = option
                selectedValue.Text = selected
                
                TweenService:Create(dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                optionsFrame.Visible = false
                arrow.Text = "▼"
                isOpen = false
                
                pcall(callback, selected)
            end)
        end
        
        if not table.find(opciones, selected) and #opciones > 0 then
            selected = opciones[1]
            selectedValue.Text = selected
        elseif #opciones == 0 then
            selected = ""
            selectedValue.Text = ""
        end
    end
    
    return dropdownFunctions
end

-- Añadir etiqueta de texto
function BrilloHub:AddLabel(categoria, texto)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = texto
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = category.Container
    
    local labelFunctions = {}
    
    function labelFunctions:Set(newText)
        label.Text = newText
    end
    
    function labelFunctions:Get()
        return label.Text
    end
    
    return labelFunctions
end

-- Añadir campo de entrada de texto
function BrilloHub:AddTextbox(categoria, titulo, predeterminado, placeholder, callback)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    predeterminado = predeterminado or ""
    placeholder = placeholder or "Escriba aquí..."
    
    local textbox = Instance.new("Frame")
    textbox.Name = titulo.."Textbox"
    textbox.Size = UDim2.new(1, 0, 0, 35)
    textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    textbox.Parent = category.Container
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 6)
    textboxCorner.Parent = textbox
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.4, -10, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titulo
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = textbox
    
    local input = Instance.new("TextBox")
    input.Name = "Input"
    input.Size = UDim2.new(0.6, -20, 0, 25)
    input.Position = UDim2.new(0.4, 5, 0.5, -12.5)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    input.Text = predeterminado
    input.PlaceholderText = placeholder
    input.TextColor3 = Color3.fromRGB(220, 220, 220)
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.ClearTextOnFocus = false
    input.Parent = textbox
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    textbox.MouseEnter:Connect(function()
        TweenService:Create(textbox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
    end)
    
    textbox.MouseLeave:Connect(function()
        TweenService:Create(textbox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    
    input.Focused:Connect(function()
        TweenService:Create(input, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
    end)
    
    input.FocusLost:Connect(function(enterPressed)
        TweenService:Create(input, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
        
        if enterPressed then
            pcall(callback, input.Text)
        end
    end)
    
    -- Función para obtener/establecer valor
    local textboxFunctions = {}
    
    function textboxFunctions:Set(text)
        input.Text = text
        pcall(callback, text)
    end
    
    function textboxFunctions:Get()
        return input.Text
    end
    
    return textboxFunctions
end

-- Añadir divisor
function BrilloHub:AddDivider(categoria)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    divider.BorderSizePixel = 0
    divider.Parent = category.Container
    
    return divider
end

-- Añadir keybind
function BrilloHub:AddKeybind(categoria, titulo, teclaDefault, callback)
    local category = self:GetCategory(categoria)
    if not category then return end
    
    local keyName = teclaDefault and teclaDefault.Name or "None"
    
    local keybind = Instance.new("Frame")
    keybind.Name = titulo.."Keybind"
    keybind.Size = UDim2.new(1, 0, 0, 35)
    keybind.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    keybind.Parent = category.Container
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 6)
    keybindCorner.Parent = keybind
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titulo
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = keybind
    
    local keyDisplay = Instance.new("TextButton")
    keyDisplay.Name = "KeyDisplay"
    keyDisplay.Size = UDim2.new(0, 100, 0, 25)
    keyDisplay.Position = UDim2.new(1, -110, 0.5, -12.5)
    keyDisplay.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    keyDisplay.Text = keyName
    keyDisplay.TextColor3 = Color3.fromRGB(220, 220, 220)
    keyDisplay.Font = Enum.Font.Gotham
    keyDisplay.TextSize = 14
    keyDisplay.Parent = keybind
    
    local keyDisplayCorner = Instance.new("UICorner")
    keyDisplayCorner.CornerRadius = UDim.new(0, 4)
    keyDisplayCorner.Parent = keyDisplay
    
    -- Variables
    local currentKey = teclaDefault
    local isChanging = false
    local connection
    
    -- Función para actualizar visualización
    local function updateDisplay()
        keyDisplay.Text = currentKey and currentKey.Name or "None"
    end
    
    -- Detectar cambio de tecla
    keyDisplay.MouseButton1Click:Connect(function()
        if isChanging then return end
        
        isChanging = true
        keyDisplay.Text = "..."
        keyDisplay.TextColor3 = Color3.fromRGB(0, 150, 255)
        
        if connection then
            connection:Disconnect()
        end
        
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                updateDisplay()
                isChanging = false
                keyDisplay.TextColor3 = Color3.fromRGB(220, 220, 220)
                
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                
                pcall(callback, currentKey)
            end
        end)
    end)
    
    -- Detectar cuando se presione la tecla
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and currentKey and input.KeyCode == currentKey then
            pcall(callback, currentKey)
        end
    end)
    
    keybind.MouseEnter:Connect(function()
        TweenService:Create(keybind, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
    end)
    
    keybind.MouseLeave:Connect(function()
        TweenService:Create(keybind, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    
    -- Función para obtener/establecer valor
    local keybindFunctions = {}
    
    function keybindFunctions:Set(key)
        currentKey = key
        updateDisplay()
    end
    
    function keybindFunctions:Get()
        return currentKey
    end
    
    return keybindFunctions
end

return BrilloHub
