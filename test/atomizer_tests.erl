-module(atomizer_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("../src/atomizer.hrl").

atomizer_test_() ->
  {setup,
     fun() -> ok end,
     fun(_) -> ok end,
     [
          {"General functionality", fun test_atomizer_api/0}
        , {"Feed Burner Blog",      fun test_feed_burner/0}
        , {"Erlang Blog Feed",      fun test_erlang_blog_feed/0}
     ]
  }.

test_atomizer_api() ->
  ok.

test_feed_burner() ->
  ?assert(
    is_tuple(
      atomizer:parse_url(
        "http://feeds.feedburner.com/blogspot/gJZg")
    )
  ).

test_erlang_blog_feed() ->
  ?assert(
    is_tuple(
      atomizer:parse_url(
        "http://blog.erlang.org/feed.xml")
    )
  ).
