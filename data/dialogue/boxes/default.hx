var isStart:Bool = true;
var game:PlayState = PlayState.instance;

function postCreate():Void {
	if (game == null) return;
	if (isStart) game.camHUD.alpha = 0; else {
		FlxTween.tween(game.camHUD, {alpha: 0}, 1, {ease: FlxEase.circOut});
		return;
	}
	if (PlayState.isStoryMode ? PlayState.storyWeek.songs[0].name != PlayState.SONG.meta.name : false) return;
}
function destroy():Void {
	if (!isStart) return;
	if (game != null) FlxTween.tween(game.camHUD, {alpha: 1}, 2, {ease: FlxEase.backOut});
}