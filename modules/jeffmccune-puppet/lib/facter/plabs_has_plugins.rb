# Custom Fact synchronized with pluginsync.
# If this fact is true, then custom facts have synchronized.
Facter.add("plabs_has_plugins") do
  setcode do
    true
  end
end
# EOF

