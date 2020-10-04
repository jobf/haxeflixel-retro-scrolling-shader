package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var isShaderEnabled:Bool;
	var shader:ScrollingShader;
	var bg:FlxSprite;

	override public function create()
	{
		super.create();

		isShaderEnabled = true;
		shader = new ScrollingShader();

		bg = new FlxSprite(0, 0, "assets/images/jungle.png");
		bg.shader = shader;
		add(bg);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (isShaderEnabled)
		{
			shader.update(elapsed);
		}

		if (FlxG.keys.justPressed.F)
		{
			isShaderEnabled = !isShaderEnabled;
		}
	}
}
