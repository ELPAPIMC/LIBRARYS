-- Modern Roblox UI Library
-- Inspirado en el estilo de la imagen proporcionada

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}
Library.__index = Library

-- Configuración de colores y estilos
local Config = {
    Colors = {
        Primary = Color3.fromRGB(180, 70, 210),        -- Púrpura principal
        Secondary = Color3.fromRGB(220, 100, 255),     -- Púrpura claro
        Accent = Color3.fromRGB(50, 200, 150),         -- Verde/cyan
        Background = Color3.fromRGB(45, 45, 60),       -- Fondo oscuro
        Surface = Color3.fromRGB(60, 60, 80),          -- Superficie
        Text = Color3.fromRGB(255, 255, 255),          -- Texto blanco
        TextSecondary = Color3.fromRGB(200, 200, 200), -- Texto secundario
        Success = Color3.fromRGB(80, 220, 100),        -- Verde éxito
        Warning = Color3.fromRGB(255, 180, 50),        -- Amarillo advertencia
        Error = Color3.fromRGB(255, 80, 80)            -- Rojo error
    },
    
    Animation = {
        Speed = 0.3,
        Style = Enum.EasingStyle.Quad,
        Direction = Enum.EasingDirection.Out
    },
    
    Corner = {
        Size = UDim.new(0, 8)
    }
}

-- Funciones de utilidad
local function CreateTween(object, properties, duration)
    duration = duration or Config.Animation.Speed
    local tweenInfo = TweenInfo.new(
        duration,
        Config.Animation.Style,
        Config.Animation.Direction
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function AddCorner(parent, size)
    size = size or Config.Corner.Size
    local corner = Instance.new("UICorner")
    corner.CornerRadius = size
    corner.Parent = parent
    return corner
end

local function AddGradient(parent, colorSequence, rotation)
    rotation = rotation or 0
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence
    gradient.Rotation = rotation
    gradient.Parent = parent
    return gradient
end

local function AddStroke(parent, thickness, color)
    thickness = thickness or 1
    color = color or Config.Colors.Primary
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color
    stroke.Parent = parent
    return stroke
end

-- Constructor principal
function Library.new(title, parent)
    local self = setmetatable({}, Library)
    
    title = title or "UI Library"
    parent = parent or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- ScreenGui principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUILibrary"
    self.ScreenGui.Parent = parent
    self.ScreenGui.ResetOnSpawn = false
    
    -- Frame principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Config.Colors.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    AddCorner(self.MainFrame, UDim.new(0, 12))
    AddStroke(self.MainFrame, 2, Config.Colors.Primary)
    
    -- Gradiente para el frame principal
    AddGradient(self.MainFrame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.Colors.Background),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 75))
    }), 45)
    
    -- Título
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 50)
    self.TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title
    self.TitleLabel.TextColor3 = Config.Colors.Text
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextStrokeTransparency = 0.5
    self.TitleLabel.Font = Enum.Font.GothamSemibold
    self.TitleLabel.Parent = self.MainFrame
    
    -- Container para tabs
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 150, 1, -60)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 50)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainFrame
    
    -- Container para contenido
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -170, 1, -60)
    self.ContentContainer.Position = UDim2.new(0, 160, 0, 50)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.MainFrame
    
    -- Lista de layouts
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = self.TabContainer
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Hacer draggable
    self:MakeDraggable()
    
    return self
end

-- Función para hacer el UI draggable
function Library:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.MainFrame.InputBegan:Connect(function(input)
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
end

-- Crear nueva tab
function Library:CreateTab(name, icon)
    local Tab = {}
    
    -- Botón de tab
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = name .. "Tab"
    Tab.Button.Size = UDim2.new(1, 0, 0, 35)
    Tab.Button.BackgroundColor3 = Config.Colors.Surface
    Tab.Button.BorderSizePixel = 0
    Tab.Button.Text = (icon and icon .. " " or "") .. name
    Tab.Button.TextColor3 = Config.Colors.TextSecondary
    Tab.Button.TextSize = 14
    Tab.Button.Font = Enum.Font.Gotham
    Tab.Button.Parent = self.TabContainer
    
    AddCorner(Tab.Button, UDim.new(0, 6))
    
    -- Contenido de la tab
    Tab.Content = Instance.new("ScrollingFrame")
    Tab.Content.Name = name .. "Content"
    Tab.Content.Size = UDim2.new(1, 0, 1, 0)
    Tab.Content.Position = UDim2.new(0, 0, 0, 0)
    Tab.Content.BackgroundTransparency = 1
    Tab.Content.BorderSizePixel = 0
    Tab.Content.ScrollBarThickness = 4
    Tab.Content.ScrollBarImageColor3 = Config.Colors.Primary
    Tab.Content.Visible = false
    Tab.Content.Parent = self.ContentContainer
    
    -- Layout para contenido
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = Tab.Content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingAll = UDim.new(0, 10)
    contentPadding.Parent = Tab.Content
    
    -- Evento de click
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    -- Efectos hover
    Tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            CreateTween(Tab.Button, {BackgroundColor3 = Config.Colors.Primary}):Play()
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            CreateTween(Tab.Button, {BackgroundColor3 = Config.Colors.Surface}):Play()
        end
    end)
    
    Tab.Elements = {}
    self.Tabs[name] = Tab
    
    -- Seleccionar la primera tab automáticamente
    if not self.CurrentTab then
        self:SelectTab(name)
    end
    
    return Tab
end

-- Seleccionar tab
function Library:SelectTab(tabName)
    for name, tab in pairs(self.Tabs) do
        if name == tabName then
            tab.Content.Visible = true
            CreateTween(tab.Button, {
                BackgroundColor3 = Config.Colors.Primary,
                TextColor3 = Config.Colors.Text
            }):Play()
        else
            tab.Content.Visible = false
            CreateTween(tab.Button, {
                BackgroundColor3 = Config.Colors.Surface,
                TextColor3 = Config.Colors.TextSecondary
            }):Play()
        end
    end
    self.CurrentTab = tabName
end

-- Crear botón
function Library:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Config.Colors.Primary
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Config.Colors.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Parent = tab.Content
    
    AddCorner(button)
    AddGradient(button, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.Colors.Primary),
        ColorSequenceKeypoint.new(1, Config.Colors.Secondary)
    }), 45)
    
    -- Efectos
    button.MouseEnter:Connect(function()
        CreateTween(button, {Size = UDim2.new(1, 0, 0, 38)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {Size = UDim2.new(1, 0, 0, 35)}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        CreateTween(button, {Size = UDim2.new(0.98, 0, 0, 33)}):Play()
        wait(0.1)
        CreateTween(button, {Size = UDim2.new(1, 0, 0, 35)}):Play()
        if callback then callback() end
    end)
    
    return button
end

-- Crear toggle
function Library:CreateToggle(tab, text, default, callback)
    local container = Instance.new("Frame")
    container.Name = text .. "Toggle"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = Config.Colors.Surface
    container.BorderSizePixel = 0
    container.Parent = tab.Content
    
    AddCorner(container)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Colors.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    toggleButton.BackgroundColor3 = default and Config.Colors.Success or Config.Colors.Error
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = container
    
    AddCorner(toggleButton, UDim.new(0, 10))
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    indicator.BackgroundColor3 = Config.Colors.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleButton
    
    AddCorner(indicator, UDim.new(0, 8))
    
    local enabled = default or false
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        CreateTween(toggleButton, {
            BackgroundColor3 = enabled and Config.Colors.Success or Config.Colors.Error
        }):Play()
        
        CreateTween(indicator, {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if callback then callback(enabled) end
    end)
    
    return container
end

-- Crear slider
function Library:CreateSlider(tab, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Name = text .. "Slider"
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Config.Colors.Surface
    container.BorderSizePixel = 0
    container.Parent = tab.Content
    
    AddCorner(container)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. (default or min)
    label.TextColor3 = Config.Colors.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -15)
    sliderBg.BackgroundColor3 = Config.Colors.Background
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    AddCorner(sliderBg, UDim.new(0, 3))
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default or min) / max, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Config.Colors.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    AddCorner(sliderFill, UDim.new(0, 3))
    AddGradient(sliderFill, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.Colors.Primary),
        ColorSequenceKeypoint.new(1, Config.Colors.Accent)
    }))
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((default or min) / max, -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Config.Colors.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    AddCorner(sliderButton, UDim.new(0, 8))
    
    local value = default or min
    local dragging = false
    
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
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = mouse.X - sliderBg.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
            
            value = min + (max - min) * percentage
            value = math.floor(value + 0.5) -- Redondear
            
            label.Text = text .. ": " .. value
            
            CreateTween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
            CreateTween(sliderButton, {Position = UDim2.new(percentage, -8, 0.5, -8)}):Play()
            
            if callback then callback(value) end
        end
    end)
    
    return container
end

-- Crear dropdown
function Library:CreateDropdown(tab, text, options, callback)
    local container = Instance.new("Frame")
    container.Name = text .. "Dropdown"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = Config.Colors.Surface
    container.BorderSizePixel = 0
    container.Parent = tab.Content
    
    AddCorner(container)
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundTransparency = 1
    button.Text = text .. ": " .. (options[1] or "None")
    button.TextColor3 = Config.Colors.Text
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = container
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Config.Colors.Text
    arrow.TextSize = 12
    arrow.Font = Enum.Font.Gotham
    arrow.Parent = container
    
    local dropdown = Instance.new("Frame")
    dropdown.Name = "DropdownList"
    dropdown.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdown.Position = UDim2.new(0, 0, 1, 5)
    dropdown.BackgroundColor3 = Config.Colors.Background
    dropdown.BorderSizePixel = 0
    dropdown.Visible = false
    dropdown.ZIndex = 10
    dropdown.Parent = container
    
    AddCorner(dropdown)
    AddStroke(dropdown, 1, Config.Colors.Primary)
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropdownLayout.Parent = dropdown
    
    local isOpen = false
    local selectedOption = options[1] or "None"
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = Color3.new(0, 0, 0)
        optionButton.BackgroundTransparency = 1
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Config.Colors.Text
        optionButton.TextSize = 13
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = dropdown
        
        optionButton.MouseEnter:Connect(function()
            CreateTween(optionButton, {BackgroundTransparency = 0.8}):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            CreateTween(optionButton, {BackgroundTransparency = 1}):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            button.Text = text .. ": " .. option
            dropdown.Visible = false
            isOpen = false
            CreateTween(arrow, {Rotation = 0}):Play()
            if callback then callback(option) end
        end)
    end
    
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        dropdown.Visible = isOpen
        CreateTween(arrow, {Rotation = isOpen and 180 or 0}):Play()
    end)
    
    return container
end

return Library
