class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :books
  has_many :favorites, dependent: :destroy
  
  # いいね多い順に表示
  has_many :favorited_books, through: :favorites, source: :book
  # 閲覧数
  has_many :view_counts, dependent: :destroy
  
  has_many :book_comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id
  has_many :followeds, through: :passive_relationships, source: :follower
  
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def followed_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end

  def self.looks(search, word)
    if search == "perfect_match"
      #User=self、selfが含まれるメソッドはクラス（全体を呼び出す）メソッド
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "partial_match"
      @user = self.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end

end
