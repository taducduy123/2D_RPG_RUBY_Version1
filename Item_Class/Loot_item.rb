require 'ruby2d'
class Meat
  attr_accessor  :image_path, :visible
  def initialize()
    @image_path = 'Image/Meat.png'
  end

  def effect
    healthRegain = -20
  end


end
class Health_talisman
  attr_accessor :image_path, :visible
  def initialize()
    @image_path = 'Image/crimson_talisman.png'
  end
end

class Rotted
  attr_accessor :image_path, :visible
  def initialize()
    @image_path = 'Image/crimson_talisman.png'
  end
end
