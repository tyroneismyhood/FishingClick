local Features = requirem("core/features")
local Config = requirem("core/config")
local Finder = requirem("core/finder")
local Actions = requirem("core/actions")

local function wanted()
    local set = {}
    for _, name in ipairs(Config:Lines("MerchantNames")) do
        set[string.lower(name)] = true
    end
    return set
end

local function findBuy()
    local root = Finder.GuiRoot()
    local merchants = wanted()
    local buyName = string.lower(Config.BuyButtonName)
    if not root or next(merchants) == nil then
        return nil
    end
    for _, inst in ipairs(root:GetDescendants()) do
        if inst:IsA("GuiButton") and inst.Visible and string.lower(inst.Name) == buyName then
            local parent = inst.Parent
            while parent and parent ~= root do
                if merchants[string.lower(parent.Name)] then
                    return inst
                end
                parent = parent.Parent
            end
        end
    end
    return nil
end

Features.Register({
    Id = "Merchants",
    Tab = { Title = "Merchants", Icon = "globe" },
    Build = function(tab, ctx)
        tab:AddParagraph({
            Title = "Auto buy",
            Content = "One merchant per line. A line is selected. Empty means buy nothing. The buy button must sit inside that merchant frame.",
        })
        tab:AddToggle({
            Title = "Auto Buy",
            Description = "Off ignores the list",
            Default = false,
            Flag = "AutoBuy",
            Callback = function(state)
                Config:Set("AutoBuy", state)
                ctx.Notify("Merchants", state and "On" or "Off", state and "Success" or "Info")
            end,
        })
        tab:AddTextArea({
            Title = "Merchants",
            Placeholder = "Fish Merchant\nPotion Merchant",
            Default = "",
            Flag = "MerchantNames",
            Callback = function(value)
                Config.MerchantNames = value
            end,
        })
        tab:AddInput({
            Title = "Buy Button Name",
            Default = "Buy",
            Flag = "BuyButtonName",
            Callback = function(value)
                Config.BuyButtonName = value
            end,
        })
        tab:AddSlider({
            Title = "Delay",
            Min = 0.2,
            Max = 10,
            Default = 1,
            Step = 0.1,
            Flag = "MerchantDelay",
            Callback = function(value)
                Config.MerchantDelay = value
            end,
        })
        tab:AddButton({
            Title = "Scan Buy Buttons",
            ButtonText = "Scan",
            Callback = function()
                local button = findBuy()
                ctx.Notify("Merchants", button and button:GetFullName() or "No selected merchant has a buy button", button and "Success" or "Error")
            end,
        })
    end,
    Tick = function()
        if not Config.AutoBuy then
            return
        end
        if not Actions.Ready("buy", Config.MerchantDelay, 0) then
            return
        end
        local button = findBuy()
        if button then
            Actions.Press(button, {
                Method = "Both",
                Hold = 0.03,
                OffsetX = 0,
                OffsetY = 0,
                UseInset = true,
                OnlyVisible = true,
            })
        end
    end,
})

return true
