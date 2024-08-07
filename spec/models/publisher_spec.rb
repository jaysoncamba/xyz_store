require 'rails_helper'

RSpec.describe Publisher, type: :model do
  subject { FactoryBot.build(:publisher, name: name) }

  context 'Validates' do
    context 'Name' do
      context 'when present' do
        let(:name) { FFaker::Name.unique.name }
        it { is_expected.to be_valid }
      end
      context 'when not present' do
        let(:name) { nil }
        it { is_expected.to be_invalid }
      end
    end
  end
end