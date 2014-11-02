local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local myApp = require( "myApp" ) 
local physics = require( "physics" )

function scene:createScene( event )
	local group = self.view
	physics.start()
	physics.setGravity( 0, 0 )
	
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY
	
	local level = 1
	local radius = 6
	local activeCircles = 0
	local numCircles = 8
	local score = 0
	local targetScore = 4
	local isPlanted = true
	local canStart = false
	local collapseTime = 1500
	local displayScore
	
	local bg = display.newImageRect( group, "images/levelBg.png", display.contentWidth, display.contentHeight )
	bg.x = centerX
	bg.y = centerY
	
	local edgeCollisionFilter = { categoryBits=1, maskBits=1 } 
	local circCollisionFilter = { categoryBits=2, maskBits=1 } 
	local circCollisionFilter2 = { categoryBits=3, maskBits=2 } 
	
	local topEdge = display.newRect(group, centerX, 10, display.contentWidth - 26, 6 )
	physics.addBody ( topEdge, "static",{friction = 0})
	local bottomEdge = display.newRect(group, centerX, display.contentHeight - 10, display.contentWidth - 26, 6 )
	physics.addBody ( bottomEdge, "static",{friction = 0})
	local leftEdge = display.newRect(group, 10, centerY, 6, display.contentHeight - 14 )
	physics.addBody ( leftEdge, "static",{friction = 0})
	local rightEdge = display.newRect(group, display.contentWidth - 10, centerY, 6, display.contentHeight - 14 )
	physics.addBody ( rightEdge, "static",{friction = 0})
	topEdge.alpha = .5
	bottomEdge.alpha = .5
	leftEdge.alpha = .5
	rightEdge.alpha = .5
	
	local function spawnCircle( event, r, g, b )
		if event.phase == "ended" and not isPlanted then	
			--local circ = display.newCircle(group, event.x, event.y, radius )
			local circ = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
			circ.x = event.x
			circ.y = event.y
			circ.isActive = true
			isPlanted = true
			--circ.alpha = .5
			--physics.addBody( circ, "static", { density=1.0, bounce=1, radius=radius, filter=circCollisionFilter2 } )
			
			--local function remakeBodyRadius()
	--			physics.removeBody( circ )
	--			physics.addBody( circ, "static", { density=1.0, bounce=1, radius=radius*circ.xScale, filter=circCollisionFilter2 } )
	--		end
			--timer.performWithDelay ( 20, remakeBodyRadius, 5 )
			
			local function makeBody()
				physics.addBody( circ, "static", { density=1.0, bounce=1, radius=radius*circ.xScale, filter=circCollisionFilter2 } )
				
				local function removeBody()
					activeCircles = activeCircles - 1
					physics.removeBody( circ )
					circ:removeSelf()
					circ = nil
				end
				
				timer.performWithDelay ( collapseTime, function() transition.to(circ, {time=150, xScale = 0.1, yScale=0.1, alpha = 0, onComplete = removeBody}) end,1 )
				
			end
			
			activeCircles = activeCircles + 1
			transition.to(circ, {time=150, xScale = 7, yScale=7, alpha = .5, onComplete = makeBody})
			
		end
	end
	
	for i = 1,numCircles do
		--local circ = display.newCircle(group, 30 + (display.contentWidth - 60)*math.random(), 30 + (display.contentHeight - 60)*math.random(), radius )
		local circ = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
		circ.x = 30 + (display.contentWidth - 60)*math.random()
		circ.y = 30 + (display.contentHeight - 60)*math.random()
		--local r, g, b = math.random(), math.random(), math.random()
		local r = math.random(50,100)/100
		local g, b = r, r
		circ:setFillColor ( r, g, b )
		physics.addBody( circ, "dynamic", { density=1.0, bounce=1, friction=0, radius=radius, filter=circCollisionFilter } )
		local direction= 90*math.random(0,3) + math.random(200,700)/10
		local speed = 100
		circ:setLinearVelocity (speed * math.cos(direction * math.pi / 180), speed * math.sin(direction * math.pi / 180))
		
		local function onCollision(event)
			if event.phase == "began" and event.other.isActive and not circ.isActive then
				score = score + 1
				displayScore.text = score .. "/" .. targetScore
				circ.isActive = true
				circ:setLinearVelocity (0, 0)
				local function makeBody()
					physics.removeBody( circ )
					physics.addBody( circ, "static", { density=1.0, bounce=1, radius=radius*circ.xScale, filter=circCollisionFilter2 } )
					circ.isActive = true
					
					local function removeBody()
						activeCircles = activeCircles - 1
						physics.removeBody( circ )
						circ:removeSelf()
						circ = nil
					end
					
					timer.performWithDelay ( collapseTime, function() transition.to(circ, {time=150, xScale = 0.1, yScale=0.1, alpha = 0, onComplete = removeBody}) end,1 )
					
				end
				
				activeCircles = activeCircles + 1
				transition.to(circ, {time=150, xScale = 7, yScale=7, alpha = .5, onComplete = makeBody})
			end
		end
		
		circ:addEventListener( "collision", onCollision )
		
	end
	
	displayScore = display.newText( group, score .. "/" .. targetScore, display.contentWidth - 16, display.contentHeight - 14, "HelveticaNeue-Light", 18 )
	displayScore.anchorX = 1
	displayScore.anchorY = 1
	
	local function endRound()
		if activeCircles == 0 and isPlanted and canStart then
			print("<---------------- game over ------------------->")
			isPlanted = false
			Runtime:removeEventListener ( "touch", spawnCircle )
        	Runtime:removeEventListener ( "enterFrame", endRound )
			if score >= targetScore then
				myApp.settings.maxLevel = math.max(myApp.settings.maxLevel, level + 1)
				myApp.saveTable(myApp.settings.maxLevel, "level.json")
				storyboard.gotoScene ( "menu" )
			else
				storyboard.purgeScene ( storyboard.getCurrentSceneName() )
				storyboard.reloadScene()
			end
		end
	end
	
	local instructions = display.newImageRect( group, "images/instructions.png", 320,128 )
	instructions.x = -154
	instructions.y = 190
	
	local instructionsText = display.newText( group, "Destroy " .. targetScore .. " stars", -100, 194, "HelveticaNeue-UltraLight", 18 )
	instructionsText:setFillColor(0)
	
	transition.to(instructions, {time=200,x = 154})
	transition.to(instructionsText, {time=200,x = 114})
	
	local function beginRound()
		transition.to(instructions, {time=200,x = -154})
		transition.to(instructionsText, {time=200,x = -100})
		isPlanted = false
		canStart = true
	end
	
	timer.performWithDelay ( 1500, beginRound, 1 )
	
	Runtime:addEventListener ( "touch", spawnCircle )
	Runtime:addEventListener ( "enterFrame", endRound )
	
			
end


function scene:enterScene( event )
        local group = self.view

end

function scene:exitScene( event )
        local group = self.view
end

function scene:destroyScene( event )
        local group = self.view

end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene









