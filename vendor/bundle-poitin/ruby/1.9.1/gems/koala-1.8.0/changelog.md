v1.8.0
=========

NOTE: Due to updates to underlying gems, new versions of Koala no longer work
with Ruby 1.8.x, rbx/jruby in 1.8 mode, and Ruby 1.9.2. Earlier versions will,
of course, continue to work, since the underlying Facebook API remains the
same.

If you, tragically, find yourself stuck using these old versions, you may be
able to get Koala to work by adding proper constraints to your Gemfile. Good
luck.

New methods:
* OAuth#generate_client_code lets you get long-lived user tokens for client apps (thanks, binarygeek!)

Updated methods:
* API#new now takes an optional access_token, which will be used to generate
  the appsecret_proof parameters ([thanks,
  nchelluri!](https://github.com/arsduo/koala/pull/323))
* GraphCollection#next_page and #previous_page can now take additional
  parameters ([thanks, gacha!](https://github.com/arsduo/koala/pull/330))

Internal Improvements:
* FIXED: TestUser#delete_all will avoid infinite loops if the user hashes
  change ([thanks, chunkerchunker!](https://github.com/arsduo/koala/pull/331))
* CHANGED: Koala now properly uploads Tempfiles like Files, detecting mime type (thanks, ys!)
* CHANGED: Koala now only passes valid Faraday options, improving compatibility with 0.9 (thanks, lsimoneau!)
* FIXED: RealtimeUpdates#validate_update now raise a proper error if secret is missing (thanks, theosp!)

Testing improvements:
* Fixed RSpec deprecations (thanks, sanemat!)

v1.7
====

New methods:
* API#debug_token allows you to examine user tokens (thanks, Cyril-sf!)
* Koala.config allows you to set Facebook servers (to use proxies, etc.) (thanks, bnorton!)

Internal improvements:
* CHANGED: Parameters can now be Arrays of non-enumerable values, which get comma-separated (thanks, csaunders!)
* CHANGED: API#put_wall_post now automatically encodes parameters hashes as JSON
* CHANGED: GraphCollections returned by batch API calls retain individual access tokens (thanks, billvieux!)
* CHANGED: Gem version restrictions have been removed, and versions updated.
* CHANGED: How support files are loaded in spec_helper has been improved.
* FIXED: API#get_picture returns nil if FB returns no result, rather than error (thanks, mtparet!)
* FIXED: Koala now uses the right grant_type value for fetching app access tokens (thanks, miv!)
* FIXED: Koala now uses the modern OAuth endpoint for generating codes (thanks, jayeff!)
* FIXED: Misc small fixes, typos, etc. (thanks, Ortuna, Crunch09, sagarbommidi!)

Testing improvements:
* FIXED: MockHTTPService compares Ruby objects rather than strings.
* FIXED: Removed deprecated usage of should_not_receive.and_return (thanks, Cyril-sf!)
* FIXED: Test suite now supports Typhoeus 0.5 (thanks, Cyril-sf!)
* CHANGED: Koala now tests against Ruby 2.0 on Travis (thanks, sanemat!)

v1.6
====

New methods:
* RealtimeUpdates#validate_update to validate the signature of a Facebook call (thanks, gaffo!)

Updated methods:
* Graph API methods now accepts a post processing block, see readme for examples (thanks, wolframarnold!)

Internal improvements:
* Koala now returns more specific and useful error classes (thanks, archfear!)
* Switched URL parsing to addressable, which can handle unusual FB URLs (thanks, bnorton!)
* Fixed Batch API bug that seems to have broken calls requiring post-processing
* Bump Faraday requirement to 0.8 (thanks, jarthod!)
* Picture and video URLs now support unicode characters (thanks, jayeff!)

Testing improvements:
* Cleaned up some test suites (thanks, bnorton!)

Documentation:
* Changelog is now markdown
* Code highlighting in readme (thanks, sfate!)
* Added Graph API explorer link in readme (thanks, jch!)
* Added permissions example for OAuth (thanks, sebastiandeutsch!)

v1.5
====

New methods:
* Added Koala::Utils.logger to enable debugging (thanks, KentonWhite!)
* Expose fb_error_message and fb_error_code directly in APIError

Updated methods:
* GraphCollection.parse_page_url now uses the URI library and can parse any address (thanks, bnorton!)

Internal improvements:
* Update MultiJson dependency to support the Oj library (thanks, eckz and zinenko!)
* Loosened Faraday dependency (thanks, rewritten and romanbsd!)
* Fixed typos (thanks, nathanbertram!)
* Switched uses of put_object to the more semantically accurate put_connections
* Cleaned up gemspec
* Handle invalid batch API responses better

Documentation:
* Added HTTP Services description for Faraday 0.8/persistent connections (thanks, romanbsd!)
* Remove documentation of the old pre-1.2 HTTP Service options

v1.4.1
=======

* Update MultiJson to 1.3 and change syntax to silence warnings (thanks, eckz and masterkain!)

v1.4
====

New methods:
* OAuth#exchange_access_token(_info) allows you to extend access tokens you receive (thanks, etiennebarrie!)

Updated methods:
* HTTPServices#encode_params sorts parameters to aid in URL comparison (thanks, sholden!)
* get_connections is now aliased as get_connection (use whichever makes sense to you)

Internal improvements:
* Fixed typos (thanks, brycethornton and jpemberthy!)
* RealtimeUpdates will no longer execute challenge block unnecessarily (thanks, iainbeeston!)

Testing improvements:
* Added parallel_tests to development gem file
* Fixed failing live tests
* Koala now tests against JRuby and Rubinius in 1.9 mode on Travis-CI

v1.3
====

New methods:
* OAuth#url_for_dialog creates URLs for Facebook dialog pages
* API#set_app_restrictions handles JSON-encoding app restrictions
* GraphCollection.parse_page_url now exposes useful functionality for non-Rails apps
* RealtimeUpdates#subscription_path and TestUsers#test_user_accounts_path are now public

Updated methods:
* REST API methods are now deprecated (see http://developers.facebook.com/blog/post/616/)
* OAuth#url_for_access_token and #url_for_oauth_code now include any provided options as URL parameters
* APIError#raw_response allows access to the raw error response received from Facebook
* Utils.deprecate only prints each message once (no more spamming)
* API#get_page_access_token now accepts additional arguments and HTTP options (like other calls)
* TestUsers and RealtimeUpdates methods now take http_options arguments
* All methods with http_options can now take :http_component => :response for the complete response
* OAuth#get_user_info_from_cookies returns nil rather than an error if the cookies are expired (thanks, herzio)
* TestUsers#delete_all now uses the Batch API and is much faster

Internal improvements:
* FQL queries now use the Graph API behind-the-scenes
* Cleaned up file and class organization, with aliases for backward compatibility
* Added YARD documentation throughout
* Fixed bugs in RealtimeUpdates, TestUsers, elsewhere
* Reorganized file and class structure non-destructively

Testing improvements:
* Expanded/improved test coverage
* The test suite no longer users any hard-coded user IDs
* KoalaTest.test_user_api allows access to the TestUsers instance
* Configured tests to run in random order using RSpec 2.8.0rc1

v1.2.1
======

New methods:
* RestAPI.set_app_properties handles JSON-encoding application properties

Updated methods:
* OAuth.get_user_from_cookie works with the new signed cookie format (thanks, gmccreight!)
* Beta server URLs are now correct
* OAuth.parse_signed_request now raises an informative error if the signed_request is malformed

Internal improvements:
* Koala::Multipart middleware properly encoding nested parameters (hashes) in POSTs
* Updated readme, changelog, etc.

Testing improvements:
* Live tests with test users now clean up all fake users they create
* Removed duplicate test cases
* Live tests with test users no longer delete each object they create, speeding things up

v1.2
====

New methods:
* API is now the main API class, contains both Graph and REST methods
  * Old classes are aliased with deprecation warnings (non-breaking change)
* TestUsers#update lets you update the name or password of an existing test user
* API.get_page_access_token lets you easily fetch the access token for a page you manage (thanks, marcgg!)
* Added version.rb (Koala::VERSION)

Updated methods:
* OAuth now parses Facebook's new signed cookie format
* API.put_picture now accepts URLs to images (thanks, marcgg!)
* Bug fixes to put_picture, parse_signed_request, and the test suite (thanks, johnbhall and Will S.!)
* Smarter GraphCollection use
  * Any pageable result will now become a GraphCollection
  * Non-pageable results from get_connections no longer error
  * GraphCollection.raw_results allows access to original result data
* Koala no longer enforces any limits on the number of test users you create at once

Internal improvements:
* Koala now uses Faraday to make requests, replacing the HTTPServices (see wiki)
  * Koala::HTTPService.http_options allows specification of default Faraday connection options
  * Koala::HTTPService.faraday_middleware allows custom middleware configurations
  * Koala now defaults to Net::HTTP rather than Typhoeus
  * Koala::NetHTTPService and Koala::TyphoeusService modules no longer exist
  * Koala no longer automatically switches to Net::HTTP when uploading IO objects to Facebook
* RealTimeUpdates and TestUsers are no longer subclasses of API, but have their own .api objects
  * The old .graph_api accessor is aliases to .api with a deprecation warning
* Removed deprecation warnings for pre-1.1 batch interface

Testing improvements:
* Live test suites now run against test users by default
  * Test suite can be repeatedly run live without having to update facebook_data.yml
  * OAuth code and session key tests cannot be run against test users
* Faraday adapter for live tests can be specified with ADAPTER=[your adapter] in the rspec command
* Live tests can be run against the beta server by specifying BETA=true in the rspec command
* Tests now pass against all rubies on Travis CI
* Expanded and refactored test coverage
* Fixed bug with YAML parsing in Ruby 1.9

v1.1
====

New methods:
* Added Batch API support (thanks, seejohnrun and spiegela!)
  * includes file uploads, error handling, and FQL
* Added GraphAPI#put_video
* Added GraphAPI#get_comments_for_urls (thanks, amrnt!)
* Added RestAPI#fql_multiquery, which simplifies the results (thanks, amrnt!)
* HTTP services support global proxy and timeout settings (thanks, itchy!)
* Net::HTTP supports global ca_path, ca_file, and verify_mode settings (thanks, spiegela!)

Updated methods:
* RealtimeUpdates now uses a GraphAPI object instead of its own API
* RestAPI#rest_call now has an optional last argument for method, for calls requiring POST, DELETE, etc. (thanks, sshilo!)
* Filename can now be specified when uploading (e.g. for Ads API) (thanks, sshilo!)
* get_objects([]) returns [] instead of a Facebook error in non-batch mode (thanks, aselder!)

Internal improvements:
* Koala is now more compatible with other Rubies (JRuby, Rubinius, etc.)
* HTTP services are more modular and can be changed on the fly (thanks, chadk!)
  * Includes support for uploading StringIOs and other non-files via Net::HTTP even when using TyphoeusService
* Koala now uses multi_json to improve compatibility with Rubinius and other Ruby versions
* Koala now uses the modern Typhoeus API (thanks, aselder!)
* Koala now uses the current modern Net::HTTP interface (thanks, romanbsd!)
* Fixed bugs and typos (thanks, waynn, mokevnin, and tikh!)

v1.0
====

New methods:
* Photo and file upload now supported through #put_picture
  * Added UploadableIO class to manage file uploads
* Added a delete_like method (thanks to waseem)
* Added put_connection and delete_connection convenience methods

Updated methods:
* Search can now search places, checkins, etc. (thanks, rickyc!)
* You can now pass :beta => true in the http options to use Facebook's beta tier
* TestUser#befriend now requires user info hashes (id and access token) due to Facebook API changes (thanks, pulsd and kbighorse!)
* All methods now accept an http_options hash as their optional last parameter (thanks, spiegela!)
* url_for_oauth_code can now take a :display option (thanks, netbe!)
* Net::HTTP can now accept :timeout and :proxy options (thanks, gilles!)
* Test users now supports using test accounts across multiple apps

Internal improvements:
* For public requests, Koala now uses http by default (instead of https) to improve speed
  * This can be overridden through Koala.always_use_ssl= or by passing :use_ssl => true in the options hash for an api call
* Read-only REST API requests now go through the faster api-read server
* Replaced parse_signed_request with a version from Facebook that also supports the new signed params proposal
  * Note: invalid requests will now raise exceptions rather than return nil, in keeping with other SDKs
* Delete methods will now raise an error if there's no access token (like put_object and delete_like)
* Updated parse_signed_request to match Facebook's current implementation (thanks, imajes!)
* APIError is now < StandardError, not Exception
* Added KoalaError for non-API errors
* Net::HTTP's SSL verification is no longer disabled by default

Test improvements:
* Incorporated joshk's awesome rewrite of the entire Koala test suite (thanks, joshk!)
* Expanded HTTP service tests (added Typhoeus test suite and additional Net::HTTP test cases)
* Live tests now verify that the access token has the necessary permissions before starting
* Replaced the 50-person network test, which often took 15+ minutes to run live, with a 5-person test

v0.10.0
=======

* Added test user module
* Fixed bug when raising APIError after Facebook fails to exchange session keys
* Made access_token accessible via the readonly access_token property on all our API classes

v0.9.1
======

* Tests are now compatible with Ruby 1.9.2
* Added JSON to runtime dependencies
* Removed examples directory (referenced from github instead)

v0.9.0
======

* Added parse_signed_request to handle Facebook's new authentication scheme
  * note: creates dependency on OpenSSL (OpenSSL::HMAC) for decryption
* Added GraphCollection class to provide paging support for GraphAPI get_connections and search methods (thanks to jagthedrummer)
* Added get_page method to easily fetch pages of results from GraphCollections
* Exchanging sessions for tokens now works properly when provided invalid/expired session keys
* You can now include a :typhoeus_options key in TyphoeusService#make_request's options hash to control the Typhoeus call (for example, to set :disable_ssl_peer_verification => true)
* All paths provided to HTTP services start with leading / to improve compatibility with stubbing libraries
* If Facebook returns nil for search or get_connections requests, Koala now returns nil rather than throwing an exception

v0.8.0
======

* Breaking interface changes
  * Removed string overloading for the methods, per 0.7.3, which caused Marshaling issues
  * Removed ability to provide a string as the second argument to url_for_access_token, per 0.5.0

v0.7.4
======

* Fixed bug with get_user_from_cookies

v0.7.3
======

* Added support for picture sizes -- thanks thhermansen for the patch!
* Adjusted the return values for several methods (get_access_token, get_app_access_token, get_token_from_session_key, get_tokens_from_session_keys, get_user_from_cookies)
  * These methods now return strings, rather than hashes, which makes more sense
  * The strings are overloaded with an [] method for backwards compatibility (Ruby is truly amazing)
    * Using those methods triggers a deprecation warning
    * This will be removed by 1.0
  * There are new info methods (get_access_token_info, get_app_access_token_info, get_token_info_from_session_keys, and get_user_info_from_cookies) that natively return hashes, for when you want the expiration date
* Responses with HTTP status 500+ now properly throw errors under Net::HTTP
* Updated changelog
* Added license

v0.7.2
======

* Added support for exchanging session keys for OAuth access tokens (get_token_from_session_key for single keys, get_tokens_from_session_keys for multiple)
* Moved Koala files into a koala/ subdirectory to minimize risk of name collisions
* Added OAuth Playground git submodule as an example
* Updated tests, readme, and changelog

v0.7.1
======

* Updated RealtimeUpdates#list_subscriptions and GraphAPI#get_connections to now return an
array of results directly (rather than a hash with one key)
* Fixed a bug with Net::HTTP-based HTTP service in which the headers hash was improperly formatted
* Updated readme

v0.7.0
======

* Added RealtimeUpdates class, which can be used to manage subscriptions for user updates (see http://developers.facebook.com/docs/api/realtime)
* Added picture method to graph API, which fetches an object's picture from the redirect headers.
* Added _greatly_ improved testing with result mocking, which is now the default set of tests
* Renamed live testing spec to koala_spec_without_mocks.rb
* Added Koala::Response class, which encapsulates HTTP results since Facebook sometimes sends data in the status or headers
* Much internal refactoring
* Updated readme, changelog, etc.

v0.6.0
======

* Added support for the old REST API thanks to cbaclig's great work
* Updated tests to conform to RSpec standards
* Updated changelog, readme, etc.

v0.5.1
======

* Documentation is now on the wiki, updated readme accordingly.

v0.5.0
======

* Added several new OAuth methods for making and parsing access token requests
* Added test suite for the OAuth class
* Made second argument to url_for_access_token a hash (strings still work but trigger a deprecation warning)
* Added fields to facebook_data.yml
* Updated readme

v0.4.1
======

* Encapsulated GraphAPI and OAuth classes in the Koala::Facebook module for clarity (and to avoid claiming the global Facebook class)
* Moved make_request method to Koala class from GraphAPI instance (for use by future OAuth class functionality)
* Renamed request method to api for consistancy with Javascript library
* Updated tests and readme

v0.4.0
======

* Adopted the Koala name
* Updated readme and tests
* Fixed cookie verification bug for non-expiring OAuth tokens

v0.3.1
======

* Bug fixes.

v0.3
====

* Renamed Graph API class from Facebook::GraphAPI to FacebookGraph::API
* Created FacebookGraph::OAuth class for tokens and OAuth URLs
* Updated method for including HTTP service (think we've got it this time)
* Updated tests
* Added CHANGELOG and gemspec

v0.2
====

* Gemified the project
* Split out HTTP services into their own file, and adjusted inclusion method

v0.1
====

* Added modular support for Typhoeus
* Added tests

v0.0
====

* Hi from F8!  Basic read/write from the graph is working
