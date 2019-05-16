-- observer.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 5/6/2019, 10:49:38 PM

---@class Observer: object
local Observer = class('Observer')

local Event = require('lib.observer.event')

---@type _Event[]
local _EVENTS = setmetatable({}, { __index = function(t, k)
    t[k] = Event:new()
    return t[k]
end })

---registerEvent
---@param id integer
---@param method function
---@return void
function Observer:registerEvent(id, method)
    _EVENTS[id]:addObject(self, method)
end

---unregisterEvent
---@param id integer
---@return void
function Observer:unregisterEvent(id)
    _EVENTS[id]:removeObject(id)
end

---unregisterAllEvents
---@return void
function Observer:unregisterAllEvents()
    for id, event in pairs(_EVENTS) do
        event:removeObject(self)

        if not event:hasListener() then
            _EVENTS[id] = ni
        end
    end
end

---fireEvent
---@param id integer
---@vararg any
function Observer:fireEvent(id, ...)
    return _EVENTS[id]:dispatch(...)
end

return Observer
