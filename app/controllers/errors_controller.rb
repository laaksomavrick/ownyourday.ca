class ErrorsController < ApplicationController
  def index
    # TODO: cause an error
    foo = params[:foo]
    hash = {}
    hash[:foo] = foo
    hash[:bar] = error
    @hash = hash
  end
end
