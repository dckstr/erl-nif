-module(mmbenchmark).
-export([benchmark_erl/0,benchmark_native/0]).

gen_seq(A,K) when K == 1 -> [lists:seq(1,A)];
gen_seq(A,N) -> [lists:seq(1,A)] ++ gen_seq(A,N-1).

totuple_sec([H | T]) -> [list_to_tuple(H)] ++ totuple_sec(T);
totuple_sec(_) -> [].

benchmark_erl() -> 
	Bench = gen_seq(1000,1000),
	{Time,_} = timer:tc(matrixmul,mul,[Bench,Bench]),
	Time.

	
	
benchmark_native() ->
	Bench = list_to_tuple(totuple_sec(gen_seq(1000,1000))),
	{Time,_} = timer:tc(mmultnif,native_mmult,[Bench,Bench]),
	Time.
	
	