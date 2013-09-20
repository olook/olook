class CepsController < ApplicationController
  def show
    @cep = Cep.find_by_cep(params[:cep])
    if @cep
      render json: @cep.to_json
    else
      render json: {}, status: :not_found
    end
  end
end
