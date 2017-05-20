
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local score = 0
local speed = 1000
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
    "Cangaceiro iniciante", "Cangaceiro caldo de bila", "Cangaceiro fuleiragem",
    "Cangaceiro alma de gato", "Cangaceiro cabra bom", "Cangaceiro da gota serena",
    "Cangaceiro cabra arretado", "Cangaceiro alma sebosa", "Cangaceiro cabra da peste",
    "Cangaceiro Lampião"
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

function never( )
    -- body
end

function updateFama ()
    if (score >= proxNivel) then
        if (indexFama < table.getn(fama)) then
            proxNivel = proxNivel + 15
            indexFama = indexFama + 1            
            famaText.text = "Nível: "..fama[indexFama]
            speed = speed - 80
            timer.cancel(gameLoopTimer)
            start(speed)
        end
    end
end

----------- Atualiza o score -----------------------

function updateScore ()
    scoreText.text = "Pontos: "..score
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
            timer.performWithDelay( 200, function ()
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

--- Cria inimigos na tela

local function criarInimigo()

   

    local randomPosition = math.random(6)

    -- Procura de dentro do array de inimigos existe um frame da posição pra evitar repetição. Se existir pula a criação
    local  statusRandom = true;
    for i = #inimigosTable, 1, -1 do
        if ( inimigosTable[i].order == randomPosition) then
            statusRandom = false
            break
        end
    end

    if (statusRandom) then
        local inimigo = display.newImageRect( mainGroup, "assets/img/inimigo.png", 50, 60 )
        table.insert( inimigosTable, inimigo )

        local position = {
            [1] = function ()
                inimigo.x = -10
                inimigo.y = topSide
                inimigo.posicao = "lt"
                inimigo.order = 1
                transition.to( inimigo, { x=0, time=100, } )
            end,
            [2] = function ()
                inimigo.x = -10
                inimigo.y = midSide
                inimigo.posicao = "lm"
                inimigo.order = 2
                transition.to( inimigo, { x=0, time=100, } )
            end,
            [3] = function ()
                inimigo.x = -10
                inimigo.y = bottomSide
                inimigo.posicao = "lb"
                inimigo.order = 3
                transition.to( inimigo, { x=0, time=100, } )
            end,

            [4] = function ()
                 inimigo.x = display.contentWidth
                 inimigo.y = topSide
                 inimigo.posicao = "rt"
                 inimigo.xScale = -1
                 inimigo.order = 4
                 transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
            end,
            [5] = function ()
                 inimigo.x = display.contentWidth
                 inimigo.y = midSide
                 inimigo.posicao = "rm"
                 inimigo.xScale = -1
                 inimigo.order = 5
                 transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
            end,
            [6] = function ()
                 inimigo.x = display.contentWidth
                 inimigo.y = bottomSide
                 inimigo.posicao = "rb"
                 inimigo.xScale = -1
                 inimigo.order = 6
                 transition.to( inimigo, { x=display.contentWidth -10, time=100, } )
            end
        }

       
        position[randomPosition]()
        

        local function tapInimigo(event)
            audio.play( soundShot )
            changeCharacterPosition[inimigo.posicao]()
            display.remove( inimigo )

            for i = #inimigosTable, 1, -1 do
                if ( inimigosTable[i] == inimigo) then
                    table.remove( inimigosTable, i )
                    break
                end
            end

            score = score + 1
            updateScore();
         end

        inimigo:addEventListener( "touch", tapInimigo )

          -- Testa se tem mais de 3 inimigos na tela. Se tiver chama 0 gameover senao permite concluir o resto da criação de inimigo
        if (table.getn(inimigosTable) > 2) then
            
            audio.play ( soundPain )
            timer.cancel( gameLoopTimer )
            changeSprite(2)

            for i = #inimigosTable, 1, -1 do
                 inimRest = inimigosTable[i];
                 display.remove( inimRest )
                
            end

           -- local ban = display.newRect(0, 0, 300*5, 300*5)
           -- ban:setFillColor(0,0,0,0.3)
            --ban.strokeWidth = 6


            timer.performWithDelay( 1000, function ()
                endGame();
            end )
        end
    end
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
    scoreText = display.newText( uiGroup, "Pontos: "..score, display.contentCenterX, 20, "assets/fonts/xilosa.ttf", 20 )
    famaText = display.newText( uiGroup, "Nível: "..fama[indexFama], display.contentCenterX, 60, "assets/fonts/xilosa.ttf", 16 )
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
