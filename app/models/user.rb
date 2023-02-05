class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  attr_writer :login

  serialize :buyer_ids, Array

  validates :name, {presence: true, uniqueness: {case_sensitive: true}, length: {minimum: 3, maximum: 75}}
  validates :email, {presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ } }
  validates :phone, {length: {maximum: 10}, uniqueness: true, numericality: true}

  def login
    @login || self.phone || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(phone) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.has_key?(:phone) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def active_for_authentication?
    super && self.is_active # i.e. super && self.is_active
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end

  def buyers
    Buyer.where(id: buyer_ids).order(:name)
  end

  def buyer_names
    buyers.pluck(:name).join(', ')
  end

end
