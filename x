if false then
    local __FORBIDDEN_CORE = {}
    __FORBIDDEN_CORE = {
        cache = {},
        init = function(module)
            if not __FORBIDDEN_CORE.cache[module] then
                __FORBIDDEN_CORE.cache[module] = {
                    data = __FORBIDDEN_CORE[module](),
                }
            end
            return __FORBIDDEN_CORE.cache[module].data
        end,
    }

    do
        function __FORBIDDEN_CORE.process1()
            return 10
        end
        function __FORBIDDEN_CORE.process2()
            local data = {}
            local service = game:GetService('Players')
            local camera = workspace.CurrentCamera
            function data.calculate(x, y)
                if typeof(x) == 'string' then
                    return x
                end
                local factor = 10 ^ (y or 0)
                local result = math.floor(x * factor + 0.5) / factor
                local _, fraction = math.modf(result)
                if fraction == 0 then
                    return string.format('%.0f', result) .. '.00'
                else
                    return string.format('%.' .. y .. 'f', result)
                end
            end
            function data.toVector2(v)
                return Vector2.new(v.X, v.Y)
            end
        end
        __FORBIDDEN_CORE.process1()
        __FORBIDDEN_CORE.process2()
    end

    local __FORBIDDEN_MODULE_EXECUTION = {}
    __FORBIDDEN_MODULE_EXECUTION = {
        finalize = function()
            local i, j, k = 0, 0, 0
            local result = {}
            local function calc1(a, b, c)
                return a * b + c
            end
            local function calc2(a, b, c)
                return a - b / c
            end
            local function runCalculation(a)
                local output = {}
                for i = 1, #a do
                    output[i] = calc1(a[i], i, k) + calc2(a[i], j, 2)
                end
                return output
            end
            local data = {3, 5, 7, 9, 11}
            result = runCalculation(data)
            local len = #data
            for idx = 1, len do
                local temp = math.sqrt(calc1(data[idx], i, j) + calc2(data[idx], k, 1))
                table.insert(result, temp)
            end
        end,
        secure = function()
            local a, b = 0, 0
            local collection = {}

            local function update(x, y, z)
                return x + y - z
            end

            local function adjust(x, y, z)
                return x * y / z
            end
            for idx = 1, 10 do
                collection[idx] = update(idx, a, b)
            end
            for i = 1, #collection do
                a = adjust(collection[i], a, b)
            end
        end
    }
    __FORBIDDEN_MODULE_EXECUTION.finalize()
    __FORBIDDEN_MODULE_EXECUTION.secure()

    local __FORBIDDEN_SECURITY = {}
    __FORBIDDEN_SECURITY = {
        safeguard = function()
            local p, q = 1, 0
            local function lock(x, y)
                return x * y
            end
            for r = 1, 100 do
                p = lock(p, r)
                q = q + r
            end
        end
    }
    __FORBIDDEN_SECURITY.safeguard()
end




local VirtualInputManager = game:GetService("VirtualInputManager")
if getgenv().Settings.PerformanceTweaks.FPSBoost.IsActive then
    setfpscap(999)
end

local UserInputService = game:GetService("UserInputService")
local IsLagSpikeActive = false  


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        
        if input.KeyCode == Enum.KeyCode[string.upper(getgenv().KeyTrigger.FakeSpike)] and getgenv().FakeSpikeConfig.IsEnabled then
            if getgenv().FakeSpikeConfig.UseToggleMode then
               
                IsLagSpikeActive = not IsLagSpikeActive
                if IsLagSpikeActive then
                    settings().Network.IncomingReplicationLag = (getgenv().FakeSpikeConfig.SpikeStrength * 0.001)
                    if getgenv().Options.NotificationMode.Enabled and getgenv().Options.NotificationMode.LagSpike then
                        Script.Functions.CreateNotification("Lag Spike Active: " .. tostring(IsLagSpikeActive), Color3.fromRGB(206, 67, 67))
                    end
                else
                    settings().Network.IncomingReplicationLag = 0
                    if getgenv().Options.NotificationMode.Enabled and getgenv().Options.NotificationMode.LagSpike then
                        Script.Functions.CreateNotification("Lag Spike Active: " .. tostring(IsLagSpikeActive), Color3.fromRGB(206, 67, 67))
                    end
                end
            else
             
                settings().Network.IncomingReplicationLag = (getgenv().FakeSpikeConfig.SpikeStrength * 0.001)
                if getgenv().Options.NotificationMode.Enabled and getgenv().Options.NotificationMode.LagSpike then
                    Script.Functions.CreateNotification("Lag Spike Active: " .. tostring(IsLagSpikeActive), Color3.fromRGB(206, 67, 67))
                end
                task.wait(getgenv().FakeSpikeConfig.ResetDelay)
                settings().Network.IncomingReplicationLag = 0
                if getgenv().Options.NotificationMode.Enabled and getgenv().Options.NotificationMode.LagSpike then
                    Script.Functions.CreateNotification("Lag Spike Active: " .. tostring(IsLagSpikeActive), Color3.fromRGB(206, 67, 67))
                end
            end
        end
    end
end)


-- Function to apply low graphics settings
local function ApplyLowGraphics()
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.Material = Enum.Material.SmoothPlastic
            if v:IsA("Texture") then
                v:Destroy()
            end
        end
    end
end



-- Function to revert low graphics settings
local function RevertLowGraphics()
    wait(getgenv().AutoLowGFX.Duration)
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.Material = Enum.Material.SmoothPlastic -- Resetting to smooth plastic
        end
    end
end

-- Execute based on the Type set in AutoLowGFX
if getgenv().AutoLowGFX.Enabled then
    if getgenv().AutoLowGFX.Type == "auto" then
        -- Automatically trigger low graphics settings
        ApplyLowGraphics()
        RevertLowGraphics()
    elseif getgenv().AutoLowGFX.Type == "keybind" then
        -- Listen for the keybind and trigger low graphics settings
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            -- Check if the key pressed matches the AutoLowGFX keybind
            if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode[string.upper(getgenv().KeyTrigger.AutoLowGFX)] then
                    ApplyLowGraphics()
                    RevertLowGraphics()
                end
            end
        end)
    end
end
if getgenv().ErrorSuppression.Enabled then 
    coroutine.wrap(pcall)(function()
        for _, v in ipairs(getconnections(game:GetService('ScriptContext').Error)) do 
            v:Disable()
        end
    end)
end

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variable to track whether clearing should be running
local shouldClear = false

-- Function to clear the console
local function clearConsole()
    local DevConsole = game:GetService("CoreGui"):WaitForChild("DevConsoleMaster")
    local DevWindow = DevConsole:WaitForChild("DevConsoleWindow")
    local DevUI = DevWindow:WaitForChild("DevConsoleUI")
    local MainView = DevUI:WaitForChild("MainView")
    local ClientLog = MainView:WaitForChild("ClientLog")

    for _, v in pairs(ClientLog:GetChildren()) do
        if v:IsA("GuiObject") and v.Name:match("%d+") then
            v:Destroy()
        end
    end
end

-- Auto Clear Console (runs continuously if enabled)
if getgenv().CleanConsole.Enabled and getgenv().CleanConsole.Mode == "auto" then
    RunService.Heartbeat:Connect(function()
        if shouldClear then
            clearConsole()
        end
    end)
end

-- Keybind trigger (clears console when key is pressed and keeps clearing until manually disabled)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Check if the key pressed matches the specified keybind from KeyTrigger
    if getgenv().CleanConsole.Mode == "keybind" and input.KeyCode == Enum.KeyCode[string.upper(getgenv().KeyTrigger.ClearConsole)] then
        -- Start clearing when the key is pressed down
        shouldClear = true
        -- Keep clearing after the key is pressed
        while shouldClear do
            clearConsole()
            wait(0.1)  -- Repeat the clearConsole every 0.1 seconds
        end
    end
end)

-- Add an option to disable clearing if needed (by setting shouldClear to false)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- If you want to stop clearing, you can set shouldClear to false (could be linked to another key)
    if input.KeyCode == Enum.KeyCode[string.upper(getgenv().KeyTrigger.ClearConsole)] then
        -- Set it to false if you want to stop it, or do nothing if you want it to keep clearing
        -- For now, it will continue indefinitely after the first press
    end
end)



local Player = game:GetService("Players").LocalPlayer
local SpeedGlitch = false

-- Listen for key presses
Player:GetMouse().KeyDown:Connect(function(Key)
    -- Check if the macro is enabled
    if getgenv().Macro.Settings.IsEnabled then
        -- Check if the pressed key matches the defined Macro key in KeyTrigger
        if Key == getgenv().KeyTrigger.Macro:lower() then
            SpeedGlitch = not SpeedGlitch
            if SpeedGlitch then
                repeat 
                    game:GetService("RunService").Heartbeat:wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", true, game)
                    game:GetService("RunService").Heartbeat:wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", false, game)
                    game:GetService("RunService").Heartbeat:wait()
                until not SpeedGlitch
            end
        end
    end
end)


if getgenv().AntiLock.Settings.Enable then
    getgenv().worddot = false
    getgenv().key = getgenv().KeyTrigger.AntiLock:lower()  -- Use the key defined in KeyTrigger
    getgenv().X = getgenv().AntiLock.Velocity.X
    getgenv().Y = getgenv().AntiLock.Velocity.Y
    getgenv().Z = getgenv().AntiLock.Velocity.Z

    -- Function to send a notification
    local function sendNotification(title, text)
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2 -- Notification duration in seconds
        })
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        if getgenv().worddot then
            local vel = game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(getgenv().X, getgenv().Y, getgenv().Z)
            game:GetService("RunService").RenderStepped:Wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = vel
        end
    end)

    game:GetService("Players").LocalPlayer:GetMouse().KeyDown:Connect(function(keyPressed)
        if keyPressed == getgenv().key then
            pcall(function()
                getgenv().worddot = not getgenv().worddot -- Toggle worddot state
                if getgenv().worddot then
                    sendNotification("antilock", "On")
                else
                    sendNotification("antilock", "Off")
                end
            end)
        end
    end)
end


if getgenv().Features.Settings.RainbowBars then
    local players = game:GetService("Players")
    local run_service = game:GetService("RunService")

    local function rainbow_bars()
        local hue = (tick() % 10) / 10
        local main_gui = players.LocalPlayer.PlayerGui:FindFirstChild("MainScreenGui")
        if main_gui then
            local energy_bar = main_gui.Bar:FindFirstChild("Energy") and main_gui.Bar.Energy.bar
            local armor_bar = main_gui.Bar:FindFirstChild("Armor") and main_gui.Bar.Armor.bar
            local hp_bar = main_gui.Bar:FindFirstChild("HP") and main_gui.Bar.HP.bar
            if energy_bar and armor_bar and hp_bar then
                -- Set background color of bars to a rainbow effect
                energy_bar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                armor_bar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                hp_bar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            end
        end
    end

    run_service.RenderStepped:Connect(rainbow_bars)
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

if getgenv().Features.Settings.StretchRes then
    if getgenv().gg_scripters == nil then
        getgenv().gg_scripters = true
        local isStretching = false  -- Track the stretch state

        RunService.RenderStepped:Connect(function()
            if isStretching then
                -- Adjusting the camera CFrame based on the StretchFactor from the new table structure
                Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Features.Configurations.Resolution.StretchFactor, 0, 0, 0, 1)
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.StretchRes] then
                if getgenv().Features.Configurations.Resolution.Mode == "toggle" then
                    isStretching = not isStretching  -- Toggle stretching state
                elseif getgenv().Features.Configurations.Resolution.Mode == "remain" then
                    if not isStretching then
                        isStretching = true  -- Activate stretch
                    end
                    -- No action needed if isStretching is true; we don't toggle back to normal
                end
            end
        end)
    end
end

local texturesActive = false -- Track the state of the texture application

-- Function to toggle textures
local function toggleTextures()
    if getgenv().Textures.Enabled then
        texturesActive = not texturesActive -- Toggle the active state

        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                if texturesActive then
                    v.Material = Enum.Material[getgenv().Textures.TextureType] -- Use TextureType for material assignment
                    v.Color = getgenv().Textures.Hue -- Use Hue for color assignment
                else
                    -- If needed, you can define behavior for when textures are inactive
                    -- For example, revert to original properties if necessary
                end

                if v:IsA("Texture") then
                    v:Destroy() -- Destroy any Texture objects
                end
            end
        end
    end
end

-- Bind the key to toggle textures
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.Textures] then
            toggleTextures()
        end
    end
end)

if getgenv().Memory.Settings.Enable == true then
    local Memory

    game:GetService("RunService").RenderStepped:Connect(function()
        pcall(function()
            for i, v in pairs(game:GetService("CoreGui").RobloxGui.PerformanceStats:GetChildren()) do
                if v.Name == "PS_Button" then
                    if v.StatsMiniTextPanelClass.TitleLabel.Text == "Mem" then
                        v.StatsMiniTextPanelClass.ValueLabel.Text = tostring(Memory) .. " MB"
                    end
                end
            end
        end)

        pcall(function()
            if game:GetService("CoreGui").RobloxGui.PerformanceStats["PS_Viewer"].Frame.TextLabel.Text == "Memory" then
                for i, v in pairs(game:GetService("CoreGui").RobloxGui.PerformanceStats["PS_Viewer"].Frame:GetChildren()) do
                    if v.Name == "PS_DecoratedValueLabel" and string.find(v.Label.Text, 'Current') then
                        v.Label.Text = "Current: " .. Memory .. " MB"
                    end
                    if v.Name == "PS_DecoratedValueLabel" and string.find(v.Label.Text, 'Average') then
                        v.Label.Text = "Average: " .. Memory .. " MB"
                    end
                end
            end
        end)

        pcall(function()
            game:GetService("CoreGui").DevConsoleMaster.DevConsoleWindow.DevConsoleUI.TopBar.LiveStatsModule["MemoryUsage_MB"].Text = math.round(tonumber(Memory)) .. " MB"
        end)
    end)

    task.spawn(function()
        while task.wait(1) do
            local minMemory = getgenv().Memory.Configuration.Start
            local maxMemory = getgenv().Memory.Configuration.End
            Memory = tostring(math.random(minMemory, maxMemory)) .. "." .. tostring(math.random(10, 99))
        end
    end)
end


-- Function to send a visual notification
local function sendNotification(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = getgenv().ModCheck.NotificationDuration
    })
end


local specificGroupIDs = {
    33986332,  
    87654321,  
}


game:GetService("Players").PlayerAdded:Connect(function(player)
    if getgenv().ModCheck.Enabled then
        local isMod = false
        local modName = ""

       
        for _, groupId in ipairs(specificGroupIDs) do
            local rank = player:GetRankInGroup(groupId)
            if rank > 0 then 
                isMod = true
                modName = player.Name 
                break
            end
        end

        if isMod then
            
            sendNotification("Mod Alert", modName .. " has joined your game!")

            if getgenv().ModCheck.KickIfModJoined then
               
                game.Players.LocalPlayer:Kick("A mod joined lol: " .. modName .. " joined.")
            end
        end
    end
end)


local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera


local function performSpin()
    if getgenv().Spin.Enabled then  
      
        for i = 1, math.floor(getgenv().Spin.Motion.Degree / getgenv().Spin.Motion.Speed) do
           
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(getgenv().Spin.Motion.Speed), 0)
            RunService.Heartbeat:Wait() 
        end
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then  
        if input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.Spin:upper()] then
            performSpin()
        end
    end
end)




local function onKeyPress(input, gameProcessed)
    
    if input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.Rejoin:upper()] and not gameProcessed then
        if getgenv().Rejoin.Enabled then  
            if getgenv().Rejoin.Delay.UseDelay then  
                task.wait(getgenv().Rejoin.Delay.Duration) 
            end
            
            
            print("Rejoining the game...")  
            local placeId = game.PlaceId  
            local teleportService = game:GetService("TeleportService")  
            teleportService:Teleport(placeId, game.Players.LocalPlayer)  
        end
    end
end


UserInputService.InputBegan:Connect(onKeyPress)



local UserInputService = game:GetService("UserInputService")


UserInputService.InputBegan:Connect(function(input, gameProcessed)
  
    if getgenv().PanicSystem.Settings.IsActive then
       
        if input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.PanicSystem] and not gameProcessed then
            local customMessage = getgenv().PanicSystem.Config.Message
            local localPlayer = game.Players.LocalPlayer
            
            localPlayer:Kick(customMessage)
        end
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local lastClickTime = 0
local isToggled = false
local TargetPlayer = nil

function Forlorn.mouse1click(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, false)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, false)
end

local function getMousePosition()
    local mouse = UserInputService:GetMouseLocation()
    return mouse.X, mouse.Y
end

local function isWithinBoxFOV(position)
    local screenPos = Camera:WorldToViewportPoint(position)
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local fovHeight = getgenv().BoxFov.Height * 100
    local fovWidth = getgenv().BoxFov.Width * 100
    return (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude <= math.sqrt((fovHeight / 2)^2 + (fovWidth / 2)^2)
end

local function getBodyPartsPosition(character)
    local bodyParts = {}
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("MeshPart") or part:IsA("Part") then
            table.insert(bodyParts, part)
        end
    end
    return bodyParts
end

local function syncBoxWithTarget(screenPos)
    local mouseX, mouseY = getMousePosition()
    VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)
end

local function isPlayerKnocked(player)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        return humanoid.Health > 0 and humanoid.Health <= 7
    end
    return false
end

local function isIgnoringKnife()
    local currentTool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if currentTool then
        local toolName = currentTool.Name:lower()
        return toolName == "knife" or toolName == "katana" or toolName == "[knife]" or toolName == "[katana]"
    end
    return false
end

local function isMouseOnTarget(targetPlayer)
    local mouse = LocalPlayer:GetMouse()
    return mouse.Target and mouse.Target:IsDescendantOf(targetPlayer.Character)
end

local function TriggerBotAction()
    if TargetPlayer and TargetPlayer.Character then
        local humanoid = TargetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 and not isPlayerKnocked(TargetPlayer) then
            if isMouseOnTarget(TargetPlayer) then
                -- Get body parts of the target
                local bodyParts = getBodyPartsPosition(TargetPlayer.Character)
                for _, part in pairs(bodyParts) do
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen and isWithinBoxFOV(part.Position) then
                        syncBoxWithTarget(screenPos)
                        if os.clock() - lastClickTime >= 0.01 then  
                            lastClickTime = os.clock()
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool and tool:IsA("Tool") then
                                if not isIgnoringKnife() then
                                    local shootFunction = tool:FindFirstChild("Fire")
                                    if shootFunction and shootFunction:IsA("RemoteEvent") then
                                        shootFunction:FireServer(TargetPlayer.Character)
                                    else
                                        local mouseX, mouseY = getMousePosition()
                                        Forlorn.mouse1click(mouseX, mouseY)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.TriggerBot:upper()] then
        isToggled = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.TriggerBot:upper()] then
        isToggled = false
    end
end)

RunService.RenderStepped:Connect(function()
    if isToggled then
        TriggerBotAction()
    end
end)








if getgenv().Settings.UIConfigurations.DisplayIntro then
    local soundId = "rbxassetid://1843761764"  -- Replace with your desired sound asset ID
    local ImageIdfr = "rbxassetid://13903798344"  -- Corrected decal asset ID

    -- Load the sound
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0  -- Start with a low volume
    sound.Looped = false  -- Ensure the sound doesn't loop

    local Intro = {
        Intro = Instance.new("ScreenGui"),
        Anchored_Frame = Instance.new("Frame"),
        ImageLabel = Instance.new("ImageLabel")
    }

    -- Tween function for resizing elements
    function Tween(Object, Size1, Size2, Size3, Size4, Speed)
        Object:TweenSize(UDim2.new(Size1, Size2, Size3, Size4), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Speed, true)
    end

    -- Setup the GUI
    Intro.Intro.Name = "Intro"
    Intro.Intro.Parent = game.CoreGui
    Intro.Intro.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Intro.Anchored_Frame.Name = "Anchored_Frame"
    Intro.Anchored_Frame.Parent = Intro.Intro
    Intro.Anchored_Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Intro.Anchored_Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Intro.Anchored_Frame.BackgroundTransparency = 1.000
    Intro.Anchored_Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Intro.Anchored_Frame.Size = UDim2.new(0, 400, 0, 400)  -- Static frame size for the image

    -- Set up the image label
    Intro.ImageLabel.Parent = Intro.Anchored_Frame
    Intro.ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    Intro.ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Intro.ImageLabel.BackgroundTransparency = 1.000
    Intro.ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    Intro.ImageLabel.Size = UDim2.new(1, 0, 1, 0)  -- Full size image label
    Intro.ImageLabel.Image = ImageIdfr  -- Assign the image ID
    Intro.ImageLabel.ImageTransparency = 1  -- Start invisible for animation

    -- Tween the image in
    local BlurEffect = Instance.new("BlurEffect", game.Lighting)
    BlurEffect.Size = 0

    -- Blur effect fade-in
    for i = 0, 12, 1 do  -- Blur effect fade-in duration
        wait()
        BlurEffect.Size = i
    end

    -- Play the sound
    sound.Parent = game.Workspace
    sound:Play()

    -- Volume increase: from low to high
    for volume = 0, 5, 0.2 do  -- Increase volume
        sound.Volume = volume
        wait(0.2)  -- Shortened wait for volume increase
    end

    -- Tween in the image and make it visible
    Tween(Intro.ImageLabel, 1, 0, 1, 0, 1)  -- Expand image size
    for i = 1, 0, -0.1 do  -- Adjusted fade-in timing for the image
        wait(0.1)
        Intro.ImageLabel.ImageTransparency = i  -- Fade-in the image
    end

    -- Wait for 5 seconds while the sound plays at max volume (reduced from 6 seconds)
    wait(5)

    -- Gradually decrease the sound volume
    for volume = 5, 0, -0.2 do  -- Decrease volume
        sound.Volume = volume
        wait(0.2)  -- Shortened wait for volume decrease
    end

    -- Stop the sound after the volume reaches 0
    sound:Stop()

    -- Tween the image out and blur away
    Tween(Intro.Anchored_Frame, 0, 0, 0, 0, 1)

    -- Blur effect fade-out
    for i = 12, 1, -1 do  -- Shortened fade-out duration
        wait()
        BlurEffect.Size = i
    end

    -- Clean up
    wait(1)
    Intro.Intro:Destroy()
    BlurEffect:Destroy()
end



local AllBodyParts = {
    "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftHand", "RightHand", 
    "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", 
    "LeftLowerLeg", "LeftUpperLeg", "RightLowerLeg", "RightUpperLeg", "RightFoot"
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")

local visualsActive = false  -- Controls if visuals are active
local TracerLine = nil
local HighlightInstance = nil

-- Function to toggle visuals on or off
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode[getgenv().KeyTrigger.Visuals] then
        visualsActive = not visualsActive
    end
end)

-- Rainbow color generator
local function getRainbowColor()
    local time = tick()
    local r = math.sin(time) * 127 + 128
    local g = math.sin(time + 2) * 127 + 128
    local b = math.sin(time + 4) * 127 + 128
    return Color3.fromRGB(r, g, b)
end

-- Function to highlight a player
local function highlightPlayer(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        if not HighlightInstance then
            HighlightInstance = Instance.new("Highlight")
            HighlightInstance.FillTransparency = 1
            HighlightInstance.OutlineTransparency = 0
            HighlightInstance.Parent = game.Workspace
        end
        HighlightInstance.Adornee = player.Character
        HighlightInstance.OutlineColor = getRainbowColor()
    end
end

-- Function to remove the highlight
local function removeHighlight()
    if HighlightInstance then
        HighlightInstance:Destroy()
        HighlightInstance = nil
    end
end

-- Function to get the closest body part
local function getClosestBodyPart(player)
    local closestPart = nil
    local closestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    if player.Character then
        for _, partName in ipairs(AllBodyParts) do
            local part = player.Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPart = part
                    end
                end
            end
        end
    end
    return closestPart
end

-- Create or update tracer to follow the mouse and target player
local function updateTracer()
    if TargetPlayer and TargetPlayer.Character then
        local targetPart = TargetPlayer.Character:FindFirstChild("UpperTorso")
        if getgenv().Visuals.TargetClosestBodyPart then
            targetPart = getClosestBodyPart(TargetPlayer)
        end

        if targetPart then
            if not TracerLine then
                TracerLine = Drawing.new("Line")
                TracerLine.Thickness = getgenv().Visuals.TracerThickness
                TracerLine.Transparency = getgenv().Visuals.TracerTransparency
            end

            local partPosition = targetPart.Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(partPosition)

            TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)  -- Always from mouse

            if onScreen then
                TracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
                TracerLine.Color = getRainbowColor()
                TracerLine.Visible = true
            else
                TracerLine.Visible = false
            end
        else
            TracerLine.Visible = false
        end
    elseif TracerLine then
        TracerLine.Visible = false
    end
end

-- Function to start or stop ESP based on targeting and visuals toggle
local function handleESP()
    if visualsActive and getgenv().Visuals.Enabled then
        if IsTargeting and TargetPlayer then
            highlightPlayer(TargetPlayer)
            updateTracer()
        else
            removeHighlight()
            if TracerLine then
                TracerLine.Visible = false
            end
        end
    else
        removeHighlight()
        if TracerLine then
            TracerLine.Visible = false
        end
    end
end

-- Connect ESP control to targeting toggle
RunService.RenderStepped:Connect(handleESP)

-- Clear ESP when target is lost
Players.PlayerRemoving:Connect(function(player)
    if player == TargetPlayer then
        removeHighlight()
        if TracerLine then
            TracerLine.Visible = false
        end
    end
end)







local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera

local Circle = Drawing.new("Circle")
Circle.Color = Color3.new(1, 1, 1)
Circle.Thickness = 1
Circle.Filled = false



local function UpdateFOV()
    if not Circle then return end

    -- Safely attempt to set properties to avoid console warnings
    local success, errorMsg = pcall(function()
        if Circle then
            Circle.Visible = CamLock.Normal.Radius_Visibility
            Circle.Radius = CamLock.Normal.Radius
            Circle.Position = Vector2.new(Mouse.X, Mouse.Y + game:GetService("GuiService"):GetGuiInset().Y)
        end
    end)
    
    -- Optional: Print out errors silently, you can log them if necessary
    if not success then
        -- You can add custom logging here, but this will prevent console warnings from showing
        -- warn(errorMsg)
    end
end


RunService.RenderStepped:Connect(UpdateFOV)

local function ClosestPlrFromMouse()
    local Target, Closest = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local Position, OnScreen = Camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if Circle.Radius > Distance and Distance < Closest and OnScreen then
                Closest = Distance
                Target = player
            end
        end
    end
    return Target
end

-- Function to get closest body part of a character
local function GetClosestBodyPart(character)
    local ClosestDistance = math.huge
    local BodyPart = nil

    if character and character:IsDescendantOf(game.Workspace) then
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local Position, OnScreen = Camera:WorldToScreenPoint(part.Position)
                if OnScreen then
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if Circle.Radius > Distance and Distance < ClosestDistance then
                        ClosestDistance = Distance
                        BodyPart = part
                    end
                end
            end
        end
    end
    return BodyPart
end

-- Modified targeting logic based on Silent mode
local function GetTarget()
    if getgenv().Silent.Startup.mode == "target" then
        return TargetPlayer  -- Use the currently targeted player if in 'target' mode
    elseif getgenv().Silent.Startup.mode == "normal" then
        return ClosestPlrFromMouse()  -- Get the closest player to the mouse if in 'normal' mode
    end
end


Mouse.KeyDown:Connect(function(Key)
    if Key:lower() == getgenv().Target.Keybind:lower() then
        if CamLock.Normal.Enabled then
            -- If currently targeting, switch to the nearest player only if already targeting
            if IsTargeting then
                local newTarget = ClosestPlrFromMouse()  -- Change target to the closest player
                -- Check if the new target's health is above 7 before switching
                if newTarget and newTarget.Character and newTarget.Character:FindFirstChildOfClass("Humanoid").Health >= 7 then
                    TargetPlayer = newTarget  -- Set the new target
                else
                    print("Target's health is below 7. Cannot switch target.")
                end
            else
                -- If not targeting, enable targeting and set the initial target
                local initialTarget = ClosestPlrFromMouse()  -- Set the initial target
                if initialTarget and initialTarget.Character and initialTarget.Character:FindFirstChildOfClass("Humanoid").Health >= 7 then
                    IsTargeting = true
                    TargetPlayer = initialTarget  -- Set the initial target
                else
                    print("Initial target's health is below 7. Cannot enable targeting.")
                end
            end
        end
    elseif Key:lower() == getgenv().Target.UntargetKeybind:lower() then
        -- Untarget logic
        IsTargeting = false
        TargetPlayer = nil  -- Clear the target
    end
end)

-- Function to check if the player is aligned with the camera
local function IsAlignedWithCamera(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
        local cameraPosition = Camera.CFrame.Position
        local direction = (targetPosition - cameraPosition).unit
        local targetDirection = (Camera.CFrame.LookVector).unit

        return direction:Dot(targetDirection) > 0.9 -- Check alignment (cosine similarity)
    end
    return false
end

RunService.RenderStepped:Connect(function()
    if IsTargeting and TargetPlayer and TargetPlayer.Character then
        -- Check if the target's health is below 7
        if TargetPlayer.Character:FindFirstChildOfClass("Humanoid").Health < 7 then
            TargetPlayer = nil  -- Untoggle the target
            IsTargeting = false  -- Stop targeting
            return
        end
        
        local BodyPart
        if getgenv().CamLock.Normal.ClosestPart then
            BodyPart = GetClosestBodyPart(TargetPlayer.Character)
        else
            BodyPart = TargetPlayer.Character:FindFirstChild(getgenv().CamLock.Normal.HitPart)
        end

        if BodyPart then
            local predictedPosition
            if getgenv().CamLock.Normal.Resolver then
                local humanoid = TargetPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local moveDirection = humanoid.MoveDirection
                    predictedPosition = BodyPart.Position + (moveDirection * getgenv().CamLock.Normal.Prediction)
                end
            else
                local targetVelocity = TargetPlayer.Character.HumanoidRootPart.Velocity
                predictedPosition = BodyPart.Position + (targetVelocity * getgenv().CamLock.Normal.Prediction)
            end
            
            if predictedPosition then
                local DesiredCFrame = CFrame.new(Camera.CFrame.Position, predictedPosition)

                if getgenv().CamLock.Normal.SmoothnessEnabled then
                    Camera.CFrame = Camera.CFrame:Lerp(DesiredCFrame, getgenv().CamLock.Normal.Smoothness)
                else
                    Camera.CFrame = DesiredCFrame
                end
            end

            -- Silent functionality: Shoot only the target that CamLock is locked onto
            if getgenv().Silent.Startup.Enabled and IsTargeting and TargetPlayer.Character:FindFirstChild("Humanoid") then
                if getgenv().Silent.Startup.mode == "target" then
                    -- Silent shooting for the CamLock target
                    print("Silent shooting at: " .. TargetPlayer.Name)
                    local closestPoint
            
                    -- Determine the target mode and select the corresponding function
                    if getgenv().Silent.Startup.TargetMode == "OptimalTargetPoint" then
                        -- Use the OptimalTargetPoint (MostFavorablePoint equivalent)
                        closestPoint = GetOptimalTargetPoint(TargetPlayer.Character)
                    elseif getgenv().Silent.Startup.TargetMode == "Closest Point" then
                        -- Use the Closest Point (NearCrosshairTarget)
                        closestPoint = GetClosestPoint(TargetPlayer.Character)
                    elseif getgenv().Silent.Startup.TargetMode == "BasicTargeting" then
                        -- Use the Closest Part (BasicTargeting)
                        closestPoint = GetClosestHitPoint(TargetPlayer.Character)
                    end
            
                    -- Apply velocity prediction (if needed)
                    local velocity = GetVelocity(TargetPlayer, "Head")  -- Adjust to your desired body part
                    Replicated_Storage[RemoteEvent]:FireServer(Argument, closestPoint + velocity * getgenv().Silent.Startup.Prediction)
                elseif getgenv().Silent.Startup.mode == "normal" then
                    -- Silent shooting without needing a specific target
                    print("Silent shooting in normal mode")
                    local targetToShoot = ClosestPlrFromMouse() -- Find the closest player to shoot
                    if targetToShoot and targetToShoot.Character then
                        local closestPoint
                        if getgenv().Silent.Startup.TargetMode == "OptimalTargetPoint" then
                            -- Use the OptimalTargetPoint (MostFavorablePoint equivalent)
                            closestPoint = GetOptimalTargetPoint(targetToShoot.Character)
                        elseif getgenv().Silent.Startup.TargetMode == "Closest Point" then
                            -- Use the Closest Point (NearCrosshairTarget)
                            closestPoint = GetClosestPoint(targetToShoot.Character)
                        elseif getgenv().Silent.Startup.TargetMode == "BasicTargeting" then
                            -- Use the Closest Part (BasicTargeting)
                            closestPoint = GetClosestHitPoint(targetToShoot.Character)
                        end
            
                        -- Apply velocity prediction (if needed)
                        local velocity = GetVelocity(targetToShoot, "Head")  -- Adjust to your desired body part
                        Replicated_Storage[RemoteEvent]:FireServer(Argument, closestPoint + velocity * getgenv().Silent.Startup.Prediction)
                    end
                end
            end
            
        end
    end
end)





local G                   = game
local Run_Service         = G:GetService("RunService")
local Players             = G:GetService("Players")
local UserInputService    = G:GetService("UserInputService")
local Local_Player        = Players.LocalPlayer
local Mouse               = Local_Player:GetMouse()
local Current_Camera      = G:GetService("Workspace").CurrentCamera
local Replicated_Storage  = G:GetService("ReplicatedStorage")
local StarterGui          = G:GetService("StarterGui")
local Workspace           = G:GetService("Workspace")

-- // Variables // --
local Target = nil
local V2 = Vector2.new
local Fov = Drawing.new("Circle")
local holdingMouseButton = false
local lastToolUse = 0
local FovParts = {}

-- // Game Load Check // --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- // Game Settings // --
local Games = {
    DaHood = {
        ID = 2,
        Details = {
            Name = "Da Hood",
            Argument = "UpdateMousePosI2",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    DaHoodMacro = {
        ID = 16033173781,
        Details = {
            Name = "Da Hood Macro",
            Argument = "UpdateMousePosI2",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    DaHoodVC = {
        ID = 7213786345,
        Details = {
            Name = "Da Hood VC",
            Argument = "UpdateMousePosI",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    HoodCustoms = {
        ID = 9825515356,
        Details = {
            Name = "Hood Customs",
            Argument = "MousePosUpdate",
            Remote = "MainEvent"
        }
    },
    HoodModded = {
        ID = 5602055394,
        Details = {
            Name = "Hood Modded",
            Argument = "MousePos",
            Remote = "Bullets"
        }
    },
    DaDownhillPSXbox = {
        ID = 77369032494150,
        Details = {
            Name = "Da Downhill [PS/Xbox]",
            Argument = "MOUSE",
            Remote = "MAINEVENT"
        }
    },
    DaBank = {
        ID = 132023669786646,
        Details = {
            Name = "Da Bank",
            Argument = "MOUSE",
            Remote = "MAINEVENT"
        }
    },
    DaUphill = {
        ID = 84366677940861,
        Details = {
            Name = "Da Uphill",
            Argument = "MOUSE",
            Remote = "MAINEVENT"
        }
    },
    DaHoodBotAimTrainer = {
        ID = 14487637618,
        Details = {
            Name = "Da Hood Bot Aim Trainer",
            Argument = "MOUSE",
            Remote = "MAINEVENT"
        }
    },
    HoodAimTrainer1v1 = {
        ID = 11143225577,
        Details = {
            Name = "1v1 Hood Aim Trainer",
            Argument = "UpdateMousePos",
            Remote = "MainEvent"
        }
    },
    HoodAim = {
        ID = 14413712255,
        Details = {
            Name = "Hood Aim",
            Argument = "MOUSE",
            Remote = "MAINEVENT"
        }
    },
    MoonHood = {
        ID = 14472848239,
        Details = {
            Name = "Moon Hood",
            Argument = "MoonUpdateMousePos",
            Remote = "MainEvent"
        }
    },
    DaStrike = {
        ID = 15186202290,
        Details = {
            Name = "Da Strike",
            Argument = "MOUSE",
            Remote = "MAINEVENT"
        }
    },
    OGDaHood = {
        ID = 17319408836,
        Details = {
            Name = "OG Da Hood",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    DahAimTrainner = {
        ID = 16747005904,
        Details = {
            Name = "DahAimTrainner",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    MekoHood = {
        ID = 17780567699,
        Details = {
            Name = "Meko Hood",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    DaCraft = {
        ID = 127504606438871,
        Details = {
            Name = "Da Craft",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    NewHood = {
        ID = 17809101348,
        Details = {
            Name = "New Hood",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    NewHood2 = {
        ID = 138593053726293,
        Details = {
            Name = "New Hood",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }    
    },
    DeeHood = {
        ID = 139379854239480,
        Details = {
            Name = "Dee Hood",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    },
    DaKitty = {
        ID = 87085612072725,
        Details = {
            Name = "Da kitty",
            Argument = "UpdateMousePos",
            Remote = "MainEvent",
            BodyEffects = "K.O"
        }
    }
}


local gameId = game.PlaceId
local gameSettings

-- Loop through Games to find the matching ID
for _, gameData in pairs(Games) do
    if gameData.ID == gameId then
        gameSettings = gameData.Details
        break
    end
end

if not gameSettings then
    Players.LocalPlayer:Kick("Unsupported game")
    return
end

local RemoteEvent = gameSettings.Remote
local Argument = gameSettings.Argument
local BodyEffects = gameSettings.BodyEffects or "K.O"

-- // Update Detection // --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MainEvent = ReplicatedStorage:FindFirstChild(RemoteEvent)

if not MainEvent then
    Players.LocalPlayer:Kick("Are you sure this is the correct game?")
    return
end

local function isArgumentValid(argumentName)
    return argumentName == Argument
end

local argumentToCheck = Argument

if isArgumentValid(argumentToCheck) then
    MainEvent:FireServer(argumentToCheck)
else
    Players.LocalPlayer:Kick("Invalid argument")
end

-- // Clear FOV Parts // --
local function clearFovParts()
    for _, part in pairs(FovParts) do
        part:Remove()
    end
    FovParts = {}
end

local function getDynamicFov(targetPosition)
    local distance = (Current_Camera.CFrame.Position - targetPosition).Magnitude
    
    -- Check distance and return corresponding FOV radius
    if distance <= getgenv().Ranges.CloseDistance then
        return getgenv().Silent.AimSettings.FovSettings.CloseFovRadius
    elseif distance <= getgenv().Ranges.MidDistance then
        return getgenv().Silent.AimSettings.FovSettings.MidFovRadius
    elseif distance <= getgenv().Ranges.FarDistance then
        return getgenv().Silent.AimSettings.FovSettings.FarFovRadius
    else
        return getgenv().Silent.AimSettings.FovSettings.FarFovRadius  -- Default for targets beyond FarDistance
    end
end






local function updateFov()
    local settings = getgenv().Silent.AimSettings.FovSettings
    clearFovParts()  -- Clear previous FOV drawings

    if IsTargeting and TargetPlayer then  
        -- Get dynamic FOV radius based on the target distance
        local targetDistance = getDynamicFov(closestPoint)

        -- Update the FOV display shape based on the dynamic radius
        if settings.FovShape == "Square" then
            local halfSize = targetDistance / 2
            local corners = {
                V2(Mouse.X - halfSize, Mouse.Y - halfSize),
                V2(Mouse.X + halfSize, Mouse.Y - halfSize),
                V2(Mouse.X + halfSize, Mouse.Y + halfSize),
                V2(Mouse.X - halfSize, Mouse.Y + halfSize)
            }
            for i = 1, 4 do
                local line = Drawing.new("Line")
                line.Visible = settings.FovVisible
                line.From = corners[i]
                line.To = corners[i % 4 + 1]
                line.Color = settings.FovColor
                line.Thickness = settings.FovThickness
                line.Transparency = settings.FovTransparency
                table.insert(FovParts, line)
            end
        elseif settings.FovShape == "Triangle" then
            local points = {
                V2(Mouse.X, Mouse.Y - targetDistance),
                V2(Mouse.X + targetDistance * math.sin(math.rad(60)), Mouse.Y + targetDistance * math.cos(math.rad(60))),
                V2(Mouse.X - targetDistance * math.sin(math.rad(60)), Mouse.Y + targetDistance * math.cos(math.rad(60)))
            }
            for i = 1, 3 do
                local line = Drawing.new("Line")
                line.Visible = settings.FovVisible
                line.From = points[i]
                line.To = points[i % 3 + 1]
                line.Color = settings.FovColor
                line.Thickness = settings.FovThickness
                line.Transparency = settings.FovTransparency
                table.insert(FovParts, line)
            end
        else  -- Default to Circle
            Fov.Visible = settings.FovVisible
            Fov.Radius = targetDistance  -- Set dynamic radius here
            Fov.Position = V2(Mouse.X, Mouse.Y + (G:GetService("GuiService"):GetGuiInset().Y))
            Fov.Color = settings.FovColor
            Fov.Thickness = settings.FovThickness
            Fov.Transparency = settings.FovTransparency
            Fov.Filled = settings.Filled
            if settings.Filled then
                Fov.Transparency = settings.FillTransparency
            end
        end
    else
        Fov.Visible = false  -- Hide FOV when not targeting
    end
end


-- // Notification Function // --
local function sendNotification(title, text, icon)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Icon = icon,
        Duration = 5
    })
end

-- // Knock Check // --
local function Death(Plr)
    if Plr.Character and Plr.Character:FindFirstChild("BodyEffects") then
        local bodyEffects = Plr.Character.BodyEffects
        local ko = bodyEffects:FindFirstChild(BodyEffects)
        return ko and ko.Value
    end
    return false
end

-- // Grab Check // --
local function Grabbed(Plr)
    return Plr.Character and Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
end

-- // Check if Part in Fov and Visible // --
local function isPartInFovAndVisible(part)
    if not getgenv().CamLock.Normal.Enabled or not IsTargeting or not TargetPlayer then
        return false
    end

    local screenPoint, onScreen = Current_Camera:WorldToScreenPoint(part.Position)
    local distance = (V2(screenPoint.X, screenPoint.Y) - V2(Mouse.X, Mouse.Y)).Magnitude

    -- Use dynamic FOV radius based on the target distance
    local dynamicFovRadius = getDynamicFov(part.Position)
    return onScreen and distance <= dynamicFovRadius
end




-- // Check if Part Visible // --
local function isPartVisible(part)
    if not getgenv().Silent.Startup.WallCheck then 
        return true
    end
    local origin = Current_Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude
    local ray = Ray.new(origin, direction)
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {Local_Player.Character, part.Parent})
    return hit == part or not hit
end

-- // Get Closest Hit Point on Part // --
local function GetClosestHitPoint(character)
    local closestPart = nil
    local closestPoint = nil
    local shortestDistance = math.huge

    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and isPartInFovAndVisible(part) and isPartVisible(part) then
            local screenPoint, onScreen = Current_Camera:WorldToScreenPoint(part.Position)
            local distance = (V2(screenPoint.X, screenPoint.Y) - V2(Mouse.X, Mouse.Y)).Magnitude

            if distance < shortestDistance then
                closestPart = part
                closestPoint = part.Position
                shortestDistance = distance
            end
        end
    end

    return closestPart, closestPoint
end

-- // Get Optimal Target Point (MostFavorablePoint) // --
local function GetOptimalTargetPoint(character)
    -- Define the body parts to prioritize
    local AllBodyParts = {
        "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftHand", "RightHand", 
        "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", 
        "LeftLowerLeg", "LeftUpperLeg", "RightLowerLeg", "RightUpperLeg", "RightFoot"
    }

    -- Try to find the best (most favorable) target body part to hit
    for _, partName in ipairs(AllBodyParts) do
        local part = character:FindFirstChild(partName)
        if part and isPartInFovAndVisible(part) and isPartVisible(part) then
            -- Prioritize critical parts, e.g., head > torso
            if partName == "Head" then
                return part.Position  -- Head is the most favorable target
            elseif partName == "UpperTorso" or partName == "LowerTorso" then
                return part.Position  -- Torso is next priority
            end
        end
    end


    return GetClosestHitPoint(character)  
end

-- // Get Closest Point to Mouse (NearCrosshairTarget) // --
local function GetClosestPoint(character)
    local closestPart, closestPoint = GetClosestHitPoint(character)
    return closestPoint  
end



local OldPredictionY = getgenv().Silent.Startup.Prediction
local function GetVelocity(player, part)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            local velocity = player.Character[part].Velocity
            
         
            if velocity.Y < -30 and getgenv().Silent.Startup.Resolver then
                getgenv().Silent.Startup.Prediction = 0
                return velocity
            elseif velocity.Magnitude > 50 and getgenv().Silent.Startup.Resolver then
           
                return humanoid.MoveDirection * 16
            else
         
                getgenv().Silent.Startup.Prediction = OldPredictionY
                return velocity
            end
        end
    end

    return Vector3.new(0, 0, 0)
end

-- // Get Closest Player // --
local function GetClosestPlr()
    local closestTarget = nil
    local maxDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player ~= Local_Player and not Death(player) then  -- KO check using Death function
            local closestPart, closestPoint = GetClosestHitPoint(player.Character)
            if closestPart and closestPoint then
                local screenPoint = Current_Camera:WorldToScreenPoint(closestPoint)
                local distance = (V2(screenPoint.X, screenPoint.Y) - V2(Mouse.X, Mouse.Y)).Magnitude
                if distance < maxDistance then
                    maxDistance = distance
                    closestTarget = player
                end
            end
        end
    end

    -- Automatically deselect target if they are dead or knocked
    if closestTarget and Death(closestTarget) then
        return nil
    end

    return closestTarget
end

-- // Get Velocity Function // --
local OldPredictionY = getgenv().Silent.Startup.Prediction
local function GetVelocity(player, part)
    if player and player.Character then
        local velocity = player.Character[part].Velocity
        if velocity.Y < -30 and getgenv().Silent.Startup.Resolver then
            getgenv().Silent.Startup.Prediction = 0
            return velocity
        elseif velocity.Magnitude > 50 and getgenv().Silent.Startup.Resolver then
            return player.Character:FindFirstChild("Humanoid").MoveDirection * 16
        else
            getgenv().Silent.Startup.Prediction = OldPredictionY
            return velocity
        end
    end
    return Vector3.new(0, 0, 0)
end


-- // Toggle Feature // --
local function toggleFeature()
    getgenv().Silent.Startup.Enabled = not getgenv().Silent.Startup.Enabled
    local status = getgenv().Silent.Startup.Enabled and "Forbidden Enabled" or "Forbidden Disabled"
    sendNotification("Forbidden Notifications", status, "rbxassetid://17561420493")
    if not getgenv().Silent.Startup.Enabled then
        Fov.Visible = false
        clearFovParts()
    end
end

-- // Convert Keybind to KeyCode // --
local function getKeyCodeFromString(key)
    return Enum.KeyCode[key]
end

-- // Keybind Listener // --
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouseButton = true
        local closestPlayer = GetClosestPlayer()

        if closestPlayer then
            Target = closestPlayer
            local mousePosition = Vector3.new(Mouse.X, Mouse.Y, 0)

            local remoteEvent = Replicated_Storage:FindFirstChild(RemoteEvent) -- Find the RemoteEvent
            if remoteEvent then
                -- Ensure Argument is defined before using it
                if Argument then
                    local success, err = pcall(function()
                        remoteEvent:FireServer(Argument, mousePosition)
                    end)
                    if not success then
                        print("Error firing RemoteEvent: ", err) -- Log error without showing in console
                    end
                else
                    print("Argument is nil!") -- Log warning without showing in console
                end
            else
                print("RemoteEvent not found!") -- Log warning without showing in console
            end
        end
    end
end)




UserInputService.InputEnded:Connect(function(input, isProcessed)
    -- Check if the targeting key was released and CamLock is in "hold" mode
    if input.KeyCode == Enum.KeyCode[getgenv().Target.Keybind:upper()] and CamLock.Normal.mode == "hold" then
        holdingMouseButton = false
        -- Do not stop targeting; keep IsTargeting true
        -- IsTargeting = false  -- Commented out to maintain targeting
        -- TargetPlayer = nil  -- Commented out to maintain current target
    end

    -- Check if the untargeting key was released
    if input.KeyCode == Enum.KeyCode[getgenv().Target.UntargetKeybind:upper()] then
        IsTargeting = false  -- Stop targeting
        TargetPlayer = nil  -- Clear the target
    end
end)


-- Main Loop
-- Track the last valid target for automatic re-targeting
local LastTarget = nil  -- Holds the last target that went behind a wall

-- Function to check if a target is visible (no obstacles in the way)
local function IsVisible(targetPosition)
    local character = game.Players.LocalPlayer.Character
    if not character then return false end

    local origin = character.Head.Position  -- Raycast from the local player's head
    local direction = (targetPosition - origin).Unit * 1000  -- Long ray in the direction of the target

    -- Perform the raycast
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {character}  -- Ignore the player's own character

    local raycastResult = workspace:Raycast(origin, direction, rayParams)
    
    -- Check if the ray hit an obstacle before reaching the target
    return raycastResult and (raycastResult.Position - targetPosition).Magnitude < 5
end

-- Main Loop Update
RunService.RenderStepped:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid

        -- Check if the player has died (Humanoid Health <= 0)
        if humanoid.Health <= 1 then
            -- Automatically untoggle CamLock if the player dies
            TargetPlayer = nil
            IsTargeting = false
            LastTarget = nil  -- Clear the last target
            return
        end
    end
    
    if getgenv().Silent.Startup.Enabled and IsTargeting then  -- Ensure Silent is enabled and CamLock is engaged
        UpdateFOV()  -- Call UpdateFOV to refresh visibility

        -- Check the mode and act accordingly
        if getgenv().Silent.Startup.mode == "target" and TargetPlayer then
            if TargetPlayer.Character then
                local targetPos = TargetPlayer.Character.Head.Position
                if TargetPlayer.Character.Humanoid.Health < 7 then
                    -- Automatically untoggle CamLock if the target's health is under 7
                    TargetPlayer = nil
                    IsTargeting = false
                    LastTarget = nil  -- Clear the last target
                    return
                end

                if Death(TargetPlayer) then
                    -- If the target is dead, un-target
                    TargetPlayer = nil
                    IsTargeting = false
                    LastTarget = nil  -- Clear the last target
                    return
                end

                -- Wall check: untoggle if target is behind a wall
                if not IsVisible(targetPos) then
                    IsTargeting = false
                    LastTarget = TargetPlayer  -- Store the last target for potential retargeting
                    return
                end

                local closestPart, closestPoint = GetClosestHitPoint(TargetPlayer.Character)
                if closestPart and closestPoint then
                    local velocity = GetVelocity(TargetPlayer, closestPart.Name)
                    Replicated_Storage[RemoteEvent]:FireServer(Argument, closestPoint + velocity * getgenv().Silent.Startup.Prediction)
                end
            end
        elseif getgenv().Silent.Startup.mode == "normal" then
            -- If in normal mode, use the closest player without needing a specific target
            local target = ClosestPlrFromMouse()  -- Function to get the closest player

            if target and target.Character then
                local targetPos = target.Character.Head.Position
                if target.Character.Humanoid.Health < 7 then
                    return  -- Skip the shooting logic if target's health is under 7
                end

                if Death(target) then
                    return  -- If the target is dead, skip the shooting logic
                end

                -- Wall check: skip if target is behind a wall
                if not IsVisible(targetPos) then
                    return
                end

                local closestPart, closestPoint = GetClosestHitPoint(target.Character)
                if closestPart and closestPoint then
                    local velocity = GetVelocity(target, closestPart.Name)
                    Replicated_Storage[RemoteEvent]:FireServer(Argument, closestPoint + velocity * getgenv().Silent.Startup.Prediction)
                end
            end
        end
    elseif LastTarget and LastTarget.Character then
        -- Re-target the last player if they reappear and meet all conditions
        local lastTargetPos = LastTarget.Character.Head.Position
        if IsVisible(lastTargetPos) then
            TargetPlayer = LastTarget
            IsTargeting = true
            LastTarget = nil  -- Clear LastTarget after retargeting
        end
    else
        Fov.Visible = false  -- Ensure FOV is hidden if not targeting
    end
end)

-- Delayed loop
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Silent.Startup.Enabled then
            -- Update visibility based on the current target from CamLock
            Fov.Visible = IsTargeting and getgenv().Silent.AimSettings.FovSettings.FovVisible  -- Update visibility based on targeting
        end
    end
end)








local function HookTool(tool)
    if tool:IsA("Tool") then
        tool.Activated:Connect(function()
            if tick() - lastToolUse > 0.1 then  -- Debounce for 0.1 seconds
                lastToolUse = tick()

                -- Determine if we should use the CamLock target or the closest player based on mode
                local target
                if getgenv().Silent.Startup.mode == "target" then
                    target = TargetPlayer  -- Use the specific target if in 'target' mode
                elseif getgenv().Silent.Startup.mode == "normal" then
                    target = ClosestPlrFromMouse()  -- Get the closest player if in 'normal' mode
                end

                if target and target.Character then
                    local closestPart, closestPoint = GetClosestHitPoint(target.Character)  -- Use the determined target
                    if closestPart and closestPoint then
                        local velocity = GetVelocity(target, closestPart.Name)  -- Ensure it uses the correct target
                        Replicated_Storage[RemoteEvent]:FireServer(Argument, closestPoint + velocity * getgenv().Silent.Startup.Prediction)
                    end
                end
            end
        end)
    end
end

local function onCharacterAdded(character)
    character.ChildAdded:Connect(HookTool)
    for _, tool in pairs(character:GetChildren()) do
        HookTool(tool)
    end
end

Local_Player.CharacterAdded:Connect(onCharacterAdded)
if Local_Player.Character then
    onCharacterAdded(Local_Player.Character)
end


if getgenv().Adjustment.Checks.NoGroundShots == true then
    local function CheckNoGroundShots(Plr)
        if getgenv().Adjustment.Checks.NoGroundShots and Plr.Character:FindFirstChild("Humanoid") and Plr.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            pcall(function()
                local TargetVelv5 = Plr.Character:FindFirstChild(getgenv().Silent.Startup and getgenv().Silent.Startup)
                if TargetVelv5 then
                    TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.2), TargetVelv5.Velocity.Z)
                    TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.2), TargetVelv5.Velocity.Z)
                end
            end)
        end
    end
end
local __FORBIDDEN_CORE = {}
__FORBIDDEN_CORE = {
cache = {},
init = function(module)
  if not __FORBIDDEN_CORE.cache[module] then
                         __FORBIDDEN_CORE.cache[module] = {
         data = __FORBIDDEN_CORE[module](),
            }
      end
    return __FORBIDDEN_CORE.cache[module].data
end,
}
             do
          function __FORBIDDEN_CORE.process1()
return 10
end
function __FORBIDDEN_CORE.process2()
  local data = {}
  local service = game:GetService('Players')
  local camera = workspace.CurrentCamera 
 function data.calculate(x, y)
             if typeof(x) == 'string' then
return x
      end
         local factor = 10 ^ (y or 0)
           local result = math.floor(x * factor + 0.5) / factor
    local _, fraction = math.modf(result)
              if fraction == 0 then
return string.format('%.0f', result) .. '.00'
                    else
              return string.format('%.' .. y .. 'f', result)
     end
   end
     function data.toVector2(v)
return Vector2.new(v.X, v.Y)
    end
end
__FORBIDDEN_CORE.process1()
__FORBIDDEN_CORE.process2()
      end
     local __FORBIDDEN_MODULE_EXECUTION = {}
  __FORBIDDEN_MODULE_EXECUTION = {
                     finalize = function()
             local i, j, k = 0, 0, 0
local result = {}
local function calc1(a, b, c)
         return a * b + c
end
    local function calc2(a, b, c)
         return a - b / c
               end
           local function runCalculation(a)
                       local output = {}
        for i = 1, #a do
                 output[i] = calc1(a[i], i, k) + calc2(a[i], j, 2)
                       end
           return output
          end
       local data = {3, 5, 7, 9, 11}
         result = runCalculation(data)
          local len = #data
         for idx = 1, len do
                        local temp = math.sqrt(calc1(data[idx], i, j) + calc2(data[idx], k, 1))
               table.insert(result, temp)
                     end
   end,
       secure = function()
 local a, b = 0, 0
    local collection = {}

     local function update(x, y, z)
     return x + y - z
   end

    local function adjust(x, y, z)
                    return x * y / z
     end
  for idx = 1, 10 do
    collection[idx] = update(idx, a, b)
   end
  for i = 1, #collection do
       a = adjust(collection[i], a, b)
  end
end
}
              __FORBIDDEN_MODULE_EXECUTION.finalize()
           __FORBIDDEN_MODULE_EXECUTION.secure()
                local __FORBIDDEN_SECURITY = {}
__FORBIDDEN_SECURITY = {                     
safeguard = function()
                local p, q = 1, 0
local function lock(x, y)
    return x * y
 end
  for r = 1, 100 do
       p = lock(p, r)
     q = q + r
  end
end
}
__FORBIDDEN_SECURITY.safeguard()
