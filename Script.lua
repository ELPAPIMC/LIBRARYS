-- Sistema de Autenticación con Key
-- Key correcta: LezzoStoreAccess

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuración
local CORRECT_KEY = "LezzoStoreAccess"
local SCRIPT_URL = "https://api.luarmor.net/files/v3/loaders/f927290098f4333a9d217cbecbe6e988.lua"

-- Verificar si ya se ingresó la key anteriormente
local keyFile = "LezzoStore_KeyData_" .. player.UserId .. ".txt"

-- Función para verificar si la key ya fue ingresada
local function hasValidKey()
    if readfile and isfile then
        if isfile(keyFile) then
            local savedKey = readfile(keyFile)
            return savedKey == CORRECT_KEY
        end
    end
    return false
end

-- Función para guardar la key
local function saveKey(key)
    if writefile then
        writefile(keyFile, key)
    end
end

-- Función para cargar el script principal
local function loadMainScript()
    local success, result = pcall(function()
        loadstring(game:HttpGet(SCRIPT_URL))()
    end)
    
    if success then
        print("✅ Script cargado correctamente!")
    else
        warn("❌ Error al cargar el script: " .. tostring(result))
    end
end

-- Si ya tiene la key válida, cargar directamente
if hasValidKey() then
    loadMainScript()
    return
end

-- Crear interfaz de autenticación
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LezzoStoreKeySystem"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Active = true
mainFrame.Draggable = true

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Sombra
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Parent = screenGui
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.Position = UDim2.new(0.5, -205, 0.5, -145)
shadow.Size = UDim2.new(0, 410, 0, 310)
shadow.ZIndex = mainFrame.ZIndex - 1

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 10)
shadowCorner.Parent = shadow

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 20)
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "🔐 Set Your Key"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 24

-- Subtítulo
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Parent = mainFrame
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 20, 0, 80)
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "Ingresa tu key para acceder al script:"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 14

-- Campo de texto para la key
local keyTextBox = Instance.new("TextBox")
keyTextBox.Name = "KeyTextBox"
keyTextBox.Parent = mainFrame
keyTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyTextBox.BorderSizePixel = 0
keyTextBox.Position = UDim2.new(0, 20, 0, 130)
keyTextBox.Size = UDim2.new(1, -40, 0, 40)
keyTextBox.Font = Enum.Font.Gotham
keyTextBox.PlaceholderText = "Ingresa tu key aquí..."
keyTextBox.Text = ""
keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTextBox.TextScaled = true
keyTextBox.TextSize = 16

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 5)
keyBoxCorner.Parent = keyTextBox

-- Botón de verificación
local verifyButton = Instance.new("TextButton")
verifyButton.Name = "VerifyButton"
verifyButton.Parent = mainFrame
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
verifyButton.BorderSizePixel = 0
verifyButton.Position = UDim2.new(0, 20, 0, 190)
verifyButton.Size = UDim2.new(1, -40, 0, 40)
verifyButton.Font = Enum.Font.GothamBold
verifyButton.Text = "✓ Verificar Key"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextScaled = true
verifyButton.TextSize = 16

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = verifyButton

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Parent = mainFrame
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0, 20, 0, 250)
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.TextSize = 12

-- Función para mostrar mensaje de estado
local function showStatus(message, isError)
    statusLabel.Text = message
    if isError then
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    else
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
    
    -- Animación de aparición
    statusLabel.TextTransparency = 1
    local tween = TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextTransparency = 0})
    tween:Play()
end

-- Función para cerrar la interfaz con animación
local function closeInterface()
    local tween1 = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
    local tween2 = TweenService:Create(shadow, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
    
    tween1:Play()
    tween2:Play()
    
    tween1.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Función para verificar la key
local function verifyKey()
    local inputKey = keyTextBox.Text
    
    if inputKey == "" then
        showStatus("❌ Por favor, ingresa una key", true)
        return
    end
    
    if inputKey == CORRECT_KEY then
        showStatus("✅ Key correcta! Cargando script...", false)
        saveKey(inputKey)
        
        wait(1)
        closeInterface()
        
        wait(0.5)
        loadMainScript()
    else
        showStatus("❌ Key incorrecta. Inténtalo de nuevo.", true)
        keyTextBox.Text = ""
    end
end

-- Eventos
verifyButton.MouseButton1Click:Connect(verifyKey)

keyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyKey()
    end
end)

-- Efecto hover para el botón
verifyButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(verifyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)})
    tween:Play()
end)

verifyButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(verifyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 0)})
    tween:Play()
end)

-- Animación de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
shadow.Size = UDim2.new(0, 0, 0, 0)

local enterTween1 = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 300)})
local enterTween2 = TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 410, 0, 310)})

enterTween1:Play()
enterTween2:Play()

print("🔐 Sistema de Key de LezzoStore iniciado")
print("Key requerida: " .. CORRECT_KEY)
