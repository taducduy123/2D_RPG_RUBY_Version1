require 'ruby2d'
require_relative '../ImageHandler' # to read dimemsion of image ==> must install (gem install rmagick)
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative '../FindingPath/Node'
require_relative '../FindingPath/PathFinder'

include CCHECK



class Monster < Sprite
  attr_reader :x, :y,
              :worldX, :worldY,
              :speed,
              :moveCounter

  attr_accessor :upDirection, :downDirection, :leftDirection, :rightDirection,
                :solidArea,
                :collisionOn,
                :image,
                :onPath,
                :exist

  def initialize(worldX, worldY, width, height)

    #1. Image and Animation
    @image = nil

    #2. Health Bar
    @healthBar = nil

    #3. Speed
    @speed = nil

    #4. Direction and Facing
    #@facing = nil
    @upDirection = false
    @downDirection = false
    @leftDirection = false
    @rightDirection = false

    #5. World Coordinate
    @worldX = worldX
    @worldY = worldY

    #6. Solid Area to check collision with other objects
    @solidArea = Rectangle.new(
      x: 8, y: 16,            # Position
      width: 32, height: 32,  # Size
      opacity: 0
    )
    @collisionOn = false

    #7. Existence of monster
    @exist = true

    #8. Tool for finding the shortest path
    @pFinder = PathFinder.new()
    @showPathOn = false
    @path = []

    #This will be convenient for random move function
    @moveCounter = 0

    #This is used to find the shortest path
    #(if you want stop monster pursue you, let change @onPath = false)
    @onPath = false

  end




#-------------------------------- Very Usefull Methods -----------------------------------------
  #
  def DrawMonster(player)
    # Screen Coordinate of monster should be
    screenX = @worldX - player.worldX + player.x
    screenY = @worldY - player.worldY + player.y

    #World Coordinate of Camera
    cameraWorldX = player.worldX - player.x
    cameraWorldY = player.worldY - player.y

    # Rendering game by removing unnessary images (we keep images in camera's scope, and remove otherwise)
    if(CCHECK.intersect(cameraWorldX, cameraWorldY, CP::SCREEN_WIDTH, CP::SCREEN_HEIGHT,
                        worldX, worldY, CP::TILE_SIZE, CP::TILE_SIZE) == true)  #Notice we want the dimension of camera is exactly same as our window
      @image.x = screenX
      @image.y = screenY
      @image.add
    else
      @image.remove
    end
  end

  #
  def DrawHealthBar(player)
    # Screen Coordinate of Health Bar should be
    screenX = @worldX - player.worldX + player.x
    screenY = @worldY - player.worldY + player.y - (2/3 * CP::TILE_SIZE)

    #World Coordinate of Camera
    cameraWorldX = player.worldX - player.x
    cameraWorldY = player.worldY - player.y

    # Rendering game by removing unnessary images (we keep images in camera's scope, and remove otherwise)
    if(CCHECK.intersect(cameraWorldX, cameraWorldY, CP::SCREEN_WIDTH, CP::SCREEN_HEIGHT,
                        worldX, worldY, CP::TILE_SIZE, CP::TILE_SIZE) == true)  #Notice we want the dimension of camera is exactly same as our window
        @healthBar.heart.x = screenX - 15
        @healthBar.heart.y = screenY
        @healthBar.rec1.x =  screenX
        @healthBar.rec1.y =  screenY
        @healthBar.rec2.x =  @healthBar.rec1.x + 2
        @healthBar.rec2.y =  @healthBar.rec1.y + 2

        # If within the scope of camera, then add health bar to our screen
        @healthBar.heart.add
        @healthBar.rec1.add
        @healthBar.rec2.add
    else # remove otherwise
        @healthBar.heart.remove
        @healthBar.rec1.remove
        @healthBar.rec2.remove
    end
  end

  #
  def removeMonster()
    @image.x = -20 * CP::TILE_SIZE
    @image.y = -20 * CP::TILE_SIZE
    @wordlX = -20 * CP::TILE_SIZE
    @wordlY = -20 * CP::TILE_SIZE
    @image.remove
  end


  #
  def checkCollision(player, map, items, npcs, monsters)
    @collisionOn = false

    #1. Check if monster collides any wall
    CCHECK.checkTile(self, map)

    #2. Check if monster collides Player
    CCHECK.checkEntity_Collide_SingleTarget(self, player)

    #3. Check if monster collides any Item in the map
    for i in 0..(items.length - 1)
      CCHECK.checkEntity_Collide_SingleTarget(self, items[i])
    end

    #4. Check if monster collides any NPC in the map
    for i in 0..(npcs.length - 1)
      CCHECK.checkEntity_Collide_SingleTarget(self, npcs[i])
    end

    #5. Check if monster collides any other monsters
    CCHECK.checkMonster_Collide_OtherMonsters(self, monsters)
  end

#------------------------------ Random Move ---------------------------------------------------
  def randMove(player, map, items, npcs, monsters)

    @moveCounter = @moveCounter + 1
    # generate a random number after every 120 steps
    if(@moveCounter == 120)
      @upDirection = false
      @downDirection = false
      @leftDirection = false
      @rightDirection = false

      ranNum = rand(1..100)
      if(1 <= ranNum && ranNum <= 25)
        @upDirection = true
      elsif(25 < ranNum && ranNum <= 50)
        @downDirection = true
      elsif(50 < ranNum && ranNum <= 75)
        @leftDirection = true
      else
        @rightDirection = true
      end
    @moveCounter = 0 #reset moveCounter
    end


    # Checking collision before moving
    self.checkCollision(player, map, items, npcs, monsters)

    # If no collison is detected, then move monster
    if(@collisionOn == false)
      if(self.upDirection == true)
        @worldY -= @speed
      elsif(self.downDirection == true)
        @worldY += @speed
      elsif(self.leftDirection == true)
        @worldX -= @speed
      elsif(self.rightDirection == true)
        @worldX += @speed
      end
    end
  end


#--------------------------------------- Target Move -----------------------------------------
  def moveForwardTo(goalRow, goalCol, player, map, items, npcs, monsters)
    @upDirection = false
    @downDirection = false
    @leftDirection = false
    @rightDirection = false

    #Search path
    self.searchPath(goalRow, goalCol, player, map, items, npcs, monsters)

    #if path found
    if(@onPath == true)

      # Checking collision before moving
      self.checkCollision(player, map, items, npcs, monsters)

      # If no collision is detected, then move the monster
      if(@collisionOn == false)
        if(self.upDirection == true)
          @worldY -= @speed
          self.runAnimation
        elsif(self.downDirection == true)
          self.runAnimationLeft
          @worldY += @speed
        elsif(self.leftDirection == true)
          self.runAnimationLeft
          @worldX -= @speed
        elsif(self.rightDirection == true)
          self.runAnimation
          @worldX += @speed
        end
      end
    end
  end


#---------------------------- Let monster follow the selected shortest path -----------------------------
# This function changes @onPath = true whenever there exists a path. Also, this function navigate the
# monster so that the monster follows the found path.
  def searchPath(goalRow, goalCol, player, map, items, npcs, monsters)
    startRow = (@worldY + @solidArea.y) / CP::TILE_SIZE
    startCol = (@worldX + @solidArea.x) / CP::TILE_SIZE

    # Convert data of map into data of graph
    @pFinder.setNodes(startRow, startCol, goalRow, goalCol, map)

    if (@pFinder.search() == true)       # if found path
      @onPath = true

      # next worldX and worldY
      nextX = @pFinder.pathList[0].col * CP::TILE_SIZE
      nextY = @pFinder.pathList[0].row * CP::TILE_SIZE

      # Entity's solid area
      enLeftX   = @worldX + @solidArea.x
      enRightX  = @worldX + @solidArea.x + @solidArea.width
      enTopY    = @worldY + @solidArea.y
      enBottomY = @worldY + @solidArea.y + @solidArea.height

      # Navigate monster
      if(enTopY > nextY && enLeftX >= nextX && enRightX < nextX + CP::TILE_SIZE)
        @upDirection = true
      elsif(enTopY < nextY && enLeftX >= nextX && enRightX < nextX + CP::TILE_SIZE)
        @downDirection = true
      elsif(enTopY >= nextY && enBottomY < nextY + CP::TILE_SIZE)
        # should go left or go right ?
        if(enLeftX > nextX)
          @leftDirection = true
        end
        if(enLeftX < nextX)
          @rightDirection = true
        end
      elsif(enTopY > nextY && enLeftX > nextX)
        # should go up or go left ?
        @upDirection = true                     # <<<<<<------------------------------------------- carefull
        self.checkCollision(player, map, items, npcs, monsters)
        if(@collisionOn == true)
          @leftDirection = true
          @upDirection = false
        end
      elsif(enTopY > nextY && enLeftX < nextX)
        # should go up or go right ?
        @upDirection = true                     # <<<<<<------------------------------------------- carefull
        self.checkCollision(player, map, items, npcs, monsters)
        if(@collisionOn == true)
          @rightDirection = true
          @upDirection = false
        end
      elsif(enTopY < nextY && enLeftX > nextX)
        # should go down or go left ?
        @downDirection = true                   # <<<<<<------------------------------------------- carefull
        self.checkCollision(player, map, items, npcs, monsters)
        if(@collisionOn == true)
          @leftDirection = true
          @downDirection = false
        end
      elsif(enTopY < nextY && enLeftX < nextX)
        # should go down or go right ?
        @downDirection = true                   # <<<<<<------------------------------------------- carefull
        self.checkCollision(player, map, items, npcs, monsters)
        if(@collisionOn == true)
          @rightDirection = true
          @downDirection = false
        end
      end

      # #Stop when catching the goal
      # nextRow = @pFinder.pathList[0].row
      # nextCol = @pFinder.pathList[0].col
      # if(nextRow == goalRow && nextCol == goalCol)
      #   @onPath = false
      # end
    end
  end


  def showPath(player)
    if (@showPathOn == true)
        for i in 0..(@pFinder.pathList.length - 1)

            # World Coordinate of path[i]
            worldX = @pFinder.pathList[i].col * CP::TILE_SIZE
            worldY = @pFinder.pathList[i].row * CP::TILE_SIZE

            # Screen Coordinate of path[i] should be
            screenX = worldX - player.worldX + player.x
            screenY = worldY - player.worldY + player.y

            #World Coordinate of Camera
            cameraWorldX = player.worldX - player.x
            cameraWorldY = player.worldY - player.y

            # Rendering game by removing unnessary images (we keep images in camera's scope, and remove otherwise)
            if(CCHECK.intersect(cameraWorldX, cameraWorldY, CP::SCREEN_WIDTH, CP::SCREEN_HEIGHT,
                                worldX, worldY, CP::TILE_SIZE, CP::TILE_SIZE) == true)  #Notice we want the dimension of camera is exactly same as our window
                if(@path != nil)
                  @path.push(Rectangle.new(x: screenX,
                                         y: screenY,
                                         width: CP::TILE_SIZE,
                                         height: CP::TILE_SIZE,
                                         color: 'red',
                                         z: -1,
                                         opacity: 0.5
                                         )
                            )
                end
            end
        end
    end

  end


  def resetPath

    for i in 0..(@path.length - 1)
      path[i].remove
    end
    @path.clear

  end


end
