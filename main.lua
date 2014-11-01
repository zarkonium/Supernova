local myApp = require("myApp")
local physics = require("physics")

physics.start()
physics.setGravity( 0, 0 )

display.setStatusBar ( display.HiddenStatusBar )

local radius = 6
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local topEdge = display.newRect( centerX, 10, display.contentWidth - 26, 6 )
physics.addBody ( topEdge, "static",{friction = 0})
local bottomEdge = display.newRect( centerX, display.contentHeight - 10, display.contentWidth - 26, 6 )
physics.addBody ( bottomEdge, "static",{friction = 0})
local leftEdge = display.newRect( 10, centerY, 6, display.contentHeight - 14 )
physics.addBody ( leftEdge, "static",{friction = 0})
local rightEdge = display.newRect( display.contentWidth - 10, centerY, 6, display.contentHeight - 14 )
physics.addBody ( rightEdge, "static",{friction = 0})

local speed = 100
for i =1,5 do
	local direction= 90*math.random(0,3) + math.random(200,700)/10
	local circ = display.newCircle( 30 + (display.contentWidth - 60)*math.random(), 30 + (display.contentHeight - 60)*math.random(), radius )
	circ.x = 30 + (display.contentWidth - 60)*math.random()
	circ.y = 30 + (display.contentHeight - 60)*math.random()
	physics.addBody( circ, "dynamic", { density=1.0, bounce=1, friction=0, radius=radius} )
	circ:setLinearVelocity (speed * math.cos(direction * math.pi / 180), speed * math.sin(direction * math.pi / 180))
end
