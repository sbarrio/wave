package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{

	// Sprites
	public static inline var TITLE:String = "assets/images/title.png";
	public static inline var TITLEBG:String = "assets/images/titleBG.png";
	public static inline var SIGNPOST:String = "assets/images/signpost.png";
	public static inline var SCREEN_WAVE:String = "assets/images/screen_wave.png";
	public static inline var HUT:String = "assets/images/hut.png";
	public static inline var SMOKE:String = "assets/images/smoke.png";
	public static inline var RAIN_DROP:String = "assets/images/rainDrop.png";
	public static inline var BGTOP:String = "assets/images/top.png";
	public static inline var RANA_GREEN:String = "assets/images/rana_final_green.png";
	public static inline var RANA_RED:String = "assets/images/rana_final_red.png";
	public static inline var RANA_YELLOW:String = "assets/images/rana_final_yellow.png";
	public static inline var RANA_BLUE:String = "assets/images/rana_final_blue.png";
	public static inline var RANA_PURPLE:String = "assets/images/rana_final_purple.png";
	public static inline var ROCK:String = "assets/images/rock.png";
	public static inline var TRUNK:String = "assets/images/trunk.png";
	public static inline var BRANCH:String = "assets/images/branch.png";
	public static inline var HOLE:String = "assets/images/hole.png";
	public static inline var WAVE:String = "assets/images/wave.png";
	public static inline var GRASS:String = "assets/images/grass.png";
	public static inline var TROPHY_BRONZE:String = "assets/images/trophy_bronze.png";
	public static inline var TROPHY_SILVER:String = "assets/images/trophy_silver.png";
	public static inline var TROPHY_GOLD:String = "assets/images/trophy_gold.png";
	public static inline var TROPHY_ALIEN:String = "assets/images/trophy_alien.png";
	public static inline var RANA_PROGRESS:String = "assets/images/ranaProgress.png";
	public static inline var GOAL_PROGRESS:String = "assets/images/goalProgress.png";
	public static inline var ALIEN_SHIP:String = "assets/images/alien_ship.png";
	public static inline var ABDUCT_LIGHT:String = "assets/images/abduct_light.png";

	public static inline var BGTEST:String = "assets/images/bgtest.png";
	public static inline var BG1:String = "assets/images/bg1.png";
	public static inline var BG2:String = "assets/images/bg2.png";
	public static inline var BG3:String = "assets/images/bg3.png";
	public static inline var FG_WATER:String = "assets/images/waterline.png";

	public static inline var START_BUTTON_NORMAL:String = "assets/images/startButtonNormal.png";	
	public static inline var START_BUTTON_PRESSED:String = "assets/images/startButtonPressed.png";	
	public static inline var RETRY_BUTTON_NORMAL:String = "assets/images/retryButtonNormal.png";	
	public static inline var RETRY_BUTTON_PRESSED:String = "assets/images/retryButtonPressed.png";	
	public static inline var QUIT_BUTTON_NORMAL:String = "assets/images/quitButtonNormal.png";	
	public static inline var QUIT_BUTTON_PRESSED:String = "assets/images/quitButtonPressed.png";	

	//Sounds
	public static inline var SND_JUMP1:String = "assets/sounds/jump1.wav";
	public static inline var SND_HIT1:String = "assets/sounds/hit1.wav";
	public static inline var SND_POINT1:String = "assets/sounds/point1.wav";
	public static inline var SND_STEPS1:String = "assets/sounds/steps1.wav";
	public static inline var SND_STEPS2:String = "assets/sounds/steps2.wav";
	public static inline var SND_TROPHY:String = "assets/sounds/trophy.wav";
	public static inline var SND_RAIN:String = "assets/sounds/rain.wav";
	public static inline var SND_WAVE:String = "assets/sounds/wave.wav";
	public static inline var SND_LOSE:String = "assets/sounds/rain.wav";
	public static inline var SND_WIN:String = "assets/sounds/rain.wav";
	public static inline var SND_ALIEN:String = "assets/sounds/alien.wav";
	public static inline var SND_ABDUCT:String = "assets/sounds/abduct.wav";


	//Music
	public static inline var MUS_STAGE:String = "assets/music/stage.wav";
	public static inline var MUS_WIN:String = "assets/music/win.wav";
	public static inline var MUS_LOSE:String = "assets/music/lose.wav";


	//Fonts
	public static inline var FONT_MAIN:String = "assets/fonts/PressStart2P.ttf";	


	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
}