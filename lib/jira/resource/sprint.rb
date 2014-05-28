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

          rapid_view_match = /rapidView=(\d+)&/.match(error.response['location'])
          if rapid_view_match != nil
            return rapid_view_match[1]
          end
        end
      end

      def sprint_report
        if @sprint_report
          return @sprint_report
        end

        search_url = client.options[:site] + "/rest/greenhopper/1.0/rapid/charts/sprintreport?rapidViewId=" + 
                     agileboard_id.to_s + "&sprintId=" + id.to_s

        response = client.get(search_url)
        json = self.class.parse_json(response.body)

        client.SprintReport.build(json['contents'])
      end

    end
  end
end
