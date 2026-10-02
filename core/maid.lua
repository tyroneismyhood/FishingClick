local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({ _tasks = {} }, Maid)
end

function Maid:Give(job)
    self._tasks[#self._tasks + 1] = job
    return job
end

function Maid:Cleanup()
    local tasks = self._tasks
    self._tasks = {}
    for index = #tasks, 1, -1 do
        local job = tasks[index]
        local kind = typeof(job)
        if kind == "RBXScriptConnection" then
            job:Disconnect()
        elseif kind == "function" then
            job()
        elseif kind == "Instance" then
            job:Destroy()
        elseif kind == "thread" then
            task.cancel(job)
        end
    end
end

return Maid
