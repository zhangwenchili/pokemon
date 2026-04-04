module ApplicationHelper
  # Bootstrap nav-link classes for top tabs (matches controller name).
  def nav_tab_class(tab)
    if controller.controller_name == tab
      "nav-link active"
    else
      "nav-link"
    end
  end
end
