# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Me' do
  let!(:user) { create(:user) }

  describe 'edit page' do
    it 'redirects non-authenticated users' do
      visit me_path
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows my information' do
      sign_in user
      visit me_path

      expect(find_field('Email address', disabled: true).value).to eq user.email
      expect(find_field('Time zone').value).to eq user.time_zone
      expect(find_field('First name').value).to eq user.first_name
      expect(find_field('Last name').value).to eq user.last_name
    end

    it 'can update my information' do
      sign_in user
      visit me_path

      select 'Atlantic Time (Canada)', from: 'user_time_zone'
      fill_in 'First name', with: 'firstname'
      fill_in 'Last name', with: 'lastname'

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content(I18n.t('helpers.alert.update_successful', name: 'user information'))
      expect(find_by_id('user_time_zone').value).to eq 'Atlantic Time (Canada)'
      expect(find_by_id('user_first_name').value).to eq 'firstname'
      expect(find_by_id('user_last_name').value).to eq 'lastname'
    end
  end
end
