class DesignerFriendlyGenerator < Rails::Generator::NamedBase
  def manifest

    destination_path = "/app/views/forms/#{file_path}_form_builder"

    class_name = file_path.classify

    record do |m|
      m.directory destination_path
      m.template 'views/forms/_general.html.erb', "#{destination_path}/_general.html.erb"
      m.template 'views/forms/_general_with_errors.html.erb', "#{destination_path}/_general_with_errors.html.erb"
      m.template 'views/forms/_general.html.erb', "#{destination_path}/_text_field.html.erb"
      m.template 'views/forms/_general_with_errors.html.erb', "#{destination_path}/_text_field_with_errors.html.erb"
      m.template 'views/forms/_general.html.erb', "#{destination_path}/_text_area.html.erb"
      m.template 'views/forms/_general_with_errors.html.erb', "#{destination_path}/_text_area_with_errors.html.erb"
      m.template 'views/forms/_check_box.html.erb', "#{destination_path}/_check_box.html.erb"
      m.template 'views/forms/_check_box_with_errors.html.erb', "#{destination_path}/_check_box_with_errors.html.erb"

      m.template 'models/form_builder.rb', "/app/models/#{file_path}_form_builder.rb", :assigns => {:class_name => class_name}
    end
  end
end
