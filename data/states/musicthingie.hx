//I gotta get the music to play

public function playLoopedSong(){
    if(inIntro){
        if (FlxG.sound.music == null){
            CoolUtil.playMenuSong();
            FlxG.sound.music.pause();
            introMusic.play(true);
        }
    } else CoolUtil.playMenuSong();
}

function update(elapsed) {
    if (introMusic.time >= 5650 && inIntro){
        inIntro = false;
        FlxG.sound.music.resume();
    }
}