# Configuration variable generator
#
# Examines the input expression for intrinsic types (numeric, duration or boolean)
# and omits quotes if specified in isolation.  The same applies for host or service
# lookups, and optionally value lookups from within 'apply Service for' blocks.
# inputs which feature double quoted values are assumed to already be correctly
# formatted.  Anything else is assumed to be a string literal and is emitted with
# double quotation.
#
def _icinga2_config_value(value, locals, depth=1)
  # Error
  if value.nil?
    "\"nil\""
  # Hashes
  elsif value.is_a?(Hash)
    "{\n" + value.sort_by{|k,v|k}.inject('') do |a, x|
      key = x.first
      # If the key features illegal characters (e.g. '-d' in check command
      # arguments) then quote the key
      key = %Q/"#{key}"/ if key.include?('-')
      "#{a}  #{'  ' * depth} #{key} = #{_icinga2_config_value(x.last, locals, depth + 1).to_s}\n"
    end + ("  " * depth) + "}"
  # Arrays - 1D ONLY
  elsif value.is_a?(Array)
    '[' + value.collect { |v| _icinga2_config_value(v, locals, 0).to_s }.join(',') + ']'
  # Numeric literals
  elsif value.is_a?(Integer) or value.is_a?(Float)
    value
  # Boolean literals
  elsif value.is_a?(TrueClass) or value.is_a?(FalseClass)
    value
  # Duration literals
  elsif /^\d+(\.\d+)?(ms|s|m|h|d)$/.match(value)
    value
  # Pre-formatted
  elsif value.include?('"')
    value
  # Apply variables
  elsif value.start_with?('host.', 'service.', 'user.')
    value
  # Apply for local variables
  elsif value.start_with?(*locals)
    value
  # Object accessor functions
  elsif value.start_with?('get_')
    value
  # String literal
  else
    "\"#{value}\""
  end
end

module Puppet::Parser::Functions
  newfunction(:icinga2_config_value, :type => :rvalue) do |args|
    _icinga2_config_value(args[0], args[1..-1])
  end
end
