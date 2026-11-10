import xml.etree.ElementTree as ET

tree = ET.parse('work/Map0002_steam_orig.emu')
root = tree.getroot()

# 1. Patch EV0001 Page 0001 to display SwitchKeyGuide first, then 000000000142 (GameFlow)
p1_commands = root.find('.//Event[@id="0001"]/pages/EventPage[@id="0001"]/event_commands')
assert p1_commands is not None, "Event commands not found in Page 1"

p1_commands.clear()

def add_cmd(parent, code, string, params, indent=0):
    cmd = ET.SubElement(parent, 'EventCommand')
    ET.SubElement(cmd, 'code').text = str(code)
    ET.SubElement(cmd, 'indent').text = str(indent)
    ET.SubElement(cmd, 'string').text = string
    ET.SubElement(cmd, 'parameters').text = params

# Initial setup & fade out
add_cmd(p1_commands, 10210, "", "0 128 128 0", 0)
add_cmd(p1_commands, 11960, "", "0", 0)
add_cmd(p1_commands, 11010, "", "19", 0)
add_cmd(p1_commands, 12330, "", "0 172 0", 0)

# Show Picture 1: SwitchKeyGuide
add_cmd(p1_commands, 11110, "SwitchKeyGuide", "1 0 160 120 0 100 0 1 100 100 100 100 0 0 0 68", 0)
add_cmd(p1_commands, 11020, "", "2", 0)

# Wait for button press (Decision A, Cancel B, Numbers X/Y/L/R; ignore directional/stick param[2]=0)
add_cmd(p1_commands, 11610, "", "2 1 0 1 1 1 0 1 0 0 0 0 0 0", 0)
# ConditionalBranch: Variable[2] >= 1 (always true once any enabled button is pressed)
add_cmd(p1_commands, 12010, "", "1 2 0 1 1 0", 0)

# Inside branch (indent 1): transition from SwitchKeyGuide to 000000000142 (GameFlow) and call Page 2
add_cmd(p1_commands, 11010, "", "3", 1)
add_cmd(p1_commands, 11130, "", "1", 1)
add_cmd(p1_commands, 11110, "000000000142", "1 0 160 120 0 100 0 1 100 100 100 100 0 0 0 68", 1)
add_cmd(p1_commands, 12330, "", "0 172 0", 1)
add_cmd(p1_commands, 11020, "", "2", 1)
add_cmd(p1_commands, 10220, "", "0 2 2 0 0 0 0", 1)
add_cmd(p1_commands, 12330, "", "1 10005 2", 1)
add_cmd(p1_commands, 10, "", "", 1)

# End branch (indent 0)
add_cmd(p1_commands, 22011, "", "", 0)

# 2. In Pages 2, 3, and 4, disable directional/stick check (param[2]=0) in KeyInputProc (11610)
# so analog stick movement or D-pad never aborts the ConditionalBranch (Var[2] == 5) and restarts Page 1
for page_id in ("0002", "0003", "0004"):
    page_cmds = root.find(f'.//Event[@id="0001"]/pages/EventPage[@id="{page_id}"]/event_commands')
    assert page_cmds is not None, f"Event commands not found in Page {page_id}"
    for cmd in page_cmds.findall('EventCommand'):
        if cmd.find('code').text == '11610':
            cmd.find('parameters').text = "2 1 0 1 0 0 0 1 0 0 0 0 0 0"

tree.write('work/Map0002_patched.emu', encoding='UTF-8', xml_declaration=True)
print("Saved work/Map0002_patched.emu successfully")
