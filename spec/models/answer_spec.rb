require 'rails_helper'

RSpec.describe Answer, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to :question }
  it { should validate_presence_of :body }
  it { should have_db_column :question_id }
end
