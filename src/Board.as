package
{

	import flash.utils.ByteArray;
	
	import starling.textures.Texture;
	
	//import starling.textures.Texture;

	public class Board
	{
		public var limit:int = Constants.BOARD_LIMIT;
		public var moves:Array = [];
		public var GAMESTATE:int = -1;
		public var current:Array = [];
		public var lastMove:Object = {1:null,2:null};
		public var totalMoves:int = limit * limit;
		public var width:Number = Constants.BOARD_WIDTH;
		public var height:Number = Constants.BOARD_HEIGHT;
		
		public var baseTexture:Texture;
		
		public function Board(texture:Texture)
		{
		 	baseTexture = texture;
			var piecebaseImage:Move;
			var c:int = 1;
			var space:Number = width / limit;
			for (var i:int = 1; i<=limit; i++) {
				for (var ii:int = 1; ii <= limit; ii++){
					//piecebaseImage = new Image(Texture.fromBitmap(piecebaseBitmap));
					//Texture.fromBitmap(piecebaseBitmap)
					piecebaseImage = new Move(baseTexture, i+","+ii);					
					piecebaseImage.x = (i-1) * space;
					piecebaseImage.y = (ii-1) * space;
					piecebaseImage.width = piecebaseImage.height = space;
					var p1:String = ((i-1) != 0 ? (i-1) : limit)+ii.toString();
					if ((i == 1 && ii >= (limit * 0.5)+1)) {
						p1 = "00";
					}
					var p2:String = ((i+1) != limit+1 ? (i+1) : 1)+ii.toString()
					if ((i == limit && ii <= (limit * 0.5))) {
						p2 = "00";
					}
					var p3:String = i.toString()+ ((ii-1) != 0 ? (ii-1) : limit);
					if ((ii == 1 && i >= (limit * 0.5)+1)) {
						p3 = "00";
					}
					var p4:String = i.toString()+ ((ii+1) != limit+1 ? (ii+1) : 1);
					if ((ii == limit && i <= (limit * 0.5))) {
						p4 = "00";
					}
					//var z:Array = [p1,p2,p3,p4];
					//piecebaseImage.data = {p: i.toString()+ ii, z: z, player: 0};
					piecebaseImage.nextPosition = [p1,p2,p3,p4];
					piecebaseImage.position = i.toString()+ ii;
					piecebaseImage.player = 0;
					//innerContainer.addChild(piecebaseImage);
					moves.push(piecebaseImage);
					c++;					
				}
			}
		}
		
		public function ApplyMove(move:Move):void {
			//var valid:Array = GetAvailableMoves(m.player,false);
			for each(var m:Move in moves) {
				var mindex:int = m.nextPosition.indexOf(move.position);
				if (mindex  > -1) {
					m.nextPosition.splice(mindex,1);
				}				
				if (m.position == move.position){
					m = move;					
				}
			}
			lastMove[move.player] = current.length;
			current.push(move);
			
			UpdateGameState();
		}
		
		public function getScore():Array {
			var score:Array = [0,0,0];
			for each(var m:Move in moves) {
				score[m.player]++;
			}
			return score;
		}
		
		public function CheckGameState():int {
			
			var availMoves1:Array = GetAvailableMoves(1);
			var availMoves2:Array = GetAvailableMoves(2);			
			var score:Array = getScore();				
			if (availMoves1.length == 0 && availMoves2.length == 0) {
				if (score[1] > score[2]) {
					return 1;
				} else if (score[2] > score[1]) {
					return 2;
				} else {
					return 0;
				}
			} else {
				return -1;
			}
			
		}
		
		public function GetLastMove(player:int):Move {
			var last:Move;
			if (current.length >= 2){
				var ri:int = 1
				last = current[current.length - ri] as Move;
				while (last.player != player && current.length != ri){
					ri ++;
					last = current[current.length - ri];
				}					
				if (last.player != player) {
					last = current[current.length - 2];
				}				
			} 
			
			return last;
		}
		
		public function GetAvailableMoves(player:int,useclone:Boolean=true):Array {
			var availMoves:Array = [];
			var last:Move = GetLastMove(player);
			var newmove:Move;
			for each(var m:Move in moves) {
				if (current.length <= 1 && m.player == 0) {
					if (useclone) {
						newmove = new Move(baseTexture);
						newmove.clone(m);
						newmove.player = player;
						availMoves.push(newmove);
					} else {
						availMoves.push(m);
					}
				} else if (last && last.nextPosition.indexOf(m.position) > -1 && m.player == 0) {
					if (useclone) {
						newmove = new Move(baseTexture);
						newmove.clone(m);
						newmove.player = player;
						availMoves.push(newmove);
					} else {
						availMoves.push(m);
					}
				}
			}
			
			return availMoves;
		}
		
		public function TestForEmptyCells():Boolean {
			var availMoves1:Array = GetAvailableMoves(1);
			var availMoves2:Array = GetAvailableMoves(2);
			if (availMoves1.length == 0 && availMoves2.length == 0) {
				return false;
			} else {
				return true;
			} 
		}
		
		public function UpdateGameState():void {
			GAMESTATE = CheckGameState();
			trace('current gamestate: '+GAMESTATE);
		}
		
		public function EvaluateTable(player:int):Number
		{
			
			if ((player == 1) && (GAMESTATE == 1))
				return 1.0;
			
			if ((player == 2) && (GAMESTATE == 2))
				return 1.0;
			
			if ((player == 1) && (GAMESTATE == 2))
				return -1.0;
			
			if ((player == 2) && (GAMESTATE == 1))
				return -1.0;
			
			return 0.0;
		}
		
		public function clone(b:Board):void {
			
			GAMESTATE = b.GAMESTATE;
			limit = cloneObject(b.limit);
			var newmoves:Array = [];
			var newcurrent:Array = [];
			var newmove:Move;

			for each (var m:Move in b.moves){
				newmove = new Move(baseTexture);
				newmove.clone(m);
				newmoves.push(newmove);
			}
			for each (m in b.current){
				newmove = new Move(baseTexture);
				newmove.clone(m);
				newcurrent.push(newmove);
			}
			current = newcurrent;
			moves = newmoves;
		}
		private function cloneObject(source:Object):* 
		{ 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}
	}
}