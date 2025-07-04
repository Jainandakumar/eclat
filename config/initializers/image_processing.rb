# Configure image processing to use mini_magick instead of vips
# This avoids ruby-vips compatibility issues with Ruby 3.2.2
Rails.application.config.active_storage.variant_processor = :mini_magick