Instance.new("Vector3Value",game.Players.LocalPlayer).Name = "btp"
Instance.new("StringValue",game.Players.LocalPlayer).Name = "maddancemoves"
game.Players.LocalPlayer.maddancemoves.Value = game.Players.LocalPlayer.Name




for i,v in pairs(workspace.ObjectSelection:GetDescendants()) do
	if v.Name == "Event" and v.Parent.Name == "Pullups" or  v.Name == "Event" and v.Parent.Name == "Treadmill" or v.Name == "Event" and v.Parent.Name == "BenchPress" then
		v:FireServer()
	end
end

_G.bored = false
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/refs/heads/main/ui%20libs2", true))()




-- Добавьте эту переменную в начало скрипта
local fovCircle = nil

-- Добавьте эту функцию для создания/обновления FOV круга
local function createOrUpdateFovCircle()
    if not fovCircle then
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = false
        fovCircle.Transparency = 1
        fovCircle.Color = Color3.fromRGB(255, 0, 0)
        fovCircle.Thickness = 2
        fovCircle.NumSides = 64
        fovCircle.Filled = false
    end
    
    fovCircle.Visible = _G.fovVisible and _G.myaim
    fovCircle.Radius = _G.fovRadius
    
    local camera = workspace.CurrentCamera
    if camera then
        fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    end
end

-- Запускаем обновление круга каждый кадр
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.fovVisible and _G.myaim then
        createOrUpdateFovCircle()
    elseif fovCircle then
        fovCircle.Visible = false
    end
end)





local example = library:CreateWindow({
  text = "Vehicle"
})
example:AddButton("Get In Nearest Vehicle", function(state)
getfenv().rat = nil
local distance = math.huge
for a,b in pairs(game:GetService("Workspace").ObjectSelection
:GetDescendants()) do
    if b.Name == "DriveSeat"  then
local Dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - b.Position).magnitude
if Dist < distance then
distance = Dist
getfenv().rat = b
end
end
end
getfenv().rat:Sit(game.Players.LocalPlayer.Character.Humanoid)
end)
example:AddButton("Fix Stuck in vehicle", function()
	game.Players.LocalPlayer.Character.Humanoid.Sit = false
 local TweenService = game:GetService("TweenService")
local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

local TweenValue = Instance.new("CFrameValue")
TweenValue.Value = game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name .."'s Vehicle"]:GetPrimaryPartCFrame()
			
TweenValue.Changed:Connect(function()
	game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name .."'s Vehicle"]:PivotTo(TweenValue.Value)
end)
			
local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(50,20,0)})
OnTween:Play()
 OnTween.Completed:Wait()
end)
example:AddButton("Get ur vehicle", function()
   local TweenService = game:GetService("TweenService")
local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

local TweenValue = Instance.new("CFrameValue")
TweenValue.Value = game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name .."'s Vehicle"]:GetPrimaryPartCFrame()
			
TweenValue.Changed:Connect(function()
	game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name .."'s Vehicle"]:PivotTo(TweenValue.Value)
end)
			
local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,10,0)})
OnTween:Play()
 OnTween.Completed:Wait()
wait(0.5)
game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name .."'s Vehicle"].DriveSeat.Disabled = false
wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name .."'s Vehicle"].DriveSeat.CFrame
end)
example:AddLabel("Get Any Vehicle",function()
end)
example:AddBox("Vehicle Name", function(object, focus)
  if focus then

      local vehicle = tostring(object.Text)
   local TweenService = game:GetService("TweenService")
local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

local TweenValue = Instance.new("CFrameValue")
TweenValue.Value = game:GetService("Workspace").ObjectSelection[vehicle]:GetPrimaryPartCFrame()
			
TweenValue.Changed:Connect(function()
	game:GetService("Workspace").ObjectSelection[vehicle]:PivotTo(TweenValue.Value)
end)
			
local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,10,0)})
OnTween:Play()
 OnTween.Completed:Wait()
wait(2)
game:GetService("Workspace").ObjectSelection[vehicle].DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
wait(2)
  end
end)
example:AddLabel("Get Any Vehicle v2",function()
end)
example:AddBox("Vehicle Name", function(object, focus)
  if focus then

      local vehicle = tostring(object.Text)
game.Players.LocalPlayer.btp.Value=game.Players.LocalPlayer.Character.HumanoidRootPart.Position
wait(0.5)

local CFrameEnd = game:GetService("Workspace").VehicleSpawns[vehicle].Pos.CFrame+Vector3.new(0,20,0)
local Time = 3 -- Time in seconds
local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
tween:Play()
tween.Completed:Wait()
 wait(3)
 local CFrameEnd = CFrame.new(game.Players.LocalPlayer.btp.Value)+Vector3.new(0,20,0)
local Time = 3 -- Time in seconds
local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
tween:Play()
tween.Completed:Wait()
 wait(1)
game:GetService("Workspace").ObjectSelection[vehicle].DriveSeat.Disabled = false
   local TweenService = game:GetService("TweenService")
local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

local TweenValue = Instance.new("CFrameValue")
TweenValue.Value = game:GetService("Workspace").ObjectSelection[vehicle]:GetPrimaryPartCFrame()
			
TweenValue.Changed:Connect(function()
	game:GetService("Workspace").ObjectSelection[vehicle]:PivotTo(TweenValue.Value)
end)
			
local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,10,0)})
OnTween:Play()
 OnTween.Completed:Wait()
wait(2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").ObjectSelection[vehicle].DriveSeat.CFrame
  end
end)
example:AddToggle("Vehicle Skin Changer", function(state)
	_G.skins = (state and true or false)
	local skin = 0
	while _G.skins == true do
	local ohString1 = "EquipItem"
	if skin == 171 then
		skin = 0
		else
		local lol = tostring("S"..skin)
	skin = skin+1
	
	game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer("EquipItem", lol)
	end
	end
	end)
	example:AddToggle("Inf Nitros", function(state)
	_G.Boost = (state and true or false)
	local gas = nil
	while _G.Boost == true do
		wait()
	 pcall(function()
		local function gasFind()
			local gas = nil
			for i,v in pairs(workspace.City:GetDescendants()) do
				if v.Name == "RefillGas" and v:findFirstChild("Trigger") then
			gas = v
			v.ModelStreamingMode = "Persistent"
			end
			end
			return gas
			end
		if gas == nil then
			print(gasFind())
			gas = gasFind().Trigger
		end
		firetouchinterest(game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"].PrimaryPart,gas,0)
		firetouchinterest(game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"].PrimaryPart,gas,1)
	end)
	end
	end)
local example = library:CreateWindow({
  text = "Mods"
})
example:AddButton("Missile Mod",function()
for i,v in pairs(getgc(true)) do
    if type(v) == "table" and rawget(v,"MissileLock") ~= nil then
        wait()
        v.MissileLock = 0
        v.MissileCooldown = 0
    end
end
end)
example:AddButton("Helicopter Mod",function()
if game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"]:FindFirstChild("HelicopterChassis") then
local r = require(game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"].Settings)
r.MaxSpeed = 1000
r.MaxAltitude = 5000
r.AscentSpeed = 10
r.DescentSpeed = 10
r.Acceleration = 10
r.Deceleration = 10
r.HorizontalRotationSpeed = 5
end
end)
example:AddLabel("Inf Gun Ammo",function()
end)
example:AddBox("Gun Name", function(object, focus)
if focus then
_G.gunz = tostring(object.Text) 
if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(_G.gunz) then
local localscript = getsenv(game:GetService("Players").LocalPlayer.Backpack[_G.gunz]:FindFirstChildOfClass("LocalScript"))
for i,v in next, localscript do
    if i == "Reload" then
for a,b in pairs(debug.getupvalues(v)) do
debug.setupvalue(v,2,math.huge)

end
end
end

elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild(_G.gunz) then
    local localscript = getsenv(game:GetService("Players").LocalPlayer.Character[_G.gunz]:FindFirstChildOfClass("LocalScript"))
for i,v in next, localscript do
    if i == "Reload" then
for a,b in pairs(debug.getupvalues(v)) do
debug.setupvalue(v,2,math.huge)

end
end
end
end
end
end)
example:AddLabel("Gun Stats Duper",function()
end)
example:AddBox("Gun Name", function(object, focus)
  if focus then
      _G.gun = tostring(object.Text)
      end
end)

example:AddLabel("DUPE AMOUNT",function()
end)
example:AddBox("Dupe amount", function(object, focus)
    if focus then
        local amount = tonumber(object.Text)
        if game.Players.LocalPlayer.Backpack:FindFirstChild(_G.gun) then
    for i = 1,amount do
   local dupe = game.Players.LocalPlayer.Backpack[_G.gun]:FindFirstChildOfClass("LocalScript"):Clone()
   dupe.Parent = game.Players.LocalPlayer.Backpack[_G.gun]
   end
    elseif game.Players.LocalPlayer.Character:FindFirstChild(_G.gun) then
    for i = 1,amount do
   local dupe = game.Players.LocalPlayer.Character[_G.gun]:FindFirstChildOfClass("LocalScript"):Clone()
   dupe.Parent = game.Players.LocalPlayer.Character[_G.gun]
    
end
    end
end
    end)


spawn(function()
	_G.rat = true
	while _G.rat do
		wait()
	if _G.fly == false then
		_G.run2:Disconnect()
		_G.run:Disconnect()
	end
	end
	end)
	local example = library:CreateWindow({
		text = "Stuff"
	  })
	  
	  	  example:AddToggle("Show Player Names", function(state)	
	  	      _G.showplayer = (state and true or false)
while _G.showplayer do
    wait()
	pcall(function()
    for i,v in pairs(game.Players:GetChildren()) do
        if v.ClassName == "Player" and v.Character:FindFirstChild("NameTag") then
            wait()
    v.Character.NameTag.MaxDistance = math.huge
        v.Character.NameTag.AlwaysOnTop = true
    end
    end
end)
end
end)
	  example:AddBox("Aimbot Distance", function(object, focus)
		if focus then
		   _G.distance = tonumber(object.Text)
		end
	end)
	  example:AddToggle("AimBot", function(state)	
		_G.myaim = (state and true or false)
local uis = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

-- Обновите функцию aim для правильного прицеливания в голову
function aim()
    local camera = workspace.CurrentCamera
    local localPlayer = game.Players.LocalPlayer
    local localTeam = localPlayer.TeamColor
    local localPos = localPlayer.Character.HumanoidRootPart.Position
    
    local bestTarget = nil
    local shortestDistance = _G.distance or math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local bestTargetPart = nil
    
    -- Функция проверки команды
    local function isValidTarget(targetPlayer)
        local targetTeam = targetPlayer.TeamColor
        
        if localTeam == BrickColor.new("Bright red") then
            return targetTeam ~= BrickColor.new("Bright red") and 
                   targetTeam ~= BrickColor.new("Bright orange") and 
                   targetTeam ~= BrickColor.new("Bright violet")
        
        elseif localTeam == BrickColor.new("Bright orange") then
            return targetTeam ~= BrickColor.new("Bright red") and 
                   targetTeam ~= BrickColor.new("Bright orange") and 
                   targetTeam ~= BrickColor.new("Bright violet")
        
        elseif localTeam == BrickColor.new("Bright violet") then
            return targetTeam ~= BrickColor.new("Bright red") and 
                   targetTeam ~= BrickColor.new("Bright orange") and 
                   targetTeam ~= BrickColor.new("Bright violet")
        
        elseif localTeam == BrickColor.new("Bright blue") then
            if targetTeam ~= BrickColor.new("Bright yellow") and 
               targetTeam ~= BrickColor.new("Bright blue") then
                return true
            elseif targetTeam == BrickColor.new("Bright orange") then
                local character = targetPlayer.Character
                return character and (character:FindFirstChild("PrisonCrime") or character:FindFirstChild("RestrictedArea"))
            end
            return false
        
        elseif localTeam == BrickColor.new("Bright yellow") then
            if targetTeam ~= BrickColor.new("Bright blue") and 
               targetTeam ~= BrickColor.new("Bright yellow") then
                return true
            elseif targetTeam == BrickColor.new("Bright orange") then
                local character = targetPlayer.Character
                return character and (character:FindFirstChild("PrisonCrime") or character:FindFirstChild("RestrictedArea"))
            end
            return false
        end
        
        return false
    end
    
    -- Функция проверки видимости и жизнеспособности цели
    local function isTargetValid(targetPlayer)
        local character = targetPlayer.Character
        if not character then return false end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart or humanoid.Health <= 0 then
            return false
        end
        
        if character:FindFirstChild("Downed") then
            return false
        end
        
        -- Проверка FOV
        local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then return false end
        
        local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
        local distanceToCenter = (screenPoint - screenCenter).Magnitude
        
        if distanceToCenter > (_G.fovRadius or 100) then
            return false
        end
        
        return true
    end
    
    -- Функция получения части тела для прицеливания
    local function getAimPart(character)
        if _G.aimAtHead and character:FindFirstChild("Head") then
            return character.Head
        else
            return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
        end
    end
    
    -- Основной цикл поиска цели
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and isValidTarget(player) and isTargetValid(player) then
            local targetPos = player.Character.HumanoidRootPart.Position
            local distance = (localPos - targetPos).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                bestTarget = player
                bestTargetPart = getAimPart(player.Character)
            end
        end
    end
    
    return bestTarget, bestTargetPart
end
		
_G.aim = false
    uis.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton2 then
            local player = game.Players.LocalPlayer
        -- Проверка на Configuration в workspace (только для второй части игры)
            local playerModel = workspace:FindFirstChild(player.Name)
            if playerModel and playerModel:FindFirstChildOfClass("Configuration") then
                _G.aim = true
                while wait() and _G.myaim do
                    local target, aimPart = aim()
                    if target and aimPart then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, aimPart.Position)
                    end
                    if _G.aim == false then return end
                end
            end
        end
    end)
    
    uis.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton2 then
            _G.aim = false
        end
    end)
end)
-- Добавьте элементы управления для FOV и стрельбы в голову
example:AddBox("FOV Radius", function(object, focus)
    if focus then
        _G.fovRadius = tonumber(object.Text) or 100
    end
end)

example:AddToggle("Show FOV Circle", function(state)
    _G.fovVisible = state
end)

-- Новый тоггл для стрельбы в голову
example:AddToggle("Aim at Head", function(state)
    _G.aimAtHead = state
end)
example:AddToggle("First Person Mode", function(state)
_G.coeman = (state and true or false)
if _G.coeman == true then
    game.Players.LocalPlayer.CameraMode = "LockFirstPerson"
    elseif _G.coeman == false then
game.Players.LocalPlayer.CameraMode = "Classic"
end
end)
example:AddLabel("Kill Specific player",function()
end)
example:AddBox("Player Name", function(object, focus)
	if focus then
		_G.playertokill = tostring(object.Text)
	end
	end)
	example:AddToggle("Kill Player", function(state)
		_G.killthisone = (state and true or false)
	while _G.killthisone do
		task.wait()
		pcall(function()
	if game.Players.LocalPlayer.Character.Humanoid.Sit ~= true then
	if game:GetService("Workspace").ObjectSelection:FindFirstChild("Buzzard") then
	   local TweenService = game:GetService("TweenService")
	local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
	
	local TweenValue = Instance.new("CFrameValue")
	TweenValue.Value = game:GetService("Workspace").ObjectSelection.Buzzard:GetPrimaryPartCFrame()
				
	TweenValue.Changed:Connect(function()
		game:GetService("Workspace").ObjectSelection.Cobra:PivotTo(TweenValue.Value)
	end)
				
	local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,10,0)})
	OnTween:Play()
	 OnTween.Completed:Wait()
game:GetService("Workspace").ObjectSelection.Buzzard.DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid) 
	elseif not game:GetService("Workspace").ObjectSelection:FindFirstChild("Buzzard") then
		   local vehicle = "Buzzard"
	game.Players.LocalPlayer.btp.Value=game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	wait(0.5)
	local CFrameEnd = game:GetService("Workspace").VehicleSpawns[vehicle].Pos.CFrame+Vector3.new(0,20,0)
	local Time = 3 -- Time in seconds
	local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
	tween:Play()
	tween.Completed:Wait()
	 wait(3)
	 local CFrameEnd = CFrame.new(game.Players.LocalPlayer.btp.Value)+Vector3.new(0,20,0)
	local Time = 3 -- Time in seconds
	local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
	tween:Play()
	tween.Completed:Wait()
	 wait(1)
	game:GetService("Workspace").ObjectSelection[vehicle].DriveSeat.Disabled = false
	   local TweenService = game:GetService("TweenService")
	local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
	
	local TweenValue = Instance.new("CFrameValue")
	TweenValue.Value = game:GetService("Workspace").ObjectSelection[vehicle]:GetPrimaryPartCFrame()
				
	TweenValue.Changed:Connect(function()
		game:GetService("Workspace").ObjectSelection[vehicle]:PivotTo(TweenValue.Value)
	end)
				
	local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,10,0)})
	OnTween:Play()
	 OnTween.Completed:Wait()
	wait(2)
	game:GetService("Workspace").ObjectSelection[vehicle].DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
	 end
	 else
		for i,v in pairs(game.Players:GetPlayers()) do
		if v.Name == _G.playertokill then
			game:GetService("ReplicatedStorage").Event:FireServer("BM", v.Character.HumanoidRootPart.Position)
		end
	end
end
end)
end	
		end)
example:AddToggle("Kill All Enemy Players", function(state)
_G.kill = (state and true or false)
while _G.kill do
    task.wait()
    pcall(function()
if game.Players.LocalPlayer.Character.Humanoid.Sit ~= true then
if game:GetService("Workspace").ObjectSelection:FindFirstChild("Cobra") or game:GetService("Workspace").ObjectSelection:FindFirstChild("Buzzard")  then

   local TweenService = game:GetService("TweenService")
local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

local TweenValue = Instance.new("CFrameValue")
TweenValue.Value = game:GetService("Workspace").ObjectSelection.Cobra:GetPrimaryPartCFrame()
			
TweenValue.Changed:Connect(function()
	game:GetService("Workspace").ObjectSelection.Cobra:PivotTo(TweenValue.Value)
end)
			
local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,10,0)})
OnTween:Play()
 OnTween.Completed:Wait()
 game:GetService("Workspace").ObjectSelection.Cobra.DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid) 
elseif not game:GetService("Workspace").ObjectSelection:FindFirstChild("Cobra") then
       local vehicle = "Cobra"
game.Players.LocalPlayer.btp.Value=game.Players.LocalPlayer.Character.HumanoidRootPart.Position
wait(0.5)
local CFrameEnd = game:GetService("Workspace").VehicleSpawns[vehicle].Pos.CFrame+Vector3.new(0,20,0)
local Time = 3 -- Time in seconds
local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
tween:Play()
tween.Completed:Wait()
 wait(3)
 local CFrameEnd = CFrame.new(game.Players.LocalPlayer.btp.Value)+Vector3.new(0,20,0)
local Time = 3 -- Time in seconds
local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
tween:Play()
tween.Completed:Wait()
 wait(1)
game:GetService("Workspace").ObjectSelection[vehicle].DriveSeat.Disabled = false
   local TweenService = game:GetService("TweenService")
local TweenInfoToUse = TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

local TweenValue = Instance.new("CFrameValue")
TweenValue.Value = game:GetService("Workspace").ObjectSelection[vehicle]:GetPrimaryPartCFrame()
			
TweenValue.Changed:Connect(function()
	game:GetService("Workspace").ObjectSelection[vehicle]:PivotTo(TweenValue.Value)
end)
			
local OnTween = TweenService:Create(TweenValue, TweenInfoToUse, {Value=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame+Vector3.new(0,10,0)})
OnTween:Play()
 OnTween.Completed:Wait()
wait(2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").ObjectSelection[vehicle].DriveSeat.CFrame
 end
 else
	for i,v in pairs(game.Players:GetPlayers()) do
	if game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright red")  and v.TeamColor ~= BrickColor.new("Bright red") and v.TeamColor ~= BrickColor.new("Bright orange") and v.TeamColor ~= BrickColor.new("Bright violet") then
		task.wait()
			game:GetService("ReplicatedStorage").Event:FireServer("BM", v.Character.HumanoidRootPart.Position)
			elseif game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright orange")  and v.TeamColor ~= BrickColor.new("Bright red") and v.TeamColor ~= BrickColor.new("Bright orange") and v.TeamColor ~= BrickColor.new("Bright violet") then
			task.wait()
			game:GetService("ReplicatedStorage").Event:FireServer("BM", v.Character.HumanoidRootPart.Position)
			elseif game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright violet")  and v.TeamColor ~= BrickColor.new("Bright red") and v.TeamColor ~= BrickColor.new("Bright orange") and v.TeamColor ~= BrickColor.new("Bright violet") then
			 task.wait()
			 game:GetService("ReplicatedStorage").Event:FireServer("BM", v.Character.HumanoidRootPart.Position)
			elseif game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright blue")  and v.TeamColor ~= BrickColor.new("Bright yellow") and v.TeamColor ~= BrickColor.new("Bright blue") then
			task.wait()
			game:GetService("ReplicatedStorage").Event:FireServer("BM", v.Character.HumanoidRootPart.Position)
			elseif game.Players.LocalPlayer.TeamColor == BrickColor.new("Bright yellow")  and v.TeamColor ~= BrickColor.new("Bright blue") and v.TeamColor ~= BrickColor.new("Bright yellow") then
           task.wait()
game:GetService("ReplicatedStorage").Event:FireServer("BM", v.Character.HumanoidRootPart.Position)

	end
end
end
end)
end
end)
example:AddToggle("Parachute Everyone", function(state)
_G.Parachute = (state and true or false)
local num = 1
while _G.Parachute do
    task.wait()
    pcall(function()
for i,v in pairs(game.Players:GetChildren()) do
    if v.ClassName == "Player" then
        task.wait()
    if num < 0.2 then
        num = 1
        else
            print("test",num)
game:GetService("ReplicatedStorage").Event:FireServer("Glider", workspace[v.Character.Name].Parachute.Handle, num) 
    end
end
end
_G.ohnum = false
num=num-0.1
end)
end
end)
	local example = library:CreateWindow({
		text = "Teleports"
	  })
	  example:AddButton("Tp to CrimeBase",function()
		if not game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
		local CFrameEnd = workspace.CriminalBase1.WorldPivot
		local Time = 4
		local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
		tween:Play()
		tween.Completed:Wait()
		elseif game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =workspace.CriminalBase1.WorldPivot
		end
		end)
		example:AddLabel("Tp to players",function()
		end)
		example:AddBox("Player", function(object, focus)
		  if focus then
			if not game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
			 _G.Player = tostring(object.Text)
		local CFrameEnd = game.Players[_G.Player].Character.HumanoidRootPart.CFrame
		local Time = 3
		local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
		tween:Play()
		tween.Completed:Wait()
			elseif  game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[_G.Player].Character.HumanoidRootPart.CFrame
			 end
			end
		end)
		 example:AddToggle("Loop Tp", function(state)
			 _G.loopp = (state and true or false)
			 while _G.loopp == true do
				 task.wait()
			pcall(function()
				 if not game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
		if game.Players.LocalPlayer:DistanceFromCharacter(game.Players[_G.Player].Character.HumanoidRootPart.Position) < 250 then
			task.wait()
		local CFrameEnd = game.Players[_G.Player].Character.HumanoidRootPart.CFrame
		local Time = 0.1
		local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
		tween:Play()
		tween.Completed:Wait()
		else
		local CFrameEnd = game.Players[_G.Player].Character.HumanoidRootPart.CFrame
		local Time = 2.5
		local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
		tween:Play()
		tween.Completed:Wait()
		end
	elseif game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=game.Players[_G.Player].Character.HumanoidRootPart.CFrame
	end
		end)    
		 end
		 end)
		  example:AddButton("Tp to Prison",function()
			if not game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
		local CFrameEnd = CFrame.new(-783.3597412109375, 76.81155395507812, -3233.08056640625)
		local Time = 4
		local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
		tween:Play()
		tween.Completed:Wait()
			elseif  game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-783.3597412109375, 76.81155395507812, -3233.08056640625)
			end
		  end)
		  example:AddButton("Tp to Gun Shop",function()
			if not game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
		local CFrameEnd = CFrame.new(-1613.8153076171875, 42.44813537597656, 690.4595947265625)
		local Time = 4
		local tween =  game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Time), {CFrame = CFrameEnd})
		tween:Play()
		tween.Completed:Wait()
			elseif game:GetService("Players").LocalPlayer:FindFirstChild("TeleportLocation") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1613.8153076171875, 42.44813537597656, 690.4595947265625)
			end
		  end)
		 
spawn(function()
	_G.noshow = true
while _G.noshow do
    wait()
if _G.showplayer == false then
    wait()
    for i,v in pairs(game.Players:GetChildren()) do
        if v.ClassName == "Player" and v.Character:FindFirstChild("NameTag") and v.Character.NameTag.MaxDistance ~= 100 then
            wait()
    v.Character.NameTag.MaxDistance = 100
        v.Character.NameTag.AlwaysOnTop = false
        v.Character.NameTag.Title.Text = v.Name
    end
    end
end
end
end)
spawn(function()
    _G.holyholy = true
    while _G.holyholy == true do
        task.wait()
        pcall(function()
    if _G.showplayer == true then
  task.wait()
        for i,v in pairs(game.Players:GetChildren()) do
        if v.ClassName == "Player" and v.Name ~= game.Players.LocalPlayer.Name and v.Character:FindFirstChild("NameTag") then
            task.wait()
           v.Character.NameTag.Title.Text = v.Name.." Dist:"..math.round((game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Character.HumanoidRootPart.Position).Magnitude/3.571).."m"
    end
        end
end
end)
end
end)

spawn(function()
    _G.l234 = true
    while _G.l234 do
        wait()
        pcall(function()
if game:GetService("Workspace").Pyramid.Line.CanCollide == true then
    for i,v in pairs(game:GetService("Workspace").Pyramid:GetChildren()) do
        if v.Name == "Line" and v.CanCollide == true then
            wait()
            v.CanCollide = false
        end
    end
end
end)
end
end)

	spawn(function()
		while wait() do
		pcall(function()
			if game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"].Body.Windows.CanCollide == true and game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"].Body.Body.CanCollide == true then
			wait()
				game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"].Body.Windows.CanCollide = false
			game:GetService("Workspace").ObjectSelection[game.Players.LocalPlayer.Character.Name.."'s Vehicle"].Body.Body.CanCollide = false
			end
		end)
		end
	end)
	spawn(function()
		while wait() do
			pcall(function()
		if _G.Parachute == false and _G.ohnum == false then
			for i,v in pairs(game.Players:GetChildren()) do
				if v.ClassName == "Player" then
					task.wait()
			game:GetService("ReplicatedStorage").Event:FireServer("Glider", workspace[v.Character.Name].Parachute.Handle, 1) 
				end
			end
			_G.ohnum = true
		end
	end)
	end
	end)


-- ESP система для вашего скрипта
-- Добавьте этот код после создания основных окон

-- ESP переменные
_G.espEnabled = false
_G.espBoxes = false
_G.espHealthBars = false

-- Хранилище ESP объектов
local espObjects = {}

-- Функция получения цвета команды
local function getTeamColor(player)
    if not player or not player.TeamColor then
        return Color3.fromRGB(255, 255, 255) -- Белый по умолчанию
    end
    
    local teamColor = player.TeamColor
    
    if teamColor == BrickColor.new("Bright red") then
        return Color3.fromRGB(255, 0, 0) -- Красный
    elseif teamColor == BrickColor.new("Bright blue") then
        return Color3.fromRGB(0, 0, 255) -- Синий
    elseif teamColor == BrickColor.new("Bright yellow") then
        return Color3.fromRGB(255, 255, 0) -- Желтый
    elseif teamColor == BrickColor.new("Bright orange") then
        return Color3.fromRGB(255, 165, 0) -- Оранжевый
    elseif teamColor == BrickColor.new("Bright violet") then
        return Color3.fromRGB(138, 43, 226) -- Фиолетовый
    else
        return Color3.fromRGB(255, 255, 255) -- Белый для неизвестных команд
    end
end

-- Функция создания ESP для игрока
local function createESP(player)
    if player == game.Players.LocalPlayer then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square")
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
    
    -- Настройка полоски здоровья
    esp.HealthBar.Visible = false
    esp.HealthBar.Filled = true
    esp.HealthBar.Thickness = 1
    esp.HealthBar.Transparency = 1
    
    -- Настройка контура полоски здоровья
    esp.HealthBarOutline.Visible = false
    esp.HealthBarOutline.Filled = false
    esp.HealthBarOutline.Thickness = 1
    esp.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBarOutline.Transparency = 1
    
    espObjects[player] = esp
end

-- Функция обновления ESP
local function updateESP(player, esp)
    if not _G.espEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.HealthBar.Visible = false
        esp.HealthBarOutline.Visible = false
        return
    end
    
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not rootPart or not head or humanoid.Health <= 0 then
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.HealthBar.Visible = false
        esp.HealthBarOutline.Visible = false
        return
    end
    
    local camera = workspace.CurrentCamera
    
    -- Получаем позиции головы и ног для точного размера во весь рост
    local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y/2, 0))
    local rootPos, rootOnScreen = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, rootPart.Size.Y/2 + 2, 0))
    
    if not headOnScreen or not rootOnScreen then
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
        esp.HealthBar.Visible = false
        esp.HealthBarOutline.Visible = false
        return
    end
    
    -- Получение цвета команды
    local teamColor = getTeamColor(player)
    
    -- Вычисляем размер бокса на основе реальных размеров персонажа во весь рост
    local boxHeight = math.abs(rootPos.Y - headPos.Y)
    local boxWidth = boxHeight * 0.5 -- Узкий бокс для тонкого вида
    
    -- Обновление бокса
    if _G.espBoxes then
        -- Обводка бокса (черная, чуть больше основного)
        esp.BoxOutline.Size = Vector2.new(boxWidth + 2, boxHeight + 2)
        esp.BoxOutline.Position = Vector2.new(headPos.X - (boxWidth + 2) / 2, headPos.Y - 1)
        esp.BoxOutline.Visible = true
        
        -- Основной бокс (цвет команды)
        esp.Box.Size = Vector2.new(boxWidth, boxHeight)
        esp.Box.Position = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
        esp.Box.Color = teamColor
        esp.Box.Visible = true
    else
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
    end
    
    -- Обновление полоски здоровья
    if _G.espHealthBars then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        local barHeight = boxHeight * healthPercent
        local barWidth = 2 -- Очень тонкая полоска
        
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
        
        -- Контур полоски здоровья (обводка с обеих сторон)
        esp.HealthBarOutline.Size = Vector2.new(barWidth + 2, boxHeight + 2)
        esp.HealthBarOutline.Position = Vector2.new(barX - 1, headPos.Y - 1)
        esp.HealthBarOutline.Visible = true
        
        -- Сама полоска здоровья
        esp.HealthBar.Size = Vector2.new(barWidth, barHeight)
        esp.HealthBar.Position = Vector2.new(barX, barY)
        esp.HealthBar.Color = healthColor
        esp.HealthBar.Visible = true
    else
        esp.HealthBar.Visible = false
        esp.HealthBarOutline.Visible = false
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

-- Создание ESP вкладки
local espWindow = library:CreateWindow({
    text = "ESP"
})

-- Основной тоггл ESP
espWindow:AddToggle("Enable ESP", function(state)
    _G.espEnabled = state
    
    if not state then
        -- Скрыть все ESP объекты при отключении
        for player, esp in pairs(espObjects) do
            esp.Box.Visible = false
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
        end
    end
end)

-- Тоггл ESP боксов
espWindow:AddToggle("ESP Boxes", function(state)
    _G.espBoxes = state
    
    if not state then
        -- Скрыть все боксы
        for player, esp in pairs(espObjects) do
            esp.Box.Visible = false
        end
    end
end)

-- Тоггл полосок здоровья
espWindow:AddToggle("Health Bars", function(state)
    _G.espHealthBars = state
    
    if not state then
        -- Скрыть все полоски здоровья
        for player, esp in pairs(espObjects) do
            esp.HealthBar.Visible = false
            esp.HealthBarOutline.Visible = false
        end
    end
end)

-- Создание ESP для существующих игроков
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        createESP(player)
    end
end

-- Обработка новых игроков
game.Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- Обработка ухода игроков
game.Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Обработка респавна персонажей
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Небольшая задержка для загрузки персонажа
        if espObjects[player] then
            removeESP(player)
            createESP(player)
        end
    end)
end)

-- Основной цикл обновления ESP
game:GetService("RunService").RenderStepped:Connect(function()
    if not _G.espEnabled then return end
    
    for player, esp in pairs(espObjects) do
        if player and player.Parent then
            updateESP(player, esp)
        else
            removeESP(player)
        end
    end
end)
