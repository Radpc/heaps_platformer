import Entity;
import level.FirstLoad;
import util.Cooldown;

class Game extends hxd.App {
	// Refs
	static public var ME:Game;
	static public var LOG:ui.Log;
	static public var READY:Bool = false;

	// Var's
	var level:Level;
	var speed:Float = 1.0;

	public function getLevel() {
		return this.level;
	}

	override function init() {
		// Autoref
		ME = this;

		// Create first scene
		level = new FirstLoad();

		// Initialize the log
		LOG = new ui.Log(level);
		level.addUI(LOG);

		// Change the scene
		setScene2D(level);

		hxd.Window.getInstance().vsync = true;

		READY = true;
	}

	public function new() {
		super();
		hxd.Res.initEmbed();
	}

	static function main() {
		new Game();
	}

	override function update(dt:Float) {
		super.update(dt);
		var tmod = hxd.Timer.tmod * speed;
		this.level.updateAll(tmod);

		Cooldown.updateAll(dt);
	}

	override function onResize() {
		super.onResize();
		this.level.resizeAll();
	}
}
