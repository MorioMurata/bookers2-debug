class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def current_page
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      #Book=self、selfが含まれるメソッドはクラス（全体を呼び出す）メソッド
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "partial_match"
      @book = self.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

end
