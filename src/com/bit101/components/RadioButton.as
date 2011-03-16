/**
 * Change from original API to implement Signals and add some functional tweaks
 * @author Alec McEachran
 * 
 * RadioButton.as
 * Keith Peters
 * version 0.97
 * 
 * A basic radio button component, meant to be used in groups, where only one button in the group can be selected.
 * Currently only one group can be created.
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

	public class RadioButton extends Component
	{
		private var _changed:Signal;
		
		private var _back:Sprite;
		private var _button:Sprite;
		private var _selected:Boolean;
		private var _label:Label;
		private var _labelText:String;

		public function RadioButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", checked:Boolean = false)
		{
			_changed = new Signal(RadioButton, Boolean);
			
			_selected = checked;
			_labelText = label || "";
			super(parent, xpos, ypos);
		}

		override protected function init():void
		{
			super.init();

			buttonMode = true;
			useHandCursor = true;

			addEventListener(MouseEvent.CLICK, onClick, false, 1);
			_button.visible = _selected;
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

		}
		
		override public function draw():void
		{
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawCircle(5, 5, 5);
			_back.graphics.endFill();

			_button.graphics.clear();
			_button.graphics.beginFill(Style.BUTTON_FACE);
			_button.graphics.drawCircle(5, 5, 3);

			_label.x = 12;
			_label.y = (10 - _label.height) / 2;
			_label.text = _labelText;
			_label.draw();
			_width = _label.width + 12;
			_height = 10;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			selected = true;
		}

		public function set selected(value:Boolean):void
		{
			if (_selected == value)
				return;
			
			_selected = value;
			_button.visible = _selected;
			
			_changed.dispatch(this, _selected);
		}

		internal function deselect():void
		{
			_selected = false;
			_button.visible = false;
		}

		public function get selected():Boolean
		{
			return _selected;
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

		public function get changed():ISignal
		{
			return _changed;
		}

	}
}