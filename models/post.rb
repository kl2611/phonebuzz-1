class Post < ActiveRecord::Base
    validates_presence_of :phone, :delay
end
