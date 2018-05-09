-module(jekyll_parser_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("../src/atomizer.hrl").

jekyll_parser_test_() ->
    {foreach, fun read_file/0, [fun test_feed_details/1, fun test_feed_entry_details/1]}.

test_feed_details(Feed) ->
    [
        ?_assertEqual("A Blog from the Erlang/OTP team", Feed#feed.title),
        ?_assertEqual(undefined, Feed#feed.author),
        ?_assertEqual("http://blog.erlang.org/", Feed#feed.url),
        ?_assertEqual(1, length(Feed#feed.entries)),
	    ?_assertEqual("2018-04-17T12:14:25+00:00", Feed#feed.updated)
    ].

test_feed_entry_details(Feed) ->
    FirstEntry = lists:nth(1, Feed#feed.entries),
    [
        ?_assertEqual("I/O polling options in OTP 21", FirstEntry#feedentry.title),
        ?_assertEqual(undefined, FirstEntry#feedentry.author),
        ?_assertEqual("2018-04-11T00:00:00+00:00", FirstEntry#feedentry.date),
        ?_assertEqual("http://blog.erlang.org/IO-Polling/", FirstEntry#feedentry.permalink),
        ?_assertEqual("<p>Erlang/OTP 21 will introduce a completely new "
                      "IO polling implementation.</p>\n", FirstEntry#feedentry.content)
   ].

read_file() ->
    read_file("atom_jekyll_feed.xml").

read_file(FeedFile) ->
    {ok, Cwd} = file:get_cwd(),
    Path = filename:join([Cwd, "test", "data", FeedFile]),
    {ok, Raw} = file:read_file(Path),
    atom_parser:parse_feed(Raw).
