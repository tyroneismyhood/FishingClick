local function mount(Config)
    local EZ = loadstring(game:HttpGet("https://raw.githubusercontent.com/akiradv/eazyuilib/main/eazyui.lua"))()
    local Window = EZ:CreateWindow({
        Name = "Fishing",
        SubTitle = "Hub",
        Size = UDim2.fromOffset(620, 480),
        ConfigId = "FishingHub",
        MinimizeKey = Enum.KeyCode.RightShift,
        LoadingTitle = "Fishing",
        LoadingSubtitle = "Loading modules",
        LoadingDuration = 0.6,
        Transparency = 0,
    })

    return {
        EZ = EZ,
        Window = Window,
        Notify = function(title, content, style)
            if not Config.Notify then
                return
            end
            EZ:Notify({
                Title = title,
                Content = content,
                Style = style or "Info",
                Duration = 1.6,
            })
        end,
    }
end

return {
    Mount = mount,
}
