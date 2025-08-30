local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Error handling wrapper
local function safeCall(func, errorMsg)
    local success, result = pcall(func)
    if not success then
        warn("[PrismaJoin Error] " .. (errorMsg or "Unknown error") .. ": " .. tostring(result))
        return false, result
    end
    return true, result
end

-- Configuration management
local hwid = "default_hwid"
safeCall(function()
    hwid = game:GetService("RbxAnalyticsService"):GetClientId()
end, "Failed to get HWID")

local cfgFile = "prisma_minimal_" .. hwid .. ".json"

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
local isMinimized = false
local originalSize = UDim2.new(0, 280, 0, 160)
local minimizedSize = UDim2.new(0, 280, 0, 35)

-- Create UI
local gui = Instance.new("ScreenGui")
gui.Name = "PrismaJoinerMinimal"
gui.Parent = game:GetService("CoreGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main container
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 160)
main.Position = UDim2.new(0.5, -140, 0.3, -80)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

-- Subtle border
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(60, 60, 60)
border.Thickness = 1
border.Parent = main

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Prisma Joiner"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.Font = Enum.Font.Gotham
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = header

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 4)
minimizeBtnCorner.Parent = minimizeBtn

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 50)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 4)
closeBtnCorner.Parent = closeBtn

-- Content area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundTransparency = 1
content.Parent = main

-- Auto Join Toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "Auto Join: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.TextSize = 12
toggleBtn.Parent = content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- Min Money Input
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Size = UDim2.new(1, -20, 0, 20)
moneyLabel.Position = UDim2.new(0, 10, 0, 50)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "Min Money (millions):"
moneyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
moneyLabel.Font = Enum.Font.Gotham
moneyLabel.TextSize = 11
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = content

local moneyInput = Instance.new("TextBox")
moneyInput.Size = UDim2.new(1, -20, 0, 25)
moneyInput.Position = UDim2.new(0, 10, 0, 75)
moneyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
moneyInput.Text = tostring(minMoney / 1000000)
moneyInput.TextColor3 = Color3.fromRGB(220, 220, 220)
moneyInput.Font = Enum.Font.Gotham
moneyInput.TextSize = 12
moneyInput.PlaceholderText = "1.0"
moneyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
moneyInput.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = moneyInput

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(80, 80, 80)
inputStroke.Thickness = 1
inputStroke.Parent = moneyInput

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 15)
status.Position = UDim2.new(0, 10, 0, 110)
status.BackgroundTransparency = 1
status.Text = "Status: Initializing..."
status.TextColor3 = Color3.fromRGB(150, 150, 150)
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = content

-- Script credit
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -20, 0, 15)
credit.Position = UDim2.new(0, 10, 0, 135)
credit.BackgroundTransparency = 1
credit.Text = "Script By Wiki"
credit.TextColor3 = Color3.fromRGB(120, 120, 120)
credit.Font = Enum.Font.Gotham
credit.TextSize = 9
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.Parent = content

-- Utility functions
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
    return math.clamp(num * 1000000, 100000, 10000000000) -- 0.1M to 10B
end

local function updateStatus(text, color)
    status.Text = "Status: " .. text
    status.TextColor3 = color or Color3.fromRGB(150, 150, 150)
end

local function parseServerMoney(moneyStr)
    if not moneyStr then return 0 end
    
    -- Remove currency symbols and /s suffix
    local cleanStr = moneyStr:gsub("[$€£¥₽]", ""):gsub("/s", ""):gsub("%s+", "")
    local num, suffix = cleanStr:match("([%d%.]+)([MKBmkb]?)")
    
    num = tonumber(num)
    if not num then return 0 end
    
    suffix = suffix and suffix:upper() or ""
    if suffix == "B" then
        return num * 1000000000
    elseif suffix == "M" then
        return num * 1000000
    elseif suffix == "K" then
        return num * 1000
    end
    
    return num
end

-- Event handlers
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and minimizedSize or originalSize
    
    -- Animate the resize
    local tween = TweenService:Create(main, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
        {Size = targetSize}
    )
    tween:Play()
    
    -- Hide/show content
    content.Visible = not isMinimized
    
    -- Update minimize button text
    minimizeBtn.Text = isMinimized and "□" or "−"
    
    updateStatus(isMinimized and "Minimized" or "Restored")
end)

closeBtn.MouseButton1Click:Connect(function()
    safeCall(function()
        if ws then ws:Close() end
        gui:Destroy()
    end, "Failed to close UI")
end)

toggleBtn.MouseButton1Click:Connect(function()
    autoJoinEnabled = not autoJoinEnabled
    toggleBtn.Text = autoJoinEnabled and "Auto Join: ON" or "Auto Join: OFF"
    toggleBtn.TextColor3 = autoJoinEnabled and Color3.fromRGB(120, 220, 120) or Color3.fromRGB(180, 180, 180)
    toggleBtn.BackgroundColor3 = autoJoinEnabled and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(60, 60, 60)
    
    updateStatus(autoJoinEnabled and "Auto join enabled" or "Auto join disabled")
end)

moneyInput.FocusLost:Connect(function()
    local newValue = parseMoney(moneyInput.Text)
    if newValue then
        minMoney = newValue
        moneyInput.Text = tostring(minMoney / 1000000)
        saveConfig({ minMoney = minMoney })
        updateStatus("Min money updated: " .. formatMoney(minMoney), Color3.fromRGB(120, 220, 120))
        
        -- Success feedback
        inputStroke.Color = Color3.fromRGB(120, 220, 120)
        wait(0.5)
        inputStroke.Color = Color3.fromRGB(80, 80, 80)
    else
        moneyInput.Text = tostring(minMoney / 1000000)
        updateStatus("Invalid input", Color3.fromRGB(220, 120, 120))
        
        -- Error feedback
        inputStroke.Color = Color3.fromRGB(220, 120, 120)
        wait(0.5)
        inputStroke.Color = Color3.fromRGB(80, 80, 80)
    end
end)

-- Enhanced dragging functionality for mobile and PC
local dragging = false
local dragStart, startPos

-- Function to handle drag start (works for both mouse and touch)
local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end

-- Function to handle drag movement
local function updateDrag(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                     input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end

-- Function to handle drag end
local function endDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end

-- Connect dragging events to header
header.InputBegan:Connect(startDrag)
header.InputChanged:Connect(updateDrag)

-- Global input handling for drag end and mobile support
UserInputService.InputEnded:Connect(endDrag)
UserInputService.InputChanged:Connect(updateDrag)

-- Mobile touch support
UserInputService.TouchEnded:Connect(function()
    dragging = false
end)

-- WebSocket connection with error handling
local function connectWebSocket()
    if not WebSocket then
        updateStatus("WebSocket not supported", Color3.fromRGB(220, 120, 120))
        return false
    end
    
    local success, result = safeCall(function()
        return WebSocket.connect("ws://5.255.97.147:6767/script")
    end, "WebSocket connection failed")
    
    if not success then
        updateStatus("Connection failed", Color3.fromRGB(220, 120, 120))
        return false
    end
    
    local ws = result
    updateStatus("Connected", Color3.fromRGB(120, 220, 120))
    
    -- Message handler with fast processing
    ws.OnMessage:Connect(function(msg)
        spawn(function() -- Process messages asynchronously for speed
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
                        updateStatus("Joining: " .. data.data.money, Color3.fromRGB(120, 220, 120))
                        print("[PrismaJoin] Joining server with " .. data.data.money)
                        
                        -- Quick join with minimal delay
                        spawn(function()
                            wait(0.1) -- Very short delay for UI update
                            
                            local scriptSuccess, scriptErr = safeCall(function()
                                local func = loadstring(data.data.join_script)
                                if func then
                                    func()
                                else
                                    error("Failed to load join script")
                                end
                            end, "Script execution failed")
                            
                            if not scriptSuccess then
                                updateStatus("Join failed", Color3.fromRGB(220, 120, 120))
                            end
                        end)
                    else
                        updateStatus("Skipped: " .. data.data.money .. " < " .. formatMoney(minMoney), 
                                   Color3.fromRGB(220, 180, 120))
                    end
                end
            end, "Message processing failed")
        end)
    end)
    
    -- Connection lost handler
    ws.OnClose:Connect(function()
        updateStatus("Connection lost", Color3.fromRGB(220, 180, 120))
        
        -- Auto-reconnect after 2 seconds
        wait(2)
        if gui.Parent then
            updateStatus("Reconnecting...", Color3.fromRGB(150, 150, 150))
            connectWebSocket()
        end
    end)
    
    return true
end

-- Entrance animation
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.3, 0)

local entranceTween = TweenService:Create(main, 
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = originalSize,
        Position = UDim2.new(0.5, -140, 0.3, -80)
    })
entranceTween:Play()

-- Initialize connection with faster startup
spawn(function()
    wait(0.2) -- Faster UI startup
    connectWebSocket()
end)

-- Cleanup on game leave
game.Players.PlayerRemoving:Connect(function(player)
    if player == game.Players.LocalPlayer then
        safeCall(function()
            if ws then ws:Close() end
        end, "Cleanup failed")
    end
end)
