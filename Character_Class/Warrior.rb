require 'ruby2d'
require_relative '../CollisionChecker'
require_relative '../CommonParameter'
require_relative '../ImageHandler'
require_relative '../Dialogue/ChatBubble'
require_relative 'NPC'
require_relative '../sharedData'
include CCHECK

class Warrior < NPC
  def initialize(worldX, worldY, width, height)
    super(worldX, worldY, width, height)
    @image = Sprite.new(
      'Image/First_Npc.png',
      x: worldX,
      y: worldY,
      width: width , height: height + 20,
      clip_width: width_Of('Image/First_Npc.png') / 5,
      clip_height: height_Of('Image/First_Npc.png') ,
      animations: {idle: 1..4},
    )

    @chatList = ["Hello there, Welcome to middle earth (Press X to continue)", "My name is NPCone, I am your guider (Press X)",
    "You can start moving by pressing W, A, S, D (Press X)","...(Press X to continue)"]

    self.runAnimation

  end



  def runAnimation()
   @image.play animation: :idle , loop: true
  end

  def startDialogue
    chatprogress = 1
    newchat = ChatBubble.new(0, Window.height - Window.height / 5,
    Window.width ,Window.height / 5, @chatList[0])
    SharedData.shared_chat_array << newchat
    Window.on :key_down do |event|
      if event.key == 'x'
        if chatprogress > @chatList.size - 1
          newchat.hide
          SharedData.clear_array
        end
        newchat.set_text(@chatList[chatprogress])
        chatprogress += 1
      end
    end
  end
end
