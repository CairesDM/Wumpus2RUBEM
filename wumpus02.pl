:-load_files([wumpus1]).
init_agent:-
    writeln("Comecando teste").
restart_agent:-
    init_agent.

run_agent(Pc,Ac):-
    writeln(Pc),
    agente002(Pc,Ac).

