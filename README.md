# NAME

PostScript::Easy - Produce PostScript files from Perl

# SYNOPSIS

    use PostScript::Easy;
    

    # create a new PostScript object
    $p = new PostScript::Easy(papersize => "A4",
                                colour => 1,
                                eps => 0,
                                units => "in");
    

    # create a new page
    $p->newpage;
    

    # draw some lines and other shapes
    $p->line(1,1, 1,4);
    $p->linextend(2,4);
    $p->box(1.5,1, 2,3.5);
    $p->circle(2,2, 1);
    $p->setlinewidth( 0.01 );
    $p->curve(1,5, 1,7, 3,7, 3,5);
    $p->curvextend(3,3, 5,3, 5,5);
    

    # draw a rotated polygon in a different colour
    $p->setcolour(0,100,200);
    $p->polygon({rotate=>45}, 1,1, 1,2, 2,2, 2,1, 1,1);
    

    # add some text in red
    $p->setcolour("red");
    $p->setfont("Times-Roman", 20);
    $p->text(1,1, "Hello");
    

    # write the output to a file
    $p->output("file.ps");



# DESCRIPTION

PostScript::Easy was forked from [PostScript::Simple](http://search.cpan.org/perldoc?PostScript::Simple) v0.07. 
And, basic usage is the same to PostScript::Simple.

PostScript::Easy allows you to have a simple method of writing PostScript
files from Perl. It has graphics primitives that allow lines, curves, circles,
polygons and boxes to be drawn. Text can be added to the page using standard
PostScript fonts.

The images can be single page EPS files, or multipage PostScript files. The
image size can be set by using a recognised paper size ("`A4`", for example) or
by giving dimensions. The units used can be specified ("`mm`" or "`in`", etc)
and are the same as those used in TeX. The default unit is a bp, or a PostScript
point, unlike TeX.

# PREREQUISITES

This module requires `strict` and `Exporter`.

## EXPORT

None.

# CONSTRUCTOR

- `new(options)`

    Create a new PostScript::Easy object. The different options that can be set are:

    - units

        Units that are to be used in the file. Common units would be `mm`, `in`,
        `pt`, `bp`, and `cm`. Others are as used in TeX. (Default: `bp`)

    - xsize

        Specifies the width of the drawing area in units.

    - ysize

        Specifies the height of the drawing area in units.

    - papersize

        The size of paper to use, if `xsize` or `ysize` are not defined. This allows
        a document to easily be created using a standard paper size without having to
        remember the size of paper using PostScript points. Valid choices are currently
        "`A3`", "`A4`", "`A5`", and "`Letter`".

    - landscape

        Use the landscape option to rotate the page by 90 degrees. The paper dimensions
        are also rotated, so that clipping will still work. (Note that the printer will
        still think that the paper is portrait.) (Default: 0)

    - copies

        Set the number of copies that should be printed. (Default: 1)

    - clip

        If set to 1, the image will be clipped to the xsize and ysize. This is most
        useful for an EPS image. (Default: 0)

    - colour

        Specifies whether the image should be rendered in colour or not. If set to 0
        (default) all requests for a colour are mapped to a greyscale. Otherwise the
        colour requested with `setcolour` or `line` is used. This option is present
        because most modern laser printers are only black and white. (Default: 0)

    - eps

        Generate an EPS file, rather than a standard PostScript file. If set to 1, no
        newpage methods will actually create a new page. This option is probably the
        most useful for generating images to be imported into other applications, such
        as TeX. (Default: 1)

    - page

        Specifies the initial page number of the (multi page) document. The page number
        is set with the Adobe DSC comments, and is used nowhere else. It only makes
        finding your pages easier. See also the `newpage` method. (Default: 1)

    - coordorigin

        Defines the co-ordinate origin for each page produced. Valid arguments are
        `LeftBottom`, `LeftTop`, `RightBottom` and `RightTop`. The default is
        `LeftBottom`.

    - direction

        The direction the co-ordinates go from the origin. Values can be `RightUp`,
        `RightDown`, `LeftUp` and `LeftDown`. The default value is `RightUp`.

    - reencode

        Requests that a font re-encode function be added and that the 13 standard
        PostScript fonts get re-encoded in the specified encoding. The most popular
        choice (other than undef) is 'ISOLatin1Encoding' which selects the iso8859-1
        encoding and fits most of western Europe, including the Scandinavia. Refer to
        Adobes Postscript documentation for other encodings.

        The output file is, by default, re-encoded to ISOLatin1Encoding. To stop this
        happening, use 'reencode => undef'. To use the re-encoded font, '-iso' must be
        appended to the names of the fonts used, e.g. 'Helvetica-iso'.

    Example:

        $ref = new PostScript::Easy(landscape => 1,
                                      eps => 0,
                                      xsize => 4,
                                      ysize => 3,
                                      units => "in");

    Create a document that is 4 by 3 inches and prints landscape on a page. It is
    not an EPS file, and must therefore use the `newpage` method.

        $ref = new PostScript::Easy(eps => 1,
                                      colour => 1,
                                      xsize => 12,
                                      ysize => 12,
                                      units => "cm",
                                      reencode => "ISOLatin1Encoding");

    Create a 12 by 12 cm EPS image that is in colour. Note that "`eps => 1`"
    did not have to be specified because this is the default. Re-encode the
    standard fonts into the iso8859-1 encoding, providing all the special characters
    used in Western Europe. The `newpage` method should not be used.

# OBJECT METHODS

All object methods return 1 for success or 0 in some error condition (e.g. insufficient arguments).
Error message text is also drawn on the page.

- `newpage([number])`

    Generates a new page on a PostScript file. If specified, `number` gives the
    number (or name) of the page. This method should not be used for EPS files.

    The page number is automatically incremented each time this is called without
    a new page number, or decremented if the current page number is negative.

    Example:

        $p->newpage(1);
        $p->newpage;
        $p->newpage("hello");
        $p->newpage(-6);
        $p->newpage;

    will generate five pages, numbered: 1, 2, "hello", -6, -7.

- `output(filename)`

    Writes the current PostScript out to the file named `filename`. Will destroy
    any existing file of the same name.

    Use this method whenever output is required to disk. The current PostScript
    document in memory is not cleared, and can still be extended.

- `get`

    Returns the current document.

    Use this method whenever output is required as a scalar. The current PostScript
    document in memory is not cleared, and can still be extended.

- `geteps`

    Returns the current document as a PostScript::Easy::EPS object. Only works if
    the current document is EPS.

    This method calls new PostScript::Easy::EPS with all the default options. To
    change these, call it yourself as below, rather than using this method.

        $eps = new PostScript::Easy::EPS(source => $ps->get);

- `setcolour((red, green, blue)|(name))`

    Sets the new drawing colour to the values specified in `red`, `green` and
    `blue`. The values range from 0 to 255.

    Alternatively, a colour name may be specified. Those currently defined are
    listed at the top of the PostScript::Easy module in the `%pscolours` hash.

    Example:

        # set new colour to brown
        $p->setcolour(200,100,0);
        # set new colour to black
        $p->setcolour("black");

- `setlinewidth(width)`

    Sets the new line width to `width` units.

    Example:

        # draw a line 10mm long and 4mm wide
        $p = new PostScript::Easy(units => "mm");
        $p->setlinewidth(4);
        $p->line(10,10, 20,10);

- `line(x1,y1, x2,y2 [,red, green, blue])`

    Draws a line from the co-ordinates (x1,x2) to (x2,y2). If values are specified
    for `red`, `green` and `blue`, then the colour is set before the line is drawn.

    Example:

        # set the colour to black
        $p->setcolour("black");

        # draw a line in the current colour (black)
        $p->line(10,10, 10,20);
        

        # draw a line in red
        $p->line(20,10, 20,20, 255,0,0);

        # draw another line in red
        $p->line(30,10, 30,20);

- `linextend(x,y)`

    Assuming the previous command was `line`, `linextend`, `curve` or
    `curvextend`, extend that line to include another segment to the co-ordinates
    (x,y). Behaviour after any other method is unspecified.

    Example:

        $p->line(10,10, 10,20);
        $p->linextend(20,20);
        $p->linextend(20,10);
        $p->linextend(10,10);

    Notes

    The `polygon` method may be more appropriate.

- `arc([options,] x,y, radius, start_angle, end_angle)`

    Draws an arc on the circle of radius `radius` with centre (`x`,`y`). The arc
    starts at angle `start_angle` and finishes at `end_angle`. Angles are specified
    in degrees, where 0 is at 3 o'clock, and the direction of travel is anti-clockwise.

    Any options are passed in a hash reference as the first parameter. The available
    option is:

    - filled => 1

        If `filled` is 1 then the arc will be filled in.

    Example:

        # semi-circle
        $p->arc(10, 10, 5, 0, 180);

        # complete filled circle
        $p->arc({filled=>1}, 30, 30, 10, 0, 360);

- `polygon([options,] x1,y1, x2,y2, ..., xn,yn)`

    The `polygon` method is multi-function, allowing many shapes to be created and
    manipulated. Polygon draws lines from (x1,y1) to (x2,y2) and then from (x2,y2) to
    (x3,y3) up to (xn-1,yn-1) to (xn,yn).

    Any options are passed in a hash reference as the first parameter. The available
    options are as follows:

    - rotate => angle
    =item rotate => \[angle,x,y\]

        Rotate the polygon by `angle` degrees anti-clockwise. If x and y are specified
        then use the co-ordinate (x,y) as the centre of rotation, otherwise use the
        co-ordinate (x1,y1) from the main polygon.

    - filled => 1

        If `filled` is 1 then the PostScript output is set to fill the object rather
        than just draw the lines.

    - offset => \[x,y\]

        Displace the object by the vector (x,y).

    Example:

        # draw a square with lower left point at (10,10)
        $p->polygon(10,10, 10,20, 20,20, 20,10, 10,10);

        # draw a filled square with lower left point at (20,20)
        $p->polygon( {offset => [10,10], filled => 1},
                    10,10, 10,20, 20,20, 20,10, 10,10);

        # draw a filled square with lower left point at (10,10)
        # rotated 45 degrees (about the point (10,10))
        $p->polygon( {rotate => 45, filled => 1},
                    10,10, 10,20, 20,20, 20,10, 10,10);

- `circle([options,] x,y, r)`

    Plot a circle with centre at (x,y) and radius of r.

    There is only one option.

    - filled => 1

        If `filled` is 1 then the PostScript output is set to fill the object rather
        than just draw the lines.

    Example:

        $p->circle(40,40, 20);
        $p->circle( {filled => 1}, 62,31, 15);

- `circletext([options,] x, y, r, a, text)`

    Draw text in an arc centered about angle `a` with circle midpoint (`x`,`y`)
    and radius `r`.

    There is only one option.

    - align => "alignment"

        `alignment` can be 'inside' or 'outside'. The default is 'inside'.

    Example:

        # outside the radius, centered at 90 degrees from the origin
        $p->circletext(40, 40, 20, 90, "Hello, Outside World!");
        # inside the radius centered at 270 degrees from the origin
        $p->circletext( {align => "inside"}, 40, 40, 20, 270, "Hello, Inside World!");

- `box(x1,y1, x2,y2 [, options])`

    Draw a rectangle from lower left co-ordinates (x1,y1) to upper right
    co-ordinates (y1,y2).

    Options are:

    - filled => 1

        If `filled` is 1 then fill the rectangle.

    Example:

        $p->box(10,10, 20,30);
        $p->box( {filled => 1}, 10,10, 20,30);

    Notes

    The `polygon` method is far more flexible, but this method is quicker!

- `setfont(font, size)`

    Set the current font to the PostScript font `font`. Set the size in PostScript
    points to `size`.

    Notes

    This method must be called on every page before the `text` method is used.

- `text([options,] x,y, string)`

    Plot text on the current page with the lower left co-ordinates at (x,y) and 
    using the current font. The text is specified in `string`.

    Options are:

    - align => "alignment"

        alignment can be 'left', 'centre' or 'right'. The default is 'left'.

    - rotate => angle

        "rotate" degrees of rotation, defaults to 0 (i.e. no rotation).
        The angle to rotate the text, in degrees. Centres about (x,y) and rotates
        clockwise. (?). Default 0 degrees.

    Example:

        $p->setfont("Times-Roman", 12);
        $p->text(40,40, "The frog sat on the leaf in the pond.");
        $p->text( {align => 'centre'}, 140,40, "This is centered.");
        $p->text( {rotate => 90}, 140,40, "This is rotated.");
        $p->text( {rotate => 90, align => 'centre'}, 140,40, "This is both.");

- curve( x1, y1, x2, y2, x3, y3, x4, y4 )

    Create a curve from (x1, y1) to (x4, y4). (x2, y2) and (x3, y3) are the
    control points for the start- and end-points respectively.

- curvextend( x1, y1, x2, y2, x3, y3 )

    Assuming the previous command was `line`, `linextend`, `curve` or
    `curvextend`, extend that path with another curve segment to the co-ordinates
    (x3, y3). (x1, y1) and (x2, y2) are the control points.  Behaviour after any
    other method is unspecified.

- newpath

    This method is used internally to begin a new drawing path - you should generally NEVER use it.

- moveto( x, y )

    This method is used internally to move the cursor to a new point at (x, y) - you will 
    generally NEVER use this method.

- `importepsfile([options,] filename, x1,y1, x2,y2)`

    Imports an EPS file and scales/translates its bounding box to fill
    the area defined by lower left co-ordinates (x1,y1) and upper right
    co-ordinates (x2,y2). By default, if the co-ordinates have a different
    aspect ratio from the bounding box, the scaling is constrained on the
    greater dimension to keep the EPS fully inside the area.

    Options are:

    - overlap => 1

        If `overlap` is 1 then the scaling is calculated on the lesser dimension
        and the EPS can overlap the area.

    - stretch => 1

        If `stretch` is 1 then fill the entire area, ignoring the aspect ratio.
        This option overrides `overlap` if both are given.

    Example:

        # Assume smiley.eps is a round smiley face in a square bounding box

        # Scale it to a (10,10)(20,20) box
        $p->importepsfile("smiley.eps", 10,10, 20,20);

        # Keeps aspect ratio, constrained to smallest fit
        $p->importepsfile("smiley.eps", 10,10, 30,20);

        # Keeps aspect ratio, allowed to overlap for largest fit
        $p->importepsfile( {overlap => 1}, "smiley.eps", 10,10, 30,20);

        # Aspect ratio is changed to give exact fit
        $p->importepsfile( {stretch => 1}, "smiley.eps", 10,10, 30,20);

- `importeps(filename, x,y)`

    Imports a PostScript::Easy::EPS object into the current document at position
    `(x,y)`.

    Example:

        use PostScript::Easy;
        

        # create a new PostScript object
        $p = new PostScript::Easy(papersize => "A4",
                                    colour => 1,
                                    units => "in");
        

        # create a new page
        $p->newpage;
        

        # create an eps object
        $e = new PostScript::Easy::EPS(file => "test.eps");
        $e->rotate(90);
        $e->scale(0.5);

        # add eps to the current page
        $p->importeps($e, 10,50);

# BUGS

Some current functionality may not be as expected, and/or may not work correctly.
That's the fun with using code in development!

# AUTHOR

Satoshi Azuma ["ytnobody at gmail dot com"](#ytnobody at gmail dot com)

The Original [PostScript::Simple](http://search.cpan.org/perldoc?PostScript::Simple) module was created by Matthew Newton, with ideas
and suggestions from Mark Withall and many other people from around the world.
Thanks!

Please see the README file in the distribution for more information about
contributors.

Copyright (C) 2002-2003 Matthew C. Newton / Newton Computing

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, version 2.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details,
available at http://www.gnu.org/licenses/gpl.html.

# SEE ALSO

[PostScript::Easy::EPS](http://search.cpan.org/perldoc?PostScript::Easy::EPS)
