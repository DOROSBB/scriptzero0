local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotMenu"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Función para crear botones
local function crearBoton(texto, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = texto
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.Parent = Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Click:Connect(callback)
end

local speed_on = false
local jump_on = false

crearBoton("Speed (Off)", 10, function()
    speed_on = not speed_on
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed_on and 50 or 16
    end
    -- Actualizar texto del botón
    Frame:GetChildren()[2].Text = speed_on and "Speed (On)" or "Speed (Off)"
end)

crearBoton("Super Jump (Off)", 60, function()
    jump_on = not jump_on
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = jump_on and 120 or 50
    end
    Frame:GetChildren()[3].Text = jump_on and "Super Jump (On)" or "Super Jump (Off)"
end)

crearBoton("Teleport a Base", 110, function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(-114, 10, -25) -- Cambia por coordenadas base
    end
end)

crearBoton("Cerrar Menú", 160, function()
    ScreenGui:Destroy()
end)

-- Auto aplicar speed y salto al reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local humanoid = char:WaitForChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed_on and 50 or 16
        humanoid.JumpPower = jump_on and 120 or 50
    end
end)
