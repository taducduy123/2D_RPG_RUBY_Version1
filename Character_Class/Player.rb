require 'ruby2d'
require_relative '../ImageHandler' # to read dimemsion of image ==> must install (gem install rmagick)
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative '../Item_Class/Player_Inventory'


require_relative 'HealthBar'
include CCHECK




class Player < Sprite
  attr_reader :x, :y,
              :worldX, :worldY,
              :speed,
              :collision_with_monster_index
              :collision_with_npc_index
              :collision_with_item_index

  attr_accessor :upDirection, :downDirection, :leftDirection, :rightDirection,
                :solidArea,
                :collisionOn,
                :myInventory,
                :interacting,
                :talktoNpc


  def initialize(worldX, worldY, width, height)

    #1. Image and Animation
    @first_frame = { x: 248 , y: 0, width: 48, height: 50, time: 80, flip: :none }
    super(
      'Image/Warrior_Red.png',
      x: CP::SCREEN_WIDTH / 2 - (CP::TILE_SIZE/2),
      y: CP::SCREEN_HEIGHT / 2 - (CP::TILE_SIZE/2),
      z: 20,                                                            #Precedence of show
      width: width, height: height,
      clip_x: @first_frame[:x], clip_y: @first_frame[:y],
      clip_width: @first_frame[:width], clip_height: @first_frame[:height],
      animations: {
       walk:
       [
          @first_frame,
          {
            x: 5, y: 0,
            width: 43, height: 50,
            time: 80, flip: :none
          },
          {
            x: 45, y: 0,
            width: 45, height: 50,
            time: 80, flip: :none
          },
          {
            x: 136, y: 0,
            width: 56, height: 50,
            time: 80, flip: :none
          },
          {
            x: 192, y: 0,
            width: 56, height: 50,
            time: 80, flip: :none
          }
        ]

      }
    )

    #2. Health Bar
    @healthBar = HealthBar.new(
      200,
      200,
      CP::SCREEN_WIDTH / 2 - (CP::TILE_SIZE/2) - (width*2/3),
      CP::SCREEN_HEIGHT / 2 - (CP::TILE_SIZE/2) - 10,
      100
    )
    @healthBar.heart.x = CP::SCREEN_WIDTH / 2 - (CP::TILE_SIZE/2) - (width*2/3) - 15

    #3. Speed
    @speed = 3

    #4. Direction and Facing
    @facing = 'right'
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

    #7. State of Collision
    @collisionOn = false                            # Whenever player collides any objects (NPCs, Items, Monsters), this will turn true, otherwise false.
    @collision_with_monster_index = -1              # When collision with Monster. The collided Monster is identified by array index
    @collision_with_npc_index = -1                  # When collision with NPC. The collided NPC is identified by array index
    @collision_with_item_index = -1                 # When collision with Item. The collided Item is identified by array index

    #8. State of interaction
    @interacting
    @talktoNpc

    #9. Inventory
    @myInventory = Inventory.new()

  end


#-------------------------------- Very Usefull Methods -----------------------------------------

  def checkCollision(monsters, map, items, npcs)

    @collisionOn = false
    @collision_with_monster_index = -1
    @collision_with_npc_index = -1
    @collision_with_item_index = -1

    #1. Check if player collides any wall
    CCHECK.checkTile(self, map)

    #2. Check if player collides any Monster
    @collision_with_monster_index = CCHECK.checkEntity_Collide_AllTargets(self, monsters)

    #3. Check if monster collides any Item in the map
    @collision_with_item_index = CCHECK.checkEntity_Collide_AllTargets(self, items)

    #4. Check if player collides any NPC in the map
    @collision_with_npc_index = CCHECK.checkEntity_Collide_AllTargets(self, npcs)

  end


#-------------------------------- Update -----------------------------------------
  def updatePlayer(monsters, map, npcs, items)

    #1. Move
    self.move(monsters, map, npcs, items)

  end



#-------------------------------- Move -----------------------------------------
  def move(monsters, map, npcs, items)

    #Check Collision before moving
    checkCollision(monsters, map, items, npcs)

    #If no collision is detected, then let player move
    if(@collisionOn == false)
      if(self.upDirection == true)
        @worldY -= @speed
      end
      if(self.downDirection == true)
        @worldY += @speed
      end
      if(self.leftDirection == true)
        @worldX -= @speed
      end
      if(self.rightDirection == true)
        @worldX += @speed
      end
    end
  end

#-------------------------------- Setter Methods -----------------------------------------

  def runAnimation()
    case @facing
    when 'right'
      if @leftDirection
        @facing = 'left'
        self.play animation: :walk, loop: true, flip: :horizontal
      else
        self.play(animation: :walk)
      end
    when 'left'
      if @rightDirection
        self.play(animation: :walk)
        @facing = 'right'
      else
        self.play animation: :walk, loop: true, flip: :horizontal
      end
    end
  end

#-------------------------------- Stop Moving -----------------------------------------

  def stop()
    @first_frame
    super
  end

  def useItem()
    puts "Access my_inventory at #{myInventory.cursor_y} #{myInventory.cursor_x}"
    if myInventory.my_inventory[myInventory.cursor_y][myInventory.cursor_x]
      @healthBar.hp = @healthBar.hp + myInventory.my_inventory[myInventory.cursor_y][myInventory.cursor_x].effect
      myInventory.removeItem(myInventory.cursor_y, myInventory.cursor_x)
      @healthBar.update
    end
  end



end
