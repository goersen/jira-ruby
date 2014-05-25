require 'spec_helper'

describe JIRA::Resource::Sprint do

  let(:client) { double("client", :options => {
                          :rest_base_path => '/jira/rest/api/2',
                          :site => 'https://example.com'
                        })
  }

  describe "relationships" do
    subject {
      JIRA::Resource::Sprint.new(client, :attrs => {
          'filter'        => {'foo' => 'bar'},
          'boardAdmin'  => {'foo' =>'bar'}
      })
    }

    it "has the correct relationships" do
      subject.should have_one(:filter, JIRA::Resource::Filter)
      subject.filter.foo.should == 'bar'

      subject.should have_one(:boardAdmin, JIRA::Resource::User)
      subject.boardAdmin.foo.should == "bar"
    end
  end

 
  describe "collection_path" do
    subject {
      JIRA::Resource::Sprint
    }

    it "should have the correct collection path" do
      collection_path = JIRA::Resource::Sprint.collection_path(client)
      collection_path.should == '/rest/greenhopper/1.0/rapidviews/list'
    end
  end

  describe "issues" do
    subject {
      JIRA::Resource::Sprint.new(client, :attrs => {
          'id'         => '42'
        })
    }

    it "returns issues" do
      response_body = '{"expand":"names,schema","startAt":0,"maxResults":1,"total":299,"issues":[{"expand":"editmeta,renderedFields,transitions,changelog,operations","id":"865585","self":"https://thisisdmg.atlassian.net/rest/api/2/issue/865585","key":"GHPOO-2728","fields":{"summary":"Touch | Produktberater | Beim ersten Mal Verändern des Jahrgangssliders wird die Ergbnissemenge nicht korrekt gesetzt.","progress":{"progress":300,"total":300,"percent":100},"issuetype":{"self":"https://thisisdmg.atlassian.net/rest/api/2/issuetype/1","id":"1","description":"A problem which impairs or prevents the functions of the product.","iconUrl":"https://thisisdmg.atlassian.net/images/icons/issuetypes/bug.png","name":"Bug","subtask":false},"timespent":300,"reporter":{"self":"https://thisisdmg.atlassian.net/rest/api/2/user?username=heinemann_c.gewalt","name":"heinemann_c.gewalt","emailAddress":"c.gewalt@nextpilgrims.com","avatarUrls":{"16x16":"https://thisisdmg.atlassian.net/secure/useravatar?size=xsmall&avatarId=10122","24x24":"https://thisisdmg.atlassian.net/secure/useravatar?size=small&avatarId=10122","32x32":"https://thisisdmg.atlassian.net/secure/useravatar?size=medium&avatarId=10122","48x48":"https://thisisdmg.atlassian.net/secure/useravatar?avatarId=10122"},"displayName":"Christian Gewalt","active":true},"created":"2014-04-02T14:02:43.000+0200","updated":"2014-04-14T16:00:37.000+0200","description":"Beim ersten Mal Verändern des Jahrgangssliders wird die Ergbnissemenge nicht korrekt gesetzt. Danach funktioniert es dann. ","priority":{"self":"https://thisisdmg.atlassian.net/rest/api/2/priority/3","iconUrl":"https://thisisdmg.atlassian.net/images/icons/priorities/major.png","name":"Major","id":"3"},"customfield_10001":"2014-04-14 16:00:37.849","customfield_10002":null,"customfield_10003":null,"issuelinks":[],"customfield_10000":"1_*:*_1_*:*_596873640_*|*_5_*:*_1_*:*_0","subtasks":[],"customfield_10008":null,"customfield_10007":null,"status":{"self":"https://thisisdmg.atlassian.net/rest/api/2/status/6","description":"The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.","iconUrl":"https://thisisdmg.atlassian.net/images/icons/statuses/closed.png","name":"Closed","id":"6","statusCategory":{"self":"https://thisisdmg.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Complete"}},"customfield_10006":"349","labels":["Kundenfeedback","TouchScreen"],"workratio":-1,"project":{"self":"https://thisisdmg.atlassian.net/rest/api/2/project/13600","id":"13600","key":"GHPOO","name":"Gebrüder Heinemann - DIA","avatarUrls":{"16x16":"https://thisisdmg.atlassian.net/secure/projectavatar?size=xsmall&pid=13600&avatarId=10011","24x24":"https://thisisdmg.atlassian.net/secure/projectavatar?size=small&pid=13600&avatarId=10011","32x32":"https://thisisdmg.atlassian.net/secure/projectavatar?size=medium&pid=13600&avatarId=10011","48x48":"https://thisisdmg.atlassian.net/secure/projectavatar?pid=13600&avatarId=10011"},"projectCategory":{"self":"https://thisisdmg.atlassian.net/rest/api/2/projectCategory/10100","id":"10100","description":"Hier finden sich alle Kundenprojekte","name":"Kunden Projekte"}},"environment":null,"lastViewed":null,"aggregateprogress":{"progress":300,"total":300,"percent":100},"customfield_10012":["com.atlassian.greenhopper.service.sprint.Sprint@1829488[rapidViewId=142,state=CLOSED,name=07.04 - 24.04,startDate=2014-04-07T13:55:52.263+02:00,endDate=2014-04-24T15:00:00.000+02:00,completeDate=2014-04-22T17:30:25.628+02:00,id=642]"],"components":[{"self":"https://thisisdmg.atlassian.net/rest/api/2/component/13904","id":"13904","name":"Technik"}],"customfield_10011":null,"timeoriginalestimate":null,"votes":{"self":"https://thisisdmg.atlassian.net/rest/api/2/issue/GHPOO-2728/votes","votes":0,"hasVoted":false},"resolution":{"self":"https://thisisdmg.atlassian.net/rest/api/2/resolution/5","id":"5","description":"All attempts at reproducing this issue failed, or not enough information was available to reproduce the issue. Reading the code produces no clues as to why this behavior would occur. If more information appears later, please reopen the issue.","name":"Cannot Reproduce"},"fixVersions":[{"self":"https://thisisdmg.atlassian.net/rest/api/2/version/15700","id":"15700","description":"Prototyp","name":"Prototyp","archived":false,"released":false}],"resolutiondate":"2014-04-09T11:50:37.000+0200","creator":{"self":"https://thisisdmg.atlassian.net/rest/api/2/user?username=heinemann_c.gewalt","name":"heinemann_c.gewalt","emailAddress":"c.gewalt@nextpilgrims.com","avatarUrls":{"16x16":"https://thisisdmg.atlassian.net/secure/useravatar?size=xsmall&avatarId=10122","24x24":"https://thisisdmg.atlassian.net/secure/useravatar?size=small&avatarId=10122","32x32":"https://thisisdmg.atlassian.net/secure/useravatar?size=medium&avatarId=10122","48x48":"https://thisisdmg.atlassian.net/secure/useravatar?avatarId=10122"},"displayName":"Christian Gewalt","active":true},"aggregatetimeoriginalestimate":null,"duedate":null,"customfield_10104":null,"customfield_10105":null,"watches":{"self":"https://thisisdmg.atlassian.net/rest/api/2/issue/GHPOO-2728/watchers","watchCount":2,"isWatching":false},"customfield_10103":null,"customfield_10102":null,"customfield_10600":"GHPOO-113","customfield_10101":null,"customfield_10100":null,"assignee":{"self":"https://thisisdmg.atlassian.net/rest/api/2/user?username=l.soeder","name":"l.soeder","emailAddress":"l.soeder@thisisdmg.com","avatarUrls":{"16x16":"https://thisisdmg.atlassian.net/secure/useravatar?size=xsmall&ownerId=l.soeder&avatarId=11302","24x24":"https://thisisdmg.atlassian.net/secure/useravatar?size=small&ownerId=l.soeder&avatarId=11302","32x32":"https://thisisdmg.atlassian.net/secure/useravatar?size=medium&ownerId=l.soeder&avatarId=11302","48x48":"https://thisisdmg.atlassian.net/secure/useravatar?ownerId=l.soeder&avatarId=11302"},"displayName":"Lars Söder","active":true},"aggregatetimeestimate":0,"versions":[{"self":"https://thisisdmg.atlassian.net/rest/api/2/version/15700","id":"15700","description":"Prototyp","name":"Prototyp","archived":false,"released":false},{"self":"https://thisisdmg.atlassian.net/rest/api/2/version/17100","id":"17100","description":"Labshop installation vom 21. März","name":"Prototyp 3. Abnahme","archived":false,"released":true,"releaseDate":"2014-03-21"}],"customfield_10700":null,"customfield_10400":null,"timeestimate":0,"customfield_10300":"Not Started","aggregatetimespent":300}}]}'
      response = double("response",
        :body => response_body)
      issue_factory = double("issue factory")

      client.should_receive(:get)
        .with('https://example.com/rest/greenhopper/1.0/xboard/work/allData/?rapidViewId=42')
        .and_return(response)
      client.should_receive(:Issue).and_return(issue_factory)
      issue_factory.should_receive(:build)
        .with(JSON.parse(response_body)["issues"][0])
      subject.issues
    end
  end

end
