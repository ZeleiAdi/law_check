#!/usr/bin/env ruby

require 'json'
raw_expressions = JSON.parse(ARGF.read)

require_relative './expressions'
LawCheck::Expressions.parse(raw_expressions)
