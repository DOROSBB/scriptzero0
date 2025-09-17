-- Steal the Brainrots - TP Save Script (Delta Actualizado)
-- by ChatGPT / DOROSBB

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local savedPos = nil
local cooldown = false
local cooldownTime = 1.2 -- segundos entre TPs

-- Helper para obtener HumanoidRootPart
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
local ok, err = pcall(function() screenGui.Parent = game.CoreGui end)
if not ok then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Panel
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundTransparency = 0.15
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "TP Save (Delta)"
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

-- Crear botones
local function makeBtn(text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 36)
    btn.Position = UDim2.new(0.05,0,0, posY)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = color
    btn.Parent = frame
    btn.BorderSizePixel = 0
    btn.BackgroundTransparency = 0.1
    return btn
end

local saveBtn = makeBtn("📍 Guardar Posición", 36, Color3.fromRGB(0,170,255))
local tpBtn   = makeBtn("⚡ TP Guardado", 76, Color3.fromRGB(0,200,0))
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,36,0,24)
closeBtn.Position = UDim2.new(1,-42,0,4)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Parent = frame

-- Estado
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-10,0,20)
status.Position = UDim2.new(0,5,1,-28)
status.BackgroundTransparency = 1
status.Text = ""
status.TextSize = 14
status.Font = Enum.Font.SourceSansItalic
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Parent = frame

-- Drag para mover GUI
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
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Guardar Posición
saveBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = getHRP(char)
    if hrp then
        savedPos = hrp.CFrame
        saveBtn.Text = "✅ Guardada"
        status.Text = "Posición guardada!"
        wait(1.2)
        saveBtn.Text = "📍 Guardar Posición"
        status.Text = ""
    else
        status.Text = "HRP no encontrada"
        wait(1.2)
        status.Text = ""
    end
end)

-- Teleport
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
    spawn(function() wait(cooldownTime) cooldown = false end)

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = getHRP(char)
    local tries = 0
    while not hrp and tries < 6 do
        wait(0.4)
        hrp = getHRP(player.Character)
        tries = tries + 1
    end
    if hrp then
        local ok,_ = pcall(function() hrp.CFrame = savedPos end)
        if ok then
            tpBtn.Text = "✅ Teleport"
            status.Text = "Teletransportado!"
            wait(1.2)
            tpBtn.Text = "⚡ TP Guardado"
            status.Text = ""
        else
            status.Text = "Error al TP"
            wait(1.2)
            status.Text = ""
        end
    else
        status.Text = "HRP no encontrada"
        wait(1.2)
        status.Text = ""
    end
end)

-- Cerrar GUI
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Mantener savedPos tras respawn
player.CharacterAdded:Connect(function(char)
    wait(0.6)
end)

print("[TP Save] Script cargado correctamente.")
