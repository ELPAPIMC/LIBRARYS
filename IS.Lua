-- IS Library v1.0
-- Biblioteca UI moderna para Roblox con sistema de temas y animaciones

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local IS = {}
IS.__index = IS

-- Temas predefinidos
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
        Warning = Color3.fromRGB(250, 166, 26)
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
        Warning = Color3.fromRGB(250, 166, 26)
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
        Warning = Color3.fromRGB(241, 196, 15)
    }
}

-- Sistema de notificaciones
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
        
        local corner = Instance.new("UICorner", notif)
        corner.CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", notif)
        stroke.Color = type == "success" and IS.CurrentTheme.Success or 
                      type == "error" and IS.CurrentTheme.Error or 
                      type == "warning" and IS.CurrentTheme.Warning or IS.CurrentTheme.Accent
        stroke.Thickness = 2
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -20, 0, 25)
        titleLabel.Position = UDim2.new(0, 10, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = IS.CurrentTheme.Text
        titleLabel.TextSize = 16
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notif
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Name = "Message"
        msgLabel.Size = UDim2.new(1, -20, 0, 40)
        msgLabel.Position = UDim2.new(0, 10, 0, 35)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = message
        msgLabel.TextColor3 = IS.CurrentTheme.TextDark
        msgLabel.TextSize = 14
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextWrapped = true
        msgLabel.Parent = notif
        
        notif.Parent = IS.ScreenGui
        
        table.insert(self.Notifications, notif)
        self:UpdatePositions()
        
        -- Animación de entrada
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 300, 0, 85)
        }):Play()
        
        -- Auto-destrucción
        task.delay(duration or 3, function()
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

-- Constructor principal
function IS:CreateWindow(config)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Keybinds = {}
    
    -- Aplicar tema
    IS.CurrentTheme = IS.Themes[config.Theme or "Dark"]
    
    -- Manejo de errores
    local success, err = pcall(function()
        -- ScreenGui principal
        IS.ScreenGui = Instance.new("ScreenGui")
        IS.ScreenGui.Name = "ISLibrary"
        IS.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        IS.ScreenGui.ResetOnSpawn = false
        IS.ScreenGui.Parent = CoreGui
        
        -- Frame principal
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 600, 0, 400)
        MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
        MainFrame.BackgroundColor3 = IS.CurrentTheme.Background
        MainFrame.BorderSizePixel = 0
        MainFrame.Active = true
        MainFrame.Draggable = true
        MainFrame.Parent = IS.ScreenGui
        
        local corner = Instance.new("UICorner", MainFrame)
        corner.CornerRadius = UDim.new(0, 10)
        
        -- Header
        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, 0, 0, 40)
        Header.BackgroundColor3 = IS.CurrentTheme.Secondary
        Header.BorderSizePixel = 0
        Header.Parent = MainFrame
        
        local headerCorner = Instance.new("UICorner", Header)
        headerCorner.CornerRadius = UDim.new(0, 10)
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -100, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = config.Name or "IS Library"
        Title.TextColor3 = IS.CurrentTheme.Text
        Title.TextSize = 18
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Header
        
        -- Botón cerrar
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Name = "Close"
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -35, 0, 5)
        CloseBtn.BackgroundColor3 = IS.CurrentTheme.Error
        CloseBtn.Text = "×"
        CloseBtn.TextColor3 = Color3.new(1, 1, 1)
        CloseBtn.TextSize = 20
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.BorderSizePixel = 0
        CloseBtn.Parent = Header
        
        local closeCorner = Instance.new("UICorner", CloseBtn)
        closeCorner.CornerRadius = UDim.new(0, 6)
        
        CloseBtn.MouseButton1Click:Connect(function()
            IS.ScreenGui:Destroy()
        end)
        
        -- Tab container
        local TabContainer = Instance.new("Frame")
        TabContainer.Name = "TabContainer"
        TabContainer.Size = UDim2.new(0, 150, 1, -50)
        TabContainer.Position = UDim2.new(0, 10, 0, 45)
        TabContainer.BackgroundColor3 = IS.CurrentTheme.Secondary
        TabContainer.BorderSizePixel = 0
        TabContainer.Parent = MainFrame
        
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
        ContentContainer.Size = UDim2.new(1, -180, 1, -50)
        ContentContainer.Position = UDim2.new(0, 170, 0, 45)
        ContentContainer.BackgroundTransparency = 1
        ContentContainer.Parent = MainFrame
        
        Window.MainFrame = MainFrame
        Window.TabContainer = TabContainer
        Window.ContentContainer = ContentContainer
    end)
    
    if not success then
        warn("[IS Library] Error al crear ventana: " .. tostring(err))
        return nil
    end
    
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
            TabBtn.TextSize = 14
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
        
        -- Toggle
        function Tab:AddToggle(config)
            local toggle = false
            
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
                ToggleBtn.BackgroundColor3 = IS.CurrentTheme.Border
                ToggleBtn.Text = ""
                ToggleBtn.BorderSizePixel = 0
                ToggleBtn.Parent = ToggleFrame
                
                local toggleCorner = Instance.new("UICorner", ToggleBtn)
                toggleCorner.CornerRadius = UDim.new(1, 0)
                
                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 16, 0, 16)
                Indicator.Position = UDim2.new(0, 2, 0.5, -8)
                Indicator.BackgroundColor3 = IS.CurrentTheme.Text
                Indicator.BorderSizePixel = 0
                Indicator.Parent = ToggleBtn
                
                local indCorner = Instance.new("UICorner", Indicator)
                indCorner.CornerRadius = UDim.new(1, 0)
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    toggle = not toggle
                    
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
                    if toggle then
                        TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = IS.CurrentTheme.Accent}):Play()
                        TweenService:Create(Indicator, tweenInfo, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = IS.CurrentTheme.Border}):Play()
                        TweenService:Create(Indicator, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    
                    if config.Callback then
                        pcall(config.Callback, toggle)
                    end
                end)
                
                if config.Default then
                    ToggleBtn.BackgroundColor3 = IS.CurrentTheme.Accent
                    Indicator.Position = UDim2.new(1, -18, 0.5, -8)
                    toggle = true
                end
            end)
            
            return {
                SetValue = function(value)
                    toggle = value
                end
            }
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
            
            pcall(function()
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, -10, 0, 50)
                SliderFrame.BackgroundColor3 = IS.CurrentTheme.Secondary
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = self.Content
                
                local corner = Instance.new("UICorner", SliderFrame)
                corner.CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 0, 20)
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
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        update(input)
                        local move, release
                        move = input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                move:Disconnect()
                            end
                        end)
                        release = UserInputService.InputEnded:Connect(function(i)
                            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                                release:Disconnect()
                            end
                        end)
                    end
                end)
                
                SliderBar.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            update(input)
                        end
                    end
                end)
                
                -- Valor inicial
                local initialPos = (value - config.Min) / (config.Max - config.Min)
                SliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
            end)
        end
        
        -- Dropdown
        function Tab:AddDropdown(config)
            local selected = config.Default or config.Options[1]
            
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
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -40, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = config.Name .. ": " .. selected
                Label.TextColor3 = IS.CurrentTheme.Text
                Label.TextSize = 14
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
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
                    OptionBtn.Text = option
                    OptionBtn.TextColor3 = IS.CurrentTheme.TextDark
                    OptionBtn.TextSize = 13
                    OptionBtn.Font = Enum.Font.Gotham
                    OptionBtn.BorderSizePixel = 0
                    OptionBtn.Parent = OptionContainer
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        selected = option
                        Label.Text = config.Name .. ": " .. selected
                        
                        if config.Callback then
                            pcall(config.Callback, selected)
                        end
                        
                        isOpen = false
                        TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, -10, 0, 35)
                        }):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    end)
                end
                
                Header.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    local targetSize = isOpen and (35 + #config.Options * 30) or 35
                    
                    TweenService:Create(DropFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(1, -10, 0, targetSize)
                    }):Play()
                    
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = isOpen and 180 or 0}):Play()
                end)
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
                Label.Parent = self.Content
            end)
        end
        
        return Tab
    end
    
    -- Keybind global
    function Window:AddKeybind(key, callback)
        pcall(function()
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == key then
                    pcall(callback)
                end
            end)
        end)
    end
    
    -- Notificaciones
    function Window:Notify(title, message, duration, type)
        NotificationManager:Create(title, message, duration, type)
    end
    
    return Window
end

return IS
