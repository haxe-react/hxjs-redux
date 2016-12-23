# Redux

Haxe externs for the redux library

## Usage

Basically it is very similar to the ordinary redux usage.

```Haxe
import redux.Redux;

var reducer = function(s:State, a:Action):State return s;
var store = Redux.createStore(reducer, {});
var state = store.getState();
store.dispatch(myAction);

// etc
```

## Macro powered `combineReducers`

One notable advantage of this library is that `combineReducers` is macro powered to ensure the result is properly typed.

```haxe

var foo = function(state:Foo, action:Action):Foo return state;
var bar = function(state:Bar, action:Action):Bar return state;

var reducer = Redux.combineReducers({
	foo: foo,
	bar: bar,
});

$type(reducer); // {foo:Foo, bar:Bar}->Action->{foo:Foo, bar:Bar}

```