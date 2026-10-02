local function start(Config, Features)
    task.spawn(function()
        while true do
            local dt = task.wait(Config.TickRate)
            if not Config.Master then
                continue
            end
            for _, feature in ipairs(Features.All()) do
                if feature.Tick then
                    local ok, err = pcall(feature.Tick, dt)
                    if not ok then
                        warn("[Fishing] " .. feature.Id .. ": " .. tostring(err))
                    end
                end
            end
        end
    end)
end

return {
    Start = start,
}
