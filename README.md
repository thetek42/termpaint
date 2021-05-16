# termpaint
A small application that allows you to draw stuff within the terminal. It is written in the Nim programming language using the [illwill](https://github.com/johnnovak/illwill) library.

## Compiling and Running

**Prerequisites**: You need to have Nim and `illwill` installed in order to compile the application.

- [Download Nim](https://nim-lang.org/install.html) and add it to your `PATH`

- To install `illwill`, run the following command:

  ```bash
  nimble install illwill
  ```

To compile termpaint, run the following commands:

```bash
git clone https://github.com/thetek42/termpaint
cd termpaint
nim c --outdir:build src/termpaint.nim
```

You will get an executable binary in the `build/` folder. To run it, either add it to your `PATH` or execute it directly from the terminal:

```bash
cd build
./termpaint
```

## Usage

- You can select colors by either clicking on them in the color menu on the left hand side or by pressing the keys 1-7.
- By pressing the key 0 or the button in the color menu, you can toggle the bright color mode (2nd color palette).
- The currently available tools are "Draw" and "Erase". They can be selected by clicking on the respective entry in the tools menu or by using the buttons Q, W, E, ...
- The other tools (rectangle, line, etc.) are currently being worked on and are not yet implemented.
- Pressing Escape will quit the application.

