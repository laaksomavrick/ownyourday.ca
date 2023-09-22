# frozen_string_literal: true

class ErrorsController < ApplicationController
  def index
    foo = params[:foo]
    hash = {}
    hash[:foo] = foo
    hash[:bar] = error
    @hash = hash
  end
end
