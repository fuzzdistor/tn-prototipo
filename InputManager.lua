local my = {
    keys = {},
    bindings = { escape = 'escape' }
}

local im = {}
function im.registerBindings(t)
    my.bindings = t
end

function im.getBinding(code)
    if my.bindings[code] then
        return my.bindings[code]
    end
    print('binding not found')
    return 'unknown'
end

function im.isCodeDown(code)
    for k,c in pairs(my.bindings) do
        if c == code then
            if love.keyboard.isDown(k) then
                return true
            end
        end
    end
    return false
end

function love.keypressed(_, code)
    my.keys[code] = true
end

function im.pollInputs(input)
    for key,_ in pairs(my.keys) do
        my.keys[key] = nil
        if my.bindings[key] then
            input.code = my.bindings[key]
            return true
        end
    end
    return false
end

return im
