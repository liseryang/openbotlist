%%
%% The laughingman appeared in public on February 3, 2024.
%%
-module(laughingman).

-include("irc.hrl").

-export([start_laughingman/0, start/1, stop/2, proceed/1]).
-export([say/3]).

-record(self, {client, nick, configuration, handler, dict, info, irclib}).
-record(state, {nick, dict, state, irclib, pong_timeout=undefined, connection_timeout}).

-define(BOT_NICK, "laughingman24").

start(Client) ->
	% Ref: spawn_link(Module, Function, ArgList)
    spawn_link(?MODULE, proceed, [Client]).

proceed(Client) ->
	Configuration = dict_proc:start(dict:from_list([{join_on_connect, 
													 Client#irc_bot.channels}])),
	io:format("trace: start_link~n"),
	StartLinkRes = irc_bot:start_link(Client),
	case StartLinkRes of 
		{ ok, Ircbot } ->
			io:format("trace: after:start_link=[~p] bothandler:[~p]~n", [StartLinkRes, Ircbot]),
 			IrcbotState = irc_bot:get_cur_state(Ircbot),
			io:format("trace: --[~p]~n", [IrcbotState]),
 			case IrcbotState of
 				{ ok, State } ->
 					Irclib = State#state.irclib,
  					io:format("Ok: proc: irclib: [~p]~n", [Irclib]),
  				 	timer:sleep(12000),
 					Handler = Client#irc_bot.handler,
   					io:format("invoking proceed<for idle>...~n"),
   					proceed(#self{ client=Ircbot,
   								   nick=Client#irc_bot.nick,
   								   dict=Client#irc_bot.channels,
   								   configuration=Configuration,
 								   irclib=Irclib,
   								   info=Client,
   								   handler=self()}, idle)
 			end;
		ignore ->
			io:format("IGNORE~n");
		{ error, Error } ->
			io:format("ERROR: ~p~n", [Error])
	end.
proceed(Self, connecting) ->
    Ircbot  = Self#self.client,
    Handler = Self#self.handler,
	Nick    = Self#self.nick,
	Info    = Self#self.info,
	io:format("trace: at proceed() clientinfo:[~p]~n", [Info]),
	io:format("IrcbotInfo: [~p] [handler:~p] ~n", [Ircbot, Handler]),
	io:format("---- IrcbotInfo END ----~n"),
    receive
        { irc_connect, Ircbot, Nick} ->
			io:format("trace: app:irc_connect~n"),
            % Do connect stuff
            join_channels(Ircbot, dict_proc:fetch(join_on_connect, 
												  Self#self.dict)),
            proceed(Self#self{nick=Nick}, idle);
        % Only the handler can stop it
        { stop, Handler, _ } ->
			io:format("trace: app:stop~n"), 
            Handler ! {stop, self()};
        Error ->
			io:format("trace: [!] app:error at proceeed: ~p~n", [Error]),
            %exit({'EXIT', Error})
			proceed(Self, idle)
    end,
	io:format("trace: app:process, waiting on proceed~n");
proceed(Self, pong) ->
    Client=Self#self.client,
    receive
        {irc_message, Client, {_, "PONG", _}} ->
            proceed(Self, idle)
    after pong_timeout() ->
            irc_lib:disconnect(Client),
            irc_lib:connect(Client),
            proceed(Self, connecting)
    end;
proceed(Self, idle) ->
	Ircbot  = Self#self.client,
    Handler = Self#self.handler,
	Nick    = Self#self.nick,
	Info    = Self#self.info,
	Irclib  = Self#self.irclib,
	io:format("trace: at proceed.idle [~p][~p]~n", [Handler, Ircbot]),
    receive
        { irc_closed, Ircbot } ->
			io:format("trace: app:proceed.idle - irc_closed~n"),
            irc_lib:connect(Ircbot),
            proceed(Self, connecting);
		% Various messages we'll try to handle
        % Respond to a ping
        { irc_message, Ircbot, { _, "PING", [Server]} } ->
			io:format("trace app:proceed.idle - message/ping~n"),
            irc_lib:pong(Ircbot, Server),
            proceed(Self, idle);
        % Catch all IRC messages
        { irc_message, Ircbot, _ } ->
			io:format("trace app:proceed.idle - message~n"),
            proceed(Self, idle);
        % Stuff from the client
        { say, Where, What} ->
			io:format("trace app:proceed.idle - say handler:[~p] ~n", [Handler]),
            irc_lib:say(Irclib, Where, What),
            proceed(Self, idle);
        { msg, Where, What} ->
			io:format("trace app:proceed.idle - msg handler:[~p] ~n", [Handler]),
            irc_lib:msg(Irclib, Where, What),
            proceed(Self, idle);
        { stop, Handler, Message} ->
			io:format("trace app:proceed.idle - stop [~p]~n", [Handler]),
            irc_lib:quit(Irclib, Message),
            irc_lib:stop(Irclib),
			io:format("[.]~n"),
            Handler ! {stop, Handler};
		Error ->
			io:format("trace: [!] app:error.proceeed<idle>: ~p~n", [Error]),
			proceed(Self, idle)
    after connection_timeout() ->
            irc_lib:ping(Irclib),
            proceed(Self, pong)
    end.

join_channels(Bot, [Channel | Rest]) ->
    irc_lib:join(Bot, Channel),
    join_channels(Bot, Rest);
join_channels(_, []) ->
    ok.

connection_timeout() ->
    % 10 minutes
    600000.

pong_timeout() ->
    % 10 Seconds
    10000.

%% -------------------------------------------------------------
%% Functions used to interact with the bot
%% -------------------------------------------------------------
say(Bot, Where, What) ->
	io:format("trace: app:say() bot:~p where:~p~n", [Bot, Where]),
    Bot ! {say, Where, What}.

msg(Bot, Where, What) ->
	io:format("trace: app:msg() bot:~p where:~p~n", [Bot, Where]),
    Bot ! {msg, Where, What}.

stop(Bot, Message) ->
	io:format("trace: app:stop() bot:~p msg:~p~n", [Bot, Message]),
    Bot ! {stop, Bot, Message},
    receive
        {stop, Bot} -> 
			io:format("trace: app:got stop~n"),
			ok
    end.

%% -------------------------------------------------------------
%% Start the laughing man
%% -------------------------------------------------------------
start_laughingman() ->
	irc_lookup:start(),
	Client = #irc_bot{nick=?BOT_NICK, 
					  realname=?BOT_NICK,
					  handler=self(),
					  servers=[{"irc.freenode.net", 6667}],
					  channels=["#botlist"]},
	P = start(Client),
 	io:format("trace: <after start> start_laughingman ->~p ~n", [P]),
 	timer:sleep(15000), 
 	msg(P, "#botlist", "This is test"),
	timer:sleep(4000),
	say(P, "#botlist", "This is test(1)"),
	timer:sleep(4000),
	timer:sleep(9999000),
 	stop(P, "bye"),
	io:format("trace app:done.laughingman~n"),
	irc_lookup:shutdown().

%% End of File
