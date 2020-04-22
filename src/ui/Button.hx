package ui;

import h2d.Scene;
import h2d.Text;
import h2d.Interactive;

class Button extends Text implements UI {
	public var ACTIVE:Bool = false;

	var customFont:h2d.Font;
	var actualColor:h3d.Vector;
	var hoveredColor:h3d.Vector;
	var i:Interactive;
	var level:Level;

	function onHover(_) {
		this.color = hoveredColor;
	}

	function onOut(_) {
		this.color = actualColor;
	}

	override public function new(buttonText:String, l:Level, onClick:hxd.Event->Void) {
		customFont = hxd.res.DefaultFont.get();
		super(customFont, l);
		this.text = buttonText;
		this.level = l;
		setColor(0.9, 0.9, 0.9);
		this.textAlign = Center;

		this.onResize();

		var my_width:Float = calcTextWidth(text);
		var my_height:Float = get_textHeight();

		// Interactive
		this.i = new Interactive(my_width, my_height, this);
		this.i.onClick = onClick;

		this.i.onOver = onHover;
		this.i.onOut = onOut;
		this.i.onClick = onClick;
	}

	function setColor(r:Float, g:Float, b:Float) {
		var factor:Float = 0.3;
		this.actualColor = new h3d.Vector(r, g, b);
		this.hoveredColor = new h3d.Vector(r * factor, g * factor, b * factor);
		this.color = this.actualColor;
	};

	public function onResize() {
		this.x = this.level.width >> 1;
		this.y = this.level.height >> 1;
	}

	public function onDelete() {
		this.level.removeUI(this);
	}

	public function update(dt:Float) {}
}
