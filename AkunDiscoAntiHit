-- Anti-Hit GUI Mejorada - Compatible con Executors
-- Versión: 4.0 Optimizada

-- Verificación de entorno
if not game:GetService("Players").LocalPlayer then
    warn("Error: LocalPlayer no encontrado")
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Verificar si ya existe la GUI para evitar duplicados
if LocalPlayer.PlayerGui:FindFirstChild("AntiHitGUI") then
    LocalPlayer.PlayerGui.AntiHitGUI:Destroy()
    wait(0.1)
end

-- Creación de instancias
local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")
local ImageLabel = Instance.new("ImageLabel")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

-- Configuración de la ScreenGui
ScreenGui.Name = "AntiHitGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false -- CRÍTICO: Evita que se destruya al morir

-- Configuración del botón principal
TextButton.Name = "AntiHitButton"
TextButton.Parent = ScreenGui
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.389962852, 0, 0.448347121, 0)
TextButton.Size = UDim2.new(0.438596487, 0, 0.103305787, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "ACTIVAR ANTI-HIT"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.Active = true -- Permite arrastre
TextButton.Draggable = true -- Hace la GUI arrastrable

-- Configuración de la imagen
ImageLabel.Parent = TextButton
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(-0.294999987, 0, 0, 0)
ImageLabel.Size = UDim2.new(0.25999999, 0, 1, 0)
ImageLabel.Image = "rbxassetid://139595360558140"

-- Configuración de esquinas redondeadas
UICorner.CornerRadius = UDim.new(0, 99)
UICorner.Parent = ImageLabel

UICorner_2.CornerRadius = UDim.new(0, 14)
UICorner_2.Parent = TextButton

-- Configuración de proporciones
UIAspectRatioConstraint.Parent = TextButton
UIAspectRatioConstraint.AspectRatio = 4.000

UITextSizeConstraint.Parent = TextButton
UITextSizeConstraint.MaxTextSize = 50

-- Variables de estado
local antiHitActive = false
local isCountingDown = false

-- Funciones utilitarias mejoradas con manejo de errores
local function safeGetCharacter()
    local character = LocalPlayer.Character
    if not character or not character.Parent then
        return nil
    end
    return character
end

local function getTorso(character)
    if not character then return nil end
    return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
end

local function getRootPart(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(character)
    if not character then return nil end
    return character:FindFirstChildOfClass("Humanoid")
end

-- Función para activar anti-hit (mejorada)
local function activateAntiHit(character)
    if not character then return false end
    
    pcall(function()
        -- Procesar partes del cuerpo
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local isTorso = (part.Name == "UpperTorso" or part.Name == "Torso")
                if not isTorso then
                    part.CanCollide = false
                    part.Transparency = 0.7
                end
                part.Anchored = false -- Nunca anclar para permitir movimiento
            end
        end
        
        -- Procesar accesorios
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") and accessory:FindFirstChild("Handle") then
                accessory.Handle.CanCollide = false
                accessory.Handle.Transparency = 0.7
                accessory.Handle.Anchored = false
            end
        end
    end)
    
    return true
end

-- Función para restaurar character (mejorada)
local function restoreCharacter(character)
    if not character then return false end
    
    pcall(function()
        -- Restaurar partes del cuerpo
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
                part.Anchored = false
            end
        end
        
        -- Restaurar accesorios
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") and accessory:FindFirstChild("Handle") then
                accessory.Handle.CanCollide = true
                accessory.Handle.Transparency = 0
                accessory.Handle.Anchored = false
            end
        end
    end)
    
    return true
end

-- Función de cuenta regresiva mejorada
local function countdown(seconds)
    isCountingDown = true
    local originalColor = TextButton.BackgroundColor3
    
    for i = seconds, 1, -1 do
        if not isCountingDown then break end
        
        TextButton.Text = "ANTI-HIT EN " .. i .. "..."
        TextButton.BackgroundColor3 = Color3.fromRGB(255, 255 - (i * 50), 0)
        
        wait(1)
    end
    
    if isCountingDown then
        TextButton.BackgroundColor3 = originalColor
        isCountingDown = false
    end
end

-- Efectos visuales mejorados
local function buttonPressEffect()
    local tween = TweenService:Create(
        TextButton,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {Size = UDim2.new(0.418596487, 0, 0.093305787, 0)}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        local tweenBack = TweenService:Create(
            TextButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0.438596487, 0, 0.103305787, 0)}
        )
        tweenBack:Play()
    end)
end

-- Lógica principal del botón (completamente reescrita)
local function onButtonClick()
    if isCountingDown then
        -- Cancelar cuenta regresiva
        isCountingDown = false
        TextButton.Text = "ACTIVAR ANTI-HIT"
        TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        return
    end
    
    buttonPressEffect()
    
    local character = safeGetCharacter()
    if not character then
        TextButton.Text = "ERROR: SIN CHARACTER"
        wait(2)
        TextButton.Text = "ACTIVAR ANTI-HIT"
        return
    end
    
    if not antiHitActive then
        -- Activar Anti-Hit
        spawn(function()
            countdown(3)
            if not isCountingDown then return end
            
            local currentChar = safeGetCharacter()
            if currentChar and activateAntiHit(currentChar) then
                antiHitActive = true
                TextButton.Text = "DESACTIVAR ANTI-HIT"
                TextButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                
                -- Notificación visual
                local notification = Instance.new("TextLabel")
                notification.Parent = ScreenGui
                notification.BackgroundTransparency = 1
                notification.Position = UDim2.new(0.5, 0, 0.3, 0)
                notification.Size = UDim2.new(0, 200, 0, 50)
                notification.AnchorPoint = Vector2.new(0.5, 0.5)
                notification.Text = "✓ ANTI-HIT ACTIVADO"
                notification.TextColor3 = Color3.fromRGB(0, 255, 0)
                notification.TextScaled = true
                notification.Font = Enum.Font.SourceSansBold
                
                -- Desvanecer notificación
                local fadeOut = TweenService:Create(
                    notification,
                    TweenInfo.new(2, Enum.EasingStyle.Quad),
                    {TextTransparency = 1}
                )
                fadeOut:Play()
                fadeOut.Completed:Connect(function()
                    notification:Destroy()
                end)
            else
                TextButton.Text = "ERROR AL ACTIVAR"
                wait(2)
                TextButton.Text = "ACTIVAR ANTI-HIT"
            end
        end)
    else
        -- Desactivar Anti-Hit
        local currentChar = safeGetCharacter()
        if currentChar and restoreCharacter(currentChar) then
            antiHitActive = false
            TextButton.Text = "ACTIVAR ANTI-HIT"
            TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            
            -- Notificación
            local notification = Instance.new("TextLabel")
            notification.Parent = ScreenGui
            notification.BackgroundTransparency = 1
            notification.Position = UDim2.new(0.5, 0, 0.3, 0)
            notification.Size = UDim2.new(0, 200, 0, 50)
            notification.AnchorPoint = Vector2.new(0.5, 0.5)
            notification.Text = "✗ ANTI-HIT DESACTIVADO"
            notification.TextColor3 = Color3.fromRGB(255, 0, 0)
            notification.TextScaled = true
            notification.Font = Enum.Font.SourceSansBold
            
            local fadeOut = TweenService:Create(
                notification,
                TweenInfo.new(2, Enum.EasingStyle.Quad),
                {TextTransparency = 1}
            )
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                notification:Destroy()
            end)
        else
            TextButton.Text = "ERROR AL DESACTIVAR"
            wait(2)
            TextButton.Text = "DESACTIVAR ANTI-HIT"
        end
    end
end

-- Conectar eventos
TextButton.MouseButton1Click:Connect(onButtonClick)

-- Auto-reactivar anti-hit al respawnear (opcional)
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(2) -- Esperar a que el character se cargue completamente
    
    if antiHitActive then
        character:WaitForChild("HumanoidRootPart", 10)
        wait(1)
        activateAntiHit(character)
    end
end)

-- Manejo de errores global
spawn(function()
    while ScreenGui.Parent do
        wait(5)
        -- Verificar si el anti-hit sigue activo
        if antiHitActive then
            local character = safeGetCharacter()
            if character then
                -- Re-aplicar anti-hit en caso de que algo lo haya desactivado
                pcall(function()
                    activateAntiHit(character)
                end)
            end
        end
    end
end)

-- Mensaje de confirmación
print("✓ Anti-Hit GUI cargada exitosamente!")
print("• La GUI es arrastrable")
print("• ResetOnSpawn desactivado")
print("• Manejo de errores activo")
print("• Compatible con executors comunes")
