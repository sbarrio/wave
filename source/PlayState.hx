package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxRandom;
import flixel.animation.FlxAnimation;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.helpers.FlxRange;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxUIState
{

	//Game control
	private var current_level:Int = 1; //default 1
	private var tilePointer:Int = 0;
	private var currentPath:Int = 0;
	private static var STRETCH_SIZE:Int = 10;

	//Game Paths
	private static var PATH_MATRIX:Array<Array<Int>> = [
											//EASY LEVEL PATHS
											[0,0,1,0,0,1,0,0,-1,0    ,0,0,0,2,0,0,0,1,0,0    ,0,0,1,0,0,1,0,1,0,0    ,0,1,0,-1,0,0,2,0,0,0],
											[0,1,0,-1,0,0,1,0,-1,0   ,0,0,0,0,-1,0,0,0,1,0   ,0,0,0,-1,0,1,0,-1,0,0   ,0,-1,0,1,0,-1,0,0,1,0],
											[0,2,0,1,0,-1,0,0,0,0    ,0,1,0,1,0,1,0,-1,0,0   ,0,0,0,-1,0,0,2,0,1,0    ,0,-1,0,-1,0,-1,0,-1,0,0],
											[0,0,1,0,1,0,0,0,1,0     ,0,0,-1,0,-1,0,0,1,0,0  ,0,1,0,0,0,0,0,-1,0,0   ,0,-1,0,-1,0,0,2,0,0,0],
											//HARD LEVEL PATHS
											[0,1,0,2,0,0,0,2,0,0   ,0,0,1,0,-1,0,2,0,1,0   ,0,-1,0,-1,0,0,-1,0,-1,0    ,0,0,-1,0,0,1,0,2,0,0],
											[0,2,0,2,0,3,0,-1,0,0   ,0,2,0,0,2,0,0,1,0,0   ,0,1,0,1,0,1,0,1,0,0    ,0,-1,0,-1,0,-1,0,-1,0,0],
											[0,0,0,0,0,-1,0,-1,0,0   ,0,2,0,0,-1,0,0,-1,0,0   ,0,0,1,0,-1,0,1,0,1,0    ,0,0,3,0,1,0,2,0,2,0],
											[0,2,0,1,0,0,0,0,0,0   ,0,1,0,3,0,2,0,-1,0,0   ,0,3,0,0,2,0,2,0,2,0    ,0,0,0,0,2,0,-1,0,1,0],
											//EXTREME LEVEL PATHS
											[0,3,0,-1,0,3,0,1,0,0   ,0,3,0,-1,0,0,-1,0,3,0   ,0,1,0,3,0,2,0,3,0,0    ,0,-1,0,0,3,0,2,0,3,0],
											[0,0,3,0,3,0,3,0,2,0   ,0,-1,0,0,-1,0,-1,0,1,0   ,0,0,1,0,2,0,1,0,2,0    ,0,2,0,2,0,3,0,2,0,0],
											[0,1,0,2,0,1,0,2,0,0   ,0,0,2,0,1,0,2,0,1,0   ,0,-1,0,-1,0,0,1,0,1,0    ,0,1,0,1,0,3,0,2,0,0],
											[0,1,0,-1,0,3,0,-1,0,0   ,0,3,0,-1,0,2,0,-1,0,0   ,0,-1,0,-1,0,1,0,3,0,0    ,0,-1,0,0,-1,0,2,0,3,0]
											];

	//Game constants
	private static var LEVEL2_POINTS:Int = 5;
	private static var LEVEL3_POINTS:Int = 10;
	private static var LEVEL4_POINTS:Int = 20;
	private static var LEVEL5_POINTS:Int = 60;
	private static var LEVEL6_POINTS:Int = 150;
	private static var GOAL_POINTS:Int = 200;

	private static var LEVEL1_SPEED:Int = 7;
	private static var LEVEL2_SPEED:Int = 9;
	private static var LEVEL3_SPEED:Int = 11;
	private static var LEVEL4_SPEED:Int = 13;

	private static var LEVEL1_ANIM_SPEED:Int = 10;
	private static var LEVEL2_ANIM_SPEED:Int = 11;
	private static var LEVEL3_ANIM_SPEED:Int = 12;
	private static var LEVEL4_ANIM_SPEED:Int = 13;

	private static var JUMP_ACCEL_LEVEL1:Float = 35000;
	private static var JUMP_ACCEL_LEVEL2:Float = 45000;
	private static var JUMP_ACCEL_LEVEL3:Float = 55000;
	private static var JUMP_ACCEL_LEVEL4:Float = 65000;

	private static var GRAVITY_LEVEL1:Float = 1500;
	private static var GRAVITY_LEVEL2:Float = 2500;
	private static var GRAVITY_LEVEL3:Float = 3500;
	private static var GRAVITY_LEVEL4:Float = 4500;

	private static var BRONZE_TROPHY_AMOUNT:Int = 20;
	private static var SILVER_TROPHY_AMOUNT:Int = 50;
	private static var GOLD_TROPHY_AMOUNT:Int = 100;

	private static var MIN_POINTS_RANA_YELLOW:Int = 20; //silver
	private static var MIN_POINTS_RANA_BLUE:Int = 15; //gold
	private static var MIN_POINTS_RANA_RED:Int = 1; //alien

	private static var RANA_PROGRESS_INIT_X:Int = 141;

	//Screen
	private var SCR_WIDTH = FlxG.width;
	private var SCR_HEIGHT = FlxG.height;
	private var CLEAR_COLOR:Int = 0x00000000;
	private var GRASS_COLOR:Int = 0xFF53973D;
	private var TROPHY_AWARD_SHOW_TIME = 170;

	//Object control
	private var moving:Bool = true;
	private var speed:Float = LEVEL1_SPEED; //defaut LEVEL1_SPEED
	private var isJumping:Bool = true;
	private var rana:FlxSprite;
	private var regRana:String = Reg.RANA_GREEN;
	private var floorBG:FlxSprite;
	private var wave:FlxSprite;
	private var jump_accel:Float = JUMP_ACCEL_LEVEL1; //default JUMP_ACCEL_LEVEL1
	private var gravity:Float = GRAVITY_LEVEL1; //default GRAVITY_LEVEL1

	private var obstacles:FlxTypedGroup<FlxSprite>;
	private var floorElements:FlxTypedGroup<FlxSprite>;
	private var lastTimeObstacle:Float = 0;

	private var obstacleMinTime:Float = 50;
	private var obstacleMaxTime:Float = 220;

	private var rainEmitter:FlxEmitter;

	private var bg1:FlxSprite;
	private var bg2:FlxSprite;
	private var bg3:FlxSprite;
	private var fgWater: FlxSprite;
	private var waveFG:FlxSprite;
	private var waveTween:FlxTween;
	private var alienShip:FlxSprite;
	private var abductLight:FlxSprite;

	private var ranaEffect:FlxEffectSprite;

	//Score
	private var counter:Int = 0; //default 0
	private var topScore:Int = 0;
	private var counterText:FlxText;
	private var topText:FlxText;
	private var signTop:FlxSprite;

	//Info
	private var tapText:FlxText;

	//Saving
	private var gameSave:FlxSave;

	private var isGameOver:Bool = false;

	//UI
	private var retryButton:FlxButton;
	private var quitButton:FlxButton;
	private var isQuitButtonPressed = false;
	private var isRetryButtonPressed = false;
	private var isBackButtonPressed = false;

	private var gameOverText:FlxText;
	private var retryButtonNormalSprite:FlxSprite;
	private var retryButtonPressedSprite:FlxSprite;
	private var retryText:FlxText;
	private var quitButtonNormalSprite:FlxSprite;
	private var quitButtonPressedSprite:FlxSprite;
	private var quitText:FlxText;
	private var bronzeTrophyIcon:FlxSprite;
	private var silverTrophyIcon:FlxSprite;
	private var goldTrophyIcon:FlxSprite;
	private var trophyPlus:FlxText;
	private var timeShowTrophy:Float = 0;
	private var ranaProgress:FlxSprite;
	private var goalProgress:FlxSprite;
	private var underlineProgress:FlxSprite;
	private var bgProgress:FlxSprite;

	private var youWonText:FlxText;
	private var backButton:FlxButton;
	private var backButtonText:FlxText;

	//Sound
	private var bgMusic:FlxSound;

	override public function create():Void
	{
		super.create();

		//Cheks for top record save
		gameSave = new FlxSave(); // initialize
		gameSave.bind("WaveSave"); // bind to the named save slot
		if (gameSave.data.topScore){
			topScore = gameSave.data.topScore;
			trace("topScore exists: " + gameSave.data.topScore);
		}else{
			gameSave.data.topScore = 0;
			gameSave.flush();
			trace("topScore does not exist -> creating " + gameSave.data.topScore);
		}

		//Checks trophies
		if (gameSave.data.silverTrophy){
			var silverTrophy = gameSave.data.silverTrophy;
			if (silverTrophy >= MIN_POINTS_RANA_YELLOW){
				regRana = Reg.RANA_YELLOW;
			}
		}

		if (gameSave.data.goldTrophy){
			var goldTrophy = gameSave.data.goldTrophy;
			if (goldTrophy >= MIN_POINTS_RANA_BLUE){
				regRana = Reg.RANA_BLUE;
			}
		}

		if (gameSave.data.alienTrophy){
			var alienTrophy = gameSave.data.alienTrophy;
			if (alienTrophy >= MIN_POINTS_RANA_RED){
				regRana = Reg.RANA_RED;
			}
		}

		bg3 = new FlxSprite(0,0,Reg.BG3);
		bg3.allowCollisions = FlxObject.NONE;
		add(bg3);

		bg2 = new FlxSprite(0,0,Reg.BG2);
		bg2.allowCollisions = FlxObject.NONE;
		add(bg2);

		bg1 = new FlxSprite(0,0,Reg.BG1);
		bg1.allowCollisions = FlxObject.NONE;
		add(bg1);

		floorBG = new FlxSprite(0,0,Reg.GRASS);
		floorBG.y = SCR_HEIGHT - floorBG.height - 20;
		floorBG.allowCollisions = FlxObject.NONE;
		floorBG.immovable = true;
		add(floorBG);

		floorElements = new FlxTypedGroup<FlxSprite>();
		//initial floor creation
		var neededTiles:Int = Math.ceil(SCR_WIDTH / 200);
		var curX:Float = 0;
		var i = 0;
		while(i < neededTiles) {
			var tile = createFloorTile(curX);
			curX += tile.width;
			i++;
		}
		add(floorElements);


		rana = new FlxSprite(100,floorBG.y - 150);
		rana.loadGraphic(regRana,true,100,100,true,"rana");
		rana.animation.add("run",[1,0,1,2,3,2],LEVEL1_ANIM_SPEED,true);
		rana.animation.add("jump",[0],10,true);
		add(rana);
		rana.allowCollisions = FlxObject.FLOOR;


		//Alien ship
		alienShip = new FlxSprite(100,100,Reg.ALIEN_SHIP);
		alienShip.allowCollisions = FlxObject.NONE;
		alienShip.visible = false;
		add(alienShip);

		abductLight = new FlxSprite(-120, 120, Reg.ABDUCT_LIGHT);
		abductLight.allowCollisions = FlxObject.NONE;
		abductLight.visible = false;
		add(abductLight);

		obstacles = new FlxTypedGroup<FlxSprite>();
		add(obstacles);

		//Sound caches
		FlxG.sound.cache(Reg.SND_JUMP1);
		FlxG.sound.cache(Reg.SND_WAVE);
		FlxG.sound.cache(Reg.SND_POINT1);
		FlxG.sound.cache(Reg.SND_HIT1);
		FlxG.sound.cache(Reg.SND_TROPHY);
		FlxG.sound.cache(Reg.SND_ALIEN);
		FlxG.sound.cache(Reg.SND_ABDUCT);
		FlxG.sound.cache(Reg.MUS_WIN);
		FlxG.sound.cache(Reg.MUS_LOSE);

		FlxG.sound.play(Reg.SND_JUMP1,0.8,false,true,null);

		tapText = new FlxText(0,120,SCR_WIDTH,"Tap to jump");
		tapText.setFormat(Reg.FONT_MAIN,30,FlxColor.WHITE,"center");
		add(tapText);

		//rain
        rainEmitter = new FlxEmitter(0, -50);
        rainEmitter.setSize(FlxG.width*2, 0);        
		rainEmitter.launchAngle.set(90,90);
		rainEmitter.acceleration.set(-200, 200, -200, 200, -200, 200, -200, 200);
        add(rainEmitter);

		rainEmitter.loadParticles(Reg.RAIN_DROP, 500);
        startRaining(0.03);

		wave = new FlxSprite(0,0,Reg.WAVE);
		wave.y = SCR_HEIGHT- wave.height;
		wave.allowCollisions = FlxObject.NONE;
		add(wave);

		waveTween = FlxTween.linearMotion(wave, wave.x, wave.y, wave.x, wave.y + 30, 20, false, {ease: FlxEase.sineIn,type: FlxTween.PINGPONG });

        fgWater = new FlxSprite(0,0,Reg.FG_WATER);
		fgWater.y = SCR_HEIGHT - fgWater.height/ 2;
		add(fgWater);

		waveFG = new FlxSprite(0,0);
		waveFG.loadGraphic(Reg.SCREEN_WAVE);
		waveFG.x = -waveFG.width;
		waveFG.color = 0x8c8c8cff; //Darkens wave for better contrast
		add(waveFG);

		signTop = new FlxSprite(48,10);
		signTop.loadGraphic(Reg.BGTOP);
		add(signTop);

		topText = new FlxText(48,36,100,"" + topScore,30);
		topText.setFormat(Reg.FONT_MAIN,22,FlxColor.WHITE,"center");
		add(topText);

		counterText = new FlxText(0,10,SCR_WIDTH,"" +  counter);
		counterText.setFormat(Reg.FONT_MAIN,50,FlxColor.WHITE,"center");
		counterText.color = 0xefefefff;
		add(counterText);

		//trophy award UI
		bronzeTrophyIcon = new FlxSprite(400,10);
		bronzeTrophyIcon.loadGraphic(Reg.TROPHY_BRONZE);
		bronzeTrophyIcon.visible = false;
		add(bronzeTrophyIcon);

		silverTrophyIcon = new FlxSprite(400,10);
		silverTrophyIcon.loadGraphic(Reg.TROPHY_SILVER);
		silverTrophyIcon.visible = false;
		add(silverTrophyIcon);

		goldTrophyIcon = new FlxSprite(400,10);
		goldTrophyIcon.loadGraphic(Reg.TROPHY_GOLD);
		goldTrophyIcon.visible = false;
		add(goldTrophyIcon);

		trophyPlus = new FlxText(425,20,60,"+1");
		trophyPlus.setFormat(Reg.FONT_MAIN,20,FlxColor.WHITE,"center");
		trophyPlus.visible = false;
		add(trophyPlus);

		bgProgress = new FlxSprite(140,84);
		bgProgress.makeGraphic(220,25,FlxColor.GRAY);
		bgProgress.alpha = 0.2;
		add(bgProgress);

		underlineProgress = new FlxSprite(150,102);
		underlineProgress.makeGraphic(GOAL_POINTS,1,0xFF7F863B);
		add(underlineProgress);

		goalProgress = new FlxSprite(141 + GOAL_POINTS,90);
		goalProgress.loadGraphic(Reg.GOAL_PROGRESS);
		add(goalProgress);

		ranaProgress = new FlxSprite(RANA_PROGRESS_INIT_X,90);
		ranaProgress.loadGraphic(Reg.RANA_PROGRESS);
		add(ranaProgress);

		//Music
		bgMusic = FlxG.sound.play(Reg.MUS_STAGE,0.55,true,true,null);
	}

	override public function update(elapsed:Float):Void
	{


		//hides new trophy if visible
		if (timeShowTrophy > 0){
			timeShowTrophy--;	
		}else{
			bronzeTrophyIcon.visible = false;
			silverTrophyIcon.visible = false;
			goldTrophyIcon.visible = false;
			trophyPlus.visible = false;
		}

		if (isGameOver){
			if (retryButton != null){
				retryButton.update(elapsed);	
			}
			if (quitButton != null){
				quitButton.update(elapsed);	
			}
			if (backButton != null){
				backButton.update(elapsed);	
			}
			if (ranaEffect != null){
				ranaEffect.update(elapsed);
			}
			return;
		}

		super.update(elapsed);

		//collision
		FlxG.collide(floorElements,rana,FlxObject.separate);

		for (o in obstacles){
			if (FlxG.pixelPerfectOverlap(rana,o)){
				FlxG.sound.play( Reg.SND_HIT1,0.9,false,true,null);
				ranaCrashed();
				break;
			}
		}

		if (!isGameOver && rana.y > SCR_HEIGHT){
			ranaCrashed();
		}

		//update state
		if (moving){
			floorBG.x -= speed;
			if (floorBG.x <= -floorBG.width/2){
				floorBG.x = 0;
			}

			//moves obstacles
			for (o in obstacles){
				o.x -= speed;
				if (!o.isOnScreen()){
					obstacles.remove(o);
					o.destroy();
				}
				if (o.active && o.x+o.width < rana.x){
					FlxG.sound.play(Reg.SND_POINT1,0.9,false,true,null);
					o.active = false;
					updateScore();
				}
			}

			//moves floor tiles
			for(f in floorElements){
				f.x -= speed;

				if (f.ID == -1 && f.active && f.x+f.width < rana.x){
					FlxG.sound.play(Reg.SND_POINT1,0.9,false,true,null);
					f.active = false;
					updateScore();
				}

				if (!f.isOnScreen()){
					floorElements.remove(f);
					f.destroy();
				}
			}

			//scrolls background layers
			bg1.x -= speed/4;
			bg2.x -= speed/8;
			bg3.x -= speed/16;
			if (bg1.x <= -bg1.width/2){
				bg1.x = 0;
			}
			if (bg2.x <= -bg2.width/2){
				bg2.x = 0;
			}
			if (bg3.x <= -bg3.width/2){
				bg3.x = 0;
			}

			//scrolls waterline
			fgWater.x -= speed;
			if (fgWater.x <= -fgWater.width/2){
				fgWater.x = 0;
			}


			//---- Course generation ----

			// trace("PATH: " + currentPath + " Tile: " + tilePointer);

			//get last floor tile
			var last:FlxSprite = null;
			for (f in floorElements){
				//gets last floor tile
				if (last == null){
					last = f;
				}
				if (last.x < f.x){
					last = f;
				}
			}

			//do we need a new tile?
			if (last != null && (last.x + last.width <= SCR_WIDTH)){
				if (last.x <= SCR_WIDTH){
					//if pointer mod 10, chanRoll to see if we change path
					if (tilePointer % STRETCH_SIZE == 0){
						var rnd = new FlxRandom();
						if (counter >= LEVEL5_POINTS && counter < LEVEL6_POINTS){
							currentPath = rnd.int(4,7);	//default (4,7)
						}else if (counter >= LEVEL6_POINTS){
							currentPath = rnd.int(8,11);	//default (8,11)
						}else{
							currentPath = rnd.int(0,3); //default (0,3)
						}
						
						trace("switched to path: " + currentPath);
					}

					//load tile from pointer position
					switch(PATH_MATRIX[currentPath][tilePointer]){
						//if hole
						case -1: createHoleTile(SCR_WIDTH);
						//if floor
						case 0: createFloorTile(SCR_WIDTH);
						//if rock
						case 1:
								var o = createObstacle(SCR_WIDTH,0,"ROCK");
								o.y = SCR_HEIGHT - o.height;
								o.active = true;
								obstacles.add(o);
								createFloorTile(SCR_WIDTH);
						//if trunk
						case 2:
								var o = createObstacle(SCR_WIDTH,0,"TRUNK");
								o.y = SCR_HEIGHT - o.height*2;
								o.active = true;
								obstacles.add(o);
								createFloorTile(SCR_WIDTH);
						//if branch
						case 3:
								var o = createObstacle(SCR_WIDTH,0,"BRANCH");
								o.y = SCR_HEIGHT - o.height*5;
								o.active = true;
								obstacles.add(o);
								createFloorTile(SCR_WIDTH);
						default: createFloorTile(SCR_WIDTH);
					}
					tilePointer++;
					if (tilePointer >= PATH_MATRIX[0].length){
						tilePointer = 0;
					}
				}
			}
		}

		rana.acceleration.y = gravity;

		if (rana.isTouching(FlxObject.DOWN) && isJumping){
			// trace("grounded!");
			isJumping = false;
			rana.animation.play("run");
		}

		//input
		if ((FlxG.keys.justPressed.SPACE || FlxG.mouse.justPressed) && !isJumping && rana.isTouching(FlxObject.DOWN)){
			// trace("jump!");
			if (tapText.visible){
				tapText.visible = false;
			}
			FlxG.sound.play( Reg.SND_JUMP1,0.8,false,true,null);
			isJumping = true;
			rana.animation.play("jump");
			rana.acceleration.y = -jump_accel;
		}
	}

	override public function destroy():Void
	{
		super.destroy();

		rana.destroy();
		floorBG.destroy();
		wave.destroy();
		obstacles.destroy();
		floorElements.destroy();
		rainEmitter.destroy();
		bg1.destroy();
		bg2.destroy();
		bg3.destroy();
		fgWater.destroy();
		waveFG.destroy();
		counterText.destroy();
		topText.destroy();
		signTop.destroy();
		tapText.destroy();
		gameSave.destroy();
		bgMusic.destroy();
		goldTrophyIcon.destroy();
		silverTrophyIcon.destroy();
		goldTrophyIcon.destroy();
		trophyPlus.destroy();
		ranaProgress.destroy();
		goalProgress.destroy();
		underlineProgress.destroy();
		bgProgress.destroy();

		if (abductLight != null){
			abductLight.destroy();
		}

		if (alienShip != null){
			alienShip.destroy();
		}

		if (ranaEffect != null){
			ranaEffect.destroy();
		}

		if (retryButton != null){
			retryButton.destroy();
			retryText.destroy();
		}
		
		if (quitButton != null){
			quitText.destroy();
			quitButton.destroy();
		}

		if (gameOverText != null){
			gameOverText.destroy();
		}

		if (youWonText != null){
			youWonText.destroy();
		}

		if (backButton != null){
			backButton.destroy();
			backButtonText.destroy();
		}
	}

	private function updateScore():Void{
		counter++;
		counterText.text = "" + counter;
		ranaProgress.x = RANA_PROGRESS_INIT_X + counter;

		if (counter > topScore){
			//updates and saves new top score
			topScore = counter;
			gameSave.data.topScore = topScore;
			gameSave.flush();
			trace("topScore beaten, updating with: " + gameSave.data.topScore);
			topText.text = "" + topScore;
		}

		if (counter % BRONZE_TROPHY_AMOUNT == 0){
			gameSave.data.bronzeTrophy = gameSave.data.bronzeTrophy +1;

			if (gameSave.data.bronzeTrophy > 999){
				gameSave.data.bronzeTrophy = 999;
			}

			gameSave.flush();

			trace("bronzeTrophy added, updating with: " + gameSave.data.bronzeTrophy);

			bronzeTrophyIcon.visible = true;
			trophyPlus.visible = true;
			timeShowTrophy = TROPHY_AWARD_SHOW_TIME;

			FlxG.sound.play(Reg.SND_TROPHY,0.8,false,true,null);
		}

		if (counter % SILVER_TROPHY_AMOUNT == 0){
			gameSave.data.silverTrophy = gameSave.data.silverTrophy +1;
			
			if (gameSave.data.silverTrophy > 999){
				gameSave.data.silverTrophy = 999;
			}

			gameSave.flush();

			trace("silverTrophy added, updating with: " + gameSave.data.silverTrophy);

			silverTrophyIcon.visible = true;
			trophyPlus.visible = true;
			timeShowTrophy = TROPHY_AWARD_SHOW_TIME;

			FlxG.sound.play(Reg.SND_TROPHY,0.8,false,true,null);
		}

		if (counter % GOLD_TROPHY_AMOUNT == 0){
			gameSave.data.goldTrophy = gameSave.data.goldTrophy +1;

			if (gameSave.data.goldTrophy > 999){
				gameSave.data.goldTrophy = 999;
			}

			gameSave.flush();

			trace("goldTrophy added, updating with: " + gameSave.data.goldTrophy);

			goldTrophyIcon.visible = true;
			trophyPlus.visible = true;
			timeShowTrophy = TROPHY_AWARD_SHOW_TIME;

			FlxG.sound.play(Reg.SND_TROPHY,0.8,false,true,null);
		}

		if (counter == LEVEL2_POINTS){
			current_level++;
			updateDifficultyLevel(current_level);
			rainEmitter.frequency = 0.02;
		}
		if (counter == LEVEL3_POINTS){
			current_level++;
			updateDifficultyLevel(current_level);
			rainEmitter.frequency = 0.02;
		}
		if (counter == LEVEL4_POINTS){
			current_level++;
			updateDifficultyLevel(current_level);
			rainEmitter.frequency = 0.01;
		}
		if (counter == LEVEL5_POINTS){
			current_level++;
			updateDifficultyLevel(current_level);
			rainEmitter.frequency = 0.008;
		}

		if (counter >= GOAL_POINTS){
			ranaWon();
		}
	}

	private function updateDifficultyLevel(level:Int){
		if (level == 2){
			speed = LEVEL2_SPEED;
			var anim = rana.animation.getByName("run");
			anim.frameRate = LEVEL2_ANIM_SPEED;
			jump_accel = JUMP_ACCEL_LEVEL2;
			gravity = GRAVITY_LEVEL2;
		}
		if (level == 3){
			speed = LEVEL3_SPEED;
			var anim = rana.animation.getByName("run");
			anim.frameRate = LEVEL3_ANIM_SPEED;
			jump_accel = JUMP_ACCEL_LEVEL3;
			gravity = GRAVITY_LEVEL3;
		}
		if (level == 4){
			speed = LEVEL4_SPEED;
			var anim = rana.animation.getByName("run");
			anim.frameRate = LEVEL4_ANIM_SPEED;
			jump_accel = JUMP_ACCEL_LEVEL4;
			gravity = GRAVITY_LEVEL4;
		}
	}

	private function ranaCrashed():Void{

		//lose music
		FlxG.sound.play(Reg.MUS_LOSE,0.5,false,true,null);

		//animates wave
		FlxTween.linearMotion(waveFG, waveFG.x, waveFG.y, waveFG.x + FlxG.width*2, waveFG.y, 1, true, {ease: FlxEase.expoIn,type: FlxTween.ONESHOT });
		FlxG.sound.play(Reg.SND_WAVE,0.8,false,true,null);

		bgMusic.stop();
		//Play sad sound

		if (tapText.visible){
			tapText.visible = false;
		}

		isGameOver = true;
		moving = false;
		gameOverText = new FlxText(0,120,SCR_WIDTH,"GAME OVER");
		gameOverText.setFormat(Reg.FONT_MAIN,40,FlxColor.WHITE,"center");
		gameOverText.borderStyle = FlxTextBorderStyle.SHADOW;
		add(gameOverText);

		retryButton = new FlxButton(140,180,null,retry);
		retryButton.loadGraphic(Reg.RETRY_BUTTON_NORMAL);
		add(retryButton);

		retryText = new FlxText(140,200,250,"Retry");
		retryText.color = FlxColor.WHITE;
		retryText.setFormat(Reg.FONT_MAIN,30,FlxColor.WHITE,"center");
		add(retryText);

		quitButton = new FlxButton(185,280,null,quit);
		quitButton.loadGraphic(Reg.QUIT_BUTTON_NORMAL);
		add(quitButton);

		quitText = new FlxText(185,290,150,"Quit");
		quitText.color = FlxColor.WHITE;
		quitText.setFormat(Reg.FONT_MAIN,23,FlxColor.WHITE,"center");
		add(quitText);
	}

	private function retry():Void{
		// trace("retry");
		if (isRetryButtonPressed || isQuitButtonPressed){
			return;
		}

		retryButton.loadGraphic(Reg.RETRY_BUTTON_PRESSED);
		isRetryButtonPressed = true;
		FlxG.resetState();
	}

	private function quit():Void{
		// trace("quit");
		if (isQuitButtonPressed || isRetryButtonPressed){
			return;
		}
		quitButton.loadGraphic(Reg.QUIT_BUTTON_PRESSED);
		isQuitButtonPressed = true;
		FlxG.switchState(new TitleState());
	}

	private function backButtonPressed():Void{
		if (isBackButtonPressed){
			return;
		}

		isBackButtonPressed = true;
		backButton.loadGraphic(Reg.RETRY_BUTTON_PRESSED);
		FlxG.switchState(new TitleState());	
	}


	private function createObstacle(x,y,type:String):FlxSprite{
		if (type == "ROCK"){
			var rock = new FlxSprite(x,y);
			rock.immovable = true;
			rock.loadGraphic(Reg.ROCK,false,100,100,false,"rock");
			return rock;
		}
		if (type == "TRUNK"){
			var trunk = new FlxSprite(x,y);
			trunk.immovable = true;
			trunk.loadGraphic(Reg.TRUNK,false,150,50,false,"trunk");
			return trunk;
		}
		if (type == "BRANCH"){
			var branch = new FlxSprite(x,y);
			branch.immovable = true;
			branch.loadGraphic(Reg.BRANCH,false,40,40,false,"branch");
			return branch;
		}
		return null;
	}

	private function createFloorTile(x:Float):FlxSprite{
			var tile = new FlxSprite(x,0);
			tile.makeGraphic(200,50,GRASS_COLOR);
			tile.y = SCR_HEIGHT-tile.height;
			tile.allowCollisions = FlxObject.CEILING;
			tile.immovable = true;
			tile.alpha = 0;
			tile.ID = 0;
			floorElements.add(tile);
			return tile;
	}

	private function createHoleTile(x:Float):FlxSprite{
			var tile = new FlxSprite(x,0);
			tile.loadGraphic(Reg.HOLE);
			tile.y = SCR_HEIGHT-tile.height-20;
			tile.allowCollisions = FlxObject.NONE;
			tile.immovable = true;
			tile.ID = -1;
			floorElements.add(tile);
			return tile;
	}

	private function startRaining(freq:Float):Void{
		rainEmitter.start(false, freq);
	}



	//Ending and cutscene

	private function ranaWon():Void{

		ranaProgress.visible = false;
		underlineProgress.visible = false;
		goalProgress.visible = false;
		bgProgress.visible = false;

		gameSave.data.alienTrophy = gameSave.data.alienTrophy +1;

		if (gameSave.data.alienTrophy > 999){
			gameSave.data.alienTrophy = 999;
		}

		gameSave.flush();

		trace("alienTrophy added, updating with: " + gameSave.data.bronzeTrophy);

		isGameOver = true;
		moving = false;

		bgMusic.stop();

		waveTween.cancel();
		rainEmitter.emitting = false;

		if (tapText.visible){
			tapText.visible = false;
		}

		var waveTween = FlxTween.linearMotion(wave, wave.x, wave.y,wave.x, wave.y*2,2, true, {ease: FlxEase.expoInOut,type: FlxTween.ONESHOT });
		waveTween.then(FlxTween.linearMotion(alienShip, 250, -100, 250, 40, 2.5, true, {ease: FlxEase.expoIn,onStart: alienStarted, onComplete: alienFinished, type: FlxTween.ONESHOT }));
		FlxG.sound.play(Reg.SND_WAVE,0.8,false,true,null);
	}

	private function alienStarted(tween:FlxTween):Void{
		trace("alien started moving");
		alienShip.visible = true;
		FlxG.sound.play(Reg.SND_ALIEN,0.8,false,true,null);
	}

	private function alienFinished(tween:FlxTween):Void{
		trace("alien finished moving");
		
		FlxG.sound.play(Reg.SND_ABDUCT,0.8,false,true,null);

		//start abduct animation
		ranaEffect= new FlxEffectSprite(rana, [new FlxWaveEffect(FlxWaveMode.ALL,8,0.5,5,5)]);
		ranaEffect.x = rana.x;
		ranaEffect.y = rana.y;
		add(ranaEffect);

		rana.visible = false;
		
		abductLight.visible = true;
	
		var timer = new FlxTimer();		
		timer.start(3, abductFinished,1);
	}

	private function abductFinished(FlxTimer):Void{
		abductLight.visible = false;
		ranaEffect.visible = false;
		FlxTween.linearMotion(alienShip, 250, 40, 250, -100, 2, true, {ease: FlxEase.expoIn,onStart: alienStartedLeaving, onComplete: alienFinishedLeaving, type: FlxTween.ONESHOT });
	}

	private function alienStartedLeaving(tween:FlxTween):Void{
		trace("alien started leaving");
		FlxG.sound.play(Reg.SND_ALIEN,0.8,false,true,null);
	}

	private function alienFinishedLeaving(tween:FlxTween):Void{
		trace("alien finished leaving");

		//PLAY SOUND WIN

		var timer = new FlxTimer();		
		timer.start(1, animationFinished,1);
	}

	private function animationFinished(tween:FlxTimer):Void{

		//win music
		FlxG.sound.play(Reg.MUS_WIN,0.8,false,true,null);

		youWonText = new FlxText(0,100,SCR_WIDTH,"YOU WON...");
		youWonText.setFormat(Reg.FONT_MAIN,40,FlxColor.WHITE,"center");
		youWonText.borderStyle = FlxTextBorderStyle.SHADOW;
		add(youWonText);

		backButton = new FlxButton(140,180,null,backButtonPressed);
		backButton.loadGraphic(Reg.RETRY_BUTTON_NORMAL);
		add(backButton);

		backButtonText = new FlxText(140,200,250,"???");
		backButtonText.color = FlxColor.WHITE;
		backButtonText.setFormat(Reg.FONT_MAIN,32,FlxColor.WHITE,"center");
		add(backButtonText);
	}


}
