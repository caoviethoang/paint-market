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
    if event.background_image.attached?
      case size
      when :large
        "/rails/active_storage/blobs/redirect/#{event.background_image.signed_id}/#{event.background_image.filename}"
      when :medium
        "/rails/active_storage/blobs/redirect/#{event.background_image.signed_id}/#{event.background_image.filename}"
      else
        "/rails/active_storage/blobs/redirect/#{event.background_image.signed_id}/#{event.background_image.filename}"
      end
    elsif event.has_images?
      event.display_image_urls(size).first
    else
      event.youtube_thumbnail_url
    end
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
