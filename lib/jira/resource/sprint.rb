module JIRA
  module Resource

    class SprintFactory < JIRA::BaseFactory # :nodoc:
    end

    class Sprint < JIRA::Base
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

      # get all issues of sprint
      def issues(options={})
        search_url = client.options[:site] + '/rest/greenhopper/1.0/xboard/work/allData/?rapidViewId=' + attrs['id']
        response = client.get(url_with_query_params(search_url, {}))
        json = self.class.parse_json(response.body)
        json['issues'].map do |issue|
          client.Issue.build(issue)
        end
      end
    end

  end
end