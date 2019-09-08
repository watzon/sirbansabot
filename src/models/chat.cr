class SirBansABot < Tourmaline::Bot
  module Models
    class Chat < Granite::Base
      connection sqlite
      table chats

      column id : Int64, primary: true
      column description : String?
      column title : String?
      column first_name : String?
      column last_name : String?
      column username : String?
      column invite_link : String?

      has_many :users, class_name: User, through: :chat_members

      def admins

      end
    end
  end
end
