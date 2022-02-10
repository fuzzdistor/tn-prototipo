local newTileLayer = require("tilelayer")
local im = require("InputManager")
local camera = require("camera")
local vec2 = require("brinevector")
local bump = require("bump")
-- local flux = require("flux")

local __INFO = {
    version = 0.1
}

-- alias para comodidad
local lg = love.graphics
-- table de alamacenaje para conveniencia. se almacena estado dentro
local my = {}
-- funcion de dibujado para pasar al creador de nodos
-- hace un cuadrado magenta del tamano del tile
local function drawMagenta(self)
    lg.setColor(1,0,1,1)
    lg.rectangle("fill", self.x, self.y, self.parent.w, self.parent.h)
end
local function drawCyan(self)
    lg.setColor(0,1,1,1)
    lg.rectangle("fill", self.x, self.y, self.parent.w, self.parent.h)
end

function love.load()
    math.randomseed(os.time())

    -- creo una capa de colisiones
    my.world = bump.newWorld(64)

    -- crear TileLayers (columnas, filas, ancho de celda, alto de celta [= alto de celda])
    my.backlayer = newTileLayer(40, 30, 40)
    my.frontlayer = newTileLayer(50, 10, 40)

    -- creo un grid en el backlayer
    for i = -1, 41 do
        for j = -1, 41 do
            local df = nil
            if i == -1 or i == 41 or j == -1 or j == 41 then
                df = drawCyan
            end
            local t = my.backlayer:newTile(i, j, df)
            if df then my.world:add(t, t.x, t.y, t.parent.w, t.parent.h) end
        end
    end

    -- creo objetos random en el frontlayer y los anado al mapa de colisiones
    for _ = 0, 50 do
        local x,y
        repeat
            x,y = math.random(0,my.backlayer.cols), math.random(0,my.backlayer.rows)
        until my.frontlayer:checkFree(x, y)
        local t = my.frontlayer:newTile(x, y, drawMagenta)
        my.world:add(t, t.x, t.y, t.parent.w, t.parent.h)
    end

    my.player = {
        speed = 200,
        pos = vec2(300,300),
        size = vec2 (32,32),
        center = vec2(16, 16),
        parent = my.frontlayer,
        draw = function(self)
            lg.setColor(1,1,0,1)
            lg.rectangle("fill", my.world:getRect(self))
        end,
        move = function(self, mov)
            -- muevo al jugador a una posicion objetivo con world:move. esa
            -- funcion devuelve la posicion real teniendo en cuenta colisiones
            local goal = self.pos + mov
            self.pos.x, self.pos.y = my.world:move(self, goal.x, goal.y)
        end,

    }

    local mp = my.player
    my.world:add(mp, mp.pos.x, mp.pos.y, mp.size.x, mp.size.y)

    table.insert(my.frontlayer.tiles, my.player)

    my.cam = camera(300,300)

    -- preparo table de los inputs que usa el juego
    -- se pueden bindear multiples codigos de tecla al mismo codigo de input
    local bindings = {
        escape = 'escape',
        w = 'up',
        a = 'left',
        s = 'down',
        d = 'right',
        u = 'scale down',
        i = 'scale up',
        j = 'action',
        k = 'cancel',
    }
    im.registerBindings(bindings)
    my.debuginfo = {}
    my.addDbInfo = function(callback) table.insert(my.debuginfo, callback) end
    local a = function(arg1, arg2) return function() return arg1..arg2 end end
    my.addDbInfo(a("Player speed: ", my.player.speed))
end

function love.update(dt)

    -- funcion para leer inputs que se busca leer cuando se dispara el presionado
    local inputs = {}
    while im.pollInputs(inputs) do
        -- si se presiona escape salir del juego
        if inputs.code == 'escape' then love.event.quit()
        end
    end

    local mov = vec2()

    -- bloque para leer inputs que se busca leer continuamente mientras esten presionados
    if im.isCodeDown('up') then     mov.y = mov.y - 1 end
    if im.isCodeDown('down') then   mov.y = mov.y + 1 end
    if im.isCodeDown('left') then   mov.x = mov.x - 1 end
    if im.isCodeDown('right') then  mov.x = mov.x + 1 end
    if im.isCodeDown('scale up') then my.cam:scaleLog(dt) end
    if im.isCodeDown('scale down') then if my.cam.scale > 1 then my.cam:scaleLog(-dt) end end
    if im.isCodeDown('action') then my.player.speed = my.player.speed + 10 end

    -- muevo el jugador y la camara
    mov = mov.normalized * my.player.speed * dt
    my.cam:lockPosition(my.player.pos.x + my.player.center.x, my.player.pos.y + my.player.center.y, camera.smooth.damped(8))
    my.player:move(mov)

end

local function drawStatistics()
    lg.setColor(1,1,1,1)
    for index, callback in ipairs(my.debuginfo) do
        lg.print(callback(), 10, (index-1) * 15 + 10)
    end
end

function love.draw()
    my.cam:attach()
        my.backlayer:draw()
        my.frontlayer:draw()
    my.cam:detach()
    drawStatistics()
end
