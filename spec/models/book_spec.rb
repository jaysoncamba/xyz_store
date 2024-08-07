require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { FactoryBot.build(:book, title:) }

  context 'Validates' do
    context 'Title' do
      context 'when present' do
        let(:title) { FFaker::Name.unique.name }
        it { is_expected.to be_valid }
      end
      context 'when not present' do
        let(:title) { nil }
        it { is_expected.to be_invalid }
      end
    end
  end
end