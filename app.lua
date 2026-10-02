local Config = requirem("core/config")
local Features = requirem("core/features")
local Ui = requirem("core/ui")
local Scheduler = requirem("core/scheduler")

requirem("features/home")
requirem("features/autoclick")
requirem("features/breakables")
requirem("features/consumables")
requirem("features/merchants")
requirem("features/target")

local ctx = Ui.Mount(Config)

for _, feature in ipairs(Features.All()) do
    local spec = feature.Tab or { Title = feature.Id, Icon = "star" }
    local tab = ctx.Window:AddTab(spec)
    if feature.Build then
        feature.Build(tab, ctx)
    end
end

local settings = ctx.Window:AddTab({ Title = "Settings", Icon = "settings" })
ctx.Window:BuildConfigSection(settings)

Scheduler.Start(Config, Features)

return true
