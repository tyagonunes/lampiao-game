
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local score = 0
local speed = 1500
local inimigosTable = {}
local proxNivel = 10
local indexFama = 1
local inimigo
local gameLoopTimer
local scoreText
local famaText
local soundShot = audio.loadSound( "assets/sounds/Shot2.mp3" )
local soundPain = audio.loadSound( "assets/sounds/pain.mp3" )
local fama = {
    "Iniciante", "Caldo de bila", "Fuleiragem",
    "Alma de gato", "Cabra bom", "da Gota serena",
    "Cabra arretado", "Alma sebosa", "Cabra da peste",
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
   "assets/img/frame/initial.png",
   "assets/img/frame/dead.png",
   "assets/img/frame/right.png",
   "assets/img/frame/rightbottom.png",
   "assets/img/frame/righttop.png",
   "assets/img/frame/left.png",
   "assets/img/frame/leftbottom.png",
   "assets/img/frame/lefttop.png"
}



-----------------------------------------------------
------------------ Funções --------------------------
------------------------------------------------------



------------- Atualiza o status da fama -------------

function updateFama ()
    if (score >= proxNivel) then
        if (indexFama < table.getn(fama)) then
            proxNivel = proxNivel + 10
            indexFama = indexFama + 1            
            famaText.text = ""..fama[indexFama]
            speed = speed - 100
            timer.cancel(gameLoopTimer)
            start(speed)
        end
    end
end

----------- Atualiza o score -----------------------

function updateScore ()
    scoreText.text = "Vítimas: "..score
    updateFama()
end

 local changeCharacterPosition = {
     ['rm'] = function () changeSprite(3) end,
     ['rb'] = function () changeSprite(4) end,
     ['rt'] = function () changeSprite(5) end,
     ['lm'] = function () changeSprite(6) end,
     ['lb'] = function () changeSprite(7) end,
     ['lt'] = function () changeSprite(8) end
        }

    function changeSprite (sprite)
         local idx = lampiaoGroup.currentLampiao
         lampiao[idx].isVisible = false
          lampiao[1].isVisible = false
         lampiaoGroup.currentLampiao = sprite
         lampiao[lampiaoGroup.currentLampiao].isVisible = true

         if (sprite ~= 2) then
            timer.performWithDelay( 300, function ()
               lampiao[lampiaoGroup.currentLampiao].isVisible = false
               lampiao[1].isVisible = true
            end )
         end
    end


local function endGame()
    
    for i = 1, #lampiaoImages do
       lampiao[i].isVisible = false
    end

    --lampiao[lampiaoGroup.currentLampiao].isVisible = false
    composer.setVariable( "finalScore", score )
    composer.setVariable( "fama", fama[indexFama] )
    composer.gotoScene( "gameover", { time=800, effect="crossFade" } )
end

----------- Cria inimigos na tela

local function criarInimigo()

    local inimigo = display.newImageRect( mainGroup, "assets/img/inimigo.png", 70, 70 )
    table.insert( inimigosTable, inimigo )
    local randomPosition = math.random(6)

    if (table.getn(inimigosTable) > 3) then
        
        audio.play ( soundPain )
        timer.cancel( gameLoopTimer )
        changeSprite(2)

        timer.performWithDelay( 3000, function ()
            endGame();
        end )
    end

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
             inimigo.xScale = -1
             transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
        end,
        [5] = function ()
             inimigo.x = display.contentWidth
             inimigo.y = midSide
             inimigo.posicao = "rm"
             inimigo.xScale = -1
             transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
        end,
        [6] = function ()
             inimigo.x = display.contentWidth
             inimigo.y = bottomSide
             inimigo.posicao = "rb"
             inimigo.xScale = -1
             transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
        end
    }

    position[randomPosition]()


   -- local gameoverTimer = timer.performWithDelay( 2000, dead, 1 )

    local function tapInimigo(event)


        changeCharacterPosition[inimigo.posicao]()
        --timer.cancel( gameoverTimer )
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


function start (speed)
    gameLoopTimer = timer.performWithDelay( speed, criarInimigo, 0 )
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


    local background = display.newImageRect( backGroup, "assets/img/fundo_cordel.jpg", 600, 350)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    for i = 1, #lampiaoImages do
       lampiao[i] = display.newImageRect( lampiaoGroup, lampiaoImages[i], 300, 240 )
       lampiao[i].x = display.contentCenterX
       lampiao[i].y = display.contentCenterY + 20
       lampiao[i].isVisible = false
    end

    lampiaoGroup.currentLampiao = 1
    lampiao[lampiaoGroup.currentLampiao].isVisible = true

    ------ Seta estilo e cor para os labels de score e fama -------------
    scoreText = display.newText( uiGroup, "Vítimas: "..score, display.contentCenterX, 20, "assets/fonts/xilosa.ttf", 20 )
    famaText = display.newText( uiGroup, ""..fama[indexFama], display.contentCenterX, 60, "assets/fonts/xilosa.ttf", 16 )
    scoreText:setFillColor( gray )
    famaText:setFillColor( gray )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
      start(speed)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

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
