class SirBansABot < Tourmaline::Bot
  @[Tourmaline::Command(["ban", "kick"])]
  def ban_command(message, params)
    if (from = message.from) && admin?(message.chat.id, from.id)
      # All bans need a reason. A ban without a reason won't work.
      if params.empty?
        return send_message(message.chat.id, "Please give a reason for banning")
      end

      # Check if this ban is in response to a message.
      if reply_message = message.reply_to_message
        if reply_from = reply_message.from
          reason = params.join(" ")
          return ban_user(reason, message.chat, reply_from)
        end
      end

      # Admins can also ban by user id. In this case the user id comes
      # first, and the reason second.
      if user_id = params[0]?
        return send_message(message.chat.id, "Please give a reason for banning") unless params.size > 1
        begin
          user = get_chat_member(message.chat.id, user_id).user
          reason = params[1..-1].join(" ")
          return ban_user(reason, message.chat, user)
        rescue ex
        end
      end

      send_message(message.chat.id, "Something went wrong while attempting to kick")
    end
  end

  @[Tourmaline::Command(["unban", "unkick"])]
  def unban_command(message, params)
    if (from = message.from) && admin?(message.chat.id, from.id)
      if reply_message = message.reply_to_message
        if reply_from = reply_message.from
          return unban_user(message.chat, reply_from)
        end
      end

      if user_id = params[0]?
        begin
          user = get_chat_member(message.chat.id, user_id).user
          return unban_user(message.chat, user)
        rescue ex
        end
      end

      send_message(message.chat.id, "Something went wrong while attempting to unban")
    end
  end

  def ban_user(reason, chat, user)
    Models::ChatMember.find_by(chat_id: chat.id, user_id: user.id).try &.ban(reason)
    kick_chat_member(chat.id, user.id)
    send_message(chat.id, "#{user.inline_mention} was kicked", :markdown)
  end

  def unban_user(chat, user)
    Models::BannedUser.find_by(chat_id: chat.id, user_id: user.id).try &.destroy
    unban_chat_member(chat.id, user.id)
    send_message(chat.id, "#{user.inline_mention} was unbanned", :markdown)
  end
end
