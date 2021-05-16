import illwill



proc exit() {.noconv.} =
    illwillDeinit()
    showCursor()
    quit(0)



proc main() =

    # variables
    var
        color        = 1
        color_id     = fgWhite
        color_bright = false
        old_termsize = terminalSize()
        tool         = 1
        tool_name    = "Draw "


    # initialize illwill
    illwillInit(fullscreen=true, mouse=true)
    setControlCHook(exit)
    hideCursor()


    # create terminal buffer
    var tb = newTerminalBuffer(terminalWidth(), terminalHeight())


    # display color selection frame
    tb.setForegroundColor(fgBlack, true)
    tb.drawRect(0, 0, 10, 10)
    tb.write(4, 1, bgWhite,   "   ", bgNone, " ", fgWhite, styleDim, "1", resetStyle)
    tb.write(4, 2, bgRed,     "   ", bgNone, " ", fgWhite, styleDim, "2", resetStyle)
    tb.write(4, 3, bgGreen,   "   ", bgNone, " ", fgWhite, styleDim, "3", resetStyle)
    tb.write(4, 4, bgYellow,  "   ", bgNone, " ", fgWhite, styleDim, "4", resetStyle)
    tb.write(4, 5, bgBlue,    "   ", bgNone, " ", fgWhite, styleDim, "5", resetStyle)
    tb.write(4, 6, bgMagenta, "   ", bgNone, " ", fgWhite, styleDim, "6", resetStyle)
    tb.write(4, 7, bgCyan,    "   ", bgNone, " ", fgWhite, styleDim, "7", resetStyle)
    tb.write(4, 9, fgWhite, "2nd ", styleDim, "0", resetStyle)
    tb.write(2, 1, bgNone, fgWhite, styleBright, "*")


    # display tool selection frame
    tb.setForegroundColor(fgBlack, true)
    tb.drawRect(0, 11, 10, 17)
    tb.write(2, 12, bgNone, fgWhite, styleBright, "Draw  ", styleDim, "q", resetStyle)
    tb.write(2, 13, bgNone, fgWhite,              "Erase ", styleDim, "w", resetStyle)
    tb.write(2, 14, bgNone, fgWhite,              "Line  ", styleDim, "e", resetStyle)
    tb.write(2, 15, bgNone, fgWhite,              "Rect  ", styleDim, "r", resetStyle)
    tb.write(2, 16, bgNone, fgWhite,              "RectO ", styleDim, "t", resetStyle)


    # frame around drawing area
    tb.setForegroundColor(fgBlack, true)
    tb.drawRect(12, 0, terminalWidth()-1, terminalHeight()-1)


    # frame labels
    tb.write( 2,  0, fgBlue, " COLOR ")
    tb.write( 2, 11, fgBlue, " TOOLS ")
    tb.write(14,  0, fgBlue, " CANVAS ")


    # select color from keypress
    proc select_color(n: int) =
        tb.write(2, color, bgNone, " ")
        color = n
        case color
            of 1: color_id = fgWhite
            of 2: color_id = fgRed
            of 3: color_id = fgGreen
            of 4: color_id = fgYellow
            of 5: color_id = fgBlue
            of 6: color_id = fgMagenta
            of 7: color_id = fgCyan
            else: discard
        tb.write(2, color, bgNone, fgWhite, styleBright, "*")
    

    # use bright color
    proc toggle_bright() =
        color_bright = not color_bright
        if color_bright:
            tb.write(2, 9, bgNone, fgWhite, styleBright, "*")
        else:
            tb.write(2, 9, bgNone, " ")


    # select tool from keypress
    proc select_tool(n: int) =
        tb.write(2, tool+11, bgNone, fgWhite, tool_name)
        tool = n
        case n
            of 1: tool_name = "Draw "
            of 2: tool_name = "Erase"
            of 3: tool_name = "Line "
            of 4: tool_name = "Rect "
            of 5: tool_name = "RectO"
            else: discard
        tb.write(2, tool+11, bgNone, fgWhite, styleBright, tool_name)
    

    # handle mouse clicks
    proc mouse_click() =
        let mi = getMouse()
        if mi.action == MouseButtonAction.mbaPressed:

            # clicked on color buttons
            if (1 < mi.x and mi.x < 9) and (0 < mi.y and mi.y < 8):
                select_color(mi.y)
            
            # clicked on bright color button
            elif (1 < mi.x and mi.x < 9) and (mi.y == 9):
                toggle_bright()
            
            # clicked on tool buttons
            elif (1 < mi.x and mi.x < 9) and (11 < mi.y and mi.y < 17):
                select_tool(mi.y - 11)
            
            # clicked in canvas
            elif (13 < mi.x and mi.x < terminalWidth() - 2) and (0 < mi.y and mi.y < terminalHeight() - 1):
                if tool == 1:
                    if color_bright:
                        tb.write(mi.x, mi.y, color_id, styleBright, "█", fgNone, resetStyle)
                    else:
                        tb.write(mi.x, mi.y, color_id, "█", fgNone)
                elif tool == 2:
                    tb.write(mi.x, mi.y, fgBlack, "█")


    # main loop
    while true:

        var key = getKey()

        case key
            of Key.None:
                discard

            # escape to exit the application
            of Key.Escape:
                exit()

            # keys 1-7 select color
            of Key.One:   select_color(1)
            of Key.Two:   select_color(2)
            of Key.Three: select_color(3)
            of Key.Four:  select_color(4)
            of Key.Five:  select_color(5)
            of Key.Six:   select_color(6)
            of Key.Seven: select_color(7)

            # key 0 toggles bright color
            of Key.Zero: toggle_bright()

            # keys Q-T select tool
            of Key.Q: select_tool(1)
            of Key.W: select_tool(2)
            of Key.E: select_tool(3)
            of Key.R: select_tool(4)
            of Key.T: select_tool(5)
            
            # handle mouse clicks
            of Key.Mouse:
                mouse_click()
            
            else:
                discard
        
        # reset ui if terminal size changed
        if old_termsize != terminalSize():
            illwillDeinit()
            showCursor()
            break

        tb.display()



# start ui (and restart if break in main loop)
while true:
    main()
