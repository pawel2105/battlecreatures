require 'spec_helper'

describe BattlesController do

  context "functionality" do

    before :each do
      @current_user = create(:user)
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can(:manage, :all)
      controller.should_receive(:current_ability).at_least(:once).and_return(@ability)
      controller.stub(:current_user).and_return(@current_user)
    end

    # describe "GET index" do

    #   def do_get_index
    #     get :index
    #   end

    #   it "assigns all battles as @battles" do
    #     battle = create(:battle)
    #     do_get_index
    #     assigns(:battles).should eq([battle])
    #   end

    #   it "renders the application layout" do
    #     do_get_index
    #     response.should render_template("layouts/application")
    #   end

    # end

    # describe "GET show" do

    #   before :each do
    #     @battle = create(:battle)
    #   end

    #   def do_get_show
    #     get :show, {:id => @battle.to_param}
    #   end

    #   it "assigns the requested battle as @battle" do
    #     do_get_show
    #     assigns(:battle).should eq(@battle)
    #   end
    # end

    describe "GET new" do

      def do_get_new
        get :new
      end

      it "assigns a new battle as @battle" do
        do_get_new
        assigns(:battle).should be_a_new(Battle)
      end

    end

    describe "GET fight" do

      def good_create
        get :fight,
            :player => "robot"
      end

      def bad_create
        get :fight,
            :player => "kitten"
      end

      describe "with valid params" do

        it "creates a new Battle" do
          expect {
            good_create
          }.to change(Battle, :count).by(1)
        end

        it "assigns a newly created battle as @battle" do
          good_create
          assigns(:battle).should be_a(Battle)
          assigns(:battle).user.should == @current_user
          assigns(:battle).should be_persisted
        end

      end

      describe "with invalid params" do
        render_views
        before :each do
          Battle.any_instance.stub(:opponent).and_return("kitten")
        end

        it "assigns a newly created but unsaved battle as @battle" do
          bad_create
          assigns(:battle).should be_a(Battle)
        end

        it "tells the user their option was wrong" do
          bad_create
          response.body.should have_content("Your option was not valid")
        end

      end
    end

  end
end
