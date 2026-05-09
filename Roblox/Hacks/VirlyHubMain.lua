local TweenService = game:GetService("TweenService")

local KEY = "KEY_7294AF72972A729732"
local KEY_LINK = "https://direct-link.net/5641438/FU5NcugWNv3I"

local HUB_URL = "https://raw.githubusercontent.com/coder-gpt/CoderGpts-Projets/refs/heads/main/Roblox/Hacks/VirlyHub.lua"

-- =========================================================
-- INTRO GUI
-- =========================================================

local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "VirlyIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://6278672195"
bg.ImageColor3 = Color3.fromRGB(136,0,61)
bg.Parent = gui

local function textLabel(txt)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = txt
	t.TextColor3 = Color3.new(1,1,1)
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextTransparency = 1
	t.Parent = bg
	return t
end

local function tween(obj,props,time)
	TweenService:Create(obj,TweenInfo.new(time),props):Play()
end

-- INTRO
local t1 = textLabel("Introducing....")
tween(t1,{TextTransparency = 0},0.6)
task.wait(2)
tween(t1,{TextTransparency = 1},0.8)
task.wait(1)
t1:Destroy()

local t2 = textLabel("Virly Rework! / Virly HUB")
tween(t2,{TextTransparency = 0},0.6)
task.wait(2)
tween(t2,{TextTransparency = 1},0.8)
task.wait(1)
t2:Destroy()

tween(bg,{ImageTransparency = 1},1)
task.wait(1.2)
gui:Destroy()

-- =========================================================
-- RAYFIELD KEY SYSTEM
-- =========================================================

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Virly Key System",
	LoadingTitle = "Virly Hub",
	LoadingSubtitle = KEY_LINK,
	ConfigurationSaving = {
		Enabled = false
	}
})

local Tab = Window:CreateTab("Key System", 4483362458)

Tab:CreateLabel("Key Link:")
Tab:CreateLabel(KEY_LINK)

local input = ""

Tab:CreateInput({
	Name = "Enter Key",
	PlaceholderText = "KEY_***************",
	RemoveTextAfterFocusLost = false,
	Callback = function(text)
		input = text
	end
})

Tab:CreateButton({
	Name = "Verify Key",
	Callback = function()

		if input == KEY then

			Rayfield:Notify({
				Title = "Virly",
				Content = "Access Granted Loading Hub",
				Duration = 3
			})

			task.wait(1)

			-- close key UI
			Rayfield:Destroy()

			-- load main hub
			loadstring(game:HttpGet(HUB_URL))()

		else

			Rayfield:Notify({
				Title = "Virly",
				Content = "Invalid Key",
				Duration = 3
			})

		end
	end
})
