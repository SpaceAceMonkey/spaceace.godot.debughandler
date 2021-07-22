# SpaceAce Debug Handler for Godot
This code was written using [Godot](https://godotengine.org/) 3.3.2.stable, and has not been tested with previous versions of the engine.

&nbsp;

## What it does

This code makes it easy to output messages at various levels in various build environments.

&nbsp;

## Features

- Fluent interface
  - Chain methods to easily output multiple messages in any combination of environments and levels
- Simple API
  - There are only four methods for the user to worry about, and three of them are just shortcuts to the fouth.
  - All options are set using a handful of enum values.
- Save screen space and your poor little fingers
  - The main methods are wrapped by single-character helper methods.
- Simplify your debug messaging
  - You can generate all the output you need for both debug and production builds without ever having to check which build is running.

&nbsp;

## Setup

1) Clone this repository or download the file DebugHandler<span/>.gd in the res/ sub-directory. Add DebugHandler<span/>.gd to your Godot project.
2) Add DebugHandler to your project's AutoLoad settings. Give it a simple name and make sure "Singleton" is enabled. The name you give this singleton will be global, so remember not to create any variables in your code which conflict with it.
![Select DebugHandler.gd and give it a name you will use to access it in code](https://github.com/SpaceAceMonkey/spaceace.godot.debughandler/blob/main/images/debug_handler_auto_load.png)
![Click "add" then close the AutoLoad dialog](https://github.com/SpaceAceMonkey/spaceace.godot.debughandler/blob/main/images/debug_handler_auto_load_part_2.png)


&nbsp;

## API

`print(message, env, level)`

*Description*:

Outputs a message to the OS console and/or the Godot debug console.

*Parameters*:

> message

The string to be output to the console.

> env

The environment(s) for which this message should be output. See the [env](#debughandlerenv-enum) enum for details. Defaults to [DebugHandler.env.DEBUG](#debughandlerenv-enum).

> level

The level at which the message should be output. See the [level](#debughandlerlevel-enum) enum for details. Defaults to [DebugHandler.level.INFO](#debughandlerlevel-enum).

*Returns*

The DebugHandler instance.

&nbsp;

`a(message, level)`

*Description*

A shortcut method which calls `print()` with the env parameter set to [env.ALL](#debughandlerenv-enum).

*Parameters*

> message

See `print()`.

> level

Defaults to [DebugHandler.level.INFO](#debughandlerlevel-enum).

*Returns*

The DebugHandler instance.

&nbsp;

`d(message, level)`

*Description*

A shortcut method which calls `print()` with the env parameter set to [env.DEBUG](#debughandlerenv-enum).

*Parameters*

> message

See `print()`.

> level

Defaults to [DebugHandler.level.INFO](#debughandlerlevel-enum).

*Returns*

The DebugHandler instance.

&nbsp;

`p(message, level)`

*Description*

A shortcut method which calls `print()` with the env parameter set to [env.PRODUCTION](#debughandlerenv-enum).

*Parameters*

> message

See `print()`.

> level

Defaults to [DebugHandler.level.INFO](#debughandlerlevel-enum).

*Returns*

The DebugHandler instance.

#### Note:

Although the official Godot IDE separates different levels of output (INFO goes to the main Output tab, while WARN and ERROR go to the Debugger -> Errors tab), the same may not be true for third-party development environments. For example, when using VSCode to run your Godot project, all levels of output go to the same terminal.

## DebugHandler.env enum

Used to select which environment(s) a message should be displayed in.

- ALL
  - Message will be displayed in both debug and production builds.
- DEBUG
  - Message will be displayed only when running a debug build.
- PRODUCTION
  - Message will be displayed only when running a production build.

&nbsp;

## DebugHandler.level enum

Used to set the level of the message.

- ALL
  - Outputs the message to all channels. See descriptions of INFO, WARN, and ERROR for details.
- INFO
  - Outputs the message in plain text to the "Output" tab in the Godot IDE, or the equivalent OS terminal if the program is run from outside the Godot IDe.
- ERROR
  - Outputs to the Debugger -> Errors tab in Godot, or to the OS terminal when run from outside of Godot. In Godot, and in most terminals, the message will be highlighted in red.
  - Includes the stack trace when run from the Godot IDE.
- WARN
  - Outputs to the Debugger -> Errors tab in Godot, or to the OS terminal when run from outside of Godot. In Godot, and in most terminals, the message will be highlighted in yellow.
  - Includes the stack trace when run from the Godot IDE.
- INFO_ERROR
  - Outputs to both the INFO and WARN channels.
- INFO_WARN
  - Outputs to both the INFO and ERROR channels.

## Examples

The following examples assume you have DebugHandler set up in your Godot AutoLoader tab, and you have given it the name `dh`.

- Basic operation
  ##### Output a simple message to the terminal when running a debug build of your application.

  `dh.print("This is a message.")`

  *Output*

  `This is a message.`

  ##### Output a simple message to the terminal when running a production build of your application.

  `dh.print("This is a message.", dh.env.PRODUCTION)`

  *Output*

  `This is a message.`

  ##### Output a simple message to the terminal regardless of whether you are running a production build or a debug build.

  `dh.print("This is a message.", dh.env.ALL)`

  *Output*

  `This is a message.`

  ##### You can do the same as above using the helper functions `d()`, `p()`, and `a()`.
  ```
  dh.d("This is a message") # Debug only
  dh.p("This is a message") # Production only
  dh.a("This is a message") # All builds
  ```

  ##### Use Godot string formatting to generate more complex messages

  ```
  var a = 1234
  var b = "Hi, I am a string"
  dh.d("This is a string, \"%s,\" and this is a number, %d." % [b, a]) # Debug only
  ```

  *Output*

  `This is a string, "Hi, I am a string," and this is a number, 1234.`

  ##### Output a short string to the OS console, and a more detailed message to the Godot console.

  ```
  var bad_json = """{
    "_id": "60f9a421f44c52bc7ab897cc",
    "index": 0,
    "guid": "c57de7c5-a775-4b1b-a92f-a08d5ec3c81a",
    "tags": [
    "nulla",
    "ullamco"
    ],
    "friends": [
    {
      "id: 0,
      "name": "Nina Valdez"
    },
    {
      "id": 1,
      "name": "Conrad Greer"
    }
    ],
    "greeting": "Hello, undefined! You have 5 unread messages.",
    "favoriteFruit": "banana"
  }"""

  # Do stuff, discover JSON is broken

  dh.a("Error parsing JSON.") # All build environments, debug level
  dh.a(
    "Bad JSON: {bad_json}".format({"bad_json": bad_json})
    , dh.level.WARN
  ) # All build environments, warning level
  ```

  *Output*

  [In OS console]

  `Error parsing JSON.`

  [In Godot debug console error tab]

  ```call: Bad JSON: {
    "_id": "60f9a421f44c52bc7ab897cc",
    "index": 0,
    "guid": "c57de7c5-a775-4b1b-a92f-a08d5ec3c81a",
    "tags": [
    "nulla",
    "ullamco"
    ],
    "friends": [
    {
      "id: 0,
      "name": "Nina Valdez"
    },
    {
      "id": 1,
      "name": "Conrad Greer"
    }
    ],
    "greeting": "Hello, undefined! You have 5 unread messages.",
    "favoriteFruit": "banana"
  }
    <C++ Source>  modules/gdscript/gdscript_functions.cpp:817 @ call()
    <Stack Trace> DebugHandler.gd:58 @ print()
                  DebugHandler.gd:25 @ a()
                  YourFile.gd:60 @ _ready()
  ```

  ![Example warning output in the Godot debug console](https://github.com/SpaceAceMonkey/spaceace.godot.debughandler/blob/main/images/debug_handler_warning_output.png)

- Chaining method calls

##### Output several info-level messages to the console in all build environments

```
dh.print(
  "Message one", dh.env.ALL
).print(
  "Message two", dh.env.ALL
).print(
  "Message three", dh.env.ALL
).print(
  "Message four", dh.env.ALL
)

# Alternatively, use the a() helper method.

dh.a(
  "Message one"
).a(
  "Message two"
).a(
  "Message three"
).a(
  "Message four"
)
```

*Output*

```
Message one
Message two
Message three
Message four
```

##### Output one message at WARN level when running a debug build, and a different message at INFO level when running a production build

```
dh.p(
  "This is a simple message shown only when running a production build."
).d(
  """
  This is a more complex message full of {information} and {data},
  which includes a stack trace when run from the Godot IDE, and
  will only be shown when running a debug build.
  """.format({
    "information": "This is additional information you would like to
    see in the WARN output"
    , "data": "This is any additional data you feel like including in the 
    message"
  })
  , dh.level.WARN
)
```

*Output*

[Debug build]

```
W 0:00:00.438   call: This is a more complex message full of [This is
 additional information you would like to see in the WARN output] and 
 [This is any additional data you feel like including in the message], 
 which includes a stack trace when run from the Godot IDE, and will only 
 be shown when running a debug build.
  <C++ Source>  modules/gdscript/gdscript_functions.cpp:817 @ call()
  <Stack Trace> DebugHandler.gd:58 @ print()
                DebugHandler.gd:38 @ debug()
                DebugHandler.gd:28 @ d()
                Sprite.gd:36 @ _ready()
```

  ![A detailed message shown only in debug builds](https://github.com/SpaceAceMonkey/spaceace.godot.debughandler/blob/main/images/debug_handler_complex_message.png)

#### Note:

The message from the dh.p() call did not show up, as p() only outputs to production environments.

*Output*

[Production build]

`This is a simple message shown only when running a production build.`

#### Note:

The complex message from the call to dh.d() is not shown, as this code was run from a production build.