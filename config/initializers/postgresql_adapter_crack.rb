module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      protected
      # Returns the version of the connected PostgreSQL server.                  
      def postgresql_version
        # Mini Crack for the -fucking- INV postgresql old version
        if @connection.server_version < 80200
          80200
        else
          @connection.server_version
        end
      end
    end
  end
end
