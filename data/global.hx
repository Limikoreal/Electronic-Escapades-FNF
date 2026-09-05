import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;
import hxvlc.util.Handle;

public static var inIntro:Bool = true;
public static var finishedSong:Bool = false;
public static var introMusic = FlxG.sound.load(Paths.music('freakyMenu'));
introMusic.persist = true;

function new() {
	if (FlxG.save.data.ele_nocountdown == null)
		FlxG.save.data.ele_nocountdown = false;

	Handle.init([]);
}

var redirectStates:Map<FlxState, String> = [
    MainMenuState => "ELEMainMenu",
	TitleState => "ELETitleScreen",
];

function preStateSwitch() {
	WindowUtils.winTitle = window.title = "Friday Night Funkin': Electronic Escapades";
	window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('game/icon'))));
	Main.framerateSprite.codenameBuildField.visible = false;
	Framerate.memoryCounter.memoryText.defaultTextFormat = Framerate.memoryCounter.memoryPeakText.defaultTextFormat = Framerate.fpsCounter.fpsNum.defaultTextFormat = Framerate.fpsCounter.fpsLabel.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('zerohour.ttf')),
		18, FlxColor.WHITE);
	FlxG.camera.bgColor = 0xFF000000;
    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function destroy()
	WindowUtils.winTitle = window.title = "Friday Night Funkin' - Codename Engine";

function update(elapsed) {
	if (FlxG.keys.justPressed.F5)
		FlxG.resetState();
}