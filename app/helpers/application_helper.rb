module ApplicationHelper
  include ImageOptimizationHelper

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

  def event_image_url(event, size = :medium)
    event.display_image_url(size)
  end

  def pagination_info(collection)
    return "No results found" unless collection.present?

    if collection.respond_to?(:total_count)
      "Showing #{collection.offset_value + 1} to #{collection.offset_value + collection.length} of #{collection.total_count} results"
    else
      "Showing #{collection.length} results"
    end
  end
end
