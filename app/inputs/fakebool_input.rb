# Derived from: https://github.com/plataformatec/simple_form/wiki/Create-a-fake-input-that-does-NOT-read-attributes
class FakeboolInput < SimpleForm::Inputs::BooleanInput
  # This method only create a basic input without reading any value from object
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    template.check_box_tag(attribute_name, nil, merged_input_options)
  end
end
