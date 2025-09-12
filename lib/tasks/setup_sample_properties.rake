# frozen_string_literal: true

namespace :properties do
  desc "Setup sample properties and property values for testing"
  task setup_sample: :environment do
    puts "Setting up sample properties and property values..."
    
    # Create properties
    properties_data = [
      {
        name: 'orientation',
        presentation: 'Orientation',
        values: [
          { value: 'vertical', display_name: 'Dọc', position: 0 },
          { value: 'horizontal', display_name: 'Ngang', position: 1 },
          { value: 'square', display_name: 'Vuông', position: 2 }
        ]
      },
      {
        name: 'material',
        presentation: 'Material',
        values: [
          { value: 'oil', display_name: 'Sơn dầu', position: 0 },
          { value: 'acrylic', display_name: 'Acrylic', position: 1 },
          { value: 'watercolor', display_name: 'Màu nước', position: 2 },
          { value: 'canvas', display_name: 'Canvas', position: 3 },
          { value: 'paper', display_name: 'Giấy', position: 4 },
          { value: 'wood', display_name: 'Gỗ', position: 5 }
        ]
      },
      {
        name: 'style',
        presentation: 'Style',
        values: [
          { value: 'abstract', display_name: 'Trừu tượng', position: 0 },
          { value: 'realism', display_name: 'Hiện thực', position: 1 },
          { value: 'impressionism', display_name: 'Ấn tượng', position: 2 },
          { value: 'expressionism', display_name: 'Biểu hiện', position: 3 },
          { value: 'contemporary', display_name: 'Đương đại', position: 4 },
          { value: 'classical', display_name: 'Cổ điển', position: 5 }
        ]
      },
      {
        name: 'size',
        presentation: 'Size',
        values: [
          { value: 'small', display_name: 'Nhỏ', position: 0 },
          { value: 'medium', display_name: 'Trung bình', position: 1 },
          { value: 'large', display_name: 'Lớn', position: 2 },
          { value: 'extra_large', display_name: 'Rất lớn', position: 3 }
        ]
      }
    ]
    
    properties_data.each do |property_data|
      puts "Creating property: #{property_data[:name]}"
      
      property = Spree::Property.create!(
        name: property_data[:name],
        presentation: property_data[:presentation]
      )
      
      property_data[:values].each do |value_data|
        puts "  Creating value: #{value_data[:display_name]}"
        PropertyValue.create!(
          property: property,
          value: value_data[:value],
          display_name: value_data[:display_name],
          position: value_data[:position]
        )
      end
    end
    
    puts "Sample properties and values created successfully!"
    puts "Total properties: #{Spree::Property.count}"
    puts "Total property values: #{PropertyValue.count}"
  end
end
