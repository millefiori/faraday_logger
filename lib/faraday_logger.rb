require "faraday_logger/version"

module FaradayLogger
  class DebugPrint < Faraday::Middleware
    def on_complete env
      info('Status') { env.status.to_s + ' ' + env.url.to_s }

      log_str = <<~EOS
        --- <%= env[:status] %> <%= env[:method].upcase %> <%= env[:url] %> <%= env[:duration] %>
          <%- env[:request_headers].each do |k,v| -%>
          <%=   k %>: <%= v %>
          <%- end -%>

          <%- env[:response_headers].each do |k,v| -%>
          <%=   k %>: <%= v %>
          <%- end -%>
          <%- unless env[:body].empty? -%>

          <%=   env[:body][0, 200].inspect %>
          <%- end -%>
      EOS

      debug('Result') {
        ERB.new( "\n" + log_str, nil, '-' ).result binding
      }
    end
  end
end
