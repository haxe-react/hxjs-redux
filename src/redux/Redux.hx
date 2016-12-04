package redux;

import haxe.Constraints;
import haxe.macro.Expr;

@:jsRequire('redux')
extern class Redux {
	static function createStore<S, A:{type:String}>(reducer:S->A->S, ?initialState:S, ?enhancer:Function):Store<S, A>;
	public static macro function combineReducers(e:Expr):Expr return macro redux.Reducer.combine($e);
	
	@:native('combineReducers') // the real one
	static function _combineReducers<S, A:{type:String}>(reducers:{}):S->A->S;
}

extern class Store<S, A:{type:String}> {
	function subscribe(listener:Void->Void):Void->Void;
	function getState():S;
	function dispatch(action:A):Void;
}