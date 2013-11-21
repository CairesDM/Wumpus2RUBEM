:-load_files([wumpus1]).

:-dynamic([orientacao/1, viradas/1, posicao_atual/2]).

init_agent:-
    writeln("Comecando teste"),
	assert(orientacao(0)),
	assert(viradas(0)),
	assert(posica_atual(1,1)).

restart_agent:-
    init_agent.

run_agent(Pc,Ac):-
    writeln(Pc),
    agente002(Pc,Ac).

atualizar_orientacao_direita :- orientacao(0), retractall(orientacao(_)), Y is 270, assert(orientacao(Y)).
atualizar_orientacao_direita :- orientacao(X), retractall(orientacao(_)), Y is X-90, assert(orientacao(Y)).

atualizar_orientacao_esquerda :- orientacao(270), retractall(orientacao(_)), Y is 0, assert(orientacao(Y)).
atualizar_orientacao_esquerda :- orientacao(X), retractall(orientacao(_)), Y is X+90, assert(orientacao(Y)).

atualizar_posicao:-orientacao(0), posicao_atual(X,Y), retractall(posicao_atual(_)), Z is X+1, W is Y, assert(posicao_atual(Z,W).
atualizar_posicao:-orientacao(90), posicao_atual(X,Y),retractall(posicao_atual(_)), Z is X, W is Y+1, assert(posicao_atual(Z,W).
atualizar_posicao:-orientacao(180),posicao_atual(X,Y),retractall(posicao_atual(_)), Z is X-1 , W is Y, assert(posicao_atual(Z,W).
atualizar_posicao:-orientacao(270),posicao_atual(X,Y),retractall(posicao_atual(_)), Z is X, W is Y-1, assert(posicao_atual(Z,W).

dobrarEsquerda(turnleft) :- viradas(0), somar(0).
dobrarEsquerda(goforward):- viradas(1), zerar, atualizar_orientacao_esquerda, atualizar_posicao.
 
dobrarDireita(turnright) :- viradas(0), somar(0).
dobrarDireita(goforward) :- viradas(1), zerar, atualizar_orientacao_direita, atualizar_posicao.

atras(turnleft):- viradas(0), somar(0).
atras(turnleft):- viradas(1), zerar, atualizar_orientacao_esquerda, atualizar_orientacao_esquerda, atualizar_posicao.

somar(X):-
    retractall(viradas(_)),
    Y is X+1,
    assert(viradas(Y)).
zerar:-
    retractall(viradas(_)),
    assert(viradas(0)).

