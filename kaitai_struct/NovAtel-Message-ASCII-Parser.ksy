meta:
  id: novatel
  file-extension: dat
  endian: le
seq:
  - id: all_novatel_messages
    type: novatel_message
#    repeat: eos
    repeat: expr
    repeat-expr: 4

types:
  novatel_message:
    seq:
    - id: novatel_ascii_header
      type: u1
    - id: message_name
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: port
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: reserved1
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: idle_time
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: time_status
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: week
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: seconds
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: receiver_status
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: reserved2
      type: str
      terminator: 0x2c
      encoding: UTF-8
    - id: reserved3
      type: str
      terminator: 0x3b
      encoding: UTF-8
    - id: command_type
      type: str
      terminator: 0x2c
      encoding: UTF-8 
    - id: embedded_message
      type: str
      terminator: 0x2a
      encoding: UTF-8
    - id: checksum
      type: str
      terminator: 0x0d
      encoding: UTF-8
    - id: message_terminator
      type: str
      terminator: 0x0a
      encoding: UTF-8
      
      
      
      
      
      
      
      
      
      