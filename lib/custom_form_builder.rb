ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end

class CustomFormBuilder < ActionView::Helpers::FormBuilder

  class_inheritable_accessor :templates

  helpers = field_helpers - %w(label fields_for hidden_field)

  helpers.each do |name|
    define_method name do |field, *args|
      options = args.detect{|argument| argument.is_a?(Hash)} || {}
      render_custom_input(field, name, options) do
        super
      end
    end
  end

  def render_custom_input(field, name, options)

    self.class.templates ||= {}

    template_path = "forms/#{self.class.name.underscore}"

    @template.capture do

      # Get the options from an instance tag
      instance_tag = ActionView::Helpers::InstanceTag.new(object_name, field, self, options.delete(:object))

      # Sure this bit can be improved.  This is just to get the name of the
      # inputs.
      name_and_id_hash = {}
      instance_tag.send(:add_default_name_and_id, name_and_id_hash)
      name_and_id_hash.symbolize_keys!


      locals = {
        :element => yield,
        :label => label(field, options[:label]),
        :label_text => (options[:label] || field.to_s.humanize),
        :object => instance_tag.object
      }

      # Merge in the returned id and name
      locals.merge!(name_and_id_hash)


      partial = "#{name}"

      if has_errors_on?(field)
        locals.merge!(:error => error_message(field, options))
        partial = "#{partial}_with_errors"
      end

      puts "=========== Looking for #{partial}"

      location = self.class.templates[partial]
      unless location
        if File.exist?("#{RAILS_ROOT}/app/views/#{template_path}/_#{partial}.html.erb")
          location = partial
        else
          if has_errors_on?(field)
            location = "general_with_errors"
          else
            location = "general"
          end
        end

        self.class.templates[partial] = location

      end



      @template.render :partial => "#{template_path}/#{location}",
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