require 'open3'

require_relative 'fetching_error'


module Weather
  module Fetcher
    class Wget
      def fetch(url)
        fetched_at = Time.now
        stdout, stderr, status = Open3.capture3("wget -nv -O - '#{url}'")
        raise FetchingError, 'Wget process crashed.' unless status.exited?
        raise FetchingError, 'Wget returned [%s] code with output: "%s".' % [status.exitstatus, stderr.gsub("\n", ' ').strip] unless status.success?
        return fetched_at, stdout
      end
    end
  end
end