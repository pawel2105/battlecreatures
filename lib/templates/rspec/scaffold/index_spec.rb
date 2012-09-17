require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= ns_table_name %>/index" do
  include ViewCapybaraRendered

  before(:each) do
    @<%= table_name %> =
    assign(:<%= table_name %>, [
<% [1,2].each_with_index do |id, model_index| -%>
      stub_model(<%= class_name %>, id: <%= model_index + 100 %> <%= output_attributes.empty? ? (model_index == 1 ? ')' : '),') : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
        <%= attribute.name %>: <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
      <%= model_index == 1 ? ')' : '),' %>
<% end -%>
<% end -%>
    ])
    view.stub!(:paginate)
  end

  it "renders a list of <%= ns_table_name %>" do
    render
<% [1,2].each_with_index do |id, model_index| -%>
    within("#<%= singular_table_name %>_<%= model_index + 100 %>") do
<% for attribute in output_attributes -%>
      rendered.should have_content(<%= value_for(attribute) %>)
<% end -%>
    end
<% end -%>
  end

  it "renders a actions of <%= ns_table_name %>" do
    render
<% [1,2].each_with_index do |id, model_index| -%>
    within("#<%= singular_table_name %>_<%= model_index + 100 %>") do
      rendered.should have_link("show_<%= singular_table_name %>_<%= model_index + 100 %>")
      rendered.should have_link("delete_<%= singular_table_name %>_<%= model_index + 100 %>")
      rendered.should have_link("edit_<%= singular_table_name %>_<%= model_index + 100 %>")
    end
<% end -%>
  end

  it "should rendered the pagination" do
    view.should_receive(:paginate).with(@<%= table_name %>).and_return("<span>Pagination</span>")
    render
    rendered.should have_content("Pagination")
  end

end