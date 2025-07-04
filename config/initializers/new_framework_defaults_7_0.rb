# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 7.0 upgrade.
#
# Once upgraded flip defaults one by one to migrate to the new default.
#
# Read the Guide for Upgrading Ruby on Rails for more info on each option.

# `button_to` view helper will render `<button>` element, regardless of whether
# or not the content is passed as the first argument or as a block.
# Rails.application.config.action_view.button_to_generates_button_tag = true

# `stylesheet_link_tag` view helper will not render the media attribute by default.
# Rails.application.config.action_view.apply_stylesheet_media_default = false

# Change the digest class for the key derivation to `OpenSSL::Digest::SHA256`.
# Changing this may affect existing passwords saved with `has_secure_password`.
# Rails.application.config.active_model.key_derivation_digest = "OpenSSL::Digest::SHA256"

# Change the digest class for ActiveSupport::Digest to `OpenSSL::Digest::SHA256`.
# This may affect existing cache keys.
# Rails.application.config.active_support.hash_digest_class = OpenSSL::Digest::SHA256

# Don't override ActiveSupport::TimeWithZone.name with the default Ruby implementation.
# Rails.application.config.active_support.remove_deprecated_time_with_zone_name = true

# Change the format of the cache entry.
# Changing this default may break existing cache entries.
# Rails.application.config.active_support.cache_format_version = 7.0

# Continue to use the pre-Rails 7 serialization format.
# This maintains compatibility with cache entries written by Rails 6.1.
# Rails.application.config.active_support.use_message_serializer_for_metadata = true

# Enable parameter wrapping for JSON.
# Rails.application.config.action_controller.wrap_parameters_by_default = true

# Specifies whether generated namespaced UUIDs follow the RFC 4122 standard for namespace IDs provided as a
# `String` to account for byte ordering when digesting.
# Rails.application.config.active_support.use_rfc4122_namespaced_uuids = true

# Change the variant processor for Active Storage.
# Changing this default may break existing images that have already been processed.
# Rails.application.config.active_storage.variant_processor = :vips

# Enable the Active Job `BigDecimal` argument serializer, which guarantees
# roundtripping. Without this serializer, some `BigDecimal` arguments may be
# serialized as simple (non-roundtrippable) strings.
Rails.application.config.active_job.use_big_decimal_serializer = true