local Library = {}
Library.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 35),
        Container = Color3.fromRGB(40, 40, 45),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 170, 255),
        Highlight = Color3.fromRGB(0, 120, 215),
        Inactive = Color3.fromRGB(100, 100, 100),
    }
}

function Library:Create(title, theme)
    theme = theme or Library.Themes.Dark
    
    -- GUI Principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HorionUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Marco principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Título
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = theme.Accent
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(1, -10, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = title or "Horion"
    TitleText.TextColor3 = theme.Text
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Botón para cerrar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 0)
    CloseButton.Size = UDim2.new(0, 25, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = theme.Text
    CloseButton.TextSize = 16
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Contenedor de categorías
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.BackgroundColor3 = theme.Container
    TabsContainer.BorderSizePixel = 0
    TabsContainer.Position = UDim2.new(0, 0, 0, 30)
    TabsContainer.Size = UDim2.new(0, 120, 1, -30)
    TabsContainer.Parent = MainFrame
    
    local TabsList = Instance.new("ScrollingFrame")
    TabsList.Name = "TabsList"
    TabsList.BackgroundTransparency = 1
    TabsList.BorderSizePixel = 0
    TabsList.Position = UDim2.new(0, 0, 0, 0)
    TabsList.Size = UDim2.new(1, 0, 1, 0)
    TabsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsList.ScrollBarThickness = 2
    TabsList.ScrollBarImageColor3 = theme.Accent
    TabsList.Parent = TabsContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.Parent = TabsList
    
    -- Contenedor de contenido
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundColor3 = theme.Background
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 120, 0, 30)
    ContentContainer.Size = UDim2.new(1, -120, 1, -30)
    ContentContainer.Parent = MainFrame
    
    local TabsContent = {}
    local Tabs = {}
    local SelectedTab = nil
    
    -- Función para crear categorías
    function Library:CreateTab(name, icon)
        -- Botón de la categoría
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name.."Tab"
        TabButton.BackgroundColor3 = theme.Container
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "  "..name
        TabButton.TextColor3 = theme.Inactive
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabsList
        
        if icon then
            local IconLabel = Instance.new("ImageLabel")
            IconLabel.Name = "Icon"
            IconLabel.BackgroundTransparency = 1
            IconLabel.Position = UDim2.new(0, 5, 0.5, -8)
            IconLabel.Size = UDim2.new(0, 16, 0, 16)
            IconLabel.Image = icon
            IconLabel.Parent = TabButton
        end
        
        -- Contenido de la categoría
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name.."Content"
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = theme.Accent
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ElementsLayout = Instance.new("UIListLayout")
        ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ElementsLayout.Padding = UDim.new(0, 5)
        ElementsLayout.Parent = TabContent
        
        local ElementsPadding = Instance.new("UIPadding")
        ElementsPadding.PaddingLeft = UDim.new(0, 10)
        ElementsPadding.PaddingRight = UDim.new(0, 10)
        ElementsPadding.PaddingTop = UDim.new(0, 10)
        ElementsPadding.PaddingBottom = UDim.new(0, 10)
        ElementsPadding.Parent = TabContent
        
        TabsContent[name] = TabContent
        Tabs[name] = TabButton
        
        -- Seleccionar la primera categoría por defecto
        if SelectedTab == nil then
            SelectedTab = name
            TabButton.TextColor3 = theme.Accent
            TabContent.Visible = true
        end
        
        -- Click en un tab
        TabButton.MouseButton1Click:Connect(function()
            for tabName, tab in pairs(Tabs) do
                if tabName == name then
                    tab.TextColor3 = theme.Accent
                    TabsContent[tabName].Visible = true
                else
                    tab.TextColor3 = theme.Inactive
                    TabsContent[tabName].Visible = false
                end
            end
            SelectedTab = name
        end)
        
        -- Objeto para elementos
        local Elements = {}
        
        -- Función para crear toggles
        function Elements:CreateToggle(text, defaultValue, callback)
            defaultValue = defaultValue or false
            callback = callback or function() end
            
            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = text.."Toggle"
            ToggleContainer.BackgroundColor3 = theme.Container
            ToggleContainer.BorderSizePixel = 0
            ToggleContainer.Size = UDim2.new(1, 0, 0, 35)
            ToggleContainer.Parent = TabContent
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 5, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleContainer
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.BackgroundColor3 = defaultValue and theme.Accent or theme.Inactive
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Parent = ToggleContainer
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "Circle"
            ToggleCircle.BackgroundColor3 = theme.Text
            ToggleCircle.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Parent = ToggleButton
            
            local UICorner2 = Instance.new("UICorner")
            UICorner2.CornerRadius = UDim.new(1, 0)
            UICorner2.Parent = ToggleCircle
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.BackgroundTransparency = 1
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Font = Enum.Font.SourceSans
            Button.Text = ""
            Button.Parent = ToggleContainer
            
            local value = defaultValue
            
            Button.MouseButton1Click:Connect(function()
                value = not value
                ToggleButton.BackgroundColor3 = value and theme.Accent or theme.Inactive
                ToggleCircle:TweenPosition(
                    value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    Enum.EasingDirection.InOut,
                    Enum.EasingStyle.Quad,
                    0.2,
                    true
                )
                callback(value)
            end)
            
            return {
                SetValue = function(newValue)
                    value = newValue
                    ToggleButton.BackgroundColor3 = value and theme.Accent or theme.Inactive
                    ToggleCircle.Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    callback(value)
                end,
                GetValue = function()
                    return value
                end
            }
        end
        
        -- Función para crear sliders
        function Elements:CreateSlider(text, min, max, defaultValue, callback)
            min = min or 0
            max = max or 100
            defaultValue = defaultValue or min
            callback = callback or function() end
            
            local SliderContainer = Instance.new("Frame")
            SliderContainer.Name = text.."Slider"
            SliderContainer.BackgroundColor3 = theme.Container
            SliderContainer.BorderSizePixel = 0
            SliderContainer.Size = UDim2.new(1, 0, 0, 50)
            SliderContainer.Parent = TabContent
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "Label"
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 5, 0, 0)
            SliderLabel.Size = UDim2.new(1, -10, 0, 25)
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.Text = text
            SliderLabel.TextColor3 = theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderContainer
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "Value"
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -50, 0, 0)
            ValueLabel.Size = UDim2.new(0, 45, 0, 25)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = tostring(defaultValue)
            ValueLabel.TextColor3 = theme.Text
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderContainer
            
            local SliderBG = Instance.new("Frame")
            SliderBG.Name = "SliderBG"
            SliderBG.BackgroundColor3 = theme.Background
            SliderBG.BorderSizePixel = 0
            SliderBG.Position = UDim2.new(0, 5, 0, 30)
            SliderBG.Size = UDim2.new(1, -10, 0, 10)
            SliderBG.Parent = SliderContainer
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 5)
            UICorner.Parent = SliderBG
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.BackgroundColor3 = theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
            SliderFill.Parent = SliderBG
            
            local UICorner2 = Instance.new("UICorner")
            UICorner2.CornerRadius = UDim.new(0, 5)
            UICorner2.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.BackgroundTransparency = 1
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.Text = ""
            SliderButton.Parent = SliderBG
            
            local value = defaultValue
            
            local function updateSlider(input)
                local sizeX = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                SliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                value = math.floor(min + ((max - min) * sizeX))
                ValueLabel.Text = tostring(value)
                callback(value)
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                local connection
                connection = game:GetService("RunService").RenderStepped:Connect(function()
                    if not game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        connection:Disconnect()
                        return
                    end
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local input = {Position = Vector2.new(mousePos.X, mousePos.Y)}
                    updateSlider(input)
                end)
            end)
            
            return {
                SetValue = function(newValue)
                    value = math.clamp(newValue, min, max)
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    callback(value)
                end,
                GetValue = function()
                    return value
                end
            }
        end
        
        -- Función para crear botones
        function Elements:CreateButton(text, callback)
            callback = callback or function() end
            
            local ButtonContainer = Instance.new("Frame")
            ButtonContainer.Name = text.."Button"
            ButtonContainer.BackgroundColor3 = theme.Container
            ButtonContainer.BorderSizePixel = 0
            ButtonContainer.Size = UDim2.new(1, 0, 0, 35)
            ButtonContainer.Parent = TabContent
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.BackgroundColor3 = theme.Accent
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 5, 0.5, -12.5)
            Button.Size = UDim2.new(1, -10, 0, 25)
            Button.Font = Enum.Font.GothamBold
            Button.Text = text
            Button.TextColor3 = theme.Text
            Button.TextSize = 14
            Button.Parent = ButtonContainer
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 4)
            UICorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = theme.Highlight
            end)
            
            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = theme.Accent
            end)
        end
        
        -- Función para etiquetas
        function Elements:CreateLabel(text)
            local LabelContainer = Instance.new("Frame")
            LabelContainer.Name = "Label"
            LabelContainer.BackgroundTransparency = 1
            LabelContainer.Size = UDim2.new(1, 0, 0, 25)
            LabelContainer.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Text"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = text
            Label.TextColor3 = theme.Text
            Label.TextSize = 14
            Label.Parent = LabelContainer
            
            return {
                SetText = function(newText)
                    Label.Text = newText
                end
            }
        end
        
        -- Función para divisor
        function Elements:CreateDivider()
            local DividerContainer = Instance.new("Frame")
            DividerContainer.Name = "Divider"
            DividerContainer.BackgroundTransparency = 1
            DividerContainer.Size = UDim2.new(1, 0, 0, 10)
            DividerContainer.Parent = TabContent
            
            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.BackgroundColor3 = theme.Accent
            Line.BorderSizePixel = 0
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Parent = DividerContainer
        end
        
        return Elements
    end
    
    -- Sistema de notificaciones
    function Library:CreateNotification(title, message, duration)
        duration = duration or 3
        
        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Name = "Notification"
        NotificationFrame.BackgroundColor3 = theme.Container
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.Position = UDim2.new(1, -10, 1, -10)
        NotificationFrame.AnchorPoint = Vector2.new(1, 1)
        NotificationFrame.Size = UDim2.new(0, 250, 0, 0)
        NotificationFrame.ClipsDescendants = true
        NotificationFrame.Parent = ScreenGui
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = NotificationFrame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        TitleLabel.Size = UDim2.new(1, -20, 0, 20)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = title
        TitleLabel.TextColor3 = theme.Accent
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotificationFrame
        
        local MessageLabel = Instance.new("TextLabel")
        MessageLabel.Name = "Message"
        MessageLabel.BackgroundTransparency = 1
        MessageLabel.Position = UDim2.new(0, 10, 0, 25)
        MessageLabel.Size = UDim2.new(1, -20, 0, 0)
        MessageLabel.Font = Enum.Font.Gotham
        MessageLabel.Text = message
        MessageLabel.TextColor3 = theme.Text
        MessageLabel.TextSize = 14
        MessageLabel.TextWrapped = true
        MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
        MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
        MessageLabel.Parent = NotificationFrame
        
        -- Calcular altura basada en el contenido
        local textSize = game:GetService("TextService"):GetTextSize(
            message,
            14,
            Enum.Font.Gotham,
            Vector2.new(230, math.huge)
        )
        
        MessageLabel.Size = UDim2.new(1, -20, 0, textSize.Y)
        local totalHeight = 35 + textSize.Y
        
        -- Animación de entrada
        NotificationFrame.Size = UDim2.new(0, 250, 0, 0)
        NotificationFrame:TweenSize(
            UDim2.new(0, 250, 0, totalHeight),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.3,
            true
        )
        
        -- Progreso
        local ProgressBar = Instance.new("Frame")
        ProgressBar.Name = "Progress"
        ProgressBar.BackgroundColor3 = theme.Accent
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Position = UDim2.new(0, 0, 1, -2)
        ProgressBar.Size = UDim2.new(1, 0, 0, 2)
        ProgressBar.Parent = NotificationFrame
        
        -- Animación de salida después del tiempo
        ProgressBar:TweenSize(
            UDim2.new(0, 0, 0, 2),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Linear,
            duration,
            true,
            function()
                NotificationFrame:TweenSize(
                    UDim2.new(0, 250, 0, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quart,
                    0.3,
                    true,
                    function()
                        NotificationFrame:Destroy()
                    end
                )
            end
        )
    end
    
    return Library
end

return Library
