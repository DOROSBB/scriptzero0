-- Steal the Brainrots - Modo Invisible/Invulnerable al agarrar Brainrot
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Función para hacer invisible y no colisionar
local function makeGhost(character)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1          -- Invisible
            part.CanCollide = false        -- No colisiona
        elseif part:IsA("Decal") then
            part.Transparency = 1          -- Oculta decals
        end
    end
    -- Opcional: desactivar efectos de sombra
    if character:FindFirstChild("Humanoid") then
        character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end

-- Detectar cuando agarras un Brainrot
-- Esto depende de cómo el juego detecta la acción. 
-- Suponiendo que hay un evento RemoteFunction/RemoteEvent llamado "PickBrainrot":
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local brainEvent = ReplicatedStorage:WaitForChild("PickBrainrot", 5)

if brainEvent then
    brainEvent.OnClientEvent:Connect(function()
        local char = player.Character or player.CharacterAdded:Wait()
        makeGhost(char)
        -- Vuelve visible después de 3 segundos (opcional)
        wait(3)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end)
end

print("[InvisibleBrainrot] Listo: al agarrar un Brainrot te vuelves invisible y no colisionas")
