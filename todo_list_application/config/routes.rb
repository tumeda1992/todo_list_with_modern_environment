Rails.application.routes.draw do
  get  "/hello", to: "hello#hello"
  get  "/healthcheck", to: "hello#healthcheck"
  get  "/scraping", to: "scraping#index"
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
end
