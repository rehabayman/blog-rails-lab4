class Post < ApplicationRecord
    validates :title, presence: true, length: {maximum: 50}, uniqueness: true
    validates :content, presence: true

    has_many :comments, dependent: :delete_all
end
