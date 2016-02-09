class Recipe < ActiveRecord::Base

	extend FriendlyId
  	friendly_id :title, use: :slugged

	has_many :ingrediants
	has_many :directions

	accepts_nested_attributes_for :ingrediants, 
		allow_destroy: true,
		reject_if: :all_blank

	accepts_nested_attributes_for :directions,
		allow_destroy: true,
		reject_if: :all_blank

	has_attached_file :image, styles: { medium: "400x400#", thumb: "250x250#"}
  	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  	
  	#validates :image, presence: true
	validates :title, presence: true, length: {minimum: 2, maximum: 30}
	validates :description, presence: true, length: {maximum: 140}
	validates :ingrediants, presence: true
	validates :directions, presence: true, length: {maximum: 50}

	# def self.search(query)
	# 	where("title like ?", "%#{query}%")
	# end

	searchable do
		text :title, :boost => 5 #keywords in title are 5 times more relevant
		text :description
		text :name, :boost => 3 do
			ingrediants.map { |ingrediants| ingrediants.name}
		end
	end

end
