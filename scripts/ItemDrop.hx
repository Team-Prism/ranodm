package;

import godot.Color.Color_;
import ItemInstance.ItemType;

class ItemDrop extends StaticBody2D {
   public var item:ItemInstance;
   var time:Single = 0;

   override function _Ready() {
      this.item = ItemInstance.randomItem();
      var sprite = getNode('Sprite').as(Sprite);
      var texPos = ItemInstance.getItemTexture(this.item.type);
      var rect = sprite.getRegionRect();
      rect.position = texPos;
      sprite.setRegionRect(rect);
      if (item.type.getParameters().length > 0) {
         var color:Color = item.type.getParameters()[0];
         sprite.setSelfModulate(color);
         var c = sprite.getSelfModulate();
         print('r:${c.r} g:${c.g} b:${c.b} a:${c.a}');
      } else {
         sprite.setSelfModulate(new Color(1, 1, 1, 1));
      }
      //sprite.regionRect.position = texPos;
   }

   override function _Process(delta:Single) {
      if (position.distanceTo(getNode('/root/BlueArea/Player').as(Node2D).position) > 1000) {
         this.queueFree();
      }
   }
}
