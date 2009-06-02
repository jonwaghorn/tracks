class Media < ActiveRecord::Base
  belongs_to :user

  KIND_YOUTUBE = 'youtube'

  def gimme
    if kind == KIND_YOUTUBE
      youtube_player
    else
      "kind: #{kind}<br/>" +
      "title: #{title}<br/>" +
      "note: #{note}<br/>" +
      "ref: #{reference}<br/>" +
      "user: #{user.screen_name}<br/>" +
      "date: #{created_at.to_s(:tracks).gsub(/^0/, '')}"
    end
  end
  
  def youtube_player
    width = "320"
    height = "260"
    '<object width="' + width + '" height="' + height + '"><param name="movie" value="http://www.youtube.com/v/' + reference + '&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/' + reference + '&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="' + width + '" height="' + height + '"></embed></object>'
  end
  
  def self.media_types
    [KIND_YOUTUBE]
  end
end
