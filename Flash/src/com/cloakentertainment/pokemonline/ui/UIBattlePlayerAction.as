package com.cloakentertainment.pokemonline.ui
{
	import com.cloakentertainment.pokemonline.battle.BattleAction;
	import com.cloakentertainment.pokemonline.Configuration;
	import com.cloakentertainment.pokemonline.input.InputGroups;
	import com.cloakentertainment.pokemonline.input.KeyboardManager;
	import com.cloakentertainment.pokemonline.sound.SoundManager;
	import com.cloakentertainment.pokemonline.stats.Pokemon;
	import com.cloakentertainment.pokemonline.stats.PokemonMoves;
	import com.cloakentertainment.pokemonline.battle.BattleType;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author PROWNE
	 */
	public class UIBattlePlayerAction extends Sprite
	{
		
		public static const TEXT_FORMAT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x484848, null, null, null, null, null, null, null, null, null, 5);
		public static var TEXT_FORMAT_MOVE:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x484848, null, null, null, null, null, null, null, null, null, 5);
		public static var TEXT_FORMAT_RIGHT:TextFormat = new TextFormat("PokemonFont", 16 * Configuration.SPRITE_SCALE, 0x484848, null, null, null, null, null, TextFormatAlign.RIGHT, null, null, null, 5);
		
		private var _box:UIBox;
		private var _action1:TextField;
		private var _action2:TextField;
		private var _action3:TextField;
		private var _action4:TextField;
		private var _arrow:UIBlackArrow;
		
		private var currentPokemon:Pokemon;
		private var uiBattle:UIBattle;
		
		private var wallyBattle:Boolean;
		private var wallyIn:Boolean;
		
		private var secondPokemon:Boolean;
		
		public function UIBattlePlayerAction(_currentPokemon:Pokemon, _uiBattle:UIBattle, _wallyBattle:Boolean, _wallyIn:Boolean, _secondPokemon:Boolean)
		{
			super();
			
			uiBattle = _uiBattle;
			
			currentPokemon = _currentPokemon;
			currentTarget = uiBattle.battle.enemyPokemon[0].ACTIVE ? uiBattle.battle.enemyPokemon[0] : uiBattle.battle.enemyPokemon[1];
			secondPokemon = _secondPokemon;
			
			TEXT_FORMAT_MOVE.letterSpacing = -0.75 * Configuration.SPRITE_SCALE;
			TEXT_FORMAT_RIGHT.letterSpacing = -0.75 * Configuration.SPRITE_SCALE;
			
			wallyBattle = _wallyBattle;
			wallyIn = _wallyIn;
			
			construct();
		}
		
		public function construct():void
		{
			_box = new UIBox(120, 48);
			_box.x = Configuration.VIEWPORT.width - _box.width;
			_box.y = Configuration.VIEWPORT.height - _box.height;
			this.addChild(_box);
			
			_action1 = new TextField();
			configureTextfield(_action1);
			_action1.text = "FIGHT";
			_action1.y = _box.y + 7 * Configuration.SPRITE_SCALE;
			_action1.x = _box.x + 16 * Configuration.SPRITE_SCALE;
			
			_action2 = new TextField();
			configureTextfield(_action2);
			_action2.text = "POKéMON";
			_action2.y = _box.y + 23 * Configuration.SPRITE_SCALE;
			_action2.x = _box.x + 16 * Configuration.SPRITE_SCALE;
			
			_action3 = new TextField();
			configureTextfield(_action3);
			_action3.text = "BAG";
			_action3.y = _box.y + 7 * Configuration.SPRITE_SCALE;
			_action3.x = _box.x + 72 * Configuration.SPRITE_SCALE;
			
			_action4 = new TextField();
			configureTextfield(_action4);
			_action4.text = "RUN";
			_action4.y = _box.y + 23 * Configuration.SPRITE_SCALE;
			_action4.x = _box.x + 72 * Configuration.SPRITE_SCALE;
			
			_arrow = new UIBlackArrow();
			_arrow.x = _box.x;
			_arrow.y = _box.y;
			this.addChild(_arrow);
			select(1, false);
			
			if (!wallyBattle)
			{
				KeyboardManager.registerKey(Configuration.UP_KEY, pressUp, InputGroups.BATTLE, true);
				KeyboardManager.registerKey(Configuration.DOWN_KEY, pressDown, InputGroups.BATTLE, true);
				KeyboardManager.registerKey(Configuration.LEFT_KEY, pressLeft, InputGroups.BATTLE, true);
				KeyboardManager.registerKey(Configuration.RIGHT_KEY, pressRight, InputGroups.BATTLE, true);
				TweenLite.delayedCall(10, KeyboardManager.registerKey, [Configuration.ENTER_KEY, pressEnter, InputGroups.BATTLE, true], true);
			}
			else
			{
				// Automatically choose fight, then the first option
				if (!wallyIn) TweenLite.delayedCall(1, pressEnter);
				else
				{
					TweenLite.delayedCall(1, pressRight);
					TweenLite.delayedCall(1.5, pressEnter);
				}
			}
		}
		
		private function pressUp():void
		{
			if (currentlySelected == 2)
				select(1);
			else if (currentlySelected == 4)
				select(3);
		}
		
		private function pressDown():void
		{
			if (currentlySelected == 1)
				select(2);
			else if (currentlySelected == 3)
				select(4);
		}
		
		private function pressLeft():void
		{
			if (currentlySelected == 3)
				select(1);
			else if (currentlySelected == 4)
				select(2);
		}
		
		private function pressRight():void
		{
			if (currentlySelected == 1)
				select(3);
			else if (currentlySelected == 2)
				select(4);
		}
		
		private var currentlySelected:int;
		private var menuOpen:Boolean = false;
		
		private function select(actionNum:int, playSound:Boolean = true):void
		{
			if (menuOpen) return;
			if (playSound)
				SoundManager.playEnterKeySoundEffect();
			currentlySelected = actionNum;
			switch (actionNum)
			{
			case 1: 
				alignArrowTo(_action1);
				break;
			case 2: 
				alignArrowTo(_action2);
				break;
			case 3: 
				alignArrowTo(_action3);
				break;
			case 4: 
				alignArrowTo(_action4);
				break;
			}
		}
		
		private function alignArrowTo(tf:TextField, arrow:UIBlackArrow = null):void
		{
			(arrow != null ? arrow : _arrow).x = tf.x - _arrow.width - 1 * Configuration.SPRITE_SCALE;
			(arrow != null ? arrow : _arrow).y = tf.y + (arrow != null ? 3.5 : 3.5) * Configuration.SPRITE_SCALE;
		}
		
		private function pressEnter():void
		{
			if (menuOpen) return;
			
			SoundManager.playEnterKeySoundEffect();
			if (currentlySelected == 1)
			{
				// Select FIGHT!
				
				// Make sure we don't already have a move selected; if we do, start the turn
				if (uiBattle.battle.doesPokemonNeedToSubmitAction(currentPokemon) == false)
				{
					uiBattle.receivePlayerAction(null);
					return;
				}
				
				createFightMenu();
			}
			else if (currentlySelected == 2)
			{
				// Select POKéMON
				createPokemonMenu();
			}
			else if (currentlySelected == 3)
			{
				// Select BAG
				createBagMenu();
			}
			else if (currentlySelected == 4)
			{
				// Select RUN
				if (uiBattle.battle.TYPE == BattleType.WILD)
				{
					if (uiBattle.battle.tutorialBattle)
					{
						MessageCenter.addMessage(Message.createMessage("PROF. BIRCH: Don't leave me like this!", true, 0, returnToAction, 22, false));
						this.visible = false;
						uiBattle.hideTextBar();
					}
					else uiBattle.receivePlayerAction(BattleAction.generateRun(currentPokemon));
				}
				else
				{
					MessageCenter.addMessage(Message.createMessage("No! There's no running\nfrom a TRAINER battle!", true, 0, returnToAction, 22, false));
					this.visible = false;
					uiBattle.hideTextBar();
				}
				return;
			}
		}
		
		private function returnToAction():void
		{
			this.visible = true;
			uiBattle.showTextBar();
		}
		
		private var fight_leftbox:UIBox;
		private var fight_rightbox:UIBox;
		private var move1:TextField;
		private var move2:TextField;
		private var move3:TextField;
		private var move4:TextField;
		private var fight_arrow:UIBlackArrow;
		private var currentlySelectedMove:int;
		private var PPtxt:TextField;
		private var PPval:TextField;
		private var TYPEtxt:TextField;
		private var TYPEval:TextField;
		
		private var currentTarget:Pokemon;
		
		private function ensurePokemonHasPPLeft():Boolean
		{
			var hasPPLeft:Boolean = false;
			
			if (currentPokemon.getMove(1) != "" && currentPokemon.getMovePP(1) > 0)
				hasPPLeft = true;
			if (currentPokemon.getMove(2) != "" && currentPokemon.getMovePP(2) > 0)
				hasPPLeft = true;
			if (currentPokemon.getMove(3) != "" && currentPokemon.getMovePP(3) > 0)
				hasPPLeft = true;
			if (currentPokemon.getMove(4) != "" && currentPokemon.getMovePP(4) > 0)
				hasPPLeft = true;
			
			if (hasPPLeft)
				return true;
			
			// Use struggle!
			var ba:BattleAction = BattleAction.generateMove(currentPokemon, currentTarget, PokemonMoves.getMoveIDByName("Struggle"));
			uiBattle.receivePlayerAction(ba);
			
			return false;
		}
		
		private function createPokemonMenu():void
		{
			if (_waitingOnPokemonMenu) return;
			_waitingOnPokemonMenu = true;
			menuOpen = true;
			KeyboardManager.disableInputGroup(InputGroups.BATTLE);
			
			Configuration.FADE_OUT_AND_IN(finishCreatePokemonMenu);
		}
		
		private var _waitingOnPokemonMenu:Boolean = false;
		
		private function finishCreatePokemonMenu():void
		{
			Configuration.createMenu(MenuType.POKEMON, 1, finishSelectingReplacementPokemon, true);
			
			KeyboardManager.disableInputGroup(InputGroups.BATTLE);
			KeyboardManager.disableInputGroup(InputGroups.OVERWORLD);
			KeyboardManager.disableInputGroup(InputGroups.POKEMON_SELECT_MENU);
		}
		
		private function createBagMenu():void
		{
			KeyboardManager.disableInputGroup(InputGroups.BATTLE);
			menuOpen = true;
			Configuration.FADE_OUT_AND_IN(finishCreateBagMenu);
		}
		
		private function finishCreateBagMenu():void
		{
			Configuration.createMenu(MenuType.BAG, 1, finishSelectingItemForUse, false, wallyBattle ? "wally" : "");
		}
		
		private function finishSelectingItemForUse(itemName:String):void
		{
			menuOpen = false;
			KeyboardManager.enableInputGroup(InputGroups.BATTLE);
			if (itemName == null) return;
			
			if (itemName.substr(-4, 4) == "Ball" && uiBattle.battle.TYPE != BattleType.WILD)
			{
				// Do not consume the item
			}
			else
			{
				Configuration.ACTIVE_TRAINER.consumeItem(itemName);
			}
			
			var ba:BattleAction = BattleAction.generateItem(currentPokemon, currentTarget, itemName);
			TweenLite.delayedCall(1, uiBattle.receivePlayerAction, [ba]);
			KeyboardManager.enableInputGroup(InputGroups.BATTLE);
		}
		
		private function finishSelectingReplacementPokemon(shiftingPokemon:Pokemon):void
		{
			_waitingOnPokemonMenu = false;
			menuOpen = false;
			if (shiftingPokemon == null)
				return;
			
			var ba:BattleAction = BattleAction.generateSwitch(currentPokemon, shiftingPokemon);
			TweenLite.delayedCall(0.5, uiBattle.receivePlayerAction, [ba], false);
		}
		
		private function ensurePokemonHasntAlreadyMoved():Boolean
		{
			return uiBattle.battle.doesPokemonNeedToSubmitAction(currentPokemon);
		}
		
		private function createFightMenu():void
		{
			if (!ensurePokemonHasPPLeft())
				return;
			if (!ensurePokemonHasntAlreadyMoved())
				return;
			
			KeyboardManager.disableAllInputGroupsExcept(InputGroups.BATTLE_FIGHT);
			
			fight_leftbox = new UIBox(160, 48);
			fight_rightbox = new UIBox(80, 48);
			
			this.addChild(fight_leftbox);
			this.addChild(fight_rightbox);
			
			fight_leftbox.y = fight_rightbox.y = Configuration.VIEWPORT.height - fight_leftbox.height;
			fight_leftbox.x = 0;
			fight_rightbox.x = fight_leftbox.width;
			
			move1 = new TextField();
			configureTextfield(move1, true);
			move1.text = currentPokemon.getMove(1).toUpperCase();
			move1.x = fight_leftbox.x + 14 * Configuration.SPRITE_SCALE;
			move1.y = fight_leftbox.y + 8 * Configuration.SPRITE_SCALE;
			this.addChild(move1);
			
			move2 = new TextField();
			configureTextfield(move2, true);
			move2.text = currentPokemon.getMove(2).toUpperCase();
			move2.x = fight_leftbox.x + 86 * Configuration.SPRITE_SCALE;
			move2.y = fight_leftbox.y + 8 * Configuration.SPRITE_SCALE;
			this.addChild(move2);
			
			move3 = new TextField();
			configureTextfield(move3, true);
			move3.text = currentPokemon.getMove(3).toUpperCase();
			move3.x = fight_leftbox.x + 14 * Configuration.SPRITE_SCALE;
			move3.y = fight_leftbox.y + 24 * Configuration.SPRITE_SCALE;
			this.addChild(move3);
			
			move4 = new TextField();
			configureTextfield(move4, true);
			move4.text = currentPokemon.getMove(4).toUpperCase();
			move4.x = fight_leftbox.x + 86 * Configuration.SPRITE_SCALE;
			move4.y = fight_leftbox.y + 24 * Configuration.SPRITE_SCALE;
			this.addChild(move4);
			
			PPtxt = new TextField();
			configureTextfield(PPtxt, true);
			PPtxt.text = "PP";
			PPtxt.x = fight_rightbox.x + 4 * Configuration.SPRITE_SCALE;
			PPtxt.y = fight_rightbox.y + 8 * Configuration.SPRITE_SCALE;
			this.addChild(PPtxt);
			PPval = new TextField();
			configureTextfield(PPval, false, true);
			PPval.text = "";
			PPval.x = fight_rightbox.x + 11.5 * Configuration.SPRITE_SCALE;
			PPval.y = fight_rightbox.y + 8 * Configuration.SPRITE_SCALE;
			this.addChild(PPval);
			
			TYPEtxt = new TextField();
			configureTextfield(TYPEtxt, true);
			TYPEtxt.text = "TYPE/";
			TYPEtxt.x = fight_rightbox.x + 4 * Configuration.SPRITE_SCALE;
			TYPEtxt.y = fight_rightbox.y + 24 * Configuration.SPRITE_SCALE;
			this.addChild(TYPEtxt);
			TYPEval = new TextField();
			configureTextfield(TYPEval, false, true);
			TYPEval.text = "";
			TYPEval.x = fight_rightbox.x + 11.5 * Configuration.SPRITE_SCALE;
			TYPEval.y = fight_rightbox.y + 24 * Configuration.SPRITE_SCALE;
			this.addChild(TYPEval);
			
			fight_arrow = new UIBlackArrow();
			this.addChild(fight_arrow);
			
			if (!secondPokemon) selectMove(Configuration.BATTLE_FIGHT_OPTION, false);
			else selectMove(Configuration.BATTLE_FIGHT_OPTION2, false);
			
			if (!wallyBattle)
			{
				KeyboardManager.registerKey(Configuration.CANCEL_KEY, destroyFightMenu, InputGroups.BATTLE_FIGHT, true);
				KeyboardManager.registerKey(Configuration.LEFT_KEY, fightPressLeft, InputGroups.BATTLE_FIGHT, true);
				KeyboardManager.registerKey(Configuration.RIGHT_KEY, fightPressRight, InputGroups.BATTLE_FIGHT, true);
				KeyboardManager.registerKey(Configuration.UP_KEY, fightPressUp, InputGroups.BATTLE_FIGHT, true);
				KeyboardManager.registerKey(Configuration.DOWN_KEY, fightPressDown, InputGroups.BATTLE_FIGHT, true);
				//KeyboardManager.registerKey(Configuration.ENTER, fightPressEnter, InputGroups.BATTLE_FIGHT, true);
				TweenLite.delayedCall(10, KeyboardManager.registerKey, [Configuration.ENTER_KEY, fightPressEnter, InputGroups.BATTLE_FIGHT, true], true);
			}
			else
			{
				TweenLite.delayedCall(1, fightPressDown);
				TweenLite.delayedCall(1.5, fightPressEnter);
			}
		}
		
		private function reenableFightBattleGroup():void
		{
			TweenLite.delayedCall(10, KeyboardManager.enableInputGroup, [InputGroups.BATTLE_FIGHT], true);
		}
		
		private function fightPressEnter():void
		{
			if (!currentPokemon) return;
			
			SoundManager.playEnterKeySoundEffect();
			
			if (_findingTarget)
			{
				generateMoveAndSend();
				_findingTarget = false;
				destroyFightMenu(false);
				return;
			}
			
			// Ensure that this move has enough PP to use
			if (currentPokemon.getMovePP(currentlySelectedMove) <= 0)
			{
				KeyboardManager.disableInputGroup(InputGroups.BATTLE_FIGHT);
				MessageCenter.addMessage(Message.createMessage(currentPokemon.getMove(currentlySelectedMove).toUpperCase() + " is out of PP!", true, 0, reenableFightBattleGroup));
				return;
			}
			else
			{
				if (uiBattle.battle.TYPE == BattleType.DOUBLE_TRAINERxTRAINER)
				{
					// Enter the targeting phase
					fightFindTarget();
					return;
				}
				
				// Transmit this action, then destroy this instance
				generateMoveAndSend();
				destroyFightMenu(false);
			}
		}
		
		private function generateMoveAndSend():void
		{
			_findingTarget = false;
			
			var ba:BattleAction = BattleAction.generateMove(currentPokemon, currentTarget, PokemonMoves.getMoveIDByName(currentPokemon.getMove(currentlySelectedMove)));
			uiBattle.receivePlayerAction(ba);
		}
		
		private var _findingTarget:Boolean = false;
		private function fightFindTarget():void
		{
			_findingTarget = true;
			if (uiBattle.battle.enemyPokemon[0].ACTIVE) currentTarget = uiBattle.selectTarget(0);
			else currentTarget = uiBattle.selectTarget(0);
		}
		
		private function fightPressLeft():void
		{
			if (_findingTarget)
			{
				currentTarget = uiBattle.selectTarget(0);
			} else
			if (currentlySelectedMove == 2 && move1.text != "")
			{
				selectMove(1);
			}
			else if (currentlySelectedMove == 4 && move3.text != "")
			{
				selectMove(3);
			}
		}
		
		private function fightPressRight():void
		{
			if (_findingTarget)
			{
				currentTarget = uiBattle.selectTarget(1);
			} else
			if (currentlySelectedMove == 1 && move2.text != "")
			{
				selectMove(2);
			}
			else if (currentlySelectedMove == 3 && move4.text != "")
			{
				selectMove(4);
			}
		}
		
		private function fightPressUp():void
		{
			if (_findingTarget) return;
			
			if (currentlySelectedMove == 3 && move1.text != "")
			{
				selectMove(1);
			}
			else if (currentlySelectedMove == 4 && move2.text != "")
			{
				selectMove(2);
			}
		}
		
		private function fightPressDown():void
		{
			if (_findingTarget) return;
			
			if (currentlySelectedMove == 1 && move3.text != "")
			{
				selectMove(3);
			}
			else if (currentlySelectedMove == 2 && move4.text != "")
			{
				selectMove(4);
			}
		}
		
		private function selectMove(moveNum:int, playSound:Boolean = true):void
		{
			if (playSound)
				SoundManager.playEnterKeySoundEffect();
			
			currentlySelectedMove = moveNum;
			
			if (!secondPokemon) Configuration.BATTLE_FIGHT_OPTION = currentlySelectedMove;
			else Configuration.BATTLE_FIGHT_OPTION2 = currentlySelectedMove;
			
			switch (moveNum)
			{
			case 1: 
				alignArrowTo(move1, fight_arrow);
				PPval.text = currentPokemon.getMovePP(1) + "/" + currentPokemon.getMovePPMax(1);
				TYPEval.text = PokemonMoves.getMoveTypeByID(PokemonMoves.getMoveIDByName(currentPokemon.getMove(1))).toUpperCase();
				break;
			case 2: 
				alignArrowTo(move2, fight_arrow);
				PPval.text = currentPokemon.getMovePP(2) + "/" + currentPokemon.getMovePPMax(2);
				TYPEval.text = PokemonMoves.getMoveTypeByID(PokemonMoves.getMoveIDByName(currentPokemon.getMove(2))).toUpperCase();
				break;
			case 3: 
				alignArrowTo(move3, fight_arrow);
				PPval.text = currentPokemon.getMovePP(3) + "/" + currentPokemon.getMovePPMax(3);
				TYPEval.text = PokemonMoves.getMoveTypeByID(PokemonMoves.getMoveIDByName(currentPokemon.getMove(3))).toUpperCase();
				break;
			case 4: 
				alignArrowTo(move4, fight_arrow);
				PPval.text = currentPokemon.getMovePP(4) + "/" + currentPokemon.getMovePPMax(4);
				TYPEval.text = PokemonMoves.getMoveTypeByID(PokemonMoves.getMoveIDByName(currentPokemon.getMove(4))).toUpperCase();
				break;
			}
		}
		
		private function destroyFightMenu(playSound:Boolean = true):void
		{
			if (_findingTarget)
			{
				if (playSound)
					SoundManager.playEnterKeySoundEffect();
				_findingTarget = false;
				uiBattle.stopFlash();
				return;
			}
			
			if (fight_leftbox)
			{
				if (playSound)
					SoundManager.playEnterKeySoundEffect();
				this.removeChild(fight_leftbox);
				this.removeChild(fight_rightbox);
				
				fight_rightbox.destroy();
				fight_leftbox.destroy();
			}
			
			fight_leftbox = fight_rightbox = null;
			
			if (move1)
			{
				this.removeChild(move1);
				this.removeChild(move2);
				this.removeChild(move3);
				this.removeChild(move4);
			}
			
			move1 = move2 = move3 = move4 = null;
			
			if (fight_arrow)
			{
				this.removeChild(fight_arrow);
				fight_arrow.destroy();
				fight_arrow = null;
			}
			
			if (PPtxt)
			{
				this.removeChild(PPtxt);
				this.removeChild(PPval);
				this.removeChild(TYPEtxt);
				this.removeChild(TYPEval);
			}
			
			PPtxt = PPval = TYPEtxt = TYPEval = null;
			
			KeyboardManager.unregisterKey(Configuration.CANCEL_KEY, destroyFightMenu);
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, fightPressLeft);
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, fightPressRight);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, fightPressDown);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, fightPressUp);
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, fightPressEnter);
			if (playSound)
				KeyboardManager.enableInputGroup(InputGroups.BATTLE);
		}
		
		private function configureTextfield(tf:TextField, useMoveFormat:Boolean = false, useAlignRight:Boolean = false):void
		{
			tf.embedFonts = true;
			tf.defaultTextFormat = useMoveFormat ? TEXT_FORMAT_MOVE : TEXT_FORMAT;
			if (useAlignRight)
				tf.defaultTextFormat = TEXT_FORMAT_RIGHT;
			//textField.textColor = 0xFFFFFF;
			tf.selectable = false;
			tf.filters = [Configuration.TEXT_FILTER];
			tf.wordWrap = true;
			tf.width = (useMoveFormat ? 70 : 50) * Configuration.SPRITE_SCALE;
			if (useAlignRight)
				tf.width = 64 * Configuration.SPRITE_SCALE;
			this.addChild(tf);
		}
		
		public function destroy():void
		{
			destroyFightMenu(false);
			
			this.removeChild(_box);
			_box.destroy();
			_box = null;
			
			this.removeChild(_action1);
			this.removeChild(_action2);
			this.removeChild(_action3);
			this.removeChild(_action4);
			
			_action1 = _action2 = _action3 = _action4 = null;
			
			this.removeChild(_arrow);
			_arrow.destroy();
			_arrow = null;
			
			currentPokemon = null;
			
			uiBattle = null;
			
			KeyboardManager.unregisterKey(Configuration.ENTER_KEY, pressEnter);
			KeyboardManager.unregisterKey(Configuration.LEFT_KEY, pressLeft);
			KeyboardManager.unregisterKey(Configuration.RIGHT_KEY, pressRight);
			KeyboardManager.unregisterKey(Configuration.DOWN_KEY, pressDown);
			KeyboardManager.unregisterKey(Configuration.UP_KEY, pressUp);
		
		}
	
	}

}