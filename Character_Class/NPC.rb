require 'ruby2d'
require_relative '../ImageHandler' # to read dimemsion of image ==> must install (gem install rmagick)
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative '../WorldHandler'


include CCHECK
include WorldHandler




class NPC < Sprite
  attr_reader :x, :y, :speed, :worldX, :worldY, :moveCounter
  attr_accessor :upDirection, :downDirection, :leftDirection,
  :rightDirection, :solidArea, :collisionOn, :image, :onPath

  def initialize(worldX, worldY, width, height)

    @image = nil

    #Direction and Speed
    @speed = nil
    @upDirection = false
    @downDirection = false
    @leftDirection = false
    @rightDirection = false

    #World Coordinate
    @worldX = worldX
    @worldY = worldY
    @solidArea = Rectangle.new(
      x: 8, y: 16,            # Position
      width: 32, height: 32,  # Size
      opacity: 0
    )
    @collisionOn = false
  end

  def updateNPC(player, map)
    WorldHandler::DrawObject(self, player)
    checkCollision(player,map)
  end

  def checkCollision(player, map)
    CCHECK.checkTile(self, map)
    if CCHECK.checkEntity_Collide_SingleTarget(player, self) == true
      startDialogue
    end
  end

  def startDialogue
     # chat override
  end

end
