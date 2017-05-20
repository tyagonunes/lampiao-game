
local composer = require( "composer" )
local json = require( "json" )

local scene = composer.newScene()

 -- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local scoresTable;
local record;
 
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local function loadScores()
 
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        record = json.decode( contents )
    end
 
    if ( record == nil ) then
        record = 0;
    end
end


local function saveScores()
 
    -- for i = #scoresTable, 11, -1 do
    --     table.remove( scoresTable, i )
    -- end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end


local function gotoGame()
    composer.gotoScene( "game", { time=400, effect="crossFade" } )
end

local function gotoMenu()
    audio.stop()  -- Stop all audio
    audio.dispose( music )  -- Release music handle
    composer.gotoScene( "menu", { time=400, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
   
    loadScores()

    local score = composer.getVariable( "finalScore" )
    local fama = composer.getVariable( "fama" )

    --composer.setVariable( "finalScore", 0 )

    if (score > record) then
        scoresTable = score;
        saveScores()
    end

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "assets/img/fundo_cordel.jpg", 600, 350 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY


    local title = display.newText( sceneGroup, "VOCÊ FOI PEGO", display.contentCenterX, 60, "assets/fonts/xilosa.ttf", 30 )
    title:setFillColor( gray )

    local scoreLabel = display.newText( sceneGroup, "Pontos: ".. score, display.contentCenterX-80, 120, "assets/fonts/xilosa.ttf", 20 )
    scoreLabel:setFillColor( gray )
   
    local famaLabel = display.newText( sceneGroup, "Recorde: "..record, display.contentCenterX+80, 120, "assets/fonts/xilosa.ttf", 18 )
    famaLabel:setFillColor( gray )

    local famaTitle = display.newText( sceneGroup, "Nível alcançado: "..fama, display.contentCenterX, 160, "assets/fonts/xilosa.ttf", 18 )
    famaTitle:setFillColor( gray )


    local playButton = display.newText( sceneGroup, "NOVAMENTE", display.contentCenterX - 50, 210, "assets/fonts/xilosa.ttf", 23 )
    playButton:setFillColor( gray )

    local menuButton = display.newText( sceneGroup, "INÍCIO", display.contentCenterX + 70, 210, "assets/fonts/xilosa.ttf", 23 )
    menuButton:setFillColor( gray )

    local iconEnemy = display.newText( sceneGroup, "_", -400, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 60 )
    iconEnemy:setFillColor( gray )
    transition.to( iconEnemy, { x=display.contentWidth + 150, time=150000, } )

    local iconLampiao = display.newText( sceneGroup, "!", -200, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 50 )
    iconLampiao:setFillColor( gray )
    transition.to( iconLampiao, { x=display.contentWidth + 150, time=100000, } )

    local iconHouse = display.newText( sceneGroup, "$", 40, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 60 )
    iconHouse:setFillColor( gray )
    transition.to( iconHouse, { x=display.contentWidth + 150, time=80000, } )

    local iconPlants = display.newText( sceneGroup, "&", display.contentWidth - 40, display.contentHeight - 40, "assets/fonts/cordel_I.ttf", 60 )
    iconPlants:setFillColor( gray )
    transition.to( iconPlants, { x=display.contentWidth + 150, time=40000, } )

    playButton:addEventListener( "touch", gotoGame )
    menuButton:addEventListener( "touch", gotoMenu )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

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

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
         composer.removeScene( "gameover" )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  --composer.removeScene( "gameover" )

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
