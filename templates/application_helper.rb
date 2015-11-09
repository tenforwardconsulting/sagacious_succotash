module ApplicationHelper

  def css_classes_for_main
    namespaces = controller_path.split('/')                               # e.g. devise/sessions
    css_classes = namespaces.map.with_index do |namespace, i|             # e.g. [devise-view, devise-sessions-view]
      beginning = namespaces[0...i].join('-').presence.try(:+, '-')
      css_class = "#{beginning}#{namespace}-view"
    end
    css_classes << "#{controller_path.gsub('/', '-')}-#{params[:action]}" # e.g. devise-sessions-new
    css_classes.join ' '
  end
end
