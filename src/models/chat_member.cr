class SirBansABot < Tourmaline::Bot
  module Models
    class ChatMember < Granite::Base
      connection sqlite
      table chat_members

      column id : Int64, primary: true
      column is_admin : Bool

      belongs_to :chat
      belongs_to :user

      def admin?
        !!is_admin
      end

      def ban(reason, gban = false)
        unless Models::BannedUser.exists?(user_id: user.id, chat_id: chat.id)
          Models::BannedUser.create(user_id: user.id, chat_id: chat.id, gban: gban, reason: reason.to_s)
        end
      end
    end
  end
end
