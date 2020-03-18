class HourAndMinuteInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    val = object.send(attribute_name) || Time.now

    input_html_options[:class] << 'form-control-inline numeric integer'
    @builder.text_field("#{attribute_name}_hour", 
                        input_html_options.merge(size:   2, 
                                                 width:  2,
                                                 value:  val.hour)) + " : " +
    @builder.text_field("#{attribute_name}_minute", 
                        input_html_options.merge(size:   2, 
                                                 width:  2,
                                                 value:  val.min))
  end
end

