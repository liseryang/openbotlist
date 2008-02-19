%%
%% Simple Statistic Analysis of social networking sites
%% Author: Berlin Brown
%% Date: 2/12/2008
%%

-module(socialstats).

-export([start_social/0]).

-import(url, [test/0, raw_get_url/2, start_cache/1, stop_cache/0]).
-import(rfc4627, [unicode_decode/1]).
-import(html_analyze, [disk_cache_analyze/1]).

-define(SocialURL, "http://botnode.com/").

start_social() ->
	io:format("*** Running social statistics~n"),
	%% First, setup the URL disk cache
	url:start_cache("db_cache/socialstats.dc"),
	case url:raw_get_url(?SocialURL, 60000) of
		{ok, Data} ->
			io:format("Data found from URL, storing=~s~n", [?SocialURL]),
			disk_cache:store(?SocialURL, Data),
			%% val = list_to_binary(xmerl_ucs:from_utf8([Data])),
			%% val = rfc4627:unicode_decode(Data),
			{ok, Data};
		{error, What} ->
			io:format("ERR:~p ~n", [What]),
		    {error, What}
	    end,
	%% Analyze the disk cache
	case disk_cache:fetch(?SocialURL) of
		{ok, Bin} ->
			io:format("Data found from disk cache, fetching=~s~n", [?SocialURL]),
			Toks = html_tokenise:disk_cache2toks(?SocialURL),
			io:format("Data found from disk cache, fetching=~p~n", [Toks]),
			{ok, Bin};
		{error, Err} ->
			io:format("ERR:~p ~n", [Err]),
		    {error, Err}
	    end,
	%% Stop the disk cach
	url:stop_cache(),
	io:format("*** Done [!]~n").

%% End of File
