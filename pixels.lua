-- PIXELS a generative 
--           visual 
--            sequencer 
--             instrument
--
-- V1.7
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
-- HINT! 
-- when changing the direction
-- of a pixel (holding k2 and
-- turning e1) you can control 
-- a pixel while it is moving!
-- when set to about 3:00,
-- the wayfinder will become
-- a circle, indicating that 
-- pixel has stopped.
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
-- setting will allow you to 
-- manually control the root
-- note with an external MIDI
-- keyboard. k = keyed, 
-- k&m = muted until keyed.
--
-- pixels screen
--
-- take control of your 
-- travelers! Set their initial 
-- state, mute group, life state, 
-- trigger probability, midi
-- velocity and channel. only
-- need one pixel? ok ... fine 
-- but it could be lonely out 
-- there.
--
-- encoder 1 = select option
-- encoder 2 = adjust option
-- key 1 = HOLD : exit menu 
-- key 2 = enable mute group 1
-- key 3 = enable mute group 2
--         & confirm selection
--         of initial state 
--
-- HINT! 
-- going below 0 on midi velocity
-- will get you random numbers!
--
-- HINTY HINT!
-- pressing k2 or k3 while 
-- selecting anything other than
-- "initial state" will activate 
-- mute group 1 or 2 respectively.
--
-- synth I screen
--
-- make music without a 
-- midi instrument? ok. 
-- here is page one of the 
-- settings for the built-in 
-- synth engine. attack, release, 
-- amp, and pan. values
-- below 0 on atk, rel & amp
-- will generate random 
-- numbers. values of pan 
-- below -50 and above 50
-- will generate random numbers.
--
-- encoder 1 = select option
-- encoder 2 = adjust option
-- key 1 = HOLD : exit menu 
--
-- synth II screen
--
-- need even more control of
-- the built in synth params?
-- here you go! change the 
-- synth algorithm, and other
-- parameters here.
-- 
--
-- encoder 1 = select option
-- encoder 2 = adjust option
-- key 1 = HOLD : exit menu 
--
-- HINT!
-- the engine supplied with
-- pixels (The Bangs) has 8 
-- different synth types with
-- varying parameters based on 
-- their type. twiddle knobs
-- and explore sounds.
--
--        
-- midi screen
--
-- midi config settings 
-- for snd/rcv transport
-- & cc/note thru. settings
-- are saved per project.
--
--
-- encoder 1 = select option
-- encoder 2 = adjust option
--
--
-- macros screen
--
-- save 12 macros for quick
-- recall from a CC msg of
-- 127. macros store scale,
-- root, and octave settings
-- for more musical control
-- on the fly. macros are 
-- saved globally and are
-- loaded on startup
--
--
-- encoder 1 = select maacro
-- encoder 2 = change CC #
-- key 1 = save current macro
--
--
-- thanks to @zebra for 
-- the bangs engine

--local start = 0

-- Please forgive me my coding sins. I know not what I do ...

local music = require 'musicutil'

--engine
engine.name = 'Pixelbangs'
local temptempsynth = 1
local tempsynth = {1,1,1,1,1,1}
local tempsynthname = {"sq","sq1","sq2","flp","ffb","rez","kex","kln"}
local synths = {"square","square_mod1","square_mod2","sinfmlp","sinfb","reznoise","klangexp","klanglin"}
local temprel = 20
local temppw = 50
local tempamp = 50
local temppan = 50
local tempmod2 = 1
local tempattack = 0
local temphz2 = 100
local pan = {50,50,50,50,50,50}
local release = {20,20,20,20,20,20}
local pw = {50,50,50,50,50,50}
local amp = {50,50,50,50,50,50}
local mod2 = {1,1,1,1,1,1}
local attack = {0,0,0,0,0,0}
local hz2 = {60,60,60,60,60,60}

--Logic
local rc = 1
local mc = 1
local drawing = 0
local k2 = 0
local k3 = 0
local page = 1
local lastpage = 2
local menumode = 0
local menupos = 1
local lastmenupos = 1

--MIDI
local sendtrans = 1
local rectrans = 0
local notetrans = 1
local cctrans = 1
local mute = false
local midi_signals_in = {}
local midi_signals_out = {}
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

--Macros
macros = paramset.new()
macroCC = {}
macros:add_number("CC1")
macros:add_number("scale1_1")
macros:add_number("scale1_2")
macros:add_number("scale1_3")
macros:add_number("scale1_4")
macros:add_number("scale1_5")
macros:add_number("scale1_6")

macros:add_number("CC2")
macros:add_number("scale2_1")
macros:add_number("scale2_2")
macros:add_number("scale2_3")
macros:add_number("scale2_4")
macros:add_number("scale2_5")
macros:add_number("scale2_6")

macros:add_number("CC3")
macros:add_number("scale3_1")
macros:add_number("scale3_2")
macros:add_number("scale3_3")
macros:add_number("scale3_4")
macros:add_number("scale3_5")
macros:add_number("scale3_6")

macros:add_number("CC4")
macros:add_number("scale4_1")
macros:add_number("scale4_2")
macros:add_number("scale4_3")
macros:add_number("scale4_4")
macros:add_number("scale4_5")
macros:add_number("scale4_6")

macros:add_number("CC5")
macros:add_number("scale5_1")
macros:add_number("scale5_2")
macros:add_number("scale5_3")
macros:add_number("scale5_4")
macros:add_number("scale5_5")
macros:add_number("scale5_6")

macros:add_number("CC6")
macros:add_number("scale6_1")
macros:add_number("scale6_2")
macros:add_number("scale6_3")
macros:add_number("scale6_4")
macros:add_number("scale6_5")
macros:add_number("scale6_6")

macros:add_number("CC7")
macros:add_number("scale7_1")
macros:add_number("scale7_2")
macros:add_number("scale7_3")
macros:add_number("scale7_4")
macros:add_number("scale7_5")
macros:add_number("scale7_6")

macros:add_number("CC8")
macros:add_number("scale8_1")
macros:add_number("scale8_2")
macros:add_number("scale8_3")
macros:add_number("scale8_4")
macros:add_number("scale8_5")
macros:add_number("scale8_6")

macros:add_number("CC9")
macros:add_number("scale9_1")
macros:add_number("scale9_2")
macros:add_number("scale9_3")
macros:add_number("scale9_4")
macros:add_number("scale9_5")
macros:add_number("scale9_6")

macros:add_number("CC10")
macros:add_number("scale10_1")
macros:add_number("scale10_2")
macros:add_number("scale10_3")
macros:add_number("scale10_4")
macros:add_number("scale10_5")
macros:add_number("scale10_6")

macros:add_number("CC11")
macros:add_number("scale11_1")
macros:add_number("scale11_2")
macros:add_number("scale11_3")
macros:add_number("scale11_4")
macros:add_number("scale11_5")
macros:add_number("scale11_6")

macros:add_number("CC12")
macros:add_number("scale12_1")
macros:add_number("scale12_2")
macros:add_number("scale12_3")
macros:add_number("scale12_4")
macros:add_number("scale12_5")
macros:add_number("scale12_6")

macros:add_number("root1_1")
macros:add_number("root1_2")
macros:add_number("root1_3")
macros:add_number("root1_4")
macros:add_number("root1_5")
macros:add_number("root1_6")

macros:add_number("root2_1")
macros:add_number("root2_2")
macros:add_number("root2_3")
macros:add_number("root2_4")
macros:add_number("root2_5")
macros:add_number("root2_6")

macros:add_number("root3_1")
macros:add_number("root3_2")
macros:add_number("root3_3")
macros:add_number("root3_4")
macros:add_number("root3_5")
macros:add_number("root3_6")

macros:add_number("root4_1")
macros:add_number("root4_2")
macros:add_number("root4_3")
macros:add_number("root4_4")
macros:add_number("root4_5")
macros:add_number("root4_6")

macros:add_number("root5_1")
macros:add_number("root5_2")
macros:add_number("root5_3")
macros:add_number("root5_4")
macros:add_number("root5_5")
macros:add_number("root5_6")

macros:add_number("root6_1")
macros:add_number("root6_2")
macros:add_number("root6_3")
macros:add_number("root6_4")
macros:add_number("root6_5")
macros:add_number("root6_6")

macros:add_number("root7_1")
macros:add_number("root7_2")
macros:add_number("root7_3")
macros:add_number("root7_4")
macros:add_number("root7_5")
macros:add_number("root7_6")

macros:add_number("root8_1")
macros:add_number("root8_2")
macros:add_number("root8_3")
macros:add_number("root8_4")
macros:add_number("root8_5")
macros:add_number("root8_6")

macros:add_number("root9_1")
macros:add_number("root9_2")
macros:add_number("root9_3")
macros:add_number("root9_4")
macros:add_number("root9_5")
macros:add_number("root9_6")

macros:add_number("root10_1")
macros:add_number("root10_2")
macros:add_number("root10_3")
macros:add_number("root10_4")
macros:add_number("root10_5")
macros:add_number("root10_6")

macros:add_number("root11_1")
macros:add_number("root11_2")
macros:add_number("root11_3")
macros:add_number("root11_4")
macros:add_number("root11_5")
macros:add_number("root11_6")

macros:add_number("root12_1")
macros:add_number("root12_2")
macros:add_number("root12_3")
macros:add_number("root12_4")
macros:add_number("root12_5")
macros:add_number("root12_6")

macros:add_number("oct1_1")
macros:add_number("oct1_2")
macros:add_number("oct1_3")
macros:add_number("oct1_4")
macros:add_number("oct1_5")
macros:add_number("oct1_6")

macros:add_number("oct2_1")
macros:add_number("oct2_2")
macros:add_number("oct2_3")
macros:add_number("oct2_4")
macros:add_number("oct2_5")
macros:add_number("oct2_6")

macros:add_number("oct3_1")
macros:add_number("oct3_2")
macros:add_number("oct3_3")
macros:add_number("oct3_4")
macros:add_number("oct3_5")
macros:add_number("oct3_6")

macros:add_number("oct4_1")
macros:add_number("oct4_2")
macros:add_number("oct4_3")
macros:add_number("oct4_4")
macros:add_number("oct4_5")
macros:add_number("oct4_6")

macros:add_number("oct5_1")
macros:add_number("oct5_2")
macros:add_number("oct5_3")
macros:add_number("oct5_4")
macros:add_number("oct5_5")
macros:add_number("oct5_6")

macros:add_number("oct6_1")
macros:add_number("oct6_2")
macros:add_number("oct6_3")
macros:add_number("oct6_4")
macros:add_number("oct6_5")
macros:add_number("oct6_6")

macros:add_number("oct7_1")
macros:add_number("oct7_2")
macros:add_number("oct7_3")
macros:add_number("oct7_4")
macros:add_number("oct7_5")
macros:add_number("oct7_6")

macros:add_number("oct8_1")
macros:add_number("oct8_2")
macros:add_number("oct8_3")
macros:add_number("oct8_4")
macros:add_number("oct8_5")
macros:add_number("oct8_6")

macros:add_number("oct9_1")
macros:add_number("oct9_2")
macros:add_number("oct9_3")
macros:add_number("oct9_4")
macros:add_number("oct9_5")
macros:add_number("oct9_6")

macros:add_number("oct10_1")
macros:add_number("oct10_2")
macros:add_number("oct10_3")
macros:add_number("oct10_4")
macros:add_number("oct10_5")
macros:add_number("oct10_6")

macros:add_number("oct11_1")
macros:add_number("oct11_2")
macros:add_number("oct11_3")
macros:add_number("oct11_4")
macros:add_number("oct11_5")
macros:add_number("oct11_6")

macros:add_number("oct12_1")
macros:add_number("oct12_2")
macros:add_number("oct12_3")
macros:add_number("oct12_4")
macros:add_number("oct12_5")
macros:add_number("oct12_6")

--Params
local fileselect = require 'fileselect'
local textentry = require "textentry"
local selecting = false
local currentname
savea = paramset.new()
savea:add_number("mutegroup1")
savea:add_number("mutegroup2")
savea:add_number("mutegroup3")
savea:add_number("mutegroup4")
savea:add_number("mutegroup5")
savea:add_number("mutegroup6")
savea:add_number("pixelon1")
savea:add_number("pixelon2")
savea:add_number("pixelon3")
savea:add_number("pixelon4")
savea:add_number("pixelon5")
savea:add_number("pixelon6")
savea:add_number("wayfinder1")
savea:add_number("wayfinder2")
savea:add_number("wayfinder3")
savea:add_number("wayfinder4")
savea:add_number("wayfinder5")
savea:add_number("wayfinder6")
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
savea:add_number("mscale1")
savea:add_number("mscale2")
savea:add_number("mscale3")
savea:add_number("mscale4")
savea:add_number("mscale5")
savea:add_number("mscale6")
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
savea:add_number("attack1")
savea:add_number("attack2")
savea:add_number("attack3")
savea:add_number("attack4")
savea:add_number("attack5")
savea:add_number("attack6")
savea:add_number("mod21")
savea:add_number("mod22")
savea:add_number("mod23")
savea:add_number("mod24")
savea:add_number("mod25")
savea:add_number("mod26")
savea:add_number("hz21")
savea:add_number("hz22")
savea:add_number("hz23")
savea:add_number("hz24")
savea:add_number("hz25")
savea:add_number("hz26")
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
savea:add_number("tempsynth1")
savea:add_number("tempsynth2")
savea:add_number("tempsynth3")
savea:add_number("tempsynth4")
savea:add_number("tempsynth5")
savea:add_number("tempsynth6")
savea:add_number("sendtrans")
savea:add_number("rectrans")
--Display
screen.aa(1)
local scalefade = 0
local drawnewmap = 0
local linetime = 0
local linex = 63
local liney = 31
local linecol = 15
local angle  = 0
local wordblast = 0
local word = "nothing"
local wordcol1 = 0
local wordcol2 = 2
local wordcol3 = 15
local piccount = 0
local colora = 0


--Notes
local scalenames = {"Ma","Nmi","Hmi","Mmi","Dor","Phr","Lyd","Mix","Loc","WT","MaP","miP","MaB","Alt","DoB","MxB","BlS","DWH","DHW","NeM","HuM","HaM","Hum","Lym","Nem","LoM","LWT","6TS","Bal","Per","EIP","Ori","DHa","Eni","Ovr","8TS","Pro","Gag","InS","Oki","Chr"}
local high = 128
local low = {48,48,48,48,48,48}
local lowmain = 48
local octaves = {3,3,3,3,3,3}
local octavesmain = 3
local mscale = {1,1,1,1,1,1}
local mscaletemp = 1
local drawcolor = {0,0,0,0,0,0}
local scale1 = {}
local scale2 = {}
local scale3 = {}
local scale4 = {}
local scale5 = {}
local scale6 = {}

--Pixels
local mutegroup = {0,0,0,0,0,0}
local mutegrouptemp = 0
local pixelon = {1,1,1,1,1,1}
local wayfinder =  {0,0,0,0,0,0}
local iwayfinder = {-1,-1,-1,-1,-1,-1,  37,45,52,22,15,7 ,  45,30,0 ,-1,-1,15,   0, 0, 0,30,  30, 30,  7,22 ,52, 37,0 ,30 ,   0, 0 , 0, 0,  0,  0,  -1,-1,-1,-1,-1,-1,   -1, -1,  -1, -1, -1, -1,   15, 15, 15, 15, 15,  15}
local ipixX =      { 0, 0, 0, 0, 0, 0,  63,64,65,63,64,65,  64,48,80,63,65,64,  10,10,10,118,118,118,  0,127,0 ,127, 0,127,   2, 25,50,75,100,125,  63,63,63,63,63,63,  11, 32 , 53, 74, 95, 116,  15, 29, 56, 70, 97, 115}
local ipixY =      { 0, 0, 0, 0, 0, 0,  31,31,31,32,32,32,  16,32,32,32,32,48,  10,30,50,14 , 34,54 ,  0,0  ,63, 63,32,32 ,   2, 12,24,36,48 , 60,   9,18,27,36,45,54,  32, 32 , 32, 32, 32, 32,   0 ,  0,  0,  0,  0,   0}
local ipixDX =     { 0, 0, 0, 0, 0, 0,  -1, 0, 1,-1, 0, 1,  0 ,-1, 1,0 ,0 ,0 ,   1, 1, 1,-1 ,-1 ,-1 ,  1,-1 ,1 , -1, 1,-1 ,   1, 1 , 1, 1, 1 ,  1,   0, 0, 0, 0, 0, 0,   0,  0,   0,  0,  0,  0,   0 ,  0,  0,  0,  0,   0}
local ipixDY =     { 0, 0, 0, 0, 0, 0,  -1,-1,-1, 1, 1, 1,  -1, 0, 0,0 ,0, 1 ,  0, 0,  0,0 , 0 , 0,    1,  1,-1, -1, 0, 0 ,   0, 0 , 0, 0, 0 ,  0,   0, 0, 0, 0, 0, 0,   0,  0,   0,  0,  0,  0,   1 ,  1,  1,  1,  1,   1}
local istepdiv=    { 1, 1, 1, 1, 1, 1,   8, 9, 10,10,9, 8,  8 ,10,11, 6,10, 9,  12, 7,10, 12,  7,10,   9, 9 ,11, 11,10, 7 ,   11,11,11,12,12 , 10,   7, 8, 9,10,11,12,   9,  9,   9,  9,  9,  9,   13, 11, 12, 8 , 12,  14}
local numpixsel = 6
local thispix = 1
local trigprob = {100,100,100,100,100,100}
local trigprobmain = 100
local pixX = {0,10,20,30,40,50}
local pixY = {0,10,20,30,40,50}
local direction = {0,0,0,0,0,0}
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
local styles = {"columns", "t.v.", "stripes", "sinefield", "strands","air duct","flannel","hubba","weave","grass","unknown","interlaced","sliced","orb","shore","afterimage","stargazing","eye","dark","gray","light"}
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
  menuwatcher()
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
  
  for i = 1,#midi.vports do -- query all ports
  midi_signals_in[i] = midi.connect(i) -- connect each device
  midi_signals_in[i].event = miditrans
  midi_signals_out[i]= midi.connect(i)
  end
end
function textenter(name)
  currentname = name
  if (currentname ~= nil) then 
    saveit()
  end
end

function saveit()
  tab.save(pixCol,"/home/we/dust/code/pixels/data/" .. currentname .. ".txt")
  savea:set("mutegroup1",mutegroup[1])
  savea:set("mutegroup2",mutegroup[2])
  savea:set("mutegroup3",mutegroup[3])
  savea:set("mutegroup4",mutegroup[4])
  savea:set("mutegroup5",mutegroup[5])
  savea:set("mutegroup6",mutegroup[6])
  savea:set("pixelon1",pixelon[1])
  savea:set("pixelon2",pixelon[2])
  savea:set("pixelon3",pixelon[3])
  savea:set("pixelon4",pixelon[4])
  savea:set("pixelon5",pixelon[5])
  savea:set("pixelon6",pixelon[6])
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
  savea:set("mscale1",mscale[1])
  savea:set("mscale2",mscale[2])
  savea:set("mscale3",mscale[3])
  savea:set("mscale4",mscale[4])
  savea:set("mscale5",mscale[5])
  savea:set("mscale6",mscale[6])
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
  savea:set("attack1",attack[1])
  savea:set("attack2",attack[2])
  savea:set("attack3",attack[3])
  savea:set("attack4",attack[4])
  savea:set("attack5",attack[5])
  savea:set("attack6",attack[6])
  savea:set("pw1",pw[1])
  savea:set("pw2",pw[2])
  savea:set("pw3",pw[3])
  savea:set("pw4",pw[4])
  savea:set("pw5",pw[5])
  savea:set("pw6",pw[6])
  savea:set("mod21",mod2[1])
  savea:set("mod22",mod2[2])
  savea:set("mod23",mod2[3])
  savea:set("mod24",mod2[4])
  savea:set("mod25",mod2[5])
  savea:set("mod26",mod2[6])
  savea:set("hz21",hz2[1])
  savea:set("hz22",hz2[2])
  savea:set("hz23",hz2[3])
  savea:set("hz24",hz2[4])
  savea:set("hz25",hz2[5])
  savea:set("hz26",hz2[6])
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
  savea:set("tempsynth1",tempsynth[1])
  savea:set("tempsynth2",tempsynth[2])
  savea:set("tempsynth3",tempsynth[3])
  savea:set("tempsynth4",tempsynth[4])
  savea:set("tempsynth5",tempsynth[5])
  savea:set("tempsynth6",tempsynth[6])
  savea:set("wayfinder1",wayfinder[1])
  savea:set("wayfinder2",wayfinder[2])
  savea:set("wayfinder3",wayfinder[3])
  savea:set("wayfinder4",wayfinder[4])
  savea:set("wayfinder5",wayfinder[5])
  savea:set("wayfinder6",wayfinder[6])
  savea:set("sendtrans",sendtrans)
  savea:set("rectrans",rectrans)
  savea:write("/home/we/dust/code/pixels/pset/" .. currentname ..".pset")
end

function load_file(file)
  selecting = false
  if file ~= "cancel" then
    s = string.sub(file,32,string.len(file)-5)
    currentname = s
    f=io.open("/home/we/dust/code/pixels/data/"..s..".txt","r")
          if (f~=nil) then 
            pixCol = tab.load("/home/we/dust/code/pixels/data/"..s..".txt")
            savea:read(file)
            styleselect = savea:get("styleselect")
            tempo = savea:get("tempo")
            sendtrans = savea:get("sendtrans")
            rectrans = savea:get("rectrans")
            for a=1,6 do
              mutegroup[a] = savea:get("mutegroup"..a)
              pixelon[a] = savea:get("pixelon"..a)
              mscale[a] = savea:get("mscale"..a)
              tempsynth[a] = savea:get("tempsynth"..a)
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
              attack[a] = savea:get("attack"..a)
              pw[a] = savea:get("pw"..a)
              mod2[a] = savea:get("mod2"..a)
              hz2[a] = savea:get("hz2"..a)
              amp[a] = savea:get("amp"..a)
              pan[a] = savea:get("pan"..a)
              wayfinder[a] = savea:get("wayfinder"..a)
            end
            scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
            scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
            scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
            scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
            scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
            scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
            savea:bang()
            drawnewmap = 1
            syncbeat()
          end
  end
end


--let's start a function that look at incoming MIDI msgs
function miditrans(data)
    local d = midi.to_msg(data)
    if(d.type == "note_off") then
      mute = true
      if(notetrans == 1) then
        for i=1,16 do
          midi_signals_out[i]:note_off(d.note,nil,d.ch)
        end
      end
    end
    if(d.type == "cc") then
      if(cctrans == 1) then
        for i=1,16 do
          midi_signals_out[i]:cc(d.cc,d.val,d.ch)
        end
      end
      for i = 1, 12 do
        if(d.cc == macroCC[i]) then
          f=io.open("/home/we/dust/code/pixels/macros.txt","r")
          if (f ~= nil) then
            macros:read("/home/we/dust/code/pixels/macros.pset")
            for a=1,6 do
              octaves[a] = macros:get("oct"..i.."_"..a)
              mscale[a] = macros:get("scale"..i.."_"..a)
              low[a] = macros:get("root"..i.."_"..a)
            end
            scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
            scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
            scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
            scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
            scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
            scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
          end
        end
      end
    end
    if(d.type == "note_on") then
      if(notetrans == 1) then
        for i=1,16 do
          midi_signals_out[i]:note_on(d.note,d.vel,d.ch)
        end
      end
      mute = false
      if(key1 > 0) then
        low[1] = d.note
        scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
      end
      if(key2 > 0) then
        low[2] = d.note
        scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
      end
      if(key3 > 0) then
        low[3] = d.note
        scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
      end
      if(key4 > 0) then
        low[4] = d.note
        scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
      end
      if(key5 > 0) then
        low[5] = d.note
        scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
      end
      if(key6 > 0) then
        low[6] = d.note
        scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
      end
    end
    if ((d.type == "start" or d.type == "continue") and rectrans == 1) then
      state = 1 
      transport(1)
    end
    if (d.type == "stop" and rectrans == 1)then
      state = 0
      transport(0)
    end
end


--let's init!
function init()
  connect()
  for x=0,128 do
    pixCol[x] = {}  
    for y=0,64 do
      pixCol[x][y] = 0
    end
  end
  f=io.open("/home/we/dust/code/pixels/macros.txt","r")
  if (f ~= nil) then
  macros:read("/home/we/dust/code/pixels/macros.pset")
    for a=1,12 do
      macroCC[a] = macros:get("CC"..a)
    end

  else
    b = 1
    for i = 1,12 do
      macros:set("CC"..i,i+19)
      macroCC[i] = i+19
      for a=1,6 do
        macros:set("scale"..i.."_"..a,b)
        macros:set("root"..i.."_"..a,low[a])
        macros:set("oct"..i.."_"..a,octaves[a])
      end  
      b = b+1
    end
    macros:write("/home/we/dust/code/pixels/macros.pset")
    tab.save(macros,"/home/we/dust/code/pixels/macros.txt")
  end
  tempscale = math.random(1,6)
  tempoct= math.random(1,3)
  templow = math.random(24,48)
  for i=1,6 do
    tempsynth[i] = math.random(1,4)
    mscale[i]= tempscale
    octaves[i] = tempoct
    low[i] = templow
    temp = math.random(0,100)
    trigprob[i] = temp
  end
  scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
  scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
  scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
  scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
  scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
  scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
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
    for mm=1,16 do
      if(sendtrans == 1) then
        midi_signals_out[mm]:stop()
      end    
    end
      
      
    for a=1,#notes1 do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes1[a],nil,midiCH[1])
      end
    end  
    for a=1,#notes1 do
      table.remove(notes1,1)
    end
    for a=1,#notes2 do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes2[a],nil,midiCH[2])
      end
    end
    for a=1,#notes2 do
      table.remove(notes2,1)
    end
    for a=1,#notes3 do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes3[a],nil,midiCH[3])
      end
    end
    for a=1,#notes3 do
      table.remove(notes3,1)
    end
    for a=1,#notes4 do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes4[a],nil,midiCH[4])
      end
    end
    for a=1,#notes4 do
      table.remove(notes4,1)
    end
    for a=1,#notes5 do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes5[a],nil,midiCH[5])
      end
    end
    for a=1,#notes5 do
      table.remove(notes5,1)
    end
    for a=1,#notes6 do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes6[a],nil,midiCH[6])
      end
    end
    for a=1,#notes6 do
      table.remove(notes6,1)
    end
  end
  if (state == 1) then
    startbeat()
    for mm=1,16 do
      if(sendtrans == 1) then
        midi_signals_out[mm]:start()
      end
    end
    for a = 1,6 do
      if(pixelon[a] == 1) then
        play(pixCol[math.floor(pixX[a])][math.floor(pixY[a])],a)
      end
    end
  end
end

--let's have a function for moving pixels around the screen
function move(who)
  if(pixelon[who] == 1) then 
    pulse[who] = 15
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
        play(  pixCol[  math.floor(pixX[who])  ]  [  math.floor(pixY[who])  ],  who)
      end
      if (drawing == 1) then
        play(drawcolor[who],who)
      end
    end
  end
end

function menuwatcher()

  if(drawing == 1 and drawnewmap ~= 1) then
    mc = mc + 1
    if (mc > 10) then
      mc = 0
    end
  end
  if (mc ~= rc and drawing == 1 and drawnewmap ~= 1) then
    mc = 0
    rc = -1
    drawnewmap = 1
  end
end

function string_to_table(s)
  return table.pack(string.byte(s, 0, string.len(s)))
end

function table_to_string(t)
  return string.char(table.unpack(t))
end


--oh god ... this redraw function is outta control ... but somehow still works
function redraw()
  if(selecting == false) then
  if(drawing == 0) then
    screen.clear()
  end
  if (page == 1) then
    rc = rc + 1
    if(rc > 10) then
      rc = 0
    end
    if(drawing == 0 and drawnewmap == 0) then
      screen.poke(0, 0, 128, 64, table_to_string(tab.load("home/we/dust/code/pixels/pixels.data")))
    end
    if(drawnewmap == 1) then
      for y=0,64 do
        for x=0,128 do
          screen.pixel(x,y)
          screen.level(util.clamp(math.abs(math.floor((pixCol[x][y] / 127) * 15)),0,15))
          screen.fill(0,0,0)
        end
      end
      tab.save(string_to_table(screen.peek(0, 0, 128, 64)), "home/we/dust/code/pixels/pixels.data")
      drawnewmap = 0
    end
    if(drawing == 1) then
      screen.pixel(pixX[1],pixY[1])
      pixCol[math.floor(pixX[1])][math.floor(pixY[1])] = drawcolor[1]
      screen.level(util.clamp(math.floor((pixCol[math.floor(pixX[1])][math.floor(pixY[1])] / 127) * 15),0,15))
      screen.fill(0,0,0)
    end
    if(drawing == 0 and linetime > 0 and (pixDX[thispix] ~= 0 or pixDY[thispix]~=0)) then
      screen.level(util.clamp(linetime,0,15))
      linetime = linetime - 1
      screen.line_width(1)
      screen.move(pixX[thispix],pixY[thispix])
      screen.line(pixX[thispix]+linex,pixY[thispix]+liney)
      screen.close()
      screen.stroke()
    end
    if(drawing == 0 and linetime > 0 and (pixDX[thispix] == 0 and pixDY[thispix] == 0)) then
        screen.line_width(1)
        screen.level(util.clamp(linetime,0,15))
        linetime = linetime - 2
        screen.circle(pixX[thispix],pixY[thispix],linetime/2)
        screen.close()
        screen.stroke()
    end
    for j=1,6 do
      
      if (size[j] > 1 and drawing == 0) then
        screen.rect(pixX[j] - math.floor(size[j]/2)-1,pixY[j]-math.floor(size[j] /2)-1,size[j]+2,size[j]+2)
        screen.level(util.clamp(size[j],0,15))
        screen.fill(0,0,0)
        screen.rect(pixX[j] - math.floor(size[j]/2),pixY[j]-math.floor(size[j] /2),size[j],size[j])
        screen.level(util.clamp(math.floor((pixCol[math.floor(pixX[j])][math.floor(pixY[j])] / 127) * 15),0,15))
        size[j] = size[j] - 1
        screen.fill(0,0,0)
      end
      if(pixelon[j] == 1) then
        if (size[j] == 1 and drawing == 0) then
          screen.pixel(math.floor(pixX[j]),math.floor(pixY[j]))
          screen.level(util.clamp(math.floor(pulse[j]),0,15))
          screen.fill(0,0,0)
        end
        if(drawing == 0) then
          pulseinc[j] = (16/12) / (60/tempo) /  stepdivamount[stepdiv[j]] 
          pulse[j] = pulse[j] - pulseinc[j]
          if (pulse[j] < 0) then
            pulse[j] = 15
          end
        end
      end
    end
    if(wordblast > 0 and drawing == 0) then
      isiton = ""
      if(pixelon[thispix] == 0) then
        isiton = " off"
      end
      screen.level(util.clamp(wordblast,0,15))
      screen.font_face(1)
      screen.font_size(math.floor((wordblast/2)+12))
      screen.move(wordblast + 36,32)
      screen.text(word..isiton)
      wordblast = wordblast - 1
    end
  end
  if (page == 2) then
    if(scalefade > 0) then
      scalefade = scalefade - 1
    end
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
    screen.text("scale")
    if (scalefade == 0) then
      screen.move(37,20)
      screen.text((scalenames[mscale[1]]))
      screen.move(52,20)
      screen.text((scalenames[mscale[2]]))
      screen.move(67,20)
      screen.text((scalenames[mscale[3]]))
      screen.move(82,20)
      screen.text((scalenames[mscale[4]]))
      screen.move(97,20)
      screen.text((scalenames[mscale[5]]))
      screen.move(112,20)
      screen.text((scalenames[mscale[6]]))
      else
        if ((menupos - 1) < 7) then
          screen.move(30,20)
          screen.text((menupos-1).." "..string.lower(music.SCALES[mscale[menupos-1]].name))
        end
        if (menupos == 8) then
          screen.move(30,20)
          screen.text("A "..string.lower(music.SCALES[mscaletemp].name))
        end
    end
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
    screen.text("load")
    screen.move(45,50)
    screen.text("save as")
    screen.move(95,50)
    if(currentname ~= nil) then
      screen.text("save")
    end
    if(menupos == 1) then
      screen.level(15)
      screen.move(6,11)
      screen.text("style " .. string.lower(styles[styleselecttemp]))
    end
    if(scalefade == 0) then
      if(menupos > 1 and menupos < 9) then
        screen.level(15)
        screen.move(6,21)
        screen.text("scale")
      end
      if(menupos == 2 or menupos == 8) then
        screen.move(38,21)
        screen.text(scalenames[mscale[1]])
      end
      if(menupos == 3 or menupos == 8) then
        screen.move(53,21)
        screen.text(scalenames[mscale[2]])
      end
      if(menupos == 4 or menupos == 8) then
        screen.move(68,21)
        screen.text(scalenames[mscale[3]])
      end
      if(menupos == 5 or menupos == 8) then
        screen.move(83,21)
        screen.text(scalenames[mscale[4]])
      end
      if(menupos == 6 or menupos == 8) then
        screen.move(98,21)
        screen.text(scalenames[mscale[5]])
      end
      if(menupos == 7 or menupos == 8) then
        screen.move(113,21)
        screen.text(scalenames[mscale[6]])
      end
      else
        screen.level(15)
        screen.move(6,21)
        screen.text("scale")
        screen.level(util.clamp(1,15,scalefade))
        if ((menupos - 1) < 7) then
          screen.move(31,21)
          screen.text((menupos-1).." "..string.lower(music.SCALES[mscale[menupos-1]].name))
        end
        if (menupos == 8) then
          screen.move(31,21)
          screen.text("A "..string.lower(music.SCALES[mscaletemp].name))
        end
    end
    if(menupos > 8 and menupos < 16) then
      screen.level(15)
      screen.move(6,31)
      screen.text("root")
    end
    if(menupos == 9 or menupos == 15) then
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
    if(menupos == 10 or menupos == 15) then
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
    if(menupos == 11 or menupos == 15) then
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
    if(menupos == 12 or menupos == 15) then
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
    if(menupos == 13 or menupos == 15) then
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
    if(menupos == 14 or menupos == 15) then
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
    if(menupos > 15 and menupos < 23) then
      screen.level(15)
      screen.move(6,41)
      screen.text("oct ")
    end
    if(menupos == 16 or menupos == 22) then
      screen.level(15)
      screen.move(38,41)
      screen.text(octaves[1])
    end
    if(menupos == 17 or menupos == 22) then
      screen.level(15)
      screen.move(53,41)
      screen.text(octaves[2])
    end
    if(menupos == 18 or menupos == 22) then
      screen.level(15)
      screen.move(68,41)
      screen.text(octaves[3])
    end
    if(menupos == 19 or menupos == 22) then
      screen.level(15)
      screen.move(83,41)
      screen.text(octaves[4])
    end
    if(menupos == 20 or menupos == 22) then
      screen.level(15)
      screen.move(98,41)
      screen.text(octaves[5])
    end
    if(menupos == 21 or menupos == 22) then
      screen.level(15)
      screen.move(113,41)
      screen.text(octaves[6])
    end
    if(menupos == 23) then
      screen.level(15)
      screen.move(6,51)
      screen.text("load")
    end
    if(menupos == 24) then
      screen.level(15)
      screen.move(46,51)
      screen.text("save as")
    end
    if(menupos == 25 and currentname ~= nil) then
      screen.level(15)
      screen.move(96,51)
      screen.text("save")
    end
  end
  if (page == 3) then
    screen.level(math.floor(wordcol1))
    screen.font_face(1)
    screen.font_size(8)
    screen.move(103,8)
    screen.text("pixels")
    screen.level(math.floor(wordcol2))
    screen.move(104,9)
    screen.text("pixels")
    screen.level(math.floor(wordcol3))
    screen.move(105,10)
    screen.text("pixels")
    screen.level(3)
    screen.move(2,10)
    screen.text("initial state " .. initialword[initialtemp])
    screen.move(2,20)
    screen.text("group")
    screen.move(37,20)
    screen.text(mutegroup[1])
    screen.move(52,20)
    screen.text(mutegroup[2])
    screen.move(67,20)
    screen.text(mutegroup[3])
    screen.move(83,20)
    screen.text(mutegroup[4])
    screen.move(97,20)
    screen.text(mutegroup[5])
    screen.move(112,20)
    screen.text(mutegroup[6])
    screen.move(2,30)
    screen.text("alive")
    screen.move(37,30)
    if(pixelon[1] == 0) then
      screen.text("X")
      else
        screen.text("O")
    end
    screen.move(52,30)
    if(pixelon[2] == 0) then
      screen.text("X")
      else
        screen.text("O")
    end
    screen.move(67,30)
    if(pixelon[3] == 0) then
      screen.text("X")
      else
        screen.text("O")
    end
    screen.move(83,30)
    if(pixelon[4] == 0) then
      screen.text("X")
      else
        screen.text("O")
    end
    screen.move(97,30)
    if(pixelon[5] == 0) then
      screen.text("X")
      else
        screen.text("O")
    end   
    screen.move(112,30)
    if(pixelon[6] == 0) then
      screen.text("X")
      else
        screen.text("O")
    end  
    
    screen.move(2,40)
    screen.text("trig %")
    screen.move(37,40)
    screen.text(trigprob[1])
    screen.move(52,40)
    screen.text(trigprob[2])
    screen.move(67,40)
    screen.text(trigprob[3])
    screen.move(83,40)
    screen.text(trigprob[4])
    screen.move(97,40)
    screen.text(trigprob[5])
    screen.move(112,40)
    screen.text(trigprob[6])
    screen.move(2,50)
    screen.text("midi vel")
    screen.move(37,50)
    midiVELtext = midiVEL[1]
    if (midiVEL[1] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(52,50)
    midiVELtext = midiVEL[2]
    if (midiVEL[2] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(67,50)
    midiVELtext = midiVEL[3]
    if (midiVEL[3] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(83,50)
    midiVELtext = midiVEL[4]
    if (midiVEL[4] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(97,50)
    midiVELtext = midiVEL[5]
    if (midiVEL[5] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(112,50)
    midiVELtext = midiVEL[6]
    if (midiVEL[6] == -1) then
      midiVELtext = "rnd"
    end
    screen.text(midiVELtext)
    screen.move(2,60)
    screen.text("midi ch")
    screen.move(37,60)
    screen.text(midiCH[1])
    screen.move(52,60)
    screen.text(midiCH[2])
    screen.move(67,60)
    screen.text(midiCH[3])
    screen.move(83,60)
    screen.text(midiCH[4])
    screen.move(97,60)
    screen.text(midiCH[5])
    screen.move(112,60)
    screen.text(midiCH[6])
    if (menupos > 1 and menupos < 9) then
      screen.level(15)
      screen.move(3,21)
      screen.text("group")
    end
    
    if(menupos == 1) then
      screen.level(15)
      screen.move(3,11)
      screen.text("initial state " .. initialword[initialtemp])
    end
    if(menupos == 2 or menupos == 8) then
      screen.level(15)
      screen.move(38,21)
      screen.text(mutegroup[1])
    end
    if(menupos == 3 or menupos == 8) then
      screen.level(15)
      screen.move(53,21)
      screen.text(mutegroup[2])
    end
    if(menupos == 4 or menupos == 8) then
      screen.level(15)
      screen.move(68,21)
      screen.text(mutegroup[3])
    end
    if(menupos == 5 or menupos == 8) then
      screen.level(15)
      screen.move(83,21)
      screen.text(mutegroup[4])
    end
    if(menupos == 6 or menupos == 8) then
      screen.level(15)
      screen.move(98,21)
      screen.text(mutegroup[5])
    end
    if(menupos == 7 or menupos == 8) then
      screen.level(15)
      screen.move(113,21)
      screen.text(mutegroup[6])
    end
    if(menupos > 8 and menupos < 16) then
      screen.level(15)
      screen.move(3,31)
      screen.text("alive")
    end
    if(menupos == 9 or menupos == 15) then
      screen.level(15)
      screen.move(38,31)
      if(pixelon[1] == 0) then
        screen.text("X")
        else
          screen.text("O")
        end
    end
    if(menupos == 10 or menupos == 15) then
      screen.level(15)
      screen.move(53,31)
      if(pixelon[2] == 0) then
        screen.text("X")
        else
          screen.text("O")
        end
    end
    if(menupos == 11 or menupos == 15) then
      screen.level(15)
      screen.move(68,31)
      if(pixelon[3] == 0) then
        screen.text("X")
        else
          screen.text("O")
        end
    end
    
    if(menupos == 12 or menupos == 15) then
      screen.level(15)
      screen.move(83,31)
      if(pixelon[4] == 0) then
        screen.text("X")
        else
          screen.text("O")
        end
    end
    
    if(menupos == 13 or menupos == 15) then
      screen.level(15)
      screen.move(98,31)
      if(pixelon[5] == 0) then
        screen.text("X")
        else
          screen.text("O")
        end
    end
    
    if(menupos == 14 or menupos == 15) then
      screen.level(15)
      screen.move(113,31)
      if(pixelon[6] == 0) then
        screen.text("X")
        else
          screen.text("O")
        end
    end
    if(menupos > 15 and menupos < 23) then
      screen.level(15)
      screen.move(3,41)
      screen.text("trig %")
    end
    if(menupos == 16 or menupos == 22) then
      screen.level(15)
      screen.move(38,41)
      screen.text(trigprob[1])
    end
    if(menupos == 17 or menupos == 22) then
      screen.level(15)
      screen.move(53,41)
      screen.text(trigprob[2])
    end
    if(menupos == 18 or menupos == 22) then
      screen.level(15)
      screen.move(68,41)
      screen.text(trigprob[3])
    end
    if(menupos == 19 or menupos == 22) then
      screen.level(15)
      screen.move(83,41)
      screen.text(trigprob[4])
    end
    if(menupos == 20 or menupos == 22) then
      screen.level(15)
      screen.move(98,41)
      screen.text(trigprob[5])
    end
    if(menupos == 21 or menupos == 22) then
      screen.level(15)
      screen.move(113,41)
      screen.text(trigprob[6])
    end
    if(menupos > 22 and menupos < 30) then
      screen.level(15)
      screen.move(3,51)
      screen.text("midi vel")
    end
    if(menupos == 23 or menupos == 29) then
      screen.level(15)
      screen.move(38,51)
      midiVELtext = midiVEL[1]
      if (midiVEL[1] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 24 or menupos == 29) then
      screen.level(15)
      screen.move(53,51)
      midiVELtext = midiVEL[2]
      if (midiVEL[2] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 25 or menupos == 29) then
      screen.level(15)
      screen.move(68,51)
      midiVELtext = midiVEL[3]
      if (midiVEL[3] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 26 or menupos == 29) then
      screen.level(15)
      screen.move(83,51)
      midiVELtext = midiVEL[4]
      if (midiVEL[4] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 27 or menupos == 29) then
      screen.level(15)
      screen.move(98,51)
      midiVELtext = midiVEL[5]
      if (midiVEL[5] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos == 28 or menupos == 29) then
      screen.level(15)
      screen.move(113,51)
      midiVELtext = midiVEL[6]
      if (midiVEL[6] == -1) then
        midiVELtext = "rnd"
      end
      screen.text(midiVELtext)
    end
    if(menupos > 29 and menupos < 37) then
      screen.level(15)
      screen.move(3,61)
      screen.text("midi ch")
    end
    if(menupos == 30 or menupos == 36) then
      screen.level(15)
      screen.move(38,61)
      screen.text(midiCH[1])
    end
    if(menupos == 31 or menupos == 36) then
      screen.level(15)
      screen.move(53,61)
      screen.text(midiCH[2])
    end
    if(menupos == 32 or menupos == 36) then
      screen.level(15)
      screen.move(68,61)
      screen.text(midiCH[3])
    end
    if(menupos == 33 or menupos == 36) then
      screen.level(15)
      screen.move(83,61)
      screen.text(midiCH[4])
    end
    if(menupos == 34 or menupos == 36) then
      screen.level(15)
      screen.move(98,61)
      screen.text(midiCH[5])
    end
    if(menupos == 35 or menupos == 36) then
      screen.level(15)
      screen.move(113,61)
      screen.text(midiCH[6])
    end
  end
  if (page == 4) then
    screen.level(math.floor(wordcol1))
    screen.font_face(1)
    screen.font_size(8)
    screen.move(89,8)
    screen.text("synth I")
    screen.level(math.floor(wordcol2))
    screen.move(90,9)
    screen.text("synth I")
    screen.level(math.floor(wordcol3))
    screen.move(91,10)
    screen.text("synth I")
    screen.level(3)
    screen.move(5,20)
    screen.text("atk ")
    screen.move(37,20)
    if (attack[1] < 0) then
      screen.text("rnd")
      else
      screen.text(attack[1])
    end
    screen.move(52,20)
    if (attack[2] < 0) then
      screen.text("rnd")
      else
      screen.text(attack[2])
    end
    screen.move(67,20)
    if (attack[3] < 0) then
      screen.text("rnd")
      else
      screen.text(attack[3])
    end
    screen.move(82,20)
    if (attack[4] < 0) then
      screen.text("rnd")
      else
      screen.text(attack[4])
    end
    screen.move(97,20)
    if (attack[5] < 0) then
      screen.text("rnd")
      else
      screen.text(attack[5])
    end
    screen.move(112,20)
    if (attack[6] < 0) then
      screen.text("rnd")
      else
      screen.text(attack[6])
    end
    screen.move(5,30)
    screen.text("rel")
    screen.move(37,30)
    if (release[1] < 0) then
      screen.text("rnd")
      else
      screen.text(release[1])
    end
    screen.move(52,30)
    if (release[2] < 0) then
      screen.text("rnd")
      else
      screen.text(release[2])
    end
    screen.move(67,30)
    if (release[3] < 0) then
      screen.text("rnd")
      else
      screen.text(release[3])
    end
    screen.move(82,30)
    if (release[4] < 0) then
      screen.text("rnd")
      else
      screen.text(release[4])
    end
    screen.move(97,30)
    if (release[5] < 0) then
      screen.text("rnd")
      else
      screen.text(release[5])
    end
    screen.move(112,30)
    if (release[6] < 0) then
      screen.text("rnd")
      else
      screen.text(release[6])
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
      screen.text("atk ")
    end
    if(menupos == 1 or menupos == 7) then
      screen.level(15)
      screen.move(38,21)
      if (attack[1] < 0) then
        screen.text("rnd")
        else
        screen.text(attack[1])
      end
    end
    if(menupos == 2 or menupos == 7) then
      screen.level(15)
      screen.move(53,21)
      if (attack[2] < 0) then
        screen.text("rnd")
        else
        screen.text(attack[2])
      end
    end
    
    if(menupos == 3 or menupos == 7) then
      screen.level(15)
      screen.move(68,21)
      if (attack[3] < 0) then
        screen.text("rnd")
        else
        screen.text(attack[3])
      end
    end
    if(menupos == 4 or menupos == 7) then
      screen.level(15)
      screen.move(83,21)
      if (attack[4] < 0) then
        screen.text("rnd")
        else
        screen.text(attack[4])
      end
    end
    if(menupos == 5 or menupos == 7) then
      screen.level(15)
      screen.move(98,21)
      if (attack[5] < 0) then
        screen.text("rnd")
        else
        screen.text(attack[5])
      end
    end
    if(menupos == 6 or menupos == 7) then
      screen.level(15)
      screen.move(113,21)
      if (attack[6] < 0) then
        screen.text("rnd")
        else
        screen.text(attack[6])
      end
    end
    
    if(menupos >= 8 and menupos < 15) then
      screen.level(15)
      screen.move(6,31)
      screen.text("rel ")
    end
    if(menupos == 8 or menupos == 14) then
      screen.level(15)
      screen.move(38,31)
      if (release[1] < 0) then
        screen.text("rnd")
        else
        screen.text(release[1])
      end
    end
    if(menupos == 9 or menupos == 14) then
      screen.level(15)
      screen.move(53,31)
      if (release[2] < 0) then
        screen.text("rnd")
        else
        screen.text(release[2])
      end
    end
    
    if(menupos == 10 or menupos == 14) then
      screen.level(15)
      screen.move(68,31)
      if (release[3] < 0) then
        screen.text("rnd")
        else
        screen.text(release[3])
      end
    end
    if(menupos == 11 or menupos == 14) then
      screen.level(15)
      screen.move(83,31)
      if (release[4] < 0) then
        screen.text("rnd")
        else
        screen.text(release[4])
      end
    end
    if(menupos == 12 or menupos == 14) then
      screen.level(15)
      screen.move(98,31)
      if (release[5] < 0) then
        screen.text("rnd")
        else
        screen.text(release[5])
      end
    end
    if(menupos == 13 or menupos == 14) then
      screen.level(15)
      screen.move(113,31)
      if (release[6] < 0) then
        screen.text("rnd")
        else
        screen.text(release[6])
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
  if (page == 5) then
    screen.level(math.floor(wordcol1))
    screen.font_size(8)
    screen.move(89,8)
    screen.text("synth II")
    screen.level(math.floor(wordcol2))
    screen.move(90,9)
    screen.text("synth II")
    screen.level(math.floor(wordcol3))
    screen.move(91,10)
    screen.text("synth II")
    screen.level(3)
    screen.move(5,20)
    screen.text("algo")
    screen.move(26,20)
    screen.move(5,20)
    
    screen.move(37,20)
    screen.text(tempsynthname[tempsynth[1]])
    screen.move(52,20)
    screen.text(tempsynthname[tempsynth[2]])
    screen.move(67,20)
    screen.text(tempsynthname[tempsynth[3]])  
    screen.move(82,20)
    screen.text(tempsynthname[tempsynth[4]])
    screen.move(97,20)
    screen.text(tempsynthname[tempsynth[5]])
    screen.move(112,20)
    screen.text(tempsynthname[tempsynth[6]])
    screen.move(5,30)
    screen.text("pw/m1")
    screen.move(37,30)
    if (pw[1] < 0) then
      screen.text("rnd")
      else
      screen.text(pw[1])
    end
    screen.move(52,30)
    if (pw[2] < 0) then
      screen.text("rnd")
      else
      screen.text(pw[2])
    end
    screen.move(67,30)
    if (pw[3] < 0) then
      screen.text("rnd")
      else
      screen.text(pw[3])
    end
    screen.move(82,30)
    if (pw[4] < 0) then
      screen.text("rnd")
      else
      screen.text(pw[4])
    end
    screen.move(97,30)
    if (pw[5] < 0) then
      screen.text("rnd")
      else
      screen.text(pw[5])
    end
    screen.move(112,30)
    if (pw[6] < 0) then
      screen.text("rnd")
      else
      screen.text(pw[6])
    end
    screen.move(5,40)
    screen.text("gn/m2")
    screen.move(37,40)
    if (mod2[1] < 0) then
      screen.text("rnd")
      else
      screen.text(mod2[1])
    end
    screen.move(52,40)
    if (mod2[2] < 0) then
      screen.text("rnd")
      else
      screen.text(mod2[2])
    end
    screen.move(67,40)
    if (mod2[3] < 0) then
      screen.text("rnd")
      else
      screen.text(mod2[3])
    end
    screen.move(82,40)
    if (mod2[4] < 0) then
      screen.text("rnd")
      else
      screen.text(mod2[4])
    end
    screen.move(97,40)
    if (mod2[5] < 0) then
      screen.text("rnd")
      else
      screen.text(mod2[5])
    end
    screen.move(112,40)
    if (mod2[6] < 0) then
      screen.text("rnd")
      else
      screen.text(mod2[6])
    end
    screen.move(5,50)
    screen.text("co/kHz")
    screen.move(37,50)
    if(hz2[1] == 0) then
      screen.text("rnd")
      else
      screen.text(hz2[1]/10)
    end
    screen.move(52,50)
    if(hz2[2] == 0) then
      screen.text("rnd")
      else
      screen.text(hz2[2]/10)
    end
    screen.move(67,50)
    if(hz2[3] == 0) then
      screen.text("rnd")
      else
      screen.text(hz2[3]/10)
    end
    screen.move(82,50)
    if(hz2[4] == 0) then
      screen.text("rnd")
      else
      screen.text(hz2[4]/10)
    end
    screen.move(97,50)
    if(hz2[5] == 0) then
      screen.text("rnd")
      else
      screen.text(hz2[5]/10)
    end
    screen.move(112,50)
    if(hz2[6] == 0) then
      screen.text("rnd")
      else
      screen.text(hz2[6]/10)
    end
    if(menupos >= 1 and menupos < 8) then
      screen.level(15)
      screen.move(6,21)
      screen.text("algo")
    end
    if(menupos == 1 or menupos == 7) then
      screen.level(15)
      screen.move(38,21)
      screen.text(tempsynthname[tempsynth[1]])
    end
    if(menupos == 2 or menupos == 7) then
      screen.level(15)
      screen.move(53,21)
      screen.text(tempsynthname[tempsynth[2]])
    end
    if(menupos == 3 or menupos == 7) then
      screen.level(15)
      screen.move(68,21)
      screen.text(tempsynthname[tempsynth[3]])
    end
    if(menupos == 4 or menupos == 7) then
      screen.level(15)
      screen.move(83,21)
      screen.text(tempsynthname[tempsynth[4]])
    end
    if(menupos == 5 or menupos == 7) then
      screen.level(15)
      screen.move(98,21)
      screen.text(tempsynthname[tempsynth[5]])
    end
    if(menupos == 6 or menupos == 7) then
      screen.level(15)
      screen.move(113,21)
      screen.text(tempsynthname[tempsynth[6]])
    end
    
    if(menupos >= 8 and menupos < 15) then
      screen.level(15)
      screen.move(6,31)
      screen.text("pw/m1")
      
    end
    if(menupos == 8 or menupos == 14) then
      screen.level(15)
      screen.move(38,31)
      if (pw[1] < 0) then
        screen.text("rnd")
        else
        screen.text(pw[1])
      end
    end
    if(menupos == 9 or menupos == 14) then
      screen.level(15)
      screen.move(53,31)
      if (pw[2] < 0) then
        screen.text("rnd")
        else
        screen.text(pw[2])
      end
    end
    
    if(menupos == 10 or menupos == 14) then
      screen.level(15)
      screen.move(68,31)
      if (pw[3] < 0) then
        screen.text("rnd")
        else
        screen.text(pw[3])
      end
    end
    if(menupos == 11 or menupos == 14) then
      screen.level(15)
      screen.move(83,31)
      if (pw[4] < 0) then
        screen.text("rnd")
        else
        screen.text(pw[4])
      end
    end
    if(menupos == 12 or menupos == 14) then
      screen.level(15)
      screen.move(98,31)
      if (pw[5] < 0) then
        screen.text("rnd")
        else
        screen.text(pw[5])
      end
    end
    if(menupos == 13 or menupos == 14) then
      screen.level(15)
      screen.move(113,31)
      if (pw[6] < 0) then
        screen.text("rnd")
        else
        screen.text(pw[6])
      end
    end
    
    
        
    if(menupos >= 15 and menupos < 22) then
      screen.level(15)
      screen.move(6,41)
      screen.text("gn/m2")
    end
    if(menupos == 15 or menupos == 21) then
      screen.level(15)
      screen.move(38,41)
      if (mod2[1] < 0) then
        screen.text("rnd")
        else
        screen.text(mod2[1])
      end
    end
    if(menupos == 16 or menupos == 21) then
      screen.level(15)
      screen.move(53,41)
      if (mod2[2] < 0) then
        screen.text("rnd")
        else
        screen.text(mod2[2])
      end
    end
    
    if(menupos == 17 or menupos == 21) then
      screen.level(15)
      screen.move(68,41)
      if (mod2[3] < 0) then
        screen.text("rnd")
        else
        screen.text(mod2[3])
      end
    end
    if(menupos == 18 or menupos == 21) then
      screen.level(15)
      screen.move(83,41)
      if (mod2[4] < 0) then
        screen.text("rnd")
        else
        screen.text(mod2[4])
      end
    end
    if(menupos == 19 or menupos == 21) then
      screen.level(15)
      screen.move(98,41)
      if (mod2[5] < 0) then
        screen.text("rnd")
        else
        screen.text(mod2[5])
      end
    end
    if(menupos == 20 or menupos == 21) then
      screen.level(15)
      screen.move(113,41)
      if (mod2[6] < 0) then
        screen.text("rnd")
        else
        screen.text(mod2[6])
      end
    end
    
   
    if(menupos > 21 and menupos < 29) then
      screen.level(15)
      screen.move(6,51)
      screen.text("co/kHz")
    end
    if(menupos == 22 or menupos == 28) then
      screen.level(15)
      screen.move(38,51)
      if(hz2[1] == 0) then
        screen.text("rnd")
        else
        screen.text((hz2[1])/10)
      end
    end
    if(menupos == 23 or menupos == 28) then
      screen.level(15)
      screen.move(53,51)
      if(hz2[2] == 0) then
        screen.text("rnd")
        else
        screen.text(hz2[2]/10)
      end
    end
    if(menupos == 24 or menupos == 28) then
      screen.level(15)
      screen.move(68,51)
      if(hz2[3] == 0) then
        screen.text("rnd")
        else
        screen.text(hz2[3]/10)
      end
    end
    if(menupos == 25 or menupos == 28) then
      screen.level(15)
      screen.move(83,51)
      if(hz2[4] == 0) then
        screen.text("rnd")
        else
        screen.text(hz2[4]/10)
      end
    end
    if(menupos == 26 or menupos == 28) then
      screen.level(15)
      screen.move(98,51)
      if(hz2[5] == 0) then
        screen.text("rnd")
        else
        screen.text(hz2[5]/10)
      end
    end
    if(menupos == 27 or menupos == 28) then
      screen.level(15)
      screen.move(113,51)
      if(hz2[6] == 0) then
        screen.text("rnd")
        else
        screen.text(hz2[6]/10)
      end
    end
  end
  
  if (page == 6) then
    screen.level(math.floor(wordcol1))
    screen.font_face(1)
    screen.font_size(8)
    screen.move(89,8)
    screen.text("midi")
    screen.level(math.floor(wordcol2))
    screen.move(90,9)
    screen.text("midi")
    screen.level(math.floor(wordcol3))
    screen.move(91,10)
    screen.text("midi")
    screen.level(3)
    screen.move(5,20)
    screen.text("snd midi trns ")
    screen.move(80,20)
    if (sendtrans == 0) then
      screen.text("no")
      else
      screen.text("yes")
    end
     if(menupos == 1) then
      screen.level(15)
      screen.move(81,21)
      if(sendtrans == 1) then
        screen.text("yes")
        else
        screen.text("no")
      end
    end
    screen.level(3)
    screen.move(5,30)  
    screen.text("rec midi trns ")
    screen.move(80,30)
    if (rectrans == 0) then
      screen.text("no")
      else
      screen.text("yes")
    end
     if(menupos == 2) then
      screen.level(15)
      screen.move(81,31)
      if(rectrans == 1) then
        screen.text("yes")
        else
        screen.text("no")
      end
    end
      
    screen.level(3)
    screen.move(5,40)  
    screen.text("midi note thru ")
    screen.move(80,40)
    if (notetrans == 0) then
      screen.text("no")
      else
      screen.text("yes")
    end
     if(menupos == 3) then
      screen.level(15)
      screen.move(81,41)
      if(notetrans == 1) then
        screen.text("yes")
        else
        screen.text("no")
      end
    end
    screen.level(3)
    screen.move(5,50)  
    screen.text("midi cc thru ")
    screen.move(80,50)
    if (cctrans == 0) then
      screen.text("no")
      else
      screen.text("yes")
    end
     if(menupos == 4) then
      screen.level(15)
      screen.move(81,51)
      if(cctrans == 1) then
        screen.text("yes")
        else
        screen.text("no")
      end
    end
  end
   if (page == 7) then
    screen.level(math.floor(wordcol1))
    screen.font_face(1)
    screen.font_size(8)
    screen.move(89,8)
    screen.text("macros")
    screen.level(math.floor(wordcol2))
    screen.move(90,9)
    screen.text("macros")
    screen.level(math.floor(wordcol3))
    screen.move(91,10)
    screen.text("macros")
    
    screen.level(3)
    
    tempx = 5
    tempy = 20
    for i = 1,12 do
      
      screen.move(tempx,tempy)
      screen.text(i)
      if i == menupos then
        menposx = tempx
        menposy = tempy
      end
      tempx = tempx + 10
      screen.move(tempx,tempy)
      screen.text("CC" .. string.lower(macroCC[i]))
      tempx = tempx + 31
      if i == 3 or i == 6 or i ==9  then
        tempx = 5
        tempy = tempy + 10
      end
    end
    
    screen.level(15)
    screen.move(menposx+1,menposy+1)
    screen.text(menupos)
    screen.move(menposx+11,menposy+1)
    screen.text("CC" .. string.lower(macroCC[menupos]))
     
      
    
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
  --[[
  if(state == 1) then
    if(piccount < 1000) then
      _norns.screen_export_png("/home/we/dust/code/pixels/pics/pic"..piccount..".png")
      piccount = piccount + 1
    end
    if(piccount > 999 and piccount < 2000) then
      _norns.screen_export_png("/home/we/dust/code/pixels/pics2/pic"..piccount..".png")
      piccount = piccount + 1
    end
    if(piccount > 1999 and piccount < 3000) then
      _norns.screen_export_png("/home/we/dust/code/pixels/pics3/pic"..piccount..".png")
      piccount = piccount + 1
    end
    if(piccount > 2999 and piccount < 4000) then
      _norns.screen_export_png("/home/we/dust/code/pixels/pics4/pic"..piccount..".png")
      piccount = piccount + 1
    end
  end
--]]
  end
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
    styleselecttemp = styleselect
    initialtemp = initial
  end
  if(page ==1) then
    if (n == 2 and id ==1) then
      k2 = 1
      if (drawing == 0) then
        linetime = 15
        wordblast = 15
        word = thispix
        size[thispix] = 6
        if(wayfinder[thispix] > -1 and wayfinder[thispix] < 61) then
          linex = ( (10 * math.cos((6*wayfinder[thispix] * math.pi / 180))))
          liney = ( (10 * math.sin((6*wayfinder[thispix] * math.pi / 180))))
        else
          linex = 0
          liney = 0
        end
      end
    end
    if (n == 2 and id ==0) then
      k2 = 0
    end
    if (n == 3 and id == 1) then
      k3 = 1
      if(drawing == 0 and k2 == 0) then
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
    if (n == 3 and id == 0) then
      k3 = 0
    end
    if(k2 == 1 and k3 == 1 and drawing == 1) then
      drawing = 0
      k2 = 0
      k3 = 0
      state = 0
      tab.save(pixCol, "/home/we/dust/code/pixels/pixel_data.txt")
      drawnewmap = 1
    end
    if(k2 == 1 and k3 == 1 and drawing == 0) then
      drawing = drawing + 1
      drawnewmap = 1
      transport(0)
      thispix = 1
      rc = mc
      tab.save(pixCol, "/home/we/dust/code/pixels/pixel_data.txt")
    end
  end
  if (page == 2) then
    if(n == 3 and id == 1) then
      if (menupos == 1) then
        style(styleselecttemp)
        styleselect = styleselecttemp
      end
      if(menupos == 23) then
        selecting = true
        fileselect.enter(_path.dust .. "code/pixels/pset",load_file)
      end
      if(menupos == 24) then
        textentry.enter(textenter,default_text,"Enter Save Name",check)
      end
      if(menupos == 25 and currentname ~= nil) then
        saveit()
      end
    end
  end
  if (page == 3) then
    if(n == 2 and id == 1) then
      if(menupos > 1) then
        for a = 1 , 6 do
          if(mutegroup[a] == 1) then
            pixelon[a] = pixelon[a] + 1
            if(pixelon[a] > 1) then
              pixelon[a] = 0
            end
          end
        end
        for mm=1,16 do
          if(pixelon[1] == 0) then
            midi_signals_out[mm]:note_off(notes1[1],nil,midiCH[1])
            table.remove(notes1,1)
          end
          if(pixelon[2] == 0) then
            midi_signals_out[mm]:note_off(notes2[1],nil,midiCH[2])
            table.remove(notes2,1)
          end
          if(pixelon[3] == 0) then
            midi_signals_out[mm]:note_off(notes3[1],nil,midiCH[3])
            table.remove(notes3,1)
          end
          if(pixelon[4] == 0) then
            midi_signals_out[mm]:note_off(notes4[1],nil,midiCH[4])
            table.remove(notes4,1)
          end
          if(pixelon[5] == 0) then
            midi_signals_out[mm]:note_off(notes5[1],nil,midiCH[5])
            table.remove(notes5,1)
          end
          if(pixelon[6] == 0) then
            midi_signals_out[mm]:note_off(notes6[1],nil,midiCH[6])
            table.remove(notes6,1)
          end
        end
      end
    end
    if(n == 3 and id == 1) then
      if (menupos == 1) then
        initialcondition(initialtemp)
        initial = initialtemp
      end
      if(menupos > 1) then
        for a = 1 , 6 do
          if(mutegroup[a] == 2) then
            pixelon[a] = pixelon[a] + 1
            if(pixelon[a] > 1) then
              pixelon[a] = 0
            end
          end
        end
        for mm=1,16 do
          if(pixelon[1] == 0) then
            midi_signals_out[mm]:note_off(notes1[1],nil,midiCH[1])
            table.remove(notes1,1)
          end
          if(pixelon[2] == 0) then
            midi_signals_out[mm]:note_off(notes2[1],nil,midiCH[2])
            table.remove(notes2,1)
          end
          if(pixelon[3] == 0) then
            midi_signals_out[mm]:note_off(notes3[1],nil,midiCH[3])
            table.remove(notes3,1)
          end
          if(pixelon[4] == 0) then
            midi_signals_out[mm]:note_off(notes4[1],nil,midiCH[4])
            table.remove(notes4,1)
          end
          if(pixelon[5] == 0) then
            midi_signals_out[mm]:note_off(notes5[1],nil,midiCH[5])
            table.remove(notes5,1)
          end
          if(pixelon[6] == 0) then
            midi_signals_out[mm]:note_off(notes6[1],nil,midiCH[6])
            table.remove(notes6,1)
          end
        end
      end
    end
  end
  if(page == 7) then
    if(n == 3 and id == 1) then
              
        tab.save(macros,"/home/we/dust/code/pixels/macros.txt")
        macros:set("CC"..menupos,macroCC[menupos])
        for i=1,6 do
          macros:set("scale"..menupos.."_"..i,mscale[i])
          macros:set("root"..menupos.."_"..i,low[i])
          macros:set("oct"..menupos.."_"..i,octaves[i])
        end  
        macros:write("/home/we/dust/code/pixels/macros.pset")
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
      wayfinder[j] = iwayfinder[(number-1)*6 +j]
      linex = ( (10 * math.cos((6*wayfinder[j] * math.pi / 180))))
      liney = ( (10 * math.sin((6*wayfinder[j] * math.pi / 180))))
    end
  end
  if (number == 1) then
    for j=1,6 do
      pixX[j] =math.random(0,127) 
      pixY[j] =math.random(0,63)
      wayfinder[j] = math.random(0,60)
      linex = ( (10 * math.cos((6*wayfinder[j] * math.pi / 180))))
      liney = ( (10 * math.sin((6*wayfinder[j] * math.pi / 180))))
      pixDX[j] =  linex/10
      pixDY[j] =  liney/10
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
   engine.algoName(synths[tempsynth[who]])
  attacker = attack[who]/10
  if(attacker < 0)  then
    attacker = math.random(1,100)/10
  end
  engine.attack(attacker)
  releaser = release[who]/10
  if(releaser < 0) then
    releaser = math.random(1,100)/10
  end
  factor = 17
  if(tempsynth[who] > 3) then
    factor = 100
  end
  mod2er = mod2[who]/factor
  if(mod2er < 0) then
    mod2er = math.random(0,100)/factor
  end
  engine.mod2(mod2er + .001)
  engine.release(releaser)
  pwer = pw[who]/100
  if(pw[who] < 0) then
    pwer = math.random(0,100)/100
  end
  engine.pw(pwer)
  hz2er = hz2[who] * 100 
  if(hz2er == 0) then
    hz2er = math.random(1,150) * 100
  end
  engine.hz2(hz2er)
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
    actualVEL = math.random(0,127)
  end
  
  

  
  if (who == 1 and (key1 == 0 or key1 == 1 or (key1 == 2 and mute == false))) then
    newrange = scale1[#scale1] - scale1[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale1[1])
    table.insert(notes1,1,music.snap_note_to_array (note, scale1))
    while(#notes1 > 1) do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes1[2],nil,midiCH[who])
      end
      table.remove(notes1,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale1)))
    for mm=1,16 do
      midi_signals_out[mm]:note_on(music.snap_note_to_array (note, scale1),actualVEL,midiCH[who])
    end
  end
  if (who == 2 and (key2 == 0 or key2 == 1 or (key2 == 2 and mute == false))) then
    newrange = scale2[#scale2] - scale2[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale2[1])
    table.insert(notes2,1,music.snap_note_to_array (note, scale2))
    while(#notes2 > 1) do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes2[2],nil,midiCH[who])
      end
      table.remove(notes2,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale2)))
    for mm = 1,16 do
      midi_signals_out[mm]:note_on(music.snap_note_to_array (note, scale2),actualVEL,midiCH[who])
    end
  end
  if (who == 3 and (key3 == 0 or key3 == 1 or (key3 == 2 and mute == false))) then
    newrange = scale3[#scale3] - scale3[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale3[1])
    table.insert(notes3,1,music.snap_note_to_array (note, scale3))
    while(#notes3 > 1) do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes3[2],nil,midiCH[who])
      end
      table.remove(notes3,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale3)))
    for mm=1,16 do
      midi_signals_out[mm]:note_on(music.snap_note_to_array (note, scale3),actualVEL,midiCH[who])
    end
  end
  if (who == 4 and (key4 == 0 or key4 == 1 or (key4 == 2 and mute == false))) then
    newrange = scale4[#scale4] - scale4[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale4[1])
    table.insert(notes4,1,music.snap_note_to_array (note, scale4))
    while(#notes4 > 1) do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes4[2],nil,midiCH[who])
      end
      table.remove(notes4,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale4)))
    for mm=1,16 do
      midi_signals_out[mm]:note_on(music.snap_note_to_array (note, scale4),actualVEL,midiCH[who])
    end  
  end
  if (who == 5 and (key5 == 0 or key5 == 1 or (key5 == 2 and mute == false))) then
    newrange = scale5[#scale5] - scale5[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale5[1])
    table.insert(notes5,1,music.snap_note_to_array (note, scale5))
    while(#notes5 > 1) do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes5[2],nil,midiCH[who])
      end
      table.remove(notes5,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale5)))
    for mm=1,16 do
      midi_signals_out[mm]:note_on(music.snap_note_to_array (note, scale5),actualVEL,midiCH[who])
    end  
  end
  if (who == 6 and (key6 == 0 or key6== 1 or (key6 == 2 and mute == false))) then
    newrange = scale6[#scale6] - scale6[1]
    note = math.floor((((note - 1)* newrange) / oldrange) + scale6[1])
    table.insert(notes6,1,music.snap_note_to_array (note, scale6))
    while(#notes6 > 1) do
      for mm=1,16 do
        midi_signals_out[mm]:note_off(notes6[2],nil,midiCH[who])
      end
      table.remove(notes6,2)
    end
    engine.hz(music.note_num_to_freq(music.snap_note_to_array (note, scale6)))
    for mm=1,16 do
      midi_signals_out[mm]:note_on(music.snap_note_to_array (note, scale6),actualVEL,midiCH[who])
    end  
  end
end
  
--let's look at twiddled knobs
function enc(n,delta)
  if (n == 1 and menumode == 1) then
    page = util.clamp(page + delta,2,7)
    lastpage = page
    menupos = 1
    styleselecttemp = styleselect
    initialtemp = initial
  end
  if (page == 1) then
    if(n == 1 and drawing == 1) then
      drawcolor[1] = util.clamp(drawcolor[1] + delta,0,127)
      play(pixCol[math.floor(pixX[1])][math.floor(pixY[1])],1)
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

    if (n == 2 and k2 == 0 and k3 == 0) then
      if(drawing == 1) then
        util.clamp(delta,-1,1)
      end
      pixX[thispix] = util.clamp(pixX[thispix] + delta,0,127)
      if(drawing == 0) then
        if(pixelon[thispix] == 1) then
          play(pixCol[  math.floor(pixX[thispix])  ][math.floor(pixY[thispix])],thispix)
        end
        size[thispix] = 6
      end
      if(drawing == 1) then
         play(drawcolor[thispix],thispix) 
      end
    end
    if (n == 2 and k2 == 1 and drawing == 0) then
      linetime = 15
      wayfinder[thispix] = util.clamp(wayfinder[thispix] + delta, -2,62)
      if(wayfinder[thispix] < 0 or wayfinder[thispix] > 60) then
        linex = 0
        liney = 0
        pixDX[thispix] = 0
        pixDY[thispix] = 0
      else
        linex = ( (10 * math.cos((6*wayfinder[thispix] * math.pi / 180))))
        liney = ( (10 * math.sin((6*wayfinder[thispix] * math.pi / 180))))
        pixDX[thispix] = 1 * linex/10
        pixDY[thispix] = 1 * liney/10
      end
      if(wayfinder[thispix] == 62) then
        wayfinder[thispix] = 0
      end
      if(wayfinder[thispix] == -2) then
        wayfinder[thispix] = 60
      end

    end
    if (n == 3 and k2 == 1 and drawing == 0) then
      thispix = util.clamp(thispix + delta,1,6)
      wordblast = 8
      word = thispix
      size[thispix] = 6
      linetime = 15
      if(wayfinder[thispix] < 0 or wayfinder[thispix] > 60) then
        linex = 0
        liney = 0
        pixDX[thispix] = 0
        pixDY[thispix] = 0
      else
        linex = ( (10 * math.cos((6*wayfinder[thispix] * math.pi / 180))))
        liney = ( (10 * math.sin((6*wayfinder[thispix] * math.pi / 180))))
        pixDX[thispix] = 1 * linex/10
        pixDY[thispix] = 1 * liney/10
      end
    end
    if (n == 3 and k2 == 0 and k3 == 0) then
      pixY[thispix] = util.clamp(pixY[thispix] + delta,0,63)
      if(drawing == 0) then
        if(pixelon[thispix] == 1) then
          play(pixCol[math.floor(pixX[thispix])][math.floor(pixY[thispix])],thispix)  
        end
        size[thispix] = 6
      end
      if (drawing == 1) then
        play(drawcolor[thispix],thispix)  
      end
    end
  end
  if (page == 2) then
    if(n == 2) then
      menupos = util.clamp(menupos + delta,1,25)
      if (currentname == nil and menupos == 25) then
        menupos = 24
      end
      lastmenupos = menupos
      if(menupos < 1 or menupos > 8) then
        scalefade = 0
      end
      if(scalefade > 0 and (menupos > 1 and menupos < 9)) then
        scalefade = 36
      end
    end
    if(n == 3) then
      if (menupos == 1) then
        styleselecttemp = util.clamp(styleselecttemp+delta,1,#styles)
      end
      if (menupos > 1 and menupos < 9) then
        scalefade = 24
      end
      if (menupos == 2) then
        mscale[1] = util.clamp(mscale[1]+delta,1,41)
        scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
      end
      if (menupos == 3) then
        mscale[2] = util.clamp(mscale[2]+delta,1,41)
        scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
      end
      if (menupos == 4) then 
        mscale[3] = util.clamp(mscale[3]+delta,1,41)
        scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
      end
      if (menupos == 5) then
        mscale[4] = util.clamp(mscale[4]+delta,1,41)
        scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
      end
      if (menupos == 6) then
        mscale[5] = util.clamp(mscale[5]+delta,1,41)
        scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
      end
      if(menupos == 7) then
        mscale[6] = util.clamp(mscale[6]+delta,1,41)
        scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
      end
      if(menupos == 8) then
        mscaletemp = util.clamp(mscaletemp+delta,1,41)
        for a = 1,6 do
          mscale[a] = mscaletemp
        end
        scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
        scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
        scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
        scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
        scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
        scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
      end
      if (menupos == 9) then
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
        scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
      end
      if (menupos == 10) then
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
        scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
      end
      if (menupos == 11) then
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
        scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
      end
      if (menupos == 12) then
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
        scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
      end
      if (menupos == 13) then
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
        scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
      end
      if (menupos == 14) then
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
        scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
      end
      if (menupos == 15) then
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
        scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
        scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
        scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
        scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
        scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
        scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
      end
      if (menupos == 16) then
        octaves[1] = util.clamp(octaves[1]+delta,1,8)
        scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
      end
      if (menupos == 17) then
        octaves[2] = util.clamp(octaves[2]+delta,1,8)
        scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
      end
      if (menupos == 18) then
        octaves[3] = util.clamp(octaves[3]+delta,1,8)
        scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
      end
      if (menupos == 19) then
        octaves[4] = util.clamp(octaves[4]+delta,1,8)
        scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
      end
      if (menupos == 20) then
        octaves[5] = util.clamp(octaves[5]+delta,1,8)
        scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
      end
      if (menupos == 21) then
        octaves[6] = util.clamp(octaves[6]+delta,1,8)
        scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
      end
      if (menupos == 22) then
        octavesmain = util.clamp(octavesmain + delta,1,8)
        octaves[1] = octavesmain
        scale1 = music.generate_scale(low[1],mscale[1],octaves[1])
        octaves[2] = octavesmain
        scale2 = music.generate_scale(low[2],mscale[2],octaves[2])
        octaves[3] = octavesmain
        scale3 = music.generate_scale(low[3],mscale[3],octaves[3])
        octaves[4] = octavesmain
        scale4 = music.generate_scale(low[4],mscale[4],octaves[4])
        octaves[5] = octavesmain
        scale5 = music.generate_scale(low[5],mscale[5],octaves[5])
        octaves[6] = octavesmain
        scale6 = music.generate_scale(low[6],mscale[6],octaves[6])
      end

    end
  end
  if (page == 3) then
    if(n == 2) then
      menupos = util.clamp(menupos + delta,1,36)
      lastmenupos = menupos
    end
    if(n == 3) then
      if (menupos == 2) then
        mutegroup[1] = util.clamp(mutegroup[1]+delta,0,2)
      end
      if (menupos == 3) then
        mutegroup[2] = util.clamp(mutegroup[2]+delta,0,2)
            end
      if (menupos == 4) then
        mutegroup[3] = util.clamp(mutegroup[3]+delta,0,2)
          end
      if (menupos == 5) then
        mutegroup[4] = util.clamp(mutegroup[4]+delta,0,2)
          end
      if (menupos == 6) then
        mutegroup[5] = util.clamp(mutegroup[5]+delta,0,2)
          end
      if (menupos == 7) then
        mutegroup[6] = util.clamp(mutegroup[6]+delta,0,2)
      end
      if (menupos == 8) then 
        mutegrouptemp = util.clamp(mutegrouptemp+delta,0,2)
        for a = 1, 6 do
          mutegroup[a] = mutegrouptemp
        end
      end
      if (menupos == 9) then
        pixelon[1] = util.clamp(pixelon[1]+delta,0,1)
        if(pixelon[1] == 0) then
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes1[1],nil,midiCH[1])
          end
          table.remove(notes1,1)
        end
      end
      if (menupos == 10) then
        pixelon[2] = util.clamp(pixelon[2]+delta,0,1)
        if(pixelon[2] == 0) then
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes2[1],nil,midiCH[2])
          end
          table.remove(notes2,1)
        end
      end
      if (menupos == 11) then
        pixelon[3] = util.clamp(pixelon[3]+delta,0,1)
        if(pixelon[3] == 0) then
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes3[1],nil,midiCH[3])
          end
          table.remove(notes3,1)
        end
      end
      if (menupos == 12) then
        pixelon[4] = util.clamp(pixelon[4]+delta,0,1)
        if(pixelon[4] == 0) then
          formm=1,16 do
            midi_signals_out[mm]:note_off(notes4[1],nil,midiCH[4])
          end
          table.remove(notes4,1)
        end
      end
      if (menupos == 13) then
        pixelon[5] = util.clamp(pixelon[5]+delta,0,1)
        if(pixelon[5] == 0) then
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes5[1],nil,midiCH[5])
          end
          table.remove(notes5,1)
        end
      end
      if (menupos == 14) then
        pixelon[6] = util.clamp(pixelon[6]+delta,0,1)
        if(pixelon[6] == 0) then
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes6[1],nil,midiCH[6])
          end
          table.remove(notes6,1)
        end
      end
      if (menupos == 15) then
        numpixsel = util.clamp(numpixsel+delta,0,1)
        for a=1,6 do
          pixelon[a] = numpixsel
      end
      end
      if (menupos == 1) then
        initialtemp = util.clamp(initialtemp + delta, 1,#initialword)
      end
      if (menupos == 16) then
       trigprob[1] = util.clamp(trigprob[1]+delta,0,100)
      end
      if (menupos == 17) then
       trigprob[2] = util.clamp(trigprob[2]+delta,0,100)
      end
      if (menupos == 18) then
       trigprob[3] = util.clamp(trigprob[3]+delta,0,100)
      end
      if (menupos == 19) then
       trigprob[4] = util.clamp(trigprob[4]+delta,0,100)
      end
      if (menupos == 20) then
       trigprob[5] = util.clamp(trigprob[5]+delta,0,100)
      end
      if (menupos == 21) then
       trigprob[6] = util.clamp(trigprob[6]+delta,0,100)
      end
      if (menupos == 22) then
        trigprobmain = util.clamp((trigprobmain) + delta, 1,100)
        for all=1,6 do
          trigprob[all] = trigprobmain
        end
      end
      if (menupos == 23) then
        midiVEL[1] = util.clamp(midiVEL[1] + delta, -1,127)
      end
      if (menupos == 24) then
        midiVEL[2] = util.clamp(midiVEL[2] + delta, -1,127)
      end
      if (menupos == 25) then
        midiVEL[3] = util.clamp(midiVEL[3] + delta, -1,127)
      end
      
      if (menupos == 26) then
        midiVEL[4] = util.clamp(midiVEL[4] + delta, -1,127)
      end
      
      if (menupos == 27) then
        midiVEL[5] = util.clamp(midiVEL[5] + delta, -1,127)
      end
      
      if (menupos == 28) then
        midiVEL[6] = util.clamp(midiVEL[6] + delta, -1,127)
      end
      if (menupos == 29) then
        midiVELmain = util.clamp(midiVELmain + delta, -1,127)
        for all=1,6 do
          midiVEL[all] = midiVELmain
        end
      end
      if (menupos == 30) then
        for a=1,#notes1 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes1[a],0,midiCH[1])
          end        
        end
        for a=1,#notes1 do
          table.remove(notes1,1)
        end
        midiCH[1] = util.clamp(midiCH[1] + delta, 1,16)
      end
      
      if (menupos == 31) then
      for a=1,#notes2 do
        for mm=1,16 do
          midi_signals_out[mm]:note_off(notes2[a],0,midiCH[2])
        end
      end
      for a=1,#notes2 do
          table.remove(notes2,1)
        end
        midiCH[2] = util.clamp(midiCH[2] + delta, 1,16)
      end
      if (menupos == 32) then
        for a=1,#notes3 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes3[a],0,midiCH[3])
          end        
        end
        for a=1,#notes3 do
          table.remove(notes3,1)
        end
        midiCH[3] = util.clamp(midiCH[3] + delta, 1,16)
      end
      if (menupos == 33) then
        for a=1,#notes4 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes4[a],0,midiCH[4])
          end
        end
        for a=1,#notes4 do
          table.remove(notes4,1)
        end
        midiCH[4] = util.clamp(midiCH[4] + delta, 1,16)
      end
      if (menupos == 34) then
        for a=1,#notes5 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes5[a],0,midiCH[5])
          end        
        end
        for a=1,#notes5 do
          table.remove(notes5,1)
        end
        midiCH[5] = util.clamp(midiCH[5] + delta, 1,16)
      end
      if (menupos == 35) then
        for a=1,#notes6 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes6[a],0,midiCH[6])
          end
        end
        for a=1,#notes6 do
          table.remove(notes6,1)
        end
        midiCH[6] = util.clamp(midiCH[6] + delta, 1,16)
      end
      if (menupos == 36) then
        midiCHmain = util.clamp((midiCHmain) + delta, 1,16)
        for a=1,#notes1 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes1[a],0,midiCH[1])
          end
        end
        for a=1,#notes1 do
          table.remove(notes1,1)
        end
        for a=1,#notes2 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes2[a],0,midiCH[2])
          end
        end
        for a=1,#notes2 do
          table.remove(notes2,1)
        end
        for a=1,#notes3 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes3[a],0,midiCH[3])
          end      
        end
        for a=1,#notes3 do
          table.remove(notes3,1)
        end
        for a=1,#notes4 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes4[a],0,midiCH[4])
          end        
        end
        for a=1,#notes4 do
          table.remove(notes4,1)
        end
        for a=1,#notes5 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes5[a],0,midiCH[5])
          end
        end
        for a=1,#notes5 do
          table.remove(notes5,1)
        end
        for a=1,#notes6 do
          for mm=1,16 do
            midi_signals_out[mm]:note_off(notes6[a],0,midiCH[6])
          end        
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
        attack[1] = util.clamp(attack[1]+delta,-1,100)
      end
      if (menupos == 2) then
        attack[2] = util.clamp(attack[2]+delta,-1,100)
      end
      if (menupos == 3) then
        attack[3] = util.clamp(attack[3]+delta,-1,100)
      end
      if (menupos == 4) then
        attack[4] = util.clamp(attack[4]+delta,-1,100)
      end
      if (menupos == 5) then
        attack[5] = util.clamp(attack[5]+delta,-1,100)
      end
      if (menupos == 6) then
        attack[6] = util.clamp(attack[6]+delta,-1,100)
      end
      if (menupos == 7) then
        tempattack = util.clamp(tempattack+delta,-1,100)
        for a=1,6 do
          attack[a]=tempattack
        end
      end
      if (menupos == 8) then
        release[1] = util.clamp(release[1]+delta,-1,100)
      end
      if (menupos == 9) then
        release[2] = util.clamp(release[2]+delta,-1,100)
      end
      if (menupos == 10) then
        release[3] = util.clamp(release[3]+delta,-1,100)
      end
      if (menupos == 11) then
        release[4] = util.clamp(release[4]+delta,-1,100)
      end
      if (menupos == 12) then
        release[5] = util.clamp(release[5]+delta,-1,100)
      end
      if (menupos == 13) then
        release[6] = util.clamp(release[6]+delta,-1,100)
      end
      if (menupos == 14) then
        temprel = util.clamp(temprel+delta,-1,100)
        for a=1,6 do
          release[a]=temprel
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
  if (page == 5) then
    if(n == 2) then
      menupos = util.clamp(menupos + delta,1,28)
      lastmenupos = menupos
    end
    if(n == 3) then
      if (menupos == 1) then
        tempsynth[1] = util.clamp(tempsynth[1]+delta,1,8)
      end
      if (menupos == 2) then
        tempsynth[2] = util.clamp(tempsynth[2]+delta,1,8)
      end
      if (menupos == 3) then
        tempsynth[3] = util.clamp(tempsynth[3]+delta,1,8)
      end
      if (menupos == 4) then
        tempsynth[4] = util.clamp(tempsynth[4]+delta,1,8)
      end
      if (menupos == 5) then
        tempsynth[5] = util.clamp(tempsynth[5]+delta,1,8)
      end
      if (menupos == 6) then
        tempsynth[6] = util.clamp(tempsynth[6]+delta,1,8)
      end
      if (menupos == 7) then
        temptempsynth = util.clamp(temptempsynth+delta,1,8)
        for a=1,6 do
          tempsynth[a]=temptempsynth
        end
      end
      
      if (menupos == 8) then
        pw[1] = util.clamp(pw[1]+delta,-1,100)
      end
      if (menupos == 9) then
        pw[2] = util.clamp(pw[2]+delta,-1,100)
      end
      if (menupos == 10) then
        pw[3] = util.clamp(pw[3]+delta,-1,100)
      end
      if (menupos == 11) then
        pw[4] = util.clamp(pw[4]+delta,-1,100)
      end
      if (menupos == 12) then
        pw[5] = util.clamp(pw[5]+delta,-1,100)
      end
      if (menupos == 13) then
        pw[6] = util.clamp(pw[6]+delta,-1,100)
      end
      if (menupos == 14) then
        temppw = util.clamp(temppw+delta,-1,100)
        for a=1,6 do
          pw[a]=temppw
        end
      end
      
      
      if (menupos == 15) then
        mod2[1] = util.clamp(mod2[1]+delta,-1,100)
      end
      if (menupos == 16) then
        mod2[2] = util.clamp(mod2[2]+delta,-1,100)
      end
      if (menupos == 17) then
        mod2[3] = util.clamp(mod2[3]+delta,-1,100)
      end
      if (menupos == 18) then
        mod2[4] = util.clamp(mod2[4]+delta,-1,100)
      end
      if (menupos == 19) then
        mod2[5] = util.clamp(mod2[5]+delta,-1,100)
      end
      if (menupos == 20) then
        mod2[6] = util.clamp(mod2[6]+delta,-1,100)
      end
      if (menupos == 21) then
        tempmod2 = util.clamp(tempmod2+delta,-1,100)
        for a=1,6 do
          mod2[a]=tempmod2
        end
      end
      if (menupos == 22) then
        hz2[1] = util.clamp(hz2[1]+delta,0,150)
      end
      if (menupos == 23) then
        hz2[2] = util.clamp(hz2[2]+delta,0,150)
      end
      if (menupos == 24) then
        hz2[3] = util.clamp(hz2[3]+delta,0,150)
      end
      if (menupos == 25) then
        hz2[4] = util.clamp(hz2[4]+delta,0,150)
      end
      if (menupos == 26) then
        hz2[5] = util.clamp(hz2[5]+delta,0,150)
      end
      if (menupos == 27) then
        hz2[6] = util.clamp(hz2[6]+delta,0,150)
      end
      if (menupos == 28) then
        temphz2 = util.clamp(temphz2+delta,0,150)
        for a=1,6 do
          hz2[a]=temphz2
        end
      end
    end
  end
  if (page == 6) then
    if(n == 2) then
      menupos = util.clamp(menupos + delta,1,4)
      lastmenupos = menupos
    end
    if(menupos == 1 and n == 3) then
      if(delta > 0) then
        sendtrans = 1
      end
      if(delta < 0) then
        sendtrans = 0
      end
    end
    if(menupos == 2 and n == 3) then
      if(delta > 0) then
        rectrans = 1
      end
      if(delta < 0) then
        rectrans = 0
      end
    end
    if(menupos == 3 and n == 3) then
      if(delta > 0) then
        notetrans = 1
      end
      if(delta < 0) then
        notetrans = 0
      end
    end
    if(menupos == 4 and n == 3) then
      if(delta > 0) then
        cctrans = 1
      end
      if(delta < 0) then
        cctrans = 0
      end
    end
  end
  if (page == 7) then
    if(n==2) then
      menupos = util.clamp(menupos + delta,1,12)
      lastmenupos = menupos
    end
    if(n==3) then
      macroCC[menupos] = util.clamp(macroCC[menupos]+delta,1,127)
    end
  end
end
  
--let's set the style of landscape our pixels travel on
function style(q)
  drawnewmap = 1
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
        pixCol[x][y] = util.clamp(temp,0,127)
        if (x == total and x < 128) then
          total = total + sizer[a+1]
          a = a + 1
        end
      end
    end
  end
  if (q == 2) then
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = math.random(0,127)
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
        pixCol[x][y] = col[position] + counter
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
        pixCol[x][y] = util.clamp(math.abs(math.sin(math.pi * ((factor+x)/(8+y))) * 127),0,127)
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
        if (tri > 127) then
          dir = -1
          tri = 127
        end
        if(tri < 0) then
          dir = 1
          tri = 0
        end
      pixCol[x][y] = tri
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
          else
            pixCol[x][y] = basecol
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
        col = col + math.random(0,12)
        if (col > top) then
          col = 0
          top = math.random(0,127)
        end
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
              pixCol[x][y] = util.clamp(127 + (y - 64),0,127)
            end
            if(y == height[w] and (x<= l[w] or x >= r[w])) then
              pixCol[x][y] = util.clamp(127 * ((y)/64),0,127)
            end
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
      end
    end
  end
  if (q == 14) then
    factor = math.random(10,100)
    factor2 = math.random(60,120)
    for x=0,128 do
      for y=0,64 do
        pixCol[x][y] = util.clamp(math.abs(math.floor(math.sin((x-12.5)/100*math.pi) * factor2 + math.sin(y/63*math.pi) * factor)),0,127)
      end
    end
  end
  if (q == 15) then
    factor = math.random(10,100)/100
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = util.clamp(math.floor(math.abs((x+y)/127 * (128-y/factor))),0,127)
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
          pixCol[x][y] = util.clamp(math.floor(col - col *  (side/sideorigin) + 15),0,127)
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
          pixCol[x][y] = util.clamp(math.floor(col - col *  (side/sideorigin) + 15),0,127)
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
          pixCol[x][y] = util.clamp(math.floor(col - col *  (side/sideorigin) + 15),0,127)
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
          pixCol[x][y] = util.clamp(math.floor(col - col *  (side/sideorigin)+ 15),0,127)
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
      end
    end
    for a=1,math.random(25,125) do
      xx = math.random(2,125)
      yy = math.random(2,61)
      base = 127
      base1 = math.random(base-60,base-24)
      base2 = math.random(base-96,base-72)
      pixCol[xx][yy] = base
      pixCol[xx-1][yy] = base1
      pixCol[xx-2][yy] = base2
      pixCol[xx+1][yy] = base1
      pixCol[xx+2][yy] = base2
      pixCol[xx][yy+1] = base1
      pixCol[xx][yy+2] = base2
      pixCol[xx][yy-1] = base1
      pixCol[xx][yy-2] = base2
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
        end
        k = k + (math.pi * 2) / circ
      end
    end
  end
  if (q == 19) then
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = 0
      end
    end
  end
  if (q == 20) then
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = 63
      end
    end
  end
  if (q == 21) then
    for y=0,64 do
      for x=0,128 do
        pixCol[x][y] = 127
      end
    end
  end
  tab.save(pixCol, "/home/we/dust/code/pixels/pixel_data.txt")
  if(state==1) then
    transport(0)
    transport(1)
  end
end
