module ApplicationHelper
	
	def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "desc") ? "asc" : "desc"
    link_to title, params.merge(:sort => column, :direction => direction, page: params[:page]), {:class => css_class}
  end

  def is_empty?(model)
    model.count == 0
  end

  def pagination_links(collection, options = {})
    options[:renderer] ||= BootstrapPaginationHelper::LinkRenderer
    options[:inner_window] ||= 2
    options[:outer_window] ||= 1
    options[:previous_label] = 'Previous'
    options[:next_label] = 'Next'
    will_paginate(collection, options)
  end

  def path_of(type)
    path = type.downcase
    link_to "List #{type}", "/#{path}"
  end

end
