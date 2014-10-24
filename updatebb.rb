# Update the schedule for Backblaze from either continuously or only_when_click_backup_now
# Must install nokogiri: gem install nokogiri
# By Shai Ben-Naphtali <shai@shaibn.com>
# Version 1.0.0

bzinfo = "c:/ProgramData/Backblaze/bzdata/bzinfo.xml"

require "nokogiri"

# Read the XML and put backup_schedule_type value in the schedule variable
doc = Nokogiri::XML(File.read(bzinfo))
backup = doc.at('do_backup')
schedule = backup['backup_schedule_type']

# if the backup_schedule_type is one change it to the other
case schedule
when 'only_when_click_backup_now'
	puts "Backblaze will backup continuously"
	backup['backup_schedule_type'] = "continuously"
when 'continuously'
	puts "Backblaze will backup only_when_click_backup_now"
	backup['backup_schedule_type'] = "only_when_click_backup_now"
end

File.write(bzinfo, doc.to_xml)
