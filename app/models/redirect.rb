class Redirect < ApplicationRecord
  # fuzzily_searchable :text

  validates_presence_of :url, :text
  belongs_to :content

end
