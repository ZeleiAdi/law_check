class Law::Actions {
  method TOP($/) {
    make($/<expressions>.ast);
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
    make({partition => {set => $/<set_path>.ast, subsets => $/<set_literals>.ast, complete => $/<either>.Bool}});
  }

  method set_path($/) {
    make($/<set_literal>.map(*.ast));
  }

  method set_literals($/) {
    make($/<set_literal>.map(*.ast));
  }

  method set_literal($/) {
    make($/<set>.ast);
  }

  method set($/) {
    make($/.Str);
  }

  method binding($/) {
    make({binding => {name => $/<name_literal>.ast, set => ($/<set_literal>.ast)}});
  }

  method name_literal($/) {
    make($/<name>.ast);
  }

  method name($/) {
    make($/.Str);
  }

  method conditional($/) {
    make({conditional => {conditions => $/<conditions>.ast, conclusion => $/<conclusion>.ast}});
  }

  method conditions($/) {
    make($/<condition>.map(*.ast));
  }

  method condition($/) {
    make($/<binding>.ast);
  }

  method conclusion($/) {
    make($/<expressions>.ast);
  }
}