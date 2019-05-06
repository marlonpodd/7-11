-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created by: Marlon
-- Created on: Jan 2018
-- 
-- This file animates a charact using a spritesheet
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

display.setDefault( "background", 100/255, 100/255, 200/255 )

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 10 ) -- ( x, y )
physics.setDrawMode( "hybrid" )

local theGround = display.newImageRect( "./assets/land.png", 600, 100 )
theGround.x = 240
theGround.y = 320
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local jumpButton = display.newImageRect( "./assets/jumpButton.png", 75, 75 )
jumpButton.x = 460
jumpButton.y = 60
jumpButton.id = " jumpButton"

---------------------------------------------------------------
--Knight character
--------------------------------------------------------------- 

local sheetOptionsIdle =
{
    width = 587,
    height = 707,
    numFrames = 10
}
local sheetIdleKnight = graphics.newImageSheet( "./assets/spritesheets/knightIdle.png",  sheetOptionsIdle )

local sheetOptionsWalk =
{
    width = 587,
    height = 707,
    numFrames = 10
}
local sheetWalkingKnight = graphics.newImageSheet( "./assets/spritesheets/knightWalking.png", sheetOptionsWalk )

local sheetOptionsDead =
{
    width = 944,
    height = 751,
    numFrames = 10
}
local sheetDeadKnight = graphics.newImageSheet( "./assets/spritesheets/knightDead.png",  sheetOptionsDead )


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleKnight
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetWalkingKnight
    },
        {
        name = "dead",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetDeadKnight
    }

}

kscrollspeed = 0.75

local knight = display.newSprite( sheetIdleKnight, sequence_data )
knight.x = 120
knight.y = 160
knight.xScale = 140/587
knight.yScale = 200/707
knight.width = 110
knight.height = 180
knight.id = "knight"
physics.addBody( knight, "dynamic", { 
    density = 3.0, 
    friction = 0, 
    bounce = 0 
    } )

knight:play()

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet

----------------------------------------------------------------------
--ninja character
----------------------------------------------------------------------

local sheetOptionsIdle =
{
    width = 232,
    height = 439,
    numFrames = 10
}
local sheetIdleNinja = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyIdle.png",  sheetOptionsIdle )

local sheetOptionsThrow =
{
    width = 377,
    height = 451,
    numFrames = 10
}
local sheetThrowNinja = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyThrow.png", sheetOptionsThrow )


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleNinja
    },
    {
        name = "throw",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetThrowNinja
    }
}

scrollspeed = 1.5

local ninja = display.newSprite( sheetIdleNinja, sequence_data )
ninja.x = 20
ninja.y = 160
ninja.xScale = 120/377
ninja.yScale = 180/451
ninja.width = 100
ninja.height = 180
ninja.id = "ninja"
physics.addBody( ninja, "dynamic", { 
    density = 3.0, 
    friction = 0, 
    bounce = 0 
    } )


ninja:play()

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function swapSheet()
    knight:setSequence( "walk" )
    knight:play()
    print("walk")
end

local function moveKnight( event )
    timer.performWithDelay(1770, function()
        knight.x = knight.x + kscrollspeed
    end
    )
end

local function ninjaswap (event)
    if ( event.phase == "began" ) then
    -- make a bullet appear
        kunai = display.newImageRect( "./assets/Kunai.png", 60, 20 )
        kunai.x = ninja.x
        kunai.y = ninja.y
        physics.addBody( kunai, 'dynamic' )
        -- Make the object a "bullet" type object
        kunai.isBullet = true
        kunai.isFixedRotation = true
        kunai.gravityScale = 0
        kunai.id = "bullet"
        kunai:setLinearVelocity( 500, 0 )

        ninja:setSequence( "throw" )
        ninja:play()
        print("throw")
        
        timer.performWithDelay(800, function()
            ninja:setSequence( "idle" )
            ninja:play()
        end
        )
    end
    
    return true
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
        local whereCollisonOccurredX = obj1.x
        local whereCollisonOccurredY = obj1.y

        if ( ( obj1.id == "knight" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "knight" ) ) then

            kunai:removeSelf()

            knight:setSequence( "dead" )
            knight:play()
            print("dead")

            kscrollspeed = 0

            timer.performWithDelay(780, function()
                knight:pause()
            end
            )
        end
    end
end






jumpButton:addEventListener("touch", ninjaswap )
timer.performWithDelay( 2000, swapSheet )
Runtime:addEventListener("enterFrame", moveKnight )
Runtime:addEventListener( "collision", onCollision )
