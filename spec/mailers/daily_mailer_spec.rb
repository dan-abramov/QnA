require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let!(:user)        { create(:user) }
    let(:mail)         { DailyMailer.digest(user) }
    let(:questions)    { create_list(:question, 2) }

    it "renders the headers" do
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      questions.each { |question| expect(mail.body.encoded).to match(question.title) }
    end
  end

end
