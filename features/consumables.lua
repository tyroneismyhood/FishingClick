local Features = requirem("core/features")
local Config = requirem("core/config")

local function useItem(kind, name)
    -- Use logic is intentionally empty until the potion and fruit remotes are known.
    return false, kind .. " use is not wired: " .. name
end

Features.Register({
    Id = "Consumables",
    Tab = { Title = "Items", Icon = "star" },
    Build = function(tab)
        tab:AddParagraph({
            Title = "Not wired yet",
            Content = "Toggles and name lists save now. Nothing is used until useItem in features/consumables.lua is filled in.",
        })
        tab:AddSection({ Title = "potions" })
        tab:AddToggle({
            Title = "Auto Potions",
            Default = false,
            Flag = "AutoPotions",
            Callback = function(state)
                Config.AutoPotions = state
            end,
        })
        tab:AddTextArea({
            Title = "Potion Names",
            Placeholder = "One potion per line",
            Default = "",
            Flag = "PotionNames",
            Callback = function(value)
                Config.PotionNames = value
            end,
        })
        tab:AddSection({ Title = "fruits" })
        tab:AddToggle({
            Title = "Auto Fruits",
            Default = false,
            Flag = "AutoFruits",
            Callback = function(state)
                Config.AutoFruits = state
            end,
        })
        tab:AddTextArea({
            Title = "Fruit Names",
            Placeholder = "One fruit per line",
            Default = "",
            Flag = "FruitNames",
            Callback = function(value)
                Config.FruitNames = value
            end,
        })
        tab:AddSlider({
            Title = "Retry Delay",
            Min = 1,
            Max = 60,
            Default = 5,
            Step = 1,
            Flag = "ConsumableDelay",
            Callback = function(value)
                Config.ConsumableDelay = value
            end,
        })
    end,
    Tick = function()
        if not Config.AutoPotions and not Config.AutoFruits then
            return
        end
        if not requirem("core/actions").Ready("items", Config.ConsumableDelay, 0) then
            return
        end
        if Config.AutoPotions then
            for _, name in ipairs(Config:Lines("PotionNames")) do
                useItem("potion", name)
            end
        end
        if Config.AutoFruits then
            for _, name in ipairs(Config:Lines("FruitNames")) do
                useItem("fruit", name)
            end
        end
    end,
})

return true
