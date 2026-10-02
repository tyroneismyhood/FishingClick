local Click = requirem("core/clicker")

local last = {}

local function ready(id, delay, jitter)
    local now = os.clock()
    local waitFor = delay + (jitter > 0 and math.random() * jitter or 0)
    if now - (last[id] or 0) < waitFor then
        return false
    end
    last[id] = now
    return true
end

return {
    Ready = ready,
    Press = function(button, options)
        return Click(button, options)
    end,
}
