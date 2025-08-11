-- Sistema de Key para el script Luarmor
local function createKeySystem()
    -- Crear instancias básicas para la GUI
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Subtitle = Instance.new("TextLabel")
    local KeyInput = Instance.new("TextBox")
    local VerifyButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    
    -- Propiedades de la GUI principal
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game.CoreGui
    end
    
    ScreenGui.Name = "KeySystemGUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Marco principal
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderColor3 = Color3.fromRGB(0, 120, 215)
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    MainFrame.Size = UDim2.new(0, 350, 0, 250)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Hacer las esquinas redondeadas
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    -- Título
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Set Your Key"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    
    -- Subtítulo
    Subtitle.Name = "Subtitle"
    Subtitle.Parent = MainFrame
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 0, 0, 55)
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "Ingresa la key para acceder al script"
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    Subtitle.TextSize = 14
    
    -- Input para la key
    KeyInput.Name = "KeyInput"
    KeyInput.Parent = MainFrame
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
    KeyInput.Position = UDim2.new(0.5, -125, 0, 100)
    KeyInput.Size = UDim2.new(0, 250, 0, 40)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.PlaceholderText = "Ingresa la key aquí..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 16
    KeyInput.ClearTextOnFocus = false
    
    -- Agregar esquinas redondeadas al input
    local UICornerInput = Instance.new("UICorner")
    UICornerInput.CornerRadius = UDim.new(0, 6)
    UICornerInput.Parent = KeyInput
    
    -- Botón de verificación
    VerifyButton.Name = "VerifyButton"
    VerifyButton.Parent = MainFrame
    VerifyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    VerifyButton.Position = UDim2.new(0.5, -75, 0, 160)
    VerifyButton.Size = UDim2.new(0, 150, 0, 40)
    VerifyButton.Font = Enum.Font.GothamBold
    VerifyButton.Text = "VERIFICAR"
    VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyButton.TextSize = 16
    
    -- Agregar esquinas redondeadas al botón
    local UICornerButton = Instance.new("UICorner")
    UICornerButton.CornerRadius = UDim.new(0, 6)
    UICornerButton.Parent = VerifyButton
    
    -- Etiqueta de estado
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 0, 0, 210)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
    StatusLabel.TextSize = 14
    
    -- Botón de cierre
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = MainFrame
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 10)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 75, 75)
    CloseButton.TextSize = 20
    
    -- Función para verificar la key
    local function verifyKey()
        local inputKey = KeyInput.Text
        if inputKey == "LezzoStoreAccess" then
            StatusLabel.Text = "Key correcta! Cargando script..."
            StatusLabel.TextColor3 = Color3.fromRGB(75, 255, 75)
            
            -- Efectos visuales de éxito
            for i = 1, 3 do
                VerifyButton.BackgroundColor3 = Color3.fromRGB(75, 255, 75)
                wait(0.1)
                VerifyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
                wait(0.1)
            end
            
            wait(1)
            ScreenGui:Destroy()
            
            -- Cargar el script original después de verificar la key
            loadstring(
                game:HttpGet(
                    'https://api.luarmor.net/files/v3/loaders/f927290098f4333a9d217cbecbe6e988.lua'
                )
            )()
        else
            StatusLabel.Text = "Key incorrecta. Inténtalo de nuevo."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
            
            -- Efectos visuales de error
            for i = 1, 2 do
                KeyInput.BorderColor3 = Color3.fromRGB(255, 0, 0)
                wait(0.1)
                KeyInput.BorderColor3 = Color3.fromRGB(60, 60, 60)
                wait(0.1)
            end
        end
    end
    
    -- Cerrar la GUI
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Verificar cuando se presiona el botón
    VerifyButton.MouseButton1Click:Connect(verifyKey)
    
    -- También verificar cuando se presiona Enter en el input
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            verifyKey()
        end
    end)
    
    -- Efectos visuales para el botón
    VerifyButton.MouseEnter:Connect(function()
        VerifyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    end)
    
    VerifyButton.MouseLeave:Connect(function()
        VerifyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)
end

-- Ejecutar el sistema de key
createKeySystem()
