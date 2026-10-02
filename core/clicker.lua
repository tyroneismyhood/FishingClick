local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

local function signalClick(button)
    if firesignal then
        pcall(firesignal, button.MouseButton1Click)
        pcall(firesignal, button.MouseButton1Down)
        pcall(firesignal, button.Activated)
        return
    end
    if getconnections then
        local signals = { button.MouseButton1Click, button.MouseButton1Down, button.Activated }
        for index = 1, #signals do
            local connections = getconnections(signals[index])
            for connIndex = 1, #connections do
                pcall(function()
                    connections[connIndex]:Fire()
                end)
            end
        end
        return
    end
    pcall(function()
        button:Activate()
    end)
end

local function mouseClick(button, options)
    local inset = options.UseInset and GuiService:GetGuiInset() or Vector2.zero
    local pos = button.AbsolutePosition + (button.AbsoluteSize * 0.5) + inset
    local x = pos.X + options.OffsetX
    local y = pos.Y + options.OffsetY
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    if options.Hold > 0 then
        task.wait(options.Hold)
    end
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

return function(button, options)
    if not button or not button.Parent then
        return false
    end
    if options.OnlyVisible and not button.Visible then
        return false
    end
    if options.Method == "Mouse" or options.Method == "Both" then
        mouseClick(button, options)
    end
    if options.Method == "Signal" or options.Method == "Both" then
        signalClick(button)
    end
    return true
end
