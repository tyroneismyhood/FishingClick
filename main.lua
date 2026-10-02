local BASE = "https://raw.githubusercontent.com/tyroneismyhood/FishingClick/main/"

local cache = {}

local function requirem(path)
    local loaded = cache[path]
    if loaded and loaded ~= true then
        return loaded
    end
    local source = game:HttpGet(BASE .. path .. ".lua")
    local chunk = loadstring(source, "@" .. path)
    cache[path] = true
    local result = chunk()
    cache[path] = result
    return result
end

getgenv().requirem = requirem
requirem("app")
