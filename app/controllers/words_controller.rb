class WordsController < ApplicationController
  def define
    @definition = Dictionary.define(params[:word]).join(": ")
  end
end
