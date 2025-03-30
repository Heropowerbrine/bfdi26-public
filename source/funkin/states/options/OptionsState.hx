package funkin.states.options;

import funkin.data.StageData;

//i didnt code this
class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private static var curSelected:Int = 0;
	public static var onPlayState:Bool = false;

	private var optionText:FlxText;

	private var border:FlxSprite;


	private var optionsArray:Array<FlxText> = [];

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls':
				openSubState(new funkin.states.options.ControlsSubState());
			case 'Graphics':
				openSubState(new funkin.states.options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new funkin.states.options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new funkin.states.options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				FlxG.switchState(funkin.states.options.NoteOffsetState.new);
		}
	}

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end

		for (i in 0...options.length)
		{
			optionText = new FlxText(0, 0, 0, options[i], 32);
			optionText.setFormat(Paths.font("Digiface Regular.ttf"), 84, FlxColor.LIME, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			add(optionText);
			optionsArray.push(optionText);
		}

		border = new FlxSprite().loadImage('menus/border');
		border.scale.set(0.725, 0.725);
		border.screenCenter();
		add(border);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				FlxG.switchState(PlayState.new);
				FlxG.sound.music.volume = 0;
			}
			else FlxG.switchState(funkin.states.NewMain.new);
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(change:Int = 0) {
		var prevSelected = curSelected;
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;
		FlxG.sound.play(Paths.sound('scrollMenu'));

		if (curSelected >= 0 && curSelected < optionsArray.length) {
			optionsArray[curSelected].text = "< " + options[curSelected] + " >";
			optionsArray[curSelected].screenCenter(X);
		}

		if (prevSelected >= 0 && prevSelected < optionsArray.length) {
			optionsArray[prevSelected].text = options[prevSelected];
			optionsArray[prevSelected].screenCenter(X);
		}
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}