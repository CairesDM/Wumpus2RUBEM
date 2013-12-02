:-load_files([wumpus1]).

:-dynamic([viradas/1, orientacao/1, flechas/1, posicao_atual/2, casas_visitadas/3, ativado/1, redirecionando/1, casas_existentes/2]).


init_agent:-
    writeln('Comecando teste'),
	retractall(flechas(_)), assert(flechas(1)),
	retractall(viradas(_)), assert(viradas(0)),
	retractall(orientacao(_)), assert(orientacao(0)),%orientacao atual do agente
	retractall(casas_visitadas(_,_,_)), assert(casas_visitadas(1,1,0)),%guarda a orientacao de onde eu vim eu uma certa casa
	retractall(posicao_atual(_,_)), assert(posicao_atual(1,1)),%guarda a posicao atual do agente
	retractall(redirecionando(_)),assert(redirecionando(0)),%guarda se o agente esta redirecionando sua trajetoria ou nao
	retractall(ativado(_)), assert(ativado(0)),%marca se o backtracking está ativado ou nao.
%banco de dados das casas existentes.
	retractall(casas_existentes(_,_)),%todas as casas do mapa
	assert(casas_existentes(1,1)),assert(casas_existentes(1,2)),assert(casas_existentes(1,3)),assert(casas_existentes(1,4)),
	assert(casas_existentes(2,1)),assert(casas_existentes(2,2)),assert(casas_existentes(2,3)),assert(casas_existentes(2,4)),
	assert(casas_existentes(3,1)),assert(casas_existentes(3,2)),assert(casas_existentes(3,3)),assert(casas_existentes(3,4)),
	assert(casas_existentes(4,1)),assert(casas_existentes(4,2)),assert(casas_existentes(4,3)),assert(casas_existentes(4,4)).


restart_agent:-
    init_agent.

run_agent(Pc,Ac):-
    writeln(Pc),
	agente002(Pc,Ac).

agente002([_,yes,_,_,_], climb):- posicao_atual(1,1).%caso sentir brisa na primeira casa, o agente sai, pois a probabilidade de morrer é grande.

agente002([_,_,_,yes,_],Ac):- ativado(0), ajuste_posicao(Ac).

agente002([yes,_,_,_,_],Ac):- atras(Ac).

agente002([_,_,yes,_,_],Ac):- pegar_ouro(Ac).%ao sentir o brilho, ativa a funcao pegar o ouro.

agente002(_,Ac):- ativado(1),  writeln('backtracking ativado'), backtracking(Ac).% caso o backtracking estiver ligado, ele o executa.


agente002([_,no,_,_,_],Ac):-ativado(0),   redirecionando(0),frente(Ac).%caso não sentir brisa, e o backtracking e redirecionamento estiverem desliga    do, o agente continua a frente.


agente002([_,yes,_,_,_], Ac):-  atras(Ac).%ao sentir a brisa, o agente virar para tras.

agente002(_,Ac):-
	redirecionando(1), ativado(0), %caso o redirecionamento estiver ligado e o backtracking desligado
	posicao_atual(X,Y), %verifica a posicao atual.
	C is Y+1,
	not(casas_visitadas(X,C,_); not(casas_existentes(X,C))), %caso a casa acima não tenha sido visitada e exista, ele irá prosseguir
	norte(Ac).%irá para o norte da posicao atual.

%as regras a seguir sao analogas a de cima, porem para ir para uma direcao diferente.
agente002(_,Ac):-
	redirecionando(1), ativado(0), 
	posicao_atual(X,Y), 
	A is X+1,
	not(casas_visitadas(A,Y,_); not(casas_existentes(A,Y))), 
	leste(Ac).
agente002(_,Ac):-
	redirecionando(1), ativado(0), 
	posicao_atual(X,Y), 
	 D is Y-1,
	not(casas_visitadas(X,D,_); not(casas_existentes(X,D))),
	sul(Ac).

%essa regra possui um detalhe a mais, caso tenha se verifica todas as casas ao redor, e nenhuma delas nao tenha sido visita e exista, o backtracking é ativado para voltar para a casa anterior.
agente002(_,Ac):-
	redirecionando(1), ativado(0), 
	posicao_atual(X,Y), 
	B is X-1, 
	(casas_visitadas(B,Y,_); not(casas_existentes(B,Y)))
								->(backtracking(Ac),retractall(redirecionando(_)), assert(redirecionando(1)));(oeste(Ac)).






%funcao que vai para o norte independente da posicao ou orientacao.
norte(Ac):- orientacao(0), dobrarEsquerda(Ac).
norte(Ac):- orientacao(90), frente(Ac).
norte(Ac):- orientacao(180), dobrarDireita(Ac).

%funcao que vai para o sul independente da posicao ou orientacao.
sul(Ac):- orientacao(0), dobrarDireita(Ac).
sul(Ac):- orientacao(180), dobrarEsquerda(Ac).
sul(Ac):- orientacao(270), frente(Ac).

%funcao que vai para o leste independente da posicao ou orientacao.
leste(Ac):- orientacao(0), frente(Ac).
leste(Ac):- orientacao(90), dobrarDireita(Ac).
leste(Ac):- orientacao(270), dobrarEsquerda(Ac).

%funcao que vai para o oeste independente da posicao ou orientacao.
oeste(Ac):- orientacao(90), dobrarEsquerda(Ac).
oeste(Ac):- orientacao(180), frente(Ac).
oeste(Ac):- orientacao(270), dobrarDireita(Ac).


%funcao que vira para tras.
atras(turnleft):- 
	viradas(0), %verifica se o contador de viradas está em 0
	somar(0),%soma um ao contador.
	atualizar_orientacao_esquerda.%atualiza a orientacao
atras(turnleft):- 
	viradas(1), %verifica se está em 1 o contador
	somar(1),%soma um ao contador
	atualizar_orientacao_esquerda.%atualiza  a orientacao.
atras(Ac):-
	viradas(2), %verifica se está em 2 o contador
	zerar, %zera o contador
	frente(Ac),%vai para frente.
	 retractall(redirecionando(_)), assert(redirecionando(1)).%ao usar atras, ele irá ativar o redirecionamento e procurará uma nova trajetoria.

%funcao que dobra a esquerda
dobrarEsquerda(turnleft) :- viradas(0), somar(0).
dobrarEsquerda(Ac):- viradas(1), atualizar_orientacao_esquerda, zerar,frente(Ac),
	 retractall(redirecionando(_)), assert(redirecionando(0)).%desliga o redirecionamento
 
%funcao que dobra a direita
dobrarDireita(turnright) :- viradas(0), somar(0).
dobrarDireita(Ac) :- viradas(1), atualizar_orientacao_direita, zerar,frente(Ac),
	 retractall(redirecionando(_)), assert(redirecionando(0)).%desliga o redirecionamento

%funcao que vai para frente
frente(goforward):- 
	atualizar_posicao,%atualiza a posicao atual
	atualizar_casas_visitadas,%atualiza as casa visitadas
	 retractall(redirecionando(_)), assert(redirecionando(0)).%desliga o redirecionamento



atualizar_orientacao_direita :- %atualiza a orientacao ao virar para direita
	orientacao(0)->
					(retractall(orientacao(_)), Y is 270, assert(orientacao(Y)));%se a orientacao atual foi 0, ao virar a direita passa a ser 270
					(orientacao(X),retractall(orientacao(_)), Y is X-90, assert(orientacao(Y))).%caso contrario, diminui-se 90 na orientacao

atualizar_orientacao_esquerda :- %analogo ao da direita
	orientacao(270)->
					(retractall(orientacao(_)), Y is 0, assert(orientacao(Y)));%analogo ao da direita.
					(orientacao(X), retractall(orientacao(_)), Y is X+90, assert(orientacao(Y))).

%atualiza as casa visitadas, e a orientacao de onde eu vim.
atualizar_casas_visitadas:-
	orientacao(O), %verifica a orientacao atual do agente
	posicao_atual(X,Y), %verifica a posicao atual do agente
	not(casas_visitadas(X,Y,_)),%verifica se a casa atual ja foi visitada ou nao
	assert(casas_visitadas(X,Y,O)).%caso nao tenha sido visitada, ele atualiza 
atualizar_casas_visitadas.%caso a casa atual ja foi visitada, esse fato, irá fazer com que a funcao que utilizar a regra prossiga.


%atualiza a posicao atual do agente
atualizar_posicao:-
	orientacao(0), %verifica se a orientacao é 0º;
	posicao_atual(X,Y), Z is X+1,%verifica a posicao atual do agente e calcula a posicao a frente dele
	casas_existentes(Z,Y), %verifica se a casa a frente existe
	retractall(posicao_atual(_,_)),assert(posicao_atual(Z,Y)).%caso sim, apaga a posicao anterior e atualiza a posicao.

%todas as outras sao analogas as de cima, porém para orientacoes atuais diferentes.
atualizar_posicao:-
	orientacao(90), 
	posicao_atual(X,Y),W is Y+1, 
	casas_existentes(X,W),
	retractall(posicao_atual(_,_)), assert(posicao_atual(X,W)).

atualizar_posicao:-
	orientacao(180),
	posicao_atual(X,Y),Z is X-1,
	casas_existentes(Z,Y),
	retractall(posicao_atual(_,_)), assert(posicao_atual(Z,Y)).

atualizar_posicao:-
	orientacao(270),
	posicao_atual(X,Y),W is Y-1,
	casas_existentes(X,W),
	retractall(posicao_atual(_,_)), assert(posicao_atual(X,W)).

atualizar_posicao.%caso a casa a frente nao exista, esse fato irá fazer com que a funcao que utiliza-la prossiga.



%funcoes para ajustar a trajetoria ao bater na parede
ajuste_posicao(turnleft):-
	orientacao(0),posicao_atual(_,Y),%verifica a orientacao e posicao.
	Y <4,%verifica se a ordenada da posicao é menor que 4.
	atualizar_orientacao_esquerda.
ajuste_posicao(turnright):-
	orientacao(0),posicao_atual(_,Y),%verifica a orientacao e posicao.
	Y=4,%verifica se a ordenada é 4.
	atualizar_orientacao_direita.

ajuste_posicao(turnright):-
	orientacao(90),posicao_atual(X,_),%verifica a orientacao e posicao.
	(X<2;X=2),%caso a abscissa for igual ou menos que 2, vira direita
	atualizar_orientacao_direita.
ajuste_posicao(turnleft):-
	orientacao(90),posicao_atual(X,_),%verifica a orientacao e posicao.
	X>2,%caso a abscissa for maior que 2, vira esquerda
	atualizar_orientacao_esquerda.

ajuste_posicao(turnright):-
	orientacao(180),posicao_atual(_,Y),%verifica a orientacao e posicao.
	Y<4,%caso a ordenada for menor que 4, vira a direita
	atualizar_orientacao_direita.
ajuste_posicao(turnleft):-
	orientacao(180),posicao_atual(_,Y),%verifica a orientacao e posicao.
	Y=4,%caso a ordenada for 4, vira a esquerda
	atualizar_orientacao_esquerda.

ajuste_posicao(turnright):-
	orientacao(270),posicao_atual(X,_),%verifica a orientacao e posicao.
	(X<2;X=2),%caso a abscissa for menor ou igual a 2, vira direita
	atualizar_orientacao_direita.
ajuste_posicao(turnleft):-
	orientacao(270),posicao_atual(X,_),%verifica a orientacao e posicao.
	X>2,%caso a abscissa for maior que 2, vira esquerda.
	atualizar_orientacao_esquerda.



%funcao que irá pegar o ouro.
pegar_ouro(turnleft):-  viradas(0), somar(0).%irá virar para tras.
pegar_ouro(turnleft):- viradas(1), somar(1).
pegar_ouro(grab):-viradas(2), atualizar_orientacao_esquerda, atualizar_orientacao_esquerda,%atualiza a orientacao do agente e pega o ouro
					retractall(ativado(_)), assert(ativado(1)), writeln('ativando backtracking'), zerar.%ativa o backtracking para voltar para posicao 1,1.


%contador de viradas usado para realizar mais de uma acao de um vez, como dobrar esquerda
somar(X):-
    retractall(viradas(_)),
    Y is X+1,
    assert(viradas(Y)).
%zera o contador de viradas
zerar:-
    retractall(viradas(_)),
    assert(viradas(0)).


backtracking(climb):-posicao_atual(1,1).%se estiver na casa original, sai.

backtracking(Ac):- 
	posicao_atual(X,Y), orientacao(O), %verifica a posicao atual e a orientacao do agente
	casas_visitadas(X,Y,P),%verifica a orientacao de onde eu vim, para essa casa.
	P is O+90, %verifica a relacao entre a orientacao atual e a que eu estava quando cheguei pela primeira vez a esta casa
	dobrarDireita(Ac).%caso a relacao se verifica verdadeira, ele irá realizar essa acao.

%todas as outras sao analogas as de cima
backtracking(Ac):- 
	posicao_atual(X,Y), orientacao(270),
	casas_visitadas(X,Y,0),
	dobrarDireita(Ac).

backtracking(Ac):- 
	posicao_atual(X,Y), orientacao(O), 
	casas_visitadas(X,Y,P),
	P is O-90,
	dobrarEsquerda(Ac).

backtracking(Ac):- 
	posicao_atual(X,Y), orientacao(0), 
	casas_visitadas(X,Y,270),
	dobrarEsquerda(Ac).

backtracking(Ac):-writeln('ai'), 
	posicao_atual(X,Y), orientacao(O), 
	casas_visitadas(X,Y,P), 
	(P is O+180), 
	frente(Ac).
backtracking(Ac):-writeln('oi'),
     posicao_atual(X,Y), orientacao(O),
     casas_visitadas(X,Y,P),
     (P is O-180),
     frente(Ac).

