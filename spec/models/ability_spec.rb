require 'rails_helper'

describe Ability do
  subject(:ability)  { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)             { create(:user) }
    let(:another_user)     { create(:user) }
    let(:question)         { create(:question, user: user) }
    let(:another_question) { create(:question, user: another_user) }
    let(:answer)           { create(:answer, user: user) }
    let(:another_answer)   { create(:answer, user: another_user) }

    it { should_not be_able_to :manage, :all }
    it { should     be_able_to :read, :all }

    it { should be_able_to :create, Question}
    it { should be_able_to :create, Answer}
    it { should be_able_to :create, Comment}

    it { should     be_able_to :update, create(:question, user: user),  user: user }
    it { should_not be_able_to :update, create(:question, user: another_user), user: user }

    it { should     be_able_to :update, create(:answer, user: user),  user: user }
    it { should_not be_able_to :update, create(:answer, user: another_user), user: user }

    it { should     be_able_to :destroy, create(:question, user: user),  user: user}
    it { should_not be_able_to :destroy, create(:question, user: another_user), user: user}

    it { should     be_able_to :destroy, create(:attachment, attachable: question) }
    it { should_not be_able_to :destroy, create(:attachment, attachable: another_question) }

    it { should     be_able_to :destroy, create(:attachment, attachable: answer) }
    it { should_not be_able_to :destroy, create(:attachment, attachable: another_answer) }

    it { should     be_able_to :set_best, create(:answer, user: another_user, question: question), user: user }
    it { should_not be_able_to :set_best, create(:answer, user: user, question: another_question), user: user }

    it { should     be_able_to [:vote_up, :vote_down, :vote_reset], create(:answer), user: another_user }
    it { should_not be_able_to [:vote_up, :vote_down, :vote_reset], create(:answer, user: user), user: user }

    it { should     be_able_to [:vote_up, :vote_down, :vote_reset], create(:question), user: another_user }
    it { should_not be_able_to [:vote_up, :vote_down, :vote_reset], create(:question, user: user), user: user }
  end
end
