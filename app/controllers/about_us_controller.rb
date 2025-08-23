class AboutUsController < StoreController
  def index
    @event = Event.active.first
  end
end
