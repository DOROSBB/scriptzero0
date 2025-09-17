-- Steal the Brainrots - Ghost Toggle Funcional
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Cambia esto al nombre correcto del evento del juego
local brainEvent = ReplicatedStorage:WaitForChild("PickBrainrot",5) 

local active = false -- toggle

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GhostGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,60)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,180,0,40)
toggleBtn.Position = UDim2.new(0.05,0,0,10)
toggleBtn.Text = "Ghost OFF"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = frame

-- Función para hacer ghost
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

-- Función para volver visible
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

-- Toggle GUI
toggleBtn.MouseButton1Click:Connect(function()
    active = not active
    toggleBtn.Text = active and "Ghost ON" or "Ghost OFF"
end)

-- Detectar cuando agarras Brainrot
if brainEvent then
    brainEvent.OnClientEvent:Connect(function()
        if active then
            local char = player.Character or player.CharacterAdded:Wait()
            makeGhost(char)
            -- Volver visible después de 3 seg (opcional)
            spawn(function()
                wait(3)
                unGhost(char)
            end)
        end
    end)
end

print("[GhostBrainrot] GUI lista. Pulsa toggle para activar ghost al agarrar Brainrot")
