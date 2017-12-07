require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  describe '.perform' do
    let(:question)      { create(:question) }
    let(:answer)        { create(:answer, question: question) }
    let(:subscriptions) { create_list(:subscription, 3, question: question) }

    it 'should send new answer notification' do
      subscriptions.each { |subscription| expect(QuestionUpdateMailer).to receive(:notificate).with(subscription).and_call_original }
      AnswerNotificationJob.perform_now(answer)
    end
  end
end
