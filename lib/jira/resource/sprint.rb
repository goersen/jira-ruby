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

      def velocity=(velocity)
        @attrs["velocity"] = velocity
      end

      def velocity
        unless attrs.keys.include? "velocity"
          @attrs["velocity"] = get_velocity
        end

        @attrs["velocity"]
      end

      private
      def get_velocity
        search_url = client.options[:site] + 
                     '/rest/greenhopper/1.0/rapid/charts/velocity.json?rapidViewId=' + agileboard_id.to_s
        begin
          response = client.get(search_url).body
        rescue
          return empty_velocity
        end

        json = self.class.parse_json(response)
        resultVelocity = json['velocityStatEntries'].select do |sprint_id|
          sprint_id.to_i == id.to_i
        end
        
        if resultVelocity.length == 0
          return empty_velocity
        end

        client.Velocity.build({
          "sprint_id" => id,
          "estimated" => resultVelocity[id.to_s]['estimated']['value'],
          "completed" => resultVelocity[id.to_s]['completed']['value']
        })
      end

      def empty_velocity
        client.Velocity.build({
          "sprint_id" => id,
          "estimated" => 0,
          "completed" => 0
        })
      end

    end
  end
end