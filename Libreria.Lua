-- Librería UI Completa para Roblox
-- Autor: Assistant
-- Versión: 1.0

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuración por defecto
Library.Config = {
    MainColor = Color3.fromRGB(45, 45, 45),
    AccentColor = Color3.fromRGB(85, 170, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    BorderColor = Color3.fromRGB(60, 60, 60),
    AnimationSpeed = 0.3,
    Font = Enum.Font.Gotham
}

-- Utilidades
local function CreateTween(object, info, properties)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

local function RoundFrame(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = frame
    return corner
end

local function AddStroke(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Library.Config.BorderColor
    stroke.Thickness = thickness or 1
    stroke.Parent = frame
    return stroke
end

-- Crear ventana principal
function Library:CreateWindow(title, size)
    local window = {}
    
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibrary"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = size or UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Library.Config.MainColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    RoundFrame(mainFrame, 8)
    AddStroke(mainFrame, Library.Config.BorderColor, 2)
    
    -- Hacer la ventana arrastrable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "UI Library"
    titleLabel.TextColor3 = Library.Config.TextColor
    titleLabel.TextSize = 16
    titleLabel.Font = Library.Config.Font
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = mainFrame
    
    -- Contenedor de tabs
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -40)
    tabContainer.Position = UDim2.new(0, 10, 0, 35)
    tabContainer.BackgroundColor3 = Library.Config.BackgroundColor
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    RoundFrame(tabContainer, 6)
    AddStroke(tabContainer)
    
    -- Lista de tabs
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 2)
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingAll = UDim.new(0, 5)
    tabPadding.Parent = tabContainer
    
    -- Contenedor de contenido
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -150, 1, -40)
    contentContainer.Position = UDim2.new(0, 140, 0, 35)
    contentContainer.BackgroundColor3 = Library.Config.BackgroundColor
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame
    
    RoundFrame(contentContainer, 6)
    AddStroke(contentContainer)
    
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.ContentContainer = contentContainer
    window.Tabs = {}
    window.CurrentTab = nil
    
    -- Crear tab
    function window:CreateTab(name)
        local tab = {}
        
        -- Botón del tab
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.BackgroundColor3 = Library.Config.MainColor
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = Library.Config.TextColor
        tabButton.TextSize = 14
        tabButton.Font = Library.Config.Font
        tabButton.Parent = self.TabContainer
        
        RoundFrame(tabButton, 4)
        
        -- Contenido del tab
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, -10, 1, -10)
        tabContent.Position = UDim2.new(0, 5, 0, 5)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = Library.Config.AccentColor
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = self.ContentContainer
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabContent
        
        local tabPadding = Instance.new("UIPadding")
        tabPadding.PaddingAll = UDim.new(0, 10)
        tabPadding.Parent = tabContent
        
        -- Actualizar tamaño del canvas
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Función para activar tab
        local function ActivateTab()
            for _, t in pairs(self.Tabs) do
                t.Button.BackgroundColor3 = Library.Config.MainColor
                t.Content.Visible = false
            end
            
            tabButton.BackgroundColor3 = Library.Config.AccentColor
            tabContent.Visible = true
            self.CurrentTab = tab
        end
        
        tabButton.MouseButton1Click:Connect(ActivateTab)
        
        -- Efectos hover
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                CreateTween(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                CreateTween(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Library.Config.MainColor})
            end
        end)
        
        tab.Button = tabButton
        tab.Content = tabContent
        tab.Layout = tabLayout
        
        -- Si es el primer tab, activarlo
        if #self.Tabs == 0 then
            ActivateTab()
        end
        
        table.insert(self.Tabs, tab)
        
        -- Crear sección
        function tab:CreateSection(name)
            local section = {}
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name .. "Section"
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundColor3 = Library.Config.MainColor
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = tabContent
            
            RoundFrame(sectionFrame, 6)
            AddStroke(sectionFrame)
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, -20, 0, 25)
            sectionTitle.Position = UDim2.new(0, 10, 0, 5)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = Library.Config.AccentColor
            sectionTitle.TextSize = 14
            sectionTitle.Font = Library.Config.Font
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = sectionFrame
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 5)
            sectionLayout.Parent = sectionFrame
            
            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingAll = UDim.new(0, 10)
            sectionPadding.PaddingTop = UDim.new(0, 30)
            sectionPadding.Parent = sectionFrame
            
            -- Actualizar tamaño de la sección
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionFrame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 40)
            end)
            
            section.Frame = sectionFrame
            section.Layout = sectionLayout
            
            -- Crear botón
            function section:CreateButton(name, callback)
                local button = Instance.new("TextButton")
                button.Name = name .. "Button"
                button.Size = UDim2.new(1, 0, 0, 30)
                button.BackgroundColor3 = Library.Config.BackgroundColor
                button.BorderSizePixel = 0
                button.Text = name
                button.TextColor3 = Library.Config.TextColor
                button.TextSize = 13
                button.Font = Library.Config.Font
                button.Parent = sectionFrame
                
                RoundFrame(button, 4)
                AddStroke(button)
                
                button.MouseButton1Click:Connect(function()
                    CreateTween(button, TweenInfo.new(0.1), {BackgroundColor3 = Library.Config.AccentColor})
                    wait(0.1)
                    CreateTween(button, TweenInfo.new(0.1), {BackgroundColor3 = Library.Config.BackgroundColor})
                    
                    if callback then
                        callback()
                    end
                end)
                
                button.MouseEnter:Connect(function()
                    CreateTween(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                end)
                
                button.MouseLeave:Connect(function()
                    CreateTween(button, TweenInfo.new(0.2), {BackgroundColor3 = Library.Config.BackgroundColor})
                end)
                
                return button
            end
            
            -- Crear toggle
            function section:CreateToggle(name, default, callback)
                local toggle = {}
                local isToggled = default or false
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = name .. "Toggle"
                toggleFrame.Size = UDim2.new(1, 0, 0, 35)
                toggleFrame.BackgroundColor3 = Library.Config.BackgroundColor
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Parent = sectionFrame
                
                RoundFrame(toggleFrame, 4)
                AddStroke(toggleFrame)
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Size = UDim2.new(1, -50, 1, 0)
                toggleLabel.Position = UDim2.new(0, 10, 0, 0)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = name
                toggleLabel.TextColor3 = Library.Config.TextColor
                toggleLabel.TextSize = 13
                toggleLabel.Font = Library.Config.Font
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggleFrame
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(0, 40, 0, 20)
                toggleButton.Position = UDim2.new(1, -45, 0.5, -10)
                toggleButton.BackgroundColor3 = isToggled and Library.Config.AccentColor or Color3.fromRGB(60, 60, 60)
                toggleButton.BorderSizePixel = 0
                toggleButton.Text = ""
                toggleButton.Parent = toggleFrame
                
                RoundFrame(toggleButton, 10)
                
                local toggleIndicator = Instance.new("Frame")
                toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
                toggleIndicator.Position = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleIndicator.BorderSizePixel = 0
                toggleIndicator.Parent = toggleButton
                
                RoundFrame(toggleIndicator, 8)
                
                local function UpdateToggle()
                    CreateTween(toggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = isToggled and Library.Config.AccentColor or Color3.fromRGB(60, 60, 60)
                    })
                    CreateTween(toggleIndicator, TweenInfo.new(0.2), {
                        Position = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    })
                    
                    if callback then
                        callback(isToggled)
                    end
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    UpdateToggle()
                end)
                
                toggle.SetValue = function(value)
                    isToggled = value
                    UpdateToggle()
                end
                
                toggle.GetValue = function()
                    return isToggled
                end
                
                return toggle
            end
            
            -- Crear slider
            function section:CreateSlider(name, min, max, default, callback)
                local slider = {}
                local value = default or min
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = name .. "Slider"
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                sliderFrame.BackgroundColor3 = Library.Config.BackgroundColor
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Parent = sectionFrame
                
                RoundFrame(sliderFrame, 4)
                AddStroke(sliderFrame)
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
                sliderLabel.Position = UDim2.new(0, 10, 0, 5)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = name
                sliderLabel.TextColor3 = Library.Config.TextColor
                sliderLabel.TextSize = 13
                sliderLabel.Font = Library.Config.Font
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = sliderFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
                valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(value)
                valueLabel.TextColor3 = Library.Config.AccentColor
                valueLabel.TextSize = 13
                valueLabel.Font = Library.Config.Font
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sliderFrame
                
                local sliderTrack = Instance.new("Frame")
                sliderTrack.Size = UDim2.new(1, -20, 0, 4)
                sliderTrack.Position = UDim2.new(0, 10, 1, -15)
                sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                sliderTrack.BorderSizePixel = 0
                sliderTrack.Parent = sliderFrame
                
                RoundFrame(sliderTrack, 2)
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                sliderFill.Position = UDim2.new(0, 0, 0, 0)
                sliderFill.BackgroundColor3 = Library.Config.AccentColor
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderTrack
                
                RoundFrame(sliderFill, 2)
                
                local sliderHandle = Instance.new("Frame")
                sliderHandle.Size = UDim2.new(0, 12, 0, 12)
                sliderHandle.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
                sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderHandle.BorderSizePixel = 0
                sliderHandle.Parent = sliderTrack
                
                RoundFrame(sliderHandle, 6)
                
                local dragging = false
                
                local function UpdateSlider(newValue)
                    value = math.clamp(newValue, min, max)
                    local percentage = (value - min) / (max - min)
                    
                    CreateTween(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)})
                    CreateTween(sliderHandle, TweenInfo.new(0.1), {Position = UDim2.new(percentage, -6, 0.5, -6)})
                    
                    valueLabel.Text = tostring(math.floor(value))
                    
                    if callback then
                        callback(value)
                    end
                end
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local mousePos = input.Position.X
                        local framePos = sliderTrack.AbsolutePosition.X
                        local frameSize = sliderTrack.AbsoluteSize.X
                        local percentage = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                        local newValue = min + (max - min) * percentage
                        UpdateSlider(newValue)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = input.Position.X
                        local framePos = sliderTrack.AbsolutePosition.X
                        local frameSize = sliderTrack.AbsoluteSize.X
                        local percentage = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                        local newValue = min + (max - min) * percentage
                        UpdateSlider(newValue)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                slider.SetValue = function(newValue)
                    UpdateSlider(newValue)
                end
                
                slider.GetValue = function()
                    return value
                end
                
                return slider
            end
            
            -- Crear dropdown
            function section:CreateDropdown(name, options, default, callback)
                local dropdown = {}
                local selectedOption = default or options[1]
                local isOpen = false
                
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = name .. "Dropdown"
                dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                dropdownFrame.BackgroundColor3 = Library.Config.BackgroundColor
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.Parent = sectionFrame
                
                RoundFrame(dropdownFrame, 4)
                AddStroke(dropdownFrame)
                
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
                dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Text = name
                dropdownLabel.TextColor3 = Library.Config.TextColor
                dropdownLabel.TextSize = 13
                dropdownLabel.Font = Library.Config.Font
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownLabel.Parent = dropdownFrame
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Size = UDim2.new(0.5, -10, 0, 25)
                dropdownButton.Position = UDim2.new(0.5, 0, 0.5, -12.5)
                dropdownButton.BackgroundColor3 = Library.Config.MainColor
                dropdownButton.BorderSizePixel = 0
                dropdownButton.Text = selectedOption .. " ▼"
                dropdownButton.TextColor3 = Library.Config.TextColor
                dropdownButton.TextSize = 12
                dropdownButton.Font = Library.Config.Font
                dropdownButton.Parent = dropdownFrame
                
                RoundFrame(dropdownButton, 4)
                
                local optionsFrame = Instance.new("Frame")
                optionsFrame.Name = "Options"
                optionsFrame.Size = UDim2.new(1, 0, 0, #options * 25)
                optionsFrame.Position = UDim2.new(0, 0, 1, 5)
                optionsFrame.BackgroundColor3 = Library.Config.MainColor
                optionsFrame.BorderSizePixel = 0
                optionsFrame.Visible = false
                optionsFrame.ZIndex = 10
                optionsFrame.Parent = dropdownFrame
                
                RoundFrame(optionsFrame, 4)
                AddStroke(optionsFrame)
                
                local optionsLayout = Instance.new("UIListLayout")
                optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                optionsLayout.Parent = optionsFrame
                
                for i, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, 0, 0, 25)
                    optionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
                    optionButton.BorderSizePixel = 0
                    optionButton.Text = option
                    optionButton.TextColor3 = Library.Config.TextColor
                    optionButton.TextSize = 12
                    optionButton.Font = Library.Config.Font
                    optionButton.Parent = optionsFrame
                    
                    optionButton.MouseEnter:Connect(function()
                        optionButton.BackgroundColor3 = Library.Config.AccentColor
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        optionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        dropdownButton.Text = option .. " ▼"
                        optionsFrame.Visible = false
                        isOpen = false
                        
                        CreateTween(dropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)})
                        
                        if callback then
                            callback(option)
                        end
                    end)
                end
                
                dropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    optionsFrame.Visible = isOpen
                    
                    if isOpen then
                        CreateTween(dropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35 + #options * 25 + 5)})
                    else
                        CreateTween(dropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)})
                    end
                end)
                
                dropdown.SetValue = function(value)
                    selectedOption = value
                    dropdownButton.Text = value .. " ▼"
                    if callback then
                        callback(value)
                    end
                end
                
                dropdown.GetValue = function()
                    return selectedOption
                end
                
                return dropdown
            end
            
            -- Crear keybind
            function section:CreateKeybind(name, default, callback)
                local keybind = {}
                local currentKey = default
                local listening = false
                
                local keybindFrame = Instance.new("Frame")
                keybindFrame.Name = name .. "Keybind"
                keybindFrame.Size = UDim2.new(1, 0, 0, 35)
                keybindFrame.BackgroundColor3 = Library.Config.BackgroundColor
                keybindFrame.BorderSizePixel = 0
                keybindFrame.Parent = sectionFrame
                
                RoundFrame(keybindFrame, 4)
                AddStroke(keybindFrame)
                
                local keybindLabel = Instance.new("TextLabel")
                keybindLabel.Size = UDim2.new(0.6, 0, 1, 0)
                keybindLabel.Position = UDim2.new(0, 10, 0, 0)
                keybindLabel.BackgroundTransparency = 1
                keybindLabel.Text = name
                keybindLabel.TextColor3 = Library.Config.TextColor
                keybindLabel.TextSize = 13
                keybindLabel.Font = Library.Config.Font
                keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                keybindLabel.Parent = keybindFrame
                
                local keybindButton = Instance.new("TextButton")
                keybindButton.Size = UDim2.new(0.4, -10, 0, 25)
                keybindButton.Position = UDim2.new(0.6, 0, 0.5, -12.5)
                keybindButton.BackgroundColor3 = Library.Config.MainColor
                keybindButton.BorderSizePixel = 0
                keybindButton.Text = currentKey and currentKey.Name or "None"
                keybindButton.TextColor3 = Library.Config.TextColor
                keybindButton.TextSize = 12
                keybindButton.Font = Library.Config.Font
                keybindButton.Parent = keybindFrame
                
                RoundFrame(keybindButton, 4)
                
                keybindButton.MouseButton1Click:Connect(function()
                    if listening then return end
                    
                    listening = true
                    keybindButton.Text = "Press a key..."
                    keybindButton.BackgroundColor3 = Library.Config.AccentColor
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            keybindButton.Text = input.KeyCode.Name
                            keybindButton.BackgroundColor3 = Library.Config.MainColor
                            listening = false
                            connection:Disconnect()
                        end
                    end)
                end)
                
                -- Detectar cuando se presiona la tecla
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed or not currentKey then return end
                    
                    if input.KeyCode == currentKey then
                        if callback then
                            callback()
                        end
                    end
                end)
                
                keybind.SetKey = function(key)
                    currentKey = key
                    keybindButton.Text = key and key.Name or "None"
                end
                
                keybind.GetKey = function()
                    return currentKey
                end
                
                return keybind
            end
            
            -- Crear color picker
            function section:CreateColorPicker(name, default, callback)
                local colorPicker = {}
                local currentColor = default or Color3.fromRGB(255, 255, 255)
                local isOpen = false
                
                local colorFrame = Instance.new("Frame")
                colorFrame.Name = name .. "ColorPicker"
                colorFrame.Size = UDim2.new(1, 0, 0, 35)
                colorFrame.BackgroundColor3 = Library.Config.BackgroundColor
                colorFrame.BorderSizePixel = 0
                colorFrame.Parent = sectionFrame
                
                RoundFrame(colorFrame, 4)
                AddStroke(colorFrame)
                
                local colorLabel = Instance.new("TextLabel")
                colorLabel.Size = UDim2.new(0.7, 0, 1, 0)
                colorLabel.Position = UDim2.new(0, 10, 0, 0)
                colorLabel.BackgroundTransparency = 1
                colorLabel.Text = name
                colorLabel.TextColor3 = Library.Config.TextColor
                colorLabel.TextSize = 13
                colorLabel.Font = Library.Config.Font
                colorLabel.TextXAlignment = Enum.TextXAlignment.Left
                colorLabel.Parent = colorFrame
                
                local colorDisplay = Instance.new("TextButton")
                colorDisplay.Size = UDim2.new(0, 60, 0, 25)
                colorDisplay.Position = UDim2.new(1, -70, 0.5, -12.5)
                colorDisplay.BackgroundColor3 = currentColor
                colorDisplay.BorderSizePixel = 0
                colorDisplay.Text = ""
                colorDisplay.Parent = colorFrame
                
                RoundFrame(colorDisplay, 4)
                AddStroke(colorDisplay, Color3.fromRGB(255, 255, 255), 1)
                
                -- Panel del color picker
                local pickerPanel = Instance.new("Frame")
                pickerPanel.Name = "PickerPanel"
                pickerPanel.Size = UDim2.new(0, 200, 0, 150)
                pickerPanel.Position = UDim2.new(1, -200, 1, 5)
                pickerPanel.BackgroundColor3 = Library.Config.MainColor
                pickerPanel.BorderSizePixel = 0
                pickerPanel.Visible = false
                pickerPanel.ZIndex = 10
                pickerPanel.Parent = colorFrame
                
                RoundFrame(pickerPanel, 6)
                AddStroke(pickerPanel)
                
                -- Área de selección de color
                local colorArea = Instance.new("Frame")
                colorArea.Size = UDim2.new(1, -20, 0, 100)
                colorArea.Position = UDim2.new(0, 10, 0, 10)
                colorArea.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                colorArea.BorderSizePixel = 0
                colorArea.Parent = pickerPanel
                
                RoundFrame(colorArea, 4)
                
                -- Gradiente de saturación
                local saturationGradient = Instance.new("Frame")
                saturationGradient.Size = UDim2.new(1, 0, 1, 0)
                saturationGradient.BackgroundTransparency = 1
                saturationGradient.Parent = colorArea
                
                local satGradient = Instance.new("UIGradient")
                satGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                }
                satGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                satGradient.Parent = saturationGradient
                
                -- Gradiente de brillo
                local brightnessGradient = Instance.new("Frame")
                brightnessGradient.Size = UDim2.new(1, 0, 1, 0)
                brightnessGradient.BackgroundTransparency = 1
                brightnessGradient.Parent = saturationGradient
                
                local brightGradient = Instance.new("UIGradient")
                brightGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                }
                brightGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                brightGradient.Rotation = 90
                brightGradient.Parent = brightnessGradient
                
                -- Barra de matiz
                local hueBar = Instance.new("Frame")
                hueBar.Size = UDim2.new(1, -20, 0, 20)
                hueBar.Position = UDim2.new(0, 10, 0, 120)
                hueBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                hueBar.BorderSizePixel = 0
                hueBar.Parent = pickerPanel
                
                RoundFrame(hueBar, 4)
                
                local hueGradient = Instance.new("UIGradient")
                hueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                hueGradient.Parent = hueBar
                
                local hue, sat, val = 0, 1, 1
                
                -- Función para convertir HSV a RGB
                local function HSVtoRGB(h, s, v)
                    local r, g, b
                    local i = math.floor(h * 6)
                    local f = h * 6 - i
                    local p = v * (1 - s)
                    local q = v * (1 - f * s)
                    local t = v * (1 - (1 - f) * s)
                    
                    local imod = i % 6
                    if imod == 0 then
                        r, g, b = v, t, p
                    elseif imod == 1 then
                        r, g, b = q, v, p
                    elseif imod == 2 then
                        r, g, b = p, v, t
                    elseif imod == 3 then
                        r, g, b = p, q, v
                    elseif imod == 4 then
                        r, g, b = t, p, v
                    elseif imod == 5 then
                        r, g, b = v, p, q
                    end
                    
                    return Color3.fromRGB(r * 255, g * 255, b * 255)
                end
                
                -- Función para actualizar color
                local function UpdateColor()
                    currentColor = HSVtoRGB(hue, sat, val)
                    colorDisplay.BackgroundColor3 = currentColor
                    
                    -- Actualizar área de color
                    local baseColor = HSVtoRGB(hue, 1, 1)
                    colorArea.BackgroundColor3 = baseColor
                    
                    if callback then
                        callback(currentColor)
                    end
                end
                
                -- Interacción con el área de color
                local colorAreaDragging = false
                colorArea.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        colorAreaDragging = true
                        local mousePos = input.Position
                        local framePos = colorArea.AbsolutePosition
                        local frameSize = colorArea.AbsoluteSize
                        
                        sat = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
                        val = 1 - math.clamp((mousePos.Y - framePos.Y) / frameSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if colorAreaDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = input.Position
                        local framePos = colorArea.AbsolutePosition
                        local frameSize = colorArea.AbsoluteSize
                        
                        sat = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
                        val = 1 - math.clamp((mousePos.Y - framePos.Y) / frameSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                -- Interacción con la barra de matiz
                local hueDragging = false
                hueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDragging = true
                        local mousePos = input.Position.X
                        local framePos = hueBar.AbsolutePosition.X
                        local frameSize = hueBar.AbsoluteSize.X
                        
                        hue = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                        UpdateColor()
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = input.Position.X
                        local framePos = hueBar.AbsolutePosition.X
                        local frameSize = hueBar.AbsoluteSize.X
                        
                        hue = math.clamp((mousePos - framePos) / frameSize, 0, 1)
                        UpdateColor()
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        colorAreaDragging = false
                        hueDragging = false
                    end
                end)
                
                -- Toggle del panel
                colorDisplay.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    pickerPanel.Visible = isOpen
                    
                    if isOpen then
                        CreateTween(colorFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 190)})
                    else
                        CreateTween(colorFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)})
                    end
                end)
                
                colorPicker.SetColor = function(color)
                    currentColor = color
                    colorDisplay.BackgroundColor3 = color
                    if callback then
                        callback(color)
                    end
                end
                
                colorPicker.GetColor = function()
                    return currentColor
                end
                
                return colorPicker
            end
            
            -- Crear textbox
            function section:CreateTextbox(name, placeholder, callback)
                local textbox = {}
                
                local textboxFrame = Instance.new("Frame")
                textboxFrame.Name = name .. "Textbox"
                textboxFrame.Size = UDim2.new(1, 0, 0, 35)
                textboxFrame.BackgroundColor3 = Library.Config.BackgroundColor
                textboxFrame.BorderSizePixel = 0
                textboxFrame.Parent = sectionFrame
                
                RoundFrame(textboxFrame, 4)
                AddStroke(textboxFrame)
                
                local textboxLabel = Instance.new("TextLabel")
                textboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
                textboxLabel.Position = UDim2.new(0, 10, 0, 0)
                textboxLabel.BackgroundTransparency = 1
                textboxLabel.Text = name
                textboxLabel.TextColor3 = Library.Config.TextColor
                textboxLabel.TextSize = 13
                textboxLabel.Font = Library.Config.Font
                textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxLabel.Parent = textboxFrame
                
                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(0.6, -10, 0, 25)
                textBox.Position = UDim2.new(0.4, 0, 0.5, -12.5)
                textBox.BackgroundColor3 = Library.Config.MainColor
                textBox.BorderSizePixel = 0
                textBox.Text = ""
                textBox.PlaceholderText = placeholder or "Enter text..."
                textBox.TextColor3 = Library.Config.TextColor
                textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                textBox.TextSize = 12
                textBox.Font = Library.Config.Font
                textBox.Parent = textboxFrame
                
                RoundFrame(textBox, 4)
                
                textBox.FocusLost:Connect(function(enterPressed)
                    if callback then
                        callback(textBox.Text, enterPressed)
                    end
                end)
                
                textbox.SetText = function(text)
                    textBox.Text = text
                end
                
                textbox.GetText = function()
                    return textBox.Text
                end
                
                return textbox
            end
            
            -- Crear label
            function section:CreateLabel(text)
                local labelFrame = Instance.new("Frame")
                labelFrame.Name = "Label"
                labelFrame.Size = UDim2.new(1, 0, 0, 25)
                labelFrame.BackgroundTransparency = 1
                labelFrame.Parent = sectionFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -20, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = Library.Config.TextColor
                label.TextSize = 13
                label.Font = Library.Config.Font
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextWrapped = true
                label.Parent = labelFrame
                
                return label
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

-- Función para mostrar notificación
function Library:CreateNotification(title, text, duration)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 1, -100)
    notification.BackgroundColor3 = Library.Config.MainColor
    notification.BorderSizePixel = 0
    notification.Parent = PlayerGui
    
    RoundFrame(notification, 8)
    AddStroke(notification, Library.Config.AccentColor, 2)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Library.Config.AccentColor
    titleLabel.TextSize = 14
    titleLabel.Font = Library.Config.Font
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 45)
    textLabel.Position = UDim2.new(0, 10, 0, 30)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Library.Config.TextColor
    textLabel.TextSize = 12
    textLabel.Font = Library.Config.Font
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = notification
    
    -- Animación de entrada
    notification.Position = UDim2.new(1, 20, 1, -100)
    CreateTween(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -320, 1, -100)})
    
    -- Desaparecer automáticamente
    wait(duration or 3)
    CreateTween(notification, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 1, -100)})
    wait(0.5)
    notification:Destroy()
end

-- Función para cambiar tema
function Library:SetTheme(theme)
    if theme == "Dark" then
        Library.Config.MainColor = Color3.fromRGB(45, 45, 45)
        Library.Config.AccentColor = Color3.fromRGB(85, 170, 255)
        Library.Config.TextColor = Color3.fromRGB(255, 255, 255)
        Library.Config.BackgroundColor = Color3.fromRGB(30, 30, 30)
        Library.Config.BorderColor = Color3.fromRGB(60, 60, 60)
    elseif theme == "Light" then
        Library.Config.MainColor = Color3.fromRGB(240, 240, 240)
        Library.Config.AccentColor = Color3.fromRGB(0, 120, 215)
        Library.Config.TextColor = Color3.fromRGB(0, 0, 0)
        Library.Config.BackgroundColor = Color3.fromRGB(255, 255, 255)
        Library.Config.BorderColor = Color3.fromRGB(200, 200, 200)
    elseif theme == "Purple" then
        Library.Config.MainColor = Color3.fromRGB(50, 40, 70)
        Library.Config.AccentColor = Color3.fromRGB(150, 100, 255)
        Library.Config.TextColor = Color3.fromRGB(255, 255, 255)
        Library.Config.BackgroundColor = Color3.fromRGB(35, 25, 55)
        Library.Config.BorderColor = Color3.fromRGB(70, 60, 90)
    end
end

-- Función para destruir la librería
function Library:Destroy()
    if PlayerGui:FindFirstChild("UILibrary") then
        PlayerGui.UILibrary:Destroy()
    end
end

return Library

--[[
EJEMPLO DE USO:

local Library = loadstring(game:HttpGet("URL_DEL_SCRIPT"))()

-- Crear ventana
local Window = Library:CreateWindow("Mi Script", UDim2.new(0, 600, 0, 500))

-- Crear tab
local Tab1 = Window:CreateTab("Principal")

-- Crear sección
local Section1 = Tab1:CreateSection("Controles")

-- Crear botón
Section1:CreateButton("Test Button", function()
    print("¡Botón presionado!")
end)

-- Crear toggle
local Toggle = Section1:CreateToggle("Enable Feature", false, function(value)
    print("Toggle:", value)
end)

-- Crear slider
local Slider = Section1:CreateSlider("Speed", 1, 100, 50, function(value)
    print("Slider:", value)
end)

-- Crear dropdown
local Dropdown = Section1:CreateDropdown("Mode", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(value)
    print("Dropdown:", value)
end)

-- Crear keybind
local Keybind = Section1:CreateKeybind("Toggle Key", Enum.KeyCode.F, function()
    print("Keybind activado!")
end)

-- Crear color picker
local ColorPicker = Section1:CreateColorPicker("Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Color:", color)
end)

-- Crear textbox
local Textbox = Section1:CreateTextbox("Username", "Enter username", function(text, enterPressed)
    print("Text:", text, "Enter pressed:", enterPressed)
end)

-- Crear label
Section1:CreateLabel("Esta es una etiqueta informativa")

-- Crear notificación
Library:CreateNotification("Título", "Mensaje de la notificación", 5)

-- Cambiar tema
Library:SetTheme("Purple")
--]]
