%% Copyright (c) 2007, Kevin A. Smith<kevin@hypotheticalabs.com>
%%
%% All rights reserved.
%%
%% Redistribution and use in source and binary forms, with or without
%% modification, are permitted provided that the following
%% conditions are met:
%%
%% * Redistributions of source code must retain the above copyright notice,
%% this list of conditions and the following disclaimer.
%%
%% * Redistributions in binary form must reproduce the above copyright
%% notice, this list of conditions and the following disclaimer in the
%% documentation and/or other materials provided with the distribution.
%%
%% * Neither the name of the hypotheticalabs.com nor the names of its
%% contributors may be used to endorse or promote products derived from
%% this software without specific prior written permission.
%%
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
%% OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
%% TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
%% THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
%% DAMAGE.

-module(atomizer).

-export([parse_url/1, parse_file/1]).

-include_lib("xmerl/include/xmerl.hrl").
-include("atomizer.hrl").

parse_url(Url) ->
	case fetcher:fetch(Url) of
		{error, Reason} ->
			throw(Reason);
		{ok, ContentType, _Status, _Headers, Body} ->
			case examine_content_type(ContentType) of
					unknown ->
						parse(examine_content(Body), Body);
					FeedType ->
						parse(FeedType, Body)
			end
	end.

parse_file(FilePath) ->
	{ok, Raw} = file:read_file(FilePath),
	Feed = binary_to_list(Raw),
	parse(examine_content(Feed), Feed).

examine_content(Feed) ->
	%% using a regex for this is fraught with danger
	%% but, Cthulhu willing, this should cover most cases
	case contains(Feed, "<feed( |>)") of
		true ->
			atom;
		false ->
			case contains(Feed, "<rdf( |>)") of
				true ->
					rdf;
				false ->
					case contains(Feed, "<channel( |>)") of
						true ->
							rss;
						false ->
							unknown
					end
			end
	end.

examine_content_type(ContentType) ->
	case ContentType of
		"application/rss+xml" ->
			rss;
		"application/atom+xml" ->
			atom;
		"application/rdf+xml" ->
			rdf;
		Other ->
			error_logger:info_msg("Atomizer - unknown content type ~p", [Other]),
			unknown
	end.

parse(unknown, _Feed) ->
	unknown;

parse(rss, Feed) ->
	error_logger:info_msg("Atomizer - parsing RSS format", []),
	rss_parser:parse_feed(Feed);
parse(rdf, Feed) ->
	error_logger:info_msg("Atomizer - parsing RDF format", []),
	rdf_parser:parse_feed(Feed);
parse(atom, Feed) ->
	error_logger:info_msg("Atomizer - parsing Atom format", []),
	atom_parser:parse_feed(Feed).

contains(Feed, Expression) ->
	case re:run(Feed, Expression) of
		{match, _} -> true;
		nomatch    -> false
	end.
