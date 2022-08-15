#Location.create(locale:"NYC")
#Location.create(locale:"Los Angeles")
#Location.create(locale:"Las Vegas")
#Location.create(locale:"Miami")
#Location.create(locale:"San Francisco")
#Location.create(locale:"Arlington")
#Location.create(locale:"Dallas")
#Location.create(locale:"MSG")
#Location.create(locale:"Barcalys Center")
Location.all.each do |l|
  l.destroy
end
Event.all.each do |l|
  l.destroy
end
User.all.each do |l|
  l.destroy
end
