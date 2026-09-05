import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;

var songName = SONG.meta.name.toLowerCase();

function postCreate() {
	window.title = "Friday Night Funkin': Electronic Escapades - " + songName;
	PauseSubState.script = 'data/states/elePause';
	allowGitaroo = false;

	comboGroup.setPosition(FlxG.width / 2 - 55, 70);

	healthBG = new FlxSprite().loadGraphic(Paths.image("game/eleHealthbar"));
	healthBG.cameras = [camHUD];
	insert(members.indexOf(healthBar) + 1, healthBG);
	healthBG.y = 571;
	healthBG.x = 230;

	healthBarBG.scale.set(0, 0);
	healthBarBG.alpha = 0;
	PlayState.instance.comboGroup.visible = false;

	healthBar.numDivisions = 10000;

	remove(accuracyTxt);
	missesTxt.alignment = "left";
	for (i in [scoreTxt, missesTxt]) {
		if (songName == 'off-the-pufferfish') {
			i.setFormat(Paths.font("minecraft.ttf"), 16, null, null, FlxTextBorderStyle.OUTLINE, 0xFF000000);
			i.y += 10;
		} else {
			i.setFormat(Paths.font("zerohour.ttf"), 16, null, null, FlxTextBorderStyle.OUTLINE, 0xFF000000);
			i.y += 12;
		}
		insert(0, i);
	}

    	if (downscroll) {
        	healthBar.y = 616;
		iconP1.y = 550;
		iconP2.y = 550;
    }

	if (!hudVisible)
		for (i in [healthBG, healthBar, scoreTxt, missesTxt])
			i.visible = false;
}

function onCountdown(event:CountdownEvent)
	event.cancel();

function postUpdate() {
	var offset = -35;
	iconP1.x = healthBar.x + healthBar.width + offset;
	iconP2.x = healthBar.x - iconP2.width - offset;

	comboGroup.forEachAlive(function(spr) {
		if (spr.camera != camHUD)
			spr.camera = camHUD;
		if (spr.acceleration.y != 0) {
			spr.acceleration.y = 0;
			spr.velocity.set(0, 0);
			FlxTween.cancelTweensOf(spr);
			var randomScale:Float = FlxG.random.float(0.7, 1);
			FlxTween.tween(spr, {'scale.x': spr.scale.x * randomScale, 'scale.y': spr.scale.x * randomScale}, FlxG.random.float(.075, .125), {
				ease: FlxEase.sineInOut,
				onComplete: (_) -> {
					FlxTween.tween(spr, {
						'scale.x': spr.scale.x * .4,
						'scale.y': spr.scale.x * .4,
						alpha: 0,
						angle: FlxG.random.float(0, 0) * FlxG.random.sign()
					}, .1 + FlxG.random.float(.255, .255), {
						ease: FlxEase.sineInOut,
						onComplete: (_) -> {
							spr.kill();
						}
					});
				}
			});
		}
	});
}
