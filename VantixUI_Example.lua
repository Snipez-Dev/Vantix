local url = "https://raw.githubusercontent.com/Snipez-Dev/Vantix/refs/heads/main/VantixUI6"

local VantixUI = loadstring(game:HttpGet(url))()

local Window = VantixUI:CreateWindow({
	Title       = "Showcase",
	Theme       = "Vantix",
	AccentColor = Color3.fromRGB(255, 255, 255),
	LogoID      = 110034487018208,
	Size        = {820, 480},
})

Window:CreateTag("Beta",    Color3.fromRGB(240, 100, 100), nil, "flask-conical")
Window:CreateTag("Premium", Color3.fromRGB(255, 180, 50),  nil, "crown")
Window:CreateTag("v2.0",    Color3.fromRGB(60, 120, 210),  nil, "git-branch")
Window:CreateTag("discord.gg/GUXhJuaqsF", Color3.fromRGB(88, 101, 242), nil, nil, true)

Window:Notify({
	Title    = "Welcome",
	Text     = "Library loaded successfully!",
	Icon     = "check",
	Duration = 4,
})

local Flags = {}
local Panel, QuickBar, accentRow, minRow, keyRow, qFpsRow, qPingRow
local lastPing = "n/a"

local function toHex(c)
	return string.format("#%02X%02X%02X", math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
end

local MainTab = Window:AddTab("Main", "house")

MainTab:AddLabel("Welcome to the Vantix Showcase", "info")
MainTab:AddSeparator()

local console = MainTab:AddConsole({ Title = "Activity Log", Height = 110 })
console:Write("Showcase loaded")

local godmode = MainTab:AddToggle({
	Title    = "God Mode",
	Subtitle = "Become invincible",
	Icon     = "shield",
	Default  = false,
	Risky    = "Manipulating MaxHealth is flagged by some anti-cheats within seconds — only enable on servers you trust.",
	Tooltip  = "Some anti-cheats flag health manipulation",
	Callback = function(state)
		Flags.GodMode = state
		local char = game.Players.LocalPlayer.Character
		local hum  = char and char:FindFirstChild("Humanoid")
		if hum then
			hum.MaxHealth = state and math.huge or 100
			hum.Health = hum.MaxHealth
		end
		console:Write("God Mode "..(state and "enabled" or "disabled"))
		Window:Notify({
			Title    = "God Mode",
			Text     = state and "Enabled" or "Disabled",
			Icon     = state and "shield-check" or "shield-off",
			Duration = 2,
		})
	end,
})

local autoFarm = MainTab:AddToggle({
	Title    = "Auto Farm",
	Subtitle = "Automatically collects nearby items",
	Icon     = "flask-conical",
	Default  = false,
	Beta     = "Still being tuned against the newer item spawn tables — may miss items or grab the wrong ones.",
	Tooltip  = "Still being tuned, may miss items or behave inconsistently",
	Callback = function(state)
		Flags.AutoFarm = state
		console:Write("Auto Farm "..(state and "enabled" or "disabled"))
		Window:Notify({
			Title    = "Auto Farm",
			Text     = state and "Enabled" or "Disabled",
			Icon     = state and "flask-conical" or "flask",
			Duration = 2,
		})
	end,
})

local walkspeed = MainTab:AddSlider({
	Title    = "Walk Speed",
	Icon     = "activity",
	Min      = 16,
	Max      = 200,
	Default  = 16,
	Tooltip  = "Applies instantly to your character",
	Callback = function(value)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = value
		end
	end,
})

MainTab:AddButton({
	Title    = "Custom Button Label",
	Subtitle = "The button on the right says 'Press Me'",
	Icon     = "mouse-pointer",
	Text     = "Press Me",
	Tooltip  = "Fires Window:Notify as a demo",
	Callback = function()
		console:Write("Custom button pressed")
		Window:Notify({Title="Pressed", Text="You pressed the custom button!"})
	end,
})

MainTab:AddButton({
	Title    = "Rebuild Item Cache",
	Subtitle = "Rescans the workspace for farmable items",
	Icon     = "refresh-cw",
	Text     = "Rebuild",
	Beta     = true,
	Tooltip  = "New scan logic, hasn't been tested on every map yet",
	Callback = function()
		console:Write("Item cache rebuilt")
		Window:Notify({Title="Item Cache", Text="Rebuilt", Duration=2})
	end,
})

MainTab:AddSeparator()

MainTab:AddToggleKey({
	Title    = "UI Toggle Key",
	Subtitle = "Rebinds the hotkey that hides/shows the window",
	Icon     = "keyboard",
})

MainTab:AddButton({
	Title    = "Reset Toggle Key",
	Subtitle = "Window:SetToggleKey / Window:GetToggleKey",
	Icon     = "rotate-ccw",
	Text     = "Reset",
	Callback = function()
		Window:SetToggleKey(Enum.KeyCode.RightShift)
		Window:Notify({Title="Toggle Key", Text="Reset to "..Window:GetToggleKey().Name, Duration=2})
	end,
})

local VisualsTab = Window:AddTab("Visuals", "eye")

local espColor = VisualsTab:AddColorPicker({
	Title    = "ESP Color",
	Subtitle = "Pick a color for player ESP",
	Icon     = "palette",
	Default  = Color3.fromRGB(255, 0, 0),
	Tooltip  = "Used to color ESP boxes and name tags",
	Callback = function(color)
		Flags.ESPColor = color
	end,
})

VisualsTab:AddSeparator()

local materialDropdown = VisualsTab:AddDropdown({
	Title   = "Chams Material",
	Icon    = "box",
	Options = {
		"ForceField", "Neon", "Plastic", "Glass",
		"Wood", "Metal", "Ice", "Slate",
		"Marble", "Granite", "Sand", "Fabric",
		"Grass", "Cobblestone", "Brick", "Foil"
	},
	Default  = 1,
	Tooltip  = "Applied to the chams overlay Material property",
	Callback = function(selected)
		Flags.ChamsMaterial = selected
	end,
})

VisualsTab:AddSeparator()

local espElements = VisualsTab:AddMultiDropdown({
	Title    = "ESP Elements",
	Subtitle = "Toggle individual ESP visual elements",
	Icon     = "layers",
	Options  = {"Names", "Boxes", "Bones", "Chams", "Tools", "Snaplines"},
	Default  = {"Names", "Boxes"},
	Callback = function(selected)
		Flags.ESPElements = selected
	end,
})

VisualsTab:AddSeparator()

VisualsTab:AddKeybind({
	Title    = "Toggle ESP",
	Subtitle = "Press to flip ESP on/off",
	Icon     = "crosshair",
	Default  = Enum.KeyCode.RightAlt,
	Tooltip  = "Fires every time the key is pressed",
	Callback = function()
		Flags.ESPEnabled = not Flags.ESPEnabled
	end,
})

local SettingsTab = Window:AddTab("Settings", "settings")

local themeNames = {}
for name in pairs(VantixUI.Themes) do
	table.insert(themeNames, name)
end
table.sort(themeNames)

SettingsTab:AddDropdown({
	Title    = "Theme",
	Icon     = "swatch-book",
	Options  = themeNames,
	Default  = Window:GetTheme(),
	Tooltip  = "Window:SetTheme swaps the whole palette live",
	Callback = function(selected)
		Window:SetTheme(selected)
	end,
})

SettingsTab:AddDropdown({
	Title    = "Accent Color",
	Icon     = "droplet",
	Options  = {"White", "Blue", "Red", "Green", "Purple"},
	Default  = "White",
	Tooltip  = "VantixUI:SetAccentColor overrides just the accent",
	Callback = function(selected)
		local colors = {
			White  = Color3.fromRGB(255, 255, 255),
			Blue   = Color3.fromRGB(64, 156, 255),
			Red    = Color3.fromRGB(230, 70, 70),
			Green  = Color3.fromRGB(80, 210, 120),
			Purple = Color3.fromRGB(170, 110, 240),
		}
		VantixUI:SetAccentColor(colors[selected])
		Panel:SetTitle("Live Stats — "..selected)
		accentRow:Set(toHex(VantixUI:GetAccentColor()))
	end,
})

SettingsTab:AddToggle({
	Title    = "Show Stats Panel",
	Subtitle = "Panel:SetVisible",
	Icon     = "gauge",
	Default  = true,
	Callback = function(state)
		Panel:SetVisible(state)
	end,
})

SettingsTab:AddSeparator()

local configName = SettingsTab:AddTextBox({
	Title       = "Configuration Name",
	Icon        = "file-text",
	Placeholder = "Enter config name...",
	Default     = "ShowcaseConfig",
	Tooltip     = "Used as the filename when saving/loading below",
	Callback    = function(text, enterPressed)
		if enterPressed then
			Flags.ConfigName = text
		end
	end,
})

local uiKeybind = SettingsTab:AddKeybind({
	Title    = "Toggle UI Keybind",
	Subtitle = "Press Insert to hide (independent of the window's built-in toggle key)",
	Icon     = "keyboard",
	Default  = Enum.KeyCode.Insert,
	Tooltip  = "Standalone AddKeybind demo, separate from Window's own toggle key",
	Callback = function()
		local parent = game:GetService("CoreGui")
		pcall(function() if typeof(gethui) == "function" then parent = gethui() end end)
		local sg = parent:FindFirstChild("VantixUI")
			or game.Players.LocalPlayer.PlayerGui:FindFirstChild("VantixUI")
		if sg then sg.Enabled = not sg.Enabled end
	end,
})

SettingsTab:AddSeparator()
SettingsTab:AddLabel("Config System", "save")

Window.ConfigManager:SetFolder("VantixUI_Examples")

local function buildConfig(name)
	local cfg = Window.ConfigManager:CreateConfig(name)
	cfg:RegisterElement("GodMode",       godmode)
	cfg:RegisterElement("WalkSpeed",     walkspeed)
	cfg:RegisterElement("ESPColor",      espColor)
	cfg:RegisterElement("ChamsMaterial", materialDropdown)
	cfg:RegisterElement("ESPElements",   espElements)
	cfg:RegisterElement("ConfigName",    configName)
	cfg:RegisterElement("UIKeybind",     uiKeybind)
	return cfg
end

local savedConfigs = SettingsTab:AddDropdown({
	Title    = "Saved Configs",
	Icon     = "folder",
	Options  = Window.ConfigManager:GetConfigs(),
	Tooltip  = "Populated from ConfigManager:GetConfigs()",
})

SettingsTab:AddButton({
	Title    = "Save Config",
	Icon     = "save",
	Text     = "Save",
	Callback = function()
		buildConfig(configName:Get()):Save()
		savedConfigs:SetOptions(Window.ConfigManager:GetConfigs())
		Window:Notify({Title="Config", Text="Saved as "..configName:Get(), Duration=2})
	end,
})

SettingsTab:AddButton({
	Title    = "Load Selected",
	Icon     = "download",
	Text     = "Load",
	Callback = function()
		local name = savedConfigs:Get()
		if name and name ~= "" then
			configName:Set(name)
			buildConfig(name):Load()
			Window:Notify({Title="Config", Text="Loaded "..name, Duration=2})
		end
	end,
})

SettingsTab:AddButton({
	Title    = "Delete Selected",
	Icon     = "trash-2",
	Text     = "Delete",
	Risky    = true,
	Tooltip  = "Permanently deletes the config file",
	Callback = function()
		local name = savedConfigs:Get()
		if name and name ~= "" then
			Window.ConfigManager:DeleteConfig(name)
			savedConfigs:SetOptions(Window.ConfigManager:GetConfigs())
			Window:Notify({Title="Config", Text="Deleted "..name, Duration=2})
		end
	end,
})

SettingsTab:AddSeparator()

SettingsTab:AddButton({
	Title    = "Minimize",
	Icon     = "minus",
	Text     = "Minimize",
	Callback = function() Window:Minimize() end,
})

SettingsTab:AddButton({
	Title    = "Restore",
	Icon     = "square",
	Text     = "Restore",
	Callback = function() Window:Restore() end,
})

SettingsTab:AddButton({
	Title    = "Toggle Window",
	Icon     = "repeat",
	Text     = "Toggle",
	Callback = function() Window:Toggle() end,
})

SettingsTab:AddButton({
	Title    = "Unload",
	Icon     = "log-out",
	Text     = "Unload",
	Callback = function()
		Panel:Destroy()
		QuickBar:Destroy()
		Window:Destroy()
	end,
})

Panel = VantixUI:CreateNewWindow({ Title = "Live Stats — White", Size = {240} })
Panel:AddHeader("Session")
local fpsRow  = Panel:AddRow("FPS")
local pingRow = Panel:AddRow("Ping")
minRow = Panel:AddRow("Minimized")
keyRow = Panel:AddRow("Toggle Key")
Panel:AddSeparator()
Panel:AddHeader("Window")
accentRow = Panel:AddRow("Accent")
accentRow:Set(toHex(VantixUI:GetAccentColor()))
Panel:AddSeparator()
Panel:AddHeader("Player")
local posRow = Panel:AddRow("Position")
Panel:AddRow("Character", {
	Style         = "Vertical",
	AccentKey     = "white",
	ValueColorKey = "text",
}):Set(game.Players.LocalPlayer.Name)
Panel:AddSeparator()
Panel:AddHeader("Actions")
Panel:AddToggle("Show Quick Bar", true, function(on)
	QuickBar:SetVisible(on)
end)
Panel:AddButton("Clear activity log", function()
	console:Clear()
end)

QuickBar = VantixUI:CreateNewWindow({
	Title    = "Quick Bar",
	Layout   = "Horizontal",
	Position = UDim2.new(0, 20, 0, 88),
})
qFpsRow  = QuickBar:AddRow("FPS")
QuickBar:AddSeparator()
qPingRow = QuickBar:AddRow("Ping")
QuickBar:AddSeparator()
QuickBar:AddButton({ Text = "Log ping", Callback = function()
	console:Write("Ping: "..lastPing)
end })

task.spawn(function()
	local RunService = game:GetService("RunService")
	local Stats = game:GetService("Stats")
	local frames, last = 0, os.clock()
	while Panel.Card and Panel.Card.Parent do
		frames += 1
		local now = os.clock()
		if now - last >= 1 then
			fpsRow:Set(frames)
			qFpsRow:Set(frames)
			frames, last = 0, now
		end
		local char = game.Players.LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			local p = root.Position
			posRow:Set(string.format("%d, %d, %d", p.X, p.Y, p.Z))
		end
		local ok, ping = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		if ok then
			lastPing = string.format("%dms", ping)
			pingRow:Set(lastPing)
			qPingRow:Set(lastPing)
		end
		minRow:Set(Window:IsMinimized() and "Yes" or "No")
		local key = Window:GetToggleKey()
		keyRow:Set(key and key.Name or "None")
		RunService.Heartbeat:Wait()
	end
end)
