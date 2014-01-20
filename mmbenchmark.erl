-module(mmbenchmark).
-export([benchmark_erl/0,benchmark_native/0,multi_benchmarks/0]).

gen_seq(A,K) when K == 1 -> [lists:seq(1,A)];
gen_seq(A,N) -> [lists:seq(1,A)] ++ gen_seq(A,N-1).

totuple_sec([H | T]) -> [list_to_tuple(H)] ++ totuple_sec(T);
totuple_sec(_) -> [].

benchmark_erl2(N) -> 
	Bench = gen_seq(N,N),
	{Time,_} = timer:tc(matrixmul,mul,[Bench,Bench]),
	Time.

	
benchmark_native2(N) ->
	Bench = list_to_tuple(totuple_sec(gen_seq(N,N))),
	{Time,_} = timer:tc(mmultnif,native_mmult,[Bench,Bench]),
	Time.
	
benchmark_erl() -> benchmark_erl2(1000).
benchmark_native() -> benchmark_native2(1000).

results(N) -> 
	ET = benchmark_erl2(N),
	NT = benchmark_native2(N),
	{N,
	ET/1000000.0,
	NT/1000000.0,
	(1.0 * ET)/(1.0 * NT)}.
	
multi_benchmarks() -> lists:map(fun(N) -> results(100 * N) end,lists:seq(1,10)).