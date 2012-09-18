require 'spec_helper'

describe GamesController do
  it_behaves_like "a cancan controller" do
    let(:subject){create(:game)}
    let(:default_params){{}}
  end

  context "functionality" do

    before :each do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can(:manage, :all)
      @controller.should_receive(:current_ability).at_least(:once).and_return(@ability)
      @controller.stub(:current_user).and_return(stub_model(User))
    end

      describe "GET index" do

      def do_get_index
        get :index
      end

      it "assigns all games as @games" do
        game = create(:game)
        do_get_index
        assigns(:games).should eq([game])
      end

      it "renders the application layout" do
        do_get_index
        response.should render_template("layouts/application")
      end

    end

      describe "GET show" do

      before :each do
        @game = create(:game)
      end

      def do_get_show
        get :show, {:id => @game.to_param}
      end

      it "assigns the requested game as @game" do
        do_get_show
        assigns(:game).should eq(@game)
      end
    end

    describe "GET new" do

      def do_get_new
        get :new
     end

      it "assigns a new game as @game" do
        do_get_new
        assigns(:game).should be_a_new(Game)
      end
    end

    describe "GET edit" do

      before(:each) do
        @game = create(:game)
      end

      def do_get_edit
        get :edit, {:id => @game.to_param}
      end

      it "assigns the requested game as @game" do
        do_get_edit
        assigns(:game).should eq(@game)
      end
    end

    # update the return value of this method accordingly.
    def valid_attributes
      {}
    end

    describe "POST create" do

      def do_create
        post :create,
             :game => valid_attributes
      end

      describe "with valid params" do

        it "creates a new Game" do
          expect {
            do_create
          }.to change(Game, :count).by(1)
        end

        it "assigns a newly created game as @game" do
          do_create
          assigns(:game).should be_a(Game)
          assigns(:game).should be_persisted
        end

        it "redirects to the created game" do
          do_create
          response.should redirect_to(Game.last)
        end
      end

      describe "with invalid params" do

        it "assigns a newly created but unsaved game as @game" do
          # Trigger the behavior that occurs when invalid params are submitted
          Game.any_instance.stub(:save).and_return(false)
          do_create
          assigns(:game).should be_a_new(Game)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Game.any_instance.stub(:save).and_return(false)
          do_create
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do

      before :each do
        @game = create(:game)
      end

      def do_update
        put :update, :id => @game.to_param, :game => valid_attributes
      end

      describe "with valid params" do
        it "updates the requested game" do
          Game.any_instance.should_receive(:update_attributes).with(valid_attributes)
          do_update
        end

        it "assigns the requested game as @game" do
          do_update
          assigns(:game).should eq(@game)
        end

        it "redirects to the game" do
          do_update
          response.should redirect_to(@game)
        end
      end

      describe "with invalid params" do
        it "assigns the game as @game" do
          # Trigger the behavior that occurs when invalid params are submitted
          Game.any_instance.stub(:save).and_return(false)
          do_update
          assigns(:game).should eq(@game)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Game.any_instance.stub(:save).and_return(false)
          do_update
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do

      before :each do
        @game = create(:game)
      end

      it "destroys the requested game" do
        expect {
          delete :destroy, {:id => @game.to_param}
        }.to change(Game, :count).by(-1)
      end

      it "redirects to the games list" do
        delete :destroy, {:id => @game.to_param}
        response.should redirect_to(games_path)
      end
    end
  end
end
