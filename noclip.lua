local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local noclipEnabled = false
local noclipConnection = nil

-- Функция для включения/отключения ноклипа
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        -- Включаем ноклип
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        noclipConnection = RunService.Stepped:Connect(function()
            local character = Player.Character
            if not character then return end
            
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        -- Уведомление
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Noclip",
            Text = "🔓 Noclip ВКЛЮЧЕН",
            Duration = 2
        })
    else
        -- Выключаем ноклип
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        
        -- Восстанавливаем коллизии
        local character = Player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        -- Уведомление
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Noclip",
            Text = "🔒 Noclip ВЫКЛЮЧЕН",
            Duration = 2
        })
    end
    
    -- Обновляем GUI
    updateGUI()
end

-- СОЗДАНИЕ GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Главная кнопка
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 140, 0, 40)
mainButton.Position = UDim2.new(0.02, 0, 0.15, 0)
mainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainButton.BorderSizePixel = 0
mainButton.Text = "🔓 NOCLIP: OFF"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextSize = 16
mainButton.Font = Enum.Font.SourceSansBold
mainButton.Draggable = true
mainButton.Active = true
mainButton.Parent = screenGui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainButton

-- Подсветка при наведении
local function updateGUI()
    if noclipEnabled then
        mainButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        mainButton.Text = "🔓 NOCLIP: ON"
        mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        mainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        mainButton.Text = "🔒 NOCLIP: OFF"
        mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Клик по кнопке
mainButton.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

-- Горячая клавиша N для включения/отключения
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    end
end)

-- Кнопка закрытия GUI (крестик)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -28, 0, -28)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Visible = false
closeButton.Parent = mainButton

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
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    screenGui:Destroy()
end)

-- Обновляем GUI при старте
updateGUI()

-- Уведомление о загрузке
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Noclip",
    Text = "Нажми N или кнопку для включения/отключения",
    Duration = 3
})
