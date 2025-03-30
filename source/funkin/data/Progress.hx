package funkin.data;

//this is why we use a macro
class Progress {
    public static var isOneshotUnlocked(get,set):Bool;
    static function set_isOneshotUnlocked(value:Bool):Bool {
        FlxG.save.data.onshotUnlock = value;
        FlxG.save.flush();
        return value;
    }
	static function get_isOneshotUnlocked():Bool return (FlxG.save.data.onshotUnlock != null && FlxG.save.data.onshotUnlock);

    public static var isWebCrashed(get,set):Bool;
    static function set_isWebCrashed(value:Bool):Bool {
        FlxG.save.data.webCrashed = value;
        FlxG.save.flush();
        return value;
    }
	static function get_isWebCrashed():Bool return (FlxG.save.data.webCrashed != null && FlxG.save.data.webCrashed);

    public static var isDataReset(get,set):Bool;
    static function set_isDataReset(value:Bool):Bool {
        FlxG.save.data.isDataReset = value;
        FlxG.save.flush();
        return value;
    }
	static function get_isDataReset():Bool return (FlxG.save.data.isDataReset != null && FlxG.save.data.isDataReset);

    public static var isUnlockedSour(get,set):Bool;
    static function set_isUnlockedSour(value:Bool):Bool {
        FlxG.save.data.isUnlockedSour = value;
        FlxG.save.flush();
        return value;
    }
	static function get_isUnlockedSour():Bool return (FlxG.save.data.isUnlockedSour != null && FlxG.save.data.isUnlockedSour);

    public static var isUnlockedHatty(get,set):Bool;
    static function set_isUnlockedHatty(value:Bool):Bool {
        FlxG.save.data.isUnlockedHatty = value;
        FlxG.save.flush();
        return value;
    }
	static function get_isUnlockedHatty():Bool return (FlxG.save.data.isUnlockedHatty != null && FlxG.save.data.isUnlockedHatty);
}