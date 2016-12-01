package redux;

import haxe.Constraints;

@:jsRequire('redux')
extern class Redux {
	static function createStore<S, A:{type:String}>(reducer:S->A->S, ?initialState:S, ?enhancer:Function):Store<S, A>;
	static function combineReducers<S, A:{type:String}>(reducers:{}):S->A->S;
}

extern class Store<S, A:{type:String}> {
	function subscribe(listener:Void->Void):Void->Void;
	function getState():S;
	function dispatch(action:A):Void;
}