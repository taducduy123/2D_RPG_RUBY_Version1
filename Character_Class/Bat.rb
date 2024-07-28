require 'ruby2d'
require_relative 'HealthBar'
require_relative '../ImageHandler' # to read dimemsion of image ==> must install (gem install rmagick)
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative 'Monster'
include CCHECK

class Bat < Monster
  def initialize(wordlX, worldY, width, height, player)
    super(wordlX, worldY, width, height)
    
    @image = Sprite.new(
      'Image/Bat.png',
      x: @worldX - player.worldX + player.x,
      y: @worldY - player.worldY + player.y,
      width: width, height: height,
      clip_width: width_Of('Image/Bat.png') / 2,
      animations: {fly: 1..2},
      loop: true,
      time: 200
    )
    @image.play

    # Health Bar
    @healthBar = HealthBar.new(100, 100, -999, -999, 48)

    # Speed
    @speed = 1
  end


#-------------------------------- Override Methods -----------------------------------------
  def updateMonster(player, map, pFinder, items, npcs, monsters)  
    if(@exist == true)
      self.DrawMonster(player)
      self.DrawHealthBar(player)
      self.randMove(player, map, items, npcs, monsters)
      # self.moveForwardTo((player.worldY + player.solidArea.y) / CP::TILE_SIZE, (player.worldX + player.solidArea.x) / CP::TILE_SIZE, 
      #                     player, map, pFinder, items, npcs, monsters)
    else
      self.removeMonster
    end
  end

end


