local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Error handling wrapper with better performance
local function safeCall(func, errorMsg)
    local success, result = pcall(func)
    if not success then
        warn("[Graipuss Hub Error] " .. (errorMsg or "Unknown error") .. ": " .. tostring(result))
        return false, result
    end
    return true, result
end

-- Optimized configuration management
local hwid = "default_hwid"
safeCall(function()
    hwid = game:GetService("RbxAnalyticsService"):GetClientId()
end, "Failed to get HWID")

local cfgFile = "graipuss_hub_" .. hwid .. ".json"

local function loadConfig()
    if not isfile or not isfile(cfgFile) then 
        return { minMoney = 1000000 } 
    end
    
    local success, data = safeCall(function()
        return HttpService:JSONDecode(readfile(cfgFile))
    end, "Failed to load config")
    
    return success and type(data) == "table" and data or { minMoney = 1000000 }
end

local function saveConfig(cfg)
    if writefile then
        safeCall(function()
            writefile(cfgFile, HttpService:JSONEncode(cfg))
        end, "Failed to save config")
    end
end

local config = loadConfig()
local minMoney = config.minMoney or 1000000
local autoJoinEnabled = false
local ws = nil
local reconnectAttempts = 0
local maxReconnectAttempts = 5

-- Performance optimization variables
local messageQueue = {}
local processingMessages = false

-- Create UI with Graipuss Hub purple theme
local gui = Instance.new("ScreenGui")
gui.Name = "GraipussHub"
gui.Parent = game:GetService("CoreGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container with purple gradient
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 180)
main.Position = UDim2.new(0.5, -150, 0.3, -90)
main.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

-- Purple gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 30, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 40, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 25, 55))
}
gradient.Rotation = 45
gradient.Parent = main

-- Purple border with glow effect
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(120, 80, 160)
border.Thickness = 2
border.Parent = main

-- Header with enhanced purple theme
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 50, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 35, 75))
}
headerGradient.Rotation = 90
headerGradient.Parent = header

-- Title with Graipuss Hub branding
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 Graipuss Hub"
title.TextColor3 = Color3.fromRGB(200, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -80, 0, 12)
subtitle.Position = UDim2.new(0, 15, 0, 22)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Fast Server Finder"
subtitle.TextColor3 = Color3.fromRGB(160, 140, 200)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

-- Close button with purple theme
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 120)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(220, 200, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

local closeBtnStroke = Instance.new("UIStroke")
closeBtnStroke.Color = Color3.fromRGB(120, 80, 160)
closeBtnStroke.Thickness = 1
closeBtnStroke.Parent = closeBtn

-- Content area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.Parent = main

-- Enhanced Auto Join Toggle with purple theme
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -24, 0, 35)
toggleBtn.Position = UDim2.new(0, 12, 0, 12)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 45, 85)
toggleBtn.Text = "🔍 Auto Join: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.Parent = content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(100, 70, 140)
toggleStroke.Thickness = 1
toggleStroke.Parent = toggleBtn

-- Min Money Input with enhanced styling
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -24, 0, 20)
moneyLabel.Position = UDim2.new(0, 12, 0, 55)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "💰 Min Money (millions):"
moneyLabel.TextColor3 = Color3.fromRGB(180, 160, 220)
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextSize = 12
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = content

local moneyInput = Instance.new("TextBox")
moneyInput.Size = UDim2.new(1, -24, 0, 28)
moneyInput.Position = UDim2.new(0, 12, 0, 78)
moneyInput.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
moneyInput.Text = tostring(minMoney / 1000000)
moneyInput.TextColor3 = Color3.fromRGB(220, 200, 255)
moneyInput.Font = Enum.Font.Gotham
moneyInput.TextSize = 13
moneyInput.PlaceholderText = "1.0"
moneyInput.PlaceholderColor3 = Color3.fromRGB(140, 120, 180)
moneyInput.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = moneyInput

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(100, 70, 140)
inputStroke.Thickness = 1
inputStroke.Parent = moneyInput

-- Enhanced status with better styling
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 25)
status.Position = UDim2.new(0, 12, 0, 115)
status.BackgroundTransparency = 1
status.Text = "⚡ Status: Initializing..."
status.TextColor3 = Color3.fromRGB(160, 140, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = content

-- Performance indicator
local perfIndicator = Instance.new("TextLabel")
perfIndicator.Size = UDim2.new(1, -24, 0, 15)
perfIndicator.Position = UDim2.new(0, 12, 0, 145)
perfIndicator.BackgroundTransparency = 1
perfIndicator.Text = "🚀 Fast Mode: Ready"
perfIndicator.TextColor3 = Color3.fromRGB(120, 200, 120)
perfIndicator.Font = Enum.Font.Gotham
perfIndicator.TextSize = 9
perfIndicator.TextXAlignment = Enum.TextXAlignment.Left
perfIndicator.Parent = content

-- Optimized utility functions
local function formatMoney(amount)
    if amount >= 1000000000 then
        return string.format("%.1fB", amount / 1000000000)
    elseif amount >= 1000000 then
        return string.format("%.1fM", amount / 1000000)
    else
        return string.format("%.1fK", amount / 1000)
    end
end

local function parseMoney(str)
    local num = tonumber(str)
    if not num or num <= 0 then return nil end
    return math.clamp(num * 1000000, 100000, 50000000000) -- 0.1M to 50B (increased limit)
end

local function updateStatus(text, color)
    status.Text = "⚡ Status: " .. text
    status.TextColor3 = color or Color3.fromRGB(160, 140, 200)
end

-- Enhanced money parsing with better performance
local moneyPatterns = {
    {"([%d%.]+)B", 1000000000},
    {"([%d%.]+)b", 1000000000},
    {"([%d%.]+)M", 1000000},
    {"([%d%.]+)m", 1000000},
    {"([%d%.]+)K", 1000},
    {"([%d%.]+)k", 1000},
    {"([%d%.]+)", 1}
}

local function parseServerMoney(moneyStr)
    if not moneyStr then return 0 end
    
    -- Fast cleaning
    local cleanStr = moneyStr:gsub("[$€£¥₽/s%s]", "")
    
    -- Pattern matching for better performance
    for _, pattern in ipairs(moneyPatterns) do
        local num = cleanStr:match(pattern[1])
        if num then
            local value = tonumber(num)
            if value then
                return value * pattern[2]
            end
        end
    end
    
    return 0
end

-- Optimized message processing queue
local function processMessageQueue()
    if processingMessages or #messageQueue == 0 then return end
    
    processingMessages = true
    
    -- Process up to 5 messages at once for better performance
    local processed = 0
    while #messageQueue > 0 and processed < 5 do
        local msg = table.remove(messageQueue, 1)
        processed = processed + 1
        
        spawn(function()
            safeCall(function()
                local data = HttpService:JSONDecode(msg)
                
                if autoJoinEnabled and 
                   data and 
                   data.type == "server_update" and 
                   data.data and 
                   data.data.join_script and 
                   data.data.money then
                    
                    local serverMoney = parseServerMoney(data.data.money)
                    
                    if serverMoney >= minMoney then
                        updateStatus("🚀 Joining: " .. data.data.money, Color3.fromRGB(120, 255, 120))
                        print("[Graipuss Hub] Fast joining server with " .. data.data.money)
                        
                        -- Ultra-fast join with minimal delay
                        spawn(function()
                            local scriptSuccess, scriptErr = safeCall(function()
                                local func = loadstring(data.data.join_script)
                                if func then
                                    func()
                                else
                                    error("Failed to load join script")
                                end
                            end, "Script execution failed")
                            
                            if not scriptSuccess then
                                updateStatus("❌ Join failed", Color3.fromRGB(255, 120, 120))
                            end
                        end)
                    else
                        updateStatus("⏭️ Skipped: " .. data.data.money .. " < " .. formatMoney(minMoney), 
                                   Color3.fromRGB(255, 200, 120))
                    end
                end
            end, "Fast message processing failed")
        end)
    end
    
    processingMessages = false
end

-- Run message processing on heartbeat for maximum speed
RunService.Heartbeat:Connect(processMessageQueue)

-- Event handlers with better feedback
closeBtn.MouseButton1Click:Connect(function()
    -- Smooth close animation
    local closeTween = TweenService:Create(main, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.3, 0)
        })
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        safeCall(function()
            if ws then ws:Close() end
            gui:Destroy()
        end, "Failed to close UI")
    end)
end)

-- Enhanced toggle with better visual feedback
toggleBtn.MouseButton1Click:Connect(function()
    autoJoinEnabled = not autoJoinEnabled
    
    if autoJoinEnabled then
        toggleBtn.Text = "🔥 Auto Join: ON"
        toggleBtn.TextColor3 = Color3.fromRGB(120, 255, 120)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
        toggleStroke.Color = Color3.fromRGB(120, 255, 120)
        perfIndicator.Text = "🚀 Fast Mode: ACTIVE"
        perfIndicator.TextColor3 = Color3.fromRGB(120, 255, 120)
    else
        toggleBtn.Text = "🔍 Auto Join: OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 45, 85)
        toggleStroke.Color = Color3.fromRGB(100, 70, 140)
        perfIndicator.Text = "🚀 Fast Mode: Ready"
        perfIndicator.TextColor3 = Color3.fromRGB(160, 140, 200)
    end
    
    updateStatus(autoJoinEnabled and "🔥 Fast auto join enabled" or "⏸️ Auto join disabled")
    
    -- Button press animation
    local pressTween = TweenService:Create(toggleBtn, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -28, 0, 33)})
    pressTween:Play()
    pressTween.Completed:Connect(function()
        TweenService:Create(toggleBtn, 
            TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -24, 0, 35)}):Play()
    end)
end)

moneyInput.FocusLost:Connect(function()
    local newValue = parseMoney(moneyInput.Text)
    if newValue then
        minMoney = newValue
        moneyInput.Text = tostring(minMoney / 1000000)
        saveConfig({ minMoney = minMoney })
        updateStatus("💰 Min money updated: " .. formatMoney(minMoney), Color3.fromRGB(120, 255, 120))
        
        -- Success feedback with glow effect
        inputStroke.Color = Color3.fromRGB(120, 255, 120)
        inputStroke.Thickness = 2
        spawn(function()
            wait(0.5)
            inputStroke.Color = Color3.fromRGB(100, 70, 140)
            inputStroke.Thickness = 1
        end)
    else
        moneyInput.Text = tostring(minMoney / 1000000)
        updateStatus("❌ Invalid input", Color3.fromRGB(255, 120, 120))
        
        -- Error feedback
        inputStroke.Color = Color3.fromRGB(255, 120, 120)
        inputStroke.Thickness = 2
        spawn(function()
            wait(0.5)
            inputStroke.Color = Color3.fromRGB(100, 70, 140)
            inputStroke.Thickness = 1
        end)
    end
end)

-- Enhanced dragging with smooth movement
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Ultra-optimized WebSocket connection
local function connectWebSocket()
    if not WebSocket then
        updateStatus("❌ WebSocket not supported", Color3.fromRGB(255, 120, 120))
        return false
    end
    
    local success, result = safeCall(function()
        return WebSocket.connect("ws://5.255.97.147:6767/script")
    end, "WebSocket connection failed")
    
    if not success then
        reconnectAttempts = reconnectAttempts + 1
        if reconnectAttempts <= maxReconnectAttempts then
            updateStatus("🔄 Reconnecting... (" .. reconnectAttempts .. "/" .. maxReconnectAttempts .. ")", 
                         Color3.fromRGB(255, 200, 120))
            spawn(function()
                wait(2 * reconnectAttempts) -- Exponential backoff
                connectWebSocket()
            end)
        else
            updateStatus("❌ Connection failed permanently", Color3.fromRGB(255, 120, 120))
        end
        return false
    end
    
    ws = result
    reconnectAttempts = 0
    updateStatus("🌐 Connected - Fast Mode", Color3.fromRGB(120, 255, 120))
    perfIndicator.Text = "🚀 Fast Mode: Connected"
    
    -- Ultra-fast message handler using queue system
    ws.OnMessage:Connect(function(msg)
        table.insert(messageQueue, msg)
    end)
    
    -- Enhanced connection lost handler
    ws.OnClose:Connect(function()
        updateStatus("⚠️ Connection lost - Reconnecting...", Color3.fromRGB(255, 200, 120))
        perfIndicator.Text = "🔄 Fast Mode: Reconnecting..."
        
        -- Fast auto-reconnect
        spawn(function()
            wait(1) -- Faster reconnect
            if gui.Parent then
                connectWebSocket()
            end
        end)
    end)
    
    return true
end

-- Enhanced entrance animation with purple glow effect
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.3, 0)
main.BackgroundTransparency = 1

-- Glow effect during entrance
local glowEffect = Instance.new("ImageLabel")
glowEffect.Size = UDim2.new(1, 40, 1, 40)
glowEffect.Position = UDim2.new(0, -20, 0, -20)
glowEffect.BackgroundTransparency = 1
glowEffect.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
glowEffect.ImageColor3 = Color3.fromRGB(120, 80, 160)
glowEffect.ImageTransparency = 0.7
glowEffect.ScaleType = Enum.ScaleType.Slice
glowEffect.SliceCenter = Rect.new(10, 10, 10, 10)
glowEffect.Parent = main

local entranceTween = TweenService:Create(main, 
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 180),
        Position = UDim2.new(0.5, -150, 0.3, -90),
        BackgroundTransparency = 0
    })

local glowTween = TweenService:Create(glowEffect,
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0.9
    })

entranceTween:Play()
glowTween:Play()

entranceTween.Completed:Connect(function()
    glowEffect:Destroy()
end)

-- Ultra-fast initialization
spawn(function()
    wait(0.1) -- Ultra-fast startup
    updateStatus("🚀 Initializing Fast Mode...", Color3.fromRGB(200, 180, 255))
    wait(0.1)
    connectWebSocket()
end)

-- Enhanced cleanup on game leave
game.Players.PlayerRemoving:Connect(function(player)
    if player == game.Players.LocalPlayer then
        safeCall(function()
            if ws then ws:Close() end
        end, "Cleanup failed")
    end
end)
