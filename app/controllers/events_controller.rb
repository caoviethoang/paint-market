class EventsController < StoreController
  def index
    @events = Event.order(:created_at)
    @first_event = @events.last
  end

  def show
    @event = Event.find(params[:id])
  end

  def preview
    @event = Event.find(params[:id])
    # Render the partial without a layout
    render partial: 'events/preview', locals: { event: @event }, layout: false
  end
end