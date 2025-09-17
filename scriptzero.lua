-- Steal the Brainrots - Alerta Brainrots Valiosos + Ghost
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local ghostActive = false

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotAlertGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,100)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.15
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "💰 Brainrots Valiosos"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1,-10,0,50)
infoLabel.Position = UDim2.new(0,5,0,35)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Esperando Brainrots..."
infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
infoLabel.TextWrapped = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 14
infoLabel.Parent = frame

local ghostBtn = Instance.new("TextButton")
ghostBtn.Size = UDim2.new(0,100,0,30)
ghostBtn.Position = UDim2.new(0.5,-50,1,-35)
ghostBtn.Text = "Ghost OFF"
ghostBtn.Font = Enum.Font.SourceSansBold
ghostBtn.TextSize = 14
ghostBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
ghostBtn.TextColor3 = Color3.fromRGB(255,255,255)
ghostBtn.Parent = frame

-- Toggle Ghost
ghostBtn.MouseButton1Click:Connect(function()
    ghostActive = not ghostActive
    ghostBtn.Text = ghostActive and "Ghost ON" or "Ghost OFF"
end)

-- Función Ghost
local function makeGhost(character)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        elseif part:IsA("Decal") then
            part.Transparency = 1
        end
    end
end

local function unGhost(character)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
        elseif part:IsA("Decal") then
            part.Transparency = 0
        end
    end
end

-- Detectar Brainrots en el servidor
local function scanBrainrots()
    local workspaceObjs = workspace:GetDescendants()
    for _, obj in pairs(workspaceObjs) do
        if obj:IsA("Model") and obj:FindFirstChild("Value") and obj:FindFirstChild("Name") then
            local value = obj.Value.Value
            local name = obj.Name
            if value >= 15000000 then -- Brainrot valioso ≥ 15 millones
                infoLabel.Text = "💰 Nombre: "..name.."\nValor: "..value.." 💸"
                if ghostActive then
                    local char = player.Character or player.CharacterAdded:Wait()
                    makeGhost(char)
                end
            end
        end
    end
end

-- Repetir escaneo cada 1 segundo
RunService.Heartbeat:Connect(function()
    scanBrainrots()
end)

-- Al reaparecer, quitar ghost si está activo
player.CharacterAdded:Connect(function(char)
    wait(0.5)
    if ghostActive then
        makeGhost(char)
    else
        unGhost(char)
    end
end)

print("[BrainrotAlert] Script cargado. Detecta Brainrots ≥ 15M y activa ghost si lo deseas.")
