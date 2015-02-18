package dialogue {
	import flash.automation.ActionGenerator;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.utils.StringUtil;
	import resource.Image;
	import settings.ControlSettings;
	import settings.DisplaySettings;
	
	/**
	 * Static class for drawing dialogue onto the game.
	 * @author shinobi0888
	 */
	public class Dialogue {
		
		private static var dBoxBitmap:BitmapData;
		private static var actions:Array;
		private static var choiceIndex:int;
		private static var choices:Array;
		private static var leftPortrait:String;
		private static var lpWidth:int;
		private static var lpHeight:int;
		private static var rightPortrait:String;
		private static var rpWidth:int;
		private static var rpHeight:int;
		private static var oldLeftPortrait:String;
		private static var oldRightPortrait:String;
		
		private static var lArrowX:int;
		private static var rArrowX:int;
		
		// Represents the width of one cell of the dialogue box.
		private static const CELL_WIDTH:int = 16;
		// The font being used by the dialogue box
		private static const FONT_INDEX:int = 0;
		
		// Represents other metrics based on the CELL_WIDTH.
		private static const DBOX_HEIGHT:int = int(Math.ceil(DisplaySettings.DISP_HEIGHT /
			4 / CELL_WIDTH));
		private static const DBOX_WIDTH:int = int(Math.ceil(DisplaySettings.DISP_WIDTH /
			CELL_WIDTH));
		private static const DBOX_START_HEIGHT:int = DisplaySettings.DISP_HEIGHT - DBOX_HEIGHT *
			CELL_WIDTH;
		
		private static const DBOX_TEXT_LBOUND:int = 24;
		private static const DBOX_TEXT_UBOUND:int = DBOX_START_HEIGHT + DBOX_TEXT_LBOUND;
		private static const DBOX_TEXT_WIDTH:int = DisplaySettings.DISP_WIDTH - int(DBOX_TEXT_LBOUND *
			2.5);
		private static const DBOX_TEXT_HEIGHT:int = DisplaySettings.DISP_HEIGHT - DBOX_START_HEIGHT -
			DBOX_TEXT_LBOUND * 2;
		private static const DBOX_TEXT_SPACING:int = 4;
		private static const DBOX_TICKER_XPOS:int = DBOX_TEXT_WIDTH + int(CELL_WIDTH *
			1.5);
		private static const DBOX_TICKER_YPOS:int = DBOX_TEXT_HEIGHT + DBOX_START_HEIGHT +
			int(CELL_WIDTH * .5);
		private static const DBOX_CHOICE_YPOS:int = DBOX_START_HEIGHT + DBOX_TEXT_HEIGHT +
			int(CELL_WIDTH * .5);
		
		// Represents the length of a question asked by choice
		private static const CHOICE_LEN:int = 90;
		
		/**
		 * Initializes the Dialogue static class for use. Should be called at the
		 * beginning of execution and has an optional callback parameter.
		 * @param	callback The callback to be called at the completion of loading
		 * if provided; optional.
		 */
		public static function init(callback:Function = null):void {
			actions = new Array();
			choices = new Array();
			Image.loadImage("../src/assets/dialogue/dg_border_test.png", function(bitmap:BitmapData):void {
					dBoxBitmap = bitmap;
					if (callback != null) {
						callback();
					}
				});
		}
		
		// Related drawing variables
		private static var dPoint:Point = new Point();
		private static var dRect:Rectangle = new Rectangle();
		
		private static function setDRect(x:int, y:int, width:int, height:int):Rectangle {
			dRect.x = x;
			dRect.y = y;
			dRect.width = width;
			dRect.height = height;
			return dRect;
		}
		
		private static function setDPoint(x:int, y:int):Point {
			dPoint.x = x;
			dPoint.y = y;
			return dPoint;
		}
		
		/**
		 * Draws the current status of the dialogue system onto a canvas, assumably
		 * the display canvas. Also advances the status of the current dialogue
		 * action. Should be called regularly during the game, once per tick or
		 * draw frame.
		 * @param	canvas The canvas (BitmapData) to draw to.
		 */
		public static function drawTick(canvas:BitmapData):void {
			if (actions.length == 0) {
				return;
			}
			var curAction:DialogueAction = actions[0];
			if (curAction.type == DialogueAction.T_LP_FADE_IN) {
				if (curAction.state == 0) {
					setLeftPortrait(curAction.initData);
				}
				drawDialogueBox(canvas);
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight, 0,
						0, -1, -1, Number(curAction.state) / DialogueAction.FADE_TIME);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight);
				}
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_RP_FADE_IN) {
				if (curAction.state == 0) {
					setRightPortrait(curAction.initData);
				}
				drawDialogueBox(canvas);
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight, 0, 0, -1, -1, Number(curAction.state) /
						DialogueAction.FADE_TIME);
				}
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_LP_FADE_OUT) {
				drawDialogueBox(canvas);
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight, 0,
						0, -1, -1, Number(DialogueAction.FADE_TIME - curAction.state) / DialogueAction.FADE_TIME);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight);
				}
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					setLeftPortrait(null);
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_RP_FADE_OUT) {
				drawDialogueBox(canvas);
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight, 0, 0, -1, -1, Number(DialogueAction.FADE_TIME -
						curAction.state) / DialogueAction.FADE_TIME);
				}
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					setRightPortrait(null);
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_LP_FADE_C) {
				if (curAction.state == 0) {
					setLeftPortrait(curAction.initData);
				}
				drawDialogueBox(canvas);
				if (oldLeftPortrait != null) {
					Image.drawTo(oldLeftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight,
						0, 0, -1, -1, Number(DialogueAction.FADE_TIME - curAction.state) / DialogueAction.FADE_TIME);
				}
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight, 0,
						0, -1, -1, Number(curAction.state) / DialogueAction.FADE_TIME);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight);
				}
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_RP_FADE_C) {
				if (curAction.state == 0) {
					setRightPortrait(curAction.initData);
				}
				drawDialogueBox(canvas);
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight);
				}
				if (oldRightPortrait != null) {
					Image.drawTo(oldRightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight, 0, 0, -1, -1, Number(DialogueAction.FADE_TIME -
						curAction.state) / DialogueAction.FADE_TIME);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight, 0, 0, -1, -1, Number(curAction.state) /
						DialogueAction.FADE_TIME);
				}
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_START) {
				var alpha:Number = Number(curAction.state) / DialogueAction.FADE_TIME;
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight, 0,
						0, -1, -1, alpha);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight, 0, 0, -1, -1, alpha);
				}
				drawDialogueBox(canvas, alpha);
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_END) {
				alpha = Number(DialogueAction.FADE_TIME - curAction.state) / DialogueAction.FADE_TIME;
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight, 0,
						0, -1, -1, alpha);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight, 0, 0, -1, -1, alpha);
				}
				drawDialogueBox(canvas, alpha);
				if (curAction.state == DialogueAction.FADE_TIME) {
					// Fade action done; remove action
					shiftActions();
				}
			} else if (curAction.type == DialogueAction.T_DISP_TXT || curAction.type ==
				DialogueAction.T_DISP_TXT_CONT) {
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight);
				}
				drawDialogueBox(canvas);
				Text.drawText(FONT_INDEX, curAction.initData.substr(0, curAction.state <
					0 ? curAction.initData.length : int(curAction.state / DialogueAction.LETTER_TIME) +
					1), canvas, DBOX_TEXT_LBOUND, DBOX_TEXT_UBOUND, DBOX_TEXT_WIDTH, DBOX_TEXT_SPACING,
					1, (curAction.state >= 0 && curAction.state % DialogueAction.LETTER_TIME <
					DialogueAction.H_LETTER_TIME));
				// Draw progress icon
				if (curAction.type == DialogueAction.T_DISP_TXT && curAction.state < 0 &&
					curAction.state >= DialogueAction.BLINK_TIME) {
					canvas.copyPixels(dBoxBitmap, setDRect(CELL_WIDTH * 9, 0, CELL_WIDTH, CELL_WIDTH),
						setDPoint(DBOX_TICKER_XPOS, DBOX_TICKER_YPOS), null, null, true);
				} else if (curAction.type == DialogueAction.T_DISP_TXT_CONT && curAction.state <
					0) {
					canvas.copyPixels(dBoxBitmap, setDRect(CELL_WIDTH * 10, 0, CELL_WIDTH,
						CELL_WIDTH), setDPoint(DBOX_TICKER_XPOS, DBOX_TICKER_YPOS - (curAction.state >=
						DialogueAction.BLINK_TIME ? -4 : 0)), null, null, true);
				}
			} else if (curAction.type == DialogueAction.T_DISP_CHOICE) {
				var fontSize:int = Text.fontSize(FONT_INDEX);
				if (curAction.state == 0) {
					// Init
					var pieces:Array = curAction.initData.split("\n");
					curAction.initData = pieces.shift();
					choiceIndex = 0;
					choices.length = 0;
					var maxLength:int = 0;
					for each (var piece:String in pieces) {
						maxLength = Math.max(maxLength, piece.length);
						choices.push(piece);
					}
					lArrowX = int((DisplaySettings.DISP_WIDTH - (maxLength + 2) * fontSize) /
						2) - fontSize;
					rArrowX = DisplaySettings.DISP_WIDTH - int((DisplaySettings.DISP_WIDTH -
						(maxLength + 2) * fontSize) / 2);
				}
				if (leftPortrait != null) {
					Image.drawTo(leftPortrait, canvas, 0, DBOX_START_HEIGHT - lpHeight);
				}
				if (rightPortrait != null) {
					Image.drawTo(rightPortrait, canvas, DBOX_WIDTH * CELL_WIDTH - rpWidth,
						DBOX_START_HEIGHT - rpHeight);
				}
				drawDialogueBox(canvas);
				Text.drawText(FONT_INDEX, curAction.initData.substr(0, curAction.state <
					0 ? curAction.initData.length : int(curAction.state / DialogueAction.LETTER_TIME) +
					1), canvas, DBOX_TEXT_LBOUND, DBOX_TEXT_UBOUND, DBOX_TEXT_WIDTH, DBOX_TEXT_SPACING,
					1, (curAction.state >= 0 && curAction.state % DialogueAction.LETTER_TIME <
					DialogueAction.H_LETTER_TIME));
				// Draw choices
				if (curAction.state < 0) {
					Text.drawText(FONT_INDEX, choices[choiceIndex], canvas, int((DisplaySettings.DISP_WIDTH -
						fontSize * choices[choiceIndex].length) / 2), DBOX_CHOICE_YPOS);
					if (choiceIndex == 0) {
						canvas.copyPixels(dBoxBitmap, setDRect(CELL_WIDTH * 12, 0, CELL_WIDTH,
							CELL_WIDTH), setDPoint(rArrowX, DBOX_CHOICE_YPOS), null, null, true);
					} else if (choiceIndex == choices.length - 1) {
						canvas.copyPixels(dBoxBitmap, setDRect(CELL_WIDTH * 11, 0, CELL_WIDTH,
							CELL_WIDTH), setDPoint(lArrowX, DBOX_CHOICE_YPOS), null, null, true);
					} else {
						canvas.copyPixels(dBoxBitmap, setDRect(CELL_WIDTH * 11, 0, CELL_WIDTH,
							CELL_WIDTH), setDPoint(lArrowX, DBOX_CHOICE_YPOS), null, null, true);
						canvas.copyPixels(dBoxBitmap, setDRect(CELL_WIDTH * 12, 0, CELL_WIDTH,
							CELL_WIDTH), setDPoint(rArrowX, DBOX_CHOICE_YPOS), null, null, true);
					}
				}
			}
			curAction.advanceState();
		}
		
		// Related reusable values
		private static var alphaBitmap:BitmapData = new BitmapData(CELL_WIDTH, CELL_WIDTH,
			true);
		private static var drawRect:Rectangle = new Rectangle(0, 0, CELL_WIDTH, CELL_WIDTH);
		
		/**
		 * Draws the dialogue box with a given alpha.
		 * @param	canvas The canvas to draw onto.
		 * @param	alpha An alpha level to draw with.
		 */
		private static function drawDialogueBox(canvas:BitmapData, alpha:Number = 1):void {
			if (alpha == 0) {
				return;
			}
			drawRect.x = drawRect.y = 0;
			alphaBitmap.fillRect(drawRect, int(alpha * 256) * 0x01000000);
			for (var i:int = 0; i < DBOX_WIDTH; i++) {
				for (var j:int = 0; j < DBOX_HEIGHT; j++) {
					if (i == 0 && j == 0) {
						drawRect.x = 0;
					} else if (i == 0 && j == DBOX_HEIGHT - 1) {
						drawRect.x = CELL_WIDTH * 6;
					} else if (i == DBOX_WIDTH - 1 && j == 0) {
						drawRect.x = CELL_WIDTH * 2;
					} else if (i == DBOX_WIDTH - 1 && j == DBOX_HEIGHT - 1) {
						drawRect.x = CELL_WIDTH * 4;
					} else if (i == 0) {
						drawRect.x = CELL_WIDTH * 7;
					} else if (j == 0) {
						drawRect.x = CELL_WIDTH;
					} else if (i == DBOX_WIDTH - 1) {
						drawRect.x = CELL_WIDTH * 3;
					} else if (j == DBOX_HEIGHT - 1) {
						drawRect.x = CELL_WIDTH * 5;
					} else {
						drawRect.x = CELL_WIDTH * 8;
					}
					canvas.copyPixels(dBoxBitmap, drawRect, new Point(i * CELL_WIDTH, j * CELL_WIDTH +
						DBOX_START_HEIGHT), alpha == 1 ? null : alphaBitmap, null, true);
				}
			}
		}
		
		// Add Action Functions		
		public static function leftFadeIn(portrait:String, callback:Function = null):void {
			actions.push(new DialogueAction(DialogueAction.T_LP_FADE_IN, portrait, callback));
		}
		
		public static function rightFadeIn(portrait:String, callback:Function = null):void {
			actions.push(new DialogueAction(DialogueAction.T_RP_FADE_IN, portrait, callback));
		}
		
		public static function leftFadeOut(callback:Function = null):void {
			actions.push(new DialogueAction(DialogueAction.T_LP_FADE_OUT, null, callback));
		}
		
		public static function rightFadeOut(callback:Function = null):void {
			actions.push(new DialogueAction(DialogueAction.T_RP_FADE_OUT, null, callback));
		}
		
		public static function leftFadeCross(portrait:String, callback:Function = null):void {
			actions.push(new DialogueAction(DialogueAction.T_LP_FADE_C, portrait, callback));
		}
		
		public static function rightFadeCross(portrait:String, callback:Function = null):void {
			actions.push(new DialogueAction(DialogueAction.T_RP_FADE_C, portrait, callback));
		}
		
		public static function start(lPortrait:String, rPortrait:String, callback:Function = null):void {
			setLeftPortrait(lPortrait);
			setRightPortrait(rPortrait);
			actions.push(new DialogueAction(DialogueAction.T_START, null, callback));
		}
		
		public static function end(callback:Function = null):void {
			actions.push(new DialogueAction(DialogueAction.T_END, null, callback));
		}
		
		/**
		 * Queues a request to display scrolling text in the dialogue box. The
		 * message will automatically be cut to full lines such that line breaks
		 * do not interrupt words. Each page that runs over has its own event.
		 * @param	message The message to display.
		 * @param	callback An optional callback to be called at the end of this
		 * choice.
		 */
		public static function showText(message:String, callback:Function = null):void {
			var DBOX_CHARS_PER_LINE:int = Text.charsAllowed(FONT_INDEX, DBOX_TEXT_WIDTH);
			var DBOX_LINES:int = Text.linesAllowed(FONT_INDEX, DBOX_TEXT_HEIGHT, DBOX_TEXT_SPACING);
			var cut:int = Text.cutText(FONT_INDEX, message, DBOX_TEXT_WIDTH, CELL_WIDTH +
				DBOX_TEXT_SPACING, DBOX_TEXT_SPACING);
			var pieces:Array = new Array();
			
			while (message.length > 0) {
				var cleanedMessage:String;
				if (cut == message.length) {
					cleanedMessage = message.indexOf("\\n") == 0 ? message.substr(2) : message;
					pieces.push(cleanedMessage);
					break;
				} else {
					cleanedMessage = message.substr(0, cut);
					cleanedMessage = cleanedMessage.indexOf("\\n") == 0 ? cleanedMessage.substr(2) :
						cleanedMessage;
					pieces.push(cleanedMessage);
					message = message.substr((message.charAt(cut) == " ") ? cut + 1 : cut);
					message = message.indexOf("\\n") == 0 ? message.substr(2) : message;
				}
				cut = Text.cutText(FONT_INDEX, message, DBOX_TEXT_WIDTH, CELL_WIDTH + DBOX_TEXT_SPACING,
					DBOX_TEXT_SPACING);
			}
			message = "";
			for (var i:int = 0; i < pieces.length; i++) {
				var piece:String = pieces[i];
				while (piece.length < DBOX_CHARS_PER_LINE) {
					piece += " ";
				}
				message += piece;
				if (i % DBOX_LINES == DBOX_LINES - 1 && i != pieces.length - 1) {
					actions.push(new DialogueAction(DialogueAction.T_DISP_TXT_CONT, StringUtil.trim(message),
						null));
					message = "";
				}
			}
			actions.push(new DialogueAction(DialogueAction.T_DISP_TXT, StringUtil.trim(message),
				callback));
		}
		
		/**
		 * Queues a request to show a question and a set of choices. The question
		 * must be within 90 characters and cannot contain new lines.
		 * @param	message The question to ask.
		 * @param	choices An array of choices that the player is allowed to
		 * choose from.
		 * @param	callback An optional callback to be called at the end of this
		 * choice.
		 */
		public static function showChoice(message:String, choices:Array, callback:Function = null):void {
			var DBOX_CHARS_PER_LINE:int = Text.charsAllowed(FONT_INDEX, DBOX_TEXT_WIDTH);
			var DBOX_LINES:int = Text.linesAllowed(FONT_INDEX, DBOX_TEXT_HEIGHT, DBOX_TEXT_SPACING);
			message = StringUtil.trim(message.substr(0, CHOICE_LEN));
			var cut:int = Text.cutText(FONT_INDEX, message, DBOX_TEXT_WIDTH, CELL_WIDTH +
				DBOX_TEXT_SPACING, DBOX_TEXT_SPACING);
			var pieces:Array = new Array();
			
			while (message.length > 0) {
				var cleanedMessage:String;
				if (cut == message.length) {
					cleanedMessage = message.indexOf("\\n") == 0 ? message.substr(2) : message;
					pieces.push(cleanedMessage);
					break;
				} else {
					cleanedMessage = message.substr(0, cut);
					cleanedMessage = cleanedMessage.indexOf("\\n") == 0 ? cleanedMessage.substr(2) :
						cleanedMessage;
					pieces.push(cleanedMessage);
					message = message.substr((message.charAt(cut) == " ") ? cut + 1 : cut);
					message = message.indexOf("\\n") == 0 ? message.substr(2) : message;
				}
				cut = Text.cutText(FONT_INDEX, message, DBOX_TEXT_WIDTH, CELL_WIDTH + DBOX_TEXT_SPACING,
					DBOX_TEXT_SPACING);
			}
			message = "";
			for (var i:int = 0; i < pieces.length; i++) {
				var piece:String = pieces[i];
				while (piece.length < DBOX_CHARS_PER_LINE) {
					piece += " ";
				}
				message += piece;
			}
			message = message.replace(/[\u000d\u000a\u0008]+/g, "");
			for each (var choice:String in choices) {
				message += "\n" + StringUtil.trim(choice);
			}
			actions.push(new DialogueAction(DialogueAction.T_DISP_CHOICE, message, callback));
		}
		
		/**
		 * Gets the last chosen choice from a Choice action.
		 * @return The string value of the chosen choice.
		 */
		public static function getChoice():String {
			return choices[choiceIndex];
		}
		
		// Helpers
		private static function setLeftPortrait(portrait:String):void {
			oldLeftPortrait = leftPortrait;
			leftPortrait = portrait;
			lpWidth = portrait == null ? 0 : Image.iWidth(portrait);
			lpHeight = portrait == null ? 0 : Image.iWidth(portrait);
		}
		
		private static function setRightPortrait(portrait:String):void {
			oldRightPortrait = rightPortrait;
			rightPortrait = portrait;
			rpWidth = portrait == null ? 0 : Image.iWidth(portrait);
			rpHeight = portrait == null ? 0 : Image.iWidth(portrait);
		}
		
		private static function shiftActions():void {
			var action:DialogueAction = actions.shift();
			if (action.callback != null) {
				action.callback();
			}
		}
		
		// KeyListener Interface Implementions
		public static function onKeyDown(e:KeyboardEvent):void {
			// TODO: handle if needed
			return;
		}
		
		public static function onKeyUp(e:KeyboardEvent):void {
			if (actions.length == 0) {
				return;
			}
			var curAction:DialogueAction = actions[0];
			if ((curAction.type == DialogueAction.T_DISP_TXT || curAction.type == DialogueAction.T_DISP_TXT_CONT) &&
				e.keyCode == ControlSettings.BUTTON1 && curAction.state < 0) {
				shiftActions();
			} else if (curAction.type == DialogueAction.T_DISP_CHOICE && curAction.state <
				0) {
				if (choiceIndex != 0 && e.keyCode == ControlSettings.LEFT) {
					choiceIndex--;
				} else if (choiceIndex != choices.length - 1 && e.keyCode == ControlSettings.RIGHT) {
					choiceIndex++;
				} else if (e.keyCode == ControlSettings.BUTTON1) {
					shiftActions();
				}
			}
		}
	}
}

class DialogueAction {
	public var state:int;
	public var type:int;
	public var callback:Function;
	public var initData:String;
	public static const T_LP_FADE_IN:int = 0;
	public static const T_LP_FADE_OUT:int = 1;
	public static const T_RP_FADE_IN:int = 2;
	public static const T_RP_FADE_OUT:int = 3;
	public static const T_LP_FADE_C:int = 4;
	public static const T_RP_FADE_C:int = 5;
	public static const T_DISP_TXT:int = 6;
	public static const T_START:int = 7;
	public static const T_END:int = 8;
	public static const T_DISP_CHOICE:int = 9;
	public static const T_DISP_TXT_CONT:int = 10;
	
	public static const FADE_TIME:int = 60;
	public static const LETTER_TIME:int = 3;
	public static const H_LETTER_TIME:int = 1;
	public static const BLINK_TIME:int = -31;
	
	public function DialogueAction(type:int, initData:String, callback:Function) {
		this.type = type;
		this.initData = initData;
		this.callback = callback;
	}
	
	public function advanceState():void {
		switch (type) {
			case T_LP_FADE_IN:
			case T_RP_FADE_IN:
			case T_LP_FADE_OUT:
			case T_RP_FADE_OUT:
			case T_LP_FADE_C:
			case T_RP_FADE_C:
			case T_START:
			case T_END:
				state++;
				break;
			case T_DISP_TXT:
			case T_DISP_TXT_CONT:
				if (state >= 0) {
					state++;
					if (initData.charAt(int(state / DialogueAction.LETTER_TIME)) == " ") {
						state += LETTER_TIME;
					}
					if (state >= initData.length * LETTER_TIME) {
						state = -1;
					}
				} else if (state < 0) {
					state--;
					if (state == -61) {
						state = -1;
					}
				}
				break;
			case T_DISP_CHOICE:
				if (state >= 0) {
					state++;
					if (initData.charAt(int(state / DialogueAction.LETTER_TIME)) == " ") {
						state += LETTER_TIME;
					}
					if (state >= initData.length * LETTER_TIME) {
						state = -1;
					}
				} else if (state < 0) {
					state--;
					if (state == -61) {
						state = -1;
					}
				}
				break;
		}
	}
}