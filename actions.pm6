class Law::Actions {
  method TOP($/) {
    make($/<expressions>.ast);
  }

  method top_unparsable($/) {
    say("\e[31m" ~ '!!! wrong syntax !!!' ~ "\e[0m");
    note($/.Str);
  }

  method expressions($/) {
    make($/<expression>.map(*.ast));
  }

  method expression($/) {
    if ($/<partition>) {
      make($/<partition>.ast);
    } elsif ($/<binding>) {
      make($/<binding>.ast);
    } elsif ($/<conditional>) {
      make($/<conditional>.ast);
    }
  }

  method partition($/) {
    make({partition => {path => $/<set_path>.ast,
                        subsets => $/<set_union>.ast,
                       complete => $/<complete>:exists}});
  }

  method set_path($/) {
    make($/<set_literal>.map(*.ast));
  }

  method set_literal($/) {
    make($/<set_name>.ast);
  }

  method set_name($/) {
    make($/.Str);
  }

  method set_union($/) {
    make($/<set_literal>.map(*.ast));
  }

  method binding($/) {
    make({binding => {name => $/<name_literal>.ast,
                      path => $/<set_path>.ast}});
  }

  method name_literal($/) {
    make($/<name_name>.ast);
  }

  method name_name($/) {
    make($/.Str);
  }

  method conditional($/) {
    make({conditional => {conditions => $/<conditions>.ast,
                          consequences => $/<consequences>.ast}});
  }

  method conditions($/) {
    make($/<condition>.map(*.ast));
  }

  method condition($/) {
    make({name => $/<name_literal>.ast, path => $/<set_path>.ast});
  }

  method consequences($/) {
    make($/<expressions>.ast);
  }

  method consequences_unparsable($/) {
    note("\e[31mInvalid expression at line {$/.prematch.split("\n").elems}!\e[0m");
    note("\e[33m$/\e[0m");
  }
}