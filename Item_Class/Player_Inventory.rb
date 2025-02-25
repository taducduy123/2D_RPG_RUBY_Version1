require 'ruby2d'
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative '../WorldHandler'
require_relative '../ImageHandler'
InventorySize = 9 / 3 # for 3x3 inventory
TILE_SIZE = 100
# Create a class for the inventory
class Inventory
  attr_accessor :cursor_x, :cursor_y, :visible, :IsFull, :my_inventory

  def initialize
    @visible = false
    @IsFull = false
    @held_items_col = 0
    @held_items_row = 0
    @my_inventory = Array.new(InventorySize) { Array.new(InventorySize, nil) }
    @cursor
    @cursor_x = 0
    @cursor_y = 0
    @created_objects = []
    @created_Items_Images = Array.new(InventorySize) { Array.new(InventorySize) }
  end


  def draw_grid
    @my_inventory.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        rect = Rectangle.new(
          x: x * TILE_SIZE + Window.width / 3, y: y * TILE_SIZE + Window.height / 4,
          width: TILE_SIZE - 2, height: TILE_SIZE - 2,
          color: 'black',
          z: 3
        )
        @created_objects << rect

        if @my_inventory[y][x]
          img = Image.new(
            @my_inventory[y][x].image_path,
            x: x * TILE_SIZE + Window.width / 3, y: y * TILE_SIZE + Window.height / 4,
            width: TILE_SIZE - 2, height: TILE_SIZE - 2,
            z: 4
          )
          @created_Items_Images[y][x] = img
        end
      end
    end
  end
  def draw_cursor
    if @cursor
      @cursor.add
    else
      @cursor = Image.new(
        'Image/cursor.png',
        x: @cursor_x * TILE_SIZE + Window.width / 3, y: @cursor_y * TILE_SIZE + Window.height / 4,
        width: TILE_SIZE - 2, height: TILE_SIZE - 2,
        z: 5)
    end
  end

  def move_cursor(dx, dy)
    @cursor_x = (@cursor_x + dx) % InventorySize
    @cursor_y = (@cursor_y + dy) % InventorySize
    @cursor.x = @cursor_x * TILE_SIZE + Window.width / 3
    @cursor.y = @cursor_y * TILE_SIZE + Window.height / 4
  end

  def add_to_inventory(loot) # Methods to add items properly
    if @held_items_row < @my_inventory.size
      @my_inventory[@held_items_row][@held_items_col] = loot[0] # WORKS only with 1 item per chest
      @held_items_col += 1
      if @held_items_col != 0 && @held_items_col % InventorySize == 0 # to convert 1d array to 2d array
        @held_items_col = 0                                           #
        @held_items_row += 1
      end
    end

  end

  def display
    draw_grid
    draw_cursor
  end

  def hide
    @created_objects.each(&:remove)
    @created_objects.clear
    @created_Items_Images.each do |row|
      row.each do |image|
        image.remove if image
      end
    end
    @created_Items_Images.each(&:clear)
    @cursor.remove
  end

  def removeItem(row, col)
    @my_inventory[row][col] = nil
    @created_Items_Images[row][col].remove
    @created_Items_Images[row].delete_at(col)
    @my_inventory
  end
end
