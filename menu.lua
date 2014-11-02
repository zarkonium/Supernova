local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local myApp = require( "myApp" ) 
local widget = require("widget")

local paralaxEffect

function scene:createScene( event )
		local group = self.view
		local centerX = display.contentCenterX
		local centerY = display.contentCenterY
		local dimBg
		
		local bgGroup = display.newGroup()
		
		local scrollView = widget.newScrollView
			{
			    top = 0,
			    left = 0,
			    width = display.contentWidth,
			    height = display.contentHeight,
			    scrollWidth = display.contentWidth,
			    scrollHeight = display.contentHeight,
			    friction = .9,
			    horizontalScrollDisabled = true,
			    isBounceEnabled = false,
			    topPadding = -100,
			    hideScrollBar = true,
			    listener = scrollListener
			}
			
		scrollView:insert(bgGroup)
		
		local bg1 = display.newImageRect( bgGroup, "images/bg1.png", display.contentWidth, display.contentHeight )
		bg1.x = centerX
		bg1.y = 2*display.contentHeight + centerY
		
		local bg2 = display.newImageRect( bgGroup, "images/bg2.png", display.contentWidth, display.contentHeight )
		bg2.x = centerX
		bg2.y = display.contentHeight + centerY
		
		local bg3 = display.newImageRect( bgGroup, "images/bg3.png", display.contentWidth, display.contentHeight )
		bg3.x = centerX
		bg3.y = centerY
		
		for i=1,100 do
			local star = display.newImageRect( bgGroup, "images/star.png", 16, 16 )
			star.x = math.random(0,display.contentWidth)
			star.y = math.random(40,3*display.contentHeight-40)
			star.alpha = math.random(0,5)/10
			transition.blink( star, {time=math.random(3000,5000), alpha = math.random(0,5)/10, width = 24, height = 24} )
		end
		
		local function createComet(x,y)
			local comet = display.newImageRect( bgGroup, "images/comet.png", 36, 12 )
			if x and y then
				comet.x = x
				comet.y = y
				comet.startSide = 1
			else
				comet.startSide = math.random(0,1)
				comet.x = - 80 + comet.startSide * ( display.contentWidth + 160 )
				comet.y = math.random(300,3*display.contentHeight - 300)
			end
			comet.rotation = - 135 + comet.startSide * 90
			comet.alpha = .2
			comet.startX = comet.x
			comet.startY = comet.y
			if comet.startSide == 0 then
				transition.to(comet, {time=5000, x=display.contentWidth + 80, y = comet.startY + ( display.contentWidth + 160 )})
			else
				transition.to(comet, {time=5000, x=-80, y = comet.startY + ( display.contentWidth + 160 )})
			end
		end
		
		createComet(display.contentWidth + 80,1200)
		local cometTimer = timer.performWithDelay ( 3000, createComet, 0 )
		
		
		scrollView:scrollToPosition( {y=- 2*display.contentHeight, time=0, onComplete = function() scrollView:scrollToPosition( {y=- 2*display.contentHeight +90*math.min( 11,(myApp.settings.maxLevel-1)), time=1000}) end} )
		
		
		group:insert(scrollView)
		
		local function goToScene( event )
			if event.target.alpha == 1 and event.phase == "ended" then
				timer.cancel( cometTimer )
				if myApp.settings.seenInstructions then
					transition.to ( dimBg, {time=500, easing = outExpo, alpha=1, onComplete = function() storyboard.gotoScene ( "level" .. event.target.id ) end} )
				else
					storyboard.gotoScene ( "help")
				end
			end
			return true
		end
		
		----------------------------------------
		----------- Level Buttons Begin ------------
		-----------------------------------------
		
		local button1 = display.newImageRect( bgGroup, "images/levels/1.png", 70, 70 )
		button1.id = 1
		button1.x = 240
		button1.y = 3*display.contentHeight - 160
		if myApp.settings.maxLevel < button1.id then
			button1.alpha = .5
		end
		button1:addEventListener ( "touch", goToScene )
		
		local button2 = display.newImageRect( bgGroup, "images/levels/2.png", 70, 70 )
		button2.id = 2
		button2.x = 140
		button2.y = 3*display.contentHeight - 240
		if myApp.settings.maxLevel < button2.id then
			button2.alpha = .5
		end
		button2:addEventListener ( "touch", goToScene )
		
		local button3 = display.newImageRect( bgGroup, "images/levels/3.png", 70, 70 )
		button3.id = 3
		button3.x = 54
		button3.y = 3*display.contentHeight - 340
		if myApp.settings.maxLevel < button3.id then
			button3.alpha = .5
		end
		button3:addEventListener ( "touch", goToScene )
		
		local button4 = display.newImageRect( bgGroup, "images/levels/4.png", 70, 70 )
		button4.id = 4
		button4.x = 148
		button4.y = 3*display.contentHeight - 468
		if myApp.settings.maxLevel < button4.id then
			button4.alpha = .5
		end
		button4:addEventListener ( "touch", goToScene )
		
		local button5 = display.newImageRect( bgGroup, "images/levels/5.png", 70, 70 )
		button5.id = 5
		button5.x = 246
		button5.y = 3*display.contentHeight - 570
		if myApp.settings.maxLevel < button5.id then
			button5.alpha = .5
		end
		button5:addEventListener ( "touch", goToScene )
		
		local button6 = display.newImageRect( bgGroup, "images/levels/6.png", 70, 70 )
		button6.id = 6
		button6.x = 214
		button6.y = 2*display.contentHeight - 142
		if myApp.settings.maxLevel < button6.id then
			button6.alpha = .5
		end
		button6:addEventListener ( "touch", goToScene )
		
		local button7 = display.newImageRect( bgGroup, "images/levels/7.png", 70, 70 )
		button7.id = 7
		button7.x = 110
		button7.y = 2*display.contentHeight - 252
		if myApp.settings.maxLevel < button7.id then
			button7.alpha = .5
		end
		button7:addEventListener ( "touch", goToScene )
		
		local button8 = display.newImageRect( bgGroup, "images/levels/8.png", 70, 70 )
		button8.id = 8
		button8.x = 110
		button8.y = 2*display.contentHeight - 402
		if myApp.settings.maxLevel < button8.id then
			button8.alpha = .5
		end
		button8:addEventListener ( "touch", goToScene )
		
		local button9 = display.newImageRect( bgGroup, "images/levels/9.png", 70, 70 )
		button9.id = 9
		button9.x = 210
		button9.y = 2*display.contentHeight - 502
		if myApp.settings.maxLevel < button9.id then
			button9.alpha = .5
		end
		button9:addEventListener ( "touch", goToScene )
		
		local button10 = display.newImageRect( bgGroup, "images/levels/10.png", 70, 70 )
		button10.id = 10
		button10.x = 270
		button10.y = display.contentHeight - 52
		if myApp.settings.maxLevel < button10.id then
			button10.alpha = .5
		end
		button10:addEventListener ( "touch", goToScene )
		
		local button11 = display.newImageRect( bgGroup, "images/levels/11.png", 70, 70 )
		button11.id = 11
		button11.x = 186
		button11.y = display.contentHeight - 150
		if myApp.settings.maxLevel < button11.id then
			button11.alpha = .5
		end
		button11:addEventListener ( "touch", goToScene )
		
		local button12 = display.newImageRect( bgGroup, "images/levels/12.png", 70, 70 )
		button12.id = 12
		button12.x = 76
		button12.y = display.contentHeight - 236
		if myApp.settings.maxLevel < button12.id then
			button12.alpha = .5
		end
		button12:addEventListener ( "touch", goToScene )
		
		---------------------------------------
		----------- Level Buttons End ------------
		---------------------------------------
		
		local houseImg = display.newImageRect( group, "images/house.png", 256, 128 )
		houseImg.x = 128
		houseImg.y = display.contentHeight - 64
		
		local logo = display.newImageRect( group, "images/supernova.png", 256, 64 )
		logo.x = 204
		logo.y = display.contentHeight - 346
		
		local dimEdge = display.newImageRect( group, "images/edgeFade.png", display.contentWidth, display.contentHeight )
		dimEdge.x = centerX
		dimEdge.y = centerY
		dimEdge:setFillColor(1)
		dimEdge.alpha = 0.1
		
		dimBg = display.newRect( group, centerX, centerY, display.contentWidth, display.contentHeight )
		dimBg:setFillColor(0)
		dimBg.alpha = .01
		
		dimBg:toFront()
		
		--transition.to(dimBg, {time = 1500, alpha = 1})
		function paralaxEffect()
			local x, y = scrollView:getContentPosition()
			houseImg.x = math.min(128 - (y+1136) , 128)
			houseImg.y = math.max(display.contentHeight - 64 + .6*(y+1136) , display.contentHeight - 64)
			houseImg.alpha = ( 1 - (y+1136)/400 )
			logo.alpha = ( 1 - (y+1136)/140 )
			logo.y = math.max(display.contentHeight - 346 + (y+1136) , display.contentHeight - 346)
		end
		
end


function scene:enterScene( event )
        local group = self.view
		Runtime:addEventListener ( "enterFrame", paralaxEffect )
--		storyboard.removeScene ( "level1" )
--		storyboard.purgeScene ( "level1" )
end

function scene:exitScene( event )
        local group = self.view
		Runtime:removeEventListener( "enterFrame", paralaxEffect )
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








