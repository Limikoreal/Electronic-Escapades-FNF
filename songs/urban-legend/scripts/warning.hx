var Square:FlxSprite;
var warning:FlxSprite;

function create()
{
    Square = new FlxSprite(0, 500).loadGraphic(Paths.image('stages/black'));
    Square.alpha = 0;
    Square.scale.set(2.5, 2.5);
    Square.cameras = [camHUD];

    warning = new FlxSprite(150, 0).loadGraphic(Paths.image('placeholder'));
    warning.alpha = 0;
    warning.cameras = [camHUD];
    warning.scale.set(1, 1);

    add(Square);
    add(warning);
}

function stepHit(curStep) {
	switch(curStep){
        case 0:
            FlxTween.tween(Square, {alpha: 0.6}, (Conductor.stepCrochet / 1000) * 3);
            FlxTween.tween(warning, {alpha: 1}, (Conductor.stepCrochet / 1000) * 3);
        case 120:
            FlxTween.tween(Square, {alpha: 0}, (Conductor.stepCrochet / 1000) * 3);
            FlxTween.tween(warning, {alpha: 0}, (Conductor.stepCrochet / 1000) * 3);
    }
}