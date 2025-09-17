-- Steal the Brainrots - TP Save Script Optimizado
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local savedPos = nil
local cooldown = false
local cooldownTime = 1.2

-- Helper
local function getHRP(char)
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart
    end
    return nil
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.05,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.15
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "TP Save Optimizado"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local function makeBtn(text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 36)
    btn.Position = UDim2.new(0.05,0,0,posY)
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

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-10,0,20)
status.Position = UDim2.new(0,5,1,-28)
status.BackgroundTransparency = 1
status.Text = ""
status.TextSize = 14
status.Font = Enum.Font.SourceSansItalic
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Parent = frame

-- Guardar posición
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
    end
end)

-- TP seguro (Tween rápido)
local function doTeleport()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = getHRP(char)
    if not hrp then return end
    -- Mueve todo el Character suavemente en 0.15s
    local info = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, info, {CFrame = savedPos})
    tween:Play()
end

tpBtn.MouseButton1Click:Connect(function()
    if cooldown then return end
    if not savedPos then
        status.Text = "❌ Sin posición"
        wait(1.2)
        status.Text = ""
        return
    end
    cooldown = true
    spawn(function() wait(cooldownTime) cooldown = false end)
    doTeleport()
end)

-- Auto-TP tras respawn
player.CharacterAdded:Connect(function(char)
    wait(0.5)
    local hrp = getHRP(char)
    if hrp and savedPos then
        wait(0.1)
        local info = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, info, {CFrame = savedPos})
        tween:Play()
    end
end)

-- Cerrar GUI
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

print("[TP Optimizado] Listo y seguro para Steal the Brainrots")
