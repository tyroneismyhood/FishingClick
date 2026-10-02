local Features = requirem("core/features")
local Config = requirem("core/config")

Features.Register({
    Id = "Home",
    Tab = { Title = "Home", Icon = "home" },
    Build = function(tab, ctx)
        tab:AddParagraph({
            Title = "Fishing hub",
            Content = "Each system has its own tab. Master must be on or nothing runs. Potions and fruits are wired in the menu only until the use logic is added.",
        })
        tab:AddSection({ Title = "run" })
        tab:AddToggle({
            Title = "Master",
            Description = "Turns every feature loop off without clearing settings",
            Default = true,
            Flag = "Master",
            Callback = function(state)
                Config:Set("Master", state)
                ctx.Notify("Master", state and "On" or "Off", state and "Success" or "Info")
            end,
        })
        tab:AddToggle({
            Title = "Notifications",
            Default = true,
            Flag = "Notify",
            Callback = function(state)
                Config.Notify = state
            end,
        })
        tab:AddSection({ Title = "look" })
        tab:AddDropdown({
            Title = "Theme",
            Values = { "Default", "Pitch", "Light", "Ocean", "Sunset", "Mono" },
            Default = "Default",
            Flag = "Theme",
            Callback = function(value)
                Config.Theme = value
                ctx.EZ:SetTheme(value)
            end,
        })
        tab:AddColorPicker({
            Title = "Accent",
            Default = Color3.fromRGB(16, 185, 129),
            Flag = "Accent",
            Callback = function(color)
                ctx.EZ:SetAccent(color)
            end,
        })
        tab:AddSlider({
            Title = "Transparency",
            Min = 0,
            Max = 0.9,
            Default = 0,
            Step = 0.05,
            Flag = "Transparency",
            Callback = function(value)
                ctx.Window:SetTransparency(value)
            end,
        })
    end,
})

return true
