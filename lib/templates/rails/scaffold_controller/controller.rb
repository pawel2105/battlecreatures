<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_filter :login_required
  load_and_authorize_resource

  def index
#    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
    @<%= plural_table_name %> = @<%= plural_table_name %>.page(params[:page])
  end

  def show

  end

  def new

  end

  def edit

  end

  def create

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully created.'" %>
    else
      render <%= key_value :action, '"new"' %>
    end
  end

  def update

    if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
      redirect_to @<%= singular_table_name %>, <%= key_value :notice, "'#{human_name} was successfully updated.'" %>
    else
      render <%= key_value :action, '"edit"' %>
    end
  end

  def destroy
    @<%= orm_instance.destroy %>

    redirect_to <%= index_helper %>_url
  end
end
<% end -%>
