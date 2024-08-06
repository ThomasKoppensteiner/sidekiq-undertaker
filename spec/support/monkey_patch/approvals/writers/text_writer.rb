
require "approvals/writer"

module Approvals
  module Writers
    class TextWriter

      # HINT: Monkey patch TextWriter to replace nonce value
      alias_method :orig_format, :format
      def format(data)
        formated_data = orig_format(data)
        replace_nonce(formated_data)
      end

      private

      def replace_nonce(data)
        data.gsub(/nonce="(.*)"/, 'nonce="<nonce>"')
      end
    end
  end
end
