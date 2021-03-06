:-load_files([wumpus1]).

:-dynamic([orientacao/1, viradas/1, posicao_atual/2, casas_visitadas/3]).

init_agent:-
    writeln("Comecando teste"),
	assert(orientacao(0)),
	assert(viradas(0)),
	assert(posica_atual(1,1)),
	assert(casas_visitadas(1,1,0)).% par ordenado da casa, e a orientacao de onde o agente veio para chegar nela.

restart_agent:-
    init_agent.

run_agent(Pc,Ac):-
    writeln(Pc),
    agente002(Pc,Ac).

agente002([_,no,_,_,_],Ac):-dobrarDireita(Ac).
agente002([_,yes,_,_,_],Ac):- dobrarEsquerda(Ac).%backtracking(Ac).

%backtracking(climb):-posicao_atual(1,1).

atualizar_orientacao_direita :- orientacao(0), retractall(orientacao(_)), Y is 270, assert(orientacao(Y)).
atualizar_orientacao_direita :- orientacao(X), retractall(orientacao(_)), Y is X-90, assert(orientacao(Y)).

atualizar_orientacao_esquerda :- orientacao(270), retractall(orientacao(_)), Y is 0, assert(orientacao(Y)).
atualizar_orientacao_esquerda :- orientacao(X), retractall(orientacao(_)), Y is X+90, assert(orientacao(Y)).

atualizar_casas_visitadas(A,B,O):- casas_visitadas(A,B,_).%caso a casa ja tenha sido visitada, a orientacao antiga se mantem.
atualizar_casas_visitadas(A,B,O):- assert(casas_visitadas(A,B,O)).%caso nao tenha sido visitada, atualiza de onde ele veio.

atualizar_posicao:-orientacao(0), posicao_atual(X,Y), retractall(posicao_atual(_)), Z is X+1, assert(posicao_atual(Z,Y)),atualizar_casas_visitadas(Z,Y,0).
atualizar_posicao:-orientacao(90), posicao_atual(X,Y),retractall(posicao_atual(_)),  W is Y+1, assert(posicao_atual(X,W)),atualizar_casas_visitadas(X,W,90).
atualizar_posicao:-orientacao(180),posicao_atual(X,Y),retractall(posicao_atual(_)),Z is X-1 , assert(posicao_atual(Z,Y)),atualizar_casas_visitadas(Z,Y,180).
atualizar_posicao:-orientacao(270),posicao_atual(X,Y),retractall(posicao_atual(_)),  W is Y-1, assert(posicao_atual(X,W)),atualizar_casas_visitadas(X,W,270).

dobrarEsquerda(turnleft) :- viradas(0), somar(0).
dobrarEsquerda(goforward):- viradas(1), zerar, atualizar_orientacao_esquerda, atualizar_posicao.
 
dobrarDireita(turnright) :- viradas(0), somar(0).
dobrarDireita(goforward) :- viradas(1), zerar, atualizar_orientacao_direita, atualizar_posicao.

atras(turnleft):- viradas(0), somar(0).
atras(turnleft):- viradas(1), somar(0).
atras(goforward):-viradas(2), zerar, atualizar_orientacao_esquerda, atualizar_orientacao_esquerda, atualizar_posicao.

%frente(goforward):- atualizar_posicao.
sair(climb):-writeln("Falou galera").

somar(X):-
    retractall(viradas(_)),
    Y is X+1,
    assert(viradas(Y)).
zerar:-
    retractall(viradas(_)),
    assert(viradas(0)).

%backtracking(climb):-posicao_atual(1,1).
%backtracking(Ac):- posicao_atual(X,Y), orientacao(Oa), casas_visitadas(X,Y,Op), Op == Oa+90, dobrarDireita(Ac), backtracking(Ac).
%backtracking(Ac):- posicao_atual(X,Y), orientacao(270), casa_visitadas(X,Y,0), dobrarDireita(Ac), backtracking(Ac).
%backtracking(Ac):- posicao_atual(X,Y), orientacao(Oa), casas_visitadas(X,Y,Op), Op == Oa-90, dobrarEsquerda(Ac), backtracking(Ac).
%backtracking(Ac):- posicao_atual(X,Y), orientacao(0), casas_visitadas(X,Y,270), dobrarEsquerda(Ac), backtracking(Ac).
%backtracking(Ac):- posicao_atual(X,Y), orientacao(Oa), casas_visitadas(X,Y,Op), Op == Oa+180; Op ==Oa-180, atras(Ac), backtracking(Ac).
%backtracking(Ac):- posicao_atual(X,Y), orientacao(Oa), casas_visitadas(X,Y,Op), Op == Oa, frente(Ac), backtracking(Ac).

