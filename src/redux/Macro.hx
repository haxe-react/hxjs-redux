package redux;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

using Lambda;

class Macro {
	public static macro function combineReducers(e:Expr) {
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
	static function typeEquivalent(t1:Type, t2:Type) {
		return Context.unify(t1, t2) && Context.unify(t2, t2);
	}
	#end
}