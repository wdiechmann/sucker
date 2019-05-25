require_relative '../../../config/application'

env_file = File.join(Rails.root, '.env.'+$ARGV.dup[0])
File.open(env_file).each do |line|
  line=line.split('#')[0]
  key,value=line.split("=") rescue [nil,nil]
  ((ENV[key.to_s] = value.gsub( /\n/,'')) unless key.nil?) rescue nil
end if File.exists?(env_file)

