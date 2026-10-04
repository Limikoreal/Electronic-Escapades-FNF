import openfl.display.BlendMode;
import flixel.addons.display.FlxBackdrop;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;
import funkin.savedata.FunkinSave;
import funkin.editors.EditorPicker;
import funkin.backend.system.framerate.Framerate;

importScript("data/states/musicthingie");

var bg:FlxSprite;
var bgdots:FlxSprite;
var barback:FlxSprite;
var pipes:FlxSprite;
var barfront:FlxSprite;
var backdrop:FlxSprite;
//special
var portrait:FlxSprite;
var curSelected:Int = 0;
var NBT:Bool = false; // heh! nothing but thieves reference -Lime
var menucam:FlxCamera;
var cameras:Array<FlxCamera>;
var buttons:Array<FlxSprite> = [];
//sounds
var selectnoise:FlxSound = FlxG.sound.load(Paths.sound("menu/confirm"));
var scrollingItem:FlxSound = FlxG.sound.load(Paths.sound('menu/scroll'));
var goBack:FlxSound = FlxG.sound.load(Paths.sound('menu/cancel'));


 function create() {
	playLoopedSong();
    menucam = new FlxCamera();
    menucam.bgColor = 0;
    FlxG.cameras.add(menucam, true);

    cameras = [menucam];
    cameras[0].scroll.set(0, 0);
    camera.scroll.set(0, 0);

  trace("cool. cool. I reallly hurt my finger doing that paper clip bit.");
  
  var portraits =[
    'menus/mainmenu/portraits/story', 
    'menus/mainmenu/portraits/fp', 
    'menus/mainmenu/portraits/creds', 
    'menus/mainmenu/portraits/options'
  ];
  for (portpath in portraits) {
    var portraitcache = new FlxSprite().loadGraphic(Paths.image(portpath));
  }
  var buttonshit =[ //I'm just winging it at this point - Lime
        {img: 'story mode', idle: 'storymode idle', selected: 'storymode selected'},
        {img: 'freeplay', idle: 'freeplay idle', selected: 'freeplay selected'},
        {img: 'credits', idle: 'credits idle', selected: 'credits selected'},
        {img: 'options', idle: 'options idle', selected: 'options selected'}
  ];
      for (info in buttonshit) {
        var cachebutton = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/MenuButtons/' + info.img));
        var cacherames = Paths.getSparrowAtlas('menus/mainmenu/MenuButtons/' + info.img);
    }

    // ------------------ MENU ITEMS ------------------
    bg = new FlxBackdrop(Paths.image('menus/mainmenu/bg'));
    bg.scale.set(1.2, 1.2);
    bg.scrollFactor.set(0.1, 0.1);
    bg.velocity.x =50;
   // bg.alpha =0.1;
    add(bg);

    bgdots = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/bgdots'));
    bgdots.scale.set(1, 1);
    bgdots.screenCenter();
    bgdots.scrollFactor.set(0.2, 0.2);
    bgdots.antialiasing = true;
    bgdots.blend = BlendMode.SCREEN;
    bgdots.alpha =0.5;
    add(bgdots);
    
    barback = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/barback'));
    barback.y = -50;
    barback.scrollFactor.set(1, 0.2);
    barback.scale.set(1.2, 1);
    add(barback);

    portrait = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/mainmenu/portraits/placeholder'));
    portrait.scale.set(1, 1);
    portrait.scrollFactor.set(.8, 1);
    add(portrait);

    pipes = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/pipes'));
    pipes.antialiasing = false;
    pipes.x -= 10;
    pipes.y -= 5;
    pipes.scrollFactor.set(0.9, 1);
    pipes.scale.set(1.2, 1.2);
    add(pipes);

    barfront = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/barfront'));
    barfront.screenCenter();
    barfront.scrollFactor.set(1, 0.05);
    barfront.scale.set(1, 1.1);
    add(barfront);

    backdrop = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/buttonbackdrop'));
    backdrop.screenCenter();
    backdrop.scrollFactor.set(1, 1);
    backdrop.scale.set(1.2, 1.2);
   // backdrop.alpha = 0.1;
    add(backdrop);

    var assY:Float = 0;
    var fuck:Float = 175;
    var fuckyougoleft:Float = 10;

    for (i in 0...buttonshit.length) {
        var shit = buttonshit[i];

        var button = new FlxSprite();
        button.frames = Paths.getSparrowAtlas('menus/mainmenu/MenuButtons/' + shit.img);

        button.animation.addByPrefix('idle', shit.idle, 24);
        button.animation.addByPrefix('selected', shit.selected, 24);

        button.animation.play('idle');
        button.updateHitbox();

        button.x = fuckyougoleft;      
        button.y = assY + i * fuck;
        barfront.scale.set(1.2, 1.2);

        button.antialiasing = false;
        button.ID = i;

        buttons.push(button);
        add(button);
    }
    	for (i in [bgdots, barback, barfront, backdrop, portrait, pipes])
		i.cameras = [menucam];
        
 }
    // ------------------------------------------------

 function update(elapsed:Float) {

    var Xshit = (FlxG.mouse.x - FlxG.width / 2) * 0.05;
    var Yshit = (FlxG.mouse.y - FlxG.height / 2) * 0.05;
    menucam.scroll.x = Xshit;
    menucam.scroll.y = Yshit;

    var portraits = [
        'menus/mainmenu/portraits/story',
        'menus/mainmenu/portraits/fp',
        'menus/mainmenu/portraits/creds',
        'menus/mainmenu/portraits/options'
    ];

    var selectedButtonIndex = [0,1,2,3][curSelected];

     for (i in 0...buttons.length) {
        if (i == selectedButtonIndex) {
            if (buttons[i].animation.curAnim.name != "selected")
                buttons[i].animation.play('selected');
        } else {
            if (buttons[i].animation.curAnim.name != "idle")
                buttons[i].animation.play('idle');
        }
    }   

    portrait.loadGraphic(Paths.image(portraits[curSelected]));

        if (controls.UP_P) {
            scrollingItem.play(true);
            curSelected = (curSelected <= 0) ? 3 : curSelected - 1;
        }
        if (controls.DOWN_P) {
           scrollingItem.play(true);
            curSelected = (curSelected >= 3) ? 0 : curSelected + 1;
        }

    if (controls.ACCEPT) selectStuff();

    if (controls.BACK) {
        FlxG.sound.play(Paths.sound('menu/cancel'), 1);
        new FlxTimer().start(0.5, function(_) {
            FlxG.switchState(new TitleState());
        });
    }

    if (controls.SWITCHMOD || FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = false;
        persistentDraw = true;
        openSubState(controls.SWITCHMOD ? new ModSwitchMenu() : new EditorPicker());
    }  
}

function selectStuff(){
    FlxG.sound.play(Paths.sound('menu/confirm'), 1);
    new FlxTimer().start(0.5, function(_) {
    
    switch(curSelected){
        case 0: 
            FlxG.switchState(new StoryMenuState());
        case 1: 
            FlxG.switchState(new FreeplayState());
        case 2: 
            FlxG.switchState(new ModState("ELECreds"));
        case 3: 
            FlxG.switchState(new OptionsMenu());
    } 
    });
    buttons[curSelected].scale.set(1.2, 1.1);
    FlxTween.tween(buttons[curSelected].scale, {x: 1, y: 1}, 0.4, {ease: FlxEase.cubeOut});
}