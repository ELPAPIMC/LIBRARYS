-- Gui to Lua
-- Version: 3.2

-- Instances:

local AkunDiscoREWORKED = Instance.new("ScreenGui")
local KeyMain = Instance.new("Frame")
local VerifyKey = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UICorner_2 = Instance.new("UICorner")
local KeyInput = Instance.new("TextBox")
local UICorner_3 = Instance.new("UICorner")
local Deco = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local AkundiscoDeco = Instance.new("ImageLabel")
local UICorner_4 = Instance.new("UICorner")
local Deco_2 = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Deco_3 = Instance.new("TextLabel")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
local AkundiscoMain = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local Options = Instance.new("ScrollingFrame")
local UICorner_6 = Instance.new("UICorner")
local TeleportUp = Instance.new("TextButton")
local UICorner_7 = Instance.new("UICorner")
local AkundiscoDeco_2 = Instance.new("ImageLabel")
local UICorner_8 = Instance.new("UICorner")
local SOON = Instance.new("TextLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

--Properties:

AkunDiscoREWORKED.Name = "AkunDisco[REWORKED]"
AkunDiscoREWORKED.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
AkunDiscoREWORKED.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

KeyMain.Name = "KeyMain"
KeyMain.Parent = AkunDiscoREWORKED
KeyMain.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
KeyMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeyMain.BorderSizePixel = 0
KeyMain.Position = UDim2.new(0.298636913, 0, 0.258264452, 0)
KeyMain.Size = UDim2.new(0.401486993, 0, 0.48140496, 0)

VerifyKey.Name = "VerifyKey"
VerifyKey.Parent = KeyMain
VerifyKey.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
VerifyKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
VerifyKey.BorderSizePixel = 0
VerifyKey.Position = UDim2.new(0.0303388648, 0, 0.660944223, 0)
VerifyKey.Size = UDim2.new(0.946340799, 0, 0.223175973, 0)
VerifyKey.Font = Enum.Font.Highway
VerifyKey.Text = "VERIFY"
VerifyKey.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyKey.TextScaled = true
VerifyKey.TextSize = 14.000
VerifyKey.TextStrokeColor3 = Color3.fromRGB(255, 255, 127)
VerifyKey.TextWrapped = true

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = VerifyKey

UICorner_2.CornerRadius = UDim.new(0, 12)
UICorner_2.Parent = KeyMain

KeyInput.Name = "KeyInput"
KeyInput.Parent = KeyMain
KeyInput.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
KeyInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeyInput.BorderSizePixel = 0
KeyInput.Position = UDim2.new(0.0340667814, 0, 0.201716736, 0)
KeyInput.Size = UDim2.new(0.927743077, 0, 0.296137333, 0)
KeyInput.Font = Enum.Font.Highway
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextScaled = true
KeyInput.TextSize = 14.000
KeyInput.TextWrapped = true

UICorner_3.CornerRadius = UDim.new(0, 24)
UICorner_3.Parent = KeyInput

Deco.Name = "Deco"
Deco.Parent = KeyMain
Deco.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Deco.BackgroundTransparency = 1.000
Deco.BorderColor3 = Color3.fromRGB(0, 0, 0)
Deco.BorderSizePixel = 0
Deco.Position = UDim2.new(0.280864209, 0, -0.2918455, 0)
Deco.Size = UDim2.new(0, 252, 0, 68)
Deco.Font = Enum.Font.Code
Deco.Text = "AkunDisco "
Deco.TextColor3 = Color3.fromRGB(0, 0, 0)
Deco.TextScaled = true
Deco.TextSize = 14.000
Deco.TextWrapped = true

UITextSizeConstraint.Parent = Deco
UITextSizeConstraint.MaxTextSize = 58

AkundiscoDeco.Name = "AkundiscoDeco"
AkundiscoDeco.Parent = KeyMain
AkundiscoDeco.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AkundiscoDeco.BorderColor3 = Color3.fromRGB(0, 0, 0)
AkundiscoDeco.BorderSizePixel = 0
AkundiscoDeco.Position = UDim2.new(0, 0, -0.317596555, 0)
AkundiscoDeco.Size = UDim2.new(0.225151718, 0, 0.266094416, 0)
AkundiscoDeco.Image = "rbxassetid://139595360558140"

UICorner_4.CornerRadius = UDim.new(0, 1000000000)
UICorner_4.Parent = AkundiscoDeco

Deco_2.Name = "Deco"
Deco_2.Parent = KeyMain
Deco_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Deco_2.BackgroundTransparency = 1.000
Deco_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Deco_2.BorderSizePixel = 0
Deco_2.Position = UDim2.new(-0.0493827164, 0, 1.02575111, 0)
Deco_2.Size = UDim2.new(0, 359, 0, 20)
Deco_2.Font = Enum.Font.Michroma
Deco_2.Text = "BUY KEY FOR LA GRANDE OR 10M+ BRAINROT"
Deco_2.TextColor3 = Color3.fromRGB(0, 0, 0)
Deco_2.TextScaled = true
Deco_2.TextSize = 14.000
Deco_2.TextWrapped = true

UITextSizeConstraint_2.Parent = Deco_2
UITextSizeConstraint_2.MaxTextSize = 15

Deco_3.Name = "Deco"
Deco_3.Parent = KeyMain
Deco_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Deco_3.BackgroundTransparency = 1.000
Deco_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Deco_3.BorderSizePixel = 0
Deco_3.Position = UDim2.new(0.648148119, 0, -0.2918455, 0)
Deco_3.Size = UDim2.new(0, 148, 0, 28)
Deco_3.Font = Enum.Font.IndieFlower
Deco_3.Text = "REWORKED"
Deco_3.TextColor3 = Color3.fromRGB(255, 255, 127)
Deco_3.TextScaled = true
Deco_3.TextSize = 14.000
Deco_3.TextWrapped = true

UITextSizeConstraint_3.Parent = Deco_3
UITextSizeConstraint_3.MaxTextSize = 28

AkundiscoMain.Name = "AkundiscoMain"
AkundiscoMain.Parent = AkunDiscoREWORKED
AkundiscoMain.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
AkundiscoMain.BackgroundTransparency = 0.300
AkundiscoMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
AkundiscoMain.BorderSizePixel = 0
AkundiscoMain.Position = UDim2.new(0.166047081, 0, 0.0371900834, 0)
AkundiscoMain.Size = UDim2.new(0.666666687, 0, 0.923553705, 0)
AkundiscoMain.Visible = false

UICorner_5.CornerRadius = UDim.new(0, 26)
UICorner_5.Parent = AkundiscoMain

Options.Name = "Options"
Options.Parent = AkundiscoMain
Options.Active = true
Options.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Options.BackgroundTransparency = 0.300
Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
Options.BorderSizePixel = 0
Options.Position = UDim2.new(0.215885267, 0, 0.033066161, 0)
Options.Size = UDim2.new(0.765427828, 0, 0.931900561, 0)

UICorner_6.CornerRadius = UDim.new(0, 26)
UICorner_6.Parent = Options

TeleportUp.Name = "Teleport Up"
TeleportUp.Parent = Options
TeleportUp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TeleportUp.BorderColor3 = Color3.fromRGB(0, 0, 0)
TeleportUp.BorderSizePixel = 0
TeleportUp.Position = UDim2.new(0.0502512567, 0, 0.0223070309, 0)
TeleportUp.Size = UDim2.new(0, 353, 0, 60)
TeleportUp.Font = Enum.Font.Highway
TeleportUp.Text = "Teleport Up [BETA]"
TeleportUp.TextColor3 = Color3.fromRGB(0, 0, 0)
TeleportUp.TextScaled = true
TeleportUp.TextSize = 14.000
TeleportUp.TextWrapped = true

UICorner_7.CornerRadius = UDim.new(0, 14)
UICorner_7.Parent = TeleportUp

AkundiscoDeco_2.Name = "AkundiscoDeco"
AkundiscoDeco_2.Parent = AkundiscoMain
AkundiscoDeco_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AkundiscoDeco_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
AkundiscoDeco_2.BorderSizePixel = 0
AkundiscoDeco_2.Position = UDim2.new(0.0501858741, 0, 0.0604795255, 0)
AkundiscoDeco_2.Size = UDim2.new(0.135593221, 0, 0.158097297, 0)
AkundiscoDeco_2.Image = "rbxassetid://139595360558140"

UICorner_8.CornerRadius = UDim.new(0, 1000000000)
UICorner_8.Parent = AkundiscoDeco_2

SOON.Name = "SOON"
SOON.Parent = AkundiscoMain
SOON.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SOON.BackgroundTransparency = 1.000
SOON.BorderColor3 = Color3.fromRGB(0, 0, 0)
SOON.BorderSizePixel = 0
SOON.Position = UDim2.new(0.0371747203, 0, 0.295302004, 0)
SOON.Size = UDim2.new(0, 71, 0, 177)
SOON.Font = Enum.Font.Highway
SOON.Text = "SOON"
SOON.TextColor3 = Color3.fromRGB(255, 255, 255)
SOON.TextScaled = true
SOON.TextSize = 14.000
SOON.TextWrapped = true

UIAspectRatioConstraint.Parent = AkundiscoMain
UIAspectRatioConstraint.AspectRatio = 1.204

-- Scripts:

local function KAYQHL_fake_script() -- VerifyKey.VerifyScript 
	local script = Instance.new('LocalScript', VerifyKey)

	local Akundisco = script.Parent.Parent.Parent
	
	local KeyMain = Akundisco:FindFirstChild("KeyMain")
	local KeyInput = KeyMain:FindFirstChild("KeyInput")
	local VerifyKey = KeyMain:FindFirstChild("VerifyKey")
	local TweenService = game:GetService("TweenService")
	local AkundiscoMain = Akundisco:FindFirstChild("AkundiscoMain")
	
	-- Set your correct key here
	local CorrectKey = "AkunDiscoIsTheBestScriptEverNiggaWikiAlSaloHow"
	
	-- Store the original size for restoring after tween
	local originalSize = KeyMain.Size
	local shrinkSize = UDim2.new(originalSize.X.Scale * 0.8, 0, originalSize.Y.Scale * 0.8, 0) -- Shrink to 80%
	
	VerifyKey.MouseButton1Click:Connect(function()
	    if KeyInput.Text == CorrectKey then
	        KeyInput.Text = "Valid Key"
	        VerifyKey.TextColor3 = Color3.fromRGB(85, 255, 127)
	        print("Valid Key")
	        
	        -- Tween to shrink KeyMain inward
	        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	        local shrinkTween = TweenService:Create(KeyMain, tweenInfo, {Size = shrinkSize})
	        shrinkTween:Play()
	        shrinkTween.Completed:Connect(function()
	            -- Tween back to original size for bounce effect
	            local restoreTween = TweenService:Create(KeyMain, tweenInfo, {Size = originalSize})
	            restoreTween:Play()
			end)
			wait(0.3)
			KeyMain.Visible = false
			AkundiscoMain.Visible = true
	    else
	        KeyInput.Text = "Invalid Key"
	        VerifyKey.TextColor3 = Color3.fromRGB(255, 85, 127)
	        print("Invalid Key")
	    end
	end)
	
	
end
coroutine.wrap(KAYQHL_fake_script)()
local function SBBIZGN_fake_script() -- AkunDiscoREWORKED.ScriptMain 
	local script = Instance.new('LocalScript', AkunDiscoREWORKED)

	local AkunDisco = script.Parent
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	
	AkunDisco.Parent = PlayerGui
	
	
end
coroutine.wrap(SBBIZGN_fake_script)()
local function JTSFQUS_fake_script() -- TeleportUp.LocalScript 
	local script = Instance.new('LocalScript', TeleportUp)

	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = Players.LocalPlayer
	
	local button = script.Parent
	
	local TELEPORT_OFFSET = Vector3.new(0, 50, 0) -- Move up by 50 studs
	local TWEEN_TIME = 0.6
	
	local teleportState = false -- false = down, true = up
	local originalPosition = nil
	
	local function createEffect(position)
	    local effect = Instance.new("ParticleEmitter")
	    effect.Texture = "rbxassetid://243098098" -- Sparkle texture, can be changed
	    effect.Lifetime = NumberRange.new(0.3)
	    effect.Rate = 100
	    effect.Speed = NumberRange.new(10)
	    effect.Size = NumberSequence.new(1)
	    effect.Parent = nil
	
	    local part = Instance.new("Part")
	    part.Anchored = true
	    part.CanCollide = false
	    part.Transparency = 1
	    part.Size = Vector3.new(1,1,1)
	    part.CFrame = CFrame.new(position)
	    part.Parent = workspace
	
	    effect.Parent = part
	    effect:Emit(30)
	
	    game:GetService("Debris"):AddItem(part, 0.5)
	end
	
	button.MouseButton1Click:Connect(function()
	    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	    if not character then return end
	
	    local humanoid = character:FindFirstChildOfClass("Humanoid")
	    if not humanoid or humanoid.SeatPart then return end -- Don't teleport if seated
	
	    local root = character:FindFirstChild("HumanoidRootPart")
	    if not root then return end
	
	    if not teleportState then
	        -- Teleport up
	        originalPosition = root.Position
	        local endPos = originalPosition + TELEPORT_OFFSET
	
	        createEffect(originalPosition)
	
	        local tween = TweenService:Create(root, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = endPos})
	        tween:Play()
	        tween.Completed:Connect(function()
	            createEffect(endPos)
	        end)
	
	        teleportState = true
	        button.Text = "Teleport Down"
	    else
	        -- Teleport down
	        if originalPosition then
	            local currentPos = root.Position
	            createEffect(currentPos)
	
	            local tween = TweenService:Create(root, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = originalPosition})
	            tween:Play()
	            tween.Completed:Connect(function()
	                createEffect(originalPosition)
	            end)
	        end
	
	        teleportState = false
	        button.Text = "Teleport Up"
	    end
	end)
end
