require "spec_helper"
require "serverspec"

package = "sudo"
service = "sudo"
config  = "/etc/sudo/sudo.conf"
user    = "sudo"
group   = "sudo"
ports   = [PORTS]
log_dir = "/var/log/sudo"
db_dir  = "/var/lib/sudo"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/sudo.conf"
  db_dir = "/var/db/sudo"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("sudo") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/sudo") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
