package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import flixel.group.FlxSpriteGroup;
import flixel.util.helpers.FlxRange;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxRange;
import flixel.math.FlxRandom;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionFade;
import flixel.system.FlxSound;

/**
 * A FlxState which can be used for the game's menu.
 */
class TitleState extends FlxUIState
{

	private var wave:FlxSprite;
	private var startButton:FlxButton;
	private var rainEmitter:FlxEmitter;
	private var smokeEmitter:FlxEmitter;

	private var waterLayer1:FlxSprite;
	private var waterLayer2:FlxSprite;
	private var bg:FlxSprite;
	private var hut:FlxSprite;

	private var startText:FlxText;
	private var copyText:FlxText;
	private var versText:FlxText;
	private var title:FlxSprite;

	private var bronzeSprite:FlxSprite = null;
	private var numTrophyBronze:FlxText = null;
	private var silverSprite:FlxSprite = null;
	private var numTrophySilver:FlxText = null;
	private var goldSprite:FlxSprite = null;
	private var numTrophyGold:FlxText = null;
	private var alienSprite:FlxSprite = null;
	private var numTrophyAlien:FlxText = null;

	private var gameSave:FlxSave;
	private var topScore:Int = 0;
	private var bronzeTrophy:Int = 0;
	private var silverTrophy:Int = 0;
	private var goldTrophy:Int = 0;
	private var alienTrophy:Int = 0;
	private var startButtonIsPressed:Bool = false;

	private var bgSound:FlxSound;

	override public function create():Void
	{

		//transitions
		bgColor = FlxColor.BLACK;	

		FlxTransitionableState.defaultTransIn = new TransitionData();
		FlxTransitionableState.defaultTransOut = new TransitionData();
		
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
		
		FlxTransitionableState.defaultTransIn.tileData = { asset:diamond, width:32, height:32 };
		FlxTransitionableState.defaultTransIn.type = TILES;
		FlxTransitionableState.defaultTransIn.color = FlxColor.BLACK;
		FlxTransitionableState.defaultTransOut.duration = 4.0;
		FlxTransitionableState.defaultTransOut.tileData = { asset:diamond, width:32, height:32 };
		FlxTransitionableState.defaultTransOut.type = TILES;
		FlxTransitionableState.defaultTransOut.color = FlxColor.BLACK;

		//Checks for top record save
		gameSave = new FlxSave(); // initialize
		gameSave.bind("WaveSave"); // bind to the named save slot

		if (gameSave.data.topScore){
			trace("topScore exists");
			topScore = gameSave.data.topScore;
		}else{
			gameSave.data.topScore = 0;
			gameSave.flush();
			trace("topScore does not exist -> creating " + gameSave.data.topScore);
		}

		//Checks trophies
		if (gameSave.data.bronzeTrophy){
			trace("bronzeTrophy exists");
			bronzeTrophy = gameSave.data.bronzeTrophy;
		}else{
			gameSave.data.bronzeTrophy = 0;
			gameSave.flush();
			trace("bronzeTrophy does not exist -> creating " + gameSave.data.bronzeTrophy);
		}

		if (gameSave.data.silverTrophy){
			trace("silverTrophy exists");
			silverTrophy = gameSave.data.silverTrophy;
		}else{
			gameSave.data.silverTrophy = 0;
			gameSave.flush();
			trace("silverTrophy does not exist -> creating " + gameSave.data.silverTrophy);
		}

		if (gameSave.data.goldTrophy){
			trace("goldTrophy exists");
			goldTrophy = gameSave.data.goldTrophy;
		}else{
			gameSave.data.goldTrophy = 0;
			gameSave.flush();
			trace("goldTrophy does not exist -> creating " + gameSave.data.goldTrophy);
		}

		if (gameSave.data.alienTrophy){
			trace("alienTrophy exists");
			alienTrophy = gameSave.data.alienTrophy;
		}else{
			gameSave.data.alienTrophy = 0;
			gameSave.flush();
			trace("alienTrophy does not exist -> creating " + gameSave.data.alienTrophy);
		}

		//Sound cache
		FlxG.sound.cache(Reg.SND_WAVE);
		FlxG.sound.cache(Reg.SND_RAIN);

		//DEBUG INFO UI
		// bronzeTrophy = 50;
		// silverTrophy = 10;
		// goldTrophy = 1;
		// alienTrophy = 1;
		// topScore= 250;

		//Title screen creation
		super.create();

		bg = new FlxSprite(0,0);
		bg.loadGraphic(Reg.TITLEBG);
		add(bg);

		//rain
        rainEmitter = new FlxEmitter(0, -50);
        rainEmitter.setSize(FlxG.width*2, 0);        
		rainEmitter.launchAngle.set(90,90);
		rainEmitter.acceleration.set(-200, 200, -200, 200, -200, 200, -200, 200);
        add(rainEmitter);

        rainEmitter.loadParticles(Reg.RAIN_DROP, 200);

        waterLayer1 = new FlxSprite(-50,0);
		waterLayer1.loadGraphic(Reg.FG_WATER);
		waterLayer1.y = FlxG.height - waterLayer1.height;
		add(waterLayer1);

		FlxTween.linearMotion(waterLayer1, waterLayer1.x, waterLayer1.y, waterLayer1.x+30, waterLayer1.y, 12, false, {ease: FlxEase.sineInOut,type: FlxTween.PINGPONG });

		//smoke
        smokeEmitter = new FlxEmitter(315, 220);
        smokeEmitter.setSize(5, 0);
        smokeEmitter.launchAngle.set(-90, -90);
        smokeEmitter.acceleration.start.min.y = -5;
		smokeEmitter.acceleration.start.max.y = -5;
		smokeEmitter.acceleration.end.min.y = -5;
		smokeEmitter.acceleration.end.max.y = -5;
        add(smokeEmitter);

        smokeEmitter.loadParticles(Reg.SMOKE, 50);

		hut = new FlxSprite(100,200);
		hut.loadGraphic(Reg.HUT,false,330,150);
		add(hut);

		FlxTween.linearMotion(hut, hut.x, hut.y, hut.x, hut.y + 5, 5, false, {ease: FlxEase.sineInOut,type: FlxTween.PINGPONG });

		//if max socre is set -> signpost floating
		if (topScore > 0){
			var signGroup = new FlxSpriteGroup();
			add(signGroup);
			var signpost = new FlxSprite(428,250);
			signpost.loadGraphic(Reg.SIGNPOST);
			signGroup.add(signpost);

			var topScoreSign = new FlxText(432,251,70,"TOP\n\n" + topScore);
			topScoreSign.setFormat(Reg.FONT_MAIN,12,FlxColor.BLACK,"center");
			signGroup.add(topScoreSign);

			FlxTween.linearMotion(signGroup, signGroup.x, signGroup.y, signGroup.x, signGroup.y + 10, 10, false, {ease: FlxEase.sineInOut,type: FlxTween.PINGPONG });
		}

		//Trophy symbols
		if (alienTrophy > 0){
			alienSprite = new FlxSprite(10,160);
			alienSprite.loadGraphic(Reg.TROPHY_ALIEN);
			add(alienSprite);

			numTrophyAlien = new FlxText(40,170, 60,"" + alienTrophy);
			numTrophyAlien.setFormat(Reg.FONT_MAIN,16,FlxColor.WHITE,"center");
			add(numTrophyAlien);
		}

		if (goldTrophy > 0){
			goldSprite = new FlxSprite(10,200);
			goldSprite.loadGraphic(Reg.TROPHY_GOLD);
			add(goldSprite);

			numTrophyGold = new FlxText(40,210, 60,"" + goldTrophy);
			numTrophyGold.setFormat(Reg.FONT_MAIN,16,FlxColor.WHITE,"center");
			add(numTrophyGold);
		}

		if (silverTrophy > 0){
			silverSprite = new FlxSprite(10,240);
			silverSprite.loadGraphic(Reg.TROPHY_SILVER);
			add(silverSprite);

			numTrophySilver = new FlxText(40,250,60,"" + silverTrophy);
			numTrophySilver.setFormat(Reg.FONT_MAIN,16,FlxColor.WHITE,"center");
			add(numTrophySilver);
		}

		if (bronzeTrophy > 0){
			bronzeSprite = new FlxSprite(10,280);
			bronzeSprite.loadGraphic(Reg.TROPHY_BRONZE);
			add(bronzeSprite);

			numTrophyBronze = new FlxText(40,290,60,"" + bronzeTrophy);
			numTrophyBronze.setFormat(Reg.FONT_MAIN,16,FlxColor.WHITE,"center");
			add(numTrophyBronze);
		}

		waterLayer2 = new FlxSprite(-50,0);
		waterLayer2.loadGraphic(Reg.FG_WATER);
		waterLayer2.y = FlxG.height - waterLayer2.height + 20;
		add(waterLayer2);

		FlxTween.linearMotion(waterLayer2, waterLayer2.x, waterLayer2.y, waterLayer2.x-50, waterLayer2.y, 15, false, {ease: FlxEase.sineInOut,type: FlxTween.PINGPONG });

		startButton = new FlxButton(150,150,"",startButtonPressed);
		startButton.loadGraphic(Reg.START_BUTTON_NORMAL,false,225,65);
		add(startButton);

		startText = new FlxText(138,168,250,"Start");
		startText.color = FlxColor.WHITE;
		startText.setFormat(Reg.FONT_MAIN,32,FlxColor.WHITE,"center");
		add(startText);

		copyText = new FlxText(0,355,FlxG.width,"2016 sbarrio");
		copyText.setFormat(Reg.FONT_MAIN,14,FlxColor.WHITE,"center");
		add(copyText);


		versText = new FlxText(210,360,FlxG.width,"v1.0");
		versText.setFormat(Reg.FONT_MAIN,12,FlxColor.WHITE,"center");
		add(versText);

		title = new FlxSprite(20,1);
		title.loadGraphic(Reg.TITLE);
		add(title);

		wave = new FlxSprite(0,0);
		wave.loadGraphic(Reg.SCREEN_WAVE);
		wave.x = -wave.width;
		add(wave);
   
        rainEmitter.start(false, 0.04);
        smokeEmitter.start(false,2);

        //BG SFX sound
		bgSound = FlxG.sound.play(Reg.SND_RAIN,0.5,true,true,null);

	}

	private function startButtonPressed():Void{
		if (startButtonIsPressed){
			return;
		}

		startButton.loadGraphic(Reg.START_BUTTON_PRESSED,false,225,65);

		startButtonIsPressed = true;

		FlxTween.linearMotion(wave, wave.x, wave.y, wave.x + FlxG.width*2, wave.y, 1, true, {ease: FlxEase.expoIn,type: FlxTween.ONESHOT });
		FlxG.sound.play(Reg.SND_WAVE,0.4,false,true,null);

		var timer = new FlxTimer();		
		timer.start(1.5, timerFinished,1);
	}

	private function timerFinished(FlxTimer):Void{
		trace("go to play state");
		goToPlayState();
	}

	private function goToPlayState():Void{
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}	

	override public function destroy():Void
	{
		super.destroy();
		rainEmitter.destroy();
		smokeEmitter.destroy();		
		wave.destroy();
		title.destroy();
		startButton.destroy();
		waterLayer1.destroy();
		waterLayer2.destroy();
		bg.destroy();
		hut.destroy();
		startText.destroy();
		copyText.destroy();
		versText.destroy();
		bgSound.destroy();

		if (bronzeSprite !=null ){
			bronzeSprite.destroy();
		}

		if (numTrophyBronze !=null ){
			numTrophyBronze.destroy();
		}

		if (silverSprite !=null ){
			silverSprite.destroy();
		}

		if (numTrophySilver !=null ){
			numTrophySilver.destroy();
		}

		if (goldSprite !=null ){
			goldSprite.destroy();
		}

		if (numTrophyGold !=null ){
			numTrophyGold.destroy();
		}

		if (alienSprite !=null ){
			alienSprite.destroy();
		}

		if (numTrophyAlien !=null ){
			numTrophyAlien.destroy();
		}

	}
}