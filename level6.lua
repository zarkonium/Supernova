--See level1.lua for comments template

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
	
	local level = 6
	myApp.level = level
	local radius = 6
	local activeCircles = 0
	local numCircles = 9
	local numBigCircles = 0
	local score = 0
	local targetScore = 5
	local targetMessage = "Destroy " .. targetScore .. " stars"
	local isPlanted = true
	local canStart = false
	local collapseTime = 1500
	local displayScore
	local dimBg
	local beginRound
	
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
	
	--------------------------------------
	---------- Obstacles Begin --------------
	--------------------------------------
	
	local R,G,B = 231/255, 148/255, 120/255
	
	local star1 = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
	star1.x = 70
	star1.y = 102
	star1:setFillColor(R,G,B)
	physics.addBody (star1, "static", {friction=0, radius=radius})
	
	local star2 = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
	star2.x = 98
	star2.y = 190
	star2:setFillColor(R,G,B)
	physics.addBody (star2, "static", {friction=0, radius=radius})
	
	local star3 = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
	star3.x = 155
	star3.y = 250 
	star3:setFillColor(R,G,B)
	physics.addBody (star3, "static", {friction=0, radius=radius})
	
	local star4 = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
	star4.x = 293
	star4.y = 300
	star4:setFillColor(R,G,B)
	physics.addBody (star4, "static", {friction=0, radius=radius})
	
	local star5 = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
	star5.x = 248
	star5.y = 370
	star5:setFillColor(R,G,B)
	physics.addBody (star5, "static", {friction=0, radius=radius})
	
	local star6 = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
	star6.x = 170
	star6.y = 340
	star6:setFillColor(R,G,B)
	physics.addBody (star6, "static", {friction=0, radius=radius})
	
	local line1 = display.newLine( group, star1.x, star1.y, star2.x, star2.y, star3.x, star3.y, star4.x, star4.y, star5.x, star5.y, star6.x, star6.y, star3.x, star3.y )
	line1:setStrokeColor( R,G,B )
	line1.strokeWidth = 3
	physics.addBody (line1, "static", {friction=0})
	
	
	--------------------------------------
	---------- Obstacles End ---------------
	--------------------------------------
	
	
	local function spawnCircle( event, r, g, b )
		if event.phase == "ended" and not isPlanted then	
			--local circ = display.newCircle(group, event.x, event.y, radius )
			local circ = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
			circ.x = event.x
			circ.y = event.y
			circ.isActive = true
			isPlanted = true
			
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
		if event.phase == "ended" and not canStart then
			beginRound()
		end
	end
	
	for i = 1,numCircles do
		local circ = display.newImageRect( group, "images/circle.png", 2*radius, 2*radius )
		circ.x = 30 + (display.contentWidth - 60)*math.random()
		circ.y = 30 + (display.contentHeight - 60)*math.random()
		local r,g,b
		if i <= numBigCircles then
			circ.finalScale = 14
			r = math.random(80,100)/100
			g, b = r, 0
		else
			if i == 1 then
				circ.x = 250
				circ.y = 330
			end
			circ.finalScale = 7
			r = math.random(50,100)/100
			g, b = r, r
		end
		
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
				transition.to(circ, {time=150, xScale = circ.finalScale, yScale=circ.finalScale, alpha = .5, onComplete = makeBody})
			end
		end
		
		circ:addEventListener( "collision", onCollision )
		
	end
	
	displayScore = display.newText( group, score .. "/" .. targetScore, display.contentWidth - 16, display.contentHeight - 14, "HelveticaNeue-Light", 18 )
	displayScore.anchorX = 1
	displayScore.anchorY = 1
	
	local instructions = display.newImageRect( group, "images/instructions.png", 320,128 )
	instructions.x = -184
	instructions.y = 190
	
	local instructionsText = display.newText( group, targetMessage, -100, 194, "HelveticaNeue-UltraLight", 18 )
	instructionsText:setFillColor(0)
	
	transition.to(instructions, {time=200,x = 154})
	transition.to(instructionsText, {time=200,x = 114})
	
	local button1 = display.newImageRect( group, "images/button.png", 320,64 )
	button1.x = -154
	button1.y = 272
	local button1Text = display.newText( group, "Retry", -100, 272, "HelveticaNeue-UltraLight", 18 )
	button1Text:setFillColor(0)
	local button2 = display.newImageRect( group, "images/button.png", 320,64 )
	button2.x = -154
	button2.y = 330
	local button2Text = display.newText( group, "Menu", -100, 330, "HelveticaNeue-UltraLight", 18 )
	button2Text:setFillColor(0)
	
	local function endRound()
		if activeCircles == 0 and isPlanted and canStart then
			--isPlanted = false
			Runtime:removeEventListener ( "touch", spawnCircle )
        	Runtime:removeEventListener ( "enterFrame", endRound )
			if score >= targetScore then
				instructionsText.text = "Success"
				transition.to(instructions, {time=200,x = 154})
				transition.to(instructionsText, {time=200,x = 114})
				
				local function advance()
					myApp.settings.maxLevel = math.max(myApp.settings.maxLevel, level + 1)
					myApp.saveTable(myApp.settings, "settings.json")
					transition.to ( dimBg, {time=500, easing = outExpo, alpha=1, onComplete = function() storyboard.gotoScene ( "menu" ) end} )
				end
				
				timer.performWithDelay ( 1000, advance, 1 )
			else
			
				local function retry( event )
					if event.phase == "ended" then
						--storyboard.purgeScene ( storyboard.getCurrentSceneName() )
						--storyboard.reloadScene()
						storyboard.gotoScene ( "tryagain" )
					end
				end
				
				local function goToMenu( event )
					if event.phase =="ended" then
						transition.to ( dimBg, {time=500, easing = outExpo, alpha=1, onComplete = function() storyboard.gotoScene ( "menu" ) end} )
					end
				end
				
				instructionsText.text = "Failure"
				
				button1:addEventListener ( "touch", retry )
				button2:addEventListener ( "touch", goToMenu )
				
				transition.to(instructions, {time=200,x = 154})
				transition.to(instructionsText, {time=200,x = 114})
				transition.to(button1, {time=200,x = 142})
				transition.to(button1Text, {time=200,x = 102})
				transition.to(button2, {time=200,x = 128})
				transition.to(button2Text, {time=200,x = 98})
				
			end
		end
	end
	
	function beginRound()
		transition.to(instructions, {time=200,x = -194})
		transition.to(instructionsText, {time=200,x = -100})
		isPlanted = false
		canStart = true
	end
	
	dimBg = display.newRect( group, centerX, centerY, display.contentWidth, display.contentHeight )
	dimBg:setFillColor(0)
	dimBg.alpha = .01
	
	--timer.performWithDelay ( 1500, beginRound, 1 )
	
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












