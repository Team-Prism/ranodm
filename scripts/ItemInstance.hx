package;

import godot.Color.Color_;

enum ItemType {
   Fez;
   Fedora(color:Color_);
   Helmet;
   TShirt(color:Color_);
   Vest;
   Bow;
   Sneaker;
   Boot;
   Shoe(color:Color_);
   OFPBadge;
   FakeMoustache;
   RealMoustache;
   GoldenStopwatch;
   GenericStopwatch(color:Color_);
   Key(color:Color_);
   Orb(color:Color_);
   Cube(color:Color_);
   Gun(color:Color_);
   Sword(color:Color_);
   Shield(color:Color_);

   Spoon;
   Spoon2;
   Megadrive;
   Megadrive2;
   QuadPistol;
   PizzaLauncher;

   // foods
   Pumpkin;
   Melon;
   OtherPumpkin;
   Pizza;
   Sandvich;
   Pie;
   Apple(color:Color_);
   Borger(color:Color_);
}

enum ProjectileType {
   ProjBullet;
   ProjPizza;
}

enum ItemEffect {
   AddMaxHealth(amount:Float);
   MultMaxHealth(amount:Float);
   AddDefense(amount:Float);
   AddMovementSpeed(amount:Float);
   MultMovementSpeed(amount:Float);
   HealNumber(amount:Float, overheal:Bool);
   HealPercentTotal(amount:Float, overheal:Bool);
   HealPercentMissing(amount:Float);
}

class ItemInstance {
   public var type:ItemType;
   public var effects:Array<ItemEffect>;

   public function new(type:ItemType, effects:Array<ItemEffect>) {
      this.type = type;
      this.effects = effects;
   }

   public static function randomEffect():ItemEffect {
      return switch Math.round(randRange(0, 6)) {
         case 0: AddMaxHealth(randRange(0.1, 10));
         case 1: MultMaxHealth(randRange(1.01, 1.2));
         //case 2: AddDefense(randRange(1, 10));
         case 2: AddMovementSpeed(randf()/5);
         case 3: MultMovementSpeed(1 + (randf()/5));
         //case 5: AddAttackSpeed(randRange(1, 4));
         //case 6: MultAttackSpeed(1 + (randf()/5));
         //case 7: AddAttackDamage(randf()*3);
         //case 8: MultAttackDamage(1 + (randf()/3));
         case 4: HealNumber(randf()*3, randf() < 0.1);
         case 5: HealPercentTotal((randf()/10) + (randf()/5), randf() < 0.05);
         case 6: HealPercentMissing(randf());

         default: HealNumber(0.0, false);
      }
   }

   public static function randomItem():ItemInstance {
      var color:Color_ = new Color_(randf(), randf(), randf(), 1);
      var type = switch Math.round(randRange(0, 32)) {
         case 0: Pumpkin;
         case 1: Melon;
         case 2: OtherPumpkin;
         case 3: Pizza;
         case 4: Sandvich;
         case 5: Pie;
         case 6: Spoon;
         case 7: Megadrive;
         case 8: Megadrive2;
         case 9: QuadPistol;
         case 10: PizzaLauncher;
         case 11: Fez;
         case 12: Bow;
         case 13: Sneaker;
         case 14: OFPBadge;
         case 15: FakeMoustache;
         case 16: RealMoustache;
         case 17: Helmet;
         case 18: Vest;
         case 19: Boot;
         case 20: GoldenStopwatch;
         case 21: Fedora(color);
         case 22: TShirt(color);
         case 23: Shoe(color);
         case 24: Key(color);
         case 25: Orb(color);
         case 26: Cube(color);
         case 27: Gun(color);
         case 28: Sword(color);
         case 29: Shield(color);
         case 30: GenericStopwatch(color);
         case 31: Apple(color);
         case 32: Borger(color);

         default: Spoon2;
      }

      var effectCount = Math.round(randRange(1, 5));
      var effects = [];
      while (effectCount > 0) {
         effectCount--;
         effects.push(randomEffect());
      }

      return new ItemInstance(type, effects);
   }

   public static function getItemTexture(type:ItemType):Vector2 {
      return (switch type {
         case Pumpkin: new Vector2(0, 0);
         case Melon: new Vector2(0, 1);
         case OtherPumpkin: new Vector2(0,2);
         case Pizza: new Vector2(0, 3);
         case Sandvich: new Vector2(0, 4);
         case Pie: new Vector2(0, 5);
         case Spoon: new Vector2(1, 0);
         case Megadrive: new Vector2(1, 1);
         case Megadrive2: new Vector2(1, 2);
         case QuadPistol: new Vector2(1, 3);
         case PizzaLauncher: new Vector2(1, 4);
         case Spoon2: new Vector2(2, 0);
         case Fez: new Vector2(3, 0);
         case Bow: new Vector2(3, 1);
         case Sneaker: new Vector2(3, 2);
         case OFPBadge: new Vector2(3, 3);
         case FakeMoustache: new Vector2(3, 4);
         case RealMoustache: new Vector2(3, 5);
         case Helmet: new Vector2(4, 0);
         case Vest: new Vector2(4, 1);
         case Boot: new Vector2(4, 2);
         case GoldenStopwatch: new Vector2(4, 3);
         case Fedora(_): new Vector2(5, 0);
         case TShirt(_): new Vector2(5, 1);
         case Shoe(_): new Vector2(5, 2);
         case Key(_): new Vector2(5, 3);
         case Orb(_): new Vector2(5, 4);
         case Cube(_): new Vector2(5, 5);
         case Gun(_): new Vector2(6, 0);
         case Sword(_): new Vector2(6, 1);
         case Shield(_): new Vector2(6, 2);
         case GenericStopwatch(_): new Vector2(6, 3);
         case Apple(_): new Vector2(6, 4);
         case Borger(_): new Vector2(6, 5);
      }) * 24;
   }
}