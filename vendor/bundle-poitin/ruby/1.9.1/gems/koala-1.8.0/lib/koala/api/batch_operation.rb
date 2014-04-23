require 'koala/api'

module Koala
  module Facebook
    class GraphBatchAPI < API
      # @private
      class BatchOperation
        attr_reader :access_token, :http_options, :post_processing, :files, :batch_api, :identifier

        @identifier = 0

        def self.next_identifier
          @identifier += 1
        end

        def initialize(options = {})
          @identifier = self.class.next_identifier
          @args = (options[:args] || {}).dup # because we modify it below
          @access_token = options[:access_token]
          @http_options = (options[:http_options] || {}).dup # dup because we modify it below
          @batch_args = @http_options.delete(:batch_args) || {}
          @url = options[:url]
          @method = options[:method].to_sym
          @post_processing = options[:post_processing]

          process_binary_args

          raise AuthenticationError.new(nil, nil, "Batch operations require an access token, none provided.") unless @access_token
        end

        def to_batch_params(main_access_token)
          # set up the arguments
          args_string = Koala.http_service.encode_params(@access_token == main_access_token ? @args : @args.merge(:access_token => @access_token))

          response = {
            :method => @method.to_s,
            :relative_url => @url,
          }

          # handle batch-level arguments, such as name, depends_on, and attached_files
          @batch_args[:attached_files] = @files.keys.join(",") if @files
          response.merge!(@batch_args) if @batch_args

          # for get and delete, we append args to the URL string
          # otherwise, they go in the body
          if args_string.length > 0
            if args_in_url?
              response[:relative_url] += (@url =~ /\?/ ? "&" : "?") + args_string if args_string.length > 0
            else
              response[:body] = args_string if args_string.length > 0
            end
          end

          response
        end

        protected

        def process_binary_args
          # collect binary files
          @args.each_pair do |key, value|
            if UploadableIO.binary_content?(value)
              @files ||= {}
              # we use a class-level counter to ensure unique file identifiers across multiple batch operations
              # (this is thread safe, since we just care about uniqueness)
              # so remove the file from the original hash and add it to the file store
              id = "op#{identifier}_file#{@files.keys.length}"
              @files[id] = @args.delete(key).is_a?(UploadableIO) ? value : UploadableIO.new(value)
            end
          end
        end

        def args_in_url?
          @method == :get || @method == :delete
        end
      end
    end

    # @private
    # legacy support for when BatchOperation lived directly under Koala::Facebook
    BatchOperation = GraphBatchAPI::BatchOperation
  end
end
