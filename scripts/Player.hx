package;

class Player extends Area2D {
   public static var difficulty:Float = 1;
   var isUsingMouse = false;
   static inline final allowMouse = false;

   static inline final baseMovementSpeed = 150;
   //var attackSpeed(get, default):Single = 1.0;
   //var attackDamage(get, default):Single = 1.0;
   var movementSpeed(get, default):Single = 1.0;

   var maxHealth(get, default):Single = 1.0;
   var currentHealth = 1.0;
   var currentHealthPercent(get, set):Float;

   function get_maxHealth():Single {
      var value = maxHealth;
      for (item in this.items) {
         for (effect in item.effects) {
               switch effect {
                  case AddMaxHealth(amount):
                     value += amount;
                  case MultMaxHealth(amount):
                     value *= amount;
                  default:
               }
         }
      }
      return value;
   }

   function get_currentHealthPercent():Float {
      return currentHealth/maxHealth;
   }

   function set_currentHealthPercent(value:Float):Float {
      return currentHealth = (value / 1) * maxHealth;
   }

 /*   function get_attackDamage():Single {
      var value = attackDamage;
      for (item in this.items) {
         for (effect in item.effects) {
               switch effect {
                  case AddAttackDamage(amount):
                     value += amount;
                  case MultAttackDamage(amount):
                     value *= amount;
                  default:
               }
         }
      }
      return value;
   }

   function get_attackSpeed():Single {
      var value = attackSpeed;
      for (item in this.items) {
         for (effect in item.effects) {
               switch effect {
                  case AddAttackSpeed(amount):
                     value += amount;
                  case MultAttackSpeed(amount):
                     value *= amount;
                  default:
               }
         }
      }
      return value;
   } */

   function get_movementSpeed():Single {
      var value = movementSpeed;
      for (item in this.items) {
         for (effect in item.effects) {
               switch effect {
                  case AddMovementSpeed(amount):
                     value += amount;
                  case MultMovementSpeed(amount):
                     value *= amount;
                  default:
               }
         }
      }
      return value;
   }

   var items:Array<ItemInstance> = [];

   function getInputVector():Vector2 {
      var vec:Vector2;
      if (allowMouse && Input.isMouseButtonPressed(1)) {
         isUsingMouse = true;
         vec = this.globalPosition.directionTo(getGlobalMousePosition());
         var dis = this.globalPosition.distanceTo(getGlobalMousePosition()) / (128/3);
         vec *= dis;
      } else {
         isUsingMouse = false;
         vec = Input.getVector(Action.move_left, Action.move_right, Action.move_up, Action.move_down);
      }
      if (vec.length() > 1)
         vec = vec.normalized();
      return vec;
   }

   override function _Process(delta:Single) {
      Player.difficulty += delta/10;
      var move = getInputVector();
      if (Math.abs(move.x) > 0.1) {
         getNode('Haxe').as(AnimatedSprite).flipH = move.x > 0;
      }
      this.position = this.position + (move * delta * baseMovementSpeed * movementSpeed);
      if (Input.isActionJustPressed('ui_accept')) {
         this.items.push(ItemInstance.randomItem());
      }
      var healthBar:ProgressBar = cast getNode('ProgressBar');
      healthBar.setMax(this.maxHealth);
      healthBar.setValue(this.currentHealth);
   }

   override function _PhysicsProcess(delta:Single) {
      iframes -= delta;
      var enemyGroup = getNode('/root/BlueArea/Enemies').as(Node2D);
      if (randf() < 0.01 && enemyGroup.getChildCount() < 50) {
         var enemyFile:PackedScene = GD.load('res://objects/Enemy.tscn');
         var enemy:Enemy = enemyFile.instance().as(Enemy);
         enemy.setGlobalPosition(this.getGlobalPosition() + (new Vector2(randRange(-1,1)*100, randRange(-1,1)*100) * 50));
         enemyGroup.addChild(enemy);
      }

      var itemGroup = getNode('/root/BlueArea/Items').as(Node2D);
      if (randf() < 0.1 && itemGroup.getChildCount() < 50) {
         var itemFile:PackedScene = GD.load('res://objects/ItemDrop.tscn');
         var item:ItemDrop = itemFile.instance().as(ItemDrop);
         item.setGlobalPosition(this.getGlobalPosition() + (new Vector2(randRange(-1,1)*100, randRange(-1,1)*100) * 15));
         itemGroup.addChild(item);
      }

      for (body in this.getOverlappingBodies()) {
         if (body == null) continue;
         if (body is Enemy) {
            if (iframes > 0) continue;
            iframes = 0.2;
            this.currentHealth -= body.as(Enemy).damage;
            this.loseItem();
            if (this.items.length <= 0) {
               this.lose();
            }
         } else if (body is ItemDrop) {
            print('item');
            this.pickupItem(body.as(ItemDrop));
            body.as(ItemDrop).queueFree();
         }
      }

      setModulate(new Color(1, 1, 1, this.iframes > 0 ? 0.5 : 1));
   }

   var iframes:Float = 0;

   function initial_randomization() {
      //this.attackSpeed *= randRange(0.5, 2);
      //this.attackDamage *= randRange(0.5, 2);
      this.movementSpeed *= randRange(0.5, 2);
      //this.items.push(ItemInstance.randomItem());
   }

   override function _Ready() {
      GD.randomize();
      initial_randomization();
   }

   function pickupItem(item:ItemDrop) {
      var addToInventory = false;
      for (effect in item.item.effects) {
         switch effect {
            case HealNumber(amount, overheal):
               this.currentHealth += amount;
               if (!overheal)
                  this.currentHealth = Math.min(currentHealth, maxHealth);
            case HealPercentTotal(amount, overheal):
               this.currentHealth += (amount/1)*maxHealth;
               if (!overheal)
                  this.currentHealth = Math.min(currentHealth, maxHealth);
            case HealPercentMissing(amount):
               this.currentHealthPercent = currentHealthPercent + amount;
               this.currentHealth = Math.min(currentHealth, maxHealth);
            default:
               addToInventory = true;
         }
      }
      if (addToInventory)
         this.items.push(item.item);
   }

   function loseItem() {
      var idx = Math.floor(Math.random()*this.items.length);
      this.items.remove(this.items[idx]);
   }

   function lose() {
      this.getNode('Lose').as(Node2D).visible = true;
      getTree().setPause(true);
   }
}