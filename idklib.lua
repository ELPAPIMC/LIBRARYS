-- WikyLibrary v1.0
-- Modern UI Library for Roblox
-- Based on UnWalk GUI System

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local WikyLibrary = {}
WikyLibrary.__index = WikyLibrary

-- Utility: Create UI element with default properties
local function createElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

-- Utility: Add rounded corners
local function addCorners(element, radius)
    local corner = Instance.new("UICorner", element)
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

-- Utility: Create smooth tween
local function createTween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Create new window
function WikyLibrary:CreateWindow(config)
    config = config or {}
    local window = {}
    
    -- Create ScreenGui
    local screenGui = createElement("ScreenGui", {
        Name = config.Name or "WikyLibrary",
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    window.ScreenGui = screenGui
    window.Tabs = {}
    window.CurrentTab = nil
    
    return setmetatable(window, {__index = self})
end

-- Create key verification screen
function WikyLibrary:CreateKeySystem(config)
    config = config or {}
    local keySystem = {}
    
    local screenGui = createElement("ScreenGui", {
        Name = "WikyKeySystem",
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    -- Main frame
    local keyFrame = createElement("Frame", {
        Size = UDim2.new(0, 280, 0, 180),
        Position = UDim2.new(0.5, -140, 0.5, -90),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = screenGui
    })
    addCorners(keyFrame, 10)
    
    -- Title
    local keyTitle = createElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = config.Title or "🔑 Key System",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        Parent = keyFrame
    })
    
    -- Key input
    local keyInput = createElement("TextBox", {
        Size = UDim2.new(0, 240, 0, 32),
        Position = UDim2.new(0.5, -120, 0, 60),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = config.Placeholder or "Ingresa tu key...",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = keyFrame
    })
    addCorners(keyInput, 6)
    
    -- Submit button
    local submitButton = createElement("TextButton", {
        Size = UDim2.new(0, 132, 0, 32),
        Position = UDim2.new(0, 20, 0, 105),
        BackgroundColor3 = Color3.fromRGB(50, 150, 255),
        Text = "Verificar",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Parent = keyFrame
    })
    addCorners(submitButton, 6)
    
    -- Get key button
    local getKeyButton = createElement("TextButton", {
        Size = UDim2.new(0, 93, 0, 32),
        Position = UDim2.new(1, -113, 0, 105),
        BackgroundColor3 = Color3.fromRGB(88, 101, 242),
        Text = "Get Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Parent = keyFrame
    })
    addCorners(getKeyButton, 6)
    
    -- Error label
    local errorLabel = createElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 0, 145),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 80, 80),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        Parent = keyFrame
    })
    
    -- Status label
    local statusLabel = createElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 0, 160),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(100, 200, 255),
        TextSize = 10,
        Font = Enum.Font.Gotham,
        Parent = keyFrame
    })
    
    -- Functions
    keySystem.SetError = function(text)
        errorLabel.Text = text
        createTween(errorLabel, {TextTransparency = 0})
        wait(3)
        createTween(errorLabel, {TextTransparency = 1})
    end
    
    keySystem.SetStatus = function(text)
        statusLabel.Text = text
    end
    
    keySystem.Destroy = function()
        createTween(keyFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
        wait(0.3)
        screenGui:Destroy()
    end
    
    -- Events
    keySystem.OnSubmit = function(callback)
        submitButton.MouseButton1Click:Connect(function()
            createTween(submitButton, {BackgroundColor3 = Color3.fromRGB(40, 120, 200)})
            wait(0.1)
            createTween(submitButton, {BackgroundColor3 = Color3.fromRGB(50, 150, 255)})
            callback(keyInput.Text)
        end)
        
        keyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(keyInput.Text)
            end
        end)
    end
    
    keySystem.OnGetKey = function(callback)
        getKeyButton.MouseButton1Click:Connect(function()
            createTween(getKeyButton, {BackgroundColor3 = Color3.fromRGB(68, 81, 200)})
            wait(0.1)
            createTween(getKeyButton, {BackgroundColor3 = Color3.fromRGB(88, 101, 242)})
            callback()
        end)
    end
    
    keySystem.Frame = keyFrame
    keySystem.ScreenGui = screenGui
    
    return keySystem
end

-- Create main window
function WikyLibrary:CreateMainWindow(config)
    config = config or {}
    local mainWindow = {}
    
    local screenGui = createElement("ScreenGui", {
        Name = "WikyMainWindow",
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })
    
    -- Main frame
    local mainFrame = createElement("Frame", {
        Size = UDim2.new(0, config.Width or 180, 0, config.Height or 95),
        Position = UDim2.new(0.5, -(config.Width or 180)/2, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Visible = config.Visible or true,
        Parent = screenGui
    })
    addCorners(mainFrame, 10)
    
    -- Title
    local title = createElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Title or "Wiky Library",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        Parent = mainFrame
    })
    
    -- Container for buttons
    local container = createElement("Frame", {
        Size = UDim2.new(1, -20, 1, -45),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })
    
    local listLayout = Instance.new("UIListLayout", container)
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Functions
    mainWindow.AddToggle = function(text, default, callback)
        local isEnabled = default or false
        
        local button = createElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = isEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(220, 50, 50),
            Text = text .. ": " .. (isEnabled and "ON" or "OFF"),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Parent = container
        })
        addCorners(button, 6)
        
        button.MouseButton1Click:Connect(function()
            isEnabled = not isEnabled
            button.Text = text .. ": " .. (isEnabled and "ON" or "OFF")
            createTween(button, {
                BackgroundColor3 = isEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(220, 50, 50)
            })
            if callback then callback(isEnabled) end
        end)
        
        return button
    end
    
    mainWindow.AddButton = function(text, callback)
        local button = createElement("TextButton", {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Color3.fromRGB(50, 150, 255),
            Text = text,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Parent = container
        })
        addCorners(button, 6)
        
        button.MouseButton1Click:Connect(function()
            createTween(button, {BackgroundColor3 = Color3.fromRGB(40, 120, 200)})
            wait(0.1)
            createTween(button, {BackgroundColor3 = Color3.fromRGB(50, 150, 255)})
            if callback then callback() end
        end)
        
        return button
    end
    
    mainWindow.Show = function()
        mainFrame.Visible = true
    end
    
    mainWindow.Hide = function()
        mainFrame.Visible = false
    end
    
    mainWindow.Destroy = function()
        screenGui:Destroy()
    end
    
    mainWindow.Frame = mainFrame
    mainWindow.ScreenGui = screenGui
    
    return mainWindow
end

print("✓ WikyLibrary loaded successfully")
return WikyLibrary
