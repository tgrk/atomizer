-module(rdf_parser_tests).

-include_lib("eunit/include/eunit.hrl").
-include_lib("../src/atomizer.hrl").

rdf_parse_test_() ->
    {foreach, fun read_file/0, [fun test_feed_details/1, fun test_feed_entry_details/1]}.

test_feed_details(Feed) ->
    [
        ?_assertEqual("Slashdot", Feed#feed.title),
        ?_assertEqual("help@slashdot.org", Feed#feed.author),
        ?_assertEqual("http://slashdot.org/", Feed#feed.url),
        ?_assertEqual(15, length(Feed#feed.entries)),
	    ?_assertEqual("2016-01-12T16:31:12+00:00", Feed#feed.updated)
    ].

test_feed_entry_details(Feed) ->
    FirstEntry  = lists:nth(1, Feed#feed.entries),
    SecondEntry = lists:nth(2, Feed#feed.entries),
    ThirdEntry  = lists:nth(3, Feed#feed.entries),
    [
        ?_assertEqual(
            "ATF Puts Up Surveillance Cameras Around Seattle<nobr> <wbr></nobr>... To Catch Illegal Grease Dump",
            FirstEntry#feedentry.title
        ),
        ?_assertEqual("timothy", FirstEntry#feedentry.author),
        ?_assertEqual("2016-01-12T16:09:00+00:00", FirstEntry#feedentry.date),
        ?_assertEqual(
            "http://yro.slashdot.org/story/16/01/12/169214/atf-puts-up-surveillance-cameras-around-seattle--to-catch-illegal-grease-dump?utm_source=rss1.0mainlinkanon&utm_medium=feed",
            FirstEntry#feedentry.permalink
        ),
        ?_assertEqual(
            "v3rgEz writes: Last summer, Seattleites noticed that utility polls around town were showing some odd growths: A raft of surveillance cameras that, under Seattle's strict surveillance equipment laws, shouldn't have been there without disclosure and monitoring. But Seattle Police said that they weren't theirs, and one enterprising citizen followed up with a series of public records requests, only to discover that they were actually the ATF's cameras &mdash; on the watch for grease dumpers. Now the requester is fighting for the full list of federal surveillance watching over Seattle, and answers to how often federal agencies pursue what appear to be purely local crimes.<p><div class=\"share_submission\" style=\"position:relative;\">\r\n<a class=\"slashpop\" href=\"http://twitter.com/home?status=ATF+Puts+Up+Surveillance+Cameras+Around+Seattle+...+To+Catch+Illegal+Grease+Dump%3A+http%3A%2F%2Fbit.ly%2F1Q2Cgqj\"><img src=\"http://a.fsdn.com/sd/twitter_icon_large.png\"></a>\r\n<a class=\"slashpop\" href=\"http://www.facebook.com/sharer.php?u=http%3A%2F%2Fyro.slashdot.org%2Fstory%2F16%2F01%2F12%2F169214%2Fatf-puts-up-surveillance-cameras-around-seattle--to-catch-illegal-grease-dump%3Futm_source%3Dslashdot%26utm_medium%3Dfacebook\"><img src=\"http://a.fsdn.com/sd/facebook_icon_large.png\"></a>\r\n\r\n<a class=\"nobg\" href=\"http://plus.google.com/share?url=http://yro.slashdot.org/story/16/01/12/169214/atf-puts-up-surveillance-cameras-around-seattle--to-catch-illegal-grease-dump?utm_source=slashdot&amp;utm_medium=googleplus\" onclick=\"javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;\"><img src=\"http://www.gstatic.com/images/icons/gplus-16.png\" alt=\"Share on Google+\"/></a>\r\n\r\n\r\n\r\n</div></p><p><a href=\"http://yro.slashdot.org/story/16/01/12/169214/atf-puts-up-surveillance-cameras-around-seattle--to-catch-illegal-grease-dump?utm_source=rss1.0moreanon&amp;utm_medium=feed\">Read more of this story</a> at Slashdot.</p><iframe src=\"http://slashdot.org/slashdot-it.pl?op=discuss&amp;id=8605281&amp;smallembed=1\" style=\"height: 300px; width: 100%; border: none;\"></iframe>",
            FirstEntry#feedentry.content
        ),

        ?_assertEqual("First Children Have Been Diagnosed In 100,000 Genomes Project", SecondEntry#feedentry.title),
        ?_assertEqual("timothy", SecondEntry#feedentry.author),
        ?_assertEqual("2016-01-12T15:27:00+00:00", SecondEntry#feedentry.date),
        ?_assertEqual(
            "http://science.slashdot.org/story/16/01/12/1528208/first-children-have-been-diagnosed-in-100000-genomes-project?utm_source=rss1.0mainlinkanon&utm_medium=feed",
            SecondEntry#feedentry.permalink
        ),
        ?_assertEqual(
            "Zane C. writes: The 100,000 Genomes project, an organization dedicated to diagnosing and researching rare genetic disorders, has just diagnosed its first 2 patients. After painstakingly analyzing about 3 billion base pairs from the parents of one young girl, and the girl herself, \"doctors told them the genetic abnormality &mdash; in a gene called KDM5b &mdash; had been identified\". The new information will not yet change the way the young girl, named Georgia, is treated, but it opens up a path for future treatments. For the other girl, Jessica, the genetic analysis provided enough information to diagnose and begin a new treatment. A mutation had occurred \"[causing] a condition called Glut1 deficiency syndrome in which the brain cannot get enough energy to function properly.\" Jessica's brain specifically had not been able to obtain enough sugar to power her brain cells, and as such, doctors prescribed a high fat diet to give her brain an alternate energy source. She has already begun showing improvement.<p><div class=\"share_submission\" style=\"position:relative;\">\r\n<a class=\"slashpop\" href=\"http://twitter.com/home?status=First+Children+Have+Been+Diagnosed+In+100%2C000+Genomes+Project%3A+http%3A%2F%2Fbit.ly%2F1W3CnlW\"><img src=\"http://a.fsdn.com/sd/twitter_icon_large.png\"></a>\r\n<a class=\"slashpop\" href=\"http://www.facebook.com/sharer.php?u=http%3A%2F%2Fscience.slashdot.org%2Fstory%2F16%2F01%2F12%2F1528208%2Ffirst-children-have-been-diagnosed-in-100000-genomes-project%3Futm_source%3Dslashdot%26utm_medium%3Dfacebook\"><img src=\"http://a.fsdn.com/sd/facebook_icon_large.png\"></a>\r\n\r\n<a class=\"nobg\" href=\"http://plus.google.com/share?url=http://science.slashdot.org/story/16/01/12/1528208/first-children-have-been-diagnosed-in-100000-genomes-project?utm_source=slashdot&amp;utm_medium=googleplus\" onclick=\"javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;\"><img src=\"http://www.gstatic.com/images/icons/gplus-16.png\" alt=\"Share on Google+\"/></a>\r\n\r\n\r\n\r\n</div></p><p><a href=\"http://science.slashdot.org/story/16/01/12/1528208/first-children-have-been-diagnosed-in-100000-genomes-project?utm_source=rss1.0moreanon&amp;utm_medium=feed\">Read more of this story</a> at Slashdot.</p><iframe src=\"http://slashdot.org/slashdot-it.pl?op=discuss&amp;id=8605117&amp;smallembed=1\" style=\"height: 300px; width: 100%; border: none;\"></iframe>",
            SecondEntry#feedentry.content
        ),

        ?_assertEqual(
            "Explosion-Proof Lithium-Ion Battery Shuts Down At High Temperatures",
            ThirdEntry#feedentry.title
        ),
        ?_assertEqual("timothy", ThirdEntry#feedentry.author),
        ?_assertEqual("2016-01-12T14:35:00+00:00", ThirdEntry#feedentry.date),
        ?_assertEqual(
            "http://hardware.slashdot.org/story/16/01/12/1426203/explosion-proof-lithium-ion-battery-shuts-down-at-high-temperatures?utm_source=rss1.0mainlinkanon&utm_medium=feed",
            ThirdEntry#feedentry.permalink
        ),
        ?_assertEqual(
            "An anonymous reader writes: Scientists have designed a lithium-ion battery that self-regulates according to temperature, to prevent itself from overheating. Reaching extreme temperatures, the battery is able to shut itself down, only restarting once it has cooled. The researchers designed the battery to shut down and restart itself over a repeated heating and cooling cycle, without compromising performance. A polyethylene film is applied to one of the electrodes, which expands and shrinks depending on temperature, to create a conductive/non-conductive material.<p><div class=\"share_submission\" style=\"position:relative;\">\r\n<a class=\"slashpop\" href=\"http://twitter.com/home?status=Explosion-Proof+Lithium-Ion+Battery+Shuts+Down+At+High+Temperatures%3A+http%3A%2F%2Fbit.ly%2F1ULZKPL\"><img src=\"http://a.fsdn.com/sd/twitter_icon_large.png\"></a>\r\n<a class=\"slashpop\" href=\"http://www.facebook.com/sharer.php?u=http%3A%2F%2Fhardware.slashdot.org%2Fstory%2F16%2F01%2F12%2F1426203%2Fexplosion-proof-lithium-ion-battery-shuts-down-at-high-temperatures%3Futm_source%3Dslashdot%26utm_medium%3Dfacebook\"><img src=\"http://a.fsdn.com/sd/facebook_icon_large.png\"></a>\r\n\r\n<a class=\"nobg\" href=\"http://plus.google.com/share?url=http://hardware.slashdot.org/story/16/01/12/1426203/explosion-proof-lithium-ion-battery-shuts-down-at-high-temperatures?utm_source=slashdot&amp;utm_medium=googleplus\" onclick=\"javascript:window.open(this.href,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');return false;\"><img src=\"http://www.gstatic.com/images/icons/gplus-16.png\" alt=\"Share on Google+\"/></a>\r\n\r\n\r\n\r\n</div></p><p><a href=\"http://hardware.slashdot.org/story/16/01/12/1426203/explosion-proof-lithium-ion-battery-shuts-down-at-high-temperatures?utm_source=rss1.0moreanon&amp;utm_medium=feed\">Read more of this story</a> at Slashdot.</p><iframe src=\"http://slashdot.org/slashdot-it.pl?op=discuss&amp;id=8604885&amp;smallembed=1\" style=\"height: 300px; width: 100%; border: none;\"></iframe>",
            ThirdEntry#feedentry.content
        )
    ].

read_file() ->
    read_file("rdf_feed.xml").

read_file(FeedFile) ->
    {ok, Cwd} = file:get_cwd(),
    Path = filename:join([Cwd, "test", "data", FeedFile]),
    {ok, Raw} = file:read_file(Path),
    rdf_parser:parse_feed(Raw).
