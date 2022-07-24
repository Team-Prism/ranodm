package;

class Player extends Node2D {
   var isUsingMouse = false;
   static inline final allowMouse = false;

   static inline final baseMovementSpeed = 150;
   var attackSpeed:Single = 1.0;
   var attackDamage:Single = 1.0;
   var movementSpeed:Single = 1.0;

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
      var move = getInputVector();
      this.position = this.position + (move * delta * baseMovementSpeed * movementSpeed);
      if (Input.isActionJustPressed('ui_accept')) {
         randomize();
      }
   }

   function randomize() {
      this.attackSpeed *= Math.sqrt(randRange(0.1, 10));
      this.attackDamage *= randRange(0.1, 10);
      var mult = Math.pow(randRange(0.1, 10), 0.1);
      this.movementSpeed *= mult;
      print('$mult -> $movementSpeed');
   }

   override function _Ready() {
      randomize();
   }
}