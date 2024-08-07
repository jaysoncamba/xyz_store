require 'rails_helper'

RSpec.describe Publisher, type: :model do
  subject { FactoryBot.build(:author, first_name:, last_name:) }
  let(:first_name) { 'Jayson' }
  let(:last_name) { 'Camba' }
  context 'Validates' do
    context 'First Name' do
      context 'when present' do
        it { is_expected.to be_valid }
      end
      context 'when not present' do
        let(:first_name) { nil }
        it { is_expected.to be_invalid }
      end
    end

    context 'Last Name' do
      context 'when present' do
        it { is_expected.to be_valid }
      end
      context 'when not present' do
        let(:last_name) { nil }
        it { is_expected.to be_invalid }
      end
    end
  end
end