document.addEventListener('DOMContentLoaded', function() {
  // Override Spree translations nếu chưa có
  window.Spree = window.Spree || {};
  window.Spree.translations = window.Spree.translations || {};

  // Set default translations
  Object.assign(window.Spree.translations, {
    variant_placeholder: "Select Variant",
    taxon_placeholder: "Select Taxon",
    option_type_placeholder: "Select Option Type",
    find_a_taxon: "Find a taxon"
  });

  // Re-initialize autocomplete nếu đã load
  if (typeof jQuery !== 'undefined' && jQuery.fn.select2) {
    jQuery('select[data-autocomplete]').each(function() {
      var $select = jQuery(this);
      if (!$select.data('select2')) {
        $select.select2({
          placeholder: $select.data('placeholder') || 'Select...',
          allowClear: true
        });
      }
    });
  }
});
