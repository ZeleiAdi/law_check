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