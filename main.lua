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

local nokia_font=love_graphics.newImageFont("font.png",[[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 $€£¥¤+-*/=%"'#@&_(),.;:?!\|{}<>[]'^~]],0)

local audio_beats={}
for i=1,100 do
  if love_filesystem.getInfo("song_part"..i..".mp3") then
    table_insert(audio_beats,love_audio.newSource("song_part"..i..".mp3","static"))
  else break end
end

-- cool variables

local DEBUG_YOOOOOOOOOOOOOOOOOOOOOOOOOOO=false
local COLOR_BRIGHT={199/255,240/255,216/255,1} -- #c7f0d8
local COLOR_DARK={67/255,82/255,61/255,1} -- #43523d
local COOL_FX=true


local display_functionality_data=love_image.newImageData(screen_width,screen_height)
local display_functionality_imag=love_graphics.newImage(display_functionality_data)

local display_functionality_blend_data=love_image.newImageData(screen_width,screen_height)
display_functionality_blend_data:mapPixel(function(x,y,r,g,b,a) return 0,0,0,0,0,0,0,0 end)
local display_functionality_blend_imag=love_graphics.newImage(display_functionality_blend_data)


local play_sound_paused={}
local play_sound_playing=nil


local music_pattern={
  1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,
  2,0,0,0,3,0,0,0,4,0,0,0,0,0,4,0,
  0,0,4,0,0,0,5,0,5,0,0,0,4,0,0,0,
  
  4,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,
  4,0,6,0,0,0,0,0,0,0,7,0,0,0,0,0,
  8,0,0,0,9,0,0,0,10,0,0,0,10,0,11,0,
  0,0,11,0,0,0,12,0,0,0,12,0,13,0,0,0
}
local music_next_beat_timer=0
local music_current_beat=1
local music_prev_beat=0
local music_bpm=200

-- functions

local play_sound=function(sound,loop)
  if sound==nil then return end
  loop=loop or false
  play_sound_playing=sound
  local paused=love_audio.pause()
  for i,source in ipairs(paused) do
    if source==play_sound_playing then
      play_sound_playing:stop()
      play_sound_playing:play()
    else
      table_insert(play_sound_paused,1,source)
    end
  end
  play_sound_playing:play()
  play_sound_playing:setLooping(loop)
end

local update_sound=function()
  if play_sound_playing==nil then return end
  if not play_sound_playing:isPlaying() and #play_sound_paused>0 then
    play_sound_paused[1]:play()
    table_remove(play_sound_paused,1)
    play_sound_playing=play_sound_paused[1]
  end
end

-- cool :sunglasses:

function LOAD(arg)
  for i,cmd in ipairs(arg) do
    if cmd=="-debug" then DEBUG_YOOOOOOOOOOOOOOOOOOOOOOOOOOO=true end
  end
  love_graphics.setFont(nokia_font)
end

function UPDATE(dt)
  local dt2=dt*60
  
  music_next_beat_timer=music_next_beat_timer+dt2
  
  if music_next_beat_timer>=800/music_bpm then
    music_next_beat_timer=0
    music_prev_beat=music_current_beat
    music_current_beat=math_fmod(music_current_beat,#music_pattern)+1
    play_sound()
  end
  
  if music_prev_beat~=music_current_beat then
    music_prev_beat=music_current_beat
    play_sound(audio_beats[music_pattern[music_current_beat]])
  end
  
  update_sound()
end

function DRAW()
  love_graphics.print(music_prev_beat.." "..music_current_beat.." "..music_pattern[music_current_beat])
  local y=8
  for i,source in ipairs(play_sound_paused) do
    love_graphics.print(to_str(source),-57,y)
    y=y+8
  end
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
      
      if COOL_FX then
        love_graphics.setColor(1,1,1,.5)
        love_graphics.draw(display_functionality_blend_imag)
      end
      
      love_graphics.origin()
      love_graphics.scale(screen_scale,screen_scale)
      love_graphics.setCanvas()
      love_graphics.setColor(1.0,1.0,1.0,1.0)
      love_graphics.clear(0,0,0,1)
      
      if COOL_FX then
        display_functionality_blend_data=display_canvas:newImageData()
        display_functionality_blend_imag:replacePixels(display_functionality_blend_data)
      end
      
      love_graphics.draw(display_canvas,love_graphics.getWidth()/screen_scale/2-screen_width/2,love_graphics.getHeight()/screen_scale/2-screen_height/2)
      -- love_graphics.draw(screen_canvas,love_graphics.getWidth()/screen_scale/2-screen_width/2,love_graphics.getHeight()/screen_scale/2-screen_height/2)
      
      
      love_graphics.pop()
      
      love_graphics.present()
    end
    
    if love.timer then love.timer.sleep(0.001) end
  end
end
