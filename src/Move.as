package
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	public class Move extends Button
	{
		//private var _data:Object = {};
		private var tween:Tween;
		private var _isPlaying:Boolean = false;
		private var _position:String = "";
		private var _nextPosition:Array = [];
		private var _player:int = 0;
		
		public function Move(upState:Texture = null, text:String="", downState:Texture=null)
		{
			//var piecebaseBitmap:Bitmap = new TikiTapToe.Piece0Texture();
			//upState = //Texture.fromBitmap(piecebaseBitmap);
			super(upState, "", downState);
			//filter = new BlurFilter(5,5,1);
		}
		/*
		public function get data():Object {
			return _data;
		}
		
		public function set data(newValue:Object):void {
			_data = newValue;
		}
		*/
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function get position():String {
			return _position;
		}
		
		public function set position(newValue:String):void {
			_position = newValue;
		}
		
		public function get nextPosition():Array {
			return _nextPosition;
		}
		
		public function set nextPosition(newValue:Array):void {
			_nextPosition = newValue;
		}
		
		public function get player():int {
			return _player;
		}
		
		public function set player(newValue:int):void {
			_player = newValue;
		}
		public function play():void {		
			
			if (!this.isPlaying) {			
				tween = new Tween(this, 1);
				tween.fadeTo(0.5);	
				tween.repeatCount = 2;
				tween.reverse = true;
				Starling.juggler.add(tween);
				tween.onComplete = function():void {  _isPlaying = false; };
				tween.onStart = function():void { _isPlaying = true; };
			}
		}
		
		public function stop():void {
			Starling.juggler.removeTweens(this);
			this.alpha = 1;
		}
		
		public function clone(m:Move):void {
			upState = m.upState;
			downState = m.downState;
			player = m.player;
			nextPosition = cloneObject(m.nextPosition);
			position = m.position;
			width = m.width;
			height = m.height;
			x = m.x;
			y = m.y;
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