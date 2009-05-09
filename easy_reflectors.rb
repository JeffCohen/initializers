# An easy way to ask a model for its related models.
#
# Adds one new class method to your models called +associations+.
#
# Returns a hash, where keys are :has_one, :has_many, :belongs_to.
#
# Example:
#
# Post.associations
# => { :has_many => [:comments, :users], :belongs_to => [:author] }

module EasyReflectors
  
  # Bring in the class methods when this module is included
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    
    # Return an easy-to-read hash of this model's associations.
    def associations
      reflect_on_all_associations.inject({}) do |all, association| 
        all[association.macro] ||= [] 
        all[association.macro] << association.name
        all
      end
    end
    
  end
  
end

# Comment this out if you don't want this applied to all of your models automatically.  
class ActiveRecord::Base
  include EasyReflectors
end
