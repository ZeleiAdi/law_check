# to-json is a slighty modified version of https://github.com/moritz/json/blob/master/lib/JSON/Tiny.pm
module JSON;

multi to-json(Str:D $d) {
  '"' ~ $d.trans(['"', '\\', "\b", "\f", "\n", "\r", "\t"] => ['\"', '\\\\', '\b', '\f', '\n', '\r', '\t']) ~ '"';
}

multi to-json(Positional:D $d) {
  '[ ' ~ $d.map(.to-json).join(', ') ~ ' ]';
}

multi to-json(Associative:D $d) {
  '{ ' ~ $d.map(to-json(.key) ~ ' : ' ~ to-json(.value)).join(', ') ~ ' }';
}