local function bindClick(tab, Config, keys)
    tab:AddDropdown({
        Title = "Click Method",
        Description = "Mouse clicks the button center. Signal fires the click events.",
        Values = { "Mouse", "Signal", "Both" },
        Default = Config[keys.Method],
        Flag = keys.Method,
        Callback = function(value)
            Config[keys.Method] = value
        end,
    })
    tab:AddSlider({
        Title = "Delay",
        Min = 0.05,
        Max = 3,
        Default = Config[keys.Delay],
        Step = 0.01,
        Flag = keys.Delay,
        Callback = function(value)
            Config[keys.Delay] = value
        end,
    })
    if keys.Jitter then
        tab:AddSlider({
            Title = "Jitter",
            Description = "Random extra wait so the interval is not perfect",
            Min = 0,
            Max = 1,
            Default = Config[keys.Jitter],
            Step = 0.01,
            Flag = keys.Jitter,
            Callback = function(value)
                Config[keys.Jitter] = value
            end,
        })
    end
    tab:AddSlider({
        Title = "Hold",
        Min = 0.01,
        Max = 0.4,
        Default = Config[keys.Hold],
        Step = 0.01,
        Flag = keys.Hold,
        Callback = function(value)
            Config[keys.Hold] = value
        end,
    })
    tab:AddSlider({
        Title = "Offset X",
        Min = -80,
        Max = 80,
        Default = Config[keys.OffsetX],
        Step = 1,
        Flag = keys.OffsetX,
        Callback = function(value)
            Config[keys.OffsetX] = value
        end,
    })
    tab:AddSlider({
        Title = "Offset Y",
        Min = -80,
        Max = 80,
        Default = Config[keys.OffsetY],
        Step = 1,
        Flag = keys.OffsetY,
        Callback = function(value)
            Config[keys.OffsetY] = value
        end,
    })
    tab:AddToggle({
        Title = "Topbar Inset",
        Default = Config[keys.Inset],
        Flag = keys.Inset,
        Callback = function(value)
            Config[keys.Inset] = value
        end,
    })
end

local function options(Config, keys)
    return {
        Method = Config[keys.Method],
        Hold = Config[keys.Hold],
        OffsetX = Config[keys.OffsetX],
        OffsetY = Config[keys.OffsetY],
        UseInset = Config[keys.Inset],
        OnlyVisible = true,
    }
end

return {
    BindClick = bindClick,
    Options = options,
}
