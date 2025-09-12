# frozen_string_literal: true

class FilterComponent < ViewComponent::Base
  BASE_CLASS = 'filter'.freeze
  CSS_CLASS = "#{BASE_CLASS}__list mt-6".freeze

  attr_reader :filter, :search_params

  def initialize(filter:, search_params:)
    @filter = filter
    @search_params = search_params || {}
  end

  def call
    if range_filter?
      range_filter_collapse
    else
      checkbox_filter_collapse
    end
  end

  private

  def filter_list_title
    content_tag(:h6, title, class: "#{BASE_CLASS}__title font-sans-md") if title
  end

  def filter_list
    return @filter_list if @filter_list
    return if labels.empty?

    @filter_list = content_tag :div, class: "space-y-2" do
      safe_join(labels.map { |name, value| filter_list_item(name: name, value: value) })
    end
  end

  def filter_list_item(name:, value:)
    id = filter_list_item_id(name)

    content_tag(:div, class: "flex items-center") do
      safe_join([
        check_box_tag(
          "search[#{filter[:scope].to_s}][]",
          value,
          filter_list_item_checked?(value),
          id: id,
          class: "h-4 w-4 text-blue-600 border-gray-300 rounded"
        ),
        label_tag(id, name, class: "ml-2 text-sm text-gray-700 cursor-pointer")
      ])
    end
  end

  def filter_list_item_id(name)
    sanitize_to_id("#{filter[:name]}_#{name}")
  end

  def filter_list_item_checked?(value)
    search_params[filter[:scope]]&.include?(value.to_s)
  end

  def title
    filter[:name]
  end

  def labels
    @labels ||= filter[:labels] || filter[:conds].map { |m,c| [m,m] }
  end

  def range_filter?
    [:height_range, :width_range].include?(filter[:scope])
  end

  def checkbox_filter_collapse
    return unless filter_list

    content_tag(:div,
      class: "border-b border-gray-200 py-4",
      data: { controller: "collapse" }
    ) do
      safe_join([
        collapse_header,
        collapse_content
      ])
    end
  end

  def range_filter_collapse
    content_tag(:div,
      class: "border-b border-gray-200 py-4",
      data: { controller: "collapse" }
    ) do
      safe_join([
        collapse_header,
        range_collapse_content
      ])
    end
  end

  def collapse_header
    content_tag(:button,
      type: "button",
      class: "w-full flex items-center justify-between text-left font-medium text-gray-900 hover:text-gray-700",
      data: {
        action: "click->collapse#toggle"
      }
    ) do
      safe_join([
        content_tag(:span, title, class: "text-sm font-medium"),
        content_tag(:svg,
          "",
          class: "h-5 w-5 transform transition-transform duration-200",
          data: { collapse_target: "icon" },
          fill: "none",
          viewBox: "0 0 24 24",
          stroke: "currentColor"
        ) do
          content_tag(:path,
            "",
            stroke_linecap: "round",
            stroke_linejoin: "round",
            stroke_width: "2",
            d: "M12 6v6m0 0v6m0-6h6m-6 0H6"
          )
        end
      ])
    end
  end

  def collapse_content
    content_tag(:div,
      class: "mt-4 space-y-3 w-full collapse-content hidden",
      data: { collapse_target: "content" }
    ) do
      filter_list
    end
  end

  def range_collapse_content
    content_tag(:div,
      class: "mt-4 space-y-3 w-full collapse-content hidden",
      data: { collapse_target: "content" }
    ) do
      range_filter_inputs
    end
  end


  def range_filter_inputs
    content_tag(:div, class: "flex gap-3") do
      safe_join([
        min_input,
        max_input
      ])
    end
  end

  def min_input
    content_tag(:div, class: "flex-1") do
      safe_join([
        content_tag(:label, I18n.t('spree.filters.min'), class: "block text-xs font-medium text-gray-600 mb-1"),
        number_field_tag(
          "search[#{filter[:scope]}_min]",
          current_min_value,
          placeholder: I18n.t('spree.filters.min'),
          class: "w-full px-3 py-2 text-sm border border-gray-300 rounded-md",
          min: min_range,
          max: max_range
        )
      ])
    end
  end

  def max_input
    content_tag(:div, class: "flex-1") do
      safe_join([
        content_tag(:label, I18n.t('spree.filters.max'), class: "block text-xs font-medium text-gray-600 mb-1"),
        number_field_tag(
          "search[#{filter[:scope]}_max]",
          current_max_value,
          placeholder: I18n.t('spree.filters.max'),
          class: "w-full px-3 py-2 text-sm border border-gray-300 rounded-md",
          min: min_range,
          max: max_range
        )
      ])
    end
  end

  def current_min_value
    search_params["#{filter[:scope]}_min"] || min_range
  end

  def current_max_value
    search_params["#{filter[:scope]}_max"] || max_range
  end

  def min_range
    case filter[:scope]
    when :height_range
      0
    when :width_range
      0
    when :price_range
      0
    else
      0
    end
  end

  def max_range
    case filter[:scope]
    when :height_range
      200
    when :width_range
      200
    when :price_range
      10000000
    else
      100
    end
  end
end
