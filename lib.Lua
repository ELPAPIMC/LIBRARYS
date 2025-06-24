--! filename: lime.lua
-- Este es el contenido de tu archivo 'lime.lua' que subirías a GitHub

local Library = {}
local Windows = {}
local ActiveWindow = nil -- Para controlar qué ventana está visible/activa

-- Constructor de la ventana
function Library:Window(name)
    local newWindow = {
        Name = name,
        Elements = {}
    }

    -- Método para añadir un botón a la ventana
    function newWindow:Button(text, callback)
        table.insert(newWindow.Elements, {
            Type = "Button",
            Text = text,
            Callback = callback
        })
        -- En un entorno real, aquí se crearía el elemento visual del botón
        -- y se le asignaría el evento de clic.
    end

    -- Método para añadir un Toggle a la ventana
    function newWindow:Toggle(text, callback)
        table.insert(newWindow.Elements, {
            Type = "Toggle",
            Text = text,
            Callback = callback,
            Value = false -- Estado inicial del toggle
        })
        -- Similar al botón, se crearía el elemento visual y se manejarían los eventos.
    end

    -- Método para añadir un Slider a la ventana
    function newWindow:Slider(text, callback, min, max, initialValue)
        table.insert(newWindow.Elements, {
            Type = "Slider",
            Text = text,
            Callback = callback,
            Min = min or 0,
            Max = max or 100,
            Value = initialValue or (min or 0) -- Estado inicial del slider
        })
        -- Implementación del slider.
    end

    -- Aquí podrías añadir más métodos para otros tipos de elementos (Label, TextBox, etc.)

    Windows[name] = newWindow
    if not ActiveWindow then
        ActiveWindow = newWindow -- Si es la primera ventana, la activamos
    end

    return newWindow
end

-- Función para dibujar la GUI (simulación, ya que en Roblox esto se haría con instancias de UI)
function Library:Draw()
    print("--- GUI Creada ---")
    for windowName, windowData in pairs(Windows) do
        print("\nVentana: " .. windowName)
        for i, element in ipairs(windowData.Elements) do
            if element.Type == "Button" then
                print(string.format("  [Button] %s", element.Text))
            elseif element.Type == "Toggle" then
                print(string.format("  [Toggle] %s (Estado: %s)", element.Text, tostring(element.Value)))
            elseif element.Type == "Slider" then
                print(string.format("  [Slider] %s (Valor: %s, Rango: %d-%d)", element.Text, tostring(element.Value), element.Min, element.Max))
            end
        end
    end
    print("------------------")
end


-- Esto es lo que se devolverá cuando se cargue la librería
return Library
