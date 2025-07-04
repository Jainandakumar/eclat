# Handle missing files gracefully in Active Storage
Rails.application.config.to_prepare do
  ActiveStorage::AnalyzeJob.class_eval do
    rescue_from ActiveStorage::FileNotFoundError do |exception|
      Rails.logger.warn "ActiveStorage file not found: #{exception.message}"
    end
  end
end