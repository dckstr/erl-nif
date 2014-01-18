-module(matrixmul).

-export([mul/2]).

transpose([[]|_]) -> [];
transpose(M) ->
  [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].
  
mul(A, B) ->
	BT = transpose(B),
	lists:map(
		fun(RA) ->
			lists:map(
				fun(CB) -> dotprod(RA, CB) end, BT)
		end, A).
		
dotprod(V1, V2) ->
	lists:foldl(
		fun({X,Y},Sum) -> Sum + X*Y end,
		0, lists:zip(V1, V2)).