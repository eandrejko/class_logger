module ClassLogger
  def self.included(base)
    base.send :extend, ClassMethods
  end


  module ClassMethods
    def has_own_logger(options = {})
      send :extend, ClassLoggerClassMethods
      send :include, ClassLoggerInstanceMethods
      cattr_accessor :class_logger_directory
      self.class_logger_directory = options[:in]
    end          
  end
  
  module ClassLoggerClassMethods
    def setup_class_logger
      return class_variable_get(:@@class_logger) if class_variable_defined?(:@@class_logger)
      if self.class_logger_directory
        log_path = File.expand_path("#{RAILS_ROOT}/#{self.class_logger_directory}")
      else
        log_path = File.expand_path("#{RAILS_ROOT}/log")
      end
      raise "#{self.to_s} has_own_logger: specified directory does not exist" unless File.exists?(log_path)
      log_file = File.join(log_path, "/#{self.to_s.downcase}.log")

      class_variable_set(:@@class_logger, Logger.new(log_file))

      logger = class_variable_get(:@@class_logger)
      def logger.format_message(severity, timestamp, progname, msg)
        "[#{timestamp.strftime("%m/%d/%y %H:%M:%S")}] #{msg}\n" 
      end

      class_variable_get(:@@class_logger)
    end

    def class_logger
      self.setup_class_logger
    end
  end
  
  module ClassLoggerInstanceMethods
    def log(msg)
      self.class.class_logger.info "(#{self.class.to_s}[#{self.id}]) #{msg}"
    end
  end
  
end
