module JIRA
  module Resource

    class AgileboardFactory < JIRA::BaseFactory # :nodoc:
    end

    class Agileboard < JIRA::Base
      has_one :filter
      has_one :boardAdmin, :class => JIRA::Resource::User

      # override population for different responses from jira
      def self.populate(client, options, json)
        if json['views']
          json = json['views']
        end

        super
      end

      # override collection path for different API endpoint
      def self.collection_path(client, prefix = '/')
         '/rest/greenhopper/1.0/rapidviews/list'
      end

      # get all issues of agile board
      def issues
        search_url = client.options[:site] + 
                     '/rest/greenhopper/1.0/xboard/work/allData/?rapidViewId=' + attrs['id'].to_s

        response = client.get(search_url)
        json = self.class.parse_json(response.body)
        json['issues'].map do |issue|
          client.Issue.build(issue)
        end
      end

      # get all sprints of agile board
      def sprints
        search_url = client.options[:site] + '/rest/greenhopper/1.0/sprintquery/' + attrs['id'].to_s
        response = client.get(search_url)
        json = self.class.parse_json(response.body)

        vels = velocities
        json['sprints'].map do |sprint|
          velocity = vels.select { |vel| vel.sprint_id.to_s == sprint["id"].to_s }.first
          sprint["velocity"] = velocity
          client.Sprint.build(sprint)
        end
      end
      
    end
  end
end