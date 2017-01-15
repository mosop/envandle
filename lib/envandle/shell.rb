module Envandle
  def self.sh(cmd)
    # output, status = Open3.capture2(cmd)
    output, error, status = Open3.capture3(cmd)
    raise "Command error: #{cmd}" unless status.success?
    output
  end
end
