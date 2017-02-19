
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



local background = display.newImageRect( backGroup, "img/fundo3.jpg", 600, 350)
background.x = display.contentCenterX
background.y = display.contentCenterY


lampiao = display.newImageRect( mainGroup, "img/lampiao.png", 90, 129 )
lampiao.x = display.contentCenterX
lampiao.y = display.contentCenterY + 20


-- inimigo = display.newImageRect( mainGroup, "img/inimigo.png", 90, 100 )
-- inimigo.x = display.contentCenterX - 240
-- inimigo.y = display.contentCenterY - 90




-- Esconde a barra de setStatus
display.setStatusBar( display.HiddenStatusBar )


livesText = display.newText( uiGroup, lives, display.contentCenterX, 40, "customfont.ttf", 13 )
scoreText = display.newText( uiGroup, "Score: "..score, display.contentCenterX, 20, "customfont.ttf", 13 )
local colorTable = { "gray" }
livesText:setFillColor( unpack(colorTable) )
scoreText:setFillColor( unpack(colorTable) )


-- Configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1) cangaceiro 1
            x = 50,
            y = 0,
            width = 172,
            height = 235
        },

    },
}

local objectSheet = graphics.newImageSheet( "img/inimigo.png", sheetOptions )


local function criarInimigo()
    local novoInimigo = display.newImageRect( mainGroup, objectSheet, 0, 71, 101 )
    table.insert( inimigosTable, novoInimigo )
    physics.addBody( novoInimigo, "static", { radius=40, bounce=0.8 } )
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
end


for i=1,10 do
  -- body...
  criarInimigo()
end
