package funkin.psychlua;

class ModchartSprite extends FlxSprite
{
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();
	
	public function new(?x:Float = 0, ?y:Float = 0)
	{
		super(x, y);
		antialiasing = ClientPrefs.data.antialiasing;
	}
	
	public function playAnim(name:String, forced:Bool = false, ?reverse:Bool = false, ?startFrame:Int = 0)
	{
		animation.play(name, forced, reverse, startFrame);
		
		var daOffset = animOffsets.get(name);
		if (animOffsets.exists(name)) offset.set(daOffset[0], daOffset[1]);
	}
	
	public function addOffset(name:String, x:Float, y:Float)
	{
		animOffsets.set(name, [x, y]);
	}
	
	public function loadFrames(path:String)
	{
		frames = Paths.getSparrowAtlas(path);
		return this;
	}
	
	public function loadFromSheet(path:String, anim:String, fps:Int = 24)
	{
		frames = Paths.getSparrowAtlas(path);
		animation.addByPrefix(anim, anim, fps);
		animation.play(anim);
		if (animation.curAnim.numFrames == 1)
		{
			active = false;
		}
		
		return this;
	}
	
	public function makeScaledGraphic(width:Float = 1, height:Float = 1, color:FlxColor = FlxColor.WHITE)
	{
		makeGraphic(1, 1, color);
		scale.set(width, height);
		updateHitbox();
		return this;
	}
}