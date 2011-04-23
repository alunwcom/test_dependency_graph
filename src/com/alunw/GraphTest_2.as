package com.alunw
{
	import com.adobe.serialization.json.JSON;
	
	import flare.display.TextSprite;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.HoverControl;
	import flare.vis.controls.IControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.layout.RadialTreeLayout;
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
	public class GraphTest_2 extends Sprite
	{
		
		private var _stageLabel:Sprite;

		public function GraphTest_2()
		{
			init();
		}
		
		protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
					
			stage.addEventListener(Event.RESIZE, setStageLabel);
			setStageLabel(null);
			
//			var txt2:TextSprite = new TextSprite("Testing");
//			txt2.font = "Verdana";
//			txt2.size = 18;
//			txt2.color = 0xff3333;
//			txt2.letterSpacing = 1;
//			txt2.x = 250;
//			txt2.y = 100;
//			addChild(txt2);
			
			
			// Build data
			var data:Data = buildData();
			
			// Visualize
			var vis:Visualization = new Visualization(data);
			vis.bounds = new Rectangle(0, 0, 600, 500);
			vis.x = 100;
			vis.y = 50;
			addChild(vis);
			
			vis.operators.add(new RadialTreeLayout(50, false));
			
			vis.operators.add(new PropertyEncoder(
				{alpha: 0, visible:false}, Data.EDGES));
			vis.operators.add(new PropertyEncoder(
				{shape: Shapes.WEDGE, lineColor: 0xffffffff}, Data.NODES));
			vis.operators.add(new PropertyEncoder(
				{angleWidth: -2*Math.PI}, "param"));
			
			vis.controls.add(new HoverControl(NodeSprite,
				// by default, move highlighted items to front
				HoverControl.MOVE_AND_RETURN,
				// highlight node border on mouse over
				function(e:SelectionEvent):void {
					e.node.lineWidth = 2;
					e.node.lineColor = 0x88ff0000;
				},
				// remove highlight on mouse out
				function(e:SelectionEvent):void {
					e.node.lineWidth = 0;
					e.node.lineColor = 0x88ffffff;
				}));
			var ctrl:IControl = new ExpandControl(NodeSprite,
				function():void { vis.update(1, "nodes","main").play(); });
			vis.controls.add(ctrl);	
			vis.continuousUpdates = true;

			

			
			
			
//			vis.setOperator("param", new PropertyEncoder({angleWidth: -2*Math.PI}, "param"));
//			vis.setOperator("nodes", new PropertyEncoder({shape: Shapes.WEDGE, lineColor: 0xffffffff}, "nodes"));
//			vis.setOperator("edges", new PropertyEncoder({alpha: 0, visible:false}, "edges"));

			
			
//			param: {angleWidth: -2*Math.PI},
//			nodes: {shape: Shapes.WEDGE, lineColor: 0xffffffff},
//			edges: {alpha: 0, visible:false}

			
//			vis.operators.add(new AxisLayout("data.date", "data.age"));
//			vis.operators.add(new ColorEncoder("data.cause", Data.NODES,
//				"lineColor", ScaleType.CATEGORIES));
//			vis.operators.add(new ShapeEncoder("data.race"));
//			vis.data.nodes.setProperties({fillColor:0, lineWidth:2});
			vis.update();

		}

		private function setStageLabel(event:Event):void {
			
			if (_stageLabel) {
				removeChild(_stageLabel);
			}
			_stageLabel = new Sprite();
			_stageLabel.x = 10;
			_stageLabel.y = 10;
			_stageLabel.graphics.beginFill(0xe0e0e0);
			_stageLabel.graphics.lineStyle(0, 0x999999);
			_stageLabel.graphics.drawRect(0, 0, 150, 20);
			_stageLabel.graphics.endFill();
			addChild(_stageLabel);

			var txt:TextField = new TextField();
			txt.width = 150;
			_stageLabel.addChild(txt); 
			txt.appendText("Stage size: (" + stage.stageWidth + ", " + stage.stageHeight + ")");
			
		}
		
		public static function buildData():Data
		{
//			var data:Data = new Data();
//			var tree:Tree = new Tree();
//			var map:Object = {};
			
//			var root:NodeSprite = tree.addRoot();
//			tree.addChild(root);
			
			var data:Data = diamondTree(3,5,4);
			
			for (var j:int=0; j<data.nodes.length; ++j) {
				data.nodes[j].data.label = String(j);
				data.nodes[j].buttonMode = true;
			}
			data.nodes.sortBy("depth");
			
//			tree.root = data.addNode({name:"flare", size:0});
//			map.flare = tree.root;

			
			
			
//			var data:Data = new Data();
//			data.addNode({name:"test1", size:1});
//			data.addNode({name:"test2", size:2});
//			data.addNode({name:"test3", size:3});
			
//			var data:Array = [
//				{id:"Q1", sales:10000, profit:2400},
//				{id:"Q2", sales:12000, profit:2900},
//				{id:"Q3", sales:15000, profit:3800},
//				{id:"Q4", sales:15500, profit:3900}
//			];
			
			
//			data.tree = tree;
			return data;

		}
		
		public static function diamondTree(b:int, d1:int, d2:int) : Tree
		{
			var tree:Tree = new Tree();
			var n:NodeSprite = tree.addRoot();
			var l:NodeSprite = tree.addChild(n);
			var r:NodeSprite = tree.addChild(n);
			
			deepHelper(tree, l, b, d1-2, true);
			deepHelper(tree, r, b, d1-2, false);
			
			while (l.firstChildNode != null)
				l = l.firstChildNode;
			while (r.lastChildNode != null)
				r = r.lastChildNode;
			
			deepHelper(tree, l, b, d2-1, false);
			deepHelper(tree, r, b, d2-1, true);
			
			return tree;
		}
		
		private static function deepHelper(t:Tree, n:NodeSprite,
										   breadth:int, depth:int, left:Boolean) : void
		{
			var c:NodeSprite = t.addChild(n);
			if (left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
			
			for (var i:uint = 1; i<breadth; ++i) {
				c = t.addChild(n);
			}
			
			if (!left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
		}
		
		
	}
}