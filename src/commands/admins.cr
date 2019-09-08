class SirBansABot < Tourmaline::Bot
  @[Tourmaline::Command("admins")]
  def admins(message, params)
    chat = message.chat
    admin_links = chat_admins(chat).map { |ad| ad.user.inline_mention }
    send_message(
      message.chat.id,
      admin_links.join("\n"),
      parse_mode: :markdown,
      disable_notification: true,
      reply_to_message_id: message.message_id
    )
  end
end
