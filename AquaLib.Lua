--[[
    Aqua UI Library
    A comprehensive UI library for Roblox with notifications, toggles, sliders and more
    Usage example:
    local AquaLib = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
    
    local window = AquaLib:CreateWindow("Aqua UI")
    
    local mainTab = window:CreateTab("Combat")
    local movementTab = window:CreateTab("Movement")
    
    local section = mainTab:CreateSection("KillAura")
    
    section:CreateToggle("Noob", true, function(value)
        print("Toggle state: " .. tostring(value))
    end)
    
    section:CreateSlider("Noob", 0, 100, 70, function(value)
        print("Slider value: " .. value)
    end)
    
    section:CreateDropdown("Mode", {"eaa", "bbb", "ccc"}, "eaa", function(value)
        print("Selected: " .. value)
    end)
    
    local button = mainTab:CreateButton("AutoClicker", function()
        print("Button clicked!")
    end)
    
    AquaLib:Notify("Title", "Description", 3)
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Constants
local TWEEN_TIME = 0.2
local UI_CORNER_RADIUS = UDim.new(0, 4)
local MAIN_COLOR = Color3.fromRGB(111, 187, 187) -- Aqua/Teal color
local DARKER_COLOR = Color3.fromRGB(91, 167, 167)
local BG_COLOR = Color3.fromRGB(40, 40, 40)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local HOVER_COLOR = Color3.fromRGB(131, 207, 207)
local SHADOW_COLOR = Color3.fromRGB(20, 20, 20)

-- Utility Functions
local function createShadow(instance, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = SHADOW_COLOR
    shadow.BackgroundTransparency = transparency or 0.5
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0, 2, 0, 2)
    shadow.Size = instance.Size
    shadow.ZIndex = instance.ZIndex - 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UI_CORNER_RADIUS
    corner.Parent = shadow
    
    shadow.Parent = instance
end

local function createTween(instance, properties, time, easingStyle, easingDirection)
    local tInfo = TweenInfo.new(
        time or TWEEN_TIME,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(instance, tInfo, properties)
    return tween
end

-- Main Library
local AquaLib = {}
AquaLib.__index = AquaLib

-- Initialize
function AquaLib:Init()
    if _G.AquaLibLoaded then
        return _G.AquaLib
    end
    
    local instance = setmetatable({}, AquaLib)
    instance.Windows = {}
    instance.Connections = {}
    instance.NotificationCount = 0
    
    -- Create notification container
    local notificationContainer = Instance.new("Frame")
    notificationContainer.Name = "NotificationContainer"
    notificationContainer.BackgroundTransparency = 1
    notificationContainer.Position = UDim2.new(1, -20, 0, 20)
    notificationContainer.Size = UDim2.new(0, 280, 1, -40)
    notificationContainer.ZIndex = 10000
    notificationContainer.AnchorPoint = Vector2.new(1, 0)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = notificationContainer
    
    -- Check if we can use CoreGui
    local success, result = pcall(function()
        return CoreGui:FindFirstChild("AquaLibNotifications") or Instance.new("ScreenGui", CoreGui)
    end)
    
    local container
    
    if success then
        container = result
        container.Name = "AquaLibNotifications"
        container.IgnoreGuiInset = true
        container.ResetOnSpawn = false
        container.ZIndexBehavior = Enum.ZIndexBehavior.Global
    else
        container = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
        container.Name = "AquaLibNotifications"
        container.IgnoreGuiInset = true
        container.ResetOnSpawn = false
        container.ZIndexBehavior = Enum.ZIndexBehavior.Global
    end
    
    notificationContainer.Parent = container
    instance.NotificationContainer = notificationContainer
    
    _G.AquaLibLoaded = true
    _G.AquaLib = instance
    
    return instance
end

-- Create a notification
function AquaLib:Notify(title, description, duration)
    duration = duration or 3
    self.NotificationCount = self.NotificationCount + 1
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification_" .. self.NotificationCount
    notification.BackgroundColor3 = BG_COLOR
    notification.BorderSizePixel = 0
    notification.Size = UDim2.new(0, 280, 0, 80)
    notification.Position = UDim2.new(1, 300, 0, 0)
    notification.ZIndex = 10001
    notification.ClipsDescendants = true
    notification.AnchorPoint = Vector2.new(1, 0)
    notification.LayoutOrder = self.NotificationCount
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UI_CORNER_RADIUS
    corner.Parent = notification
    
    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = MAIN_COLOR
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 5)
    topBar.ZIndex = 10002
    topBar.Parent = notification
    
    -- Icon (water drop icon)
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7072716834" -- Water drop icon
    icon.Position = UDim2.new(0, 10, 0, 15)
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.ZIndex = 10002
    icon.ImageColor3 = MAIN_COLOR
    icon.Parent = notification
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 40, 0, 13)
    titleLabel.Size = UDim2.new(1, -50, 0, 25)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = TEXT_COLOR
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 10002
    titleLabel.Parent = notification
    
    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 10, 0, 40)
    descLabel.Size = UDim2.new(1, -20, 0, 30)
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description or ""
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 14
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.ZIndex = 10002
    descLabel.Parent = notification
    
    -- Progress bar
    local progressBarBG = Instance.new("Frame")
    progressBarBG.Name = "ProgressBarBG"
    progressBarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    progressBarBG.BorderSizePixel = 0
    progressBarBG.Position = UDim2.new(0, 0, 1, -4)
    progressBarBG.Size = UDim2.new(1, 0, 0, 4)
    progressBarBG.ZIndex = 10002
    progressBarBG.Parent = notification
    
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.BackgroundColor3 = MAIN_COLOR
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.ZIndex = 10003
    progressBar.Parent = progressBarBG
    
    -- Create shadow
    createShadow(notification, 0.4)
    
    notification.Parent = self.NotificationContainer
    
    -- Animate entry
    local entryTween = createTween(notification, {Position = UDim2.new(1, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    entryTween:Play()
    
    -- Animate progress bar
    local progressTween = createTween(progressBar, {Size = UDim2.new(0, 0, 1, 0)}, duration)
    progressTween:Play()
    
    -- Auto close
    task.delay(duration, function()
        local exitTween = createTween(notification, {Position = UDim2.new(1, 300, 0, 0)}, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        exitTween:Play()
        
        exitTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    return notification
end

-- Create a window
function AquaLib:CreateWindow(title)
    local window = {}
    window.Tabs = {}
    window.ActiveTab = nil
    
    -- Check if we can use CoreGui
    local success, gui = pcall(function()
        return CoreGui:FindFirstChild("AquaLibWindow") or Instance.new("ScreenGui", CoreGui)
    end)
    
    if not success then
        gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    end
    
    gui.Name = "AquaLibWindow"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Main frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.BackgroundColor3 = BG_COLOR
    main.BorderSizePixel = 0
    main.Position = UDim2.new(0.5, -250, 0.5, -150)
    main.Size = UDim2.new(0, 500, 0, 300)
    main.ZIndex = 1
    main.Parent = gui
    main.Active = true
    main.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UI_CORNER_RADIUS
    corner.Parent = main
    
    -- Top bar with icon
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = MAIN_COLOR
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.ZIndex = 2
    topBar.Parent = main
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UI_CORNER_RADIUS
    topCorner.Parent = topBar
    
    -- Fix the corner at the bottom
    local bottomFix = Instance.new("Frame")
    bottomFix.Name = "BottomFix"
    bottomFix.BackgroundColor3 = MAIN_COLOR
    bottomFix.BorderSizePixel = 0
    bottomFix.Position = UDim2.new(0, 0, 1, -10)
    bottomFix.Size = UDim2.new(1, 0, 0, 10)
    bottomFix.ZIndex = 2
    bottomFix.Parent = topBar
    
    -- Icon (water drop)
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7072716834" -- Water drop icon
    icon.Position = UDim2.new(0, 8, 0, 5)
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.ZIndex = 3
    icon.Parent = topBar
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 35, 0, 0)
    titleLabel.Size = UDim2.new(1, -35, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title or "Aqua UI"
    titleLabel.TextColor3 = TEXT_COLOR
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = topBar
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundTransparency = 1
    tabContainer.Position = UDim2.new(0, 10, 0, 40)
    tabContainer.Size = UDim2.new(0, 120, 1, -50)
    tabContainer.ZIndex = 2
    tabContainer.Parent = main
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer
    
    -- Tab content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    contentContainer.BorderSizePixel = 0
    contentContainer.Position = UDim2.new(0, 140, 0, 40)
    contentContainer.Size = UDim2.new(1, -150, 1, -50)
    contentContainer.ZIndex = 2
    contentContainer.Parent = main
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UI_CORNER_RADIUS
    contentCorner.Parent = contentContainer
    
    -- Create shadow
    createShadow(main, 0.3)
    
    window.Gui = gui
    window.Main = main
    window.TabContainer = tabContainer
    window.ContentContainer = contentContainer
    
    -- Create Tab Function
    function window:CreateTab(name)
        local tab = {}
        tab.Name = name
        tab.Sections = {}
        
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.BackgroundColor3 = #self.Tabs == 0 and MAIN_COLOR or Color3.fromRGB(50, 50, 50)
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = name
        tabButton.TextColor3 = TEXT_COLOR
        tabButton.TextSize = 14
        tabButton.ZIndex = 3
        tabButton.AutoButtonColor = false
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UI_CORNER_RADIUS
        buttonCorner.Parent = tabButton
        
        tabButton.Parent = self.TabContainer
        
        -- Tab content frame
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Name = name .. "Content"
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.ScrollBarThickness = 3
        contentFrame.ScrollBarImageColor3 = MAIN_COLOR
        contentFrame.ZIndex = 3
        contentFrame.Visible = #self.Tabs == 0
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.ClipsDescendants = true
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = contentFrame
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingLeft = UDim.new(0, 10)
        contentPadding.PaddingRight = UDim.new(0, 10)
        contentPadding.PaddingTop = UDim.new(0, 10)
        contentPadding.PaddingBottom = UDim.new(0, 10)
        contentPadding.Parent = contentFrame
        
        -- Auto-resize canvas
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        contentFrame.Parent = self.ContentContainer
        
        tab.Button = tabButton
        tab.Content = contentFrame
        
        table.insert(self.Tabs, tab)
        
        if #self.Tabs == 1 then
            self.ActiveTab = tab
        end
        
        -- Tab button click function
        tabButton.MouseButton1Click:Connect(function()
            if self.ActiveTab == tab then return end
            
            -- Hide all other tabs
            for _, otherTab in pairs(self.Tabs) do
                otherTab.Content.Visible = false
                createTween(otherTab.Button, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end
            
            -- Show this tab
            tab.Content.Visible = true
            createTween(tab.Button, {BackgroundColor3 = MAIN_COLOR}):Play()
            
            self.ActiveTab = tab
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if self.ActiveTab ~= tab then
                createTween(tabButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.ActiveTab ~= tab then
                createTween(tabButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end
        end)
        
        -- Create Section Function
        function tab:CreateSection(title)
            local section = {}
            
            -- Section container
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = title .. "Section"
            sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Size = UDim2.new(1, 0, 0, 30) -- Will be auto-sized
            sectionFrame.ZIndex = 4
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UI_CORNER_RADIUS
            sectionCorner.Parent = sectionFrame
            
            -- Section title
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Position = UDim2.new(0, 10, 0, 0)
            sectionTitle.Size = UDim2.new(1, -20, 0, 30)
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.Text = title
            sectionTitle.TextColor3 = TEXT_COLOR
            sectionTitle.TextSize = 14
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.ZIndex = 5
            sectionTitle.Parent = sectionFrame
            
            -- Section content
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.BackgroundTransparency = 1
            sectionContent.Position = UDim2.new(0, 0, 0, 30)
            sectionContent.Size = UDim2.new(1, 0, 0, 0) -- Will be auto-sized
            sectionContent.ZIndex = 5
            sectionContent.Parent = sectionFrame
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 5)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Parent = sectionContent
            
            -- Auto-resize section
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(1, 0, 0, 30 + contentLayout.AbsoluteContentSize.Y + 5)
            end)
            
            sectionFrame.Parent = self.Content
            
            section.Frame = sectionFrame
            section.Content = sectionContent
            
            -- Create Toggle Function
            function section:CreateToggle(name, default, callback)
                default = default or false
                callback = callback or function() end
                
                local toggle = {}
                toggle.Value = default
                
                -- Toggle container
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = name .. "Toggle"
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Size = UDim2.new(1, 0, 0, 30)
                toggleFrame.ZIndex = 6
                
                -- Toggle name
                local toggleName = Instance.new("TextLabel")
                toggleName.Name = "Name"
                toggleName.BackgroundTransparency = 1
                toggleName.Position = UDim2.new(0, 10, 0, 0)
                toggleName.Size = UDim2.new(1, -60, 1, 0)
                toggleName.Font = Enum.Font.Gotham
                toggleName.Text = name
                toggleName.TextColor3 = TEXT_COLOR
                toggleName.TextSize = 14
                toggleName.TextXAlignment = Enum.TextXAlignment.Left
                toggleName.ZIndex = 7
                toggleName.Parent = toggleFrame
                
                -- Toggle button
                local toggleButton = Instance.new("Frame")
                toggleButton.Name = "Button"
                toggleButton.BackgroundColor3 = default and MAIN_COLOR or Color3.fromRGB(60, 60, 60)
                toggleButton.BorderSizePixel = 0
                toggleButton.Position = UDim2.new(1, -40, 0.5, -8)
                toggleButton.Size = UDim2.new(0, 30, 0, 16)
                toggleButton.ZIndex = 7
                toggleButton.Parent = toggleFrame
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(1, 0)
                buttonCorner.Parent = toggleButton
                
                -- Toggle knob
                local toggleKnob = Instance.new("Frame")
                toggleKnob.Name = "Knob"
                toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleKnob.BorderSizePixel = 0
                toggleKnob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                toggleKnob.Size = UDim2.new(0, 12, 0, 12)
                toggleKnob.ZIndex = 8
                toggleKnob.Parent = toggleButton
                
                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = toggleKnob
                
                -- Click detection (the entire frame is clickable)
                local clickArea = Instance.new("TextButton")
                clickArea.Name = "ClickArea"
                clickArea.BackgroundTransparency = 1
                clickArea.Size = UDim2.new(1, 0, 1, 0)
                clickArea.ZIndex = 9
                clickArea.Text = ""
                clickArea.Parent = toggleFrame
                
                toggleFrame.Parent = self.Content
                
                -- Toggle function
                local function updateToggle()
                    toggle.Value = not toggle.Value
                    
                    local knobPosition = toggle.Value and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                    local buttonColor = toggle.Value and MAIN_COLOR or Color3.fromRGB(60, 60, 60)
                    
                    createTween(toggleKnob, {Position = knobPosition}):Play()
                    createTween(toggleButton, {BackgroundColor3 = buttonColor}):Play()
                    
                    callback(toggle.Value)
                end
                
                clickArea.MouseButton1Click:Connect(updateToggle)
                
                toggle.Instance = toggleFrame
                toggle.Update = updateToggle
                
                return toggle
            end
            
            -- Create Slider Function
            function section:CreateSlider(name, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                callback = callback or function() end
                
                local slider = {}
                slider.Value = default
                slider.Min = min
                slider.Max = max
                
                -- Slider container
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = name .. "Slider"
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Size = UDim2.new(1, 0, 0, 40)
                sliderFrame.ZIndex = 6
                
                -- Slider name
                local sliderName = Instance.new("TextLabel")
                sliderName.Name = "Name"
                sliderName.BackgroundTransparency = 1
                sliderName.Position = UDim2.new(0, 10, 0, 0)
                sliderName.Size = UDim2.new(1, -60, 0, 20)
                sliderName.Font = Enum.Font.Gotham
                sliderName.Text = name
                sliderName.TextColor3 = TEXT_COLOR
                sliderName.TextSize = 14
                sliderName.TextXAlignment = Enum.TextXAlignment.Left
                sliderName.ZIndex = 7
                sliderName.Parent = sliderFrame
                
                -- Slider value display
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "Value"
                sliderValue.BackgroundTransparency = 1
                sliderValue.Position = UDim2.new(1, -50, 0, 0)
                sliderValue.Size = UDim2.new(0, 40, 0, 20)
                sliderValue.Font = Enum.Font.Gotham
                sliderValue.Text = tostring(default)
                sliderValue.TextColor3 = TEXT_COLOR
                sliderValue.TextSize = 14
                sliderValue.ZIndex = 7
                sliderValue.Parent = sliderFrame
                
                -- Slider background
                local sliderBg = Instance.new("Frame")
                sliderBg.Name = "Background"
                sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                sliderBg.BorderSizePixel = 0
                sliderBg.Position = UDim2.new(0, 10, 0, 25)
                sliderBg.Size = UDim2.new(1, -20, 0, 5)
                sliderBg.ZIndex = 7
                sliderBg.Parent = sliderFrame
                
                local bgCorner = Instance.new("UICorner")
                bgCorner.CornerRadius = UDim.new(1, 0)
                bgCorner.Parent = sliderBg
                
                -- Slider fill
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.BackgroundColor3 = MAIN_COLOR
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.ZIndex = 8
                sliderFill.Parent = sliderBg
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = sliderFill
                
                -- Slider knob
                local sliderKnob = Instance.new("Frame")
                sliderKnob.Name = "Knob"
                sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderKnob.BorderSizePixel = 0
                sliderKnob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
                sliderKnob.Size = UDim2.new(0, 12, 0, 12)
                sliderKnob.ZIndex = 9
                sliderKnob.Parent = sliderBg
                
                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = sliderKnob
                
                -- Click detection
                local clickArea = Instance.new("TextButton")
                clickArea.Name = "ClickArea"
                clickArea.BackgroundTransparency = 1
                clickArea.Size = UDim2.new(1, 0, 1, 0)
                clickArea.ZIndex = 10
                clickArea.Text = ""
                clickArea.Parent = sliderBg
                
                sliderFrame.Parent = self.Content
                
                -- Update function
                local function updateSlider(input)
                    local sizeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * sizeX)
                    
                    -- Update slider position and fill
                    sliderKnob.Position = UDim2.new(sizeX, -6, 0.5, -6)
                    sliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                    
                    -- Update value
                    slider.Value = value
                    sliderValue.Text = tostring(value)
                    
                    callback(value)
                end
                
                -- Slider interaction
                local dragging = false
                
                clickArea.MouseButton1Down:Connect(function()
                    dragging = true
                    updateSlider({Position = Mouse})
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                        updateSlider({Position = Mouse})
                    end
                end)
                
                slider.Instance = sliderFrame
                slider.Set = function(value)
                    value = math.clamp(value, min, max)
                    local sizeX = (value - min) / (max - min)
                    
                    sliderKnob.Position = UDim2.new(sizeX, -6, 0.5, -6)
                    sliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
                    
                    slider.Value = value
                    sliderValue.Text = tostring(value)
                    
                    callback(value)
                end
                
                return slider
            end
            
            -- Create Dropdown Function
            function section:CreateDropdown(name, options, default, callback)
                options = options or {}
                default = default or (options[1] or "")
                callback = callback or function() end
                
                local dropdown = {}
                dropdown.Value = default
                dropdown.Options = options
                dropdown.Open = false
                
                -- Dropdown container
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = name .. "Dropdown"
                dropdownFrame.BackgroundTransparency = 1
                dropdownFrame.Size = UDim2.new(1, 0, 0, 60) -- Will be auto-sized
                dropdownFrame.ZIndex = 6
                dropdownFrame.ClipsDescendants = true
                
                -- Dropdown name
                local dropdownName = Instance.new("TextLabel")
                dropdownName.Name = "Name"
                dropdownName.BackgroundTransparency = 1
                dropdownName.Position = UDim2.new(0, 10, 0, 0)
                dropdownName.Size = UDim2.new(1, -20, 0, 20)
                dropdownName.Font = Enum.Font.Gotham
                dropdownName.Text = name
                dropdownName.TextColor3 = TEXT_COLOR
                dropdownName.TextSize = 14
                dropdownName.TextXAlignment = Enum.TextXAlignment.Left
                dropdownName.ZIndex = 7
                dropdownName.Parent = dropdownFrame
                
                -- Dropdown button
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "Button"
                dropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                dropdownButton.BorderSizePixel = 0
                dropdownButton.Position = UDim2.new(0, 10, 0, 25)
                dropdownButton.Size = UDim2.new(1, -20, 0, 30)
                dropdownButton.Font = Enum.Font.Gotham
                dropdownButton.Text = ""
                dropdownButton.TextColor3 = TEXT_COLOR
                dropdownButton.TextSize = 14
                dropdownButton.ZIndex = 7
                dropdownButton.AutoButtonColor = false
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UI_CORNER_RADIUS
                buttonCorner.Parent = dropdownButton
                
                -- Selected value text
                local selectedValue = Instance.new("TextLabel")
                selectedValue.Name = "Value"
                selectedValue.BackgroundTransparency = 1
                selectedValue.Position = UDim2.new(0, 10, 0, 0)
                selectedValue.Size = UDim2.new(1, -40, 1, 0)
                selectedValue.Font = Enum.Font.Gotham
                selectedValue.Text = default
                selectedValue.TextColor3 = TEXT_COLOR
                selectedValue.TextSize = 14
                selectedValue.TextXAlignment = Enum.TextXAlignment.Left
                selectedValue.ZIndex = 8
                selectedValue.Parent = dropdownButton
                
                -- Arrow icon
                local arrowIcon = Instance.new("ImageLabel")
                arrowIcon.Name = "Arrow"
                arrowIcon.BackgroundTransparency = 1
                arrowIcon.Position = UDim2.new(1, -25, 0.5, -8)
                arrowIcon.Size = UDim2.new(0, 16, 0, 16)
                arrowIcon.Image = "rbxassetid://6034818372" -- Down arrow
                arrowIcon.ZIndex = 8
                arrowIcon.Parent = dropdownButton
                
                -- Options container
                local optionsFrame = Instance.new("Frame")
                optionsFrame.Name = "Options"
                optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                optionsFrame.BorderSizePixel = 0
                optionsFrame.Position = UDim2.new(0, 10, 0, 60)
                optionsFrame.Size = UDim2.new(1, -20, 0, 0) -- Will be auto-sized
                optionsFrame.ZIndex = 9
                optionsFrame.Visible = false
                optionsFrame.ClipsDescendants = true
                
                local optionsCorner = Instance.new("UICorner")
                optionsCorner.CornerRadius = UI_CORNER_RADIUS
                optionsCorner.Parent = optionsFrame
                
                local optionsList = Instance.new("UIListLayout")
                optionsList.Padding = UDim.new(0, 2)
                optionsList.SortOrder = Enum.SortOrder.LayoutOrder
                optionsList.Parent = optionsFrame
                
                dropdownButton.Parent = dropdownFrame
                optionsFrame.Parent = dropdownFrame
                dropdownFrame.Parent = self.Content
                
                -- Create option buttons
                local function createOptions()
                    -- Clear previous options
                    for _, child in pairs(optionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Create new options
                    for i, optionText in pairs(options) do
                        local optionButton = Instance.new("TextButton")
                        optionButton.Name = "Option_" .. i
                        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        optionButton.BorderSizePixel = 0
                        optionButton.Size = UDim2.new(1, 0, 0, 25)
                        optionButton.Font = Enum.Font.Gotham
                        optionButton.Text = optionText
                        optionButton.TextColor3 = TEXT_COLOR
                        optionButton.TextSize = 14
                        optionButton.ZIndex = 10
                        optionButton.Parent = optionsFrame
                        
                        -- Option selection
                        optionButton.MouseButton1Click:Connect(function()
                            dropdown.Value = optionText
                            selectedValue.Text = optionText
                            dropdown:Toggle()
                            callback(optionText)
                        end)
                        
                        -- Hover effect
                        optionButton.MouseEnter:Connect(function()
                            createTween(optionButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            createTween(optionButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                        end)
                    end
                    
                    -- Set options frame size based on number of options
                    local optionsCount = #options
                    local optionsHeight = math.min(optionsCount * 27, 100)
                    optionsFrame.Size = UDim2.new(1, -20, 0, optionsHeight)
                    
                    -- Update dropdown frame size if open
                    if dropdown.Open then
                        dropdownFrame.Size = UDim2.new(1, 0, 0, 60 + optionsHeight)
                    else
                        dropdownFrame.Size = UDim2.new(1, 0, 0, 60)
                    end
                end
                
                -- Toggle dropdown function
                function dropdown:Toggle()
                    self.Open = not self.Open
                    
                    if self.Open then
                        -- Make options visible and expand
                        optionsFrame.Visible = true
                        createTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 60 + optionsFrame.Size.Y.Offset)}):Play()
                        createTween(arrowIcon, {Rotation = 180}):Play()
                    else
                        -- Hide options and collapse
                        createTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 60)}):Play()
                        createTween(arrowIcon, {Rotation = 0}):Play()
                        
                        task.delay(0.2, function()
                            optionsFrame.Visible = false
                        end)
                    end
                end
                
                -- Set dropdown options
                function dropdown:SetOptions(newOptions, newDefault)
                    self.Options = newOptions
                    
                    if newDefault then
                        self.Value = newDefault
                        selectedValue.Text = newDefault
                    elseif not table.find(newOptions, self.Value) then
                        self.Value = newOptions[1] or ""
                        selectedValue.Text = self.Value
                    end
                    
                    createOptions()
                end
                
                -- Toggle on button click
                dropdownButton.MouseButton1Click:Connect(function()
                    dropdown:Toggle()
                end)
                
                -- Button hover effect
                dropdownButton.MouseEnter:Connect(function()
                    createTween(dropdownButton, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                end)
                
                dropdownButton.MouseLeave:Connect(function()
                    createTween(dropdownButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                end)
                
                -- Initialize options
                createOptions()
                
                dropdown.Instance = dropdownFrame
                
                return dropdown
            end
            
            -- Create Button Function
            function section:CreateButton(name, callback)
                callback = callback or function() end
                
                local button = {}
                
                -- Button container
                local buttonFrame = Instance.new("Frame")
                buttonFrame.Name = name .. "Button"
                buttonFrame.BackgroundTransparency = 1
                buttonFrame.Size = UDim2.new(1, 0, 0, 35)
                buttonFrame.ZIndex = 6
                
                -- Button
                local buttonInstance = Instance.new("TextButton")
                buttonInstance.Name = "Button"
                buttonInstance.BackgroundColor3 = MAIN_COLOR
                buttonInstance.BorderSizePixel = 0
                buttonInstance.Position = UDim2.new(0, 10, 0, 5)
                buttonInstance.Size = UDim2.new(1, -20, 0, 30)
                buttonInstance.Font = Enum.Font.GothamBold
                buttonInstance.Text = name
                buttonInstance.TextColor3 = TEXT_COLOR
                buttonInstance.TextSize = 14
                buttonInstance.ZIndex = 7
                buttonInstance.AutoButtonColor = false
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UI_CORNER_RADIUS
                buttonCorner.Parent = buttonInstance
                
                buttonInstance.Parent = buttonFrame
                buttonFrame.Parent = self.Content
                
                -- Button click
                buttonInstance.MouseButton1Click:Connect(function()
                    -- Click animation
                    createTween(buttonInstance, {BackgroundColor3 = DARKER_COLOR}, 0.1):Play()
                    task.delay(0.1, function()
                        createTween(buttonInstance, {BackgroundColor3 = MAIN_COLOR}, 0.1):Play()
                    end)
                    
                    callback()
                end)
                
                -- Button hover effect
                buttonInstance.MouseEnter:Connect(function()
                    createTween(buttonInstance, {BackgroundColor3 = HOVER_COLOR}):Play()
                end)
                
                buttonInstance.MouseLeave:Connect(function()
                    createTween(buttonInstance, {BackgroundColor3 = MAIN_COLOR}):Play()
                end)
                
                button.Instance = buttonFrame
                
                return button
            end
                        
            -- Create Label Function
            function section:CreateLabel(text)
                local label = {}
                
                -- Label container
                local labelFrame = Instance.new("Frame")
                labelFrame.Name = "Label"
                labelFrame.BackgroundTransparency = 1
                labelFrame.Size = UDim2.new(1, 0, 0, 25)
                labelFrame.ZIndex = 6
                
                -- Label text
                local labelText = Instance.new("TextLabel")
                labelText.Name = "Text"
                labelText.BackgroundTransparency = 1
                labelText.Position = UDim2.new(0, 10, 0, 0)
                labelText.Size = UDim2.new(1, -20, 1, 0)
                labelText.Font = Enum.Font.Gotham
                labelText.Text = text
                labelText.TextColor3 = TEXT_COLOR
                labelText.TextSize = 14
                labelText.TextXAlignment = Enum.TextXAlignment.Left
                labelText.ZIndex = 7
                labelText.Parent = labelFrame
                
                labelFrame.Parent = self.Content
                
                -- Update function
                function label:SetText(newText)
                    labelText.Text = newText
                end
                
                label.Instance = labelFrame
                
                return label
            end
            
            table.insert(self.Sections, section)
            return section
        end
        
        -- Create Button directly on tab
        function tab:CreateButton(name, callback)
            local button = Instance.new("TextButton")
            button.Name = name .. "Button"
            button.BackgroundColor3 = MAIN_COLOR
            button.BorderSizePixel = 0
            button.Position = UDim2.new(0, 10, 0, 10)
            button.Size = UDim2.new(1, -20, 0, 30)
            button.Font = Enum.Font.GothamBold
            button.Text = name
            button.TextColor3 = TEXT_COLOR
            button.TextSize = 14
            button.ZIndex = 5
            button.AutoButtonColor = false
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UI_CORNER_RADIUS
            buttonCorner.Parent = button
            
            button.Parent = self.Content
            
            -- Create shadow
            createShadow(button, 0.5)
            
            -- Click event
            button.MouseButton1Click:Connect(function()
                -- Animation
                createTween(button, {BackgroundColor3 = DARKER_COLOR}, 0.1):Play()
                task.delay(0.1, function()
                    createTween(button, {BackgroundColor3 = MAIN_COLOR}, 0.1):Play()
                end)
                
                if callback then
                    callback()
                end
            end)
            
            -- Hover effects
            button.MouseEnter:Connect(function()
                createTween(button, {BackgroundColor3 = HOVER_COLOR}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                createTween(button, {BackgroundColor3 = MAIN_COLOR}):Play()
            end)
            
            return button
        end
        
        return tab
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Cleanup function
function AquaLib:Destroy()
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    
    for _, win in pairs(self.Windows) do
        if win.Gui and win.Gui.Parent then
            win.Gui:Destroy()
        end
    end
    
    self.Windows = {}
    self.Connections = {}
    
    if self.NotificationContainer and self.NotificationContainer.Parent then
        self.NotificationContainer.Parent:Destroy()
    end
    
    _G.AquaLibLoaded = nil
    _G.AquaLib = nil
end

-- Initialize and return the library
return AquaLib:Init()
