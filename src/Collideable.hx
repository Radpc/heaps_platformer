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

class Collideable extends Entity {
	static var ALL:Array<Collideable> = new Array<Collideable>();

	var col:Collider;
	var myUpdate:Float->Void;

	public function new(x:Float, y:Float, width:Float, height:Float, ?offsetX:Float = 0, ?offsetY:Float = 0, type:CollisionType, ?dormant:Bool = true,
			b:Bitmap, level:Level) {
		if (b == null)
			b = new Bitmap(Tile.fromColor(0xffffff, Math.round(width), Math.round(height)));

		super(x, y, level, b);

		this.col = new Collider(width, height, type, offsetX, offsetY);
		this.col.x = this.x;
		this.col.y = this.y;

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

	// GET COLLISIONS

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
