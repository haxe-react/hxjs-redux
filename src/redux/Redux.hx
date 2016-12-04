package redux;

import haxe.Constraints;
import haxe.macro.Expr;

@:jsRequire('redux')
extern class Redux {
	static function createStore<S, A:{type:String}>(reducer:S->A->S, ?initialState:S, ?enhancer:Function):Store<S, A>;
	
	@:native('combineReducers') // the real one
	static function _combineReducers<S, A:{type:String}>(reducers:{}):S->A->S;
	
	public static inline macro function combineReducers(e:Expr):Expr return macro redux.Reducer.combine($e);
}

extern class Store<S, A:{type:String}> {
	function subscribe(listener:Void->Void):Void->Void;
	function getState():S;
	function dispatch(action:A):Void;
}