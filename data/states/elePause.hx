import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText.FlxTextAlign as Align;
import flixel.text.FlxText.FlxTextBorderStyle as Border;
import funkin.backend.system.framerate.Framerate;

var pauseCam:FlxCamera;
var pauseMusic:FlxSound;
var bg:FlxSprite;
var backdrop:FlxSprite;
var bgplate:FlxSprite;
var fgplate:FlxSprite;
var art:FlxSprite;
var songName = PlayState.SONG.meta.name.toLowerCase();
var pauseNoise:FlxSound = FlxG.sound.load(Paths.sound("pause/pauseNoise"));
var resumeTxt:FunkinText;
var restartTxt:FunkinText;
var controlsTxt:FunkinText;
var optionsTxt:FunkinText;
var exitTxt:FunkinText;
var coolOptions:Array<String>;
var coolTextGroup:FlxTypedGroup<FunkinText>;
var levelInfo:FlxText;
var deathCounter:FlxText = new FunkinText(20, 15, 0, "Fails: " + PlayState.deathCounter, 32);
var countdownTimer:FlxText = new FunkinText(20, 15, 0, "0", 82);

function create(event) {
	coolOptions = event.options;
	event.cancel();

	cameras = [];

	pauseCam = new FlxCamera();
	pauseCam.bgColor = 0;

	bg = new FlxBackdrop(Paths.image('menus/pause/checkers'));
	bg.scale.set(3, 3);
	bg.velocity.x = 100;
	bg.alpha = 0.4;

	

	if (Framerate.instance.visible)
		FlxTween.tween(Framerate.instance, {alpha: 1}, 0.4, {
			onComplete: function(twn) {
				Framerate.debugMode = 0;
			}
		});

	FlxG.cameras.add(pauseCam, false);

	cameras = [pauseCam];

	var imagePath:String = 'menus/pause/portraits/' + songName;
	if (!Assets.exists(Paths.image(imagePath, null, true))) { // hoping this works
		imagePath = 'menus/pause/placeholder';
	}

	backdrop = new FlxSprite().loadGraphic(Paths.image('menus/pause/backdrop'));
	backdrop.setGraphicSize(FlxG.width * 1);
	backdrop.antialiasing = true;
	backdrop.x -= 320;
	backdrop.y -= 180;

	fgplate = new FlxSprite().loadGraphic(Paths.image('menus/pause/platefront'));
	fgplate.antialiasing = true;
	fgplate.scale.set(1, 1);
	fgplate.y -= 280;
	fgplate.x -= 623;

	bgplate = new FlxSprite().loadGraphic(Paths.image('menus/pause/plateback'));
	bgplate.antialiasing = true;
	bgplate.scale.set(0.8, 0.8);
	bgplate.x -= 365;
	bgplate.y -= 120;

	art = new FlxSprite().loadGraphic(Paths.image(imagePath));
	art.setGraphicSize(FlxG.width * 1);
	art.antialiasing = true;
	art.alpha = 0.001;
	art.cameras = [pauseCam];
	art.screenCenter();
	var artCenterPos = art.x;
	art.x += 200;

	if (songName == 'off-the-pufferfish' && FlxG.random.bool(13.72)) {
		art.loadGraphic(Paths.image('menus/pause/portraits/fuckinghelpme'));
	}
	if (FlxG.random.bool(1)) {
		art.loadGraphic(Paths.image('menus/pause/portraits/theytoldmetostopaddingsecrets'));
	}

	coolTextGroup = new FlxTypedGroup();

	for (i in 0...coolOptions.length) {
		var tempText:FunkinText;
		if (!PlayState.instance.inCutscene) {
			tempText = new FunkinText(0, 0, 1500, switch (i) {
				case 0: "Resume";
				case 1: "Restart";
				case 2: "Controls";
				case 3: "Options";
				case 4: "Exit";
				case 5: "Charter";
				default: "hi there";
			}, 14);
		} else {
			tempText = new FunkinText(0, 0, 1500, switch (i) {
				case 0: "Resume";
				case 1: "Skip";
				case 2: "Restart";
				case 3: "Exit";
				default: "hi there";
			}, 14);
		}

		tempText.setFormat(Paths.font("zerohour.ttf"), 48, 0xB17C3D, null, Border.OUTLINE, FlxColor.BLACK);
		tempText.borderSize = 3;
		tempText.borderQuality = 6;
		tempText.ID = i;
		coolTextGroup.add(tempText);
	}

	for (i in [bg, bgplate, backdrop, fgplate])
		i.cameras = [pauseCam];
		coolTextGroup.cameras = [pauseCam];

	add(bg);
	add(bgplate);
	add(art);
	add(fgplate);
	add(backdrop);
	add(coolTextGroup);

	for (text in [resumeTxt, restartTxt, controlsTxt, optionsTxt, exitTxt]) {
		add(text);
	}

	var stuffArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('states/songCredits'));
	if (stuffArray.contains(''))
		stuffArray.remove('');
	for (i in 0...stuffArray.length) {
		wat = stuffArray[i].split('--');
		if (wat[0] == songName) {
			levelInfo = new FunkinText(20, 15, 0, wat[0] + " - " + wat[1], 32);
		}
		if (levelInfo == null) {
			levelInfo = new FunkinText(20, 15, 0, songName, 32);
		}
	}

	// ------------------ DYNAMIC LEVELINFO FIX ------------------
	for (k => label in [levelInfo, deathCounter]) {
		if (songName.toLowerCase() == 'off-the-pufferfish') {
			label.setFormat(Paths.font("minecraft.ttf"), 20, FlxColor.WHITE, Align.RIGHT, Border.OUTLINE, 0xFF301E05);
			label.borderSize = 1.5;
		} else {
			label.setFormat(Paths.font("zerohour.ttf"), 20, 0xB17C3D, Align.RIGHT, Border.OUTLINE, FlxColor.BLACK);
			label.borderSize = 1.5;
		}
		label.borderQuality = 6;
		label.alpha = 0;
		label.x = 20;
		label.y = 50 + (40 * k);

		FlxTween.tween(label, {alpha: 1, y: label.y - 10}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.6 + (0.45 * k)});
		add(label);
	}
	// ------------------------------------------------------------

	countdownTimer.setFormat(Paths.font("zerohour.ttf"), 82, 0xB17C3D, null, Border.OUTLINE, 0xFF000000);
	countdownTimer.borderSize = 2;
	countdownTimer.borderQuality = 6;
	countdownTimer.screenCenter();
	countdownTimer.visible = false;
	add(countdownTimer);

	// animations
	pauseNoise.play(true);
	FlxTween.tween(bg, {alpha: 0.4}, 0.4, {
		onComplete: function() {
			FlxTween.tween(art, {x: artCenterPos, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
		}
	});

	changeSelection(0, true);
}

var active = true;
var timer = 3;

function onSelectOption(event) {
	if (FlxG.save.data.ele_nocountdown)
		return;

	if (curSelected == 0 && !PlayState.instance.inCutscene) {
		event.cancel();
		active = false;
		
	if (pauseNoise.playing){
		pauseNoise.stop();
	}

		FlxTween.tween(bg, {alpha: 0}, (Conductor.crochet / 1000) * 1.5);
		FlxTween.tween(bgplate, {y: -200, alpha: 0},(Conductor.crochet / 1000) * 2, {ease: FlxEase.backIn});
		FlxTween.tween(backdrop, {x: -500 ,alpha: 0},(Conductor.crochet / 1000) * 2, {ease: FlxEase.quartIn});				
		FlxTween.tween(fgplate, {y: 300 ,alpha: 0},(Conductor.crochet / 1000) * 2, {ease: FlxEase.backIn});
		FlxTween.tween(art, {x: -200, alpha: 0}, (Conductor.crochet / 1000) * 2, {ease: FlxEase.cubeIn});
		for (k => label in [deathCounter, levelInfo]) {
			FlxTween.tween(label, {alpha: 0, x: -100}, (Conductor.crochet / 1000), {ease: FlxEase.quartIn});
		}

		coolTextGroup.visible = false;
		countdownTimer.visible = true;
		countdownTimer.text = "3";
		FlxG.sound.play(Paths.sound("pause/pauseTick" + timer), 0.5);
		new FlxTimer().start((Conductor.stepCrochet / 1000) * 4, function(tmr) {
			timer -= 1;

			if (timer == 0) {
				close();
				return;
			}

			FlxG.sound.play(Paths.sound("pause/pauseTick" + timer), 0.5);
			countdownTimer.text = timer;
		}, 3);
	}
}

function update(elapsed) {
	for (i in 0...coolTextGroup.members.length) {
		var text = coolTextGroup.members[i];
		text.setPosition(20, 170 + ((coolTextGroup.members.length >= 6 ? 60 : 70) * i));
	}

	if (!active)
		return;

	if (controls.DOWN_P)
		changeSelection(1, false);
	if (controls.UP_P)
		changeSelection(-1);
	if (controls.ACCEPT) {
		if (curSelected != 4 && !PlayState.instance.inCutscene)
			selectOption();
		if ((curSelected != 3 && curSelected != 2) && PlayState.instance.inCutscene)
			selectOption();

		if (curSelected == 0 || curSelected == 1) {
			if (Framerate.instance.visible) {
				FlxTween.cancelTweensOf(Framerate.instance);
				Framerate.debugMode = 1;
			}
		} else if (curSelected == 4 || (curSelected == 3 && PlayState.instance.inCutscene)) {
			Framerate.instance.visible = true;
			Framerate.debugMode = 1;
			FlxG.switchState(new FreeplayState());
		} else if (curSelected == 2 && PlayState.instance.inCutscene) {
			FlxG.resetState();
		}
	}
}

function destroy() {
	if (FlxG.cameras.list.contains(pauseCam))
		FlxG.cameras.remove(pauseCam);

	pauseNoise.stop();
}

var scrollSound:FlxSound = FlxG.sound.load(Paths.sound("menu/scroll"));

scrollSound.volume = 0.5;
function changeSelection(change, ?mute:Bool = false) {
	scrollSound.pitch = FlxG.random.float(0.99, 1.02);
	if (!mute)
		scrollSound.play(true);

	curSelected += change;

	if (curSelected < 0)
		curSelected = menuItems.length - 1;
	if (curSelected >= menuItems.length)
		curSelected = 0;

	for (i in 0...coolTextGroup.members.length) {
		var text = coolTextGroup.members[i];
		if (i != curSelected) {
			text.alpha = 0.4;
		} else {
			text.alpha = 1;
		}
	}
}
