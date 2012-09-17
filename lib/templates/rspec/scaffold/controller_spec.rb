require 'spec_helper'

describe <%= controller_class_name %>Controller do

  context "functionality" do

    before :each do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can(:manage, :all)
      @controller.should_receive(:current_ability).at_least(:once).and_return(@ability)
      @controller.stub(:current_user).and_return(stub_model(User))
    end

  <% unless options[:singleton] -%>
    describe "GET index" do

      def do_get_index
        get :index
      end

      it "assigns all <%= table_name.pluralize %> as @<%= table_name.pluralize %>" do
        <%= file_name %> = create(:<%= file_name %>)
        do_get_index
        assigns(:<%= table_name %>).should eq([<%= file_name %>])
      end

      it "renders the application layout" do
        do_get_index
        response.should render_template("layouts/application")
      end

    end

  <% end -%>
    describe "GET show" do

      before :each do
        @<%= file_name %> = create(:<%= file_name %>)
      end

      def do_get_show
        get :show, {:id => @<%= file_name %>.to_param}
      end

      it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
        do_get_show
        assigns(:<%= ns_file_name %>).should eq(@<%= file_name %>)
      end
    end

    describe "GET new" do

      def do_get_new
        get :new
     end

      it "assigns a new <%= ns_file_name %> as @<%= ns_file_name %>" do
        do_get_new
        assigns(:<%= ns_file_name %>).should be_a_new(<%= class_name %>)
      end
    end

    describe "GET edit" do

      before(:each) do
        @<%= file_name %> = create(:<%= file_name %>)
      end

      def do_get_edit
        get :edit, {:id => @<%= file_name %>.to_param}
      end

      it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
        do_get_edit
        assigns(:<%= ns_file_name %>).should eq(@<%= file_name %>)
      end
    end

    # update the return value of this method accordingly.
    def valid_attributes
      {}
    end

    describe "POST create" do

      def do_create
        post :create,
             :<%= ns_file_name %> => valid_attributes
      end

      describe "with valid params" do

        it "creates a new <%= class_name %>" do
          expect {
            do_create
          }.to change(<%= class_name %>, :count).by(1)
        end

        it "assigns a newly created <%= ns_file_name %> as @<%= ns_file_name %>" do
          do_create
          assigns(:<%= ns_file_name %>).should be_a(<%= class_name %>)
          assigns(:<%= ns_file_name %>).should be_persisted
        end

        it "redirects to the created <%= ns_file_name %>" do
          do_create
          response.should redirect_to(<%= class_name %>.last)
        end
      end

      describe "with invalid params" do

        it "assigns a newly created but unsaved <%= ns_file_name %> as @<%= ns_file_name %>" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          do_create
          assigns(:<%= ns_file_name %>).should be_a_new(<%= class_name %>)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          do_create
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do

      before :each do
        @<%= file_name %> = create(:<%= file_name %>)
      end

      def do_update
        put :update, :id => @<%= file_name %>.to_param, :<%= ns_file_name %> => valid_attributes
      end

      describe "with valid params" do
        it "updates the requested <%= ns_file_name %>" do
          <%= class_name %>.any_instance.should_receive(:update_attributes).with(valid_attributes)
          do_update
        end

        it "assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>" do
          do_update
          assigns(:<%= ns_file_name %>).should eq(@<%= file_name %>)
        end

        it "redirects to the <%= ns_file_name %>" do
          do_update
          response.should redirect_to(@<%= file_name %>)
        end
      end

      describe "with invalid params" do
        it "assigns the <%= ns_file_name %> as @<%= ns_file_name %>" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          do_update
          assigns(:<%= ns_file_name %>).should eq(@<%= file_name %>)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save).and_return(false)
          do_update
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do

      before :each do
        @<%= file_name %> = create(:<%= file_name %>)
      end

      it "destroys the requested <%= ns_file_name %>" do
        expect {
          delete :destroy, {:id => @<%= file_name %>.to_param}
        }.to change(<%= class_name %>, :count).by(-1)
      end

      it "redirects to the <%= table_name %> list" do
        delete :destroy, {:id => @<%= file_name %>.to_param}
        response.should redirect_to(<%= index_helper %>_path)
      end
    end
  end
end
