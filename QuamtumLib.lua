-- QuantumUI v1.1 - Advanced Roblox UI Library by QuantumAI (Unrestricted Edition)
-- Designed for exploits/hacks. Load with: local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSER/YOURREPO/main/QuantumUI.lua"))()
-- Features: Windows, Tabs, Sections, Button, Toggle, Slider, Dropdown, Textbox, Label, ColorPicker (fully functional), Keybind, Notifications (with types, duration, stacking, and animations)
-- New: CreateLib now accepts title, themeName, libType ("normal" or "overlay") for different UI modes. Improved animations throughout.

local QuantumUI = {}
QuantumUI.__index = QuantumUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Helper functions (error-free, optimized)
local function createInstance(class, props)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do
        inst[prop] = value
    end
    return inst
end

local function tweenObject(obj, props, duration, easingStyle, easingDirection)
    TweenService:Create(obj, TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out), props):Play()
end

local function getTheme(themeName)
    local themes = {
        Dark = {
            Background = Color3.fromRGB(30, 30, 30),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(255, 255, 255),
            Secondary = Color3.fromRGB(45, 45, 45),
            Border = Color3.fromRGB(60, 60, 60)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(0, 0, 0),
            Secondary = Color3.fromRGB(220, 220, 220),
            Border = Color3.fromRGB(200, 200, 200)
        },
        -- Add more themes as needed
    }
    return themes[themeName] or themes.Dark
end

-- Notification system (global, stackable from bottom-right, with smooth animations and proper overlapping handling)
local notifications = {}
function QuantumUI:Notify(title, text, duration, type)
    local notifyGui = createInstance("ScreenGui", {Parent = game.CoreGui or Players.LocalPlayer.PlayerGui, IgnoreGuiInset = true})
    local frame = createInstance("Frame", {
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, 10, 1, -90 - (#notifications * 90)),  -- Start slightly off-screen to the right for slide-in animation
        BackgroundColor3 = getTheme("Dark").Background,
        BorderColor3 = getTheme("Dark").Border,
        Parent = notifyGui
    })
    createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = frame})
    
    local titleLabel = createInstance("TextLabel", {
        Text = title or "Notification",
        TextColor3 = getTheme("Dark").Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
        Parent = frame
    })
    
    local textLabel = createInstance("TextLabel", {
        Text = text or "",
        TextColor3 = getTheme("Dark").Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -30),
        Position = UDim2.new(0, 10, 0, 25),
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextWrapped = true,
        Parent = frame
    })
    
    -- Type-based accent
    local accentColor = type == "success" and Color3.fromRGB(0, 255, 0) or type == "error" and Color3.fromRGB(255, 0, 0) or getTheme("Dark").Accent
    createInstance("Frame", {Size = UDim2.new(0, 5, 1, 0), BackgroundColor3 = accentColor, Parent = frame})
    
    table.insert(notifications, frame)
    
    -- Slide-in animation from right
    tweenObject(frame, {Position = UDim2.new(1, -310, 1, -90 - (#notifications * 90))}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.delay(duration or 5, function()
        -- Slide-out animation to right
        tweenObject(frame, {Position = UDim2.new(1, 10, frame.Position.Y.Scale, frame.Position.Y.Offset)}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.5)
        notifyGui:Destroy()
        local index = table.find(notifications, frame)
        if index then table.remove(notifications, index) end
        -- Smoothly animate remaining notifications upward
        for i, notif in ipairs(notifications) do
            tweenObject(notif, {Position = UDim2.new(1, -310, 1, -90 - (i * 90))}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end)
end

-- Main Library Creation (now with libType: "normal" for draggable window, "overlay" for fixed overlay menu)
function QuantumUI.CreateLib(title, themeName, libType)
    local self = setmetatable({}, QuantumUI)
    self.Theme = getTheme(themeName)
    self.Tabs = {}
    self.Minimized = false
    self.LibType = libType or "normal"  -- "normal" or "overlay"
    
    -- Main GUI Setup
    self.ScreenGui = createInstance("ScreenGui", {Parent = game.CoreGui or Players.LocalPlayer.PlayerGui, IgnoreGuiInset = true})
    self.MainFrame = createInstance("Frame", {
        Size = UDim2.new(0, 600, 0, 400),
        Position = self.LibType == "overlay" and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, -300, 0.5, -200),  -- Overlay is fixed top-left
        BackgroundColor3 = self.Theme.Background,
        BorderColor3 = self.Theme.Border,
        Parent = self.ScreenGui
    })
    createInstance("UICorner", {CornerRadius = UDim.new(0, 8), Parent = self.MainFrame})
    
    -- Title Bar (hidden in overlay mode)
    if self.LibType ~= "overlay" then
        self.TitleBar = createInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = self.Theme.Secondary,
            Parent = self.MainFrame
        })
        self.TitleLabel = createInstance("TextLabel", {
            Text = title or "QuantumUI",
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18,
            Parent = self.TitleBar
        })
        
        -- Minimize Button
        local minButton = createInstance("TextButton", {
            Text = "-",
            TextColor3 = self.Theme.Text,
            BackgroundColor3 = self.Theme.Accent,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -55, 0, 2.5),
            Parent = self.TitleBar
        })
        createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = minButton})
        minButton.MouseButton1Click:Connect(function()
            self.Minimized = not self.Minimized
            tweenObject(self.MainFrame, {Size = self.Minimized and UDim2.new(0, 600, 0, 30) or UDim2.new(0, 600, 0, 400)}, 0.3, Enum.EasingStyle.Sine)
        end)
        
        -- Close Button
        local closeButton = createInstance("TextButton", {
            Text = "X",
            TextColor3 = self.Theme.Text,
            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -25, 0, 2.5),
            Parent = self.TitleBar
        })
        createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = closeButton})
        closeButton.MouseButton1Click:Connect(function()
            self.ScreenGui:Destroy()
        end)
        
        -- Draggable (only for normal mode)
        local dragging, dragInput, dragStart, startPos
        self.TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = self.MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        self.TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    else
        -- Overlay mode: No title bar, full screen overlay or fixed, add a close button in corner
        local closeButton = createInstance("TextButton", {
            Text = "X",
            TextColor3 = self.Theme.Text,
            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -25, 0, 0),
            Parent = self.MainFrame
        })
        createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = closeButton})
        closeButton.MouseButton1Click:Connect(function()
            tweenObject(self.MainFrame, {Position = UDim2.new(0, -600, 0, 0)}, 0.5, Enum.EasingStyle.Quad)  -- Slide out left
            task.wait(0.5)
            self.ScreenGui:Destroy()
        end)
        -- Slide-in animation for overlay
        self.MainFrame.Position = UDim2.new(0, -600, 0, 0)
        tweenObject(self.MainFrame, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Quad)
    end
    
    -- Tab Container
    self.TabContainer = createInstance("Frame", {
        Size = UDim2.new(1, 0, 1, self.LibType == "overlay" and 0 or -30),
        Position = UDim2.new(0, 0, 0, self.LibType == "overlay" and 0 or 30),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })
    self.TabList = createInstance("Frame", {
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = self.Theme.Secondary,
        Parent = self.TabContainer
    })
    createInstance("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = self.TabList})
    
    self.ContentContainer = createInstance("Frame", {
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 150, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.TabContainer
    })
    
    return self
end

-- New Tab (with improved selection animation)
function QuantumUI:NewTab(name)
    local tab = {}
    tab.Sections = {}
    tab.Visible = false
    
    -- Tab Button
    tab.Button = createInstance("TextButton", {
        Text = name or "Tab",
        TextColor3 = self.Theme.Text,
        BackgroundColor3 = self.Theme.Background,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = self.TabList
    })
    createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = tab.Button})
    
    tab.Button.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Visible = false
            t.Content.Visible = false
            tweenObject(t.Button, {BackgroundColor3 = self.Theme.Background}, 0.2, Enum.EasingStyle.Sine)
        end
        tab.Visible = true
        tab.Content.Visible = true
        tweenObject(tab.Button, {BackgroundColor3 = self.Theme.Accent}, 0.2, Enum.EasingStyle.Sine)
        tweenObject(tab.Content, {CanvasPosition = Vector2.new(0, 0)}, 0.3)  -- Reset scroll on tab switch
    end)
    
    -- Tab Content
    tab.Content = createInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        Visible = false,
        Parent = self.ContentContainer
    })
    createInstance("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = tab.Content})
    
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then tab.Button:Invoke() end  -- Select first tab by default
    
    -- New Section
    function tab:NewSection(name)
        local section = {}
        section.Elements = {}
        
        section.Frame = createInstance("Frame", {
            Size = UDim2.new(1, -10, 0, 0),
            BackgroundColor3 = self.Theme.Secondary,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = tab.Content
        })
        createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = section.Frame})
        createInstance("UIPadding", {Padding = UDim.new(0, 10), Parent = section.Frame})  -- Fixed: Use UIPadding correctly
        section.Layout = createInstance("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = section.Frame})
        
        section.Title = createInstance("TextLabel", {
            Text = name or "Section",
            TextColor3 = self.Theme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Font = Enum.Font.SourceSansBold,
            TextSize = 16,
            Parent = section.Frame
        })
        
        -- Auto-update canvas size (improved to handle multiple sections)
        local function updateCanvas()
            local totalHeight = 0
            for _, child in ipairs(tab.Content:GetChildren()) do
                if child:IsA("Frame") then totalHeight = totalHeight + child.AbsoluteSize.Y + 10 end
            end
            tab.Content.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        end
        section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        updateCanvas()
        
        -- New Button (with better click animation)
        function section:NewButton(name, desc, callback)
            local button = createInstance("TextButton", {
                Text = name or "Button",
                TextColor3 = self.Theme.Text,
                BackgroundColor3 = self.Theme.Background,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = section.Frame
            })
            createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = button})
            
            -- Tooltip for desc (improved positioning)
            if desc then
                local tooltip = createInstance("TextLabel", {
                    Text = desc,
                    BackgroundColor3 = Color3.fromRGB(0,0,0),
                    TextColor3 = Color3.fromRGB(255,255,255),
                    Visible = false,
                    Size = UDim2.new(0, 200, 0, 50),
                    Position = UDim2.new(0, 0, 1, 5),
                    Parent = button
                })
                createInstance("UICorner", {Parent = tooltip})
                button.MouseEnter:Connect(function() tooltip.Visible = true end)
                button.MouseLeave:Connect(function() tooltip.Visible = false end)
            end
            
            button.MouseButton1Click:Connect(function()
                if callback then callback() end
                tweenObject(button, {BackgroundColor3 = self.Theme.Accent, Size = UDim2.new(1, 0, 0, 28)}, 0.1, Enum.EasingStyle.Linear)
                task.delay(0.1, function() tweenObject(button, {BackgroundColor3 = self.Theme.Background, Size = UDim2.new(1, 0, 0, 30)}, 0.1, Enum.EasingStyle.Linear) end)
            end)
            
            table.insert(section.Elements, button)
            updateCanvas()
        end
        
        -- New Toggle (with smoother animation)
        function section:NewToggle(name, default, callback)
            local toggled = default or false
            local toggleFrame = createInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = section.Frame
            })
            local label = createInstance("TextLabel", {
                Text = name or "Toggle",
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 1, 0),
                Parent = toggleFrame
            })
            local toggleButton = createInstance("Frame", {
                Size = UDim2.new(0, 30, 0, 15),
                Position = UDim2.new(1, -30, 0.5, -7.5),
                BackgroundColor3 = toggled and self.Theme.Accent or self.Theme.Border,
                Parent = toggleFrame
            })
            createInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = toggleButton})
            local circle = createInstance("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(toggled and 0.5 or 0, 0, -0.15, 0),
                BackgroundColor3 = self.Theme.Text,
                Parent = toggleButton
            })
            createInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = circle})
            
            toggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggled = not toggled
                    tweenObject(circle, {Position = UDim2.new(toggled and 0.5 or 0, 0, -0.15, 0)}, 0.2, Enum.EasingStyle.Sine)
                    tweenObject(toggleButton, {BackgroundColor3 = toggled and self.Theme.Accent or self.Theme.Border}, 0.2, Enum.EasingStyle.Sine)
                    if callback then callback(toggled) end
                end
            end)
            
            table.insert(section.Elements, toggleFrame)
            updateCanvas()
            return {
                Set = function(val)
                    toggled = val
                    tweenObject(circle, {Position = UDim2.new(toggled and 0.5 or 0, 0, -0.15, 0)}, 0.2, Enum.EasingStyle.Sine)
                    tweenObject(toggleButton, {BackgroundColor3 = toggled and self.Theme.Accent or self.Theme.Border}, 0.2, Enum.EasingStyle.Sine)
                end
            }
        end
        
        -- New Slider (with precise dragging and animation)
        function section:NewSlider(name, min, max, default, callback)
            local value = math.clamp(default or min, min, max)
            local sliderFrame = createInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Parent = section.Frame
            })
            local label = createInstance("TextLabel", {
                Text = name .. ": " .. value,
                TextColor3 = self.Theme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Parent = sliderFrame
            })
            local sliderBar = createInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 0, 20),
                BackgroundColor3 = self.Theme.Border,
                Parent = sliderFrame
            })
            createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = sliderBar})
            local fill = createInstance("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = self.Theme.Accent,
                Parent = sliderBar
            })
            createInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = fill})
            
            local dragging = false
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(functi
