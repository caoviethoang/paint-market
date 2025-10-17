# frozen_string_literal: true

class VotesController < StoreController
  before_action :set_product

  def create
    @vote = @product.votes.build(vote_params)

    if @vote.save
      redirect_to product_path(@product), notice: I18n.t('spree.votes.thanks_for_review')
    else
      redirect_to product_path(@product), alert: @vote.errors.full_messages.join(', ')
    end
  end

  private

  def set_product
    @product = Spree::Product.friendly.find(params[:product_id])
  end

  def vote_params
    params.require(:vote).permit(:user_name, :user_email, :star, :comment)
  end
end
