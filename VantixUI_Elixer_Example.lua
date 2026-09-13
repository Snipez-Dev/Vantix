local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Snipez-Dev/Vantix/refs/heads/main/VantixUI_Elixer"
))({ cheatname = 'ExampleHub', gamename = 'ExampleGame' })
library:init()

local Players = game:GetService("Players")

local Window = library:Window({ name = 'Example | elixer' })
local tabMain = Window:AddTab('Main')
local tabVisuals = Window:AddTab('Visuals')
local tabConfig = Window:AddTab('Config')

local state = { speed = 16, esp = false, target = 'Head', armed = false, color = Color3.fromRGB(255, 80, 80), webhook = '' }

local main = tabMain:AddSection('Player', 1)
main:AddLabel({ text = 'every element is a handle with Get, Set and Remove' })
main:AddSlider({ text = 'Walk Speed', flag = 'speed', min = 8, max = 120, value = 16, increment = 1,
    tooltip = 'Studs per second',
    callback = function(v)
        state.speed = v
        local character = Players.LocalPlayer and Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass('Humanoid')
        if humanoid then humanoid.WalkSpeed = v end
    end })
main:AddToggle({ text = 'Enable Feature', flag = 'feature_on', state = false, callback = function(v) state.esp = v end })
main:AddList({ text = 'Target Part', flag = 'target_part', values = { 'Head', 'HumanoidRootPart', 'UpperTorso' },
    selected = 'Head', callback = function(v) state.target = v end })
main:AddBind({ text = 'Activation Key', flag = 'feature_key', bind = 'none', mode = 'hold', nomouse = false,
    tooltip = 'Any keyboard key or mouse button - hold it to arm. None = always active',
    Indicator = 'Example Feature', State = function() return state.esp end,
    callback = function(held) state.armed = held end,
    OnBind = function(key) state.key = key end })
main:AddButton({ text = 'Reset Colour', confirm = true, callback = function()
    state.color = Color3.fromRGB(255, 80, 80)
    library:SendNotification('Colour reset', 3, Color3.fromRGB(80, 200, 120))
end })

local visuals = tabVisuals:AddSection('Appearance', 1)
visuals:AddColor({ text = 'Highlight Colour', flag = 'highlight', color = state.color,
    callback = function(c) state.color = c end })
visuals:AddBox({ text = 'Webhook', flag = 'webhook', placeholder = 'https://discord.com/api/webhooks/...',
    callback = function(text) state.webhook = text end })
visuals:AddSeparator({ text = 'Read only' })
visuals:AddText({ text = 'Text blocks wrap and take a Height.', height = 30 })
visuals:AddSlider({ text = 'Transparency', flag = 'alpha', min = 0, max = 1, value = 0.2, increment = 0.05,
    suffix = '', callback = function(v) state.alpha = v end })

local cfg = tabConfig:AddSection('Config', 1)
cfg:AddLabel({ text = 'Saved to cheatname/gamename/configs/<name>.json', offset = 16 })
cfg:AddButton({ text = 'Key Indicators', callback = function()
    library:SetIndicatorsVisible(not library.indicatorsVisible)
end })

library:CreateSettingsTab(Window)
library:SendNotification('Example loaded', 4, Color3.fromRGB(80, 200, 120))