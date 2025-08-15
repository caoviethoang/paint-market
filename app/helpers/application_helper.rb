module ApplicationHelper
  def youtube_embed_url(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end

    if youtube_id
      "https://www.youtube.com/embed/#{youtube_id}"
    else
      nil
    end
  end
end
