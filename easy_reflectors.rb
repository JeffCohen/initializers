# An easy way to ask a model for its related models.
#
# Adds one new class method to your models called +associations+.
#
# Returns a hash, where keys can be :has_one, :has_many, or :belongs_to.
#
# Example:
#
# Post.associations
# => { :has_many => [:comments, :users], :belongs_to => [:author] }

module EasyReflectors
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    
    def associations
      mirror = {}
      z = reflect_on_all_associations.group_by { |a| a.macro }
      z.keys.each do |k|
        mirror[k] = z[k].collect { |e| e.name }
      end
      mirror
    end
  end
end

# Comment this out if you don't want this applied to all of your models automatically.  
class ActiveRecord::Base
  include EasyReflectors
end
