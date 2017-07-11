require_relative '../models_helper'

shared_examples_for 'votable' do
  let!(:model) { described_class }
  let!(:user)  { create(:user) }

  describe 'User vote for object of somebody' do
    let(:object) { create(model.to_s.underscore.to_sym) }

    it 'can change rating of object' do
      object.vote_up(user)
      expect(object.rating).to eq 1
    end

    it 'voting up' do
      expect { object.vote_up(user) }.to change(Vote, :count).by(1)
    end

    it 'voting down' do
      expect { object.vote_down(user) }.to change(Vote, :count).by(1)
    end

    it 'reset votes' do
      expect { object.vote_reset(user) }.to change(Vote, :count).by(0)
    end

    it 'checking object voting' do
      expect(object.voted?(user)).to eq false
      object.vote_up(user)
      expect(object.voted?(user)).to eq true
    end

    context 'can not voting more than 1 time' do
      it 'voting up' do
        object.vote_up(user)
        object.vote_up(user)
        expect(object.rating).to eq 1
      end

      it 'voting down' do
        object.vote_down(user)
        object.vote_down(user)
        expect(object.rating).to eq -1
      end
    end
  end

  describe 'User can not vote for his object' do
    let(:object) { create(model.to_s.underscore.to_sym, user:user) }

    it 'can not change rating of object' do
      object.vote_up(user)
      expect(object.rating).to eq 0
    end

    it 'voting up' do
      expect { object.vote_up(user) }.to_not change(Vote, :count)
    end

    it 'voting down' do
      expect { object.vote_down(user) }.to_not change(Vote, :count)
    end

    it 'reset votes' do
      expect { object.vote_reset(user) }.to_not change(Vote, :count)
    end

    it 'checking object voting' do
      expect(object.voted?(user)).to eq false
      object.vote_up(user)
      expect(object.voted?(user)).to eq false
    end
  end
end
