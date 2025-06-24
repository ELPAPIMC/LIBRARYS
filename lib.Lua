-- UI Library v2.0
-- Versión mejorada con notificaciones, secciones colapsables, sliders mejorados y GUI de ayuda

local Library = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuración de colores y estilo
local Config = {
    Colors = {
        Background = Color3.fromRGB(25, 25, 25),
        TabBackground = Color3.fromRGB(35, 35, 35),
        TabSelected = Color3.fromRGB(45, 45, 45),
        TabHover = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Accent = Color3.fromRGB(64, 158, 255),
        AccentHover = Color3.fromRGB(84, 178, 255),
        Border = Color3.fromRGB(60, 60, 60),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Error = Color3.fromRGB(231, 76, 60),
        Info = Color3.fromRGB(52, 152, 219)
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        Bold = Enum.Font.GothamBold,
        Mono = Enum.Font.RobotoMono
    },
    Animations = {
        Speed = 0.3,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out
    }
}

-- Sistema de notificaciones
local NotificationContainer = nil

local function InitNotifications()
    if NotificationContainer then return end
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "NotificationSystem"
    NotificationGui.Parent = PlayerGui
    NotificationGui.ResetOnSpawn = false
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    NotificationContainer = Instance.new("Frame")
    NotificationContainer.Name = "Container"
    NotificationContainer.Parent = NotificationGui
    NotificationContainer.Position = UDim2.new(1, -320, 0, 20)
    NotificationContainer.Size = UDim2.new(0, 300, 1, -40)
    NotificationContainer.BackgroundTransparency = 1
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = NotificationContainer
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
end

-- Función para crear tweens
local function CreateTween(object, properties, duration)
    duration = duration or Config.Animations.Speed
    local tweenInfo = TweenInfo.new(duration, Config.Animations.Style, Config.Animations.Direction)
    return TweenService:Create(object, tweenInfo, properties)
end

-- Función para crear elementos UI base
local function CreateElement(elementType, properties)
    local element = Instance.new(elementType)
    for property, value in pairs(properties or {}) do
        element[property] = value
    end
    return element
end

-- Función para crear notificaciones
function Library:Notification(text, notificationType, duration)
    InitNotifications()
    
    notificationType = notificationType or "Info"
    duration = duration or 3
    
    local colors = {
        Success = Config.Colors.Success,
        Warning = Config.Colors.Warning,
        Error = Config.Colors.Error,
        Info = Config.Colors.Info
    }
    
    local icons = {
        Success = "✓",
        Warning = "⚠",
        Error = "✗",
        Info = "ℹ"
    }
    
    local notification = CreateElement("Frame", {
        Parent = NotificationContainer,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Config.Colors.TabBackground,
        BorderSizePixel = 1,
        BorderColor3 = colors[notificationType] or Config.Colors.Info,
        Position = UDim2.new(1, 50, 0, 0)
    })
    
    CreateElement("UICorner", {
        Parent = notification,
        CornerRadius = UDim.new(0, 6)
    })
    
    local iconLabel = CreateElement("TextLabel", {
        Parent = notification,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        BackgroundTransparency = 1,
        Text = icons[notificationType] or icons.Info,
        TextColor3 = colors[notificationType] or Config.Colors.Info,
        Font = Config.Fonts.Bold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    local textLabel = CreateElement("TextLabel", {
        Parent = notification,
        Position = UDim2.new(0, 45, 0, 5),
        Size = UDim2.new(1, -55, 1, -10),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Regular,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    -- Animación de entrada
    CreateTween(notification, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    -- Auto-destrucción
    spawn(function()
        wait(duration)
        CreateTween(notification, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        wait(Config.Animations.Speed)
        notification:Destroy()
    end)
end

-- Función para crear botones estilizados
local function CreateStyledButton(parent, text, position, size, callback)
    local button = CreateElement("TextButton", {
        Parent = parent,
        Text = text,
        Position = position,
        Size = size,
        BackgroundColor3 = Config.Colors.TabBackground,
        BorderSizePixel = 1,
        BorderColor3 = Config.Colors.Border,
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Regular,
        TextSize = 14,
        AutoButtonColor = false
    })
    
    CreateElement("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 4)
    })
    
    -- Efectos hover
    button.MouseEnter:Connect(function()
        CreateTween(button, {BackgroundColor3 = Config.Colors.TabHover}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {BackgroundColor3 = Config.Colors.TabBackground}):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- Función principal para crear la ventana
function Library:CreateWindow(title)
    local Window = {}
    
    -- Crear ScreenGui principal
    local ScreenGui = CreateElement("ScreenGui", {
        Name = "UILibrary",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Frame principal
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Position = UDim2.new(0.5, -400, 0.5, -300),
        Size = UDim2.new(0, 800, 0, 600),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    CreateElement("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Barra de título
    local TitleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Config.Colors.TabBackground,
        BorderSizePixel = 0
    })
    
    CreateElement("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    local TitleLabel = CreateElement("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = title or "UI Library",
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Bold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Botón cerrar
    local CloseButton = CreateElement("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        Position = UDim2.new(1, -35, 0, 5),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Config.Colors.Error,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Bold,
        TextSize = 18
    })
    
    CreateElement("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(0, 4)
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Contenedor de tabs
    local TabContainer = CreateElement("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 200, 1, -40),
        BackgroundColor3 = Config.Colors.TabBackground,
        BorderSizePixel = 0
    })
    
    local TabList = CreateElement("ScrollingFrame", {
        Name = "TabList",
        Parent = TabContainer,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    CreateElement("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Contenedor de contenido
    local ContentContainer = CreateElement("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 200, 0, 40),
        Size = UDim2.new(1, -200, 1, -40),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0
    })
    
    -- Variables para manejo de tabs
    local Tabs = {}
    local CurrentTab = nil
    
    -- Función para crear tab
    function Window:CreateTab(name, icon)
        local Tab = {}
        
        -- Botón del tab
        local TabButton = CreateElement("TextButton", {
            Name = name .. "Button",
            Parent = TabList,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Config.Colors.TabBackground,
            BorderSizePixel = 1,
            BorderColor3 = Config.Colors.Border,
            Text = (icon and icon .. " " or "") .. name,
            TextColor3 = Config.Colors.TextSecondary,
            Font = Config.Fonts.Regular,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })
        
        CreateElement("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 4)
        })
        
        CreateElement("UIPadding", {
            Parent = TabButton,
            PaddingLeft = UDim.new(0, 10)
        })
        
        -- Contenido del tab
        local TabContent = CreateElement("ScrollingFrame", {
            Name = name .. "Content",
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Config.Colors.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        
        CreateElement("UIPadding", {
            Parent = TabContent,
            PaddingTop = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingBottom = UDim.new(0, 15)
        })
        
        CreateElement("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        -- Funcionalidad del tab
        local function SelectTab()
            -- Deseleccionar tab actual
            if CurrentTab then
                CreateTween(CurrentTab.Button, {
                    BackgroundColor3 = Config.Colors.TabBackground,
                    TextColor3 = Config.Colors.TextSecondary
                }):Play()
                CurrentTab.Content.Visible = false
            end
            
            -- Seleccionar nuevo tab
            CreateTween(TabButton, {
                BackgroundColor3 = Config.Colors.TabSelected,
                TextColor3 = Config.Colors.Text
            }):Play()
            TabContent.Visible = true
            CurrentTab = {Button = TabButton, Content = TabContent}
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Efectos hover
        TabButton.MouseEnter:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then
                CreateTween(TabButton, {BackgroundColor3 = Config.Colors.TabHover}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then
                CreateTween(TabButton, {BackgroundColor3 = Config.Colors.TabBackground}):Play()
            end
        end)
        
        -- Si es el primer tab, seleccionarlo
        if #Tabs == 0 then
            SelectTab()
        end
        
        Tabs[name] = {Button = TabButton, Content = TabContent, Tab = Tab}
        
        -- Funciones del tab
        function Tab:CreateSection(sectionName)
            local Section = {}
            local isCollapsed = false
            
            local SectionFrame = CreateElement("Frame", {
                Name = sectionName,
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Config.Colors.TabBackground,
                BorderSizePixel = 1,
                BorderColor3 = Config.Colors.Border,
                AutomaticSize = Enum.AutomaticSize.Y
            })
            
            CreateElement("UICorner", {
                Parent = SectionFrame,
                CornerRadius = UDim.new(0, 6)
            })
            
            -- Header de la sección (clickeable para colapsar)
            local SectionHeader = CreateElement("TextButton", {
                Name = "Header",
                Parent = SectionFrame,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = "[" .. sectionName .. " 🡇]",
                TextColor3 = Config.Colors.Text,
                Font = Config.Fonts.Bold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })
            
            CreateElement("UIPadding", {
                Parent = SectionHeader,
                PaddingLeft = UDim.new(0, 15)
            })
            
            local SectionContent = CreateElement("Frame", {
                Name = "Content",
                Parent = SectionFrame,
                Position = UDim2.new(0, 0, 0, 30),
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Visible = true
            })
            
            CreateElement("UIPadding", {
                Parent = SectionContent,
                PaddingTop = UDim.new(0, 5),
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                PaddingBottom = UDim.new(0, 15)
            })
            
            CreateElement("UIListLayout", {
                Parent = SectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            })
            
            -- Funcionalidad de colapsar
            SectionHeader.MouseButton1Click:Connect(function()
                isCollapsed = not isCollapsed
                SectionContent.Visible = not isCollapsed
                SectionHeader.Text = "[" .. sectionName .. " " .. (isCollapsed and "🡆" or "🡇") .. "]"
                
                CreateTween(SectionHeader, {
                    TextColor3 = isCollapsed and Config.Colors.TextSecondary or Config.Colors.Text
                }):Play()
            end)
            
            -- Hover effect para el header
            SectionHeader.MouseEnter:Connect(function()
                CreateTween(SectionHeader, {
                    TextColor3 = Config.Colors.Accent
                }):Play()
            end)
            
            SectionHeader.MouseLeave:Connect(function()
                CreateTween(SectionHeader, {
                    TextColor3 = isCollapsed and Config.Colors.TextSecondary or Config.Colors.Text
                }):Play()
            end)
            
            -- Funciones de la sección
            function Section:CreateButton(text, callback)
                local button = CreateStyledButton(SectionContent, text, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 35), callback)
                return button
            end
            
            function Section:CreateToggle(text, defaultState, callback)
                local toggleFrame = CreateElement("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border
                })
                
                CreateElement("UICorner", {
                    Parent = toggleFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local toggleLabel = CreateElement("TextLabel", {
                    Parent = toggleFrame,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.Colors.Text,
                    Font = Config.Fonts.Regular,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local toggleButton = CreateElement("TextButton", {
                    Parent = toggleFrame,
                    Position = UDim2.new(1, -35, 0, 7.5),
                    Size = UDim2.new(0, 20, 0, 20),
                    BackgroundColor3 = defaultState and Config.Colors.Success or Config.Colors.Border,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false
                })
                
                CreateElement("UICorner", {
                    Parent = toggleButton,
                    CornerRadius = UDim.new(0, 10)
                })
                
                local toggled = defaultState or false
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    CreateTween(toggleButton, {
                        BackgroundColor3 = toggled and Config.Colors.Success or Config.Colors.Border
                    }):Play()
                    if callback then callback(toggled) end
                end)
                
                return toggleButton
            end
            
            function Section:CreateSlider(text, minValue, maxValue, defaultValue, callback)
                local sliderFrame = CreateElement("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border
                })
                
                CreateElement("UICorner", {
                    Parent = sliderFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local sliderLabel = CreateElement("TextLabel", {
                    Parent = sliderFrame,
                    Position = UDim2.new(0, 15, 0, 8),
                    Size = UDim2.new(1, -30, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text .. ": " .. (defaultValue or minValue),
                    TextColor3 = Config.Colors.Text,
                    Font = Config.Fonts.Regular,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local sliderTrack = CreateElement("Frame", {
                    Parent = sliderFrame,
                    Position = UDim2.new(0, 15, 0, 35),
                    Size = UDim2.new(1, -30, 0, 8),
                    BackgroundColor3 = Config.Colors.Border,
                    BorderSizePixel = 0
                })
                
                CreateElement("UICorner", {
                    Parent = sliderTrack,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local sliderFill = CreateElement("Frame", {
                    Parent = sliderTrack,
                    Size = UDim2.new(((defaultValue or minValue) - minValue) / (maxValue - minValue), 0, 1, 0),
                    BackgroundColor3 = Config.Colors.Accent,
                    BorderSizePixel = 0
                })
                
                CreateElement("UICorner", {
                    Parent = sliderFill,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local currentValue = defaultValue or minValue
                local dragging = false
                
                local function UpdateSlider(input)
                    local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    currentValue = math.floor(minValue + (maxValue - minValue) * percentage)
                    
                    CreateTween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
                    sliderLabel.Text = text .. ": " .. currentValue
                    
                    if callback then callback(currentValue) end
                end
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                        
                        -- Deshabilitar el arrastre de la ventana mientras se usa el slider
                        MainFrame.Draggable = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                        dragging = false
                        -- Rehabilitar el arrastre de la ventana
                        MainFrame.Draggable = true
                    end
                end)
                
                return sliderFrame
            end
            
            function Section:CreateTextBox(text, placeholder, callback)
                local textboxFrame = CreateElement("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border
                })
                
                CreateElement("UICorner", {
                    Parent = textboxFrame,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local textboxLabel = CreateElement("TextLabel", {
                    Parent = textboxFrame,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.Colors.Text,
                    Font = Config.Fonts.Regular,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local textBox = CreateElement("TextBox", {
                    Parent = textboxFrame,
                    Position = UDim2.new(0.4, 10, 0, 5),
                    Size = UDim2.new(0.6, -15, 1, -10),
                    BackgroundColor3 = Config.Colors.Background,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border,
                    Text = "",
                    PlaceholderText = placeholder or "",
                    TextColor3 = Config.Colors.Text,
                    PlaceholderColor3 = Config.Colors.TextSecondary,
                    Font = Config.Fonts.Regular,
                    TextSize = 14
                })
                
                CreateElement("UICorner", {
                    Parent = textBox,
                    CornerRadius = UDim.new(0, 3)
                })
                
                if callback then
                    textBox.FocusLost:Connect(function()
                        callback(textBox.Text)
                    end)
                end
                
                return textBox
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

-- Sistema de ayuda
function Library.Help()
    local HelpGui = CreateElement("ScreenGui", {
        Name = "LibraryHelp",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local HelpFrame = CreateElement("Frame", {
        Name = "HelpFrame",
        Parent = HelpGui,
        Position = UDim2.new(0.5, -300, 0.5, -250),
        Size = UDim2.new(0, 600, 0, 500),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    CreateElement("UICorner", {
        Parent = HelpFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Barra de título
    local TitleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Parent = HelpFrame,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Config.Colors.TabBackground,
        BorderSizePixel = 0
    })
    
    CreateElement("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    local TitleLabel = CreateElement("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = "📚 Guía de UI Library",
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Bold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Botón cerrar
    local CloseButton = CreateElement("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        Position = UDim2.new(1, -35, 0, 5),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Config.Colors.Error,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Bold,
        TextSize = 18
    })
    
    CreateElement("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(0, 4)
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        HelpGui:Destroy()
    end)
    
    -- Contenido de ayuda
    local ScrollFrame = CreateElement("ScrollingFrame", {
        Name = "HelpContent",
        Parent = HelpFrame,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    CreateElement("UIPadding", {
        Parent = ScrollFrame,
        PaddingTop = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 20)
    })
    
    CreateElement("UIListLayout", {
        Parent = ScrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 15)
    })
    
    -- Función para crear secciones de ayuda
    local function CreateHelpSection(title, content)
        local section = CreateElement("Frame", {
            Parent = ScrollFrame,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Config.Colors.TabBackground,
            BorderSizePixel = 1,
            BorderColor3 = Config.Colors.Border,
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        CreateElement("UICorner", {
            Parent = section,
            CornerRadius = UDim.new(0, 6)
        })
        
        local titleLabel = CreateElement("TextLabel", {
            Parent = section,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Config.Colors.Accent,
            Font = Config.Fonts.Bold,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        CreateElement("UIPadding", {
            Parent = titleLabel,
            PaddingLeft = UDim.new(0, 15)
        })
        
        local contentLabel = CreateElement("TextLabel", {
            Parent = section,
            Position = UDim2.new(0, 0, 0, 30),
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = Config.Colors.Text,
            Font = Config.Fonts.Regular,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        CreateElement("UIPadding", {
            Parent = contentLabel,
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingBottom = UDim.new(0, 15)
        })
    end
    
    -- Contenido de la ayuda
    CreateHelpSection("🚀 Inicio Rápido", [[
-- Cargar la librería
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ELPAPIMC/LIBRARYS/refs/heads/main/lib.Lua"))()

-- Crear ventana principal
local Window = Library:CreateWindow("Mi Script")

-- Crear un tab
local Tab = Window:CreateTab("General", "⚙️")

-- Crear una sección
local Section = Tab:CreateSection("Configuración")]])
    
    CreateHelpSection("🔘 Crear Botones", [[
-- Crear un botón simple
Section:CreateButton("Ejecutar Acción", function()
    print("¡Botón presionado!")
    Library:Notification("Acción ejecutada", "Success")
end)]])
    
    CreateHelpSection("🔄 Crear Toggles", [[
-- Crear un toggle con estado inicial
Section:CreateToggle("Activar ESP", false, function(estado)
    print("ESP:", estado and "Activado" or "Desactivado")
    Library:Notification("ESP " .. (estado and "Activado" or "Desactivado"), "Info")
end)]])
    
    CreateHelpSection("📏 Crear Sliders", [[
-- Crear un slider con rango personalizado
Section:CreateSlider("Velocidad", 1, 100, 16, function(valor)
    print("Velocidad establecida:", valor)
    Library:Notification("Velocidad: " .. valor, "Info")
end)]])
    
    CreateHelpSection("📝 Crear TextBox", [[
-- Crear una caja de texto
Section:CreateTextBox("Nombre de jugador", "Escribe aquí...", function(texto)
    print("Texto ingresado:", texto)
    Library:Notification("Texto guardado: " .. texto, "Success")
end)]])
    
    CreateHelpSection("🔔 Crear Notificaciones", [[
-- Diferentes tipos de notificaciones
Library:Notification("Información general", "Info", 3)
Library:Notification("Operación exitosa", "Success", 3)
Library:Notification("Advertencia importante", "Warning", 5)
Library:Notification("Error crítico", "Error", 4)]])
    
    CreateHelpSection("📁 Secciones Colapsables", [[
Las secciones ahora son colapsables por defecto.
Haz clic en el título de cualquier sección para mostrar/ocultar su contenido.

Ejemplo: [Aimbot 🡇] se convierte en [Aimbot 🡆] cuando está colapsada.]])
    
    CreateHelpSection("🎨 Características Mejoradas", [[
• Sliders más anchos y mejor diseño
• Arrastre de ventana deshabilitado al usar sliders
• Secciones colapsables con indicadores visuales
• Sistema de notificaciones integrado
• Efectos hover mejorados
• Animaciones suaves en todos los elementos]])
end

return Library
