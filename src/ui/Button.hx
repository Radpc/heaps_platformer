package ui;

import h2d.Scene;
import h2d.Text;
import h2d.Interactive;

class Button extends Text {
	var customFont:h2d.Font;
	var actualColor:h3d.Vector;
	var hoveredColor:h3d.Vector;
	var i:Interactive;
	var scene:Scene;

	function onHover(_) {
		this.color = hoveredColor;
	}

	function onOut(_) {
		this.color = actualColor;
	}

	function onClick(_) {
		this.text += '\nClicked!';
	}

	override public function new(buttonText:String, sc:h2d.Scene, onClick:hxd.Event->Void) {
		customFont = hxd.res.DefaultFont.get();
		super(customFont, sc);
		this.text = buttonText;
		this.scene = sc;
		setColor(0.9, 0.9, 0.9);
		this.textAlign = Center;

		this.resetPosition();

		var my_width:Float = calcTextWidth(text);
		var my_height:Float = get_textHeight();

		// Interactive
		this.i = new Interactive(my_width, my_height, this);
		this.i.onClick = onClick;

		this.i.onOver = onHover;
		this.i.onOut = onOut;
		this.i.onClick = this.onClick;
	}

	function setColor(r:Float, g:Float, b:Float) {
		var factor:Float = 0.3;
		this.actualColor = new h3d.Vector(r, g, b);
		this.hoveredColor = new h3d.Vector(r * factor, g * factor, b * factor);
		this.color = this.actualColor;
	};

	public function resetPosition() {
		this.x = this.scene.width >> 1;
		this.y = this.scene.height >> 1;
	}

	public function reposition() {
		this.x = hxd.Window.getInstance().width >> 1;
		this.y = hxd.Window.getInstance().height >> 1;
	}
}
