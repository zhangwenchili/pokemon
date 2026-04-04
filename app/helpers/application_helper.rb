module ApplicationHelper
  # Rounded avatar or username initial when no image is uploaded.
  def user_avatar_tag(user, size: 40, extra_class: nil)
    style = "width: #{size}px; height: #{size}px; object-fit: cover;"
    classes = [ "rounded-circle", extra_class ].compact.join(" ")

    if user.avatar.attached?
      image_tag user.avatar, class: classes, style:, alt: user.username
    else
      initial = user.username.to_s.first&.upcase || "?"
      content_tag(:div, initial,
                  class: "#{classes} bg-secondary text-white d-inline-flex align-items-center justify-content-center user-avatar-placeholder",
                  style: "#{style} font-size: #{size * 0.42}px; font-weight: 600;")
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
