grammar Law::Grammar {
  rule TOP {
    ^ <expressions> <top_unparsable>? $
  }

  rule top_unparsable {
    .+
  }

  rule expressions {
    <expression>*%[<[\s] - [\n]>*\n\s*]
  }

  token expression {
    <partition>|<binding>|<conditional>
  }

  token partition {
    <set_path>\s+can\s+be[\s+<complete>]?\s+<set_union>
  }

  token set_path {
    <set_literal>+%<[\s] - [\n]>+
  }

  token set_literal {
    \"<set_name>\"
  }

  token set_name {
    <-[\"]>+
  }

  token complete {
    either
  }

  token set_union {
    <set_literal>+%[\s+or\s+]
  }

  token binding {
    <name_literal>\s+is\s+<set_path>
  }

  token name_literal {
    \*<name_name>\*
  }

  token name_name {
    <-[*]>+
  }

  token conditional {
    if\s+<conditions>\s+then\s*<consequences>\s*end
  }

  token conditions {
    <condition>+%[\s+and\s+]
  }

  token condition {
    <name_literal>\s+is\s+<set_path>
  }

  token consequences {
    <expressions>\s*<consequences_unparsable>?
  }

  token consequences_unparsable {
    [<-[e]>|e<!before nd>]+
  }
}