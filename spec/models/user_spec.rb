# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'can create a user' do
    user = create(:user)
    expect(user.valid?).to be(true)
  end

  it 'requires a first name' do
    expect do
      create(:user, first_name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: First name can't be blank")
  end

  it 'requires a last name' do
    expect do
      create(:user, last_name: '')
    end.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Last name can't be blank")
  end
end
