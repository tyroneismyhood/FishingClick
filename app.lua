local Config = requirem("core/config")
local Target = requirem("core/target")
local Click = requirem("core/clicker")
local Features = requirem("core/features")

requirem("features/autoclick")

local EZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/akiradv/eazyuilib/main/eazyui.lua"))()
local Window = EZ:CreateWindow({
    Name = "Fishing",
    SubTitle = "Hub",
    Size = UDim2.fromOffset(560, 460),
    ConfigId = "FishingHub",
    MinimizeKey = Enum.KeyCode.RightShift,
})

local Main = Window:AddTab({ Title = "Main", Icon = "home" })
local TargetTab = Window:AddTab({ Title = "Target", Icon = "crosshair" })
local Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

for _, feature in ipairs(Features.All()) do
    if feature.Build then
        feature.Build(Main)
    end
end

TargetTab:AddSection({ Title = "path" })
TargetTab:AddInput({
    Title = "Player",
    Default = Config.PlayerName,
    Flag = "PlayerName",
    Callback = function(value)
        Config.PlayerName = value
        Target.Invalidate()
    end,
})
TargetTab:AddInput({
    Title = "ScreenGui",
    Default = Config.GuiName,
    Flag = "GuiName",
    Callback = function(value)
        Config.GuiName = value
        Target.Invalidate()
    end,
})
TargetTab:AddInput({
    Title = "Frame",
    Default = Config.FrameName,
    Flag = "FrameName",
    Callback = function(value)
        Config.FrameName = value
        Target.Invalidate()
    end,
})
TargetTab:AddInput({
    Title = "Button",
    Default = Config.ButtonName,
    Flag = "ButtonName",
    Callback = function(value)
        Config.ButtonName = value
        Target.Invalidate()
    end,
})
TargetTab:AddButton({
    Title = "Print Found Button",
    ButtonText = "Check",
    Callback = function()
        local button = Target.GetButton()
        EZ:Notify({
            Title = "Target",
            Content = button and (button.ClassName .. " / " .. button.Name) or "Not found",
            Style = button and "Success" or "Error",
            Duration = 3,
        })
    end,
})
TargetTab:AddToggle({
    Title = "Notifications",
    Default = true,
    Flag = "Notify",
    Callback = function(value)
        Config.Notify = value
    end,
})

Window:BuildConfigSection(Settings)

Config:OnChanged("AutoClick", function(state)
    if Config.Notify then
        EZ:Notify({
            Title = "Auto Click",
            Content = state and "On" or "Off",
            Style = state and "Success" or "Info",
            Duration = 1.2,
        })
    end
end)

task.spawn(function()
    while true do
        local delay = Config.Delay
        if Config.AutoClick then
            local button = Target.GetButton()
            if button then
                Click(button, Config)
            end
            if Config.Jitter > 0 then
                delay += math.random() * Config.Jitter
            end
        end
        task.wait(delay)
    end
end)

return true
