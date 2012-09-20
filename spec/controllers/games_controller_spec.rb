require 'spec_helper'

describe GamesController do

  context "functionality" do

    before :each do
      @current_user = create(:user)
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.can(:manage, :all)
      controller.should_receive(:current_ability).at_least(:once).and_return(@ability)
      controller.stub(:current_user).and_return(@current_user)
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

    describe "GET play_letter" do

      before :each do
        @game = create(:game, choices: "a")
      end

      def do_get_play_letter
        get :play_letter, :id => @game.to_param, :letter => "g"
      end

      it "assigns the requested game as @game" do
        do_get_play_letter
        assigns(:game).should eq(@game)
        @game.reload
        @game.choices.should include("g")
      end

      it "render the show template" do
        do_get_play_letter
        response.should redirect_to(@game)
      end

      it "render adds a flash message if weekly_rating increases" do
        @game = create(:game, word: "game", choices: "ame", user: @current_user)
        expect {
          do_get_play_letter
        }.to change{@current_user.reload;@current_user.weekly_rating}
        flash[:notice].should_not be_blank
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
          assigns(:game).user.should == @current_user
          assigns(:game).should be_persisted
        end

        it "redirects to the created game" do
          do_create
          response.should redirect_to(Game.last)
        end
      end

      describe "with invalid params" do

        before :each do
          # Trigger the behavior that occurs when invalid params are submitted
          Game.any_instance.stub(:save).and_return(false)
        end

        it "assigns a newly created but unsaved game as @game" do
          do_create
          assigns(:game).should be_a_new(Game)
        end

        it "redirects to index" do
          do_create
          response.should redirect_to(Game)
        end

        it "sets an alert message" do
          do_create
          flash[:alert].should_not be_blank
        end

      end
    end

  end
end
