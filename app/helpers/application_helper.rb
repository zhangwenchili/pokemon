module ApplicationHelper
  # Pixel sizes with matching rules in application.css (user-avatar--*).
  AVATAR_SIZE_PRESETS = [ 32, 36, 40, 48, 64, 80, 120 ].freeze

  # Rounded avatar or username initial when no image is uploaded.
  def user_avatar_tag(user, size: 40, extra_class: nil)
    px = AVATAR_SIZE_PRESETS.min_by { |preset| (preset - size).abs }
    size_class = "user-avatar user-avatar--#{px}"
    classes = [ "rounded-circle", size_class, extra_class ].compact.join(" ")

    if user.avatar.attached?
      image_tag user.avatar, class: classes, alt: user.username
    else
      initial = user.username.to_s.first&.upcase || "?"
      content_tag(:div, initial,
                  class: "#{classes} bg-secondary text-white d-inline-flex align-items-center justify-content-center user-avatar-placeholder")
    end
  end

  # Bootstrap nav-link classes for top tabs (matches controller name).
  def nav_tab_class(tab)
    if controller.controller_name == tab
      "nav-link active"
    else
      "nav-link"
    end
  end
end
