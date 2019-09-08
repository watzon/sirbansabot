class SirBansABot < Tourmaline::Bot
  META_COMMANDS = {
    "banana" => {
      "image" => "https://media3.giphy.com/media/bh4jzePjmd9iE/giphy.gif"
    },
    "skiddie" => {
      "image" => "https://i.kym-cdn.com/photos/images/original/001/176/251/4d7.png"
    },
    "screenshot" => {
      "image" => "http://www.quickmeme.com/img/50/509be1d35120cc3a41784b23a07e9ab366dbbf2ae95bc30a911fe00f7683eec5.jpg",
      "text" => "Seriously though avoid taking screenshots of code, and especially avoid taking pictures of your screen."
    },
    "smartquestions" => {
      "text" => "You may want to check out https://bit.ly/smartquestions"
    },
    "manjaro" => {
      "text" => <<-TEXT
Manjaro - rolling back your system clock since 2015.

[Failure to manage TLS certificates and suggesting terrible workarounds](https://web.archive.org/web/20150409040851/https://manjaro.github.io/expired_SSL_certificate/)... [Then stealth editing the article](https://web.archive.org/web/20181012040231/https://manjaro.github.io/expired_SSL_certificate/)

[Multiple times.](https://web.archive.org/web/20181112113901/https://manjaro.github.io/SSL-Certificate-Expired/) All those articles were purged in 2018.

[Continuous winner of the hackiest update script of the year](https://gitlab.manjaro.org/packages/core/manjaro-system/blob/master/manjaro-update-system.sh)

[Delays package updates for 'testing' and yet still completely breaks with a regular update](https://www.reddit.com/r/linux/comments/ajclsq/manjaro_stable_requires_users_to_manually/)

[Shipping sponsored proprietary office suite by default](https://www.reddit.com/r/linux/comments/cjrkfs/manjaro_announces_partnership_will_start_shipping/)
TEXT
    },
    "kali" => {
      "image" => "https://i.imgur.com/jmxVPxK.jpg",
      "text" => <<-TEXT
Looks like you're asking about a pentesting distribution.

If you're stuck with basic setup on such a distribution, then it is very likely not for you.

Read the sticky and use a normal distribution instead.

If you insist on using a pentesting distribution keep in mind they're meant to be live booted or installed in a VM, not installed directly.
TEXT
    }
  }

  {% for command, options in META_COMMANDS %}
    @[Tourmaline::Command({{ command.id.stringify }}, prefix: '!')]
    def {{ command.id }}_command(message, params)
      {% if image = options["image"] %}
        {% caption = options["text"] %}
        {% if image.includes?(".gif") || image.includes?(".mp4") %}
          send_animation(message.chat.id, {{ image }}, {{ caption }}, parse_mode: :markdown)
        {% else %}
          send_photo(message.chat.id, {{ image }}, {{ caption }}, parse_mode: :markdown)
        {% end %}
      {% elsif text = options["text"] %}
        send_message(message.chat.id, {{ text }}, parse_mode: :markdown)
      {% end %}
    end
  {% end %}
end
