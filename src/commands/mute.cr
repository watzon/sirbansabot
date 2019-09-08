class SirBansABot < Tourmaline::Bot
  @[Tourmaline::Command(["mute", "shhh", "muzzle"])]
  def mute_command(message, params)
    if (from = message.from) && admin?(message.chat.id, from.id)
      # Mutes need a time limit
      if params.empty?
        return send_message(message.chat.id, "Please give an amount of time to mute for (in seconds)")
      end

      # Check if this ban is in response to a message.
      if reply_message = message.reply_to_message
        if reply_from = reply_message.from
          time = params[0].to_i
          return mute_user(time, message.chat, reply_from)
        end
      end

      send_message(message.chat.id, "Something went wrong while attempting to mute")
    end
  end

  @[Tourmaline::Command(["unmute"])]
  def unmute_command(message, params)
    if (from = message.from) && admin?(message.chat.id, from.id)
      # Check if this ban is in response to a message.
      if reply_message = message.reply_to_message
        if reply_from = reply_message.from
          return unmute_user(message.chat, reply_from)
        end
      end

      send_message(message.chat.id, "Something went wrong while attempting to unmute")
    end
  end

  def mute_user(time, chat, user)
    restrict_chat_member(chat.id, user.id, {
      can_send_messages: false,
      can_send_media_messages: false,
      can_send_polls: false,
      can_send_other_messages: false,
      can_add_web_page_previews: false,
      can_change_info: false,
      can_invite_users: false,
      can_pin_messages: false
    }, time)

    if time <= 30 || time >= 31190400
      span = "forever"
    else
      span = "for #{time} seconds"
    end

    send_message(chat.id, "#{user.inline_mention} was muted #{span}", :markdown)
  end

  def unmute_user(chat, user)
    restrict_chat_member(chat.id, user.id, permissions: {
      can_send_messages: true,
      can_send_media_messages: true,
      can_send_polls: true,
      can_send_other_messages: true,
      can_add_web_page_previews: true,
      can_change_info: true,
      can_invite_users: true,
      can_pin_messages: true
    })

    send_message(chat.id, "#{user.inline_mention} was unmuted", :markdown)
  end
end
