import h2d.Tile;
import h2d.Bitmap;
import Level;
import h2d.Object;

class Entity {
	static public var ALL:Array<Entity> = new Array<Entity>();

	// Parent
	var p:Object = null;

	// Level
	var level:Level;

	// Position
	var x:Float = 0;
	var y:Float = 0;

	// Velocity
	var dx:Float = 0;
	var dy:Float = 0;

	// Offset sprite
	var ox:Float = 0;
	var oy:Float = 0;

	// Flags
	var visible:Bool = true;

	// Sprite
	var sprite:Bitmap;

	// Constructor
	public function new(x:Float, y:Float, level:Level, ?b:Bitmap, ?center:Bool = false) {
		this.level = level;
		this.x = x;
		this.y = y;

		if (b != null)
			this.set_sprite(b);

		this.level.addEntity(this);
		ALL.push(this);

		if (center) {
			this.anchorSpriteCenter();
		}
	}

	public function set_sprite(b:Bitmap) {
		this.level.removeChild(sprite);
		this.sprite = b;
		this.level.addChild(sprite);
		this.sprite.x = x + ox;
		this.sprite.y = y + oy;
	}

	// Boilerplate
	public function update(tmod:Float) {
		// Update sprite position
		if (sprite != null) {
			this.sprite.x = x + ox;
			this.sprite.y = y + oy;
		}
	}

	public function delete() {
		ALL.remove(this);
		this.level.removeEntity(this);
	}

	public function anchorSpriteCenter() {
		this.anchorSprite(this.sprite.tile.width / 2, this.sprite.tile.height / 2);
	}

	public function anchorSprite(x:Float, y:Float) {
		this.sprite.tile.dx = -x;
		this.sprite.tile.dy = -y;

		this.ox = x;
		this.oy = y;
	}
}
