function create() {
}

function stepHit(curStep) {
	switch(curStep){
        case 227:
        if (FlxG.random.bool(50)) {
           strumLines.members[1].characters[0].playAnim('grabALT', true);
           new FlxTimer().start(2, function(tmr:FlxTimer) {
                   health = .950;
            });
        } else {
            strumLines.members[1].characters[0].playAnim('grab', true);
        }
    }
}