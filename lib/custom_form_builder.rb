ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end

class CustomFormBuilder < ActionView::Helpers::FormBuilder

  class_inheritable_accessor :templates

  

  helpers = field_helpers - %w(label fields_for)

  helpers.each do |name|
    define_method name do |field, *args|
      options = args.detect{|argument| argument.is_a?(Hash)} || {}
      build_shell(field, name, options) do
        super
      end
    end
  end

  def build_shell(field, name, options)

    self.class.templates ||= {}

    template_path = "forms/#{self.class.name.underscore}"

    @template.capture do
      locals = {
        :element => yield,
        :label => label(field, options[:label])
      }

      partial = "#{template_path}/#{name}"

      if has_errors_on?(field)
        locals.merge!(:error => error_message(field, options))
        partial = "#{partial}_with_errors"
      end

      location = self.class.templates[partial]
      unless location
        if File.exist?("#{partial}.html.erb")
          location = partial
        else
          if has_errors_on?(field)
            location = "#{template_path}/general_with_errors"
          else
            location = "#{template_path}/general"
          end
        end

        self.class.templates[partial] = location

      end

      location = "/forms/testing_form_builder/general"

      @template.render :partial => location,
                       :locals => locals
    end
  end

  def error_message(field, options)
    if has_errors_on?(field)
      errors = object.errors.on(field)
      errors.is_a?(Array) ? errors.to_sentence : errors
    else
      ''
    end
  end

  def has_errors_on?(field)
    !(object.nil? || object.errors.on(field).blank?)
  end
end