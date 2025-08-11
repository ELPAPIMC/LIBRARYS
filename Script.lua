-- Script de Autenticación con Key para Roblox
-- Key correcta: LezzoStoreAccess

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Key correcta
local CORRECT_KEY = "LezzoStoreAccess"

-- URL del script a cargar
local SCRIPT_URL = "https://api.luarmor.net/files/v3/loaders/f927290098f4333a9d217cbecbe6e988.lua"

-- Variable global para recordar si ya se autenticó
if not _G.KeyAuthenticated then
    _G.KeyAuthenticated = false
end

-- Función para cargar el script principal
local function loadMainScript()
    print("Cargando script principal...")
    
    -- Intentar cargar el script
    local success, result = pcall(function()
        return loadstring(game:HttpGet(SCRIPT_URL))()
    end)
    
    if success then
        print("Script cargado exitosamente!")
    else
        print("Error al cargar el script:", result)
    end
end

-- Si ya está autenticado, cargar directamente el script
if _G.KeyAuthenticated then
    print("Key ya autenticada, cargando script directamente...")
    loadMainScript()
    return
end

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyAuthGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Set Your Key"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Esquinas del título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- TextBox para la key
local keyTextBox = Instance.new("TextBox")
keyTextBox.Name = "KeyTextBox"
keyTextBox.Size = UDim2.new(0.8, 0, 0, 40)
keyTextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
keyTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyTextBox.BorderSizePixel = 0
keyTextBox.Text = ""
keyTextBox.PlaceholderText = "Ingresa tu key aquí..."
keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
keyTextBox.TextScaled = true
keyTextBox.Font = Enum.Font.Gotham
keyTextBox.Parent = mainFrame

-- Esquinas del TextBox
local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 8)
textBoxCorner.Parent = keyTextBox

-- Botón de verificación
local verifyButton = Instance.new("TextButton")
verifyButton.Name = "VerifyButton"
verifyButton.Size = UDim2.new(0.6, 0, 0, 40)
verifyButton.Position = UDim2.new(0.2, 0, 0.6, 0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
verifyButton.BorderSizePixel = 0
verifyButton.Text = "Verificar Key"
verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyButton.TextScaled = true
verifyButton.Font = Enum.Font.GothamBold
verifyButton.Parent = mainFrame

-- Esquinas del botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = verifyButton

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0.8, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Función de animación para el botón
local function animateButton(button, scale)
    local tween = TweenService:Create(
        button,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = button.Size * scale}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        local returnTween = TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = button.Size / scale}
        )
        returnTween:Play()
    end)
end

-- Función para cargar el script principal
local function loadMainScript()
    statusLabel.Text = "Cargando script..."
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    wait(1)
    
    -- Intentar cargar el script
    local success, result = pcall(function()
        return loadstring(game:HttpGet(SCRIPT_URL))()
    end)
    
    if success then
        statusLabel.Text = "Script cargado exitosamente!"
        -- Marcar como autenticado
        _G.KeyAuthenticated = true
        wait(2)
        screenGui:Destroy()
    else
        statusLabel.Text = "Error al cargar el script"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        print("Error loading script:", result)
    end
end

-- Función de verificación de key
local function verifyKey()
    local enteredKey = keyTextBox.Text
    
    if enteredKey == CORRECT_KEY then
        statusLabel.Text = "Key correcta! ✓"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Animar el frame desapareciendo
        local fadeOut = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        fadeOut:Play()
        
        -- Hacer todos los elementos transparentes
        for _, child in pairs(mainFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                local properties = {}
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    properties.TextTransparency = 1
                end
                if child.BackgroundTransparency ~= 1 then
                    properties.BackgroundTransparency = 1
                end
                
                if next(properties) then
                    local childTween = TweenService:Create(
                        child,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        properties
                    )
                    childTween:Play()
                end
            end
        end
        
        wait(1)
        loadMainScript()
    else
        statusLabel.Text = "Key incorrecta. Inténtalo de nuevo."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Animar error
        local errorTween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -190, 0.5, -125)}
        )
        errorTween:Play()
        
        errorTween.Completed:Connect(function()
            local returnTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, -210, 0.5, -125)}
            )
            returnTween:Play()
            
            returnTween.Completed:Connect(function()
                local finalTween = TweenService:Create(
                    mainFrame,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = UDim2.new(0.5, -200, 0.5, -125)}
                )
                finalTween:Play()
            end)
        end)
    end
end

-- Conectar eventos
verifyButton.MouseButton1Click:Connect(function()
    animateButton(verifyButton, 0.95)
    verifyKey()
end)

-- Permitir verificar con Enter
keyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyKey()
    end
end)

-- Efectos hover
verifyButton.MouseEnter:Connect(function()
    local hoverTween = TweenService:Create(
        verifyButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(0, 140, 220)}
    )
    hoverTween:Play()
end)

verifyButton.MouseLeave:Connect(function()
    local leaveTween = TweenService:Create(
        verifyButton,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(0, 162, 255)}
    )
    leaveTween:Play()
end)

print("Sistema de autenticación cargado.")
print("Estado de autenticación:", _G.KeyAuthenticated and "Autenticado" or "No autenticado")
if not _G.KeyAuthenticated then
    print("Key requerida: " .. CORRECT_KEY)
end
