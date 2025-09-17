-- Steal the Brainrots - TP Save Script para Delta (mejorado)
-- Pega en Delta Executor mientras estás dentro del juego

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local savedPos = nil
local cooldown = false
local cooldownTime = 1.2 -- segundos entre TPs

-- Helper: obtener HumanoidRootPart (espera si no existe aún)
local function getHRP(char)
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart
    end
    return nil
end

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.ResetOnSpawn = false
-- Intenta CoreGui (Delta suele permitirlo); si falla, usa PlayerGui
local ok, err = pcall(function() screenGui.Parent = game.CoreGui end)
if not ok then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Panel contenedor (para mover)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 210, 0, 150)
frame.Position = UDim2.new(0.05, 0, 0.22, 0)
frame.BackgroundTransparency = 0.15
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "TP Save (Delta)"
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- Botones
local function makeBtn(text, posY)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 180, 0, 36)
    b.Position = UDim2.new(0.05, 0, 0, posY)
    b.Text = text
    b.Font = Enum.Font.SourceSans
    b.TextSize = 15
    b.Parent = frame
    b.BorderSizePixel = 0
    b.BackgroundTransparency = 0.08
    return b
end

local saveBtn = makeBtn("📍 Guardar Posición", 36)
local tpBtn   = makeBtn("⚡ TP Guardado", 76)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 24)
closeBtn.Position = UDim2.new(1, -42, 0, 4)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.Parent = frame
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0

-- Mensaje de estado
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.new(0, 5, 1, -28)
status.BackgroundTransparency = 1
status.Text = ""
status.TextSize = 14
status.Font = Enum.Font.SourceSansItalic
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Parent = frame

-- Drag del frame (para mover en pantalla)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Guardar posición
saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = getHRP(char)
    if hrp then
        savedPos = hrp.CFrame
        status.Text = "Posición guardada ✅"
        saveBtn.Text = "✅ Guardada"
        wait(1.2)
        saveBtn.Text = "📍 Guardar Posición"
        status.Text = ""
    else
        status.Text = "No se encontró HumanoidRootPart"
        wait(1.2)
        status.Text = ""
    end
end)

-- Teletransportar con manejo de respawn y cooldown
tpBtn.MouseButton1Click:Connect(function()
    if cooldown then
        status.Text = "En cooldown..."
        wait(0.8)
        status.Text = ""
        return
    end
    if not savedPos then
        status.Text = "No hay posición guardada ❌"
        tpBtn.Text = "❌ Sin Pos"
        wait(1.2)
        tpBtn.Text = "⚡ TP Guardado"
        status.Text = ""
        return
    end

    cooldown = true
    spawn(function()
        wait(cooldownTime)
        cooldown = false
    end)

    -- Si el personaje no existe ahora, espera a que reaparezca y luego TP
    local char = player.Character
    if not char then
        status.Text = "Esperando respawn..."
        char = player.CharacterAdded:Wait()
    end

    local hrp = getHRP(char)
    local tries = 0
    while not hrp and tries < 6 do
        wait(0.4)
        hrp = getHRP(player.Character)
        tries = tries + 1
    end

    if hrp then
        local ok, e = pcall(function()
            hrp.CFrame = savedPos
        end)
        if ok then
            status.Text = "Teletransportado ✅"
            tpBtn.Text = "✅ Teletransportado"
            wait(1.2)
            tpBtn.Text = "⚡ TP Guardado"
            status.Text = ""
        else
            status.Text = "Error al TP: "..tostring(e)
            wait(1.4)
            status.Text = ""
        end
    else
        status.Text = "No se encontró HRP para TP"
        wait(1.2)
        status.Text = ""
    end
end)

-- Cerrar GUI
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Mantener savedPos si reapareces (no se borra)
player.CharacterAdded:Connect(function(char)
    wait(0.6)
    -- opcional: podrías auto-teleportear si quieres, pero no lo hago para evitar riesgos
    -- si deseas auto-TP, descomenta lo siguiente (no recomendado en la mayoría de casos):
    -- if savedPos and char:FindFirstChild("HumanoidRootPart") then
    --    char.HumanoidRootPart.CFrame = savedPos
    -- end
end)

print("[TPGui] Cargado - usa 'Guardar Posición' y luego 'TP Guardado'")
