require "tesseract-ocr"
require "halite"

class SirBansABot < Tourmaline::Bot
  BANNED_PHRASES = [
    "binance us",
    "bam trading service"
  ]

  @[Tourmaline::On(:photo)]
  @[Tourmaline::On(:edited_message)]
  def check_photo_contents(update)
    spawn do
      if (message = update.message || update.edited_message) && (photo = message.photo)
        largest = photo.last
        file = get_file(largest.file_id)
        file_url = get_file_link(file)

        if file_url
          File.tempfile do |file|
            response = Halite.get(file_url)
            file.write(response.body.to_slice)
            data = Tesseract::Ocr.read(file.path, { :psm => "12", :oem => 2 })
            data = data.downcase

            BANNED_PHRASES.each do |phrase|
              if data.includes?(phrase)
                send_message(message.chat.id, "Possible spam image detected from #{message.from.try &.inline_mention}, deleting and muting user.", parse_mode: :markdown)
                delete_message(message.chat.id, message.message_id)
                mute_user(0, message.chat, message.from.not_nil!)
                break
              end
            end
          end
        end
      end
    end
  end
end
