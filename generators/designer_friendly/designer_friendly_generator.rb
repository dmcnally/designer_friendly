class DesignerFriendlyGenerator < Rails::Generator::NamedBase
  def manifest

    destination_path = "/app/views/forms/#{file_path}"

    record do |m|
      m.directory destination_path
      m.template 'forms/general.html.erb', "#{destination_path}/general.html.erb"
      m.template 'forms/general_with_errors.html.erb', "#{destination_path}/general_with_errors.html.erb"

    end
  end
end
