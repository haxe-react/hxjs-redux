package redux;

import haxe.Constraints;
import haxe.macro.Expr;
import haxe.macro.Context;

@:jsRequire('redux')
extern class Redux {
	static function createStore<S, A:{type:String}>(reducer:S->A->S, ?initialState:S, ?enhancer:Function):Store<S, A>;
	
	@:noCompletion @:native('combineReducers') // the real one
	static function _combineReducers<S, A:{type:String}>(reducers:{}):S->A->S;
	
	public static inline macro function combineReducers(e:Expr) {
		var action = null;
		switch e.expr {
			case EObjectDecl(fields):
				var stateFields:Array<Field> = [];
				for(field in fields) {
					var pos = field.expr.pos;
					var state = switch Context.followWithAbstracts(Context.typeof(field.expr)) {
						case TFun([{t:s}, {t:a}], ret):
							if(action == null)
								action = a;
							else if(!typeEquivalent(action, a))
								Context.error('Expected function accepting the same action type', pos);
							
							if(!typeEquivalent(s, ret))
								Context.error('Expected function with signature S->A->S', pos);
							else
								Context.toComplexType(s);
								
						default:
							Context.error('Expected function with signature S->A->S', pos);
					}
					
					stateFields.push({
						name: field.field,
						kind: FVar(state),
						pos: field.expr.pos
					});
				}
				
				var state = ComplexType.TAnonymous(stateFields);
				var ct = ComplexType.TFunction([state, Context.toComplexType(action)], state);
				return macro (redux.Redux._combineReducers($e):$ct);
				
			default:
				Context.error('Expected object declaration', e.pos);
				return macro null;
		}
	}
	#if macro
	static function typeEquivalent(t1:haxe.macro.Type, t2:haxe.macro.Type) {
		return Context.unify(t1, t2) && Context.unify(t2, t2);
	}
	#end
}

extern class Store<S, A:{type:String}> {
	function subscribe(listener:Void->Void):Void->Void;
	function getState():S;
	function dispatch(action:A):Void;
}