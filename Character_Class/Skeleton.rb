require 'ruby2d'
require_relative 'HealthBar'
require_relative '../ImageHandler' # to read dimemsion of image ==> must install (gem install rmagick)
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative 'Monster'
include CCHECK

class Skeleton < Monster
  def initialize(wordlX, worldY, width, height, player)
    super(wordlX, worldY, width, height)

    @image = Sprite.new(
      'Image/Skeleton.png',
      x: @worldX - player.worldX + player.x,
      y: @worldY - player.worldY + player.y,
      width: width, height: height,
      # clip_width: width_Of('Image/cropskeleton.png') / 10,
      # clip_height: height_Of('Image/cropskeleton.png'),
      animations: {
        walk:
        [
           {
             x: 0, y: 0,
             width: 32, height: 49,
             time: 180, flip: :none
           },
           {
             x: 39, y: 0,
             width: 32, height: 49,
             time: 180, flip: :none
           },
           {
             x: 74, y: 0,
             width: 36, height: 49,
             time: 180, flip: :none
           },
           {
             x: 113, y: 0,
             width: 37, height: 49,
             time: 180, flip: :none
           },
           {
             x: 152, y: 0,
             width: 40, height: 49,
             time: 180, flip: :none
           },
           {
             x: 192, y: 0,
             width: 40, height: 49,
             time: 180, flip: :none
           },
           {
             x: 238, y: 0,
             width: 35, height: 49,
             time: 180, flip: :none
           },
           {
             x: 357, y: 0,
             width: 33, height: 49,
             time: 180, flip: :none
           }
         ]

       },
    )

    # Health Bar
    @healthBar = HealthBar.new(100, 100, -999, -999, 48)

    # Speed
    @speed = 1

    #show path?
    @showPathOn = true
  end
  def runAnimation
    @image.play animation: :walk, loop: true
  end

  def runAnimationLeft
    @image.play animation: :walk, loop: true, flip: :horizontal
  end

#-------------------------------- Override Methods -----------------------------------------
  def updateMonster(player, map, items, npcs, monsters)
    if(@exist == true)
      self.DrawMonster(player)
      self.DrawHealthBar(player)

      self.resetPath
      self.moveForwardTo((player.worldY + player.solidArea.y) / CP::TILE_SIZE, (player.worldX + player.solidArea.x) / CP::TILE_SIZE,
                          player, map, items, npcs, monsters)
      self.showPath(player)
    else
      self.removeMonster
    end
  end

end
