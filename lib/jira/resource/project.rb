module JIRA
  module Resource

    class ProjectFactory < JIRA::BaseFactory # :nodoc:
    end

    class Project < JIRA::Base

      has_one :lead, :class => JIRA::Resource::User
      has_many :components
      has_many :issuetypes, :attribute_key => 'issueTypes'
      has_many :versions

      def self.key_attribute
        :key
      end

      # Returns all the issues for this project
      def issues(options={})
        search_url = client.options[:rest_base_path] + '/search'
        query_params = {:jql => "project=\"#{key}\""}
        query_params.update Base.query_params_for_search(options)
        response = client.get(url_with_query_params(search_url, query_params))
        json = self.class.parse_json(response.body)
        json['issues'].map do |issue|
          client.Issue.build(issue)
        end
      end

      # Returns all sprints for this project
      def sprints
        search_url = client.options[:site] + 
                     '/rest/greenhopper/1.0/integration/teamcalendars/sprint/list?jql=project=' + key

        response = client.get(search_url)
        json = self.class.parse_json(response.body)

        json["sprints"].map do |sprint|
          client.Sprint.build(sprint)
        end
      end

    end
  end
end
