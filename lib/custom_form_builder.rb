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
      @template.render :partial => partial,
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