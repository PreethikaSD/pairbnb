require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {User.create(email:'mspreethika@gmail.com', password: '12345', password_confirmation: '12345')}
	it {is_expected.to validate_presence_of(:email) }
	it {is_expected.to have_many(:listings)}
	it {is_expected.to have_many(:bookings)}
end
