
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Seed the random number generator
math.randomseed( os.time() )
-- Initialize variables
local lives = "X X X"
local score = 0
local died = false
local inimigosTable = {}
local lampiao
local inimigo
local gameLoopTimer
local livesText
local scoreText

local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score



local background = display.newImageRect( backGroup, "img/fundo.jpg", 600, 350)
background.x = display.contentCenterX
background.y = display.contentCenterY


lampiao = display.newImageRect( mainGroup, "img/lampiao.png", 90, 129 )
lampiao.x = display.contentCenterX
lampiao.y = display.contentCenterY + 20


-- Esconde a barra de setStatus
display.setStatusBar( display.HiddenStatusBar )


local function updateScore ()
  -- body...
  scoreText.text = "Score: " .. score
end

livesText = display.newText( uiGroup, lives, display.contentCenterX, 40, "customfont.ttf", 13 )
scoreText = display.newText( uiGroup, "Score: "..score, display.contentCenterX, 20, "customfont.ttf", 13 )
local colorTable = { "gray" }
livesText:setFillColor( unpack(colorTable) )
scoreText:setFillColor( unpack(colorTable) )


-- Configure image sheet
-- local sheetOptions =
-- {
--     frames =
--     {
--         {   -- 1) cangaceiro 1
--             x = 50,
--             y = 0,
--             width = 172,
--             height = 235
--         },
--
--     },
-- }

local sheetOptions =
{
    frames =
    {
        {   -- 1) cangaceiro 1
            x = 0,
            y = 0,
            width = 123,
            height = 200
        },

    },
}

local objectSheet = graphics.newImageSheet( "img/gun.png", sheetOptions )


local function criarInimigo()
    local novoInimigo = display.newImageRect( mainGroup, objectSheet, 0, 51, 70 )
    table.insert( inimigosTable, novoInimigo )
    physics.addBody( novoInimigo, "static", { isSensor=true } )
    novoInimigo.myName = "inimigo"

    local whereFrom = math.random( 3 )
      -- local whereFrom = 2

    if ( whereFrom == 1 ) then
        -- From the left
        novoInimigo.x = 10
        novoInimigo.y = math.random( display.contentHeight - 20 )
        novoInimigo:setLinearVelocity(60, 100 )
    elseif ( whereFrom == 2 ) then
       -- From the top
       novoInimigo.x = math.random( display.contentWidth )
       novoInimigo.y = 296
       novoInimigo:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
     elseif ( whereFrom == 3 ) then
         -- From the right
         novoInimigo.x = display.contentWidth
         novoInimigo.y = math.random( display.contentHeight - 20 )
         novoInimigo:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
     end

     local function remove()
       -- body...
       display.remove( novoInimigo )
       score = score + 1
       updateScore();
     end


     novoInimigo:addEventListener( "tap", remove )
end


local function gameLoop()

    -- Create new asteroid
    criarInimigo()

    -- -- Remove asteroids which have drifted off screen
    -- for i = #asteroidsTable, 1, -1 do
    --
    -- end
end


gameLoopTimer = timer.performWithDelay( 2000, gameLoop, 0 )
