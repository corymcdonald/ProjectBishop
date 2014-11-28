class Section < ActiveRecord::Base
  def self.search(search)
    if search
      search = search.gsub(' ','')
      self.where("name like ?", "%#{search}%")
    end
  end
end
