local Config = {
    Master = true,
    Notify = true,
    Theme = "Default",
    TickRate = 0.05,

    PlayerName = "P217",
    GuiName = "FishingGui",
    FrameName = "Fishing",
    ButtonName = "ClickSpeedUpActive",

    AutoClick = false,
    Delay = 0.3,
    Jitter = 0,
    Hold = 0.03,
    Method = "Both",
    OnlyVisible = true,
    UseInset = true,
    OffsetX = 0,
    OffsetY = 0,

    Breakables = false,
    BreakablePriority = "Crystal\nRock\nOre",
    BreakableDelay = 0.35,
    BreakableMethod = "Both",
    BreakableHold = 0.03,
    BreakableInset = true,
    BreakableOffsetX = 0,
    BreakableOffsetY = 0,

    AutoPotions = false,
    AutoFruits = false,
    PotionNames = "",
    FruitNames = "",
    ConsumableDelay = 5,

    AutoBuy = false,
    MerchantNames = "",
    BuyButtonName = "Buy",
    MerchantDelay = 1,
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

function Config:Lines(key)
    local out = {}
    for line in string.gmatch(self[key] or "", "[^\r\n]+") do
        local trimmed = line:match("^%s*(.-)%s*$")
        if trimmed ~= "" and trimmed:sub(1, 2) ~= "--" then
            out[#out + 1] = trimmed
        end
    end
    return out
end

return Config
