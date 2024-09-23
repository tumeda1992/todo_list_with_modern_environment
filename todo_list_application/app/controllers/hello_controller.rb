class HelloController < ApplicationController
  def hello
    render json: {content: "hello"}
  end

  def healthcheck
    render json: {status: "success"}
  end
end
