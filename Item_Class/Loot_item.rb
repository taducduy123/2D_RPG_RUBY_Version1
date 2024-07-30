require 'ruby2d'

#NOTES: ALL ITEMS are CONSUMABLES

class Meat
  attr_accessor  :image_path, :visible
  def initialize()
    @image_path = 'Image/Meat.png'
  end

  def effect
    healthRegain = 20
    return healthRegain
  end


end

class Rotted
  attr_accessor :image_path, :visible
  def initialize()
    @image_path = 'Image/Meat.png'
  end

  def effect
    healthRegain = -60
    return healthRegain
  end
end
