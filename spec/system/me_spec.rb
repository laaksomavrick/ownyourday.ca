# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Me' do
  let!(:user) { create(:user) }

  describe 'edit page' do
    it 'redirects non-authenticated users' do
      visit me_path
      expect(page).to have_current_path('/users/sign_in')
    end

    it 'shows my email and time zone' do
      sign_in user
      visit me_path

      expect(find_field('Email address', disabled: true).value).to eq user.email
      expect(find_field('Time zone').value).to eq user.time_zone
    end

    it 'can update my time zone' do
      sign_in user
      visit me_path

      select 'Atlantic Time (Canada)', from: 'user_time_zone'

      submit_button = find('input[name="commit"]')
      submit_button.click

      expect(page).to have_content(I18n.t('helpers.alert.update_successful', name: 'time zone'))
      expect(find_by_id('user_time_zone').value).to eq 'Atlantic Time (Canada)'
    end
  end
end
