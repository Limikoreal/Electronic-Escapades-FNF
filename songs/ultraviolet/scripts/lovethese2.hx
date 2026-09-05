var van:FlxSprite;

function postCreate(){
    van = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/KatelynWeek/newsvan'));
    add(van);
    van.scale.set(1.1, 1.1);
    van.y = 100;
    van.x = -500;
    van.visible = false;
}

function stepHit(curStep) {
	switch(curStep){
        case 0:
			FlxTween.tween(camHUD, {alpha: 0.001}, (Conductor.stepCrochet / 1000) * 2);
        case 80:
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 100) * 2);
        case 1148:
            van.visible = true;
            FlxTween.tween(van , {x: 3700}, 2, {ease: FlxEase.expoOut});
        case 1156:
            van.visible = false;
    }
}