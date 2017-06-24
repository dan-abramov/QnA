# frozen_string_literal: true

require_relative 'models_helper'

RSpec.describe Question, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_db_column :user_id }
end
