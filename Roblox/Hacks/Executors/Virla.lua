local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "VExecutor"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- blur
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- floating V button
local button = Instance.new("Frame")
button.Size = UDim2.new(0, 60, 0, 60)
button.Position = UDim2.new(0.1, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.Active = true
button.Parent = gui

local bCorner = Instance.new("UICorner")
bCorner.CornerRadius = UDim.new(1, 0)
bCorner.Parent = button

local vText = Instance.new("TextLabel")
vText.Size = UDim2.new(1, 0, 1, 0)
vText.BackgroundTransparency = 1
vText.Text = "V"
vText.TextColor3 = Color3.fromRGB(255, 255, 255)
vText.TextScaled = true
vText.Parent = button

-- main window (NO purple background)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 300)
main.Position = UDim2.new(0.5, -250, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Visible = false
main.Parent = gui

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 15)
mCorner.Parent = main

-- textbox
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.9, 0, 0.65, 0)
box.Position = UDim2.new(0.05, 0, 0.1, 0)
box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.PlaceholderText = "Script here...."
box.Text = ""
box.MultiLine = true
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.Parent = main

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 10)
boxCorner.Parent = box

-- execute
local exec = Instance.new("TextButton")
exec.Size = UDim2.new(0.4, 0, 0, 40)
exec.Position = UDim2.new(0.05, 0, 0.8, 0)
exec.Text = "Execute"
exec.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
exec.TextColor3 = Color3.fromRGB(255,255,255)
exec.Parent = main

local eCorner = Instance.new("UICorner")
eCorner.CornerRadius = UDim.new(0, 10)
eCorner.Parent = exec

-- clear
local clear = Instance.new("TextButton")
clear.Size = UDim2.new(0.4, 0, 0, 40)
clear.Position = UDim2.new(0.55, 0, 0.8, 0)
clear.Text = "Clear"
clear.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
clear.TextColor3 = Color3.fromRGB(255,255,255)
clear.Parent = main

local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0, 10)
cCorner.Parent = clear

-- close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Parent = main

local xCorner = Instance.new("UICorner")
xCorner.CornerRadius = UDim.new(1, 0)
xCorner.Parent = close

-- open
button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		button.Visible = false
		main.Visible = true

		TweenService:Create(blur, TweenInfo.new(0.2), {
			Size = 24
		}):Play()
	end
end)

-- close
close.MouseButton1Click:Connect(function()
	main.Visible = false
	button.Visible = true

	TweenService:Create(blur, TweenInfo.new(0.2), {
		Size = 0
	}):Play()
end)

-- clear
clear.MouseButton1Click:Connect(function()
	box.Text = ""
end)

-- execute
exec.MouseButton1Click:Connect(function()
	local f = loadstring(box.Text)
	if f then pcall(f) end
end)

-- drag
local dragging = false
local dragStart
local startPos
local dragInput

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = button.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		button.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
