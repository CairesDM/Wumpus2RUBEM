:-load_files([wumpus1]).

:-dynamic([orientacao/1, viradas/1, posicao_atual/2, casas_visitadas/3, redirecionando/1, direcoes/1]).

init_agent:-
    writeln('Comecando teste'),
        assert(orientacao(0)),
        assert(viradas(0)),
        assert(posica_atual(1,1)),
		assert(casas_visitadas(1,1,0)),%para ordenado da casa, e orientacao de onde veio.
		assert(redirecionando(0)),
		assert(direcoes([0,90,180,270])).

restart_agent:-
    init_agent.

run_agent(Pc,Ac):-
    writeln(Pc),
    agente002(Pc,Ac).

agente002([_,no,_,_,_],Ac):- frente(Ac).
agente002([_,_,_,yes,_],Ac):- ajuste_posicao(Ac).

%agente002(_,Ac):- redirecionando(1), posicao_atual(X,Y),casas_visitadas(X,Y,A), orientacao(B), C is A+180, D is A-180,delete(direcoes, C, direcoes2); delete(direcoes,D,direcoes2),E is B +180, F is B -180, delete(direcoes2,E,direcoes3); delete(direcoes2, F, direcoes3).

%agente002([_,yes,_,_,_], Ac):- atras(Ac),retractall(redirecionando(_)), assert(redirecionando(1)).

frente(goforward):- atualizar_posicao.

atualizar_orientacao_direita :- orientacao(0), retractall(orientacao(_)), Y is 270, assert(orientacao(Y)).
atualizar_orientacao_direita :- orientacao(X), retractall(orientacao(_)), Y is X-90, assert(orientacao(Y)).

atualizar_orientacao_esquerda :- orientacao(270), retractall(orientacao(_)), Y is 0, assert(orientacao(Y)).
atualizar_orientacao_esquerda :- orientacao(X), retractall(orientacao(_)), Y is X+90, assert(orientacao(Y)).

atualizar_casas_visitadas(A,B,O):- casas_visitadas(A,B,_).%caso a casa ja tenha sido visitada, a orientacao antiga se mantem.
atualizar_casas_visitadas(A,B,O):- assert(casas_visitadas(A,B,O)).%caso nao tenha sido visitada, atualiza de onde ele veio.

atualizar_posicao:-orientacao(0), posicao_atual(X,Y), retractall(posicao_atual(_)), Z is X+1, assert(posicao_atual(Z,Y)),atualizar_casas_visitadas(Z,Y,0).
atualizar_posicao:-orientacao(90), posicao_atual(X,Y),retractall(posicao_atual(_)), W is Y+1, assert(posicao_atual(X,W)),atualizar_casas_visitadas(X,W,90).
atualizar_posicao:-orientacao(180),posicao_atual(X,Y),retractall(posicao_atual(_)), Z is X-1,assert(posicao_atual(Z,Y)),atualizar_casas_visitadas(Z,Y,180).
atualizar_posicao:-orientacao(270),posicao_atual(X,Y),retractall(posicao_atual(_)), W is Y-1, assert(posicao_atual(X,W)),atualizar_casas_visitadas(X,W,270).

ajuste_posicao(turnleft):-  orientacao(0), posicao_atual(X,Y), retractall(posicao_atual(_,_)), Z is X-1,  assert(posicao_atual(Z,Y)),atualizar_orientacao_esquerda.
ajuste_posicao(turnright):-  orientacao(90), posicao_atual(X,Y), retractall(posicao_atual(_,_)), W is Y-1, assert(posicao_atual(X,W)),atualizar_orientacao_direita.
ajuste_posicao(turnright):-  orientacao(180), posicao_atual(X,Y), retractall(posicao_atual(_,_)), Z is X+1,assert(posicao_atual(Z,Y)),atualizar_orientacao_direita.
ajuste_posicao(turnleft):-  orientacao(270), posicao_atual(X,Y), retractall(posicao_atual(_,_)), W is Y+1, assert(posicao_atual(X,W)),atualizar_orientacao_esquerda.

dobrarEsquerda(turnleft) :- viradas(0), somar(0).
dobrarEsquerda(goforward):- viradas(1), zerar, atualizar_orientacao_esquerda, atualizar_posicao.
 
dobrarDireita(turnright) :- viradas(0), somar(0).
dobrarDireita(goforward) :- viradas(1), zerar, atualizar_orientacao_direita, atualizar_posicao.

atras(turnleft):- viradas(0), somar(0).
atras(turnleft):- viradas(1),somar(1).
atras(turnleft):- viradas(2), zerar, atualizar_orientacao_esquerda, atualizar_orientacao_esquerda, atualizar_posicao.


backtracking(climb):-posicao_atual(1,1).
backtracking(Ac):- posicao_atual(X,Y), orientacao(O), casas_visitadas(X,Y,P), P = O + 90, dobrarDireita(Ac).
backtracking(Ac):- posicao_atual(X,Y), orientacao(270), casa_visitadas(X,Y,0), dobrarDireita(Ac).
backtracking(Ac):- posicao_atual(X,Y), orientacao(O), casas_visitadas(X,Y,P), P = O-90, dobrarEsquerda(Ac).
backtracking(Ac):- posicao_atual(X,Y), orientacao(0), casas_visitadas(X,Y,270), dobrarEsquerda(Ac).
backtracking(Ac):- posicao_atual(X,Y), orientacao(O), casas_visitadas(X,Y,P), P = O, frente(Ac).

somar(X):-
    retractall(viradas(_)),
    Y is X+1,
    assert(viradas(Y)).
zerar:-
    retractall(viradas(_)),
    assert(viradas(0)).

