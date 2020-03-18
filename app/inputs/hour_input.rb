class HourInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    input_html_options[:class] << 'form-control-inline numeric integer'
    val = object.send(attribute_name) || Time.now
    @builder.text_field("#{attribute_name}_hour", 
                        input_html_options.merge(size:   2, 
                                                 width:  2,
                                                 value:  val.hour))
  end
end

