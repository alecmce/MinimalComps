/**
 * Change from original API to implement Signals
 * @author Alec McEachran
 * 
 * CheckBox.as
 * Keith Peters
 * version 0.97
 * 
 * A basic CheckBox component.
 * 
 * Copyright (c) 2009 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.bit101.components
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CheckBox extends Component
	{
		private var _back:Sprite;
		private var _button:Sprite;
		private var _label:Label;
		private var _labelText:String = "";
		private var _selected:Boolean = false;

		private var _changed:Signal;

		public function CheckBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "")
		{
			_changed = new Signal(Boolean);
			
			_labelText = label;
			super(parent, xpos, ypos);
		}
		
		override protected function init():void
		{
			super.init();
			
			buttonMode = true;
			useHandCursor = true;
		}

		override protected function addChildren():void
		{
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);

			_button = new Sprite();
			_button.filters = [getShadow(1)];
			_button.visible = false;
			addChild(_button);

			_label = new Label(this, 0, 0, _labelText);
			draw();

			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function draw():void
		{
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, 10, 10);
			_back.graphics.endFill();

			_button.graphics.clear();
			_button.graphics.beginFill(Style.BUTTON_FACE);
			_button.graphics.drawRect(2, 2, 6, 6);

			_label.text = _labelText;
			_label.draw();
			_label.x = 12;
			_label.y = (10 - _label.height) / 2;
			_width = _label.width + 12;
			_height = 10;
		}

		protected function onClick(event:MouseEvent):void
		{
			_selected = !_selected;
			_button.visible = _selected;
		}

		public function set label(str:String):void
		{
			_labelText = str;
			invalidate();
		}

		public function get label():String
		{
			return _labelText;
		}

		[Bindable( "change" )]
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
				return;

			_selected = value;
			_button.visible = _selected;
			_changed.dispatch(value);
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function get changed():ISignal
		{
			return _changed;
		}

	}
}