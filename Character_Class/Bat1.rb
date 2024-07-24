require 'ruby2d'
require_relative '../ImageHandler' # to read dimemsion of image ==> must install (gem install rmagick)
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative 'Monster'
include CCHECK

class Bat1 < Monster
  def initialize(wordlX, worldY, width, height)
    super(wordlX, worldY, width, height)
    @image = Sprite.new(
      'Image/Bat.png',
      x: 0,
      y: 0,
      width: width, height: height,
      clip_width: width_Of('Image/Bat.png') / 2,
      animations: {fly: 1..2},
      loop: true,
      time: 200
    )
    @image.play

    @speed = 3
  end


#-------------------------------- Override Methods -----------------------------------------
  def updateMonster(player, map, pFinder)
      self.DrawMonster(player)
      self.moveForwardTo(0, 0, player, map, pFinder)
  end

end

# player = Player.new(48, 48)
# bat = Bat.new(300, 300, 48, 48)
# bat.DrawMonster(player)
# show
