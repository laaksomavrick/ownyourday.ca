# frozen_string_literal: true

require 'factory_bot'
# rubocop:disable Style/MixinUsage
include FactoryBot::Syntax::Methods
# rubocop:enable Style/MixinUsage

# Create dev user
user = User.create(email: 'dev@example.com', password: 'Qweqwe1!')

# Create list of goals for user
create_list(:goal, 5, user:)
