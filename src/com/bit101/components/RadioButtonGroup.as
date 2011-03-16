/**
 * Manages a group of radio buttons
 * 
 * RadioButtonGroup.as
 * Alec McEachran
 * version 0.1
 * 
 * A basic radio button component, meant to be used in groups, where only one button in the group can be selected.
 * Currently only one group can be created.
 * 
 * Copyright (c) 2009 Alec McEachran
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

	import flash.utils.Dictionary;
	
	public class RadioButtonGroup
	{
		private var _changed:Signal;
		
		private var values:Dictionary;
		private var current:RadioButton;
		
		public function RadioButtonGroup()
		{
			_changed = new Signal();
			
			values = new Dictionary();
		}

		public function add(button:RadioButton, value:*):void
		{
			values[button] = value;
			if (button.selected)
			{
				if (current)
					button.selected = false;
				else
					current = button;
			}
			
			button.changed.add(onSelected);
		}
		
		private function onSelected(button:RadioButton, selected:Boolean):void
		{
			if (selected && current != button)
			{
				current.deselect();
				current = button;
			}
			else if (!selected && current == button)
			{
				current = null;
			}
			
			var value:* = current ? values[current] : null;
			_changed.dispatch(value);
		}

		public function get changed():ISignal
		{
			return _changed;
		}
		
		public function get selected():*
		{
			return values[current];
		}

		
	}
}
