package;

class Enemy extends KinematicBody2D {
   public var damage:Float = 0.25;
   var speed:Float = 15.0;
   var health:Float = 1.0;

   function inital_randomization() {
      
      this.damage *= randRange(0.5 * Player.difficulty, 2 * Player.difficulty);
      this.speed *= randRange(0.5 * Player.difficulty, 2 * Player.difficulty);
      this.health *= randRange(0.5 * Player.difficulty, 2 * Player.difficulty);
      getNode('Body').as(Sprite).setSelfModulate(new Color(1 - randf(), randf(), randf(), 1));
   }

   override function _Ready() {
      inital_randomization();
   }

   override function _Process(delta:Single) {
      getNode('Eyes').as(Node2D).setRotation(getNode('Body').as(Node2D).getAngleTo(getNode('/root/BlueArea/Player').as(Node2D).position) + (Math.PI/2));
      var vel = position.directionTo(getNode('/root/BlueArea/Player').as(Node2D).position) * speed;
      moveAndSlide(vel);
      if (position.distanceTo(getNode('/root/BlueArea/Player').as(Node2D).position) > 1000) {
         this.queueFree();
         Player.difficulty += 0.5;
      }

      if (health <= 0) this.queueFree();
   }
}
