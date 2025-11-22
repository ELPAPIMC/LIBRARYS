-- Paintball GUI Library v1.0
-- Sistema modular para crear GUIs personalizadas
-- Compatible con PC y Móvil

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}
Library.Tabs = {}
Library.ActiveTab = nil
Library.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Función para calcular tamaño responsivo
local function GetResponsiveSize()
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local isMobile = Library.IsMobile
    
    if isMobile then
        -- Móvil: GUI más grande y adaptable
        return {
            Width = math.min(ViewportSize.X * 0.95, 400),
            Height = math.min(ViewportSize.Y * 0.7, 500),
            HeaderHeight = 50,
            SidebarWidth = 120,
            ToggleHeight = 55,
            FontSizeTitle = 16,
            FontSizeLabel = 13,
            FontSizeValue = 12
        }
    else
        -- PC: GUI estándar
        return {
            Width = 550,
            Height = 400,
            HeaderHeight = 45,
            SidebarWidth = 150,
            ToggleHeight = 50,
            FontSizeTitle = 18,
            FontSizeLabel = 14,
            FontSizeValue = 11
        }
    end
end

function Library:CreateWindow(title)
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local sizes = GetResponsiveSize()
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PaintballLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = PlayerGui

    -- Botón flotante para abrir/cerrar
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "LibraryToggle"
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Position = UDim2.new(1, -80, 0, 100)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = "🎨"
    ToggleButton.TextSize = 28
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.AutoButtonColor = false
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    ToggleButton.Parent = ScreenGui

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton

    local ToggleShadow = Instance.new("UIStroke")
    ToggleShadow.Color = Color3.fromRGB(0, 0, 0)
    ToggleShadow.Thickness = 3
    ToggleShadow.Transparency = 0.7
    ToggleShadow.Parent = ToggleButton

    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, sizes.Width, 0, sizes.Height)
    MainFrame.Position = UDim2.new(0.5, -sizes.Width/2, 0.5, -sizes.Height/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Hacer el MainFrame arrastrable solo desde el header
    local dragging = false
    local dragInput, mousePos, framePos

    -- Sombra
    local Shadow = Instance.new("ImageLabel")
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxasset://textures/ui/GUI/ShadowTexture.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, sizes.HeaderHeight)
    Header.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header

    local HeaderCover = Instance.new("Frame")
    HeaderCover.Size = UDim2.new(1, 0, 0, 10)
    HeaderCover.Position = UDim2.new(0, 0, 1, -10)
    HeaderCover.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 105, 180)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = sizes.FontSizeTitle
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- Hacer header arrastrable
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)

    -- Botón cerrar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.3)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, sizes.Width, 0, sizes.Height)
    end)

    -- Container de tabs
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -sizes.HeaderHeight)
    TabContainer.Position = UDim2.new(0, 0, 0, sizes.HeaderHeight)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, sizes.SidebarWidth, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = TabContainer

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 5)
    SidebarList.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 5)
    SidebarPadding.Parent = Sidebar

    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -sizes.SidebarWidth, 1, 0)
    ContentArea.Position = UDim2.new(0, sizes.SidebarWidth, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = TabContainer

    -- Toggle button funcionalidad
    local guiOpen = false
    ToggleButton.MouseButton1Click:Connect(function()
        guiOpen = not guiOpen
        
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        if guiOpen then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, sizes.Width, 0, sizes.Height)}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
            wait(0.3)
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0, sizes.Width, 0, sizes.Height)
        end
    end)

    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame
    self.Sidebar = Sidebar
    self.ContentArea = ContentArea
    self.Sizes = sizes

    return self
end

function Library:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Elements = {}
    local sizes = self.Sizes
    
    -- Botón de tab
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
    TabButton.BorderSizePixel = 0
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = sizes.FontSizeLabel
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.Sidebar

    -- Container de contenido
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
    TabContent.Visible = false
    TabContent.Parent = self.ContentArea

    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = TabContent

    -- Auto-ajustar tamaño del canvas
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
    end)

    TabButton.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.Tabs) do
            otherTab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
            otherTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            otherTab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        self.ActiveTab = tab
    end)

    tab.Button = TabButton
    tab.Content = TabContent
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        self.ActiveTab = tab
    end

    return tab
end

function Library:CreateToggle(tab, name, config, callback)
    local sizes = self.Sizes
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(1, 0, 0, sizes.ToggleHeight)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tab.Content

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = toggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -120, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = sizes.FontSizeLabel
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = toggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 24)
    ToggleButton.Position = UDim2.new(1, -100, 0.5, -12)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = toggleFrame

    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, 3, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = ToggleButton

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local SettingsButton = Instance.new("TextButton")
    SettingsButton.Size = UDim2.new(0, 35, 0, 35)
    SettingsButton.Position = UDim2.new(1, -45, 0.5, -17.5)
    SettingsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SettingsButton.BorderSizePixel = 0
    SettingsButton.Text = "⚙️"
    SettingsButton.TextSize = 16
    SettingsButton.AutoButtonColor = false
    SettingsButton.Parent = toggleFrame

    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 8)
    SettingsCorner.Parent = SettingsButton

    local isEnabled = false

    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        config.Enabled = isEnabled
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if isEnabled then
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        
        if callback then callback(isEnabled) end
    end)

    if config.Settings then
        local SettingsPanel = Instance.new("Frame")
        SettingsPanel.Name = "SettingsPanel"
        SettingsPanel.Size = UDim2.new(1, 0, 0, 0)
        SettingsPanel.Position = UDim2.new(0, 0, 1, 5)
        SettingsPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        SettingsPanel.BorderSizePixel = 0
        SettingsPanel.ClipsDescendants = true
        SettingsPanel.Visible = false
        SettingsPanel.Parent = toggleFrame

        local SettingsPanelCorner = Instance.new("UICorner")
        SettingsPanelCorner.CornerRadius = UDim.new(0, 8)
        SettingsPanelCorner.Parent = SettingsPanel

        local SettingsList = Instance.new("UIListLayout")
        SettingsList.Padding = UDim.new(0, 8)
        SettingsList.Parent = SettingsPanel

        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingTop = UDim.new(0, 10)
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingRight = UDim.new(0, 10)
        UIPadding.PaddingBottom = UDim.new(0, 10)
        UIPadding.Parent = SettingsPanel

        local settingsOpen = false
        local totalHeight = 20

        for _, setting in ipairs(config.Settings) do
            if setting.Type == "Slider" then
                totalHeight = totalHeight + 68
                self:CreateSlider(SettingsPanel, setting.Name, setting.Min, setting.Max, setting.Default, setting.Suffix, config)
            elseif setting.Type == "Toggle" then
                totalHeight = totalHeight + 48
                self:CreateMiniToggle(SettingsPanel, setting.Name, setting.Warning, config, setting.ConfigKey)
            end
        end

        SettingsButton.MouseButton1Click:Connect(function()
            settingsOpen = not settingsOpen
            
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            if settingsOpen then
                SettingsPanel.Visible = true
                toggleFrame.Size = UDim2.new(1, 0, 0, sizes.ToggleHeight)
                TweenService:Create(toggleFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, sizes.ToggleHeight + totalHeight)}):Play()
                TweenService:Create(SettingsPanel, tweenInfo, {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                TweenService:Create(SettingsButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
            else
                TweenService:Create(toggleFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, sizes.ToggleHeight)}):Play()
                TweenService:Create(SettingsPanel, tweenInfo, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                TweenService:Create(SettingsButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                wait(0.3)
                SettingsPanel.Visible = false
            end
        end)
    end

    return toggleFrame
end

function Library:CreateSlider(parent, name, min, max, default, suffix, config)
    local sizes = self.Sizes
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 18)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name
    SliderLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    SliderLabel.Font = Enum.Font.GothamBold
    SliderLabel.TextSize = sizes.FontSizeValue
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 18)
    ValueLabel.Position = UDim2.new(1, -60, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = default .. suffix
    ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.TextSize = sizes.FontSizeValue
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, 0, 0, 8)
    SliderBG.Position = UDim2.new(0, 0, 0, 26)
    SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame

    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(1, 0)
    SliderBGCorner.Parent = SliderBG

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBG

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 18, 0, 18)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    SliderButton.Parent = SliderBG

    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(1, 0)
    SliderButtonCorner.Parent = SliderButton

    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderButton.Position = UDim2.new(pos, -9, 0.5, -9)
        ValueLabel.Text = value .. suffix
        
        if name:find("Velocidad") then
            config.FireRate = value / 100
        elseif name:find("Distancia") then
            config.MaxDistance = value
        end
        
        return value
    end

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
        end
    end)

    return SliderFrame
end

function Library:CreateMiniToggle(parent, name, warning, config, configKey)
    local sizes = self.Sizes
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "MiniToggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 105, 180)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = sizes.FontSizeValue
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    if warning then
        local WarningLabel = Instance.new("TextLabel")
        WarningLabel.Size = UDim2.new(1, 0, 0, 15)
        WarningLabel.Position = UDim2.new(0, 0, 0, 20)
        WarningLabel.BackgroundTransparency = 1
        WarningLabel.Text = warning
        WarningLabel.TextColor3 = Color3.fromRGB(255, 180, 80)
        WarningLabel.Font = Enum.Font.Gotham
        WarningLabel.TextSize = 9
        WarningLabel.TextXAlignment = Enum.TextXAlignment.Left
        WarningLabel.Parent = ToggleFrame
    end

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 45, 0, 22)
    Toggle.Position = UDim2.new(1, -45, 0, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Toggle.BorderSizePixel = 0
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 3, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    Toggle.MouseButton1Click:Connect(function()
        config[configKey] = not config[configKey]
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if config[configKey] then
            TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Toggle, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Knob, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
    end)

    return ToggleFrame
end

return Library
