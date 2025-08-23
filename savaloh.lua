-- New example script written by wally
-- You can suggest changes with a pull request or something

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- Проверяем, находимся ли мы в Mad City
local isMadCity = game.PlaceId == 9128235071 or game.PlaceId == 91282350711571

local espObjects = {}
local chamsObjects = {}
local chamsConnections = {}

local chamscolor = Color3.new(1,1,1)
local chamstransp = 0

local espDistance = 1000 -- Максимальная дистанция отрисовки
local espTeamCheck = true -- Показывать только врагов
local currentAimbotTarget = nil
local espEnabled = false
local espBoxes = true
local espHealthBars = true
local espHealthText = true
local espName = false
local espWeapon = false
local espCrime = false
local espChams = false
local espChamsThroughWalls = true

local generalColor = false

local espFill = false
local espFont = Drawing.Fonts.Monospace



-- Функция проверки, нужно ли отображать ESP для игрока
local function shouldShowESP(player)
    if not player or not player.Character then return false end
    
    -- Проверка team check
    if espTeamCheck then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer and localPlayer.Team and player.Team then
            
            -- Специальная проверка для Mad City
            if isMadCity then
                local localTeam = localPlayer.TeamColor
                local targetTeam = player.TeamColor
                
                if localTeam == BrickColor.new("Bright red") then
                    if targetTeam == BrickColor.new("Bright red") or 
                       targetTeam == BrickColor.new("Bright orange") or 
                       targetTeam == BrickColor.new("Bright violet") then
                        return false
                    end
                
                elseif localTeam == BrickColor.new("Bright orange") then
                    if targetTeam == BrickColor.new("Bright red") or 
                       targetTeam == BrickColor.new("Bright orange") or 
                       targetTeam == BrickColor.new("Bright violet") then
                        return false
                    end
                
                elseif localTeam == BrickColor.new("Bright violet") then
                    if targetTeam == BrickColor.new("Bright red") or 
                       targetTeam == BrickColor.new("Bright orange") or 
                       targetTeam == BrickColor.new("Bright violet") then
                        return false
                    end
                
                elseif localTeam == BrickColor.new("Bright blue") then
                    if targetTeam == BrickColor.new("Bright yellow") or 
                       targetTeam == BrickColor.new("Bright blue") then
                        return false
                    elseif targetTeam == BrickColor.new("Bright orange") then
                        local character = player.Character
                        if not character or not (character:FindFirstChild("PrisonCrime") or character:FindFirstChild("HasCrime")) then
                            
                        end
                    end
                
                elseif localTeam == BrickColor.new("Bright yellow") then
                    if targetTeam == BrickColor.new("Bright yellow") or 
                       targetTeam == BrickColor.new("Bright blue") then
                        return false
                    elseif targetTeam == BrickColor.new("Bright orange") then
                        local character = player.Character
                        if not character or not (character:FindFirstChild("PrisonCrime") or character:FindFirstChild("HasCrime")) then
                            
                        end
                    end
                end
            else
                -- Обычная проверка для других игр
                if localPlayer.Team == player.Team then
                    return false -- Не показывать союзников
                end
            end
        end
    end
    
    -- Проверка дистанции
    local localChar = game.Players.LocalPlayer.Character
    local targetChar = player.Character
    if not localChar or not targetChar then return false end
    
    local humanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")
    local targetRootPart = targetChar:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart and targetRootPart then
        local distance = (humanoidRootPart.Position - targetRootPart.Position).Magnitude
        if distance > espDistance then
            return false -- Слишком далеко
        end
    end
    
    return true
end


local function createChams(player)
    if player == game.Players.LocalPlayer then return end
    if chamsObjects[player] then return end -- Уже созданы
    
    -- Проверяем нужно ли создавать чамсы
    if not shouldShowESP(player) then return end
    
    local function setupChams(character)
        if not character or not character:FindFirstChild("Humanoid") then return end
        
        -- Проверяем нужно ли создавать чамсы
        if not shouldShowESP(player) then
            if chamsObjects[player] then
                pcall(function()
                    chamsObjects[player]:Destroy()
                end)
                chamsObjects[player] = nil
            end
            return
        end
        
        -- Удаляем старые чамсы если есть
        if chamsObjects[player] then
            pcall(function()
                chamsObjects[player]:Destroy()
            end)
            chamsObjects[player] = nil
        end
        
        -- Создаем Highlight
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPChams"
        highlight.Adornee = character
        highlight.Parent = character
        
        -- Настройки
        highlight.FillColor = chamscolor
        highlight.FillTransparency = chamstransp
        highlight.OutlineColor = chamscolor
        highlight.OutlineTransparency = chamstransp
        
        if espChamsThroughWalls then
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        else
            highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        end
        
        chamsObjects[player] = highlight
        
        -- Соединение для удаления при смерти
        if not chamsConnections[player] then
            chamsConnections[player] = {}
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            table.insert(chamsConnections[player], humanoid.Died:Connect(function()
                if chamsObjects[player] then
                    pcall(function()
                        chamsObjects[player]:Destroy()
                    end)
                    chamsObjects[player] = nil
                end
            end))
        end
    end
    
    -- Если персонаж уже существует
    if player.Character then
        setupChams(player.Character)
    end
    
    -- Соединение для появления персонажа
    if not chamsConnections[player] then
        chamsConnections[player] = {}
    end
    
    table.insert(chamsConnections[player], player.CharacterAdded:Connect(function(character)
        task.wait(1) -- Ждем загрузки
        setupChams(character)
    end))
end

-- Функция обновления чамсов
local function updateChams(player)
    if not espChams or player == game.Players.LocalPlayer then 
        -- Если чамсы выключены, удаляем их
        if chamsObjects[player] then
            chamsObjects[player]:Destroy()
            chamsObjects[player] = nil
        end
        return 
    end
    
    -- Проверяем нужно ли отображать чамсы для этого игрока
    if not shouldShowESP(player) then
        if chamsObjects[player] then
            chamsObjects[player]:Destroy()
            chamsObjects[player] = nil
        end
        return
    end
    
    local character = player.Character
    if not character then 
        if chamsObjects[player] then
            chamsObjects[player]:Destroy()
            chamsObjects[player] = nil
        end
        return 
    end
    
    local highlight = chamsObjects[player] or character:FindFirstChild("ESPChams")
    
    if highlight then
        -- Обновляем цвет в зависимости от настроек
        if generalColor then
            highlight.FillColor = chamscolor
        else
            highlight.FillColor = chamscolor
        end
        
        highlight.FillTransparency = chamstransp
        highlight.OutlineTransparency = chamstransp
        
        -- Обновляем видимость сквозь стены
        if espChamsThroughWalls then
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        else
            highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        end
    else
        createChams(player)
    end
end

-- Функция включения/выключения чамсов
local function toggleChams(enabled)
    espChams = enabled
    
    if enabled then
        -- Включаем для всех игроков
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createChams(player)
            end
        end
    else
        -- Выключаем все чамсы
        for player, highlight in pairs(chamsObjects) do
            pcall(function()
                highlight:Destroy()
            end)
        end
        chamsObjects = {}
        
        -- Очищаем соединения
        for player, connections in pairs(chamsConnections) do
            for _, connection in ipairs(connections) do
                connection:Disconnect()
            end
        end
        chamsConnections = {}
    end
end

-- Функция удаления чамсов игрока
local function removeChams(player)
    if chamsObjects[player] then
        pcall(function()
            chamsObjects[player]:Destroy()
        end)
        chamsObjects[player] = nil
    end
    
    if chamsConnections[player] then
        for _, connection in ipairs(chamsConnections[player]) do
            connection:Disconnect()
        end
        chamsConnections[player] = nil
    end
end



local function getTeamColor(player)
    if not player or not player.TeamColor then
        return Options.boxcolor.Value -- Белый по умолчанию
    end
    
    local teamColor = player.TeamColor
    
    if teamColor == BrickColor.new("Bright red") then
        return Options.crimsboxcolor.Value -- Красный
    elseif teamColor == BrickColor.new("Bright blue") then
        return Options.policesboxcolor.Value -- Синий
    elseif teamColor == BrickColor.new("Bright yellow") then
        return Options.heroboxcolor.Value -- Желтый
    elseif teamColor == BrickColor.new("Bright orange") then
        return Options.prisonersboxcolor.Value -- Оранжевый
    elseif teamColor == BrickColor.new("Bright violet") then
        return Options.villainboxcolor.Value
    else
        return Options.boxcolor.Value -- Белый для неизвестных команд
    end
end

local function createESP(player)
    if player == game.Players.LocalPlayer then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Fill = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        InnerOutline = Drawing.new("Square"),

        HealthBarOutline = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),

        Name = Drawing.new("Text"),
        Weapon = Drawing.new("Text"),
        HealthText = Drawing.new("Text"),
        CrimePrison = Drawing.new("Text")
    }


    
    
    -- Настройка основного бокса
    esp.Box.Visible = false
    esp.Box.Filled = false
    esp.Box.Thickness = 1 -- Тонкая линия
    esp.Box.Transparency = 1
    
    -- Настройка обводки бокса
    esp.BoxOutline.Visible = false
    esp.BoxOutline.Filled = false
    esp.BoxOutline.Thickness = 1
    esp.BoxOutline.Color = Color3.fromRGB(0, 0, 0) -- Черная обводка
    esp.BoxOutline.Transparency = 1

    esp.InnerOutline.Visible = false
    esp.InnerOutline.Filled = false
    esp.InnerOutline.Thickness = 1
    esp.InnerOutline.Color = Color3.fromRGB(0, 0, 0) -- Черная обводка
    esp.InnerOutline.Transparency = 1

    esp.Fill.Visible = false
    esp.Fill.Filled = true
    esp.Fill.Thickness = 1
    esp.Fill.Transparency = 0.5
    
    -- Настройка контура полоски здоровья
    esp.HealthBarOutline.Visible = false
    esp.HealthBarOutline.Filled = true
    esp.HealthBarOutline.Thickness = 1
    esp.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBarOutline.Transparency = 1

    -- Настройка полоски здоровья
    esp.HealthBar.Visible = false
    esp.HealthBar.Filled = true
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Transparency = 1
    
    


    esp.Name.Visible = false
    esp.Name.Text = player.Name
    esp.Name.Color = Color3.new(1, 1, 1)
    esp.Name.Size = 13
    esp.Name.Font = espFont
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.OutlineColor = Color3.new(0, 0, 0)
    esp.Name.Transparency = 1

    esp.Weapon.Visible = false
    esp.Weapon.Text = "Hands"
    esp.Weapon.Color = Color3.new(1, 1, 1)
    esp.Weapon.Size = 13
    esp.Weapon.Font = espFont
    esp.Weapon.Center = true
    esp.Weapon.Outline = true
    esp.Weapon.OutlineColor = Color3.new(0, 0, 0)
    esp.Weapon.Transparency = 1

    esp.HealthText.Visible = false
    esp.HealthText.Text = 0
    esp.HealthText.Color = Color3.new(1, 1, 1)
    esp.HealthText.Size = 13
    esp.HealthText.Font = espFont
    esp.HealthText.Center = false
    esp.HealthText.Outline = true
    esp.HealthText.OutlineColor = Color3.new(0, 0, 0)
    esp.HealthText.Transparency = 1

    esp.CrimePrison.Visible = false
    esp.CrimePrison.Text = "CRIME"
    esp.CrimePrison.Color = Color3.new(1, 0, 0)
    esp.CrimePrison.Size = 16
    esp.CrimePrison.Font = espFont
    esp.CrimePrison.Center = false
    esp.CrimePrison.Outline = true
    esp.CrimePrison.OutlineColor = Color3.new(0, 0, 0)
    esp.CrimePrison.Transparency = 1
    
    espObjects[player] = esp
end

local function calculateTextSize(distance, baseSize)
    -- Чем дальше - тем меньше текст
    local maxDistance = 100 -- Максимальное расстояние для уменьшения
    local minSize = 8 -- Минимальный размер текста
    
    if distance > maxDistance then
        return minSize
    end
    
    -- Плавное уменьшение размера
    local size = baseSize * (1 - (distance / maxDistance) * 0.6)
    return math.max(size, minSize)
end




local function updateESP(player, esp)

    if not shouldShowESP(player) then
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.Fill.Visible = false
        esp.InnerOutline.Visible = false
        esp.HealthBarOutline.Visible = false
        esp.HealthBar.Visible = false
        esp.Weapon.Visible = false
        esp.Name.Visible = false
        esp.HealthText.Visible = false
        esp.CrimePrison.Visible = false
        return
    end

    if not espEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.Fill.Visible = false
        esp.InnerOutline.Visible = false
        esp.HealthBarOutline.Visible = false
        esp.HealthBar.Visible = false
        esp.Weapon.Visible = false
        esp.Name.Visible = false
        esp.HealthText.Visible = false
        esp.CrimePrison.Visible = false
        return
    end
    
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not rootPart or not head or humanoid.Health <= 0 then
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.Fill.Visible = false
        esp.InnerOutline.Visible = false
        esp.HealthBarOutline.Visible = false
        esp.HealthBar.Visible = false
        
        esp.Name.Visible = false
        esp.Weapon.Visible = false
        esp.HealthText.Visible = false
        esp.CrimePrison.Visible = false
        return
    end
    
    local camera = workspace.CurrentCamera
    
    -- Получаем позиции головы и ног для точного размера во весь рост
    local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y/2, 0))
    local rootPos, rootOnScreen = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, rootPart.Size.Y/2 + 2, 0))
    
    if not headOnScreen or not rootOnScreen then
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.Fill.Visible = false
        esp.InnerOutline.Visible = false
        
        esp.HealthBarOutline.Visible = false
        esp.HealthBar.Visible = false

        esp.Name.Visible = false
        esp.Weapon.Visible = false
        esp.CrimePrison.Visible = false
        esp.HealthText.Visible = false
        return
    end
    
    -- Получение цвета команды
    
    local teamColor
    if player == currentAimbotTarget then
        -- ЗЕЛЕНЫЙ цвет для цели аимбота
        teamColor = Color3.fromRGB(0, 255, 0)
    else
        -- Обычный цвет по логике команды
        teamColor = getTeamColor(player)
        if generalColor then
            teamColor = Options.boxcolor.Value
        end
    end
    -- Вычисляем размер бокса на основе реальных размеров персонажа во весь рост
    local boxHeight = math.abs(rootPos.Y - headPos.Y)
    local boxWidth = boxHeight * 0.5 -- Узкий бокс для тонкого вида
    
    -- Обновление бокса
    if espBoxes then
        -- Обводка бокса (черная, чуть больше основного)
        esp.BoxOutline.Size = Vector2.new(boxWidth + 2, boxHeight + 2)
        esp.BoxOutline.Position = Vector2.new(headPos.X - (boxWidth + 2) / 2, headPos.Y - 1)
        esp.BoxOutline.Visible = true
        esp.InnerOutline.Size = Vector2.new(boxWidth - 2, boxHeight - 2)
        esp.InnerOutline.Position = Vector2.new(headPos.X - (boxWidth - 2) / 2, headPos.Y + 1)
        esp.InnerOutline.Visible = true



        



        -- Основной бокс (цвет команды)
        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
        esp.Box.Position = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
        esp.Box.Color = teamColor
        esp.Box.Visible = true
        if espFill then
            esp.Fill.Size = Vector2.new(boxWidth, boxHeight)
            esp.Fill.Position = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
            
            esp.Fill.Transparency = Options.filltransp.Value
            esp.Fill.Visible = true
            if espFillgrad then
                esp.Fill.Color = teamColor
            else
                esp.Fill.Color = teamColor
            end
        end
    else
        esp.Box.Visible = false
        esp.Fill.Visible = false
        esp.InnerOutline.Visible = false
        esp.BoxOutline.Visible = false
        
    end
    
    -- Обновление полоски здоровья
    if espHealthBars then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        local barHeight = boxHeight * healthPercent
        local barWidth = 1 -- Очень тонкая полоска
        
        -- Позиция полоски здоровья (слева от бокса с небольшим отступом)
        local barX = headPos.X - (boxWidth / 2) - 6
        local barY = headPos.Y + (boxHeight * (1 - healthPercent))
        
        -- Цвет полоски здоровья (от красного к зеленому)
        local healthColor
        if healthPercent > 0.5 then
            healthColor = Color3.fromRGB(255 * (2 * (1 - healthPercent)), 255, 0)
        else
            healthColor = Color3.fromRGB(255, 255 * (2 * healthPercent), 0)
        end
        

        -- Сама полоска здоровья
        esp.HealthBar.Size = Vector2.new(barWidth, barHeight)
        esp.HealthBar.Position = Vector2.new(barX, barY)
        esp.HealthBar.Color = healthColor
        esp.HealthBar.Visible = true
        -- Контур полоски здоровья (обводка с обеих сторон)
        esp.HealthBarOutline.Size = Vector2.new(barWidth + 2, boxHeight + 2)
        esp.HealthBarOutline.Position = Vector2.new(barX - 1, headPos.Y - 1)
        esp.HealthBarOutline.Visible = true
        
        
    else
        esp.HealthBar.Visible = false
        esp.HealthBarOutline.Visible = false
    end

    if espName then
        esp.Name.Text = player.Name
        esp.Name.Size = 12
        esp.Name.Color = Options.textboxcolor.Value
        esp.Name.Position = Vector2.new(headPos.X, headPos.Y - 16) -- Над головой
        esp.Name.Visible = true
    else
        esp.Name.Visible = false
    end

    if espWeapon then
        currentweapon = "Hands"
        weapon = character:FindFirstChildOfClass("Tool")
        if weapon then
            currentweapon = weapon.Name
        else
            currentweapon = "Hands"
        end

        esp.Weapon.Text = currentweapon
        esp.Weapon.Size = 12
        esp.Weapon.Color = Options.textboxcolor.Value
        esp.Weapon.Position = Vector2.new(headPos.X, rootPos.Y)
        esp.Weapon.Visible = true
    else
        esp.Weapon.Visible = false
        
    end

    if espHealthText then
        currenthealth = humanoid.Health
        local localPlayer = game.Players.LocalPlayer
        local localChar = localPlayer.Character
        local distance = 0
        
        if localChar and localChar:FindFirstChild("HumanoidRootPart") and rootPart then
            distance = (localChar.HumanoidRootPart.Position - rootPart.Position).Magnitude
        end
        
        -- Размер текста based на расстоянии
        local textSize = calculateTextSize(distance, 14)

        esp.HealthText.Text = currenthealth .. " HP"
        esp.HealthText.Size = textSize
        esp.HealthText.Color = Color3.new(0,1,0)
        local healthTextX = headPos.X + (boxWidth / 2) + 5
        esp.HealthText.Position = Vector2.new(healthTextX, headPos.Y)
        esp.HealthText.Visible = true
        
    else
        esp.HealthText.Visible = false
    end

    if espChams and espEnabled then
        updateChams(player)
    end

    if espCrime and espEnabled then
        local localPlayer = game.Players.LocalPlayer
        local localChar = localPlayer.Character
        local distance = 0
        
        if localChar and localChar:FindFirstChild("HumanoidRootPart") and rootPart then
            distance = (localChar.HumanoidRootPart.Position - rootPart.Position).Magnitude
        end
        local character = player.Character
        local tteam = player.TeamColor
        if teamColor == BrickColor.new("Bright orange") and character:FindFirstChild("PrisonCrime") or character:FindFirstChild("RestrictedArea") then
            local crimeTextX = headPos.X + (boxWidth / 2) + 5
            local textSize = calculateTextSize(distance, 14)
            esp.CrimePrison.size = textSize
            esp.CrimePrison.Position = Vector2.new(crimeTextX, headPos.Y + 10)
            esp.CrimePrison.Visible = true
        else 
            esp.CrimePrison.Visible = false
        end
    else
        esp.CrimePrison.Visible = false
    end


end

-- Функция удаления ESP
local function removeESP(player)
    if espObjects[player] then
        for _, drawing in pairs(espObjects[player]) do
            drawing:Remove()
        end
        espObjects[player] = nil
    end
end

-- Создание ESP для существующих игроков
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        createESP(player)
        if espChams then
            createChams(player)
        end
    end
end



-- hitbox


-- Обработка новых игроков
game.Players.PlayerAdded:Connect(function(player)
    createESP(player)
    if espChams then
        createChams(player)
    end
    -- Обработка выхода игрока
    table.insert(chamsConnections[player] or {}, player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game.Players) then
            removeESP(player)
            removeChams(player)
        end
    end))
end)

-- Обработка ухода игроков
game.Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    removeChams(player)
end)

-- Обработка респавна персонажей
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Небольшая задержка для загрузки персонажа
        if espObjects[player] then
            removeESP(player)
            createESP(player)
        end
        if chamsObjects[player] then
            removeChams(player)
            createChams(player)
        end
    end)
end)

local lastUpdate = 0
local updateInterval = 0.01 -- Обновляем каждые 0.1 секунды для оптимизации

local RenderSteppedConnection
RenderSteppedConnection = game:GetService("RunService").RenderStepped:Connect(function()
    local currentTime = tick()
    
    -- Оптимизация: обновляем не каждый кадр, а с интервалом
    if currentTime - lastUpdate < updateInterval then
        return
    end
    lastUpdate = currentTime
    
    if not espEnabled then 
        -- Отключаем ESP
        for player, esp in pairs(espObjects) do
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.Fill.Visible = false
            esp.InnerOutline.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
            esp.Name.Visible = false
            esp.Weapon.Visible = false
            esp.HealthText.Visible = false
        end
        
        -- Отключаем чамсы если они включены
        if espChams then
            toggleChams(false)
        end
        return 
    end
    
    -- Обновляем ESP
    for player, esp in pairs(espObjects) do
        if player and player.Parent then
            updateESP(player, esp)
            
            -- Обновляем чамсы если они включены
            if espChams then
                updateChams(player)
            end
        else
            removeESP(player)
            removeChams(player)
        end
    end
end)






-- Функция для принудительного обновления всех ESP
local function updateAllESP()
    for player, esp in pairs(espObjects) do
        if player and player.Parent then
            updateESP(player, esp)
        end
    end
    
    for player, highlight in pairs(chamsObjects) do
        if highlight and highlight.Parent then
            updateChams(player)
        end
    end
end





local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'doraware | Madcity',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Visuals'),
    Combat = Window:AddTab('Combat'),
    Exploits = Window:AddTab('Exploits'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local pegb = Tabs.Main:AddLeftGroupbox('ESP')

-- We can also get our Main tab via the following code:
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox('Groupbox')

-- Tabboxes are a tiny bit different, but here's a basic example:
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on left side

local Tab1 = TabBox:AddTab('Tab 1')
local Tab2 = TabBox:AddTab('Tab 2')

-- You can now call AddToggle, etc on the tabs you added to the Tabbox
]]

-- Groupbox:AddToggle
-- Arguments: Index, Options
pegb:AddToggle('playeresp', {
    Text = 'Enable ESP',
    Default = false, -- Default value (true / false)
    
    Callback = function(Value)
        espEnabled = Value
        print(espEnabled)
        if not Value then
            for player, esp in pairs(espObjects) do
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.Fill.Visible = false
            esp.InnerOutline.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
            esp.Name.Visible = false
            esp.Weapon.Visible = false
            esp.HealthText.Visible = false
            esp.CrimePrison.Visible = false
            end
            toggleChams(false)
        else
            if espChams then
                toggleChams(true)
            end
        end
    end
})

pegb:AddDivider()


pegb:AddToggle('filledesp', {
    Text = 'Filled',
    Default = false,

    Callback = function(Value)
        espFill = Value
        if not Value then
                for player, esp in pairs(espObjects) do
                esp.Fill.Visible = false
            end
        end
    end
})

pegb:AddSlider('filltransp', {
    Text = 'Fill Transparency',
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        print('transp is', Value)
    end
})

local pedd = pegb:AddDropdown('pedd', {
    -- Default is the numeric index (e.g. "This" would be 1 since it if first in the values list)
    -- Default also accepts a string as well

    -- Currently you can not set multiple values with a dropdown

    Values = { 'Box', 'Name', 'Healthbar', 'HealthText', 'Weapon', 'CrimeInfo' },
    Default = { 'Box', 'Healthbar', 'HealthText' },
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = 'Settings',
    
    Callback = function(Value)
        -- Обновляем настройки на основе выбранных опций
        espBoxes = Value.Box or false
        espName = Value.Name or false
        espHealthBars = Value.Healthbar or false
        espWeapon = Value.Weapon or false
        espHealthText = Value.HealthText or false
        espCrime = Value.CrimeInfo or false
    
        print(string.format("ESP Settings: Box=%s, Name=%s, Healthbar=%s, Weapon=%s", 
            tostring(espBoxes), tostring(espName), tostring(espHealthBars), tostring(espWeapon)))
        end
})

pegb:AddDivider()

pegb:AddLabel('Colors\n', true)





pegb:AddLabel('Box General'):AddColorPicker('boxcolor', {
    Default = Color3.new(1, 1, 1), -- whiteen
    Title = 'General color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('general color is', Value)
    end
})

pegb:AddLabel('Criminals'):AddColorPicker('crimsboxcolor', {
    Default = Color3.new(1, 0, 0), -- Bright orange
    Title = 'Criminals color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('prisoner color is', Value)
    end
})

pegb:AddLabel('Prisoners'):AddColorPicker('prisonersboxcolor', {
    Default = Color3.new(0.85, 0.52, 0.26), -- Bright orange
    Title = 'Prisoners color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('prisoner color is', Value)
    end
})

pegb:AddLabel('Police'):AddColorPicker('policesboxcolor', {
    Default = Color3.new(0.051, 0.411, 0.674), -- Bright blue
    Title = 'Police color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('police color is', Value)
    end
})

pegb:AddLabel('Heroes'):AddColorPicker('heroboxcolor', {
    Default = Color3.new(0.97, 0.80, 0.19), -- Bright blue
    Title = 'Hero color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('police color is', Value)
    end
})

pegb:AddLabel('Villains'):AddColorPicker('villainboxcolor', {
    Default = Color3.new(0.82, 0.25, 1), -- Bright blue
    Title = 'Villain color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('police color is', Value)
    end
})
pegb:AddLabel('')
pegb:AddLabel('Text'):AddColorPicker('textboxcolor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Text color',
    Transparency = 0,

    Callback = function(Value)
        print('text color is', Value)
    end
})
















local esrgb = Tabs.Main:AddRightGroupbox('ESP Settings')


esrgb:AddToggle('generalcolor', {
    Text = 'General ESP Color',
    Default = false,

    Callback = function(Value)
        generalColor = Value
    end
})


esrgb:AddSlider('espdistance', {
    Text = 'ESP Distance',
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        espDistance = Value
        updateAllESP() 
    end
})

-- Добавляем team check
esrgb:AddToggle('teamcheck', {
    Text = 'Team Check (Enemies Only)',
    Default = true,
    Callback = function(Value)
        espTeamCheck = Value
        updateAllESP() 
    end
})





local clgb = Tabs.Main:AddLeftGroupbox('Chams')

clgb:AddToggle('chamstoggle', {
    Text = 'Enable Chams',
    Default = false,

    Callback = function(Value)
        espChams = Value
        toggleChams(Value)
    end
})

clgb:AddToggle('thrghwallschams', {
    Text = 'Through walls',
    Default = true,

    Callback = function(Value)
        espChamsThroughWalls = Value
        -- Обновляем все существующие чамсы
        for player, highlight in pairs(chamsObjects) do
            if highlight and highlight.Parent then
                if Value then
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                end
            end
        end
    end
    
})

clgb:AddSlider('chamstransp', {
    Text = 'Transparency',
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        print('transp chams is', Value)
    end
})

clgb:AddLabel('Color'):AddColorPicker('chamscolor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Chams color',
    Transparency = nil,

    Callback = function(Value)
        print('chams color is', Value)
    end
})










-- Хранилище ESP объектов


-- Функция получения цвета команды









-- combat
local aimbotEnabled = false
local aimbotWeaponCheck = true 
local aimbotDistance = 1000
local aimbotFOV = 100
local aimbotShowFOV = false
local aimbotAtHead = false
local aimbotKey = Enum.UserInputType.MouseButton2
local isAiming = false
local fovCircle = nil
local silentAimEnabled = false
local silentAimHitChance = 100


local hitboxExpanderEnabled = false
local hitboxSizeMultiplier = 1.5
local originalHitboxSizes = {}
local hitboxParts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}

local aimbotGroup = Tabs.Combat:AddLeftGroupbox('Aimbot')

-- Функция создания FOV круга
local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = aimbotShowFOV and aimbotEnabled
    fovCircle.Radius = aimbotFOV
    fovCircle.Color = Color3.new(1, 1, 1)
    fovCircle.Thickness = 2
    fovCircle.Filled = false
    fovCircle.Transparency = 1
    fovCircle.Position = Vector2.new(
        workspace.CurrentCamera.ViewportSize.X / 2,
        workspace.CurrentCamera.ViewportSize.Y / 2
    )
    
    return fovCircle
end

-- Функция проверки валидности цели для аимбота
local function isValidAimbotTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return false end
    
    -- Проверка команды (используем ту же логику что и в ESP)
    if espTeamCheck then
        if isMadCity then
            local localTeam = localPlayer.TeamColor
            local targetTeam = targetPlayer.TeamColor
            
            if localTeam == BrickColor.new("Bright red") then
                if not (targetTeam ~= BrickColor.new("Bright red") and 
                       targetTeam ~= BrickColor.new("Bright orange") and 
                       targetTeam ~= BrickColor.new("Bright violet")) then
                    return false
                end
            
            elseif localTeam == BrickColor.new("Bright orange") then
                if not (targetTeam ~= BrickColor.new("Bright red") and 
                       targetTeam ~= BrickColor.new("Bright orange") and 
                       targetTeam ~= BrickColor.new("Bright violet")) then
                    return false
                end
            
            elseif localTeam == BrickColor.new("Bright violet") then
                if not (targetTeam ~= BrickColor.new("Bright red") and 
                       targetTeam ~= BrickColor.new("Bright orange") and 
                       targetTeam ~= BrickColor.new("Bright violet")) then
                    return false
                end
            
            elseif localTeam == BrickColor.new("Bright blue") then
                if targetTeam == BrickColor.new("Bright yellow") then
                    return falsew
                elseif targetTeam == BrickColor.new("Bright blue") then
                    return false -- Не атакуем свою команду
                elseif targetTeam == BrickColor.new("Bright orange") then
                    -- Для Bright Orange: проверяем наличие RestrictedArea или PrisonCrime
                    local character = targetPlayer.Character
                    if not character then return false end
                    
                    -- Если НЕТ RestrictedArea И НЕТ PrisonCrime - пропускаем
                    if not character:FindFirstChild("RestrictedArea") and not character:FindFirstChild("PrisonCrime") then
                        return false
                    end
                else
                    return true -- Не атакуем другие команды
                end
            
            elseif localTeam == BrickColor.new("Bright yellow") then
                if targetTeam == BrickColor.new("Bright blue") then
                    return false
                elseif targetTeam == BrickColor.new("Bright yellow") then
                    return false -- Не атакуем свою команду
                elseif targetTeam == BrickColor.new("Bright orange") then
                    -- Для Bright Orange: проверяем наличие RestrictedArea или PrisonCrime
                    local character = targetPlayer.Character
                    if not character then return false end
                    
                    -- Если НЕТ RestrictedArea И НЕТ PrisonCrime - пропускаем
                    if not character:FindFirstChild("RestrictedArea") and not character:FindFirstChild("PrisonCrime") then
                        return false
                    end
                else
                    return true
                end
            end
        else
            -- Обычная проверка для других игр
            if localPlayer.Team and targetPlayer.Team and localPlayer.Team == targetPlayer.Team then
                return false
            end
        end
    end
    
    -- Проверка дистанции
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return false end
    
    local distance = (localRoot.Position - targetRoot.Position).Magnitude
    if distance > aimbotDistance then
        return false
    end
    
    -- Проверка видимости
    local camera = workspace.CurrentCamera
    local screenPos, onScreen = camera:WorldToViewportPoint(targetRoot.Position)
    if not onScreen then return false end
    
    -- Проверка FOV
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
    local distanceToCenter = (screenPoint - screenCenter).Magnitude
    
    if distanceToCenter > aimbotFOV then
        return false
    end
    
    -- Проверка здоровья и состояния
    local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    
    if targetPlayer.Character:FindFirstChild("Downed") then
        return false
    end
    
    return true
end



-- Функция поиска лучшей цели для аимбота
local function findBestTarget()
    if not aimbotEnabled and not silentAimEnabled then return nil, nil end
    
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return nil, nil end
    
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil, nil end
    
    local camera = workspace.CurrentCamera
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    local bestTarget = nil
    local bestTargetPart = nil
    local closestDistanceToCenter = math.huge
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and isValidAimbotTarget(player) then
            local character = player.Character
            local aimPart = nil
            
            -- Выбираем часть тела для прицеливания
            if (aimbotAtHead or silentAimEnabled) and character:FindFirstChild("Head") then
                aimPart = character.Head
            else
                aimPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
            end
            
            if aimPart then
                local screenPos = camera:WorldToViewportPoint(aimPart.Position)
                local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                local distanceToCenter = (screenPoint - screenCenter).Magnitude
                
                if distanceToCenter < closestDistanceToCenter then
                    closestDistanceToCenter = distanceToCenter
                    bestTarget = player
                    bestTargetPart = aimPart
                end
            end
        end
    end
    
    -- ОБНОВЛЯЕМ ТЕКУЩУЮ ЦЕЛЬ АИМБОТА
    currentAimbotTarget = bestTarget
    
    return bestTarget, bestTargetPart
end

local function clearAimbotTarget()
    currentAimbotTarget = nil
end

-- Обработка ввода для аимбота
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input)
    if input.UserInputType == aimbotKey and aimbotEnabled then
        isAiming = true
        
        -- Запускаем цикл аимбота
        local aimbotConnection
        aimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not isAiming or not aimbotEnabled then
                aimbotConnection:Disconnect()
                return
            end
            if aimbotWeaponCheck then
                if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    local target, aimPart = findBestTarget()
                    if target and aimPart then
                        local camera = workspace.CurrentCamera
                        camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)
                    end
                end
                
            else
                local target, aimPart = findBestTarget()
                if target and aimPart then
                    local camera = workspace.CurrentCamera
                    camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)
                end
            end
        end)
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == aimbotKey then
        isAiming = false
        clearAimbotTarget() -- Очищаем цель при отпускании кнопки
    end
end)

-- Обновление позиции FOV круга
local function updateFOVCircle()
    if fovCircle and aimbotShowFOV and aimbotEnabled then
        fovCircle.Position = Vector2.new(
            workspace.CurrentCamera.ViewportSize.X / 2,
            workspace.CurrentCamera.ViewportSize.Y / 2
        )
    end
end

-- Цикл обновления FOV круга
game:GetService("RunService").RenderStepped:Connect(function()
    updateFOVCircle()
end)

-- Элементы UI
aimbotGroup:AddToggle('aimbotenable', {
    Text = 'Enable Aimbot',
    Default = false,
    Callback = function(Value)
        aimbotEnabled = Value
        if not Value then
            clearAimbotTarget()
        end
        if not Value and fovCircle then
            fovCircle.Visible = false
        elseif Value and aimbotShowFOV then
            createFOVCircle()
        end
    end
}):AddKeyPicker('aimbotenkb', { Default = 'LeftAlt', NoUI = false, Text = 'Aimbot', SyncToggleState = true, Mode = 'Toggle' })



aimbotGroup:AddSlider('aimbotdistance', {
    Text = 'Aimbot Distance',
    Default = 1000,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        aimbotDistance = Value
    end
})

aimbotGroup:AddSlider('aimbotfov', {
    Text = 'FOV Radius',
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        aimbotFOV = Value
        if fovCircle then
            fovCircle.Radius = Value
        end
    end
})

aimbotGroup:AddToggle('aimbotshowfov', {
    Text = 'Show FOV Circle',
    Default = false,
    Callback = function(Value)
        aimbotShowFOV = Value
        if Value and aimbotEnabled then
            createFOVCircle()
        elseif fovCircle then
            fovCircle.Visible = false
        end
    end
})

aimbotGroup:AddToggle('aimbothead', {
    Text = 'Aim at Head',
    Default = false,
    Callback = function(Value)
        aimbotAtHead = Value
    end
})

aimbotGroup:AddToggle('aimbotweaponcheck', {
    Text = 'Weapon Check',
    Default = true,
    Callback = function(Value)
        aimbotWeaponCheck = Value
    end
})

aimbotGroup:AddDropdown('aimbotkey', {
    Values = {'MouseButton2', 'LeftShift', 'LeftControl', 'Q', 'E', 'F'},
    Default = 'MouseButton2',
    Text = 'Aimbot Key',
    Callback = function(Value)
        aimbotKey = Enum.UserInputType[Value]
    end
})



local hitboxGroup = Tabs.Combat:AddLeftGroupbox('Hitbox Expander')



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local hitboxExpanderEnabled = false
local hitboxSize = 5
local originalSizes = {}
local hitboxConnections = {}

-- Функция для изменения размера хитбокса
local function updateHitboxSize(character, size)
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if head then
        -- Сохраняем оригинальный размер, если еще не сохранили
        if not originalSizes[character] then
            originalSizes[character] = head.Size
        end
        
        -- Устанавливаем новый размер
        head.Size = Vector3.new(size, size, size)
    end
end

-- Функция для восстановления оригинального размера
local function restoreOriginalSize(character)
    if not character then return end
    
    if originalSizes[character] then
        local head = character:FindFirstChild("Head")
        if head then
            head.Size = originalSizes[character]
        end
        originalSizes[character] = nil
    end
end

-- Функция для обработки появления игрока
local function onPlayerAdded(player)
    if player == Players.LocalPlayer then return end
    
    local function onCharacterAdded(character)
        if hitboxExpanderEnabled then
            updateHitboxSize(character, hitboxSize)
        end
        
        -- Отслеживаем удаление персонажа
        hitboxConnections[character] = character.AncestryChanged:Connect(function()
            if not character:IsDescendantOf(workspace) then
                restoreOriginalSize(character)
                if hitboxConnections[character] then
                    hitboxConnections[character]:Disconnect()
                    hitboxConnections[character] = nil
                end
            end
        end)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    
    -- Обрабатываем существующий персонаж
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Функция для обработки выхода игрока
local function onPlayerRemoving(player)
    if player.Character then
        restoreOriginalSize(player.Character)
    end
end

-- Обработка существующих игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        onPlayerAdded(player)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)





hitboxGroup:AddToggle('hitboxexpander', {
    Text = 'Enable Hitbox Expander',
    Default = false,
    Callback = function(Value)
        hitboxExpanderEnabled = Value
        
        if Value then
            -- Включаем: устанавливаем размеры всем игрокам
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character then
                    updateHitboxSize(player.Character, hitboxSize)
                end
            end
        else
            -- Выключаем: восстанавливаем оригинальные размеры
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    restoreOriginalSize(player.Character)
                end
            end
            -- Очищаем таблицу оригинальных размеров
            originalSizes = {}
        end
    end
}):AddKeyPicker('hitboxkey', { Default = 'X', NoUI = false, Text = 'Hitbox Expand', SyncToggleState = true, Mode = 'Toggle' })


hitboxGroup:AddSlider('hitboxsize', {
    Text = 'Hitbox Size',
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        hitboxSize = Value
        if hitboxExpanderEnabled then
            -- Обновляем размеры всем игрокам при изменении слайдера
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character then
                    updateHitboxSize(player.Character, Value)
                end
            end
        end
    end
})

hitboxGroup:AddLabel('Makes head hitboxes bigger for easy aiming')
hitboxGroup:AddLabel('Works on all enemies')




local explgroup = Tabs.Exploits:AddLeftGroupbox('Teleport to Player')
local selectedplayer = ""
explgroup:AddDropdown('MyPlayerDropdown', {
    SpecialType = 'Player',
    Text = 'Select Player',

    Callback = function(Value)
        print('player changed to', Value)
        selectedplayer = Value
    end
})

local tpbutton = explgroup:AddButton({
    Text = 'Teleport',
    Func = function()
        if selectedplayer ~= nil then
            local CFrameEnd = workspace:FindFirstChild(selectedplayer).Head.CFrame
            local Time = 2
            local tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
            tween:Play()
            tween.Completed:Wait()
        end
    end,
    DoubleClick = false,
    Tooltip = 'double click to teleport'
})

local expl2group = Tabs.Exploits:AddLeftGroupbox('Dupe damage x2')
local selectedweapon = ""

expl2group:AddInput('weaponname', {
    Default = '',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter

    Text = '',
    Tooltip = 'Weapon name', -- Information shown when you hover over the textbox

    Placeholder = 'AK47, Pistol, Deagle, etc.', -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(Value)
        print('weapon selected -', Value)
        selectedweapon = Value
    end
})

local plr = game.Players.LocalPlayer
local bck = plr:WaitForChild("Backpack")

local dupebutton = expl2group:AddButton({
    Text = 'Dupe damage x2',
    Func = function()
        if selectedweapon ~= nil then
            if game.Players.LocalPlayer.Backpack:FindFirstChild(selectedweapon) then
                
                local dupe = bck[selectedweapon]:FindFirstChildOfClass("LocalScript"):Clone()
                dupe.Parent = bck[selectedweapon]
            elseif plr.Character:FindFirstChild(selectedweapon) then
                local dupe = plr.Character[selectedweapon]:FindFirstChildOfClass("LocalScript"):Clone()
                dupe.Parent = plr.Character[selectedweapon]
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Dupes dmg'
})


local expl3group = Tabs.Exploits:AddLeftGroupbox('Pickpocket')

local ppbutton = expl3group:AddButton({
    Text = 'Fire Pickpocket!',
    Func = function()
        for i,v in pairs(game:GetService("Players"):GetChildren()) do
            if v.ClassName == "Player" then
                wait(0.1)
                game:GetService("ReplicatedStorage").Event:FireServer("Pickpocket", v)
            end
	    end	
    end,
    DoubleClick = false,
    Tooltip = 'gives you keycard or pistol or something...'
})

-- Library functions
-- Sets the watermark visibility
Library:SetWatermarkVisibility(true)

-- Example of dynamically-updating watermark with common traits (fps and ping)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 144;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('doraware | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = false; -- todo: add a function for this







local function cleanupESP()
    -- Очистка Drawing объектов
    for player, esp in pairs(espObjects) do
        if esp then
            for name, drawing in pairs(esp) do
                if drawing and typeof(drawing) == "userdata" then
                    pcall(function()
                        drawing:Remove()
                    end)
                end
            end
        end
    end
    espObjects = {}

    -- Очистка Highlight объектов
    for player, highlight in pairs(chamsObjects) do
        if highlight then
            pcall(function()
                highlight:Destroy()
            end)
        end
    end
    chamsObjects = {}
    
    -- Очистка соединений
    for player, connections in pairs(chamsConnections) do
        for _, connection in ipairs(connections) do
            pcall(function()
                connection:Disconnect()
            end)
        end
    end
    chamsConnections = {}
end






Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    if RenderSteppedConnection then
            RenderSteppedConnection:Disconnect()
    end

    -- Полная очистка ESP
    for player, esp in pairs(espObjects) do
            esp.Box.Visible = false
            esp.BoxOutline.Visible = false
            esp.Fill.Visible = false
            esp.InnerOutline.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
            esp.Name.Visible = false
            esp.Weapon.Visible = false
            esp.HealthText.Visible = false
    end
    cleanupESP()

    if fovCircle then
        fovCircle:Remove()
        fovCircle = nil
    end

    if aimbotConnection then
        aimbotConnection:Disconnect()
    end
    
    
    aimbotEnabled = false
    isAiming = false

    print('Unloaded!')
    
    wait(1)

    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu
Library.KeybindFrame.Visible = true
-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
