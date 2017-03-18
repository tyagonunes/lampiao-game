
local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
physics.start()
physics.setDrawMode( "normal" )
physics.setGravity( 0, 0 )

-- Seed the random number generator
math.randomseed( os.time() )

-- Esconde a barra de setStatus
display.setStatusBar( display.HiddenStatusBar )

local score = 0
local inimigosTable = {}
local proxNivel = 5
local indexFama = 1
local lampiao
local inimigo
local gameLoopTimer
local scoreText
local famaText
local soundShot = audio.loadSound( "sounds/Shot.mp3" )
local soundRicochet = audio.loadSound( "sounds/ricochet.mp3" )
local fama = {"Sem fama", "Caldo de bila", "Fuleiragem", "Alma de gato", "Cabra bom", "Gota serena", "Cabra arretado", "Alma sebosa", "Cabra da peste", "Lampião" }

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local background = display.newImageRect( backGroup, "img/fundo.jpg", 600, 350)
background.x = display.contentCenterX
background.y = display.contentCenterY

lampiao = display.newImageRect( mainGroup, "img/lampiao.png", 90, 129 )
lampiao.x = display.contentCenterX
lampiao.y = display.contentCenterY + 20


------ Seta estilo e cor para os labels de score e fama -------------
scoreText = display.newText( uiGroup, "Score: "..score, display.contentCenterX, 20, "customfont.ttf", 13 )
famaText = display.newText( uiGroup, "Cangaceiro "..fama[indexFama], display.contentCenterX, 60, "customfont.ttf", 13 )
local colorBlack = { "gray" }
scoreText:setFillColor( unpack(colorBlack) )
famaText:setFillColor(unpack(colorBlack) )

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

----------- Variaveis de medidas de tela para localização dos inimigos -----------
local lateral_meio = display.contentHeight/2
local lateral_cima = display.contentHeight/9
local lateral_baixo = display.contentHeight - 40



-----------------------------------------------------
------------------ Funções --------------------------
------------------------------------------------------


---------- Função executa som de tiro----------------
local function shot ()
    audio.play( soundShot )
end

------------- Atualiza o status da fama -------------

local function updateFama ()
    if (score >= proxNivel) then
        proxNivel = proxNivel + 5
        indexFama = indexFama + 1
        famaText.text = "Cangaceiro "..fama[indexFama]
    end
end

----------- Atualiza o score -----------------------

local function updateScore ()
    scoreText.text = "Score: " .. score
    updateFama()
end

-- local function gameover () {
--     composer.gotoScene( "gameover", { time = 250, effect = "fade" } )
-- }

----------- Cria inimigos na tela

local function criarInimigo()
    local inimigo = display.newImageRect( mainGroup, objectSheet, 0, 51, 70 )
    table.insert( inimigosTable, inimigo )

    if (table.getn(inimigosTable) > 2) then
        scoreText.text = "Voce perdeu"
        timer.cancel( gameLoopTimer )
        gameover();
    end

    physics.addBody( inimigo, "static", { isSensor=true } )
    inimigo.myName = "inimigo"

    local lado = math.random( 3 )
    local altura = math.random( 3 )

    if ( lado == 1 ) then
        -- Esquerda
        inimigo.x = -10

        if (altura == 1) then
            inimigo.y = lateral_cima
        elseif (altura == 2)then
            inimigo.y = lateral_meio
        elseif (altura == 3) then
            inimigo.y = lateral_baixo
        end
        transition.to( inimigo, { x=0, time=100, } )

    elseif ( lado == 2 ) then
       -- Baixo
       inimigo.x = display.contentWidth/2
       inimigo.y = 300
       transition.to( inimigo, { y=280, time=100, } )
   elseif ( lado == 3 ) then
         -- Direita
         inimigo.x = display.contentWidth
         if (altura == 1) then
             inimigo.y = lateral_cima
         elseif (altura == 2)then
             inimigo.y = lateral_meio
         elseif (altura == 3) then
             inimigo.y = lateral_baixo
         end
         transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
     end

     local function tapListener(event)
        display.remove( inimigo )

        for i = #inimigosTable, 1, -1 do
            if ( inimigosTable[i] == inimigo) then
                table.remove( inimigosTable, i )
                break
            end
        end
        score = score + 1
        updateScore();
        shot()
     end

     inimigo:addEventListener( "touch", tapListener )
end


local function gameLoop()
    criarInimigo()
end

gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 20 )



-- local function endGame()
--     composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
-- end
--
-- local scene = composer.newScene()
