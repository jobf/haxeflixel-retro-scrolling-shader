import flixel.system.FlxAssets.FlxShader;

typedef ParallaxSplit =
{
	SplitY:Float,
	Speed:Float
}

class ScrollingShader extends FlxShader
{
	@:glFragmentSource("
	#pragma header

	// x : < 1 = false, 1 = true
	// y : position of splity on y axis
	// z : amount to scroll by
	uniform vec3 splitA;

	float wrap(float toWrap){
		return mod(toWrap, 1);
	}
	
	void main()
	{
		if(openfl_TextureCoordv.y < splitA.y){

			float x = wrap((splitA.z / openfl_TextureSize.x) + openfl_TextureCoordv.x);
			gl_FragColor = flixel_texture2D(bitmap, vec2(x, openfl_TextureCoordv.y));
		}
		else{
			gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		}
	}
	")
	var splitDefinitions:Array<ParallaxSplit>;

	public function new()
	{
		super();
		var imageHeight = 512;
		splitDefinitions = [{SplitY: calculateShaderCoord(399, imageHeight), Speed: 30.0}];
		this.splitA.value = [0, 0, 0];
		this.splitA.value[0] = 1;
		this.splitA.value[1] = splitDefinitions[0].SplitY;
		this.splitA.value[2] = splitDefinitions[0].Speed;
	}

	function calculateShaderCoord(pixelPosition:Int, imageSize:Int):Float
	{
		return pixelPosition / imageSize;
	}

	public function update(elapsed:Float)
	{
		this.splitA.value[2] += (elapsed * splitDefinitions[0].Speed);
	}
}
