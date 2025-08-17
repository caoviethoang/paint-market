class EventsController < StoreController
  before_action :load_event, only: [:show, :detail]
  before_action :load_products, only: [:show]

  def index
    @current_event = Event.active.first
    
    @upcoming_events = Event.last(5)
    
    @featured_events = []
    @featured_events << @current_event if @current_event
    # Chỉ thêm upcoming events nếu khác với current_event
    @upcoming_events.each do |event|
      @featured_events << event unless @featured_events.include?(event)
    end
    @all_products = Spree::Product.limit(8)
  end

  def show
  end

  def detail
    @products = @event.products.page(params[:page]).per(12)
  end

  private

  def load_products
    @products = @event.products
  end

  def load_event
    @event = Event.find(params[:id])
  end
end
