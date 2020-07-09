class TodoItem < ApplicationRecord
  belongs_to :todo_list
  validates :content,  presence: true
  attribute :completed, default: false
end
