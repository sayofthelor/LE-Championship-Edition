package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.effects.particles.FlxParticle.IFlxParticle;

/**
 * @author Shaun Stone (SMKS) <http://www.smks.co.uk>
 */
class Confetti extends FlxTypedGroup<FlxEmitter>
{
	#if mobile
	private static inline var MAX_COUNT:Int = 30;
	#else
	private static inline var MAX_COUNT:Int = 100;
	#end
	
	var emitter:FlxEmitter;

	public function new() 
	{ 
		super(MAX_COUNT);
		
		emitter = new FlxEmitter(FlxG.width / 2, 0, MAX_COUNT);
		
		emitter.acceleration.set(0, 200);
		
		// emitter.gravity = 150;
		
		for (i in 0...MAX_COUNT) {
			var p = new ConfettiParticle();
        	emitter.add(p);
			emitter.kill();
		}
		
		emitter.setSize(FlxG.width / 2, 0);
		
		add(emitter);
	}
	
	override public function update(elapsed):Void 
	{
		super.update(elapsed);
	}

	public function trigger():Void
	{		
		for (i in 0...MAX_COUNT) {
			emitter.recycle(FlxParticle);
		}
		
		emitter.start(true, 0);
	}
	
}

class ConfettiParticle extends FlxParticle implements IFlxParticle
{
	var spinRotation:Float;
	
	public function new()
	{
		super();
		
		this.makeGraphic(20, 20, FlxG.random.color());
		this.x = FlxG.random.float(0, FlxG.width - this.width);
		this.y = this.height * 1.5;
		this.exists = false;
		this.angularVelocity = 0.1;
		// this.friction = 0;
		
		this.spinRotation = FlxG.random.float(0.01, 0.05);
	}
	
	override public function update(elapsed):Void 
	{
		super.update(elapsed);
		
		this.scale.x = 1;
		this.scale.y = this.scale.y - spinRotation;
		
		if (this.scale.y <= -1) {
			this.scale.y = 1;
		}
	}
}