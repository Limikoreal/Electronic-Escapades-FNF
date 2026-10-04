//I gotta get the music to play

public function playLoopedSong() {
    if (inIntro) {
        if (!introMusic.playing) {
            if (FlxG.sound.music == null || !FlxG.sound.music.playing)
                CoolUtil.playMenuSong();

            if (FlxG.sound.music != null)
                FlxG.sound.music.pause();

            introMusic.play(true);
        }
    } else if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
        CoolUtil.playMenuSong();
    }
}

function update(elapsed) {
    if (inIntro && introMusic.time >= 5650) {
        inIntro = false;

        if (FlxG.sound.music != null) {
            FlxG.sound.music.time = introMusic.time;
            introMusic.stop();
            FlxG.sound.music.resume();
        } else {
            introMusic.stop();
            CoolUtil.playMenuSong();
        }
    }
}