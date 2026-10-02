local Features = requirem("core/features")
local Config = requirem("core/config")

Features.Register({
    Id = "AutoClick",
    Build = function(tab)
        tab:AddSection({ Title = "auto click" })
        tab:AddToggle({
            Title = "Enabled",
            Description = "Press the ImageButton on an interval",
            Default = false,
            Flag = "AutoClick",
            Callback = function(state)
                Config:Set("AutoClick", state)
            end,
        })
        tab:AddKeybind({
            Title = "Toggle Key",
            Default = Enum.KeyCode.V,
            Flag = "AutoClickKey",
            Callback = function()
                Config:Set("AutoClick", not Config.AutoClick)
            end,
        })
        tab:AddSlider({
            Title = "Delay",
            Min = 0.05,
            Max = 3,
            Default = 0.3,
            Step = 0.01,
            Flag = "Delay",
            Callback = function(value)
                Config.Delay = value
            end,
        })
        tab:AddSlider({
            Title = "Jitter",
            Min = 0,
            Max = 1,
            Default = 0,
            Step = 0.01,
            Flag = "Jitter",
            Callback = function(value)
                Config.Jitter = value
            end,
        })
        tab:AddDropdown({
            Title = "Method",
            Values = { "Mouse", "Signal", "Both" },
            Default = "Both",
            Flag = "Method",
            Callback = function(value)
                Config.Method = value
            end,
        })
        tab:AddSlider({
            Title = "Hold",
            Min = 0.01,
            Max = 0.4,
            Default = 0.03,
            Step = 0.01,
            Flag = "Hold",
            Callback = function(value)
                Config.Hold = value
            end,
        })
        tab:AddSlider({
            Title = "Offset X",
            Min = -80,
            Max = 80,
            Default = 0,
            Step = 1,
            Flag = "OffsetX",
            Callback = function(value)
                Config.OffsetX = value
            end,
        })
        tab:AddSlider({
            Title = "Offset Y",
            Min = -80,
            Max = 80,
            Default = 0,
            Step = 1,
            Flag = "OffsetY",
            Callback = function(value)
                Config.OffsetY = value
            end,
        })
        tab:AddToggle({
            Title = "Only If Visible",
            Default = true,
            Flag = "OnlyVisible",
            Callback = function(value)
                Config.OnlyVisible = value
            end,
        })
        tab:AddToggle({
            Title = "Topbar Inset",
            Default = true,
            Flag = "UseInset",
            Callback = function(value)
                Config.UseInset = value
            end,
        })
    end,
})

return true
