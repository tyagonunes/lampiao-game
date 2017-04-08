
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local score = 0
local inimigosTable = {}
local proxNivel = 5
local indexFama = 1
local inimigo
local gameLoopTimer
local scoreText
local famaText
local soundShot = audio.loadSound( "sounds/Shot.mp3" )
local grito = audio.loadSound ("sounds/grito-maria.mp3")

local fama = {
    "Sem fama", "Caldo de bila",
    "Fuleiragem",
    "Alma de gato",
    "Cabra bom",
    "Gota serena",
    "Cabra arretado",
    "Alma sebosa",
    "Cabra da peste",
    "Lampião"
}

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()


----------- Variaveis de medidas de tela para localização dos inimigos -----------
local midSide = display.contentHeight/2
local topSide = display.contentHeight/9
local bottomSide = display.contentHeight - 40



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
    scoreText.text = score
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

    local inimigo = display.newImageRect( mainGroup, "img/enemy.png", 51, 70 )
    table.insert( inimigosTable, inimigo )

    -- if (table.getn(inimigosTable) > 2) then
    --     timer.cancel( gameLoopTimer )
    --     endGame();
    -- end



    local randomPosition = math.random(6)

-- Posiciona o inimigo de acordo com o random
-- Legenda:
-- lm = left middle
-- Lt = Left top
-- lb = Left bottom

-- rm = Right middle
-- rt = Right top
-- rb = Right bottom


    local position = {
        [1] = function ()
            inimigo.x = -10
            inimigo.y = topSide
            inimigo.posicao = "lt"
            transition.to( inimigo, { x=0, time=100, } )
        end,
        [2] = function ()
            inimigo.x = -10
            inimigo.y = midSide
            inimigo.posicao = "lm"
            transition.to( inimigo, { x=0, time=100, } )
        end,
        [3] = function ()
            inimigo.x = -10
            inimigo.y = bottomSide
            inimigo.posicao = "lb"
            transition.to( inimigo, { x=0, time=100, } )
        end,

        [4] = function ()
             inimigo.x = display.contentWidth
             inimigo.y = topSide
             inimigo.posicao = "rt"
             transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
        end,
        [5] = function ()
             inimigo.x = display.contentWidth
             inimigo.y = midSide
             inimigo.posicao = "rm"
             transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
        end,
        [6] = function ()
             inimigo.x = display.contentWidth
             inimigo.y = bottomSide
             inimigo.posicao = "rb"
             transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
        end
    }

    position[randomPosition]()

    function dead ()
        timer.cancel( gameLoopTimer )
        endGame();
    end

    local gameoverTimer = timer.performWithDelay( 1000, dead, 1 )

    local function tapInimigo(event)


        local changeCharacterPosition = {

             ['rm'] = function () changeSprite(2) end,

             ['rb'] = function () changeSprite(3) end,

             ['rt'] = function () changeSprite(4) end,

             ['lm'] = function () changeSprite(5) end,

             ['lb'] = function () changeSprite(6) end,

             ['lt'] = function () changeSprite(7) end
        }

        function changeSprite (sprite)
             local idx = lampiaoGroup.currentLampiao
             lampiao[idx].isVisible = false
             lampiaoGroup.currentLampiao = sprite
             lampiao[lampiaoGroup.currentLampiao].isVisible = true
        end

        changeCharacterPosition[inimigo.posicao]()

        timer.cancel( gameoverTimer )

        display.remove( inimigo )

        for i = #inimigosTable, 1, -1 do
            if ( inimigosTable[i] == inimigo) then
                table.remove( inimigosTable, i )
                break
            end
        end

        score = score + 1

        updateScore();

        audio.play( soundShot )

     end

     inimigo:addEventListener( "touch", tapInimigo )
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


    ------ Seta estilo e cor para os labels de score e fama -------------
    scoreText = display.newText( uiGroup, score, display.contentCenterX, 20, "customfont.ttf", 18 )
    famaText = display.newText( uiGroup, "Cangaceiro "..fama[indexFama], display.contentCenterX, 60, "customfont.ttf", 13 )
    scoreText:setFillColor( gray )
    famaText:setFillColor( gray )

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
