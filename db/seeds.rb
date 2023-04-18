# frozen_string_literal: true

require 'factory_bot'
include FactoryBot::Syntax::Methods

# Create dev user
user = User.create(email: 'dev@example.com', password: 'Qweqwe1!')

# Create list of goals for user
create_list(:goal, 5, user:)
