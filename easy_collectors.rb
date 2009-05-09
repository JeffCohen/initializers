#
# Example:
# class User < ActiveRecord::Base
#
#   include EasyCollectors
#
#   named_scope :admins, :conditions => { :role => 'admin' }
#
# end
#
# User.names  # => User.all.collect(&:name)
# User.admins.names  # => User.admins.collect(&:name) 
#
# You can also provide all the usual ActiveRecord options, like :conditions and :limit.
# 
# User.names :conditions => { :role => 'standard' }, :limit => 5
module EasyCollectors
  
  def self.included(klass)

    class << klass

      alias_method :active_record_method_missing, :method_missing
      
      def method_missing(m, *args)
        begin
          active_record_method_missing(m, args)
        rescue
          collect_all_from_column(m.to_s, args) || raise
        end
      end
      
      def collect_all_from_column(m, args)
        col = column_names.detect { |col_name| m == col_name.pluralize }
        if col
          opts = options_for_collect_all_from_column(col, args)
          all(opts).collect(&col.to_sym)
        end
      end
      
      def options_for_collect_all_from_column(col, args)
        opts = Hash[*args]
        opts[:order] ||= col
        opts[:select] ||= col
        opts
      end
      
    end
    
  end
end

# Comment this out if you don't want this applied to all of your models automatically.  
class ActiveRecord::Base
  include EasyCollectors
end
