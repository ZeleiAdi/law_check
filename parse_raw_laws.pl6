use v6;

grammar Law::Grammar {
  rule TOP {
    <ws><expressions>
  }

  rule expressions {
    [<expression> ]+
  }

  rule expression {
    <partition>|<binding>|<conditional>
  }

  rule partition {
    <set_literal> is <either>? <set_literals>
  }

  rule set_literals {
    <set_literal> [or <set_literal> ]*
  }

  token set_literal {
    \"<set>\"
  }

  token set {
    <-[\"]>+
  }

  token either {
    either
  }

  rule binding {
    <name_literal> is <set_literal>
  }

  token name_literal {
    \*<name>\*
  }

  token name {
    <-[*]>+
  }

  rule conditional {
    if <conditions> then
      <conclusion>
    end
  }

  rule conditions {
    <condition> [and <condition> ]*
  }

  rule condition {
    <binding>
  }

  rule conclusion {
    <expressions>
  }
}

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
    make({partition => {set => $/<set_literal>.ast, subsets => $/<set_literals>.ast, complete => $/<either>.Bool}});
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

# to-json is a slighty modified version of https://github.com/moritz/json/blob/master/lib/JSON/Tiny.pm

multi to-json(Str:D $d) {
  '"' ~ $d.trans(['"', '\\', "\b", "\f", "\n", "\r", "\t"] => ['\"', '\\\\', '\b', '\f', '\n', '\r', '\t']) ~ '"';
}

multi to-json(Positional:D $d) {
  '[ ' ~ $d.map(.to-json).join(', ') ~ ' ]';
}

multi to-json(Associative:D $d) {
  '{ ' ~ $d.map(to-json(.key) ~ ' : ' ~ to-json(.value)).join(', ') ~ ' }';
}

sub MAIN($in_file_path, $out_file_path) {
  open($out_file_path, :w).say(to-json(Law::Grammar.parsefile($in_file_path, :actions(Law::Actions.new())).ast));
}