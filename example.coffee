dotdoc = require "./graphviz"
object = dotdoc.object


style_base =
  color: "deepskyblue4"
  fontcolor: "white"
  style: "filled"

style_second =
  color: "deepskyblue"
  fontcolor: "white"
  style: "filled"

style_line =
  color: "deepskyblue4"
  fontcolor: "white"

dotdoc.dot.defaultStyleLine = style_line


user = object "user", {
  label: 'User',
}, style_base

user2 = user.clone "user 2"

legal_person = object "legal_person", {
  label: 'Legal person'
}, style_base

item = object "item", {
  label: 'Item',
}, style_base

message = object "message", {
  label: 'Message'
}, style_base

language = object "language", {
  label: 'Language'
  table: [
    'ru'
    'en'
  ]
}, style_base

uiux = object "uiux", {
  label: 'UI/UX'
}, style_base

countries = object "countries", {
  label: 'Countries'
}, style_base

addresses = object "addresses", {
  label: 'Addresses'
}, style_base


countries[">"] addresses
user[">"] [item, message, legal_person]
language["<"] uiux

item.options.table = [
  'field 1'
  'field 2'
  'field 3'
]

item[">"] user2


dotdoc.dot.graph.bgcolor = 'white'
dotdoc.generator_and_print()
