local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotMenu"
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 320)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

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
    return button
end

local speed_on = false
local jump_on = false

local speed_button = crearBoton("Speed (Off)", 10, function()
    speed_on = not speed_on
    speed_button.Text = speed_on and "Speed (On)" or "Speed (Off)"
end)

local jump_button = crearBoton("Super Jump (Off)", 60, function()
    jump_on = not jump_on
    jump_button.Text = jump_on and "Super Jump (On)" or "Super Jump (Off)"
end)

crearBoton("Teleport a mi Base", 110, function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Cambia estas coordenadas a las de TU base exacta
        char.HumanoidRootPart.CFrame = CFrame.new(-200, 10, 300)
    end
end)

crearBoton("Cerrar Menú", 160, function()
    ScreenGui:Destroy()
end)

-- Mantener speed y salto activos
spawn(function()
    while true do
        task.wait(0.5)
        if speed_on then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.WalkSpeed ~= 50 then
                    humanoid.WalkSpeed = 50
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.WalkSpeed ~= 16 then
                    humanoid.WalkSpeed = 16
                end
            end
        end

        if jump_on then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.JumpPower ~= 120 then
                    humanoid.JumpPower = 120
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.JumpPower ~= 50 then
                    humanoid.JumpPower = 50
                end
            end
        end
    end
end)

-- Aplica al reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speed_on and 50 or 16
    humanoid.JumpPower = jump_on and 120 or 50
end)
