local Config = requirem("core/config")
local Players = game:GetService("Players")

local scan = {
    at = 0,
    root = nil,
    list = {},
}

local function player()
    return Players:FindFirstChild(Config.PlayerName) or Players.LocalPlayer
end

local function guiRoot()
    local found = player()
    return found and found:FindFirstChild("PlayerGui")
end

local function isButton(inst)
    return inst:IsA("ImageButton") or inst:IsA("GuiButton")
end

local function buttons(root)
    if scan.root == root and os.clock() - scan.at < 0.4 then
        return scan.list
    end
    local list = {}
    if root then
        for _, inst in ipairs(root:GetDescendants()) do
            if isButton(inst) then
                list[#list + 1] = inst
            end
        end
    end
    scan.at = os.clock()
    scan.root = root
    scan.list = list
    return list
end

local function byPath(guiName, frameName, buttonName)
    local root = guiRoot()
    local screen = root and root:FindFirstChild(guiName)
    local frame = screen and screen:FindFirstChild(frameName)
    if not frame then
        return nil
    end
    local named = frame:FindFirstChild(buttonName, true)
    if not named then
        return nil
    end
    if isButton(named) then
        return named
    end
    return named:FindFirstChildWhichIsA("ImageButton", true)
end

local function findPriority(root, orderedNames)
    if not root or #orderedNames == 0 then
        return nil, nil
    end
    local rankOf = {}
    for index, name in ipairs(orderedNames) do
        local key = string.lower(name)
        if not rankOf[key] then
            rankOf[key] = index
        end
    end
    local best, bestRank, bestName = nil, math.huge, nil
    for _, inst in ipairs(buttons(root)) do
        if inst.Parent and inst.Visible and inst.AbsoluteSize.X > 0 then
            local rank = rankOf[string.lower(inst.Name)]
            if rank and rank < bestRank then
                best = inst
                bestRank = rank
                bestName = inst.Name
            end
        end
    end
    return best, bestName
end

return {
    Player = player,
    GuiRoot = guiRoot,
    ByPath = byPath,
    FindPriority = findPriority,
    Invalidate = function()
        scan.at = 0
        scan.root = nil
        scan.list = {}
    end,
}
