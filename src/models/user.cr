class SirBansABot < Tourmaline::Bot
  module Models
    class User < Granite::Base
      connection sqlite
      table users

      column id : Int64, primary: true
      column is_bot : Bool
      column first_name : String?
      column last_name : String?
      column username : String?
      column language_code : String?

      has_many :chats, class_name: Chat, through: :chat_members

      def admin?(chat_id)
        !!Models::ChatMember.find_by(chat_id: chat_id, user_id: id).try &.admin?
      end
    end
  end
end
