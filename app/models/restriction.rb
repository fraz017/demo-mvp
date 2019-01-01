class Restriction < ApplicationRecord
    validates_presence_of :limit, :unit
end
