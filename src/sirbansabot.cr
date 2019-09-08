require "tourmaline"
require "./commands/**"
require "./middleware/*"
require "./database"

class SirBansABot < Tourmaline::Bot
  include Tourmaline

  def initialize(api_key)
    super(api_key)
    @admin_ids = {} of Int64 => Set(Int64)
  end

  @[On(:message)]
  def update_chats(update)
    message = update.message.not_nil!
    chat = message.chat

    update_chat(chat)

    if from_user = message.from
      update_user(chat, from_user)
    end

    if reply_to = message.reply_to_message.try &.from
      update_user(chat, reply_to)
    end
  end

  def update_chat(chat)
    if Models::Chat.exists?(id: chat.id)
      chat_model = Models::Chat.find(chat.id)
    else
      chat_model = Models::Chat.from_json(chat.to_json).save!
      @@logger.debug("#{bot_name} added to chat #{chat.id}")
    end
  end

  def update_user(chat, user)
    if user_mod = Models::User.find(user.id)
      user_mod.update(
        first_name: user.first_name,
        last_name: user.last_name,
        username: user.username,
        language_code: user.language_code
      )
    else
      Models::User.from_json(user.to_json).save
      @@logger.debug("#{user.id} added to database")
    end

    unless Models::ChatMember.exists?(chat_id: chat.id, user_id: user.id)
      Models::ChatMember.create!(chat_id: chat.id, user_id: user.id, is_admin: false)
      @@logger.debug("#{user.id} added to chat #{chat.id}")
    end
  end

  def chat_admins(chat)
    chat_admins = get_chat_administrators(chat.id)

    chat_admins.each do |admin|
      if chat_member = Models::ChatMember.find_by(chat_id: chat.id, user_id: admin.user.id)
        unless chat_member.admin?
          chat_member.is_admin = true
          chat_member.save
          @@logger.debug("#{admin.user.id} added as admin to #{chat.id}")
        end
      else
        Models::ChatMember.create(chat_id: chat.id, user_id: admin.user.id, is_admin: true)
        @@logger.debug("#{admin.user.id} added as admin to #{chat.id}")
      end
    end

    chat_admins
  end

  def admin?(chat_id, user_id)
    !!Models::ChatMember.find_by(chat_id: chat_id, user_id: user_id).try &.admin?
  end

  def self.serve
    bot = SirBansABot.new(ENV["SBAB_API_KEY"])

    if webhook_url = ENV["SBAB_WEBHOOK_URL"]?
      host = ENV["SBAB_HOST"]? || "0.0.0.0"
      port = ENV["SBAB_PORT"]?.try &.to_i || 3400

      bot.set_webhook(webhook_url)
      bot.serve(host, port)
    else
      bot.poll
    end
  end
end

SirBansABot.serve
