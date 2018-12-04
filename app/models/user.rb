class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "follow_id"
    has_many :followers, through: :reverse_of_relationships, source: :user
    has_many :like_relationships
    has_many :favorites, through: :like_relationships, source: :micropost
    
    def follow(other_user)
      unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end
    
    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end
      
    def following?(other_user)
      self.followings.include?(other_user) # ==を呼び出してる。==はidしか比較しない
    end
    
    def feed_microposts
      Micropost.where(user_id: self.following_ids + [self.id])
    end
    
    def like(micropost)
      self.like_relationships.find_or_create_by(micropost_id: micropost.id)
    end
    
    def unlike(micropost)
      like_relationship = self.like_relationships.find_by(micropost_id: micropost.id)
      like_relationship.destroy if like_relationship
    end
    
    def liking?(micropost)
      self.favorites.include?(micropost)
    end
end
