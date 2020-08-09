import argparse
import tarfile
import StringIO
import os
from template import Template


def make_tarfile(rendered_templates):
    full_path_commands = os.path.join(os.path.dirname(__file__), 'commands')
    commands_to_include = os.listdir(full_path_commands)
    with tarfile.open('espec.tar.gz', "w:gz") as tar:
        for filename, filestring in rendered_templates:
            tarinfo = tarfile.TarInfo(filename)
            tarinfo.size = len(filestring)
            tar.addfile(tarinfo, StringIO.StringIO(filestring))
        for command_to_include in commands_to_include:
            tar.add(os.path.join(full_path_commands, command_to_include), arcname=command_to_include)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate espec for kubernetes')
    parser.add_argument('--nodes', type=int, nargs='?',
                        help='amount of nodes in the generated espec, not including the master node')
    parser.add_argument('--wall', choices=['wall1', 'wall2'], default='wall2', help='Target Virtual Wall, defaults to wall2')
    parser.add_argument('--hardware', type=str, default='pcgen02-5p', help='Type of hardware, everything is supported except for pcgen01')

    args = parser.parse_args()
    templates = Template(args.nodes, args.wall, args.hardware)
    make_tarfile(templates.all_templates())
