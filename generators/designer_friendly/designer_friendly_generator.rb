class DesignerFriendlyGenerator < Rails::Generator::NamedBase
  def manifest

    destination_path = "/app/views/forms/#{file_path}_form_builder"

    class_name = file_path.classify

    record do |m|
      m.directory destination_path
      m.template 'views/forms/general.html.erb', "#{destination_path}/general.html.erb"
      m.template 'views/forms/general_with_errors.html.erb', "#{destination_path}/general_with_errors.html.erb"
      m.template 'models/form_builder.rb', "/app/models/#{file_path}_form_builder.rb", :assigns => {:class_name => class_name}
    end
  end
end
