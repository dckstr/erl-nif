-module(mmultnif).
-export([start/0, native_mmult/2]).
-compile(debug_info).

% Automatically load native code module
-on_load(start/0).

start() ->
    erlang:load_nif("mmultnif", 0).

native_mmult(_A, _B) ->
    "NIF library not loaded".