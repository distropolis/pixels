// "the" bangs

Thebgs  {
	classvar maxVoices = 32;

	var server;
	var group;

	// synth params
	var <>hz1;
	var <>hz2;
	var <>mod1;
	var <>mod2;
	var <>amp;
	var <>pan;
	var <>attack;
	var <>release;

	// some bangs
	var bangs;
	// the bang - a method of Bangs, as a string
	var <thebang;
	// which bang - numerical index
	var <whichbang;

	var <voicer;

	*new { arg srv;
		^super.new.init(srv);
	}

	init {
		arg srv;
		server = srv;
		group = Group.new(server);

		// default parameter values
		hz1 = 330;
		hz2 = 10000;
		mod1 = 0.5;
		mod2 = 0.0;

		attack = 0.01;
		release = 2;
		amp = 0.1;
		pan = 0.0;

		bangs = Bgs.class.methods.collect({|m| m.name});
		bangs.do({|name| postln(name); });

		this.whichBang = 0;

		voicer = OneshVoicer.new(maxVoices);
	}

	//--- setters
	bang_{ arg name;
		thebang = name;
	}

	whichBang_ { arg i;
		whichbang = i;
		thebang = bangs[whichbang];
	}

	// bang!
	bang { arg hz;
		var fn;

		/*
		postln("bang!");
		postln([hz1, mod1, hz2, mod2, amp, pan, attack, release]);
		postln([server, group]);
		*/
		
		if (hz != nil, { hz1 = hz; });
		
		fn = {
			var syn;
			syn = {
				arg gate=1;
				var snd, perc, ender;

				perc = EnvGen.ar(Env.perc(attack, release), doneAction:Done.freeSelf);
				ender = EnvGen.ar(Env.asr(0, 1, 0.01), gate:gate, doneAction:Done.freeSelf);
				
				snd = Bgs.perform(thebang, hz1, mod1, hz2, mod2, perc);

				Out.ar(0, Pan2.ar(snd * perc * amp * ender, pan));

			}.play(group);
			syn
		};

		voicer.newVoice(fn);
	}

	
	freeAllNotes {
		// do need this to keep the voicer in sync..
		voicer.stopAllVoices;
		// but it should ultimately do the same as this (more reliable):
		group.set(\gate, 0);
	}

}
