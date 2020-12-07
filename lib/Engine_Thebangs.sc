// thin wrapper around `thebangs` for norns

Engine_Pixelbangs : CroneEngine {

	var thebangs;
	
	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		thebangs = Thebgs.new(Crone.server);

		// TODO: should probably clamp incoming values.
		// or, at minimum, provide a lua layer which does so
		// (e.g. by defining parameters.)

		// setting the primary frequency also triggers a new self-freeing synth voice.
		// this is the defining behavior of a Bang.
		this.addCommand("hz1", "f", { arg msg;
			thebangs.hz1 = msg[1];
			thebangs.bang;
		});

		
		// each of these commands simply calls a correspondingly-named setter,
		// with a single float argument
		["hz2", "mod1", "mod2", "amp", "pan", "attack", "release"].do({
			arg str;
			this.addCommand(str, "f", { arg msg;
				thebangs.perform((str++"_").asSymbol, msg[1]);
			});
		});
		
		
		// select the synthesis algorithm by name
		this.addCommand("algoName", "s", { arg msg;
			thebangs.bang = msg[1];
		});

		// select the synthesis algorithm by index
		this.addCommand("algoIndex", "i", { arg msg;
			thebangs.whichBang = msg[1]-1; // convert from 1-based
		});

		// select the voice-stealing mode
		// - 0: static; always steal the voice that is `stealIdx` from oldest
		// - 1: (default): oldest first
		// - 2: newest first
		// - 3: ignore new notes until a voice becomes free
		this.addCommand("stealMode", "i", { arg msg;
			thebangs.voicer.stealMode = msg[1];
		});

		// set the voice-stealing index to be used with stealMode=0
		this.addCommand("stealIndex", "i", { arg msg;
			thebangs.voicer.stealIdx = msg[1];
		});

		// stop all currently sustaining voices
		this.addCommand("stopAllVoices", "", { arg msg;
			thebangs.voicer.stopAllVoices;
		});

		// set the max number of simultaneous voices
		this.addCommand("maxVoices", "i", { arg msg;
			thebangs.voicer.maxVoices = msg[1];
		});
		

		//---------------------------------------------------
		//--- command aliases for compatibility with PolyPerc
		this.addCommand("hz", "f", { arg msg;
			thebangs.hz1 = msg[1];
			thebangs.bang;
		});

		this.addCommand("pw", "f", { arg msg;
			thebangs.mod1 = msg[1]; 
		});

		this.addCommand("cutoff", "f", { arg msg;
			var val = msg[1];
			thebangs.hz2 = val;
		});

		this.addCommand("gain", "f", { arg msg;
			thebangs.mod2 = msg[1];
		});

	}

	free {
		thebangs.freeAllNotes;
	}
}
