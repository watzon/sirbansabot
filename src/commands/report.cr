class SirBansABot < Tourmaline::Bot
  @[Tourmaline::Command("report")]
  def report_command(message, params)
    reason = params.join(" ") unless params.empty?

    if !message.reply_to_message
      send_message(message.chat.id, "Please reply to the message you want to report")
      return
    end

    admin_links = chat_admins(message.chat).map { |ad| ad.user.inline_mention }

    delete_message(message.chat.id, message.message_id)
    send_message(
      message.chat.id,
      "This message has been reported to:\n#{admin_links.join("\n")}",
      parse_mode: :markdown,
      reply_to_message_id: message.reply_to_message.try &.message_id
    )
  end
end
