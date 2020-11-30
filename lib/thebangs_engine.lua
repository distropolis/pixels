local Thebangs = {}

Thebangs.options = {}
Thebangs.options.algoNames = {
   "square", "square_mod1", "square_mod2",
   "sinfmlp", "sinfb",
   "reznoise",
   "klangexp", "klanglin"
}

Thebangs.options.stealModes = {
   "static", "FIFO", "LIFO", "ignore"
}

function Thebangs.add_basic_synth_params()
   --  TODO: add these params:
   --[[
      amp, pan, release, mod1, hz2, mod2
   --]]
end

function Thebangs.add_additional_synth_params()   
   params:add{
      type="option", id="algo", default=1,
      options=Thebangs.options.algoNames,
      action=function(value)
	 engine.algoIndex(value)
      end
   }
   
   params:add{
      type="control", id="attack",
      controlspec=controlspec.new(0.0001, 1, 'exp', 0, 0.01, ''),
      action=function(value)
	 engine.attack(value)
      end
   }
   
end

function Thebangs.add_voicer_params()
   params:add{
      type="trigger", id="stop_all", name="stop all",
      action=function(value)
	 engine.stopAllVoices()
      end
   }
   
   params:add{
      type="number", id="max_voices", name="max voices", min=1, max=32, default=32,
      action=function(value)
	 engine.maxVoices(value)
      end
   }
   
   
   params:add{
      type="option", id="steal_mode", name="steal mode", default=2,
      options=Thebangs.options.stealModes,
      action=function(value)
	 engine.stealMode(value-1)
      end
   }
   
   params:add{
      type="number", id="steal_index", name="steal index", min=0, max=32, default=0,
      action=function(value)
	 engine.stealIndex(value)
      end
   }
   
end

return Thebangs
