class TodoList < ApplicationRecord
	validates :title,  presence: true
	has_many :todo_items
end
