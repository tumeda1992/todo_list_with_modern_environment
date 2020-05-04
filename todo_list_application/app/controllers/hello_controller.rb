class HelloController < ApplicationController
  def hello
    render json: {content: "hello"}
  end
end
