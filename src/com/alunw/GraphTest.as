package com.alunw
{
	import com.adobe.serialization.json.JSON;
	
	import flare.vis.Visualization;
	import flare.widgets.ProgressBar;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	[SWF(backgroundColor="#ffffdd", frameRate="30")]
	public class GraphTest extends Sprite
	{
		
		private var _url:String = 
			"http://flare.prefuse.org/data/flare.json.txt";
		private var _vis:Visualization;
		private var _bar:ProgressBar;
		private var _bounds:Rectangle;
		private var _txt:TextField;
		private var container:Sprite;

		public function GraphTest()
		{
			init();
		}
		
		protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			container = new Sprite();
			container.x = 400;
			container.y = 100;
			//container.width = 400;
			//container.height = 200;
			container.graphics.beginFill(0xc0c0c0);
			container.graphics.lineStyle(1, 0x999999);
			container.graphics.drawRect(0, 0, 300-1, 100-1);
			container.graphics.endFill();
			addChild(container);
			
			_txt = new TextField();
			container.addChild(_txt);
			_txt.width = 300;
			_txt.appendText("Stage width: " + stage.stageWidth);
			_txt.appendText("\nStage height: " + stage.stageHeight);
			_txt.appendText("\nContainer width: " + container.width);
			_txt.appendText("\nContainer height: " + container.height);
			_txt.appendText("\nDate/time: " + new Date());
			
			_bounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

			var container2:Sprite = new Sprite();
			container2.x = 400;
			container2.y = 250;
			//container2.width = 600;
			container2.graphics.beginFill(0xeeeeee);
			container2.graphics.lineStyle(0, 0xFF8080);
			container2.graphics.drawRoundRect(0, 0, 400, 150, 16);
			container2.graphics.endFill();
			addChild(container2);
			
			// create progress bar
			container2.addChild(_bar = new ProgressBar());
			_bar.bar.filters = [new DropShadowFilter(1)];
			
			// load data file
			var ldr:URLLoader = new URLLoader(new URLRequest(_url));
			_bar.loadURL(ldr, function():void {
				var obj:Array = JSON.decode(ldr.data as String) as Array;
//				var data:Data = buildData(obj);
//				visualize(data);
//				_bar = null;
			});
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			//onStageResize(null);

		}

		protected function onStageResize(event:Event):void {
			container.removeChild(_txt);
			_txt = new TextField();
			_txt.width = 300;
			container.addChild(_txt); 
			_txt.appendText("Stage resize: (" + stage.stageWidth + ", " + stage.stageHeight + ")");
			
		}

	}
}