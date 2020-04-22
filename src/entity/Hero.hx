package entity;

import util.Cooldown;
import h2d.Tile;
import h2d.Bitmap;
import hxd.Key in K;

using util.MyMath;

enum State {
	GROUND;
	AIR;
}

class Hero extends Collideable {
	// Values
	final DECCEL = 0.1;
	final maxDy = 30;
	final maxDx = 5;
	final ACCEL = 0.5;
	final GRAVITY = 0.8;
	final JUMP_POWER = 10;

	// Sprite
	final SPR_WIDTH:Int = 30;
	final SPR_HEIGHT:Int = 30;

	// Collision
	final COL_WIDTH:Float = 30;
	final COL_HEIGHT:Float = 30;
	final COL_X_OFFSET:Float = 0;
	final COL_Y_OFFSET:Float = 0;

	// State function
	var state:Float->Void;
	var stateName:State;

	public function new(x, y, level) {
		super(x, y, COL_WIDTH, COL_HEIGHT, COL_X_OFFSET, COL_Y_OFFSET, Player, false, new Bitmap(Tile.fromColor(0xff00ff, SPR_WIDTH, SPR_HEIGHT)), level);

		// Set first state
		setState(GROUND);
		Cooldown.add('hero_color', 5);
	}

	override function update(tmod:Float) {
		super.update(tmod);

		// Run current state
		this.state(tmod);
		if (!Cooldown.isAlive('hero_color')) {
			this.sprite.tile = Tile.fromColor(0x404040, SPR_WIDTH, SPR_HEIGHT);
		}
	}

	public function setState(s:State) {
		if (Game.READY)
			Game.LOG.add('State -> ' + s);

		this.stateName = s;
		switch (s) {
			case GROUND:
				this.state = stGround;

			case AIR:
				this.state = stAir;
		}
	}

	// States ===================================================
	// Moving state - Ground
	function stGround(tmod:Float) {
		var isGrounded:Bool = false;

		this.dy += GRAVITY;

		if (K.isDown(K.RIGHT)) {
			this.dx += tmod * ACCEL;
		} else {
			if (K.isDown(K.LEFT)) {
				this.dx -= tmod * ACCEL;
			} else {
				this.dx /= 1 + tmod * DECCEL;
			}
		}

		if (K.isDown(K.A)) {
			this.sprite.tile = Tile.fromColor(Std.random(0xffffff), 30, 30);
		}

		if (K.isDown(K.UP)) {
			this.dy -= JUMP_POWER;
			setState(AIR);
		}

		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveY(c) != 0) {
					dy = this.resolveY(c);
					isGrounded = true;
				}
			}
		}

		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveX(c) != 0) {
					x += resolveX(c).decreaseAbs();
					dx = 0;
				}
			}
		}

		if (!isGrounded && stateName != AIR) {
			setState(AIR);
		}

		this.dy = dy.clamp(maxDy);
		this.dx = dx.clamp(maxDx);
		this.x += this.dx * tmod;
		this.y += this.dy * tmod;
	}

	// Moving state - Air
	function stAir(tmod:Float) {
		dy += GRAVITY * tmod;

		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveY(c) != 0) {
					var r = resolveY(c).decreaseAbs();

					dy = r; // Stop the element

					if (r == 0) {
						this.x += resolveY(c);
						this.dy = 0;
						setState(GROUND);
					}
				}
			}
		}

		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveX(c) != 0) {
					x += resolveX(c).decreaseAbs(); // Approximate
					dx = 0; // Stop
				}
			}
		}

		this.dy = dy.clamp(maxDy);
		this.dx = dx.clamp(maxDx);
		this.x += this.dx * tmod;
		this.y += this.dy * tmod;
	}

	public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}
}
