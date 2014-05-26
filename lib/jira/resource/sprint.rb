module JIRA
  module Resource

    class SprintFactory < JIRA::BaseFactory # :nodoc:
    end

    class Sprint < JIRA::Base

      # get all issues of sprint
      def issues
        jql = "sprint = " + id
        Issue.jql(client, jql)
      end

      # get rapid view id
      def agileboard_id
        search_url = client.options[:site] + "/secure/GHGoToBoard.jspa?sprintId=" + id.to_s

        begin
          response = client.get(search_url)
        rescue JIRA::HTTPError => error
          unless error.response.instance_of? Net::HTTPFound
            return
          end

          /rapidView=(\d+)&/.match(error.response['location'])[1]
        end
      end
    end

  end
end