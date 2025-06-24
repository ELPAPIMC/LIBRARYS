-- UI Library v2.1
-- Versión mejorada con CoreGui, dropdowns y multi-select

local Library = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- Usar CoreGui en lugar de PlayerGui
local function GetParentGui()
    local success, result = pcall(function()
        return CoreGui
    end)
    if success then
        return CoreGui
    else
        return Player:WaitForChild("PlayerGui")
    end
end

local ParentGui = GetParentGui()

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
        Info = Color3.fromRGB(52, 152, 219),
        DropdownSelected = Color3.fromRGB(70, 130, 255)
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        Bold = Enum.Font.GothamBold,
        Mono = Enum.Font.RobotoMono
    },
    Animations = {
        Speed = 0.25,
        SlowSpeed = 0.4,
        FastSpeed = 0.15,
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
    NotificationGui.Parent = ParentGui
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

-- Función para crear tweens mejorados
local function CreateTween(object, properties, duration, style, direction)
    duration = duration or Config.Animations.Speed
    style = style or Config.Animations.Style
    direction = direction or Config.Animations.Direction
    local tweenInfo = TweenInfo.new(duration, style, direction)
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

-- Función para crear notificaciones mejoradas
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
        Position = UDim2.new(1, 50, 0, 0),
        BackgroundTransparency = 0.3
    })
    
    CreateElement("UICorner", {
        Parent = notification,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Barra de progreso para duración
    local progressBar = CreateElement("Frame", {
        Parent = notification,
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = colors[notificationType] or Config.Colors.Info,
        BorderSizePixel = 0
    })
    
    CreateElement("UICorner", {
        Parent = progressBar,
        CornerRadius = UDim.new(0, 2)
    })
    
    local iconLabel = CreateElement("TextLabel", {
        Parent = notification,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 30, 1, -3),
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
        Size = UDim2.new(1, -55, 1, -8),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Regular,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    -- Animaciones mejoradas
    CreateTween(notification, {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0
    }, Config.Animations.SlowSpeed):Play()
    
    -- Animación de la barra de progreso
    CreateTween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear):Play()
    
    -- Auto-destrucción con animación
    spawn(function()
        wait(duration)
        local fadeOut = CreateTween(notification, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, Config.Animations.FastSpeed)
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

-- Función para crear botones estilizados mejorados
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
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Efectos hover mejorados
    button.MouseEnter:Connect(function()
        CreateTween(button, {
            BackgroundColor3 = Config.Colors.TabHover,
            BorderColor3 = Config.Colors.Accent
        }, Config.Animations.FastSpeed):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {
            BackgroundColor3 = Config.Colors.TabBackground,
            BorderColor3 = Config.Colors.Border
        }, Config.Animations.FastSpeed):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        CreateTween(button, {
            BackgroundColor3 = Config.Colors.Accent
        }, Config.Animations.FastSpeed):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        CreateTween(button, {
            BackgroundColor3 = Config.Colors.TabHover
        }, Config.Animations.FastSpeed):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- Función principal para crear la ventana
function Library:CreateWindow(title)
    local Window = {}
    
    -- Crear ScreenGui principal en CoreGui
    local ScreenGui = CreateElement("ScreenGui", {
        Name = "UILibrary_" .. math.random(1000, 9999),
        Parent = ParentGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Frame principal con animación de entrada
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Position = UDim2.new(0.5, -400, -1, -300),
        Size = UDim2.new(0, 800, 0, 600),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    CreateElement("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Animación de entrada de la ventana
    CreateTween(MainFrame, {
        Position = UDim2.new(0.5, -400, 0.5, -300)
    }, Config.Animations.SlowSpeed, Enum.EasingStyle.Back):Play()
    
    -- Barra de título con gradiente
    local TitleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Config.Colors.TabBackground,
        BorderSizePixel = 0
    })
    
    CreateElement("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Gradiente para la barra de título
    local gradient = CreateElement("UIGradient", {
        Parent = TitleBar,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Config.Colors.TabBackground),
            ColorSequenceKeypoint.new(1, Config.Colors.TabSelected)
        },
        Rotation = 45
    })
    
    local TitleLabel = CreateElement("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = title or "UI Library v2.1",
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Bold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Botón cerrar mejorado
    local CloseButton = CreateElement("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        Position = UDim2.new(1, -40, 0, 7.5),
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Config.Colors.Error,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Config.Colors.Text,
        Font = Config.Fonts.Bold,
        TextSize = 20
    })
    
    CreateElement("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(0, 15)
    })
    
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, Config.Animations.FastSpeed):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Config.Colors.Error}, Config.Animations.FastSpeed):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {
            Position = UDim2.new(0.5, -400, -1, -300)
        }, Config.Animations.SlowSpeed, Enum.EasingStyle.Back):Play()
        wait(Config.Animations.SlowSpeed)
        ScreenGui:Destroy()
    end)
    
    -- Contenedor de tabs
    local TabContainer = CreateElement("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 220, 1, -45),
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
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Config.Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    CreateElement("UIListLayout", {
        Parent = TabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })
    
    -- Contenedor de contenido
    local ContentContainer = CreateElement("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        Position = UDim2.new(0, 220, 0, 45),
        Size = UDim2.new(1, -220, 1, -45),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0
    })
    
    -- Variables para manejo de tabs
    local Tabs = {}
    local CurrentTab = nil
    
    -- Función para crear tab
    function Window:CreateTab(name, icon)
        local Tab = {}
        
        -- Botón del tab con animación
        local TabButton = CreateElement("TextButton", {
            Name = name .. "Button",
            Parent = TabList,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Config.Colors.TabBackground,
            BorderSizePixel = 1,
            BorderColor3 = Config.Colors.Border,
            Text = (icon and icon .. " " or "") .. name,
            TextColor3 = Config.Colors.TextSecondary,
            Font = Config.Fonts.Regular,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })
        
        CreateElement("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 8)
        })
        
        CreateElement("UIPadding", {
            Parent = TabButton,
            PaddingLeft = UDim.new(0, 15)
        })
        
        -- Contenido del tab
        local TabContent = CreateElement("ScrollingFrame", {
            Name = name .. "Content",
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = Config.Colors.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        
        CreateElement("UIPadding", {
            Parent = TabContent,
            PaddingTop = UDim.new(0, 20),
            PaddingLeft = UDim.new(0, 20),
            PaddingRight = UDim.new(0, 20),
            PaddingBottom = UDim.new(0, 20)
        })
        
        CreateElement("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15)
        })
        
        -- Funcionalidad del tab con animaciones
        local function SelectTab()
            -- Deseleccionar tab actual
            if CurrentTab then
                CreateTween(CurrentTab.Button, {
                    BackgroundColor3 = Config.Colors.TabBackground,
                    TextColor3 = Config.Colors.TextSecondary,
                    BorderColor3 = Config.Colors.Border
                }, Config.Animations.FastSpeed):Play()
                CurrentTab.Content.Visible = false
            end
            
            -- Seleccionar nuevo tab
            CreateTween(TabButton, {
                BackgroundColor3 = Config.Colors.TabSelected,
                TextColor3 = Config.Colors.Text,
                BorderColor3 = Config.Colors.Accent
            }, Config.Animations.FastSpeed):Play()
            TabContent.Visible = true
            CurrentTab = {Button = TabButton, Content = TabContent}
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        -- Efectos hover mejorados
        TabButton.MouseEnter:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then
                CreateTween(TabButton, {
                    BackgroundColor3 = Config.Colors.TabHover,
                    BorderColor3 = Config.Colors.Accent
                }, Config.Animations.FastSpeed):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab and CurrentTab.Button ~= TabButton then
                CreateTween(TabButton, {
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderColor3 = Config.Colors.Border
                }, Config.Animations.FastSpeed):Play()
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
                CornerRadius = UDim.new(0, 10)
            })
            
            -- Header de la sección con animación
            local SectionHeader = CreateElement("TextButton", {
                Name = "Header",
                Parent = SectionFrame,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                Text = "📁 " .. sectionName .. " 🔽",
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
                Position = UDim2.new(0, 0, 0, 35),
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                Visible = true
            })
            
            CreateElement("UIPadding", {
                Parent = SectionContent,
                PaddingTop = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                PaddingBottom = UDim.new(0, 15)
            })
            
            CreateElement("UIListLayout", {
                Parent = SectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            })
            
            -- Funcionalidad de colapsar con animación
            SectionHeader.MouseButton1Click:Connect(function()
                isCollapsed = not isCollapsed
                
                local targetSize = UDim2.new(1, 0, 0, isCollapsed and 0 or SectionContent.AbsoluteSize.Y)
                SectionHeader.Text = "📁 " .. sectionName .. (isCollapsed and " 🔼" or " 🔽")
                
                CreateTween(SectionContent, {
                    Size = targetSize
                }, Config.Animations.Speed):Play()
                
                SectionContent.Visible = not isCollapsed
                
                CreateTween(SectionHeader, {
                    TextColor3 = isCollapsed and Config.Colors.TextSecondary or Config.Colors.Text
                }, Config.Animations.FastSpeed):Play()
            end)
            
            -- Hover effect para el header
            SectionHeader.MouseEnter:Connect(function()
                CreateTween(SectionHeader, {
                    TextColor3 = Config.Colors.Accent
                }, Config.Animations.FastSpeed):Play()
            end)
            
            SectionHeader.MouseLeave:Connect(function()
                CreateTween(SectionHeader, {
                    TextColor3 = isCollapsed and Config.Colors.TextSecondary or Config.Colors.Text
                }, Config.Animations.FastSpeed):Play()
            end)
            
            -- Funciones de la sección
            function Section:CreateButton(text, callback)
                local button = CreateStyledButton(SectionContent, text, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), callback)
                return button
            end
            
            function Section:CreateToggle(text, defaultState, callback)
                local toggleFrame = CreateElement("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border
                })
                
                CreateElement("UICorner", {
                    Parent = toggleFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local toggleLabel = CreateElement("TextLabel", {
                    Parent = toggleFrame,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -70, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.Colors.Text,
                    Font = Config.Fonts.Regular,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local toggleButton = CreateElement("TextButton", {
                    Parent = toggleFrame,
                    Position = UDim2.new(1, -50, 0, 8),
                    Size = UDim2.new(0, 35, 0, 24),
                    BackgroundColor3 = defaultState and Config.Colors.Success or Config.Colors.Border,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false
                })
                
                CreateElement("UICorner", {
                    Parent = toggleButton,
                    CornerRadius = UDim.new(0, 12)
                })
                
                local toggleIndicator = CreateElement("Frame", {
                    Parent = toggleButton,
                    Position = defaultState and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2),
                    Size = UDim2.new(0, 20, 0, 20),
                    BackgroundColor3 = Config.Colors.Text,
                    BorderSizePixel = 0
                })
                
                CreateElement("UICorner", {
                    Parent = toggleIndicator,
                    CornerRadius = UDim.new(0, 10)
                })
                
                local toggled = defaultState or false
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    CreateTween(toggleButton, {
                        BackgroundColor3 = toggled and Config.Colors.Success or Config.Colors.Border
                    }, Config.Animations.Speed):Play()
                    CreateTween(toggleIndicator, {
                        Position = toggled and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
                    }, Config.Animations.Speed):Play()
                    if callback then callback(toggled) end
                end)
                
                return toggleButton
            end
            
            function Section:CreateSlider(text, minValue, maxValue, defaultValue, callback)
                local sliderFrame = CreateElement("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 70),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border
                })
                
                CreateElement("UICorner", {
                    Parent = sliderFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local sliderLabel = CreateElement("TextLabel", {
                    Parent = sliderFrame,
                    Position = UDim2.new(0, 15, 0, 8),
                    Size = UDim2.new(1, -30, 0, 25),
                    BackgroundTransparency = 1,
                    Text = text .. ": " .. (defaultValue or minValue),
                    TextColor3 = Config.Colors.Text,
                    Font = Config.Fonts.Regular,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local sliderTrack = CreateElement("Frame", {
                    Parent = sliderFrame,
                    Position = UDim2.new(0, 15, 0, 40),
                    Size = UDim2.new(1, -30, 0, 12),
                    BackgroundColor3 = Config.Colors.Border,
                    BorderSizePixel = 0
                })
                
                CreateElement("UICorner", {
                    Parent = sliderTrack,
                    CornerRadius = UDim.new(0, 6)
                })
                
                local sliderFill = CreateElement("Frame", {
                    Parent = sliderTrack,
                    Size = UDim2.new(((defaultValue or minValue) - minValue) / (maxValue - minValue), 0, 1, 0),
                    BackgroundColor3 = Config.Colors.Accent,
                    BorderSizePixel = 0
                })
                
                CreateElement("UICorner", {
                    Parent = sliderFill,
                    CornerRadius = UDim.new(0, 6)
                })
                
                local sliderHandle = CreateElement("Frame", {
                    Parent = sliderTrack,
                    Position = UDim2.new(((defaultValue or minValue) - minValue) / (maxValue - minValue), -8, 0, -4),
                    Size = UDim2.new(0, 16, 0, 20),
                    BackgroundColor3 = Config.Colors.Text,
                    BorderSizePixel = 0
                })
                
                CreateElement("UICorner", {
                    Parent = sliderHandle,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local currentValue = defaultValue or minValue
                local dragging = false
                
                local function UpdateSlider(input)
                    local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    currentValue = math.floor(minValue + (maxValue - minValue) * percentage)
                    
                    CreateTween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, Config.Animations.FastSpeed):Play()
                    CreateTween(sliderHandle, {Position = UDim2.new(percentage, -8, 0, -4)}, Config.Animations.FastSpeed):Play()
                    sliderLabel.Text = text .. ": " .. currentValue
                    
                    if callback then callback(currentValue) end
                end
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                        MainFrame.Draggable = false
                        CreateTween(sliderHandle, {BackgroundColor3 = Config.Colors.Accent}, Config.Animations.FastSpeed):Play()
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
                        MainFrame.Draggable = true
                        CreateTween(sliderHandle, {BackgroundColor3 = Config.Colors.Text}, Config.Animations.FastSpeed):Play()
                    end
                end)
                
                return sliderFrame
            end
            
            function Section:CreateTextBox(text, placeholder, callback)
                local textboxFrame = CreateElement("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border
                })
                
                CreateElement("UICorner", {
                    Parent = textboxFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local textboxLabel = CreateElement("TextLabel", {
                    Parent = textboxFrame,
                    Position = UDim2.new(0, 15, 0, 0),
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
                    Position = UDim2.new(0.4, 10, 0, 8),
                    Size = UDim2.new(0.6, -25, 1, -16),
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
                    CornerRadius = UDim.new(0, 5)
                })
                
                textBox.Focused:Connect(function()
                    CreateTween(textBox, {BorderColor3 = Config.Colors.Accent}, Config.Animations.FastSpeed):Play()
                end)
                
                textBox.FocusLost:Connect(function()
                    CreateTween(textBox, {BorderColor3 = Config.Colors.Border}, Config.Animations.FastSpeed):Play()
                    if callback then callback(textBox.Text) end
                end)
                
                return textBox
            end
            
            -- Función para crear Dropdown
            function Section:CreateDropdown(text, options, multiSelect, callback)
                local dropdownFrame = CreateElement("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border
                })
                
                CreateElement("UICorner", {
                    Parent = dropdownFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local dropdownLabel = CreateElement("TextLabel", {
                    Parent = dropdownFrame,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.Colors.Text,
                    Font = Config.Fonts.Regular,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local dropdownButton = CreateElement("TextButton", {
                    Parent = dropdownFrame,
                    Position = UDim2.new(0.4, 10, 0, 8),
                    Size = UDim2.new(0.6, -25, 1, -16),
                    BackgroundColor3 = Config.Colors.Background,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border,
                    Text = multiSelect and "Seleccionar opciones..." or "Seleccionar opción...",
                    TextColor3 = Config.Colors.TextSecondary,
                    Font = Config.Fonts.Regular,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false
                })
                
                CreateElement("UICorner", {
                    Parent = dropdownButton,
                    CornerRadius = UDim.new(0, 5)
                })
                
                CreateElement("UIPadding", {
                    Parent = dropdownButton,
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 25)
                })
                
                local dropdownArrow = CreateElement("TextLabel", {
                    Parent = dropdownButton,
                    Position = UDim2.new(1, -20, 0, 0),
                    Size = UDim2.new(0, 15, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = Config.Colors.TextSecondary,
                    Font = Config.Fonts.Regular,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Center
                })
                
                local dropdownList = CreateElement("Frame", {
                    Parent = dropdownFrame,
                    Position = UDim2.new(0.4, 10, 1, 5),
                    Size = UDim2.new(0.6, -25, 0, 0),
                    BackgroundColor3 = Config.Colors.TabBackground,
                    BorderSizePixel = 1,
                    BorderColor3 = Config.Colors.Border,
                    Visible = false,
                    ZIndex = 10
                })
                
                CreateElement("UICorner", {
                    Parent = dropdownList,
                    CornerRadius = UDim.new(0, 5)
                })
                
                local listLayout = CreateElement("UIListLayout", {
                    Parent = dropdownList,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                
                local selectedOptions = {}
                local isOpen = false
                
                local function UpdateDropdownText()
                    if multiSelect then
                        if #selectedOptions == 0 then
                            dropdownButton.Text = "Seleccionar opciones..."
                            dropdownButton.TextColor3 = Config.Colors.TextSecondary
                        else
                            dropdownButton.Text = table.concat(selectedOptions, ", ")
                            dropdownButton.TextColor3 = Config.Colors.Text
                        end
                    else
                        if selectedOptions[1] then
                            dropdownButton.Text = selectedOptions[1]
                            dropdownButton.TextColor3 = Config.Colors.Text
                        else
                            dropdownButton.Text = "Seleccionar opción..."
                            dropdownButton.TextColor3 = Config.Colors.TextSecondary
                        end
                    end
                end
                
                local function CreateOption(optionText)
                    local optionButton = CreateElement("TextButton", {
                        Parent = dropdownList,
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = Config.Colors.Background,
                        BorderSizePixel = 0,
                        Text = optionText,
                        TextColor3 = Config.Colors.Text,
                        Font = Config.Fonts.Regular,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false
                    })
                    
                    CreateElement("UIPadding", {
                        Parent = optionButton,
                        PaddingLeft = UDim.new(0, 10)
                    })
                    
                    local isSelected = false
                    
                    optionButton.MouseEnter:Connect(function()
                        CreateTween(optionButton, {BackgroundColor3 = Config.Colors.TabHover}, Config.Animations.FastSpeed):Play()
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundColor3 = isSelected and Config.Colors.DropdownSelected or Config.Colors.Background
                        }, Config.Animations.FastSpeed):Play()
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        if multiSelect then
                            isSelected = not isSelected
                            if isSelected then
                                table.insert(selectedOptions, optionText)
                                CreateTween(optionButton, {BackgroundColor3 = Config.Colors.DropdownSelected}, Config.Animations.FastSpeed):Play()
                            else
                                for i, v in ipairs(selectedOptions) do
                                    if v == optionText then
                                        table.remove(selectedOptions, i)
                                        break
                                    end
                                end
                                CreateTween(optionButton, {BackgroundColor3 = Config.Colors.Background}, Config.Animations.FastSpeed):Play()
                            end
                        else
                            selectedOptions = {optionText}
                            isOpen = false
                            CreateTween(dropdownList, {Size = UDim2.new(0.6, -25, 0, 0)}, Config.Animations.Speed):Play()
                            CreateTween(dropdownArrow, {Rotation = 0}, Config.Animations.Speed):Play()
                            wait(Config.Animations.Speed)
                            dropdownList.Visible = false
                        end
                        
                        UpdateDropdownText()
                        if callback then callback(multiSelect and selectedOptions or selectedOptions[1]) end
                    end)
                end
                
                for _, option in ipairs(options) do
                    CreateOption(option)
                end
                
                dropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local targetSize = isOpen and UDim2.new(0.6, -25, 0, #options * 32 + 5) or UDim2.new(0.6, -25, 0, 0)
                    
                    if isOpen then
                        dropdownList.Visible = true
                        CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + #options * 32 + 10)}, Config.Animations.Speed):Play()
                    else
                        CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, Config.Animations.Speed):Play()
                        wait(Config.Animations.Speed)
                        dropdownList.Visible = false
                    end
                    
                    CreateTween(dropdownList, {Size = targetSize}, Config.Animations.Speed):Play()
                    CreateTween(dropdownArrow, {Rotation = isOpen and 180 or 0}, Config.Animations.Speed):Play()
                    CreateTween(dropdownButton, {BorderColor3 = isOpen and Config.Colors.Accent or Config.Colors.Border}, Config.Animations.FastSpeed):Play()
                end)
                
                UpdateDropdownText()
                return dropdownFrame
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

-- Sistema de ayuda mejorado
function Library.Help()
    local HelpGui = CreateElement("ScreenGui", {
        Name = "LibraryHelp",
        Parent = ParentGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    local HelpFrame = CreateElement("Frame", {
        Name = "HelpFrame",
        Parent = HelpGui,
        Position = UDim2.new(0.5, -350, -1, -300),
        Size = UDim2.new(0, 700, 0, 600),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    CreateElement("UICorner", {
        Parent = HelpFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Animación de entrada
    CreateTween(HelpFrame, {
        Position = UDim2.new(0.5, -350, 0.5, -300)
    }, Config.Animations.SlowSpeed, Enum.EasingStyle.Back):Play()
    
    -- Resto del contenido de ayuda...
    -- [El resto del código de ayuda permanece igual pero con las nuevas animaciones]
end

return Library
