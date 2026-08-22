local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local PlayerGui = Player:WaitForChild("PlayerGui")

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

-- Создание инструмента
local function GiveTool()
    local Tool = Instance.new("Tool")
    Tool.Name = "Gold C4 Bomb"
    Tool.RequiresHandle = true
    Tool.CanBeDropped = false
    Tool.Grip = CFrame.new(0, -0.2, 0.2) * CFrame.Angles(0, math.rad(180), 0)
    
    local C4Part = BuildC4()
    C4Part.Parent = Tool
    
    Tool.Activated:Connect(function()
        -- Создаем бомбу в мире
        local bomb = BuildC4()
        bomb.Position = Player.Character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)
        bomb.Parent = workspace
        
        -- Эффект появления (партиклы)
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
        
        -- Удаляем бомбу через 5 секунд
        task.wait(5)
        if bomb and bomb.Parent then
            bomb:Destroy()
        end
    end)
    
    -- Даем инструмент игроку
    Tool.Parent = Player.Backpack
end

-- Даем инструмент при запуске
task.wait(1)
GiveTool()

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "C4 Bomb",
    Text = "кароче золотая бомба она видна ток у тебя",
    Duration = 5
})
