import funkin.menus.credits.CreditsMain;
import hxvlc.flixel.FlxVideoSprite;

var credsArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('credits'));
var curSelected:Int = 0;
var curCred;
var active = false;

var bg:FlxSprite;
var portrait:FlxSprite = new FlxSprite(0, 0);
var jacky:FlxVideoSprite;
var foreground:FlxSprite;
var buttonleft:FLxSprite;
var buttonright:FlxSprite;

var name:FlxText = new FlxText(20, 60, FlxG.width, "Heya", 32, false).setFormat(Paths.font("zerohour.ttf"), 50, FlxColor.BLACK, 'center');
var role:FlxText = new FlxText(340, 140, 500, FlxG.width, "test", 28, false).setFormat(Paths.font("zerohour.ttf"), 26, FlxColor.BLACK, 'center');
var contributions:FlxText = new FlxText(200, 250, 500, "test", 32, false).setFormat(Paths.font("zerohour.ttf"), 20, FlxColor.BLACK, 'center');
var message:FlxText = new FlxText(200, 450, 600, "test", 32, false).setFormat(Paths.font("zerohour.ttf"), 32, FlxColor.BLACK, 'center');
var pageIndic:FlxText = new FlxText(200, 800, 500, "cum", 32, false).setFormat(Paths.font("zerohour.ttf"), 32, FlxColor.BLACK, 'center');


function create() {
    bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/credits/bg'));
    add(bg); 

    foreground = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/credits/foreground'));
    add(foreground);

    buttonleft = new FlxSprite(0, 0);
    buttonleft.frames = Paths.getSparrowAtlas('menus/credits/leftbutt');
    buttonleft.animation.addByPrefix("idle", "left idle", 24, true);
    buttonleft.animation.addByPrefix("select", "left select", 24, false);
    buttonleft.updateHitbox();
    buttonleft.y = 250;

    buttonright = new FlxSprite(0, 0);
    buttonright.frames = Paths.getSparrowAtlas('menus/credits/rightbutt');
    buttonright.animation.addByPrefix("idle", "right idle", 24, true);
    buttonright.animation.addByPrefix("select", "right select", 24, false);
    buttonright.updateHitbox();
    buttonright.y = 250;
    buttonright.x = 1125;

    jacky = new FlxVideoSprite(580, 250);
    jacky.load(Assets.getPath(Paths.video("corndog")));
    jacky.pause();
    jacky.visible = false;
    jacky.scale.set(0.7, 0.7);
    jacky.y = 200;
    add(jacky);

    portrait.scale.set(1,1);
    portrait.antialiasing = true;
    add(portrait);

	pageIndic.updateHitbox();
	pageIndic.screenCenter(FlxAxes.X);
	pageIndic.antialiasing = true;

    for (coolstuff in [name, role, contributions, message]) {
        coolstuff.antialiasing = true;
        add(coolstuff);
    }
    add(pageIndic);
    add(buttonleft);
    add(buttonright);
}

function changethecreds(change:Int = 0) {
    curSelected = FlxMath.wrap(curSelected + change, 0, credsArray.length-1);
    curCred = credsArray[curSelected].split('//');

    //I'm so fucking sorry...
    name.text = curCred[0];
	role.text = curCred[1];
	contributions.text = curCred[2];
    message.text = (curCred[3] == "null") ? "" : '"' + curCred[3] + '"';

	for (text in [name, role, contributions, message]) {
		text.updateHitbox();
		text.screenCenter(FlxAxes.X);
		if (curCred[0] != "Special Thanks") 
            text.x += 190; 
	}
    
    portrait.loadGraphic(Paths.image('menus/credits/portraits/'+curCred[0].toLowerCase()));
    portrait.updateHitbox();
        

    if (curCred[0] == "Tetrolt") {
		FlxG.sound.play(Paths.sound('menu/secretmenu/hi'), 1);       
    }
    if (curCred[0] == "Special Thanks"){
        portrait.visible = false;
    } else {
        portrait.visible = true;
    }

	pageIndic.text = curSelected+ "/" +(credsArray.length-1);
    
}

function update(elapsed:Float) {

    if (controls.RIGHT_P) {
        FlxG.sound.play(Paths.sound('menu/scroll'), 1);
        buttonright.animation.play("select");
        changethecreds(1);
    } else {
        buttonright.animation.play("idle");
    }

    if (controls.LEFT_P) {
       FlxG.sound.play(Paths.sound('menu/scroll'), 1);
       buttonleft.animation.play("select");
       changethecreds(-1);
    } else {
        buttonleft.animation.play("idle");
    }

    if (controls.BACK) {
        FlxG.sound.play(Paths.sound('menu/cancel'), 1);
        new FlxTimer().start(0.5, function(_) {
            FlxG.switchState(new MainMenuState());
        });
    }
}
override function destroy(){
    if (jacky != null) {
        jacky.stop();
        jacky.destroy();
        jacky = null;
    }
    super.destroy();
}