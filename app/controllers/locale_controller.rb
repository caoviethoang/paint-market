# frozen_string_literal: true

class LocaleController < StoreController
  def set
    requested_locale = params[:switch_to_locale] || params[:locale]
    
    # Log the request for debugging
    Rails.logger.info "Locale change requested: #{requested_locale}, params: #{params.inspect}"
    
    if locale_is_available?(requested_locale)
      I18n.locale = requested_locale
      session[set_user_language_locale_key] = requested_locale
      session[:locale] = requested_locale # Add fallback session key
      
      Rails.logger.info "Locale changed successfully to: #{requested_locale}"
      flash[:notice] = t('spree.locale_changed', default: 'Language changed successfully')
    else
      Rails.logger.warn "Invalid locale requested: #{requested_locale}"
      flash[:error] = t('spree.locale_not_changed', default: 'Language could not be changed')
    end

    # Use referer if available, otherwise redirect to root
    redirect_back(fallback_location: root_path)
  end

  private

  def locale_is_available?(locale)
    return false unless locale.present?
    
    # Check both Spree and Rails available locales
    spree_available = Spree.i18n_available_locales.include?(locale.to_sym)
    rails_available = I18n.available_locales.include?(locale.to_sym)
    
    spree_available || rails_available
  end
end
