import h2d.Anim;
import h2d.Tile;
import h2d.Bitmap;
import Level;
import h2d.Object;

enum GraphicType {
	Bitmap;
	Anim;
	None;
}

/**
 * A base class for everything that have anims/updates
 */
@:publicFields
class Entity {
	static public var ALL:Array<Entity> = new Array<Entity>();

	// Parent
	var p:Object = null;

	// Level
	var level(default, null):Level;

	// Position
	public var x(default, null):Float = 0;
	public var y(default, null):Float = 0;

	// Velocity
	var dx(default, null):Float = 0;
	var dy(default, null):Float = 0;

	// Offset bitmap
	var bx:Float = 0;
	var by:Float = 0;

	// Offset anim
	var ax:Float = 0;
	var ay:Float = 0;

	// Flags
	var visible:Bool = true;

	// GRAPHICS
	var bitmap:Bitmap;
	var anim:Anim;
	var myGraphicUpdate:Float->Void;

	// Constructor
	public function new(x:Float, y:Float, level:Level, ?b:Bitmap, ?a:Anim) {
		this.level = level;
		this.x = x;
		this.y = y;

		// IF ANIMATION
		if (a != null) {
			this.setAnim(a);
		} else {
			// IF NOT ANIMATION
			if (b != null) {
				this.setBitmap(b);
			}
		}

		// Automatically choose the graphical update
		this.setGraphicalUpdate();

		// Add update to level control
		this.level.addEntity(this);

		// Add to entity pool
		ALL.push(this);
	}

	public function setBitmap(b:Bitmap) {
		this.level.removeInCamera(bitmap);
		this.bitmap = b;
		this.level.addInCamera(bitmap);
		this.bitmap.x = x + bx;
		this.bitmap.y = y + by;
	}

	public function setAnim(a:Anim) {
		this.level.removeInCamera(anim);
		this.anim = a;
		this.level.addInCamera(anim);
		this.anim.x = x + ax;
		this.anim.y = y + ay;
	}

	// Boilerplate
	public function update(tmod:Float) {
		myGraphicUpdate(tmod);
	}

	// Types of graphical update ----------------------------------

	function setGraphicalUpdate(?t:GraphicType, ?remove:Bool = true) {
		if (t != null) {
			switch (t) {
				case Bitmap:
					this.myGraphicUpdate = updateBitmap;
					if (remove) {
						if (this.anim != null) {
							this.level.removeInCamera(anim);
							this.anim = null;
						}
					}

				case Anim:
					this.myGraphicUpdate = updateAnim;
					if (remove) {
						if (this.bitmap != null) {
							this.level.removeInCamera(bitmap);
							this.bitmap = null;
						}
					}
				case None:
					this.myGraphicUpdate = updateNothing;
					if (remove) {
						if (this.bitmap != null) {
							this.level.removeInCamera(bitmap);
							this.bitmap = null;
						}
						if (this.anim != null) {
							this.level.removeInCamera(anim);
							this.anim = null;
						}
					}
			}
		} else {
			if (this.anim != null) {
				this.myGraphicUpdate = updateAnim;
				if (remove) {
					if (this.bitmap != null) {
						this.level.removeInCamera(bitmap);
						this.bitmap = null;
					}
				}
			} else {
				if (this.bitmap != null) {
					this.myGraphicUpdate = updateBitmap;
					if (remove) {
						if (this.anim != null) {
							this.level.removeInCamera(anim);
							this.anim = null;
						}
					}
				} else {
					this.myGraphicUpdate = updateNothing;
					if (remove) {
						if (this.bitmap != null) {
							this.level.removeInCamera(bitmap);
							this.bitmap = null;
						}
						if (this.anim != null) {
							this.level.removeInCamera(anim);
							this.anim = null;
						}
					}
				}
			}
		}
	}

	function updateBitmap(tmod:Float) {
		this.bitmap.x = x + bx;
		this.bitmap.y = y + by;
	}

	function updateAnim(tmod:Float) {
		this.anim.x = x + ax;
		this.anim.y = y + ay;
	}

	function updateNothing(tmod:Float) {}

	// ----------------------------------------------------------------
	public function delete() {
		// Remove graphics
		this.level.removeInCamera(this.anim);
		this.level.removeInCamera(this.bitmap);

		this.anim.remove();
		this.bitmap.remove();

		// Remove entity control
		ALL.remove(this);

		// Remove level update
		this.level.removeEntity(this);
	}
}
