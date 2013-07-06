-module(rss_parser_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("../src/atomizer.hrl").

rss_parse_test_() ->
    {foreach, fun read_file/0, [fun test_feed_details/1, fun test_feed_entry_details/1]}.

read_file() ->
    {ok, Raw} = file:read_file("../test/rss.xml"),
    Feed = rss_parser:parse_feed(Raw),
    Feed.

test_feed_details(Feed) ->
    [
        ?_assertEqual("XML.com", Feed#feed.title),
        ?_assertEqual(undefined, Feed#feed.author), %% is this available?
        ?_assertEqual("http://www.xml.com/", Feed#feed.url),
        ?_assertEqual(3, length(Feed#feed.entries))
    ].

test_feed_entry_details(Feed) ->
    FirstEntry = lists:nth(1, Feed#feed.entries),
    SecondEntry = lists:nth(2, Feed#feed.entries),
    ThirdEntry = lists:nth(3, Feed#feed.entries),
    [
        ?_assertEqual("Normalizing XML, Part 2", FirstEntry#feedentry.title),
        ?_assertEqual("Will Provost", FirstEntry#feedentry.author),
        ?_assertEqual("2002-12-04", FirstEntry#feedentry.date),
        ?_assertEqual("http://www.xml.com/pub/a/2002/12/04/normalizing.html", FirstEntry#feedentry.permalink),
        ?_assertEqual("In this second and final look at applying relational normalization techniques to W3C XML Schema data modeling, Will Provost discusses when not to normalize, the scope of uniqueness and the fourth and fifth normal forms.", FirstEntry#feedentry.content),

        ?_assertEqual("The .NET Schema Object Model", SecondEntry#feedentry.title),
        ?_assertEqual("Priya Lakshminarayanan", SecondEntry#feedentry.author),
        ?_assertEqual("2002-12-05", SecondEntry#feedentry.date),
        ?_assertEqual("http://www.xml.com/pub/a/2002/12/04/som.html", SecondEntry#feedentry.permalink),
        ?_assertEqual("Priya Lakshminarayanan describes in detail the use of the .NET Schema Object Model for programmatic manipulation of W3C XML Schemas.", SecondEntry#feedentry.content),

        ?_assertEqual("SVG's Past and Promising Future", ThirdEntry#feedentry.title),
        ?_assertEqual("Antoine Quint", ThirdEntry#feedentry.author),
        ?_assertEqual("2002-12-06", ThirdEntry#feedentry.date),
        ?_assertEqual("http://www.xml.com/pub/a/2002/12/04/svg.html", ThirdEntry#feedentry.permalink),
        ?_assertEqual("In this month's SVG column, Antoine Quint looks back at SVG's journey through 2002 and looks forward to 2003.", ThirdEntry#feedentry.content)
    ].
