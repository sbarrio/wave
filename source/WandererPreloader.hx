package ;
 
import flixel.system.FlxBasePreloader;
import flash.display.*;
import flash.Lib;
import openfl.display.Sprite;
 


 @:bitmap("assets/images/wanderer.png") class LogoImage extends BitmapData { }
 
class WandererPreloader extends FlxBasePreloader
{
    public function new(MinDisplayTime:Float=0, ?AllowedURLs:Array<String>)
    {
        super(MinDisplayTime, AllowedURLs);
    }


    var logo:Sprite;
     
    override function create():Void 
    {

    	minDisplayTime = 4;

        this._width = Lib.current.stage.stageWidth;
        this._height = Lib.current.stage.stageHeight;
         
        var ratio:Float = this._width / 800; //This allows us to scale assets depending on the size of the screen.
         
        logo = new Sprite();
        logo.addChild(new Bitmap(new LogoImage(0,0))); //Sets the graphic of the sprite to a Bitmap object, which uses our embedded BitmapData class.
        logo.scaleX = logo.scaleY = ratio;
        logo.x = ((this._width) / 2) - ((logo.width) / 2);
        logo.y = (this._height / 2) - ((logo.height) / 2);
        addChild(logo); //Adds the graphic to the NMEPreloader's buffer.
         
        super.create();
    } 
}