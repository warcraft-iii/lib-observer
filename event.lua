-- item.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 5/6/2019, 11:57:08 PM

---@class _Event: object
local Event = class('_Event')

function Event:constructor()
    self.listeners = {}
    self.insertQueue = {}
    self.recurse = 0
end

function Event:addObject(obj, method)
    if self.recurse < 1 then
        self.listeners[obj] = method
    else
        self.insertQueue[obj] = method
    end
end

function Event:removeObject(obj)
    self.listeners[obj] = nil
    self.insertQueue[obj] = nil
end

function Event:dispatch(...)
    local recurse = self.recurse
    self.recurse = recurse + 1

    for obj, method in pairs(self.listeners) do
        method(obj, ...)
    end

    self.recurse = recurse

    if not table.isempty(self.insertQueue) and recurse == 0 then
        for obj, method in pairs(self.insertQueue) do
            self.listeners[obj] = method
            self.insertQueue[obj] = nil
        end
        self.insertQueue = nil
    end
end

function Event:hasListener()
    return not table.isempty(self.listeners) or not table.isempty(self.insertQueue)
end

return Event
