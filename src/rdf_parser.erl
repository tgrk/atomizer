-module(rdf_parser).

-export([parse_feed/1]).

-include("atomizer.hrl").

parse_feed(RawFeed) ->
	erlsom:sax(RawFeed, [], fun handle_event/2).

handle_event(startDocument, _State) ->
	[{cmd, start}, {md, #feed{}}, {entries, []}];

handle_event(endDocument, [{cmd, _Command}, {md, Feed}, {entries, Entries}]) ->
	Feed#feed{entries=lists:reverse(Entries)};

handle_event({startElement, _NS, "title", _, _Attrs}, [{cmd, start}, {md, Feed}, {entries, Entries}]) ->
	update_feed_metadata(Feed, Entries, title, titletext);

handle_event({characters, Text}, [{cmd, titletext}, {md, Feed}, {entries, Entries}]) ->
	build_state(start, Feed#feed{title=Text}, Entries);

handle_event({startElement, _NS, "link", _, _Attrs}, [{cmd, start}, {md, Feed}, {entries, Entries}]) ->
	update_feed_metadata(Feed, Entries, url, linktext);

handle_event({characters, Text}, [{cmd, linktext}, {md, Feed}, {entries, Entries}]) ->
	build_state(start, Feed#feed{url=Text}, Entries);

handle_event({startElement, _NS, "date", _, _Attrs}, [{cmd, start}, {md, Feed}, {entries, Entries}]) ->
		update_feed_metadata(Feed, Entries, updated, updated2text);

handle_event({characters, Text}, [{cmd, updated2text}, {md, Feed}, {entries, Entries}]) ->
	build_state(start, Feed#feed{updated=Text}, Entries);

handle_event({startElement, _NS, "creator", _, _Attrs}, [{cmd, start}, {md, Feed}, {entries, Entries}]) ->
	update_feed_metadata(Feed, Entries, author, authortext);

handle_event({characters, Text}, [{cmd, authortext}, {md, Feed}, {entries, Entries}]) ->
	build_state(start, Feed#feed{author=Text}, Entries);

handle_event({startElement, _NS, "item", _, _Attrs}, [{cmd, _Command}, {md, Feed}, {entries, Entries}]) ->
	build_state(entry, Feed, [#feedentry{content=""}|Entries]);

handle_event({endElement, _NS, "item", _}, [{cmd, _Command}, {md, Feed}, {entries, Entries}]) ->
	build_state(start, Feed, Entries);

handle_event({startElement, _NS, "title", _, _Attrs}, [{cmd, entry}, {md, Feed}, {entries, Entries}]) ->
	build_state(entrytitletext, Feed, Entries);

handle_event({characters, Text}, [{cmd, entrytitletext}, {md, Feed}, {entries, [Entry|T]}]) ->
	build_state(entry, Feed, [Entry#feedentry{title=Text}|T]);

handle_event({startElement, _NS, "creator", _, _Attrs}, [{cmd, entry}, {md, Feed}, {entries, Entries}]) ->
	build_state(creatortext, Feed, Entries);

handle_event({characters, Text}, [{cmd, creatortext}, {md, Feed}, {entries, [Entry|T]}]) ->
	build_state(entry, Feed, [Entry#feedentry{author=Text}|T]);

handle_event({startElement, _NS, "link", _, _Attrs}, [{cmd, entry}, {md, Feed}, {entries, Entries}]) ->
	build_state(entrylinktext, Feed, Entries);

handle_event({characters, Text}, [{cmd, entrylinktext}, {md, Feed}, {entries, [Entry|T]}]) ->
	build_state(entry, Feed, [Entry#feedentry{permalink=Text}|T]);

handle_event({startElement, _NS, "description", _, _Attrs}, [{cmd, entry}, {md, Feed}, {entries, Entries}]) ->
	build_state(entrycontenttext, Feed, Entries);

handle_event({characters, Text}, [{cmd, entrycontenttext}, {md, Feed}, {entries, [Entry|T]}]) ->
	UpdatedEntry = Entry#feedentry{content=lists:append(Entry#feedentry.content, Text)},
	build_state(entry, Feed, [UpdatedEntry|T]);

handle_event({startElement, _NS, "date", _, _Attrs}, [{cmd, entry}, {md, Feed}, {entries, Entries}]) ->
	build_state(pubdatetext, Feed, Entries);

handle_event({characters, Text}, [{cmd, pubdatetext}, {md, Feed}, {entries, [Entry|T]}]) ->
	build_state(entry, Feed, [Entry#feedentry{date=Text}|T]);

handle_event(_Event, State) ->
	State.

build_state(Command, Feed, Entries) ->
	[{cmd, Command}, {md, Feed}, {entries, Entries}].

update_feed_metadata(Feed, Entries, FieldName, Cmd) ->
	Index = get_field_idx(FieldName),
	case element(Index, Feed) of
		undefined ->
			build_state(Cmd, Feed, Entries);
		_AlreadySet ->
			build_state(start, Feed, Entries)
	end.

get_field_idx(title)   -> 2;
get_field_idx(author)  -> 3;
get_field_idx(url)     -> 4;
get_field_idx(updated) -> 5.
