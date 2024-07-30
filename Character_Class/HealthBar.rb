require 'ruby2d'

class HealthBar

  attr_reader :hp
  attr_writer :hp
  attr_accessor :heart, :rec1, :rec2, :leng

  def initialize(hp, maxHp, x, y, leng)
    @hp = hp
    @maxHp = maxHp
    #the heart icon
    @heart = Image.new(
      './Image/Heart.png',
      x: x, y: y,
      width: 15, height: 10,
      z: 2
    )
    @leng = leng
    #the maxHp bar
    @rec1 = Rectangle.new(
      x: x, y: y,
      width: leng + 4, height: 12, #plus 4 to make the right and left border for the health bar (each is 2 pixel)
      color: 'black',
      z: 0
    )
    # the hp bar
    @rec2 = Rectangle.new(
      x: x + 2, y: y + 2,
      width: (@hp*1.00/@maxHp)*leng , height: 8,
      color: 'red',
      z: 1
    )
  end

  def move(xspeed,yspeed)
    @rec1.x += xspeed
    @rec1.y += yspeed

    @rec2.x += xspeed
    @rec2.y += yspeed

    @heart.x += xspeed
    @heart.y += yspeed
  end

  #update method and setting range for hp
  def update
    if @hp <= 0
      @hp = 0
    elsif @hp >= @maxHp
      @hp = @maxHp
    end
    @rec2.width = (@hp*1.00/@maxHp)*leng
  end
end
