package
{
	import com.cloakentertainment.pokemonline.world.map.ChunkManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;
	import com.cloakentertainment.pokemonline.Configuration;
	
	public class FPSCounter extends Sprite
	{
		private var last:uint = getTimer();
		private var ticks:uint = 0;
		private var tf:TextField;
		
		public function FPSCounter(xPos:int = 0, yPos:int = 0, color:uint = 0xffffff, fillBackground:Boolean = false, backgroundColor:uint = 0x000000)
		{
			x = xPos;
			y = yPos;
			tf = new TextField();
			tf.textColor = color;
			tf.text = "v" + Configuration.VERSION + " - 60.0 fps - 00.00 MB - 0 chunks" + " - " + ChunkManager.CENTER_X_TILE + "x" + ChunkManager.CENTER_Y_TILE;
			tf.selectable = false;
			tf.background = fillBackground;
			tf.backgroundColor = backgroundColor;
			tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(tf);
			width = tf.textWidth;
			height = tf.textHeight;
			addEventListener(Event.ENTER_FRAME, tick);
			//tf.visible = false;
		}
		
		public function tick(evt:Event):void
		{
			ticks++;
			var now:uint = getTimer();
			var delta:uint = now - last;
			if (delta >= 1000)
			{
				//trace(ticks / delta * 1000+" ticks:"+ticks+" delta:"+delta);
				var mem:String = Number(System.totalMemory / 1024 / 1024).toFixed(2) + " MB";
				var fps:Number = ticks / delta * 1000;
				tf.text = "v" + Configuration.VERSION + " - " + fps.toFixed(1) + " fps - " + mem + " - " + ChunkManager.CHUNKS + " chunks" + " - " + ChunkManager.CENTER_X_TILE + "x" + ChunkManager.CENTER_Y_TILE;
				ticks = 0;
				last = now;
			}
		}
	}
}