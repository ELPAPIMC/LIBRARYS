-- PibblestoreLib v1.0.0
-- A comprehensive UI library for Roblox
-- Created for easy integration and sharing

local PibblestoreLib = {}
PibblestoreLib.__index = PibblestoreLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Theme Configuration
local themes = {
    light = {
        primary = Color3.fromRGB(255, 255, 255),
        secondary = Color3.fromRGB(240, 240, 240),
        accent = Color3.fromRGB(0, 120, 215),
        text = Color3.fromRGB(0, 0, 0),
        textSecondary = Color3.fromRGB(100, 100, 100),
        border = Color3.fromRGB(200, 200, 200),
        hover = Color3.fromRGB(230, 230, 230),
        success = Color3.fromRGB(40, 167, 69),
        warning = Color3.fromRGB(255, 193, 7),
        error = Color3.fromRGB(220, 53, 69)
    },
    dark = {
        primary = Color3.fromRGB(45, 45, 45),
        secondary = Color3.fromRGB(35, 35, 35),
        accent = Color3.fromRGB(0, 120, 215),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(180, 180, 180),
        border = Color3.fromRGB(70, 70, 70),
        hover = Color3.fromRGB(55, 55, 55),
        success = Color3.fromRGB(40, 167, 69),
        warning = Color3.fromRGB(255, 193, 7),
        error = Color3.fromRGB(220, 53, 69)
    },
    aquamarine = {
        primary = Color3.fromRGB(127, 255, 212),
        secondary = Color3.fromRGB(102, 205, 170),
        accent = Color3.fromRGB(0, 139, 139),
        text = Color3.fromRGB(0, 0, 0),
        textSecondary = Color3.fromRGB(40, 40, 40),
        border = Color3.fromRGB(95, 158, 160),
        hover = Color3.fromRGB(144, 238, 144),
        success = Color3.fromRGB(46, 125, 50),
        warning = Color3.fromRGB(255, 152, 0),
        error = Color3.fromRGB(183, 28, 28)
    }
}

-- Animation Configuration
local animationConfig = {
    duration = 0.3,
    easingStyle = Enum.EasingStyle.Quad,
    easingDirection = Enum.EasingDirection.Out
}

-- Utility Functions
local function createTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or animationConfig.duration,
        easingStyle or animationConfig.easingStyle,
        easingDirection or animationConfig.easingDirection
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function createPadding(parent, padding)
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = UDim.new(0, padding)
    uiPadding.PaddingBottom = UDim.new(0, padding)
    uiPadding.PaddingLeft = UDim.new(0, padding)
    uiPadding.PaddingRight = UDim.new(0, padding)
    uiPadding.Parent = parent
    return uiPadding
end

-- Main Library Constructor
function PibblestoreLib.new(config)
    local self = setmetatable({}, PibblestoreLib)
    
    -- Configuration
    self.config = config or {}
    self.theme = themes[self.config.theme or "dark"]
    self.minimized = false
    self.notifications = {}
    
    -- Create main GUI
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "PibblestoreLib"
    self.screenGui.Parent = playerGui
    self.screenGui.ResetOnSpawn = false
    
    -- Create main frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0, 500, 0, 400)
    self.mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.mainFrame.BackgroundColor3 = self.theme.primary
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.screenGui
    
    createCorner(self.mainFrame, 12)
    createStroke(self.mainFrame, self.theme.border, 2)
    
    -- Make draggable
    self:makeDraggable(self.mainFrame)
    
    -- Create title bar
    self.titleBar = Instance.new("Frame")
    self.titleBar.Name = "TitleBar"
    self.titleBar.Size = UDim2.new(1, 0, 0, 40)
    self.titleBar.Position = UDim2.new(0, 0, 0, 0)
    self.titleBar.BackgroundColor3 = self.theme.secondary
    self.titleBar.BorderSizePixel = 0
    self.titleBar.Parent = self.mainFrame
    
    createCorner(self.titleBar, 12)
    
    -- Title text
    self.titleText = Instance.new("TextLabel")
    self.titleText.Name = "TitleText"
    self.titleText.Size = UDim2.new(1, -80, 1, 0)
    self.titleText.Position = UDim2.new(0, 10, 0, 0)
    self.titleText.BackgroundTransparency = 1
    self.titleText.Text = self.config.title or "PibblestoreLib"
    self.titleText.TextColor3 = self.theme.text
    self.titleText.TextScaled = true
    self.titleText.TextXAlignment = Enum.TextXAlignment.Left
    self.titleText.Font = Enum.Font.GothamBold
    self.titleText.Parent = self.titleBar
    
    -- Create minimize button
    self:createMinimizeButton()
    
    -- Create content frame
    self.contentFrame = Instance.new("ScrollingFrame")
    self.contentFrame.Name = "ContentFrame"
    self.contentFrame.Size = UDim2.new(1, -20, 1, -60)
    self.contentFrame.Position = UDim2.new(0, 10, 0, 50)
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.BorderSizePixel = 0
    self.contentFrame.ScrollBarThickness = 6
    self.contentFrame.ScrollBarImageColor3 = self.theme.accent
    self.contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.contentFrame.Parent = self.mainFrame
    
    -- Layout for content
    self.contentLayout = Instance.new("UIListLayout")
    self.contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.contentLayout.Padding = UDim.new(0, 10)
    self.contentLayout.Parent = self.contentFrame
    
    -- Auto-resize content
    self.contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.contentFrame.CanvasSize = UDim2.new(0, 0, 0, self.contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Setup minimize functionality
    self:setupMinimizeControls()
    
    return self
end

-- Make frame draggable
function PibblestoreLib:makeDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create minimize button
function PibblestoreLib:createMinimizeButton()
    self.minimizeButton = Instance.new("TextButton")
    self.minimizeButton.Name = "MinimizeButton"
    self.minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    self.minimizeButton.Position = UDim2.new(1, -35, 0, 5)
    self.minimizeButton.BackgroundColor3 = self.theme.accent
    self.minimizeButton.BorderSizePixel = 0
    self.minimizeButton.Text = "_"
    self.minimizeButton.TextColor3 = Color3.white
    self.minimizeButton.TextScaled = true
    self.minimizeButton.Font = Enum.Font.GothamBold
    self.minimizeButton.Parent = self.titleBar
    
    createCorner(self.minimizeButton, 6)
    
    -- Hover effect
    self.minimizeButton.MouseEnter:Connect(function()
        createTween(self.minimizeButton, {BackgroundColor3 = self.theme.hover}):Play()
    end)
    
    self.minimizeButton.MouseLeave:Connect(function()
        createTween(self.minimizeButton, {BackgroundColor3 = self.theme.accent}):Play()
    end)
    
    -- Click event
    self.minimizeButton.MouseButton1Click:Connect(function()
        self:toggleMinimize()
    end)
end

-- Setup minimize controls
function PibblestoreLib:setupMinimizeControls()
    -- PC: Left Control key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
            self:toggleMinimize()
        end
    end)
    
    -- Mobile: Create floating minimize button
    if UserInputService.TouchEnabled then
        self.mobileMinimizeButton = Instance.new("TextButton")
        self.mobileMinimizeButton.Name = "MobileMinimizeButton"
        self.mobileMinimizeButton.Size = UDim2.new(0, 50, 0, 50)
        self.mobileMinimizeButton.Position = UDim2.new(1, -60, 0, 10)
        self.mobileMinimizeButton.BackgroundColor3 = self.theme.accent
        self.mobileMinimizeButton.BorderSizePixel = 0
        self.mobileMinimizeButton.Text = "≡"
        self.mobileMinimizeButton.TextColor3 = Color3.white
        self.mobileMinimizeButton.TextScaled = true
        self.mobileMinimizeButton.Font = Enum.Font.GothamBold
        self.mobileMinimizeButton.Parent = self.screenGui
        
        createCorner(self.mobileMinimizeButton, 25)
        
        self.mobileMinimizeButton.MouseButton1Click:Connect(function()
            self:toggleMinimize()
        end)
    end
end

-- Toggle minimize
function PibblestoreLib:toggleMinimize()
    self.minimized = not self.minimized
    
    if self.minimized then
        createTween(self.mainFrame, {
            Size = UDim2.new(0, 200, 0, 40),
            Position = UDim2.new(0.5, -100, 0.5, -20)
        }):Play()
        self.contentFrame.Visible = false
        self.minimizeButton.Text = "□"
    else
        createTween(self.mainFrame, {
            Size = UDim2.new(0, 500, 0, 400),
            Position = UDim2.new(0.5, -250, 0.5, -200)
        }):Play()
        self.contentFrame.Visible = true
        self.minimizeButton.Text = "_"
    end
end

-- Change theme
function PibblestoreLib:setTheme(themeName)
    if themes[themeName] then
        self.theme = themes[themeName]
        self:updateTheme()
    end
end

-- Update theme colors
function PibblestoreLib:updateTheme()
    self.mainFrame.BackgroundColor3 = self.theme.primary
    self.titleBar.BackgroundColor3 = self.theme.secondary
    self.titleText.TextColor3 = self.theme.text
    self.minimizeButton.BackgroundColor3 = self.theme.accent
    
    -- Update stroke
    for _, child in pairs(self.mainFrame:GetChildren()) do
        if child:IsA("UIStroke") then
            child.Color = self.theme.border
        end
    end
end

-- Create Label
function PibblestoreLib:createLabel(config)
    local label = Instance.new("TextLabel")
    label.Name = config.name or "Label"
    label.Size = UDim2.new(1, -20, 0, config.height or 30)
    label.BackgroundColor3 = config.background or self.theme.secondary
    label.BorderSizePixel = 0
    label.Text = config.text or "Label"
    label.TextColor3 = config.textColor or self.theme.text
    label.TextScaled = true
    label.Font = config.font or Enum.Font.Gotham
    label.Parent = self.contentFrame
    
    createCorner(label, 6)
    createPadding(label, 5)
    
    return label
end

-- Create Button
function PibblestoreLib:createButton(config)
    local button = Instance.new("TextButton")
    button.Name = config.name or "Button"
    button.Size = UDim2.new(1, -20, 0, config.height or 35)
    button.BackgroundColor3 = config.background or self.theme.accent
    button.BorderSizePixel = 0
    button.Text = config.text or "Button"
    button.TextColor3 = config.textColor or Color3.white
    button.TextScaled = true
    button.Font = config.font or Enum.Font.GothamBold
    button.Parent = self.contentFrame
    
    createCorner(button, 6)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        createTween(button, {BackgroundColor3 = self.theme.hover}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        createTween(button, {BackgroundColor3 = config.background or self.theme.accent}):Play()
    end)
    
    -- Click effect
    button.MouseButton1Click:Connect(function()
        createTween(button, {Size = UDim2.new(1, -25, 0, (config.height or 35) - 5)}):Play()
        wait(0.1)
        createTween(button, {Size = UDim2.new(1, -20, 0, config.height or 35)}):Play()
        
        if config.callback then
            config.callback()
        end
    end)
    
    return button
end

-- Create Toggle
function PibblestoreLib:createToggle(config)
    local container = Instance.new("Frame")
    container.Name = config.name or "Toggle"
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = self.theme.secondary
    container.BorderSizePixel = 0
    container.Parent = self.contentFrame
    
    createCorner(container, 6)
    createPadding(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text or "Toggle"
    label.TextColor3 = self.theme.text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggleFrame.BackgroundColor3 = self.theme.border
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = container
    
    createCorner(toggleFrame, 12)
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = UDim2.new(0, 2.5, 0, 2.5)
    toggleButton.BackgroundColor3 = Color3.white
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    createCorner(toggleButton, 10)
    
    local toggled = config.default or false
    
    local function updateToggle()
        if toggled then
            createTween(toggleButton, {Position = UDim2.new(0, 27.5, 0, 2.5)}):Play()
            createTween(toggleFrame, {BackgroundColor3 = self.theme.success}):Play()
        else
            createTween(toggleButton, {Position = UDim2.new(0, 2.5, 0, 2.5)}):Play()
            createTween(toggleFrame, {BackgroundColor3 = self.theme.border}):Play()
        end
        
        if config.callback then
            config.callback(toggled)
        end
    end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggled = not toggled
            updateToggle()
        end
    end)
    
    -- Initialize
    updateToggle()
    
    return container
end

-- Create Slider
function PibblestoreLib:createSlider(config)
    local container = Instance.new("Frame")
    container.Name = config.name or "Slider"
    container.Size = UDim2.new(1, -20, 0, 50)
    container.BackgroundColor3 = self.theme.secondary
    container.BorderSizePixel = 0
    container.Parent = self.contentFrame
    
    createCorner(container, 6)
    createPadding(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text or "Slider"
    label.TextColor3 = self.theme.text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 6)
    sliderFrame.Position = UDim2.new(0, 0, 1, -16)
    sliderFrame.BackgroundColor3 = self.theme.border
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = container
    
    createCorner(sliderFrame, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = self.theme.accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderFrame
    
    createCorner(sliderFill, 3)
    
    local sliderButton = Instance.new("Frame")
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new(0, -6, 0, -3)
    sliderButton.BackgroundColor3 = Color3.white
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderFrame
    
    createCorner(sliderButton, 6)
    createStroke(sliderButton, self.theme.accent, 2)
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(config.min or 0)
    valueLabel.TextColor3 = self.theme.textSecondary
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = container
    
    local dragging = false
    local currentValue = config.default or config.min or 0
    local minValue = config.min or 0
    local maxValue = config.max or 100
    
    local function updateSlider(value)
        currentValue = math.clamp(value, minValue, maxValue)
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        
        createTween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        createTween(sliderButton, {Position = UDim2.new(percentage, -6, 0, -3)}):Play()
        
        valueLabel.Text = tostring(math.floor(currentValue))
        
        if config.callback then
            config.callback(currentValue)
        end
    end
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - sliderFrame.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
            local value = minValue + (maxValue - minValue) * percentage
            updateSlider(value)
        end
    end)
    
    -- Initialize
    updateSlider(currentValue)
    
    return container
end

-- Create Dropdown
function PibblestoreLib:createDropdown(config)
    local container = Instance.new("Frame")
    container.Name = config.name or "Dropdown"
    container.Size = UDim2.new(1, -20, 0, 35)
    container.BackgroundColor3 = self.theme.secondary
    container.BorderSizePixel = 0
    container.Parent = self.contentFrame
    
    createCorner(container, 6)
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = config.default or config.options[1] or "Select Option"
    button.TextColor3 = self.theme.text
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = container
    
    createPadding(button, 10)
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.theme.textSecondary
    arrow.TextScaled = true
    arrow.Font = Enum.Font.Gotham
    arrow.Parent = container
    
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, 0)
    dropdown.Position = UDim2.new(0, 0, 1, 5)
    dropdown.BackgroundColor3 = self.theme.primary
    dropdown.BorderSizePixel = 0
    dropdown.Visible = false
    dropdown.Parent = container
    
    createCorner(dropdown, 6)
    createStroke(dropdown, self.theme.border, 1)
    
    local optionLayout = Instance.new("UIListLayout")
    optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionLayout.Parent = dropdown
    
    local isOpen = false
    
    local function createOption(text, index)
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, 0, 0, 30)
        option.BackgroundColor3 = self.theme.primary
        option.BorderSizePixel = 0
        option.Text = text
        option.TextColor3 = self.theme.text
        option.TextScaled = true
        option.Font = Enum.Font.Gotham
        option.Parent = dropdown
        
        createPadding(option, 5)
        
        option.MouseEnter:Connect(function()
            createTween(option, {BackgroundColor3 = self.theme.hover}):Play()
        end)
        
        option.MouseLeave:Connect(function()
            createTween(option, {BackgroundColor3 = self.theme.primary}):Play()
        end)
        
        option.MouseButton1Click:Connect(function()
            button.Text = text
            isOpen = false
            
            createTween(dropdown, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            createTween(arrow, {Rotation = 0}):Play()
            
            wait(0.3)
            dropdown.Visible = false
            
            if config.callback then
                config.callback(text, index)
            end
        end)
    end
    
    -- Create options
    for i, option in ipairs(config.options or {}) do
        createOption(option, i)
    end
    
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            dropdown.Visible = true
            local optionCount = #(config.options or {})
            createTween(dropdown, {Size = UDim2.new(1, 0, 0, optionCount * 30)}):Play()
            createTween(arrow, {Rotation = 180}):Play()
        else
            createTween(dropdown, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            createTween(arrow, {Rotation = 0}):Play()
            
            wait(0.3)
            dropdown.Visible = false
        end
    end)
    
    return container
end

-- Create TextLabel (Enhanced)
function PibblestoreLib:createTextLabel(config)
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = config.name or "TextLabel"
    textLabel.Size = UDim2.new(1, -20, 0, config.height or 40)
    textLabel.BackgroundColor3 = config.background or self.theme.secondary
    textLabel.BorderSizePixel = 0
    textLabel.Text = config.text or "Text Label"
    textLabel.TextColor3 = config.textColor or self.theme.text
    textLabel.TextScaled = config.textScaled ~= false
    textLabel.Font = config.font or Enum.Font.Gotham
    textLabel.TextXAlignment = config.textXAlignment or Enum.TextXAlignment.Center
    textLabel.TextYAlignment = config.textYAlignment or Enum.TextYAlignment.Center
    textLabel.Parent = self.contentFrame
    
    createCorner(textLabel, 6)
    createPadding(textLabel, config.padding or 10)
    
    return textLabel
end

-- Create Notification
function PibblestoreLib:createNotification(config)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 0, 20 + (#self.notifications * 90))
    notification.BackgroundColor3 = config.background or self.theme.primary
    notification.BorderSizePixel = 0
    notification.Parent = self.screenGui
    
    -- Set notification type color
    local notificationColor = self.theme.accent
    if config.type == "success" then
        notificationColor = self.theme.success
    elseif config.type == "warning" then
        notificationColor = self.theme.warning
    elseif config.type == "error" then
        notificationColor = self.theme.error
    end
    
    createCorner(notification, 8)
    createStroke(notification, notificationColor, 2)
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = config.icon or "ℹ"
    icon.TextColor3 = notificationColor
    icon.TextScaled = true
    icon.Font = Enum.Font.GothamBold
    icon.Parent = notification
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 0, 25)
    title.Position = UDim2.new(0, 50, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = config.title or "Notification"
    title.TextColor3 = self.theme.text
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = notification
    
    -- Message
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -90, 0, 20)
    message.Position = UDim2.new(0, 50, 0, 30)
    message.BackgroundTransparency = 1
    message.Text = config.message or "This is a notification message"
    message.TextColor3 = self.theme.textSecondary
    message.TextScaled = true
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.Font = Enum.Font.Gotham
    message.Parent = notification
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = self.theme.textSecondary
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = notification
    
    -- Progress bar
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = notificationColor
    progressBar.BorderSizePixel = 0
    progressBar.Parent = notification
    
    -- Animate notification in
    notification.Position = UDim2.new(1, 0, 0, 20 + (#self.notifications * 90))
    createTween(notification, {Position = UDim2.new(1, -320, 0, 20 + (#self.notifications * 90))}):Play()
    
    -- Add to notifications list
    table.insert(self.notifications, notification)
    
    -- Auto-dismiss timer
    local duration = config.duration or 5
    local startTime = tick()
    
    local function updateProgressBar()
        local elapsed = tick() - startTime
        local progress = elapsed / duration
        
        if progress >= 1 then
            self:removeNotification(notification)
            return
        end
        
        createTween(progressBar, {Size = UDim2.new(1 - progress, 0, 0, 3)}):Play()
    end
    
    local progressConnection
    progressConnection = RunService.Heartbeat:Connect(updateProgressBar)
    
    -- Manual close
    closeButton.MouseButton1Click:Connect(function()
        if progressConnection then
            progressConnection:Disconnect()
        end
        self:removeNotification(notification)
    end)
    
    -- Hover to pause
    notification.MouseEnter:Connect(function()
        if progressConnection then
            progressConnection:Disconnect()
        end
    end)
    
    notification.MouseLeave:Connect(function()
        if notification.Parent then
            startTime = tick() - (duration * (1 - progressBar.Size.X.Scale))
            progressConnection = RunService.Heartbeat:Connect(updateProgressBar)
        end
    end)
    
    return notification
end

-- Remove notification
function PibblestoreLib:removeNotification(notification)
    -- Find notification in list
    for i, notif in ipairs(self.notifications) do
        if notif == notification then
            table.remove(self.notifications, i)
            break
        end
    end
    
    -- Animate out
    createTween(notification, {
        Position = UDim2.new(1, 0, notification.Position.Y.Scale, notification.Position.Y.Offset),
        Size = UDim2.new(0, 0, 0, 80)
    }):Play()
    
    -- Remove after animation
    wait(0.3)
    if notification.Parent then
        notification:Destroy()
    end
    
    -- Reposition remaining notifications
    for i, notif in ipairs(self.notifications) do
        createTween(notif, {Position = UDim2.new(1, -320, 0, 20 + ((i - 1) * 90))}):Play()
    end
end

-- Create TextBox
function PibblestoreLib:createTextBox(config)
    local container = Instance.new("Frame")
    container.Name = config.name or "TextBox"
    container.Size = UDim2.new(1, -20, 0, 50)
    container.BackgroundColor3 = self.theme.secondary
    container.BorderSizePixel = 0
    container.Parent = self.contentFrame
    
    createCorner(container, 6)
    createPadding(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.label or "Input"
    label.TextColor3 = self.theme.text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, 0, 0, 25)
    textBox.Position = UDim2.new(0, 0, 0, 25)
    textBox.BackgroundColor3 = self.theme.primary
    textBox.BorderSizePixel = 0
    textBox.Text = config.default or ""
    textBox.PlaceholderText = config.placeholder or "Enter text..."
    textBox.TextColor3 = self.theme.text
    textBox.PlaceholderColor3 = self.theme.textSecondary
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = container
    
    createCorner(textBox, 4)
    createStroke(textBox, self.theme.border, 1)
    createPadding(textBox, 5)
    
    -- Focus effects
    textBox.Focused:Connect(function()
        createTween(textBox:FindFirstChild("UIStroke"), {Color = self.theme.accent}):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        createTween(textBox:FindFirstChild("UIStroke"), {Color = self.theme.border}):Play()
        
        if config.callback then
            config.callback(textBox.Text)
        end
    end)
    
    return container
end

-- Create Section
function PibblestoreLib:createSection(config)
    local section = Instance.new("Frame")
    section.Name = config.name or "Section"
    section.Size = UDim2.new(1, -20, 0, 30)
    section.BackgroundTransparency = 1
    section.Parent = self.contentFrame
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -100, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = self.theme.border
    line.BorderSizePixel = 0
    line.Parent = section
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 80, 1, 0)
    title.Position = UDim2.new(1, -80, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.title or "Section"
    title.TextColor3 = self.theme.textSecondary
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = section
    
    return section
end

-- Create Progress Bar
function PibblestoreLib:createProgressBar(config)
    local container = Instance.new("Frame")
    container.Name = config.name or "ProgressBar"
    container.Size = UDim2.new(1, -20, 0, 50)
    container.BackgroundColor3 = self.theme.secondary
    container.BorderSizePixel = 0
    container.Parent = self.contentFrame
    
    createCorner(container, 6)
    createPadding(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text or "Progress"
    label.TextColor3 = self.theme.text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    local percentage = Instance.new("TextLabel")
    percentage.Size = UDim2.new(0, 40, 0, 20)
    percentage.Position = UDim2.new(1, -40, 0, 0)
    percentage.BackgroundTransparency = 1
    percentage.Text = "0%"
    percentage.TextColor3 = self.theme.textSecondary
    percentage.TextScaled = true
    percentage.Font = Enum.Font.Gotham
    percentage.Parent = container
    
    local progressFrame = Instance.new("Frame")
    progressFrame.Size = UDim2.new(1, 0, 0, 8)
    progressFrame.Position = UDim2.new(0, 0, 1, -18)
    progressFrame.BackgroundColor3 = self.theme.border
    progressFrame.BorderSizePixel = 0
    progressFrame.Parent = container
    
    createCorner(progressFrame, 4)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = self.theme.accent
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressFrame
    
    createCorner(progressFill, 4)
    
    local function updateProgress(value)
        local clampedValue = math.clamp(value, 0, 100)
        createTween(progressFill, {Size = UDim2.new(clampedValue / 100, 0, 1, 0)}):Play()
        percentage.Text = math.floor(clampedValue) .. "%"
    end
    
    -- Initialize
    updateProgress(config.value or 0)
    
    -- Return update function
    container.UpdateProgress = updateProgress
    
    return container
end

-- Create Keybind
function PibblestoreLib:createKeybind(config)
    local container = Instance.new("Frame")
    container.Name = config.name or "Keybind"
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = self.theme.secondary
    container.BorderSizePixel = 0
    container.Parent = self.contentFrame
    
    createCorner(container, 6)
    createPadding(container, 10)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text or "Keybind"
    label.TextColor3 = self.theme.text
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Size = UDim2.new(0, 70, 0, 25)
    keybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    keybindButton.BackgroundColor3 = self.theme.accent
    keybindButton.BorderSizePixel = 0
    keybindButton.Text = config.key or "None"
    keybindButton.TextColor3 = Color3.white
    keybindButton.TextScaled = true
    keybindButton.Font = Enum.Font.GothamBold
    keybindButton.Parent = container
    
    createCorner(keybindButton, 4)
    
    local listening = false
    local currentKey = config.key
    
    keybindButton.MouseButton1Click:Connect(function()
        if listening then return end
        
        listening = true
        keybindButton.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode.Name
                keybindButton.Text = currentKey
                listening = false
                connection:Disconnect()
                
                if config.callback then
                    config.callback(currentKey)
                end
            end
        end)
    end)
    
    -- Set up keybind listener
    if config.callback then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed or listening then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
                config.callback(currentKey)
            end
        end)
    end
    
    return container
end

-- Utility Methods
function PibblestoreLib:addSeparator()
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, -40, 0, 1)
    separator.BackgroundColor3 = self.theme.border
    separator.BorderSizePixel = 0
    separator.Parent = self.contentFrame
    
    return separator
end

function PibblestoreLib:addSpace(height)
    local space = Instance.new("Frame")
    space.Name = "Space"
    space.Size = UDim2.new(1, 0, 0, height or 10)
    space.BackgroundTransparency = 1
    space.Parent = self.contentFrame
    
    return space
end

-- Show/Hide Methods
function PibblestoreLib:show()
    self.screenGui.Enabled = true
    createTween(self.mainFrame, {
        Position = UDim2.new(0.5, -250, 0.5, -200),
        Size = UDim2.new(0, 500, 0, 400)
    }):Play()
end

function PibblestoreLib:hide()
    createTween(self.mainFrame, {
        Position = UDim2.new(0.5, -250, 1, 100),
        Size = UDim2.new(0, 500, 0, 400)
    }):Play()
    
    wait(0.3)
    self.screenGui.Enabled = false
end

function PibblestoreLib:destroy()
    if self.screenGui then
        self.screenGui:Destroy()
    end
end

-- Example Usage and Documentation
--[[
-- Basic Usage:
local lib = PibblestoreLib.new({
    title = "My GUI",
    theme = "dark" -- "light", "dark", "aquamarine"
})

-- Create components:
lib:createLabel({
    name = "WelcomeLabel",
    text = "Welcome to PibblestoreLib!",
    height = 40
})

lib:createButton({
    name = "TestButton",
    text = "Click Me!",
    callback = function()
        print("Button clicked!")
    end
})

lib:createToggle({
    name = "TestToggle",
    text = "Enable Feature",
    default = false,
    callback = function(value)
        print("Toggle:", value)
    end
})

lib:createSlider({
    name = "VolumeSlider",
    text = "Volume",
    min = 0,
    max = 100,
    default = 50,
    callback = function(value)
        print("Volume:", value)
    end
})

lib:createDropdown({
    name = "ThemeSelector",
    options = {"Light", "Dark", "Aquamarine"},
    default = "Dark",
    callback = function(selected, index)
        print("Selected:", selected)
    end
})

lib:createNotification({
    title = "Success!",
    message = "Operation completed successfully",
    type = "success", -- "success", "warning", "error", "info"
    duration = 3
})

-- Change theme:
lib:setTheme("aquamarine")

-- Show/Hide:
lib:show()
lib:hide()
--]]

return PibblestoreLib
