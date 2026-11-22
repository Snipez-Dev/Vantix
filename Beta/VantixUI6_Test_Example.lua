local VantixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Snipez-Dev/Vantix/refs/heads/main/Beta/VantixUI6_Test"))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local Window = VantixUI:CreateWindow({
	Title = "Beta Test",
	Theme = "Vantix",
	Size = {820, 480},
})
Window:CreateTag("Beta", Color3.fromRGB(240, 100, 100), nil, "flask-conical")

local log

local function hum()
	return LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
end

local Main = Window:AddTab("Main", "house")
Main:AddLabel("Movement", "activity")
Main:AddSeparator()

local speed = Main:AddToggle({
	Title = "Speed Boost",
	Subtitle = "Three dots on the right set a key",
	Icon = "zap",
	Callback = function(on)
		local h = hum()
		if h then h.WalkSpeed = on and 50 or 16 end
		log:Write("Speed Boost " .. (on and "on" or "off"))
	end,
})

local sprint = Main:AddToggle({
	Title = "Sprint",
	Subtitle = "Preset: hold LeftShift",
	Icon = "wind",
	Keybind = Enum.KeyCode.LeftShift,
	KeyMode = "Hold",
	Callback = function(on)
		local h = hum()
		if h then h.WalkSpeed = on and 30 or 16 end
	end,
})

local fly = Main:AddToggle({
	Title = "Fly",
	Subtitle = "Preset: F",
	Icon = "feather",
	Keybind = Enum.KeyCode.F,
	Callback = function(on) log:Write("Fly " .. (on and "on" or "off")) end,
})

Main:AddToggle({
	Title = "Noclip",
	Subtitle = "Risky toggles ask first, by key too",
	Icon = "ghost",
	Risky = true,
	Callback = function(on) log:Write("Noclip " .. (on and "on" or "off")) end,
})

Main:AddToggle({
	Title = "No Key Menu",
	Subtitle = "Keybind = false hides the dots",
	Icon = "circle-off",
	Keybind = false,
})

Main:AddSlider({Title = "Jump Power", Icon = "arrow-up", Min = 50, Max = 200, Default = 50})
Main:AddSeparator()
log = Main:AddConsole({Title = "Log", Height = 90})

local Visuals = Window:AddTab("Visuals", "eye")
Visuals:AddLabel("Player ESP", "eye")
Visuals:AddSeparator()
local esp = Visuals:AddToggle({Title = "ESP", Subtitle = "Boxes and names", Icon = "scan", Keybind = Enum.KeyCode.G})
Visuals:AddToggle({Title = "Tracers", Icon = "move-up-right"})
Visuals:AddToggle({Title = "Chams", Icon = "box"})
Visuals:AddColorPicker({Title = "ESP Color", Icon = "palette", Default = Color3.fromRGB(255, 80, 80)})
Visuals:AddDropdown({Title = "Chams Material", Icon = "layers", Options = {"ForceField", "Neon", "Glass"}})

local Settings = Window:AddTab("Settings", "settings")
Settings:AddToggleKey({Title = "UI Toggle Key"})
Window.ConfigManager:SetFolder("VantixUI_BetaTest")

local function cfg()
	local c = Window.ConfigManager:CreateConfig("default")
	c:RegisterElement("Speed", speed)
	c:RegisterElement("SpeedKey", speed.Keybind)
	c:RegisterElement("FlyKey", fly.Keybind)
	c:RegisterElement("SprintKey", sprint.Keybind)
	c:RegisterElement("EspKey", esp.Keybind)
	return c
end

Settings:AddButton({Title = "Save Config", Icon = "save", Text = "Save", Callback = function()
	cfg():Save()
	Window:Notify({Title = "Config", Text = "Saved", Duration = 2})
end})
Settings:AddButton({Title = "Load Config", Icon = "download", Text = "Load", Callback = function()
	cfg():Load()
	Window:Notify({Title = "Config", Text = "Loaded", Duration = 2})
end})
