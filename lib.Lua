--[[
    PibblestoreLib v1.0
    Una biblioteca UI completa para Roblox
    Desarrollado por Pibblestore
]]

local PibblestoreLib = {}
PibblestoreLib.__index = PibblestoreLib

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Configuraciones de la biblioteca
local Config = {
    Themes = {
        Dark = {
            Background = Color3.fromRGB(30, 30, 30),
            Container = Color3.fromRGB(40, 40, 40),
            TextColor = Color3.fromRGB(255, 255, 255),
            AccentColor = Color3.fromRGB(0, 120, 215),
            ButtonColor = Color3.fromRGB(60, 60, 60),
            ToggleOn = Color3.fromRGB(0, 175, 255),
            ToggleOff = Color3.fromRGB(100, 100, 100)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            Container = Color3.fromRGB(255, 255, 255),
            TextColor = Color3.fromRGB(0, 0, 0),
            AccentColor = Color3.fromRGB(0, 120, 215),
            ButtonColor = Color3.fromRGB(220, 220, 220),
            ToggleOn = Color3.fromRGB(0, 120, 215),
            ToggleOff = Color3.fromRGB(180, 180, 180)
        },
        Aquamarine = {
            Background = Color3.fromRGB(18, 38, 32),
            Container = Color3.fromRGB(24, 48, 41),
            TextColor = Color3.fromRGB(210, 255, 252),
            AccentColor = Color3.fromRGB(64, 224, 208),
            ButtonColor = Color3.fromRGB(30, 60, 55),
            ToggleOn = Color3.fromRGB(64, 224, 208),
            ToggleOff = Color3.fromRGB(70, 90, 85)
        }
    },
    Animation = {
        Duration = 0.3,
        Style = Enum.EasingStyle.Quint,
        Direction = Enum.EasingDirection.Out
    }
}

-- Función auxiliar para crear tweens
local function CreateTween(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or Config.Animation.Duration,
            style or Config.Animation.Style,
            direction or Config.Animation.Direction
        ),
        properties
    )
    return tween
end

-- Función para crear objetos UI
local function CreateObject(class, properties)
    local obj = Instance.new(class)
    for property, value in pairs(properties) do
        obj[property] = value
    end
    return obj
end

-- Función para redondear las esquinas
local function ApplyCorners(object, radius)
    local corner = Instance.new("UICorner", object)
    corner.CornerRadius = UDim.new(0, radius or 4)
    return corner
end

-- Función principal para crear la interfaz
function PibblestoreLib.new(title, themeName)
    local theme = Config.Themes[themeName or "Dark"]
    if not theme then theme = Config.Themes.Dark end
    
    -- Creamos el ScreenGui
    local ScreenGui = CreateObject("ScreenGui", {
        Name = "PibblestoreLib",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Contenedor principal
    local Main = CreateObject("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = theme.Background,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 450, 0, 350),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    ApplyCorners(Main, 6)
    
    -- Sombra
    local Shadow = CreateObject("ImageLabel", {
        Name = "Shadow",
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 30, 1, 30),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277)
    })
    
    -- Barra superior
    local TopBar = CreateObject("Frame", {
        Name = "TopBar",
        Parent = Main,
        BackgroundColor3 = theme.Container,
        Size = UDim2.new(1, 0, 0, 30)
    })
    ApplyCorners(TopBar, 6)
    
    local TopBarBottomCover = CreateObject("Frame", {
        Name = "TopBarBottomCover",
        Parent = TopBar,
        BackgroundColor3 = theme.Container,
        Position = UDim2.new(0, 0, 1, -6),
        Size = UDim2.new(1, 0, 0, 6)
    })
    
    -- Título
    local TitleLabel = CreateObject("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = title or "PibblestoreLib",
        TextColor3 = theme.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Botón para cerrar
    local CloseButton = CreateObject("TextButton", {
        Name = "CloseButton",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = theme.TextColor,
        TextSize = 14
    })
    
    -- Soporte para arrastrar la ventana
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Contenedor para pestañas
    local TabContainer = CreateObject("Frame", {
        Name = "TabContainer",
        Parent = Main,
        BackgroundColor3 = theme.Container,
        Position = UDim2.new(0, 5, 0, 35),
        Size = UDim2.new(0, 100, 1, -40)
    })
    ApplyCorners(TabContainer, 6)
    
    local TabList = CreateObject("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 5),
        Size = UDim2.new(1, 0, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    local TabListLayout = CreateObject("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local TabListPadding = CreateObject("UIPadding", {
        Parent = TabList,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })
    
    -- Contenedor para el contenido
    local ContentContainer = CreateObject("Frame", {
        Name = "ContentContainer",
        Parent = Main,
        BackgroundColor3 = theme.Container,
        Position = UDim2.new(0, 110, 0, 35),
        Size = UDim2.new(1, -115, 1, -40)
    })
    ApplyCorners(ContentContainer, 6)
    
    -- Manejador para cerrar la UI
    CloseButton.MouseButton1Click:Connect(function()
        local closeTween = CreateTween(Main, {Size = UDim2.new(0, 0, 0, 0), Transparency = 1})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Crear efecto de aparición
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.BackgroundTransparency = 1
    Shadow.ImageTransparency = 1
    
    local openTween = CreateTween(Main, {Size = UDim2.new(0, 450, 0, 350), BackgroundTransparency = 0})
    local shadowTween = CreateTween(Shadow, {ImageTransparency = 0.6})
    
    openTween:Play()
    shadowTween:Play()
    
    -- Objeto que manejaremos
    local Window = {}
    Window.ScreenGui = ScreenGui
    Window.Main = Main
    Window.Theme = theme
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Método para cambiar el tema
    function Window:SetTheme(themeName)
        local newTheme = Config.Themes[themeName]
        if not newTheme then return end
        
        self.Theme = newTheme
        
        -- Actualizar colores principales
        local mainTween = CreateTween(Main, {BackgroundColor3 = newTheme.Background})
        local topBarTween = CreateTween(TopBar, {BackgroundColor3 = newTheme.Container})
        local topBarCoverTween = CreateTween(TopBarBottomCover, {BackgroundColor3 = newTheme.Container})
        local tabContainerTween = CreateTween(TabContainer, {BackgroundColor3 = newTheme.Container})
        local contentContainerTween = CreateTween(ContentContainer, {BackgroundColor3 = newTheme.Container})
        
        mainTween:Play()
        topBarTween:Play()
        topBarCoverTween:Play()
        tabContainerTween:Play()
        contentContainerTween:Play()
        
        -- Actualizar textos
        TitleLabel.TextColor3 = newTheme.TextColor
        CloseButton.TextColor3 = newTheme.TextColor
        
        -- Actualizar pestañas y contenidos
        for _, tab in pairs(self.Tabs) do
            tab:UpdateTheme(newTheme)
        end
    end
    
    -- Método para crear una nueva pestaña
    function Window:CreateTab(name, icon)
        local tabButton = CreateObject("TextButton", {
            Name = name,
            Parent = TabList,
            BackgroundColor3 = self.Theme.ButtonColor,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = self.Theme.TextColor,
            TextSize = 12,
            AutoButtonColor = false
        })
        ApplyCorners(tabButton, 4)
        
        if icon then
            local iconImage = CreateObject("ImageLabel", {
                Name = "Icon",
                Parent = tabButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = icon
            })
            
            tabButton.Text = "    " .. name
            tabButton.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        local tabContent = CreateObject("ScrollingFrame", {
            Name = name .. "Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarImageColor3 = self.Theme.AccentColor
        })
        
        local contentLayout = CreateObject("UIListLayout", {
            Parent = tabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })
        
        local contentPadding = CreateObject("UIPadding", {
            Parent = tabContent,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        
        local Tab = {}
        Tab.Button = tabButton
        Tab.Content = tabContent
        Tab.Elements = {}
        
        -- Actualizar el tema de los elementos
        function Tab:UpdateTheme(newTheme)
            tabButton.BackgroundColor3 = newTheme.ButtonColor
            tabButton.TextColor3 = newTheme.TextColor
            tabContent.ScrollBarImageColor3 = newTheme.AccentColor
            
            for _, element in pairs(self.Elements) do
                if element.UpdateTheme then
                    element:UpdateTheme(newTheme)
                end
            end
        end
        
        -- Método para crear un Label
        function Tab:AddLabel(text)
            local label = CreateObject("TextLabel", {
                Name = "Label",
                Parent = tabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local labelObj = {
                Instance = label,
                Type = "Label"
            }
            
            -- Método para actualizar el texto
            function labelObj:SetText(newText)
                label.Text = newText
            end
            
            -- Método para actualizar el tema
            function labelObj:UpdateTheme(newTheme)
                label.TextColor3 = newTheme.TextColor
            end
            
            table.insert(self.Elements, labelObj)
            return labelObj
        end
        
        -- Método para crear un botón
        function Tab:AddButton(text, callback)
            local button = CreateObject("TextButton", {
                Name = "Button",
                Parent = tabContent,
                BackgroundColor3 = Window.Theme.ButtonColor,
                Size = UDim2.new(1, 0, 0, 35),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                AutoButtonColor = false
            })
            ApplyCorners(button, 4)
            
            local buttonObj = {
                Instance = button,
                Type = "Button",
                Callback = callback
            }
            
            -- Efectos de hover
            button.MouseEnter:Connect(function()
                local hoverTween = CreateTween(button, {BackgroundColor3 = Window.Theme.AccentColor})
                hoverTween:Play()
            end)
            
            button.MouseLeave:Connect(function()
                local leaveTween = CreateTween(button, {BackgroundColor3 = Window.Theme.ButtonColor})
                leaveTween:Play()
            end)
            
            button.MouseButton1Click:Connect(function()
                if buttonObj.Callback then
                    buttonObj.Callback()
                end
                
                -- Efecto de clic
                local clickScale = CreateTween(button, {Size = UDim2.new(0.97, 0, 0, 35)}, 0.1)
                local returnScale = CreateTween(button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
                
                clickScale:Play()
                clickScale.Completed:Connect(function()
                    returnScale:Play()
                end)
            end)
            
            -- Método para actualizar el texto
            function buttonObj:SetText(newText)
                button.Text = newText
            end
            
            -- Método para actualizar el callback
            function buttonObj:SetCallback(newCallback)
                self.Callback = newCallback
            end
            
            -- Método para actualizar el tema
            function buttonObj:UpdateTheme(newTheme)
                button.BackgroundColor3 = newTheme.ButtonColor
                button.TextColor3 = newTheme.TextColor
            end
            
            table.insert(self.Elements, buttonObj)
            return buttonObj
        end
        
        -- Método para crear un toggle
        function Tab:AddToggle(text, default, callback)
            local toggle = CreateObject("Frame", {
                Name = "Toggle",
                Parent = tabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35)
            })
            
            local toggleLabel = CreateObject("TextLabel", {
                Name = "Label",
                Parent = toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local toggleButton = CreateObject("Frame", {
                Name = "ToggleButton",
                Parent = toggle,
                BackgroundColor3 = default and Window.Theme.ToggleOn or Window.Theme.ToggleOff,
                Position = UDim2.new(1, -40, 0.5, 0),
                Size = UDim2.new(0, 40, 0, 20),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            ApplyCorners(toggleButton, 10)
            
            local toggleCircle = CreateObject("Frame", {
                Name = "Circle",
                Parent = toggleButton,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            ApplyCorners(toggleCircle, 8)
            
            local toggleHitbox = CreateObject("TextButton", {
                Name = "Hitbox",
                Parent = toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 10
            })
            
            local toggleObj = {
                Instance = toggle,
                Type = "Toggle",
                Enabled = default or false,
                Callback = callback
            }
            
            -- Función para actualizar el estado visual
            local function updateToggleVisual()
                local targetPosition = toggleObj.Enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                local targetColor = toggleObj.Enabled and Window.Theme.ToggleOn or Window.Theme.ToggleOff
                
                local positionTween = CreateTween(toggleCircle, {Position = targetPosition})
                local colorTween = CreateTween(toggleButton, {BackgroundColor3 = targetColor})
                
                positionTween:Play()
                colorTween:Play()
            end
            
            toggleHitbox.MouseButton1Click:Connect(function()
                toggleObj.Enabled = not toggleObj.Enabled
                updateToggleVisual()
                
                if toggleObj.Callback then
                    toggleObj.Callback(toggleObj.Enabled)
                end
            end)
            
            -- Método para obtener el valor
            function toggleObj:GetValue()
                return self.Enabled
            end
            
            -- Método para establecer el valor
            function toggleObj:SetValue(value)
                self.Enabled = value
                updateToggleVisual()
                
                if self.Callback then
                    self.Callback(self.Enabled)
                end
            end
            
            -- Método para actualizar el tema
            function toggleObj:UpdateTheme(newTheme)
                toggleLabel.TextColor3 = newTheme.TextColor
                toggleButton.BackgroundColor3 = self.Enabled and newTheme.ToggleOn or newTheme.ToggleOff
            end
            
            table.insert(self.Elements, toggleObj)
            return toggleObj
        end
        
        -- Método para crear un Slider
        function Tab:AddSlider(text, min, max, default, precision, callback)
            min = min or 0
            max = max or 100
            default = default or min
            precision = precision or 1
            
            -- Asegurarse de que el valor predeterminado esté dentro del rango
            default = math.clamp(default, min, max)
            
            local slider = CreateObject("Frame", {
                Name = "Slider",
                Parent = tabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 50)
            })
            
            local sliderLabel = CreateObject("TextLabel", {
                Name = "Label",
                Parent = slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local valueLabel = CreateObject("TextLabel", {
                Name = "Value",
                Parent = slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -40, 0, 0),
                Size = UDim2.new(0, 40, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(default),
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local sliderBg = CreateObject("Frame", {
                Name = "Background",
                Parent = slider,
                BackgroundColor3 = Window.Theme.ButtonColor,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 8)
            })
            ApplyCorners(sliderBg, 4)
            
            local sliderFill = CreateObject("Frame", {
                Name = "Fill",
                Parent = sliderBg,
                BackgroundColor3 = Window.Theme.AccentColor,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            })
            ApplyCorners(sliderFill, 4)
            
            local sliderKnob = CreateObject("Frame", {
                Name = "Knob",
                Parent = sliderBg,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
                Size = UDim2.new(0, 16, 0, 16),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ZIndex = 5
            })
            ApplyCorners(sliderKnob, 8)
            
            local sliderHitbox = CreateObject("TextButton", {
                Name = "Hitbox",
                Parent = sliderBg,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 10
            })
            
            local sliderObj = {
                Instance = slider,
                Type = "Slider",
                Value = default,
                Min = min,
                Max = max,
                Precision = precision,
                Callback = callback
            }
            
            -- Función para formatear el valor según la precisión
            local function formatValue(value)
                if precision == 0 then
                    return math.floor(value)
                else
                    local fmt = "%." .. precision .. "f"
                    return string.format(fmt, value)
                end
            end
            
            -- Función para actualizar el slider visualmente
            local function updateSlider(value)
                value = math.clamp(value, min, max)
                local percentage = (value - min) / (max - min)
                
                -- Redondear según la precisión
                if precision == 0 then
                    value = math.floor(value)
                else
                    local multiplier = 10 ^ precision
                    value = math.floor(value * multiplier + 0.5) / multiplier
                end
                
                sliderObj.Value = value
                valueLabel.Text = formatValue(value)
                
                -- Animación suave
                local fillTween = CreateTween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                local knobTween = CreateTween(sliderKnob, {Position = UDim2.new(percentage, 0, 0.5, 0)}, 0.1)
                
                fillTween:Play()
                knobTween:Play()
                
                if sliderObj.Callback then
                    sliderObj.Callback(value)
                end
            end
            
            -- Manejo de eventos de arrastre
            local isDragging = false
            
            sliderHitbox.MouseButton1Down:Connect(function()
                isDragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            sliderHitbox.MouseButton1Click:Connect(function()
                local relativeX = Mouse.X - sliderBg.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
                local value = min + (max - min) * percentage
                updateSlider(value)
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relativeX = Mouse.X - sliderBg.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * percentage
                    updateSlider(value)
                end
            end)
            
            -- Método para obtener el valor
            function sliderObj:GetValue()
                return self.Value
            end
            
            -- Método para establecer el valor
            function sliderObj:SetValue(value)
                updateSlider(value)
            end
            
            -- Método para actualizar el tema
            function sliderObj:UpdateTheme(newTheme)
                sliderLabel.TextColor3 = newTheme.TextColor
                valueLabel.TextColor3 = newTheme.TextColor
                sliderBg.BackgroundColor3 = newTheme.ButtonColor
                sliderFill.BackgroundColor3 = newTheme.AccentColor
            end
            
            -- Actualizar el slider inicialmente
            updateSlider(default)
            
            table.insert(self.Elements, sliderObj)
            return sliderObj
        end
        
        -- Método para crear un Dropdown
        function Tab:AddDropdown(text, options, default, callback)
            options = options or {}
            default = default or options[1]
            
            local dropdown = CreateObject("Frame", {
                Name = "Dropdown",
                Parent = tabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                ClipsDescendants = true
            })
            
            local dropdownLabel = CreateObject("TextLabel", {
                Name = "Label",
                Parent = dropdown,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local dropdownButton = CreateObject("TextButton", {
                Name = "Button",
                Parent = dropdown,
                BackgroundColor3 = Window.Theme.ButtonColor,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = default or "Select...",
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                AutoButtonColor = false
            })
            ApplyCorners(dropdownButton, 4)
            
            local dropdownPadding = CreateObject("UIPadding", {
                Parent = dropdownButton,
                PaddingLeft = UDim.new(0, 10)
            })
            
            local dropdownIcon = CreateObject("ImageLabel", {
                Name = "Icon",
                Parent = dropdownButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0.5, 0),
                Size = UDim2.new(0, 15, 0, 15),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Image = "rbxassetid://7072706663", -- Flecha hacia abajo
                ImageColor3 = Window.Theme.TextColor
            })
            
            local optionsFrame = CreateObject("Frame", {
                Name = "Options",
                Parent = dropdown,
                BackgroundColor3 = Window.Theme.ButtonColor,
                Position = UDim2.new(0, 0, 0, 60),
                Size = UDim2.new(1, 0, 0, 0),
                Visible = false,
                ZIndex = 10,
                ClipsDescendants = true
            })
            ApplyCorners(optionsFrame, 4)
            
            local optionsList = CreateObject("ScrollingFrame", {
                Name = "List",
                Parent = optionsFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = Window.Theme.AccentColor,
                ZIndex = 10,
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            })
            
            local optionsLayout = CreateObject("UIListLayout", {
                Parent = optionsList,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            })
            
            local optionsPadding = CreateObject("UIPadding", {
                Parent = optionsList,
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5)
            })
            
            local dropdownObj = {
                Instance = dropdown,
                Type = "Dropdown",
                Value = default,
                Options = options,
                Callback = callback,
                IsOpen = false
            }
            
            -- Función para agregar opciones
            local function createOptions()
                -- Limpiar opciones existentes
                for _, child in pairs(optionsList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Agregar nuevas opciones
                for i, option in ipairs(options) do
                    local optionButton = CreateObject("TextButton", {
                        Name = "Option_" .. i,
                        Parent = optionsList,
                        BackgroundColor3 = Window.Theme.ButtonColor,
                        BackgroundTransparency = 0.5,
                        Size = UDim2.new(1, 0, 0, 25),
                        Font = Enum.Font.Gotham,
                        Text = option,
                        TextColor3 = Window.Theme.TextColor,
                        TextSize = 12,
                        ZIndex = 11,
                        AutoButtonColor = false
                    })
                    ApplyCorners(optionButton, 4)
                    
                    -- Eventos de hover
                    optionButton.MouseEnter:Connect(function()
                        local hoverTween = CreateTween(optionButton, {BackgroundColor3 = Window.Theme.AccentColor})
                        hoverTween:Play()
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        local leaveTween = CreateTween(optionButton, {BackgroundColor3 = Window.Theme.ButtonColor, BackgroundTransparency = 0.5})
                        leaveTween:Play()
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        dropdownObj.Value = option
                        dropdownButton.Text = option
                        
                        if dropdownObj.Callback then
                            dropdownObj.Callback(option)
                        end
                        
                        -- Cerrar el dropdown
                        toggleDropdown(false)
                    end)
                end
            end
            
            -- Función para abrir/cerrar el dropdown
            function toggleDropdown(state)
                dropdownObj.IsOpen = state
                
                local targetSize = state and UDim2.new(1, 0, 0, math.min(120, #options * 35)) or UDim2.new(1, 0, 0, 0)
                local targetVisible = state
                local targetRotation = state and 180 or 0
                
                -- Ajustar tamaño del dropdown
                dropdown.Size = state and UDim2.new(1, 0, 0, 65 + math.min(120, #options * 35)) or UDim2.new(1, 0, 0, 60)
                
                -- Animación del icono de flecha
                local iconTween = CreateTween(dropdownIcon, {Rotation = targetRotation})
                iconTween:Play()
                
                -- Animación del frame de opciones
                if state then
                    optionsFrame.Visible = true
                    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
                    
                    local sizeTween = CreateTween(optionsFrame, {Size = targetSize})
                    sizeTween:Play()
                else
                    local sizeTween = CreateTween(optionsFrame, {Size = targetSize})
                    sizeTween:Play()
                    
                    sizeTween.Completed:Connect(function()
                        if not dropdownObj.IsOpen then
                            optionsFrame.Visible = false
                        end
                    end)
                end
            end
            
            -- Manejar clic en el botón
            dropdownButton.MouseButton1Click:Connect(function()
                toggleDropdown(not dropdownObj.IsOpen)
            end)
            
            -- Cerrar el dropdown cuando se hace clic fuera
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dropdownPos = dropdown.AbsolutePosition
                    local dropdownSize = dropdown.AbsoluteSize
                    
                    if dropdownObj.IsOpen and 
                       (mousePos.X < dropdownPos.X or 
                        mousePos.X > dropdownPos.X + dropdownSize.X or 
                        mousePos.Y < dropdownPos.Y or 
                        mousePos.Y > dropdownPos.Y + dropdownSize.Y) then
                        toggleDropdown(false)
                    end
                end
            end)
            
            -- Método para obtener el valor
            function dropdownObj:GetValue()
                return self.Value
            end
            
            -- Método para establecer el valor
            function dropdownObj:SetValue(value)
                if table.find(self.Options, value) then
                    self.Value = value
                    dropdownButton.Text = value
                    
                    if self.Callback then
                        self.Callback(value)
                    end
                end
            end
            
            -- Método para refrescar las opciones
            function dropdownObj:RefreshOptions(newOptions)
                self.Options = newOptions
                createOptions()
                
                -- Si el valor actual no está en las nuevas opciones, resetearlo
                if not table.find(newOptions, self.Value) then
                    self.Value = newOptions[1]
                    dropdownButton.Text = self.Value or "Select..."
                end
            end
            
            -- Método para actualizar el tema
            function dropdownObj:UpdateTheme(newTheme)
                dropdownLabel.TextColor3 = newTheme.TextColor
                dropdownButton.BackgroundColor3 = newTheme.ButtonColor
                dropdownButton.TextColor3 = newTheme.TextColor
                dropdownIcon.ImageColor3 = newTheme.TextColor
                optionsFrame.BackgroundColor3 = newTheme.ButtonColor
                optionsList.ScrollBarImageColor3 = newTheme.AccentColor
                
                -- Actualizar opciones
                for _, child in pairs(optionsList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = newTheme.ButtonColor
                        child.TextColor3 = newTheme.TextColor
                    end
                end
            end
            
            -- Crear opciones iniciales
            createOptions()
            
            table.insert(self.Elements, dropdownObj)
            return dropdownObj
        end
        
        -- Método para crear un TextBox
        function Tab:AddTextBox(text, placeholder, default, callback)
            local textbox = CreateObject("Frame", {
                Name = "TextBox",
                Parent = tabContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 60)
            })
            
            local textboxLabel = CreateObject("TextLabel", {
                Name = "Label",
                Parent = textbox,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local textboxContainer = CreateObject("Frame", {
                Name = "Container",
                Parent = textbox,
                BackgroundColor3 = Window.Theme.ButtonColor,
                Position = UDim2.new(0, 0, 0, 25),
                Size = UDim2.new(1, 0, 0, 35)
            })
            ApplyCorners(textboxContainer, 4)
            
            local textboxInput = CreateObject("TextBox", {
                Name = "Input",
                Parent = textboxContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.Gotham,
                Text = default or "",
                PlaceholderText = placeholder or "Type here...",
                TextColor3 = Window.Theme.TextColor,
                PlaceholderColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false
            })
            
            local textboxObj = {
                Instance = textbox,
                Type = "TextBox",
                Value = default or "",
                Callback = callback
            }
            
            -- Manejar cambios en el texto
            textboxInput.FocusLost:Connect(function(enterPressed)
                textboxObj.Value = textboxInput.Text
                
                if textboxObj.Callback then
                    textboxObj.Callback(textboxInput.Text, enterPressed)
                end
            end)
            
            -- Método para obtener el valor
            function textboxObj:GetValue()
                return self.Value
            end
            
            -- Método para establecer el valor
            function textboxObj:SetValue(value)
                self.Value = value
                textboxInput.Text = value
                
                if self.Callback then
                    self.Callback(value, false)
                end
            end
            
            -- Método para actualizar el tema
            function textboxObj:UpdateTheme(newTheme)
                textboxLabel.TextColor3 = newTheme.TextColor
                textboxContainer.BackgroundColor3 = newTheme.ButtonColor
                textboxInput.TextColor3 = newTheme.TextColor
            end
            
            table.insert(self.Elements, textboxObj)
            return textboxObj
        end
        
        -- Método para crear una sección de información
        function Tab:AddSection(title)
            local section = CreateObject("Frame", {
                Name = "Section",
                Parent = tabContent,
                BackgroundColor3 = Window.Theme.ButtonColor,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, 0, 0, 30)
            })
            ApplyCorners(section, 4)
            
            local sectionLabel = CreateObject("TextLabel", {
                Name = "Label",
                Parent = section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = title,
                TextColor3 = Window.Theme.TextColor,
                TextSize = 14
            })
            
            local sectionObj = {
                Instance = section,
                Type = "Section"
            }
            
            -- Método para actualizar el texto
            function sectionObj:SetText(newText)
                sectionLabel.Text = newText
            end
            
            -- Método para actualizar el tema
            function sectionObj:UpdateTheme(newTheme)
                section.BackgroundColor3 = newTheme.ButtonColor
                sectionLabel.TextColor3 = newTheme.TextColor
            end
            
            table.insert(self.Elements, sectionObj)
            return sectionObj
        end
        
        -- Activar la pestaña al hacer clic
        tabButton.MouseButton1Click:Connect(function()
            if Window.ActiveTab then
                -- Desactivar la pestaña actual
                Window.ActiveTab.Content.Visible = false
                local inactiveTween = CreateTween(Window.ActiveTab.Button, {BackgroundColor3 = Window.Theme.ButtonColor})
                inactiveTween:Play()
            end
            
            -- Activar la nueva pestaña
            tabContent.Visible = true
            local activeTween = CreateTween(tabButton, {BackgroundColor3 = Window.Theme.AccentColor})
            activeTween:Play()
            
            Window.ActiveTab = Tab
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Si es la primera pestaña, activarla
        if #Window.Tabs == 1 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Window.Theme.AccentColor
            Window.ActiveTab = Tab
        end
        
        return Tab
    end
    
    -- Método para mostrar notificación
    function Window:Notify(title, content, duration)
        duration = duration or 5
        
        local notification = CreateObject("Frame", {
            Name = "Notification",
            Parent = ScreenGui,
            BackgroundColor3 = self.Theme.Container,
            Position = UDim2.new(1, -20, 1, 20),
            Size = UDim2.new(0, 250, 0, 80),
            AnchorPoint = Vector2.new(1, 1)
        })
        ApplyCorners(notification, 6)
        
        local notifShadow = CreateObject("ImageLabel", {
            Name = "Shadow",
            Parent = notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 20, 1, 20),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = "rbxassetid://5554236805",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.6,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(23, 23, 277, 277)
        })
        
        local notifTitle = CreateObject("TextLabel", {
            Name = "Title",
            Parent = notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = self.Theme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local notifContent = CreateObject("TextLabel", {
            Name = "Content",
            Parent = notification,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 30),
            Size = UDim2.new(1, -20, 0, 40),
            Font = Enum.Font.Gotham,
            Text = content,
            TextColor3 = self.Theme.TextColor,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        
        -- Línea de progreso
        local progressBar = CreateObject("Frame", {
            Name = "ProgressBar",
            Parent = notification,
            BackgroundColor3 = self.Theme.AccentColor,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2),
            AnchorPoint = Vector2.new(0, 0)
        })
        
        -- Animación de entrada
        notification.Position = UDim2.new(1, 270, 1, -20)
        local entryTween = CreateTween(notification, {Position = UDim2.new(1, -20, 1, -20)})
        entryTween:Play()
        
        -- Animación de la barra de progreso
        local progressTween = CreateTween(progressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration)
        progressTween:Play()
        
        -- Animación de salida después de la duración
        local function dismiss()
            local exitTween = CreateTween(notification, {Position = UDim2.new(1, 270, 1, -20)})
            exitTween:Play()
            
            exitTween.Completed:Connect(function()
                notification:Destroy()
            end)
        end
        
        -- Permitir cerrar la notificación haciendo clic
        notification.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dismiss()
            end
        end)
        
        -- Programar eliminación
        task.delay(duration, dismiss)
        
        return notification
    end
    
    return Window
end

-- Alias para acceder fácilmente a la biblioteca
getgenv().PibblestoreLib = PibblestoreLib

return PibblestoreLib
