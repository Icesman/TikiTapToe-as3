package
{
	import flash.geom.Point;
	
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.display.graphics.Graphic;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Old extends Sprite
	{
		public var main:Old;
		public var SCR_WIDTH:int = 465, SCR_HEIGHT:int = 465;
		private var board:Array;
		private var turn:int = 1;
		public var shape:Shape = new Shape();
		public var basew:int = 100;
		public var basen:int = 4;
		public function Old()
		{
			addEventListener(TouchEvent.TOUCH,handleTouch);
			addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event):void {		
			main = this;
			useHandCursor = true;
			SCR_WIDTH =  stage.stageWidth;
			SCR_HEIGHT = stage.stageHeight;
			basew = SCR_WIDTH / basen;
			trace(SCR_WIDTH);
			
			//initializeFirst();
			initBoard();
			
		}
		public var pos:Point = new Point();
		
		public function handleTouch(e:TouchEvent):void {		
			var touch:Touch = e.getTouch(main.stage);
			if (!touch)
				return;
			var mousePos:Point = touch.getLocation(main.stage);
			
			switch(touch.phase) {
				case TouchPhase.BEGAN:
					//isPressing = true;
					pos.x = mousePos.x; 
					pos.y = mousePos.y;
					break;
				case TouchPhase.MOVED:				
					pos.x = mousePos.x; 
					pos.y = mousePos.y;			
					break;
				case TouchPhase.ENDED:
					//isPressing = false;			
					//trace(e.target);
					//isPressing = handleHUD();				
					trace(pos);
					//trace(isPressing);
					onClick()
					break;
			}
		}
		
		private function initializeFirst():void {
			
		}
		
		private function onClick():void
		{
			var i:int = pos.x/155 >> 0;
			var j:int = pos.y/155 >> 0;
			
			if(board[i][j] == 0)
			{
				board[i][j] = turn;
				if(turn == 1)
				{
					drawX(i,j);
					turn=2;
				}
				else
				{
					drawO(i,j);
					turn=1;
				}
			}
			
			var win:int = checkWin();
			if(win != 0)
			{
				trace(win);
			}
		}
		
		private function initBoard():void
		{
			board = [[0,0,0],[0,0,0],[0,0,0]];
			turn = 1;
			
			addChild(shape);
			shape.graphics.clear();
			shape.graphics.lineStyle(6,0x0);
			for(var i:int = 1; i<=(basen-1); i++)
			{
				shape.graphics.moveTo(basew*i, 0);
				shape.graphics.lineTo(basew*i, basew*basen);
				shape.graphics.moveTo(0, basew*i);
				shape.graphics.lineTo(basew*basen, basew*i);
			}
			
		}
		
		private function drawX(i:int, j:int):void
		{
			shape.graphics.lineStyle(12, 0xFF0000);
			shape.graphics.moveTo(basew*i + 35, basew*j + 35);
			shape.graphics.lineTo(basew*i + basew, basew*j + basew);
			shape.graphics.moveTo(basew*i + 35, basew*j + 115);
			shape.graphics.lineTo(basew*i + basew, basew*j + 35);
		}
		
		private function drawO(i:int, j:int):void
		{
			shape.graphics.lineStyle(12, 0x0000FF);
			shape.graphics.drawCircle(basew*i + 75, basew*j + 75, 40);
		}
		
		private function checkWin():int
		{
			for(var i:int = 0; i<3; i++)
			{
				if(board[i][0] != 0 
					&& board[i][0] == board[i][1] 
					&& board[i][0] == board[i][2])
					return board[i][0];
				
				if(board[0][i] != 0 
					&& board[0][i] == board[1][i] 
					&& board[0][i] == board[2][i])
					return board[0][i];
			}
			
			if(board[0][0] != 0 
				&& board[0][0] == board[1][1] 
				&& board[0][0] == board[2][2])
				return board[0][0];
			
			if(board[0][2] != 0 
				&& board[0][2] == board[1][1] 
				&& board[0][2] == board[2][0])
				return board[0][2];
			
			return 0;
		}
		
	}
}