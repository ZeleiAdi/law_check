use v6;

use lib '.';

use grammar;
use actions;

sub MAIN() {
  my $parsed = Law::Grammar.parse(slurp, :actions(Law::Actions.new()));
  say(to-json($parsed.ast));
}