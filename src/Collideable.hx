import h2d.Anim;
import util.MyMath;
import h2d.Tile;
import h2d.Bitmap;

enum CollisionType {
	Solid;
	Bouncy(force:Float);
	Slow(slow:Float);
	Passeable;
	Player;
}

/*
	The class works in this way. If it's dormant, it will not update it's collision mask. If it is, everytime, at the ent
	of the update cycle it will calculate it's mask.
 */
class Collideable extends Entity {
	public static var ALL(default, null):Array<Collideable> = new Array<Collideable>();

	var col:Collider;
	var debug:Bool = false;
	var debugB:Bitmap;
	var myUpdate:Float->Void;

	/**
	 * Constructor for an entity with a connected collision mask to itself
	 * @param x The X position of the entity
	 * @param y The Y position of the entity
	 * @param width The width of the collision mask
	 * @param height The height of the collision mask
	 * @param offsetX The X offset of the collision mask
	 * @param offsetY The Y offset of the collision mask
	 * @param type The type of collider (Solid, bouncy, etc)
	 * @param dormant If it's dormant, don't update it's col's X and Y
	 * @param b The bitmap for the entity
	 * @param a The animation for the entity
	 * @param level The level it's attributed to
	 */
	public function new(x:Float, y:Float, width:Float, height:Float, ?offsetX:Float = 0, ?offsetY:Float = 0, type:CollisionType, ?dormant:Bool = true,
			?b:Bitmap = null, ?a:Anim = null, level:Level) {
		if (b == null && a == null)
			b = new Bitmap(Tile.fromColor(0xffffff, Math.round(width), Math.round(height)));

		super(x, y, level, b, a);
		this.col = new Collider(width, height, type, offsetX, offsetY);
		this.col.x = this.x;
		this.col.y = this.y;

		// Decides what type of update
		dormant ? this.myUpdate = this.dormant : this.myUpdate = this.active;

		ALL.push(this);
	}

	override function update(tmod:Float) {
		myUpdate(tmod);
	}

	function dormant(tmod:Float) {
		super.update(tmod);
	}

	function active(tmod:Float) {
		super.update(tmod);
		this.col.x = this.x + this.col.ox;
		this.col.y = this.y + this.col.oy;
	}

	// DEBUGS ---------------------------------

	public function toggleDebug() {
		if (debug) {
			this.myUpdate == activeDebug ? this.myUpdate = active : this.myUpdate = dormant;
			destroyDebugBitmap();
			this.debug = false;
		} else {
			this.createDebugBitmap();
			this.myUpdate == active ? this.myUpdate = activeDebug : this.myUpdate = dormantDebug;
			this.debug = true;
		}
	}

	function createDebugBitmap() {
		this.debugB = new Bitmap(Tile.fromColor(0xff0000, Math.round(this.col.width), Math.round(this.col.height)));
		this.debugB.alpha = 0.4;
		this.level.addInCamera(debugB);
	}

	function destroyDebugBitmap() {
		this.level.removeInCamera(debugB);
		this.debugB = null;
	}

	function activeDebug(tmod:Float) {
		super.update(tmod);
		this.active(tmod);
		this.debugB.x = this.col.x;
		this.debugB.y = this.col.y;
	}

	function dormantDebug(tmod:Float) {
		super.update(tmod);
		this.dormant(tmod);
		this.debugB.x = this.col.x;
		this.debugB.y = this.col.y;
	}

	// GET COLLISIONS ----------------------------

	public function resolveX(another:Collideable):Float {
		if (this.col.x + this.dx >= another.col.x + another.col.width
			|| this.col.x + this.dx + this.col.width <= another.col.x
			|| this.col.y >= another.col.y + another.col.height
			|| this.col.y + this.col.height <= another.col.y) {
			return 0;
		} else {
			// if (this.col.x >= another.col.x) {
			// 	return (another.col.x + another.col.width) - (this.col.x);
			// } else {
			// 	return ((another.col.x) - (this.col.x + this.col.width));
			// }
			return MyMath.minAbs((another.col.x + another.col.width) - (this.col.x), ((another.col.x) - (this.col.x + this.col.width)));
		}
	}

	public function resolveY(another:Collideable):Float {
		if (this.col.x >= another.col.x + another.col.width
			|| this.col.x + this.col.width <= another.col.x
			|| this.col.y + this.dy >= another.col.y + another.col.height
			|| this.col.y + this.dy + this.col.height <= another.col.y) {
			return 0;
		} else {
			// if (this.col.y >= another.col.y) {
			// 	return (another.col.y + another.col.height) - (this.col.y);
			// } else {
			// 	return ((another.col.y) - (this.col.y + this.col.height));
			// }
			return MyMath.minAbs((another.col.y + another.col.height) - (this.col.y), ((another.col.y) - (this.col.y + this.col.height)));
		}
	}

	override function delete() {
		super.delete();
		this.level.removeInCamera(debugB);
	}
}

class Collider {
	// Position
	public var x:Float;
	public var y:Float;

	// Offset - Applied before setting X and Y
	public var ox:Float;
	public var oy:Float;

	// Size
	public var width:Float;
	public var height:Float;

	// My type of material
	public var type:CollisionType;

	public function new(width:Float, height:Float, type:CollisionType, ox:Float, oy:Float) {
		this.width = width;
		this.height = height;
		this.type = type;
		this.ox = ox;
		this.oy = oy;
	}
}
