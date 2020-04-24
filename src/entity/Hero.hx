package entity;

import hxd.Res;
import h2d.Anim;
import h2d.Tile;
import hxd.Key in K;

using util.MyMath;

enum State {
	GROUND;
	AIR;
	WALL;
}

@:publicFields
class Hero extends Collideable {
	// Defines
	final ACCEL = 0.5;
	final DECCEL = 0.1;
	final maxDy = 30;
	final maxDx = 2;
	final GRAVITY = 0.3;
	final JUMP_POWER = 4;
	final AIRFACTOR = 0.5;
	final WALLFACTOR = 0.2;
	final WALLUPDECCEL = 0.1;
	final EPSOLON = 0.1;

	// Variables
	var direction:Int = 0;
	var wallSide:Int = 0;

	// Collision
	final COL_WIDTH:Float = 15;
	final COL_HEIGHT:Float = 30;
	final COL_X_OFFSET:Float = 15;
	final COL_Y_OFFSET:Float = 6;

	// State function
	var state:Float->Void;
	var stateName:State;

	public function new(x, y, level) {
		// The bitmap
		// var b:Bitmap = new Bitmap(Tile.fromColor(0xff00ff, SPR_WIDTH, SPR_HEIGHT));

		var t1:Tile = Res.graphic.hero.adventurer_idle_00.toTile();
		var t2:Tile = Res.graphic.hero.adventurer_idle_01.toTile();

		var b:Anim = new Anim([t1, t2], 2);

		super(x, y, COL_WIDTH, COL_HEIGHT, COL_X_OFFSET, COL_Y_OFFSET, Player, false, b, level);

		// Set first state
		setState(GROUND);
	}

	override function update(tmod:Float) {
		super.update(tmod);

		// Run current state
		this.state(tmod);
	}

	public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
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
			case WALL:
				this.state = stOnWall;
		}
	}

	// ==========================================================================================================
	// STATES ===================================================================================================
	// ==========================================================================================================
	//
	// -----------------------------------------------------------------------------------
	// Moving state - Ground
	// -----------------------------------------------------------------------------------
	function stGround(tmod:Float) {
		// Apply gravity to check ground
		this.dy += GRAVITY;

		// Initial flags
		var isGrounded:Bool = false;
		direction = 0;

		// X movement
		if (K.isDown(K.RIGHT))
			direction++;

		if (K.isDown(K.LEFT))
			direction--;

		direction != 0 ? this.dx += direction * tmod * ACCEL : this.dx /= 1 + tmod * DECCEL;

		// Other bindings
		// Jump
		if (K.isDown(K.UP)) {
			this.dy -= JUMP_POWER;
			setState(AIR);
		}

		// Collision
		// Y
		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveY(c) != 0) {
					dy = this.resolveY(c);
					if (Math.abs(dy) < EPSOLON)
						dy = 0;

					isGrounded = true;
				}
			}
		}

		// X
		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveX(c) != 0) {
					dx = resolveX(c);
					if (Math.abs(dx) < EPSOLON)
						dx = 0;
				}
			}
		}

		// Change state if needed
		if (!isGrounded && stateName != AIR) {
			setState(AIR);
		}

		// Real movement
		this.dy = dy.clamp(maxDy);
		this.dx = dx.clamp(maxDx);
		this.x += this.dx * tmod;
		this.y += this.dy * tmod;
	}

	// -----------------------------------------------------------------------------------
	// Moving state - Air
	// -----------------------------------------------------------------------------------
	function stAir(tmod:Float) {
		// Apply gravity to check ground
		dy += GRAVITY * tmod;

		// Initial flags
		direction = 0;

		// X movement
		if (K.isDown(K.RIGHT))
			direction++;

		if (K.isDown(K.LEFT))
			direction--;

		direction != 0 ? this.dx += direction * tmod * ACCEL * AIRFACTOR : this.dx /= 1 + tmod * DECCEL * AIRFACTOR;

		// Collision
		// Y
		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveY(c) != 0) {
					dy = resolveY(c); // Approach to ground or ceiling
					if (Math.abs(dy) < EPSOLON)
						dy = 0;
					setState(GROUND);
				}
			}
		}

		// X
		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveX(c) != 0) {
					dx = resolveX(c); // Approach to the wall
					if (Math.abs(dx) < EPSOLON)
						dx = 0;

					// Set the side of the wall, and the state
					if ((dx == 0 || this.direction == (dx < 0 ? -1 : 1)) && this.direction != 0) {
						this.wallSide = this.direction;
						setState(WALL);
					}
				}
			}
		}

		// Real movement
		this.dy = dy.clamp(maxDy);
		this.dx = dx.clamp(maxDx);
		this.x += this.dx * tmod;
		this.y += this.dy * tmod;
	}

	// -----------------------------------------------------------------------------------
	// Moving state - Wall
	// -----------------------------------------------------------------------------------
	function stOnWall(tmod:Float) {
		// Initial flags
		var isWalled:Bool = false;
		direction = 0;

		// Add light gravity
		dy += GRAVITY * tmod * WALLFACTOR;

		if (K.isDown(K.RIGHT))
			direction++;

		if (K.isDown(K.LEFT))
			direction--;

		this.dx += direction;

		if (dy < 0) {
			this.dy *= 1 - WALLUPDECCEL * tmod;
		}

		// Collision
		// Y
		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveY(c) != 0) {
					dy = resolveY(c); // Approach to ground or ceiling
					if (Math.abs(dy) < EPSOLON)
						dy = 0;
					setState(GROUND);
				}
			}
		}

		// X
		for (c in Collideable.ALL) {
			if (c.col.type == Solid) {
				if (this.resolveX(c) != 0) {
					dx = resolveX(c); // Approach to the wall
					if (Math.abs(dx) < EPSOLON)
						dx = 0;
					isWalled = true;
				}
			}
		}

		if (direction != wallSide || !isWalled) {
			setState(AIR);
		}

		// Real movement
		this.dy = dy.clamp(maxDy);
		this.dx = dx.clamp(maxDx);
		this.x += this.dx * tmod;
		this.y += this.dy * tmod;
	}
}
