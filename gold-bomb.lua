local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- Функция создания бомбы
local function BuildC4()
    local Main = Instance.new("Part")
    Main.Name = "Handle"
    Main.Size = Vector3.new(1.8, 0.7, 1.2)
    Main.Color = Color3.fromRGB(255, 180, 50)
    Main.Material = Enum.Material.Metal
    Main.CanCollide = true
    return Main
end

-- Функция создания инструмента
local function GiveTool()
    if Player.Backpack:FindFirstChild("Gold C4 Bomb") then
        return
    end
    
    local Tool = Instance.new("Tool")
    Tool.Name = "Gold C4 Bomb"
    Tool.RequiresHandle = true
    Tool.CanBeDropped = false
    Tool.Grip = CFrame.new(0, -0.2, 0.2) * CFrame.Angles(0, math.rad(180), 0)
    
    local C4Part = BuildC4()
    C4Part.Parent = Tool
    
    Tool.Activated:Connect(function()
        local bomb = BuildC4()
        bomb.Position = Player.Character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)
        bomb.Parent = workspace
        
        local attachment = Instance.new("Attachment", bomb)
        local particle = Instance.new("ParticleEmitter", attachment)
        particle.Texture = "rbxassetid://10834488259"
        particle.Lifetime = NumberRange.new(0.5)
        particle.Rate = 100
        particle.VelocityInheritance = 0
        particle.SpreadAngle = Vector2.new(360, 360)
        particle.Enabled = true
        
        task.wait(0.3)
        particle.Enabled = false
        task.wait(0.2)
        particle:Destroy()
        attachment:Destroy()
        
        task.wait(5)
        if bomb and bomb.Parent then
            bomb:Destroy()
        end
    end)
    
    Tool.Parent = Player.Backpack
end

-- СОЗДАНИЕ GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoldBombGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Главная кнопка
local mainButton = Instance.new("ImageButton")
mainButton.Size = UDim2.new(0, 60, 0, 60)
mainButton.Position = UDim2.new(0.02, 0, 0.2, 0)
mainButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
mainButton.BackgroundTransparency = 0.2
mainButton.BorderSizePixel = 0
mainButton.Image = "rbxassetid://109283577128136"
mainButton.ImageColor3 = Color3.fromRGB(255, 215, 0)
mainButton.Draggable = true
mainButton.Active = true
mainButton.Parent = screenGui

-- Скругление
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = mainButton

-- Текст на кнопке (эмодзи бомбы)
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 20)
label.Position = UDim2.new(0, 0, 1, -20)
label.BackgroundTransparency = 1
label.Text = "💣"
label.TextSize = 18
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSansBold
label.Parent = mainButton

-- Подпись под кнопкой
local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(0, 70, 0, 16)
subLabel.Position = UDim2.new(0, -5, 1, 5)
subLabel.BackgroundTransparency = 1
subLabel.Text = "Gold Bomb"
subLabel.TextSize = 12
subLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
subLabel.Font = Enum.Font.SourceSansBold
subLabel.TextScaled = true
subLabel.Parent = mainButton

-- Подсказка при наведении
local tooltip = Instance.new("TextLabel")
tooltip.Size = UDim2.new(0, 120, 0, 25)
tooltip.Position = UDim2.new(0, 70, 0, 10)
tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tooltip.BackgroundTransparency = 0.1
tooltip.Text = "Нажми для бомбы | G - скрыть"
tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
tooltip.TextSize = 12
tooltip.Font = Enum.Font.SourceSans
tooltip.Visible = false
tooltip.Parent = mainButton

-- Появление подсказки
mainButton.MouseEnter:Connect(function()
    tooltip.Visible = true
end)

mainButton.MouseLeave:Connect(function()
    tooltip.Visible = false
end)

-- Клик по кнопке - выдача бомбы
mainButton.MouseButton1Click:Connect(function()
    GiveTool()
    
    mainButton.ImageColor3 = Color3.fromRGB(100, 255, 100)
    task.wait(0.1)
    mainButton.ImageColor3 = Color3.fromRGB(255, 215, 0)
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Gold Bomb",
        Text = "Бомба добавлена в инвентарь!",
        Duration = 2
    })
end)

-- Кнопка для закрытия GUI (маленький крестик)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, -25) -- Снаружи, сверху справа
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Visible = false
closeButton.Parent = mainButton

-- Скругление крестика
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Показываем крестик при наведении
mainButton.MouseEnter:Connect(function()
    closeButton.Visible = true
end)

mainButton.MouseLeave:Connect(function()
    closeButton.Visible = false
end)

-- Закрытие по крестику
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- ОТКЛЮЧЕНИЕ ПО КНОПКЕ G
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
        
        -- Уведомление о статусе
        local status = screenGui.Enabled and "показан" or "скрыт"
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Gold Bomb GUI",
            Text = "GUI " .. status,
            Duration = 1
        })
    end
end)

-- Создаем бомбу при запуске
task.wait(0.5)
GiveTool()

-- Уведомление о загрузке
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Gold Bomb",
    Text = "Нажми 💣 для бомбы | G - скрыть/показать",
    Duration = 4
})
