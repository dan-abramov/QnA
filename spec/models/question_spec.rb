# frozen_string_literal: true

require_relative 'models_helper'

RSpec.describe Question, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_db_column :user_id }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'

  describe '.update_notification' do
    let(:question)     { create(:question) }
    let(:subscription) { create(:subscription) }

    it 'is working when question updated' do
      expect(question).to receive(:update_notification)
      question.save
    end

    it 'is manage to work QuestionUpdateMailer' do
      expect(QuestionUpdateMailer).to receive(:notificate).with(subscription).and_call_original
      question.save
    end
  end
end
