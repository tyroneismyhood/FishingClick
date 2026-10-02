local Config = {
    PlayerName = "P217",
    GuiName = "FishingGui",
    FrameName = "Fishing",
    ButtonName = "ClickSpeedUpActive",
    Notify = true,
    AutoClick = false,
    Delay = 0.3,
    Jitter = 0,
    Hold = 0.03,
    Method = "Both",
    OnlyVisible = true,
    UseInset = true,
    OffsetX = 0,
    OffsetY = 0,
}

local listeners = {}

function Config:Set(key, value)
    if self[key] == value then
        return
    end
    self[key] = value
    local list = listeners[key]
    if not list then
        return
    end
    for index = 1, #list do
        list[index](value)
    end
end

function Config:OnChanged(key, callback)
    local list = listeners[key]
    if not list then
        list = {}
        listeners[key] = list
    end
    list[#list + 1] = callback
end

return Config
