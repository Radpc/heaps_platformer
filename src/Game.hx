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
		// Initialize the resources
		hxd.Res.initEmbed();

		// Create first scene
		level = new FirstLoad();
		level.scaleMode = LetterBox(400, 300);

		// Initialize the log
		LOG = new ui.Log(level);
		level.addUI(LOG);

		// Change the scene
		setScene2D(level);

		// Vsync
		hxd.Window.getInstance().vsync = true;

		// Fullscreen
		engine.fullScreen = true;

		READY = true;
	}

	public function new() {
		super();
		// Autoref
		ME = this;
	}

	static function main() {
		new Game();
	}

	override function update(dt:Float) {
		super.update(dt);

		// Create a variable tmod
		var tmod = hxd.Timer.tmod * speed;

		// Update the level
		this.level.updateAll(tmod);

		// Update alarms
		Cooldown.updateAll(dt);
	}

	override function onResize() {
		super.onResize();
		this.level.resizeAll();
	}
}
