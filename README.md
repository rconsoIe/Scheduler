# Scheduler

Client-side update scheduler for Roblox.

Scheduler replaces multiple `RunService.Heartbeat` connections and `while task.wait()` loops with a single, centralized update loop.

This improves client performance, reduces CPU usage, and avoids runaway connections.

Pure client-side. No server code.

---

## What it does

- Uses a single Heartbeat connection
- Schedules repeated, delayed, and per-frame tasks
- Reduces script overhead and garbage creation
- Gives explicit control over update frequency
- Helps prevent performance degradation over time

---

## Setup

Load Scheduler using HttpGet:

```lua
local Scheduler = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rconsoIe/Scheduler/refs/heads/main/loader.lua"
))()

-- Optional: choose a specific version
-- Scheduler.version = "v1.0.0"

Scheduler = Scheduler.init()
```

If no version is specified, the latest version is loaded by default.

---

## Basic usage

### Scheduler.every

Runs a function repeatedly at a fixed interval.

Returns an ID that can be used to cancel, pause, or resume the task.

```lua
Scheduler.every(interval, callback)
```

Example:

```lua
local id = Scheduler.every(0.1, function()
    update()
end)
```

This replaces:

```lua
while task.wait(0.1) do
    update()
end
```

---

### Scheduler.onHeartbeat

Runs a function every frame.

Uses the same internal Heartbeat connection as all other tasks.

```lua
Scheduler.onHeartbeat(callback)
```

Example:

```lua
Scheduler.onHeartbeat(function(dt)
    updateCamera(dt)
end)
```

This replaces:

```lua
RunService.Heartbeat:Connect(function(dt)
    updateCamera(dt)
end)
```

---

### Scheduler.after

Runs a function once after a delay.

```lua
Scheduler.after(delay, callback)
```

Example:

```lua
Scheduler.after(2, function()
    print("2 seconds passed")
end)
```

This replaces:

```lua
task.delay(2, function()
    print("2 seconds passed")
end)
```

---

## Task control

### Scheduler.cancel

Stops and removes a scheduled task.

```lua
Scheduler.cancel(taskId)
```

Example:

```lua
Scheduler.cancel(id)
```

---

### Scheduler.pause

Temporarily pauses a task without removing it.

```
Scheduler.pause(taskId)
```

Paused tasks do not run until resumed.

---

### Scheduler.resume

Resumes a paused task.

```lua
Scheduler.resume(taskId)
```

---

## Why Scheduler exists

Common Roblox client issues:

- Too many Heartbeat connections
- Unthrottled update loops
- Scripts running every frame unnecessarily
- Increasing CPU usage over time
- Garbage collection spikes

Scheduler solves this by:

- Centralizing updates
- Reducing connections to one
- Making update frequency explicit
- Avoiding unnecessary work

---

## Performance notes

- All tasks share one Heartbeat connection
- No additional threads or loops are created
- Task execution is lightweight and predictable
- Suitable for UI updates, hitboxes, animation logic, and input handling

---

## What Scheduler does NOT do

- It does not run server code
- It does not add security
- It does not manage networking
- It does not replace Roblox physics or rendering

---

## Recommended usage

Use Scheduler for:

- Hitbox updates
- UI refresh throttling
- Camera updates
- Animation checks
- Client-only logic that runs repeatedly

Avoid using it for:

- Server logic
- One-off instant actions
- Long blocking operations

---

## Example (realistic)

```
Scheduler.every(0.1, function()
    updateHitbox()
end)

Scheduler.onHeartbeat(function(dt)
    updateCamera(dt)
end)

Scheduler.after(5, function()
    print("done")
end)
```

---

## Notes

- Scheduler is intentionally minimal
- Keep tasks lightweight
- Cancel tasks you no longer need
- Prefer lower update frequencies when possible
