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

    @speed = 1
  end


#-------------------------------- Override Methods -----------------------------------------
  def updateMonster(player, map, pFinder, items, npcs)
      self.DrawMonster(player)
      #self.debug((player.worldY + player.solidArea.y) / CP::TILE_SIZE, (player.worldX + player.solidArea.x) / CP::TILE_SIZE, player, map, pFinder)
      #self.randMove(player, map)
      self.moveForwardTo((player.worldY + player.solidArea.y) / CP::TILE_SIZE, (player.worldX + player.solidArea.x) / CP::TILE_SIZE, 
                          player, map, pFinder, items, npcs)
  end




  # def debug(goalRow, goalCol, player, map, pFinder)
  #   startRow = (@worldY + @solidArea.y) / CP::TILE_SIZE
  #   startCol = (@worldX + @solidArea.x) / CP::TILE_SIZE
  
  #   pFinder.setNodes(startRow, startCol, goalRow, goalCol, map)

  #   pFinder.search()
  #   puts "#{pFinder.pathList[0].row}     #{pFinder.pathList[0].col} \n"

    
  # end


end

# player = Player.new(48, 48)
# bat = Bat.new(300, 300, 48, 48)
# bat.DrawMonster(player)
# show
