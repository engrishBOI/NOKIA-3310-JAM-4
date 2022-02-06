require"good_lua"
math_randomseed(os.date("%H")+os.date("%M")*os.date("%S"))
love_graphics.setDefaultFilter("nearest","nearest",0)

local screen_x=0
local screen_y=0
local screen_scale=1
local screen_canvas=love_graphics.newCanvas(84,48)
local screen_width=screen_canvas:getWidth()
local screen_height=screen_canvas:getHeight()
local display_canvas=love_graphics.newCanvas(screen_width,screen_height)

-- load stuff in ty :]

local testpng=love_graphics.newImage("test.png")

-- cool variables

local DEBUG_YOOOOOOOOOOOOOOOOOOOOOOOOOOO=false
local COLOR_BRIGHT={199/255,240/255,216/255,1} -- #c7f0d8
local COLOR_DARK={67/255,82/255,61/255,1} -- #43523d
local COLOR_DARK_HALF={67/255,82/255,61/255,1} -- #43523d

local display_functionality_data=love_image.newImageData(screen_width,screen_height)
local display_functionality_imag=love_graphics.newImage(display_functionality_data)

local display_functionality_blend_data=love_image.newImageData(screen_width,screen_height)
display_functionality_blend_data:mapPixel(function(x,y,r,g,b,a) return 0,0,0,0,0,0,0,0 end)
local display_functionality_blend_imag=love_graphics.newImage(display_functionality_blend_data)

local testpngx=0
local testpngy=0

-- functions

local coolify=function(x,y,r,g,b,a)
end

-- cool :sunglasses:

function LOAD(arg)
  for i,cmd in ipairs(arg) do
    if cmd=="-debug" then DEBUG_YOOOOOOOOOOOOOOOOOOOOOOOOOOO=true end
  end
end

function UPDATE(dt)
  local dt2=dt*60
  
  if love_keyboard.isDown("w") then testpngy=testpngy-1 end
  if love_keyboard.isDown("a") then testpngx=testpngx-1 end
  if love_keyboard.isDown("s") then testpngy=testpngy+1 end
  if love_keyboard.isDown("d") then testpngx=testpngx+1 end
end

function DRAW()
  love_graphics.draw(testpng,testpngx,testpngy)
end

function love.keypressed(key)
end

-- dont care l+ratio

function love.resize(w,h)
  if love_graphics.getWidth()/(screen_width*screen_scale)<love_graphics.getHeight()/(screen_height*screen_scale) then
    screen_scale=love_graphics.getWidth()/(screen_width)
  else
    screen_scale=love_graphics.getHeight()/(screen_height)
  end
end

function love.run()
  LOAD(love.arg.parseGameArguments(arg),arg)
  
  -- We don't want the first frame's dt to include time taken by LOAD.
  if love.timer then love.timer.step() end
  
  local dt=0
  
  -- Main loop time.
  return function()
    -- Process events.
    if love.event then
      love.event.pump()
      for name,a,b,c,d,e,f in love.event.poll() do
        if name=="quit" then
          if not love.quit or not love.quit() then
            return a or 0
          end
        end
        love.handlers[name](a,b,c,d,e,f)
      end
    end
    
    -- Update dt, as we'll be passing it to update
    if love.timer then dt=love.timer.step() end
    
    -- Call update and draw
    UPDATE(dt) -- will pass 0 if love.timer is disabled
    
    if love_graphics and love_graphics.isActive() then
      love_graphics.setCanvas(screen_canvas)
      love_graphics.clear(1,1,1,1)
      
      
      love_graphics.push()
      love_graphics.origin()
      love_graphics.translate(-screen_x,-screen_y)
      
      DRAW()
      
      love_graphics.setCanvas(display_canvas)
      love_graphics.clear(COLOR_BRIGHT)
      
      -- love_graphics.setColor(COLOR_DARK_HALF)
      -- love_graphics.draw(display_functionality_blend_imag)
      
      display_functionality_data=screen_canvas:newImageData()
      local r,g,b,a,avg
      for y=0,display_functionality_data:getHeight()-1 do
        for x=0,display_functionality_data:getWidth()-1 do
          r,g,b,a=display_functionality_data:getPixel(x,y)
          avg=r+g+b/3
          if avg<=.5 then
            display_functionality_data:setPixel(x,y,1,1,1,1)
          else
            display_functionality_data:setPixel(x,y,1,1,1,0)
          end
        end
      end
      display_functionality_imag:replacePixels(display_functionality_data)
      love_graphics.setColor(COLOR_DARK)
      love_graphics.draw(display_functionality_imag)
      
      love_graphics.origin()
      love_graphics.scale(screen_scale,screen_scale)
      love_graphics.setCanvas()
      love_graphics.setColor(1.0,1.0,1.0,1.0)
      love_graphics.clear(0,0,0,1)
      
      display_functionality_blend_data=display_canvas:newImageData()
      display_functionality_blend_imag:replacePixels(display_functionality_blend_data)
      
      love_graphics.draw(display_canvas,love_graphics.getWidth()/screen_scale/2-screen_width/2,love_graphics.getHeight()/screen_scale/2-screen_height/2)
      -- love_graphics.draw(screen_canvas,love_graphics.getWidth()/screen_scale/2-screen_width/2,love_graphics.getHeight()/screen_scale/2-screen_height/2)
      
      
      love_graphics.pop()
      
      love_graphics.present()
    end
    
    if love.timer then love.timer.sleep(0.001) end
  end
end
