local Config = requirem("core/config")
local Players = game:GetService("Players")

local cacheKey = ""
local cacheButton = nil

local function getButton()
    local key = Config.PlayerName .. "\0" .. Config.GuiName .. "\0" .. Config.FrameName .. "\0" .. Config.ButtonName
    if cacheKey == key and cacheButton and cacheButton.Parent then
        return cacheButton
    end

    local player = Players:FindFirstChild(Config.PlayerName) or Players.LocalPlayer
    local playerGui = player and player:FindFirstChild("PlayerGui")
    local screen = playerGui and playerGui:FindFirstChild(Config.GuiName)
    local frame = screen and screen:FindFirstChild(Config.FrameName)
    local button = nil

    if frame then
        local named = frame:FindFirstChild(Config.ButtonName, true)
        if named then
            if named:IsA("ImageButton") or named:IsA("GuiButton") then
                button = named
            else
                button = named:FindFirstChildWhichIsA("ImageButton", true)
            end
        end
    end

    cacheKey = key
    cacheButton = button
    return button
end

return {
    GetButton = getButton,
    Invalidate = function()
        cacheKey = ""
        cacheButton = nil
    end,
}
