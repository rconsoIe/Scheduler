local Scheduler = {}

Scheduler.version = nil

function Scheduler.init()
    local path

    if Scheduler.version then
        path = "@%s/main.lua"
        path = string.format(path, Scheduler.version)
    else
        path = "main/main.lua"
    end

    local url =
        "https://raw.githubusercontent.com/rconsoIe/Scheduler/refs/heads/main/" .. path

    local ok, impl = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not ok then
        error("Scheduler: failed to load implementation (" .. path .. ")")
    end

    return impl
end

return Scheduler
