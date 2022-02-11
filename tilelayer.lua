-- lib for generating tilelayers
-- tilelayers store number of columns, rows, tile height and
-- width and the drawing function for it.
-- you can add nodes by creating a newTileLayer and calling
-- newNode on it.

local bump = require("bump")
local lg = love.graphics

local function default_draw(tile)
    lg.setColor(tile.parent.defcol)
    if tile.texture then
        lg.draw(tile.texture)
    else
        lg.rectangle("line", tile.x, tile.y, tile.parent.w, tile.parent.h)
    end
end

return function(cols, rows, width, height, default_color)
    height = height or width
    default_color = default_color or {1,1,1,0.3}
    local bump_layer = bump.newWorld(64)
    return {
        tiles = {},
        collision_map = bump_layer,

        cols = cols,
        rows = rows,
        w = width,
        h = height,
        defcol = default_color,

        draw = function(self)
            for _, tile in pairs(self.tiles) do
                if not tile.draw then
                    default_draw(tile)
                else
                    tile:draw()
                end
            end
        end,

        update = function(self)
            for _, tile in pairs(self.tiles) do
                if tile.update then
                    tile.update()
                end
            end
        end,

        newTile = function(self,row,col,drawfunc,w,h,player)
            drawfunc = drawfunc or default_draw
            w = w or self.w
            h = h or self.h
            local tile = {
                col = col,
                row = row,
                x = col * w,
                y = row * h,
                parent = self,
                draw = drawfunc
            }
            table.insert(self.tiles, tile)
            player = player or tile
            self.collision_map:add(player, tile.x, tile.y, tile.parent.w, tile.parent.h)
            return tile
        end,

        checkFree = function(self, x, y)
            for _, tile in pairs(self.tiles) do
                if tile.col == x and tile.row == y then
                    return false
                end
            end
            return true
        end
    }
end
