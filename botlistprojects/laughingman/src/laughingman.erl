%%
%% The laughingman appeared in public on February 3, 2024.
%%
-module(laughingman).

-include("irc.hrl").

-export([start_laughingman/0, start/1, stop/2, proceed/1]).
-export([say/3]).

-record(self, {client, nick, configuration, handler, dict, info}).

start(Client) ->
	% Ref: spawn_link(Module, Function, ArgList)
    spawn_link(?MODULE, proceed, [Client]).

proceed(Client) ->
	Configuration = dict_proc:start(dict:from_list([{join_on_connect, 
													 Client#irc_bot.channels}])),
	io:format("trace: start_link~n"),
	Ircbot = irc_bot:start_link(Client),
	case Ircbot of 
		{ ok, P } ->
			io:format("trace: after:start_link=~p~n", [Ircbot]),
			IrcbotInit = irc_bot:init([Client]),
			case IrcbotInit of
				{ ok, State } ->
 					io:format("Ok: proc~n"),
 				 	timer:sleep(12000),
					Handler = Client#irc_bot.handler,
  					io:format("invoking proceed...~n"),
  					proceed(#self{ client=Ircbot,
  								   nick=Client#irc_bot.nick,
  								   dict=Client#irc_bot.channels,
  								   configuration=Configuration,
  								   info=Client,
  								   handler=Handler}, connecting);
					%io:format("terminating irc_bot server"),
					%irc_bot:terminate(none, State);
				{ ok, State, Timeout } ->
					io:format("IGNORE~n");
				ignore ->
					io:format("IGNORE~n");
				{ stop, Reason } ->
					io:format("STOP: ->~p~n", [Reason])
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
            exit({'EXIT', Error})
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
    Client  = Self#self.client,
    Nick    = Self#self.nick,
    Handler = Self#self.handler,
	io:format("trace: proceed(idle)"),
    receive
        { irc_closed, Client } ->
            irc_lib:connect(Client),
            proceed(Self, connecting);
        % Various messages we'll try to handle
        % Respond to a ping
        { irc_message, Client, { _,    "PING",    [Server             ]} } ->
            irc_lib:pong(Client, Server),
            proceed(Self, idle);
        % Catch all IRC messages
        { irc_message, Client, _ } ->
            proceed(Self, idle);
        % Stuff from the client
        { say, Where, What} ->
            irc_lib:say(Client, Where, What),
            proceed(Self, idle);
        { stop, Handler, Message} ->
            irc_lib:quit(Client, Message),
            irc_lib:stop(Client),
            Handler ! {stop, self()}
    
    after connection_timeout() ->
            irc_lib:ping(Client),
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
    Bot ! {proceed, Where, What}.

stop(Bot, Message) ->
    Bot ! {stop, self(), Message},
    receive
        {stop, Bot} -> ok
    end.

%% -------------------------------------------------------------
%% Start the laughing man
%% -------------------------------------------------------------
start_laughingman() ->
	irc_lookup:start(),
	Client = #irc_bot{nick="laughingman24g", 
					  realname="laughingman24g",
					  handler=self(),
					  servers=[{"irc.freenode.net", 6667}],
					  channels=["#botlist"]},
	P = start(Client),
 	io:format("trace: <after start> start_laughingman ->~p ~n", [P]),
 	timer:sleep(18000),
	P ! { irc_message, P },
 	%say(P, "#botlist", "This is test"),
 	%stop(P, "bye"),
	irc_lookup:shutdown(),
	io:format("trace app:done.laughingman~n").

wait_for_messages(Client) ->
    receive
        Anything ->
            io:format("Anything: ~w~n", [Anything]),
            wait_for_messages(Client)
    after connection_timeout() + 10000 ->
            io:format("Timed out")
    end.

%% End of File
