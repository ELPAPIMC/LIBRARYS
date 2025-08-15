-- AkunDisco GUI - Fixed Version
-- Compatible with most Roblox executors

-- Instances:
local AkunDiscoUI = Instance.new("ScreenGui")
local KeyMain = Instance.new("Frame")
local VerifyButton = Instance.new("TextButton")
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
local TeleportBack = Instance.new("TextButton")
local UICorner_8 = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")
local AkundiscoDeco_2 = Instance.new("ImageLabel")
local UICorner_9 = Instance.new("UICorner")
local AkunDiscoREWORKED = Instance.new("TextLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

-- Properties:
AkunDiscoUI.Name = "AkunDiscoUI"
AkunDiscoUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
AkunDiscoUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AkunDiscoUI.ResetOnSpawn = false

KeyMain.Name = "KeyMain"
KeyMain.Parent = AkunDiscoUI
KeyMain.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
KeyMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
KeyMain.BorderSizePixel = 0
KeyMain.Position = UDim2.new(0.298636913, 0, 0.258264452, 0)
KeyMain.Size = UDim2.new(0.401486993, 0, 0.48140496, 0)

VerifyButton.Name = "VerifyButton"
VerifyButton.Parent = KeyMain
VerifyButton.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
VerifyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
VerifyButton.BorderSizePixel = 0
VerifyButton.Position = UDim2.new(0.0303388648, 0, 0.660944223, 0)
VerifyButton.Size = UDim2.new(0.946340799, 0, 0.223175973, 0)
VerifyButton.Font = Enum.Font.Highway
VerifyButton.Text = "VERIFY"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.TextScaled = true
VerifyButton.TextSize = 14.000
VerifyButton.TextStrokeColor3 = Color3.fromRGB(255, 255, 127)
VerifyButton.TextWrapped = true

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = VerifyButton

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
KeyInput.PlaceholderText = "Enter Key Here..."
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
AkundiscoMain.Parent = AkunDiscoUI
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
Options.ScrollBarThickness = 6

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

TeleportBack.Name = "Teleport Back"
TeleportBack.Parent = Options
TeleportBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TeleportBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
TeleportBack.BorderSizePixel = 0
TeleportBack.Position = UDim2.new(0.0502512567, 0, 0.0223070309, 0)
TeleportBack.Size = UDim2.new(0, 353, 0, 60)
TeleportBack.Font = Enum.Font.Highway
TeleportBack.Text = "Teleport Back [BETA]"
TeleportBack.TextColor3 = Color3.fromRGB(0, 0, 0)
TeleportBack.TextScaled = true
TeleportBack.TextSize = 14.000
TeleportBack.TextWrapped = true

UICorner_8.CornerRadius = UDim.new(0, 14)
UICorner_8.Parent = TeleportBack

UIListLayout.Parent = Options
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)

AkundiscoDeco_2.Name = "AkundiscoDeco"
AkundiscoDeco_2.Parent = AkundiscoMain
AkundiscoDeco_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AkundiscoDeco_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
AkundiscoDeco_2.BorderSizePixel = 0
AkundiscoDeco_2.Position = UDim2.new(0.0501858741, 0, 0.0604795255, 0)
AkundiscoDeco_2.Size = UDim2.new(0.135593221, 0, 0.158097297, 0)
AkundiscoDeco_2.Image = "rbxassetid://139595360558140"

UICorner_9.CornerRadius = UDim.new(0, 1000000000)
UICorner_9.Parent = AkundiscoDeco_2

AkunDiscoREWORKED.Name = "AkunDisco[REWORKED]"
AkunDiscoREWORKED.Parent = AkundiscoMain
AkunDiscoREWORKED.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AkunDiscoREWORKED.BackgroundTransparency = 1.000
AkunDiscoREWORKED.BorderColor3 = Color3.fromRGB(0, 0, 0)
AkunDiscoREWORKED.BorderSizePixel = 0
AkunDiscoREWORKED.Position = UDim2.new(0.0371747203, 0, 0.295302004, 0)
AkunDiscoREWORKED.Size = UDim2.new(0, 71, 0, 177)
AkunDiscoREWORKED.Font = Enum.Font.Highway
AkunDiscoREWORKED.Text = "SOON"
AkunDiscoREWORKED.TextColor3 = Color3.fromRGB(255, 255, 255)
AkunDiscoREWORKED.TextScaled = true
AkunDiscoREWORKED.TextSize = 14.000
AkunDiscoREWORKED.TextWrapped = true

UIAspectRatioConstraint.Parent = AkundiscoMain
UIAspectRatioConstraint.AspectRatio = 1.204

-- Scripts:

-- Main Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Ensure GUI is properly parented
if AkunDiscoUI.Parent ~= PlayerGui then
	AkunDiscoUI.Parent = PlayerGui
end

-- Set your correct key here
local CorrectKey = "AkunDiscoIsTheBestScriptEverNiggaWikiAlSaloHow"

-- Store the original size for restoring after tween
local originalSize = KeyMain.Size
local shrinkSize = UDim2.new(originalSize.X.Scale * 0.8, 0, originalSize.Y.Scale * 0.8, 0)

-- Verification Script
VerifyButton.MouseButton1Click:Connect(function()
	local inputText = KeyInput.Text

	if inputText == CorrectKey then
		KeyInput.Text = "Valid Key"
		VerifyButton.TextColor3 = Color3.fromRGB(85, 255, 127)
		print("Valid Key - Access Granted")

		-- Tween animation for successful verification
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local shrinkTween = TweenService:Create(KeyMain, tweenInfo, {Size = shrinkSize})

		shrinkTween:Play()
		shrinkTween.Completed:Connect(function()
			local restoreTween = TweenService:Create(KeyMain, tweenInfo, {Size = originalSize})
			restoreTween:Play()

			-- Wait a bit then show main GUI
			wait(0.3)
			KeyMain.Visible = false
			AkundiscoMain.Visible = true
		end)
	else
		KeyInput.Text = "Invalid Key"
		VerifyButton.TextColor3 = Color3.fromRGB(255, 85, 127)
		print("Invalid Key - Access Denied")

		-- Clear the text after a short delay
		wait(1)
		KeyInput.Text = ""
	end
end)

-- Teleport Up Script
TeleportUp.MouseButton1Click:Connect(function()
	local character = LocalPlayer.Character
	if character then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			-- Teleport 50 studs up
			humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 50, 0)
			print("Teleported up!")
		else
			warn("HumanoidRootPart not found!")
		end
	else
		warn("Character not found!")
	end
end)

-- Teleport Back Script
TeleportBack.MouseButton1Click:Connect(function()
	local character = LocalPlayer.Character
	if character then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			-- Teleport 50 studs down
			humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, -50, 0)
			print("Teleported back!")
		else
			warn("HumanoidRootPart not found!")
		end
	else
		warn("Character not found!")
	end
end)

-- Add dragging functionality to KeyMain
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart = nil
local startPos = nil

KeyMain.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = KeyMain.Position
	end
end)

KeyMain.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		KeyMain.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

KeyMain.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Add dragging functionality to AkundiscoMain
local draggingMain = false
local dragStartMain = nil
local startPosMain = nil

AkundiscoMain.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMain = true
		dragStartMain = input.Position
		startPosMain = AkundiscoMain.Position
	end
end)

AkundiscoMain.InputChanged:Connect(function(input)
	if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStartMain
		AkundiscoMain.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
	end
end)

AkundiscoMain.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMain = false
	end
end)

print("AkunDisco GUI Loaded Successfully!")
print("Key : BUY FOR LA GRANDE")
