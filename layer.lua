local lg = love.graphics

local function default_draw(node)
    lg.setColor(1,1,1,1)
    if node.texture then
        lg.draw(node.texture)
    end
end

return function()
    return {
        nodes = {},

        draw = function(self)
            for _, node in pairs(self.nodes) do
                if not node.draw then
                    default_draw(node)
                else
                    node:draw()
                end
            end
        end
    }
end
