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

	// x : 0 = false, 1 = true
	// y : position of splity on y axis
	// z : amount to scroll by
	uniform vec3 splitA;
	uniform vec3 splitB;

	float wrap(float toWrap){
		return mod(toWrap, 1);
	}
	
	float when_eq(float a, float b) {
		return 1.0 - abs(sign(a - b));
	}

	float when_lt(float a, float b) {
		return max(sign(b - a), 0.0);
	}

	float when_gt(float a, float b) {
		return max(sign(a - b), 0.0);
	}

	void main()
	{
		float x = openfl_TextureCoordv.x;
		x += (splitA.z / openfl_TextureSize.x) * when_lt(openfl_TextureCoordv.y, splitA.y) * when_eq(splitA.x, 1.0);
		x += (splitB.z / openfl_TextureSize.x) * when_lt(openfl_TextureCoordv.y, splitB.y) * when_eq(splitB.x, 1.0) * when_gt(openfl_TextureCoordv.y, splitA.y);

		gl_FragColor = flixel_texture2D(bitmap, vec2(wrap(x), openfl_TextureCoordv.y));
	}
	")
	var splitDefinitions:Array<ParallaxSplit>;

	public function new()
	{
		super();
		var imageHeight = 512;

		splitDefinitions = [
			{SplitY: calculateShaderCoord(191, imageHeight), Speed: 10.0},
			{SplitY: calculateShaderCoord(399, imageHeight), Speed: 30.0}
		];

		this.splitA.value = [0, 0, 0];
		this.splitA.value[0] = 1;
		this.splitA.value[1] = splitDefinitions[0].SplitY;
		this.splitA.value[2] = splitDefinitions[0].Speed;

		this.splitB.value = [0, 0, 0];
		this.splitB.value[0] = 1;
		this.splitB.value[1] = splitDefinitions[1].SplitY;
		this.splitB.value[2] = splitDefinitions[1].Speed;
	}

	function calculateShaderCoord(pixelPosition:Int, imageSize:Int):Float
	{
		return pixelPosition / imageSize;
	}

	public function update(elapsed:Float)
	{
		this.splitA.value[2] += (elapsed * splitDefinitions[0].Speed);
		this.splitB.value[2] += (elapsed * splitDefinitions[1].Speed);
	}
}
