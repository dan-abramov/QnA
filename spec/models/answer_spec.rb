# frozen_string_literal: true

require_relative 'models_helper'

RSpec.describe Answer, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to :question }
  it { should have_many(:attachments) }
  it { should validate_presence_of :body }

  it { should have_db_column :question_id }
  it { should have_db_column :user_id }
  it { should have_db_column :best }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'

  describe 'set best:true to answer' do
    let!(:question)     { create(:question) }
    let!(:answer)       { create(:answer, question: question, best: false) }
    let!(:answer2)      { create(:answer, question: question, best: true) }

    it 'set best:true to one answer' do
      answer.set_best
      expect(answer.best).to eq true
    end

    it 'set best:false to another answer' do
      answer2.set_best
      expect(answer.best).to eq false
    end
  end
end
