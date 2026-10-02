local Features = requirem("core/features")
local Config = requirem("core/config")
local Actions = requirem("core/actions")

local Workspace = game:GetService("Workspace")
local status

local function selected()
    return Config:Lines("BreakablePriority")
end

local function findBreakable()
    local names = selected()
    if #names == 0 then
        return nil
    end
    local rankOf = {}
    for index, name in ipairs(names) do
        local key = string.lower(name)
        if not rankOf[key] then
            rankOf[key] = index
        end
    end
    local best, bestRank = nil, math.huge
    for _, inst in ipairs(Workspace:GetDescendants()) do
        local rank = rankOf[string.lower(inst.Name)]
        if rank and rank < bestRank and (inst:IsA("Model") or inst:IsA("BasePart")) then
            best = inst
            bestRank = rank
        end
    end
    return best
end

local function interact(inst)
    -- Real break logic is not wired yet. Workspace scan and priority are ready.
    local prompt = inst:FindFirstChildWhichIsA("ProximityPrompt", true)
    local detector = inst:FindFirstChildWhichIsA("ClickDetector", true)
    if prompt or detector then
        return false, "found a prompt, waiting for break logic"
    end
    return false, "break logic not wired"
end

Features.Register({
    Id = "Breakables",
    Tab = { Title = "Breakables", Icon = "target" },
    Build = function(tab, ctx)
        tab:AddParagraph({
            Title = "Workspace",
            Content = "One name per line. The top line wins. Matches Models and Parts in Workspace. Breaking itself is not wired yet.",
        })
        tab:AddToggle({
            Title = "Auto Break",
            Default = false,
            Flag = "Breakables",
            Callback = function(state)
                Config:Set("Breakables", state)
                ctx.Notify("Breakables", state and "On" or "Off", state and "Success" or "Info")
            end,
        })
        tab:AddTextArea({
            Title = "Priority List",
            Placeholder = "Crystal\nRock\nOre",
            Default = Config.BreakablePriority,
            Flag = "BreakablePriority",
            Callback = function(value)
                Config.BreakablePriority = value
            end,
        })
        status = tab:AddLabel("Last target: none")
        tab:AddButton({
            Title = "Scan Workspace",
            ButtonText = "Scan",
            Callback = function()
                local inst = findBreakable()
                ctx.Notify("Breakables", inst and (inst.ClassName .. " / " .. inst:GetFullName()) or "No name from the list is in Workspace", inst and "Success" or "Error")
            end,
        })
        tab:AddSlider({
            Title = "Delay",
            Min = 0.05,
            Max = 3,
            Default = Config.BreakableDelay,
            Step = 0.01,
            Flag = "BreakableDelay",
            Callback = function(value)
                Config.BreakableDelay = value
            end,
        })
    end,
    Tick = function()
        if not Config.Breakables then
            return
        end
        if not Actions.Ready("break", Config.BreakableDelay, 0) then
            return
        end
        local inst = findBreakable()
        if status then
            status:Set(inst and ("Last target: " .. inst.Name) or "Last target: none")
        end
        if inst then
            interact(inst)
        end
    end,
})

return true
