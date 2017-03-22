
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setDrawMode( "normal" )
physics.setGravity( 0, 0 )


local score = 0
local inimigosTable = {}
local proxNivel = 5
local indexFama = 1
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



local lampiaoGroup = display.newGroup()
local lampiao = {}
local lampiaoImages = {
   "img/frame/bottom.png",
   "img/frame/right.png",
   "img/frame/rightbottom.png",
   "img/frame/righttop.png",
   "img/frame/left.png",
   "img/frame/leftbottom.png",
   "img/frame/lefttop.png"
   }


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

local function endGame()

    local idx = lampiaoGroup.currentLampiao
    lampiao[idx].isVisible = false

    composer.setVariable( "finalScore", score )
    composer.setVariable( "fama", fama[indexFama] )
    composer.gotoScene( "gameover", { time=800, effect="crossFade" } )
end

----------- Cria inimigos na tela

local function criarInimigo()

    local inimigo = display.newImageRect( mainGroup, objectSheet, 0, 51, 70 )
    table.insert( inimigosTable, inimigo )

    if (table.getn(inimigosTable) > 2) then
        timer.cancel( gameLoopTimer )
        endGame();
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
            inimigo.posicao = "ec"
        elseif (altura == 2)then
            inimigo.y = lateral_meio
            inimigo.posicao = "em"
        elseif (altura == 3) then
            inimigo.y = lateral_baixo
            inimigo.posicao = "eb"
        end
        transition.to( inimigo, { x=0, time=100, } )

    elseif ( lado == 2 ) then
       -- Baixo
       inimigo.x = display.contentWidth/2
       inimigo.y = 300
       inimigo.posicao = "b"
       transition.to( inimigo, { y=280, time=100, } )
   elseif ( lado == 3 ) then
         -- Direita
         inimigo.x = display.contentWidth
         if (altura == 1) then
             inimigo.y = lateral_cima
             inimigo.posicao = "dc"
         elseif (altura == 2)then
             inimigo.y = lateral_meio
             inimigo.posicao = "dm"
         elseif (altura == 3) then
             inimigo.y = lateral_baixo
             inimigo.posicao = "db"
         end
         transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
     end

     local function tapListener(event)

        if (inimigo.posicao == 'dm') then
            local idx = lampiaoGroup.currentLampiao
            lampiao[idx].isVisible = false
            lampiaoGroup.currentLampiao = 2
            lampiao[lampiaoGroup.currentLampiao].isVisible = true

        elseif (inimigo.posicao == 'b') then
            local idx = lampiaoGroup.currentLampiao
            lampiao[idx].isVisible = false
            lampiaoGroup.currentLampiao = 1
            lampiao[lampiaoGroup.currentLampiao].isVisible = true

        elseif (inimigo.posicao == 'db') then
            local idx = lampiaoGroup.currentLampiao
            lampiao[idx].isVisible = false
            lampiaoGroup.currentLampiao = 3
            lampiao[lampiaoGroup.currentLampiao].isVisible = true

        elseif (inimigo.posicao == 'dc') then
            local idx = lampiaoGroup.currentLampiao
            lampiao[idx].isVisible = false
            lampiaoGroup.currentLampiao = 4
            lampiao[lampiaoGroup.currentLampiao].isVisible = true

        elseif (inimigo.posicao == 'em') then
            local idx = lampiaoGroup.currentLampiao
            lampiao[idx].isVisible = false
            lampiaoGroup.currentLampiao = 5
            lampiao[lampiaoGroup.currentLampiao].isVisible = true

        elseif (inimigo.posicao == 'eb') then
            local idx = lampiaoGroup.currentLampiao
            lampiao[idx].isVisible = false
            lampiaoGroup.currentLampiao = 6
            lampiao[lampiaoGroup.currentLampiao].isVisible = true

        elseif (inimigo.posicao == 'ec') then
            local idx = lampiaoGroup.currentLampiao
            lampiao[idx].isVisible = false
            lampiaoGroup.currentLampiao = 7
            lampiao[lampiaoGroup.currentLampiao].isVisible = true

        end


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



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

    backGroup = display.newGroup()
    sceneGroup:insert( backGroup )

    mainGroup = display.newGroup()
    sceneGroup:insert( mainGroup )

    uiGroup = display.newGroup()
    sceneGroup:insert( uiGroup )


    local background = display.newImageRect( backGroup, "img/fundo.jpg", 600, 350)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    for i = 1, #lampiaoImages do
       lampiao[i] = display.newImageRect( lampiaoGroup, lampiaoImages[i], 100, 100 )
       lampiao[i].x = display.contentCenterX
       lampiao[i].y = display.contentCenterY + 20
       lampiao[i].isVisible = false
    end
    lampiaoGroup.currentLampiao = 1
    lampiao[lampiaoGroup.currentLampiao].isVisible = true

    -- lampiao = display.newImageRect( mainGroup, "img/frame/bottom.png", 100, 100 )
    -- lampiao.x = display.contentCenterX
    -- lampiao.y = display.contentCenterY + 20

    ------ Seta estilo e cor para os labels de score e fama -------------
    scoreText = display.newText( uiGroup, "Score: "..score, display.contentCenterX, 20, "customfont.ttf", 13 )
    famaText = display.newText( uiGroup, "Cangaceiro "..fama[indexFama], display.contentCenterX, 60, "customfont.ttf", 13 )
    local colorBlack = { "gray" }
    scoreText:setFillColor( unpack(colorBlack) )
    famaText:setFillColor(unpack(colorBlack) )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
        physics.start()
        gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0 )



	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
