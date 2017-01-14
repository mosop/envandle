module Envandle
  def self.sh(cmd)
    system cmd, out: "/dev/null", err: "/dev/null"
    raise "Command error: #{cmd}" unless $?.success?
  end
end
