class Content < ApplicationRecord
    validates_presence_of :name#, :url, :text
    has_one :restriction, dependent: :destroy
    has_many :redirects

    has_one_attached :background_image
    has_one_attached :overlay_image
    has_one_attached :scan_button
    has_one_attached :loading_image

    accepts_nested_attributes_for :redirects, allow_destroy: true
    before_save :set_name

    def set_name
        self.name = self.name.downcase.squish.gsub(" ", "-")
    end
end
