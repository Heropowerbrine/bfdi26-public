package funkin.psychlua;

import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;
import flixel.addons.ui.FlxUIGroup;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import openfl.display.BlendMode;
import flixel.util.FlxAxes;
import flixel.addons.display.FlxRuntimeShader;
import flixel.system.FlxAssets.FlxShader;
import funkin.objects.Character;
import funkin.psychlua.LuaUtils;
import funkin.utils.CoolUtil;
import funkin.psychlua.CustomSubstate;
#if LUA_ALLOWED
import funkin.psychlua.FunkinLua;
#end
#if HSCRIPT_ALLOWED
import crowplexus.iris.IrisConfig;
#end

class HScript extends Iris
{
	public var filePath:String;
	public var modFolder:String;
	
	public static function setIrisLogger()
	{
		Iris.warn = (x, ?pos) -> {
			PlayState.instance?.addTextToDebug('[${pos.fileName}]: ${pos.lineNumber} -> $x', FlxColor.YELLOW);
			
			Iris.logLevel(ERROR, x, pos);
		}
		
		Iris.fatal = (x, ?pos) -> {
			trace('fatalerr');
		}
		
		Iris.error = (x, ?pos) -> {
			PlayState.instance?.addTextToDebug('[${pos.fileName}]: ${pos.lineNumber} -> $x', FlxColor.RED);
			
			Iris.logLevel(ERROR, x, pos);
		}
		
		Iris.print = (x, ?pos) -> {
			PlayState.instance?.addTextToDebug('[${pos.fileName}]: ${pos.lineNumber} -> $x', FlxColor.WHITE);
			
			Iris.logLevel(NONE, x, pos);
		}
	}
	
	#if LUA_ALLOWED
	public var parentLua:FunkinLua;
	
	public static function initHaxeModule(parent:FunkinLua)
	{
		if (parent.hscript == null)
		{
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript = new HScript(parent);
		}
	}
	
	public static function initHaxeModuleCode(parent:FunkinLua, code:String, ?varsToBring:Any = null)
	{
		var hs:HScript = try parent.hscript catch (e) null;
		if (hs == null)
		{
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript = new HScript(parent, code, varsToBring);
		}
		else
		{
			try
			{
				hs.scriptCode = code;
				hs.varsToBring = varsToBring;
				hs.parse(true);
				hs.execute();
			}
			catch (e:Dynamic)
			{
				FunkinLua.luaTrace('ERROR (${hs.origin}) - $e', false, false, FlxColor.RED);
			}
		}
	}
	#end
	
	public var origin:String;
	
	public function new(?parent:Dynamic, ?file:String, ?varsToBring:Any = null,manual:Bool = false)
	{
		if (file == null) file = '';
		
		filePath = file;
		if (filePath != null && filePath.length > 0)
		{
			this.origin = filePath;
			#if MODS_ALLOWED
			var myFolder:Array<String> = filePath.split('/');
			if (myFolder[0] + '/' == Paths.mods()
				&& (Mods.currentModDirectory == myFolder[1] || Mods.getGlobalMods().contains(myFolder[1]))) // is inside mods folder
				this.modFolder = myFolder[1];
			#end
		}
		var scriptThing:String = file;
		var scriptName:String = null;
		if (parent == null && file != null)
		{
			var f:String = file.replace('\\', '/');
			if (f.contains('/') && !f.contains('\n'))
			{
				scriptThing = File.getContent(f);
				scriptName = f;
			}
		}
		#if LUA_ALLOWED
		if (scriptName == null && parent != null) scriptName = parent.scriptName;
		#end
		this.varsToBring = varsToBring;
		super(scriptThing, new IrisConfig(scriptName, false, false));
		
		this.interp = new funkin.psychlua.InterpEx();
		this.interp.showPosOnLog = false;
		cast(this.interp, funkin.psychlua.InterpEx).parentInstance = FlxG.state;
		
		#if LUA_ALLOWED
		parentLua = parent;
		if (parent != null)
		{
			this.origin = parent.scriptName;
			this.modFolder = parent.modFolder;
		}
		#end
		
		preset();
		if (!manual)
			execute();
	}
	
	var varsToBring:Any = null;
	
	override function preset()
	{
		super.preset();
		
		// Some very commonly used classes
		set('FlxText', flixel.text.FlxText);
		set('FlxG', flixel.FlxG);
		set('FlxMath', flixel.math.FlxMath);
		set('FlxSprite', ModchartSprite);
		set('FlxCamera', flixel.FlxCamera);
		set('PsychCamera', funkin.backend.PsychCamera);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxColor', CustomFlxColor);
		set('Countdown', funkin.backend.BaseStage.Countdown);
		set('PlayState', PlayState);
		set('Paths', Paths);
		set('Conductor', Conductor);
		set('ClientPrefs', ClientPrefs);
		#if ACHIEVEMENTS_ALLOWED
		set('Achievements', Achievements);
		#end
		set('Character', Character);
		set('Alphabet', Alphabet);
		set('Note', funkin.objects.Note);
		set('CustomSubstate', CustomSubstate);
		#if (!flash && sys)
		set('FlxRuntimeShader', FlxRuntimeShader);
		#end
		set('ShaderFilter', openfl.filters.ShaderFilter);
		set('StringTools', StringTools);
		#if flxanimate
		set('FlxAnimate', FlxAnimate);
		#end

		set('FlxObjectTools', FlxObjectTools);
		
		#if VIDEOS_ALLOWED
		set('FlxVideo', FlxVideo);
		set('FlxVideoSprite', FlxVideoSprite);
		set('Video4', funkin.objects.Video4);
		#end

		set('ColorSwap', shaders.ColorSwap);

		set('FlxBitmapText', FlxBitmapText);
		set('FlxBitmapFont', FlxBitmapFont);
		
		//set('FlxContainer', flixel.group.FlxContainer);
		set('FlxSpriteGroup', FlxSpriteGroup);
		set('FlxUIGroup', FlxUIGroup);
		
		set('FlxPoint',flixel.math.FlxPoint.FlxBasePoint);
		set('betterLerp',CoolUtil.betterLerp);
		
		// Functions & Variables
		set('setVar', function(name:String, value:Dynamic) {
			PlayState.instance.variables.set(name, value);
			return value;
		});
		set('getVar', function(name:String) {
			var result:Dynamic = null;
			if (PlayState.instance.variables.exists(name)) result = PlayState.instance.variables.get(name);
			return result;
		});
		set('removeVar', function(name:String) {
			if (PlayState.instance.variables.exists(name))
			{
				PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
		set('debugPrint', function(text:String, ?color:FlxColor = null) {
			if (color == null) color = FlxColor.WHITE;
			PlayState.instance.addTextToDebug(text, color);
		});
		set('getModSetting', function(saveTag:String, ?modName:String = null) {
			if (modName == null)
			{
				if (this.modFolder == null)
				{
					PlayState.instance.addTextToDebug('getModSetting: Argument #2 is null and script is not inside a packed Mod folder!', FlxColor.RED);
					return null;
				}
				modName = this.modFolder;
			}
			return LuaUtils.getModSetting(saveTag, modName);
		});
		
		// Keyboard & Gamepads
		set('keyboardJustPressed', function(name:String) return Reflect.getProperty(FlxG.keys.justPressed, name));
		set('keyboardPressed', function(name:String) return Reflect.getProperty(FlxG.keys.pressed, name));
		set('keyboardReleased', function(name:String) return Reflect.getProperty(FlxG.keys.justReleased, name));
		
		set('anyGamepadJustPressed', function(name:String) return FlxG.gamepads.anyJustPressed(name));
		set('anyGamepadPressed', function(name:String) FlxG.gamepads.anyPressed(name));
		set('anyGamepadReleased', function(name:String) return FlxG.gamepads.anyJustReleased(name));
		
		set('gamepadAnalogX', function(id:Int, ?leftStick:Bool = true) {
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return 0.0;
			
			return controller.getXAxis(leftStick ? LEFT_ANALOG_STICK : RIGHT_ANALOG_STICK);
		});
		set('gamepadAnalogY', function(id:Int, ?leftStick:Bool = true) {
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return 0.0;
			
			return controller.getYAxis(leftStick ? LEFT_ANALOG_STICK : RIGHT_ANALOG_STICK);
		});
		set('gamepadJustPressed', function(id:Int, name:String) {
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;
			
			return Reflect.getProperty(controller.justPressed, name) == true;
		});
		set('gamepadPressed', function(id:Int, name:String) {
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;
			
			return Reflect.getProperty(controller.pressed, name) == true;
		});
		set('gamepadReleased', function(id:Int, name:String) {
			var controller = FlxG.gamepads.getByID(id);
			if (controller == null) return false;
			
			return Reflect.getProperty(controller.justReleased, name) == true;
		});
		
		set('keyJustPressed', function(name:String = '') {
			name = name.toLowerCase();
			switch (name)
			{
				case 'left':
					return Controls.instance.NOTE_LEFT_P;
				case 'down':
					return Controls.instance.NOTE_DOWN_P;
				case 'up':
					return Controls.instance.NOTE_UP_P;
				case 'right':
					return Controls.instance.NOTE_RIGHT_P;
				default:
					return Controls.instance.justPressed(name);
			}
			return false;
		});
		set('keyPressed', function(name:String = '') {
			name = name.toLowerCase();
			switch (name)
			{
				case 'left':
					return Controls.instance.NOTE_LEFT;
				case 'down':
					return Controls.instance.NOTE_DOWN;
				case 'up':
					return Controls.instance.NOTE_UP;
				case 'right':
					return Controls.instance.NOTE_RIGHT;
				default:
					return Controls.instance.pressed(name);
			}
			return false;
		});
		set('keyReleased', function(name:String = '') {
			name = name.toLowerCase();
			switch (name)
			{
				case 'left':
					return Controls.instance.NOTE_LEFT_R;
				case 'down':
					return Controls.instance.NOTE_DOWN_R;
				case 'up':
					return Controls.instance.NOTE_UP_R;
				case 'right':
					return Controls.instance.NOTE_RIGHT_R;
				default:
					return Controls.instance.justReleased(name);
			}
			return false;
		});
		
		// For adding your own callbacks
		// not very tested but should work
		#if LUA_ALLOWED
		set('createGlobalCallback', function(name:String, func:Dynamic) {
			for (script in PlayState.instance.luaArray) if (script != null && script.lua != null && !script.closed) Lua_helper.add_callback(script.lua, name, func);
			
			FunkinLua.customFunctions.set(name, func);
		});
		
		// this one was tested
		set('createCallback', function(name:String, func:Dynamic, ?funk:FunkinLua = null) {
			if (funk == null) funk = parentLua;
			
			if (parentLua != null) funk.addLocalCallback(name, func);
			else FunkinLua.luaTrace('createCallback ($name): 3rd argument is null', false, false, FlxColor.RED);
		});
		#end
		
		set('addHaxeLibrary', function(libName:String, ?libPackage:String = '') {
			try
			{
				var str:String = '';
				if (libPackage.length > 0) str = libPackage + '.';
				
				set(libName, Type.resolveClass(str + libName));
			}
			catch (e:Dynamic)
			{
				var msg:String = e.message.substr(0, e.message.indexOf('\n'));
				#if LUA_ALLOWED
				if (parentLua != null)
				{
					FunkinLua.lastCalledScript = parentLua;
					FunkinLua.luaTrace('$origin: ${parentLua.lastCalledFunction} - $msg', false, false, FlxColor.RED);
					return;
				}
				#end
				if (PlayState.instance != null) PlayState.instance.addTextToDebug('$origin - $msg', FlxColor.RED);
				else trace('$origin - $msg');
			}
		});
		#if LUA_ALLOWED
		set('parentLua', parentLua);
		#else
		set('parentLua', null);
		#end
		set('this', this);
		set('game', FlxG.state);
		
		set('buildTarget', LuaUtils.getBuildTarget());
		set('customSubstate', CustomSubstate.instance);
		set('customSubstateName', CustomSubstate.name);
		
		set('Function_Stop', LuaUtils.Function_Stop);
		set('Function_Continue', LuaUtils.Function_Continue);
		set('Function_StopLua', LuaUtils.Function_StopLua); // doesnt do much cuz HScript has a lower priority than Lua
		set('Function_StopHScript', LuaUtils.Function_StopHScript);
		set('Function_StopAll', LuaUtils.Function_StopAll);
		
		set('add', FlxG.state.add);
		set('insert', FlxG.state.insert);
		set('remove', FlxG.state.remove);
		
		if (PlayState.instance == FlxG.state)
		{
			set('addBehindGF', PlayState.instance.addBehindGF);
			set('addBehindDad', PlayState.instance.addBehindDad);
			set('addBehindBF', PlayState.instance.addBehindBF);
		}
		
		if (varsToBring != null)
		{
			for (key in Reflect.fields(varsToBring))
			{
				key = key.trim();
				var value = Reflect.field(varsToBring, key);
				set(key, Reflect.field(varsToBring, key));
			}
			varsToBring = null;
		}
	}
	
	public function executeCode(?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null):IrisCall
	{
		if (funcToRun == null) return null;
		
		if (!exists(funcToRun))
		{
			#if LUA_ALLOWED
			FunkinLua.luaTrace(origin + ' - No function named: $funcToRun', false, false, FlxColor.RED);
			#else
			PlayState.instance.addTextToDebug(origin + ' - No function named: $funcToRun', FlxColor.RED);
			#end
			return null;
		}
		
		try
		{
			final callValue:IrisCall = call(funcToRun, funcArgs);
			return callValue;
		}
		catch (e:Dynamic)
		{
			trace('ERROR ${funcToRun}: $e');
		}
		return null;
	}
	
	#if LUA_ALLOWED
	public static function implement(funk:FunkinLua)
	{
		funk.addLocalCallback("runHaxeCode", function(codeToRun:String, ?varsToBring:Any = null, ?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null):Dynamic {
			#if HSCRIPT_ALLOWED
			initHaxeModuleCode(funk, codeToRun, varsToBring);
			try
			{
				final retVal:IrisCall = funk.hscript.executeCode(funcToRun, funcArgs);
				if (retVal != null)
				{
					return (retVal.returnValue == null
						|| LuaUtils.isOfTypes(retVal.returnValue, [Bool, Int, Float, String, Array])) ? retVal.returnValue : null;
				}
			}
			catch (e:Dynamic)
			{
				FunkinLua.luaTrace('ERROR (${funk.hscript.origin}: $funcToRun) - $e', false, false, FlxColor.RED);
			}
			#else
			FunkinLua.luaTrace("runHaxeCode: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
			return null;
		});
		
		funk.addLocalCallback("runHaxeFunction", function(funcToRun:String, ?funcArgs:Array<Dynamic> = null) {
			#if HSCRIPT_ALLOWED
			try
			{
				final retVal:IrisCall = funk.hscript.call(funcToRun, funcArgs);
				if (retVal != null)
				{
					return (retVal.returnValue == null
						|| LuaUtils.isOfTypes(retVal.returnValue, [Bool, Int, Float, String, Array])) ? retVal.returnValue : null;
				}
			}
			catch (e:Dynamic)
			{
				FunkinLua.luaTrace('ERROR (${funk.hscript.origin}: $funcToRun) - $e', false, false, FlxColor.RED);
			}
			return null;
			#else
			FunkinLua.luaTrace("runHaxeFunction: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			return null;
			#end
		});
		// This function is unnecessary because import already exists in Hscript as a native feature
		funk.addLocalCallback("addHaxeLibrary", function(libName:String, ?libPackage:String = '') {
			var str:String = '';
			if (libPackage.length > 0) str = libPackage + '.';
			else if (libName == null) libName = '';
			
			var c:Dynamic = Type.resolveClass(str + libName);
			if (c == null) c = Type.resolveEnum(str + libName);
			
			#if HSCRIPT_ALLOWED
			if (funk.hscript != null)
			{
				try
				{
					if (c != null) funk.hscript.set(libName, c);
				}
				catch (e:Dynamic)
				{
					FunkinLua.luaTrace(funk.hscript.origin + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
				}
			}
			#else
			FunkinLua.luaTrace("addHaxeLibrary: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
		});
	}
	#end
	
	override public function destroy()
	{
		origin = null;
		#if LUA_ALLOWED parentLua = null; #end
		
		super.destroy();
	}
}

class CustomFlxColor
{
	public static var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	public static var BLACK(default, null):Int = FlxColor.BLACK;
	public static var WHITE(default, null):Int = FlxColor.WHITE;
	public static var GRAY(default, null):Int = FlxColor.GRAY;
	
	public static var GREEN(default, null):Int = FlxColor.GREEN;
	public static var LIME(default, null):Int = FlxColor.LIME;
	public static var YELLOW(default, null):Int = FlxColor.YELLOW;
	public static var ORANGE(default, null):Int = FlxColor.ORANGE;
	public static var RED(default, null):Int = FlxColor.RED;
	public static var PURPLE(default, null):Int = FlxColor.PURPLE;
	public static var BLUE(default, null):Int = FlxColor.BLUE;
	public static var BROWN(default, null):Int = FlxColor.BROWN;
	public static var PINK(default, null):Int = FlxColor.PINK;
	public static var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	public static var CYAN(default, null):Int = FlxColor.CYAN;
	
	public static function fromInt(Value:Int):Int
	{
		return cast FlxColor.fromInt(Value);
	}
	
	public static function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
	{
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);
	}
	
	public static function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);
	}
	
	public static inline function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}
	
	public static function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);
	}
	
	public static function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);
	}
	
	public static function fromString(str:String):Int
	{
		return cast FlxColor.fromString(str);
	}
}

#if HSCRIPT_ALLOWED
class InterpEx extends crowplexus.hscript.Interp
{
	override function makeIterator(v:Dynamic):Iterator<Dynamic>
	{
		#if ((flash && !flash9) || (php && !php7 && haxe_ver < '4.0.0'))
		if (v.iterator != null) v = v.iterator();
		#else
		// DATA CHANGE //does a null check because this crashes on debug build
		if (v.iterator != null) try
			v = v.iterator()
		catch (e:Dynamic) {};
		#end
		if (v.hasNext == null || v.next == null) error(EInvalidIterator(v));
		return v;
	}
	
	// direct access to state vars
	// parent
	public var parentInstance:Dynamic;
	
	override function resolve(id:String):Dynamic
	{
		if (locals.exists(id))
		{
			var l = locals.get(id);
			return l.r;
		}
		
		if (variables.exists(id))
		{
			var v = variables.get(id);
			return v;
		}
		
		if (imports.exists(id))
		{
			var v = imports.get(id);
			return v;
		}
		
		if (parentInstance != null)
		{
			var v = Reflect.getProperty(parentInstance, id);
            if (v != null) return v;
		}
		
		error(EUnknownVariable(id));
		
		return null;
	}
}
#end