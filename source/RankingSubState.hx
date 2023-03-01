import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.addons.transition.FlxTransitionableState;

class RankingSubState extends FlxSubState {
    var twnScores:Array<Int> = [0, 0];
    var scoreTxt1:FlxText;
    var scoreTxt2:FlxText;
    var headerTxt:FlxText;
    var confetti:Confetti;
    var canExit:Bool = false;
    override function create() {
        cameras = [PlayState.instance.camOther];
        super.create();
        add({var e = new FlxSprite().makeGraphic(1280, 720, 0xff000000); e.alpha = 0.5; e;});
        add(headerTxt = new FlxText(0, 20, 1280, "RANKING").setFormat(Paths.font("vcr.ttf"), 64, 0xffffffff, "center"));
        add(scoreTxt1 = new FlxText(100, 0, 1280, "0").setFormat(Paths.font("vcr.ttf"), 48, 0xffffffff, "left"));
        add(scoreTxt2 = new FlxText(100, 0, 1280, "0").setFormat(Paths.font("vcr.ttf"), 48, 0xffffffff, "right"));
        add(confetti = new Confetti());
        if (PlayState.instance.songScore < PlayState.instance.songScore2) confetti.emitter.x = 0;
        scoreTxt2.x = 1280 - scoreTxt2.width - 100;
        scoreTxt1.screenCenter(Y);
        scoreTxt2.screenCenter(Y);
        new FlxTimer().start(1, (t) -> {
            FlxG.sound.play(Paths.sound("drumroll"));
            FlxTween.num(0, PlayState.instance.songScore, 3.55,  (v) -> {
                twnScores[1] = Std.int(v);
                scoreTxt1.text = Std.string(twnScores[0]);
            });
            FlxTween.num(0, PlayState.instance.songScore2, 3.55, {onComplete: (twn) -> {
                canExit = true;
                confetti.trigger();
                headerTxt.text = "Player on the" + (PlayState.instance.songScore > PlayState.instance.songScore2 ? " right" : " left") + " WINS!";
                FlxG.sound.play(Paths.sound("win"));
                return;
            }}, (v) -> {
                twnScores[0] = Std.int(v);
                scoreTxt2.text = Std.string(twnScores[1]);
            });
        });
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.SPACE && canExit) {
            trace('WENT BACK TO FREEPLAY??');
            WeekData.loadTheFirstEnabledMod();
            PlayState.cancelMusicFadeTween();
            if(FlxTransitionableState.skipNextTransIn) {
                CustomFadeTransition.nextCamera = null;
            }
            MusicBeatState.switchState(new FreeplayState());
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
        }
    }
}
