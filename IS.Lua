-- IS Library v2.5 Enhanced
-- Biblioteca UI moderna para Roblox con sistema completo

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local IS = {}
IS.__index = IS
IS.ConfigFolder = "ISLibrary"

-- Temas predefinidos con gradientes
IS.Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 190),
        Border = Color3.fromRGB(45, 45, 55),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26),
        Info = Color3.fromRGB(52, 152, 219),
        Gradient = {
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 75)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
            }),
            Speed = 3
        }
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(20, 20, 30),
        TextDark = Color3.fromRGB(100, 100, 110),
        Border = Color3.fromRGB(220, 220, 230),
        Success = Color3.fromRGB(67, 181, 129),
        Error = Color3.fromRGB(240, 71, 71),
        Warning = Color3.fromRGB(250, 166, 26),
        Info = Color3.fromRGB(52, 152, 219),
        Gradient = {
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 220)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 220))
            }),
            Speed = 4
        }
    },
    Ocean = {
        Background = Color3.fromRGB(20, 30, 48),
        Secondary = Color3.fromRGB(30, 42, 66),
        Accent = Color3.fromRGB(52, 152, 219),
        Text = Color3.fromRGB(236, 240, 241),
        TextDark = Color3.fromRGB(149, 165, 166),
        Border = Color3.fromRGB(41, 128, 185),
        Success = Color3.fromRGB(46, 204, 113),
        Error = Color3.fromRGB(231, 76, 60),
        Warning = Color3.fromRGB(241, 196, 15),
        Info = Color3.fromRGB(52, 152, 219),
        Gradient = {
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 60, 90)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(52, 152, 219)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 60, 90))
            }),
            Speed = 5
        }
    }
}

-- Sistema de notificaciones (posición superior derecha)
local NotificationManager = {}
NotificationManager.Notifications = {}
NotificationManager.Offset = 10

function NotificationManager:Create(title, message, duration, type)
    pcall(function()
        local notif = Instance.new("Frame")
        notif.Name = "Notification"
        notif.Size = UDim2.new(0, 300, 0, 0)
        notif.Position = UDim2.new(1, -310, 0, self.Offset)
        notif.BackgroundColor3 = IS.CurrentTheme.Secondary
        notif.BorderSizePixel = 0
        notif.ZIndex = 10000
        notif.ClipsDescendants = true
        notif.Parent = IS.ScreenGui
        
        local corner = Instance.new("UICorner", notif)
        corner.CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", notif)
        stroke.Color = type == "success" and IS.CurrentTheme.Success or 
                      type == "error" and IS.CurrentTheme.Error or 
                      type == "warning" and IS.CurrentTheme.Warning or 
                      type == "info" and IS.CurrentTheme.Info or IS.CurrentTheme.Accent
        stroke.Thickness = 2
        
        local icon = "ℹ"
        if type == "success" then icon = "✓"
        elseif type == "error" then icon = "✕"
        elseif type == "warning" then icon = "⚠" end
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        iconLabel.Position = UDim2.new(0, 10, 0, 10)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = stroke.Color
        iconLabel.TextSize = 20
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Parent = notif
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -55, 0, 25)
        titleLabel.Position = UDim2.new(0, 45, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = IS.CurrentTheme.Text
        titleLabel.TextSize = 15
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notif
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Name = "Message"
        msgLabel.Size = UDim2.new(1, -55, 0, 40)
        msgLabel.Position = UDim2.new(0, 45, 0, 35)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = message
        msgLabel.TextColor3 = IS.CurrentTheme.TextDark
        msgLabel.TextSize = 13
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextWrapped = true
        msgLabel.Parent = notif
        
        table.insert(self.Notifications, notif)
        self:UpdatePositions()
        
        -- Animación de entrada
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 300, 0, 85)
        }):Play()
        
        -- Auto-destrucción
        task.delay(duration or 4, function()
            TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 10, 0, notif.Position.Y.Offset)
            }):Play()
            
            task.wait(0.3)
            for i, n in ipairs(self.Notifications) do
                if n == notif then
                    table.remove(self.Notifications, i)
                    break
                end
            end
            notif:Destroy()
            self:UpdatePositions()
        end)
    end)
end

function NotificationManager:UpdatePositions()
    local offset = 10
    for _, notif in ipairs(self.Notifications) do
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -310, 0, offset)
        }):Play()
        offset = offset + notif.Size.Y.Offset + 10
    end
end

-- Sistema de configuración
function IS:SaveConfig(name, data)
    pcall(function()
        if not isfolder(self.ConfigFolder) then
            makefolder(self.ConfigFolder)
        end
        writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
end

function IS:LoadConfig(name)
    local success, result = pcall(function()
        if isfile(self.ConfigFolder .. "/" .. name .. ".json") then
            return HttpService:JSONDecode(readfile(self.ConfigFolder .. "/" .. name .. ".json"))
        end
        return nil
    end)
    return success and result or nil
end

function IS:GetConfigs()
    local configs = {}
    pcall(function()
        if not isfolder(self.ConfigFolder) then
            makefolder(self.ConfigFolder)
        end
        for _, file in ipairs(listfiles(self.ConfigFolder)) do
            local name = file:match("([^/\\]+)%.json$")
            if name then
                table.insert(configs, name)
            end
        end
    end)
    return configs
end

function IS:DeleteConfig(name)
    pcall(function()
        if isfile(self.ConfigFolder .. "/" .. name .. ".json") then
            delfile(self.ConfigFolder .. "/" .. name .. ".json")
        end
    end)
end

-- Constructor principal
function IS:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Keybinds = {}
    Window.Minimized = false
    Window.ConfigData = {}
    Window.Elements = {}
    
    IS.CurrentTheme = IS.Themes[config.Theme or "Dark"]
    
    local success, err = pcall(function()
        -- Detectar tamaño de pantalla
        local viewport = workspace.CurrentCamera.ViewportSize
        local isMobile = viewport.X < 600 or UserInputService.TouchEnabled
        
        local windowWidth = isMobile and math.min(viewport.X - 20, 500) or 650
        local windowHeight = isMobile and math.min(viewport.Y - 40, 450) or 420
        
        -- ScreenGui principal
        IS.ScreenGui = Instance.new("ScreenGui")
        IS.ScreenGui.Name = "ISLibrary"
        IS.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        IS.ScreenGui.ResetOnSpawn = false
        IS.ScreenGui.Parent = CoreGui
        
        -- Frame principal
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
        MainFrame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
        MainFrame.BackgroundColor3 = IS.CurrentTheme.Background
        MainFrame.BorderSizePixel = 0
        MainFrame.Active = true
        MainFrame.ClipsDescendants = true
        MainFrame.Parent = IS.ScreenGui
        
        local corner = Instance.new("UICorner", MainFrame)
        corner.CornerRadius = UDim.new(0, 10)
        
        -- Stroke animado con gradiente
        local stroke = Instance.new("UIStroke", MainFrame)
        stroke.Thickness = 2
        stroke.Transparency = 0
        
        local gradient = Instance.new("UIGradient", stroke)
        gradient.Color = IS.CurrentTheme.Gradient[1]
        
        -- Animación del gradiente
        local gradientConnection
        gradientConnection = RunService.RenderStepped:Connect(function()
            if not MainFrame or not MainFrame.Parent then
                gradientConnection:Disconnect()
                return
            end
            gradient.Rotation = (gradient.Rotation + IS.CurrentTheme.Gradient.Speed) % 360
        end)
        
        -- Animación de flotación
        local floatConnection
        local startPos = MainFrame.Position
        floatConnection = RunService.RenderStepped:Connect(function()
            if not MainFrame or not MainFrame.Parent then
                floatConnection:Disconnect()
                return
            end
            local offset = math.sin(tick() * 2) * 3
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, startPos.Y.Offset + offset)
        end)
        
        -- Hacer draggable
        local dragging, dragInput, dragStart, startPosOffset
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPosOffset = MainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        startPos = MainFrame.Position
                    end
                end)
            end
        end)
        
        MainFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(startPosOffset.X.Scale, startPosOffset.X.Offset + delta.X, startPosOffset.Y.Scale, startPosOffset.Y.Offset + delta.Y)
                MainFrame.Position = newPos
            end
        end)
        
        -- Header
        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, 0, 0, 40)
        Header.BackgroundColor3 = IS.CurrentTheme.Secondary
        Header.BorderSizePixel = 0
        Header.Parent = MainFrame
        
        local headerCorner = Instance.new("UICorner", Header)
        headerCorner.CornerRadius = UDim.new(0, 10)
        
        local headerFix = Instance.new("Frame")
        headerFix.Size = UDim2.new(1, 0, 0, 10)
        headerFix.Position = UDim2.new(0, 0, 1, -10)
        headerFix.BackgroundColor3 = IS.CurrentTheme.Secondary
        headerFix.BorderSizePixel = 0
        headerFix.Parent = Header
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -80, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = config.Name or "IS Library"
        Title.TextColor3 = IS.CurrentTheme.Text
        Title.TextSize = isMobile and 16 or 18
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Header
        
        -- Botón minimizar
        local MinimizeBtn = Instance.new("TextButton")
        MinimizeBtn.Name = "Minimize"
        MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
        MinimizeBtn.Position = UDim2.new(1, -68, 0, 6)
        MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 189, 68)
        MinimizeBtn.Text = ""
        MinimizeBtn.BorderSizePixel = 0
        MinimizeBtn.Parent = Header
        
        local minimizeCorner = Instance.new("UICorner", MinimizeBtn)
        minimizeCorner.CornerRadius = UDim.new(1, 0)
        
        -- Botón cerrar
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Name = "Close"
        CloseBtn.Size = UDim2.new(0, 28, 0, 28)
        CloseBtn.Position = UDim2.new(1, -35, 0, 6)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
        CloseBtn.Text = ""
        CloseBtn.BorderSizePixel = 0
        CloseBtn.Parent = Header
        
        local closeCorner = Instance.new("UICorner", CloseBtn)
        closeCorner.CornerRadius = UDim.new(1, 0)
        
        CloseBtn.MouseButton1Click:Connect(function()
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            task.wait(0.3)
            if floatConnection then floatConnection:Disconnect() end
            if gradientConnection then gradientConnection:Disconnect() end
            IS.ScreenGui:Destroy()
        end)
        
        -- Container para contenido (tabs + content)
        local ContentWrapper = Instance.new("Frame")
        ContentWrapper.Name = "ContentWrapper"
        ContentWrapper.Size = UDim2.new(1, 0, 1, -40)
        ContentWrapper.Position = UDim2.new(0, 0, 0, 40)
        ContentWrapper.BackgroundTransparency = 1
        ContentWrapper.Parent = MainFrame
        
        MinimizeBtn.MouseButton1Click:Connect(function()
            Window.Minimized = not Window.Minimized
            local targetSize = Window.Minimized and UDim2.new(0, windowWidth, 0, 40) or UDim2.new(0, windowWidth, 0, windowHeight)
            
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = targetSize
            }):Play()
            
            ContentWrapper.Visible = not Window.Minimized
        end)
        
        -- Tab container
        local tabWidth = isMobile and 120 or 150
        local TabContainer = Instance.new("Frame")
        TabContainer.Name = "TabContainer"
        TabContainer.Size = UDim2.new(0, tabWidth, 1, -10)
        TabContainer.Position = UDim2.new(0, 10, 0, 5)
        TabContainer.BackgroundColor3 = IS.CurrentTheme.Secondary
        TabContainer.BorderSizePixel = 0
        TabContainer.Parent = ContentWrapper
        
        local tabCorner = Instance.new("UICorner", TabContainer)
        tabCorner.CornerRadius = UDim.new(0, 8)
        
        local TabList = Instance.new("UIListLayout")
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Padding = UDim.new(0, 5)
        TabList.Parent = TabContainer
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingTop = UDim.new(0, 10)
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        TabPadding.Parent = TabContainer
        
        -- Content container
        local ContentContainer = Instance.new("Frame")
        ContentContainer.Name = "ContentContainer"
        ContentContainer.Size = UDim2.new(1, -(tabWidth + 30), 1, -10)
        ContentContainer.Position = UDim2.new(0, tabWidth + 20, 0, 5)
        ContentContainer.BackgroundTransparency = 1
        ContentContainer.Parent = ContentWrapper
        
        Window.MainFrame = MainFrame
        Window.TabContainer = TabContainer
        Window.ContentContainer = ContentContainer
        Window.IsMobile = isMobile
        Window.ContentWrapper = ContentWrapper
        
        -- Botón móvil si está habilitado
        if config.MobileButton and isMobile then
            local MobileBtn = Instance.new("TextButton")
            MobileBtn.Name = "MobileToggle"
            MobileBtn.Size = UDim2.new(0, 60, 0, 60)
            MobileBtn.Position = UDim2.new(0, 10, 0, 10)
            MobileBtn.BackgroundColor3 = IS.CurrentTheme.Accent
            MobileBtn.Text = "☰"
            MobileBtn.TextColor3 = Color3.new(1, 1, 1)
            MobileBtn.TextSize = 30
            MobileBtn.Font = Enum.Font.GothamBold
            MobileBtn.BorderSizePixel = 0
            MobileBtn.ZIndex = 9999
            MobileBtn.Parent = IS.ScreenGui
            
            local mobileCorner = Instance.new("UICorner", MobileBtn)
            mobileCorner.CornerRadius = UDim.new(1, 0)
            
            local mobileStroke = Instance.new("UIStroke", MobileBtn)
            mobileStroke.Color = Color3.new(1, 1, 1)
            mobileStroke.Thickness = 2
            mobileStroke.Transparency = 0.7
            
            MobileBtn.MouseButton1Click:Connect(function()
                MainFrame.Visible = not MainFrame.Visible
            end)
            
            -- Hacer draggable el botón móvil
            local btnDragging, btnDragStart, btnStartPos
            MobileBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    btnDragging = true
                    btnDragStart = input.Position
                    btnStartPos = MobileBtn.Position
                end
            end)
            
            MobileBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    btnDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - btnDragStart
                    MobileBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)
    
    if not success then
        warn("[IS Library] Error al crear ventana: " .. tostring(err))
        return nil
    end
    
    -- Crear tab de Config por defecto
    local ConfigTab = Window:CreateTab("⚙️ Config")
    
    local currentConfigName = ""
    local selectedConfig = nil
    
    ConfigTab:AddSection("Administrar Configs")
    
    ConfigTab:AddTextbox({
        Name = "Nombre de Config",
        Id = "_ConfigName",
        Placeholder = "Mi Configuración",
        Callback = function(text)
            currentConfigName = text
        end
    })
    
    ConfigTab:AddButton({
        Name = "💾 Guardar Config",
        Callback = function()
            if currentConfigName ~= "" then
                Window:SaveConfig(currentConfigName)
            else
                Window:Notify("Error", "Escribe un nombre para la config", 3, "error")
            end
        end
    })
    
    ConfigTab:AddSection("Cargar Configs")
    
    local configDropdown
    local function refreshConfigs()
        local configs = IS:GetConfigs()
        if #configs == 0 then
            table.insert(configs, "Sin configs")
        end
        return configs
    end
    
    configDropdown = ConfigTab:AddDropdown({
        Name = "Seleccionar Config",
        Id = "_SelectedConfig",
        Options = refreshConfigs(),
        Callback = function(option)
            if option ~= "Sin configs" then
                selectedConfig = option
            end
        end
    })
    
    ConfigTab:AddButton({
        Name = "📂 Cargar Config",
        Callback = function()
            if selectedConfig and selectedConfig ~= "Sin configs" then
                Window:LoadConfig(selectedConfig)
            else
                Window:Notify("Error", "Selecciona una config primero", 3, "error")
            end
        end
    })
    
    ConfigTab:AddButton({
        Name = "🔄 Refrescar Lista",
        Callback = function()
            -- Nota: Necesitarías recrear el dropdown para refrescar
            Window:Notify("Info", "Recarga el script para ver configs nuevas", 3, "info")
        end
    })
    
    ConfigTab:AddButton({
        Name = "🗑️ Eliminar Config",
        Callback = function()
            if selectedConfig and selectedConfig ~= "Sin configs" then
                IS:DeleteConfig(selectedConfig)
                Window:Notify("Éxito", "Config eliminada: " .. selectedConfig, 3, "success")
                selectedConfig = nil
            else
                Window:Notify("Error", "Selecciona una config primero", 3, "error")
            end
        end
    })
    
    -- Crear Tab
    function Window:CreateTab(name)
        local Tab = {}
        Tab.Elements = {}
        
        local success, err = pcall(function()
            local TabBtn = Instance.new("TextButton")
            TabBtn.Name = name
            TabBtn.Size = UDim2.new(1, 0, 0, 35)
            TabBtn.BackgroundColor3 = IS.CurrentTheme.Background
            TabBtn.Text = name
            TabBtn.TextColor3 = IS.CurrentTheme.TextDark
            TabBtn.TextSize = self.IsMobile and 12 or 14
            TabBtn.Font = Enum.Font.Gotham
            TabBtn.BorderSizePixel = 0
            TabBtn.Parent = self.TabContainer
            
            local btnCorner = Instance.new("UICorner", TabBtn)
            btnCorner.CornerRadius = UDim.new(0, 6)
            
            local Content = Instance.new("ScrollingFrame")
            Content.Name = name .. "Content"
            Content.Size = UDim2.new(1, 0, 1, 0)
            Content.BackgroundTransparency = 1
            Content.ScrollBarThickness = 4
            Content.ScrollBarImageColor3 = IS.CurrentTheme.Accent
            Content.BorderSizePixel = 0
            Content.Visible = false
            Content.Parent = self.ContentContainer
            
            local ContentList = Instance.new("UIListLayout")
            ContentList.SortOrder = Enum.SortOrder.LayoutOrder
            ContentList.Padding = UDim.new(0, 8)
            ContentList.Parent = Content
            
            local ContentPadding = Instance.new("UIPadding")
            ContentPadding.PaddingTop = UDim.new(0, 10)
            ContentPadding.PaddingLeft = UDim.new(0, 10)
            ContentPadding.PaddingRight = UDim.new(0, 10)
            ContentPadding.Parent = Content
            
            TabBtn.MouseButton1Click:Connect(function()
                for _, tab in pairs(self.Tabs) do
                    tab.Button.BackgroundColor3 = IS.CurrentTheme.Background
                    tab.Button.TextColor3 = IS.CurrentTheme.TextDark
                    tab.Content.Visible = false
                end
                
                TabBtn.BackgroundColor3 = IS.CurrentTheme.Accent
                TabBtn.TextColor3 = IS.CurrentTheme.Text
                Content.Visible = true
                self.CurrentTab = Tab
            end)
            
            Tab.Button = TabBtn
            Tab.Content = Content
            table.insert(self.Tabs, Tab)
            
            if #self.Tabs == 1 then
                TabBtn.BackgroundColor3 = IS.CurrentTheme.Accent
                TabBtn.TextColor3 = IS.CurrentTheme.Text
                Content.Visible = true
                self.CurrentTab = Tab
            end
        end)
        
        if not success then
            warn("[IS Library] Error al crear tab: " .. tostring(err))
            return nil
        end
        
        -- Sección
        function Tab:AddSection(name)
            pcall(function()
                local Section = Instance.new("Frame")
                Section.Size = UDim2.new(1, -10, 0, 30)
                Section.BackgroundTransparency = 1
                Section.Parent = self.Content
                
                local Line = Instance.new("Frame")
                Line.Size = UDim2.new(1, -80, 0, 2)
                Line.Position = UDim2.new(0, 0, 0.5, -1)
                Line.BackgroundColor3 = IS.CurrentTheme.Border
                Line.BorderSizePixel = 0
                Line.Parent = Section
                
                local SectionLabel = Instance.new("TextLabel")
                SectionLabel.Size = UDim2.new(0, 70, 1, 0)
                SectionLabel.Position = UDim2.new(1, -70, 0, 0)
                SectionLabel.BackgroundTransparency = 1
                SectionLabel.Text = name
                SectionLabel.TextColor3 = IS.CurrentTheme.Accent
                SectionLabel.TextSize = 13
                SectionLabel.Font = Enum.Font.GothamBold
                SectionLabel.Parent = Section
            end)
        end
        
        -- Toggle mejorado con keybind sync
        function Tab:AddToggle(config)
            local toggleState = config.Default or false
            local elementId = config.Id or config.Name
            
            pcall(function()
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
                ToggleFrame.BackgroundColor3 = IS.CurrentTheme.Secondary
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = self.Content
                
                local corner = Instance.new("UICorner", ToggleFrame)
                corner.CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -50, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = config.Name or "Toggle"
                Label.TextColor3 = IS.CurrentTheme.Text
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ToggleFrame
                
                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
                ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
                ToggleBtn.BackgroundColor3 = toggleState and IS.CurrentTheme.Accent or IS.CurrentTheme.Border
                ToggleBtn.Text = ""
                ToggleBtn.BorderSizePixel = 0
                ToggleBtn.Parent = ToggleFrame
                
                local toggleCorner = Instance.new("UICorner", ToggleBtn)
                toggleCorner.CornerRadius = UDim.new(1, 0)
                
                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 16, 0, 16)
                Indicator.Position = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Indicator.BackgroundColor3 = IS.CurrentTheme.Text
                Indicator.BorderSizePixel = 0
                Indicator.Parent = ToggleBtn
                
                local indCorner = Instance.new("UICorner", Indicator)
                indCorner.CornerRadius = UDim.new(1, 0)
                
                local function updateToggle(value)
                    toggleState = value
                    
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
                    if toggleState then
                        TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = IS.CurrentTheme.Accent}):Play()
                        TweenService:Create(Indicator, tweenInfo, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = IS.CurrentTheme.Border}):Play()
                        TweenService:Create(Indicator, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    
                    if config.Callback then
                        pcall(config.Callback, toggleState)
                    end
                    
                    Window.ConfigData[elementId] = toggleState
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    updateToggle(not toggleState)
                end)
                
                -- Registrar elemento para keybind sync
                Window.Elements[elementId] = {
                    Type = "Toggle",
                    Update = updateToggle,
                    GetValue = function() return toggleState end
                }
                
                if config.Default then
                    Window.ConfigData[elementId] = toggleState
                end
            end)
            
            return {
                SetValue = function(value)
                    if Window.Elements[elementId] then
                        Window.Elements[elementId].Update(value)
                    end
                end,
                GetValue = function()
                    return Window.Elements[elementId] and Window.Elements[elementId].GetValue() or false
                end
            }
        end
        
        -- Keybind Selector
        function Tab:AddKeybind(config)
            local selectedKey = config.Default or Enum.KeyCode.E
            local listening = false
            local elementId = config.Id or config.Name
            local linkedToggle = config.LinkedToggle
            
            pcall(function()
                local KeyFrame = Instance.new("Frame")
                KeyFrame.Size = UDim2.new(1, -10, 0, 35)
                KeyFrame.BackgroundColor3 = IS.CurrentTheme.Secondary
                KeyFrame.BorderSizePixel = 0
                KeyFrame.Parent = self.Content
                
                local corner = Instance.new("UICorner", KeyFrame)
                corner.CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -110, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = config.Name or "Keybind"
                Label.TextColor3 = IS.CurrentTheme.Text
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = KeyFrame
                
                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Size = UDim2.new(0, 95, 0, 25)
                KeyBtn.Position = UDim2.new(1, -100, 0.5, -12.5)
                KeyBtn.BackgroundColor3 = IS.CurrentTheme.Background
                KeyBtn.Text = selectedKey.Name
                KeyBtn.TextColor3 = IS.CurrentTheme.Accent
                KeyBtn.TextSize = 12
                KeyBtn.Font = Enum.Font.GothamBold
                KeyBtn.BorderSizePixel = 0
                KeyBtn.Parent = KeyFrame
                
                local keyCorner = Instance.new("UICorner", KeyBtn)
                keyCorner.CornerRadius = UDim.new(0, 6)
                
                local keyStroke = Instance.new("UIStroke", KeyBtn)
                keyStroke.Color = IS.CurrentTheme.Accent
                keyStroke.Thickness = 1
                
                KeyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KeyBtn.Text = "..."
                    keyStroke.Color = IS.CurrentTheme.Warning
                end)
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        selectedKey = input.KeyCode
                        KeyBtn.Text = selectedKey.Name
                        keyStroke.Color = IS.CurrentTheme.Accent
                        listening = false
                        
                        Window.ConfigData[elementId] = selectedKey.Name
                    end
                    
                    if not gameProcessed and input.KeyCode == selectedKey and not listening then
                        if linkedToggle and Window.Elements[linkedToggle] then
                            local currentValue = Window.Elements[linkedToggle].GetValue()
                            Window.Elements[linkedToggle].Update(not currentValue)
                        end
                        
                        if config.Callback then
                            pcall(config.Callback)
                        end
                    end
                end)
            end)
        end
        
        -- Button
        function Tab:AddButton(config)
            pcall(function()
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, -10, 0, 35)
                Button.BackgroundColor3 = IS.CurrentTheme.Accent
                Button.Text = config.Name or "Button"
                Button.TextColor3 = IS.CurrentTheme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.GothamBold
                Button.BorderSizePixel = 0
                Button.Parent = self.Content
                
                local corner = Instance.new("UICorner", Button)
                corner.CornerRadius = UDim.new(0, 6)
                
                Button.MouseButton1Click:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 30)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 35)}):Play()
                    
                    if config.Callback then
                        pcall(config.Callback)
                    end
                end)
            end)
        end
        
        -- Slider
        function Tab:AddSlider(config)
            local value = config.Default or config.Min or 0
            local elementId = config.Id or config.Name
            
            pcall(function()
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 50)
                SliderFrame.BackgroundColor3 = IS.CurrentTheme.Secondary
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = self.Content
                
                local corner = Instance.new("UICorner", SliderFrame)
                corner.CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 5)
                Label.BackgroundTransparency = 1
                Label.Text = config.Name or "Slider"
                Label.TextColor3 = IS.CurrentTheme.Text
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 50, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 5)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = IS.CurrentTheme.Accent
                ValueLabel.TextSize = 14
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -20, 0, 6)
                SliderBar.Position = UDim2.new(0, 10, 1, -15)
                SliderBar.BackgroundColor3 = IS.CurrentTheme.Border
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame
                
                local barCorner = Instance.new("UICorner", SliderBar)
                barCorner.CornerRadius = UDim.new(1, 0)
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.BackgroundColor3 = IS.CurrentTheme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                local fillCorner = Instance.new("UICorner", SliderFill)
                fillCorner.CornerRadius = UDim.new(1, 0)
                
                local function update(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    value = math.floor(config.Min + (config.Max - config.Min) * pos)
                    
                    ValueLabel.Text = tostring(value)
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    
                    if config.Callback then
                        pcall(config.Callback, value)
                    end
                    
                    Window.ConfigData[elementId] = value
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        update(input)
                    end
                end)
                
                SliderBar.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            update(input)
                        end
                    end
                end)
                
                local initialPos = (value - config.Min) / (config.Max - config.Min)
                SliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
                Window.ConfigData[elementId] = value
            end)
        end
        
        -- Dropdown mejorado con multi-select
        function Tab:AddDropdown(config)
            local selected = config.Default or (config.Multi and {} or config.Options[1])
            local elementId = config.Id or config.Name
            
            pcall(function()
                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, -10, 0, 35)
                DropFrame.BackgroundColor3 = IS.CurrentTheme.Secondary
                DropFrame.BorderSizePixel = 0
                DropFrame.Parent = self.Content
                DropFrame.ClipsDescendants = true
                
                local corner = Instance.new("UICorner", DropFrame)
                corner.CornerRadius = UDim.new(0, 6)
                
                local Header = Instance.new("TextButton")
                Header.Size = UDim2.new(1, 0, 0, 35)
                Header.BackgroundTransparency = 1
                Header.Text = ""
                Header.Parent = DropFrame
                
                local function getDisplayText()
                    if config.Multi then
                        return config.Name .. ": " .. (#selected > 0 and table.concat(selected, ", ") or "None")
                    else
                        return config.Name .. ": " .. selected
                    end
                end
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -40, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = getDisplayText()
                Label.TextColor3 = IS.CurrentTheme.Text
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextTruncate = Enum.TextTruncate.AtEnd
                Label.Parent = Header
                
                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 20, 0, 20)
                Arrow.Position = UDim2.new(1, -30, 0.5, -10)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "▼"
                Arrow.TextColor3 = IS.CurrentTheme.TextDark
                Arrow.TextSize = 12
                Arrow.Parent = Header
                
                local OptionContainer = Instance.new("Frame")
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionContainer.Position = UDim2.new(0, 0, 0, 35)
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.Parent = DropFrame
                
                local OptionList = Instance.new("UIListLayout")
                OptionList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionList.Parent = OptionContainer
                
                local isOpen = false
                
                for _, option in ipairs(config.Options) do
                    local OptionBtn = Instance.new("TextButton")
                    OptionBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptionBtn.BackgroundColor3 = IS.CurrentTheme.Background
                    OptionBtn.Text = ""
                    OptionBtn.BorderSizePixel = 0
                    OptionBtn.Parent = OptionContainer
                    
                    local optionLabel = Instance.new("TextLabel")
                    optionLabel.Size = UDim2.new(1, -40, 1, 0)
                    optionLabel.Position = UDim2.new(0, 10, 0, 0)
                    optionLabel.BackgroundTransparency = 1
                    optionLabel.Text = option
                    optionLabel.TextColor3 = IS.CurrentTheme.TextDark
                    optionLabel.TextSize = 13
                    optionLabel.Font = Enum.Font.Gotham
                    optionLabel.TextXAlignment = Enum.TextXAlignment.Left
                    optionLabel.Parent = OptionBtn
                    
                    if config.Multi then
                        local Checkbox = Instance.new("Frame")
                        Checkbox.Size = UDim2.new(0, 18, 0, 18)
                        Checkbox.Position = UDim2.new(1, -25, 0.5, -9)
                        Checkbox.BackgroundColor3 = IS.CurrentTheme.Border
                        Checkbox.BorderSizePixel = 0
                        Checkbox.Parent = OptionBtn
                        
                        local checkCorner = Instance.new("UICorner", Checkbox)
                        checkCorner.CornerRadius = UDim.new(0, 4)
                        
                        local Check = Instance.new("TextLabel")
                        Check.Size = UDim2.new(1, 0, 1, 0)
                        Check.BackgroundTransparency = 1
                        Check.Text = ""
                        Check.TextColor3 = IS.CurrentTheme.Text
                        Check.TextSize = 14
                        Check.Font = Enum.Font.GothamBold
                        Check.Parent = Checkbox
                        
                        local function updateCheckbox()
                            local isSelected = table.find(selected, option)
                            Checkbox.BackgroundColor3 = isSelected and IS.CurrentTheme.Accent or IS.CurrentTheme.Border
                            Check.Text = isSelected and "✓" or ""
                        end
                        
                        updateCheckbox()
                        
                        OptionBtn.MouseButton1Click:Connect(function()
                            local index = table.find(selected, option)
                            if index then
                                table.remove(selected, index)
                            else
                                table.insert(selected, option)
                            end
                            
                            updateCheckbox()
                            Label.Text = getDisplayText()
                            
                            if config.Callback then
                                pcall(config.Callback, selected)
                            end
                            
                            Window.ConfigData[elementId] = selected
                        end)
                    else
                        OptionBtn.MouseButton1Click:Connect(function()
                            selected = option
                            Label.Text = getDisplayText()
                            
                            if config.Callback then
                                pcall(config.Callback, selected)
                            end
                            
                            isOpen = false
                            TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                                Size = UDim2.new(1, -10, 0, 35)
                            }):Play()
                            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                            
                            Window.ConfigData[elementId] = selected
                        end)
                    end
                end
                
                Header.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local targetSize = isOpen and (35 + #config.Options * 30) or 35
                    
                    TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(1, -10, 0, targetSize)
                    }):Play()
                    
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = isOpen and 180 or 0}):Play()
                end)
                
                Window.ConfigData[elementId] = selected
            end)
        end
        
        -- TextBox/Input
        function Tab:AddTextbox(config)
            local currentText = config.Default or ""
            local elementId = config.Id or config.Name
            
            pcall(function()
                local TextFrame = Instance.new("Frame")
                TextFrame.Size = UDim2.new(1, -10, 0, 60)
                TextFrame.BackgroundColor3 = IS.CurrentTheme.Secondary
                TextFrame.BorderSizePixel = 0
                TextFrame.Parent = self.Content
                
                local corner = Instance.new("UICorner", TextFrame)
                corner.CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 5)
                Label.BackgroundTransparency = 1
                Label.Text = config.Name or "Textbox"
                Label.TextColor3 = IS.CurrentTheme.Text
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = TextFrame
                
                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, -20, 0, 28)
                InputBox.Position = UDim2.new(0, 10, 0, 27)
                InputBox.BackgroundColor3 = IS.CurrentTheme.Background
                InputBox.Text = currentText
                InputBox.PlaceholderText = config.Placeholder or "Enter text..."
                InputBox.TextColor3 = IS.CurrentTheme.Text
                InputBox.PlaceholderColor3 = IS.CurrentTheme.TextDark
                InputBox.TextSize = 13
                InputBox.Font = Enum.Font.Gotham
                InputBox.ClearTextOnFocus = false
                InputBox.BorderSizePixel = 0
                InputBox.Parent = TextFrame
                
                local inputCorner = Instance.new("UICorner", InputBox)
                inputCorner.CornerRadius = UDim.new(0, 6)
                
                local inputStroke = Instance.new("UIStroke", InputBox)
                inputStroke.Color = IS.CurrentTheme.Border
                inputStroke.Thickness = 1
                
                InputBox.Focused:Connect(function()
                    inputStroke.Color = IS.CurrentTheme.Accent
                end)
                
                InputBox.FocusLost:Connect(function(enterPressed)
                    inputStroke.Color = IS.CurrentTheme.Border
                    currentText = InputBox.Text
                    
                    if enterPressed and config.Callback then
                        pcall(config.Callback, currentText)
                    end
                    
                    Window.ConfigData[elementId] = currentText
                end)
                
                Window.ConfigData[elementId] = currentText
            end)
        end
        
        -- Label
        function Tab:AddLabel(text)
            pcall(function()
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -10, 0, 25)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = IS.CurrentTheme.TextDark
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = self.Content
            end)
        end
        
        return Tab
    end
    
    -- Sistema de configuración
    function Window:SaveConfig(configName)
        local success, err = pcall(function()
            IS:SaveConfig(configName, self.ConfigData)
            self:Notify("Éxito", "Configuración guardada: " .. configName, 3, "success")
        end)
        
        if not success then
            self:Notify("Error", "No se pudo guardar la configuración", 3, "error")
            warn("[IS Library] Error al guardar config: " .. tostring(err))
        end
    end
    
    function Window:LoadConfig(configName)
        local success, err = pcall(function()
            local data = IS:LoadConfig(configName)
            if data then
                for id, value in pairs(data) do
                    if self.Elements[id] then
                        self.Elements[id].Update(value)
                    end
                    self.ConfigData[id] = value
                end
                self:Notify("Éxito", "Configuración cargada: " .. configName, 3, "success")
            else
                self:Notify("Advertencia", "No se encontró la configuración", 3, "warning")
            end
        end)
        
        if not success then
            self:Notify("Error", "No se pudo cargar la configuración", 3, "error")
            warn("[IS Library] Error al cargar config: " .. tostring(err))
        end
    end
    
    -- Notificaciones
    function Window:Notify(title, message, duration, type)
        NotificationManager:Create(title, message, duration, type)
    end
    
    return Window
end

return IS
