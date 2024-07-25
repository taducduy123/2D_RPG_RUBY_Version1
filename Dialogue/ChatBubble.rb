require 'ruby2d'

class ChatBubble
  attr_accessor :image, :text
  attr_reader :isSolid,  :visible

  def initialize(x, y, width, height, message = "")
    @image = Image.new(
      'Image/ChatBox.png',
      x: x,
      y: y,
      width: width,
      height: height
    )

    @isSolid = false

    @text = Text.new(
      message,
      x: x + Window.height / 3, y: y + 10,
      style: 'bold',
      size: 15,
      color: 'black'
    )
  end

  def set_text(message)
    @text.text = message
  end

  def show
    @image.add
    @text.add
    @visible = true
    print @text.width
  end

  def hide
    @image.remove
    @text.remove
    @visible = false
  end
end
