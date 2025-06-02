-- UI Library para Roblox
-- Versión mejorada con soporte completo para toggles, color pickers, keybinds, sliders, dropdowns, textboxes, y animaciones
-- Optimizado para Roblox Studio y ejecutores de scripts, siguiendo las mejores prácticas de la plataforma

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Configuraciones por defecto
Library.Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Secondary = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(46, 204, 113),
    Warning = Color3.fromRGB(241, 196, 15),
    Error = Color3.fromRGB(231, 76, 60)
}

Library.Flags = {}
Library.Connections = {}

-- Funciones de utilidad
local function CreateTween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    return tween
end

local function RippleEffect(button, color)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = color or Library.Theme.Accent
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, Mouse.X - button.AbsolutePosition.X, 0, Mouse.Y - button.AbsolutePosition.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local tween = CreateTween(ripple, {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    }, 0.4, Enum.EasingStyle.Sine)
    
    tween:Play()
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Library.Theme.Secondary
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Función principal para crear la ventana
function Library:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "UI Library"
    config.Size = config.Size or UDim2.new(0, 500, 0, 400)
    config.Position = config.Position or UDim2.new(0.5, -250, 0.5, -200)
    config.MinSize = config.MinSize or Vector2.new(300, 200)
    
    -- ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_" .. tostring(math.random(1000, 9999)) -- Nombre único para evitar conflictos
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    ScreenGui.IgnoreGuiInset = true -- Ignorar barras del sistema
    
    -- Ventana principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = config.Size
    MainFrame.Position = config.Position
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    CreateCorner(MainFrame, 10)
    CreateStroke(MainFrame, Library.Theme.Secondary, 2)
    
    -- Sombra de la ventana
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxasset://textures/ui/DropShadow.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ZIndex = MainFrame.ZIndex - 1
    Shadow.Parent = MainFrame
    
    -- Barra de título
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Library.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    CreateCorner(TitleBar, 10)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Name
    TitleLabel.TextColor3 = Library.Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.Parent = TitleBar
    
    -- Botones de control
    local ControlFrame = Instance.new("Frame")
    ControlFrame.Name = "ControlFrame"
    ControlFrame.Size = UDim2.new(0, 90, 0, 30)
    ControlFrame.Position = UDim2.new(1, -95, 0, 5)
    ControlFrame.BackgroundTransparency = 1
    ControlFrame.Parent = TitleBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
    MinimizeButton.BackgroundColor3 = Library.Theme.Warning
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Library.Theme.Text
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = ControlFrame
    
    CreateCorner(MinimizeButton, 15)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(0, 60, 0, 0)
    CloseButton.BackgroundColor3 = Library.Theme.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Library.Theme.Text
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = ControlFrame
    
    CreateCorner(CloseButton, 15)
    
    -- Contenedor de pestañas
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Library.Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 2)
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.Parent = TabContainer
    
    -- Contenedor de contenido
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Resize handle
    local ResizeHandle = Instance.new("Frame")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 10, 0, 10)
    ResizeHandle.Position = UDim2.new(1, -10, 1, -10)
    ResizeHandle.BackgroundColor3 = Library.Theme.Accent
    ResizeHandle.BorderSizePixel = 0
    ResizeHandle.Parent = MainFrame
    
    CreateCorner(ResizeHandle, 3)
    
    -- Sistema de arrastrar ventana
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Sistema de redimensionamiento
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(config.MinSize.X, startSize.X.Offset + delta.X)
            local newHeight = math.max(config.MinSize.Y, startSize.Y.Offset + delta.Y)
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    -- Sistema de minimización
    local isMinimized = false
    local originalSize = config.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        RippleEffect(MinimizeButton)
        isMinimized = not isMinimized
        if isMinimized then
            originalSize = MainFrame.Size
            CreateTween(MainFrame, {Size = UDim2.new(0, 200, 0, 40)}, 0.3):Play()
            ContentContainer.Visible = false
            TabContainer.Visible = false
            ResizeHandle.Visible = false
            MinimizeButton.Text = "+"
        else
            CreateTween(MainFrame, {Size = originalSize}, 0.3):Play()
            ContentContainer.Visible = true
            TabContainer.Visible = true
            ResizeHandle.Visible = true
            MinimizeButton.Text = "−"
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        RippleEffect(CloseButton)
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Objeto Window
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        ScreenGui = ScreenGui
    }
    
    -- Función para crear pestañas
    function Window:CreateTab(name)
        local Tab = {
            Name = name,
            Elements = {},
            Content = nil,
            Button = nil,
            List = nil
        }
        
        -- Botón de pestaña
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Library.Theme.Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Library.Theme.TextDark
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextTruncate = Enum.TextTruncate.AtEnd
        TabButton.Parent = TabContainer
        
        CreateCorner(TabButton, 6)
        
        -- Contenido de la pestaña
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Library.Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 5)
        ContentList.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        -- Auto-resize del canvas
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            RippleEffect(TabButton)
            
            -- Ocultar todas las pestañas
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Library.Theme.Background
                tab.Button.TextColor3 = Library.Theme.TextDark
            end
            
            -- Mostrar pestaña actual
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Library.Theme.Accent
            TabButton.TextColor3 = Library.Theme.Text
            Window.CurrentTab = Tab
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.List = ContentList
        
        -- Activar primera pestaña por defecto
        if #Window.Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Library.Theme.Accent
            TabButton.TextColor3 = Library.Theme.Text
            Window.CurrentTab = Tab
        end
        
        Window.Tabs[#Window.Tabs + 1] = Tab
        
        -- Funciones de elementos de la pestaña
        
        -- Toggle/Switch
        function Tab:CreateToggle(config)
            config = config or {}
            config.Name = config.Name or "Toggle"
            config.Default = config.Default or false
            config.Callback = config.Callback or function() end
            config.Flag = config.Flag
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle_" .. config.Name
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Library.Theme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            CreateCorner(ToggleFrame, 6)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = config.Name
            ToggleLabel.TextColor3 = Library.Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.TextTruncate = Enum.TextTruncate.AtEnd
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = config.Default and Library.Theme.Success or Library.Theme.Background
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            CreateCorner(ToggleButton, 10)
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = config.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Library.Theme.Text
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            CreateCorner(ToggleCircle, 8)
            
            local toggled = config.Default
            
            if config.Flag then
                Library.Flags[config.Flag] = toggled
            end
            
            local function UpdateToggle()
                local tween1 = CreateTween(ToggleButton, {
                    BackgroundColor3 = toggled and Library.Theme.Success or Library.Theme.Background
                }, 0.2)
                local tween2 = CreateTween(ToggleCircle, {
                    Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }, 0.2)
                
                tween1:Play()
                tween2:Play()
                
                config.Callback(toggled)
                
                if config.Flag then
                    Library.Flags[config.Flag] = toggled
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
                RippleEffect(ToggleButton)
            end)
            
            return {
                Set = function(value)
                    toggled = value
                    UpdateToggle()
                end,
                Get = function()
                    return toggled
                end
            }
        end
        
        -- Slider
        function Tab:CreateSlider(config)
            config = config or {}
            config.Name = config.Name or "Slider"
            config.Min = config.Min or 0
            config.Max = config.Max or 100
            config.Default = math.clamp(config.Default or config.Min, config.Min, config.Max)
            config.Callback = config.Callback or function() end
            config.Flag = config.Flag
            config.Decimals = config.Decimals or 0
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider_" .. config.Name
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            SliderFrame.BackgroundColor3 = Library.Theme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            CreateCorner(SliderFrame, 6)
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -60, 0, 25)
            SliderLabel.Position = UDim2.new(0, 10, 0, 0)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = config.Name
            SliderLabel.TextColor3 = Library.Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.TextTruncate = Enum.TextTruncate.AtEnd
            SliderLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 50, 0, 25)
            ValueLabel.Position = UDim2.new(1, -60, 0, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(config.Default)
            ValueLabel.TextColor3 = Library.Theme.Accent
            ValueLabel.TextSize = 14
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, -20, 0, 4)
            SliderTrack.Position = UDim2.new(0, 10, 1, -15)
            SliderTrack.BackgroundColor3 = Library.Theme.Background
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = SliderFrame
            
            CreateCorner(SliderTrack, 2)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Library.Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack
            
            CreateCorner(SliderFill, 2)
            
            local SliderHandle = Instance.new("Frame")
            SliderHandle.Size = UDim2.new(0, 12, 0, 12)
            SliderHandle.Position = UDim2.new(0, -6, 0.5, -6)
            SliderHandle.BackgroundColor3 = Library.Theme.Text
            SliderHandle.BorderSizePixel = 0
            SliderHandle.Parent = SliderFill
            
            CreateCorner(SliderHandle, 6)
            
            local value = config.Default
            local dragging = false
            
            if config.Flag then
                Library.Flags[config.Flag] = value
            end
            
            local function UpdateSlider(newValue)
                newValue = math.clamp(newValue, config.Min, config.Max)
                if config.Decimals == 0 then
                    newValue = math.floor(newValue)
                else
                    newValue = tonumber(string.format("%." .. config.Decimals .. "f", newValue))
                end
                
                value = newValue
                local percentage = (value - config.Min) / (config.Max - config.Min)
                
                CreateTween(SliderFill, {
                    Size = UDim2.new(percentage, 0, 1, 0)
                }, 0.1):Play()
                
                ValueLabel.Text = tostring(value)
                config.Callback(value)
                
                if config.Flag then
                    Library.Flags[config.Flag] = value
                end
            end
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local newValue = config.Min + (config.Max - config.Min) * percentage
                    UpdateSlider(newValue)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local newValue = config.Min + (config.Max - config.Min) * percentage
                    UpdateSlider(newValue)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UpdateSlider(config.Default)
            
            return {
                Set = function(newValue)
                    UpdateSlider(newValue)
                end,
                Get = function()
                    return value
                end
            }
        end
        
        -- Button
        function Tab:CreateButton(config)
            config = config or {}
            config.Name = config.Name or "Button"
            config.Callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = "Button_" .. config.Name
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            ButtonFrame.BackgroundColor3 = Library.Theme.Accent
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = config.Name
            ButtonFrame.TextColor3 = Library.Theme.Text
            ButtonFrame.TextSize = 14
            ButtonFrame.Font = Enum.Font.GothamBold
            ButtonFrame.TextTruncate = Enum.TextTruncate.AtEnd
            ButtonFrame.Parent = TabContent
            
            CreateCorner(ButtonFrame, 6)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                RippleEffect(ButtonFrame)
                config.Callback()
            end)
            
            ButtonFrame.MouseEnter:Connect(function()
                CreateTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(
                    math.min(255, Library.Theme.Accent.R * 255 + 20),
                    math.min(255, Library.Theme.Accent.G * 255 + 20),
                    math.min(255, Library.Theme.Accent.B * 255 + 20)
                )}, 0.2):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                CreateTween(ButtonFrame, {BackgroundColor3 = Library.Theme.Accent}, 0.2):Play()
            end)
            
            return {
                Click = function()
                    config.Callback()
                end
            }
        end
        
        -- Keybind
        function Tab:CreateKeybind(config)
            config = config or {}
            config.Name = config.Name or "Keybind"
            config.Default = config.Default or Enum.KeyCode.F
            config.Callback = config.Callback or function() end
            config.Flag = config.Flag
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "Keybind_" .. config.Name
            KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
            KeybindFrame.BackgroundColor3 = Library.Theme.Secondary
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent
            
            CreateCorner(KeybindFrame, 6)
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = config.Name
            KeybindLabel.TextColor3 = Library.Theme.Text
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.TextTruncate = Enum.TextTruncate.AtEnd
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 60, 0, 25)
            KeybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
            KeybindButton.BackgroundColor3 = Library.Theme.Background
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = config.Default.Name
            KeybindButton.TextColor3 = Library.Theme.Text
            KeybindButton.TextSize = 12
            KeybindButton.Font = Enum.Font.Gotham
            KeybindButton.Parent = KeybindFrame
            
            CreateCorner(KeybindButton, 4)
            CreateStroke(KeybindButton, Library.Theme.Accent, 1)
            
            local currentKey = config.Default
            local listening = false
            
            if config.Flag then
                Library.Flags[config.Flag] = currentKey
            end
            
            KeybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                KeybindButton.Text = "..."
                KeybindButton.BackgroundColor3 = Library.Theme.Accent
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeybindButton.Text = currentKey.Name
                        KeybindButton.BackgroundColor3 = Library.Theme.Background
                        listening = false
                        connection:Disconnect()
                        
                        if config.Flag then
                            Library.Flags[config.Flag] = currentKey
                        end
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        KeybindButton.Text = currentKey.Name
                        KeybindButton.BackgroundColor3 = Library.Theme.Background
                        listening = false
                        connection:Disconnect()
                    end
                end)
                
                table.insert(Library.Connections, connection)
            end)
            
            local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed or listening then return end
                if input.KeyCode == currentKey then
                    config.Callback()
                end
            end)
            
            table.insert(Library.Connections, inputConnection)
            
            return {
                Set = function(newKey)
                    currentKey = newKey
                    KeybindButton.Text = newKey.Name
                    if config.Flag then
                        Library.Flags[config.Flag] = newKey
                    end
                end,
                Get = function()
                    return currentKey
                end
            }
        end
        
        -- Color Picker
        function Tab:CreateColorPicker(config)
            config = config or {}
            config.Name = config.Name or "Color Picker"
            config.Default = config.Default or Color3.fromRGB(255, 255, 255)
            config.Callback = config.Callback or function() end
            config.Flag = config.Flag
            
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Name = "ColorPicker_" .. config.Name
            ColorFrame.Size = UDim2.new(1, 0, 0, 40)
            ColorFrame.BackgroundColor3 = Library.Theme.Secondary
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Parent = TabContent
            
            CreateCorner(ColorFrame, 6)
            
            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -50, 1, 0)
            ColorLabel.Position = UDim2.new(0, 10, 0, 0)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = config.Name
            ColorLabel.TextColor3 = Library.Theme.Text
            ColorLabel.TextSize = 14
            ColorLabel.Font = Enum.Font.Gotham
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.TextTruncate = Enum.TextTruncate.AtEnd
            ColorLabel.Parent = ColorFrame
            
            local ColorPreview = Instance.new("Frame")
            ColorPreview.Size = UDim2.new(0, 30, 0, 20)
            ColorPreview.Position = UDim2.new(1, -40, 0.5, -10)
            ColorPreview.BackgroundColor3 = config.Default
            ColorPreview.BorderSizePixel = 0
            ColorPreview.Parent = ColorFrame
            
            CreateCorner(ColorPreview, 4)
            CreateStroke(ColorPreview, Library.Theme.Text, 1)
            
            local ColorButton = Instance.new("TextButton")
            ColorButton.Size = UDim2.new(1, 0, 1, 0)
            ColorButton.BackgroundTransparency = 1
            ColorButton.Text = ""
            ColorButton.Parent = ColorPreview
            
            local currentColor = config.Default
            local colorPicker = nil
            
            if config.Flag then
                Library.Flags[config.Flag] = currentColor
            end
            
            ColorButton.MouseButton1Click:Connect(function()
                if colorPicker then
                    colorPicker:Destroy()
                    colorPicker = nil
                    return
                end
                
                -- Crear ventana del color picker
                colorPicker = Instance.new("Frame")
                colorPicker.Name = "ColorPickerWindow"
                colorPicker.Size = UDim2.new(0, 250, 0, 200)
                colorPicker.Position = UDim2.new(0, ColorFrame.AbsolutePosition.X, 0, ColorFrame.AbsolutePosition.Y + 45)
                colorPicker.BackgroundColor3 = Library.Theme.Background
                colorPicker.BorderSizePixel = 0
                colorPicker.ZIndex = 1000
                colorPicker.Parent = ScreenGui
                
                CreateCorner(colorPicker, 8)
                CreateStroke(colorPicker, Library.Theme.Secondary, 2)
                
                -- Selector de color principal
                local ColorCanvas = Instance.new("ImageLabel")
                ColorCanvas.Size = UDim2.new(1, -60, 1, -60)
                ColorCanvas.Position = UDim2.new(0, 10, 0, 10)
                ColorCanvas.BackgroundTransparency = 1
                ColorCanvas.Image = "rbxasset://textures/ui/ColorPicker.png"
                ColorCanvas.Parent = colorPicker
                
                CreateCorner(ColorCanvas, 4)
                
                -- Cursor del selector
                local ColorCursor = Instance.new("Frame")
                ColorCursor.Size = UDim2.new(0, 8, 0, 8)
                ColorCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ColorCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ColorCursor.BorderSizePixel = 1
                ColorCursor.Parent = ColorCanvas
                
                CreateCorner(ColorCursor, 4)
                
                -- Selector de matiz
                local HueSelector = Instance.new("Frame")
                HueSelector.Size = UDim2.new(0, 20, 1, -60)
                HueSelector.Position = UDim2.new(1, -30, 0, 10)
                HueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueSelector.BorderSizePixel = 0
                HueSelector.Parent = colorPicker
                
                CreateCorner(HueSelector, 4)
                
                local HueGradient = Instance.new("UIGradient")
                HueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                HueGradient.Rotation = 90
                HueGradient.Parent = HueSelector
                
                local HueCursor = Instance.new("Frame")
                HueCursor.Size = UDim2.new(1, 0, 0, 2)
                HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueCursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
                HueCursor.BorderSizePixel = 1
                HueCursor.Parent = HueSelector
                
                -- Botones de control
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Size = UDim2.new(1, -20, 0, 30)
                ButtonFrame.Position = UDim2.new(0, 10, 1, -40)
                ButtonFrame.BackgroundTransparency = 1
                ButtonFrame.Parent = colorPicker
                
                local AcceptButton = Instance.new("TextButton")
                AcceptButton.Size = UDim2.new(0.48, 0, 1, 0)
                AcceptButton.BackgroundColor3 = Library.Theme.Success
                AcceptButton.BorderSizePixel = 0
                AcceptButton.Text = "Accept"
                AcceptButton.TextColor3 = Library.Theme.Text
                AcceptButton.TextSize = 12
                AcceptButton.Font = Enum.Font.GothamBold
                AcceptButton.Parent = ButtonFrame
                
                CreateCorner(AcceptButton, 4)
                
                local CancelButton = Instance.new("TextButton")
                CancelButton.Size = UDim2.new(0.48, 0, 1, 0)
                CancelButton.Position = UDim2.new(0.52, 0, 0, 0)
                CancelButton.BackgroundColor3 = Library.Theme.Error
                CancelButton.BorderSizePixel = 0
                CancelButton.Text = "Cancel"
                CancelButton.TextColor3 = Library.Theme.Text
                CancelButton.TextSize = 12
                CancelButton.Font = Enum.Font.GothamBold
                CancelButton.Parent = ButtonFrame
                
                CreateCorner(CancelButton, 4)
                
                -- Variables para el color picker
                local hue, saturation, brightness = Color3.toHSV(currentColor)
                local tempColor = currentColor
                
                -- Función para actualizar el color
                local function UpdateColor()
                    tempColor = Color3.fromHSV(hue, saturation, brightness)
                    ColorPreview.BackgroundColor3 = tempColor
                    ColorCanvas.ImageColor3 = Color3.fromHSV(hue, 1, 1)
                    ColorCursor.Position = UDim2.new(saturation, 0, 1 - brightness, 0)
                    HueCursor.Position = UDim2.new(0, 0, hue, 0)
                end
                
                -- Manejo del selector de matiz
                local hueDragging = false
                HueSelector.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = true
                        local relativeY = math.clamp((input.Position.Y - HueSelector.AbsolutePosition.Y) / HueSelector.AbsoluteSize.Y, 0, 1)
                        hue = relativeY
                        UpdateColor()
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local relativeY = math.clamp((input.Position.Y - HueSelector.AbsolutePosition.Y) / HueSelector.AbsoluteSize.Y, 0, 1)
                        hue = relativeY
                        UpdateColor()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = false
                    end
                end)
                
                -- Manejo del canvas de color
                local canvasDragging = false
                ColorCanvas.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        canvasDragging = true
                        local relativeX = math.clamp((input.Position.X - ColorCanvas.AbsolutePosition.X) / ColorCanvas.AbsoluteSize.X, 0, 1)
                        local relativeY = math.clamp((input.Position.Y - ColorCanvas.AbsolutePosition.Y) / ColorCanvas.AbsoluteSize.Y, 0, 1)
                        saturation = relativeX
                        brightness = 1 - relativeY
                        UpdateColor()
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if canvasDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local relativeX = math.clamp((input.Position.X - ColorCanvas.AbsolutePosition.X) / ColorCanvas.AbsoluteSize.X, 0, 1)
                        local relativeY = math.clamp((input.Position.Y - ColorCanvas.AbsolutePosition.Y) / ColorCanvas.AbsoluteSize.Y, 0, 1)
                        saturation = relativeX
                        brightness = 1 - relativeY
                        UpdateColor()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        canvasDragging = false
                    end
                end)
                
                -- Botones de control
                AcceptButton.MouseButton1Click:Connect(function()
                    RippleEffect(AcceptButton)
                    currentColor = tempColor
                    ColorPreview.BackgroundColor3 = currentColor
                    config.Callback(currentColor)
                    if config.Flag then
                        Library.Flags[config.Flag] = currentColor
                    end
                    colorPicker:Destroy()
                    colorPicker = nil
                end)
                
                CancelButton.MouseButton1Click:Connect(function()
                    RippleEffect(CancelButton)
                    ColorPreview.BackgroundColor3 = currentColor
                    colorPicker:Destroy()
                    colorPicker = nil
                end)
                
                -- Inicializar con color actual
                UpdateColor()
                
                return {
                    Set = function(color)
                        currentColor = color
                        ColorPreview.BackgroundColor3 = color
                        hue, saturation, brightness = Color3.toHSV(color)
                        UpdateColor()
                        if config.Flag then
                            Library.Flags[config.Flag] = color
                        end
                    end,
                    Get = function()
                        return currentColor
                    end
                }
            end)
            
            return {
                Set = function(color)
                    currentColor = color
                    ColorPreview.BackgroundColor3 = color
                    if config.Flag then
                        Library.Flags[config.Flag] = color
                    end
                end,
                Get = function()
                    return currentColor
                end
            }
        end
        
        -- Dropdown
        function Tab:CreateDropdown(config)
            config = config or {}
            config.Name = config.Name or "Dropdown"
            config.Options = config.Options or {"Option 1", "Option 2"}
            config.Default = config.Default or config.Options[1]
            config.Callback = config.Callback or function() end
            config.Flag = config.Flag
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown_" .. config.Name
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Library.Theme.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabContent
            
            CreateCorner(DropdownFrame, 6)
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -120, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = config.Name
            DropdownLabel.TextColor3 = Library.Theme.Text
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.TextTruncate = Enum.TextTruncate.AtEnd
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 100, 0, 25)
            DropdownButton.Position = UDim2.new(1, -110, 0.5, -12.5)
            DropdownButton.BackgroundColor3 = Library.Theme.Background
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = config.Default .. " ▼"
            DropdownButton.TextColor3 = Library.Theme.Text
            DropdownButton.TextSize = 12
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
            DropdownButton.Parent = DropdownFrame
            
            CreateCorner(DropdownButton, 4)
            CreateStroke(DropdownButton, Library.Theme.Accent, 1)
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Size = UDim2.new(0, 100, 0, 0)
            DropdownList.Position = UDim2.new(1, -110, 1, 5)
            DropdownList.BackgroundColor3 = Library.Theme.Background
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false
            DropdownList.ZIndex = 1000
            DropdownList.ClipsDescendants = true
            DropdownList.Parent = DropdownFrame
            
            CreateCorner(DropdownList, 4)
            CreateStroke(DropdownList, Library.Theme.Secondary, 1)
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = DropdownList
            
            local ListPadding = Instance.new("UIPadding")
            ListPadding.PaddingTop = UDim.new(0, 2)
            ListPadding.PaddingBottom = UDim.new(0, 2)
            ListPadding.Parent = DropdownList
            
            local currentValue = config.Default
            local isOpen = false
            
            if config.Flag then
                Library.Flags[config.Flag] = currentValue
            end
            
            -- Crear opciones
            local function UpdateOptions()
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for i, option in ipairs(config.Options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.BackgroundColor3 = Library.Theme.Background
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Library.Theme.Text
                    OptionButton.TextSize = 12
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.TextTruncate = Enum.TextTruncate.AtEnd
                    OptionButton.Parent = DropdownList
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        RippleEffect(OptionButton)
                        currentValue = option
                        DropdownButton.Text = option .. " ▼"
                        DropdownList.Visible = false
                        isOpen = false
                        config.Callback(option)
                        
                        if config.Flag then
                            Library.Flags[config.Flag] = option
                        end
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        CreateTween(OptionButton, {BackgroundColor3 = Library.Theme.Accent}, 0.2):Play()
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        CreateTween(OptionButton, {BackgroundColor3 = Library.Theme.Background}, 0.2):Play()
                    end)
                end
                
                DropdownList.Size = UDim2.new(0, 100, 0, math.min(#config.Options * 25 + 4, 100))
            end
            
            UpdateOptions()
            
            DropdownButton.MouseButton1Click:Connect(function()
                RippleEffect(DropdownButton)
                isOpen = not isOpen
                DropdownList.Visible = isOpen
                DropdownButton.Text = currentValue .. (isOpen and " ▲" or " ▼")
            end)
            
            -- Cerrar dropdown al hacer clic fuera
            local clickConnection
            clickConnection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                    local mousePos = Vector2.new(input.Position.X, input.Position.Y)
                    local listPos = DropdownList.AbsolutePosition
                    local listSize = DropdownList.AbsoluteSize
                    if not (mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
                            mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y) then
                        DropdownList.Visible = false
                        isOpen = false
                        DropdownButton.Text = currentValue .. " ▼"
                    end
                end
            end)
            
            table.insert(Library.Connections, clickConnection)
            
            return {
                Set = function(value)
                    if table.find(config.Options, value) then
                        currentValue = value
                        DropdownButton.Text = value .. " ▼"
                        if config.Flag then
                            Library.Flags[config.Flag] = value
                        end
                    end
                end,
                Get = function()
                    return currentValue
                end,
                UpdateOptions = function(newOptions)
                    config.Options = newOptions
                    UpdateOptions()
                    if not table.find(config.Options, currentValue) then
                        currentValue = config.Options[1] or ""
                        DropdownButton.Text = currentValue .. " ▼"
                        if config.Flag then
                            Library.Flags[config.Flag] = currentValue
                        end
                    end
                end
            }
        end
        
        -- Textbox
        function Tab:CreateTextbox(config)
            config = config or {}
            config.Name = config.Name or "Textbox"
            config.Default = config.Default or ""
            config.Placeholder = config.Placeholder or "Enter text..."
            config.Callback = config.Callback or function() end
            config.Flag = config.Flag
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "Textbox_" .. config.Name
            TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
            TextboxFrame.BackgroundColor3 = Library.Theme.Secondary
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            CreateCorner(TextboxFrame, 6)
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 25)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = config.Name
            TextboxLabel.TextColor3 = Library.Theme.Text
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.TextTruncate = Enum.TextTruncate.AtEnd
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -20, 0, 25)
            Textbox.Position = UDim2.new(0, 10, 0, 30)
            Textbox.BackgroundColor3 = Library.Theme.Background
            Textbox.BorderSizePixel = 0
            Textbox.Text = config.Default
            Textbox.PlaceholderText = config.Placeholder
            Textbox.TextColor3 = Library.Theme.Text
            Textbox.PlaceholderColor3 = Library.Theme.TextDark
            Textbox.TextSize = 12
            Textbox.Font = Enum.Font.Gotham
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame
            
            CreateCorner(Textbox, 4)
            CreateStroke(Textbox, Library.Theme.Accent, 1)
            
            if config.Flag then
                Library.Flags[config.Flag] = config.Default
            end
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    config.Callback(Textbox.Text)
                    if config.Flag then
                        Library.Flags[config.Flag] = Textbox.Text
                    end
                end
            end)
            
            Textbox.Focused:Connect(function()
                CreateTween(Textbox, {BackgroundColor3 = Color3.fromRGB(
                    math.min(255, Library.Theme.Background.R * 255 + 20),
                    math.min(255, Library.Theme.Background.G * 255 + 20),
                    math.min(255, Library.Theme.Background.B * 255 + 20)
                )}, 0.2):Play()
            end)
            
            Textbox.FocusLost:Connect(function()
                CreateTween(Textbox, {BackgroundColor3 = Library.Theme.Background}, 0.2):Play()
            end)
            
            return {
                Set = function(text)
                    Textbox.Text = tostring(text)
                    if config.Flag then
                        Library.Flags[config.Flag] = Textbox.Text
                    end
                end,
                Get = function()
                    return Textbox.Text
                end
            }
        end
        
        -- Label
        function Tab:CreateLabel(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label_" .. tostring(text):sub(1, 10)
            LabelFrame.Size = UDim2.new(1, 0, 0, 30)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text or "Label"
            Label.TextColor3 = Library.Theme.TextDark
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.TextTruncate = Enum.TextTruncate.AtEnd
            Label.Parent = LabelFrame
            
            return {
                Set = function(newText)
                    Label.Text = tostring(newText)
                end,
                Get = function()
                    return Label.Text
                end
            }
        end
        
        -- Separator
        function Tab:CreateSeparator()
            local SeparatorFrame = Instance.new("Frame")
            SeparatorFrame.Name = "Separator"
            SeparatorFrame.Size = UDim2.new(1, 0, 0, 20)
            SeparatorFrame.BackgroundTransparency = 1
            SeparatorFrame.Parent = TabContent
            
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, -20, 0, 1)
            Line.Position = UDim2.new(0, 10, 0.5, 0)
            Line.BackgroundColor3 = Library.Theme.Secondary
            Line.BorderSizePixel = 0
            Line.Parent = SeparatorFrame
        end
        
        return Tab
    end
    
    return Window
end

-- Funciones adicionales de la librería

-- Función para obtener flags
function Library:GetFlag(flag)
    return Library.Flags[flag]
end

-- Función para establecer flags
function Library:SetFlag(flag, value)
    Library.Flags[flag] = value
end

-- Función para actualizar el tema
function Library:UpdateTheme(newTheme)
    for key, color in pairs(newTheme) do
        Library.Theme[key] = color
    end
end

-- Función para crear notificaciones
function Library:CreateNotification(config)
    config = config or {}
    config.Title = config.Title or "Notification"
    config.Text = config.Text or "This is a notification"
    config.Duration = config.Duration or 3
    config.Type = config.Type or "Info"
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "Notification_" .. tostring(math.random(1000, 9999))
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationGui.Parent = CoreGui
    
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
    NotificationFrame.Position = UDim2.new(1, -320, 1, -100)
    NotificationFrame.BackgroundColor3 = Library.Theme.Background
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = NotificationGui
    
    CreateCorner(NotificationFrame, 8)
    CreateStroke(NotificationFrame, Library.Theme.Secondary, 2)
    
    local typeColors = {
        Info = Library.Theme.Accent,
        Success = Library.Theme.Success,
        Warning = Library.Theme.Warning,
        Error = Library.Theme.Error
    }
    
    local ColorStrip = Instance.new("Frame")
    ColorStrip.Size = UDim2.new(0, 4, 1, 0)
    ColorStrip.BackgroundColor3 = typeColors[config.Type] or Library.Theme.Accent
    ColorStrip.BorderSizePixel = 0
    ColorStrip.Parent = NotificationFrame
    
    CreateCorner(ColorStrip, 2)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title
    TitleLabel.TextColor3 = Library.Theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.Parent = NotificationFrame
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -50, 0, 35)
    TextLabel.Position = UDim2.new(0, 15, 0, 35)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = config.Text
    TextLabel.TextColor3 = Library.Theme.TextDark
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel.Parent = NotificationFrame
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Library.Theme.TextDark
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = NotificationFrame
    
    -- Animación de entrada
    NotificationFrame.Position = UDim2.new(1, 0, 1, -100)
    CreateTween(NotificationFrame, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, Enum.EasingStyle.Back):Play()
    
    -- Auto-close
    local closeConnection
    closeConnection = task.spawn(function()
        task.wait(config.Duration)
        CreateTween(NotificationFrame, {Position = UDim2.new(1, 0, 1, -100)}, 0.3):Play()
        task.wait(0.3)
        NotificationGui:Destroy()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        RippleEffect(CloseButton)
        task.cancel(closeConnection)
        CreateTween(NotificationFrame, {Position = UDim2.new(1, 0, 1, -100)}, 0.3):Play()
        task.wait(0.3)
        NotificationGui:Destroy()
    end)
end

-- Función para destruir la librería
function Library:Destroy()
    for _, connection in pairs(Library.Connections) do
        connection:Disconnect()
    end
    Library.Connections = {}
    Library.Flags = {}
    
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name:match("^UILibrary_") or gui.Name:match("^Notification_") then
            gui:Destroy()
        end
    end
end

-- Función para alternar visibilidad
function Library:ToggleVisibility(window)
    if window and window.ScreenGui then
        window.ScreenGui.Enabled = not window.ScreenGui.Enabled
    end
end

return Library
