local Features = requirem("core/features")
local Config = requirem("core/config")
local Finder = requirem("core/finder")
local Actions = requirem("core/actions")
local Controls = requirem("core/controls")

local keys = {
    Method = "Method",
    Delay = "Delay",
    Jitter = "Jitter",
    Hold = "Hold",
    OffsetX = "OffsetX",
    OffsetY = "OffsetY",
    Inset = "UseInset",
}

Features.Register({
    Id = "AutoClick",
    Tab = { Title = "Click", Icon = "zap" },
    Build = function(tab, ctx)
        tab:AddParagraph({
            Title = "Speed button",
            Content = "Clicks the ImageButton from the Target tab while it is on screen.",
        })
        tab:AddToggle({
            Title = "Auto Click",
            Default = false,
            Flag = "AutoClick",
            Callback = function(state)
                Config:Set("AutoClick", state)
                ctx.Notify("Auto Click", state and "On" or "Off", state and "Success" or "Info")
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
        tab:AddSection({ Title = "timing" })
        Controls.BindClick(tab, Config, keys)
    end,
    Tick = function()
        if not Config.AutoClick then
            return
        end
        if not Actions.Ready("click", Config.Delay, Config.Jitter) then
            return
        end
        local button = Finder.ByPath(Config.GuiName, Config.FrameName, Config.ButtonName)
        if button then
            Actions.Press(button, Controls.Options(Config, keys))
        end
    end,
})

return true
