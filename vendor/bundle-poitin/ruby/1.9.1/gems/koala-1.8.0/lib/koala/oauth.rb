# OpenSSL and Base64 are required to support signed_request
require 'openssl'
require 'base64'

module Koala
  module Facebook
    class OAuth
      attr_reader :app_id, :app_secret, :oauth_callback_url

      # Creates a new OAuth client.
      #
      # @param app_id [String, Integer] a Facebook application ID
      # @param app_secret a Facebook application secret
      # @param oauth_callback_url the URL in your app to which users authenticating with OAuth will be sent
      def initialize(app_id, app_secret, oauth_callback_url = nil)
        @app_id = app_id
        @app_secret = app_secret
        @oauth_callback_url = oauth_callback_url
      end

      # Parses the cookie set Facebook's JavaScript SDK.
      #
      # @note this method can only be called once per session, as the OAuth code
      #       Facebook supplies can only be redeemed once.  Your application
      #       must handle cross-request storage of this information; you can no
      #       longer call this method multiple times.  (This works out, as the
      #       method has to make a call to FB's servers anyway, which you don't
      #       want on every call.)
      #
      # @param cookie_hash a set of cookies that includes the Facebook cookie.
      #                     You can pass Rack/Rails/Sinatra's cookie hash directly to this method.
      #
      # @return the authenticated user's information as a hash, or nil.
      def get_user_info_from_cookies(cookie_hash)
        if signed_cookie = cookie_hash["fbsr_#{@app_id}"]
          parse_signed_cookie(signed_cookie)
        elsif unsigned_cookie = cookie_hash["fbs_#{@app_id}"]
          parse_unsigned_cookie(unsigned_cookie)
        end
      end
      alias_method :get_user_info_from_cookie, :get_user_info_from_cookies

      # Parses the cookie set Facebook's JavaScript SDK and returns only the user ID.
      #
      # @note (see #get_user_info_from_cookie)
      #
      # @param (see #get_user_info_from_cookie)
      #
      # @return the authenticated user's Facebook ID, or nil.
      def get_user_from_cookies(cookies)
        Koala::Utils.deprecate("Due to Facebook changes, you can only redeem an OAuth code once; it is therefore recommended not to use this method, as it will consume the code without providing you the access token. See https://developers.facebook.com/roadmap/completed-changes/#december-2012.")
        if signed_cookie = cookies["fbsr_#{@app_id}"]
          if components = parse_signed_request(signed_cookie)
            components["user_id"]
          end
        elsif info = get_user_info_from_cookies(cookies)
          # Parsing unsigned cookie
          info["uid"]
        end
      end
      alias_method :get_user_from_cookie, :get_user_from_cookies

      # URLs

      # Builds an OAuth URL, where users will be prompted to log in and for any desired permissions.
      # When the users log in, you receive a callback with their
      # See http://developers.facebook.com/docs/authentication/.
      #
      # @see #url_for_access_token
      #
      # @note The server-side authentication and dialog methods should only be used
      #       if your application can't use the Facebook Javascript SDK,
      #       which provides a much better user experience.
      #       See http://developers.facebook.com/docs/reference/javascript/.
      #
      # @param options any query values to add to the URL, as well as any special/required values listed below.
      # @option options permissions an array or comma-separated string of desired permissions
      # @option options state a unique string to serve as a CSRF (cross-site request
      #                 forgery) token -- highly recommended for security. See
      #                 https://developers.facebook.com/docs/howtos/login/server-side-login/
      #
      # @raise ArgumentError if no OAuth callback was specified in OAuth#new or in options as :redirect_uri
      #
      # @return an OAuth URL you can send your users to
      def url_for_oauth_code(options = {})
        # for permissions, see http://developers.facebook.com/docs/authentication/permissions
        if permissions = options.delete(:permissions)
          options[:scope] = permissions.is_a?(Array) ? permissions.join(",") : permissions
        end
        url_options = {:client_id => @app_id}.merge(options)

        # Creates the URL for oauth authorization for a given callback and optional set of permissions
        build_url("https://#{Koala.config.dialog_host}/dialog/oauth", true, url_options)
      end

      # Once you receive an OAuth code, you need to redeem it from Facebook using an appropriate URL.
      # (This is done by your server behind the scenes.)
      # See http://developers.facebook.com/docs/authentication/.
      #
      # @see #url_for_oauth_code
      #
      # @note (see #url_for_oauth_code)
      #
      # @param code an OAuth code received from Facebook
      # @param options any additional query parameters to add to the URL
      #
      # @raise (see #url_for_oauth_code)
      #
      # @return an URL your server can query for the user's access token
      def url_for_access_token(code, options = {})
        # Creates the URL for the token corresponding to a given code generated by Facebook
        url_options = {
          :client_id => @app_id,
          :code => code,
          :client_secret => @app_secret
        }.merge(options)
        build_url("https://#{Koala.config.graph_server}/oauth/access_token", true, url_options)
      end

      # Builds a URL for a given dialog (feed, friends, OAuth, pay, send, etc.)
      # See http://developers.facebook.com/docs/reference/dialogs/.
      #
      # @note (see #url_for_oauth_code)
      #
      # @param dialog_type the kind of Facebook dialog you want to show
      # @param options any additional query parameters to add to the URL
      #
      # @return an URL your server can query for the user's access token
      def url_for_dialog(dialog_type, options = {})
        # some endpoints require app_id, some client_id, supply both doesn't seem to hurt
        url_options = {:app_id => @app_id, :client_id => @app_id}.merge(options)
        build_url("http://#{Koala.config.dialog_host}/dialog/#{dialog_type}", true, url_options)
      end

      # Generates a 'client code' from a server side long-lived access token. With the generated
      # code, it can be sent to a client application which can then use it to get a long-lived
      # access token from Facebook. After which the clients can use that access token to make
      # requests to Facebook without having to use the server token, yet the server access token
      # remains valid.
      # See https://developers.facebook.com/docs/facebook-login/access-tokens/#long-via-code
      #
      # @param access_token a user's long lived (server) access token
      #
      # @raise Koala::Facebook::ServerError if Facebook returns a server error (status >= 500)
      # @raise Koala::Facebook::OAuthTokenRequestError if Facebook returns an error response (status >= 400)
      # @raise Koala::Facebook::BadFacebookResponse if Facebook returns a blank response
      # @raise Koala::KoalaError if response does not contain 'code' hash key
      #
      # @return a string of the generated 'code'
      def generate_client_code(access_token)
        response = fetch_token_string({:redirect_uri => @oauth_callback_url, :access_token => access_token}, false, 'client_code')

        # Facebook returns an empty body in certain error conditions
        if response == ''
          raise BadFacebookResponse.new(200, '', 'generate_client_code received an error: empty response body')
        else
          result = MultiJson.load(response)
        end

        result.has_key?('code') ? result['code'] : raise(Koala::KoalaError.new("Facebook returned a valid response without the expected 'code' in the body (response = #{response})"))
      end

      # access tokens

      # Fetches an access token, token expiration, and other info from Facebook.
      # Useful when you've received an OAuth code using the server-side authentication process.
      # @see url_for_oauth_code
      #
      # @note (see #url_for_oauth_code)
      #
      # @param code (see #url_for_access_token)
      # @param options any additional parameters to send to Facebook when redeeming the token
      #
      # @raise Koala::Facebook::OAuthTokenRequestError if Facebook returns an error response
      #
      # @return a hash of the access token info returned by Facebook (token, expiration, etc.)
      def get_access_token_info(code, options = {})
        # convenience method to get a parsed token from Facebook for a given code
        # should this require an OAuth callback URL?
        get_token_from_server({:code => code, :redirect_uri => options[:redirect_uri] || @oauth_callback_url}, false, options)
      end


      # Fetches the access token (ignoring expiration and other info) from Facebook.
      # Useful when you've received an OAuth code using the server-side authentication process.
      # @see get_access_token_info
      #
      # @note (see #url_for_oauth_code)
      #
      # @param (see #get_access_token_info)
      #
      # @raise (see #get_access_token_info)
      #
      # @return the access token
      def get_access_token(code, options = {})
        # upstream methods will throw errors if needed
        if info = get_access_token_info(code, options)
          string = info["access_token"]
        end
      end

      # Fetches the application's access token, along with any other information provided by Facebook.
      # See http://developers.facebook.com/docs/authentication/ (search for App Login).
      #
      # @param options any additional parameters to send to Facebook when redeeming the token
      #
      # @return the application access token and other information (expiration, etc.)
      def get_app_access_token_info(options = {})
        # convenience method to get a the application's sessionless access token
        get_token_from_server({:grant_type => 'client_credentials'}, true, options)
      end

      # Fetches the application's access token (ignoring expiration and other info).
      # @see get_app_access_token_info
      #
      # @param (see #get_app_access_token_info)
      #
      # @return the application access token
      def get_app_access_token(options = {})
        if info = get_app_access_token_info(options)
          string = info["access_token"]
        end
      end

      # Fetches an access_token with extended expiration time, along with any other information provided by Facebook.
      # See https://developers.facebook.com/docs/offline-access-deprecation/#extend_token (search for fb_exchange_token).
      #
      # @param access_token the access token to exchange
      # @param options any additional parameters to send to Facebook when exchanging tokens.
      #
      # @return the access token with extended expiration time and other information (expiration, etc.)
      def exchange_access_token_info(access_token, options = {})
        get_token_from_server({
          :grant_type => 'fb_exchange_token',
          :fb_exchange_token => access_token
        }, true, options)
      end

      # Fetches an access token with extended expiration time (ignoring expiration and other info).

      # @see exchange_access_token_info
      #
      # @param (see #exchange_access_token_info)
      #
      # @return A new access token or the existing one, set to expire in 60 days.
      def exchange_access_token(access_token, options = {})
        if info = exchange_access_token_info(access_token, options)
          info["access_token"]
        end
      end

      # Parses a signed request string provided by Facebook to canvas apps or in a secure cookie.
      #
      # @param input the signed request from Facebook
      #
      # @raise OAuthSignatureError if the signature is incomplete, invalid, or using an unsupported algorithm
      #
      # @return a hash of the validated request information
      def parse_signed_request(input)
        encoded_sig, encoded_envelope = input.split('.', 2)
        raise OAuthSignatureError, 'Invalid (incomplete) signature data' unless encoded_sig && encoded_envelope

        signature = base64_url_decode(encoded_sig).unpack("H*").first
        envelope = MultiJson.load(base64_url_decode(encoded_envelope))

        raise OAuthSignatureError, "Unsupported algorithm #{envelope['algorithm']}" if envelope['algorithm'] != 'HMAC-SHA256'

        # now see if the signature is valid (digest, key, data)
        hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, @app_secret, encoded_envelope)
        raise OAuthSignatureError, 'Invalid signature' if (signature != hmac)

        envelope
      end

      # Old session key code

      # @deprecated Facebook no longer provides session keys.
      def get_token_info_from_session_keys(sessions, options = {})
        Koala::Utils.deprecate("Facebook no longer provides session keys. The relevant OAuth methods will be removed in the next release.")

        # fetch the OAuth tokens from Facebook
        response = fetch_token_string({
          :type => 'client_cred',
          :sessions => sessions.join(",")
        }, true, "exchange_sessions", options)

        # Facebook returns an empty body in certain error conditions
        if response == ""
          raise BadFacebookResponse.new(200, '', "get_token_from_session_key received an error (empty response body) for sessions #{sessions.inspect}!")
        end

        MultiJson.load(response)
      end

      # @deprecated (see #get_token_info_from_session_keys)
      def get_tokens_from_session_keys(sessions, options = {})
        # get the original hash results
        results = get_token_info_from_session_keys(sessions, options)
        # now recollect them as just the access tokens
        results.collect { |r| r ? r["access_token"] : nil }
      end

      # @deprecated (see #get_token_info_from_session_keys)
      def get_token_from_session_key(session, options = {})
        # convenience method for a single key
        # gets the overlaoded strings automatically
        get_tokens_from_session_keys([session], options)[0]
      end

      protected

      def get_token_from_server(args, post = false, options = {})
        # fetch the result from Facebook's servers
        response = fetch_token_string(args, post, "access_token", options)
        parse_access_token(response)
      end

      def parse_access_token(response_text)
        components = response_text.split("&").inject({}) do |hash, bit|
          key, value = bit.split("=")
          hash.merge!(key => value)
        end
        components
      end

      def parse_unsigned_cookie(fb_cookie)
        # remove the opening/closing quote
        fb_cookie = fb_cookie.gsub(/\"/, "")

        # since we no longer get individual cookies, we have to separate out the components ourselves
        components = {}
        fb_cookie.split("&").map {|param| param = param.split("="); components[param[0]] = param[1]}

        # generate the signature and make sure it matches what we expect
        auth_string = components.keys.sort.collect {|a| a == "sig" ? nil : "#{a}=#{components[a]}"}.reject {|a| a.nil?}.join("")
        sig = Digest::MD5.hexdigest(auth_string + @app_secret)
        sig == components["sig"] && (components["expires"] == "0" || Time.now.to_i < components["expires"].to_i) ? components : nil
      end

      def parse_signed_cookie(fb_cookie)
        components = parse_signed_request(fb_cookie)
        if code = components["code"]
          begin
            token_info = get_access_token_info(code, :redirect_uri => '')
          rescue Koala::Facebook::OAuthTokenRequestError => err
            if err.fb_error_type == 'OAuthException' && err.fb_error_message =~ /Code was invalid or expired/
              return nil
            else
              raise
            end
          end

          components.merge(token_info) if token_info
        else
          Koala::Utils.logger.warn("Signed cookie didn't contain Facebook OAuth code! Components: #{components}")
          nil
        end
      end

      def fetch_token_string(args, post = false, endpoint = "access_token", options = {})
        response = Koala.make_request("/oauth/#{endpoint}", {
          :client_id => @app_id,
          :client_secret => @app_secret
        }.merge!(args), post ? "post" : "get", {:use_ssl => true}.merge!(options))

        raise ServerError.new(response.status, response.body) if response.status >= 500
        raise OAuthTokenRequestError.new(response.status, response.body) if response.status >= 400

        response.body
      end

      # base 64
      # directly from https://github.com/facebook/crypto-request-examples/raw/master/sample.rb
      def base64_url_decode(str)
        str += '=' * (4 - str.length.modulo(4))
        Base64.decode64(str.tr('-_', '+/'))
      end

      def build_url(base, require_redirect_uri = false, url_options = {})
        if require_redirect_uri && !(url_options[:redirect_uri] ||= url_options.delete(:callback) || @oauth_callback_url)
          raise ArgumentError, "build_url must get a callback either from the OAuth object or in the parameters!"
        end

        "#{base}?#{Koala::HTTPService.encode_params(url_options)}"
      end
    end
  end
end
