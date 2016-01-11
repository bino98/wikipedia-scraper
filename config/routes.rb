Rails.application.routes.draw do
  match 'search/ping', to: 'search#ping', via: :get
  match 'search/relational_keywords', to: 'search#relational_keywords', via: :get
end
