class EventsController < StoreController
  def index
    @events = Event.order(:created_at)
    @products = Spree::Product.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def detail
    @event = Event.find(params[:id])
    @products = @event.products
  end
end
