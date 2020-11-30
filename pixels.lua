-- PIXELS a generative 
--           visual 
--            sequencer 
--             instrument
--
-- six travelers inching over 
-- luminous terrain
-- worlds to be explored in time
-- each step, a new chance 
-- to emanate tones
--
-- HOLD K1 to alternate between
-- the menu pages and the map.
-- 
-- TURN encoder 1 while in 
-- a menu to change pages.
-- 
-- map screen
--
-- this is where the action is. 
-- adjust the position, direction 
-- and rate of each pixel.
-- press play and have fun!
--
-- encoder 1 = tempo 
--  ALT (pixel travel rate)
-- encoder 2 = pixel x position 
--  ALT (pixel direction)
-- encoder 3 = pixel y position 
--  ALT (pixel selection)
--
-- key 1 = HOLD : enter menu
-- key 2 = HOLD : ALT
-- key 3 = play/stop
--
-- 
-- landscape screen
--
-- this is where you change the 
-- world your pixels inhabit. 
-- Select the style, scale,
-- starting note and number of 
-- octaves. the 16 levels of 
-- brightness displayed on 
-- the norns screen represent 
-- the notes of the selected 
-- scale (albeit highly 
-- compressed) from low (dark) 
-- to high (light).
--
-- encoder 1 = select option
-- encoder 2 = adjust option
-- key 1 = HOLD : exit menu 
-- key 3 = confirm selection
--
-- HINT!
-- going below C0 on the root
--setting will allow you to 
-- manually control the root
-- note with an external MIDI
-- keyboard.
--
-- pixels screen
--
-- take control of your 
-- travelers! Set their initial 
-- state, trigger probability, 
-- midi velocity and midi channel.
-- only need one pixel? ok ... 
-- fine, but it could be lonely 
-- out there
--
-- encoder 1 = select option
-- encoder 2 = adjust option
-- key 1 = HOLD : exit menu 
-- key 3 = confirm selection
--
-- HINT! 
-- going below 0 on midi velocity
-- will get you random numbers!
--
-- synth screen
--
-- make music without a 
-- midi instrument? ok. 
-- here are the settings for the 
-- built-in synth engine. 
-- release, pulse width,
-- amp, and pan. values
-- below 0 on rel, pw & amp
-- will generate random 
-- numbers. values of pan 
-- below -50 and above 50
-- will generate random numbers.
--
-- encoder 1 = select option
-- encoder 2 = adjust option
-- key 1 = HOLD : exit menu 
--
--
-- S E C R E T M O D E?
--
-- ?

--local start = 0

-- Please forgive me my coding sins. I know not what I do ...

local music = require 'musicutil'

--engine
engine.name = 'Thebangs'
local temprel = 20
local temppw = 50
local tempamp = 50
local temppan = 50
local pan = {50,50,50,50,50,50}
local release = {20,20,20,20,20,20}
local pw = {50,50,50,50,50,50}
local amp = {50,50,50,50,50,50}


--Logic
local drawing = 0
local k2 = 0
local k3 = 0
local page = 1
local lastpage = 2
local menumode = 0
local menupos = 1
local lastmenupos = 1
local loading = {"a","b","c"}
local loadtext = 1
local saving = {"a","b","c"}
local savetext = 1

--MIDI
local mute = false
local midi_signal_in
local midi_signal_out
local midiCH = {1,1,1,1,1,1}
local midiCHmain = 1
local midiVEL = {64,64,64,64,64,64}
local midiVELmain = 1
local notes1 = {}
local notes2 = {}
local notes3 = {}
local notes4 = {}
local notes5 = {}
local notes6 = {}
local key1 = 0
local key2 = 0
local key3 = 0
local key4 = 0
local key5 = 0
local key6 = 0

--Params
savea = paramset.new()
savea:add_number("pixX1")
savea:add_number("pixX2")
savea:add_number("pixX3")
savea:add_number("pixX4")
savea:add_number("pixX5")
savea:add_number("pixX6")
savea:add_number("pixY1")
savea:add_number("pixY2")
savea:add_number("pixY3")
savea:add_number("pixY4")
savea:add_number("pixY5")
savea:add_number("pixY6")
savea:add_number("pixDX1")
savea:add_number("pixDX2")
savea:add_number("pixDX3")
savea:add_number("pixDX4")
savea:add_number("pixDX5")
savea:add_number("pixDX6")
savea:add_number("pixDY1")
savea:add_number("pixDY2")
savea:add_number("pixDY3")
savea:add_number("pixDY4")
savea:add_number("pixDY5")
savea:add_number("pixDY6")
savea:add_number("stepdiv2")
savea:add_number("stepdiv3")
savea:add_number("stepdiv4")
savea:add_number("stepdiv5")
savea:add_number("stepdiv6")
savea:add_number("stepdiv1")
savea:add_number("numpix")
savea:add_number("trigprob1")
savea:add_number("trigprob2")
savea:add_number("trigprob3")
savea:add_number("trigprob4")
savea:add_number("trigprob5")
savea:add_number("trigprob6")
savea:add_number("styleselect")
savea:add_number("tempo")
savea:add_number("low1")
savea:add_number("low2")
savea:add_number("low3")
savea:add_number("low4")
savea:add_number("low5")
savea:add_number("low6")
savea:add_number("octaves1")
savea:add_number("octaves2")
savea:add_number("octaves3")
savea:add_number("octaves4")
savea:add_number("octaves5")
savea:add_number("octaves6")
savea:add_number("mscale")
savea:add_number("midiVEL1")
savea:add_number("midiVEL2")
savea:add_number("midiVEL3")
savea:add_number("midiVEL4")
savea:add_number("midiVEL5")
savea:add_number("midiVEL6")
savea:add_number("midiCH1")
savea:add_number("midiCH2")
savea:add_number("midiCH3")
savea:add_number("midiCH4")
savea:add_number("midiCH5")
savea:add_number("midiCH6")
savea:add_number("release1")
savea:add_number("release2")
savea:add_number("release3")
savea:add_number("release4")
savea:add_number("release5")
savea:add_number("release6")
savea:add_number("pw1")
savea:add_number("pw2")
savea:add_number("pw3")
savea:add_number("pw4")
savea:add_number("pw5")
savea:add_number("pw6")
savea:add_number("amp1")
savea:add_number("amp2")
savea:add_number("amp3")
savea:add_number("amp4")
savea:add_number("amp5")
savea:add_number("amp6")
savea:add_number("pan1")
savea:add_number("pan2")
savea:add_number("pan3")
savea:add_number("pan4")
savea:add_number("pan5")
savea:add_number("pan6")
saveb = paramset.new()
saveb:add_number("pixX1")
saveb:add_number("pixX2")
saveb:add_number("pixX3")
saveb:add_number("pixX4")
saveb:add_number("pixX5")
saveb:add_number("pixX6")
saveb:add_number("pixY1")
saveb:add_number("pixY2")
saveb:add_number("pixY3")
saveb:add_number("pixY4")
saveb:add_number("pixY5")
saveb:add_number("pixY6")
saveb:add_number("pixDX1")
saveb:add_number("pixDX2")
saveb:add_number("pixDX3")
saveb:add_number("pixDX4")
saveb:add_number("pixDX5")
saveb:add_number("pixDX6")
saveb:add_number("pixDY1")
saveb:add_number("pixDY2")
saveb:add_number("pixDY3")
saveb:add_number("pixDY4")
saveb:add_number("pixDY5")
saveb:add_number("pixDY6")
saveb:add_number("stepdiv2")
saveb:add_number("stepdiv3")
saveb:add_number("stepdiv4")
saveb:add_number("stepdiv5")
saveb:add_number("stepdiv6")
saveb:add_number("stepdiv1")
saveb:add_number("numpix")
saveb:add_number("trigprob1")
saveb:add_number("trigprob2")
saveb:add_number("trigprob3")
saveb:add_number("trigprob4")
saveb:add_number("trigprob5")
saveb:add_number("trigprob6")
saveb:add_number("styleselect")
saveb:add_number("tempo")
saveb:add_number("low1")
saveb:add_number("low2")
saveb:add_number("low3")
saveb:add_number("low4")
saveb:add_number("low5")
saveb:add_number("low6")
saveb:add_number("octaves1")
saveb:add_number("octaves2")
saveb:add_number("octaves3")
saveb:add_number("octaves4")
saveb:add_number("octaves5")
saveb:add_number("octaves6")
saveb:add_number("mscale")
saveb:add_number("midiVEL1")
saveb:add_number("midiVEL2")
saveb:add_number("midiVEL3")
saveb:add_number("midiVEL4")
saveb:add_number("midiVEL5")
saveb:add_number("midiVEL6")
saveb:add_number("midiCH1")
saveb:add_number("midiCH2")
saveb:add_number("midiCH3")
saveb:add_number("midiCH4")
saveb:add_number("midiCH5")
saveb:add_number("midiCH6")
saveb:add_number("release1")
saveb:add_number("release2")
saveb:add_number("release3")
saveb:add_number("release4")
saveb:add_number("release5")
saveb:add_number("release6")
saveb:add_number("pw1")
saveb:add_number("pw2")
saveb:add_number("pw3")
saveb:add_number("pw4")
saveb:add_number("pw5")
saveb:add_number("pw6")
saveb:add_number("amp1")
saveb:add_number("amp2")
saveb:add_number("amp3")
saveb:add_number("amp4")
saveb:add_number("amp5")
saveb:add_number("amp6")
saveb:add_number("pan1")
saveb:add_number("pan2")
saveb:add_number("pan3")
saveb:add_number("pan4")
saveb:add_number("pan5")
saveb:add_number("pan6")
savec = paramset.new()
savec:add_number("pixX1")
savec:add_number("pixX2")
savec:add_number("pixX3")
savec:add_number("pixX4")
savec:add_number("pixX5")
savec:add_number("pixX6")
savec:add_number("pixY1")
savec:add_number("pixY2")
savec:add_number("pixY3")
savec:add_number("pixY4")
savec:add_number("pixY5")
savec:add_number("pixY6")
savec:add_number("pixDX1")
savec:add_number("pixDX2")
savec:add_number("pixDX3")
savec:add_number("pixDX4")
savec:add_number("pixDX5")
savec:add_number("pixDX6")
savec:add_number("pixDY1")
savec:add_number("pixDY2")
savec:add_number("pixDY3")
savec:add_number("pixDY4")
savec:add_number("pixDY5")
savec:add_number("pixDY6")
savec:add_number("stepdiv2")
savec:add_number("stepdiv3")
savec:add_number("stepdiv4")
savec:add_number("stepdiv5")
savec:add_number("stepdiv6")
savec:add_number("stepdiv1")
savec:add_number("numpix")
savec:add_number("trigprob1")
savec:add_number("trigprob2")
savec:add_number("trigprob3")
savec:add_number("trigprob4")
savec:add_number("trigprob5")
savec:add_number("trigprob6")
savec:add_number("styleselect")
savec:add_number("tempo")
savec:add_number("low1")
savec:add_number("low2")
savec:add_number("low3")
savec:add_number("low4")
savec:add_number("low5")
savec:add_number("low6")
savec:add_number("octaves1")
savec:add_number("octaves2")
savec:add_number("octaves3")
savec:add_number("octaves4")
savec:add_number("octaves5")
savec:add_number("octaves6")
savec:add_number("mscale")
savec:add_number("midiVEL1")
savec:add_number("midiVEL2")
savec:add_number("midiVEL3")
savec:add_number("midiVEL4")
savec:add_number("midiVEL5")
savec:add_number("midiVEL6")
savec:add_number("midiCH1")
savec:add_number("midiCH2")
savec:add_number("midiCH3")
savec:add_number("midiCH4")
savec:add_number("midiCH5")
savec:add_number("midiCH6")
savec:add_number("release1")
savec:add_number("release2")
savec:add_number("release3")
savec:add_number("release4")
savec:add_number("release5")
savec:add_number("release6")
savec:add_number("pw1")
savec:add_number("pw2")
savec:add_number("pw3")
savec:add_number("pw4")
savec:add_number("pw5")
savec:add_number("pw6")
savec:add_number("amp1")
savec:add_number("amp2")
savec:add_number("amp3")
savec:add_number("amp4")
savec:add_number("amp5")
savec:add_number("amp6")
savec:add_number("pan1")
savec:add_number("pan2")
savec:add_number("pan3")
savec:add_number("pan4")
savec:add_number("pan5")
savec:add_number("pan6")

--Display
local wordblast = 0
local word = "nothing"
local wordcol1 = 0
local wordcol2 = 2
local wordcol3 = 15
local piccount = 0
local colora = 0


--Notes
local high = 128
local low = {48,48,48,48,48,48}
local lowmain = 48
local octaves = {3,3,3,3,3,3}
local octavesmain = 3
local mscale = 1
local mscaletemp = 1
local drawcolor = {0,0,0,0,0,0}
local scale1 = {}
local scale2 = {}
local scale3 = {}
local scale4 = {}
local scale5 = {}
local scale5 = {}

--Pixels
local ipixX =  {0,0,0,0,0,0,  63,64,65,63,64,65,  64,48,80,63,65,64,  10,10,10,118,118,118,  0,127,0 ,127, 0,127,   2, 25,50,75,100,125,  63,63,63,63,63,63,  11, 32 , 53, 74, 95, 116,  15, 29, 56, 70, 97, 115}
local ipixY =  {0,0,0,0,0,0,  31,31,31,32,32,32,  16,32,32,32,32,48,  10,30,50,14 , 34,54 ,  0,0  ,63, 63,32,32 ,   2, 12,24,36,48 , 60,   9,18,27,36,45,54,  32, 32 , 32, 32, 32, 32,   0 ,  0,  0,  0,  0,   0}
local ipixDX = {0,0,0,0,0,0,  -1, 0, 1,-1, 0, 1,  0 ,-1, 1,0 ,0 ,0 ,   1, 1, 1,-1 ,-1 ,-1 ,  1,-1 ,1 , -1, 1,-1 ,   1, 1 , 1, 1, 1 ,  1,   0, 0, 0, 0, 0, 0,   0,  0,   0,  0,  0,  0,   0 ,  0,  0,  0,  0,   0}
local ipixDY = {0,0,0,0,0,0,  -1,-1,-1, 1, 1, 1,  -1, 0, 0,0 ,0, 1 ,  0, 0, 0, 0 , 0 , 0,    1,  1,-1, -1, 0, 0 ,   0, 0 , 0, 0, 0 ,  0,   0, 0, 0, 0, 0, 0,   0,  0,   0,  0,  0,  0,   1 ,  1,  1,  1,  1,   1}
local istepdiv={1,1,1,1,1,1,   8, 9, 10,10,9, 8,  8 ,10,11, 6,10, 9,  12, 7,10, 12,  7,10,   9, 9 ,11, 11,10, 7 ,   11,11,11,12,12 , 10,   7, 8, 9,10,11,12,   9,  9,   9,  9,  9,  9,   13, 11, 12, 8 , 12,  14}
local numpix = 6
local numpixsel = 6
local thispix = 1
local trigprob = {100,100,100,100,100,100}
local trigprobmain = 100
local pixX = {0,10,20,30,40,50}
local pixY = {0,10,20,30,40,50}
local direction = {0,0,0,0,0,0}
local directionname = {"N","NE","E","SE","S","SW","W","NW","0"}
local pixDX = {0,0,0,0,0,0}
local pixDY = {0,0,0,0,0,0}
local stepdiv = {0,0,0,0,0,0}
local stepdivamount = {64   ,32  ,16 , 12, 8 , 6   ,4  ,  3    ,2    ,.6666    ,1    ,1.5      ,.3333    ,.5    ,.75      ,.1666     ,.250  ,.375      ,.125}
local lengthname =    {"16" ,"8" ,"4","3","2","1.5","1","3/4"  ,"1/2","1/4 trp","1/4","dot 1/4","1/8 trp","1/8" ,"dot 1/8","1/16 trp","1/16","dot 1/16","1/32"}
local x = 0
local y = 0
local pixCol = {}
local size = {1,1,1,1,1,1}
local pulse = {15,15,15,15,15,15}
local pulseinc = {0,0,0,0,0,0}
local styles = {"columns", "t.v.", "stripes", "sinefeild", "strands","air duct","flannel","hubba","weave","grass","unknown","interlaced","sliced","orb","shore","afterimage","stargazing","eye","dark","gray","light"}
local styleselect = 1
local styleselecttemp = 1
local initial = 1
local initialtemp = 1
local initialword = {"random","box","diamond","vs","corners","diag","pulse", "in-sync", "rain"}

--metro
tempo = clock.get_tempo()
re = metro.init()
re.time = 1 / 12
re.event = function()
  redraw()
end
re:start()


beat1 = metro.init()
beat1.time = (60/tempo)
beat1.event = function()
  move(1)
end

beat2 = metro.init()
beat2.time = (60/tempo)
beat2.event = function()
  move(2)
end

beat3 = metro.init()
beat3.time = (60/tempo)
beat3.event = function()
  move(3)
end

beat4 = metro.init()
beat4.time = (60/tempo)
beat4.event = function()
  move(4)
end

beat5 = metro.init()
beat5.time = (60/tempo)
beat5.event = function()
  move(5)
end

beat6 = metro.init()
beat6.time = (60/tempo)
beat6.event = function()
  move(6)
end

--transport
local state = 0

--let's connect MIDI!
function connect()
  midi_signal_in = midi.connect(1)
  midi_signal_out = midi.connect(1)
  midi_signal_in.event = miditrans
end

--let's start a function that look at incoming MIDI transport msgs
function miditrans(data)
    local d = midi.to_msg(data)
    if(d.type == "note_off") then
      mute = true
      print(d.note)
    end
    if(d.type == "note_on") then
      mute = false
      if(key1 > 0) then
        low[1] = d.note
        scale1 = music.generate_scale(low[1],mscale,octaves[1])
      end
      if(key2 > 0) then
        low[2] = d.note
        scale2 = music.generate_scale(low[2],mscale,octaves[2])
      end
      if(key3 > 0) then
        low[3] = d.note
        scale3 = music.generate_scale(low[3],mscale,octaves[3])
      end
      if(key4 > 0) then
        low[4] = d.note
        scale4 = music.generate_scale(low[4],mscale,octaves[4])
      end
      if(key5 > 0) then
        low[5] = d.note
        scale5 = music.generate_scale(low[5],mscale,octaves[5])
      end
      if(key6 > 0) then
        low[6] = d.note
        scale6 = music.generate_scale(low[6],mscale,octaves[6])
      end
    end
    if (d.type == "start" or d.type == "continue") then
      state = 1 
      transport(1)
    end
    if (d.type == "stop")then
      state = 0
      transport(0)
    end
end

--let's init!
function init()
  connect()
  engine.release(release[1])
  engine.amp(amp[1]/100)
  engine.cutoff(20000)
  engine.pw(pw[1]/100)
  for x=0,128 do
    pixCol[x] = {}     -- create a new row
    for y=0,64 do
      pixCol[x][y] = 0
    end
  end
  scale1 = music.generate_scale(low[1],mscale,octaves[1])
  scale2 = music.generate_scale(low[2],mscale,octaves[2])
  scale3 = music.generate_scale(low[3],mscale,octaves[3])
  scale4 = music.generate_scale(low[4],mscale,octaves[4])
  scale5 = music.generate_scale(low[5],mscale,octaves[5])
  scale6 = music.generate_scale(low[6],mscale,octaves[6])
  stylechoice = math.random(1,#styles-3)
  styleselect = stylechoice
  style(stylechoice)
  initialcondition(math.random(1,#initialword))
end

--let's have a transport function for starting and stopping playback
function transport(state)
  if (state == 0) then
    beat1:stop()
    beat2:stop()
    beat3:stop()
    beat4:stop()
    beat5:stop()
    beat6:stop()
    midi_signal_out:stop()
    for a=1,#notes1 do
      midi_signal_out:note_off(notes1[a],0,midiCH[1])
    end
    for a=1,#notes1 do
      table.remove(notes1,1)
    end
    for a=1,#notes2 do
      midi_signal_out:note_off(notes2[a],0,midiCH[2])
    end
    for a=1,#notes2 do
      table.remove(notes2,1)
    end
    for a=1,#notes3 do
      midi_signal_out:note_off(notes3[a],0,midiCH[3])
    end
    for a=1,#notes3 do
      table.remove(notes3,1)
    end
    for a=1,#notes4 do
      midi_signal_out:note_off(notes4[a],0,midiCH[4])
    end
    for a=1,#notes4 do
      table.remove(notes4,1)
    end
    for a=1,#notes5 do
      midi_signal_out:note_off(notes5[a],0,midiCH[5])
    end
    for a=1,#notes5 do
      table.remove(notes5,1)
    end
    for a=1,#notes6 do
      midi_signal_out:note_off(notes6[a],0,midiCH[6])
    end
    for a=1,#notes6 do
      table.remove(notes6,1)
    end
  end
  if (state == 1) then
    startbeat()
    midi_signal_out:start()
    play(pixCol[pixX[1]][pixY[1]],1)
    play(pixCol[pixX[2]][pixY[2]],2)
    play(pixCol[pixX[3]][pixY[3]],3)
    play(pixCol[pixX[4]][pixY[4]],4)
    play(pixCol[pixX[5]][pixY[5]],5)
    play(pixCol[pixX[6]][pixY[6]],6)
  end
end

--let's have a function for moving pixels around the screen
function move(who)
  pulse[who] = 15
  if(who<=numpix) then
    pixX[who] = pixX[who] + pixDX[who]
    if (pixX[who] > 127) then
      pixX[who] = 0
    end
    if (pixX[who]<0) then
      pixX[who] = 127
    end
    pixY[who] = pixY[who] + pixDY[who]
    if (pixY[who] > 63) then
      pixY[who] = 0
    end
    if (pixY[who] <0) then
      pixY[who] = 63
    end
    if (math.random(0,100) <= trigprob[who]) then
      if (drawing == 0) then
        play(pixCol[pixX[who]][pixY[who]],who)
      end
      if (drawing == 1) then
        play(drawcolor[who],who)
      end
    end
  end
end

--oh god ... this redraw function is outta control ... but somehow still works
function redraw()
  if(drawing == 0) then
    screen.clear()
  end
  if (page == 1) then
    if(drawing == 0) then
      screen.clear()
      screen.display_png ("/home/we/dust/code/pixels/pixels.png", 0, 0)
    end
    if(drawing == 1) then
      screen.pixel(pixX[1],pixY[1])
      pixCol[pixX[1]][pixY[1]] = drawcolor[1]
      screen.level(math.floor((pixCol[pixX[1]][pixY[1]] / 127) * 15))
      screen.fill(0,0,0)
    end
    for j=1,numpix do
        if(drawing == 0) then
          pulseinc[j] = (16/12) / (60/tempo) /  stepdivamount[stepdiv[j]] 
          pulse[j] = pulse[j] - pulseinc[j]
          if (pulse[j] < 0) then
            pulse[j] = 15
          end
        end
        if (size[j] > 1 and drawing == 0) then
          screen.rect(pixX[j] - math.floor(size[j]/2)-1,pixY[j]-math.floor(size[j] /2)-1,size[j]+2,size[j]+2)
          screen.level(size[j])
          screen.fill(0,0,0)
          screen.rect(pixX[j] - math.floor(size[j]/2),pixY[j]-math.floor(size[j] /2),size[j],size[j])
          screen.level(math.floor((pixCol[pixX[j]][pixY[j]] / 128) * 16))
          size[j] = size[j] - 1
          screen.fill(0,0,0)
        end
      if (size[j] == 1 and drawing == 0) then
        screen.pixel(pixX[j],pixY[j])
        screen.level(math.floor(pulse[j]))
        screen.fill(0,0,0)
      end
    end
    if(wordblast > 0 and drawing == 0) then
      screen.level(wordblast)
      screen.font_face(1)
      screen.font_size(math.floor((wordblast/2)+12))
      screen.move(wordblast + 36,32)
      screen.text(word)
      wordblast = wordblast - 1
    end
  end
  if (page == 2) then
    screen.level(math.floor(wordcol1))
    screen.font_face(1)
    screen.font_size(8)
    screen.move(80,8)
    screen.text("landscape")
    screen.level(math.floor(wordcol2))
    screen.move(81,9)
    screen.text("landscape")
    screen.level(math.floor(wordcol3))
    screen.move(82,10)
    screen.text("landscape")
    screen.level(3)
    screen.move(5,10)
    screen.text("style " .. string.lower(styles[styleselecttemp]))
    screen.move(5,20)
    screen.text("scale ".. string.lower(music.SCALES[mscaletemp].name))
    screen.move(5,30)
    screen.text("root ")
    screen.move(37,30)
    if(key1 == 1) then
      screen.text("key")
    end
    if(key1 == 2) then
      screen.text("K&M")
    end
    if(key1 == 0) then
      screen.text(music.note_num_to_name(low[1]) .. math.floor(low[1]/12))
    end
    screen.move(52,30)
    if(key2 == 1) then
      screen.text("key")
    end
    if(key2 == 2) then
      screen.text("K&M")
    end
    if(key2 == 0) then
      screen.text(music.note_num_to_name(low[2]) .. math.floor(low[2]/12))
    end
    screen.move(67,30)
    if(key3 == 1) then
      screen.text("key")
    end
    if(key3 == 2) then
      screen.text("K&M")
    end
    if(key3 == 0) then
      screen.text(music.note_num_to_name(low[3]) .. math.floor(low[3]/12))
    end
    screen.move(82,30)
    if(key4 == 1) then
      screen.text("key")
    end
    if(key4 == 2) then
      screen.text("K&M")
    end
    if(key4 == 0) then
      screen.text(music.note_num_to_name(low[4]) .. math.floor(low[4]/12))
    end
    screen.move(97,30)
    if(key5 == 1) then
      screen.text("key")
    end
    if(key5 == 2) then
      screen.text("K&M")
    end
    if(key5 == 0) then
      screen.text(music.note_num_to_name(low[5]) .. math.floor(low[5]/12))
    end
    screen.move(112,30)
    if(key6 == 1) then
      screen.text("key")
    end
    if(key6 == 2) then
      screen.text("K&M")
    end
    if(key6 == 0) then
      screen.text(music.note_num_to_name(low[6]) .. math.floor(low[6]/12))
    end
    screen.move(5,40)
    screen.text("oct ")
     screen.move(37,40)
    screen.text(octaves[1])
    screen.move(52,40)
    screen.text(octaves[2])
    screen.move(67,40)
    screen.text(octaves[3])
    screen.move(82,40)
    screen.text(octaves[4])
    screen.move(97,40)
    screen.text(octaves[5])
    screen.move(112,40)
    screen.text(octaves[6])
    screen.move(5,50)
    screen.text("load " .. loading[loadtext])
    screen.move(5,60)
    screen.text("save " .. saving[savetext])
    if(menupos == 1) then
      screen.level(15)
      screen.move(6,11)
      screen.text("style " .. string.lower(styles[styleselecttemp]))
    end
    if(menupos == 2) then
      screen.level(15)
      screen.move(6,21)
      screen.text("scale " .. string.lower(music.SCALES[mscaletemp].name))
    end
    if(menupos > 2 and menupos < 10) then
      screen.level(15)
      screen.move(6,31)
      screen.text("root")
    end
    if(menupos == 3 or menupos == 9) then
      screen.level(15)
      screen.move(38,31)
      if(key1 == 1) then
        screen.text("key")
      end
      if(key1 == 2) then
        screen.text("K&M")
      end
      if(key1 == 0) then
        screen.text(music.note_num_to_name(low[1]) .. math.floor(low[1]/12))
      end
    end
    if(menupos == 4 or menupos == 9) then
      screen.level(15)
      screen.move(53,31)
      if(key2 == 1) then
        screen.text("key")
      end
      if(key2 == 2) then
        screen.text("K&M")
      end
      if(key2 == 0) then
        screen.text(music.note_num_to_name(low[2]) .. math.floor(low[2]/12))
      end
    end
    if(menupos == 5 or menupos == 9) then
      screen.level(15)
      screen.move(68,31)
      if(key3 == 1) then
        screen.text("key")
      end
      if(key3 == 2) then
        screen.text("K&M")
      end
      if(key3 == 0) then
        screen.text(music.note_num_to_name(low[3]) .. math.floor(low[3]/12))
      end   
    end
    if(menupos == 6 or menupos == 9) then
      screen.level(15)
      screen.move(83,31)
      if(key4 == 1) then
        screen.text("key")
      end
      if(key4 == 2) then
        screen.text("K&M")
      end
      if(key4 == 0) then
        screen.text(music.note_num_to_name(low[4]) .. math.floor(low[4]/12))
      end
    end
    if(menupos == 7 or menupos == 9) then
      screen.level(15)
      screen.move(98,31)
      if(key5 == 1) then
        screen.text("key")
      end
      if(key5 == 2) then
        screen.text("K&M")
      end
      if(key5 == 0) then
        screen.text(music.note_num_to_name(low[5]) .. math.floor(low[5]/12))
      end
    end
    if(menupos == 8 or menupos == 9) then
      screen.level(15)
      screen.move(113,31)
      if(key6 == 1) then
        screen.text("key")
      end
      if(key6 == 2) then
        screen.text("K&M")
      end
      if(key6 == 0) then
        screen.text(music.note_num_to_name(low[6]) .. math.floor(low[6]/12))
      end
    end
    if(menupos > 9 and menupos < 17) then
      screen.level(15)
      screen.move(6,41)
      screen.text("oct ")
    end
    if(menupos == 10 or menupos == 16) then
      screen.level(15)
      screen.move(38,41)
      screen.text(octaves[1])
    end
    if(menupos == 11 or menupos == 16) then
      screen.level(15)
      screen.move(53,41)
      screen.text(octaves[2])
    end
    if(menupos == 12 or menupos == 16) then
      screen.level(15)
      screen.move(68,41)
      screen.text(octaves[3])
    end
    if(menupos == 13 or menupos == 16) then
      screen.level(15)
      screen.move(83,41)
      screen.text(octaves[4])
    end
    if(menupos == 14 or menupos == 16) then
      screen.level(15)
      screen.move(98,41)
      screen.text(octaves[5])
    end
    if(menupos == 15 or menupos == 16) then
      screen.level(15)
      screen.move(113,41)
      screen.text(octaves[6])
    end
    if(menupos == 17) then
      screen.level(15)
      screen.move(6,51)
      screen.text("load " .. loading[loadtext])
    end
    if(menupos == 18) then
      screen.level(15)
      screen.move(6,61)
      screen.text("save " .. saving[savetext])
    end
  end
  if (page == 3) then
    screen.level(math.floor(wordcol1))
    screen.font_face(1)
    screen.font_size(8)
    screen.move(100,8)
    screen.text("pixels")
    screen.level(math.floor(wordcol2))
    screen.move(101,9)
    screen.text("pixels")
    screen.level(math.floor(wordcol3))
    screen.move(102,10)
    screen.text("pixels")
    screen.level(3)
    screen.move(2,10)
    screen.text("number of pixels " .. numpixsel)
    screen.move(2,30)
    screen.text("trig %")
    screen.move(37,30)
    screen.text(trigprob[1])
    screen.move(52,30)
    screen.text(trigprob[2])
    screen.move(67,30)
    screen.text(trigprob[3])
    screen.move(83,30)
    screen.text(trigprob[4])
    screen.move(97,30)
    screen.text(trigprob[5])
    screen.move(112,30)
    screen.text(trigprob[6])
    screen.move(2,20)
    screen.text("initial state " .. initialword[initialtemp])
    screen.move(2,40)
    screen.text("midi vel")
    screen.move(37,40)
    midiVELtext = midiVEL[1]
    if (midiVEL[1] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(52,40)
    midiVELtext = midiVEL[2]
    if (midiVEL[2] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(67,40)
    midiVELtext = midiVEL[3]
    if (midiVEL[3] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(83,40)
    midiVELtext = midiVEL[4]
    if (midiVEL[4] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(97,40)
    midiVELtext = midiVEL[5]
    if (midiVEL[5] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(112,40)
    midiVELtext = midiVEL[6]
    if (midiVEL[6] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(2,50)
    screen.text("midi ch")
    screen.move(37,50)
    screen.text(midiCH[1])
    screen.move(52,50)
    screen.text(midiCH[2])
    screen.move(67,50)
    screen.text(midiCH[3])
    screen.move(83,50)
    screen.text(midiCH[4])
    screen.move(97,50)
    screen.text(midiCH[5])
    screen.move(112,50)
    screen.text(midiCH[6])
    if(menupos == 1) then
      screen.level(15)
      screen.move(3,11)
      screen.text("number of pixels " .. numpixsel)
    end
    if(menupos == 2) then
      screen.level(15)
      screen.move(3,21)
      screen.text("initial state " .. initialword[initialtemp])
    end
    if(menupos > 2 and menupos < 10) then
      screen.level(15)
      screen.move(3,31)
      screen.text("trig %")
    end
    if(menupos == 3 or menupos == 9) then
      screen.level(15)
      screen.move(38,31)
      screen.text(trigprob[1])
    end
    if(menupos == 4 or menupos == 9) then
      screen.level(15)
      screen.move(53,31)
      screen.text(trigprob[2])
    end
    if(menupos == 5 or menupos == 9) then
      screen.level(15)
      screen.move(68,31)
      screen.text(trigprob[3])
    end
    if(menupos == 6 or menupos == 9) then
      screen.level(15)
      screen.move(83,31)
      screen.text(trigprob[4])
    end
    if(menupos == 7 or menupos == 9) then
      screen.level(15)
      screen.move(98,31)
      screen.text(trigprob[5])
    end
    if(menupos == 8 or menupos == 9) then
      screen.level(15)
      screen.move(113,31)
      screen.text(trigprob[6])
    end
    if(menupos > 9 and menupos < 17) then
      screen.level(15)
      screen.move(3,41)
      screen.text("midi vel")
    end
    if(menupos == 10 or menupos == 16) then
      screen.level(15)
      screen.move(38,41)
      midiVELtext = midiVEL[1]
      if (midiVEL[1] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 11 or menupos == 16) then
      screen.level(15)
      screen.move(53,41)
      midiVELtext = midiVEL[2]
      if (midiVEL[2] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos ==12 or menupos == 16) then
      screen.level(15)
      screen.move(68,41)
      midiVELtext = midiVEL[3]
      if (midiVEL[3] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 13 or menupos == 16) then
      screen.level(15)
      screen.move(83,41)
      midiVELtext = midiVEL[4]
      if (midiVEL[4] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 14 or menupos == 16) then
      screen.level(15)
      screen.move(98,41)
      midiVELtext = midiVEL[5]
      if (midiVEL[5] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 15 or menupos == 16) then
      screen.level(15)
      screen.move(113,41)
      midiVELtext = midiVEL[6]
      if (midiVEL[6] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos > 16 and menupos < 24) then
      screen.level(15)
      screen.move(3,51)
      screen.text("midi ch")
    end
    if(menupos == 17 or menupos == 23) then
      screen.level(15)
      screen.move(38,51)
      screen.text(midiCH[1])
    end
    if(menupos == 18 or menupos == 23) then
      screen.level(15)
      screen.move(53,51)
      screen.text(midiCH[2])
    end
    if(menupos == 19 or menupos == 23) then
      screen.level(15)
      screen.move(68,51)
      screen.text(midiCH[3])
    end
    if(menupos == 20 or menupos == 23) then
      screen.level(15)
      screen.move(83,51)
      screen.text(midiCH[4])
    end
    if(menupos == 21 or menupos == 23) then
      screen.level(15)
      screen.move(98,51)
      screen.text(midiCH[5])
    end
    if(menupos == 22 or menupos == 23) then
      screen.level(15)
      screen.move(113,51)
      screen.text(midiCH[6])
    end
  end
  if (page == 4) then
    screen.level(math.floor(wordcol1))
    screen.font_face(1)
    screen.font_size(8)
    screen.move(100,8)
    screen.text("synth")
    screen.level(math.floor(wordcol2))
    screen.move(101,9)
    screen.text("synth")
    screen.level(math.floor(wordcol3))
    screen.move(102,10)
    screen.text("synth")
    screen.level(3)
    screen.move(5,20)
    screen.text("rel ")
    screen.move(37,20)
    if (release[1] < 0) then
      screen.text("rnd")
      else
      screen.text(release[1])
    end
    screen.move(52,20)
    if (release[2] < 0) then
      screen.text("rnd")
      else
      screen.text(release[2])
    end
    screen.move(67,20)
    if (release[3] < 0) then
      screen.text("rnd")
      else
      screen.text(release[3])
    end
    screen.move(82,20)
    if (release[4] < 0) then
      screen.text("rnd")
      else
      screen.text(release[4])
    end
    screen.move(97,20)
    if (release[5] < 0) then
      screen.text("rnd")
      else
      screen.text(release[5])
    end
    screen.move(112,20)
    if (release[6] < 0) then
      screen.text("rnd")
      else
      screen.text(release[6])
    end
    screen.move(5,30)
    screen.text("pw ")
    screen.move(37,30)
    if (pw[1] == 0) then
      screen.text("rnd")
      else
      screen.text(pw[1])
    end
    screen.move(52,30)
    if (pw[2] == 0) then
      screen.text("rnd")
      else
      screen.text(pw[2])
    end
    screen.move(67,30)
    if (pw[3] == 0) then
      screen.text("rnd")
      else
      screen.text(pw[3])
    end
    screen.move(82,30)
    if (pw[4] == 0) then
      screen.text("rnd")
      else
      screen.text(pw[4])
    end
    screen.move(97,30)
    if (pw[5] == 0) then
      screen.text("rnd")
      else
      screen.text(pw[5])
    end
    screen.move(112,30)
    if (pw[6] == 0) then
      screen.text("rnd")
      else
      screen.text(pw[6])
    end
    screen.move(5,40)
    screen.text("amp ")
    screen.move(37,40)
    if(amp[1] == 0) then
      screen.text("rnd")
      else
      screen.text(amp[1])
    end
    screen.move(52,40)
    if(amp[2] == 0) then
      screen.text("rnd")
      else
      screen.text(amp[2])
    end
    screen.move(67,40)
    if(amp[3] == 0) then
      screen.text("rnd")
      else
      screen.text(amp[3])
    end
    screen.move(82,40)
    if(amp[4] == 0) then
      screen.text("rnd")
      else
      screen.text(amp[4])
    end
    screen.move(97,40)
    if(amp[5] == 0) then
      screen.text("rnd")
      else
      screen.text(amp[5])
    end
    screen.move(112,40)
    if(amp[6] == 0) then
      screen.text("rnd")
      else
      screen.text(amp[6])
    end
    screen.move(5,50)
    screen.text("pan ")
    screen.move(37,50)
    if(pan[1] == -1 or pan[1] == 101) then
      screen.text("rnd")
      else
      screen.text((pan[1]-50))
    end
    screen.move(52,50)
    if(pan[2] == -1 or pan[2] == 101) then
      screen.text("rnd")
      else
      screen.text((pan[2]-50))
    end
    screen.move(67,50)
     if(pan[3] == -1 or pan[3] == 101) then
      screen.text("rnd")
      else
      screen.text((pan[3]-50))
    end
    screen.move(82,50)
     if(pan[4] == -1 or pan[4] == 101) then
      screen.text("rnd")
      else
      screen.text((pan[4]-50))
    end
    screen.move(97,50)
     if(pan[5] == -1 or pan[5] == 101) then
      screen.text("rnd")
      else
      screen.text((pan[5]-50))
    end
    screen.move(112,50)
    if(pan[6] == -1 or pan[6] == 101) then
      screen.text("rnd")
      else
      screen.text((pan[6]-50))
    end
    if(menupos >= 1 and menupos < 8) then
      screen.level(15)
      screen.move(6,21)
      screen.text("rel ")
    end
    if(menupos == 1 or menupos == 7) then
      screen.level(15)
      screen.move(38,21)
      if (release[1] < 0) then
        screen.text("rnd")
        else
        screen.text(release[1])
      end
    end
    if(menupos == 2 or menupos == 7) then
      screen.level(15)
      screen.move(53,21)
      if (release[2] < 0) then
        screen.text("rnd")
        else
        screen.text(release[2])
      end
    end
    
    if(menupos == 3 or menupos == 7) then
      screen.level(15)
      screen.move(68,21)
      if (release[3] < 0) then
        screen.text("rnd")
        else
        screen.text(release[3])
      end
    end
    if(menupos == 4 or menupos == 7) then
      screen.level(15)
      screen.move(83,21)
      if (release[4] < 0) then
        screen.text("rnd")
        else
        screen.text(release[4])
      end
    end
    if(menupos == 5 or menupos == 7) then
      screen.level(15)
      screen.move(98,21)
      if (release[5] < 0) then
        screen.text("rnd")
        else
        screen.text(release[5])
      end
    end
    if(menupos == 6 or menupos == 7) then
      screen.level(15)
      screen.move(113,21)
      if (release[6] < 0) then
        screen.text("rnd")
        else
        screen.text(release[6])
      end
    end
    
    if(menupos > 7 and menupos < 15) then
      screen.level(15)
      screen.move(6,31)
      screen.text("pw ")
    end
    if(menupos == 8 or menupos == 14) then
      screen.level(15)
      screen.move(38,31)
      if (pw[1] == 0) then
        screen.text("rnd")
        else
        screen.text(pw[1])
      end
    end
    if(menupos == 9 or menupos == 14) then
      screen.level(15)
      screen.move(53,31)
      if (pw[2] == 0) then
        screen.text("rnd")
        else
        screen.text(pw[2])
      end
    end
    if(menupos == 10 or menupos == 14) then
      screen.level(15)
      screen.move(68,31)
      if (pw[3] == 0) then
        screen.text("rnd")
        else
        screen.text(pw[3])
      end
    end
    if(menupos == 11 or menupos == 14) then
      screen.level(15)
      screen.move(83,31)
      if (pw[4] == 0) then
        screen.text("rnd")
        else
        screen.text(pw[4])
      end
    end
    if(menupos == 12 or menupos == 14) then
      screen.level(15)
      screen.move(98,31)
      if (pw[5] == 0) then
        screen.text("rnd")
        else
        screen.text(pw[5])
      end
    end
    if(menupos == 13 or menupos == 14) then
      screen.level(15)
      screen.move(113,31)
      if (pw[6] == 0) then
        screen.text("rnd")
        else
        screen.text(pw[6])
      end
    end
    
    if(menupos > 14 and menupos < 22) then
      screen.level(15)
      screen.move(6,41)
      screen.text("amp ")
    end
    if(menupos == 15 or menupos == 21) then
      screen.level(15)
      screen.move(38,41)
      if(amp[1] == 0) then
        screen.text("rnd")
        else
        screen.text(amp[1])
      end
    end
    if(menupos == 16 or menupos == 21) then
      screen.level(15)
      screen.move(53,41)
      if(amp[2] == 0) then
        screen.text("rnd")
        else
        screen.text(amp[2])
      end
    end
    if(menupos == 17 or menupos == 21) then
      screen.level(15)
      screen.move(68,41)
      if(amp[3] == 0) then
        screen.text("rnd")
        else
        screen.text(amp[3])
      end
    end
    if(menupos == 18 or menupos == 21) then
      screen.level(15)
      screen.move(83,41)
      if(amp[4] == 0) then
        screen.text("rnd")
        else
        screen.text(amp[4])
      end
    end
    if(menupos == 19 or menupos == 21) then
      screen.level(15)
      screen.move(98,41)
      if(amp[5] == 0) then
        screen.text("rnd")
        else
        screen.text(amp[5])
      end
    end
    if(menupos == 20 or menupos == 21) then
      screen.level(15)
      screen.move(113,41)
      if(amp[6] == 0) then
        screen.text("rnd")
        else
        screen.text(amp[6])
      end
    end
    
    if(menupos > 21 and menupos < 29) then
      screen.level(15)
      screen.move(6,51)
      screen.text("pan ")
    end
    if(menupos == 22 or menupos == 28) then
      screen.level(15)
      screen.move(38,51)
      if(pan[1] == -1 or pan[1] == 101) then
        screen.text("rnd")
        else
        screen.text((pan[1]-50))
      end
    end
    if(menupos == 23 or menupos == 28) then
      screen.level(15)
      screen.move(53,51)
      if(pan[2] == -1 or pan[2] == 101) then
        screen.text("rnd")
        else
        screen.text((pan[2]-50))
      end
    end
    if(menupos == 24 or menupos == 28) then
      screen.level(15)
      screen.move(68,51)
      if(pan[3] == -1 or pan[3] == 101) then
        screen.text("rnd")
        else
        screen.text((pan[3]-50))
      end
    end
    if(menupos == 25 or menupos == 28) then
      screen.level(15)
      screen.move(83,51)
      if(pan[4] == -1 or pan[4] == 101) then
        screen.text("rnd")
        else
        screen.text((pan[4]-50))
      end
    end
    if(menupos == 26 or menupos == 28) then
      screen.level(15)
      screen.move(98,51)
      if(pan[5] == -1 or pan[5] == 101) then
        screen.text("rnd")
        else
        screen.text((pan[5]-50))
      end
    end
    if(menupos == 27 or menupos == 28) then
      screen.level(15)
      screen.move(113,51)
      if(pan[6] == -1 or pan[6] == 101) then
        screen.text("rnd")
        else
        screen.text((pan[6]-50))
      end
    end
    
    
    
    
    
  end
  wordcol1 = wordcol1 + .1
  if (wordcol1 > 5) then
    wordcol1 = 0
  end
  wordcol2 = wordcol2 + .1
  if (wordcol2 > 7) then
    wordcol2 = 0
  end
  wordcol3 = wordcol3 + .1
  if (wordcol3 > 15) then
    wordcol3 = 9
  end
  screen.fill(0,0,0)
  screen.update()

  --if(page == 1) then
    --if (start == 1) then
     -- _norns.screen_export_png("/home/we/dust/code/pixels/pics/screena"..piccount..".png")
     -- piccount = piccount + 1
    --end
  --end


end
  
--let's look at some key inputs
function key(n,id)
  if (n == 1 and id == 1 and drawing == 0 and k3 == 0 and k2 == 0) then
    menumode = menumode + 1 
    page = lastpage
    if(menumode > 1) then
      menumode = 0
      page = 1
    end
    menupos = lastmenupos
    numpixsel = numpix
    styleselecttemp = styleselect
    mscaletemp= mscale
    initialtemp = initial
  end
  if(page ==1) then
    if (n == 2 and id ==1) then
      k2 = 1
    end
    if (n == 2 and id ==0) then
      k2 = 0
    end
    if (n == 3 and id == 1) then
      k3 = 1
      state = state + 1
      if (state > 1) then
        state = 0
        --piccount = piccount + 100
      end
     -- start = state
      transport(state)
      for j=1,6 do
        pulse[j] = 15
      end
    end
    if (n == 3 and id == 0) then
      k3 = 0
    end
    if(k2 == 1 and k3 == 1 and drawing == 1) then
      drawing = 0
      k2 = 0
      k3 = 0
      _norns.screen_export_png("/home/we/dust/code/pixels/pixels.png")
      tab.save(pixCol, "/home/we/dust/code/pixels/pixel_data.txt")
    end
    if(k2 == 1 and k3 == 1 and drawing == 0) then
      drawing = drawing + 1
      transport(0)
      thispix = 1
      for x=0,128 do
        for y=0,64 do
          screen.pixel(x,y)
          screen.level(math.floor(15*(pixCol[x][y]/127)))
          screen.fill(0,0,0)
        end
      end
      screen.update()
      _norns.screen_export_png("/home/we/dust/code/pixels/pixels.png")
      tab.save(pixCol, "/home/we/dust/code/pixels/pixel_data.txt")
      screen.update()
    end
    if(k1 == 1 and k3 == 1 ) then
      if (drawing == 0) then
        state = state + 1
        if (state > 1) then
          state = 0
        end
        transport(state)
        for j=1,6 do
          pulse[j] = 15
        end
      end
    end
  end
  if (page == 2) then
    if(n == 3 and id == 1) then
      if (menupos == 1) then
        style(styleselecttemp)
        styleselect = styleselecttemp
      end
      if (menupos == 2) then
        mscale = mscaletemp
        scale1 = music.generate_scale(low[1],mscale,octaves[1])
        scale2 = music.generate_scale(low[2],mscale,octaves[2])
        scale3 = music.generate_scale(low[3],mscale,octaves[3])
        scale4 = music.generate_scale(low[4],mscale,octaves[4])
        scale5 = music.generate_scale(low[5],mscale,octaves[5])
        scale6 = music.generate_scale(low[6],mscale,octaves[6])
      end
      if(menupos ==17) then
        if(loadtext == 1) then
          f=io.open("/home/we/dust/code/pixels/pixel_data_a.txt","r")
          if (f~=nil) then 
            pixCol = tab.load("/home/we/dust/code/pixels/pixel_data_a.txt")
            savea:read("/home/we/dust/code/pixels/savea.pset")
            numpix = savea:get("numpix")
            styleselect = savea:get("styleselect")
            tempo = savea:get("tempo")
            mscale = savea:get("mscale")
            for a=1,6 do
              pixX[a] = savea:get("pixX"..a)
              pixY[a] = savea:get("pixY"..a)
              pixDX[a] = savea:get("pixDX"..a)
              pixDY[a] = savea:get("pixDY"..a)
              stepdiv[a] = savea:get("stepdiv"..a)
              trigprob[a] = savea:get("trigprob"..a)
              low[a] = savea:get("low"..a)
              octaves[a] = savea:get("octaves"..a)
              midiVEL[a] = savea:get("midiVEL"..a)
              midiCH[a] = savea:get("midiCH"..a)
              release[a] = savea:get("release"..a)
              pw[a] = savea:get("pw"..a)
              amp[a] = savea:get("amp"..a)
              pan[a] = savea:get("pan"..a)
            end
            scale1 = music.generate_scale(low[1],mscale,octaves[1])
            scale2 = music.generate_scale(low[2],mscale,octaves[2])
            scale3 = music.generate_scale(low[3],mscale,octaves[3])
            scale4 = music.generate_scale(low[4],mscale,octaves[4])
            scale5 = music.generate_scale(low[5],mscale,octaves[5])
            scale6 = music.generate_scale(low[6],mscale,octaves[6])
            savea:bang()
            screen.display_png ("/home/we/dust/code/pixels/pixels_a.png", 0, 0)
            screen.update()
            _norns.screen_export_png("/home/we/dust/code/pixels/pixels.png")
            syncbeat()
          end
        end
        if(loadtext == 2) then
          f=io.open("/home/we/dust/code/pixels/pixel_data_b.txt","r")
          if (f ~= nil) then
            pixCol = tab.load("/home/we/dust/code/pixels/pixel_data_b.txt")
            saveb:read("/home/we/dust/code/pixels/saveb.pset")
            numpix = saveb:get("numpix")
            styleselect = saveb:get("styleselect")
            tempo = saveb:get("tempo")
            mscale = saveb:get("mscale")
            for a=1,6 do
              pixX[a] = saveb:get("pixX"..a)
              pixY[a] = saveb:get("pixY"..a)
              pixDX[a] = saveb:get("pixDX"..a)
              pixDY[a] = saveb:get("pixDY"..a)
              stepdiv[a] = saveb:get("stepdiv"..a)
              trigprob[a] = saveb:get("trigprob"..a)
              low[a] = saveb:get("low"..a)
              octaves[a] = saveb:get("octaves"..a)
              midiVEL[a] = saveb:get("midiVEL"..a)
              midiCH[a] = saveb:get("midiCH"..a)
              release[a] = saveb:get("release"..a)
              pw[a] = saveb:get("pw"..a)
              amp[a] = saveb:get("amp"..a)
              pan[a] = saveb:get("pan"..a)
            end
            scale1 = music.generate_scale(low[1],mscale,octaves[1])
            scale2 = music.generate_scale(low[2],mscale,octaves[2])
            scale3 = music.generate_scale(low[3],mscale,octaves[3])
            scale4 = music.generate_scale(low[4],mscale,octaves[4])
            scale5 = music.generate_scale(low[5],mscale,octaves[5])
            scale6 = music.generate_scale(low[6],mscale,octaves[6])
            saveb:bang()
            screen.display_png ("/home/we/dust/code/pixels/pixels_b.png", 0, 0)
            screen.update()
            _norns.screen_export_png("/home/we/dust/code/pixels/pixels.png")
            syncbeat()
          end
        end
        if(loadtext == 3) then
        f=io.open("/home/we/dust/code/pixels/pixel_data_c.txt","r")
          if (f ~= nil) then
            pixCol = tab.load("/home/we/dust/code/pixels/pixel_data_c.txt")
            savec:read("/home/we/dust/code/pixels/savec.pset")
            numpix = savec:get("numpix")
            styleselect = savec:get("styleselect")
            tempo = savec:get("tempo")
            mscale = savec:get("mscale")
            for a=1,6 do
              pixX[a] = savec:get("pixX"..a)
              pixY[a] = savec:get("pixY"..a)
              pixDX[a] = savec:get("pixDX"..a)
              pixDY[a] = savec:get("pixDY"..a)
              stepdiv[a] = savec:get("stepdiv"..a)
              trigprob[a] = savec:get("trigprob"..a)
              low[a] = savec:get("low"..a)
              octaves[a] = savec:get("octaves"..a)
              midiVEL[a] = savec:get("midiVEL"..a)
              midiCH[a] = savec:get("midiCH"..a)
              release[a] = savec:get("release"..a)
              pw[a] = savec:get("pw"..a)
              amp[a] = savec:get("amp"..a)
              pan[a] = savec:get("pan"..a)
            end
                        scale1 = music.generate_scale(low[1],mscale,octaves[1])
            scale2 = music.generate_scale(low[2],mscale,octaves[2])
            scale3 = music.generate_scale(low[3],mscale,octaves[3])
            scale4 = music.generate_scale(low[4],mscale,octaves[4])
            scale5 = music.generate_scale(low[5],mscale,octaves[5])
            scale6 = music.generate_scale(low[6],mscale,octaves[6])
            savec:bang()
            screen.display_png ("/home/we/dust/code/pixels/pixels_c.png", 0, 0)
            screen.update()
             _norns.screen_export_png("/home/we/dust/code/pixels/pixels.png")
            syncbeat()
          end
        end
      end
      if(menupos == 18) then
        screen.display_png ("/home/we/dust/code/pixels/pixels.png", 0, 0)
        screen.update()
        if(savetext == 1) then
          tab.save(pixCol,"/home/we/dust/code/pixels/pixel_data_a.txt")
          _norns.screen_export_png("/home/we/dust/code/pixels/pixels_a.png")
          savea:set("pixX1",pixX[1])
          savea:set("pixX2",pixX[2])
          savea:set("pixX3",pixX[3])
          savea:set("pixX4",pixX[4])
          savea:set("pixX5",pixX[5])
          savea:set("pixX6",pixX[6])
          savea:set("pixY1",pixY[1])
          savea:set("pixY2",pixY[2])
          savea:set("pixY3",pixY[3])
          savea:set("pixY4",pixY[4])
          savea:set("pixY5",pixY[5])
          savea:set("pixY6",pixY[6])
          savea:set("pixDX1",pixDX[1])
          savea:set("pixDX2",pixDX[2])
          savea:set("pixDX3",pixDX[3])
          savea:set("pixDX4",pixDX[4])
          savea:set("pixDX5",pixDX[5])
          savea:set("pixDX6",pixDX[6])
          savea:set("pixDY1",pixDY[1])
          savea:set("pixDY2",pixDY[2])
          savea:set("pixDY3",pixDY[3])
          savea:set("pixDY4",pixDY[4])
          savea:set("pixDY5",pixDY[5])
          savea:set("pixDY6",pixDY[6])
          savea:set("stepdiv2",stepdiv[2])
          savea:set("stepdiv3",stepdiv[3])
          savea:set("stepdiv4",stepdiv[4])
          savea:set("stepdiv5",stepdiv[5])
          savea:set("stepdiv6",stepdiv[6])
          savea:set("stepdiv1",stepdiv[1])
          savea:set("numpix",numpix)
          savea:set("trigprob1",trigprob[1])
          savea:set("trigprob2",trigprob[2])
          savea:set("trigprob3",trigprob[3])
          savea:set("trigprob4",trigprob[4])
          savea:set("trigprob5",trigprob[5])
          savea:set("trigprob6",trigprob[6])
          savea:set("styleselect",styleselect)
          savea:set("tempo",tempo)
          savea:set("low1",low[1])
          savea:set("low2",low[2])
          savea:set("low3",low[3])
          savea:set("low4",low[4])
          savea:set("low5",low[5])
          savea:set("low6",low[6])
          savea:set("octaves1",octaves[1])
          savea:set("octaves2",octaves[2])
          savea:set("octaves3",octaves[3])
          savea:set("octaves4",octaves[4])
          savea:set("octaves5",octaves[5])
          savea:set("octaves6",octaves[6])
          savea:set("mscale",mscale)
          savea:set("midiVEL1",midiVEL[1])
          savea:set("midiVEL2",midiVEL[2])
          savea:set("midiVEL3",midiVEL[3])
          savea:set("midiVEL4",midiVEL[4])
          savea:set("midiVEL5",midiVEL[5])
          savea:set("midiVEL6",midiVEL[6])
          savea:set("midiCH1",midiCH[1])
          savea:set("midiCH2",midiCH[2])
          savea:set("midiCH3",midiCH[3])
          savea:set("midiCH4",midiCH[4])
          savea:set("midiCH5",midiCH[5])
          savea:set("midiCH6",midiCH[6])
          savea:set("release1",release[1])
          savea:set("release2",release[2])
          savea:set("release3",release[3])
          savea:set("release4",release[4])
          savea:set("release5",release[5])
          savea:set("release6",release[6])
          savea:set("pw1",pw[1])
          savea:set("pw2",pw[2])
          savea:set("pw3",pw[3])
          savea:set("pw4",pw[4])
          savea:set("pw5",pw[5])
          savea:set("pw6",pw[6])
          savea:set("amp1",amp[1])
          savea:set("amp2",amp[2])
          savea:set("amp3",amp[3])
          savea:set("amp4",amp[4])
          savea:set("amp5",amp[5])
          savea:set("amp6",amp[6])
          savea:set("pan1",pan[1])
          savea:set("pan2",pan[2])
          savea:set("pan3",pan[3])
          savea:set("pan4",pan[4])
          savea:set("pan5",pan[5])
          savea:set("pan6",pan[6])
          savea:write("/home/we/dust/code/pixels/savea.pset")
        end
        if(savetext == 2) then
          tab.save(pixCol,"/home/we/dust/code/pixels/pixel_data_b.txt")
          _norns.screen_export_png("/home/we/dust/code/pixels/pixels_b.png")
          saveb:set("pixX1",pixX[1])
          saveb:set("pixX2",pixX[2])
          saveb:set("pixX3",pixX[3])
          saveb:set("pixX4",pixX[4])
          saveb:set("pixX5",pixX[5])
          saveb:set("pixX6",pixX[6])
          saveb:set("pixY1",pixY[1])
          saveb:set("pixY2",pixY[2])
          saveb:set("pixY3",pixY[3])
          saveb:set("pixY4",pixY[4])
          saveb:set("pixY5",pixY[5])
          saveb:set("pixY6",pixY[6])
          saveb:set("pixDX1",pixDX[1])
          saveb:set("pixDX2",pixDX[2])
          saveb:set("pixDX3",pixDX[3])
          saveb:set("pixDX4",pixDX[4])
          saveb:set("pixDX5",pixDX[5])
          saveb:set("pixDX6",pixDX[6])
          saveb:set("pixDY1",pixDY[1])
          saveb:set("pixDY2",pixDY[2])
          saveb:set("pixDY3",pixDY[3])
          saveb:set("pixDY4",pixDY[4])
          saveb:set("pixDY5",pixDY[5])
          saveb:set("pixDY6",pixDY[6])
          saveb:set("stepdiv2",stepdiv[2])
          saveb:set("stepdiv3",stepdiv[3])
          saveb:set("stepdiv4",stepdiv[4])
          saveb:set("stepdiv5",stepdiv[5])
          saveb:set("stepdiv6",stepdiv[6])
          saveb:set("stepdiv1",stepdiv[1])
          saveb:set("numpix",numpix)
          saveb:set("trigprob1",trigprob[1])
          saveb:set("trigprob2",trigprob[2])
          saveb:set("trigprob3",trigprob[3])
          saveb:set("trigprob4",trigprob[4])
          saveb:set("trigprob5",trigprob[5])
          saveb:set("trigprob6",trigprob[6])
          saveb:set("styleselect",styleselect)
          saveb:set("tempo",tempo)
          saveb:set("low1",low[1])
          saveb:set("low2",low[2])
          saveb:set("low3",low[3])
          saveb:set("low4",low[4])
          saveb:set("low5",low[5])
          saveb:set("low6",low[6])
          saveb:set("octaves1",octaves[1])
          saveb:set("octaves2",octaves[2])
          saveb:set("octaves3",octaves[3])
          saveb:set("octaves4",octaves[4])
          saveb:set("octaves5",octaves[5])
          saveb:set("octaves6",octaves[6])
          saveb:set("mscale",mscale)
          saveb:set("midiVEL1",midiVEL[1])
          saveb:set("midiVEL2",midiVEL[2])
          saveb:set("midiVEL3",midiVEL[3])
          saveb:set("midiVEL4",midiVEL[4])
          saveb:set("midiVEL5",midiVEL[5])
          saveb:set("midiVEL6",midiVEL[6])
          saveb:set("midiCH1",midiCH[1])
          saveb:set("midiCH2",midiCH[2])
          saveb:set("midiCH3",midiCH[3])
          saveb:set("midiCH4",midiCH[4])
          saveb:set("midiCH5",midiCH[5])
          saveb:set("midiCH6",midiCH[6])
          saveb:set("release1",release[1])
          saveb:set("release2",release[2])
          saveb:set("release3",release[3])
          saveb:set("release4",release[4])
          saveb:set("release5",release[5])
          saveb:set("release6",release[6])
          saveb:set("pw1",pw[1])
          saveb:set("pw2",pw[2])
          saveb:set("pw3",pw[3])
          saveb:set("pw4",pw[4])
          saveb:set("pw5",pw[5])
          saveb:set("pw6",pw[6])
          saveb:set("amp1",amp[1])
          saveb:set("amp2",amp[2])
          saveb:set("amp3",amp[3])
          saveb:set("amp4",amp[4])
          saveb:set("amp5",amp[5])
          saveb:set("amp6",amp[6])
          saveb:set("pan1",pan[1])
          saveb:set("pan2",pan[2])
          saveb:set("pan3",pan[3])
          saveb:set("pan4",pan[4])
          saveb:set("pan5",pan[5])
          saveb:set("pan6",pan[6])
          saveb:write("/home/we/dust/code/pixels/saveb.pset")
        end
        if(savetext == 3) then
          tab.save(pixCol,"/home/we/dust/code/pixels/pixel_data_c.txt")
          _norns.screen_export_png("/home/we/dust/code/pixels/pixels_c.png")
          savec:set("pixX1",pixX[1])
          savec:set("pixX2",pixX[2])
          savec:set("pixX3",pixX[3])
          savec:set("pixX4",pixX[4])
          savec:set("pixX5",pixX[5])
          savec:set("pixX6",pixX[6])
          savec:set("pixY1",pixY[1])
          savec:set("pixY2",pixY[2])
          savec:set("pixY3",pixY[3])
          savec:set("pixY4",pixY[4])
          savec:set("pixY5",pixY[5])
          savec:set("pixY6",pixY[6])
          savec:set("pixDX1",pixDX[1])
          savec:set("pixDX2",pixDX[2])
          savec:set("pixDX3",pixDX[3])
          savec:set("pixDX4",pixDX[4])
          savec:set("pixDX5",pixDX[5])
          savec:set("pixDX6",pixDX[6])
          savec:set("pixDY1",pixDY[1])
          savec:set("pixDY2",pixDY[2])
          savec:set("pixDY3",pixDY[3])
          savec:set("pixDY4",pixDY[4])
          savec:set("pixDY5",pixDY[5])
          savec:set("pixDY6",pixDY[6])
          savec:set("stepdiv2",stepdiv[2])
          savec:set("stepdiv3",stepdiv[3])
          savec:set("stepdiv4",stepdiv[4])
          savec:set("stepdiv5",stepdiv[5])
          savec:set("stepdiv6",stepdiv[6])
          savec:set("stepdiv1",stepdiv[1])
          savec:set("numpix",numpix)
          savec:set("trigprob1",trigprob[1])
          savec:set("trigprob2",trigprob[2])
          savec:set("trigprob3",trigprob[3])
          savec:set("trigprob4",trigprob[4])
          savec:set("trigprob5",trigprob[5])
          savec:set("trigprob6",trigprob[6])
          savec:set("styleselect",styleselect)
          savec:set("tempo",tempo)
          savec:set("low1",low[1])
          savec:set("low2",low[2])
          savec:set("low3",low[3])
          savec:set("low4",low[4])
          savec:set("low5",low[5])
          savec:set("low6",low[6])
          savec:set("octaves1",octaves[1])
          savec:set("octaves2",octaves[2])
          savec:set("octaves3",octaves[3])
          savec:set("octaves4",octaves[4])
          savec:set("octaves5",octaves[5])
          savec:set("octaves6",octaves[6])
          savec:set("mscale",mscale)
          savec:set("midiVEL1",midiVEL[1])
          savec:set("midiVEL2",midiVEL[2])
          savec:set("midiVEL3",midiVEL[3])
          savec:set("midiVEL4",midiVEL[4])
          savec:set("midiVEL5",midiVEL[5])
          savec:set("midiVEL6",midiVEL[6])
          savec:set("midiCH1",midiCH[1])
          savec:set("midiCH2",midiCH[2])
          savec:set("midiCH3",midiCH[3])
          savec:set("midiCH4",midiCH[4])
          savec:set("midiCH5",midiCH[5])
          savec:set("midiCH6",midiCH[6])
          savec:set("release1",release[1])
          savec:set("release2",release[2])
          savec:set("release3",release[3])
          savec:set("release4",release[4])
          savec:set("release5",release[5])
          savec:set("release6",release[6])
          savec:set("pw1",pw[1])
          savec:set("pw2",pw[2])
          savec:set("pw3",pw[3])
          savec:set("pw4",pw[4])
          savec:set("pw5",pw[5])
          savec:set("pw6",pw[6])
          savec:set("amp1",amp[1])
          savec:set("amp2",amp[2])
          savec:set("amp3",amp[3])
          savec:set("amp4",amp[4])
          savec:set("amp5",amp[5])
          savec:set("amp6",amp[6])
          savec:set("pan1",pan[1])
          savec:set("pan2",pan[2])
          savec:set("pan3",pan[3])
          savec:set("pan4",pan[4])
          savec:set("pan5",pan[5])
          savec:set("pan6",pan[6])
          savec:write("/home/we/dust/code/pixels/savec.pset")
        end
      end
    end
  end
  if (page == 3) then
    if(n == 3 and id == 1) then
      if (menupos == 1) then
        numpix = numpixsel
        syncbeat()
        if(numpix ==1) then
          if(state ==1) then
            beat1:start()
          end
          beat2:stop()
          beat3:stop()
          beat4:stop()
          beat5:stop()
          beat6:stop()
        end
        if(numpix ==2) then
          if(state == 1) then
          beat1:start()
          beat2:start()
          end
          beat3:stop()
          beat4:stop()
          beat5:stop()
          beat6:stop()
        end
        if(numpix ==3) then
          if(state == 1) then
          beat1:start()
          beat2:start()
          beat3:start()
          end
          beat4:stop()
          beat5:stop()
          beat6:stop()
        end
        if(numpix ==4) then
          if(state == 1) then
          beat1:start()
          beat2:start()
          beat3:start()
          beat4:start()
          end
          beat5:stop()
          beat6:stop()
        end
        if(numpix ==5) then
          if(state == 1) then
          beat1:start()
          beat2:start()
          beat3:start()
          beat4:start()
          beat5:start()
          end
          beat6:stop()
        end
        if(numpix ==6) then
          if(state == 1) then
          beat1:start()
          beat2:start()
          beat3:start()
          beat4:start()
          beat5:start()
          beat6:start()
          end
        end
      end
      if (menupos == 2) then
        initialcondition(initialtemp)
        initial = initialtemp
      end
    end
  end
end

--let's set up soem intitial conditions for our pixel travelers
function initialcondition(number)
  if(number ~= 1) then 
    for j=1,6 do
      pixX[j] =ipixX[(number-1 )*6+j] 
      pixY[j] =ipixY[(number-1)*6 +j]
      pixDX[j] =ipixDX[(number-1)*6 +j] 
      pixDY[j] =ipixDY[(number-1)*6+j]
      stepdiv[j] = istepdiv[(number-1)*6 +j]
    end
  end
  if (number == 1) then
    for j=1,6 do
      pixX[j] =math.random(0,127) 
      pixY[j] =math.random(0,63)
      pixDX[j] =math.random(-1,1) 
      pixDY[j] =math.random(-1,1)
      stepdiv[j] = math.random(1,#stepdivamount)
    end
  end
  syncbeat()
  if(state == 1) then
    startbeat()
  end
end

--call this to re-sync all beat counters 
function syncbeat()
  beat1.time = (60/tempo) * stepdivamount[stepdiv[1]]
  beat2.time = (60/tempo) * stepdivamount[stepdiv[2]]
  beat3.time = (60/tempo) * stepdivamount[stepdiv[3]]
  beat4.time = (60/tempo) * stepdivamount[stepdiv[4]]
  beat5.time = (60/tempo) * stepdivamount[stepdiv[5]]
  beat6.time = (60/tempo) * stepdivamount[stepdiv[6]]
end

--call this to start all beat clocks
function startbeat()
  beat1:start()
  beat2:start()
  beat3:start()
  beat4:start()
  beat5:start()
  beat6:start()
end

--call this to stop all beat clocks
function stopbeat()
  beat1:stop()
  beat2:stop()
  beat3:stop()
  beat4:stop()
  beat5:stop()
  beat6:stop()
end

--call this to trigger a note from a pixel
function play(note,who)
  oldrange = 127
  actualVEL = midiVEL[who]
  releaser = release[who]/10
  if(releaser < 0) then
    releaser = math.random(1,100)/10
  end
  engine.release(releaser)
  pwer = pw[who]/100
  if(pw[who] == 0) then
    pwer = math.random(0,100)/100
  end
  engine.pw(pwer)
  amper = amp[who]
  if(amper < 1) then
    amper = math.random(1,100)
  end
  engine.amp(amper/100)
  panner = (pan[who]-50)/50
  if (pan[who] == -1 or pan[who] == 101) then
    panner = (math.random(0,100)-50)/50
  end
  engine.pan(panner)
  if(midiVEL[who] == -1) then
    actualVEL = math.random(0,128)
  end
  if (who == 1 and (key1 == 0 or key1 == 1 or (key1 == 2 and mute == false))) then
    newrange = scale1[#scale1] - scale1[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale1[1])
    table.insert(notes1,1,music.snap_note_to_array (note, scale1))
    if(#notes1 > 1) then
      midi_signal_out:note_off(notes1[2],nil,midiCH[who])
      table.remove(notes1,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale1)))
    midi_signal_out:note_on(music.snap_note_to_array (note, scale1),actualVEL,midiCH[who])
  end
  if (who == 2 and (key2 == 0 or key2 == 1 or (key2 == 2 and mute == false))) then
    newrange = scale2[#scale2] - scale2[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale2[1])
    table.insert(notes2,1,music.snap_note_to_array (note, scale2))
    if(#notes2 > 1) then
      midi_signal_out:note_off(notes2[2],nil,midiCH[who])
      table.remove(notes2,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale2)))
    midi_signal_out:note_on(music.snap_note_to_array (note, scale2),actualVEL,midiCH[who])
  end
  if (who == 3 and (key3 == 0 or key3 == 1 or (key3 == 2 and mute == false))) then
    newrange = scale3[#scale3] - scale3[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale3[1])
    table.insert(notes3,1,music.snap_note_to_array (note, scale3))
    if(#notes3 > 1) then
      midi_signal_out:note_off(notes3[2],nil,midiCH[who])
      table.remove(notes3,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale3)))
    midi_signal_out:note_on(music.snap_note_to_array (note, scale3),actualVEL,midiCH[who])
  end
  if (who == 4 and (key4 == 0 or key4 == 1 or (key4 == 2 and mute == false))) then
    newrange = scale4[#scale4] - scale4[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale4[1])
    table.insert(notes4,1,music.snap_note_to_array (note, scale4))
    if(#notes4 > 1) then
      midi_signal_out:note_off(notes4[2],nil,midiCH[who])
      table.remove(notes4,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale4)))
    midi_signal_out:note_on(music.snap_note_to_array (note, scale4),actualVEL,midiCH[who])
  end
  if (who == 5 and (key5 == 0 or key5 == 1 or (key5 == 2 and mute == false))) then
    newrange = scale5[#scale5] - scale5[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale5[1])
    table.insert(notes5,1,music.snap_note_to_array (note, scale5))
    if(#notes5 > 1) then
      midi_signal_out:note_off(notes5[2],nil,midiCH[who])
      table.remove(notes5,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale5)))
    midi_signal_out:note_on(music.snap_note_to_array (note, scale5),actualVEL,midiCH[who])
  end
  if (who == 6 and (key6 == 0 or key6== 1 or (key6 == 2 and mute == false))) then
    newrange = scale6[#scale6] - scale6[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale6[1])
    table.insert(notes6,1,music.snap_note_to_array (note, scale6))
    if(#notes6 > 1) then
      midi_signal_out:note_off(notes6[2],nil,midiCH[who])
      table.remove(notes6,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale6)))
    midi_signal_out:note_on(music.snap_note_to_array (note, scale6),actualVEL,midiCH[who])
  end
end
  
--let's look at twiddled knobs
function enc(n,delta)
  if (n == 1 and menumode == 1) then
    page = util.clamp(page + delta,2,4)
    lastpage = page
    menupos = 1
    numpixsel = numpix
    styleselecttemp = styleselect
    mscaletemp = mscale
    initialtemp = initial
  end
  if (page == 1) then
    if(n == 1 and drawing == 1) then
      drawcolor[1] = util.clamp(drawcolor[1] + delta,0,127)
      play(pixCol[pixX[1]][pixY[1]],1)
    end
    if (n ==1 and k2 == 0 and drawing == 0) then
      tempo = util.clamp(tempo + delta,1,240)
      params:set("clock_tempo",tempo)
      wordblast = 16
      word = tempo
      syncbeat()
      if (state == 1) then
        startbeat()
      end
      for j=1,6 do
        pulse[j] = 15
      end
    end
    if (n ==1 and k2 ==1 and drawing == 0) then
      stepdiv[thispix] = math.floor(util.clamp(stepdiv[thispix] + delta, 1,#stepdivamount))
      wordblast = 16
      word = lengthname[stepdiv[thispix]]
      syncbeat()
      if (state == 1) then
        startbeat()
      end
      for j=1,6 do
        pulse[j] = 15
      end
    end
    if (n == 3 and k3 == 1 and drawing == 0) then
    end
    if (n == 2 and k2 == 0 and k3 == 0) then
      pixX[thispix] = util.clamp(pixX[thispix] + delta,0,127)
      if(drawing == 0) then
        play(pixCol[pixX[thispix]][pixY[thispix]],thispix)
        size[thispix] = 6
      end
      if(drawing == 1) then
         play(drawcolor[thispix],thispix) 
      end
    end
    if (n == 2 and k2 == 1 and drawing == 0) then
      direction[thispix] = util.clamp(direction[thispix] + delta,0,10) 
      if (direction[thispix] == 0) then
        direction[thispix] = 9
      end
      if (direction[thispix] == 10) then
        direction[thispix] = 1
      end
      if(direction[thispix] == 1) then
        pixDX[thispix] = 0
        pixDY[thispix] = -1
      end
      if(direction[thispix] == 2) then
        pixDX[thispix] = 1
        pixDY[thispix] = -1
      end
      if(direction[thispix] == 3) then
        pixDX[thispix] = 1
        pixDY[thispix] = 0
      end
      if(direction[thispix] == 4) then
        pixDX[thispix] = 1
        pixDY[thispix] = 1
      end
      if(direction[thispix] == 5) then
        pixDX[thispix] = 0
        pixDY[thispix] = 1
      end
      if(direction[thispix] == 6) then
        pixDX[thispix] = -1
        pixDY[thispix] = 1
      end
      if(direction[thispix] == 7) then
        pixDX[thispix] = -1
        pixDY[thispix] = 0
      end
      if(direction[thispix] == 8) then
        pixDX[thispix] = -1
        pixDY[thispix] = -1
      end
      if(direction[thispix] == 9) then
        pixDX[thispix] = 0
        pixDY[thispix] = 0
      end
      wordblast = 16
      word = directionname[direction[thispix]]
    end
    if (n == 3 and k2 == 1 and drawing == 0) then
      thispix = util.clamp(thispix + delta,1,numpix)
      wordblast = 8
      word = thispix
      size[thispix] = 6
    end
    if (n == 3 and k2 == 0 and k3 == 0) then
      pixY[thispix] = util.clamp(pixY[thispix] + delta,0,63)
      if(drawing == 0) then
        play(pixCol[pixX[thispix]][pixY[thispix]],thispix)  
        size[thispix] = 6
      end
      if (drawing == 1) then
        play(drawcolor[thispix],thispix)  
      end
    end
  end
  if (page == 2) then
    if(n == 2) then
      menupos = util.clamp(menupos + delta,1,18)
      lastmenupos = menupos
    end
    if(n == 3) then
      if (menupos == 1) then
        styleselecttemp = util.clamp(styleselecttemp+delta,1,#styles)
      end
      if (menupos == 2) then
        mscaletemp = util.clamp(mscaletemp+delta,1,41)
      end
      if (menupos == 3) then
        low[1] = util.clamp(low[1]+delta,-2,127)
        if (low[1] < 0) then
          key1 = 1
          if (low[1] == -2) then
            key1 = 2
          end
          low[1] = 0
          else
            key1 = 0
        end
        scale1 = music.generate_scale(low[1],mscale,octaves[1])
      end
      if (menupos == 4) then
        low[2] = util.clamp(low[2]+delta,-2,127)
        if (low[2]  < 0) then
          key2 = 1
          if (low[2] == -2) then
            key2 = 2
          end
          low[2] = 0
          else
            key2 = 0
        end
        scale2 = music.generate_scale(low[2],mscale,octaves[2])
      end
      if (menupos == 5) then
        low[3] = util.clamp(low[3]+delta,-2,127)
        if (low[3]  < 0) then
          key3 = 1
          if (low[3] == -2) then
            key3 = 2
          end
          low[3] = 0
          else
            key3 = 0
        end
        scale3 = music.generate_scale(low[3],mscale,octaves[3])
      end
      if (menupos == 6) then
        low[4] = util.clamp(low[4]+delta,-2,127)
        if (low[4]  < 0) then
          key4 = 1
          if (low[4] == -2) then
            key4 = 2
          end
          low[4] = 0
          else
            key4 = 0
        end
        scale4 = music.generate_scale(low[4],mscale,octaves[4])
      end
      if (menupos == 7 ) then
        low[5] = util.clamp(low[5]+delta,-2,127)
        if (low[5]  < 0) then
          key5 = 1
          if (low[5] == -2) then
            key5 = 2
          end
          low[5] = 0
          else
            key5 = 0
        end
        scale5 = music.generate_scale(low[5],mscale,octaves[5])
      end
      if (menupos == 8) then
        low[6] = util.clamp(low[6]+delta,-2,127)
        if (low[6]  < 0) then
          key6 = 1
          if (low[6] == -2) then
            key6 = 2
          end
          low[6] = 0
          else
            key6 = 0
        end
        scale6 = music.generate_scale(low[6],mscale,octaves[6])
      end
      if (menupos == 9) then
        lowmain = util.clamp(lowmain +delta,-2,127)
        key1 = 0
        key2 = 0
        key3 = 0
        key4 = 0
        key5 = 0
        key6 = 0
        for a=1,6 do
          low[a] = lowmain
        end
        if(lowmain  == -1) then
          key1 = 1
          key2 = 1
          key3 = 1
          key4 = 1
          key5 = 1
          key6 = 1
          low[1] = 0
          low[2] = 0
          low[3] = 0
          low[4] = 0
          low[5] = 0
          low[6] = 0
        end
        if(lowmain == -2) then
          key1 = 2
          key2 = 2
          key3 = 2
          key4 = 2
          key5 = 2
          key6 = 2
          low[1] = 0
          low[2] = 0
          low[3] = 0
          low[4] = 0
          low[5] = 0
          low[6] = 0
        end
        scale1 = music.generate_scale(low[1],mscale,octaves[1])
        scale2 = music.generate_scale(low[2],mscale,octaves[2])
        scale3 = music.generate_scale(low[3],mscale,octaves[3])
        scale4 = music.generate_scale(low[4],mscale,octaves[4])
        scale5 = music.generate_scale(low[5],mscale,octaves[5])
        scale6 = music.generate_scale(low[6],mscale,octaves[6])
      end
      if (menupos == 10) then
        octaves[1] = util.clamp(octaves[1]+delta,1,8)
        scale1 = music.generate_scale(low[1],mscale,octaves[1])
      end
      if (menupos == 11) then
        octaves[2] = util.clamp(octaves[2]+delta,1,8)
        scale2 = music.generate_scale(low[2],mscale,octaves[2])
      end
      if (menupos == 12) then
        octaves[3] = util.clamp(octaves[3]+delta,1,8)
        scale3 = music.generate_scale(low[3],mscale,octaves[3])
      end
      if (menupos == 13) then
        octaves[4] = util.clamp(octaves[4]+delta,1,8)
        scale4 = music.generate_scale(low[4],mscale,octaves[4])
      end
      if (menupos == 14) then
        octaves[5] = util.clamp(octaves[5]+delta,1,8)
        scale5 = music.generate_scale(low[5],mscale,octaves[5])
      end
      if (menupos == 15) then
        octaves[6] = util.clamp(octaves[6]+delta,1,8)
        scale6 = music.generate_scale(low[6],mscale,octaves[6])
      end
      if (menupos == 16) then
        octavesmain = util.clamp(octavesmain + delta,1,8)
        octaves[1] = octavesmain
        scale1 = music.generate_scale(low[1],mscale,octaves[1])
        octaves[2] = octavesmain
        scale2 = music.generate_scale(low[2],mscale,octaves[2])
        octaves[3] = octavesmain
        scale3 = music.generate_scale(low[3],mscale,octaves[3])
        octaves[4] = octavesmain
        scale4 = music.generate_scale(low[4],mscale,octaves[4])
        octaves[5] = octavesmain
        scale5 = music.generate_scale(low[5],mscale,octaves[5])
        octaves[6] = octavesmain
        scale6 = music.generate_scale(low[6],mscale,octaves[6])
      end
      if (menupos == 17) then
        loadtext = util.clamp(loadtext+delta,1,#loading)
      end
      if (menupos == 18) then
        savetext = util.clamp(savetext+delta,1,#saving)
      end
    end
  end
  if (page == 3) then
    if(n == 2) then
      menupos = util.clamp(menupos + delta,1,23)
      lastmenupos = menupos
    end
    if(n == 3) then
      if (menupos == 1) then
       numpixsel = util.clamp(numpixsel+delta,1,6)
      end
      if (menupos == 2) then
        initialtemp = util.clamp(initialtemp + delta, 1,#initialword)
      end
      if (menupos == 3) then
       trigprob[1] = util.clamp(trigprob[1]+delta,0,100)
      end
      if (menupos == 4) then
       trigprob[2] = util.clamp(trigprob[2]+delta,0,100)
      end
      if (menupos == 5) then
       trigprob[3] = util.clamp(trigprob[3]+delta,0,100)
      end
      if (menupos == 6) then
       trigprob[4] = util.clamp(trigprob[4]+delta,0,100)
      end
      if (menupos == 7) then
       trigprob[5] = util.clamp(trigprob[5]+delta,0,100)
      end
      if (menupos == 8) then
       trigprob[6] = util.clamp(trigprob[6]+delta,0,100)
      end
      if (menupos == 9) then
        trigprobmain = util.clamp((trigprobmain) + delta, 1,100)
        for all=1,6 do
          trigprob[all] = trigprobmain
        end
      end
      if (menupos == 10) then
        midiVEL[1] = util.clamp(midiVEL[1] + delta, -1,127)
      end
      if (menupos == 11) then
        midiVEL[2] = util.clamp(midiVEL[2] + delta, -1,127)
      end
      if (menupos == 12) then
        midiVEL[3] = util.clamp(midiVEL[3] + delta, -1,127)
      end
      
      if (menupos == 13) then
        midiVEL[4] = util.clamp(midiVEL[4] + delta, -1,127)
      end
      
      if (menupos == 14) then
        midiVEL[5] = util.clamp(midiVEL[5] + delta, -1,127)
      end
      
      if (menupos == 15) then
        midiVEL[6] = util.clamp(midiVEL[6] + delta, -1,127)
      end
      if (menupos == 16) then
        midiVELmain = util.clamp(midiVELmain + delta, -1,127)
        for all=1,6 do
          midiVEL[all] = midiVELmain
        end
      end
      if (menupos == 17) then
        for a=1,#notes1 do
          midi_signal_out:note_off(notes1[a],0,midiCH[1])
        end
        for a=1,#notes1 do
          table.remove(notes1,1)
        end
        midiCH[1] = util.clamp(midiCH[1] + delta, 1,16)
      end
      
      if (menupos == 18) then
      for a=1,#notes2 do
          midi_signal_out:note_off(notes2[a],0,midiCH[2])
        end
        for a=1,#notes2 do
          table.remove(notes2,1)
        end
        midiCH[2] = util.clamp(midiCH[2] + delta, 1,16)
      end
      if (menupos == 19) then
        for a=1,#notes3 do
          midi_signal_out:note_off(notes3[a],0,midiCH[3])
        end
        for a=1,#notes3 do
          table.remove(notes3,1)
        end
        midiCH[3] = util.clamp(midiCH[3] + delta, 1,16)
      end
      if (menupos == 20) then
        for a=1,#notes4 do
          midi_signal_out:note_off(notes4[a],0,midiCH[4])
        end
        for a=1,#notes4 do
          table.remove(notes4,1)
        end
        midiCH[4] = util.clamp(midiCH[4] + delta, 1,16)
      end
      if (menupos == 21) then
        for a=1,#notes5 do
          midi_signal_out:note_off(notes5[a],0,midiCH[5])
        end
        for a=1,#notes5 do
          table.remove(notes5,1)
        end
        midiCH[5] = util.clamp(midiCH[5] + delta, 1,16)
      end
      if (menupos == 22) then
        for a=1,#notes6 do
          midi_signal_out:note_off(notes6[a],0,midiCH[6])
        end
        for a=1,#notes6 do
          table.remove(notes6,1)
        end
        midiCH[6] = util.clamp(midiCH[6] + delta, 1,16)
      end
      if (menupos == 23) then
        midiCHmain = util.clamp((midiCHmain) + delta, 1,16)
        for a=1,#notes1 do
          midi_signal_out:note_off(notes1[a],0,midiCH[1])
        end
        for a=1,#notes1 do
          table.remove(notes1,1)
        end
        for a=1,#notes2 do
          midi_signal_out:note_off(notes2[a],0,midiCH[2])
        end
        for a=1,#notes2 do
          table.remove(notes2,1)
        end
        for a=1,#notes3 do
          midi_signal_out:note_off(notes3[a],0,midiCH[3])
        end
        for a=1,#notes3 do
          table.remove(notes3,1)
        end
        for a=1,#notes4 do
          midi_signal_out:note_off(notes4[a],0,midiCH[4])
        end
        for a=1,#notes4 do
          table.remove(notes4,1)
        end
        for a=1,#notes5 do
          midi_signal_out:note_off(notes5[a],0,midiCH[5])
        end
        for a=1,#notes5 do
          table.remove(notes5,1)
        end
        for a=1,#notes6 do
          midi_signal_out:note_off(notes6[a],0,midiCH[6])
        end
        for a=1,#notes6 do
          table.remove(notes6,1)
        end
        for all=1,6 do
          midiCH[all] = midiCHmain
        end
      end
    end
  end
  if (page == 4) then
    if(n == 2) then
      menupos = util.clamp(menupos + delta,1,28)
      lastmenupos = menupos
    end
    if(n == 3) then
      if (menupos == 1) then
        release[1] = util.clamp(release[1]+delta,-1,100)
      end
      if (menupos == 2) then
        release[2] = util.clamp(release[2]+delta,-1,100)
      end
      if (menupos == 3) then
        release[3] = util.clamp(release[3]+delta,-1,100)
      end
      if (menupos == 4) then
        release[4] = util.clamp(release[4]+delta,-1,100)
      end
      if (menupos == 5) then
        release[5] = util.clamp(release[5]+delta,-1,100)
      end
      if (menupos == 6) then
        release[6] = util.clamp(release[6]+delta,-1,100)
      end
      if (menupos == 7) then
        temprel = util.clamp(temprel+delta,-1,100)
        for a=1,6 do
          release[a]=temprel
        end
      end
      if (menupos == 8) then
        pw[1] = util.clamp(pw[1]+delta,0,100)
      end
      if (menupos == 9) then
        pw[2] = util.clamp(pw[2]+delta,0,100)
      end
      if (menupos == 10) then
        pw[3] = util.clamp(pw[3]+delta,0,100)
      end
      if (menupos == 11) then
        pw[4] = util.clamp(pw[4]+delta,0,100)
      end
      if (menupos == 12) then
        pw[5] = util.clamp(pw[5]+delta,0,100)
      end
      if (menupos == 13) then
        pw[6] = util.clamp(pw[6]+delta,0,100)
      end
      if (menupos == 14) then
        temppw = util.clamp(temppw+delta,0,100)
        for a=1,6 do
          pw[a]=temppw
        end
      end
      if (menupos == 15) then
        amp[1] = util.clamp(amp[1]+delta,0,100)
      end
      if (menupos == 16) then
        amp[2] = util.clamp(amp[2]+delta,0,100)
      end
      if (menupos == 17) then
        amp[3] = util.clamp(amp[3]+delta,0,100)
      end
      if (menupos == 18) then
        amp[4] = util.clamp(amp[4]+delta,0,100)
      end
      if (menupos == 19) then
        amp[5] = util.clamp(amp[5]+delta,0,100)
      end
      if (menupos == 20) then
        amp[6] = util.clamp(amp[6]+delta,0,100)
      end
      if (menupos == 21) then
        tempamp = util.clamp(tempamp+delta,0,100)
        for a=1,6 do
          amp[a]=tempamp
        end
      end
      if (menupos == 22) then
        pan[1] = util.clamp(pan[1]+delta,-1,101)
      end
      if (menupos == 23) then
        pan[2] = util.clamp(pan[2]+delta,-1,101)
      end
      if (menupos == 24) then
        pan[3] = util.clamp(pan[3]+delta,-1,101)
      end
      if (menupos == 25) then
        pan[4] = util.clamp(pan[4]+delta,-1,101)
      end
      if (menupos == 26) then
        pan[5] = util.clamp(pan[5]+delta,-1,101)
      end
      if (menupos == 27) then
        pan[6] = util.clamp(pan[6]+delta,-1,101)
      end
      if (menupos == 28) then
        temppan = util.clamp(temppan+delta,-1,101)
        for a=1,6 do
          pan[a]=temppan
        end
      end
    end
  end
end
  
--let's set the style of landscape our pixels travel on
function style(q)
  if (q == 1) then
    total = 0
    a = 1
    sizer = {}
    peak = {}
    while (total < 128) do
      sizer[a] = 8 * (math.random(1,6))
      peak[a] = (math.random(1,3))
      total = total + sizer[a]
      a = a + 1
    end
    a = 1
    total = sizer[a]
    for x=0,128 do

      for y=0,64 do
        temp = (-1*(math.sin(math.pi * ((x-total)/(sizer[a]))))) * 127 / peak[a]
        if (temp < 0) then
          temp = 0
        end
        pixCol[x][y] = temp
        if (x == total and x < 128) then
          total = total + sizer[a+1]
          a = a + 1
        end
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 127) * 15))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 2) then
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = math.random(1,128)
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 128) * 16))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 3) then
    col = {}
    for a=1,16 do
      col[a] = a * 8
    end
    counter = 0
    position = math.random(1,#col)
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = col[position] +counter
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 127) * 15))
        screen.fill(0,0,0)
      end
      counter = counter + 1
      if(counter == 8 and x < 127) then
        table.remove(col,position)
        counter = 0
        position = math.random(1,#col)
      end
    end
  end  
  if (q == 4) then
    factor = math.random(0,1000)
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = math.abs(math.sin(math.pi * ((factor+x)/(8+y))) * 128)
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 128) * 16))
        screen.fill(0,0,0)
      end
    end
  end  
  if (q == 5) then
    tri = 0
    dir = 1
    factor = math.random(-100,100)/100
    for y=0,64 do
      for x=0,128 do
      tri = tri + dir * (9+factor)
        if (tri > 128) then
          dir = -1
          tri = 128
        end
        if(tri < 0) then
          dir = 1
          tri = 0
        end
      pixCol[x][y] = tri
      screen.pixel(x,y)
      screen.level(math.floor((pixCol[x][y] / 128) * 16))
      screen.fill(0,0,0)
      end
    end
  end
  if (q == 6) then
    --top
    width = 2
    color = colora
    startpos = 0
    endpos = 128
    for y=0, 32 do
      for x=startpos,endpos do
        pixCol[x][y] = color
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 127) * 15))
        screen.fill(0,0,0)
      end
      color = color - 4
      if (color < 0) then
        color = 127
      end
      endpos = endpos - 2
      startpos = startpos + 2
    end
    --bottom
    color = colora
    startpos = 64
    endpos = 64
    for y=32, 64 do
      for x=startpos,endpos do
        pixCol[x][y] = color
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 127) * 15))
        screen.fill(0,0,0)
      end
      color = color + 4
      if (color > 127) then
        color = 0
      end
      endpos = endpos + 2
      startpos = startpos - 2
    end
    
    --left
    color = colora
    startpos = 1
    endpos = 64
    for x=0, 64 do
      for y=math.floor(startpos),math.floor(endpos) do
        pixCol[x][y] = color
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 127) * 15))
        screen.fill(0,0,0)
      end
      color = color - 2
      if (color < 0) then
        color = 127
      end
      endpos = endpos - .5
      startpos = startpos + .5
    end
    
    --right
    flip = 0 
    color = colora
    startpos = 33
    endpos = 32
    for x=64, 127 do
      for y=math.floor(startpos),math.floor(endpos) do
        pixCol[x][y] = color
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 127) * 15))
        screen.fill(0,0,0)
      end
      color = color + 2
      if (color > 127) then
        color = 0
      end
      endpos = endpos + .5
      startpos = startpos - .5
    end
    colora = colora - 8
    if (colora < 0) then
      colora = 127 + colora
    end
  end  
  if (q == 7) then
    basecol = math.random(0,127)
    color = math.random(1,15) * 8 - 1
    for y=0,64 do
      width = 4
      for x=0,128 do
        if(width < 4) then
          pixCol[x][y] = color
          screen.pixel(x,y)
          screen.level(math.floor((pixCol[x][y] / 127) * 15))
          screen.fill(0,0,0)
          else
            pixCol[x][y] = basecol
            screen.pixel(x,y)
            screen.level(math.floor((pixCol[x][y] / 127) * 15))
            screen.fill(0,0,0)
        end
        width = width + 1
        if(width > 7) then
          width = 0
        end
      end
      color = color - 2
      if (color < 0) then
        color = 127
      end
    end
    color = math.random(0,127)
    for x=0,128 do
      width = 4
      for y=0,64 do
        if (width < 4) then
          pixCol[x][y] = color
          screen.pixel(x,y)
          screen.level(math.floor((pixCol[x][y] / 127) * 15))
          screen.fill(0,0,0)
        end
        width = width + 1
        if (width > 7) then
          width = 0
        end
      end
      color = color + 1
      if(color > 127) then
        color = 0
      end
    end
    
  end
  if (q == 8) then
    factor = math.random(-100,100)
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = util.clamp(math.abs((((math.sin(2 * math.pi * (x/127)))) * (127-factor) + ((math.sin(2 * math.pi * (y/63))) * (63-factor)))/1.5),0,127)
        screen.pixel(x,y)
        screen.level(math.floor((pixCol[x][y] / 127) * 15))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 9) then
    col = math.random(0,127)
    factor = math.random(4,10)
    xpos = 0
    for x=0,63 do
      for y=0,64 do
        pixCol[xpos][y] = col
        pixCol[xpos+1][y] = col
        col = col + factor
        if (col > 127) then
          col = 0
        end
        screen.pixel(xpos,y)
        screen.pixel(xpos+1,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
      xpos = xpos + 2
    end
  end
  if (q == 10) then
    col = 0
    top = math.random(0,127)
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = col
        col = col + 9
        if (col > top) then
          col = 0
          top = math.random(0,128)
        end
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 11) then
    l = {}
    r = {}
    peak = {}
    height = {}
    heighttotal = 3
    for w=1,25 do
      l[w] = 64 + math.random(-5,5)
      r[w] = l[w]
      peak[w]=math.random(7,15)
      height[w] = heighttotal + 3
      heighttotal = height[w]
    end
    height[0] = 0
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = 0
        for w=1,25 do
          if(y >= height[w]-peak[w] and y <= height[w]) then
            if(x >= l[w] and x <= r[w]) then
              pixCol[x][y] = 0
            end
            if(y >= height[w]-peak[w] and y <= height[w] and(x == l[w] or x == r[w])) then
              pixCol[x][y] = 127 + (y - 64)
            end
            if(y == height[w] and (x<= l[w] or x >= r[w])) then
              pixCol[x][y] = 127 * ((y)/64)
            end
            screen.pixel(x,y)
            screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
            screen.fill(0,0,0)
          end
        end
      end
      for w=1,25 do
        if(y >= height[w]-peak[w]) then
          l[w] = l[w] - 1
          r[w] = r[w] + 1
        end
      end
    end
  end  
  if (q == 12) then
    col = 0
    factor = math.random(1,7)
    factor2 = math.random(1,7)
    top = 127
    bottom = 0
    up = 1
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = col
        col = col + 1
        if (col > top) then
          col = bottom
          if (up == 1) then
            top = top - factor
          end
          if(up == 0) then
            bottom = bottom + factor2
          end
          if(top < 64) then
            top = 127
            up = 0
            col = bottom
          end
          if(bottom > 64) then
            bottom = 0
            up = 1
            col = bottom
          end
        end
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 13) then
    col = {}
    for w=0,128 do
      col[w] = w
    end
    for x=0,128 do
      selection = math.random(1,#col)
      for y=0,64 do
        pixCol[x][y] = col[selection]
        if(y == 64 and #col > 1) then
          table.remove(col,selection)
        end
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 14) then
    factor = math.random(10,100)
    factor2 = math.random(60,120)
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = util.clamp(math.abs(math.floor(math.sin((x-12.5)/100*math.pi) * factor2 + math.sin(y/63*math.pi) * factor)),0,127)
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 15) then
    factor = math.random(10,100)/100
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = util.clamp(math.floor(math.abs((x+y)/127 * (128-y/factor))),0,127)
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 16) then
    side = math.random(5,20)
    sx = math.random(0,127-side)
    sy = math.random(0,64-side)
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = math.random(0,32)
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
    col = 127
    for squares=0, 20 do
      side = math.random(5,25)
      xorigin = math.random(0,127-side)
      yorigin = math.random(0,63-side)
      sx = xorigin
      sy = yorigin
      sideorigin = side
      x = sx
      y = sy
      col = 127
      colorigin = col
      --top
      for top = 0, side do
        x = sx
        for row = 0, side do
          pixCol[x][y] = math.floor(col - col *  (side/sideorigin) + 15)
          screen.pixel(x,y)
          screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
          screen.fill(0,0,0)
          x = x + 1
        end
        y = y + 1
        sx = sx + 1
        side = side - 2
      end
      -- bottom
      sx = xorigin
      sy = yorigin
      side = sideorigin
      x = sx
      y = sy + side
      for bottom = 0, side do
        x = sx
        for row = 0, side do
          pixCol[x][y] = math.floor(col - col *  (side/sideorigin) + 15)
          screen.pixel(x,y)
          screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
          screen.fill(0,0,0)
          x = x + 1
        end
        y = y - 1
        sx = sx + 1
        side = side - 2
      end
      --left
      sx = xorigin
      sy = yorigin
      side = sideorigin
      x = sx
      y = sy
      for bottom = 0, side do
        y = sy
        for row = 0, side do
          pixCol[x][y] = math.floor(col - col *  (side/sideorigin) + 15)
          screen.pixel(x,y)
          screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
          screen.fill(0,0,0)
          y = y + 1
        end
        x = x + 1
        sy = sy + 1
        side = side - 2
      end
      --right
      sx = xorigin
      sy = yorigin
      side = sideorigin
      x = sx + side
      y = sy
      for bottom = 0, side do
        y = sy
        for row = 0, side do
          pixCol[x][y] = math.floor(col - col *  (side/sideorigin)+ 15)
          screen.pixel(x,y)
          screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
          screen.fill(0,0,0)
          y = y + 1
        end
        x = x - 1
        sy = sy + 1
        side = side - 2
      end
    end
  end
  if (q == 17) then
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = math.random(-64,24)
        if(pixCol[x][y]<0) then
          pixCol[x][y] = math.random(0,8)
        end
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
    for a=1,math.random(25,125) do
      xx = math.random(2,125)
      yy = math.random(2,61)
      base = 127
      base1 = math.random(base-60,base-24)
      base2 = math.random(base-96,base-72)
      screen.pixel(xx,yy)
      screen.level(math.floor((base/127)*15))
      pixCol[xx][yy] = base
      screen.fill(0,0,0)
      
      screen.pixel(xx-1,yy)
      screen.level(math.floor((base1/127)*15))
      pixCol[xx-1][yy] = base1
      screen.fill(0,0,0)
      
      screen.pixel(xx-2,yy)
      screen.level(math.floor((base2/127)*15))
      pixCol[xx-2][yy] = base2
      screen.fill(0,0,0)
      
      screen.pixel(xx+1,yy)
      screen.level(math.floor((base1/127)*15))
      pixCol[xx+1][yy] = base1
      screen.fill(0,0,0)
      
      screen.pixel(xx+2,yy)
      screen.level(math.floor((base2/127)*15))
      pixCol[xx+2][yy] = base2
      screen.fill(0,0,0)
      
      screen.pixel(xx,yy+1)
      screen.level(math.floor((base1/127)*15))
      pixCol[xx][yy+1] = base1
      screen.fill(0,0,0)
      
      screen.pixel(xx,yy+2)
      screen.level(math.floor((base2/127)*15))
      pixCol[xx][yy+2] = base2
      screen.fill(0,0,0)
      
      screen.pixel(xx,yy-1)
      screen.level(math.floor((base1/127)*15))
      pixCol[xx][yy-1] = base1
      screen.fill(0,0,0)
      
      screen.pixel(xx,yy-2)
      screen.level(math.floor((base2/127)*15))
      pixCol[xx][yy-2] = base2
      screen.fill(0,0,0)
    end
  end
  if (q == 18) then
    width = 0
    wr = math.random(1,8)
    col = math.random(0,127)
    for rad=1,140 do
      radius =  rad/2
      circ = 2 * math.pi * radius
      k = 0
      pix2 = 2 * math.pi
      width = width + 1
      if (width > wr ) then
        col = math.random(0,127)
        wr = math.random(1,8)
        width = 0
      end
      col = col - 2
      if (col < 0) then
        col = 127
      end
      while k < pix2
      do
        x0 = math.floor(63 + (radius * math.cos(k)))
        y0 = math.floor(32 + (radius * math.sin(k)))
        if (x0 > -1 and x0 < 128 and y0 > -1 and y0 < 64) then
          pixCol[x0][y0] = col
          screen.pixel(x0,y0)
          screen.level(math.abs(math.floor((pixCol[x0][y0] / 127) * 15)))
          screen.fill(0,0,0)
        end
        k = k + (math.pi * 2) / circ
      end
    end
  
  end
  if (q == 19) then
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = 0
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 20) then
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = 63
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  if (q == 21) then
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = 127
        screen.pixel(x,y)
        screen.level(math.abs(math.floor((pixCol[x][y] / 127) * 15)))
        screen.fill(0,0,0)
      end
    end
  end
  screen.update()
  _norns.screen_export_png("/home/we/dust/code/pixels/pixels.png")
  tab.save(pixCol, "/home/we/dust/code/pixels/pixel_data.txt")
  if(state==1) then
    transport(0)
    transport(1)
  end
end
