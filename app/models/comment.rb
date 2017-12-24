class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true, touch: true

  validates :user, :commentable, :commentable_type, :body, presence: true

  default_scope { order(created_at: :asc) }
end
