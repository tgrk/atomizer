-module(atom_parser_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("../src/atomizer.hrl").

atom_parse_test_() ->
    {foreach, fun read_file/0, [fun test_feed_details/1, fun test_feed_entry_details/1]}.

read_file() ->
    {ok, Raw} = file:read_file("../test/atom.xml"),
    Feed = atom_parser:parse_feed(Raw),
    Feed.

test_feed_details(Feed) ->
    [
        ?_assertEqual("Example Feed", Feed#feed.title),
        ?_assertEqual("John Doe", Feed#feed.author),
        ?_assertEqual("http://example.org/", Feed#feed.url),
        ?_assertEqual(2, length(Feed#feed.entries)),
	?_assertEqual("2003-12-13T18:30:02Z", Feed#feed.updated)
    ].

test_feed_entry_details(Feed) ->
    FirstEntry = lists:nth(1, Feed#feed.entries),
    SecondEntry = lists:nth(2, Feed#feed.entries),
    [
        ?_assertEqual("Atom-Powered Robots Run Amok", FirstEntry#feedentry.title),
        ?_assertEqual(undefined, FirstEntry#feedentry.author),
        ?_assertEqual("2003-12-13T18:30:02Z", FirstEntry#feedentry.date),
        ?_assertEqual("http://example.org/2003/12/13/atom03", FirstEntry#feedentry.permalink),
        ?_assertEqual("Some content.", FirstEntry#feedentry.content),

        ?_assertEqual("Something something something", SecondEntry#feedentry.title),
        ?_assertEqual(undefined, SecondEntry#feedentry.author),
        ?_assertEqual("2003-12-12T13:37:46Z", SecondEntry#feedentry.date),
        ?_assertEqual("http://example.org/2003/12/12/atom04", SecondEntry#feedentry.permalink),
        ?_assertEqual("", SecondEntry#feedentry.content)
   ].
