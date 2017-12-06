require "rails_helper"

RSpec.describe QuestionUpdateMailer, type: :mailer do
  describe "notificate" do
    let!(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, question: question) }
    let(:mail) { QuestionUpdateMailer.notificate(subscription) }

    it "renders the headers" do
      expect(mail.to).to eq(["user3@for_test.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(subscription.question.title)
    end
  end

end
