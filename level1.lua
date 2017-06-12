-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
local timer = require "timer"

local newBox = require ("box").newBox

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


function scene:create( event )


	local sceneGroup = self.view

	physics.start()
	physics.pause()

	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	--background:setFillColor( .5 )
  display.setDefault( "textureWrapX", "repeat" )
  display.setDefault( "textureWrapY", "repeat" )
	background.fill = {type = 'image', filename = 'fill-2.png'}
  
  background.fill.scaleX = 0.1
  background.fill.scaleY = 0.1
  
  
  local bx = {};
  table.insert(bx, newBox({scene = sceneGroup, n = 1}))
  table.insert(bx, newBox({scene = sceneGroup, n = 1}))
  
  timer.performWithDelay(1000, function()
    local bn = newBox({scene = sceneGroup, n = 1})
    if(bn == 'near') then 
      physics.stop();
      composer.gotoScene( "gameover", "fade", 500 ) 
    end
    table.insert(bx,bn)
    bn:addToScene();
  end, 0)

  
  
  
	local grass = display.newImageRect( "grass.png", screenW, 1 )
	grass.anchorX = 0
	grass.anchorY = 1
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	physics.addBody( grass, "static", { friction=0.3 } )	
  local grass2 = display.newImageRect( "grass.png", screenW, 1 )
	grass2.anchorX = 0
	grass2.anchorY = 1
	grass2.x, grass2.y = display.screenOriginX, display.screenOriginY
	physics.addBody( grass2, "static", { friction=0.3 } )
  
  local grass3 = display.newImageRect( "grass.png", 1, screenH )
	grass3.anchorX = 1
	grass3.anchorY = 0
	grass3.x, grass3.y = display.screenOriginX, display.screenOriginY
	physics.addBody( grass3, "static", { friction=0.3 } )	
  local grass4 = display.newImageRect( "grass.png", 1, screenH )
	grass4.anchorX = 1
	grass4.anchorY = 0
	grass4.x, grass4.y = display.screenOriginX+display.actualContentWidth, display.screenOriginY
	physics.addBody( grass4, "static", { friction=0.3 } )
	
	-- all display objects must be inserted into group
  sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( grass2)
  sceneGroup:insert( grass3)
	sceneGroup:insert( grass4)
	--sceneGroup:insert( crate )
  --sceneGroup:insert( crate2 )
  
  for _,b in pairs(bx) do
    b:addToScene();
  end
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end


-- Set accelerometer to maximum responsiveness
system.setAccelerometerInterval( 100 )

-- Function to adjust gravity based on accelerometer response
local function onTilt( event )
	-- Gravity is in portrait orientation on Android, iOS, and Windows Phone
	-- On tvOS, gravity is in the orientation of the device attached to the event
	if ( event.device ) then
		physics.setGravity( ( 9.8 * event.xGravity ), ( -9.8 * event.yGravity ) )
	else
		physics.setGravity( ( -9.8 * event.yGravity ), ( -9.8 * event.xGravity ) )
	end
end

Runtime:addEventListener( "accelerometer", onTilt )

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene