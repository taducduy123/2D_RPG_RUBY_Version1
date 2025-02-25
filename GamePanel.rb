
require 'ruby2d'
require_relative 'Character_Class/Player'
require_relative 'KeyHandler'
require_relative 'GameMap'
require_relative 'CommonParameter'
require_relative 'Character_Class/Monster'
require_relative 'Character_Class/Bat'
require_relative 'Character_Class/Skeleton'
require_relative 'FindingPath/Node'
require_relative 'FindingPath/PathFinder'
require_relative 'Character_Class/Warrior'
require_relative 'Item_Class/Chest'
require_relative 'Item_Class/Loot_item'

include CCHECK



#1. Create objects in the game
#------------------------- 1.1. Map Section --------------------------------
map = GameMap.new()

#------------------------- 1.2. Player Section --------------------------------
player = Player.new(1*CP::TILE_SIZE, 1*CP::TILE_SIZE, CP::TILE_SIZE, CP::TILE_SIZE)

#------------------------- 1.3. Monsters Section --------------------------------
monsters = [
            Bat.new(16*CP::TILE_SIZE, 0*CP::TILE_SIZE, CP::TILE_SIZE, CP::TILE_SIZE, player),
            Bat.new(16*CP::TILE_SIZE, 1*CP::TILE_SIZE, CP::TILE_SIZE, CP::TILE_SIZE, player),
            Skeleton.new(26*CP::TILE_SIZE, 5*CP::TILE_SIZE, CP::TILE_SIZE, CP::TILE_SIZE, player)
            # Bat.new(1500, 1500, CP::TILE_SIZE, CP::TILE_SIZE, player)
           ]

#------------------------- 1.4. NPCs Section --------------------------------
npcs = [
          Warrior.new(CP::TILE_SIZE * 3, CP::TILE_SIZE * 3, CP::TILE_SIZE, CP::TILE_SIZE)

       ]

#------------------------- 1.5. Items Section --------------------------------
insideChest = Rotted.new
items = [
          Chest.new(CP::TILE_SIZE * 6, CP::TILE_SIZE * 4, insideChest)

        ]


#------------------------- 1.6. Text Section --------------------------------
text = Text.new(
  '',
  x: 0, y: 0,
  #font: 'vera.ttf',
  style: 'bold',
  size: 20,
  color: 'white',
  #rotate: 90,
  #z: 10
)

text1 = Text.new(
  '',
  x: 450, y: 0,
  #font: 'vera.ttf',
  style: 'bold',
  size: 20,
  color: 'white',
  #rotate: 90,
  #z: 10
)


#2. Include necessary tools
#------------------------------------ 2.1. Get user's input -------------------------
get_key_input(player, items, npcs)
#------------------------------------ 2.2. Audio/Sound ------------------------------
music = Music.new('Sound/Dungeon.wav')
music.loop = true
music.play



#3. Core of 2D game
#------------------------------------------------------- Game Loop ------------------------------------------
update do
    #1. Update Player
    player.updatePlayer(monsters, map, npcs, items)

    #2. Update Monsters
    for i in 0..(monsters.length - 1)
      monsters[i].updateMonster(player, map, items, npcs, monsters)
    end

    #3. Update Texts
    text.text = "Coordinate: #{player.worldX}   #{player.worldY} "
    text1.text = "Coordinate Skeleton: #{monsters[2].worldX}    #{monsters[2].worldY}"

    #4. Update NPCs
    for i in 0..(npcs.length - 1)
      npcs[i].updateNPC(player, map, i)
    end

    #5. Update Items in map
    for i in 0..(items.length - 1)
      items[i].updateChest(player, i)
    end

    #6. Update Map
    map.updateMap(player)

end



#------------------------------------------------------- Set up window ---------------------------------------
#Setting Window
set width: CP::SCREEN_WIDTH 
set height: CP::SCREEN_HEIGHT 
set title: "Simulating Hero's Adventure (RPG GAME) with Ruby "
set resizable: true
set background: 'black'
#set fullscreen: true


#------------------------------------------------------- Show window ---------------------------------------
show
