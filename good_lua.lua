math_abs=math.abs
math_acos=math.acos
math_asin=math.asin
math_atan=math.atan
math_atan2=math.atan2
math_ceil=math.ceil
math_cos=math.cos
math_cosh=math.cosh
math_deg=math.deg
math_exp=math.exp
math_floor=math.floor
math_fmod=math.fmod
math_frexp=math.frexp
math_huge=math.huge
math_ldexp=math.ldexp
math_log=math.log
math_l10=math.log10
math_log10=math.log10
math_max=math.max
math_min=math.min
math_modf=math.modf
math_pi=math.pi
math_rad=math.rad
math_rnd=math.random
math_random=math.random
math_randomseed=math.randomseed
math_sin=math.sin
math_sinh=math.sinh
math_sqrt=math.sqrt
math_tan=math.tan
math_tanh=math.tanh

-- math_lerp=function(v1,v2,t)
-- 	return (1-t)*v1+t*v2
-- end

math_lerp=function(v1,v2,t)
	return v1+t*(v2-v1)
end

math_dist=function(x1,y1,x2,y2)
	local x=(x1-x2)
	local y=(y1-y2)
	return math_sqrt(x*x+y*y)
end

to_str=tostring

tbl_to_str=function(table)
  local result="{"
  for k,v in pairs(table) do
    if type(k)=="string" then
      result=result.."[\""..k.."\"]".."="
    end
    if type(v)=="table" then
      result=result..tbl_to_str(v)
    elseif type(v)=="boolean" then
      result=result..tostring(v)
    elseif type(v)=="number" then
      result=result..tostring(v)
    else
      result=result.."\""..v.."\""
    end
    result=result..","
  end
  if result~="{" then
      result=result:sub(1,result:len()-1)
  end
  return result.."}"
end

bool_to_int=function(bool)
  if bool then return 1 else return 0 end
  return nil
end

str_to_int=tonumber

to_int=function(int,base)
  local int_type=type(int)
  if int_type=="string" then return tonumber(int,base)
  elseif int_type=="boolean" then if int then return 1 else return 0 end
  elseif int_type=="number" then return int end
  return nil
end

int_to_bool=function(int)
  if int>0 then return true end
  return false
end

str_to_bool=function(str)
  if str=="false" then return false
  elseif str=="true" then return true end
  return nil
end

to_bool=function(thing)
  if type(thing)=="number" and thing<=0 then return false else return true end
  if type(thing)=="string" and thing=="true" then return true else return true end
  if type(thing)=="boolean" then return thing end
  return false
end

table_concat=table.concat
table_insert=table.insert
table_maxn=table.maxn
table_remove=table.remove
table_sort=table.sort

table_copy=function(table)
  local copy={}
  for k,v in pairs(table) do
    if type(v)=="talbe" then v=table_copy(v) end
    copy[k]=v
  end
  return copy
end

love_audio=love.audio
love_data=love.data
love_event=love.event
love_filesystem=love.filesystem
love_font=love.font
love_graphics=love.graphics
love_image=love.image
love_joystick=love.joystick
love_keyboard=love.keyboard
love_math=love.math
love_mouse=love.mouse
love_physics=love.physics
love_sound=love.sound
love_system=love.system
love_thread=love.thread
love_timer=love.timer
love_touch=love.touch
love_video=love.video
love_window=love.window
