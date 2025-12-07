---
title: "MVU Pattern and Functional Approach in Flutter"
date: 2025-12-08
---

When learning Flutter, its view-state management is straightforward on first glance: you create your own widget classes and use anonymous functions as callbacks directly in the view, where you use builtin `setState(...)` function to change a state inside this widget. But as the project grows, you can face with some problems using this approach:

1. **Synchronization of state and presentation**. When you change some value in one place, which should change a presentation (view) in another place, when your widget depends on another widget's state, when and how should you call your `setState(...)`?

2. **Correct event handling**. When some event happened in one widget, how would you handle execution of the next one? And moreover, if the next event should happen in another widget, and even more is `async`, how will you preserve the execution order?

3. **Multiple widgets — multiple states**. If one widget's state depends on another one, for example, some page's state depends on root widget's state or even on another page, how will you synchronize it? Borrowing mutable references of a widget state or a part of it is the most common approach in Flutter, because there objects are passed by mutable reference. For example, borrowing `Post`s from some `Blog` page for each `PostPreview` widget, so every `PostPreview` will contain a reference to its corresponding post. But it's really error-prone in big projects with a lot of widgets and states, see points above.

It is not an only Flutter's problem, a lot of frameworks, which are worse designed, are even harder to handle. However, there is a quite simple solution, which would work good even on big projects and is well presented in Elm framework and programming language — **MVU pattern**, along with some functional approach, which will make your project even less error-prone.

## What is MVU?

**MVU** (acronym for **Model-View-Update**) is a simple pattern, which uses the simple algorithm:

1. We have an initial **model**, a global collection of data, used in our application, which we initialize at the beginning of the program. If its structure becomes too big, we can split it into modules, how it's done in Elm.

2. We have our **view** — a root widget, which is built from smaller widgets, which we can interact with.

3. When we interact with our view, e.g. clicking button, writing text etc., we send some `Msg` — "tagged union"-based event data structure, which is then processed in a special `update` function, that will return a new version of our model and build a new view with respect to the new model.

![MVU demonstration](/assets/blog/mvu-flutter/img1.svg)

Advantages of this approach are obvious: we don't care about state management at all, we just send specific `Msg` for each specific action and process it in `update` function, changing the model, which automatically updates the view as needed.

And the most pleasant is the thing, that we can easily implement it in Flutter, without difficult project architecture, and I'll show you how. Let's go!

## Simple and _pure_ counter project

Like the most of UI frameworks tutorials, and especially MVU-based ones, we will start with a simple counter project. I call it _pure_, because for now our application logic will not contain any side effects and will only affect inner state of a program: increment/decrement a number.

First of all, we need to create our main `MVU` widget, which will be a skeleton for our program. Let's create some auxiliary types and `MVU` class:

```dart
typedef Update<M, Msg> = M Function(M model, Msg msg);
typedef View<M, Msg> = Widget Function(
  M model, 
  void Function(Msg msg) dispatch,
);

class MVU<M, Msg> extends StatefulWidget {
  final M initialModel;
  final Update<M, Msg> update;
  final View<M, Msg> view;

  const MVU({
    super.key,
    required this.initialModel,
    required this.update,
    required this.view,
  });

  @override
  MVUState<M, Msg> createState() => MVUState<M, Msg>();
}

// Here we change our state based on dispatched Msg
class MVUState<M, Msg> extends State<MVU<M, Msg>> {
  late M model;

  @override
  void initState() {
    super.initState();
    model = widget.initialModel;
  }

  void dispatch(Msg msg) {
    final newModel = widget.update(model, msg);

    setState(() {
      model = newModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.view(model, dispatch);
  }
}
```

Now we will create our `Model` and `Msg`. Because the first is immutable and the second is actually an ADT, we will use `freezed` package for this.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

@freezed
abstract class Model with _$Model {
  const Model._();

  // Declare our fields here
  const factory Model({
    required int value
  }) = _Model;

  // Initial state
  factory Model.initial() => Model(
    value: 0
  );
}
```

```dart
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'msg.freezed.dart';

@freezed
sealed class Msg with _$Msg {
  const factory Msg.increment() = Increment;
  const factory Msg.decrement() = Decrement;
}
```

Variants of our `Msg` can also have fields, so we can pass some data sending events, but for our application it is not needed. Also do not forget to add `build_runner` package to dependencies and run `dart run build_runner watch -d` to generate freezed files.

Then we initialize our application and main widget, containing the `MVU`:

```dart
void main() => runApp(const AppRoot());

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) => MVU<Model, Msg>(
    initialModel: Model.initial(),
    update: update,
    view: view,
  );
}
```

In `update` function we will process our events, which are dispatched in UI. In our application it is simple for now (and pure):

```dart
Model update(Model model, Msg msg) => switch (msg) {
  // Copying immutable models in `freezed` 
  // is actually cheap, unlike deep cloning
  Increment() => model.copyWith(value: model.value + 1),
  Decrement() => model.copyWith(value: model.value - 1),
};
```

And in `view` we will initialize our UI, which will be based on our `Model` and could dispatch events with `Msg`:

```dart
Widget view(Model model, void Function(Msg) dispatch) => MaterialApp(
  // General stuff
  debugShowCheckedModeBanner: false,
  title: 'Counter MVU',
  theme: ThemeData.light(),
  home: Scaffold(
    body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // This button dispatches `Increment` event
        TextButton(
          onPressed: () => dispatch(Increment()), 
          child: Text('Increment'),
        ),

        // Here we print value from the model
        Text('Value: ${model.value}'),

        // This button dispatches `Decrement` event
        TextButton(
          onPressed: () => dispatch(Decrement()), 
          child: Text('Decrement'),
        ),
      ],
    ),
  )
);
```

And that's it! Now we have a pure MVU-idiomatic counter application, which we could easily extend and maintain, as each event the application sends, can and must be processed explicitly.

![MVU application diagram](/assets/blog/mvu-flutter/img2.svg)

## MVU with nested widgets

However, as the project grows, we create new widgets, which doesn't have a direct acces to our `MVUState` and `dispatch` function. How to deal with it? The answer is clear and quite Dart'ish: we just create anonymous functions, which enclosure dispatch calls for every needed `Msg` and then pass them to our widgets' constructors, so we can call them from there.

In our example, we will separate buttons to different widgets; it's not very good to do this, as they are semantically similar, but it's for an educational purpose 😊

Create two simple classes:

```dart
class IncButton extends StatelessWidget {
  final VoidCallback onIncrement;
  
  const IncButton({super.key, required this.onIncrement});
  
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onIncrement, 
    child: Text('Increment'),
  );
}

class DecButton extends StatelessWidget {
  final VoidCallback onDecrement;
  
  const DecButton({super.key, required this.onDecrement});
  
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onDecrement, 
    child: Text('Increment'),
  );
}
```

And pass anonymous function with a correct `dispatch`:

```dart
...
children: [
  IncButton(onIncrement: () => dispatch(Increment())),

  Text('Value: ${model.value}'),

  DecButton(onDecrement: () => dispatch(Decrement())),
]
...
```

## Side effects and async

But what if we want some side effects occur, when processing our events: reading from file, printing to terminal, web requests etc? If they are sync, we could just rewrite our `update` function imperatively and use side effects implicitly. However, the better way would be to use `IO` wrapper to explicitly show that our event can arouse side effects. And even bettern `Task` wrapper, because the most of Flutter side effects are async, so that it won't freeze our UI.

So to introduce side effects in our MVU pattern let's firstly change a signature of our `Update` type alias:

```dart
// Semantically means: returns `Task`, which processes model M
typedef Update<M, Msg> = Task<M> Function(M model, Msg msg);
```

and dispatch method inside `MVU` widget:

```dart
// Changed to async context
void dispatch(Msg msg) async {
  // Added .run() to execute `Task`
  final newModel = await widget.update(model, msg).run();

  setState(() {
    model = newModel;
  });
}
```

For example, let's add some side effect to `Increment` event to save some data using `SharedPreferences`. For this we should add new variant `SaveData(int data)` to `Msg` and use `Task` or `Task.Do` (which is actually more useful in TaskEither.Do). To evoke an event from another event we can simply call `update` function with new model and needed `Msg`. But in `Task` context it is more interesting:

```dart
// We return Task instead of raw Model
Task<Model> update(Model model, Msg msg) => switch (msg) {
  Increment() => Task.Do(
    ($) async {
      // Compute new model
      final newModel = model.copyWith(value: model.value + 1);

      // Return the result of `SaveData` event with `$`
      // (we will talk about `$` later)
      return $(update(newModel, SaveData(model.value)));
    }
  ),

  Decrement() => Task.of(model.copyWith(value: model.value - 1)),

  SaveData(:final data) => Task.Do(
    ($) async {
      // Do some async stuff
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("counter", data);

      // Return model as is, because we haven't done any computation here
      return model;
    }
  )
};
```

![MVU with side effects](/assets/blog/mvu-flutter/img3.svg)

You might notice, that `Do` and `$` operator are implementation of monad `do-notation` borrowed from Haskell:

* `Do` is a syntax sugar to present monad consecutive computation in a imperative way;
* `$` is actually a function, which is almost an analogue of `<-` operator in Haskell: it "unwraps" a context, some mysterious box, where the value is hidden, and returns it, if it is available, to continue computation. With a `Task` semantics it is like: _"if the value is computed asynchronously — get it and pass forward, if not yet — wait, if it is failed — stop computation"_. We will discuss this stuff below.

## More functional features: Option, Either, TaskEither

`$` operator is more useful and, what is more important, understandable in contexts like `Option` — context with "optional value" semantics or `Either` — context with "value or error" semantics.

For example, say we have two functions: one, which returns a reciprocal of a number, and another, which returns a square root. First of all, how do we handle situations, where these functions are not defined? We can do it implicitly, throwing an exception, but we should specify all error cases in documentation, which not everyone does. Also we can return something like `-1` value, but, again, without proper documentation it still can cause a lot of errors. In Flutter we can return nullable type, and it is better. `fpdart`'s `Option` type is the same nullable, but with possibility to be used in consecutive (monadic) computations. 

Let's write these functions:

```dart
Option<double> reciprocal(double n) {
  if (n == 0) {
    return None();
  }

  return Some(1 / n);
}

Option<double> root(double n) {
  if (n < 0) {
    return None();
  }

  return Some(sqrt(n));
}
```

Or in more functional way using pattern matching:

```dart
Option<double> reciprocal(double n) => switch (n) {
  0 => None(),
  _ => Some(1 / n),
};

Option<double> root(double n) => switch (n) {
  final invalid when invalid < 0 => 
    None(),

  final other => 
    Some(sqrt(other))
};
```

And then, what will be a **composition** of these functions? Obviously, it is a "reciprocal root" of a number, but how would it look like in code?

We can simply check a return value of each function like null-checking in Java:

```dart
Option<double> reciprocalRoot(double n) {
  final x = root(n);
  if (x.isSome()) {
    final y = reciprocal(x.toNullable()!);
    return y;
  } else {
    return None();
  }
}
```

But what if we had 10 optional computations, how many nested brackets would we get? The question is rhetorical 😅

To avoid it, we can use an approach, which we'd use in Rust dealing with consecutive `Option`s — `and_then`. While writing this post, I've found out, that `fpdart`'s analogue of `and_then` is `flatMap`, while `andThen` is a really different function, but _whatever_ 😁

It would look like this:

```dart
Option<double> reciprocalRoot(double n) =>
  root(n)
    .flatMap((value) => reciprocal(value));
```

Much better. Now even having multiple steps, everything will be linear, without nested brackets. But we can go even further — use a functional approach in an imperative way, even if it sounds paradoxical. This is where do-notation comes. We can write our `Option`-computations as a sequence of imperative commands, "unwrapping" values for next computation using previously defined `$` operator:

```dart
Option<double> reciprocalRoot(double n) => Option.Do(
  ($) {
    final x = $(root(n));
    final y = $(reciprocal(x));

    return y;
  }
);
```

or more simple, without a redundant binding:

```dart
Option<double> reciprocalRoot(double n) => Option.Do(
  ($) {
    final x = $(root(n));
    
    return $(reciprocal(x));
  }
);
```

`$` here does exactly the same as in a `Task` case: _"if a value exists — get it and pass forward, otherwise — stop the computation"_.

`Either` is similar to `Option`, but instead of `None`, we can indicate some "erroneous" computation with a custom error type — `String`, some ADT etc. `TaskOption` and `TaskEither` are async wrappers for optional and erroneous types which indicate: _"this function describes an async computation with effects which may fail"_. 

This is really useful in handling consecutive web requests. Here are some examples from my [Frago](https://github.com/konceptosociala/frago) project: one with do-notation:

```dart
TaskEither<LoginError, String> pollForToken({
  required String clientId,
  required String deviceCode,
  int interval = 5
}) => TaskEither.Do(
  ($) async {
    await Future.delayed(Duration(seconds: interval));

    final accessTokenInfo = await $(accessToken(
      clientId: clientId, 
      deviceCode: deviceCode
    ));

    return switch (accessTokenInfo) {
      Token(token: final token) => token,

      Error(err: final err) => switch (err) {
        AuthPending() => $(pollForToken(
          clientId: clientId,
          deviceCode: deviceCode
        )),

        ExpiredToken() => $(TaskEither.left(
          LoginError(kind: LoginErrorKind.expiredToken)
        )),
        
        ...
      }
    };
  }
);
```
and one without it:
```dart

TaskEither<LoginError, String> fetchGitHubUser(String token) => TaskEither
  .tryCatch(
    () async => await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'token $token',
        'Accept': 'application/vnd.github.v3+json',
      },
    ),
    (_, __) => LoginError(kind: LoginErrorKind.cannotResolve),
  )
  
  ...

  .map((data) => data['login']! as String);
```

## Conclusion