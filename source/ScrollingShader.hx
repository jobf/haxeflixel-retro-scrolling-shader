import flixel.system.FlxAssets.FlxShader;

class ScrollingShader extends FlxShader
{
	@:glFragmentSource("
	#pragma header
	
	uniform float scrollBy;
	uniform float splitY;

	float wrap(float toWrap){
		return mod(toWrap, 1);
	}
	
	void main()
	{
		if(openfl_TextureCoordv.y < splitY){

			float x = wrap((scrollBy / openfl_TextureSize.x) + openfl_TextureCoordv.x);
			gl_FragColor = flixel_texture2D(bitmap, vec2(x, openfl_TextureCoordv.y));
		}
		else{
			gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		}
	}
    ")
	public function new()
	{
		super();
		var imageHeight = 512;
		var splitYAt = 399 / imageHeight;
		this.splitY.value = [splitYAt];
		this.scrollBy.value = [0.0];
	}

	public function update(elapsed:Float)
	{
		this.scrollBy.value[0] += (elapsed * 30);
	}
}
