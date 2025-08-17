module ImageOptimizationHelper
  # Generate optimized image tag with proper attributes
  def optimized_image_tag(image_name, options = {})
    # Set default optimization attributes
    default_options = {
      loading: "lazy",
      decoding: "async",
      fetchpriority: "low"
    }
    
    # Merge with provided options
    final_options = default_options.merge(options)
    
    # Generate image tag
    image_tag(image_name, final_options)
  end
  
  # Generate high priority image tag for above-the-fold content
  def high_priority_image_tag(image_name, options = {})
    optimized_image_tag(image_name, options.merge(
      loading: "eager",
      fetchpriority: "high"
    ))
  end
  
  # Generate responsive image with multiple sizes
  def responsive_image_tag(image_name, options = {})
    sizes = options.delete(:sizes) || "100vw"
    srcset = options.delete(:srcset)
    
    # Add responsive attributes
    responsive_options = options.merge(
      sizes: sizes,
      srcset: srcset
    )
    
    optimized_image_tag(image_name, responsive_options)
  end
end
