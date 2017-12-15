require 'rails_helper'

RSpec.describe Search, type: :model do
  it 'finds object Everywhere' do
    expect(ThinkingSphinx).to receive(:search).with('test')
    Search.find('Everywhere', 'test')
  end

  ['Questions', 'Answers', 'Comments', 'Users'].each do |klass|
    it "finds model in #{klass}" do
      expect(klass.chop.constantize).to receive(:search).with('test')
      Search.find(klass, 'test')
    end
  end
end
