local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Настройки
local TeleportPoints = {
    Point1 = Vector3.new(10.9, 2484.6, 8.8),
    Point2 = Vector3.new(-31.0, 1845.4, -9.3),
}

local isRunning = true  -- АВТОЗАПУСК
local currentLoop = 0

-- Функция отправки сообщения в чат от имени игрока
local function sendChatMessage(message)
    local TextChatService = game:GetService("TextChatService")
    
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local success = pcall(function()
            TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
        end)
        if not success then
            pcall(function()
                local channel = TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
                if channel then
                    channel:SendAsync(message)
                end
            end)
        end
    else
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents then
            chatEvents.SayMessageRequest:FireServer(message, "All")
        end
    end
end

-- Функция телепортации
local function teleportTo(position)
    local character = Player.Character
    if not character then return false end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    return true
end

-- ================== GUI ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoSkipGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Главная рамка
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🔄 AUTO SKIP CYCLE"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "▶ Работает..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Счётчик циклов
local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, -20, 0, 20)
counterLabel.Position = UDim2.new(0, 10, 0, 65)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Циклов выполнено: 0"
counterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
counterLabel.Font = Enum.Font.SourceSans
counterLabel.TextSize = 12
counterLabel.TextXAlignment = Enum.TextXAlignment.Left
counterLabel.Parent = mainFrame

-- Функция обновления статуса
local function updateStatus()
    if isRunning then
        statusLabel.Text = "▶ Работает..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        statusLabel.Text = "⏸ Остановлено"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
    counterLabel.Text = "Циклов выполнено: " .. currentLoop
end

-- Кнопка PAUSE
local pauseButton = Instance.new("TextButton")
pauseButton.Size = UDim2.new(0.5, -15, 0, 35)
pauseButton.Position = UDim2.new(0, 10, 1, -45)
pauseButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
pauseButton.BorderSizePixel = 0
pauseButton.Text = "⏸ PAUSE"
pauseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pauseButton.Font = Enum.Font.SourceSansBold
pauseButton.TextSize = 14
pauseButton.Parent = mainFrame

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 8)
pauseCorner.Parent = pauseButton

-- Кнопка RESUME
local resumeButton = Instance.new("TextButton")
resumeButton.Size = UDim2.new(0.5, -15, 0, 35)
resumeButton.Position = UDim2.new(0.5, 5, 1, -45)
resumeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
resumeButton.BorderSizePixel = 0
resumeButton.Text = "▶ RESUME"
resumeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resumeButton.Font = Enum.Font.SourceSansBold
resumeButton.TextSize = 14
resumeButton.Parent = mainFrame

local resumeCorner = Instance.new("UICorner")
resumeCorner.CornerRadius = UDim.new(0, 8)
resumeCorner.Parent = resumeButton

-- Циклический скрипт
local function runLoop()
    while isRunning do
        currentLoop = currentLoop + 1
        updateStatus()
        
        -- ЭТАП 1: Телепорт на первую точку
        local char1 = Player.Character or Player.CharacterAdded:Wait()
        char1:WaitForChild("HumanoidRootPart")
        
        if not isRunning then break end
        
        teleportTo(TeleportPoints.Point1)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔄 Цикл #" .. currentLoop,
            Text = "ТП 1 выполнено",
            Duration = 1.5
        })
        
        -- Ждём 3 секунды
        task.wait(3)
        
        if not isRunning then break end
        
        -- ЭТАП 2: Телепорт на вторую точку
        local char2 = Player.Character or Player.CharacterAdded:Wait()
        char2:WaitForChild("HumanoidRootPart")
        
        if not isRunning then break end
        
        teleportTo(TeleportPoints.Point2)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔄 Цикл #" .. currentLoop,
            Text = "ТП 2 выполнено",
            Duration = 1.5
        })
        
        -- ЭТАП 3: Пишем /skip в чат
        task.wait(0.5)
        
        if not isRunning then break end
        
        sendChatMessage("/skip")
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "💬 Чат",
            Text = "Отправлено: /skip",
            Duration = 1.5
        })
        
        -- Небольшая задержка перед следующим циклом
        task.wait(0.5)
    end
    
    -- Если цикл прервался, но isRunning всё ещё true — перезапускаем
    if isRunning then
        task.spawn(runLoop)
    end
end

-- Обработчики кнопок
pauseButton.MouseButton1Click:Connect(function()
    if not isRunning then return end
    isRunning = false
    updateStatus()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔄 Auto Skip",
        Text = "⏸ Пауза",
        Duration = 2
    })
end)

resumeButton.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    updateStatus()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔄 Auto Skip",
        Text = "▶ Продолжение",
        Duration = 2
    })
    
    task.spawn(runLoop)
end)

closeButton.MouseButton1Click:Connect(function()
    isRunning = false
    screenGui:Destroy()
end)

-- ================== АВТОЗАПУСК ==================
updateStatus()

-- Уведомление при загрузке
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔄 Auto Skip",
    Text = "Скрипт запущен автоматически!",
    Duration = 3
})

-- Ждём загрузки персонажа и запускаем цикл
task.wait(1)
task.spawn(runLoop)
