@vcr
Feature: Admins can import project from Pivotal Tracker via its API
  Background:
    Given the following users exist:
      | email                | name             | initials | username | admin |
      | micah@botandrose.com | Micah Geisel     | MG       | micahg   | Yes   | 
      | gubs@botandrose.com  | Michael Gubitosa | GUBS     | gubs     | Yes   | 

  Scenario: Admin imports a project from Pivotal Tracker
    Given I am logged in as "micah@botandrose.com"
    When I follow "Refresh"
    Then I should see the following importable projects:
      | AC Community Connections                |
      | Adapt2Play                              |
      | ARBOR Telehealth                        |
      | Art & Space Staging                     |
      | BARD gem                                |
      | Brian Porter                            |
      | Complexity Explorer                     |
      | David Rumsey                            |
      | David Rumsey - Interactive Walk-through |
      | David Rumsey - Terra                    |
      | Eboshi                                  |
      | Helga Van Helgenwagen                   |
      | JHU - Lives Saved                       |
      | Joseph Holmes                           |
      | K-State CMS                             |
      | METRC - NSAID                           |
      | METRC - NSAID Adjudication Sites        |
      | METRC - POvIV2                          |
      | METRC.ORG                               |
      | MIMIC                                   |
      | PALS                                    |
      | PEP                                     |
      | PEP - Diabetes                          |
      | Portland Duplex                         |
      | REC                                     |
      | Red Hat CMS                             |
      | REPAIR                                  |
      | Riverwest24                             |
      | Sharebears                              |
      | SMH Casting                             |
      | Take Charge                             |
      | TSN                                     |
      | Vagrant VM                              |

    When I follow "Import project" within the "Adapt2Play" pivotal project with a 600 second timeout
    Then I should see "Import from Pivotal Tracker"
    And I should see the following project import results:
      | Resource    | Count      |
      | Project     | ✓          |
      | Users       | 3 / 3      |
      | Stories     | 84 / 84    |
      | Tasks       | 0 / 0      |
      | Comments    | 308 / 308  |
      | Attachments | 41 / 41    |
      | Activities  | 988 / 1026 |

    And "micah@botandrose.com" should receive no emails
    And "gubs@botandrose.com" should receive no emails
    And "lindsaycaron37@gmail.com" should receive no emails

    When I follow "Visit imported project" with a 10 second timeout
    Then I should see the following project board:
      | Done                                                                                                               | Current                                                                                        | Icebox                                                                                   |
      | C Proposal gubs                                                                                                    | F Optimize for mobile gubs                                                                     | F Show linked calendars on Organizations gubs start                                      |
      | C Create project MG                                                                                                | B About Page: wrong Insta Link gubs                                                            | F Update site fonts? gubs start                                                          |
      | C Get calagator running on current Ubuntu Linux MG                                                                 | F New homepage gubs                                                                            | C Transfer disabilityinspiration.com registration from Wordpress to Cloudflare? MG start |
      | C Set up AWS account MG                                                                                            | F Add "Organization Name" field to events gubs                                                 | C Open source? LC start                                                                  |
      | C Set up DNS MG                                                                                                    | F Some way to solicit feedback from users gubs                                                 |                                                                                          |
      | R Deploy Calagator instance to production server MG                                                                | B When I share an event, the image displayed is the sponsor listed in the margin. gubs         |                                                                                          |
      | C Move pink slip to Lindsay's drive folder LC                                                                      | B Multiple Events on a Day UX gubs                                                             |                                                                                          |
      | C Migrate spreadsheet over to stories here gubs                                                                    | F Re-calibrate search distance options MG finish                                               |                                                                                          |
      | C Update to Rails 7 and Ruby 3.2 MG                                                                                | B Clone function no bueno MG finish                                                            |                                                                                          |
      | C Get calagator tests passing in CI MG                                                                             | F Basic organization create / edit / delete functionality MG finish                            |                                                                                          |
      | C Decide on The Blox Show LC                                                                                       | F Organizations can add events from iCal URL gubs start                                        |                                                                                          |
      | C Paying Bot and Rose gubs                                                                                         | R MVP - Present at Wellness Business Networking Event start                                    |                                                                                          |
      | C If the URL does not literally state the resource, how can it still show up towards the top of Google Results? LC | F Do we actually need the event sorting? LC start                                              |                                                                                          |
      | C Survey to send to Adaptive Athletes for appropriate name options LC                                              | F Show associated events on Organizations gubs start                                           |                                                                                          |
      | C Switch to dartsass MG                                                                                            | F Masthead slideshow? LC start                                                                 |                                                                                          |
      | F Redirect all other domains to adapt2play.org MG                                                                  | F Require valid address for creating an event MG start                                         |                                                                                          |
      | B mockup_form_for not working MG                                                                                   | F Patreon: Yes please! LC start                                                                |                                                                                          |
      | B link_to_current not working MG                                                                                   | F Delete orphaned tags MG start                                                                |                                                                                          |
      | B bard data broken MG                                                                                              | F Add "Organized by" prefix text to organization name on event index and show views gubs start |                                                                                          |
      | F Design application layout gubs                                                                                   | F Change "export" buttons' texts gubs start                                                    |                                                                                          |
      | B Can't deploy MG                                                                                                  | F Use taggle for event tags MG start                                                           |                                                                                          |
      | B Fix FOUT gubs                                                                                                    | F Allow commenting on events start                                                             |                                                                                          |
      | F Events page MG                                                                                                   | F CMS About page start                                                                         |                                                                                          |
      | F Set up work email address LC                                                                                     | F Social buttons to share events gubs start                                                    |                                                                                          |
      | C How does event sorting work? LC                                                                                  | F Events can repeat? gubs start                                                                |                                                                                          |
      | F Set up adapt2play.org MG                                                                                         | F Redesign layout with red gubs start                                                          |                                                                                          |
      | F Events can be filtered by tag gubs                                                                               | F Accessibility LC start                                                                       |                                                                                          |
      | B Excessive space in events sort by options gubs                                                                   | F Filterable directory of organizations start                                                  |                                                                                          |
      | F Advertising gubs                                                                                                 | F Changing event form auto refreshes events start                                              |                                                                                          |
      | F About page gubs                                                                                                  | C Get variable fonts working? MG start                                                         |                                                                                          |
      | F Events can be filtered by date range MG                                                                          | F Merchandise Page start                                                                       |                                                                                          |
      | F Add MP4 video to About page LC                                                                                   | F Register as participant gubs start                                                           |                                                                                          |
      | F Create / Manage Events MG                                                                                        | F Filterable directory of Adaptive Sports start                                                |                                                                                          |
      | F Style flash alerts gubs                                                                                          | F Filterable directory of participants start                                                   |                                                                                          |
      | B Text areas are using markdown MG                                                                                 | F Event comments / discussions start                                                           |                                                                                          |
      | B Editing events loses location and times MG                                                                       | F Auto import tags on source import? MG start                                                  |                                                                                          |
      | F Rebrand site with new Adapt2Play name LC                                                                         | F Add participants? gubs start                                                                 |                                                                                          |
      | F Basic filtering of events by location MG                                                                         | F Submit an advertisement start                                                                |                                                                                          |
      | F Upgrade About Page gubs                                                                                          |                                                                                                |                                                                                          |
      | F Add "add your own tags" help text to event form gubs                                                             |                                                                                                |                                                                                          |
      | F Remove hCalendar markup gubs                                                                                     |                                                                                                |                                                                                          |
      | B Error when entering a non-location into the location field MG                                                    |                                                                                                |                                                                                          |

    When I follow "Members"
    Then I should see the following project members:
      | Lindsay Caron (pending) | lindsaycaron37@gmail.com | REMOVE | SEND INVITATION EMAIL |
      | Micah Geisel            | micah@botandrose.com     | REMOVE |                       |
      | Michael Gubitosa        | gubs@botandrose.com      | REMOVE |                       |

    When I follow "Send invitation email"
    Then I should see "Invitation email sent to lindsaycaron37@gmail.com"
    And I should see the following project members:
      | Lindsay Caron (pending) | lindsaycaron37@gmail.com | REMOVE | RESEND INVITATION EMAIL |
      | Micah Geisel            | micah@botandrose.com     | REMOVE |                         |
      | Michael Gubitosa        | gubs@botandrose.com      | REMOVE |                         |

    And "lindsaycaron37@gmail.com" should receive 1 email
