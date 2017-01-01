module Study
  module TextHighlight
    class << self
      def red(string, plain: false)
        plain ? string.to_s : "\033[1;31;40m#{ string.to_s }\033[0m"
      end

      def yellow(string, plain: false)
        plain ? string.to_s : "\033[1;33;40m#{ string.to_s }\033[0m"
      end

      def blue(string, plain: false)
        plain ? string.to_s : "\033[1;34;40m#{ string.to_s }\033[0m"
      end

      def green(string, plain: false)
        plain ? string.to_s : "\033[1;32;40m#{ string.to_s }\033[0m"
      end

      def violet(string, plain: false)
        plain ? string.to_s : "\033[1;35;40m#{ string.to_s }\033[0m"
      end

      def cyan(string, plain: false)
        plain ? string.to_s : "\033[1;36;40m#{ string.to_s }\033[0m"
      end

      def white(string, plain: false)
        plain ? string.to_s : "\033[1;37;40m#{ string.to_s }\033[0m"
      end
    end
  end
end