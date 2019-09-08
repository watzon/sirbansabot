class SirBansABot < Tourmaline::Bot
  module Models
    class BannedUser < Granite::Base
      connection sqlite
      table banned_users

      column id : Int64, primary: true
      column gban : Bool
      column reason : String
      timestamps

      belongs_to :chat
      belongs_to :user
    end
  end
end
