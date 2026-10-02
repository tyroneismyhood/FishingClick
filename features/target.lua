local Features = requirem("core/features")
local Config = requirem("core/config")
local Finder = requirem("core/finder")

Features.Register({
    Id = "Target",
    Tab = { Title = "Target", Icon = "crosshair" },
    Build = function(tab, ctx)
        tab:AddParagraph({
            Title = "Speed button path",
            Content = "Used by the Click tab only. Breakables and merchants search the whole PlayerGui by name.",
        })
        tab:AddInput({
            Title = "Player",
            Default = Config.PlayerName,
            Flag = "PlayerName",
            Callback = function(value)
                Config.PlayerName = value
                Finder.Invalidate()
            end,
        })
        tab:AddInput({
            Title = "ScreenGui",
            Default = Config.GuiName,
            Flag = "GuiName",
            Callback = function(value)
                Config.GuiName = value
                Finder.Invalidate()
            end,
        })
        tab:AddInput({
            Title = "Frame",
            Default = Config.FrameName,
            Flag = "FrameName",
            Callback = function(value)
                Config.FrameName = value
                Finder.Invalidate()
            end,
        })
        tab:AddInput({
            Title = "Button",
            Default = Config.ButtonName,
            Flag = "ButtonName",
            Callback = function(value)
                Config.ButtonName = value
                Finder.Invalidate()
            end,
        })
        tab:AddButton({
            Title = "Check Path",
            ButtonText = "Check",
            Callback = function()
                local button = Finder.ByPath(Config.GuiName, Config.FrameName, Config.ButtonName)
                ctx.Notify("Target", button and (button.ClassName .. " / " .. button.Name) or "Not found", button and "Success" or "Error")
            end,
        })
    end,
})

return true
