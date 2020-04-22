interface UI {
	public function onResize():Void;
	public function onDelete():Void;
	public function update(dt:Float):Void;
	public var ACTIVE:Bool;
}
