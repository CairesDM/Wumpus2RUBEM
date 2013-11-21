:-load_files([wumpus1]).

:-dynamic([orientacao/1]).

init_agent:-
    writeln("Comecando teste"),
	assert(orientacao(0)).
restart_agent:-
    init_agent.

run_agent(Pc,Ac):-
    writeln(Pc),
    agente002(Pc,Ac).

atualizar_orientacao_direita :- orientacao(0), retractall(orientacao(_)), Y is 270, assert(orientacao(Y)).
atualizar_orientacao_direita :- orientacao(X), retractall(orientacao(_)), Y is X-90, assert(orientacao(Y)).

atualizar_orientacao_esquerda :- orientacao(270), retractall(orientacao(_)), Y is 0, assert(orientacao(Y)).
atualizar_orientacao_esquerda :- orientacao(X), retractall(orientacao(_)), Y is X+90, assert(orientacao(Y)).

