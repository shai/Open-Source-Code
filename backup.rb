# Vagrant snapshots using the snapshot plugin
# Will keep 3 snapshot and remove older ones
# This script needs to be in the same directory as the Vagrantfile
# By Shai Ben-Naphtali <shai@shaibn.com>
# Version: 1.0.0

# Make sure we've got one argument
if ARGV.length != 1
	puts "Usage: provide one argument, the vm name."
	puts "Example: #{$0} backup"
	exit
end

vmName = ARGV[0]

require 'date'

# This format will be used to create the snapshots and find them
mytime = Time.now.strftime("%Y%m%d_%H%M%S")

# If the user isn't where the Vagrantfile is, this script won't work
testVagrant = `vagrant snapshot list #{vmName}`
if $?.exitstatus != 0
	puts testVagrant
	exit 1
end

# First, create a snapshot, then list all of them
`vagrant snapshot take #{vmName} #{mytime}`
list = `vagrant snapshot list #{vmName}`

# Now find all of the dates (as the above date format was given)
# and flatten because the .scan will create arrays within the array
# so flattening the array will produce strings within the array
m = list.scan(/Name:\s(\d+_\d+)/).flatten

# As long as we have more then 4 snapshots, find the oldest one
# that with the smallest number and delete it, remove it from the array
# and repeat
while m.length > 3
	`vagrant snapshot delete #{vmName} #{m.min}`
	mMin = m.each.with_index.find_all{ |a,i| a == m.min }.map{ |a,b| b }
	m.delete_at(mMin[0])
end
