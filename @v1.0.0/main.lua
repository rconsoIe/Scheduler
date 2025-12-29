local RunService = game:GetService("RunService")

local Scheduler = {}

local tasks = {}
local nextId = 0
local heartbeatConn

local function ensureHeartbeat()
    if heartbeatConn then return end

    heartbeatConn = RunService.Heartbeat:Connect(function(dt)
        local now = os.clock()

        for id, task in pairs(tasks) do
            if not task.active then
                continue
            end

            if task.type == "heartbeat" then
                task.fn(dt)

            elseif task.type == "every" then
                if now - task.last >= task.interval then
                    task.last = now
                    task.fn(dt)
                end

            elseif task.type == "after" then
                if now >= task.at then
                    task.fn()
                    tasks[id] = nil
                end
            end
        end
    end)
end

local function addTask(task)
    nextId += 1
    task.id = nextId
    task.active = true
    tasks[nextId] = task
    ensureHeartbeat()
    return nextId
end

function Scheduler.onHeartbeat(fn)
    return addTask({
        type = "heartbeat",
        fn = fn
    })
end

function Scheduler.every(interval, fn)
    return addTask({
        type = "every",
        interval = interval,
        last = 0,
        fn = fn
    })
end

function Scheduler.after(delay, fn)
    return addTask({
        type = "after",
        at = os.clock() + delay,
        fn = fn
    })
end

function Scheduler.cancel(id)
    tasks[id] = nil
end

function Scheduler.pause(id)
    if tasks[id] then
        tasks[id].active = false
    end
end

function Scheduler.resume(id)
    if tasks[id] then
        tasks[id].active = true
    end
end

return Scheduler
