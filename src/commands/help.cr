require "./meta"

class SirBansABot < Tourmaline::Bot
  COMMAND_HELP = {
    "help" => "Show this message.",
    "report" => "Report a message to the group admins.",
    "me" => "Get personal group info.",
    "groups" => "List the groups this bot manages.",
    "++" => "Updoot a message.",
    "--" => "Downvote a message.",
  }

  COMMAND_NOT_FOUND_MESSAGE = <<-TEXT
  404 command not found. For a list of available commands please use `/help`.
  TEXT

  HELP_MESSAGE = <<-TEXT
  My name is SirBansABot, I am a group management bot with a friendly web interface. If you own this \
  bot you can find the web interface at the configured URL.

  Commands:
  #{COMMAND_HELP.map { |cmd, msg| "`#{cmd.ljust(10)}` - #{msg}" }.join('\n')}

  Meta Commands:
  #{META_COMMANDS.keys.map { |cmd| "`!#{cmd}`" }.join(", ")}
  TEXT

  @[Tourmaline::Command("help")]
  def help_command(message, params)
    command = params[0]?

    if command
      if help = COMMAND_HELP[command]?
        help = "**#{command}**\n#{help}"
        send_message(message.chat.id, help, parse_mode: :markdown)
      else
        send_message(message.chat.id, COMMAND_NOT_FOUND_MESSAGE, parse_mode: :markdown)
      end
    else
      send_message(message.chat.id, HELP_MESSAGE, parse_mode: :markdown)
    end
  end
end
