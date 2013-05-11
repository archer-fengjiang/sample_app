# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  # note we don't put admin as an attr_accessible due to put /users/17?admin=1
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships,  foreign_key: "followed_id",
                                    class_name: "Relationship", # otherwise rails would look for ReverseRelationship class
                                    dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower #we can omit source since rails will singularize "followers" and look for the foreign key follower_id in this case
  has_many :followed_users, through: :relationships, source: :followed

  before_save{ |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence:true

  def feed
    # This is preliminary. See "Following users" for the
    # full implementation.
    Micropost.where("user_id = ?", id)
  end

  # ! means this method will raise an exception, so will use create!
  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by_followed_id(other_user.id).destroy
  end

  def following?(other_user)
    self.relationships.find_by_followed_id(other_user.id)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
