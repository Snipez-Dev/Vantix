local VantixPVPUI6 = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Snipez-Dev/Vantix/refs/heads/main/VantixPVPUI6"
))()

local Window = VantixPVPUI6:Window({
    Name = "Vantix",
    Color = Color3.fromRGB(255, 128, 64),
    Size = UDim2.new(0, 496, 0, 496),
})

local Tab = Window:Tab({ Name = "Legit" })

Tab:Divider({ Text = "Aimbot", Side = "Left" })

local aimEnabled = Tab:Toggle({
    Name = "Aimbot",
    Side = "Left",
    Flag = "aim_enabled",
    Value = false,
    Callback = function(state)
        workspace:SetAttribute("VantixAimbotEnabled", state)
    end,
})

local aimFov = Tab:Slider({
    Name = "FOV",
    Side = "Left",
    Flag = "aim_fov",
    Min = 10,
    Max = 200,
    Value = 90,
    Unit = "px",
    Callback = function(value)
        workspace:SetAttribute("VantixAimbotFOV", value)
    end,
})

Tab:Keybind({
    Name = "Aim Key",
    Side = "Left",
    Flag = "aim_key",
    Value = "LeftAlt",
    Callback = function(state, key)
        aimEnabled:ChangeValue(state)
    end,
})

Tab:Colorpicker({
    Name = "FOV Color",
    Side = "Left",
    Flag = "aim_fov_color",
    Callback = function(color)
        workspace:SetAttribute("VantixAimbotFOVColor", color)
    end,
})

local Section = Tab:Section({ Name = "Visuals", Side = "Right" })

Section:Toggle({
    Name = "ESP",
    Flag = "esp_enabled",
    Value = false,
    Callback = function(state)
        workspace:SetAttribute("VantixESPEnabled", state)
    end,
})

local espParts = Section:Dropdown({
    Name = "ESP Part",
    Flag = "esp_part",
    List = {
        { Name = "Head", Mode = "Toggle", Value = true, Callback = function() end },
        { Name = "HumanoidRootPart", Mode = "Toggle", Value = false, Callback = function() end },
    },
})

Section:Textbox({
    Name = "Config Name",
    Flag = "config_name",
    Placeholder = "profile1",
    Callback = function(text)
        Window:SaveConfig("Vantix", text)
    end,
})

Section:Button({
    Name = "Unload",
    Callback = function()
        Window:SetEnabled(false)
    end,
})

VantixPVPUI6:Notification({
    Title = "Vantix",
    Description = "Loaded — " .. #Window.Elements .. " elements registered.",
    Duration = 4,
})
