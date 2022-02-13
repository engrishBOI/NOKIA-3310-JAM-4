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
local cool_snake=love_graphics.newImage("snake.png")
local cool_note=love_graphics.newImage("note.png")

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


local cool_snake_direction=1
local cool_snake_longness=3  
local cool_snake_highest_longness=3  
local cool_snake_x=2
local cool_snake_y=0
local cool_snake_type=1
local cool_snake_layout={
  "0000T1","0100B1"
  -- "0202H0","0402B0","0602C0","0802T0",
  -- "0203H1","0403B1","0603C1","0803T1",
  -- "0204H2","0404B2","0604C2","0804T2",
  -- "0205H3","0405B3","0605C3","0805T3"
}
local cool_snake_parts={
  {
    H=love_graphics.newQuad(0,0,6,6,cool_snake),
    B=love_graphics.newQuad(6,0,6,6,cool_snake),
    C=love_graphics.newQuad(12,0,6,6,cool_snake),
    K=love_graphics.newQuad(18,0,6,6,cool_snake),
    T=love_graphics.newQuad(24,0,6,6,cool_snake)
  },
  {
    H=love_graphics.newQuad(0,6,6,6,cool_snake),
    B=love_graphics.newQuad(6,6,6,6,cool_snake),
    C=love_graphics.newQuad(12,6,6,6,cool_snake),
    K=love_graphics.newQuad(18,6,6,6,cool_snake),
    T=love_graphics.newQuad(24,6,6,6,cool_snake)
  },
  {
    H=love_graphics.newQuad(0,12,6,6,cool_snake),
    B=love_graphics.newQuad(6,12,6,6,cool_snake),
    C=love_graphics.newQuad(12,12,6,6,cool_snake),
    K=love_graphics.newQuad(18,12,6,6,cool_snake),
    T=love_graphics.newQuad(24,12,6,6,cool_snake)
  }
}
local cool_snake_move={
  1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,
  1,0,1,0,1,0,1,0,0,0,1,0,1,0,0,0,
  1,0,1,0,1,0,1,0,1,0,0,0,0,0,1,0,
  0,0,1,0,0,0,1,0,1,0,0,0,1,0,0,0,
  
  1,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,
  1,0,1,0,1,0,1,0,0,0,1,0,1,0,0,0,
  1,0,1,0,1,0,1,0,1,0,0,0,1,0,1,0,
  0,0,1,0,0,0,1,0,0,0,1,0,1,0,0,0
}

local cool_note_x=math_random(1,12)
local cool_note_y=math_random(1,6)
local cool_note_frame=1
local cool_note_frames={
  love_graphics.newQuad(0,0,6,6,cool_note),
  love_graphics.newQuad(6,0,6,6,cool_note)
}

local display_functionality_data=love_image.newImageData(screen_width,screen_height)
local display_functionality_imag=love_graphics.newImage(display_functionality_data)

local display_functionality_blend_data=love_image.newImageData(screen_width,screen_height)
display_functionality_blend_data:mapPixel(function(x,y,r,g,b,a) return 0,0,0,0,0,0,0,0 end)
local display_functionality_blend_imag=love_graphics.newImage(display_functionality_blend_data)


local play_sound_paused={}
local play_sound_playing=nil


local music_pattern={
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, -- 001 002 003 004   005 006 007 008   009 010 011 012   013 014 015 016
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, -- 017 018 019 020   021 022 023 024   025 026 027 028   029 030 031 032
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, -- 033 034 035 036   037 038 039 040   041 042 043 044   045 046 047 048
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, -- 049 050 051 052   053 054 055 056   057 058 059 060   061 062 063 064
  
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, -- 065 066 067 068   069 070 071 072   073 074 075 076   077 078 079 080
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, -- 081 082 083 084   085 086 087 088   089 090 091 092   093 094 095 096
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, -- 097 098 099 100   101 102 103 104   105 106 107 108   109 110 111 112
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  -- 113 114 115 116   117 118 119 120   121 122 123 124   125 126 127 128
  
  -- 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  -- 1,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,
  -- 2,0,0,0,3,0,0,0,4,0,0,0,0,0,4,0,
  -- 0,0,4,0,0,0,5,0,5,0,0,0,4,0,0,0,
  
  -- 4,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,
  -- 4,0,6,0,0,0,0,0,0,0,7,0,0,0,0,0,  
  -- 8,0,0,0,9,0,0,0,10,0,0,0,10,0,11,0,
  -- 0,0,11,0,0,0,12,0,0,0,12,0,13,0,0,0
}
local music_pattern_add={
  -- "00101;06504",
  -- "06706;03302",
  -- "03703;04104",
  -- "04704;09708",
  -- "10109;10510",
  -- "10910;11111",
  -- "01701;02702",
  -- "08104;08306",
  -- "09107:11511",
  -- "11912;12312;12513"
  
  -- "11111",
  -- "11511",
  -- "06104",
  -- "12513",
  -- "09708",
  -- "08104",
  -- "10109",
  -- "12312",
  -- "03703",
  -- "05705",
  -- "00101",
  -- "06706",
  -- "05505",
  -- "05104",
  -- "04104",
  -- "04704",
  -- "09107",
  -- "10510",
  -- "02702",
  -- "01701",
  -- "08306",
  -- "06504",
  -- "03302",
  -- "11912",
  -- "10910",
  
  "10910", -- 20
  "11912", -- 23
  "11111", -- 21
  "11511", -- 22
  "09107", -- 16
  "10510", -- 19
  "12312", -- 24
  "06104", -- 11
  "04104", -- 06
  "05505", -- 09
  "10109", -- 18
  "12513", -- 25
  "02702", -- 03
  "05104", -- 08
  "01701", -- 02
  "08104", -- 14
  "06504", -- 12
  "08306", -- 15
  "09708", -- 17
  "04704", -- 07
  "06706", -- 13
  "05705", -- 10
  "03703", -- 05
  "00101", -- 01
  "03302"  -- 04
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


local cool_snake_draw_bit=function(snake_bit)
  local draw_x=tonumber(string_sub(snake_bit,1,2))*6+3
  local draw_y=tonumber(string_sub(snake_bit,3,4))*6+3
  local draw_dir=math_rad(tonumber(string_sub(snake_bit,6,6))*90)
  local draw_spr=string_sub(snake_bit,5,5)
  -- print(draw_x,draw_y,draw_dir,draw_spr)
  
  love_graphics.draw(cool_snake,cool_snake_parts[cool_snake_type][draw_spr],draw_x,draw_y,draw_dir,1,1,3,3)
end

local music_pattern_add_function=function(add_thing)
  for str in string.gmatch(add_thing..";","(.-);") do
    local id=tonumber(string_sub(str,1,3))
    local num=tonumber(string_sub(str,4,5))
    music_pattern[id]=num
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
  
  if love_keyboard.isDown("up") and tonumber(string_sub(cool_snake_layout[1],6,6))~=2 then cool_snake_direction=0 end
  if love_keyboard.isDown("right") and tonumber(string_sub(cool_snake_layout[1],6,6))~=3 then cool_snake_direction=1 end
  if love_keyboard.isDown("down") and tonumber(string_sub(cool_snake_layout[1],6,6))~=0 then cool_snake_direction=2 end
  if love_keyboard.isDown("left") and tonumber(string_sub(cool_snake_layout[1],6,6))~=1 then cool_snake_direction=3 end
  
  if music_prev_beat~=music_current_beat then
    music_prev_beat=music_current_beat
    play_sound(audio_beats[music_pattern[music_current_beat]])
    
    if math_fmod(music_current_beat,8)==0 then cool_note_frame=math_fmod(cool_note_frame,2)+1 end
    
    if cool_snake_move[music_current_beat]==1 then
      
      if cool_snake_direction==0 then
        cool_snake_y=cool_snake_y-1
      elseif cool_snake_direction==1 then
        cool_snake_x=cool_snake_x+1
      elseif cool_snake_direction==2 then
        cool_snake_y=cool_snake_y+1
      else
        cool_snake_x=cool_snake_x-1
      end
      if cool_snake_x>13 then cool_snake_x=0 end
      if cool_snake_y>7 then cool_snake_y=0 end
      if cool_snake_x<0 then cool_snake_x=13 end
      if cool_snake_y<0 then cool_snake_y=7 end
      
      if cool_snake_direction==1 and string_sub(cool_snake_layout[1],6,6)=="0" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."C0" goto skip_this_little_part end
      if cool_snake_direction==2 and string_sub(cool_snake_layout[1],6,6)=="1" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."C1" goto skip_this_little_part end
      if cool_snake_direction==3 and string_sub(cool_snake_layout[1],6,6)=="2" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."C2" goto skip_this_little_part end
      if cool_snake_direction==0 and string_sub(cool_snake_layout[1],6,6)=="3" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."C3" goto skip_this_little_part end
    
      if cool_snake_direction==3 and string_sub(cool_snake_layout[1],6,6)=="0" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."K0" goto skip_this_little_part end
      if cool_snake_direction==0 and string_sub(cool_snake_layout[1],6,6)=="1" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."K1" goto skip_this_little_part end
      if cool_snake_direction==1 and string_sub(cool_snake_layout[1],6,6)=="2" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."K2" goto skip_this_little_part end
      if cool_snake_direction==2 and string_sub(cool_snake_layout[1],6,6)=="3" then cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."K3" goto skip_this_little_part end
      cool_snake_layout[1]=string_sub(cool_snake_layout[1],1,4).."B"..string_sub(cool_snake_layout[1],6,6)
      ::skip_this_little_part::
      
      cool_snake_layout[#cool_snake_layout]=string_sub(cool_snake_layout[#cool_snake_layout],1,4).."T"..string_sub(cool_snake_layout[#cool_snake_layout-1],6,6)
      table_insert(cool_snake_layout,1,int_to_str(cool_snake_x,2)..int_to_str(cool_snake_y,2).."H"..cool_snake_direction)
      
      for i,body in ipairs(cool_snake_layout) do
        local fuck_x=tonumber(string_sub(body,1,2))
        local fuck_y=tonumber(string_sub(body,3,4))
        local sonohead=string_sub(body,5,5)
        
        if cool_snake_x==fuck_x and cool_snake_y==fuck_y and sonohead~="H" then
          if cool_snake_longness>cool_snake_highest_longness then cool_snake_highest_longness=cool_snake_longness end
          cool_snake_longness=3
          music_pattern_add={"10910","11912","11111","11511","09107","10510","12312","06104","04104","05505","10109","12513","02702","05104","01701","08104","06504","08306","09708","04704","06706","05705","03703","00101","03302"}
          music_pattern={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        end
      end
      
      if cool_snake_x==cool_note_x and cool_snake_y==cool_note_y then
        cool_snake_longness=cool_snake_longness+1
        cool_note_x=math_random(1,12)
        cool_note_y=math_random(1,6)
        local reandoum=math_random(1,#music_pattern_add)
        if music_pattern_add[reandoum] then
          music_pattern_add_function(music_pattern_add[reandoum])
          table_remove(music_pattern_add,reandoum)
          
        end
      end
    end
    if #cool_snake_layout>cool_snake_longness then
      table_remove(cool_snake_layout,#cool_snake_layout)
      cool_snake_layout[#cool_snake_layout]=string_sub(cool_snake_layout[#cool_snake_layout],1,4).."T"..string_sub(cool_snake_layout[#cool_snake_layout-1],6,6)
    end
  end
  
  update_sound()
end

function DRAW()
  love_graphics.draw(cool_note,cool_note_frames[cool_note_frame],cool_note_x*6,cool_note_y*6)
  
  for i,bit in ipairs(cool_snake_layout) do
    cool_snake_draw_bit(bit)
  end
  
  love_graphics.print(cool_snake_longness-3)
  if cool_snake_highest_longness-3>0 then love_graphics.print("HI "..cool_snake_highest_longness-3,0,8) end
  
  if not DEBUG_YOOOOOOOOOOOOOOOOOOOOOOOOOOO then return end
  
  love_graphics.print(music_prev_beat.." "..music_current_beat.." "..cool_snake_move[music_current_beat])
  -- love_graphics.print(music_prev_beat.." "..music_current_beat.." "..music_pattern[music_current_beat])
  
  local y=8
  for i,source in ipairs(play_sound_paused) do
    love_graphics.print(to_str(source),-57,y)
    y=y+8
  end
end

function love.keypressed(key)
  if key=="1" then cool_snake_type=1 end
  if key=="2" then cool_snake_type=2 end
  if key=="3" then cool_snake_type=3 end
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
