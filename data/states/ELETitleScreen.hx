import funkin.backend.MusicBeatState;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.system.framerate.Framerate;

importScript("data/states/musicthingie");

var finished = false;
var transitioning = false;
var curWacky:Array<String> = [];
var introText:FlxSpriteGroup;

var Artwork:FlxSprite;
var bg:FlxSprite;
var ELElogo:FlxSprite;
var confirm:FlxText = new FlxText(250, 620, FlxG.width, "Press Enter to begin", 32, false).setFormat(Paths.font("zerohour.ttf"), 40, FlxColor.WHITE, 'center');
var boxthing:FlxSprite = new FlxSprite();
boxthing.makeGraphic(3000,3000,FlxColor.BLACK);

var daBeat = 0;
var daCrochet = (60/85);
var daStepCrochet = daCrochet / 4;

function create() {
	playLoopedSong();
	FlxG.mouse.visible = true;
    trace("testing testing");
	window.title = "";

   // confirm.alpha = 0.5;
	confirm.alpha = 0.001;

    bg = new FlxBackdrop(Paths.image('menus/mainmenu/bg'));
    bg.scale.set(1.2, 1.2);
    bg.velocity.x =50;
	bg.alpha =0.001;

    Artwork = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/titlescreen/KatelynNKai'));
    Artwork.scale.set(0.37,0.37);
    Artwork.antialiasing = true;
	Artwork.alpha = 0.001;
	Artwork.updateHitbox();


    ELElogo = new FlxSprite(0,0);
    ELElogo.frames = Paths.getSparrowAtlas('menus/titlescreen/ELElogo');
    ELElogo.animation.addByPrefix("idle", "logo bumpin", 24, true);
    ELElogo.animation.play("idle");
    ELElogo.scale.set(0.55, 0.55);
    ELElogo.x-= -440;
    ELElogo.y-= -1000;
	ELElogo.antialiasing = true;
	ELElogo.alpha = 0.001;

	introText = new FlxSpriteGroup();

	add(introText);
    add(bg);
    add(ELElogo);
    add(confirm);
	add(boxthing);

	var introTextArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('states/introText'));
	if (introTextArray.contains('')) introTextArray.remove('');
	curWacky = introTextArray[FlxG.random.int(0, introTextArray.length-1)].split('--');

	looper = new FlxTimer().start((60 / 85), function(tmr:FlxTimer)
		{
			daBeat += 1;
			if(!finished){
				trace ("does this work" + daBeat);
				switch (daBeat)
				{
					case 1: FlxTween.tween(boxthing,{alpha: 0}, 1.5);
					case 2:	FlxTween.tween(boxthing,{alpha: 0.3}, 1.5);
					case 5:	
						if (FlxG.random.bool(0.1989)) textAdd(['Defunct', 'Inc.']);
							else textAdd(['ELE', 'Team']);
					case 7: textAdd(['Presents']);
					case 9: textRemove();
					case 10: textAdd(['Absolutely no affiliation with']);
					case 12: textAdd(['newgorounds']);
					case 14: textRemove();
					case 15: textAdd([curWacky[0]]);
					case 16: textAdd([curWacky[1]]);
					case 17: textRemove();
					case 19: textAdd(['Electronic']); FlxTween.tween(FlxG.camera,{zoom: FlxG.camera.zoom + 0.05}, 0.2, {ease: FlxEase.cubeOut}); FlxTween.tween(boxthing,{alpha: 0.5}, 1);
					case 20: textAdd(['Escapades']); FlxTween.tween(FlxG.camera,{zoom: FlxG.camera.zoom + 0.05}, 0.2, {ease: FlxEase.cubeOut});
					case 21: if (!finished) finishIntro();
				}
			}
		},0);

}

function textAdd(lines:Array<String>) {
	FlxG.sound.play(Paths.sound('menu/scroll'), 1);
	for (line in lines) {
		var lastHeight:Float = CoolUtil.last(introText.members) == null ? 0 : CoolUtil.last(introText.members).height;
		var text:FlxText = new FlxText(0, 125 + (lastHeight*(introText.length)), FlxG.width, line, 16, false);
        text.setFormat(Paths.font("zerohour.ttf"), 92, null, 'center');
        text.antialiasing = true;
		introText.add(text);
	}
}
function textRemove() {
	while (introText.members.length > 0) {
		introText.members[0].destroy();
		introText.remove(introText.members[0], true);
	}
}

function selectStuff() {
    FlxTween.tween(confirm, {y: 1000, alpha: 0},(Conductor.crochet / 1000) * 1, {ease: FlxEase.backIn});
    FlxTween.tween(Artwork, {x:-1000, alpha: 0},(Conductor.crochet / 1000) * 1, {ease: FlxEase.backIn});
	FlxTween.tween(ELElogo, {y:-1000, alpha: 0},(Conductor.crochet / 1000) * 1, {ease: FlxEase.backIn});	
    FlxG.sound.play(Paths.sound('menu/confirm'), 1);
        new FlxTimer().start(0.7, function(_) {    
        FlxG.switchState(new ModState("ELEMainMenu"));
    });
}

function finishIntro(){
  	add(Artwork);	
	finished = true;
	boxthing.kill();
	FlxTween.cancelTweensOf(FlxG.camera);
	FlxTween.cancelTweensOf(boxthing);	

	window.title = "Electronic Escapades - Press Enter to Begin";
	trace ("yes it does!");

	FlxTween.tween(FlxG.camera,{zoom: 1}, 1, {ease: FlxEase.cubeOut}); FlxTween.tween(boxthing,{alpha: 0}, 0.1);
	
	for(i=>introText in introText.members){
		FlxTween.tween(introText, {y: introText.y + 550}, 1.3, {ease: FlxEase.sineIn, startDelay: 0.03 * i});
		FlxTween.num(1,0.4,2,{ease: FlxEase.cubeInOut, startDelay: 0.05 * i}, function(num){
			introText.scale.set(num,num);
		});
	}

	FlxTween.tween(bg, {alpha: 1}, (Conductor.crochet / 1000) * 0.1);
	FlxTween.tween(Artwork, {alpha: 1}, (Conductor.crochet / 1000) * 1);
	FlxTween.tween(ELElogo, {y: -100, angle: 0, alpha: 1}, (Conductor.crochet / 1000) * 1, {ease: FlxEase.cubeOut});
	FlxTween.tween(confirm, {alpha: 0.5}, (Conductor.crochet / 1000) * 0.1);
}

function heythere() {
	add(Artwork);
	trace("wow, that was fast!");
    finished = true;
	transitioning = true;
    introText.visible = false;
	window.title = "Electronic Escapades - Press Enter to Begin";	
	
	FlxTween.tween(FlxG.camera,{zoom: 1}, 1, {ease: FlxEase.cubeOut}); FlxTween.tween(boxthing,{alpha: 0}, 0.001);
	FlxTween.tween(bg, {alpha: 1}, (Conductor.crochet / 1000) * 0.1);
	FlxTween.tween(Artwork, {alpha: 1}, (Conductor.crochet / 1000) * 0.1);
	FlxTween.tween(ELElogo, {y: -100, angle: 0, alpha: 1}, (Conductor.crochet / 1000) * 1, {ease: FlxEase.cubeOut});
	FlxTween.tween(confirm, {alpha: 0.5}, (Conductor.crochet / 1000) * 0.1);
}

function update(elapsed:Float){
	 if (FlxG.keys.justPressed.ENTER && !finished && !transitioning) {
        heythere();
    }
    else if (FlxG.keys.justPressed.ENTER && finished) {
        selectStuff();
    }
	
	  if (FlxG.mouse.overlaps(Artwork))
    {
     if (FlxG.mouse.justPressed)
        {

            FlxG.sound.play(Paths.sound('menu/secretmenu/squeak'), 1);

            Artwork.scale.set(0.42, 0.32);
			Artwork.y = 10;

			//little secrets heh heh
			// little note but I really like how all of these can play at once! Very silly indeed


			if (FlxG.random.bool(1)){
				FlxTween.tween(Artwork, {x: Artwork.x + -1000}, (Conductor.crochet / 1000) * 5);
				FlxG.sound.play(Paths.sound('menu/secretmenu/drag'), 1);
       			 new FlxTimer().start(10, function(_) {    
					FlxG.sound.play(Paths.sound('menu/secretmenu/pop'), 1);
       				Artwork.x = 0;
    			});				
			}
				else Artwork.x = 0;
			if (FlxG.random.bool(2)) {
				FlxTween.tween(Artwork, {alpha: 0}, (Conductor.crochet / 1000) * 2);
				FlxG.sound.play(Paths.sound('menu/secretmenu/oh'), 1);
			}
			else Artwork.alpha = 1;

			if (FlxG.random.bool(3)) {
				FlxTween.tween(Artwork, {y: Artwork.y + -1000, angle: 360}, (Conductor.crochet / 1000) * 2, {ease: FlxEase.backIn});
				new FlxTimer().start(2, function(_) {    
				FlxTween.tween(Artwork, {y: Artwork.y + 1000, angle: 360}, (Conductor.crochet / 1000) * 1, {ease: FlxEase.elasticOut});
				});
			}
				else Artwork.y = 0;

			if (FlxG.random.bool(.67)){
				FlxTween.tween(Artwork, {angle: 360}, (Conductor.crochet / 1000) * 1, {ease: FlxEase.expoIn});
			}
				else Artwork.angle = 0;
				
			// squish

            FlxTween.tween(Artwork.scale,
            {
                x: 0.37,
                y: 0.37
            },
            0.4,
            {
                ease: FlxEase.backOut
            });
        }
    }
    else
    {
        Artwork.scale.set(0.37, 0.37);
    }
}
