--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                   DELUXE UI LIBRARY                       ║
    ║                Created by: Isme/TheQuestian               ║
    ╚═══════════════════════════════════════════════════════════╝
]]

local Library = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Theme Configuration
Library.Theme = {
    Primary = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 30),
    Tertiary = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentHover = Color3.fromRGB(158, 63, 246),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(170, 170, 170),
    Success = Color3.fromRGB(46, 204, 113),
    Error = Color3.fromRGB(231, 76, 60),
    Info = Color3.fromRGB(52, 152, 219),
    Warning = Color3.fromRGB(241, 196, 15),
    Border = Color3.fromRGB(45, 45, 50)
}

-- Configuration Storage
Library.Flags = {}
Library.ConfigFolder = "LibraryConfigs"

-- Create config folder if it doesn't exist
if not isfolder(Library.ConfigFolder) then
    makefolder(Library.ConfigFolder)
end

-- Notification System
local NotificationHolder = nil

function Library:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Message or "No message provided"
    local duration = options.Duration or 3
    local type = options.Type or "Info"
    
    -- Create notification holder if it doesn't exist
    if not NotificationHolder then
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "NotificationHolder"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.DisplayOrder = 999999
        ScreenGui.Parent = LocalPlayer.PlayerGui
        
        NotificationHolder = Instance.new("Frame")
        NotificationHolder.Name = "Holder"
        NotificationHolder.Size = UDim2.new(0, 320, 1, -20)
        NotificationHolder.Position = UDim2.new(1, -330, 0, 10)
        NotificationHolder.BackgroundTransparency = 1
        NotificationHolder.Parent = ScreenGui
        
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 10)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        Layout.Parent = NotificationHolder
    end
    
    -- Determine color based on type
    local notifColor = self.Theme.Info
    local icon = "ℹ️"
    
    if type == "Success" then
        notifColor = self.Theme.Success
        icon = "✓"
    elseif type == "Error" then
        notifColor = self.Theme.Error
        icon = "✕"
    elseif type == "Warning" then
        notifColor = self.Theme.Warning
        icon = "⚠"
    end
    
    -- Create notification
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 0)
    Notification.BackgroundColor3 = self.Theme.Secondary
    Notification.BorderSizePixel = 0
    Notification.ClipsDescendants = true
    Notification.Parent = NotificationHolder
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Notification
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = notifColor
    Stroke.Thickness = 2
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Notification
    
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(1, 0, 0, 3)
    Accent.BackgroundColor3 = notifColor
    Accent.BorderSizePixel = 0
    Accent.Parent = Notification
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 10)
    AccentCorner.Parent = Accent
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 10, 0, 15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextColor3 = notifColor
    IconLabel.TextSize = 20
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = Notification
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 0, 20)
    Title.Position = UDim2.new(0, 45, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = self.Theme.Text
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Notification
    
    local Message = Instance.new("TextLabel")
    Message.Size = UDim2.new(1, -55, 1, -35)
    Message.Position = UDim2.new(0, 45, 0, 32)
    Message.BackgroundTransparency = 1
    Message.Text = message
    Message.TextColor3 = self.Theme.TextDim
    Message.TextSize = 13
    Message.Font = Enum.Font.Gotham
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.TextYAlignment = Enum.TextYAlignment.Top
    Message.TextWrapped = true
    Message.Parent = Notification
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = self.Theme.TextDim
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Notification
    
    -- Calculate content height
    local textHeight = Message.TextBounds.Y
    local finalHeight = math.max(80, textHeight + 45)
    
    -- Animate in
    Notification:TweenSize(
        UDim2.new(1, 0, 0, finalHeight),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quint,
        0.4,
        true
    )
    
    -- Progress bar
    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new(0, 0, 0, 3)
    Progress.Position = UDim2.new(0, 0, 1, -3)
    Progress.BackgroundColor3 = notifColor
    Progress.BorderSizePixel = 0
    Progress.Parent = Notification
    
    TweenService:Create(
        Progress,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(1, 0, 0, 3)}
    ):Play()
    
    -- Close function
    local function Close()
        TweenService:Create(
            Notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint),
            {Size = UDim2.new(1, 0, 0, 0)}
        ):Play()
        
        task.wait(0.3)
        Notification:Destroy()
    end
    
    CloseBtn.MouseButton1Click:Connect(Close)
    
    task.delay(duration, Close)
end

-- Create Window
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "UI Library"
    local subtitle = options.Subtitle or "v1.0"
    local configName = options.ConfigName or "config"
    local autoSave = options.AutoSave or false
    local size = options.Size or UDim2.new(0, 550, 0, 600)
    
    local Window = {}
    Window.Flags = {}
    Window.ConfigName = configName
    Window.AutoSave = autoSave
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary_" .. HttpService:GenerateGUID(false)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100
    ScreenGui.Parent = LocalPlayer.PlayerGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = size
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Library.Theme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.Border
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Library.Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    local TopFix = Instance.new("Frame")
    TopFix.Size = UDim2.new(1, 0, 0, 25)
    TopFix.Position = UDim2.new(0, 0, 1, -25)
    TopFix.BackgroundColor3 = Library.Theme.Secondary
    TopFix.BorderSizePixel = 0
    TopFix.Parent = TopBar
    
    -- Logo/Icon
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.BackgroundColor3 = Library.Theme.Accent
    Logo.Text = "🎮"
    Logo.TextColor3 = Library.Theme.Text
    Logo.TextSize = 20
    Logo.Font = Enum.Font.GothamBold
    Logo.Parent = TopBar
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = Logo
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.Position = UDim2.new(0, 60, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Library.Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 15)
    SubtitleLabel.Position = UDim2.new(0, 60, 0, 28)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = subtitle
    SubtitleLabel.TextColor3 = Library.Theme.TextDim
    SubtitleLabel.TextSize = 12
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TopBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    MinimizeBtn.Position = UDim2.new(1, -80, 0, 7.5)
    MinimizeBtn.BackgroundColor3 = Library.Theme.Tertiary
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Library.Theme.Text
    MinimizeBtn.TextSize = 16
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TopBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -40, 0, 7.5)
    CloseBtn.BackgroundColor3 = Library.Theme.Error
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Library.Theme.Text
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundColor3 = Library.Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.PaddingBottom = UDim.new(0, 8)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -165, 1, -60)
    ContentContainer.Position = UDim2.new(0, 155, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Dragging
    local dragging = false
    local dragInput, mousePos, framePos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Minimize
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = UDim2.new(0, size.X.Offset, 0, 50)
            }):Play()
            MinimizeBtn.Text = "+"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Size = size
            }):Play()
            MinimizeBtn.Text = "—"
        end
    end)
    
    -- Close
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Tab System
    local Tabs = {}
    local CurrentTab = nil
    
    function Window:CreateTab(options)
        options = options or {}
        local name = options.Name or "Tab"
        local icon = options.Icon or "📁"
        
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 38)
        TabButton.BackgroundColor3 = Library.Theme.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        TabButton.Parent = TabContainer
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabButton
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Size = UDim2.new(0, 25, 1, 0)
        TabIcon.Position = UDim2.new(0, 5, 0, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = icon
        TabIcon.TextColor3 = Library.Theme.TextDim
        TabIcon.TextSize = 16
        TabIcon.Font = Enum.Font.GothamBold
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -35, 1, 0)
        TabLabel.Position = UDim2.new(0, 30, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Library.Theme.TextDim
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Library.Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 8)
        ContentPadding.PaddingLeft = UDim.new(0, 8)
        ContentPadding.PaddingRight = UDim.new(0, 18)
        ContentPadding.PaddingBottom = UDim.new(0, 8)
        ContentPadding.Parent = TabContent
        
        -- Tab Button Click
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Tertiary
                }):Play()
                tab.Icon.TextColor3 = Library.Theme.TextDim
                tab.Label.TextColor3 = Library.Theme.TextDim
                tab.Content.Visible = false
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Accent
            }):Play()
            TabIcon.TextColor3 = Library.Theme.Text
            TabLabel.TextColor3 = Library.Theme.Text
            TabContent.Visible = true
            CurrentTab = Tab
        end)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= Tab then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Border
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= Tab then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Tertiary
                }):Play()
            end
        end)
        
        Tab.Button = TabButton
        Tab.Icon = TabIcon
        Tab.Label = TabLabel
        Tab.Content = TabContent
        
        table.insert(Tabs, Tab)
        
        -- Elements
        function Tab:CreateSection(name)
            local Section = Instance.new("Frame")
            Section.Name = name
            Section.Size = UDim2.new(1, 0, 0, 35)
            Section.BackgroundTransparency = 1
            Section.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = name
            SectionLabel.TextColor3 = Library.Theme.Text
            SectionLabel.TextSize = 15
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Section
            
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 1)
            Divider.Position = UDim2.new(0, 0, 1, -5)
            Divider.BackgroundColor3 = Library.Theme.Border
            Divider.BorderSizePixel = 0
            Divider.Parent = Section
            
            return Section
        end
        
        function Tab:CreateToggle(options)
            options = options or {}
            local name = options.Name or "Toggle"
            local flag = options.Flag
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Library.Theme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -55, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Library.Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Position = UDim2.new(1, -52, 0.5, -11)
            ToggleButton.BackgroundColor3 = Library.Theme.Tertiary
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
            ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -9)
            ToggleIndicator.BackgroundColor3 = Library.Theme.TextDim
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            local toggled = default
            
            local function SetState(state)
                toggled = state
                
                if toggled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        BackgroundColor3 = Library.Theme.Accent
                    }):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Position = UDim2.new(1, -20, 0.5, -9),
                        BackgroundColor3 = Library.Theme.Text
                    }):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        BackgroundColor3 = Library.Theme.Tertiary
                    }):Play()
                    TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Position = UDim2.new(0, 2, 0.5, -9),
                        BackgroundColor3 = Library.Theme.TextDim
                    }):Play()
                end
                
                if flag then
                    Library.Flags[flag] = toggled
                    Window.Flags[flag] = toggled
                end
                
                callback(toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                SetState(not toggled)
            end)
            
            if flag then
                Library.Flags[flag] = toggled
                Window.Flags[flag] = toggled
            end
            
            SetState(default)
            
            return {SetState = SetState}
        end
        
        function Tab:CreateSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local flag = options.Flag
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local decimals = options.Decimals or 0
            local callback = options.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = Library.Theme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -70, 0, 20)
            SliderLabel.Position = UDim2.new(0, 12, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = name
            SliderLabel.TextColor3 = Library.Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local ValueBox = Instance.new("TextBox")
            ValueBox.Size = UDim2.new(0, 55, 0, 24)
            ValueBox.Position = UDim2.new(1, -62, 0, 6)
            ValueBox.BackgroundColor3 = Library.Theme.Tertiary
            ValueBox.BorderSizePixel = 0
            ValueBox.Text = tostring(default)
            ValueBox.TextColor3 = Library.Theme.Accent
            ValueBox.TextSize = 13
            ValueBox.Font = Enum.Font.GothamBold
            ValueBox.Parent = SliderFrame
            
            local ValueCorner = Instance.new("UICorner")
            ValueCorner.CornerRadius = UDim.new(0, 6)
            ValueCorner.Parent = ValueBox
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 1, -18)
            SliderBar.BackgroundColor3 = Library.Theme.Tertiary
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Library.Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local SliderDot = Instance.new("Frame")
            SliderDot.Size = UDim2.new(0, 14, 0, 14)
            SliderDot.Position = UDim2.new(0, -7, 0.5, -7)
            SliderDot.BackgroundColor3 = Library.Theme.Text
            SliderDot.BorderSizePixel = 0
            SliderDot.Parent = SliderFill
            
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = SliderDot
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar
            
            local dragging = false
            local currentValue = default
            
            local function Round(num)
                if decimals == 0 then
                    return math.floor(num + 0.5)
                end
                local mult = 10 ^ decimals
                return math.floor(num * mult + 0.5) / mult
            end
            
            local function SetValue(value)
                value = math.clamp(value, min, max)
                value = Round(value)
                currentValue = value
                
                local percent = (value - min) / (max - min)
                
                TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(percent, 0, 1, 0)
                }):Play()
                
                ValueBox.Text = tostring(value)
                
                if flag then
                    Library.Flags[flag] = value
                    Window.Flags[flag] = value
                end
                
                callback(value)
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            SliderButton.MouseMoved:Connect(function()
                if dragging then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local barPos = SliderBar.AbsolutePosition.X
                    local barSize = SliderBar.AbsoluteSize.X
                    local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    local value = min + (max - min) * percent
                    SetValue(value)
                end
            end)
            
            ValueBox.FocusLost:Connect(function()
                local value = tonumber(ValueBox.Text)
                if value then
                    SetValue(value)
                else
                    ValueBox.Text = tostring(currentValue)
                end
            end)
            
            SetValue(default)
            
            return {SetValue = SetValue}
        end
        
        function Tab:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Library.Theme.Accent
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = ""
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = name
            ButtonLabel.TextColor3 = Library.Theme.Text
            ButtonLabel.TextSize = 14
            ButtonLabel.Font = Enum.Font.GothamSemibold
            ButtonLabel.Parent = ButtonFrame
            
            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.AccentHover
                }):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.Accent
                }):Play()
            end)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, -4, 0, 38)
                }):Play()
                task.wait(0.1)
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 40)
                }):Play()
                callback()
            end)
        end
        
        function Tab:CreateDropdown(options)
            options = options or {}
            local name = options.Name or "Dropdown"
            local flag = options.Flag
            local list = options.List or {}
            local default = options.Default or (list[1] or "None")
            local callback = options.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Library.Theme.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -50, 0, 40)
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = name
            DropdownLabel.TextColor3 = Library.Theme.Text
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(0, 30, 0, 30)
            DropdownButton.Position = UDim2.new(1, -37, 0, 5)
            DropdownButton.BackgroundColor3 = Library.Theme.Tertiary
            DropdownButton.Text = "▼"
            DropdownButton.TextColor3 = Library.Theme.Text
            DropdownButton.TextSize = 12
            DropdownButton.Font = Enum.Font.GothamBold
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = DropdownFrame
            
            local DropBtnCorner = Instance.new("UICorner")
            DropBtnCorner.CornerRadius = UDim.new(0, 6)
            DropBtnCorner.Parent = DropdownButton
            
            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Size = UDim2.new(1, -50, 0, 15)
            SelectedLabel.Position = UDim2.new(0, 12, 0, 20)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Text = default
            SelectedLabel.TextColor3 = Library.Theme.Accent
            SelectedLabel.TextSize = 12
            SelectedLabel.Font = Enum.Font.GothamBold
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
            SelectedLabel.Parent = DropdownFrame
            
            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Size = UDim2.new(1, -12, 0, 0)
            OptionsContainer.Position = UDim2.new(0, 6, 0, 45)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Parent = DropdownFrame
            
            local OptionsList = Instance.new("UIListLayout")
            OptionsList.Padding = UDim.new(0, 3)
            OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsList.Parent = OptionsContainer
            
            local opened = false
            local currentValue = default
            
            local function CreateOption(optionName)
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 32)
                OptionButton.BackgroundColor3 = Library.Theme.Tertiary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = ""
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = OptionsContainer
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton
                
                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Size = UDim2.new(1, -20, 1, 0)
                OptionLabel.Position = UDim2.new(0, 10, 0, 0)
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.Text = optionName
                OptionLabel.TextColor3 = Library.Theme.Text
                OptionLabel.TextSize = 13
                OptionLabel.Font = Enum.Font.Gotham
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                OptionLabel.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Library.Theme.Accent
                    }):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Library.Theme.Tertiary
                    }):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    currentValue = optionName
                    SelectedLabel.Text = optionName
                    
                    if flag then
                        Library.Flags[flag] = optionName
                        Window.Flags[flag] = optionName
                    end
                    
                    callback(optionName)
                    
                    -- Close dropdown
                    opened = false
                    local optionsHeight = OptionsList.AbsoluteContentSize.Y
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, 0, 0, 40)
                    }):Play()
                    TweenService:Create(DropdownButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Rotation = 0
                    }):Play()
                end)
            end
            
            for _, option in ipairs(list) do
                CreateOption(option)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                opened = not opened
                local optionsHeight = OptionsList.AbsoluteContentSize.Y
                
                if opened then
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, 0, 0, 55 + optionsHeight)
                    }):Play()
                    TweenService:Create(DropdownButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Rotation = 180
                    }):Play()
                else
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Size = UDim2.new(1, 0, 0, 40)
                    }):Play()
                    TweenService:Create(DropdownButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                        Rotation = 0
                    }):Play()
                end
            end)
            
            if flag then
                Library.Flags[flag] = currentValue
                Window.Flags[flag] = currentValue
            end
            
            callback(currentValue)
        end
        
        function Tab:CreateTextbox(options)
            options = options or {}
            local name = options.Name or "Textbox"
            local flag = options.Flag
            local default = options.Default or ""
            local placeholder = options.Placeholder or "Enter text..."
            local callback = options.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, 0, 0, 65)
            TextboxFrame.BackgroundColor3 = Library.Theme.Secondary
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 12, 0, 8)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = name
            TextboxLabel.TextColor3 = Library.Theme.Text
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -24, 0, 30)
            Textbox.Position = UDim2.new(0, 12, 0, 30)
            Textbox.BackgroundColor3 = Library.Theme.Tertiary
            Textbox.BorderSizePixel = 0
            Textbox.Text = default
            Textbox.PlaceholderText = placeholder
            Textbox.TextColor3 = Library.Theme.Text
            Textbox.PlaceholderColor3 = Library.Theme.TextDim
            Textbox.TextSize = 13
            Textbox.Font = Enum.Font.Gotham
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame
            
            local TextboxInnerCorner = Instance.new("UICorner")
            TextboxInnerCorner.CornerRadius = UDim.new(0, 6)
            TextboxInnerCorner.Parent = Textbox
            
            local TextboxPadding = Instance.new("UIPadding")
            TextboxPadding.PaddingLeft = UDim.new(0, 10)
            TextboxPadding.PaddingRight = UDim.new(0, 10)
            TextboxPadding.Parent = Textbox
            
            Textbox.FocusLost:Connect(function()
                local text = Textbox.Text
                
                if flag then
                    Library.Flags[flag] = text
                    Window.Flags[flag] = text
                end
                
                callback(text)
            end)
            
            if flag then
                Library.Flags[flag] = default
                Window.Flags[flag] = default
            end
        end
        
        return Tab
    end
    
    -- Config Management
    function Window:SaveConfig(configName)
        configName = configName or self.ConfigName
        local configPath = Library.ConfigFolder .. "/" .. configName .. ".json"
        
        local success, err = pcall(function()
            writefile(configPath, HttpService:JSONEncode(self.Flags))
        end)
        
        if success then
            Library:Notify({
                Title = "Config Saved",
                Message = "Configuration '" .. configName .. "' saved successfully!",
                Duration = 3,
                Type = "Success"
            })
            return true
        else
            Library:Notify({
                Title = "Save Failed",
                Message = "Failed to save configuration: " .. tostring(err),
                Duration = 4,
                Type = "Error"
            })
            return false
        end
    end
    
    function Window:LoadConfig(configName)
        configName = configName or self.ConfigName
        local configPath = Library.ConfigFolder .. "/" .. configName .. ".json"
        
        if not isfile(configPath) then
            Library:Notify({
                Title = "Load Failed",
                Message = "Configuration '" .. configName .. "' not found!",
                Duration = 3,
                Type = "Error"
            })
            return false
        end
        
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(configPath))
        end)
        
        if success and result then
            -- Apply loaded config
            for flag, value in pairs(result) do
                if Library.Flags[flag] ~= nil then
                    Library.Flags[flag] = value
                    self.Flags[flag] = value
                end
            end
            
            Library:Notify({
                Title = "Config Loaded",
                Message = "Configuration '" .. configName .. "' loaded successfully!",
                Duration = 3,
                Type = "Success"
            })
            return true
        else
            Library:Notify({
                Title = "Load Failed",
                Message = "Failed to load configuration: Invalid format",
                Duration = 4,
                Type = "Error"
            })
            return false
        end
    end
    
    function Window:DeleteConfig(configName)
        local configPath = Library.ConfigFolder .. "/" .. configName .. ".json"
        
        if isfile(configPath) then
            delfile(configPath)
            Library:Notify({
                Title = "Config Deleted",
                Message = "Configuration '" .. configName .. "' deleted!",
                Duration = 3,
                Type = "Info"
            })
            return true
        else
            Library:Notify({
                Title = "Delete Failed",
                Message = "Configuration '" .. configName .. "' not found!",
                Duration = 3,
                Type = "Error"
            })
            return false
        end
    end
    
    function Window:GetConfigs()
        local configs = {}
        local files = listfiles(Library.ConfigFolder)
        
        for _, file in ipairs(files) do
            local fileName = file:match("([^/]+)%.json$")
            if fileName then
                table.insert(configs, fileName)
            end
        end
        
        return configs
    end
    
    -- Auto Load
    if Window.AutoSave then
        local configPath = Library.ConfigFolder .. "/" .. Window.ConfigName .. ".json"
        if isfile(configPath) then
            Window:LoadConfig(Window.ConfigName)
        end
    end
    
    -- Create Settings Tab by default
    local SettingsTab = Window:CreateTab({Name = "Settings", Icon = "⚙️"})
    
    SettingsTab:CreateSection("🎨 GUI Settings")
    
    SettingsTab:CreateTextbox({
        Name = "Window Title",
        Flag = "WindowTitle",
        Default = title,
        Placeholder = "Enter window title...",
        Callback = function(value)
            TitleLabel.Text = value
        end
    })
    
    SettingsTab:CreateTextbox({
        Name = "Window Subtitle",
        Flag = "WindowSubtitle",
        Default = subtitle,
        Placeholder = "Enter subtitle...",
        Callback = function(value)
            SubtitleLabel.Text = value
        end
    })
    
    SettingsTab:CreateSection("💾 Configuration")
    
    SettingsTab:CreateTextbox({
        Name = "Config Name",
        Flag = "ConfigName",
        Default = configName,
        Placeholder = "Enter config name...",
        Callback = function(value)
            Window.ConfigName = value
        end
    })
    
    SettingsTab:CreateButton({
        Name = "💾 Save Configuration",
        Callback = function()
            Window:SaveConfig(Window.ConfigName)
        end
    })
    
    SettingsTab:CreateButton({
        Name = "📂 Load Configuration",
        Callback = function()
            Window:LoadConfig(Window.ConfigName)
        end
    })
    
    SettingsTab:CreateButton({
        Name = "🗑️ Delete Configuration",
        Callback = function()
            Window:DeleteConfig(Window.ConfigName)
        end
    })
    
    SettingsTab:CreateToggle({
        Name = "Auto Save on Exit",
        Flag = "AutoSave",
        Default = autoSave,
        Callback = function(value)
            Window.AutoSave = value
        end
    })
    
    local configList = Window:GetConfigs()
    if #configList > 0 then
        SettingsTab:CreateDropdown({
            Name = "Saved Configurations",
            Flag = "SelectedConfig",
            List = configList,
            Default = configList[1] or "None",
            Callback = function(value)
                Window.ConfigName = value
            end
        })
    end
    
    SettingsTab:CreateSection("ℹ️ Information")
    
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(1, 0, 0, 80)
    InfoFrame.BackgroundColor3 = Library.Theme.Secondary
    InfoFrame.BorderSizePixel = 0
    InfoFrame.Parent = SettingsTab.Content
    
    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 8)
    InfoCorner.Parent = InfoFrame
    
    local InfoText = Instance.new("TextLabel")
    InfoText.Size = UDim2.new(1, -20, 1, -20)
    InfoText.Position = UDim2.new(0, 10, 0, 10)
    InfoText.BackgroundTransparency = 1
    InfoText.Text = "Advanced UI Library v3.0\n\nCreated by: Script Dev\nFeatures: Auto-Save, Multiple Configs, Notifications"
    InfoText.TextColor3 = Library.Theme.TextDim
    InfoText.TextSize = 12
    InfoText.Font = Enum.Font.Gotham
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.TextYAlignment = Enum.TextYAlignment.Top
    InfoText.TextWrapped = true
    InfoText.Parent = InfoFrame
    
    -- Set Settings as default tab
    if #Tabs > 0 then
        Tabs[#Tabs].Button.MouseButton1Click:Fire()
    end
    
    -- Show intro notification
    Library:Notify({
        Title = "UI Library Loaded",
        Message = "Welcome to " .. title .. "! All systems operational.",
        Duration = 4,
        Type = "Success"
    })
    
    return Window
end

return Library
