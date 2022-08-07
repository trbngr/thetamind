# Thetamind

## Command Creation

I prefer to do command enrichment in `*.Handler.before_dispatch`

fields (internal or not) can be set in `*.before_validate(incoming_string_key_values)` or `*.after_validate(populated_command_struct)`

I implemented a few commands for you to look at. See `lib/thetamind/tasks/protocol`

## Command Dispatch

Greg's advice is sound for the majority of frameworks. They will tie you into patterns that won't feel natural to you. Commanded is actually a framework too. :) Blunt tries to be *super* configurable to avoid this pitfall. I'm always open to efforts to make the library easier and more ergonomic to use

## 3

Nothing forces you to use Blunt in all the places. If you feel it's better to use inline functions in a context module, by all means go for it. I've never wanted to go back to the so-called Phoenix context mess, personally.

> What if:
> - BoundedContext could generate query module by inspecting Ecto schema? query :list_tasks, schema: Projections.Task, filter: [:user_id]
> - BoundedContext accepts function? query :list_tasks, fn filters -> Repo.all(where(Task, filters)) end

I'd like to explorer these ideas! 

## 4

I'm not sure I understand the question. I don't think that `Blunt.Absinthe` supports the `then` option like `cqrs_tools`. If that's needed, I'd like to explore options.

## 5

That commit fixed an error we had internally the other day. It should be looked at more closely and changed if we can do it without breaking the public API.

## 6 Factories

Factories are an accidental feature that turned out absolutely killer for our teams.

They are pretty simple though. Sorry for the lack of docs.

They work in the following way.

### factory def
``` 
factory SomeCommandQueryOrStruct, debug: true do
  defaults value: 1, pet: :dog
  lazy_prop :name, &SomeFunction/0
  prop :id, new_uuid()
end
```

this can be used like so: 

```
%SomeCommandQueryOrStruct{value: 1, pet: :dog, name: "chris", id: id} = build(:some_command_query_or_struct, name: "chris")

```

or if the factory is for a Blunt command or query:


```
_return_value = dispatch(:some_command_query_or_struct, name: "chris")

```

You can also just create maps by simply giving it an atom name

``` 
factory :my_setup, debug: true do
  defaults value: 1, pet: :dog
  lazy_prop :name, &SomeFunction/0
  prop :id, new_uuid()
end
```

Factories accumulate data as they evaluate props. Turn on the debug option to see it in action.

## 7 Blunt.Behaviour

This is used at compile-time -- mostly.

It is used to validate some behaviours at run-time too. See `PipelineResolver`.

## 8 Blunt.DispatchStrategy

This is where the ultimate configurability of Blunt comes into play.

See the `Thetamind.Blunt.DispatchStrategy` module for an example.

Basically, you define the steps you want your commands and queries to go through when they are dispatched. You can be as clever as you need here. Blunt gets out of your way.

---

I'm super open to hearing ideas on how to improve the DX of Blunt. Feel free to send PRs and/or open issues. I'm also on Slack all day if you need to hit me up.

Enjoy,

Chris

