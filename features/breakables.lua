local Features = requirem("core/features")
local Config = requirem("core/config")
local Finder = requirem("core/finder")
local Actions = requirem("core/actions")
local Controls = requirem("core/controls")

local keys = {
    Method = "BreakableMethod",
    Delay = "BreakableDelay",
    Hold = "BreakableHold",
    OffsetX = "BreakableOffsetX",
    OffsetY = "BreakableOffsetY",
    Inset = "BreakableInset",
}

local status

local function selected()
    return Config:Lines("BreakablePriority")
end

Features.Register({
    Id = "Breakables",
    Tab = { Title = "Breakables", Icon = "target" },
    Build = function(tab, ctx)
        tab:AddParagraph({
            Title = "Priority",
            Content = "One breakable name per line. The top line wins if several are on screen. Matching is the ImageButton name.",
        })
        tab:AddToggle({
            Title = "Auto Break",
            Default = false,
            Flag = "Breakables",
            Callback = function(state)
                Config:Set("Breakables", state)
                ctx.Notify("Breakables", state and "On" or "Off", state and "Success" or "Info")
            end,
        })
        tab:AddTextArea({
            Title = "Priority List",
            Placeholder = "Crystal\nRock\nOre",
            Default = Config.BreakablePriority,
            Flag = "BreakablePriority",
            Callback = function(value)
                Config.BreakablePriority = value
            end,
        })
        status = tab:AddLabel("Last target: none")
        tab:AddButton({
            Title = "Scan Once",
            ButtonText = "Scan",
            Callback = function()
                local button, name = Finder.FindPriority(Finder.GuiRoot(), selected())
                ctx.Notify("Breakables", button and ("Found " .. name) or "Nothing in the list is visible", button and "Success" or "Error")
            end,
        })
        tab:AddSection({ Title = "timing" })
        Controls.BindClick(tab, Config, keys)
    end,
    Tick = function()
        if not Config.Breakables then
            return
        end
        if not Actions.Ready("break", Config.BreakableDelay, 0) then
            return
        end
        local button, name = Finder.FindPriority(Finder.GuiRoot(), selected())
        if status then
            status:Set(button and ("Last target: " .. name) or "Last target: none")
        end
        if button then
            Actions.Press(button, Controls.Options(Config, keys))
        end
    end,
})

return true
