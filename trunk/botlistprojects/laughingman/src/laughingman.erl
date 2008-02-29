-module(laughingman).

-include("irc.hrl").

-export([test/0, test/1, start/1, stop/2, proceed/1]).
-export([say/3]).

-record(self, {client, nick, configuration, handler, dict, info}).

start(Client) ->
    spawn_link(?MODULE, proceed, [Client]).

proceed(Client) ->
	CurHandler = self(),
	io:format("Current handler=~p~n", [CurHandler]),
	Info = #irc_client_info{realname=Client#irc_bot.realname,
							nick=Client#irc_bot.nick,
							handler=self(),
							servers=Client#irc_bot.servers },
	
	Configuration = dict_proc:start(dict:from_list([{join_on_connect, 
													 Client#irc_bot.channels}])),
	io:format("trace: start_link ~p~n", [Configuration]),
	P = irc_lib:start_link(Info),
    case P of
		{ ok, Client } -> 
			io:format("Ok Client~n"), 
			Client;
		{ ignore } ->
			io:format("ignore~n");
		{ error, Error} ->
			io:format("ignore~n");
		{ _, Sock } -> Sock
	end,
	timer:sleep(25000),
	io:format("trace: set handler~n"),
    Handler = Client#irc_bot.handler,
	io:format("invoking proceed~n"),
	proceed(#self{ client=Client, 
				   nick=Client#irc_bot.nick,
				   dict=Client#irc_bot.channels,
				   configuration=Configuration,
				   info=Info,
				   handler=Handler}, connecting).

proceed(Self, connecting) ->
	Tmp = Self#self.client, 
    Client  = Self#self.client,
    Handler = Self#self.handler,
	Nick    = Self#self.nick,
	Info    = Self#self.info,
	io:format("trace: at proceed() ~p~n", [Info]),
	io:format("ClientInfo: ~p [handler:~p] ~n", [Client, Handler]),
	%%join_channels(Client, dict_proc:fetch(join_on_connect, 
	%%									  Self#self.dict)),	
	%%irc_lib:join(Client, "#ai-nocrackpots"),
	%%io:format("join ok!~n"),
    receive
        { irc_connect, Client, Nick} ->
			io:format("trace: irc_connect~n"),
            % Do connect stuff
            join_channels(Client, dict_proc:fetch(join_on_connect, 
												  Self#self.configuration)),
            proceed(Self#self{nick=Nick}, idle);
        % Only the handler can stop it
        { stop, Handler, _ } ->
            Handler ! {stop, self()};
        Error ->
			io:format("trace: [!] error: ~p~n", [Error]),
            exit({'EXIT', Error})
    end;
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
        % Handle kicks
        { irc_message, Client, { _,    "KICK",    [Channel, Nick,    _]} } ->
            irc_lib:join(Client, Channel),
            proceed(Self, idle);
        { irc_message, Client, { _,    "KICK",    [Channel, Nick      ]} } ->
            irc_lib:join(Client, Channel),
            proceed(Self, idle);
        % Make sure to relay various messages
        { irc_message, Client, { From, "PRIVMSG", [To,      Message   ]} } ->
            irc_relay:relay(From, To, Message),
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

% -------------------------------------------------------------
% Functions used to interact with the bot
say(Bot, Where, What) ->
	io:format("trace: say()~n"),
    Bot ! {say, Where, What}.

stop(Bot, Message) ->
    Bot ! {stop, self(), Message},
    receive
        {stop, Bot} -> ok
    end.

% -------------------------------------------------------------
% Unit tests
test() ->
    irc_lookup:start(),
    P = start(#irc_bot{nick="ort_test", 
					   realname="foo",
					   handler=self(),
					   servers=[{"irc.freenode.net", 6667}], 
					   channels=["#botlist"]}),
	io:format("irc_lib:start_link ->~p ~n", [P]),
	case P of
		{ ok, Irclib } ->
			timer:sleep(19000),
			say(P, "#botlist", "This is test"),
			stop(P, "bye");
		{ error, _ } -> 
			io:format ("ERROR~n")
	end,
    irc_lookup:shutdown().

test(idling) ->
    P = start(#irc_bot{nick="laughingman", 
					   realname="laughingman", 
					   servers=[{"irc.freenode.net", 6667}], 
					   channels=["#botlist"]}),
    wait_for_messages(P),
    say(P, "#botlist", "ok, exiting"),
    stop(P, ""),
    irc_lookup:shutdown().

wait_for_messages(Client) ->
    receive
        Anything ->
            io:format("Anything: ~w~n", [Anything]),
            wait_for_messages(Client)
    after connection_timeout() + 10000 ->
            io:format("Timed out")
    end.

%% End of File
