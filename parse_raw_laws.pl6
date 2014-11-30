use v6;

use lib '.';

use grammar;
use actions;

use JSON;

sub MAIN($in_file_path, $out_file_path) {
  open($out_file_path, :w).say(to-json(Law::Grammar.parsefile($in_file_path, :actions(Law::Actions.new())).ast));
}