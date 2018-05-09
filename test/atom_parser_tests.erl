-module(atom_parser_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("../src/atomizer.hrl").

atom_parser_test_() ->
    {foreach, fun read_file/0, [fun test_feed_details/1, fun test_feed_entry_details/1]}.

test_feed_details(Feed) ->
    [
        ?_assertEqual("Example Feed", Feed#feed.title),
        ?_assertEqual("John Doe", Feed#feed.author),
        ?_assertEqual("http://example.org/", Feed#feed.url),
        ?_assertEqual(3, length(Feed#feed.entries)),
	    ?_assertEqual("2003-12-13T18:30:02Z", Feed#feed.updated)
    ].

test_feed_entry_details(Feed) ->
    FirstEntry = lists:nth(1, Feed#feed.entries),
    SecondEntry = lists:nth(2, Feed#feed.entries),
    ThirdEntry = lists:nth(3, Feed#feed.entries),
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
        ?_assertEqual("", SecondEntry#feedentry.content),

        ?_assertEqual("An entry with a different style link", ThirdEntry#feedentry.title),
        ?_assertEqual(undefined, ThirdEntry#feedentry.author),
        ?_assertEqual("2003-12-11T09:09:09Z", ThirdEntry#feedentry.date),
        ?_assertEqual("http://example.org/2003/12/11/atom05", ThirdEntry#feedentry.permalink),
        ?_assertEqual("", ThirdEntry#feedentry.content)
   ].

read_file() ->
    read_file("atom.xml").

read_file(FeedFile) ->
    {ok, Cwd} = file:get_cwd(),
    Path = filename:join([Cwd, "test", "data", FeedFile]),
    {ok, Raw} = file:read_file(Path),
    atom_parser:parse_feed(Raw).
