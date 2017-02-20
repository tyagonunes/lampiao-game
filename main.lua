
local physics = require( "physics" )
physics.start()
physics.setDrawMode( "normal" )
physics.setGravity( 0, 0 )

-- Seed the random number generator
math.randomseed( os.time() )

-- Initialize variables
local lives = "X X X"
local score = 0
local inimigosTable = {}
local proxNivel = 5
local indexFama = 1
local lampiao
local inimigo
local velocidade = 2000
local gameLoopTimer
local livesText
local scoreText
local famaText
local soundShot = audio.loadSound( "sounds/Shot.mp3" )
local soundRicochet = audio.loadSound( "sounds/ricochet.mp3" )
local fama = {"Sem fama", "Caldo de bila", "Fuleiragem", "Alma de gato", "Cabra bom", "Gota serena", "Cabra arretado", "Alma sebosa", "Cabra da peste", "Lampião" }

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


local function shot ()
  -- body...
  audio.play( soundShot )
end

-- background:addEventListener("tap", shot )
local function updateFama ()

  if (score >= proxNivel) then

    proxNivel = proxNivel + 5
    indexFama = indexFama + 1
    famaText.text = "Cangaceiro "..fama[indexFama]

    velocidade = velocidade - 1800
  end
end


local function updateScore ()
  -- body...
  scoreText.text = "Score: " .. score
  updateFama()
end



livesText = display.newText( uiGroup, lives, display.contentCenterX, 40, "customfont.ttf", 13 )
scoreText = display.newText( uiGroup, "Score: "..score, display.contentCenterX, 20, "customfont.ttf", 13 )
famaText = display.newText( uiGroup, "Cangaceiro "..fama[indexFama], display.contentCenterX, 60, "customfont.ttf", 13 )
local colorBlack = { "gray" }

livesText:setFillColor( unpack(colorBlack) )
scoreText:setFillColor( unpack(colorBlack) )
famaText:setFillColor(unpack(colorBlack) )

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
       shot()
     end


     novoInimigo:addEventListener( "touch", remove )
end


local function gameLoop()
    criarInimigo()
end


gameLoopTimer = timer.performWithDelay( velocidade, gameLoop, 0 )
