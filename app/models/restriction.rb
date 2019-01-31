class Restriction < ApplicationRecord
    belongs_to :content
    validates_presence_of :limit, :unit 
end
